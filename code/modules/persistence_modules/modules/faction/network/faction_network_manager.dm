GLOBAL_DATUM_INIT(FactionNetManager, /datum/faction_network_manager, new /datum/faction_network_manager())
/datum/faction_network_manager
	var/global/list/faction_networks = list() //Format is network (id = network)

//Allow to quickly get a network with the given uid
/datum/faction_network_manager/proc/GetNetwork(var/uid)
	return (uid in faction_networks)? faction_networks[uid] : null

/datum/faction_network_manager/proc/AddNetwork(var/datum/ntnet/faction/N)
	if(!istype(N))
		return FALSE
	if(!N.uid)
		return FALSE
	faction_networks[N.uid] = N
	return TRUE

//Create a brand new network
/datum/faction_network_manager/proc/CreateNetwork(var/uid)
	if(faction_networks[uid])
		return null
	var/datum/ntnet/faction/N = new()
	N.uid = uid
	faction_networks[uid] = N
	return faction_networks[uid]
