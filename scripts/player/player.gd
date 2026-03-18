class_name Player
extends Node2D

@onready var dash_component: DashComponent = $DashComponent
@onready var stabilization_component: StabilizationComponent = $StabilizationComponent
@onready var player_movement: PlayerMovement = $PlayerMovement

var can_move: bool = true
var target_size: float = 0.5
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	EventManager.on_game_state_changed.connect(_on_game_state_changed)
	await get_tree().create_timer(5.0).timeout
	var r = GalaxyData.new()
	absorb_galaxy(r)

func _process(_delta: float) -> void:
	pass

func use_dash() -> void:
	dash_component.consume_dash()
	EventManager.on_camera_shake.emit(0.7, 1.0)

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
	var buff_debuff: Dictionary = data.buff_debuff
	#var buff_debuff: Dictionary = BuffDebuffPool.pool["buffs"][0]
	
	#var buff_debuff: Dictionary = BuffDebuffPool.pool["debuffs"][2]
	#print(buff_debuff)
	
	dash_component.reset_buffs()
	#stabilization_component.reset_buffs()
	apply_buff_debuff(buff_debuff)

func apply_buff_debuff(buff: Dictionary) -> void:
	var HANDLERS: Dictionary = {
		BuffDebuffKey.EXTRA_DASHES: _apply_extra_dashes,
		BuffDebuffKey.DASH_FORCE_FACTOR: _apply_dash_force_factor,
		BuffDebuffKey.DASH_RECHARGE_FACTOR: _apply_dash_recharge_factor,
		BuffDebuffKey.STABILITY_TIME: _apply_stability_time,
		BuffDebuffKey.SIZE_CHANGE_FACTOR: _apply_size_change_factor,
		# not done yet
		BuffDebuffKey.STABILITY_SPEED_FACTOR: _apply_stability_speed_factor,
		BuffDebuffKey.ESCAPING_TIME_FACTOR: _apply_escaping_time_factor,
		BuffDebuffKey.ABSORTION_SPEED_FACTOR: _apply_absortion_speed_factor,
		BuffDebuffKey.MOVEMENT_SPEED_FACTOR: _apply_movement_speed_factor,
		BuffDebuffKey.CONTROL_TYPE: _apply_control_type,
		BuffDebuffKey.STABILITY_MAX: _apply_stability_max,
		BuffDebuffKey.BLACK_HOLES_PROB_FACTOR: _apply_black_holes_prob_factor,
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
func _apply_size_change_factor(value: float) -> void:
	target_size *= (1.0 + value)

func _apply_control_type(value: int) -> void:
	player_movement.set_control_type(PlayerMovement.MovementType.values()[value])

func _apply_extra_dashes(value: int) -> void:
	dash_component.apply_extra_dashes(value)

func _apply_dash_force_factor(value: float) -> void:
	dash_component.apply_force_factor(value)

func _apply_dash_recharge_factor(value: float) -> void:
	dash_component.apply_recharge_factor(value)
	
func _apply_stability_time(value: float) -> void:
	stabilization_component.add_time(value)

# TODO: missing applies
func _apply_escaping_time_factor(value: float) -> void:
	print("TODO: _apply_escaping_time_factor")
	pass
	
func _apply_absortion_speed_factor(value: float) -> void:
	print("TODO: _apply_absortion_speed_factor")
	pass

func _apply_movement_speed_factor(value: float) -> void:
	print("TODO: _apply_movement_speed_factor")
	pass

func _apply_stability_max(value: int) -> void:
	print("TODO: _apply_stability_max")
	pass

func _apply_stability_speed_factor(value: float) -> void:
	print("TODO: _apply_stability_speed_factor")
	pass

func _apply_black_holes_prob_factor(value: float) -> void:
	print("TODO: _apply_black_holes_prob_factor")
	pass
#endregion
