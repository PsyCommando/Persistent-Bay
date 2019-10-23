//Faction for nexus citizens
/obj/faction_spawner/democratic/Nexus
	name 			= "Nexus City Government"
	name_short 		= "Nexus"
	name_tag 		= "NX"
	uid 			= NEXUS_FACTION_CITIZEN
	password 		= ""
	network_name 	= "NEXUSGOV-NET"//"NexusNet"
	network_uid 	= "nx_net"
	purpose 		= "To represent the citizenship of Nexus and keep the station operating."
	starter_outfit	= /decl/hierarchy/outfit/nexus/citizen

	//Mapper helpers
	icon 			= 'icons/misc/map_helpers.dmi'
	icon_state 		= "faction"

//Null faction
/obj/faction_spawner/Freemen
	name 			= "None"
	name_short 		= "None"
	name_tag 		= "NO"
	uid 			= NEXUS_FACTION_RESIDENT
	password 		= ""
	network_name 	= "FreeNet"
	network_uid 	= "free_net"
	starter_outfit	= /decl/hierarchy/outfit/nexus/starter

	//Mapper helpers
	icon 			= 'icons/misc/map_helpers.dmi'
	icon_state 		= "faction"

/proc/spawn_nexus_gov()
	var/datum/world_faction/democratic/nexus = new()
	nexus.name = "Nexus City Government"
	nexus.abbreviation = "NEXUS"
	nexus.short_tag = "NEX"
	nexus.purpose = "To represent the citizenship of Nexus and keep the station operating."
	nexus.uid = "nexus"
	nexus.gov = new()
	var/datum/election/gov/gov_elect = new()
	gov_elect.ballots |= nexus.gov

	nexus.waiting_elections |= gov_elect

	var/datum/election/council_elect = new()
	var/datum/democracy/councillor/councillor1 = new()
	councillor1.title = "Councillor of Justice and Criminal Matters"
	nexus.city_council |= councillor1
	council_elect.ballots |= councillor1

	var/datum/democracy/councillor/councillor2 = new()
	councillor2.title = "Councillor of Budget and Tax Measures"
	nexus.city_council |= councillor2
	council_elect.ballots |= councillor2

	var/datum/democracy/councillor/councillor3 = new()
	councillor3.title = "Councillor of Commerce and Business Relations"
	nexus.city_council |= councillor3
	council_elect.ballots |= councillor3

	var/datum/democracy/councillor/councillor4 = new()
	councillor4.title = "Councillor for Culture and Ethical Oversight"
	nexus.city_council |= councillor4
	council_elect.ballots |= councillor4

	var/datum/democracy/councillor/councillor5 = new()
	councillor5.title = "Councillor for the Domestic Affairs"
	nexus.city_council |= councillor5
	council_elect.ballots |= councillor5

	nexus.waiting_elections |= council_elect

	nexus.network.name = "NEXUSGOV-NET"
	nexus.network.net_uid = "nexus"
	nexus.network.password = ""
	nexus.network.invisible = 0

	LAZYDISTINCTADD(GLOB.all_world_factions, nexus)