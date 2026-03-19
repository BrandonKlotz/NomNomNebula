extends Node

var size_incremented : bool = false
var size_incremented_amount : float
@export var interaction_collision_shape : CollisionShape2D

func _ready() -> void:
	EventManager.on_increment_galaxy_size.connect(_on_increment_size)
	EventManager.on_galaxy_absorbed.connect(_on_check_state)

func _on_check_state() -> void:
	if size_incremented:
		get_parent().size -= size_incremented_amount
	
#Increment galaxy size or interaction area size?
func _on_increment_size(amount:float) -> void:
	size_incremented_amount = amount
	#Galaxy Size
	get_parent().size += amount
	
	#Interaction Area
	if false: #Delete this
		interaction_collision_shape.shape.radius += amount
	size_incremented = true
	
