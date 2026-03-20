extends Node

## Player Data ##
var current_save: SaveGame = null
var player: Player = null
var game_camera: MainCamera = null
var current_score: int = 0
var elapse_time: float = 0.0

## Random numbers ##
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _init() -> void:
	rng.randomize()
