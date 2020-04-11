//Stuff to implement
/datum/ntnet/proc/get_network_name()
/datum/ntnet/proc/get_network_uid()
/datum/ntnet/proc/get_faction_uid()
/datum/ntnet/proc/set_faction_uid(var/newuid)
/datum/ntnet/proc/get_faction()
/datum/ntnet/proc/check_password(var/otherpass)

//
// Faction Network
//
/datum/ntnet/faction
	var/name = "" // network name
	var/uid = "" // the thing the cards connect to, this is DANGEROUS TO CHANGE, BREAKING ALL CONNECTED MACHINES, also their can only be ONE NETWORK OF EACH TYPE
	var/invisible = 0
	var/secured = 0
	var/password = "password"
	var/datum/world_faction/faction
	var/faction_uid

	//Local records
	var/list/datum/computer_file/report/crew_record/faction/records = list()

//Override the default ntnet constructor so we don't delete any new networks
/datum/ntnet/faction/New(var/_uid, var/_name, var/_faction_uid, var/_visible = FALSE, var/_secure = FALSE, var/_password = null)
	uid = _uid
	name = _name
	faction_uid = _faction_uid
	invisible = !_visible
	secured = _secure
	password = _password
	if(faction_uid)
		faction = FindFaction(faction_uid)
	if(uid)
		GLOB.FactionNetManager.faction_networks[src.uid] = src
	reconnect_network_relays()
	build_software_lists()
	build_news_list()
	build_emails_list()
	build_reports_list()
	add_log("Net logging system activated.")

/datum/ntnet/faction/after_load()
	. = ..()
	if(faction_uid)
		faction = FindFaction(faction_uid)
	GLOB.FactionNetManager.faction_networks[src.uid] = src
	reconnect_network_relays()

/datum/ntnet/faction/proc/get_name()
	return name
/datum/ntnet/faction/proc/set_name(var/_name)
	name = _name

/datum/ntnet/faction/proc/get_uid()
	return uid
/datum/ntnet/faction/proc/set_uid(var/_uid)
	if(_uid && _uid != uid)
		GLOB.FactionNetManager.faction_networks[uid] = null
		GLOB.FactionNetManager.faction_networks[_uid] = src
		uid = _uid
		reconnect_network_relays()

/datum/ntnet/faction/get_faction_uid()
	return faction_uid
/datum/ntnet/faction/set_faction_uid(var/_faction_uid)
	if(_faction_uid && _faction_uid != faction_uid)
		faction = null
		faction_uid = _faction_uid
		faction = FindFaction(faction_uid)
		reconnect_network_relays()

/datum/ntnet/faction/proc/is_secured()
	return secured

/datum/ntnet/faction/get_faction()
	return faction

/datum/ntnet/faction/check_password(var/otherpass)
	return deep_string_equals(password, otherpass)

/datum/ntnet/faction/proc/reconnect_network_relays()
	if(!faction_uid)
		return
	for(var/obj/machinery/ntnet_relay/R in GLOB.all_factionalized_relays)
		if(R.faction_uid == faction_uid)
			relays |= R
			R.NTNet = src

//Overrides:
// Simplified logging: Adds a log. log_string is mandatory parameter, source is optional.
/datum/ntnet/faction/add_log(var/log_string, var/obj/item/weapon/stock_parts/computer/network_card/source = null)
	var/log_text = "[stationtime2text()] - "
	if(source)
		log_text += "[source.get_network_tag()] - "
	else
		log_text += "*SYSTEM* - "
	log_text += log_string
	logs.Add(log_text)

	if(logs.len > setting_maxlogcount)
		// We have too many logs, remove the oldest entries until we get into the limit
		for(var/L in logs)
			if(logs.len > setting_maxlogcount)
				logs.Remove(L)
			else
				break

	for(var/obj/machinery/ntnet_relay/R in relays)
		var/obj/item/weapon/stock_parts/computer/hard_drive/portable/P = R.get_component_of_type(/obj/item/weapon/stock_parts/computer/hard_drive/portable)
		if(P)
			var/datum/computer_file/data/logfile/file = P.find_file_by_name("ntnet_log")
			if(!istype(file))
				file = new()
				file.filename = "ntnet_log"
				P.store_file(file)
			file.stored_data += log_text + "\[br\]"


