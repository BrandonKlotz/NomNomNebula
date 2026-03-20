class_name BlackHoleTow
extends State

@export var black_hole: BlackHole

var escaped: bool = false
var duration: float = 0.5
var timer: float = 0.0
var pull_strength: float = 800.0

func enter() -> void:
	escaped = false
	timer = 0.0
	
	Engine.time_scale = 0.3
	
	Globals.game_camera.target = black_hole
	Globals.game_camera.target_zoom = Vector2(0.4, 0.4)
	
	Globals.player.can_move = true
	Globals.player.can_control = true
	
	EventManager.on_dash_used.connect(_on_dash_used)

func update(delta: float) -> void:
	timer += delta
	
	var dir = (black_hole.global_position - Globals.player.global_position).normalized()
	Globals.player.apply_force(dir * pull_strength * delta)
	
	if timer >= duration and not escaped:
		black_hole.game_over()
		Engine.time_scale = 1.0
		change_state.emit("desintegrate")

func _on_dash_used():
	if not escaped:
		escaped = true
		_escape()
	
func _escape():
	Engine.time_scale = 1.0
	var dir = (Globals.player.global_position - black_hole.global_position).normalized()
	Globals.player.apply_force(dir * 700)
	EventManager.on_shock_wave.emit(black_hole)
	AudioManager.play_sfx(AudioManager.tracks.galaxy_desintegrated, 0.6)
	Globals.game_camera.set_target(Globals.player)

func on_exited_area(_area: Area2D) -> void:
	change_state.emit("idle")
	
func exit() -> void:
	pass
