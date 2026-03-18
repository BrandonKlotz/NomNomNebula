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

func _process(_delta: float) -> void:
	pass

func use_dash() -> void:
	dash_component.use_dash()
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
	print(buff_debuff)
	#apply_buff_debuff(buff_debuff)
	#target_size += 1 # data.mass

func apply_buff_debuff(buff: Dictionary) -> void:
	var HANDLERS: Dictionary = {
		BuffDebuffKey.EXTRA_DASHES: _apply_extra_dashes,
		BuffDebuffKey.DASH_SPEED_FACTOR: _apply_dash_speed_factor,
		BuffDebuffKey.ESCAPING_TIME_FACTOR: _apply_escaping_time_factor,
		BuffDebuffKey.ABSORTION_SPEED_FACTOR: _apply_absortion_speed_factor,
		BuffDebuffKey.MOVEMENT_SPEED_FACTOR: _apply_movement_speed_factor,
		BuffDebuffKey.SIZE_CHANGE_FACTOR: _apply_size_change_factor,
		BuffDebuffKey.CONTROL_TYPE: _apply_control_type,
		BuffDebuffKey.STABILITY_MAX: _apply_stability_max,
		BuffDebuffKey.STABILITY_TIME: _apply_stability_time,
		BuffDebuffKey.STABILITY_SPEED_FACTOR: _apply_stability_speed_factor,
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
func _apply_escaping_time_factor(value: float) -> void:
	pass

func _apply_black_holes_prob_factor(value: float) -> void:
	pass
	
func _apply_size_change_factor(value: float) -> void:
	target_size *= (1.0 + value)

func _apply_control_type(value: int) -> void:
	player_movement.set_control_type(PlayerMovement.MovementType.values()[value])

func _apply_extra_dashes(value: int) -> void:
	dash_component.dash_count += value

func _apply_dash_speed_factor(value: float) -> void:
	#dash_component.speed *= (1.0 + value)
	pass

func _apply_absortion_speed_factor(value: float) -> void:
	#stabilization_component.absortion_speed *= (1.0 + value)
	pass

func _apply_movement_speed_factor(value: float) -> void:
	#player_movement.speed *= (1.0 + value)
	pass

func _apply_stability_max(value: int) -> void:
	#stabilization_component.stability_max += value
	pass

func _apply_stability_time(value: float) -> void:
	stabilization_component.add_time(value)

func _apply_stability_speed_factor(value: float) -> void:
	#stabilization_component.stability_speed *= (1.0 + value)
	pass
#endregion
