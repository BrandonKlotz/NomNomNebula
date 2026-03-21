class_name GalaxyIdle
extends State

@export var galaxy: Galaxy 
@export var attraction_area: Area2D
@export var speed: float = 5

var direction: float = 0
var is_active: bool = true

func enter() -> void:
	attraction_area.area_entered.connect(start_attraction_state)
	EventManager.on_game_state_changed.connect(_on_state_changed)

func _on_state_changed(state: GameWorld.GameState) -> void:
	match state:
		GameWorld.GameState.ONGOING:
			is_active = true
		GameWorld.GameState.PAUSED:
			is_active = false
		GameWorld.GameState.FINISHED:
			is_active = false
			
func update(_delta: float) -> void:
	if not is_active:
		return
	
	add_random_velocity()

func start_attraction_state(_area: Area2D) -> void:
	if Globals.player.can_be_absorbed:
		change_state.emit("attract")

func add_random_velocity() -> void:
	var random_direction: float = randf_range(-PI, PI)
	direction += random_direction
	var vec_rotation: Vector2 = Utils.rotation_to_vector(direction)
	galaxy.apply_force(vec_rotation * speed)

func exit() -> void:
	attraction_area.area_entered.disconnect(start_attraction_state)
	EventManager.on_game_state_changed.disconnect(_on_state_changed)
