class_name AnimationComponent
extends Node

var parent: Node

func _ready() -> void:
	parent = get_parent()

func micro_bounce(override_parent: Node = null) -> void:
	if override_parent:
		parent = override_parent
		
	var original_scale: Vector2 = parent.scale
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(parent, "scale", original_scale - Vector2(0.05, 0.05), 0.06)
	tween.tween_property(parent, "scale", original_scale, 0.08)

func subtle_wobble(override_node: Node = null) -> void:
	if override_node:
		parent = override_node

	var tween: Tween = create_tween()
	var original_scale: Vector2 = parent.scale
	var click_scale: float = 0.96

	tween.tween_property(parent, "scale", original_scale * click_scale, 0.05)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(parent, "scale", original_scale, 0.1)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
