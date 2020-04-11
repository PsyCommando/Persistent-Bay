/*
	Helper for editing custom faction accesses.
*/
/datum/access
	var/faction_uid = ""
	// var/id = ""
	// var/desc = ""

/datum/access/dd_SortValue()
	return "[faction_uid][access_type][desc]"

/datum/world_faction/proc/get_access(var/real_name)
	var/datum/computer_file/report/crew_record/faction/R = src.get_record(real_name)
	if(!R)
		return 0
	var/datum/assignment/A = get_assignment(R.get_assignment_uid(), real_name)
	if(!A)
		return 0
	return A?.allowed_access
	// var/datum/accesses/access = assignment.accesses[record.get_rank()]
	// if(!access)
	// 	return 0
	// return access.accesses

//Returns a named list of all the custom accesses defined for the faction
/datum/world_faction/proc/get_all_accesses()
	return accesses

//Returns a list of list with all the fields of the each access, mainly for displaying in a ui
/datum/world_faction/proc/get_all_accesses_for_ui()
	var/list/data = list()
	for(var/key in accesses)
		var/datum/access/A = accesses[key]
		if(isnull(A))
			continue
		data["id"] = A.id
		data["desc"] = A.desc
	return