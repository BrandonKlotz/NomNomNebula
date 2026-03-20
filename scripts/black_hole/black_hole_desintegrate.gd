class_name BlackHoleDesintegrate
extends State

@export var black_hole: BlackHole
@export var desintegration_duration: float = 0.8
@export var spin_rotations: float = 3.0

var tween: Tween

func enter() -> void:
	black_hole.set_process(false)
	AudioManager.play_sfx(AudioManager.tracks.galaxy_desintegrated)
	
	for child in black_hole.get_children():
		if child is Area2D:
			child.set_deferred("monitoring", false)
			child.set_deferred("monitorable", false)

	_play_disintegration_tween()
	var timer = get_tree().create_timer(1)
	Globals.player.apply_force((Globals.player.global_position - black_hole.global_position).normalized() * 250)
	timer.timeout.connect(_free_black_hole)
	EventManager.on_black_hole_desintegrated.emit(black_hole.data)

func _play_disintegration_tween() -> void:
	tween = black_hole.create_tween()

	var current_scale: Vector2 = black_hole.scale
	var current_rotation: float = black_hole.rotation
	
	tween.set_parallel(true)

	tween.tween_property(
		black_hole, "scale",
		current_scale * 1.15,
		desintegration_duration * 0.1
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	tween.tween_property(
		black_hole, "scale",
		Vector2.ZERO,
		desintegration_duration * 0.9
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)

	tween.tween_property(
		black_hole, "rotation",
		current_rotation + TAU * spin_rotations,
		desintegration_duration
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

	tween.tween_property(
		black_hole, "modulate",
		Color(1, 1, 1, 0),
		desintegration_duration * 0.8
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)

	tween.set_parallel(false)
	tween.chain()

func _free_black_hole() -> void:
	tween.kill()
	black_hole.queue_free()
