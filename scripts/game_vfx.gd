extends Node

@onready var shock_wave: ColorRect = $ShockWave
@onready var stabilization: StabilizationScreenFX = $Stabilization
@onready var color_aberration: ColorRect = $ColorAberration
@onready var black_hole_expand: AnimatedAtlas = $BlackHoleExpand

func _ready() -> void:
	self.visible = true
	
	stabilization.visible = false
	color_aberration.visible = false
	black_hole_expand.visible = false
	
	EventManager.on_shock_wave.connect(func(node: Node) -> void:
		shock_wave.visible = true
		shock_wave.on_shock_wave(node)
	)
	
	EventManager.on_black_hole_expanded.connect(func() -> void:
		black_hole_expand.visible = true
		black_hole_expand.play_animation()
	)
