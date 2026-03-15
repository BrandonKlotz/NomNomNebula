class_name Galaxy
extends Node2D

@export var data : GalaxyData
@export var scaling_speed: float = 1

@onready var animation : AnimatedSprite2D = get_node("Animation")
@onready var size : float = data.size

var velocity : Vector2 = Vector2.ZERO

func _ready() -> void:
	$InteractionArea/CollisionShape2D.shape.radius = data.interaction_radius
	animation.play("main")
	
func _process(delta: float) -> void:
	size = lerp(size, 1.0, scaling_speed*delta)
	scale = Vector2(size, size)
	position += velocity*delta

func apply_force(force:Vector2) ->void:
	velocity += force
