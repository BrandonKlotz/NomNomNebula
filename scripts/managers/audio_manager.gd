extends Node

const POOL_SIZE: int = 5
const MUSIC_BUS_ID: String = "Music"
const SFX_BUS_ID: String = "SFX"

@export var tracks: AudioTable

var effects_pool: Node2D
var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var fade_duration: float = 1.0

func _ready() -> void:
	_setup_nodes()
	_setup_player_pool()

func _setup_player_pool() -> void:
	for _i: int in range(0, POOL_SIZE):
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		effects_pool.add_child(player)
		sfx_players.append(player)

func _setup_nodes() -> void:
	effects_pool = Node2D.new()
	
	music_player = AudioStreamPlayer.new()
	music_player.bus = MUSIC_BUS_ID
	
	add_child(effects_pool)
	add_child(music_player)

func play_music(setting: AudioSetting) -> void:
	music_player.stream = setting.source
	music_player.volume_db = -80.0
	music_player.play()
	
	var tween: Tween = create_tween()
	tween.tween_property(music_player, "volume_db", setting.volume_db, fade_duration)\
		.set_trans(Tween.TRANS_SINE)

func stop_music() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(music_player, "volume_db", -80.0, fade_duration)\
		.set_trans(Tween.TRANS_SINE)
	tween.finished.connect(func() -> void: music_player.stop())

func play_sfx(setting: AudioSetting, override_scale: float = 1.0) -> void:
	if setting == null:
		return
	
	var player: AudioStreamPlayer = get_next_sfx_player()
	
	player.stream = setting.source
	player.volume_db = setting.volume_db
	
	var scale: float = setting.pitch_scale
	
	if override_scale != 1.0:
		scale = override_scale
	
	if scale != 1.0:
		if setting.pitch_randomness != 0:
			scale = get_random_pitch_from_base(scale, setting.pitch_randomness)
	elif setting.pitch_randomness != 0:
		scale = get_random_pitch(setting.pitch_randomness)
	
	player.pitch_scale = scale
	player.bus = SFX_BUS_ID
	player.play()

func get_random_pitch(randomness: float) -> float:
	return rng.randf_range(1.0 - randomness, 1.0 + randomness)

func get_random_pitch_from_base(base_pitch: float, randomness: float) -> float:
	var random_offset: float = rng.randf_range(-randomness, randomness)
	return base_pitch + random_offset

func get_next_sfx_player() -> AudioStreamPlayer:
	for player: AudioStreamPlayer in sfx_players:
		if not player.playing:
			return player
	
	var temp_player: AudioStreamPlayer = AudioStreamPlayer.new()
	temp_player.set_meta("temp", true)
	temp_player.finished.connect(on_temp_finished.bind(temp_player))
	effects_pool.add_child(temp_player)
	
	return temp_player

func on_temp_finished(player: AudioStreamPlayer) -> void:
	if player.has_meta("temp"):
		player.queue_free()

func configure_audio_server(_sfx_level: int, _music_level: int) -> void:
	var sfx_level: float = float(_sfx_level) / 10
	var music_level: float = float(_music_level) / 10
	
	music_level = clampf(music_level, 0, 1)
	sfx_level = clampf(sfx_level, 0, 1)
	
	var music_bus_id: int = AudioServer.get_bus_index("Music")
	var sfx_bus_id: int = AudioServer.get_bus_index("SFX")
	
	AudioServer.set_bus_volume_db(sfx_bus_id, linear_to_db(sfx_level))
	AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(music_level))
