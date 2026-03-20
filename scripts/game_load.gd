extends Node

@onready var godot_panel: Panel = $CanvasLayer/Panel/GodotPanel
@onready var logo_panel: Panel = $CanvasLayer/Panel/LogoPanel

func _ready() -> void:
	if Flags.autostart():
		var saves: Array[SaveGame] = DataManager.load_all_saves()
		if not saves.is_empty():
			Globals.current_save = saves[0]
			SceneManager.transition_to(Scenes.WORLD)
		else:
			SceneManager.fade_in(_animate_logo)
	else:
		SceneManager.fade_in(_animate_logo)

func _animate_logo() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(godot_panel, "modulate:a", 1.0, 0.4)
	tween.tween_interval(1.0)
	tween.tween_property(godot_panel, "modulate:a", 0.0, 0.5)
	
	tween.tween_interval(0.5)
	tween.tween_method(_play_sound, 0, 0, 0)
	tween.tween_property(logo_panel, "modulate:a", 1.0, 0.4)
	tween.tween_interval(1.2)
	tween.tween_property(logo_panel, "modulate:a", 0.0, 0.5)
	tween.tween_callback(_navigate_to_title)

func _navigate_to_title() -> void:
	SceneManager.transition_to(Scenes.TITLE)

func _play_sound(_v: Variant) -> void:
	AudioManager.play_sfx(AudioManager.tracks.logos)
