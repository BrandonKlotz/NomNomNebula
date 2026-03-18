class_name GalaxyInfoPanel
extends Node

@onready var data_label: Label = $DataLabel

func _ready() -> void:
	self.visible = false

func present(data: GalaxyData) -> void:
	self.visible = true
	data_label.text = "\n".join([
		data.uid,
		data.buff_debuff
	])

func dismiss() -> void:
	self.visible = false
