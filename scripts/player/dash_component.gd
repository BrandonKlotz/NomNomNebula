class_name DashComponent
extends Node

var max_dashes: int = 2
var recharge_time_per_use: float = 1.0
var dash_count: int
var recharging: bool = false
var recharge_elapsed: float = 0.0
var recharge_time: float
var dash_delay: float = 1.0
var dash_delay_timer: float = 0.0

func _ready() -> void:
	dash_count = max_dashes
	recharge_time = max_dashes * recharge_time_per_use

func can_dash() -> bool:
	return dash_count > 0 and not recharging and dash_delay_timer <= 0

func use_dash() -> void:
	if not can_dash():
		return

	dash_count -= 1
	dash_delay_timer = dash_delay
	
	EventManager.on_dash_used.emit()
	AudioManager.play_sfx(AudioManager.tracks.dash)

	if dash_count == 0:
		_start_recharge()

func dash_error() -> void:
	AudioManager.play_sfx(AudioManager.tracks.dash_error)

func _start_recharge() -> void:
	if recharging:
		return

	recharging = true
	recharge_elapsed = 0.0
	EventManager.on_dash_recover_progress.emit(0.0)
	AudioManager.play_sfx(AudioManager.tracks.dash_empty)

func _process(delta: float) -> void:
	if dash_delay_timer > 0:
		dash_delay_timer -= delta

	if not recharging:
		return

	recharge_elapsed += delta
	var progress: float = recharge_elapsed / recharge_time
	EventManager.on_dash_recover_progress.emit(clamp(progress, 0.0, 1.0))

	if recharge_elapsed >= recharge_time:
		recharge_elapsed = 0.0
		dash_count += 1
		dash_count = max_dashes

		if dash_count >= max_dashes:
			recharging = false
			EventManager.on_dash_fully_recovered.emit()
			AudioManager.play_sfx(AudioManager.tracks.dash_recovered)
