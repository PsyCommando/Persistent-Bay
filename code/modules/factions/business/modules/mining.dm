/datum/business_module/mining
	cost = 1400
	name = "Mining"
	desc = "Mining companies send teams out into the hostile outer-space armed with picks, drills and a variety of other EVA equipment plus weapons and armor to defend themselves. The ores they recover can be processed and then sold on the Material Marketplace to other organizations for massive profits."
	levels = list(/datum/machine_limits/mining/one, /datum/machine_limits/mining/two, /datum/machine_limits/mining/three, /datum/machine_limits/mining/four)
	specs = list(/datum/business_spec/mining/massdrill, /datum/business_spec/mining/monsterhunter)
	hourly_objectives = list(/datum/module_objective/hourly/employees, /datum/module_objective/hourly/revenue, /datum/module_objective/hourly/travel, /datum/module_objective/hourly/cost)
	daily_objectives = list(/datum/module_objective/daily/employees, /datum/module_objective/daily/revenue, /datum/module_objective/daily/travel, /datum/module_objective/daily/cost)
	weekly_objectives = list(/datum/module_objective/weekly/employees, /datum/module_objective/weekly/revenue, /datum/module_objective/weekly/travel, /datum/module_objective/weekly/cost)
	starting_items = list(/obj/item/weapon/storage/toolbox/mechanical/filled = 1, /obj/item/stack/cable_coil/thirty = 1, /obj/item/weapon/stock_parts/matter_bin = 3, /obj/item/weapon/stock_parts/micro_laser = 4, /obj/item/weapon/stock_parts/console_screen = 1, /obj/item/modular_computer/pda = 1, /obj/item/weapon/circuitboard/fabricator/genfab = 1, /obj/item/weapon/circuitboard/telepad = 1, /obj/item/stack/material/steel/ten = 2, /obj/item/stack/material/glass/ten = 2, /obj/item/weapon/pickaxe = 2, /obj/item/clothing/head/helmet/space/mining = 2, /obj/item/clothing/suit/space/mining = 2)

/datum/business_spec/mining/massdrill
	name = "Mass Production"
	desc = "The Mass Production specialization allows operation of two extra drills, an extra shuttle, plus an engineering fabricator and a engineering tech limit. Take multiple teams to harvest materials from the managable sectors of outer-space."
	limits = /datum/machine_limits/mining/spec/massdrill

/datum/business_spec/mining/monsterhunter
	name = "Monster Hunter"
	desc = "This specialization gives the business capacity for a medical fabricator and tech that can produce machines and equipment to keep employees alive while fighting the top tier of monsters. Travel to the outer reaches and dig for riches, let the monsters come to you."
	limits = /datum/machine_limits/mining/spec/monsterhunter
	hourly_objectives = list(/datum/module_objective/hourly/monsters)
	daily_objectives = list(/datum/module_objective/daily/monsters)
	weekly_objectives = list(/datum/module_objective/weekly/monsters)
