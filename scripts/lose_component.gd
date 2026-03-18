extends Node

var timer: float = 0
var active: bool = false

func _ready() -> void:
	EventManager.on_player_destabilized.connect(on_start_game_over)

func on_start_game_over():
	self.visible = true
	active = true
	Globals.player.can_control = false
	Globals.game_camera.target = Globals.player
	Globals.game_camera.hard_zoom = true
	Globals.game_camera.target_zoom *= 2
	Engine.time_scale = 0.8
	
func _process(delta: float) -> void:
	if active:
		timer = minf(timer + delta * 0.8, 1.2)
		self.material.set_shader_parameter("intensity", timer)
