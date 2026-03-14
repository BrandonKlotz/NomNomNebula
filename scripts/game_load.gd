extends Node

func _ready() -> void:
	var prefs: UserPreferences = DataManager.load_prefs()
	
	TranslationServer.set_locale(prefs.language)
	AudioManager.configure_audio_server(prefs)
	SceneManager.fade_in()
	
	if Flags.skip_logos():
		_navigate_to_title()
	else:
		_start_animation()

func _navigate_to_title() -> void:
	SceneManager.transition_to(Scenes.TITLE, false)

func _start_animation() -> void:
	#var tween: Tween = create_tween()
	#var fade_duration: float = 0.4
	#
	#tween.tween_property(panel1, "modulate:a", 1.0, fade_duration)
	#tween.tween_interval(1.3)
	#tween.tween_property(panel1, "modulate:a", 0.0, fade_duration)
	#tween.tween_callback(_navigate_to_title)
	pass

	# some comment
