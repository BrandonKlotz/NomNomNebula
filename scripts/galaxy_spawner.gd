class_name GalaxySpawner
extends Node

const GALAXY: PackedScene = preload("uid://ge3n0d66rcq8")
const BLACK_HOLE: PackedScene = preload("uid://bliqp60aweli1")

const galaxies_variants_data = [
	preload("uid://baxkohgisu4jk"),
	preload("uid://bt1bbrc3g1atx"),
	preload("uid://g38kwgaypusv"),
	preload("uid://53lwckvnjlyy"),
	preload("uid://d3pqhf4o3i6n4")
]

var galaxies: Array = []
var black_holes: Array = []

var elapsed_time: float = 0.0
var spawn_timer: float = 0.0
var base_spawn_interval: float = 2.0
var max_galaxies: int = 6
var max_black_holes: int = 2
var spawn_radius: float = 600.0
var min_spawn_radius: float = 200.0
var min_distance_between: float = 150.0
var initial_galaxies: int = 3

func _ready() -> void:
	for i in range(initial_galaxies):
		_spawn_galaxy()
	
	EventManager.on_galaxies_updated.emit({"galaxies": galaxies})

func _process(delta: float) -> void:
	return
	elapsed_time += delta
	spawn_timer += delta

	if spawn_timer >= _get_spawn_interval():
		spawn_timer = 0.0
		_try_spawn()

func _try_spawn() -> void:
	# roll black hole first
	if black_holes.size() < max_black_holes and Globals.rng.randf() < _get_black_hole_chance():
		_spawn_black_hole()
	elif galaxies.size() < max_galaxies:
		_spawn_galaxy()

func _spawn_black_hole() -> void:
	var pos: Vector2 = _get_valid_position()
	if pos == Vector2.ZERO:
		return

	var black_hole: BlackHole = BLACK_HOLE.instantiate()
	black_hole.position = pos
	black_hole.data = BlackHoleData.new()

	add_child(black_hole)
	black_holes.append(black_hole)

func remove_black_hole(black_hole: BlackHole) -> void:
	var idx: int = black_holes.find(black_hole)
	if idx == -1:
		return
	black_hole.queue_free()
	black_holes.remove_at(idx)
	
	EventManager.on_galaxies_updated.emit({"galaxies": galaxies})

func _spawn_galaxy() -> void:
	var pos: Vector2 = _get_valid_position()
	if pos == Vector2.ZERO:
		return
	
	var galaxy: Galaxy = GALAXY.instantiate()
	galaxy.position = pos
	galaxy.data = galaxies_variants_data.pick_random()
	galaxy.data.uid = Utils.gen_uid("g")
	
	if _is_bad_galaxy():
		galaxy.set_bad()
	else:
		galaxy.set_good()
	
	add_child(galaxy)
	galaxies.append(galaxy)

func _get_valid_position() -> Vector2:
	var all_objects: Array = galaxies + black_holes
	var tries: int = 30

	while tries > 0:
		var angle: float = Globals.rng.randf() * TAU
		var t: float = Globals.rng.randf()
		var distance: float = sqrt(t) * (spawn_radius - min_spawn_radius) + min_spawn_radius
		var pos: Vector2 = Vector2(cos(angle), sin(angle)) * distance

		var valid: bool = true
		for obj in all_objects:
			if obj.position.distance_to(pos) < min_distance_between:
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
	return clamp(0.05 + elapsed_time * 0.01, 0.05, 0.4)

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
