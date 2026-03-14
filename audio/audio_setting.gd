class_name AudioSetting
extends Resource

@export var source: AudioStream
@export_range(-40, 20) var volume_db: float = 0
@export_range(0.0, 4.0, 0.1) var pitch_scale: float = 1.0
@export_range(0.0, 1.0, 0.01) var pitch_randomness: float = 0.0 
