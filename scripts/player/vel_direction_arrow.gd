extends Sprite2D

@onready var player: Player = get_parent()
@export var distance: float = 10

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	var player_direction :Vector2 = Utils.rotation_to_vector(player.rotation)
	global_position = player.position + player_direction * distance
