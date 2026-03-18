extends CanvasLayer

var target_scene: String = ""
var duration: float = 0.8
var is_loading: bool = false
var progress: Array = []
var material: ShaderMaterial

@onready var bg: ColorRect = $ColorRect

func _ready() -> void:
	material = bg.material
	 
	if Flags.skip_scene_manager():
		_skip_scene_manager()

func _skip_scene_manager() -> void:
	var main_scene_path: String = ProjectSettings.get_setting("application/run/main_scene")
	if main_scene_path.begins_with("uid://"):
		main_scene_path = ResourceUID.get_id_path(ResourceUID.text_to_id(main_scene_path))
	var is_main_scene: bool = get_tree().current_scene.scene_file_path == main_scene_path
	if not is_main_scene:
		self.visible = false
		
func transition_to(scene: String) -> void:
	target_scene = scene
	fade_out(on_fade_out_finished)

# from scene to black
func fade_out(block: Callable) -> void:
	self.material.set_shader_parameter("progress", 0.0)
	
	self.visible = true
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.0, duration)
	
	var callback: Callable = func() -> void:
		block.call()
	
	tween.connect("finished", callback)

# from black to scene
func fade_in(block: Callable = func() -> void: pass) -> void:
	self.visible = true
	self.material.set_shader_parameter("progress", 1.0)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 0.0, duration)
	
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
