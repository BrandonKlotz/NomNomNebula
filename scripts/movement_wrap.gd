extends Node2D

const CANVAS_SIZE: float = 1920
const TILE_SIZE: float = 64
const PADDING_TILES: float = 14

@export var move_camera: bool = false

func _process(_delta: float) -> void:
	_handle_wrapping()

func _handle_wrapping() -> void:
	var pos: Vector2 = owner.position
	var padding: float = TILE_SIZE * PADDING_TILES
	var max_x: float = CANVAS_SIZE - padding
	var min_x: float = (CANVAS_SIZE - padding) * -1
	var size: float = max_x - min_x
	var offset: Vector2 = Vector2.ZERO

	if pos.x > max_x:
		pos.x -= size
		offset.x = -size
	elif pos.x < min_x:
		pos.x += size
		offset.x = size

	if pos.y > max_x:
		pos.y -= size
		offset.y = -size
	elif pos.y < min_x:
		pos.y += size
		offset.y = size
	
	owner.position = pos
	
	if move_camera and offset != Vector2.ZERO:
		Globals.game_camera.position += offset
