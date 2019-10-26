GLOBAL_RAW(/list/datum/world_faction/all_world_factions);GLOBAL_UNMANAGED(all_world_factions, null); //Don't init as empty list, because it happens too late during init

//-------------------------------
// Faction Access
//-------------------------------
/proc/get_faction(var/name, var/password)
	if(password)
		var/datum/world_faction/found_faction
		for(var/datum/world_faction/fac in GLOB.all_world_factions)
			if(fac && fac.uid == name)
				found_faction = fac
				break
		if(!found_faction) return
		if(found_faction.password != password) return
		return found_faction
	var/datum/world_faction/found_faction
	for(var/datum/world_faction/fac in GLOB.all_world_factions)
		if(fac && fac.uid == name)
			found_faction = fac
			break
	return found_faction

/proc/get_faction_tag(var/name)
	var/datum/world_faction/fac = get_faction(name)
	if(fac)
		return fac.short_tag
	else
		return "BROKE"

//-------------------------------
// Faction Define
//-------------------------------
/datum/world_faction
	var/name 						= "" // can be safely changed
	var/abbreviation 				= "" // can be safely changed
	var/short_tag 					= "" // This can be safely changed as long as it doesn't conflict
	var/purpose 					= "" // can be safely changed
	var/uid 						= "" // THIS SHOULD NEVER BE CHANGED!
	var/password					= "password" // this is used to access the faction, can be safely changed
	var/list/assignment_categories 	= list()
	var/list/access_categories		= list()
	var/list/all_access 			= list() // format list("10", "11", "12", "13") used to determine which accesses are already given out.
	var/list/all_assignments
	var/datum/records_holder/records
	var/datum/ntnet/network
	var/datum/money_account/central_account
	var/allow_id_access = 0 // allows access off the ID (the IDs access var instead of directly from faction records, assuming its a faction-approved ID
	var/allow_unapproved_ids = 0 // **THIS VAR NO LONGER MATTERS IDS ARE ALWAYS CONSIDERED APPROVED** allows ids that are not faction-approved or faction-created to still be used to access doors IF THE registered_name OF THE CARD HAS VALID RECORDS ON FILE or allow_id_access is set to 1
	var/list/connected_laces = list()

	var/all_promote_req = 3
	var/three_promote_req = 2
	var/five_promote_req = 1

	var/payrate = 100
	var/leader_name = ""
	var/list/debts = list() // format list("Ro Laren" = "550") real_name = debt amount
	var/joinable = 0

	var/list/cargo_telepads = list()
	var/list/approved_orders = list()
	var/list/pending_orders = list()

	var/list/cryo_networks = list() // "default" is always a cryo_network

	var/list/unpaid = list()

	var/tax_rate = 10
	var/import_profit = 10
	var/export_profit = 20

	var/hiring_policy = 0 // if hiring_policy, anyone with reassignment can add people to the network, else only people in command a command category with reassignment can add people
	var/last_expense_print = 0

	var/list/reserved_frequencies = list() // Reserved frequencies that the faction can create encryption keys from.

	//var/datum/machine_limits/limits

	//var/datum/faction_research/research

	var/status = 1

	var/list/employment_log = list()

	var/objective = ""

	//var/datum/material_inventory/inventory

	var/obj/machinery/telepad_cargo/default_telepad
	var/default_telepad_x
	var/default_telepad_y
	var/default_telepad_z
	var/decl/hierarchy/outfit/starter_outfit = /decl/hierarchy/outfit/nexus/starter //Outfit members of this faction spawn with by default

	var/list/service_medical_business = list() // list of all organizations linked into the medical service for this business

	var/list/service_medical_personal = list() // list of all people linked int othe medical service for this business

	var/list/service_security_business = list() // list of all orgs linked to the security services

	var/list/service_security_personal = list() // list of all people linked to the security services

	var/datum/NewsFeed/feed
	var/datum/LibraryDatabase/library

	var/list/people_to_notify = list()

/datum/world_faction/New()
	..()
	network = new()
	network.holder = src
	records = new()
	create_faction_account()
	//limits = new()
	// research = new()
	// inventory = new()

/datum/world_faction/before_save()
	if(default_telepad)
		default_telepad_x = default_telepad.x
		default_telepad_y = default_telepad.y
		default_telepad_z = default_telepad.z

/datum/world_faction/after_load()
	if(default_telepad_x && default_telepad_y && default_telepad_z)
		var/turf/T = locate(default_telepad_x, default_telepad_y, default_telepad_z)
		for(var/obj/machinery/telepad_cargo/telepad in T.contents)
			default_telepad = telepad
			break
	if(!debts)
		debts = list()
	if(central_account)
		central_account.connected_business = src
	..()

/datum/world_faction/proc/get_leadername()
	return leader_name

/datum/world_faction/proc/apc_alarm(var/obj/machinery/power/apc/apc)
	var/subject = "APC Alarm at [apc.area.name] ([apc.connected_faction.name])"
	var/body = "On [stationtime2text()] the APC at [apc.area.name] for [apc.connected_faction.name] went into alarm. If you want to unsubscribe to notifications like this use the personal modification program."
	for(var/name in people_to_notify)
		Send_Email(name, sender = src.name, subject, body)
	for(var/obj/item/organ/internal/stack/stack in connected_laces)
		if(stack.owner)
			to_chat(stack.owner, "Your neural lace buzzes letting you know that the APC at [apc.area.name] has gone into alarm.")

/datum/world_faction/proc/employee_health_alarm(var/mob/M)
	for(var/datum/world_faction/faction in GLOB.all_world_factions)
		if(faction == src) continue
		if(M.real_name in faction.service_medical_personal) continue
		if(uid in faction.service_medical_personal)
			faction.health_alarm(M)

/datum/world_faction/proc/health_alarm(var/mob/M)
	var/subject = "Critical Health Alarm for [M.real_name]"
	var/body = "On [stationtime2text()] [M.real_name] is in critical health status. If you want to unsubscribe to notifications like this use the personal modification program."
	for(var/name in people_to_notify)
		Send_Email(name, sender = src.name, subject, body)
	for(var/obj/item/organ/internal/stack/stack in connected_laces)
		if(stack.owner)
			to_chat(stack.owner, "Your neural lace buzzes letting you know that [M.real_name] is in critical health status.")

/datum/world_faction/proc/give_inventory(var/typepath, var/amount)
	var/obj/machinery/telepad_cargo/using_telepad
	var/remaining_amount = amount
	rebuild_cargo_telepads()
	if(default_telepad)
		using_telepad = default_telepad
	else
		using_telepad = pick(cargo_telepads)
	if(!using_telepad) return 0
	for(var/x in 1 to amount)
		if(!remaining_amount) break
		var/obj/item/stack/material/stack = new typepath(using_telepad.loc)
		var/distributing = min(remaining_amount, stack.max_amount)
		remaining_amount -= distributing
		stack.amount = distributing
	return 1

/datum/world_faction/proc/take_inventory(var/typepath, var/amount)
	var/remaining_amount = amount
	rebuild_cargo_telepads()
	var/list/found_stacks
	for(var/obj/machinery/telepad_cargo/telepad in cargo_telepads)
		if(!remaining_amount)
			break
		if(telepad.loc)
			var/list/stacks = telepad.loc.search_contents_for(/obj/item/stack/material, list(/mob/))
			if(!stacks.len) continue
			for(var/ind in 1 to stacks.len)
				if(!remaining_amount)
					break
				var/obj/item/stack/material/stack = stacks[ind]
				if(istype(stack, typepath))
					remaining_amount -= stack.amount
					found_stacks |= stack
	if(remaining_amount)
		return 0
	var/taken = 0
	for(var/obj/item/stack/material/stack in found_stacks)
		if(taken >= amount)
			break
		var/take = min(stack.amount, (amount-taken))
		stack.amount -= take
		if(!stack.amount)
			qdel(stack)
		taken += take
	return 1

// /datum/world_faction/proc/rebuild_inventory()
// 	inventory.steel = 0
// 	inventory.glass = 0
// 	inventory.gold = 0
// 	inventory.silver = 0
// 	inventory.copper = 0
// 	inventory.wood = 0
// 	inventory.cloth = 0
// 	inventory.leather = 0
// 	inventory.phoron = 0
// 	inventory.diamond = 0
// 	inventory.uranium = 0
// 	rebuild_cargo_telepads()
// 	for(var/obj/machinery/telepad_cargo/telepad in cargo_telepads)
// 		if(telepad.loc)
// 			var/list/stacks = telepad.loc.search_contents_for(/obj/item/stack/material, list(/mob/))
// 			if(!stacks.len) continue
// 			for(var/ind in 1 to stacks.len)
// 				var/obj/item/stack/material/stack = stacks[ind]
// 				if(istype(stack, /obj/item/stack/material/steel))
// 					inventory.steel += stack.amount
// 				if(istype(stack, /obj/item/stack/material/glass))
// 					inventory.glass += stack.amount
// 				if(istype(stack, /obj/item/stack/material/gold))
// 					inventory.gold += stack.amount
// 				if(istype(stack, /obj/item/stack/material/silver))
// 					inventory.silver += stack.amount
// 				if(istype(stack, /obj/item/stack/material/copper))
// 					inventory.copper += stack.amount
// 				if(istype(stack, /obj/item/stack/material/wood))
// 					inventory.wood += stack.amount
// 				if(istype(stack, /obj/item/stack/material/cloth))
// 					inventory.cloth += stack.amount
// 				if(istype(stack, /obj/item/stack/material/leather))
// 					inventory.leather += stack.amount
// 				if(istype(stack, /obj/item/stack/material/phoron))
// 					inventory.phoron += stack.amount
// 				if(istype(stack, /obj/item/stack/material/diamond))
// 					inventory.diamond += stack.amount
// 				if(istype(stack, /obj/item/stack/material/uranium))
// 					inventory.uranium += stack.amount

// /datum/material_inventory
// 	var/steel = 0
// 	var/glass = 0
// 	var/gold = 0
// 	var/silver = 0
// 	var/copper = 0
// 	var/wood = 0
// 	var/cloth = 0
// 	var/leather = 0
// 	var/phoron = 0
// 	var/diamond = 0
// 	var/uranium = 0

/datum/world_faction/proc/get_stockholder(var/real_name)
	return 0

// /datum/world_faction/proc/get_limits()
// 	return limits

//(Re)Calculates the current claimed area and returns it.
// /datum/world_faction/proc/get_claimed_area()
// 	src.calculate_claimed_area()
// 	return limits.claimed_area

//Calculates the current claimed area. Only used by "get_claimed_area()" and "apc/can_disconnect()" procs.~
//Call "get_claimed_area()" directly instead (in most cases).
// /datum/world_faction/proc/calculate_claimed_area()
// 	var/new_claimed_area = 0

// 	for(var/obj/machinery/power/apc/apc in limits.apcs)
// 		if(!apc.area || apc.area.shuttle) continue
// 		var/list/apc_turfs = get_area_turfs(apc.area)
// 		new_claimed_area += apc_turfs.len
// 	limits.claimed_area = new_claimed_area

/datum/world_faction/proc/get_duty_status(var/real_name)
	for(var/obj/item/organ/internal/stack/stack in connected_laces)
		if(stack.get_owner_name() == real_name)
			return stack.duty_status + 1
	return 0

/datum/world_faction/proc/get_debt()
	var/debt = 0
	for(var/x in debts)
		debt += text2num(debts[x])
	return debt

/datum/world_faction/proc/pay_debt()
	for(var/x in debts)
		var/debt = text2num(debts[x])
		if(!money_transfer(central_account,x,"Postpaid Payroll",debt))
			return 0
		debts -= x

// /datum/world_faction/proc/get_tech_points()
// 	return research.points

// /datum/world_faction/proc/take_tech_points(var/amount)
// 	research.points -= amount


// /datum/world_faction/proc/unlock_tech(var/uid)
// 	research.unlocked |= uid

// /datum/world_faction/proc/is_tech_unlocked(var/uid)
// 	if(uid in research.unlocked)
// 		return 1

// /datum/world_faction/proc/meets_prereqs(var/datum/tech_entry/tech)
// 	for(var/x in tech.prereqs)
// 		if(!(x in research.unlocked))
// 			return 0
// 	return 1

/datum/world_faction/proc/rebuild_cargo_telepads()
	cargo_telepads.Cut()
	for(var/obj/machinery/telepad_cargo/telepad in GLOB.cargotelepads)
		if(telepad.req_access_faction == uid)
			telepad.connected_faction = src
			cargo_telepads |= telepad

//Just a way to customize the starting money for new characters joining a specific faction on spawn
// Can be expanded to check the specie and origins and etc too
/datum/world_faction/proc/get_new_character_money(var/mob/living/carbon/human/H)
	return DEFAULT_NEW_CHARACTER_MONEY //By default just throw the default amount at them

/datum/world_faction/proc/get_records()
	return records.faction_records

/datum/world_faction/proc/get_record(var/real_name)
	for(var/datum/computer_file/report/crew_record/R in records.faction_records)
		if(R.get_name() == real_name)
			return R
	var/datum/computer_file/report/crew_record/L = Retrieve_Record_Faction(real_name, src)
	return L

/datum/world_faction/proc/in_command(var/real_name)
	var/datum/computer_file/report/crew_record/R = get_record(real_name)
	if(R)
		var/datum/assignment/assignment = get_assignment(R.assignment_uid, R.get_name())
		if(assignment)
			if(assignment.parent)
				return assignment.parent.command_faction
	return 0

/datum/world_faction/proc/outranks(var/real_name, var/target)
	if(real_name == get_leadername())
		return 1
	var/datum/computer_file/report/crew_record/R = get_record(real_name)
	if(!R) return 0
	var/datum/computer_file/report/crew_record/target_record = get_record(target)
	if(!target_record) return 1
	var/user_command = 0
//	var/target_command = 0
	var/user_leader = 0
	var/target_leader = 0
	var/same_department = 0
	var/user_auth = 0
	var/target_auth = 0

	var/datum/assignment/assignment = get_assignment(R.assignment_uid, R.get_name())
	if(assignment)
		user_auth = assignment.edit_authority
		if(assignment.parent)
			user_command = assignment.parent.command_faction
			if(assignment.parent.head_position && assignment.parent.head_position.name == assignment.name)
				user_leader = 1
	else
		return 0
	var/datum/assignment/target_assignment = get_assignment(target_record.assignment_uid, target_record.get_name())
	if(target_assignment)
		target_auth = target_assignment.authority_restriction
		if(target_assignment.any_assign)
			same_department = 1
		if(target_assignment.parent)
	//		target_command = target_assignment.parent.command_faction
			if(target_assignment.parent.head_position && target_assignment.parent.head_position.name == target_assignment.name)
				target_leader = 1
			if(assignment.parent && target_assignment.parent.name == assignment.parent.name)
				same_department = 1
	else
		return 1
	if(user_command)
	//	if(!target_command) return 1
		if(user_leader)
			if(!target_leader) return 1
		else
			if(target_leader) return 0
	//	if(user_rank >= target_rank) return 1
		if(user_auth >= target_auth) return 1
		else return 0
	if(same_department)
		if(user_leader)
			if(!target_leader) return 1
		else
			if(target_leader) return 0
	//	if(user_rank >= target_rank) return 1
		if(user_auth >= target_auth) return 1
		else return 0
	return 0

/datum/world_faction/proc/create_faction_account()
	central_account = create_account(name, 0)
	central_account.account_type = 2
