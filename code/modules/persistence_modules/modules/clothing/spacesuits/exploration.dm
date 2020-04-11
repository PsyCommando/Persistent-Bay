//Exploration
/obj/item/clothing/head/helmet/space/void/exploration
	name = "purple voidsuit helmet"
	desc = "A lightweight helmet designed to accommodate only the most opulent space explorers."
	icon_state = "helm_explorer"
	item_state = "helm_explorer"
	armor  = list(
		DAM_BLUNT 	= 50,
		DAM_PIERCE 	= 40,
		DAM_CUT 	= 50,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 25,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 15,
		DAM_BOMB 	= 55,
		DAM_EMP 	= 20,
		DAM_BIO 	= 100,
		DAM_RADS 	= 50,
		DAM_STUN 	= 0)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	light_overlay = "explorer_light"

/obj/item/clothing/suit/space/void/exploration
	name = "purple voidsuit"
	desc = "A lightweight, general use voidsuit padded with soft cushioning to provide maximum comfort in the depths of space."
	icon_state = "void_explorer"
	item_state = "void_explorer"
	armor  = list(
		DAM_BLUNT 	= 50,
		DAM_PIERCE 	= 40,
		DAM_CUT 	= 50,
		DAM_BULLET 	= 10,
		DAM_LASER 	= 25,
		DAM_ENERGY 	= 20,
		DAM_BURN 	= 15,
		DAM_BOMB 	= 55,
		DAM_EMP 	= 20,
		DAM_BIO 	= 100,
		DAM_RADS 	= 50,
		DAM_STUN 	= 0)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/device/scanner/health,/obj/item/device/gps,/obj/item/weapon/pinpointer/radio,/obj/item/device/radio/beacon,/obj/item/weapon/material/hatchet/machete,/obj/item/weapon/shovel)

/obj/item/clothing/suit/space/void/exploration/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/exploration
	boots = /obj/item/clothing/shoes/magboots
