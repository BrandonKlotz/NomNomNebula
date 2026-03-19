class_name BlackHoleAttract
extends State

@export var attraction_area: Area2D
@export var black_hole: BlackHole
@export var sprite: Sprite2D

@onready var max_time: float

var strenght: float
var timer: float
var last_dash_used_time: float
var strong_attract_start_time: float
var elapsed_time: float

func enter() -> void:
	max_time = black_hole.data.event_start_time * Globals.player.escaping_timer_factor
	strenght = black_hole.data.strength
	timer = max_time
	elapsed_time = 0
	
	attraction_area.area_exited.connect(on_exited_area)
	EventManager.on_dash_used.connect(on_player_dash_used)
	EventManager.on_attracting_player.emit()
	
	Globals.game_camera.target_zoom = Vector2(0.4, 0.4)
	Globals.game_camera.set_target(black_hole)

func update(delta: float) -> void:
	if timer >= 0:
		timer -= delta
		elapsed_time += delta
	
	if timer <= 0:
		strong_attract_start_time = Time.get_ticks_msec() / 1000.0
		strenght = 600.0
		
	var force: Vector2 = calc_force()
	Globals.player.apply_force(force*delta)
	sprite.material.set_shader_parameter("holeSize", 0.1 + 0.4 * elapsed_time / max_time)

func on_exited_area(_area:Area2D) -> void:
	change_state.emit("idle")
	
func exit() -> void:
	attraction_area.area_exited.disconnect(on_exited_area)
	EventManager.on_dash_used.disconnect(on_player_dash_used)
	Globals.game_camera.target_zoom = Vector2.ONE * (Globals.player.target_size+0.5)
	Globals.game_camera.set_target(Globals.player.camera_target)
	
func calc_force() -> Vector2:
	var offset: Vector2 = get_offset_to_player()
	var dir: Vector2 = offset.normalized()
	var distance = maxf(offset.length(), 5.0)
	return dir * strenght / (distance * 0.01)
	
func get_offset_to_player() -> Vector2:
	return black_hole.global_position - Globals.player.global_position
	
func on_player_dash_used():
	last_dash_used_time = Time.get_ticks_msec() / 1000.0
	if timer < 0.5 or abs(last_dash_used_time - strong_attract_start_time) < 0.5:
		change_state.emit("disabled")
		Globals.player.apply_force((Globals.player.global_position - black_hole.global_position).normalized() * 200)
		EventManager.on_shock_wave.emit(black_hole)
