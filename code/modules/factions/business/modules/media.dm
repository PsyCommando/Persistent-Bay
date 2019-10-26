// /datum/business_module/media
// 	cost = 1100
// 	name = "Media"
// 	desc = "Media companies have simple production and tech capacities but exclusive access to programs that can publish books and news articles for paid redistribution. It is also much less expensive than other types, making it a good choice for generic business."
// 	levels = list(/datum/machine_limits/media/one, /datum/machine_limits/media/two, /datum/machine_limits/media/three, /datum/machine_limits/media/four)
// 	specs = list(/datum/business_spec/media/journalism, /datum/business_spec/media/bookpublishing)
// 	hourly_objectives = list(/datum/module_objective/hourly/employees, /datum/module_objective/hourly/revenue, /datum/module_objective/hourly/sales)
// 	daily_objectives = list(/datum/module_objective/daily/employees, /datum/module_objective/daily/revenue, /datum/module_objective/daily/sales)
// 	weekly_objectives = list(/datum/module_objective/weekly/employees, /datum/module_objective/weekly/revenue, /datum/module_objective/weekly/sales)
// 	starting_items = list(/obj/item/weapon/storage/toolbox/mechanical/filled = 1, /obj/item/stack/cable_coil/thirty = 1, /obj/item/weapon/stock_parts/matter_bin = 3, /obj/item/weapon/stock_parts/micro_laser = 4, /obj/item/weapon/stock_parts/console_screen = 1, /obj/item/modular_computer/pda = 1, /obj/item/weapon/circuitboard/fabricator/genfab = 1, /obj/item/weapon/circuitboard/telepad = 1, /obj/item/stack/material/steel/ten = 2, /obj/item/stack/material/glass/ten = 2, /obj/item/device/camera = 2, /obj/item/weapon/paper_bin = 1, /obj/item/weapon/pen = 2)

// /datum/business_spec/media/journalism
// 	name = "Journalism"
// 	desc = "Specializing in Journalism gives capacity for an EVA fabricator and shuttle, plus a medical fabricator with basic medical tech limitation. Explore every corner of Nexus-space, but best to carry basic medical supplies."
// 	limits = /datum/machine_limits/media/spec/journalism
// 	hourly_objectives = list(/datum/module_objective/hourly/publish_article)
// 	daily_objectives = list(/datum/module_objective/daily/article_viewers)
// 	weekly_objectives = list(/datum/module_objective/weekly/article_viewers)

// /datum/business_spec/media/bookpublishing
// 	name = "Publishing"
// 	desc = "The Publishing specialization grants 200 extra tiles to the area limit and an engineering fabricator and tech limit. You can build a proper library and publishing house, or perhaps some other artistic facility."
// 	limits = /datum/machine_limits/media/spec/bookpublishing
// 	hourly_objectives = list(/datum/module_objective/hourly/publish_book)
// 	daily_objectives = list(/datum/module_objective/daily/publish_book)
// 	weekly_objectives = list(/datum/module_objective/weekly/publish_book)
