//Keep base class from overwriting loaded mineral spread
/turf/simulated/mineral/MineralSpread()
	//If we're running this on init, from a turf loaded from the save, skip
	if(!(atom_flags & ATOM_FLAG_INITIALIZED) && map_storage_loaded)
		return
	. = ..()

//Override the base one to work with stackable ore
/turf/simulated/mineral/DropMineral(var/howmany)
	if(!mineral)
		return

	clear_ore_effects()
	var/obj/item/stack/ore/O = new(src, mineral.name)
	if(geologic_data && istype(O))
		geologic_data.UpdateNearbyArtifactInfo(src)
		O.geologic_data = geologic_data
	if(howmany >= 0)
		O.add(howmany-1)
	return O