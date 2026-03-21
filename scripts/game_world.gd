class_name GameWorld
extends Node

const POINTER_C: Resource = preload("uid://b085nphr6bvo4")

@onready var dash_panel: DashPanel = $CanvasLayer/DashPanel
@onready var player: Player = $Player
@onready var pause_menu: PauseMenu = $CanvasLayer/PauseMenu
@onready var pause_button: Button = $CanvasLayer/PauseButton
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var main_camera: MainCamera = $MainCamera
@onready var galaxy_spawner: GalaxySpawner = $GalaxySpawner
@onready var minimap_markers: MinimapMarkers = $MinimapViewport/MinimapMarkers
@onready var conditions_panel: ConditionsPanel = $CanvasLayer/ConditionsPanel
@onready var score_panel: ScorePanel = $CanvasLayer/ScorePanel
@onready var radar_texture: RadarWrap = $CanvasLayer/MinimapPanel/RadarTexture
@onready var burst_panel: Panel = $CanvasLayer/BurstPanel
@onready var tutorial_panel: Node = $CanvasLayer/TutorialPanel
@onready var help_button: Button = $CanvasLayer/HelpButton
@onready var close_tutorial_button: MainButton = $CanvasLayer/TutorialPanel/CloseTutorialButton

enum GameState {
	ONGOING, PAUSED, FINISHED
}

var tooltip_duration: float = 2.0
var current_state: GameState = GameState.ONGOING

func _ready() -> void:
	Globals.player = player
	Globals.game_camera = main_camera
	
	dash_panel.setup(player.get_dash_count())
	burst_panel.visible = false
	
	pause_menu.on_resume.connect(_handle_toggle_pause)
	pause_menu.on_finish.connect(_handle_finish)
	pause_button.pressed.connect(func() -> void:
		_handle_toggle_pause()
		AudioManager.play_sfx(AudioManager.tracks.click)
		animation_component.subtle_wobble(pause_button)
	)
	
	help_button.pressed.connect(func() -> void:
		_show_tutorial(false, true)
		AudioManager.play_sfx(AudioManager.tracks.click)
		animation_component.subtle_wobble(help_button)
	)
	
	close_tutorial_button.pressed.connect(func() -> void:
		_hide_tutorial()
		AudioManager.play_sfx(AudioManager.tracks.click)
		animation_component.subtle_wobble(help_button)
	)
	
	EventManager.on_game_over.connect(_on_game_over_animation)
	EventManager.on_galaxy_absorbed.connect(_on_galaxy_absorbed)
	EventManager.on_black_hole_desintegrated.connect(_on_black_hole_desintegrated)
	EventManager.on_buffs_applied.connect(_on_buffs_applied)
	EventManager.on_tug_of_war.connect(_on_tug_of_war)
	
	AudioManager.configure_audio_server(
		Globals.current_save.sfx_level,
		Globals.current_save.music_level
	)
	
	AudioManager.start_playlist()
	Input.set_custom_mouse_cursor(POINTER_C)
	SceneManager.fade_in()
	
	_show_tutorial_first_time()

func _on_tug_of_war(value: bool) -> void:
	burst_panel.visible = value

func _on_buffs_applied(data: Dictionary) -> void:
	conditions_panel.set_data(data)

func _show_tutorial_first_time() -> void:
	var is_first_time: bool = Globals.current_save.is_first_time
	
	if is_first_time:
		Globals.current_save.is_first_time = false
		DataManager.write_save(Globals.current_save)
		_show_tutorial(true, false)

func _show_tutorial(autohide: bool, freeze: bool) -> void:
	tutorial_panel.visible = true
	_change_state(GameState.PAUSED)
	
	if freeze:
		Engine.time_scale = 0.0
	
	if autohide:
		await get_tree().create_timer(6.0).timeout
		_hide_tutorial()

func _hide_tutorial() -> void:
	Engine.time_scale = 1.0
	tutorial_panel.visible = false
	_change_state(GameState.ONGOING)

#region debug
var i = 0
func _get_buff() -> Dictionary:
	var options: Array = BuffDebuffPool.buffs + BuffDebuffPool.debuffs
	var data: Dictionary = options[i].duplicate()
	i = (i + 1) % options.size()
	return data
#endregion
	
func _process(delta: float) -> void:
	if OS.is_debug_build() and Input.is_action_just_pressed("debug"):
		var g = GalaxyData.new()
		g.buff_debuff = _get_buff()
		EventManager.on_galaxy_absorbed.emit(g)
	
	if current_state == GameState.ONGOING:
		Globals.elapse_time += delta
	
	if Input.is_action_just_pressed("pause") and current_state != GameState.FINISHED:
		if tutorial_panel.visible:
			_hide_tutorial()
			_change_state(GameState.ONGOING)
		else:
			_handle_toggle_pause()
			
		AudioManager.play_sfx(AudioManager.tracks.show_ui)

func _change_state(new_state: GameState) -> void:
	current_state = new_state
	EventManager.on_game_state_changed.emit(new_state)

func _on_player_wrapped(offset: Vector2) -> void:
	var camera: MainCamera = Globals.game_camera
	camera.position += offset

func _handle_toggle_pause() -> void:
	if pause_menu.visible:
		pause_menu.dismiss()
		Engine.time_scale = 1.0
		_change_state(GameState.ONGOING)
	else:
		pause_menu.present()
		Engine.time_scale = 0.0
		_change_state(GameState.PAUSED)

func _on_game_over_animation():
	_change_state(GameState.FINISHED)
	radar_texture.stop_shader()
	_on_game_over()

func _on_game_over() -> void:
	SceneManager.transition_to(Scenes.FINISH)

func _handle_finish() -> void:
	Engine.time_scale = 1.0
	SceneManager.transition_to(Scenes.TITLE)

func _on_galaxy_absorbed(data: GalaxyData) -> void:
	player.absorb_galaxy(data)
	galaxy_spawner.remove_galaxy(data)
	_grant_score(1)
	
func _on_black_hole_desintegrated(data: BlackHoleData) -> void:
	galaxy_spawner.remove_black_hole(data)
	_grant_score(1)

func _grant_score(points_earned: int) -> void:
	Globals.current_score += points_earned
	score_panel.increment_score(points_earned)
