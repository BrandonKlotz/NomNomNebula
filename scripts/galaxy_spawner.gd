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

var galaxy_spawn_timer: float = 0.0
var black_hole_spawn_timer: float = 0.0

var base_galaxy_interval: float = 2.0
var base_black_hole_interval: float = 8.0  # black holes on their own slower clock

var max_galaxies: int = 10
var max_black_holes: int = 2

var spawn_radius: float = 600.0
var min_spawn_radius: float = 200.0
var min_distance_between: float = 180.0  # slightly increased for better visual breathing room

var initial_galaxies: int = 5
const WARM_UP_DURATION: float = 15.0  # seconds before difficulty ramps meaningfully

func _ready() -> void:
	for i in range(initial_galaxies):
		_spawn_galaxy()
	EventManager.on_galaxies_updated.emit(galaxies)

	# Stagger the black hole timer so it doesn't fire immediately
	black_hole_spawn_timer = -base_black_hole_interval * 0.5

func _process(delta: float) -> void:
	elapsed_time += delta
	galaxy_spawn_timer += delta
	black_hole_spawn_timer += delta

	if galaxy_spawn_timer >= _get_galaxy_interval():
		galaxy_spawn_timer = _spawn_jitter()  # reset with small random offset
		if galaxies.size() < max_galaxies:
			_spawn_galaxy()
			EventManager.on_galaxies_updated.emit(galaxies)

	if black_hole_spawn_timer >= _get_black_hole_interval():
		black_hole_spawn_timer = 0.0
		if black_holes.size() < max_black_holes and Globals.rng.randf() < _get_black_hole_chance():
			_spawn_black_hole()

func _spawn_black_hole() -> void:
	var pos: Vector2 = _get_valid_position()
	if pos == Vector2.ZERO:
		return
	var black_hole: BlackHole = BLACK_HOLE.instantiate()
	black_hole.position = pos
	black_hole.data = BlackHoleData.new()
	black_hole.data.uid = Utils.gen_uid("b")
	add_child(black_hole)
	black_holes.append(black_hole)

func remove_black_hole(data: BlackHoleData) -> void:
	var idx: int = black_holes.find_custom(func(b: BlackHole) -> bool: return b.uid == data.uid)
	if idx == -1:
		return
	black_holes.remove_at(idx)
	EventManager.on_galaxies_updated.emit(galaxies)

func _spawn_galaxy() -> void:
	var pos: Vector2 = _get_valid_position()
	if pos == Vector2.ZERO:
		return

	var galaxy: Galaxy = GALAXY.instantiate()
	galaxy.position = pos
	galaxy.data = galaxies_variants_data.pick_random().duplicate()
	galaxy.data.uid = Utils.gen_uid("g")

	if _is_bad_galaxy():
		galaxy.set_bad()
	else:
		galaxy.set_good()

	add_child(galaxy)
	galaxies.append(galaxy)

var _recent_sector_hits: Dictionary = {}
const SECTOR_COUNT: int = 8
const SECTOR_COOLDOWN: float = 6.0  # seconds before a sector can be reused

func _get_valid_position() -> Vector2:
	# Prune old sector hits
	for sector in _recent_sector_hits.keys():
		if elapsed_time - _recent_sector_hits[sector] > SECTOR_COOLDOWN:
			_recent_sector_hits.erase(sector)

	var all_objects: Array = galaxies + black_holes
	var tries: int = 40

	while tries > 0:
		var angle: float = Globals.rng.randf() * TAU
		var t: float = Globals.rng.randf()
		# sqrt distribution for uniform area coverage
		var distance: float = sqrt(t) * (spawn_radius - min_spawn_radius) + min_spawn_radius
		var pos: Vector2 = Vector2(cos(angle), sin(angle)) * distance

		# Check sector preference — try to avoid recently used sectors
		var sector: int = int((angle / TAU) * SECTOR_COUNT) % SECTOR_COUNT
		var sector_recently_used: bool = _recent_sector_hits.has(sector)

		var too_close: bool = false
		for obj in all_objects:
			if obj.position.distance_to(pos) < min_distance_between:
				too_close = true
				break

		# Accept if not too close; deprioritize recently used sectors
		# (only skip on recent sector if we have tries remaining to find better)
		if not too_close and (not sector_recently_used or tries <= 8):
			_recent_sector_hits[sector] = elapsed_time
			return pos

		tries -= 1

	return Vector2.ZERO

func _difficulty_t() -> float:
	# Normalized 0..1 over ~120 seconds, suppressed during warm-up
	var effective_time: float = max(0.0, elapsed_time - WARM_UP_DURATION)
	return clamp(effective_time / 120.0, 0.0, 1.0)

func _ease_in_out(t: float) -> float:
	# Smooth S-curve: slow start, fast middle, plateau at end
	return t * t * (3.0 - 2.0 * t)

func _get_bad_probability() -> float:
	var t: float = _ease_in_out(_difficulty_t())
	# Guarantee at least one good galaxy in the current pool
	var good_count: int = galaxies.filter(func(g): return not g.is_bad() if g.has_method("is_bad") else true).size()
	if good_count == 0 and galaxies.size() > 0:
		return 0.0  # force a good galaxy next
	var base: float = lerp(0.15, 0.75, t)
	# Add small noise so rolls don't feel mechanical
	var noise: float = Globals.rng.randf_range(-0.05, 0.05)
	return clamp(base + noise, 0.0, 1.0)

func _get_black_hole_chance() -> float:
	var t: float = _ease_in_out(_difficulty_t())
	var base: float = lerp(0.1, 0.55, t)
	var noise: float = Globals.rng.randf_range(-0.05, 0.05)
	return clamp(base + noise, 0.0, 1.0)

func _is_bad_galaxy() -> bool:
	return Globals.rng.randf() < _get_bad_probability()

func _get_galaxy_interval() -> float:
	var t: float = _ease_in_out(_difficulty_t())
	var base: float = lerp(base_galaxy_interval, 0.7, t)
	# Sine wave adds ~±20% breathing variation
	var wave: float = sin(elapsed_time * 0.4) * 0.2 * base
	return clamp(base + wave, 0.5, base_galaxy_interval)

func _get_black_hole_interval() -> float:
	var t: float = _ease_in_out(_difficulty_t())
	# Black holes slow down slightly as difficulty rises (they become rarer but scarier)
	return lerp(base_black_hole_interval, 5.0, t)

func _spawn_jitter() -> float:
	# Small random offset so galaxy spawns don't feel metronomic
	return Globals.rng.randf_range(-0.3, 0.1)

#region Public
func remove_galaxy(data: GalaxyData) -> void:
	for i in range(galaxies.size()):
		var g: Galaxy = galaxies[i]
		if g.uid() == data.uid:
			g.queue_free()
			galaxies.remove_at(i)
			break
	EventManager.on_galaxies_updated.emit(galaxies)

func get_visible_galaxies() -> Array:
	return galaxies
#endregion
