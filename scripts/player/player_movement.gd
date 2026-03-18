class_name PlayerMovement
extends Node2D

enum ControlType {
	NORMAL, TANK, INVERTED
}

var movement_type_map: Dictionary = {
	ControlType.NORMAL: _normal_movement,
	ControlType.TANK: _tank_movement,
}

@export var player: Player
@export var movement_indicator : Sprite2D
@export var dash_speed: float = 200.0
@export var acceleration: float = 300.0
@export var friction: float = 0.98
@export var current_movement_type: ControlType = ControlType.TANK

var movement_speed_factor : float = 1
var rotation_speed: float = 5
var movement_angle: float = 0
var speed: float = 300
var axes_direction : Vector2 = Vector2.ONE

func set_control_type(type: ControlType) -> void:
	movement_indicator.visible = false
	current_movement_type = type
	
	if type == ControlType.TANK:
		movement_indicator.visible = true

func _process(delta: float) -> void:
	if not player.can_move:
		return
	
	if player.can_control:
		movement_type_map[current_movement_type].call(delta)
	
	player.position += player.velocity * delta
	player.velocity *= friction
	player.scale = lerp(player.scale, Vector2(player.target_size, player.target_size), 0.1)

func _normal_movement(delta: float):
	var input_dir: Vector2 = _get_input_direction()
	if input_dir != Vector2.ZERO:
		player.velocity += input_dir * acceleration * delta
		try_dash(input_dir)

func _tank_movement(delta: float):
	if Input.is_action_pressed("move_left"):
		movement_angle -= rotation_speed * delta
	if Input.is_action_pressed("move_right"):
		movement_angle += rotation_speed * delta
	if Input.is_action_pressed("move_up"):
		player.velocity += Vector2(cos(movement_angle), sin(movement_angle)) * speed * delta
	try_dash(Utils.rotation_to_vector(movement_angle))
	

func try_dash(dir: Vector2):
	if Input.is_action_just_pressed("dash"):
		if player.can_dash():
			if dir != Vector2.ZERO:
				EventManager.on_dash_used.emit()
				player.velocity += dir * dash_speed
				player.use_dash()
		else:
			player.use_dash_error()

func _get_input_direction() -> Vector2:
	var dir: Vector2 = Vector2.ZERO

	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	return (dir*axes_direction).normalized()

func apply_movement_factor_speed(factor:float) -> void:
	movement_speed_factor = factor
	
func invert_axes(axes:Vector2) -> void:
	axes_direction *= axes 
	
func set_axes_direction(directions: Vector2) -> void:
	axes_direction = directions
