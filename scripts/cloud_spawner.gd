class_name CloudSpawner
extends Node2D

const CLOUD: PackedScene = preload("uid://ruadlq2l3he5")

var max_clouds: int = 300
var spawn_range: float = 960.0
var pool: Array = []
var active_clouds: Array = []
var spawn_timer: Timer
var _grid_positions: Array = []
var _grid_index: int = 0

func _ready():
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	
	for i in max_clouds:
		var cloud = CLOUD.instantiate()
		add_child(cloud)
		cloud.visible = false
		cloud.on_done.connect(_return_to_pool.bind(cloud))
		pool.append(cloud)
	
	spawn_timer.wait_time = 0.05
	spawn_timer.timeout.connect(spawn_cloud)
	spawn_timer.start()
	
	_build_grid()

func spawn_cloud():
	if pool.is_empty():
		return
	
	var cloud: Cloud = pool.pop_back()
	active_clouds.append(cloud)
	cloud.visible = true
	
	var base = _grid_positions[_grid_index % _grid_positions.size()]
	_grid_index += 1
	var jitter = Vector2(randf_range(-80, 80), randf_range(-80, 80))
	
	cloud.setup(base + jitter, spawn_range)

func _return_to_pool(cloud: Cloud) -> void:
	cloud.visible = false
	active_clouds.erase(cloud)
	pool.append(cloud)

func _build_grid() -> void:
	var cols = 5
	var rows = 5
	var cell_w = (spawn_range * 2) / cols
	var cell_h = (spawn_range * 2) / rows
	
	for row in rows:
		for col in cols:
			var x = -spawn_range + col * cell_w + cell_w * 0.5
			var y = -spawn_range + row * cell_h + cell_h * 0.5
			_grid_positions.append(Vector2(x, y))
	
	_grid_positions.shuffle()
