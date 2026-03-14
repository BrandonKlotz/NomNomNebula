class_name Flags

#region Values
const SKIP_LOGOS: int = 1
#endregion

#region Functions
static func skip_logos() -> bool:
	return is_debug() and SKIP_LOGOS
#endregion

static func is_debug() -> bool:
	return OS.is_debug_build()
