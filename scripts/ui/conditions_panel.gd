class_name ConditionsPanel
extends Node

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var label: Label = $HBoxContainer/Label
@onready var tooltip_label: Label = $Tooltip/TooltipLabel
@onready var tooltip: PanelContainer = $Tooltip

var atlas: AtlasTexture

func _ready() -> void:
	atlas = texture_rect.texture as AtlasTexture
	label.text = ""
	texture_rect.visible = false
	tooltip.visible = false
	
	texture_rect.mouse_exited.connect(func() -> void:
		tooltip.visible = false
		AudioManager.play_sfx(AudioManager.tracks.dismiss_ui)
	)
	
	texture_rect.mouse_entered.connect(func() -> void:
		tooltip.visible = true
		AudioManager.play_sfx(AudioManager.tracks.show_ui)
	)

func set_data(data: Dictionary) -> void:
	texture_rect.visible = true
	label.text = ""
	tooltip_label.text = ""
	
	for key: String in data:
		if key == "rarity":
			pass
		elif key == BuffDebuffKey.CONTROL_TYPE_TANK or key == BuffDebuffKey.CONTROL_TYPE_INVERTED:
			label.text = ""
			_set_icon(key)
			_set_tooltip_title(key)
		else:
			label.text = _get_title(key, data[key])
			_set_icon(key)
			_set_tooltip_title(key)

func _set_tooltip_title(key: String) -> void:
	tooltip_label.text = BuffDebuffKey.DESCRIPTIONS.get(key, "-")
	
func _set_icon(key: String) -> void:
	var tile_size: float = 24
	var y: float = 0.0
	var frames: int = 8 
	
	match key:
		BuffDebuffKey.EXTRA_DASHES:
			y = tile_size * 3.0
			frames = 4
		BuffDebuffKey.LIMIT_DASH:
			y = tile_size * 10.0
			frames = 4
		BuffDebuffKey.DASH_FORCE_FACTOR:
			y = tile_size * 5.0
			frames = 5
		BuffDebuffKey.ESCAPING_TIME:
			y = tile_size * 6.0
			frames = 4
		BuffDebuffKey.DASH_RECHARGE_FACTOR:
			y = tile_size * 0.0
			frames = 4
		BuffDebuffKey.DASH_RECHARGE_FACTOR_INCREASED:
			y = tile_size * 8.0
			frames = 8
		BuffDebuffKey.MOVEMENT_WARP_FACTOR:
			y = tile_size * 1.0
			frames = 4
		BuffDebuffKey.INTERACTION_RADIUS_FACTOR:
			y = tile_size * 2.0
			frames = 4
		BuffDebuffKey.ABSORPTION_SPEED_FACTOR:
			y = tile_size * 4.0
			frames = 3
		BuffDebuffKey.STABILITY_MAX:
			y = tile_size * 9.0
			frames = 8
		BuffDebuffKey.CONTROL_TYPE_TANK:
			y = tile_size * 7.0
			frames = 8
		BuffDebuffKey.CONTROL_TYPE_INVERTED:
			y = tile_size * 11.0
			frames = 8
	
	texture_rect.hframes = frames
	texture_rect.y = int(y)
	texture_rect.play_animation()

func _get_title(key: String, value: Variant) -> String:
	match key:
		BuffDebuffKey.EXTRA_DASHES:
			return "+" + str(value)
		BuffDebuffKey.LIMIT_DASH:
			return str(value)
		BuffDebuffKey.DASH_FORCE_FACTOR:
			return _get_float_format(value)
		BuffDebuffKey.ESCAPING_TIME:
			return "+" + str(value) + "s"
		BuffDebuffKey.DASH_RECHARGE_FACTOR:
			return _get_float_format(value)
		BuffDebuffKey.DASH_RECHARGE_FACTOR_INCREASED:
			return _get_float_format(value)
		BuffDebuffKey.MOVEMENT_WARP_FACTOR:
			return _get_float_format(value)
		BuffDebuffKey.INTERACTION_RADIUS_FACTOR:
			return _get_float_format(value)
		BuffDebuffKey.ABSORPTION_SPEED_FACTOR:
			return _get_float_format(value)
		BuffDebuffKey.STABILITY_MAX:
			return str(value)
		BuffDebuffKey.CONTROL_TYPE_TANK:
			return ""
		BuffDebuffKey.CONTROL_TYPE_INVERTED:
			return ""
	
	return ""

func _get_float_format(value: float) -> String:
	var new_value: int = int(value * 100)
	var symbol: String = "" if new_value < 0 else "+"
	return symbol + str(new_value) + "%"
