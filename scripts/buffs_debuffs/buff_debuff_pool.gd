class_name BuffDebuffPool

const buffs: Array = [
	{ "rarity": 0, BuffDebuffKey.EXTRA_DASHES: 2},
	{ "rarity": 0, BuffDebuffKey.DASH_FORCE_FACTOR: 0.5}, # 50% larger
	{ "rarity": 0, BuffDebuffKey.ESCAPING_TIME: 2}, # +2s time to scape from black holes
	{ "rarity": 0, BuffDebuffKey.DASH_RECHARGE_FACTOR: -0.5}, # charge dash 50% faster
	{ "rarity": 0, BuffDebuffKey.MOVEMENT_WARP_FACTOR: 0.2}, # moves faster
	{ "rarity": 0, BuffDebuffKey.INTERACTION_RADIUS_FACTOR: 0.2},
	{ "rarity": 0, BuffDebuffKey.ABSORPTION_SPEED_FACTOR: 0.5}, # absorbe galaxies faster
]

const debuffs: Array = [
	{ "rarity": 1, BuffDebuffKey.STABILITY_MAX: -5 }, # Exotic matter only, -5 stability max
	{ "rarity": 1, BuffDebuffKey.CONTROL_TYPE_TANK: 1 }, # tank control
	{ "rarity": 1, BuffDebuffKey.CONTROL_TYPE_INVERTED: 2 }, # inverted control
	{ "rarity": 0, BuffDebuffKey.DASH_RECHARGE_FACTOR_INCREASED: 0.5 }, # charge 50% faster
	{ "rarity": 0, BuffDebuffKey.LIMIT_DASH: -1 }, # -1 dash
]

#{ "rarity": 0, BuffDebuffKey.EXTRA_DASHES: -1 },
#{ "rarity": 0, BuffDebuffKey.MOVEMENT_WARP_FACTOR: -0.2 },
#{ "rarity": 0, BuffDebuffKey.MOVEMENT_SPEED_FACTOR: -0.5 },
#{ "rarity": 0, BuffDebuffKey.STABILITY_DRAIN_FACTOR: 0.5 },
#{ "rarity": 0, BuffDebuffKey.STABILITY_DRAIN_FACTOR: -0.5 }, # drains 50% slower
#{ "rarity": 0, BuffDebuffKey.STABILITY_TIME: -5 },
#{ "rarity": 0, BuffDebuffKey.STABILITY_TIME: 5 }, # add 5s to stability
#{ "rarity": 0, BuffDebuffKey.DASH_FORCE_FACTOR: -0.5 }, # 50% shorter
#{ "rarity": 0, BuffDebuffKey.ABSORPTION_SPEED_FACTOR: -0.5 },
#{ "rarity": 0, BuffDebuffKey.SIZE_CHANGE_FACTOR: 0.5 }, # 50% bigger
#{ "rarity": 0, BuffDebuffKey.SIZE_CHANGE_FACTOR: -0.5 }, # 50% smaller
