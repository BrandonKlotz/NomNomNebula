class_name BuffDebuffPool

const pool: Dictionary = {
	"buffs": [
		{ "rarity": 0, BuffDebuffKey.EXTRA_DASHES: 2 }, # +2 dashes
		{ "rarity": 0, BuffDebuffKey.STABILITY_TIME: 5 }, # add 5s to stability
		{ "rarity": 0, BuffDebuffKey.DASH_FORCE_FACTOR: 0.5 }, # 50% larger
		{ "rarity": 0, BuffDebuffKey.DASH_RECHARGE_FACTOR: 0.5 }, # charge dash 50% faster
		{ "rarity": 0, BuffDebuffKey.SIZE_CHANGE_FACTOR: 0.5 }, # 50% bigger
		{ "rarity": 0, BuffDebuffKey.STABILITY_DRAIN_FACTOR: -0.5 }, # drains 50% slower
		
		# WIP
		#{ "rarity": 0, BuffDebuffKey.ESCAPING_TIME: 2 }, # +2s time to scape from black holes
		#{ "rarity": 0, BuffDebuffKey.ABSORPTION_SPEED_FACTOR: 0.5 }, # absorbe galaxies faster
		#{ "rarity": 0, BuffDebuffKey.MOVEMENT_SPEED_FACTOR: 0.5 }, # moves faster
	],
	"debuffs": [
		{ "rarity": 0, BuffDebuffKey.STABILITY_TIME: -5 },
		{ "rarity": 0, BuffDebuffKey.DASH_FORCE_FACTOR: -0.5 }, # 50% shorter
		{ "rarity": 0, BuffDebuffKey.DASH_RECHARGE_FACTOR: -0.5 }, # charge 50% faster
		{ "rarity": 0, BuffDebuffKey.SIZE_CHANGE_FACTOR: -0.5 }, # 50% smaller
		{ "rarity": 1, BuffDebuffKey.CONTROL_TYPE: 1 }, # tank control
		{ "rarity": 0, BuffDebuffKey.STABILITY_DRAIN_FACTOR: 0.5 },
		{ "rarity": 2, BuffDebuffKey.STABILITY_MAX: -5 }, # Exotic matter only, -5 stability max
		
		# WIP
		#{ "rarity": 1, BuffDebuffKey.CONTROL_TYPE: 2 }, # inverted control
		#{ "rarity": 0, BuffDebuffKey.ABSORPTION_SPEED_FACTOR: -0.5 },
		#{ "rarity": 0, BuffDebuffKey.MOVEMENT_SPEED_FACTOR: -0.5 },
	]
}
