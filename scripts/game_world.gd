extends Node

@onready var dash_panel: DashPanel = $CanvasLayer/DashPanel
@onready var player_test: Player = $PlayerTest
@onready var pause_menu: PauseMenu = $CanvasLayer/PauseMenu
@onready var pause_button: Button = $CanvasLayer/PauseButton
@onready var animation_component: AnimationComponent = $AnimationComponent

func _ready() -> void:
	dash_panel.setup(player_test.get_dash_count())
	
	pause_button.pressed.connect(func() -> void:
		_handle_toggle_pause()
		animation_component.subtle_wobble(pause_button)
	)
	pause_menu.on_resume.connect(_handle_toggle_pause)
	
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
