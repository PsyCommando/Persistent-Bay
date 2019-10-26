// /datum/business_module/engineering
// 	cost = 1400
// 	name = "Engineering"
// 	desc = "An engineering business has tools to develop areas of the station and construct shuttles plus the unique capacity to manage private radio communications. Engineering businesses can reserve larger spaces than other businesses and develop those into residential areas to be leased to individuals."
// 	levels = list(/datum/machine_limits/eng/one, /datum/machine_limits/eng/two, /datum/machine_limits/eng/three, /datum/machine_limits/eng/four)
// 	specs = list(/datum/business_spec/eng/realestate, /datum/business_spec/eng/tcomms)
// 	hourly_objectives = list(/datum/module_objective/hourly/revenue, /datum/module_objective/hourly/employees, /datum/module_objective/hourly/cost, /datum/module_objective/hourly/contract)
// 	daily_objectives = list(/datum/module_objective/daily/revenue, /datum/module_objective/daily/employees, /datum/module_objective/daily/cost, /datum/module_objective/daily/contract)
// 	weekly_objectives = list(/datum/module_objective/weekly/revenue, /datum/module_objective/weekly/employees, /datum/module_objective/weekly/cost, /datum/module_objective/weekly/contract)
// 	starting_items = list(/obj/item/weapon/storage/toolbox/mechanical/filled = 1, /obj/item/stack/cable_coil/thirty = 1, /obj/item/weapon/stock_parts/matter_bin = 3, /obj/item/weapon/stock_parts/micro_laser = 4, /obj/item/weapon/stock_parts/console_screen = 1, /obj/item/modular_computer/pda = 1, /obj/item/weapon/circuitboard/fabricator/genfab = 1, /obj/item/weapon/circuitboard/telepad = 1, /obj/item/stack/material/steel/ten = 2, /obj/item/stack/material/glass/ten = 2, /obj/item/clothing/gloves/insulated/cheap = 2, /obj/item/weapon/storage/belt/utility/full = 2)

// /datum/business_spec/eng/realestate
// 	name = "Real-Estate"
// 	desc = "With this specialization the engineering business gains another 200 tiles of area limit plus a consumer fabricator limit and two levels of consumer tech limit so that you can better furnish interiors."
// 	limits = /datum/machine_limits/eng/spec/realestate

// /datum/business_spec/eng/tcomms
// 	name = "Communication & Travel"
// 	desc = "This specialization grants operation of three extra telecomms machines that can operate three frequencies each. It also allows for two shuttles and an extra EVA fabricator."
// 	limits = /datum/machine_limits/eng/spec/realestate
