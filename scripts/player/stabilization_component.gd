class_name StabilizationComponent
extends Node

var max_time: float = 60.0
var warning_time: float = 12.0
var base_drain_rate: float = 1.0

var current_time: float
var warning_triggered: bool = false
var drain_multiplier: float = 1.0

func _ready() -> void:
	current_time = max_time
	_emit_change()

func _process(delta: float) -> void:
	if current_time <= 0:
		return
	
	var effective_drain: float = base_drain_rate * drain_multiplier
	
	current_time -= delta * effective_drain
	current_time = max(current_time, 0.0)
	
	_emit_change()
	
	if current_time <= warning_time and not warning_triggered:
		warning_triggered = true
		EventManager.on_stabilization_warning.emit()
	
	if current_time <= 0:
		_trigger_death()

func add_time(amount: float) -> void:
	current_time = clamp(current_time + amount, 0.0, max_time)
	
	if current_time > warning_time and warning_triggered:
		warning_triggered = false
		EventManager.on_stabilization_warning_end.emit()
	
	_emit_change()

func modify_max_time(delta: float) -> void:
	max_time += delta
	current_time = min(current_time, max_time)
	_emit_change()
	EventManager.on_stabilization_max_changed.emit()

func apply_drain_factor(factor: float) -> void:
	drain_multiplier *= (1.0 + factor)

func reset_buffs() -> void:
	drain_multiplier = 1.0

func _trigger_death() -> void:
	EventManager.on_player_destabilized.emit()

func _emit_change() -> void:
	EventManager.on_stabilization_changed.emit({
		"progress": current_time / max_time,
		"current_time": current_time,
		"max_time": max_time
	})
