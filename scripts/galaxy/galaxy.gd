class_name Galaxy
extends Node2D

@export var data: GalaxyData
@export var scaling_speed: float = 1

@onready var animation: AnimatedSprite2D = get_node("Animation")
@onready var size: float = data.size

var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	$InteractionArea/CollisionShape2D.shape.radius = data.interaction_radius
	animation.play("main")
	
func _process(delta: float) -> void:
	size = lerp(size, 2.0, scaling_speed * delta)
	scale = Vector2(size, size)
	position += velocity * delta

func apply_force(force:Vector2) ->void:
	velocity += force


func _on_center_area_entered(area: Area2D) -> void:
	Globals.player.velocity = Vector2.ZERO
	Globals.player.apply_force((Globals.player.global_position - global_position).normalized() * 500)
