extends Node

## Player Data ##
var current_save: SaveGame = null

## Random numbers ##
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _init() -> void:
	rng.randomize()
	
func rotation_to_vector(angle:float) -> Vector2:
	return Vector2(cos(angle), sin(angle))
