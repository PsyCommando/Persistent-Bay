// /datum/business_module/service
// 	cost = 1100
// 	name = "Service"
// 	desc = "A service business has a fabricator that can produce culinary and botany equipment. A service business can serve food or drink and supply freshly grown plants for other organizations, a crucial source of cloth and biomass."
// 	levels = list(/datum/machine_limits/service/one, /datum/machine_limits/service/two, /datum/machine_limits/service/three, /datum/machine_limits/service/four)
// 	specs = list(/datum/business_spec/service/culinary, /datum/business_spec/service/farmer)
// 	hourly_objectives = list(/datum/module_objective/hourly/employees, /datum/module_objective/hourly/revenue, /datum/module_objective/hourly/sales, /datum/module_objective/hourly/cost)
// 	daily_objectives = list(/datum/module_objective/daily/employees, /datum/module_objective/daily/revenue, /datum/module_objective/daily/sales, /datum/module_objective/daily/cost)
// 	weekly_objectives = list(/datum/module_objective/weekly/employees, /datum/module_objective/weekly/revenue, /datum/module_objective/weekly/sales, /datum/module_objective/weekly/cost)
// 	starting_items = list(/obj/item/weapon/storage/toolbox/mechanical/filled = 1, /obj/item/stack/cable_coil/thirty = 1, /obj/item/weapon/stock_parts/matter_bin = 3, /obj/item/weapon/stock_parts/micro_laser = 4, /obj/item/weapon/stock_parts/console_screen = 1, /obj/item/modular_computer/pda = 1, /obj/item/weapon/circuitboard/fabricator/genfab = 1, /obj/item/weapon/circuitboard/telepad = 1, /obj/item/stack/material/steel/ten = 3, /obj/item/stack/material/glass/ten = 3, /obj/item/seeds/potatoseed = 1, /obj/item/seeds/towermycelium = 1)

// /datum/business_spec/service/culinary
// 	name = "Culinary"
// 	desc = "This specialization gives 200 extra tiles to the area limit, plus an engineering fabricator and tech level so that you can put together the perfect space for your customers."
// 	limits = /datum/machine_limits/service/spec/culinary
// 	hourly_objectives = list(/datum/module_objective/hourly/visitors)
// 	daily_objectives = list(/datum/module_objective/daily/visitors)
// 	weekly_objectives = list(/datum/module_objective/weekly/visitors)


// /datum/business_spec/service/farmer
// 	name = "Farming"
// 	desc = "Farming gives four additional botany trays and limits for two of the exclusive auto-tailor types, so you can process cloth into a finished product for selling. The extra botany trays can produce plants or reagents to be sold to all sorts of other businesses."
// 	limits = /datum/machine_limits/service/spec/farmer
