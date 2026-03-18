class_name StabilizationComponent
extends Node

@export var max_time: float = 30.0
@export var warning_time: float = 10.0
@export var drain_rate: float = 1.0
@export var base_absorption_speed: float = 1.0

var _base_max_time: float
var _base_drain_rate: float
var _base_absorption_speed: float

var effective_max_time: float
var effective_drain_rate: float
var effective_absorption_speed: float

var current_time: float
var warning_triggered: bool = false

func _ready() -> void:
	_base_max_time = max_time
	_base_drain_rate = drain_rate
	_base_absorption_speed = base_absorption_speed
	_reset_effective()
	current_time = effective_max_time
	EventManager.on_stabilization_changed.emit(_get_data())

func _process(delta: float) -> void:
	if current_time <= 0:
		return
	
	current_time -= delta * effective_drain_rate
	current_time = max(current_time, 0.0)
	
	EventManager.on_stabilization_changed.emit(_get_data())
	
	if current_time <= warning_time and not warning_triggered:
		warning_triggered = true
		EventManager.on_stabilization_warning.emit()
	
	if current_time <= 0:
		_trigger_death()

func add_time(amount: float) -> void:
	current_time += amount
	current_time = min(current_time, effective_max_time)
	
	if current_time > warning_time:
		warning_triggered = false
		EventManager.on_stabilization_warning_end.emit()
	
	EventManager.on_stabilization_changed.emit(_get_data())

func reset_buffs() -> void:
	_reset_effective()
	# clamp current_time in case max was reduced
	current_time = min(current_time, effective_max_time)
	EventManager.on_stabilization_changed.emit(_get_data())

func apply_stability_time(amount: float) -> void:
	add_time(amount)

func apply_stability_max_delta(value: int) -> void:
	effective_max_time = _base_max_time + value
	current_time = min(current_time, effective_max_time)
	EventManager.on_stabilization_changed.emit(_get_data())

func apply_drain_rate_factor(value: float) -> void:
	effective_drain_rate = _base_drain_rate * (1.0 + value)

func apply_absorption_speed_factor(value: float) -> void:
	effective_absorption_speed = _base_absorption_speed * (1.0 + value)

func _reset_effective() -> void:
	effective_max_time = _base_max_time
	effective_drain_rate = _base_drain_rate
	effective_absorption_speed = _base_absorption_speed

func _trigger_death() -> void:
	EventManager.on_player_destabilized.emit()

func _get_data() -> Dictionary:
	return {
		"progress": current_time / effective_max_time,
		"current_time": current_time,
		"max_time": effective_max_time
	}
