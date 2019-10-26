/datum/accesses
	var/list/accesses = list()
	var/expense_limit = 0
	var/pay
	var/name
	var/auth_req
	var/auth_level

/datum/access_category
	var/name = ""
	var/list/accesses = list() // format-- list("11" = "Bridge Access")

/datum/access_category/core
	name = "Core Access"
	accesses = list(
		"101" = "Access & Assignment Control",
		"102" = "Command Programs",
		"103" = "Reassignment/Promotion Vote",
		"104" = "Research Control",
		"105" = "Engineering Programs",
		"106" = "Medical Programs",
		"107" = "Security Programs",
		"108" = "Shuttle Control",
		"109" = "Machine Linking",
		"110" = "Computer Linking",
		"111" = "Budget View",
		"112" = "Contract Signing/Control",
		"113" = "Material Marketplace",
	)

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
