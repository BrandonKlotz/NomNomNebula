extends Node

const POINTER_C: Resource = preload("uid://b085nphr6bvo4")

@onready var version_label: Label = $CanvasLayer/Panel/VersionLabel
@onready var start_button: MainButton = $CanvasLayer/Panel/VBoxContainer/StartButton
@onready var exit_button: MainButton = $CanvasLayer/Panel/VBoxContainer/ExitButton
@onready var credits_button: MainButton = $CanvasLayer/Panel/VBoxContainer/CreditsButton
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
	
	if SceneManager.last_scene != Scenes.FINISH:
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
	Globals.current_score = 0
	Globals.game_camera = null
	
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

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and credits_panel.visible:
		credits_panel.visible = false
		AudioManager.play_sfx(AudioManager.tracks.dismiss_ui)

func _on_start_button_pressed() -> void:
	AudioManager.stop_music()
	SceneManager.transition_to(Scenes.WORLD)
	AudioManager.play_sfx(AudioManager.tracks.click)

func _on_exit_button_pressed() -> void:
	AudioManager.play_sfx(AudioManager.tracks.click)
	get_tree().quit()

func _on_credits_button_pressed() -> void:
	AudioManager.play_sfx(AudioManager.tracks.click)
	credits_panel.visible = true
