class_name GalaxyAttrach
extends State

@export var galaxy : Galaxy
@export var attraction_area :Area2D
@onready var camera = get_tree().get_first_node_in_group("main_camera")

func enter() -> void:
	attraction_area.area_exited.connect(end_attraction_state)
	camera.set_target(galaxy)
	camera.target_zoom *= 0.5

func update(delta:float) -> void:
	var force : Vector2 = calc_force(delta)
	Globals.player.apply_force(force)
	
func calc_force(delta:float) -> Vector2:
	var dif : Vector2 =  (galaxy.global_position -Globals.player.global_position).normalized()
	return dif * galaxy.data.strength / dif.length()

func end_attraction_state(area:Area2D) -> void:
	if not area.is_in_group("player_hb"): return
	change_state.emit(self, "galaxyidle")
	
func exit() -> void:
	camera.set_target(Globals.player)
	camera.target_zoom *= 2
	
