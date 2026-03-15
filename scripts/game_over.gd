extends Node

@onready var start_over_button: Button = $CanvasLayer/SummaryPanel/Panel/StartOverButton
@onready var exit_button: Button = $CanvasLayer/SummaryPanel/Panel/ExitButton

func _ready() -> void:
	start_over_button.pressed.connect(_start_over)
	exit_button.pressed.connect(_exit_game)
	
	SceneManager.fade_in()

func _start_over() -> void:
	SceneManager.transition_to(Scenes.WORLD, false)
	
func _exit_game() -> void:
	SceneManager.transition_to(Scenes.TITLE, false)
