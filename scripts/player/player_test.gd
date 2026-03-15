class_name Player
extends Node2D

@onready var dash_component: DashComponent = $DashComponent

@export var forward_speed: float = 10
@export var dash_speed: float = 50
@export var turn_speed: float = 10

var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_pressed("turn_left"):
		rotation += -turn_speed * delta
	if Input.is_action_pressed("turn_right"):
		rotation += turn_speed * delta
	
	if Input.is_action_pressed("move_forward"):
		move_forward(delta, forward_speed)
	
	if Input.is_action_just_pressed("dash"):
		try_dash(delta)
	
	position += velocity * delta
		
func move_forward(delta: float, speed: float) -> void:
	var dir_vec: Vector2 = Utils.rotation_to_vector(rotation)
	velocity += dir_vec * speed * delta

func try_dash(_delta: float) -> void:
	if dash_component.can_dash():
		var dir_vec: Vector2 = Utils.rotation_to_vector(rotation)
		velocity += dir_vec * dash_speed
		dash_component.use_dash()
	else:
		EventManager.on_dash_error.emit()
		dash_component.dash_error()

func get_dash_count() -> int:
	return dash_component.dash_count
