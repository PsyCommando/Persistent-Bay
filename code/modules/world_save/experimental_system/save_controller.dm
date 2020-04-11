var/global/datum/controller/save_controller/SaveController = new()


/*
	Handles saving and loading the game
*/
/datum/controller/save_controller
	var/const/DEFAULT_MAP_SAVE_DIRECTORY = "map_save/"

/datum/controller/save_controller/proc/InitWorld()
	if(ShouldLoadMapFile())
		//load the map file
	else
		//load the saved map instead

/datum/map_template/load(no_changeturf = TRUE)


/datum/controller/save_controller/proc/ShouldLoadMapFile()
	return TRUE

/datum/controller/save_controller/proc/SaveWorld()
/datum/controller/save_controller/proc/LoadWorld()