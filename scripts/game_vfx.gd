extends Node

@onready var shock_wave: ColorRect = $ShockWave
@onready var stabilization: StabilizationScreenFX = $Stabilization
@onready var color_aberration: ColorRect = $ColorAberration

func _ready() -> void:
	self.visible = true
	
	stabilization.visible = false
	color_aberration.visible = false
