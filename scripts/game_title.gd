extends Node

@onready var version_label: Label = $CanvasLayer/Panel/VersionLabel

func _ready() -> void:
	SceneManager.fade_in()
	AudioManager.play_music(AudioManager.tracks.title_music)
	
	_setup_ui()

func _setup_ui() -> void:
	version_label.text = "Version " + ProjectSettings.get_setting("application/config/version")
