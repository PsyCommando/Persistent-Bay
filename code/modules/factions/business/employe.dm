/datum/employee_data
	var/name = "" // real_name of the employee
	var/job_title = "New Hire"
	var/pay_rate = 25 // hourly rate of pay
	var/list/accesses = list()
	var/expense_limit = 0
	var/expenses = 0

/datum/world_faction/business/get_assignment(var/assignment, var/real_name)
	if(real_name == leader_name)
		return CEO
	return ..()