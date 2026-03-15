class_name GameData
extends Resource

@export_category("Player")
@export var total_elapsed_time: float = 0.0 # in seconds
@export var highest_score: int = 0

@export_category("Audio")
@export_range(0, 10, 1) var music_level: int = 5
@export_range(0, 10, 1) var sfx_level: int = 5
