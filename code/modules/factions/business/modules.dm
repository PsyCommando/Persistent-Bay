// /datum/business_module
// 	var/cost = 750
// 	var/name = ""
// 	var/desc = ""
// 	var/current_level = 1
// 	var/list/levels = list()
// 	var/datum/business_spec/spec
// 	var/list/specs = list()

// 	var/list/hourly_objectives = list()
// 	var/list/daily_objectives = list()
// 	var/list/weekly_objectives = list()

// 	var/list/starting_items = list()

// /datum/business_module/New()
// 	var/list/specs_c = specs.Copy()
// 	specs = list()
// 	for(var/x in specs_c)
// 		specs |= new x()
// 	var/list/levels_c = levels.Copy()
// 	levels = list()
// 	for(var/x in levels_c)
// 		levels |= new x()
