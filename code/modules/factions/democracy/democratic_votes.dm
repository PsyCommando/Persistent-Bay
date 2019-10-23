//-------------------------------------
// Council vote
//-------------------------------------
/datum/council_vote
	var/name = "" // title of votes
	var/bill_type = 1 //  1 = criminal law, 2 = civil law, 3 = tax policy, 4 = impeachment (judge) 5 = nomination (judge) 6 = repeal law
	var/sponsor = "" // real_name of the vote starter
	var/time_started // realtime of when the vote started.
	var/time_signed // realtime when passed
	var/signer = ""
	var/list/yes_votes = list()
	var/list/no_votes = list()
	var/body = "" // used by civil and criminal laws
	var/tax = 0 // 1 = personal 2 = business
	var/taxtype = 1 // 1 = flat, 2 = progressive
	var/flatrate = 0
	var/prograte1 = 0
	var/prograte2 = 0
	var/prograte3 = 0
	var/prograte4 = 0
	var/progamount2 = 0
	var/progamount3 = 0
	var/progamount4 = 0
	var/impeaching = "" // real_name of impaechment target
	var/nominated = ""
	var/datum/council_vote/repealing

//-------------------------------------
// Faction votes handling
//-------------------------------------
/datum/world_faction/democratic/proc/withdraw_vote(var/datum/council_vote/vote)
	votes -= vote

/datum/world_faction/democratic/proc/defeat_vote(var/datum/council_vote/vote)
	var/subject = "Law Defeated ([vote.name])"
	var/body = "A law has been defeated on [stationtime2text()], [stationdate2text()]."
	notify_council(subject,body)
	votes -= vote

/datum/world_faction/democratic/proc/start_vote(var/datum/council_vote/vote)
	var/subject = "New Law Proposal ([vote.name])"
	var/body = "A new law has been proposed on [stationtime2text()], [stationdate2text()] by [vote.sponsor]. Please view it as soon as possible."
	notify_council(subject,body)
	votes |= vote

/datum/world_faction/democratic/proc/notify_council(var/subject, var/body)
	for(var/datum/democracy/councillor in city_council)
		Send_Email(councillor.real_name, "Nexus City Government", subject, body)
	Send_Email(gov.real_name, "Nexus City Government", subject, body)

/datum/world_faction/democratic/proc/has_vote(var/real_name)
	for(var/datum/council_vote/vote in votes)
		if(vote.sponsor == real_name)
			return 1

/datum/world_faction/democratic/proc/vote_yes(var/datum/council_vote/vote, var/mob/user)
	vote.yes_votes |= user.real_name
	if(vote.yes_votes.len >= 5)
		pass_vote(vote)
	else if(vote.yes_votes.len >= 3 && vote.signer != "")
		pass_vote(vote)

/datum/world_faction/democratic/proc/vote_no(var/datum/council_vote/vote, var/mob/user)
	vote.no_votes |= user.real_name
	if(vote.no_votes.len >= 3)
		defeat_vote(vote)

/datum/world_faction/democratic/proc/repeal_policy(var/datum/council_vote/vote)
	policy -= vote
	command_announcement.Announce("Governor [gov.real_name] has repealed an executive policy! [vote.name].","Governor Action")
	GLOB.discord_api.broadcast("Governor [gov.real_name] has repealed an executive policy! [vote.name].")

/datum/world_faction/democratic/proc/pass_policy(var/datum/council_vote/vote)
	policy |= vote
	command_announcement.Announce("Governor [vote.signer] has passed an executive policy! [vote.name].","Governor Action")
	GLOB.discord_api.broadcast("Governor [vote.signer] has passed an executive policy! [vote.name].")

/datum/world_faction/democratic/proc/pass_nomination_judge(var/datum/democracy/judge)
	judges |= judge
	command_announcement.Announce("The government has approved the nomination of [judge.real_name] for judge. They are now Judge [judge.real_name].","Nomination Pass")
	GLOB.discord_api.broadcast("The government has approved the nomination of [judge.real_name] for judge. They are now Judge [judge.real_name].")

/datum/world_faction/democratic/proc/pass_impeachment_judge(var/datum/democracy/judge)
	judges -= judge
	command_announcement.Announce("The government has voted to remove [judge.real_name] from their position of judge.","Impeachment")
	GLOB.discord_api.broadcast("The government has voted to remove [judge.real_name] from their position of judge.")

/datum/world_faction/democratic/proc/pass_vote(var/datum/council_vote/vote)
	votes -= vote
	vote.time_signed = world.realtime
	var/subject = "Law passed ([vote.name])"
	var/body = "A law has been passed on [stationtime2text()], [stationdate2text()]."
	notify_council(subject,body)
	if(vote.bill_type == 3)
		if(vote.tax == 2)
			if(vote.taxtype == 2)
				tax_bprog1_rate = vote.prograte1
				tax_bprog2_rate = vote.prograte2
				tax_bprog3_rate = vote.prograte3
				tax_bprog4_rate = vote.prograte4

				tax_bprog2_amount = vote.progamount2
				tax_bprog3_amount = vote.progamount3
				tax_bprog4_amount = vote.progamount4
				tax_type_b = 2
				command_announcement.Announce("The government has just passed a new progressive tax policy for business income.","Business Tax")
				GLOB.discord_api.broadcast("The government has just passed a new progressive tax policy for business income.")
			else
				tax_bflat_rate = vote.flatrate
				tax_type_b = 1
				command_announcement.Announce("The government has just passed a new flat tax policy for business income.","Business Tax")
				GLOB.discord_api.broadcast("The government has just passed a new flat tax policy for business income.")
		else
			if(vote.taxtype == 2)
				tax_pprog1_rate = vote.prograte1
				tax_pprog2_rate = vote.prograte2
				tax_pprog3_rate = vote.prograte3
				tax_pprog4_rate = vote.prograte4

				tax_pprog2_amount = vote.progamount2
				tax_pprog3_amount = vote.progamount3
				tax_pprog4_amount = vote.progamount4
				tax_type_p = 2
				command_announcement.Announce("The government has just passed a new progressive tax policy for personal income.","Personal Income Tax")
				GLOB.discord_api.broadcast("The government has just passed a new progressive tax policy for personal income.")
			else
				tax_pflat_rate = vote.flatrate
				tax_type_p = 1
				command_announcement.Announce("The government has just passed a new flat tax policy for personal income.","Personal Income Tax")
				GLOB.discord_api.broadcast("The government has just passed a new flat tax policy for personal income.")
	else if(vote.bill_type == 4)
		for(var/datum/democracy/judge in judges)
			if(judge.real_name == vote.impeaching)
				pass_impeachment_judge(judge)
				return 1

	else if(vote.bill_type == 5)
		if(is_governor(vote.nominated) || is_councillor(vote.nominated) || is_judge(vote.nominated))
			return 0
		var/datum/democracy/judge/judge = new()
		judge.real_name = vote.nominated
		pass_nomination_judge(judge)

	else if(vote.bill_type == 6)
		if(vote.repealing)
			civil_laws -= vote.repealing
			criminal_laws -= vote.repealing
			command_announcement.Announce("The government has just repealed a law! ([vote.repealing.name]).","Law Repeal")
			GLOB.discord_api.broadcast("The government has just repealed a law! ([vote.repealing.name]).")


	else if(vote.bill_type == 1)
		criminal_laws |= vote
		command_announcement.Announce("The government has just passed a new criminal law. [vote.name]","New Criminal Law")
		GLOB.discord_api.broadcast("The government has just passed a new criminal law. [vote.name]")

	else if(vote.bill_type == 2)
		civil_laws |= vote
		command_announcement.Announce("The government has just passed a new civil law. [vote.name]","New Civil Law")
		GLOB.discord_api.broadcast("The government has just passed a new civil law. [vote.name]")
