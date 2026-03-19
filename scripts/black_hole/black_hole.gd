class_name BlackHole
extends Node2D

@export var data: BlackHoleData
@onready var interaction_collision_shape: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	var shape: CircleShape2D = interaction_collision_shape.shape.duplicate()
	shape.radius = data.interaction_radius
	interaction_collision_shape.shape = shape

func _on_center_area_entered(_area: Area2D) -> void:
	EventManager.on_player_absorbed.emit(self)
	EventManager.on_camera_shake.emit(4.0)
	
	Globals.player.can_move = false
	animation_player.play("expand")
	state_machine.on_change_state('disabled')
	get_tree().create_timer(0.8).timeout.connect(_on_game_over_emit)
	EventManager.on_shock_wave.emit(self)
	
func _on_game_over_emit() -> void:
	EventManager.on_game_over.emit()
