class_name DashPanel
extends Node

@onready var dash_slot: DashSlot = $HBoxContainer/DashSlot
@onready var dash_slot_2: DashSlot = $HBoxContainer/DashSlot2
@onready var dash_slot_3: DashSlot = $HBoxContainer/DashSlot3
@onready var dash_slot_4: DashSlot = $HBoxContainer/DashSlot4

var slot_count: int = 0
var remaining: int = 0
var slots: Array[DashSlot]

func _ready() -> void:
	EventManager.on_dash_used.connect(_on_dash_used)
	EventManager.on_dash_updated.connect(_on_dash_updated)
	EventManager.on_dash_recover_progress.connect(_on_dash_recover_progress)
	EventManager.on_dash_error.connect(_on_dash_error)
	
	slots = [dash_slot, dash_slot_2, dash_slot_3, dash_slot_4]

func _on_dash_used() -> void:
	if remaining > 0:
		slots[remaining - 1].play_consume()
		slots[remaining - 1].show_wobble()

func setup(max_dashes: int) -> void:
	slot_count = max_dashes
	remaining = max_dashes
	_sync_slots()
	
	for i in range(min(slot_count, slots.size())):
		slots[i].make_full()

func _on_dash_updated(data: Dictionary) -> void:
	var new_remaining: int = data.get("remaining", 0)
	slot_count = data.get("max", 0)
	
	if new_remaining > remaining:
		for i in range(min(slot_count, slots.size())):
			slots[i].make_full()
		
	remaining = new_remaining
	_sync_slots()

func _sync_slots() -> void:
	for node: Node in slots:
		node.visible = false
	
	for i in range(min(slot_count, slots.size())):
		slots[i].visible = true

func _on_dash_recover_progress(progress: float) -> void:
	for slot: DashSlot in slots:
		if progress == 1.0:
			slot.make_full()
		else:
			if progress >= 0.3:
				slot.set_fill_progress(progress)

func _on_dash_error() -> void:
	for node: DashSlot in slots:
		node.show_wobble()
