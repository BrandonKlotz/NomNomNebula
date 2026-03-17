class_name BlackHole
extends Node2D

@export var data : BlackHoleData

@onready var timer_label : Label = get_node("TimerLabel")
@onready var interaction_collision_shape: CollisionShape2D = $InteractionArea/CollisionShape2D

func _ready() -> void:
	var shape: CircleShape2D = interaction_collision_shape.shape.duplicate()
	shape.radius = data.interaction_radius
	interaction_collision_shape.shape = shape

func _process(delta: float) -> void:
	pass


func _on_center_area_entered(area: Area2D) -> void:
	EventManager.on_player_absorbed.emit()
