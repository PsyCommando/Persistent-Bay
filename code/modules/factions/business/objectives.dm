/datum/module_objective
	var/name = "Objective name"
	var/payout = 0 // how much to pay upon completion
	var/research_payout = 0 // ho many research points to award

	var/filled = 0 // how much has been provided of whatever is required
	var/required = 10 // How much of whatever is required to fill the objective

	var/completed = 0 // is the objective completed

	var/list/unique_characters = list() // a list of unique characters for objective tracking
	var/list/unique_factions = list() // a list of unique factions for objective tracking

	var/datum/world_faction/business/parent


/datum/module_objective/proc/check_completion()
	if(completed) return 1
	if(filled >= required)
		completed = 1
		if(parent)
			var/datum/transaction/Te = new("Completed Objective", "Nexus Economic Stimulus", payout, "Nexus Economic Module")
			parent.central_account.do_transaction(Te)
			parent.research.points += research_payout
		return 1

/datum/module_objective/proc/get_status()
	if(completed)
		return "Objective Complete. [payout]$$ and [research_payout] tech has been awarded to the business."
	else
		return "[filled] out of [required] complete."

/datum/module_objective/hourly // these are for every 2 hours
	payout = 250
	research_payout = 100


/datum/module_objective/hourly/visitors
	name = "Have 7 people visit an area controlled by your business and remain for long enough to be counted."
	required = 7

/datum/module_objective/hourly/visitors/check_completion() // special cod to handle vistors compltion
	if(parent) // parent is faction objective is assigned to
		for(var/obj/machinery/power/apc/apc in parent.limits.apcs) // parent.limits.apcs is a list of all apcs connected to the faction, iterate through them
			var/area/A = apc.area // area the apc represents
			if(A)
				for(var/mob/living/carbon/M in A) // all valid mobs (laces and humans) in the area
					if(M.key && !(M.real_name in unique_characters)) // the mob must have a key (a player active) and not be in the unique_characters list
						unique_characters |= M.real_name // add them to list to prevent duplicates
						filled++ // add to filled
	..()


/datum/module_objective/hourly/revenue
	name = "Earn 350$$ in revenue from any source by providing a useful function in the economy."
	required = 350

/datum/module_objective/hourly/employees
	name = "Have 3 employees get paid for productively working."
	required = 3

/datum/module_objective/hourly/cost
	name = "Spend 300$$ out of the business account for useful goods and services."
	required = 300

/datum/module_objective/hourly/sales
	name = "Have 4 people or businesses pay us through an invoice."
	required = 4

/datum/module_objective/hourly/monsters
	name = "Have clocked in employees kill 5 wilderness creatures."
	required = 5

/datum/module_objective/hourly/travel
	name = "Have clocked in employees travel to 2 different wilderness sectors and remain long enough to be counted."
	required = 2

/datum/module_objective/hourly/travel/check_completion()
	if(parent)
		for(var/obj/item/organ/internal/stack/stack in parent.connected_laces)
			var/mob/M = stack.get_owner()
			if(M && M.z > 3 && !("[M.z]" in unique_factions))
				unique_factions |= "[M.z]"
				filled++
	..()
/datum/module_objective/hourly/publish_article
	name = "Publish a quality article in the news feed."
	required = 1

/datum/module_objective/hourly/publish_book
	name = "Add a new book to the library database."
	required = 1

/datum/module_objective/hourly/contract
	name = "Have an individual or organization sign a new contract with us."
	required = 1

/datum/module_objective/hourly/fabricate
	name = "Fabricate 15 items to sell or help us conduct business."
	required = 15


/datum/module_objective/daily
	payout = 650
	research_payout = 400

/datum/module_objective/daily/visitors
	name = "Have 20 people visit an area controlled by your business and remain for long enough to be counted."
	required = 20

/datum/module_objective/daily/visitors/check_completion() // special cod to handle vistors compltion
	if(parent) // parent is faction objective is assigned to
		for(var/obj/machinery/power/apc/apc in parent.limits.apcs) // parent.limits.apcs is a list of all apcs connected to the faction, iterate through them
			var/area/A = apc.area // area the apc represents
			if(A)
				for(var/mob/living/carbon/M in A) // all valid mobs (laces and humans) in the area
					if(M.key && !(M.real_name in unique_characters)) // the mob must have a key (a player active) and not be in the unique_characters list
						unique_characters |= M.real_name // add them to list to prevent duplicates
						filled++ // add to filled
	..()


/datum/module_objective/daily/revenue
	name = "Earn 1100$$ in revenue from any source by providing a useful function in the economy."
	required = 1100

/datum/module_objective/daily/employees
	name = "Have 6 employees get paid for productively working."
	required = 6

/datum/module_objective/daily/cost
	name = "Spend 1000$$ out of the business account for useful goods and services."
	required = 1000

/datum/module_objective/daily/sales
	name = "Have 10 people or businesses pay us through an invoice."
	required = 10

/datum/module_objective/daily/monsters
	name = "Have 25 wilderness creatures die in proximity to a clocked in employee."
	required = 25

/datum/module_objective/daily/travel
	name = "Have clocked in employees travel to 4 different wilderness sectors and remain long enough to be counted."
	required = 4


/datum/module_objective/daily/travel/check_completion()
	if(parent)
		for(var/obj/item/organ/internal/stack/stack in parent.connected_laces)
			var/mob/M = stack.get_owner()
			if(M && M.z > 3 && !("[M.z]" in unique_factions))
				unique_factions |= "[M.z]"
				filled++
	..()

/datum/module_objective/daily/article_viewers
	name = "Have 15 unique viewers for articles in your news feed."
	required = 15

/datum/module_objective/daily/publish_book
	name = "Add 3 books printed by seperate individuals to the library database."
	required = 3

/datum/module_objective/daily/contract
	name = "Have 2 individuals or organizations sign new contracts with us."
	required = 2

/datum/module_objective/daily/fabricate
	name = "Fabricate 40 items to sell or help us conduct business."
	required = 40


/datum/module_objective/weekly
	payout = 1200
	research_payout = 1000

/datum/module_objective/weekly/visitors
	name = "Have 60 people visit an area controlled by your business and remain for long enough to be counted."
	required = 60

/datum/module_objective/weekly/visitors/check_completion() // special cod to handle vistors compltion
	if(parent) // parent is faction objective is assigned to
		for(var/obj/machinery/power/apc/apc in parent.limits.apcs) // parent.limits.apcs is a list of all apcs connected to the faction, iterate through them
			var/area/A = apc.area // area the apc represents
			if(A)
				for(var/mob/living/carbon/M in A) // all valid mobs (laces and humans) in the area
					if(M.key && !(M.real_name in unique_characters)) // the mob must have a key (a player active) and not be in the unique_characters list
						unique_characters |= M.real_name // add them to list to prevent duplicates
						filled++ // add to filled
	..()


/datum/module_objective/weekly/employees
	name = "Have 12 employees get paid for productively working."
	required = 12

/datum/module_objective/weekly/revenue
	name = "Earn 6500$$ in revenue from any source by providing a useful function in the economy."
	required = 6500


/datum/module_objective/weekly/cost
	name = "Spend 6000$$ out of the business account for useful goods and services."
	required = 6000

/datum/module_objective/weekly/sales
	name = "Have 40 people or businesses pay us through an invoice."
	required = 40

/datum/module_objective/weekly/monsters
	name = "Have 100 wilderness creatures die in proximity to a clocked in employee."
	required = 100

/datum/module_objective/weekly/travel
	name = "Have clocked in employees travel to 8 different wilderness sectors and remain long enough to be counted."
	required = 8

/datum/module_objective/weekly/travel/check_completion()
	if(parent && istype(parent))
		for(var/obj/item/organ/internal/stack/stack in parent.connected_laces)
			var/mob/M = stack.get_owner()
			if(M && M.z > 3 && !("[M.z]" in unique_factions))
				unique_factions |= "[M.z]"
				filled++
	..()

/datum/module_objective/weekly/article_viewers
	name = "Have 40 unique viewers for articles in your news feed."
	required = 40

/datum/module_objective/weekly/publish_book
	name = "Add 7 books printed by seperate individuals to the library database."
	required = 3

/datum/module_objective/weekly/contract
	name = "Have 6 individuals or organizations sign new contracts with us."
	required = 6

/datum/module_objective/weekly/fabricate
	name = "Fabricate 200 items to sell or help us conduct business."
	required = 200

/datum/world_faction/business/proc/assign_hourly_objective()
	var/list/possible = list()
	possible |= module.hourly_objectives
	possible |= module.spec.hourly_objectives
	var/chose_type = pick(possible)
	hourly_objective = new chose_type()
	hourly_objective.parent = src
	hourly_assigned = world.realtime

/datum/world_faction/business/proc/assign_daily_objective()
	var/list/possible = list()
	possible |= module.daily_objectives
	possible |= module.spec.daily_objectives
	var/chose_type = pick(possible)
	daily_objective = new chose_type()
	daily_objective.parent = src
	daily_assigned = world.realtime

/datum/world_faction/business/proc/assign_weekly_objective()
	var/list/possible = list()
	possible |= module.weekly_objectives
	possible |= module.spec.weekly_objectives
	var/chose_type = pick(possible)
	weekly_objective = new chose_type()
	weekly_objective.parent = src
	weekly_assigned = world.realtime


/datum/world_faction/business/proc/revenue_objectives(var/amount) // run this anytime a revenue objective might be filled
	if(istype(hourly_objective, /datum/module_objective/hourly/revenue)) // checks if the hourly objective is a revenue objective
		hourly_objective.filled += amount // fill by the amount
		hourly_objective.check_completion() // check if its done
	if(istype(daily_objective, /datum/module_objective/daily/revenue)) // repeat for daily, weekly
		daily_objective.filled += amount
		daily_objective.check_completion()
	if(istype(weekly_objective, /datum/module_objective/weekly/revenue))
		weekly_objective.filled += amount
		weekly_objective.check_completion()

/datum/world_faction/business/proc/cost_objectives(var/amount) // run this anytime a cost objective might be filled
	if(istype(hourly_objective, /datum/module_objective/hourly/cost)) // checks if the hourly objective is a cost objective
		hourly_objective.filled += amount // fill by the amount
		hourly_objective.check_completion() // check if its done
	if(istype(daily_objective, /datum/module_objective/daily/cost)) // repeat for daily, weekly
		daily_objective.filled += amount
		daily_objective.check_completion()
	if(istype(weekly_objective, /datum/module_objective/weekly/cost))
		weekly_objective.filled += amount
		weekly_objective.check_completion()

/datum/world_faction/business/proc/monster_objectives() // run this anytime a monster objective might be filled
	if(istype(hourly_objective, /datum/module_objective/hourly/monsters))
		hourly_objective.filled++ // fill by one
		hourly_objective.check_completion()
	if(istype(daily_objective, /datum/module_objective/daily/monsters)) // repeat for daily, weekly
		daily_objective.filled++
		daily_objective.check_completion()
	if(istype(weekly_objective, /datum/module_objective/weekly/monsters))
		weekly_objective.filled++
		weekly_objective.check_completion()

/datum/world_faction/business/proc/publish_article_objectives() // run this anytime a publish article objective might be filled
	if(istype(hourly_objective, /datum/module_objective/hourly/publish_article))
		hourly_objective.filled++ // fill by one
		hourly_objective.check_completion()

/datum/world_faction/business/proc/publish_book_objectives(var/real_name) // run this anytime a publish book objective might be filled
	if(istype(hourly_objective, /datum/module_objective/hourly/publish_book))
		hourly_objective.filled++ // fill by one
		hourly_objective.check_completion()
	if(istype(daily_objective, /datum/module_objective/daily/publish_book) && !(real_name in daily_objective.unique_characters)) // repeat for daily, weekly
		daily_objective.filled++
		daily_objective.check_completion()
	if(istype(weekly_objective, /datum/module_objective/weekly/publish_book) && !(real_name in weekly_objective.unique_characters))
		weekly_objective.filled++
		weekly_objective.check_completion()

/datum/world_faction/business/proc/contract_objectives(var/namee, var/sale_type)
	if(istype(hourly_objective, /datum/module_objective/hourly/contract))
		if(sale_type == CONTRACT_PERSON && !(namee in hourly_objective.unique_characters)) //
			hourly_objective.filled++ // increase by one
			hourly_objective.unique_characters |= namee
			hourly_objective.check_completion() // check if its done
		else if(sale_type == CONTRACT_BUSINESS && !(namee in hourly_objective.unique_factions)) //
			hourly_objective.filled++ // increase by one
			hourly_objective.unique_factions |= namee
			hourly_objective.check_completion() // check if its done
	if(istype(daily_objective, /datum/module_objective/daily/contract)) //
		if(sale_type == CONTRACT_PERSON && !(namee in daily_objective.unique_characters)) //
			daily_objective.filled++ // increase by one
			daily_objective.unique_characters |= namee
			daily_objective.check_completion() // check if its done
		else if(sale_type == CONTRACT_BUSINESS && !(namee in daily_objective.unique_factions)) //
			daily_objective.filled++ // increase by one
			daily_objective.unique_factions |= namee
			daily_objective.check_completion() // check if its done
	if(istype(weekly_objective, /datum/module_objective/weekly/contract)) //
		if(sale_type == CONTRACT_PERSON && !(namee in weekly_objective.unique_characters)) //
			weekly_objective.filled++ // increase by one
			weekly_objective.unique_characters |= namee
			weekly_objective.check_completion() // check if its done
		else if(sale_type == CONTRACT_BUSINESS && !(namee in weekly_objective.unique_factions)) //
			weekly_objective.filled++ // increase by one
			weekly_objective.unique_factions |= namee
			weekly_objective.check_completion() // check if its done

/datum/world_faction/business/proc/sales_objectives(var/namee, var/sale_type) // sale_type 1 == character, 2 == business
	if(istype(hourly_objective, /datum/module_objective/hourly/sales))
		if(sale_type == 1 && !(namee in hourly_objective.unique_characters)) // if its a individual sale, check if the name is already used by characters
			hourly_objective.filled++ // increase by one
			hourly_objective.unique_characters |= namee
			hourly_objective.check_completion() // check if its done
		else if(sale_type == 2 && !(namee in hourly_objective.unique_factions)) // if its with another faction, check if its in the list of factions
			hourly_objective.filled++ // increase by one
			hourly_objective.unique_factions |= namee
			hourly_objective.check_completion() // check if its done
	if(istype(daily_objective, /datum/module_objective/daily/sales)) // checks if the hourly objective is a cost objective
		if(sale_type == 1 && !(namee in daily_objective.unique_characters)) // if its a individual sale, check if the name is already used by characters
			daily_objective.filled++ // increase by one
			daily_objective.unique_characters |= namee
			daily_objective.check_completion() // check if its done
		else if(sale_type == 2 && !(namee in daily_objective.unique_factions)) // if its with another faction, check if its in the list of factions
			daily_objective.filled++ // increase by one
			daily_objective.unique_factions |= namee
			daily_objective.check_completion() // check if its done
	if(istype(weekly_objective, /datum/module_objective/weekly/sales)) // checks if the hourly objective is a cost objective
		if(sale_type == 1 && !(namee in weekly_objective.unique_characters)) // if its a individual sale, check if the name is already used by characters
			weekly_objective.filled++ // increase by one
			weekly_objective.unique_characters |= namee
			weekly_objective.check_completion() // check if its done
		else if(sale_type == 2 && !(namee in weekly_objective.unique_factions)) // if its with another faction, check if its in the list of factions
			weekly_objective.filled++ // increase by one
			weekly_objective.unique_factions |= namee
			weekly_objective.check_completion() // check if its done


/datum/world_faction/business/proc/employee_objectives(var/real_name) // run anytime a employee objective might be filled
	if(istype(hourly_objective, /datum/module_objective/hourly/employees)) // check for objective
		if(!(real_name in hourly_objective.unique_characters)) // this means IF the name of the employee IS NOT already used to fill the objective
			hourly_objective.unique_characters |= real_name // put the name in the unique names list to prevent duplicates
			hourly_objective.filled++ // increased filled by 1 (++ increases by 1)
			hourly_objective.check_completion() // check if its done
	if(istype(daily_objective, /datum/module_objective/daily/employees)) // repeat for daily, weekly
		if(!(real_name in daily_objective.unique_characters))
			daily_objective.unique_characters |= real_name
			daily_objective.filled++
			daily_objective.check_completion()
	if(istype(weekly_objective, /datum/module_objective/weekly/employees)) // repeat for daily, weekly
		if(!(real_name in weekly_objective.unique_characters))
			weekly_objective.unique_characters |= real_name
			weekly_objective.filled++
			weekly_objective.check_completion()

/datum/world_faction/business/proc/fabricator_objectives()
	if(istype(hourly_objective, /datum/module_objective/hourly/fabricate))
		hourly_objective.filled++ // fill by one
		hourly_objective.check_completion()
	if(istype(daily_objective, /datum/module_objective/daily/fabricate)) // repeat for daily, weekly
		daily_objective.filled++
		daily_objective.check_completion()
	if(istype(weekly_objective, /datum/module_objective/weekly/fabricate))
		weekly_objective.filled++
		weekly_objective.check_completion()

/datum/world_faction/business/proc/article_view_objectives(var/real_name) // run anytime a employee objective might be filled
	if(istype(daily_objective, /datum/module_objective/daily/article_viewers)) // repeat for daily, weekly
		if(!(real_name in daily_objective.unique_characters))
			daily_objective.unique_characters |= real_name
			daily_objective.filled++
			daily_objective.check_completion()
	if(istype(weekly_objective, /datum/module_objective/weekly/article_viewers)) // repeat for daily, weekly
		if(!(real_name in weekly_objective.unique_characters))
			weekly_objective.unique_characters |= real_name
			weekly_objective.filled++
			weekly_objective.check_completion()