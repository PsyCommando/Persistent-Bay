//Status Flags for the faction
var/const/FACTION_STATUS_FLAG_ACTIVE	= 1 //Whether the business/faction is Opened/Closed
var/const/FACTION_STATUS_FLAG_PENDING 	= 2 //Whether the faction is awaiting finalization or not
var/const/FACTION_STATUS_FLAG_TERMINATED= 4 //Whether the faction was terminated and shouldn't be considered an existing faction anymore

/*
	Definition for the world_faction datum
*/
/datum/world_faction
	var/uid										//Unique identifier for the faction. Should not be changed manually.
	var/name									//The displayed name for the faction.
	var/abbreviation							//Shorter one word display name for the faction
	var/short_tag								//Shortest 4 characters displayed tag for the faction
	var/desc									//Long description for the faction
	var/status									//Current state type of the faction. Whether its pending, terminated, active, etc..

	//Access
	var/password								//Password to access the faction network
	var/owner_name								//Character real_name of the current leader of this faction
	var/allow_new_player_spawn					//Whether new players should be allowed to spawn from available spawnpoints this faction owns
	var/list/accesses = list()					//List of accesses uid to each of the access datum {uid, datum}. Buffered from DB.

	//Network
	var/newtork_uid								//UID of the faction's ntnet network
	var/network_flags							//Saved parameters of the associated ntnet network
	var/tmp/datum/ntnet/faction/network			//Faction ntnet network reference

	//Money
	var/central_account_id						//Account number of the central faction account
	var/tmp/datum/money_account/central_account	//Reference on the central faction account

	//Faction Relations
	var/parent_faction_uid 						//Faction that owns this faction, and receive taxes and etc from them
	var/tmp/datum/world_faction/parent_faction	//Reference on the parent faction

	//Members
	var/list/records_byname = list()			//List of names to their corresponding faction crew record. Is buffered from the DB.
	var/list/expenses = list()					//Current Expenses for each characters

	//Employment
	var/list/assignments = list()				//List of assignments uid to each assignments datum {uid, datum/assignment_category} currently existing for this faction. Is buffered from the DB.
	var/hiring									//Whether the faction is currently allowing hiring people.
	var/employe_log = list()					//Text log for various employe actions. Buffered from DB.

//========================================
//	Standard Stuff
//========================================
/datum/world_faction/New(var/_uid, var/_name, var/_abbreviation, var/_short_tag, var/_desc)
	. = ..()
	src.uid = _uid
	src.name = _name
	src.abbreviation = _abbreviation
	src.short_tag = _short_tag
	src.desc = _desc

/datum/world_faction/after_load()
	. = ..()
	load_assignments()
	get_central_account() //Make sure the central account is loaded

/datum/world_faction/Destroy()
	return ..()

//========================================
//	Initiate all faction related stuff
//========================================
/datum/world_faction/proc/InitialSetup()
	create_network(uid, name)
	create_faction_account()
	setup_stocks()

/datum/world_faction/proc/create_network(var/_uid, var/_name)
	network = new(_uid, _name, _faction_uid = uid, _visible = TRUE, _secure = TRUE, _password = password)

/datum/world_faction/proc/create_faction_account()
	central_account = create_account("[name] central account", uid, 0, ACCOUNT_TYPE_DEPARTMENT)
	central_account_id = central_account.account_number

/datum/world_faction/proc/setup_stocks()
	return PSDB.factions.AddStockHolding(src.uid, src.uid, 100)

//========================================
//	Generic Stuff
//========================================
