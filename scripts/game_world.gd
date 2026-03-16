class_name GameWorld
extends Node

@onready var dash_panel: DashPanel = $CanvasLayer/DashPanel
@onready var player: Player = $Player
@onready var pause_menu: PauseMenu = $CanvasLayer/PauseMenu
@onready var pause_button: Button = $CanvasLayer/PauseButton
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var game_over_button: Button = $CanvasLayer/GameOverButton
@onready var galaxy_info_panel: GalaxyInfoPanel = $CanvasLayer/GalaxyInfoPanel

enum GameState {
	ONGOING, PAUSED, FINISHED
}

var current_score: int = 10
var tooltip_timer: Timer
var tooltip_duration: float = 2.0

func _ready() -> void:
	Globals.player = player
	dash_panel.setup(player.get_dash_count())
	
	_setup_tooltip_timer()
	
	game_over_button.pressed.connect(_on_game_over)
	pause_menu.on_resume.connect(_handle_toggle_pause)
	pause_menu.on_finish.connect(_handle_finish)
	pause_button.pressed.connect(func() -> void:
		_handle_toggle_pause()
		animation_component.subtle_wobble(pause_button)
	)
	
	EventManager.on_player_destabilized.connect(_on_game_over)
	EventManager.on_tooltip_show.connect(_on_galaxy_tooltip_show)
	EventManager.on_tooltip_hide.connect(_on_galaxy_tooltip_hide)
	EventManager.on_galaxy_absorbed.connect(_on_galaxy_absorbed)
	SceneManager.fade_in()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_handle_toggle_pause()

func _setup_tooltip_timer() -> void:
	tooltip_timer = Timer.new()
	tooltip_timer.timeout.connect(_on_hide_tooltip_timeout)
	tooltip_timer.wait_time = tooltip_duration
	tooltip_timer.one_shot = false
	add_child(tooltip_timer)
	tooltip_timer.start()

func _handle_toggle_pause() -> void:
	if pause_menu.visible:
		AudioManager.play_sfx(AudioManager.tracks.dismiss_ui)
		pause_menu.dismiss()
		
		EventManager.on_game_state_changed.emit(GameState.ONGOING)
		AudioManager.resume_music()
		Engine.time_scale = 1.0
	else:
		pause_menu.present()
		AudioManager.play_sfx(AudioManager.tracks.show_ui)
		
		EventManager.on_game_state_changed.emit(GameState.PAUSED)
		AudioManager.pause_music()
		Engine.time_scale = 0.0

func _on_game_over() -> void:
	if current_score > Globals.current_save.data.highest_score:
		Globals.current_save.data.highest_score = current_score
		DataManager.write_save(Globals.current_save)
	
	Globals.current_score = current_score
	SceneManager.transition_to(Scenes.FINISH)

func _handle_finish() -> void:
	Engine.time_scale = 1.0
	SceneManager.transition_to(Scenes.TITLE)

func _on_galaxy_absorbed(data: GalaxyData) -> void:
	player.absorb_galaxy(data)

func _on_galaxy_tooltip_show(data: GalaxyData) -> void:
	galaxy_info_panel.present(data)
	tooltip_timer.stop()

func _on_galaxy_tooltip_hide() -> void:
	tooltip_timer.start()

func _on_hide_tooltip_timeout():
	galaxy_info_panel.dismiss()
