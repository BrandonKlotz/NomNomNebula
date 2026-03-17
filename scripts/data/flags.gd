class_name Flags

#region Values
const SKIP_SCENE_MANAGER: int = 1
const AUTOSTART: int = 0
#endregion

#region Functions
static func skip_scene_manager() -> bool:
	return is_debug() and SKIP_SCENE_MANAGER

static func autostart() -> bool:
	return is_debug() and AUTOSTART
#endregion

static func is_debug() -> bool:
	return OS.is_debug_build()
