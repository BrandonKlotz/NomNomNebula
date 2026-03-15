extends Node

const POINTER_C: Resource = preload("uid://b085nphr6bvo4")

@onready var version_label: Label = $CanvasLayer/Panel/VersionLabel
@onready var start_button: Button = $CanvasLayer/Panel/VBoxContainer/StartButton
@onready var exit_button: Button = $CanvasLayer/Panel/VBoxContainer/ExitButton

func _ready() -> void:
	_load_save()
	
	var save: SaveGame = _load_save()
	
	AudioManager.configure_audio_server(
		save.data.sfx_level,
		save.data.music_level
	)
	
	Globals.current_save = save
	
	SceneManager.fade_in()
	Input.set_custom_mouse_cursor(POINTER_C)
	#AudioManager.play_music(AudioManager.tracks.title_music)
	
	start_button.pressed.connect(_on_start_button_pressed)
	start_button.mouse_entered.connect(_on_hover)
	
	exit_button.pressed.connect(_on_exit_button_pressed)
	exit_button.mouse_entered.connect(_on_hover)
	
	_setup_ui()

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
	version_label.text = "Version " + ProjectSettings.get_setting("application/config/version")

func _on_start_button_pressed() -> void:
	SceneManager.transition_to(Scenes.WORLD, false)
	AudioManager.play_sfx(AudioManager.tracks.click)

func _on_hover() -> void:
	AudioManager.play_sfx(AudioManager.tracks.hover)

func _on_exit_button_pressed() -> void:
	get_tree().quit()
