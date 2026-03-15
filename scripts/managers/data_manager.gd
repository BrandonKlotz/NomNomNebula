class_name DataManager
extends Node

const SAVE_BASE_PATH: String = "user://saves/"

# PLAYER SAVES
static func load_all_saves() -> Array[SaveGame]:
	var saves: Array[SaveGame] = []
	
	if not DirAccess.dir_exists_absolute(SAVE_BASE_PATH):
		DirAccess.make_dir_recursive_absolute(SAVE_BASE_PATH)
		
	var dir: DirAccess = DirAccess.open(SAVE_BASE_PATH)

	if dir:
		dir.list_dir_begin()

		while true:
			var filename: String = dir.get_next()
			if filename.is_empty():
				break
			
			if dir.current_is_dir() or filename.begins_with("."):
				continue
			
			var file_path: String = SAVE_BASE_PATH + filename
			if filename.begins_with("save_"):
				var load_file: bool = false
				
				if is_debug() and filename.ends_with(".tres"):
					load_file = true
				if not is_debug() and filename.ends_with(".res"):
					load_file = true
				
				if load_file:
					var save: Resource = ResourceLoader.load(file_path, "", ResourceLoader.CACHE_MODE_IGNORE)
					if save:
						saves.append(save)

		dir.list_dir_end()

	# Only reads files with slots in [0, 1, 2]
	return saves.filter(func(it: SaveGame) -> bool: return it.slot < 3)

static func load_save(save_id: String) -> SaveGame:
	var filepath: String = get_filepath(SAVE_BASE_PATH, save_id)
	
	if ResourceLoader.exists(filepath):
		return ResourceLoader.load(filepath, "", ResourceLoader.CACHE_MODE_IGNORE)
	return null

static func delete_save(save_id: String) -> void:
	var filepath: String = get_filepath(SAVE_BASE_PATH, save_id)

	if FileAccess.file_exists(filepath):
		DirAccess.remove_absolute(filepath)

static func new_save_file(slot: int) -> SaveGame:
	var save: SaveGame = SaveGame.new()
	save.uid = Utils.gen_save_uid()
	save.created_at = timestamp()
	save.updated_at = save.created_at
	save.data = GameData.new()
	save.slot = slot
	
	write_save(save)
	
	return save

static func write_save(save: SaveGame) -> void:
	var filepath: String = get_filepath(SAVE_BASE_PATH, save.uid)
	save.updated_at = timestamp()
	ResourceSaver.save(save, filepath)

# UTIL
static func get_filepath(base_path: String, filename: String) -> String:
	var extension: String = ".tres" if is_debug() else ".res"
	
	if not DirAccess.dir_exists_absolute(base_path):
		DirAccess.make_dir_recursive_absolute(base_path)

	return base_path + filename + extension

static func timestamp() -> String:
	return Time.get_datetime_string_from_system(true)

static func is_debug() -> bool:
	return OS.is_debug_build()
