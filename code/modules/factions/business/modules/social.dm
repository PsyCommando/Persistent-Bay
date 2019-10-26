// /datum/business_module/social
// 	cost = 1100
// 	name = "Social"
// 	desc = "Social companies have simple production and tech capacities but exclusive access to programs and objectives that track voluntary membership, so that mass-emails can be sent and events can be planned for the members."
// 	levels = list(/datum/machine_limits/social/one, /datum/machine_limits/social/two, /datum/machine_limits/social/three, /datum/machine_limits/social/four)
// 	specs = list(/datum/business_spec/social/religion, /datum/business_spec/social/club)
// 	hourly_objectives = list(/datum/module_objective/hourly/employees, /datum/module_objective/hourly/revenue, /datum/module_objective/hourly/sales)
// 	daily_objectives = list(/datum/module_objective/daily/employees, /datum/module_objective/daily/revenue, /datum/module_objective/daily/sales)
// 	weekly_objectives = list(/datum/module_objective/weekly/employees, /datum/module_objective/weekly/revenue, /datum/module_objective/weekly/sales)
// 	starting_items = list(/obj/item/weapon/storage/toolbox/mechanical/filled = 1, /obj/item/stack/cable_coil/thirty = 1, /obj/item/weapon/stock_parts/matter_bin = 3, /obj/item/weapon/stock_parts/micro_laser = 4, /obj/item/weapon/stock_parts/console_screen = 1, /obj/item/modular_computer/pda = 1, /obj/item/weapon/circuitboard/fabricator/genfab = 1, /obj/item/weapon/circuitboard/telepad = 1, /obj/item/stack/material/steel/ten = 2, /obj/item/stack/material/glass/ten = 2, /obj/item/device/camera = 2, /obj/item/weapon/paper_bin = 1, /obj/item/weapon/pen = 2)

// /datum/business_spec/social/religion
// 	name = "Religion"
// 	desc = "The Religion specialization presumes this organization will represent a religion. You can hold plan and hold events using the mass-email and scheduling systems for your congregation. You have access to the costume fabricator to make religious clothing."
// 	limits = /datum/machine_limits/social/spec/religion

// /datum/business_spec/social/club
// 	name = "Club"
// 	desc = "The club specialization is for organizations like political parties, artists guilds or other social groups. Use the unique programs to plan and hold events. You have access to an accessory fabricator to make unique accoutrements for your members."
// 	limits = /datum/machine_limits/social/spec/club
