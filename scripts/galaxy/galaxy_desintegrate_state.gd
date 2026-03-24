class_name GalaxyDesintegrate
extends State

@export var galaxy: Galaxy
@export var desintegration_duration: float = 2.0  # Increased for testing
@export var spin_rotations: float = 3.0

var tween: Tween

func enter() -> void:
	print("DEBUG: Desintegrate state entered for galaxy at ", galaxy.global_position)
	# Stop Galaxy
	galaxy.velocity = Vector2.ZERO
	galaxy.set_process(false)
	AudioManager.play_sfx(AudioManager.tracks.galaxy_desintegrated)

	# Move camera back to player immediately (will smoothly transition)
	if Globals.game_camera and Globals.player:
		Globals.game_camera.set_target(Globals.player.camera_target)

	# Disable Physics
	for child in galaxy.get_children():
		if child is Area2D:
			child.set_deferred("monitoring", false)
			child.set_deferred("monitorable", false)

	_play_disintegration_tween()
	_create_absorption_twinkle()
	# Wait for animation to complete before freeing
	var timer = get_tree().create_timer(desintegration_duration + 0.2)
	Globals.player.apply_force((Globals.player.global_position - galaxy.global_position).normalized() * 250)
	timer.timeout.connect(_free_galaxy)
	# DON'T emit absorbed event yet - it triggers immediate removal!
	# Will emit in _free_galaxy after animation completes

func _play_disintegration_tween() -> void:
	print("DEBUG: Starting simple scale animation. Initial scale: ", galaxy.scale)
	print("DEBUG: Duration: ", desintegration_duration, "s")

	# Create very simple tween - just shrink to zero
	tween = galaxy.get_tree().create_tween()

	# Single simple animation: shrink over 2 seconds
	tween.tween_property(galaxy, "scale", Vector2.ZERO, desintegration_duration)
	tween.tween_property(galaxy, "modulate:a", 0.0, desintegration_duration)

	tween.finished.connect(func():
		print("DEBUG: Animation finished. Final scale: ", galaxy.scale)
	)

func _create_absorption_twinkle() -> void:
	if Globals.player == null:
		return

	# Create a light at the player's position
	var twinkle_light: PointLight2D = PointLight2D.new()
	Globals.player.add_child(twinkle_light)

	# Position at player center
	twinkle_light.position = Vector2.ZERO

	# Set light properties - match galaxy color
	twinkle_light.color = galaxy.data.halo_color1
	twinkle_light.energy = 0.0
	twinkle_light.texture_scale = 0.5
	twinkle_light.shadow_enabled = false

	# Create twinkle animation
	var twinkle_tween: Tween = twinkle_light.create_tween()
	twinkle_tween.set_parallel(true)

	# Quick flash up
	twinkle_tween.tween_property(twinkle_light, "energy", 2.0, 0.1)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	twinkle_tween.tween_property(twinkle_light, "texture_scale", 1.5, 0.1)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

	# Fade out
	twinkle_tween.tween_property(twinkle_light, "energy", 0.0, 0.3)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO).set_delay(0.1)
	twinkle_tween.tween_property(twinkle_light, "texture_scale", 0.3, 0.3)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO).set_delay(0.1)

	# Clean up after animation
	await twinkle_tween.finished
	twinkle_light.queue_free()

func _free_galaxy() -> void:
	print("DEBUG: Freeing galaxy")
	# Emit absorbed event NOW, after animation completed
	EventManager.on_galaxy_absorbed.emit(galaxy.data)
	if tween:
		tween.kill()
	# Note: galaxy_spawner.remove_galaxy() will call queue_free()
	# so we don't need to call it here
