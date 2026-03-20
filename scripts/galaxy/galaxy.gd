class_name Galaxy
extends Node2D

const VORTEX_MATERIAL: Resource = preload("uid://jske8d54cs0g")

@export var data: GalaxyData
@export var scaling_speed: float = 1

@onready var animation: AnimatedSprite2D = get_node("Animation")
@onready var interaction_collision_shape: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var vortex_effect: Sprite2D = $VortexEffect
@onready var repel_particles: GPUParticles2D = $RepelParticles
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer

var size: float
var velocity: Vector2 = Vector2.ZERO
var base_interaction_radius: float = 55.0

func _ready() -> void:
	EventManager.on_increment_galaxy_size.connect(_on_increment_interaction_radius)
	EventManager.on_reset_galaxy_size.connect(_on_increment_interaction_radius.bind(0))
	EventManager.on_game_state_changed.connect(_on_game_state_changed)
	
	# duplicate shape to make size unique per galaxy
	var shape: CircleShape2D = interaction_collision_shape.shape.duplicate()
	shape.radius = base_interaction_radius
	interaction_collision_shape.shape = shape
	size = data.size
	
	repel_particles.one_shot = true
	repel_particles.emitting = false
	
	# apply shader parameters
	var halo: Gradient = Gradient.new()
	halo.set_color(0, data.halo_color1)
	halo.set_color(1, data.halo_color2)
	var tex: GradientTexture1D = GradientTexture1D.new()
	tex.gradient = halo
	
	vortex_effect.material = VORTEX_MATERIAL.duplicate()
	vortex_effect.material.set_shader_parameter('haloColor', tex)
	
	animation.play(data.animation)

func _on_increment_interaction_radius(factor: float) -> void:
	interaction_collision_shape.shape.radius = base_interaction_radius * (1 + factor)

func _process(delta: float) -> void:
	size = lerp(size, 2.0, scaling_speed * delta)
	scale = Vector2(size, size)
	position += velocity * delta

func apply_force(force: Vector2) ->void:
	velocity += force

func _on_center_area_entered(_area: Area2D) -> void:
	Globals.player.velocity = Vector2.ZERO
	Globals.player.apply_force((Globals.player.global_position - global_position).normalized() * 400)
	EventManager.on_camera_shake.emit(4.0)
	AudioManager.play_sfx(AudioManager.tracks.galaxy_repel)
	repel_particles.restart()
	audio_player.play(0)

func _on_game_state_changed(state: GameWorld.GameState) -> void:
	match state:
		GameWorld.GameState.ONGOING:
			audio_player.stream_paused = false
		GameWorld.GameState.PAUSED:
			audio_player.stream_paused = true
		GameWorld.GameState.FINISHED:
			audio_player.stream_paused = true

func is_good_galaxy() -> bool:
	return data.is_good_galaxy

func uid() -> String:
	return data.uid

func set_good():
	var buff: Dictionary = BuffDebuffFactory.generate_buff()
	self.data.buff_debuff = buff
	self.data.is_good_galaxy = true

func set_bad():
	var debuff: Dictionary = BuffDebuffFactory.generate_debuff()
	self.data.buff_debuff = debuff
	self.data.is_good_galaxy = false
	
