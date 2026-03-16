class_name GalaxyAttach
extends State

@export var galaxy: Galaxy
@export var attraction_area: Area2D
@export var absorption_time_required : float
@onready var target : Node2D = get_node("Target")
@onready var camera : Camera2D = get_tree().get_first_node_in_group("main_camera")
@onready var absorbing_timer : float = absorption_time_required
var inner_radius: float = 50

func enter() -> void:
	attraction_area.area_exited.connect(end_attraction_state)
	camera.set_target(target)
	camera.target_zoom *= 0.5

func update(delta: float) -> void:
	var force: Vector2 = calc_force(delta)
	Globals.player.apply_force(force)
	
	target.global_position = galaxy.global_position + get_offset_to_player()* -1.0 * 0.5
	
	if get_offset_to_player().length() > inner_radius:
		absorbing_timer -= delta
	else:
		absorbing_timer = absorption_time_required
		
	if absorbing_timer < 0:
		EventManager.on_galaxy_absorbed.emit(galaxy.data)
		change_state.emit(self, "desintegrate")
	
func calc_force(_delta: float) -> Vector2:
	var offset: Vector2 = get_offset_to_player()
	#var dist: float = offset.length()
	var dir: Vector2 = offset.normalized()

	var outer_force: float = galaxy.data.strength
		
	return dir * outer_force
	
func get_offset_to_player() -> Vector2:
	return galaxy.global_position - Globals.player.global_position

func end_attraction_state(_area: Area2D) -> void:
	change_state.emit(self, "idle")
	
func exit() -> void:
	camera.set_target(Globals.player)
	camera.target_zoom *= 2
	attraction_area.area_exited.disconnect(end_attraction_state)
