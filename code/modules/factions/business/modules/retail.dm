/datum/business_module/retail
	cost = 1200
	name = "Retail"
	desc = "A retail business has exclusive production capacity so that they can sell clothing and furniture to individuals and organizations. With additional specialization they can branch out into combat equipment or engineering supplies, but they are reliant on the material market to supply their production."
	levels = list(/datum/machine_limits/retail/one, /datum/machine_limits/retail/two, /datum/machine_limits/retail/three, /datum/machine_limits/retail/four)
	specs = list(/datum/business_spec/retail/combat, /datum/business_spec/retail/bigstore)
	hourly_objectives = list(/datum/module_objective/hourly/visitors, /datum/module_objective/hourly/employees, /datum/module_objective/hourly/cost, /datum/module_objective/hourly/sales, /datum/module_objective/hourly/fabricate, /datum/module_objective/hourly/revenue)
	daily_objectives = list(/datum/module_objective/daily/visitors, /datum/module_objective/daily/employees, /datum/module_objective/daily/cost, /datum/module_objective/daily/sales, /datum/module_objective/daily/fabricate, /datum/module_objective/daily/revenue)
	weekly_objectives = list(/datum/module_objective/weekly/visitors, /datum/module_objective/weekly/employees, /datum/module_objective/weekly/cost, /datum/module_objective/weekly/sales, /datum/module_objective/weekly/fabricate, /datum/module_objective/weekly/revenue)
	starting_items = list(/obj/item/weapon/storage/toolbox/mechanical/filled = 1, /obj/item/stack/cable_coil/thirty = 1, /obj/item/weapon/stock_parts/matter_bin = 3, /obj/item/weapon/stock_parts/micro_laser = 4, /obj/item/weapon/stock_parts/console_screen = 1, /obj/item/modular_computer/pda = 1, /obj/item/weapon/circuitboard/fabricator/genfab = 1, /obj/item/weapon/circuitboard/telepad = 1, /obj/item/stack/material/steel/ten = 4, /obj/item/stack/material/glass/ten = 4)

/datum/business_spec/retail/combat
	name = "Combat"
	desc = "The Combat specialization gives limits for a combat fabricator and an early combat tech limit which will increase as the business network expands. You can also maintain a shuttle, but you'll need to purchase the EVA equipment elsewhere."
	limits = /datum/machine_limits/retail/spec/combat

/datum/business_spec/retail/bigstore
	name = "Grand Emporium"
	desc = "This specialization gives the business capacity for an engineering fabricator, an EVA fabricator, an engineering tech limit, plus 200 extra tiles for the area limit so that you can produce a grand emporium that sells all manner of things."
	limits = /datum/machine_limits/retail/spec/bigstore
