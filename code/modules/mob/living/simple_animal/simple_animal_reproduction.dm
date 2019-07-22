/mob/living/simple_animal
	//Reproduction stuff
	gender 							= NEUTER
	var/fertility 					= 0.5	 	//How fertile is a mob. Multiplier used to determine the chances of becoming pregnant
	var/pregnancy 					= 0.0 		//The pregnancy progression modifier.{0..1} Basically, incrments from 0 to 1, depending on feeding and etc during pregnancy. When it hit 1, the offspring is born
	var/reproduce_chance 			= 0.1 		//Chances for this reproduction attempt to result in pregnancy
	var/offspring_type 				= null 		//What offspring will this mob deliver
	var/max_age						= 0			//Oldest age in days a mob of this type might live to
	var/age_growup					= 0 		//If the mob may grow into an adult, set the required age
	var/tmp/time_next_reproduction 	= 0 		//time when the mob will attempt reproduction again
	var/tmp/time_next_delivery 		= 0 		//Time in which we'll try to deliver next
	var/time_birth					= 0			//Realtime when the mob was created/born

	//Reproduction AI
	var/mob/living/simple_animal/target_mate

/mob/living/simple_animal/New()
	. = ..()
	time_birth = REALTIMEOFDAY
	ADD_SAVED_VAR(gender)
	ADD_SAVED_VAR(fertility)
	ADD_SAVED_VAR(pregnancy)
	ADD_SAVED_VAR(reproduce_chance)
	ADD_SAVED_VAR(offspring_type)
	ADD_SAVED_VAR(time_birth)
	ADD_SAVED_VAR(max_age)
	ADD_SAVED_VAR(age_growup)

//
// Reproduction stuff
//
/mob/living/simple_animal/proc/handle_reproduction()
	if(pregnancy == 0 || nutrition < (max_nutrition * 0.50) || health < maxHealth) //only do anything about reproduction if we're fed at all
		return
	pregnancy = between(0, pregnancy + 0.001, 1.0)

	if(pregnancy >= 1.0 && world.time >= time_next_delivery)
		deliver() //Time to have an offspring!

//Yeah..
/mob/living/simple_animal/proc/try_make_babies(var/mob/living/simple_animal/mate)
	if(pregnancy > 0 || fertility <= 0) //Can't get pregnant twice
		return FALSE

	//Do anim or emote or something
	var/pregchance = fertility * (health / (maxHealth+1)) * (nutrition / (max_nutrition+1)) * 5 //base chance is 5 percent

	//mission successful
	if(prob(pregchance))
		pregnancy = 0.01 //Start at 1%
		time_next_reproduction = 0
		testing("[src]\ref[src] made [mate]\ref[mate] pregnant!")
		return TRUE

	//Best luck next time!
	time_next_reproduction = world.time + (rand(30 SECONDS, 5 MINUTES)) //Its random between 30 secs and 5 minutes
	return FALSE

//Whether two critter can be compatible partners
/mob/living/simple_animal/proc/compatible_gender(var/mob/living/simple_animal/mate)
	return (gender == MALE && mate.gender == FEMALE) || (gender == FEMALE && mate.gender == MALE)

//Have babies
/mob/living/simple_animal/proc/deliver()
	//Only deliver if we're fed enough to pay the cost
	if(nutrition < (max_nutrition * 0.25))
		return FALSE

	nutrition = max(0, nutrition - (max_nutrition * 0.25))
	var/off = new offspring_type(get_turf(src))
	testing("[src]\ref[src] gave birth to [off]\ref[off]!")

//Returns age in days
/mob/living/simple_animal/proc/get_age()
	return (REALTIMEOFDAY - time_birth) / 24 HOURS

//Handle aging effect
/mob/living/simple_animal/proc/handle_age()
	var/age = get_age()
	if(age_growup && age >= age_growup)
		grow_up()
	if(max_age && age >= max_age && prob(abs(max_age - age)))
		adjustToxLoss(maxHealth) //Game over man

//For mobs that support it, grow up into an adult form
/mob/living/simple_animal/proc/grow_up()
	testing("[src]\ref[src] is growning up at age [get_age()]!")
	return //default does nothing

//Return a value from 0 to 1+ indicating how good of a pick this mob is for the given enquirer
/mob/living/simple_animal/proc/reproduction_candidate_score(var/mob/living/simple_animal/A)
	if(A.type != type)
		return 0 //no inter-specie plz
	if(pregnancy > 0)
		return 0 //No pregnant mobs
	if(!compatible_gender(A))
		return 0 //We need things that can mate
	//Fertility, nutrition, health, and age affect the mate rating
	var/age_factor = (get_age() >= 1)? 1.0/get_age() : 0
	return (fertility * (nutrition / max_nutrition) * (health / maxHealth)) - age_factor
