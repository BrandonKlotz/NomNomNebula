class_name BlackHoleIdle
extends State

@export var sprite : Sprite2D
@export var attraction_area: Area2D
@export var timer_label : Label

var start_value : float
var current_value : float 
var direction: float = 0


func enter() -> void:
	start_value = sprite.material.get_shader_parameter("holeSize")
	current_value = start_value
	timer_label.visible = false
	attraction_area.area_entered.connect(start_attraction_state)
	
func update(delta: float) -> void:
	current_value -= (current_value-0.13)*delta
	sprite.material.set_shader_parameter('holeSize', current_value)
	
func start_attraction_state(_area: Area2D) -> void:
	if Globals.player.can_be_absorbed:
		change_state.emit("attract")
	
func exit() -> void:
	attraction_area.area_entered.disconnect(start_attraction_state)
