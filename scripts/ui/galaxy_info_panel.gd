class_name GalaxyInfoPanel
extends Node

@onready var data_label: Label = $DataLabel

func _ready() -> void:
	self.visible = false

func present(data: GalaxyData) -> void:
	self.visible = true
	
	var lines: Array[String] = ["uid: " + data.uid]
	for key in data.buff_debuff:
		var line: String = key + " : " + str(data.buff_debuff[key])
		lines.append(line)
		
	data_label.text = "\n".join(lines)

func dismiss() -> void:
	self.visible = false
