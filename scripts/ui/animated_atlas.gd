class_name AnimatedAtlas
extends TextureRect

@export var hframes: int
@export var y: int
@export var duration: float
@export var autostart: bool = true
@export var loop: bool = true

var atlas: AtlasTexture
var frame_size: Vector2 = Vector2(320, 180)
var tween: Tween

func _ready() -> void:
	atlas = self.texture as AtlasTexture
	_set_frame(0)
	
	if autostart:
		play_animation()

func play_animation(callback: Callable = func() -> void: return) -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	
	if loop:
		tween.set_loops()
		
	tween.tween_method(_set_frame, 0, hframes - 1, duration)
	tween.tween_callback(callback)

func stop_animation() -> void:
	if tween:
		tween.kill()

func _set_frame(frame: int) -> void:
	atlas.region = Rect2(frame * frame_size.x, float(y), frame_size.x, frame_size.y)
