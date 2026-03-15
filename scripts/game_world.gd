extends Node

@onready var dash_panel: DashPanel = $CanvasLayer/DashPanel
@onready var player: Player = $Player
@onready var pause_menu: PauseMenu = $CanvasLayer/PauseMenu
@onready var pause_button: Button = $CanvasLayer/PauseButton
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var game_over_button: Button = $CanvasLayer/GameOverButton

var current_score: int = 10

func _ready() -> void:
	Globals.player = player
	dash_panel.setup(player.get_dash_count())
	
	game_over_button.pressed.connect(_on_game_over)
	pause_menu.on_resume.connect(_handle_toggle_pause)
	pause_menu.on_finish.connect(_handle_finish)
	pause_button.pressed.connect(func() -> void:
		_handle_toggle_pause()
		animation_component.subtle_wobble(pause_button)
	)
	
	EventManager.on_game_over.connect(_on_game_over)
	SceneManager.fade_in()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_handle_toggle_pause()
	
func _handle_toggle_pause() -> void:
	if pause_menu.visible:
		AudioManager.play_sfx(AudioManager.tracks.dismiss_ui)
		pause_menu.dismiss()
	else:
		pause_menu.show()
		# TODO: Stop engine time, animations, etc
		AudioManager.play_sfx(AudioManager.tracks.show_ui)

func _on_game_over() -> void:
	if current_score > Globals.current_save.data.highest_score:
		Globals.current_save.data.highest_score = current_score
		DataManager.write_save(Globals.current_save)
	
	Globals.current_score = current_score
	SceneManager.transition_to(Scenes.FINISH, false)

func _handle_finish() -> void:
	SceneManager.transition_to(Scenes.TITLE, false)
