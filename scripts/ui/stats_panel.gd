extends Node

@onready var label: Label = $Label

func _ready() -> void:
	self.visible = false
	
	if Flags.is_debug():
		self.visible = true
	else:
		self.queue_free()

func _process(_delta: float) -> void:
	_show_stats()

func _show_stats() -> void:
	var fps: float = Engine.get_frames_per_second()
	var mem_static: float = Performance.get_monitor(Performance.MEMORY_STATIC)
	var mem_static_max: float = Performance.get_monitor(Performance.MEMORY_STATIC_MAX)
	var video_mem: float = Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)
	var draw_calls: float = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)

	label.text = "FPS: %d\nStatic Mem: %.2f MB\nStatic Max: %.2f MB\nVRAM: %.2f MB\nDraw Calls: %d" % [
		fps,
		mem_static / 1024.0 / 1024.0,
		mem_static_max / 1024.0 / 1024.0,
		video_mem / 1024.0 / 1024.0,
		draw_calls
	]
