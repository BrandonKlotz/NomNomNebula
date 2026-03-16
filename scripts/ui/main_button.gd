class_name MainButton
extends Button

@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var arrow: TextureRect = $MarginContainer/HBoxContainer/Arrow

@export var custom_title: String

func _ready() -> void:
	label.text = custom_title
	arrow.visible = false
	
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	arrow.show()

func _on_mouse_exited() -> void:
	arrow.hide()
