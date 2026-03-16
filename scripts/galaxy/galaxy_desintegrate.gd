class_name GalaxyDesintegrate
extends State

@export var galaxy: Galaxy

@export var desintegration_duration: float = 0.8
@export var spin_rotations: float = 3.0


var tween: Tween

func enter() -> void:
	#Stop Galaxy
	galaxy.velocity = Vector2.ZERO
	galaxy.set_process(false)
	
	#Disable Physics
	for child in galaxy.get_children():
		if child is Area2D:
			child.set_deferred("monitoring", false)
			child.set_deferred("monitorable", false)

	play_disintegration_tween()

func play_disintegration_tween() -> void:
	tween = galaxy.create_tween()

	var current_scale: Vector2 = galaxy.scale
	var current_rotation: float = galaxy.rotation
	
	tween.set_parallel(true)

	tween.tween_property(
		galaxy, "scale",
		current_scale * 1.15,
		desintegration_duration * 0.1
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	tween.tween_property(
		galaxy, "scale",
		Vector2.ZERO,
		desintegration_duration * 0.9
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)

	tween.tween_property(
		galaxy, "rotation",
		current_rotation + TAU * spin_rotations,
		desintegration_duration
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

	tween.tween_property(
		galaxy, "modulate",
		Color(1, 1, 1, 0),
		desintegration_duration * 0.8
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)

	tween.set_parallel(false)
	tween.chain()
	
	var timer = get_tree().create_timer(1)
	Globals.player.apply_force((Globals.player.global_position - galaxy.global_position).normalized() * 250)
	timer.timeout.connect(free_galaxy)

func free_galaxy() -> void:
	tween.kill()
	galaxy.queue_free()
