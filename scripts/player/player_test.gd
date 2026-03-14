class_name Player
extends Node2D

@export var forward_speed:float = 10;
@export var burts_speed : float = 10;
@export var turn_speed : float = 10;

var velocity : Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("turn_left"):
		rotation += -turn_speed * delta
	if Input.is_action_pressed("turn_right"):
		rotation += turn_speed * delta
	
	if Input.is_action_pressed("move_forward"):
		move_forward(delta, forward_speed)
	
	if Input.is_action_pressed("burts"):
		move_forward(delta, burts_speed)
	
	position += velocity * delta
		
func move_forward(delta : float, speed : float) ->void:
	var dir_vec : Vector2 = Globals.rotation_to_vector(rotation)
	velocity += dir_vec * speed * delta
