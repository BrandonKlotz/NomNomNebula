class_name StabilizationPanel
extends Node

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label: Label = $Label

var default_color: Color
var warning_color: Color = Color.RED

func _ready() -> void:
	default_color = progress_bar.modulate
	
	EventManager.on_stabilization_changed.connect(_on_stabilization_changed)
	EventManager.on_stabilization_warning.connect(_on_stabilization_warning)
	EventManager.on_stabilization_warning_end.connect(_on_warning_end)

func _on_stabilization_changed(data: Dictionary) -> void:
	progress_bar.value = data["progress"] * 100
	label.text = str(int(round(data["current_time"]))) + " / " + str(int(round(data["max_time"])))

func _on_stabilization_warning() -> void:
	progress_bar.modulate = warning_color
	label.modulate = warning_color

func _on_warning_end() -> void:
	progress_bar.modulate = default_color
	label.modulate = default_color
