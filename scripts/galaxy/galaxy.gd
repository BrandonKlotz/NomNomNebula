class_name Galaxy
extends Node2D

const VORTEX_MATERIAL: Resource = preload("uid://jske8d54cs0g")

@export var data: GalaxyData
@export var scaling_speed: float = 1

@onready var charge_player: AudioStreamPlayer2D = $ChargePlayer
@onready var animation: AnimatedSprite2D = get_node("Animation")
@onready var timer_label: Label = $TimerLabel
@onready var interaction_collision_shape: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var vortex_effect: Sprite2D = $VortexEffect

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
	var halo: Gradient = Gradient.new()
	halo.set_color(0, data.halo_color1)
	halo.set_color(1, data.halo_color2)
	var tex: GradientTexture1D = GradientTexture1D.new()
	tex.gradient = halo
	
	vortex_effect.material = VORTEX_MATERIAL.duplicate()
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
	Globals.player.apply_force((Globals.player.global_position - global_position).normalized() * 400)
	EventManager.on_camera_shake.emit(4.0, 1.0)
	AudioManager.play_sfx(AudioManager.tracks.galaxy_repel)

func _on_interaction_area_mouse_entered() -> void:
	EventManager.on_tooltip_show.emit(data)

func _on_interaction_area_mouse_exited() -> void:
	EventManager.on_tooltip_hide.emit()

func _on_game_state_changed(state: GameWorld.GameState) -> void:
	pass

func is_good_galaxy() -> bool:
	return data.is_good_galaxy

func uid() -> String:
	return data.uid

func set_good():
	var buff: Dictionary = BuffDebuffFactory.generate_buff()
	self.data.buff_debuff = buff

func set_bad():
	var debuff: Dictionary = BuffDebuffFactory.generate_debuff()
	self.data.buff_debuff = debuff
