class_name BuffDebuffPool

const pool: Dictionary = {
	"buffs": [
		{ "rarity": 0, BuffDebuffKey.EXTRA_DASHES: 2 }, # more dashes
		{ "rarity": 0, BuffDebuffKey.DASH_FORCE_FACTOR: 0.5 }, # 0.5 stronger
		{ "rarity": 0, BuffDebuffKey.DASH_RECHARGE_FACTOR: 0.5 }, # 0.5 charge faster
		{ "rarity": 0, BuffDebuffKey.STABILITY_TIME: 5 }, # add 5 to stability
		{ "rarity": 0, BuffDebuffKey.SIZE_CHANGE_FACTOR: 0.5 }, # changes size
		
		#{ "rarity": 0, BuffDebuffKey.STABILITY_MAX: 5 },
		#{ "rarity": 0, BuffDebuffKey.ESCAPING_TIME_FACTOR: 0.5 }, # more time to scape
		#{ "rarity": 0, BuffDebuffKey.ABSORTION_SPEED_FACTOR: 0.5 }, # absorbe galaxies faster
		#{ "rarity": 0, BuffDebuffKey.MOVEMENT_SPEED_FACTOR: 0.5 }, # moves faster
	],
	"debuffs": [
		{ "rarity": 0, BuffDebuffKey.STABILITY_TIME: -5 },
		{ "rarity": 0, BuffDebuffKey.CONTROL_TYPE: 1 },
		{ "rarity": 0, BuffDebuffKey.CONTROL_TYPE: 2 },
		{ "rarity": 0, BuffDebuffKey.SIZE_CHANGE_FACTOR: -0.5 },
		
		#{ "rarity": 0, BuffDebuffKey.STABILITY_MAX: -5 },
		#{ "rarity": 0, BuffDebuffKey.STABILITY_SPEED_FACTOR: -0.5 },
		#{ "rarity": 0, BuffDebuffKey.BLACK_HOLES_PROB_FACTOR: 0.5 },
		#
		#{ "rarity": 0, BuffDebuffKey.ESCAPING_TIME_FACTOR: -0.5 },
		#{ "rarity": 0, BuffDebuffKey.ABSORTION_SPEED_FACTOR: -0.5 },
		#{ "rarity": 0, BuffDebuffKey.MOVEMENT_SPEED_FACTOR: -0.5 },
	]
}
