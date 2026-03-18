class_name MinimapMarkers
extends Node2D

const MINIMAP_MARKER: Texture2D = preload("uid://6yo25fpoqpne")

@export var world_scale: float = 0.1

var galaxies: Array = []
var galaxy_markers: Dictionary = {}

func _ready() -> void:
	EventManager.on_galaxies_updated.connect(_on_galaxies_updated)

func _on_galaxies_updated(data: Dictionary) -> void:
	var new_galaxies: Array = data["galaxies"]
	set_galaxies(new_galaxies)
	
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
	if galaxies.is_empty():
		return

	#for galaxy in galaxies:
		#var id: String = galaxy.uid()
#
		#if not galaxy_markers.has(id):
			#continue
#
		#var marker: Sprite2D = galaxy_markers[id]
		#marker.position = galaxy.position * world_scale
