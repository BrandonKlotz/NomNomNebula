class_name BlackHoleIdle
extends State

@export var attraction_area: Area2D

var start_value : float
var current_value : float 
var direction: float = 0

func enter() -> void:
	current_value = start_value
	attraction_area.area_entered.connect(start_attraction_state)
	
func update(delta: float) -> void:
	current_value -= (current_value-0.13)*delta
	
func start_attraction_state(_area: Area2D) -> void:
	if Globals.player.can_be_absorbed:
		change_state.emit("attract")
	
func exit() -> void:
	attraction_area.area_entered.disconnect(start_attraction_state)
