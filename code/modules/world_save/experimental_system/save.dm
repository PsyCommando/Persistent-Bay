//Override for skipping blacklisted vars
/datum/Write(var/savefile/F, var/list/neversave = null)
	before_save(F)
	var/list/savetmp = null
	if(neversave && islist(neversave) && neversave.len)
		savetmp = list() //Holds the changed value of variables
		for(var/v in neversave)
			//If not saveable, pass
			if(!issaved(src.vars[v]))
				continue
			//If not default value, save cur value and set it to default, so it won't be saved by the default proc
			var/init = initial(src.vars[v])
			if(src.vars[v] != init)
				savetmp[v] = src.vars[v]
				src.vars[v] = init
	
	//Do base saving proc
	. = ..(F)
	
	//If we got any variables we changed the value of, we restore them
	if(savetmp)
		for(var/v in savetmp)
			src.vars[v] = savetmp[v]
	after_save(F)

//Some common things we don't want
/*
	Byond defines those already as tmp vars (http://www.byond.com/docs/ref/#/var/tmp):
    type 
    parent_type 
    vars 
    verbs 
    group 
    loc 
    locs 
    vis_locs 
    x 
    y 
    z 
    ckey 
    visibility 
    bound_x 
    bound_y 
    bound_width 
    bound_height 
    mouse_over_pointer 
    mouse_drag_pointer 
    mouse_drop_pointer 
*/
/atom/should_never_save(list/L)
	L.Add("icon","icon_state","overlays","underlays")
	return ..(L)

//No screen_loc please
/atom/movable/should_never_save(list/L)
	L.Add("screen_loc")
    return ..(L)

//Ckey is special
/mob/Write(var/savefile/F, var/list/neversave = null)
	. = ..(F, neversave)
	F.dir.Remove("key")
	return .

