class_name PauseMenu
extends Node

signal on_resume

@onready var resume_button: Button = $ResumeButton

func _ready() -> void:
	resume_button.pressed.connect(func() -> void: on_resume.emit())
	dismiss()

func show() -> void:
	self.visible = true

func dismiss() -> void:
	self.visible = false
