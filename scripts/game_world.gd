extends Node

@onready var dash_panel: DashPanel = $CanvasLayer/DashPanel
@onready var player_test: Player = $PlayerTest
@onready var pause_menu: PauseMenu = $CanvasLayer/PauseMenu
@onready var pause_button: Button = $CanvasLayer/PauseButton

func _ready() -> void:
	dash_panel.setup(player_test.get_dash_count())
	
	pause_button.pressed.connect(_handle_toggle_pause)
	pause_menu.on_resume.connect(_handle_toggle_pause)
	
	SceneManager.fade_in()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_handle_toggle_pause()
	
func _handle_toggle_pause() -> void:
	if pause_menu.visible:
		pause_button.visible = true
		AudioManager.play_sfx(AudioManager.tracks.dismiss_ui)
		pause_menu.dismiss()
	else:
		pause_menu.show()
		pause_button.visible = false
		AudioManager.play_sfx(AudioManager.tracks.show_ui)
