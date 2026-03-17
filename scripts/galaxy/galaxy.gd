class_name Galaxy
extends Node2D

@export var data: GalaxyData
@export var scaling_speed: float = 1

@onready var animation: AnimatedSprite2D = get_node("Animation")
@onready var timer_label: Label = $TimerLabel
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var interaction_collision_shape: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var vortex_effect : Sprite2D = $VortexEffect

var size: float
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	EventManager.on_game_state_changed.connect(_on_game_state_changed)
	# duplicate shape to make size unique per galaxy
	var shape: CircleShape2D = interaction_collision_shape.shape.duplicate()
	shape.radius = data.interaction_radius
	interaction_collision_shape.shape = shape
	size = data.size
	
	#apply shader parameters
	var halo : Gradient = Gradient.new()
	halo.set_color(0, data.halo_color1)
	halo.set_color(1, data.halo_color2)
	var tex : GradientTexture1D = GradientTexture1D.new()
	tex.gradient = halo
	vortex_effect.material.set_shader_parameter('haloColor', tex)
	
	animation.play(data.animation)

func _process(delta: float) -> void:
	size = lerp(size, 2.0, scaling_speed * delta)
	scale = Vector2(size, size)
	position += velocity * delta

func apply_force(force: Vector2) ->void:
	velocity += force

func _on_center_area_entered(_area: Area2D) -> void:
	Globals.player.velocity = Vector2.ZERO
	Globals.player.apply_force((Globals.player.global_position - global_position).normalized() * 500)

func _on_interaction_area_mouse_entered() -> void:
	EventManager.on_tooltip_show.emit(data)

func _on_interaction_area_mouse_exited() -> void:
	EventManager.on_tooltip_hide.emit()

func _on_game_state_changed(state: GameWorld.GameState) -> void:
	match state:
		GameWorld.GameState.ONGOING:
			audio_player.play()
		GameWorld.GameState.PAUSED:
			audio_player.stop()
		GameWorld.GameState.FINISHED:
			audio_player.stop()
