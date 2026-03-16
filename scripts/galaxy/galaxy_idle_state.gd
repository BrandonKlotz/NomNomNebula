class_name GalaxyIdle
extends State

@export var galaxy :Galaxy 
@export var attraction_area :Area2D
@export var speed : float = 5

var direction :float = 0

func enter() -> void:
	attraction_area.area_entered.connect(start_attraction_state)
	
func update(_delta: float) -> void:
	add_random_velocity()

func start_attraction_state(_area: Area2D) -> void:
	change_state.emit(self, "attach")

func add_random_velocity() -> void:
	var random_direction: float = randf_range(-PI, PI)
	direction += random_direction
	var vec_rotation: Vector2 = Utils.rotation_to_vector(direction)
	galaxy.apply_force(vec_rotation * speed)

func exit() -> void:
	attraction_area.area_entered.disconnect(start_attraction_state)
