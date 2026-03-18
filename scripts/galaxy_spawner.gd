class_name GalaxySpawner
extends Node

const GALAXY: PackedScene = preload("uid://ge3n0d66rcq8")

const galaxies_variants_data = [
	preload("uid://baxkohgisu4jk"),
	preload("uid://bt1bbrc3g1atx"),
	preload("uid://g38kwgaypusv"),
	preload("uid://53lwckvnjlyy"),
	preload("uid://d3pqhf4o3i6n4")
]

var galaxies: Array = []
var elapsed_time: float = 0.0
var spawn_timer: float = 0.0
var base_spawn_interval: float = 2.0
var max_galaxies: int = 6
var spawn_radius: float = 600.0
var min_distance_between: float = 150.0
var initial_galaxies: int = 10

func _ready() -> void:
	_spawn_initial_galaxies(initial_galaxies)

func _process(delta: float) -> void:
	elapsed_time += delta
	spawn_timer += delta
	
	if spawn_timer >= _get_spawn_interval():
		spawn_timer = 0.0
		
		if galaxies.size() < max_galaxies:
			_spawn_galaxy()

func _spawn_initial_galaxies(amount: int):
	for i in range(amount):
		_spawn_galaxy()
	
	EventManager.on_galaxies_updated.emit({"galaxies": galaxies})

func _spawn_galaxy():
	var pos: Vector2 = _get_valid_position()
	if pos == Vector2.ZERO:
		return
	
	var galaxy: Galaxy = GALAXY.instantiate()
	galaxy.position = pos
	galaxy.data = galaxies_variants_data.pick_random()
	
	if _is_bad_galaxy():
		galaxy.set_bad()
	else:
		galaxy.set_good()
	
	# Black hole
	#if randf() < _get_black_hole_chance():
		#if galaxy.has_method("spawn_black_hole"):
			#galaxy.spawn_black_hole()
	
	add_child(galaxy)
	galaxies.append(galaxy)

func _get_valid_position() -> Vector2:
	var tries: int = 20
	
	while tries > 0:
		var angle: float = Globals.rng.randf() * TAU
		var distance: float = Globals.rng.randf_range(200, spawn_radius)
		var pos: Vector2 = Vector2(cos(angle), sin(angle)) * distance
		var valid: bool = true
		
		for g in galaxies:
			if g.position.distance_to(pos) < min_distance_between:
				valid = false
				break
		
		if valid:
			return pos
		
		tries -= 1
	
	return Vector2.ZERO

#region Probabilities
func _get_bad_probability() -> float:
	# gets more difficult over time
	return clamp(0.2 + elapsed_time * 0.02, 0.2, 0.8)

func _get_black_hole_chance() -> float:
	return clamp(0.05 + elapsed_time * 0.01, 0.05, 0.5)

func _is_bad_galaxy() -> bool:
	return Globals.rng.randf() < _get_bad_probability()

func _get_spawn_interval() -> float:
	# faster everytime
	return clamp(base_spawn_interval - elapsed_time * 0.02, 0.6, base_spawn_interval)
#endregion

func remove_galaxy(data: GalaxyData) -> void:
	for i in range(galaxies.size()):
		var g: Galaxy = galaxies[i]
		
		if g.uid() == data.uid:
			g.queue_free()
			galaxies.remove_at(i)
			break
	
	EventManager.on_galaxies_updated.emit({"galaxies": galaxies})

func get_visible_galaxies() -> Array:
	return galaxies
