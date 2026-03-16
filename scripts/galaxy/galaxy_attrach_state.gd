class_name GalaxyAttrach
extends State

@export var galaxy: Galaxy
@export var attraction_area: Area2D
@onready var camera = get_tree().get_first_node_in_group("main_camera")

func enter() -> void:
	attraction_area.area_exited.connect(end_attraction_state)
	camera.set_target(galaxy)
	camera.target_zoom *= 0.5

func update(delta: float) -> void:
	var force: Vector2 = calc_force(delta)
	Globals.player.apply_force(force)
	
func calc_force(_delta: float) -> Vector2:
	var offset: Vector2 = galaxy.global_position - Globals.player.global_position
	var dist: float = offset.length()
	var dir: Vector2 = offset.normalized()

	var inner_radius: float = 20
	var outer_force: float = galaxy.data.strength

	if dist < inner_radius:
		var repel = (inner_radius - dist) / inner_radius
		return -dir * outer_force * (4 + repel * 8)
	else:
		return dir * outer_force
		
func end_attraction_state(_area: Area2D) -> void:
	change_state.emit(self, "idle")
	
func exit() -> void:
	camera.set_target(Globals.player)
	camera.target_zoom *= 2
	attraction_area.area_exited.disconnect(end_attraction_state)
