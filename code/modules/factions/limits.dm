// /datum/machine_limits
// 	var/cost = 0 // used when this serves as a business level datum

// 	var/limit_genfab = 0
// 	var/list/genfabs = list()
// 	var/limit_engfab = 0
// 	var/list/engfabs = list()
// 	var/limit_medicalfab = 0
// 	var/list/medicalfabs = list()
// 	var/limit_mechfab = 0
// 	var/list/mechfabs = list()
// 	var/limit_voidfab = 0
// 	var/list/voidfabs = list()
// 	var/limit_ataccessories = 0
// 	var/list/ataccessories = list()
// 	var/limit_atnonstandard = 0
// 	var/list/atnonstandards = list()
// 	var/limit_atstandard = 0
// 	var/list/atstandards = list()
// 	var/limit_ammofab = 0
// 	var/list/ammofabs = list()
// 	var/limit_consumerfab = 0
// 	var/list/consumerfabs = list()
// 	var/limit_servicefab = 0
// 	var/list/servicefabs = list()

// 	var/limit_drills = 0
// 	var/list/drills = list()

// 	var/limit_botany = 0
// 	var/list/botany = list()

// 	var/limit_shuttles = 0
// 	var/list/shuttles = list()

// 	var/limit_area = 0
// 	var/list/apcs = list()
// 	var/claimed_area = 0


// 	var/limit_tcomms = 0
// 	var/list/tcomms = list()



// 	var/limit_tech_general = 0
// 	var/limit_tech_engi = 0
// 	var/limit_tech_medical = 0
// 	var/limit_tech_consumer = 0
// 	var/limit_tech_combat = 0


// 	var/desc = ""

// /datum/world_faction/business/get_limits()
// 	rebuild_limits()
// 	return limits

// /datum/world_faction/proc/rebuild_limits()
// 	return

// /datum/machine_limits/democracy
// 	limit_genfab = 5
// 	limit_engfab = 5
// 	limit_medicalfab = 5
// 	limit_mechfab = 5
// 	limit_voidfab = 5
// 	limit_ataccessories = 5
// 	limit_atnonstandard = 5
// 	limit_atstandard = 5
// 	limit_ammofab = 5
// 	limit_consumerfab = 5
// 	limit_servicefab = 5
// 	limit_drills = 5
// 	limit_botany = 10
// 	limit_shuttles = 10
// 	limit_area = 200000 //size of the nexus at most 3z levels of 255x255
// 	limit_tcomms = 5
// 	limit_tech_general = 4
// 	limit_tech_engi = 4
// 	limit_tech_medical = 4
// 	limit_tech_consumer = 4
// 	limit_tech_combat = 4




// // ENGINEERING LIMITS

// /datum/machine_limits/eng/spec/tcomms
// 	limit_tcomms = 3
// 	limit_shuttles = 2
// 	limit_voidfab = 1

// /datum/machine_limits/eng/spec/realestate
// 	cost = 0
// 	limit_tech_consumer = 2
// 	limit_area = 400
// 	limit_consumerfab = 1

// /datum/machine_limits/eng/one
// 	limit_tech_engi = 2
// 	limit_tech_general = 1
// 	limit_shuttles = 1
// 	limit_area = 300
// 	limit_genfab = 2
// 	limit_engfab = 2
// 	limit_tcomms = 1
// 	limit_voidfab = 1


// /datum/machine_limits/eng/two
// 	cost = 1000
// 	limit_tech_engi = 3
// 	limit_tech_general = 2
// 	limit_shuttles = 1
// 	limit_area = 400
// 	limit_genfab = 3
// 	limit_engfab = 3
// 	limit_voidfab = 1
// 	limit_tcomms = 1
// 	desc = "Increase area size, tech levels and add an extra to engineering and general fabricator limit."

// /datum/machine_limits/eng/three
// 	cost = 3000
// 	limit_tech_engi = 4
// 	limit_tech_general = 3
// 	limit_shuttles = 2
// 	limit_area = 500
// 	limit_genfab = 4
// 	limit_engfab = 4
// 	limit_voidfab = 2
// 	limit_tcomms = 2
// 	desc = "Increase area size, tech levels and adds an extra shuttle, telecomms machine and extra fabricators."

// /datum/machine_limits/eng/four
// 	cost = 7500
// 	limit_tech_engi = 4
// 	limit_tech_general = 4
// 	limit_tech_medical = 1
// 	limit_tech_consumer = 1
// 	limit_shuttles = 3
// 	limit_area = 600
// 	limit_genfab = 5
// 	limit_engfab = 5
// 	limit_voidfab = 3
// 	limit_tcomms = 3
// 	limit_consumerfab = 1
// 	limit_medicalfab = 1
// 	desc = "Gain final tech levels, area limit, extra fabricators plus gain an extra shuttle and a medical fabricator."
// // END ENGINEERING LIMITS

// // RETAIL LIMITS

// /datum/machine_limits/retail/spec/combat
// 	limit_tech_combat = 2
// 	limit_ammofab = 1
// 	limit_shuttles = 1
// /datum/machine_limits/retail/spec/bigstore
// 	limit_tech_engi = 2
// 	limit_engfab = 1
// 	limit_voidfab = 1
// 	limit_area = 200

// /datum/machine_limits/retail/one
// 	limit_tech_consumer = 2
// 	limit_tech_general = 1
// 	limit_area = 200
// 	limit_genfab = 2
// 	limit_consumerfab = 2
// 	limit_ataccessories = 1
// 	limit_atstandard = 1
// 	limit_atnonstandard = 1


// /datum/machine_limits/retail/two
// 	cost = 1000
// 	limit_tech_consumer = 3
// 	limit_tech_general = 2
// 	limit_area = 300
// 	limit_genfab = 3
// 	limit_consumerfab = 3
// 	limit_ataccessories = 2
// 	limit_atstandard = 2
// 	limit_atnonstandard = 2
// 	desc = "Increase area size, tech levels and add an extra to many fabricator limits."



// /datum/machine_limits/retail/three
// 	cost = 3000
// 	limit_tech_consumer = 4
// 	limit_tech_general = 3
// 	limit_tech_combat = 1
// 	limit_tech_engi = 1
// 	limit_area = 400
// 	limit_genfab = 3
// 	limit_consumerfab = 3
// 	limit_ataccessories = 2
// 	limit_atstandard = 2
// 	limit_atnonstandard = 2
// 	limit_voidfab = 1
// 	limit_shuttles = 1
// 	desc = "Increase area size, tech levels, fabricator limits but most importantly adds a shuttle and EVA fabricator."

// /datum/machine_limits/retail/four
// 	cost = 7500
// 	limit_tech_consumer = 4
// 	limit_tech_general = 4
// 	limit_tech_combat = 2
// 	limit_tech_engi = 2
// 	limit_area = 500
// 	limit_genfab = 3
// 	limit_consumerfab = 3
// 	limit_ataccessories = 3
// 	limit_atstandard = 3
// 	limit_atnonstandard = 3
// 	limit_voidfab = 2
// 	limit_shuttles = 2
// 	limit_ammofab = 1
// 	limit_engfab = 1
// 	desc = "Gain final tech levels, area limit, extra fabricators including an engineering and combat fabricator, plus an extra shuttle."

// // END RETAIL LIMITS

// // MEDICAL LIMITS

// /datum/machine_limits/medical/spec/paramedic
// 	limit_voidfab = 1
// 	limit_shuttles = 2

// /datum/machine_limits/medical/spec/pharma
// 	limit_servicefab = 1
// 	limit_botany = 2
// 	limit_area = 200

// /datum/machine_limits/medical/one
// 	limit_tech_medical = 2
// 	limit_tech_general = 1
// 	limit_area = 300
// 	limit_genfab = 2
// 	limit_medicalfab = 2


// /datum/machine_limits/medical/two
// 	cost = 1000
// 	limit_tech_medical = 3
// 	limit_tech_general = 2
// 	limit_area = 400
// 	limit_genfab = 3
// 	limit_medicalfab = 3
// 	limit_voidfab = 1
// 	desc = "Increase area size, tech levels, fabricator limits and gain an EVA equipment fabricator."

// /datum/machine_limits/medical/three
// 	cost = 3000
// 	limit_tech_medical = 4
// 	limit_tech_general = 3
// 	limit_area = 500
// 	limit_genfab = 3
// 	limit_medicalfab = 3
// 	limit_voidfab = 2
// 	limit_shuttles = 1
// 	limit_botany = 1
// 	limit_servicefab = 1
// 	desc = "Increase area size, tech levels, fabricator limits, botany tray, service fabricator, and a shuttle limit."
// /datum/machine_limits/medical/four
// 	cost = 7500
// 	limit_tech_medical = 4
// 	limit_tech_general = 4
// 	limit_area = 600
// 	limit_genfab = 4
// 	limit_medicalfab = 4
// 	limit_voidfab = 3
// 	limit_shuttles = 2
// 	limit_botany = 3
// 	limit_servicefab = 1
// 	desc = "Gain final tech levels, area limit, extra fabricators, botany trays, plus an extra shuttle."
// // END MEDICAL LIMITS

// // SERVICE LIMITS

// /datum/machine_limits/service/spec/culinary
// 	limit_tech_engi = 1
// 	limit_engfab = 1
// 	limit_area = 200

// /datum/machine_limits/service/spec/farmer
// 	limit_botany = 4
// 	limit_atstandard = 1
// 	limit_ataccessories = 1

// /datum/machine_limits/service/one
// 	limit_tech_consumer = 2
// 	limit_tech_general = 1
// 	limit_area = 200
// 	limit_genfab = 2
// 	limit_servicefab = 2
// 	limit_botany = 2

// /datum/machine_limits/service/two
// 	cost = 1250
// 	limit_tech_consumer = 3
// 	limit_tech_general = 2
// 	limit_area = 300
// 	limit_genfab = 3
// 	limit_servicefab = 3
// 	limit_botany = 3
// 	desc = "Increase area size, tech levels, fabricator limits and get an extra botany tray."
// /datum/machine_limits/service/three
// 	cost = 2500
// 	limit_tech_consumer = 4
// 	limit_tech_general = 3
// 	limit_area = 400
// 	limit_genfab = 3
// 	limit_servicefab = 3
// 	limit_botany = 3
// 	limit_voidfab = 1
// 	limit_shuttles = 1
// 	desc = "Increase area size, tech levels, fabricator limits and get an EVA fabricator and shuttle limit."
// /datum/machine_limits/service/four
// 	cost = 5000
// 	limit_tech_consumer = 4
// 	limit_tech_general = 4
// 	limit_tech_medical = 1
// 	limit_tech_engi = 1
// 	limit_area = 500
// 	limit_genfab = 3
// 	limit_servicefab = 3
// 	limit_botany = 4
// 	limit_voidfab = 2
// 	limit_shuttles = 2
// 	limit_engfab = 1
// 	limit_medicalfab = 1
// 	desc = "Gain final tech levels, area limit, extra fabricators including a medical and engineering fabricator, botany trays, plus an extra shuttle."
// // END SERVICE LIMITS

// // MINING LIMITS

// /datum/machine_limits/mining/spec/monsterhunter
// 	limit_tech_medical = 2
// 	limit_medicalfab = 1
// 	limit_area = 200
// 	limit_botany = 2

// /datum/machine_limits/mining/spec/massdrill
// 	limit_tech_engi = 1
// 	limit_engfab = 1
// 	limit_drills = 2
// 	limit_shuttles = 1

// /datum/machine_limits/mining/one
// 	limit_tech_combat = 2
// 	limit_tech_general = 1
// 	limit_area = 200
// 	limit_genfab = 2
// 	limit_ammofab = 2
// 	limit_drills = 1
// 	limit_voidfab = 1
// 	limit_shuttles = 1

// /datum/machine_limits/mining/two
// 	cost = 1000
// 	limit_tech_combat = 3
// 	limit_tech_general = 2
// 	limit_area = 300
// 	limit_genfab = 3
// 	limit_ammofab = 3
// 	limit_drills = 2
// 	limit_voidfab = 2
// 	limit_shuttles = 1
// 	desc = "Increase area size, tech levels, fabricator limits and an extra drill."

// /datum/machine_limits/mining/three
// 	cost = 3000
// 	limit_tech_combat = 4
// 	limit_tech_general = 3
// 	limit_area = 400
// 	limit_genfab = 3
// 	limit_ammofab = 3
// 	limit_drills = 3
// 	limit_voidfab = 3
// 	limit_shuttles = 2
// 	limit_botany = 1
// 	desc = "Increase area size, tech levels, fabricators, drills, and adds a botany tray plus an extra shuttle."

// /datum/machine_limits/mining/four
// 	cost = 7500
// 	limit_tech_combat = 4
// 	limit_tech_general = 4
// 	limit_tech_engi = 1
// 	limit_tech_medical = 1
// 	limit_area = 500
// 	limit_genfab = 3
// 	limit_ammofab = 3
// 	limit_drills = 4
// 	limit_voidfab = 3
// 	limit_shuttles = 3
// 	limit_botany = 2
// 	limit_engfab = 1
// 	limit_medicalfab = 1
// 	desc = "Gain final tech levels, area limit, extra fabricators including a medical and engineering fabricator, botany trays, drills plus an extra shuttle."


// // END MINING LIMITS


// // MEDIA LIMITS

// /datum/machine_limits/media/spec/journalism
// 	limit_voidfab = 1
// 	limit_shuttles = 1
// 	limit_tech_medical = 1
// 	limit_medicalfab = 1

// /datum/machine_limits/media/spec/bookpublishing
// 	limit_tech_engi = 1
// 	limit_engfab = 1
// 	limit_area = 200

// /datum/machine_limits/media/one
// 	limit_tech_consumer = 1
// 	limit_tech_general = 1
// 	limit_area = 200
// 	limit_genfab = 2
// 	limit_consumerfab = 1

// /datum/machine_limits/media/two
// 	cost = 750
// 	limit_tech_consumer = 2
// 	limit_tech_general = 2
// 	limit_area = 300
// 	limit_genfab = 3
// 	limit_consumerfab = 2
// 	desc = "Increase area size, tech levels and fabricator limits."
// /datum/machine_limits/media/three
// 	cost = 1600
// 	limit_tech_consumer = 3
// 	limit_tech_general = 3
// 	limit_area = 400
// 	limit_genfab = 3
// 	limit_consumerfab = 2
// 	desc = "Increase area size, tech levels and fabricator limits."
// /datum/machine_limits/media/four
// 	cost = 3200
// 	limit_tech_consumer = 4
// 	limit_tech_general = 4
// 	limit_area = 500
// 	limit_genfab = 3
// 	limit_consumerfab = 2
// 	limit_shuttles = 1
// 	desc = "Gain final tech levels, area limit, fabricators and a shuttle."


// // END MEDIA LIMITS

// // SOCIAL LIMITS

// /datum/machine_limits/social/spec/religion
// 	limit_engfab = 1
// 	limit_servicefab = 1
// 	limit_atnonstandard = 1

// /datum/machine_limits/social/spec/club
// 	limit_voidfab = 1
// 	limit_shuttles = 1
// 	limit_ataccessories = 1

// /datum/machine_limits/social/one
// 	limit_tech_consumer = 1
// 	limit_tech_general = 1
// 	limit_area = 200
// 	limit_genfab = 2
// 	limit_consumerfab = 1

// /datum/machine_limits/social/two
// 	cost = 750
// 	limit_tech_consumer = 2
// 	limit_tech_general = 2
// 	limit_area = 300
// 	limit_genfab = 3
// 	limit_consumerfab = 2
// 	desc = "Increase area size, tech levels and fabricator limits."
// /datum/machine_limits/social/three
// 	cost = 1600
// 	limit_tech_consumer = 3
// 	limit_tech_general = 3
// 	limit_area = 400
// 	limit_genfab = 3
// 	limit_consumerfab = 2
// 	desc = "Increase area size, tech levels and fabricator limits."
// /datum/machine_limits/social/four
// 	cost = 3200
// 	limit_tech_consumer = 4
// 	limit_tech_general = 4
// 	limit_area = 500
// 	limit_genfab = 3
// 	limit_consumerfab = 2
// 	limit_shuttles = 1
// 	desc = "Gain final tech levels, area limit, fabricators and a shuttle."
// // END SOCIAL LIMITS

// // SCIENCE LIMITS

// /datum/machine_limits/science/spec/practical
// 	limit_engfab = 1
// 	limit_area = 200
// /datum/machine_limits/science/spec/theory
// 	limit_voidfab = 1
// 	limit_shuttles = 1
// /datum/machine_limits/science/one
// 	limit_tech_consumer = 2
// 	limit_tech_general = 2
// 	limit_tech_combat = 2
// 	limit_tech_medical = 2
// 	limit_tech_engi = 2
// 	limit_area = 200
// 	limit_genfab = 2
// 	limit_medicalfab = 1
// 	limit_servicefab = 1
// 	limit_botany = 2

// /datum/machine_limits/science/two
// 	cost = 1250
// 	limit_tech_consumer = 3
// 	limit_tech_general = 3
// 	limit_tech_combat = 3
// 	limit_tech_medical = 3
// 	limit_area = 300
// 	limit_genfab = 2
// 	limit_servicefab = 2
// 	limit_medicalfab = 2
// 	limit_botany = 3
// 	desc = "Increase area size, tech levels, fabricator limits and get an extra botany tray."
// /datum/machine_limits/science/three
// 	cost = 2500
// 	limit_tech_consumer = 4
// 	limit_tech_general = 4
// 	limit_tech_combat = 4
// 	limit_tech_medical = 4
// 	limit_area = 400
// 	limit_genfab = 3
// 	limit_servicefab = 3
// 	limit_botany = 3
// 	limit_voidfab = 1
// 	limit_medicalfab = 2
// 	limit_shuttles = 1
// 	desc = "Increase area size, tech levels, fabricator limits and get an EVA fabricator and shuttle limit."
// /datum/machine_limits/science/four
// 	cost = 5000
// 	limit_tech_consumer = 5
// 	limit_tech_general = 5
// 	limit_tech_combat = 5
// 	limit_tech_medical = 5
// 	limit_area = 500
// 	limit_genfab = 3
// 	limit_servicefab = 3
// 	limit_botany = 4
// 	limit_voidfab = 2
// 	limit_shuttles = 2
// 	limit_engfab = 1
// 	limit_medicalfab = 2
// 	desc = "Gain final tech levels, area limit, extra fabricators including a medical and engineering fabricator, botany trays, plus an extra shuttle."
// // END SCIENCE LIMITS
