extends Node

@onready var highest_score_2: Label = $CanvasLayer/SummaryPanel/NormalPanel/VBoxContainer2/HBoxContainer/HighestScore2
@onready var highest_score: Label = $CanvasLayer/SummaryPanel/WinPanel/HBoxContainer/HighestScore
@onready var your_score: Label = $CanvasLayer/SummaryPanel/NormalPanel/VBoxContainer2/HBoxContainer3/YourScore
@onready var time_elapsed: Label = $CanvasLayer/SummaryPanel/WinPanel/HBoxContainer3/TimeElapsed

@onready var normal_panel: Panel = $CanvasLayer/SummaryPanel/NormalPanel
@onready var win_panel: Panel = $CanvasLayer/SummaryPanel/WinPanel

@onready var start_over_button: MainButton = $CanvasLayer/SummaryPanel/HBoxContainer/StartOverButton
@onready var exit_button: MainButton = $CanvasLayer/SummaryPanel/HBoxContainer/ExitButton

func _ready() -> void:
	start_over_button.pressed.connect(_start_over)
	exit_button.pressed.connect(_exit_game)
	
	_setup_data()
	SceneManager.fade_in()

func _start_over() -> void:
	SceneManager.transition_to(Scenes.WORLD)
	
func _exit_game() -> void:
	SceneManager.transition_to(Scenes.TITLE)

func _setup_data() -> void:
	var save: SaveGame = Globals.current_save
	if not save:
		return
	
	your_score.text = str(Globals.current_score)
	time_elapsed.text = _format_time(Globals.elapse_time)
	
	normal_panel.visible = false
	win_panel.visible = false
	
	var has_beaten_score: bool = Globals.current_score > save.highest_score
	
	if has_beaten_score:
		win_panel.visible = true
		highest_score.text = str(Globals.current_score)
		
		save.highest_score = Globals.current_score
		DataManager.write_save(save)
	else:
		normal_panel.visible = true
		highest_score_2.text = str(save.highest_score)

func _format_time(seconds: float) -> String:
	var mins: int = int(seconds) / 60
	var secs: float = fmod(seconds, 60.0)
	
	if mins > 0:
		return "%d:%05.2f" % [mins, secs]
	else:
		return "%.2fs" % secs
