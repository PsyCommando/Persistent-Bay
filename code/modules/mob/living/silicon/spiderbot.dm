/mob/living/silicon/spiderbot
	name 				= "spider-bot"
	desc 				= "A skittering robotic friend!"
	icon 				= 'icons/mob/robots_misc.dmi'
	icon_state 			= "spiderbot-chassis"
	density 			= 0
	mob_size 			= MOB_SMALL
	health 				= 75
	maxHealth 			= 75
	// attacktext 			= "shocked"
	// melee_damage_lower 	= 5
	// melee_damage_upper 	= 10
	// response_help		= "pets"
	// response_disarm		= "shoos"
	// response_harm		= "stomps on"
	// speed				= -1                    //Spiderbots gotta go fast.
	pass_flags			= PASS_FLAG_TABLE
	speak_emote			= list("beeps","clicks","chirps")
	holder_type 		= /obj/item/weapon/holder
	hand 				= 0	//left hand is the one always active!
	l_hand 				= null //Left hand is the one we use!
	r_hand 				= null //right hand is unused!
	silicon_subsystems = list(
		/datum/nano_module/email_client,
		/datum/nano_module/program/computer_newsbrowser,
	)

	//State
	var/speed 											= -1 	//Same as old value
	var/fire_alert										= FALSE
	var/emagged 										= FALSE
	var/locked											= TRUE	//Brain lock, prevents people from randomly removing the brain of the thing

	//Brains
	var/obj/item/device/mmi/mmi 						= null
	var/obj/item/device/lmi/lmi 						= null
	var/obj/item/organ/internal/posibrain/positronic	= null

	//Storage stuff
	var/obj/item/internal_storage 						= null

	//Internal systems
	var/obj/item/weapon/cell/cell 						= null
	var/obj/machinery/camera/camera 					= null

/mob/living/silicon/spiderbot/get_cell()
	return cell

/mob/living/silicon/spiderbot/get_stack()
	return lmi? lmi.brainobj : null

/mob/living/silicon/spiderbot/New(var/loc, var/constructed = FALSE)
	..()
	ADD_SAVED_VAR(emagged)
	ADD_SAVED_VAR(cell)
	ADD_SAVED_VAR(mmi)
	ADD_SAVED_VAR(lmi)
	ADD_SAVED_VAR(internal_storage)

/mob/living/silicon/spiderbot/Initialize(mapload, constructed = FALSE)
	. = ..()
	if(!map_storage_loaded)
		if(!constructed) //If we just assembled the thing, don't put a powercell in!
			cell = new /obj/item/weapon/cell/high(src)
		add_language(LANGUAGE_GALCOM)
		add_language(LANGUAGE_EAL)
		default_language = all_languages[LANGUAGE_GALCOM]
		camera = new /obj/machinery/camera(src)
		camera.c_tag = "spiderbot-[real_name]"
		camera.replace_networks(list(NETWORK_NEXUS))
	verbs |= /mob/living/proc/ventcrawl
	verbs |= /mob/living/proc/hide
	verbs |= /mob/living/silicon/spiderbot/proc/eject_brain
	queue_icon_update()
	update_action_buttons()

/mob/living/silicon/spiderbot/Destroy()
	eject_brain()
	QDEL_NULL(cell)
	QDEL_NULL(camera)
	QDEL_NULL(internal_storage)
	return ..()

/mob/living/silicon/spiderbot/proc/install_brain(var/obj/item/device/B, var/mob/user)
	if(!istype(B))
		return FALSE
	if(lmi || mmi)
		to_chat(user, SPAN_WARNING("There's already a brain in [src]!"))
		return FALSE

	var/mob/living/carbon/brainmob
	var/obj/item/device/lmi/LMI = B
	var/obj/item/device/mmi/MMI = B

	if(istype(LMI, /obj/item/device/lmi))
		brainmob = LMI.brainmob
		MMI = null //Just to be sure 
	else if(istype(MMI, /obj/item/device/mmi))
		brainmob = MMI.brainmob
		LMI = null //Just to be sure 

	if(!brainmob)
		to_chat(user, SPAN_WARNING("Sticking an empty [B.name] into the frame would sort of defeat the purpose."))
		return FALSE
	if(!brainmob.key)
		var/ghost_can_reenter = 0
		if(brainmob.mind)
			for(var/mob/observer/ghost/G in GLOB.player_list)
				if(G.can_reenter_corpse && G.mind == brainmob.mind)
					ghost_can_reenter = 1
					break
		if(!ghost_can_reenter)
			to_chat(user, SPAN_NOTICE("[B] is completely unresponsive; there's no point."))
			return FALSE
	if(jobban_isbanned(brainmob, "Cyborg"))
		to_chat(user, SPAN_WARNING("\The [B] does not seem to fit."))
		return FALSE
	user.visible_message( SPAN_NOTICE("[user] installs \the [B] in \the [src]."), SPAN_NOTICE("You install \the [B] in \the [src]!"))
	user.drop_item()

	if(LMI)
		lmi = B
	else if(MMI)
		mmi = B
	B.forceMove(src)
	transfer_personality(B)
	update_icon()
	update_action_buttons()
	return TRUE

//Handle picking up things/interactions
/mob/living/silicon/spiderbot/UnarmedAttack(var/atom/A, var/proximity)
	if(!A.attack_hand(src))
		return ..()
	return TRUE

/mob/living/silicon/spiderbot/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/device/lmi) || istype(O, /obj/item/device/mmi))
		return install_brain(O, user)
	else if(isWelder(O))
		var/obj/item/weapon/tool/weldingtool/WT = O
		if (WT.remove_fuel(0))
			if(health < maxHealth)
				health += pick(1,1,1,2,2,3)
				if(health > maxHealth)
					health = maxHealth
				add_fingerprint(user)
				src.visible_message("<span class='notice'>\The [user] has spot-welded some of the damage to \the [src]!</span>")
			else
				to_chat(user, "<span class='warning'>\The [src] is undamaged!</span>")
		else
			to_chat(user, "<span class='danger'>You need more welding fuel for this task!</span>")
			return TRUE
	else if(isscrewdriver(O))
		var/list/things_to_remove = list()
		if(cell)
			things_to_remove += cell
		if(mmi)
			things_to_remove += mmi
		if(lmi)
			things_to_remove += lmi

		if(!length(things_to_remove))
			to_chat(user, SPAN_WARNING("\The [src] has nothing that can be removed."))
			return 0
		else if(length(things_to_remove) > 1)
			var/choice = input(user, "What to remove?") in things_to_remove
			if(choice == cell)
				cell.dropInto(loc)
				cell = null
				update_hud()
			else if(choice == mmi || choice == lmi)
				to_chat(user, SPAN_NOTICE("You pop \the [lmi? lmi : (mmi? mmi : null)] out of \the [src]."))
				eject_brain()
		return TRUE
	else
		return ..()

/mob/living/silicon/spiderbot/emag_act(var/remaining_charges, var/mob/user)
	if (emagged)
		to_chat(user, "<span class='warning'>[src] is already overloaded - better run.</span>")
		return 0
	else
		to_chat(user, "<span class='notice'>You short out the security protocols and overload [src]'s cell, priming it to explode in a short time.</span>")
		spawn(100)	to_chat(src, "<span class='danger'>Your cell seems to be outputting a lot of power...</span>")
		spawn(200)	to_chat(src, "<span class='danger'>Internal heat sensors are spiking! Something is badly wrong with your cell!</span>")
		spawn(300)	src.explode()

/mob/living/silicon/spiderbot/proc/transfer_personality(var/obj/item/device/M)
	var/mob/living/carbon/brainmob
	var/obj/item/device/lmi/LMI = M
	var/obj/item/device/mmi/MMI = M
	if(istype(M, /obj/item/device/lmi))
		brainmob = LMI.brainmob
		MMI = null
	else if(istype(M, /obj/item/device/mmi))
		brainmob = MMI.brainmob
		LMI = null
	if(!brainmob)
		return FALSE
	
	SetName("spider-bot ([brainmob.real_name])")
	real_name = brainmob.real_name
	brainmob.mind.transfer_to(src)
	if(LMI)
		QDEL_NULL(LMI.brainmob)
	else if(MMI)
		QDEL_NULL(MMI.brainmob)
	return TRUE

/mob/living/silicon/spiderbot/proc/explode() //When emagged.
	src.visible_message("<span class='danger'>\The [src] makes an odd warbling noise, fizzles, and explodes!</span>")
	explosion(get_turf(loc), -1, -1, 3, 5)
	eject_brain()
	death()

/mob/living/silicon/spiderbot/update_icons()
	overlays.Cut()
	update_inv_l_hand(FALSE)
	update_inv_s_store(FALSE)

/mob/living/silicon/spiderbot/on_update_icon()
	..()
	if(stat == DEAD)
		icon_state = "spiderbot-smashed"
	else if(lmi || mmi || positronic)
		if(positronic)
			icon_state = "spiderbot-chassis-posi"
		else
			icon_state = "spiderbot-chassis-mmi"
	else
		icon_state = "spiderbot-chassis"

/mob/living/silicon/spiderbot/update_inv_l_hand()
	if(l_hand)
		var/image/I = overlay_image(l_hand.icon, l_hand.icon_state)
		I.pixel_y = 5
		overlays |= I

/mob/living/silicon/spiderbot/proc/eject_brain()
	set name = "Eject brain"
	set category = "Abilities"
	set desc = "Explosively eject your current brain from your robotic body over to a safe distance."
	if(!lmi || !mmi || !positronic)
		to_chat(usr, SPAN_WARNING("Nothing to eject!!!"))
		return

	var/obj/item/B
	if(lmi)
		if(mind)
			lmi.transfer_identity(src)
			lmi.brainmob.dna = lmi.brainobj.dna
			mind.transfer_to(lmi.brainmob)
		B = lmi
	if(mmi)
		if(mind)
			mmi.transfer_identity(src)
			mmi.brainmob.dna = mmi.brainobj.dna
			mind.transfer_to(mmi.brainmob)
		B = mmi
	if(positronic)
		if(mind)
			positronic.transfer_identity(src)
			positronic.brainmob.dna = positronic.dna
			mind.transfer_to(positronic.brainmob)
		B = positronic

	B.forceMove(loc)
	B.throw_at_random(FALSE, 5, 20)
	real_name = initial(real_name)
	name = initial(name)
	positronic = null
	mmi = null
	lmi = null
	drop_item(loc)
	update_icon()

/mob/living/silicon/spiderbot/death()
	if(camera)
		camera.status = 0
	drop_item(loc)
	return ..()

/mob/living/silicon/spiderbot/examine(mob/user)
	. = ..(user)
	if(src.l_hand)
		to_chat(user, "It is carrying \icon[src.l_hand] \a [src.l_hand].")

//Item handling
/mob/living/silicon/spiderbot/put_in_hands(var/obj/item/W)
	if(!W)
		return FALSE
	if(!l_hand)
		W.update_held_icon()
		equip_to_slot(W, slot_l_hand)
		return TRUE
	drop_from_inventory(W)
	return FALSE

/mob/living/silicon/spiderbot/equip_to_slot(obj/item/W as obj, slot)
	if(!slot) return
	if(!istype(W)) return

	if(slot == slot_l_hand || slot == slot_r_hand)
		l_hand = W
		W.equipped(src, slot)
		W.screen_loc =  hands.screen_loc
		update_inv_l_hand(TRUE)
	else if(slot == slot_s_store)
		internal_storage = W
		W.equipped(src, slot)
		W.screen_loc = hud_storage.screen_loc
		update_inv_s_store(TRUE)
	else
		return
	W.forceMove(src)
	W.hud_layerise()
	if(W.action_button_name)
		update_action_buttons()
	update_icon()
	
/mob/living/silicon/spiderbot/u_equip(obj/item/W as obj)
	if(!istype(W))
		return FALSE
	if (W == l_hand)
		l_hand = null
		update_inv_l_hand(TRUE)
	else if (W == internal_storage)
		internal_storage = null
		W.dropped(src)
		update_inv_s_store(TRUE)
	else
		return FALSE
	update_action_buttons()
	update_icon()
	return TRUE

//Both hands are the same!
/mob/living/silicon/spiderbot/get_active_hand()
	return l_hand
/mob/living/silicon/spiderbot/get_inactive_hand()
	return l_hand
/mob/living/silicon/spiderbot/put_in_active_hand(var/obj/item/W)
	return put_in_hands(W)
/mob/living/silicon/spiderbot/put_in_inactive_hand(var/obj/item/W)
	return put_in_hands(W)
/mob/living/silicon/spiderbot/put_in_l_hand(var/obj/item/W)
	if(lying || !istype(W))
		return 0
	return put_in_hands(W)
/mob/living/silicon/spiderbot/put_in_r_hand(var/obj/item/W)
	return put_in_l_hand(W)

//Returns the item equipped to the specified slot, if any.
/mob/living/silicon/spiderbot/get_equipped_item(var/slot)
	switch(slot)
		if(slot_l_hand, slot_r_hand) 	return l_hand
		if(slot_s_store) 				return internal_storage
	return ..()

/mob/living/silicon/spiderbot/get_equipped_items(var/include_carried = 0)
	. = ..()
	if(internal_storage) . += internal_storage

//Droping either hands just drops the one held_item
/mob/living/silicon/spiderbot/drop_l_hand(var/atom/Target)
	return drop_from_inventory(l_hand, Target)
/mob/living/silicon/spiderbot/drop_r_hand(var/atom/Target)
	return drop_from_inventory(l_hand, Target)
/mob/living/silicon/spiderbot/drop_item(var/atom/Target)
	return drop_from_inventory(l_hand, Target)

/mob/living/silicon/spiderbot/get_all_inventory_slots()
	return list(slot_l_hand, slot_s_store)

/mob/living/silicon/spiderbot/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	if(carried_item in list(l_hand, silicon_radio, cell, camera, lmi))
		return 1
	return ..()

/mob/living/silicon/spiderbot/handle_hud_icons()
	. = ..()
	if (healths)
		if(stat == DEAD)
			healths.icon_state = "health7"
		else
			if(health >= maxHealth)
				healths.icon_state = "health0"
			else if(health >= (maxHealth * 0.75))
				healths.icon_state = "health1"
			else if(health >= (maxHealth * 0.50))
				healths.icon_state = "health2"
			else if(health >= (maxHealth * 0.25))
				healths.icon_state = "health3"
			else if(health >= 0)
				healths.icon_state = "health4"
			else if(health <= config.health_threshold_dead)
				src.healths.icon_state = "health5"
			else
				src.healths.icon_state = "health6"

	if(istype(cell))
		var/chargeNum = Clamp(ceil(cell.percent()/25), 0, 4)	//0-100 maps to 0-4, but give it a paranoid clamp just in case.
		cells.icon_state = "charge[chargeNum]"
		if(chargeNum == 4)
			cells.opacity = 0
		else
			cells.opacity = 1
	else
		cells.icon_state = "charge-empty"
	
	if(bodytemp)
		switch(bodytemperature) //310.055 optimal body temp
			if(335 to INFINITY)
				bodytemp.icon_state = "temp2"
			if(320 to 335)
				bodytemp.icon_state = "temp1"
			if(300 to 320)
				bodytemp.icon_state = "temp0"
			if(260 to 300)
				bodytemp.icon_state = "temp-1"
			else
				bodytemp.icon_state = "temp-2"
		if(bodytemp.icon_state == "temp0")
			bodytemp.opacity = 0
		else
			bodytemp.opacity = 1

	if(oxygen)
		oxygen.icon_state = "oxy1"
		if(loc)
			var/datum/gas_mixture/env = loc.return_air()
			if(env && env.return_pressure() > WARNING_LOW_PRESSURE)
				var/oxymoles = env.get_gas(GAS_OXYGEN)
				if(oxymoles && (oxymoles * 100 / env.total_moles) >= 16)
					oxygen.icon_state = "oxy0"

	if(fire)
		if(fire_alert == 1) //Heat warning
			fire.icon_state = "fire1"
		else if(fire_alert == 2) //Cold warning
			fire.icon_state = "fire0"
		else
			fire.icon_state = "fire0"

	if(stat != DEAD)
		if(blinded)
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
		else
			clear_fullscreen("blind")
			set_fullscreen(disabilities & NEARSIGHTED, "impaired", /obj/screen/fullscreen/impaired, 1)
			set_fullscreen(eye_blurry, "blurry", /obj/screen/fullscreen/blurry)
			set_fullscreen(druggy, "high", /obj/screen/fullscreen/high)

		if (machine)
			if (machine.check_eye(src) < 0)
				reset_view(null)
		else
			if(client && !client.adminobs)
				reset_view(null)
	return 1

/mob/living/silicon/spiderbot/a_intent_change(input as text)
	switch(input)
		if(I_HELP)
			a_intent = I_HELP
		if(I_HURT)
			a_intent = I_HURT
		if("right","left")
			a_intent = intent_numeric(intent_numeric(a_intent) - 3)
	if(hud_used && hud_used.action_intent)
		if(a_intent == I_HURT)
			hud_used.action_intent.icon_state = I_HURT
		else
			hud_used.action_intent.icon_state = I_HELP

/mob/living/silicon/spiderbot/Life()
	. = ..()
	//Atmos effects
	if(bodytemperature > SYNTH_HEAT_LEVEL_1)
		fire_alert = 1
		adjustFireLoss(0.5)
	else
		fire_alert = 0

/mob/living/silicon/spiderbot/movement_delay()
	var/tally = ..()
	tally += speed
	return tally + config.animal_delay