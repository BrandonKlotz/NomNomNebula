extends Node

@onready var start_over_button: Button = $CanvasLayer/SummaryPanel/Panel/StartOverButton
@onready var exit_button: Button = $CanvasLayer/SummaryPanel/Panel/ExitButton
@onready var current_label: Label = $CanvasLayer/SummaryPanel/Panel/CurrentLabel
@onready var highest_label: Label = $CanvasLayer/SummaryPanel/Panel/HighestLabel

func _ready() -> void:
	start_over_button.pressed.connect(_start_over)
	exit_button.pressed.connect(_exit_game)
	_setup_data()
	
	SceneManager.fade_in()

func _start_over() -> void:
	SceneManager.transition_to(Scenes.WORLD, false)
	
func _exit_game() -> void:
	SceneManager.transition_to(Scenes.TITLE, false)

func _setup_data() -> void:
	var save: SaveGame = Globals.current_save
	if not save:
		return
	
	current_label.text = "Score: " + str(Globals.current_score)
	highest_label.text = "Highest: " + str(save.data.highest_score)
