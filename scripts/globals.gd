extends Node

## Player Data ##
var current_save: SaveGame = null

##player global reference
var player : Player

## Random numbers ##
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _init() -> void:
	rng.randomize()
