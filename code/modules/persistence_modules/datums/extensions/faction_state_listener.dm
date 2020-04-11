/*
	This extension is for handling faction related events.
	Just add it to anything that should receive signals from the faction and that's it.
*/
/datum/extension/faction_state_listener
	expected_type = /obj

/datum/extension/faction_state_listener/proc/OnFactionClosed(var/faction_uid)
	var/obj/O = src.holder
	return (O?.get_faction_uid()) == faction_uid
	//Override me

/datum/extension/faction_state_listener/proc/OnFactionOpened(var/faction_uid)
	var/obj/O = src.holder
	return (O?.get_faction_uid()) == faction_uid
	//Override me

//
//Override for the objects that receive the signals
//
