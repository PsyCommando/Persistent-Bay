GLOBAL_LIST_EMPTY(all_business)

//-------------------------------
// Business Access
//-------------------------------
/proc/get_business(var/name)
	var/datum/small_business/found_faction
	for(var/datum/small_business/fac in GLOB.all_business)
		if(fac.name == name)
			found_faction = fac
			break
	return found_faction

/proc/get_businesses(var/real_name)
	var/list/lis = list()
	for(var/datum/small_business/fac in GLOB.all_business)
		if(fac.is_allowed(real_name)) lis |= fac
	return lis

//-------------------------------
// Business state handling
//-------------------------------
/datum/world_faction/proc/open_business()
	status = 1

/datum/world_faction/proc/close_business()
	for(var/obj/item/organ/internal/stack/stack in connected_laces)
		if(stack.owner)
			to_chat(stack.owner, "Your neural lace vibrates letting you know that [src.name] is closed for business and you have been automatically clocked out.")
		if(employment_log.len > 100)
			employment_log.Cut(1,2)
		employment_log += "At [stationdate2text()] [stationtime2text()] [stack.owner.real_name] clocked out."
	connected_laces.Cut()
	status = 0

//-------------------------------
// Business faction
//-------------------------------
/datum/world_faction/business
	var/datum/business_module/module
	var/list/stock_holders = list()
	var/datum/assignment/CEO
	var/list/proposals = list()

	var/ceo_tax = 0
	var/stockholder_tax = 0
	var/public_stock = 0

	var/datum/module_objective/hourly_objective
	var/hourly_assigned = 0
	var/datum/module_objective/daily_objective
	var/daily_assigned = 0
	var/datum/module_objective/weekly_objective
	var/weekly_assigned = 0

	var/commission = 0
	var/PriorityQueue/buyorders
	var/PriorityQueue/sellorders
	var/stock_sales = 0 // stock sales this hour
	var/list/stock_sales_data = list() // stock sales in the past 24 hours

/datum/world_faction/business/New()
	..()
	CEO = new()
	feed = new()
	library = new()
	buyorders = new /PriorityQueue(/proc/cmp_buyorders_stock)
	sellorders = new /PriorityQueue(/proc/cmp_sellorders_stock)

/datum/world_faction/business/after_load()
	if(CEO)
		if(!CEO.accesses.len)
			var/datum/accesses/access = new()
			access.name = "CEO"
			access.pay = 45
			access.expense_limit = 10000000
			CEO.accesses |= access
		else
			var/datum/accesses/access = CEO.accesses[1]
			access.expense_limit = 10000000
	..()

/datum/world_faction/business/proc/get_ceo_wage()
	return CEO.get_pay(1)

/datum/world_faction/business/proc/get_ceo()
	if(!leader_name || leader_name == "") return "**NONE**"
	return leader_name











