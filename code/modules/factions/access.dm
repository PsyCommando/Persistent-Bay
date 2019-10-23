/datum/accesses
	var/list/accesses = list()
	var/expense_limit = 0
	var/pay
	var/name
	var/auth_req
	var/auth_level

/datum/assignment/after_load()
	..()

/datum/access_category
	var/name = ""
	var/list/accesses = list() // format-- list("11" = "Bridge Access")

/datum/access_category/core
	name = "Core Access"

/datum/access_category/core/New()
	accesses["101"] = "Access & Assignment Control"
	accesses["102"] = "Command Programs"
	accesses["103"] = "Reassignment/Promotion Vote"
	accesses["104"] = "Research Control"
	accesses["105"] = "Engineering Programs"
	accesses["106"] = "Medical Programs"
	accesses["107"] = "Security Programs"
	accesses["108"] = "Shuttle Control"
	accesses["109"] = "Machine Linking"
	accesses["110"] = "Computer Linking"
	accesses["111"] = "Budget View"
	accesses["112"] = "Contract Signing/Control"
	accesses["113"] = "Material Marketplace"


/datum/world_faction/proc/get_access_name(var/access)
	var/datum/access_category/core/core = new()
	for(var/datum/access_category/access_category in access_categories+core)
		if(access in access_category.accesses) return access_category.accesses[access]
	return 0

/datum/world_faction/proc/rebuild_all_access()
	all_access = list()
	var/datum/access_category/core/core = new()
	for(var/datum/access_category/access_category in access_categories+core)
		for(var/x in access_category.accesses)
			all_access |= x
