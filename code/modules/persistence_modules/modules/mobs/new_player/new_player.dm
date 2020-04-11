
/mob/new_player
	// Persitent Edit, chosen slot
	var/chosen_slot = 0
	var/datum/browser/load_panel

/mob/new_player/New()
	..()
	verbs -= /mob/proc/toggle_antag_pool //no antags

/mob/new_player/new_player_panel(force = FALSE)
	if(!SScharacter_setup.initialized && !force)
		return // Not ready yet.
	var/output = list()
	output += "<div align='center'>"
	output += "<i>[GLOB.using_map.get_map_info()]</i>"
	output +="<hr>"

	var/selected_save_slot = PSDB.player.GetLastSelectedSaveSlot(client.ckey)
	client.prefs.real_name = PSDB.characters.GetCharacterName(client.ckey, selected_save_slot)
	
	if(GAME_STATE < RUNLEVEL_GAME)
		output += "<span class='average'><b>The Game Is Loading..</b></span><br><br>"
	else
		//This stuff should only be done once everything is set up or bad things happen
		output += "<hr>Current character: <b>[client.prefs.real_name]</b>[client.prefs.job_high ? ", [client.prefs.job_high]" : null]<br>"
		output += "<a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A> "
		output += "<a href='byond://?src=\ref[src];late_join=1'>Join Game!</A>"

	if(!IsGuestKey(src.key))
		establish_db_connection()
		if(dbcon.IsConnected())
			var/isadmin = 0
			if(src.client && src.client.holder)
				isadmin = 1
			var/DBQuery/query = dbcon.NewQuery("SELECT id FROM erro_poll_question WHERE [(isadmin ? "" : "adminonly = false AND")] Now() BETWEEN starttime AND endtime AND id NOT IN (SELECT pollid FROM erro_poll_vote WHERE ckey = \"[ckey]\") AND id NOT IN (SELECT pollid FROM erro_poll_textreply WHERE ckey = \"[ckey]\")")
			query.Execute()
			var/newpoll = 0
			while(query.NextRow())
				newpoll = 1
				break

			if(newpoll)
				output += "<b><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A> (NEW!)</b> "
			else
				output += "<a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A> "

	if(check_rights(R_ADMIN | R_DEBUG | R_INVESTIGATE, null, client))
		output += "<a href='byond://?src=\ref[src];observe=1'>Observe</A> "

	output += "</div>"

	panel = new(src, "Welcome","Welcome to [GLOB.using_map.full_name]", 560, 280, src)
	panel.set_window_options("can_close=0")
	panel.set_content(JOINTEXT(output))
	panel.open()
	// if(!SScharacter_setup.initialized && !force)
	// 	return // Not ready yet.
	// var/output = list()
	// output += "<div align='center'>"
	// output += "<i>[GLOB.using_map.get_map_info()]</i>"
	// output +="<hr>"
	// if(GAME_STATE < RUNLEVEL_GAME)
	// 	output += "<span class='average'><b>The Game Is Loading!</b></span><br><br>"
	// else
	// 	output += "<a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A> "
	// 	output += "<a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A> "
	// if(check_rights(R_DEBUG, 0, client))
	// 	output += "<a href='byond://?src=\ref[src];observe=1'>Observe</a><br><br>"
	// output += "<a href='https://discord.gg/53YgfNU'target='_blank'>Join Discord</a><br><br>"

/mob/new_player/Stat()
	. = ..()
	if(statpanel("Lobby"))
		if(GAME_STATE != RUNLEVEL_LOBBY)
			stat("Players : [GLOB.player_list.len]")

// /mob/new_player/proc/newCharacterPanel()
// 	var/data = "<div align='center'><br>"
// 	data += "<b>Select the slot you want to save this character under.</b><br>"
// 	var/max_slots = PSDB.player.GetPlayerMaxSaveSlots(client.ckey) //Returns default if it can't find a player
// 	var/list/datum/character_records/character_recs = PSDB.characters.GetCharacterRecordsForCKEY(client.ckey)
// 	//If the player wasn't stored yet add it to the DB
// 	if(!character_recs)
// 		PSDB.player.AddNewPlayer(client.ckey)
// 		character_recs = PSDB.characters.GetCharacterRecordsForCKEY(client.ckey)
// 		max_slots = PSDB.player.GetPlayerMaxSaveSlots(client.ckey)

// 	for(var/ind = 1, ind <= max_slots, ind++)
// 		var/characterName = (ind < length(character_recs) && character_recs[ind])? character_recs[ind].get_real_name() : null
// 		if(characterName)
// 			data += "<b>[characterName]</b><br>"
// 		else
// 			data += "<b><a href='byond://?src=\ref[src];pickSlot=[ind]create'>Open Slot</a></b><br>"

// 	data += "</div>"
// 	load_panel = new(src, "Create Character", "Create Character", 300, 500, src)
// 	load_panel.set_content(data)
// 	load_panel.open()

// /mob/new_player/proc/ImportCharacter()
	// var/found_slot = 0
	// if(!chosen_slot)
	// 	return 0
	// for(var/ind = 1, ind <= client.prefs.Slots(), ind++)
	// 	var/characterName = SScharacter_setup.peek_import_name(ind, ckey)
	// 	if(!characterName)
	// 		found_slot = ind
	// 		break
	// if(!found_slot)
	// 	to_chat(src, "Your character slots are full. Import failed.")
	// 	return
	// var/mob/living/carbon/human/character = SScharacter_setup.load_import_character(chosen_slot, ckey)
	
	// if(!character)
	// 	return
	// if(!character.mind)
	// 	character.mind = new()
	// character.revive()
	// character.real_name = SScharacter_setup.peek_import_name(chosen_slot, ckey)
	// var/list/L = recursive_content_check(character, recursion_limit = 5)
	// var/list/spared = list()
	// var/obj/item/weapon/storage/bag/plasticbag = new()
	// for(var/ind in 1 to L.len)
	// 	var/atom/movable/A = L[ind]
	// 	if(istype(A, /obj/item/clothing/accessory/toggleable/hawaii))
	// 		var/obj/item/clothing/accessory/toggleable/hawaii = A
	// 		hawaii.has_suit = null
	// 		spared |= A
	// 		A.loc = plasticbag
	// 	if(istype(A, /obj/item/weapon/paper))
	// 		spared |= A
	// 		A.loc = plasticbag
	// 	if(istype(A, /obj/item/weapon/photo))
	// 		spared |= A
	// 		A.loc = plasticbag
	// for(var/obj/item/W in character)
	// 	character.drop_from_inventory(W)
	// character.update_languages()

	// //DNA should be last
	// var/datum/computer_file/report/crew_record/R = GetGlobalCrewRecord(character.real_name)
	// character.dna.ResetUIFrom(character)
	// character.dna.ready_dna(character)
	// character.dna.b_type = client.prefs.b_type
	// character.sync_organ_dna()
	// character.spawn_loc = "nexus"
	// // Do the initial caching of the player's body icons.
	// character.force_update_limbs()
	// character.update_eyes()
	// character.regenerate_icons()
	// character.spawn_type = CHARACTER_SPAWN_TYPE_IMPORT //For first time spawn
	// if(R)
	// 	R.linked_account.money = 1000
	// 	R.email = new()
	// 	R.email.login = character.real_name

	// else
	// 	client.prefs.real_name = character.real_name
	// 	client.prefs.setup_new_accounts(character) //make accounts before! Outfit setup needs the record set



	// var/decl/hierarchy/outfit/clothes
	// clothes = outfit_by_type(/decl/hierarchy/outfit/job/assistant)
	// ASSERT(istype(clothes))
	// dressup_human(character, clothes)
	// var/obj/item/weapon/card/id/W = new (character)
	// W.registered_name = character.real_name
	// W.get_faction_uid() = GLOB.using_map.default_faction_uid
	// character.equip_to_slot_or_store_or_drop(character, slot_wear_id)
	// var/obj/item/weapon/book/multipage/guide
	// var/datum/book_constructor/starterbook/bookconstruct = new()
	// guide = bookconstruct.construct()
	// guide.icon_state= "anomaly"
	// character.equip_to_slot_or_del(guide, slot_r_hand)
	// for(var/ind in 1 to spared.len)
	// 	var/atom/A = spared[ind]
	// 	message_admins("recovered ITEM!![A]")
	// 	character.equip_to_slot_or_store_or_drop(A, slot_r_hand)
	// SScharacter_setup.delete_import_character(chosen_slot, ckey)
	// SScharacter_setup.save_character(found_slot, client.ckey, character)
	// to_chat(src, "Import Successful. [character.real_name] saved to slot [found_slot].")

// /mob/new_player/proc/selectImportPanel()
	// var/data = "<div align='center'><br>"
	// data += "<b>Select the character you want to import.</b><br>"


	// for(var/ind = 1, ind <= client.prefs.Slots(), ind++)
	// 	var/characterName = SScharacter_setup.peek_import_name(ind, ckey)
	// 	if(characterName)
	// 		var/icon/preview = SScharacter_setup.peek_import_icon(ind, ckey)
	// 		if(preview)
	// 			send_rsc(src, preview, "[ind]preview.png")
	// 		data += "<img src=[ind]preview.png width=[preview.Width()] height=[preview.Height()]><br>"
	// 		data += "<b><a href='?src=\ref[src];importSlot=[ind]'>[characterName]</a></b><hr>"
	// data += "</div>"
	// load_panel = new(src, "Select Character", "Select Character", 300, 500, src)
	// load_panel.set_content(data)
	// load_panel.open()

/mob/new_player/proc/CheckResumeExistingCharacter()
	for(var/mob/M in SSmobs.mob_list)
		if(isobserver(M) && LAST_CKEY(M) == ckey) //Clean up observers..
			qdel(M)
			continue
		if(!M.loc || !isliving(M) || LAST_CKEY(M) != ckey)
			continue
		var/datum/character_records/C = GetCharacterRecord(M.real_name)
		if(!C || C.get_status() == CHARACTER_RECORD_STATUS_DEAD)
			continue
		chosen_slot = C.get_save_slot()
		to_chat(src, SPAN_NOTICE("A character is already in game."))
		GetGlobalCrewRecord(M.real_name) //Will cache the character record from the DB
		if(GAME_STATE >= RUNLEVEL_GAME)
			transitionToGame()
			M.update_icons()
			M.key = key
			return TRUE
	return FALSE

/mob/new_player/proc/selectCharacterPanel(var/action = "")
	if(CheckResumeExistingCharacter())
		qdel(src)
		return

	var/data = "<div align='center'><br>"
	data += "<b>Select the character you want to [action].</b><br>"

	var/max_slots = GetPlayerMaxSaveSlots(ckey)
	var/list/datum/character_records/CL = GetCharacterRecordsForCKEY(ckey)
	
	for(var/ind = 1, ind <= max_slots, ind++)
		var/datum/character_records/char = ind < length(CL)? CL[ind] : null
		var/characterName = char? char.get_real_name() : null
		if(char)
			var/icon/preview = char.get_front_picture()
			if(preview)
				send_rsc(src, preview, "[ind]preview.png")
			data += "<img src=[ind]preview.png width=[preview.Width()] height=[preview.Height()]><br>"
			data += "<b><a href='?src=\ref[src];pickSlot=[ind][action]'>[characterName]</a></b><hr>"
		else
			data += "<b>Open Slot</b><hr>"
	data += "</div>"
	load_panel = new(src, "Select Character", "Select Character", 300, 500, src)
	load_panel.set_content(data)
	load_panel.open()

/mob/new_player/proc/observeGame()
	chosen_slot = -1
	//loadCharacter()

//Stops the lobby music and close the main menu panels
/mob/new_player/proc/transitionToGame()
	panel?.close()
	load_panel?.close()
	sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))

// /mob/new_player/proc/loadCharacter()
// 	if(!config.enter_allowed && !check_rights(R_ADMIN|R_MOD, 0, src))
// 		to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
// 		return
// 	if(!chosen_slot)
// 		return
// 	if(spawning)
// 		return
// 	spawning = TRUE

// 	//Resume playing
// 	if(CheckResumeExistingCharacter())
// 		qdel(src)
// 		return
// 	// for(var/mob/M in SSmobs.mob_list)
// 	// 	if(M.loc && !M.perma_dead && M.type != /mob/new_player && (M.stored_ckey == ckey || M.stored_ckey == "@[ckey]"))
// 	// 		transitionToGame() //Don't forget to close the panel and stop the lobby music
// 	// 		if(istype(M, /mob/observer))
// 	// 			qdel(M)
// 	// 			continue
// 	// 		M.ckey = ckey
// 	// 		M.update_icons()
// 	// 		spawn(200)
// 	// 			M.redraw_inv() //Make sure icons shows up
// 	// 		qdel(src)
// 	// 		return

// 	//Observer Spawn
// 	if(chosen_slot == -1)
// 		transitionToGame() //Don't forget to close the panel and stop the lobby music
// 		var/mob/observer/ghost/observer = new()
// 		observer.started_as_observer = 1
// 		observer.forceMove(GLOB.cryopods.len ? get_turf(pick(GLOB.cryopods)) : locate(100, 100, 1))
// 		observer.ckey = ckey
// 		qdel(src)
// 		return

// 	sleep(10) //Wait possibly for the file to unlock???
// 	var/list/datum/character_records/CL = PSDB.characters.GetCharacterRecordsForCKEY(ckey, chosen_slot)
// 	var/datum/character_records/C
// 	if(!CL || !length(CL))
// 		return FALSE
// 	C = CL[1]
	
// 	var/mob/character
// 	try
// 		character = C.restore_saved_character()
// 	catch(var/exception/e)
// 		message_admins("[ckey], slot [chosen_slot] failed loading the saved character: [e]")
	
// 	if(!character)
// 		message_admins("[ckey], slot [chosen_slot], load character failed during join.")
// 		to_chat(src, "Your character is not loading correctly. Contact Brawler.")
// 		spawning = FALSE
// 		return
// 	if (!GetGlobalCrewRecord(character.real_name))
// 		var/datum/computer_file/report/crew_record/new_record = CreateModularRecord(character)
// 		GLOB.all_crew_records |= new_record
// 	var/turf/spawnTurf

// 	if(character.spawn_type == CHARACTER_SPAWN_TYPE_CRYONET)
// 		// var/datum/world_faction/faction = FindFaction(character.spawn_loc)
// 		// var/assignmentSpawnLocation = faction?.get_assignment(faction?.get_record(character.real_name)?.assignment_uid, character.real_name)?.cryo_net
// 		// if (assignmentSpawnLocation == "Last Known Cryonet")
// 		// 	// The character's assignment is set to spawn in their last cryo location
// 		// 	// Do nothing, leave it the way it is.
// 		// else if (assignmentSpawnLocation)
// 		// 	// The character has a special cryo network set to override their normal spawn location
// 		// 	character.spawn_loc_2 = assignmentSpawnLocation
// 		// else
// 		// 	// The character doesn't have a spawn_loc_2, so use the one for their assignment or the default
// 		// 	character.spawn_loc_2 = " default"

// 		// if(character.spawn_personal)
// 		// 	var/turf/T = locate(character.spawn_p_x,character.spawn_p_y,character.spawn_p_z)
// 		// 	if(T)
// 		// 		for(var/obj/machinery/cryopod/pod in T.contents)
// 		// 			spawnTurf = T
// 		// 			break
// 		// if(!spawnTurf)
// 		// 	for(var/obj/machinery/cryopod/pod in GLOB.cryopods)
// 		// 		if(!pod.loc)
// 		// 			qdel(pod)
// 		// 			continue
// 		// 		if(pod.req_access_faction == character.spawn_loc)
// 		// 			if(pod.network == character.spawn_loc_2)
// 		// 				spawnTurf = get_turf(pod)
// 		// 				break
// 		// 			else
// 		// 				spawnTurf = get_turf(pod)
// 		// 		else if(!spawnTurf)
// 		// 			spawnTurf = get_turf(pod)

// 		if(!spawnTurf)
// 			log_and_message_admins("WARNING! No cryopods avalible for spawning! Get some spawned and connected to the starting factions uid (req_access_faction)")
// 			spawnTurf = locate(102, 98, 1)

// 	else if(character.spawn_type == CHARACTER_SPAWN_TYPE_FRONTIER_BEACON || character.spawn_type == CHARACTER_SPAWN_TYPE_IMPORT)
// 		// var/obj/item/weapon/card/id/W = character.GetIdCard()
// 		// if(W)
// 		// 	W.selected_faction_uid = "nexus"
// 		// var/list/obj/machinery/frontier_beacon/possibles = list()
// 		// var/list/obj/machinery/frontier_beacon/possibles_unsafe = list()
// 		// for(var/obj/machinery/frontier_beacon/beacon in GLOB.frontierbeacons)
// 		// 	if(!beacon.loc)
// 		// 		continue
// 		// 	if(beacon.req_access_faction == character.spawn_loc && beacon.citizenship_type == character.spawn_cit)
// 		// 		//Check the beacon position to see if they're safe
// 		// 		var/turf/T = get_turf(beacon)
// 		// 		var/radlevel = SSradiation.get_rads_at_turf(T)
// 		// 		var/airstatus = IsTurfAtmosUnsafe(T)
// 		// 		if(airstatus || radlevel > 0)
// 		// 			possibles_unsafe += beacon
// 		// 		else
// 		// 			possibles += beacon

// 		// if(possibles.len)
// 		// 	spawnTurf = get_turf(pick(possibles)) //Pick one randomly
// 		// else if(possibles_unsafe.len)
// 		// 	spawnTurf = get_turf(pick(possibles_unsafe))
// 		// 	var/radlevel = SSradiation.get_rads_at_turf(spawnTurf)
// 		// 	var/airstatus = IsTurfAtmosUnsafe(spawnTurf)
// 		// 	log_and_message_admins("Couldn't find a safe spawn beacon. Spawning [character] at [spawnTurf] ([spawnTurf.x], [spawnTurf.y], [spawnTurf.z])! Warning player!", character, spawnTurf)
// 		// 	var/reply = alert(src, "Warning. Your selected spawn location seems to have unfavorable conditions. You may die shortly after spawning. \
// 		// 	Spawn anyway? More information: [airstatus] Radiation: [radlevel] Bq", "Atmosphere warning", "Abort", "Spawn anyway")
// 		// 	if(reply == "Abort")
// 		// 		spawning = FALSE
// 		// 		new_player_panel(TRUE)
// 		// 		return
// 		// 	else
// 		// 		// Let the staff know, in case the person complains about dying due to this later. They've been warned.
// 		// 		log_and_message_admins("User [src.client] spawned as [character] at [spawnTurf]([spawnTurf.x], [spawnTurf.y], [spawnTurf.z]) with dangerous atmosphere.")

// 		// if(!spawnTurf)
// 		// 	log_and_message_admins("WARNING! No frontier beacons avalible for spawning! Get some spawned and connected to the starting factions uid (req_access_faction)")
// 		// 	spawnTurf = locate(world.maxx / 2 , world.maxy /2, 1)

// 	else if(character.spawn_type == CHARACTER_SPAWN_TYPE_LACE_STORAGE)
// 		// spawnTurf = GetLaceStorage(character)
// 		// if(!spawnTurf)
// 		// 	log_and_message_admins("WARNING! Unable To Find Any Spawn Turf!!! Prehaps you didn't include a map?")
// 		// 	return

// 	//Close the menu and stop the lobby music once we're sure we're spawning
// 	transitionToGame()
// 	character.after_spawn()

// 	if(!character.mind)
// 		mind.active = 1
// 		mind.original = character
// 		mind.transfer_to(character)	//won't transfer key since the mind is not active

// 	character.forceMove(spawnTurf)
// 	character.stored_ckey = key
// 	character.key = key
// 	character.last_ckey = ckey

// 	//Make sure dna is spread to limbs
// 	character.dna.ready_dna(character)
// 	character.sync_organ_dna()

// 	//GLOB.minds |= character.mind
// 	character.regenerate_icons()
// 	character.update_inv_back()
// 	character.update_inv_wear_id()
// 	character.update_inv_belt()
// 	character.update_inv_pockets()
// 	character.update_inv_l_hand()
// 	character.update_inv_r_hand()
// 	character.update_inv_s_store()
// 	character.redraw_inv()

// 	//Execute post-spawn stuff
// 	character.finishLoadCharacter()	// This is ran because new_players don't like to stick around long.
// 	return 1


/mob/new_player/proc/GetCryonetSpawnLocation(var/mob/character)
	var/datum/world_faction/F = FindFaction(character.saved_cryonet.cryonet_faction_uid)
	if(!F)
		return null
	for(var/obj/machinery/cryopod/Cryo in GLOB.cryopods)
		if(Cryo.faction_uid == character.saved_cryonet.cryonet_faction_uid && Cryo.network == character.saved_cryonet.cryonet_name)
			return get_turf(Cryo)
	return null

/mob/new_player/proc/GetPersonalPodSpawnLocation(var/mob/character)
	for(var/obj/machinery/cryopod/personal/Cryo in GLOB.cryopods)
		if(Cryo.network == character.saved_cryonet.cryonet_name)
			return get_turf(Cryo)
	return null

// /mob/new_player/proc/GetFrontierBeaconSpawnLocation(var/mob/character)
// 	for(var/obj/machinery/frontier_beacon/B in GLOB.frontierbeacons)
// 		if(B.faction_uid == client.prefs.starting_faction_uid)
// 	return null

/mob/new_player/proc/GetLaceStorageSpawnLocation(var/mob/character)

/mob/new_player/proc/SpawnSavedCharacter(var/mob/character)
	var/turf/spawnTurf
	// switch(character.spawn_type)
	// 	if(CHARACTER_SPAWN_TYPE_CRYONET)
	// 		spawnTurf = GetCryonetSpawnLocation(character)
	// 	if(CHARACTER_SPAWN_TYPE_PERSONAL)
	// 		spawnTurf = GetPersonalPodSpawnLocation(character)
	// 	if(CHARACTER_SPAWN_TYPE_FRONTIER_BEACON || CHARACTER_SPAWN_TYPE_IMPORT)
	// 		spawnTurf = GetFrontierBeaconSpawnLocation(character)
	// 	if(CHARACTER_SPAWN_TYPE_LACE_STORAGE)
	// 		spawnTurf = GetLaceStorageSpawnLocation(character)

	//Emergency spawn location
	//if(!spawnTurf)
		//Map default spawn location
		

	transitionToGame()
	if(!character.mind)
		mind.active = TRUE
		mind.original = character
		mind.transfer_to(character)	//won't transfer key since the mind is not active
	//
	character.forceMove(spawnTurf)
	character.stored_ckey = key
	character.key = key
	character.last_ckey = ckey

	character.update_icons()
	character.after_spawn()
	character.finishLoadCharacter()	// This is ran because new_players don't like to stick around long.

//Runs what happens after the character is loaded. Mainly for cinematics and lore text.
/mob/finishLoadCharacter()
	switch(spawn_type)
		if(CHARACTER_SPAWN_TYPE_CRYONET || CHARACTER_SPAWN_TYPE_PERSONAL)
			to_chat(src, "You eject from your cryosleep, ready to resume life in the frontier.")
			//notify_friends()
		else if(CHARACTER_SPAWN_TYPE_FRONTIER_BEACON)
			GLOB.using_map.on_new_spawn(src) //Moved to overridable map specific code
		else if(CHARACTER_SPAWN_TYPE_LACE_STORAGE)
			to_chat(src, "You regain consciousness, still prisoner of your neural lace.")
			//notify_friends()
		else if(CHARACTER_SPAWN_TYPE_IMPORT)
			import_spawn()

/mob/proc/import_spawn()
	// var/mob/newchar = src
	// if(!istype(newchar))
	// 	return
	// var/obj/screen/cinematic
	// cinematic = new
	// cinematic.icon = 'maps/nexus/icons/intro.dmi'
	// cinematic.icon_state = "blank"
	// cinematic.plane = HUD_PLANE
	// cinematic.layer = HUD_ABOVE_ITEM_LAYER
	// cinematic.mouse_opacity = 2
	// cinematic.screen_loc = "WEST,SOUTH"

	// if(newchar.client)
	// 	newchar.client.screen += cinematic
	// 	flick("cinematic",cinematic)
	// 	sleep(106)
	// 	newchar.client.screen -= cinematic

	// newchar.spawn_type = CHARACTER_SPAWN_TYPE_CRYONET
	// var/sound/mus = sound('sound/music/brandon_morris_loop.ogg', repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel)
	// mus.environment = -1 //Don't do silly reverb stuff
	// mus.status = SOUND_STREAM //Cheaper to do streams
	// sound_to(newchar, mus)
	// spawn()
	// 	new /obj/effect/portal(get_turf(newchar), null, 5 SECONDS, 0)
	// 	shake_camera(newchar, 3, 1)
	// newchar.druggy = 3
	// newchar.Weaken(3)
	// to_chat(newchar, "<span class='danger'>Aboard the cruiser ecaping from the Alpha Quadrant, the journey through the bluespace barrier shreds the hull as it passes the threshold.</span>")
	// to_chat(newchar, "<span class='danger'>With the barrier weakened, the station inside the Beta Quadrant is able to yank the failing vessels cryo-storage over to the frontier beacons..</span>")
	// to_chat(newchar, "But it must have prioritized saving life-signs rather than the item storage. You wake up in an unfamilar uniform with a basic backpack. Maybe some of your lightest belongings are in there.")
	// to_chat(newchar, "You find a book at your feet. 'Guide to Nexus City'.")
	// to_chat(newchar, "You've been in this situation before, but on a different station. What new stories does the Nexus City hold for you?")
	// to_chat(newchar, "((Thanks for returning to persistence. So many staff and contributors have come together to make the lastest chapter, and I'm really glad to have you back. -- Brawler.))")

/mob/new_player/proc/deleteCharacter()
	. = TRUE
	var/list/datum/character_records/CL = GetCharacterRecordsForCKEYAndSaveSlot(ckey, chosen_slot)
	if(!CL || length(CL))
		return FALSE
	var/datum/character_records/C = CL[1] //Only handle the first one we find.
	var/charname = C.get_real_name()
	if(input("Are you SURE you want to delete [charname]? THIS IS PERMANENT. enter the character\'s full name to conform.", "DELETE A CHARACTER", "") == charname)
		. = PSDB.characters.RemoveCharacterRecord(charname)
	load_panel.close()

/mob/new_player/proc/crewManifestPanel()
	var/list/factions = list()

	for(var/obj/item/organ/internal/stack/stack in GLOB.neural_laces)
		if(!stack.loc) continue
		var/faction = FindFaction(stack.connected_faction)?.name
		if(factions["[faction]"])
			factions["[faction]"] += stack
		else
			factions["[faction]"] = list(stack)

	var/data = "<div align='center'><br>"

	for(var/faction in factions)
		data += "<table width=150px>"
		data += "<tr class='title'><th colspan=3>[faction]</th></tr>"
		data += "<tr class='title'><th>Name</th><th>Status</th></tr>"
		var/ind = 0
		for(var/obj/item/organ/internal/stack/stack in factions[faction])
			data += "<tr[ind ? " class='alt'" : " class='norm'"]><td>[stack.get_owner_name()]</td><td>[stack.duty_status ? "On Duty" : "Off Duty"]</td></tr>"
			ind = !ind
		data += "</table>"

	data += "</div>"
	load_panel = new(src, "Crew Manifest", "Crew Manifest", 300, 500, src)
	load_panel.set_content(data)
	load_panel.open()

/mob/new_player/create_character(var/turf/spawn_turf)
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]

	if(!spawn_turf)
		var/datum/job/job = SSjobs.get_by_title(mind.assigned_role)
		if(!job)
			job = SSjobs.get_by_title(GLOB.using_map.default_assistant_title)
		var/datum/spawnpoint/spawnpoint = job.get_spawnpoint(client, client.prefs.ranks[job.title], client.prefs.starting_faction_uid)
		spawn_turf = pick(spawnpoint.turfs)

	if(chosen_species)
		if(!check_species_allowed(chosen_species))
			spawning = 0 //abort
			return null
		new_character = new(spawn_turf, chosen_species.name)
		if(chosen_species.has_organ[BP_POSIBRAIN] && client && client.prefs.is_shackled)
			var/obj/item/organ/internal/posibrain/B = new_character.internal_organs_by_name[BP_POSIBRAIN]
			if(B)	B.shackle(client.prefs.get_lawset())

	if(!new_character)
		new_character = new(spawn_turf)

	new_character.lastarea = get_area(spawn_turf)

	if(GLOB.random_players)
		client.prefs.gender = pick(MALE, FEMALE)
		client.prefs.real_name = random_name(new_character.gender)
		client.prefs.randomize_appearance_and_body_for(new_character)
	client.prefs.copy_to(new_character)

	sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))// MAD JAMS cant last forever yo

	if(mind)
		mind.active = 0 //we wish to transfer the key manually
		mind.original = new_character
		if(client.prefs.memory)
			mind.StoreMemory(client.prefs.memory)
		if(client.prefs.relations.len)
			for(var/T in client.prefs.relations)
				var/TT = matchmaker.relation_types[T]
				var/datum/relation/R = new TT
				R.holder = mind
				R.info = client.prefs.relations_info[T]
			mind.gen_relations_info = client.prefs.relations_info["general"]
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_organ_dna()
	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		new_character.dna.SetSEState(GLOB.GLASSESBLOCK,1,0)
		new_character.disabilities |= NEARSIGHTED

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_eyes()
	new_character.regenerate_icons()

	new_character.key = key		//Manually transfer the key to log them in
	return new_character


/mob/new_player/Topic(href, href_list) // This is a full override; does not call parent.
	if(usr != src)
		return TOPIC_NOACTION
	if(!client)
		return TOPIC_NOACTION

	// if(href_list["createCharacter"])
	// 	newCharacterPanel()
	// 	return 0

	// if(href_list["deleteCharacter"])
	// 	selectCharacterPanel("delete")
	// 	return 0

	// if(href_list["refresh"])
	// 	panel.close()
	// 	new_player_panel()

	// if(href_list["importSlot"])
	// 	chosen_slot = text2num(href_list["importSlot"])
	// 	ImportCharacter()
	// 	load_panel?.close()
	// if(href_list["importCharacter"])
	// 	selectImportPanel()
	// if(href_list["pickSlot"])
	// 	chosen_slot = text2num(copytext(href_list["pickSlot"], 1, 2))
	// 	client.prefs.default_slot = chosen_slot
	// 	load_panel?.close()
	// 	switch(copytext(href_list["pickSlot"], 2))
	// 		if("create")
	// 			client.prefs.randomize_appearance_and_body_for()
	// 			client.prefs.real_name = null
	// 			client.prefs.preview_icon = null
	// 			client.prefs.sanitize_preferences()
	// 			client.prefs.ShowChoices(src)
	// 		if("load")
	// 			loadCharacter()
	// 		if("delete")
	// 			deleteCharacter()
	// 	return 0

	// if(href_list["pickSlot"])
	// 	chosen_slot = text2num(copytext(href_list["pickSlot"], 1, 2))
	// 	client.prefs.default_slot = chosen_slot
	// 	load_panel?.close()
	// 	switch(copytext(href_list["pickSlot"], 2))
	// 		if("create")
	// 			client.prefs.randomize_appearance_and_body_for()
	// 			client.prefs.real_name = null
	// 			client.prefs.preview_icon = null
	// 			client.prefs.sanitize_preferences()
	// 			client.prefs.ShowChoices(src)
	// 		if("load")
	// 			loadCharacter()
	// 		if("delete")
	// 			deleteCharacter()
	// 	return 0
	return ..()