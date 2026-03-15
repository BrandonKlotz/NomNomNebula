class_name DashPanel
extends Node

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var texture_rect: TextureRect = $TextureRect

var slot_count: int = 0
var remaning: int = 0
var is_recharging: bool = false

func _ready() -> void:
	EventManager.on_dash_used.connect(_on_dash_used)
	EventManager.on_dash_error.connect(_on_dash_error)
	EventManager.on_dash_fully_recovered.connect(_on_dash_recovered)
	EventManager.on_dash_recover_progress.connect(_on_dash_recharging)

func setup(max_dashes: int) -> void:
	slot_count = max_dashes
	remaning = max_dashes
	
	for node: Node in h_box_container.get_children():
		node.visible = false
	
	for i: int in range(slot_count):
		h_box_container.get_child(i).visible = true
	
	_update()

func _process(_delta: float) -> void:
	progress_bar.visible = is_recharging
	
func _update() -> void:
	for i: int in range(slot_count):
		h_box_container.get_child(i).color = Color.WHITE
		
	for i: int in range(remaning):
		h_box_container.get_child(i).visible = true
		h_box_container.get_child(i).color = Color.GREEN

func _on_dash_used() -> void:
	remaning -= 1
	_update()
	animation_component.subtle_wobble(texture_rect)

func _on_dash_recovered() -> void:
	remaning = slot_count
	is_recharging = false
	_update()

func _on_dash_recharging(progress: float) -> void:
	is_recharging = true
	progress_bar.value = progress * 100

func _on_dash_error() -> void:
	pass
