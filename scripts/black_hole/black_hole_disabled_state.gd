class_name BlackHoleDisabled
extends State

@export var sprite : Sprite2D
var start_value : float
var current_value : float 

func enter() -> void:
	start_value = sprite.material.get_shader_parameter("holeSize")
	current_value = start_value
	AudioManager.play_sfx(AudioManager.tracks.galaxy_desintegrated, 0.6)

func update(delta: float) -> void:
	current_value -= (current_value-0)*10*delta
	sprite.material.set_shader_parameter('holeSize', current_value)
