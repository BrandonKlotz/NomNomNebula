class_name PauseMenu
extends Node

signal on_resume
signal on_finish

@onready var resume_button: Button = $PauseMenu/ResumeButton
@onready var exit_button: Button = $PauseMenu/ExitButton
@onready var effects_slider: HSlider = $PauseMenu/EffectsSlider
@onready var music_slider: HSlider = $PauseMenu/MusicSlider

var save: SaveGame

func _ready() -> void:
	resume_button.pressed.connect(func() -> void: on_resume.emit())
	exit_button.pressed.connect(func() -> void: on_finish.emit())
	
	var saves: Array[SaveGame] = DataManager.load_all_saves()
	if not saves.is_empty():
		save = saves[0]
	
	_setup_sliders()
	_subscribe_to_sliders()
	dismiss()

func present() -> void:
	self.visible = true

func dismiss() -> void:
	self.visible = false

func _setup_sliders() -> void:
	music_slider.min_value = 0
	music_slider.max_value = 10
	music_slider.value = save.data.music_level
	
	effects_slider.min_value = 0
	effects_slider.max_value = 10
	effects_slider.value = save.data.sfx_level
	
func _subscribe_to_sliders() -> void:
	music_slider.drag_ended.connect(func(value_changed: bool) -> void:
		if value_changed:
			save.data.music_level = int(music_slider.value)
			DataManager.write_save(save)
			AudioManager.configure_audio_server(save.data.sfx_level, save.data.music_level)
	)
	
	effects_slider.drag_ended.connect(func(value_changed: bool) -> void:
		if value_changed:
			save.data.sfx_level = int(effects_slider.value)
			DataManager.write_save(save)
			AudioManager.configure_audio_server(save.data.sfx_level, save.data.music_level)
	)
