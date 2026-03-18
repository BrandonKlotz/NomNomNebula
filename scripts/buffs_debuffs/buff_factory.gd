class_name BuffDebuffFactory

const RARITY = { "COMMON": 0, "UNCOMMON": 1, "RARE": 2 }
const RARITY_WEIGHTS = { 0: 100, 1: 40, 2: 10 }

static func generate_buff() -> Dictionary:
	return _generate(true)

static func generate_debuff() -> Dictionary:
	return _generate(false)

static func _generate(is_good: bool) -> Dictionary:
	var key: String = "buffs" if is_good else "debuffs"
	var candidates: Array = BuffDebuffPool.pool[key]

	if candidates.is_empty():
		return {}

	# weighted list
	var weighted: Array = []
	for entry in candidates:
		var rarity: int = entry.get("rarity", 0)
		var weight: int = RARITY_WEIGHTS[clamp(rarity, 0, RARITY_WEIGHTS.size() - 1)]
		weighted.append({ "entry": entry, "weight": weight })

	# weighted random
	var total_weight: int = 0
	for w in weighted:
		total_weight += w["weight"]

	var roll: float = Globals.rng.randf() * total_weight
	var cumulative: float = 0.0

	for w in weighted:
		cumulative += w["weight"]
		if roll < cumulative:
			return w["entry"].duplicate()

	return candidates[-1].duplicate()
