class_name BlackHole
extends Node2D

@export var data: BlackHoleData
@onready var interaction_collision_shape: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var state_machine: StateMachine = $StateMachine
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer
@onready var animation: AnimatedSprite2D = $Animation

func _ready() -> void:
	var shape: CircleShape2D = interaction_collision_shape.shape.duplicate()
	shape.radius = data.interaction_radius
	interaction_collision_shape.shape = shape
	animation.play("main")

func _on_center_area_entered(_area: Area2D) -> void:
	EventManager.on_player_absorbed.emit(self)
	EventManager.on_camera_shake.emit(4.0)
	Globals.game_camera.target = self
	Globals.player.can_move = false

	EventManager.on_black_hole_expanded.emit()
	get_tree().create_timer(1.2).timeout.connect(_on_game_over_emit)

func _on_game_over_emit() -> void:
	EventManager.on_game_over.emit()

func play_appear() -> void:
	animation.speed_scale = 1.0
	animation.play("appear")
	await get_tree().create_timer(0.5).timeout
	animation.play("idle")

func play_dissappear() -> void:
	animation.speed_scale = -1
	animation.play("appear")
