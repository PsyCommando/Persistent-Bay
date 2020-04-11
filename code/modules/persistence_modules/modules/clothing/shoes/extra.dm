
/obj/item/clothing/shoes/eod
	name = "bomb boots"
	desc = "A pair of boot reinforced to provide some explosion protection."
	icon_state = "swat"
	force = 2
	item_flags = ITEM_FLAG_NOSLIP
	siemens_coefficient = 0.6
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	armor  = list(
		DAM_BLUNT 	= ARMOR_MELEE_RESISTANT,
		DAM_PIERCE 	= ARMOR_MELEE_RESISTANT,
		DAM_CUT 	= ARMOR_MELEE_RESISTANT,
		DAM_BULLET 	= ARMOR_BALLISTIC_MINOR,
		DAM_LASER 	= ARMOR_LASER_SMALL,
		DAM_ENERGY 	= ARMOR_ENERGY_RESISTANT,
		DAM_BURN 	= ARMOR_ENERGY_RESISTANT,
		DAM_BOMB 	= ARMOR_BOMB_SHIELDED,
	)
