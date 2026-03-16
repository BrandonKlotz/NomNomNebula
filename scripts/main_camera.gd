extends Camera2D

var zoom_target : Vector2 = Vector2(1.0, 1.0)
@export var target : Node2D
@export var follow_reduction_factor : float = 1
@export var zoom_speed : float = 1

var target_zoom: Vector2 = Vector2(1, 1)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if target == Globals.player:
		target_zoom = Vector2.ONE - Vector2(Globals.player.velocity.length() * 0.0015, Globals.player.velocity.length() * 0.0015)

	position += (target.global_position - global_position)/follow_reduction_factor * delta
	zoom = lerp(zoom, target_zoom, zoom_speed*delta)

func set_target(_target) -> void:
	target = _target
