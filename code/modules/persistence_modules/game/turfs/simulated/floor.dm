/turf/simulated/floor
	var/prior_floortype = /turf/space
	var/prior_resources = list()

/turf/simulated/floor/New(var/newloc, var/floortype)
	..()
	ADD_SAVED_VAR(broken)
	ADD_SAVED_VAR(burnt)
	ADD_SAVED_VAR(flooring)
	ADD_SAVED_VAR(mineral)

/turf/simulated/floor/Initialize()
	if(flooring)
		set_flooring(flooring)
	else
		make_plating()
	. = ..()

/turf/simulated/floor/ReplaceWithLattice()
	var/resources = prior_resources
	var/floortype = prior_floortype
	src.ChangeTurf(prior_floortype)
	spawn()
		var/turf/simulated/T = locate(src.x, src.y, src.z)
		if(ispath(floortype, /turf/simulated))
			T.resources = resources
		new /obj/structure/lattice(T)

