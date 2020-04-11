
// /datum/spawnpoint/faction/beacon/New(var/faction_uid)
// 	. = ..()
// 	src.assigned_faction_uid = faction_uid
// 	var/datum/world_faction/F = FindFaction(faction_uid)
// 	if(!F)
// 		assigned_faction_uid = null
// 		return //Skip adding to list if the faction doesn't exist
// 	if(!GLOB.faction_spawnpoints_beacons)
// 		GLOB.faction_spawnpoints_beacons = list()
// 	GLOB.faction_spawnpoints_beacons[assigned_faction_uid] = src
// 	update_spawn_turfs()

// /datum/spawnpoint/faction/beacon/Destroy()
// 	if(GLOB.faction_spawnpoints_beacons)
// 		GLOB.faction_spawnpoints_beacons[assigned_faction_uid] = null
// 	return ..()

// /datum/spawnpoint/faction/beacon/proc/update_spawn_turfs()
// 	if(!assigned_faction_uid)
// 		return
// 	turfs.Cut()
// 	for(var/obj/machinery/frontier_beacon/B in GLOB.frontierbeacons)
// 		if(B && B.loc && B.faction_uid == assigned_faction_uid)
// 			turfs += B

GLOBAL_VAR(faction_spawn_types)
/proc/get_faction_spawn_types()
	if(!GLOB.faction_spawn_types)
		GLOB.faction_spawn_types = list()
		for(var/types in typesof(/datum/spawnpoint/faction)-/datum/spawnpoint/faction)
			var/datum/spawnpoint/faction/S = types
			var/display_name = initial(S.display_name)
			if((display_name in GLOB.using_map.allowed_spawns) || initial(S.always_visible))
				GLOB.faction_spawn_types[display_name] = new S
	return GLOB.faction_spawn_types

/*
	Definition for a job meant to identify a spawn context for new characters.
	After Spawn the job is cleared.
*/
/datum/job/spawnonly
	title = "citizen"
	latejoin_at_spawnpoints = FALSE //We always latejoin in persistence mode
	create_record = TRUE

//This returns a spawnpoint datum containing all the possible turfs that can be spawned on
/datum/job/spawnonly/get_spawnpoint(var/client/C)
	if(!C)
		CRASH("Null client passed to get_spawnpoint_for() proc!")

	var/mob/H = C.mob
	//var/spawnpoint = C.prefs.spawnpoint //Prefered spawnpoint name/ID picked in char creation panel
	var/faction_uid = C.prefs.starting_faction_uid
	var/datum/spawnpoint/faction/spawnpos = ..()

	//A little hack here to override the default behavior of spawnpoints
	//Since bay always assume they're setup once, ever. But we need to re-evaluate on each spawn
	if(istype(spawnpos, /datum/spawnpoint/faction))
		. = spawnpos.get_spawnpoint_with_turfs(H, faction_uid)

//We need to check according to the starting faction
/datum/job/is_available(var/client/caller)
	. = ..()
	if(!. || !caller.prefs)
		return .
	var/datum/world_faction/F = FindFaction(caller.prefs.starting_faction_uid)
	if(!F)
		return FALSE
	var/list/beacons = GetFactionFrontierBeacons(F.uid)
	if(!F.isNewPlayerSpawningAllowed() || !beacons || !LAZYLEN(beacons))
		return FALSE

/datum/job/get_unavailable_reasons(var/client/caller)
	var/list/reasons = ..()
	var/datum/world_faction/F = FindFaction(caller.prefs.starting_faction_uid)
	var/list/beacons = GetFactionFrontierBeacons(F.uid)
	if(!F)
		reasons["No valid starting faction selected!"] = TRUE
	if(!F.isNewPlayerSpawningAllowed())
		reasons["The selected faction has disallowed new player spawning!"] = TRUE
	if(!beacons || !LAZYLEN(beacons))
		reasons["The selected faction has all its arrival teleporters deactivated!"] = TRUE
	if(LAZYLEN(reasons))
		. = reasons

/datum/job/setup_account(var/mob/living/carbon/human/H)
	. = ..()

