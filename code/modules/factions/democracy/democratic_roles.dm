//-------------------------------------
// Governor
//-------------------------------------
/datum/democracy/governor
	title = "Governor"
	description = "Manage the executive government by creating assignments, ranks and accesses while publishing executive policy documents. Nominate Judges."

//-------------------------------------
// Councillor
//-------------------------------------
/datum/democracy/councillor

//-------------------------------------
// Judge
//-------------------------------------
/datum/democracy/judge
	title = "Judge"


/datum/world_faction/democratic/get_assignment(var/assignment, var/real_name)
	if(is_judge(real_name))
		return judge_assignment
	if(is_councillor(real_name))
		return councillor_assignment
	if(is_governor(real_name))
		return governor_assignment
	return ..()