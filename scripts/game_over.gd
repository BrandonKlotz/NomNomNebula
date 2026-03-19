extends Node

@onready var highest_score: Label = $CanvasLayer/SummaryPanel/Panel/VBoxContainer/HBoxContainer/HighestScore
@onready var current_score: Label = $CanvasLayer/SummaryPanel/Panel/VBoxContainer/HBoxContainer2/CurrentScore
@onready var score_star: TextureRect = $CanvasLayer/SummaryPanel/Panel/VBoxContainer/HBoxContainer/ScoreStar
@onready var start_over_button: MainButton = $CanvasLayer/SummaryPanel/Panel/HBoxContainer/StartOverButton
@onready var exit_button: MainButton = $CanvasLayer/SummaryPanel/Panel/HBoxContainer/ExitButton

func _ready() -> void:
	start_over_button.pressed.connect(_start_over)
	exit_button.pressed.connect(_exit_game)
	
	_setup_data()
	
	AudioManager.play_music(AudioManager.tracks.finish_music)
	SceneManager.fade_in()

func _start_over() -> void:
	SceneManager.transition_to(Scenes.WORLD)
	
func _exit_game() -> void:
	SceneManager.transition_to(Scenes.TITLE)

func _setup_data() -> void:
	var save: SaveGame = Globals.current_save
	
	if not save:
		return
	
	highest_score.text = str(save.highest_score)
	current_score.text = str(Globals.current_score)
	
	var has_beaten_score: bool = Globals.current_score > save.highest_score
	score_star.visible = has_beaten_score
	
	if has_beaten_score:
		highest_score.add_theme_color_override("font_color", Color("#e3db48"))
