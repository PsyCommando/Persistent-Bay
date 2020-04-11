/*

	Don't save faction networks, since they don't need anything saved at all.
*/

//========================================
//	Helpers
//========================================
/proc/CreateNewFaction(var/_uid, var/_name, var/_abbreviation, var/_short_tag, var/_desc)
	var/datum/world_faction/F = new(_uid, _name, _abbreviation, _short_tag, _desc)
	F.InitialSetup()
	return F

