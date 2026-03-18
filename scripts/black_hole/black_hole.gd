class_name BlackHole
extends Node2D

@export var data: BlackHoleData
@onready var interaction_collision_shape: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var timer_label: Label = $TimerLabel

func _ready() -> void:
	var shape: CircleShape2D = interaction_collision_shape.shape.duplicate()
	print(data.strength)
	shape.radius = data.interaction_radius
	interaction_collision_shape.shape = shape

func _process(delta: float) -> void:
	pass

func _on_center_area_entered(area: Area2D) -> void:
	EventManager.on_player_absorbed.emit()
	EventManager.on_camera_shake.emit(5.0, 2.0)
