class_name PlayerMovement
extends Node2D

enum MovementType {
	NORMAL, TANK, INVERTED
}

@export var player: Player
@export var dash_speed: float = 200.0
@export var acceleration: float = 300.0
@export var friction: float = 0.98
@export var movement_type: MovementType = MovementType.NORMAL

func set_control_type(type: MovementType) -> void:
	movement_type = type
	# actually do something

func _process(delta: float) -> void:
	if not player.can_move:
		return
	
	var input_dir: Vector2 = _get_input_direction()
	if input_dir != Vector2.ZERO:
		player.velocity += input_dir * acceleration * delta

	if Input.is_action_just_pressed("dash"):
		if player.can_dash():
			if input_dir != Vector2.ZERO:
				player.velocity += input_dir * dash_speed
				player.use_dash()
		else:
			player.use_dash_error()
		
	player.position += player.velocity * delta
	player.velocity *= friction
	player.scale = lerp(player.scale, Vector2(player.target_size, player.target_size), 0.1)

func _get_input_direction() -> Vector2:
	var dir: Vector2 = Vector2.ZERO

	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	return dir.normalized()
