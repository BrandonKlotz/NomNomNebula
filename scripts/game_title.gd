extends Node

const POINTER_C: Resource = preload("uid://b085nphr6bvo4")

@onready var version_label: Label = $CanvasLayer/Panel/VersionLabel
@onready var start_button: MainButton = $CanvasLayer/Panel/VBoxContainer/StartButton
@onready var credits_button: MainButton = $CanvasLayer/Panel/VBoxContainer/CreditsButton
@onready var exit_button: MainButton = $CanvasLayer/Panel/ExitButton
@onready var highest_score: Label = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/HighestScore
@onready var h_box_container: HBoxContainer = $CanvasLayer/Panel/VBoxContainer/HBoxContainer

@onready var credits_panel: Panel = $CanvasLayer/Panel/CreditsPanel
@onready var close_credits_button: MainButton = $CanvasLayer/Panel/CreditsPanel/CloseCreditsButton

func _ready() -> void:
	_load_save()
	_clear_globals()
	
	var save: SaveGame = _load_save()
	
	AudioManager.configure_audio_server(
		save.sfx_level,
		save.music_level
	)
	
	Globals.current_save = save
	
	credits_panel.visible = false
	SceneManager.fade_in()
	Input.set_custom_mouse_cursor(POINTER_C)
	AudioManager.play_music(AudioManager.tracks.title_music)
	
	start_button.pressed.connect(_on_start_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	credits_button.pressed.connect(_on_credits_button_pressed)
	
	close_credits_button.pressed.connect(func() -> void:
		credits_panel.visible = false
		AudioManager.play_sfx(AudioManager.tracks.click)
	)
	
	_setup_ui()

func _clear_globals() -> void:
	Globals.player = null
	Globals.game_camera = null
	Globals.current_score = 0
	Globals.elapse_time = 0.0
	
func _load_save() -> SaveGame:
	var saves = DataManager.load_all_saves()
	var save: SaveGame
	
	if saves.is_empty():
		save = DataManager.new_save_file(0)
		DataManager.write_save(save)
	else:
		save = saves[0]
	
	return save
	
func _setup_ui() -> void:
	version_label.text = "v_" + ProjectSettings.get_setting("application/config/version")
	
	highest_score.text = str(Globals.current_save.highest_score)
	if Globals.current_save.highest_score == 0:
		h_box_container.visible = false
	
	if OS.has_feature("web"):
		exit_button.visible = false
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and credits_panel.visible:
		credits_panel.visible = false
		AudioManager.play_sfx(AudioManager.tracks.dismiss_ui)

func _on_start_button_pressed() -> void:
	AudioManager.stop_music()
	SceneManager.transition_to(Scenes.WORLD)
	AudioManager.play_sfx(AudioManager.tracks.click)

func _on_exit_button_pressed() -> void:
	if OS.has_feature("web"):
		return
	
	AudioManager.play_sfx(AudioManager.tracks.click)
	get_tree().quit()

func _on_credits_button_pressed() -> void:
	AudioManager.play_sfx(AudioManager.tracks.click)
	credits_panel.visible = true
