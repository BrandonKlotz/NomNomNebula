class_name GameWorld
extends Node

const POINTER_C: Resource = preload("uid://b085nphr6bvo4")

@onready var dash_panel: DashPanel = $CanvasLayer/DashPanel
@onready var player: Player = $Player
@onready var pause_menu: PauseMenu = $CanvasLayer/PauseMenu
@onready var pause_button: Button = $CanvasLayer/PauseButton
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var galaxy_info_panel: GalaxyInfoPanel = $CanvasLayer/GalaxyInfoPanel
@onready var main_camera: MainCamera = $MainCamera
@onready var galaxy_spawner: GalaxySpawner = $GalaxySpawner
@onready var minimap_markers: MinimapMarkers = $MinimapViewport/MinimapMarkers
@onready var conditions_label: Label = $CanvasLayer/ConditionsPanel/ConditionsLabel

enum GameState {
	ONGOING, PAUSED, FINISHED
}

var current_score: int = 10
var tooltip_timer: Timer
var tooltip_duration: float = 2.0
var showing_absorption_tutorial: bool = false
var current_state: GameState = GameState.ONGOING

func _ready() -> void:
	Globals.player = player
	Globals.game_camera = main_camera
	
	dash_panel.setup(player.get_dash_count())
	
	_setup_tooltip_timer()
	
	pause_menu.on_resume.connect(_handle_toggle_pause)
	pause_menu.on_finish.connect(_handle_finish)
	pause_button.pressed.connect(func() -> void:
		_handle_toggle_pause()
		AudioManager.play_sfx(AudioManager.tracks.click)
		animation_component.subtle_wobble(pause_button)
	)
	
	EventManager.on_game_over.connect(_on_game_over_animation)
	EventManager.on_tooltip_show.connect(_on_galaxy_tooltip_show)
	EventManager.on_tooltip_hide.connect(_on_galaxy_tooltip_hide)
	EventManager.on_galaxy_absorbed.connect(_on_galaxy_absorbed)
	EventManager.on_buff_applied.connect(_on_buff_applied)
	
	AudioManager.configure_audio_server(
		Globals.current_save.sfx_level,
		Globals.current_save.music_level
	)
	
	AudioManager.play_music(AudioManager.tracks.game_music)
	Input.set_custom_mouse_cursor(POINTER_C)
	SceneManager.fade_in()

func _on_buff_applied(data: Dictionary) -> void:
	conditions_label.text = "\n".join(data.keys().map(func(c: String) -> String: return c + " : " + str(data[c])))
 
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and current_state != GameState.FINISHED:
		AudioManager.play_sfx(AudioManager.tracks.show_ui)
		_handle_toggle_pause()
	
	if showing_absorption_tutorial and Input.is_action_just_pressed("dash"):
		Engine.time_scale = 1.0
		showing_absorption_tutorial = false

func _on_player_wrapped(offset: Vector2) -> void:
	var camera: MainCamera = Globals.game_camera
	camera.position += offset
	
func _setup_tooltip_timer() -> void:
	tooltip_timer = Timer.new()
	tooltip_timer.timeout.connect(_on_hide_tooltip_timeout)
	tooltip_timer.wait_time = tooltip_duration
	tooltip_timer.one_shot = false
	add_child(tooltip_timer)
	tooltip_timer.start()

func _handle_toggle_pause() -> void:
	if pause_menu.visible:
		pause_menu.dismiss()
		current_state = GameState.ONGOING
		EventManager.on_game_state_changed.emit(current_state)
		Engine.time_scale = 1.0
	else:
		pause_menu.present()
		current_state = GameState.PAUSED
		EventManager.on_game_state_changed.emit(current_state)
		Engine.time_scale = 0.0

func _on_game_over_animation():
	current_state = GameState.FINISHED
	# wait
	# shader del radar se remueve
	_on_game_over()

func _on_game_over() -> void:
	if current_score > Globals.current_save.highest_score:
		Globals.current_save.highest_score = current_score
		DataManager.write_save(Globals.current_save)
	
	Globals.current_score = current_score
	SceneManager.transition_to(Scenes.FINISH)

func _handle_finish() -> void:
	Engine.time_scale = 1.0
	SceneManager.transition_to(Scenes.TITLE)

func _on_galaxy_absorbed(data: GalaxyData) -> void:
	player.absorb_galaxy(data)
	galaxy_spawner.remove_galaxy(data)

func _on_galaxy_tooltip_show(data: GalaxyData) -> void:
	galaxy_info_panel.present(data)
	tooltip_timer.stop()

func _on_galaxy_tooltip_hide() -> void:
	tooltip_timer.start()

func _on_hide_tooltip_timeout():
	galaxy_info_panel.dismiss()
