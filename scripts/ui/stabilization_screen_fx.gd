class_name StabilizationScreenFX
extends Node

func _ready() -> void:
	EventManager.on_stabilization_warning.connect(_on_stabilization_warning)
	EventManager.on_stabilization_warning_end.connect(_on_warning_end)

func _on_stabilization_warning() -> void:
	self.visible = true
	self.material.set_shader_parameter("intensity", 0.05)

func _on_warning_end() -> void:
	self.visible = false
	self.material.set_shader_parameter("intensity", 0.0)
