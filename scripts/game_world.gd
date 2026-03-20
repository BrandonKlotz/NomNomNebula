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

enum GameState {
	ONGOING, PAUSED, FINISHED
}

var tooltip_duration: float = 2.0
var showing_absorption_tutorial: bool = false
var current_state: GameState = GameState.ONGOING
var playlist: Array[AudioSetting] = []
var current_track: int = 0

func _ready() -> void:
	Globals.player = player
	Globals.game_camera = main_camera
	
	dash_panel.setup(player.get_dash_count())
	
	pause_menu.on_resume.connect(_handle_toggle_pause)
	pause_menu.on_finish.connect(_handle_finish)
	pause_button.pressed.connect(func() -> void:
		_handle_toggle_pause()
		AudioManager.play_sfx(AudioManager.tracks.click)
		animation_component.subtle_wobble(pause_button)
	)
	
	EventManager.on_game_over.connect(_on_game_over_animation)
	EventManager.on_galaxy_absorbed.connect(_on_galaxy_absorbed)
	EventManager.on_buffs_applied.connect(_on_buffs_applied)
	
	AudioManager.configure_audio_server(
		Globals.current_save.sfx_level,
		Globals.current_save.music_level
	)
	
	_start_playlist()
	Input.set_custom_mouse_cursor(POINTER_C)
	SceneManager.fade_in()

func _start_playlist() -> void:
	playlist = [
		AudioManager.tracks.music_track_1,
		AudioManager.tracks.music_track_2,
		AudioManager.tracks.music_track_3,
		AudioManager.tracks.music_track_4,
		AudioManager.tracks.music_track_5,
	]
	
	_play_current_track()

func _play_current_track() -> void:
	var setting: AudioSetting = playlist[current_track]
	
	AudioManager.play_music(setting, current_track == 0)
	
	if AudioManager.music_player.finished.is_connected(_on_track_finished):
		AudioManager.music_player.finished.disconnect(_on_track_finished)
	
	AudioManager.music_player.finished.connect(_on_track_finished)

func _on_track_finished() -> void:
	if current_track >= playlist.size() - 1:
		_play_current_track()
	else:
		current_track += 1
		_play_current_track()

func _on_buffs_applied(data: Dictionary) -> void:
	conditions_panel.set_data(data)

func _process(delta: float) -> void:
	if OS.is_debug_build() and Input.is_action_just_pressed("debug"):
		var r = GalaxyData.new()
		r.buff_debuff = BuffDebuffPool.debuffs[0].duplicate()
		EventManager.on_galaxy_absorbed.emit(r)
	
	if current_state == GameState.ONGOING:
		Globals.elapse_time += delta
	
	if Input.is_action_just_pressed("pause") and current_state != GameState.FINISHED:
		AudioManager.play_sfx(AudioManager.tracks.show_ui)
		_handle_toggle_pause()
	
	if showing_absorption_tutorial and Input.is_action_just_pressed("dash"):
		Engine.time_scale = 1.0
		showing_absorption_tutorial = false

func _on_player_wrapped(offset: Vector2) -> void:
	var camera: MainCamera = Globals.game_camera
	camera.position += offset

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
	SceneManager.transition_to(Scenes.FINISH)
	AudioManager.music_player.finished.disconnect(_on_track_finished)
	AudioManager.stop_music()

func _handle_finish() -> void:
	Engine.time_scale = 1.0
	SceneManager.transition_to(Scenes.TITLE)

func _on_galaxy_absorbed(data: GalaxyData) -> void:
	player.absorb_galaxy(data)
	galaxy_spawner.remove_galaxy(data)
	
	var points_earned: int = 1
	Globals.current_score += points_earned
	score_panel.increment_score(points_earned)
	
