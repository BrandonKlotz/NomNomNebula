extends Node

func _ready() -> void:
	SceneManager.fade_in()
	_navigate_to_title()

func _navigate_to_title() -> void:
	SceneManager.transition_to(Scenes.TITLE)
