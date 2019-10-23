//-------------------------------------
// Verdict
//-------------------------------------
/datum/verdict
	var/name = "" //title
	var/judge = ""
	var/defendant = ""
	var/body = ""
	var/time_rendered = 0
	var/citizenship_change = 0

//-------------------------------------
// Trial
//-------------------------------------
/datum/judge_trial
	var/name = "" //title
	var/judge = ""
	var/defendant = ""
	var/plaintiff = ""
	var/body = ""
	var/month = ""
	var/day = 0
	var/hour = 0

//-------------------------------------
// Faction trial handling
//-------------------------------------
/datum/world_faction/democratic/proc/render_verdict(var/datum/verdict/verdict)
	verdicts |= verdict
	command_announcement.Announce("Judge [verdict.judge] has rendered a verdict! [verdict.name].","Judicial Decision")

/datum/world_faction/democratic/proc/schedule_trial(var/datum/judge_trial/trial)
	scheduled_trials |= trial

/datum/world_faction/democratic/proc/cancel_trial(var/datum/judge_trial/trial)
	scheduled_trials -= trial
