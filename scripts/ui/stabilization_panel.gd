class_name StabilizationPanel
extends Node

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var animation_component: AnimationComponent = $AnimationComponent

var default_color: Color
var warning_color: Color = Color.RED
var total_frames: int = 35

func _ready() -> void:
	EventManager.on_stabilization_changed.connect(_on_stabilization_changed)
	EventManager.on_stabilization_max_changed.connect(_on_stabilization_max_changed)

func _on_stabilization_changed(data: Dictionary) -> void:
	var progress: float = 1.0 - data["progress"]
	var frame_index: int = int(progress * (total_frames - 1))
	sprite_2d.frame = frame_index
	
	var current_time: int = int(data["current_time"])
	label.text = str(current_time)

func _on_stabilization_max_changed() -> void:
	animation_component.subtle_wobble(sprite_2d)
