//
// Voxslugs
//
/mob/living/simple_animal/hostile/voxslug/Move()
	. = ..()
	if(.)
		pixel_x = rand(-10,10)
		pixel_y = rand(-10,10)

/mob/living/simple_animal/hostile/voxslug/Found(var/atom/A)
	if(istype(A, /obj/machinery/mining/drill))
		var/obj/machinery/mining/drill/drill = A
		if(drill.active)
			stance = HOSTILE_STANCE_ATTACK
			return A
	if(istype(A, /obj/structure/ore_box))
		stance = HOSTILE_STANCE_ATTACK
		return A
	if(istype(A, /obj/item/stack/ore))
		stance = HOSTILE_STANCE_ATTACK
		return A

/mob/living/simple_animal/hostile/voxslug/Allow_Spacemove(var/check_drift = 0)
	return 1 // Ripped from space carp, no more floating


//
// Bats
//
/mob/living/simple_animal/hostile/scarybat/locusectums
	name = "locusectums"
	desc = "A swarm of of terrible locusectum."
	meat_amount = 2
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	melee_damage_lower = 4
	faction = "asteroid"
/mob/living/simple_animal/hostile/scarybat/locusectums/Allow_Spacemove()
	return TRUE // Ripped from space carp, no more floating


//
// GREED
//
/mob/living/simple_animal/hostile/creature/greed
	name = "GREED" // never uncapitalize GREED
	health = 60
	maxHealth = 60
	melee_damage_lower = 20
	melee_damage_upper = 30
	move_to_delay = 12
	destroy_surroundings = 1
	faction = "asteroid"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	should_save = 0
	meat_amount = 10
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/xenomeat
/mob/living/simple_animal/hostile/creature/greed/Found(var/atom/A)
	if(istype(A, /obj/machinery/mining/drill))
		var/obj/machinery/mining/drill/drill = A
		if(drill.active)
			stance = HOSTILE_STANCE_ATTACK
			return A
	if(istype(A, /obj/structure/ore_box))
		stance = HOSTILE_STANCE_ATTACK
		return A
	if(istype(A, /obj/item/stack/ore))
		stance = HOSTILE_STANCE_ATTACK
		return A
/mob/living/simple_animal/hostile/creature/greed/Allow_Spacemove()
	return 1

//
//
//
/mob/living/simple_animal/hostile/faithless
	desc = "The loss of faith leaves a burning absence."