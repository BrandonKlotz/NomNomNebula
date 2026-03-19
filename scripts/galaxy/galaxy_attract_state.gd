class_name GalaxyAttract
extends State

@export var galaxy: Galaxy
@export var attraction_area: Area2D
@onready var target: Node2D = get_node("Target")

var was_inside_inner_radius: bool = false
var absorbing_timer: float
var inner_radius: float = 50.0
var absorbing_speed: float = 1.0
var absorption_time_required: float = 3.0
var base_strength: float = 2.0

func enter() -> void:
	galaxy.charge_player.play(0)
	attraction_area.area_exited.connect(end_attraction_state)
	EventManager.on_attracting_player.emit()
	
	Globals.game_camera.set_target(target)
	Globals.game_camera.target_zoom = Vector2(galaxy.size/4, galaxy.size/4)
	
	absorbing_timer = absorption_time_required

func update(delta: float) -> void:
	var offset = _get_offset_to_player()
	var is_inside: bool = offset.length() <= inner_radius
	var force: Vector2 = calc_force(delta)
	
	Globals.player.apply_force(force)
	target.global_position = galaxy.global_position + _get_offset_to_player() * -1.0 * 0.5

	if not is_inside:
		absorbing_timer -= delta * absorbing_speed*(Globals.player.absorption_speed_factor*Globals.player.target_size)
	else:
		absorbing_timer = absorption_time_required
	
	was_inside_inner_radius = is_inside
		
	if absorbing_timer < 0:
		change_state.emit("desintegrate")
	
	galaxy.timer_label.text = "%.2f" % absorbing_timer
	
func calc_force(_delta: float) -> Vector2:
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
	Globals.game_camera.target_zoom = Vector2.ONE
	attraction_area.area_exited.disconnect(end_attraction_state)
	absorbing_timer = absorption_time_required
	galaxy.charge_player.stop()
	galaxy.timer_label.text = str(absorption_time_required)
