//Keeps details on the cryonet the character despawned into
/datum/saved_cryonet_details
	var/cryonet_faction_uid 						//Set to the name of the faction owning the cryo network. If personal, can be null.
	var/cryonet_name								//Set to the name of the sub-network. If null will spawn in only machines that have a null subnet.. Or the last resort spawn

	proc/Clone()
		var/datum/saved_cryonet_details/details = new()
		details.cryonet_name = src.cryonet_name
		details.cryonet_faction_uid = src.cryonet_faction_uid
		return details

/mob
	var/spawn_type = CHARACTER_SPAWN_TYPE_CRYONET // 1 = cryobed, 2 = newplayer spawn, 3 = lace storage... this should be set to 2 for new players
	var/datum/saved_cryonet_details/saved_cryonet

	var/riding = 0 //That's a terrible variable

/mob/proc/finishLoadCharacter()
	return

/mob/living/carbon/human/finishLoadCharacter()
	if(spawn_type == CHARACTER_SPAWN_TYPE_FRONTIER_BEACON)
		//We want to clear the now useless backpack setup object
		QDEL_NULL(backpack_setup)
	..()

//Cryo Callbacks
/mob/proc/OnCryo(var/obj/machinery/cryopod/cryo)
	QDEL_NULL(saved_cryonet)
	saved_cryonet = new()
	saved_cryonet.cryonet_faction_uid = cryo.faction_uid
	saved_cryonet.cryonet_name = cryo.network
	loc = cryo

	//Clear mind stuff
	if(mind)
		if(mind.assigned_job)
			mind.assigned_job.clear_slot()

		if(mind.objectives.len)
			mind.objectives = null
			mind.special_role = null
	
	

/mob/proc/OnUnCryo(var/obj/machinery/cryopod/cryo)
	QDEL_NULL(saved_cryonet)
