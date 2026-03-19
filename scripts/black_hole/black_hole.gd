class_name BlackHole
extends Node2D

@export var data: BlackHoleData
@onready var interaction_collision_shape: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var timer_label: Label = $TimerLabel

func _ready() -> void:
	var shape: CircleShape2D = interaction_collision_shape.shape.duplicate()
	shape.radius = data.interaction_radius
	interaction_collision_shape.shape = shape

func _process(delta: float) -> void:
	pass

func _on_center_area_entered(area: Area2D) -> void:
	EventManager.on_player_absorbed.emit(self)
	EventManager.on_camera_shake.emit(4.0, 2.0)
	Globals.player.can_move = false
	$Sprite2D/AnimationPlayer.play("expand")
	$StateMachine.on_change_state('disabled')
	get_tree().create_timer(0.8).timeout.connect(_on_game_over_emit)
	EventManager.on_shock_wave.emit(self)
	
	
func _on_game_over_emit() -> void:
	EventManager.on_game_over.emit()
