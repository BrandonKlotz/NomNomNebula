class_name MinimapMarkers
extends Node2D

const MINIMAP_MARKER: Texture2D = preload("uid://6yo25fpoqpne")

@export var world_scale: float = 0.1

var galaxies: Array = []
var galaxy_markers: Dictionary = {}

func _ready() -> void:
	EventManager.on_galaxies_updated.connect(_on_galaxies_updated)

func _on_galaxies_updated(data: Dictionary) -> void:
	return
	self.galaxies = data["galaxies"]
	_sync_markers()

func _sync_markers() -> void:
	for g: Galaxy in galaxies:
		if not is_instance_valid(g):
			continue
		var id: String = g.uid()
		if not galaxy_markers.has(id):
			var marker: Sprite2D = _make_marker()
			galaxy_markers[id] = marker

	# remove outdated markers
	var current_ids: Array = galaxies\
		.filter(func(g: Galaxy): return is_instance_valid(g))\
		.map(func(g: Galaxy): return g.uid())
	
	print(current_ids)
	print(galaxy_markers.keys())
	
	for id in galaxy_markers.keys():
		if id not in current_ids:
			galaxy_markers[id].queue_free()
			galaxy_markers.erase(id)

func _make_marker() -> Sprite2D:
	var marker: Sprite2D = Sprite2D.new()
	marker.texture = MINIMAP_MARKER
	marker.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	marker.centered = true
	add_child(marker)
	return marker
	
func set_galaxies(new_galaxies: Array) -> void:
	galaxies = new_galaxies
	Utils.clear_node(self)
	galaxy_markers.clear()

	for galaxy: Galaxy in galaxies:
		var id: String = galaxy.uid()

		if not galaxy_markers.has(id):
			var marker: Sprite2D = Sprite2D.new()
			marker.texture = MINIMAP_MARKER
			marker.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			marker.centered = true

			add_child(marker)
			galaxy_markers[id] = marker

func _process(_delta: float) -> void:
	_update_marker_positions(galaxy_markers)
	
func _update_marker_positions(markers: Dictionary) -> void:
	for id in markers.keys():
		var marker: Sprite2D = markers[id]
		if not is_instance_valid(marker):
			markers.erase(id)
			#
	#if galaxies.is_empty():
		#return
#
	##for galaxy in galaxies:
		#var id: String = galaxy.uid()
#
		#if not galaxy_markers.has(id):
			#continue
#
		#var marker: Sprite2D = galaxy_markers[id]
		#marker.position = galaxy.position * world_scale
