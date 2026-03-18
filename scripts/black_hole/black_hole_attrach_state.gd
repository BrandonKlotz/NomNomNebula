class_name BlackHoleAttrach
extends State

@export var attraction_area: Area2D
@export var black_hole: BlackHole
@export var sprite : Sprite2D

@onready var max_time : float = black_hole.data.event_start_time
@onready var camera: Camera2D = get_tree().get_first_node_in_group("main_camera")
@onready var player: Player = get_tree().get_first_node_in_group("player")

var strenght: float
var timer: float
var last_dash_used_time : float
var strong_attrach_start_time : float
var elapsed_time : float

func enter() -> void:
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
		strong_attrach_start_time = Time.get_ticks_msec()/1000.0
		strenght = 15.0
		
	var force : Vector2 = calc_force()
	Globals.player.apply_force(force)
	sprite.material.set_shader_parameter("holeSize", 0.1+0.4*elapsed_time/max_time)
	
	black_hole.timer_label.text = "%.2f" % timer

func on_exited_area(_area:Area2D) -> void:
	change_state.emit(self, "blackholeidle")
	
func exit() -> void:
	attraction_area.area_exited.disconnect(on_exited_area)
	EventManager.on_dash_used.disconnect(on_player_dash_used)
	
	Globals.game_camera.set_target(Globals.player)
	
func calc_force() -> Vector2:
	var offset: Vector2 = get_offset_to_player()
	var dir: Vector2 = offset.normalized()
	var distance = maxf(offset.length(), 5.0)
	return dir * strenght/(distance*0.01)
	
func get_offset_to_player() -> Vector2:
	return black_hole.global_position - Globals.player.global_position
	
func on_player_dash_used():
	last_dash_used_time = Time.get_ticks_msec()/1000.0
	if timer < 0.5 or abs(last_dash_used_time - strong_attrach_start_time) < 0.5:
		change_state.emit(self, "blackholedisabled")
		sprite.material.set_shader_parameter("holeSize", 0.0)
