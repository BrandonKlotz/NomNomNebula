class_name UserPreferences
extends Resource

enum SchemaVersion {
	VERSION_1 = 1,
}

@export var version: SchemaVersion = SchemaVersion.VERSION_1
@export_range(0, 10, 1) var general_level: int = 5
@export_range(0, 10, 1) var music_level: int = 10
@export_range(0, 10, 1) var sfx_level: int = 10
@export var language: String = "en"
