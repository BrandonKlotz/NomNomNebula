extends Node

## Player Data ##
var current_save: SaveGame = null

## Random numbers ##
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _init() -> void:
	rng.randomize()
