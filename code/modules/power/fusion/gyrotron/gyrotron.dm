#define GYRO_POWER 25000

/obj/machinery/power/emitter/gyrotron
	name = "gyrotron"
	icon = 'icons/obj/machines/power/fusion.dmi'
	desc = "It is a heavy duty industrial gyrotron suited for powering fusion reactors."
	icon_state = "emitter-off"
	req_access = list(core_access_engineering_programs)
	use_power = POWER_USE_IDLE
	active_power_usage = GYRO_POWER

	var/initial_id_tag
	var/rate = 3
	var/mega_energy = 1

/obj/machinery/power/emitter/gyrotron/New()
	. = ..()
	ADD_SAVED_VAR(rate)
	ADD_SAVED_VAR(mega_energy)

/obj/machinery/power/emitter/gyrotron/anchored
	anchored = TRUE
	state = 2

/obj/machinery/power/emitter/gyrotron/Initialize()
	set_extension(src, /datum/extension/fusion_plant_member, /datum/extension/fusion_plant_member)
	if(initial_id_tag)
		var/datum/extension/fusion_plant_member/fusion = get_extension(src, /datum/extension/fusion_plant_member)
		fusion.set_tag(null, initial_id_tag)
	change_power_consumption(mega_energy * GYRO_POWER, POWER_USE_ACTIVE)
	. = ..()

/obj/machinery/power/emitter/gyrotron/Process()
	change_power_consumption(mega_energy * GYRO_POWER, POWER_USE_ACTIVE)
	. = ..()

/obj/machinery/power/emitter/gyrotron/get_rand_burst_delay()
	return rate*10

/obj/machinery/power/emitter/gyrotron/get_burst_delay()
	return rate*10

/obj/machinery/power/emitter/gyrotron/get_emitter_beam()
	var/obj/item/projectile/beam/emitter/E = ..()
	E.force = mega_energy * 50
	return E

/obj/machinery/power/emitter/gyrotron/on_update_icon()
	if (active && powernet && avail(active_power_usage))
		icon_state = "emitter-on"
	else
		icon_state = "emitter-off"

/obj/machinery/power/emitter/gyrotron/attackby(var/obj/item/W, var/mob/user)
	if(isMultitool(W))
		var/datum/extension/fusion_plant_member/fusion = get_extension(src, /datum/extension/fusion_plant_member)
		fusion.get_new_tag(user)
		return
	return ..()

#undef GYRO_POWER
