class_name Player
extends Node2D

@onready var dash_component: DashComponent = $DashComponent
@onready var stabilization_component: StabilizationComponent = $StabilizationComponent
@onready var player_movement: PlayerMovement = $PlayerMovement
@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_target : Node2D = $CameraTarget
@onready var dash_particles: GPUParticles2D = $DashParticles

var can_move: bool = true
var can_control: bool = true
var target_size: float = 0.5
var velocity: Vector2 = Vector2.ZERO
var color_amount: int = 1

var escaping_timer_factor: float = 1.0
var absorption_speed_factor: float = 1.0
var increase_size_factor: float = 0.15
var can_be_absorbed : bool = true

func _ready() -> void:
	animation.play("main")
	EventManager.on_game_state_changed.connect(_on_game_state_changed)
	
	dash_particles.one_shot = true
	dash_particles.emitting = false
	
	# FIXME: remove
	#await get_tree().create_timer(4.0).timeout
	#var r = GalaxyData.new()
	#absorb_galaxy(r)

func _process(_delta: float) -> void:
	camera_target.global_position = global_position + (velocity)

func use_dash() -> void:
	dash_component.consume_dash()
	EventManager.on_camera_shake.emit(1.0, 1.0)
	dash_particles.restart()

func use_dash_error() -> void:
	EventManager.on_dash_error.emit()
	dash_component.dash_error()

func get_dash_count() -> int:
	return dash_component.dash_count

func can_dash() -> bool:
	return dash_component.can_dash()

func apply_force(force: Vector2) -> void:
	velocity += force

func absorb_galaxy(data: GalaxyData) -> void:
	$Sprite2D.material.set_shader_parameter("color_count", color_amount + 1)
	color_amount += 1
	var buff_debuff: Dictionary = data.buff_debuff
	
	# FIXME: Remove debug
	#buff_debuff = BuffDebuffPool.buffs[0]
	#buff_debuff = BuffDebuffPool.buffs[0]
	#buff_debuff = BuffDebuffPool.pool["debuffs"][4]
	#print(buff_debuff)
	
	target_size += increase_size_factor
	player_movement.set_control_type(PlayerMovement.ControlType.NORMAL)
	dash_component.reset_buffs()
	stabilization_component.reset_buffs()
	stabilization_component.add_time(data.stability_buff)
	
	apply_buff_debuff(buff_debuff)
	EventManager.on_buff_applied.emit(buff_debuff)

func apply_buff_debuff(buff: Dictionary) -> void:
	var HANDLERS: Dictionary = {
		BuffDebuffKey.EXTRA_DASHES: _apply_extra_dashes,
		BuffDebuffKey.DASH_FORCE_FACTOR: _apply_dash_force_factor,
		BuffDebuffKey.ESCAPING_TIME: _apply_escaping_time,
		BuffDebuffKey.DASH_RECHARGE_FACTOR: _apply_dash_recharge_factor,
		BuffDebuffKey.MOVEMENT_WARP_FACTOR: _apply_movement_speed_factor,
		BuffDebuffKey.INTERACTION_RADIUS_FACTOR: _apply_interaction_radius_factor,
		BuffDebuffKey.ABSORPTION_SPEED_FACTOR: _apply_absorption_speed_factor,
		BuffDebuffKey.STABILITY_MAX: _apply_stability_max,
		BuffDebuffKey.CONTROL_TYPE: _apply_control_type,
	}

	for key in buff.keys():
		if key == "rarity":
			continue
		if HANDLERS.has(key):
			HANDLERS[key].call(buff[key])
		else:
			push_warning("Unsupported buff key '%s'" % key)
			
func _on_game_state_changed(state: GameWorld.GameState) -> void:
	match state:
		GameWorld.GameState.ONGOING:
			can_move = true
		GameWorld.GameState.PAUSED:
			can_move = false
		GameWorld.GameState.FINISHED:
			can_move = false

#region buff debuff handlers

func _apply_control_type(value: int) -> void:
	player_movement.set_control_type(PlayerMovement.ControlType.values()[value])

func _apply_extra_dashes(value: int) -> void:
	dash_component.apply_extra_dashes(value)

func _apply_dash_force_factor(value: float) -> void:
	dash_component.apply_force_factor(value)

func _apply_dash_recharge_factor(value: float) -> void:
	dash_component.apply_recharge_factor(value)
	
func _apply_stability_max(value: int) -> void:
	stabilization_component.modify_max_time(value)

func _apply_escaping_time(value: float) -> void:
	escaping_timer_factor = value
	
func _apply_absorption_speed_factor(value: float) -> void:
	absorption_speed_factor = value

func _apply_movement_speed_factor(value: float) -> void:
	player_movement.apply_movement_factor_speed(value)

func _apply_interaction_radius_factor(value: float) -> void:
	pass

#func _apply_size_change_factor(value: float) -> void:
	#target_size *= (1.0 + value)
#func _apply_stability_time(value: float) -> void:
	#stabilization_component.add_time(value)
#func _apply_stability_drain_factor(value: float) -> void:
	#stabilization_component.apply_drain_factor(value)
#endregion
