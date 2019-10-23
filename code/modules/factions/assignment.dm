/datum/assignment
	var/name = ""
	var/list/accesses[0]
	var/uid = ""
	var/datum/assignment_category/parent
	var/payscale = 1.0
	var/list/ranks = list() // format-- list("Apprentice Engineer (2)" = "1.1", "Journeyman Engineer (3)" = "1.2")
	var/duty_able = 1
	var/cryo_net = "default"
	var/any_assign = 0 // this makes it so that the assignment can be assigned by anyone with the reassignment access,

	var/task
	var/edit_authority = 1
	var/authority_restriction = 1

/datum/assignment/New(var/title, var/pay)
	if(title && pay)
		var/datum/accesses/access = new()
		access.name = title
		access.pay = pay
		accesses |= access

/datum/assignment/proc/get_title(var/rank)
	if(!rank)	rank = 1
	if(!accesses.len)
		message_admins("broken assignment [src.uid]")
		return "BROKEN"
	if(accesses.len < rank)
		var/datum/accesses/access = accesses[accesses.len]
		return access.name
	else
		var/datum/accesses/access = accesses[rank]
		return access.name

/datum/assignment/proc/get_pay(var/rank)
	if(!rank)	rank = 1
	if(!accesses.len)
		message_admins("broken assignment [src.uid]")
		return 0
	if(accesses.len < rank)
		var/datum/accesses/access = accesses[accesses.len]
		return access.pay
	else
		var/datum/accesses/access = accesses[rank]
		return access.pay

/datum/assignment_category
	var/name = ""
	var/list/assignments = list()
	var/datum/assignment/head_position
	var/datum/world_faction/parent
	var/command_faction = 0
	var/member_faction = 1
	var/account_status = 0
	var/datum/money_account/account

/datum/assignment_category/proc/create_account()
	account = create_account(name, 0)





/datum/world_faction/proc/rebuild_all_assignments()
	all_assignments = list()
	for(var/datum/assignment_category/assignment_category in assignment_categories)
		for(var/x in assignment_category.assignments)
			all_assignments |= x

/datum/world_faction/proc/get_assignment(var/assignment, var/real_name)
	if(!assignment) return null
	rebuild_all_assignments()
	for(var/datum/assignment/assignmentt in all_assignments)
		if(assignmentt.uid == assignment) return assignmentt