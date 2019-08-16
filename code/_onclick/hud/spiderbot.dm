/mob/living/silicon/spiderbot
	hud_type = /datum/hud/spiderbot
	var/obj/screen/hud_radio
	var/obj/screen/inventory/hud_storage

/datum/hud/spiderbot/FinalizeInstantiation()
	var/mob/living/silicon/spiderbot/target = mymob
	var/obj/screen/using

	if(!istype(target))
		return

	src.adding = list()
	src.other = list()
	src.hotkeybuttons = list() //These can be disabled for hotkey usersx

//Radio
	if(target.silicon_radio)
		target.hud_radio = new /obj/screen()
		target.hud_radio.SetName("radio")
		target.hud_radio.set_dir(SOUTHWEST)
		target.hud_radio.icon = 'icons/mob/screen1_robot.dmi'
		target.hud_radio.icon_state = "radio"
		target.hud_radio.screen_loc = ui_movi
		src.adding |= target.hud_radio

//Intent
	action_intent = new /obj/screen()
	action_intent.SetName("act_intent")
	action_intent.set_dir(SOUTHWEST)
	action_intent.icon = 'icons/mob/screen1_robot.dmi'
	action_intent.icon_state = mymob.a_intent
	action_intent.screen_loc = ui_acti
	src.adding |= action_intent

//Cell
	target.cells = new /obj/screen()
	target.cells.icon = 'icons/mob/screen1_robot.dmi'
	target.cells.icon_state = "charge-empty"
	target.cells.SetName("cell")
	target.cells.screen_loc = ui_toxin
	src.adding |= target.cells

//Health
	target.healths = new /obj/screen()
	target.healths.icon = 'icons/mob/screen1_robot.dmi'
	target.healths.icon_state = "health0"
	target.healths.SetName("health")
	target.healths.screen_loc = ui_health
	src.adding |= target.healths

//Temp
	target.bodytemp = new /obj/screen()
	target.bodytemp.icon = 'icons/mob/screen1_robot.dmi'
	target.bodytemp.icon_state = "temp0"
	target.bodytemp.SetName("body temperature")
	target.bodytemp.screen_loc = ui_temp
	src.adding |= target.bodytemp

//Oxygen
	target.oxygen = new /obj/screen()
	target.oxygen.icon = 'icons/mob/screen1_robot.dmi'
	target.oxygen.icon_state = "oxy0"
	target.oxygen.SetName("oxygen")
	target.oxygen.screen_loc = ui_oxygen
	src.adding |= target.oxygen

//Fire
	target.fire = new /obj/screen()
	target.fire.icon = 'icons/mob/screen1_robot.dmi'
	target.fire.icon_state = "fire0"
	target.fire.SetName("fire")
	target.fire.screen_loc = ui_fire
	src.adding |= target.fire

//Pull
	target.pullin = new /obj/screen()
	target.pullin.icon = 'icons/mob/screen1_robot.dmi'
	target.pullin.icon_state = "pull0"
	target.pullin.SetName("pull")
	target.pullin.screen_loc = ui_borg_pull
	src.adding |= target.pullin

//Resist
	// using = new /obj/screen()
	// using.SetName("resist")
	// using.icon = 'icons/mob/screen1_robot.dmi'
	// using.icon_state = "act_resist"
	// using.screen_loc = ui_pull_resist
	// src.adding |= using

//Target zone selection
	target.zone_sel = new /obj/screen/zone_sel()
	target.zone_sel.icon = 'icons/mob/screen1_robot.dmi'
	target.zone_sel.overlays.Cut()
	target.zone_sel.overlays += image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]")
	src.adding |= target.zone_sel

//Hand (spiderbots can hold a single thing)
	var/obj/screen/inventory/lhand = new /obj/screen/inventory()
	lhand.SetName("hand")
	lhand.icon = 'icons/mob/screen1_robot.dmi'
	lhand.icon_state = "inv1 +a" //Since its the only one, its always active
	lhand.set_dir(SOUTHWEST)
	lhand.screen_loc = ui_inv1
	lhand.slot_id = slot_l_hand
	target.hands = lhand
	src.adding |= lhand

//Storage slot
	target.hud_storage = new /obj/screen/inventory()
	target.hud_storage.SetName("storage")
	target.hud_storage.icon = 'icons/mob/screen1_robot.dmi'
	target.hud_storage.icon_state = "blankhud"
	target.hud_storage.screen_loc = ui_borg_store
	target.hud_storage.slot_id = slot_s_store
	src.adding |= target.hud_storage
	
//Drop
	// using = new /obj/screen()
	// using.SetName("drop")
	// using.icon = 'icons/mob/screen1_robot.dmi'
	// using.icon_state = "act_drop"
	// using.screen_loc = ui_dropbutton
	// src.adding |= using

//Throw
	// target.throw_icon = new /obj/screen()
	// target.throw_icon.icon = 'icons/mob/screen1_robot.dmi'
	// target.throw_icon.icon_state = "act_throw_off"
	// target.throw_icon.SetName("throw")
	// target.throw_icon.screen_loc = ui_drop_throw
	// src.hotkeybuttons |= target.throw_icon

//Handle the gun settings buttons
	mymob.gun_setting_icon = new /obj/screen/gun/mode(null)
	mymob.item_use_icon = new /obj/screen/gun/item(null)
	mymob.gun_move_icon = new /obj/screen/gun/move(null)
	mymob.radio_use_icon = new /obj/screen/gun/radio(null)

	mymob.client.screen = list()
	mymob.client.screen += src.adding + src.hotkeybuttons

/mob/living/silicon/spiderbot/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 0
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 1
