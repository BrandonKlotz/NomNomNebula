class_name MainCamera
extends Camera2D

@export var player: Player
@export var follow_speed: float = 1.5
@export var zoom_speed: float = 1

var target : Node2D
var rng = RandomNumberGenerator.new()
var shaking : bool = false
var shake_strength : float
var shake_time : float
var target_zoom: Vector2 = Vector2(1, 1)
var hard_zoom : bool = false

func _ready() -> void:
	target = player.camera_target
	EventManager.on_camera_shake.connect(on_start_shake)

func _process(delta: float) -> void:
	if target == Globals.player.camera_target and not hard_zoom:
		target_zoom = (Vector2.ONE/(Globals.player.target_size))*0.7
		if Globals.player.target_size < 0.4:
			target_zoom = Vector2(1.75, 1.75)
		position += (target.global_position - global_position)*follow_speed/Globals.player.target_size * delta
	else:
		position += (target.global_position - global_position) * follow_speed * delta
	zoom = lerp(zoom, target_zoom, zoom_speed*delta)
	
	if shake_strength > 0:
		position += get_random_offset()
		shake_strength = lerpf(shake_strength, 0, 5.0 * delta)

func set_target(_target) -> void:
	target = _target

func on_start_shake(strength) -> void:
	shake_strength = strength

func get_random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
