extends CanvasLayer

var target_scene: String = ""
var duration: float = 0.5
var is_loading: bool = false
var progress: Array = []

@onready var bg: ColorRect = $ColorRect
@onready var label: Label = $Label

func transition_to(scene: String, show_loader: bool) -> void:
	target_scene = scene
	fade_out(on_fade_out_finished, show_loader)

# from scene to black
func fade_out(block: Callable, show_loader: bool = false) -> void:
	bg.color = Colors.TRANSPARENT
	label.modulate.a = 0.0
	
	self.visible = true
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(bg, "color", Colors.BASE_COLOR, duration)
	
	var callback: Callable = func() -> void:
		if show_loader:
			label.modulate.a = 1.0
		block.call()
	
	tween.connect("finished", callback)

# from black to scene
func fade_in(block: Callable = func() -> void: pass) -> void:
	bg.color = Colors.BASE_COLOR
	self.visible = true
	self.label.modulate.a = 0
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(bg, "color", Colors.TRANSPARENT, duration)
	
	var callback: Callable = func() -> void:
		self.visible = false
		block.call()
	
	tween.connect("finished", callback)

func on_fade_out_finished() -> void:
	start_loading_scene()

func start_loading_scene() -> void:
	ResourceLoader.load_threaded_request(target_scene)
	is_loading = true
	
func _process(_delta: float) -> void:
	if not is_loading or target_scene.is_empty():
		return
	
	var status: ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(target_scene, progress)
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		is_loading = false
		var new_scene: Resource = ResourceLoader.load_threaded_get(target_scene)
		call_deferred("on_scene_loaded", new_scene)
		
func on_scene_loaded(scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene)
