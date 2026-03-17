extends Node

var timer = 5
var active_tutorial : bool = false
@onready var tutorial_panel = get_parent().get_node("CanvasLayer/AbsortionTutorial")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return
	EventManager.on_attraching_player.connect(on_start_tutorial)
	pass # Replace with function body.

func on_start_tutorial():
	tutorial_panel.visible = true
	Engine.time_scale = 0.2
	active_tutorial = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not active_tutorial: return
	if Input.is_action_just_pressed("dash"):
		Engine.time_scale = 1.0
		self.queue_free()
		tutorial_panel.queue_free()
