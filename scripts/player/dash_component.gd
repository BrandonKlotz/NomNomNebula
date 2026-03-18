class_name DashComponent
extends Node

var base_dashes: int = 2
var effective_speed: float
var base_speed: float = 200.0
var effective_recharge: float = 0.0
var base_recharge: float = 3.0

var dash_count: int
var recharging: bool = false
var recharge_elapsed: float = 0.0
var dash_delay: float = 0.5
var dash_delay_timer: float = 0.0

var current_buff_dashes: int = 0

func _ready() -> void:
	effective_recharge = base_recharge
	effective_speed = base_speed
	dash_count = get_max_dashes()

func _process(delta: float) -> void:
	if dash_delay_timer > 0:
		dash_delay_timer -= delta
	
	if not recharging:
		return
	
	recharge_elapsed += delta
	var progress: float = recharge_elapsed / _get_recharge_time()
	EventManager.on_dash_recover_progress.emit(clamp(progress, 0.0, 1.0))
	
	if recharge_elapsed >= _get_recharge_time():
		recharge_elapsed = 0.0
		recharging = false
		current_buff_dashes = 0
		dash_count = get_max_dashes()
		_emit_change()
		AudioManager.play_sfx(AudioManager.tracks.dash_recovered)

func get_max_dashes() -> int:
	return base_dashes + current_buff_dashes

func can_dash() -> bool:
	return dash_count > 0 and not recharging and dash_delay_timer <= 0

func _emit_change() -> void:
	EventManager.on_dash_udpated.emit({"count": dash_count, "max": get_max_dashes()})

func consume_dash() -> void:
	if not can_dash():
		return
	
	dash_count -= 1
	dash_delay_timer = dash_delay
	
	_emit_change()
	AudioManager.play_sfx(AudioManager.tracks.dash)
	
	if dash_count == 0:
		_start_recharge()

func dash_error() -> void:
	AudioManager.play_sfx(AudioManager.tracks.dash_error)

func reset_buffs() -> void:
	effective_speed = base_speed
	current_buff_dashes = 0
	effective_recharge = base_recharge
	
	dash_count = get_max_dashes()
	_emit_change()

func apply_extra_dashes(value: int) -> void:
	current_buff_dashes = value
	dash_count = get_max_dashes()
	_emit_change()

func apply_force_factor(value: float) -> void:
	effective_speed = base_speed * (1.0 + value)

func apply_recharge_factor(value: float) -> void:
	effective_recharge = base_recharge * value

func _get_recharge_time() -> float:
	return effective_recharge

func _start_recharge() -> void:
	if recharging:
		return
	
	recharging = true
	recharge_elapsed = 0.0
	EventManager.on_dash_recover_progress.emit(0.0)
	AudioManager.play_sfx(AudioManager.tracks.dash_empty)
