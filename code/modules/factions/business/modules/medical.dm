/datum/business_module/medical
	cost = 1200
	name = "Medical"
	desc = "A medical firm has unqiue capacity to develop medications and implants. Programs can be used to register clients under your care and recieve a weekly insurance payment from them, in exchange for tracking their health and responding to medical emergencies."
	specs = list(/datum/business_spec/medical/pharma, /datum/business_spec/medical/paramedic)
	levels = list(/datum/machine_limits/medical/one, /datum/machine_limits/medical/two, /datum/machine_limits/medical/three, /datum/machine_limits/medical/four)
	hourly_objectives = list(/datum/module_objective/hourly/visitors, /datum/module_objective/hourly/employees, /datum/module_objective/hourly/cost, /datum/module_objective/hourly/contract)
	daily_objectives = list(/datum/module_objective/daily/visitors, /datum/module_objective/daily/employees, /datum/module_objective/daily/cost, /datum/module_objective/daily/contract)
	weekly_objectives = list(/datum/module_objective/weekly/visitors, /datum/module_objective/weekly/employees, /datum/module_objective/weekly/cost, /datum/module_objective/weekly/contract)
	starting_items = list(/obj/item/weapon/storage/toolbox/mechanical/filled = 1, /obj/item/stack/cable_coil/thirty = 1, /obj/item/weapon/stock_parts/matter_bin = 3, /obj/item/weapon/stock_parts/micro_laser = 4, /obj/item/weapon/stock_parts/console_screen = 1, /obj/item/modular_computer/pda = 1, /obj/item/weapon/circuitboard/fabricator/genfab = 1, /obj/item/weapon/circuitboard/telepad = 1, /obj/item/stack/material/steel/ten = 2, /obj/item/stack/material/glass/ten = 2, /obj/item/weapon/storage/firstaid/surgery/full = 1, /obj/item/clothing/gloves/latex = 2, /obj/item/device/scanner/health = 2)

/datum/business_spec/medical/paramedic
	name = "Paramedic"
	desc = "The Paramedic specialization allows the business to operate a voidsuit fabricator and two shuttles to retrieve clients from the dangerous sectors of the Nexus outer-space."
	limits = /datum/machine_limits/medical/spec/paramedic
	hourly_objectives = list(/datum/module_objective/hourly/travel)
	daily_objectives = list(/datum/module_objective/daily/travel)
	weekly_objectives = list(/datum/module_objective/weekly/travel)

/datum/business_spec/medical/pharma
	name = "Pharmacy"
	desc = "This specialization gives the business capacity for a service fabricator and two botany trays that can produce reagents that can be further refined into valuable and effective medicines. It also grants 200 extra tiles to the area limit so you can have larger medical facilities."
	limits = /datum/machine_limits/medical/spec/pharma
