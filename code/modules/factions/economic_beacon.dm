/obj/machinery/economic_beacon
	name = "Economic Beacon"
	anchored = 1
	var/datum/world_faction/holder
	var/holder_uid

	var/list/connected_orgs = list()
	var/list/connected_orgs_uids = list()
	var/completed_objectives = 0
