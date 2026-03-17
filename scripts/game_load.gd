extends Node

@onready var logo_panel: Panel = $CanvasLayer/Panel/LogoPanel

func _ready() -> void:
	SceneManager.fade_in(_animate_logo)
	#_animate_logo()

func _animate_logo() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(logo_panel, "modulate:a", 1.0, 0.4)
	tween.tween_interval(0.5)
	tween.tween_property(logo_panel, "modulate:a", 0.0, 0.5)
	tween.tween_callback(_navigate_to_title)

func _navigate_to_title() -> void:
	SceneManager.transition_to(Scenes.TITLE)
