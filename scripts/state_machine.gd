extends Node

var current_state : State
var states: Dictionary[String, State]= {}
@export var initial_state : State

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.change_state.connect(on_change_state)
	
	if initial_state:
		current_state = initial_state
		current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func on_change_state(state: State, new_state_name: String):
	current_state.exit()
	if not new_state_name in states:
		return
	
	var new_state: State = states.get(new_state_name.to_lower())
	current_state = new_state
	current_state.enter()
