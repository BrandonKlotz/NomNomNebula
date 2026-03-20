extends Sprite2D

@export var player: Player
@export var player_movement : PlayerMovement
@export var distance: float = 50

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if not player_movement.current_movement_type == player_movement.ControlType.TANK:
		return
	
	var player_direction: Vector2 = Utils.rotation_to_vector(player_movement.movement_angle)
	rotation = player_movement.movement_angle
	global_position = player.position + player_direction * distance * player.target_size
