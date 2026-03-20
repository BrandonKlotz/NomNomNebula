class_name GalaxyAttract
extends State

@export var galaxy: Galaxy
@export var attraction_area: Area2D

var was_inside_inner_radius: bool = false
var absorption_timer: float
var inner_radius: float = 50.0
var absorption_speed_factor: float = 2.0
var absorption_time_required: float = 3.0
var base_strength: float = 200.0

func enter() -> void:
	galaxy.audio_player.play(0)
	attraction_area.area_exited.connect(end_attraction_state)
	EventManager.on_attracting_player.emit()
	Globals.game_camera.set_target(galaxy)
	Globals.game_camera.target_zoom = Vector2(galaxy.size / 4, galaxy.size/4)
	absorption_timer = absorption_time_required * Globals.player.absorption_speed_factor

func update(delta: float) -> void:
	var offset = _get_offset_to_player()
	var is_inside: bool = offset.length() <= inner_radius
	var force: Vector2 = calc_force()
	
	Globals.player.apply_force(force*delta)

	if not is_inside:
		absorption_timer -= delta * absorption_speed_factor
	else:
		absorption_timer = absorption_time_required * Globals.player.absorption_speed_factor
	
	was_inside_inner_radius = is_inside
		
	if absorption_timer < 0:
		change_state.emit("desintegrate")
	
func calc_force() -> Vector2:
	var offset: Vector2 = _get_offset_to_player()
	var dir: Vector2 = offset.normalized()
	var outer_force: float = base_strength
	
	return dir * outer_force
	
func _get_offset_to_player() -> Vector2:
	return galaxy.global_position - Globals.player.global_position

func end_attraction_state(_area: Area2D) -> void:
	change_state.emit("idle")
	
func exit() -> void:
	Globals.game_camera.set_target(Globals.player.camera_target)
	attraction_area.area_exited.disconnect(end_attraction_state)
	absorption_timer = absorption_time_required
	galaxy.audio_player.stop()
