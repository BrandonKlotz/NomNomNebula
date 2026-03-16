class_name StabilizationScreenFX
extends Node

@onready var rect: ColorRect = $ColorRect

var mat: ShaderMaterial

func _ready() -> void:
	mat = rect.material
	
	EventManager.on_stabilization_warning.connect(_on_stabilization_warning)
	EventManager.on_stabilization_warning_end.connect(_on_warning_end)

func _on_stabilization_warning() -> void:
	mat.set_shader_parameter("intensity", 0.05)

func _on_warning_end() -> void:
	mat.set_shader_parameter("intensity", 0.0)
