//	Organs
/obj/item/organ/New()
	. = ..()
	matter = list(MATERIAL_PINK_GOO = w_class * 100)
	if(istype(owner))
		species = owner.species

	//Setup saved vars
	ADD_SAVED_VAR(min_broken_damage)
	ADD_SAVED_VAR(status)
	ADD_SAVED_VAR(owner)
	ADD_SAVED_VAR(dna)
	ADD_SAVED_VAR(species)
	ADD_SAVED_VAR(rejecting)
	ADD_SAVED_VAR(death_time)
	ADD_SAVED_VAR(organ_tag)

/obj/item/organ/Destroy()
#ifdef TESTING
	testing("Destroying [src]\ref[src]([x], [y], [z]), in \the '[loc]'\ref[loc]([loc?.x], [loc?.y], [loc?.z]), with owner: [owner? owner : "null"]\ref[owner]([owner?.x], [owner?.y], [owner?.z])!")
#endif
	species = null
	return ..()

/obj/item/organ/after_load()
	. = ..()
	if(istype(owner))
		w_class = max(w_class + mob_size_difference(owner.mob_size, MOB_MEDIUM), 1) //smaller mobs have smaller organs.
		if(!dna)
			set_dna(owner.dna)
		if(!species)
			species = owner.species
		if (!species)
			species = all_species[SPECIES_HUMAN]

	if(BP_IS_ROBOTIC(src))
		robotize()

/obj/item/organ/die()
	..()
	update_icon()

/obj/item/organ/is_preserved()
	if(istype(loc,/obj/item/organ))
		var/obj/item/organ/O = loc
		return O.is_preserved()
	else if(loc && loc.return_air())
		var/datum/gas_mixture/G = loc.return_air()
		return (G.temperature < T0C)
	else
		return (istype(loc,/obj/item/device/mmi) || istype(loc,/obj/structure/closet/body_bag/cryobag) || istype(loc,/obj/structure/closet/crate/freezer) || istype(loc,/obj/item/weapon/storage/box/freezer))

/obj/item/organ/robotize() //Being used to make robutt hearts, etc
	status = ORGAN_ROBOTIC
	update_icon()

/obj/item/organ/mechassist() //Used to add things like pacemakers, etc
	status = ORGAN_ASSISTED
	update_icon()

/obj/item/organ/removed(var/mob/living/user, var/drop_organ=1)
	if(!istype(owner) || QDELETED(owner))
		rejecting = null
		owner = null
		return
	return ..()
