extends ColorRect

@export var shock_wave_speed: float = 1.5
@export var shock_wave_center: Vector2 = Vector2(0.5, 0.5)
@export var shock_wave_force: float = 0.5

var target: Node
var shock_wave_size: float = 5.0

func _ready() -> void:
	EventManager.on_shock_wave.connect(start_shock_wave)

func start_shock_wave(node) -> void:
	shock_wave_size = -0.1
	target = node

func _process(delta: float) -> void:
	if not Globals.game_camera:
		return
		
	if shock_wave_size < 5:
		var target_screen_coords: Vector2 = get_viewport().get_canvas_transform() * target.global_position
		var screen_size: Vector2 = get_viewport().get_visible_rect().size / Globals.game_camera.zoom
		shock_wave_size += shock_wave_speed * shock_wave_speed * delta
		self.material.set_shader_parameter("size", shock_wave_size)
		self.material.set_shader_parameter("center", target_screen_coords / Globals.game_camera.zoom/screen_size)
		
