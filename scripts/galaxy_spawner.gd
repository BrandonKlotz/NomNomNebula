class_name GalaxySpawner
extends Node

@onready var galaxy: Galaxy = $Galaxy
@onready var galaxy_2: Galaxy = $Galaxy2

var galaxies: Array = []

func _ready() -> void:
	galaxies = [galaxy, galaxy_2]

func get_visible_galaxies() -> Array:
	return galaxies

func remove_galaxy(data: GalaxyData) -> void:
	for i: int in range(galaxies.size()):
		var g: Galaxy = galaxies[i]
		if g.uid() == data.uid:
			galaxies.remove_at(i)
			break
	
	EventManager.on_galaxies_updated.emit({"galaxies": galaxies})
