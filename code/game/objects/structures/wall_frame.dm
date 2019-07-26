// Basically see-through walls. Used for windows
// If nothing has been built on the low wall, you can climb on it

/obj/structure/wall_frame
	name = "low wall"
	desc = "A low wall section which serves as the base of windows, amongst other things."
	icon = 'icons/obj/wall_frame.dmi'
	icon_state = "frame"

	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	anchored = 1
	density = 1
	throwpass = 1
	layer = TABLE_LAYER

	max_health = 100
	mass = 20
	damthreshold_brute 	= 5
	damthreshold_burn	= 5
	var/paint_color
	var/stripe_color

	blend_objects = list(/obj/machinery/door, /turf/simulated/wall) // Objects which to blend with
	noblend_objects = list(/obj/machinery/door/window)

/obj/structure/wall_frame/New(var/new_loc, var/materialtype)
	..()
	ADD_SAVED_VAR(paint_color)
	ADD_SAVED_VAR(stripe_color)

/obj/structure/wall_frame/Initialize(mapload, var/materialtype)
	if(materialtype)
		material = materialtype
	if(!material)
		material = DEFAULT_WALL_MATERIAL
	if(istext(material))
		material = SSmaterials.get_material_by_name(material)
	max_health = material.integrity
	. = ..()

/obj/structure/wall_frame/LateInitialize()
	. = ..()
	queue_icon_update()

/obj/structure/wall_frame/examine(mob/user)
	if(paint_color)
		to_chat(user, "<span class='notice'>It has a smooth coat of paint applied.</span>")
	. = ..()

/obj/structure/wall_frame/attackby(var/obj/item/weapon/W, var/mob/user)
	src.add_fingerprint(user)

	//grille placing
	if(istype(W, /obj/item/stack/material/rods))
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == get_dir(src, user))
				to_chat(user, "<span class='notice'>There is a window in the way.</span>")
				return
		place_grille(user, loc, W)
		return

	//window placing
	else if(istype(W,/obj/item/stack/material))
		var/obj/item/stack/material/ST = W
		if(ST.material.opacity > 0.7)
			return 0
		place_window(user, loc, SOUTHWEST, ST)

	if(isWrench(W))
		for(var/obj/structure/S in loc)
			if(istype(S, /obj/structure/window))
				to_chat(user, "<span class='notice'>There is still a window on the low wall!</span>")
				return
			else if(istype(S, /obj/structure/grille))
				to_chat(user, "<span class='notice'>There is still a grille on the low wall!</span>")
				return
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		to_chat(user, "<span class='notice'>Now disassembling the low wall...</span>")
		if(do_after(user, 40,src))
			if(!src) return
			to_chat(user, "<span class='notice'>You dissasembled the low wall!</span>")
			dismantle()

	return  ..()

/obj/structure/wall_frame/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1

// icon related

/obj/structure/wall_frame/on_update_icon()
	if(!material || istext(material))
		return //Don't let it update the icon when the material isn't set!
	overlays.Cut()
	var/image/I

	var/new_color = (paint_color ? paint_color : material.icon_colour)
	color = new_color

	for(var/i = 1 to 4)
		if(other_connections[i] != "0")
			I = image(icon, "frame_other[connections[i]]", dir = 1<<(i-1))
		else
			I = image(icon, "frame[connections[i]]", dir = 1<<(i-1))
		overlays += I

	if(stripe_color)
		for(var/i = 1 to 4)
			if(other_connections[i] != "0")
				I = image(icon, "stripe_other[connections[i]]", dir = 1<<(i-1))
			else
				I = image(icon, "stripe[connections[i]]", dir = 1<<(i-1))
			I.color = stripe_color
			overlays += I

	SetName("[material.display_name] [initial(name)]")

/obj/structure/wall_frame/hull/Initialize()
	. = ..()
	if(prob(40))
		var/spacefacing = FALSE
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(src, direction)
			var/area/A = get_area(T)
			if(A && (A.area_flags & AREA_FLAG_EXTERNAL))
				spacefacing = TRUE
				break
		if(spacefacing)
			var/bleach_factor = rand(10,50)
			paint_color = adjust_brightness(paint_color, bleach_factor)
	queue_icon_update()

/obj/structure/wall_frame/bullet_act(var/obj/item/projectile/Proj)
	var/proj_damage = Proj.get_structure_damage()
	var/damage = min(proj_damage, 100)
	take_damage(damage)
	return


/obj/structure/wall_frame/dismantle()
	refund_matter()
	qdel(src)

/obj/structure/wall_frame/destroyed()
	dismantle()

//Subtypes
/obj/structure/wall_frame/standard
	paint_color = COLOR_WALL_GUNMETAL

/obj/structure/wall_frame/titanium
	material = MATERIAL_TITANIUM

/obj/structure/wall_frame/hull
	paint_color = COLOR_HULL
