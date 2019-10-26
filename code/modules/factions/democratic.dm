/datum/world_faction/democratic

	var/datum/democracy/governor/gov

	var/datum/assignment/councillor_assignment
	var/datum/assignment/judge_assignment
	var/datum/assignment/governor_assignment
	var/datum/assignment/resident_assignment
	var/datum/assignment/citizen_assignment
	var/datum/assignment/prisoner_assignment

	var/datum/assignment_category/special_category

	var/list/city_council = list()
	var/list/judges = list()

	var/council_amount = 5

	var/list/policy = list()

	var/list/criminal_laws = list()
	var/list/civil_laws = list()

	var/list/votes = list()
	var/list/vote_history = list()

	var/datum/election/current_election
	var/list/waiting_elections = list()
	var/active_elections = 1

	var/election_toggle = 0


	var/list/scheduled_trials = list()
	var/list/verdicts = list()


	var/tax_type_b = 1 // business 1 = flat, 2 = progressie
	var/tax_bprog1_rate = 0
	var/tax_bprog2_rate = 0
	var/tax_bprog3_rate = 0
	var/tax_bprog4_rate = 0
	var/tax_bprog2_amount = 0
	var/tax_bprog3_amount = 0
	var/tax_bprog4_amount = 0
	var/tax_bflat_rate = 0

	var/tax_type_p = 1 // personal 1 = flat, 2 = progressie
	var/tax_pprog1_rate = 0
	var/tax_pprog2_rate = 0
	var/tax_pprog3_rate = 0
	var/tax_pprog4_rate = 0
	var/tax_pprog2_amount = 0
	var/tax_pprog3_amount = 0
	var/tax_pprog4_amount = 0
	var/tax_pflat_rate = 0

/datum/world_faction/democratic/New()
	..()
	councillor_assignment = new("Councillor", 30)
	judge_assignment = new("Judge", 30)
	governor_assignment = new("Governor", 45)
	councillor_assignment.name = "Councillor"
	judge_assignment.name = "Judge"
	governor_assignment.name = "Governor"
	governor_assignment.uid = "governor"
	judge_assignment.uid = "judge"
	councillor_assignment.uid = "councillor"
	special_category = new()

	councillor_assignment.parent = special_category
	judge_assignment.parent = special_category
	governor_assignment.parent = special_category

	special_category.assignments |= councillor_assignment
	special_category.assignments |= judge_assignment
	special_category.assignments |= governor_assignment
	special_category.name = "Special Assignments"
	special_category.head_position = governor_assignment
	special_category.parent = src
	special_category.command_faction = 1
	// limits = new /datum/machine_limits/democracy()

	name = "Nexus City Government"
	abbreviation = "NEXUS"
	short_tag = "NEX"
	purpose = "To represent the citizenship of Nexus and keep the station operating."
	uid = "nexus"
	gov = new()
	var/datum/election/gov/gov_elect = new()
	gov_elect.ballots |= gov

	waiting_elections |= gov_elect

	var/datum/election/council_elect = new()
	var/datum/democracy/councillor/councillor1 = new()
	councillor1.title = "Councillor of Justice and Criminal Matters"
	city_council |= councillor1
	council_elect.ballots |= councillor1

	var/datum/democracy/councillor/councillor2 = new()
	councillor2.title = "Councillor of Budget and Tax Measures"
	city_council |= councillor2
	council_elect.ballots |= councillor2

	var/datum/democracy/councillor/councillor3 = new()
	councillor3.title = "Councillor of Commerce and Business Relations"
	city_council |= councillor3
	council_elect.ballots |= councillor3

	var/datum/democracy/councillor/councillor4 = new()
	councillor4.title = "Councillor for Culture and Ethical Oversight"
	city_council |= councillor4
	council_elect.ballots |= councillor4

	var/datum/democracy/councillor/councillor5 = new()
	councillor5.title = "Councillor for the Domestic Affairs"
	city_council |= councillor5
	council_elect.ballots |= councillor5

	waiting_elections |= council_elect

	network.name = "NEXUSGOV-NET"
	network.net_uid = "nexus"
	network.password = ""
	network.invisible = 0


/datum/world_faction/democratic/get_leadername()
	if(gov && gov.real_name != "")
		return gov.real_name
	else
		return leader_name

/datum/world_faction/democratic/proc/pay_tax(var/datum/money_account/account, var/amount)
	var/tax_amount
	if(account.account_type == 2)
		if(tax_type_b == 2)
			if(account.money >= tax_bprog4_amount)
				tax_amount = amount * (tax_bprog4_rate/100)
			else if(account.money >= tax_bprog3_amount)
				tax_amount = amount * (tax_bprog3_rate/100)
			else if(account.money >= tax_bprog2_amount)
				tax_amount = amount * (tax_bprog2_rate/100)
			else
				tax_amount = amount * (tax_bprog1_rate/100)
		else
			tax_amount = amount * (tax_bflat_rate/100)

	else
		if(tax_type_p == 2)
			if(account.money >= tax_pprog4_amount)
				tax_amount = amount * (tax_pprog4_rate/100)
			else if(account.money >= tax_pprog3_amount)
				tax_amount = amount * (tax_pprog3_rate/100)
			else if(account.money >= tax_pprog2_amount)
				tax_amount = amount * (tax_pprog2_rate/100)
			else
				tax_amount = amount * (tax_pprog1_rate/100)
		else
			tax_amount = amount * (tax_pflat_rate/100)
	tax_amount = round(tax_amount)
	if(tax_amount)
		var/datum/transaction/T = new("[src.name]", "Tax", -tax_amount, "Nexus Economy Network")
		account.do_transaction(T)
		var/datum/transaction/Te = new("[account.owner_name]", "Tax", tax_amount, "Nexus Economy Network")
		central_account.do_transaction(Te)







/datum/world_faction/democratic/proc/is_councillor(var/real_name)
	for(var/datum/democracy/ballot in city_council)
		if(ballot.real_name == real_name)
			return ballot

/datum/world_faction/democratic/proc/is_governor(var/real_name)
	if(!gov)
		return null
	if(gov.real_name == real_name)
		return gov

/datum/world_faction/democratic/proc/is_judge(var/real_name)
	for(var/datum/democracy/ballot in judges)
		if(ballot.real_name == real_name)
			return ballot

/datum/world_faction/democratic/proc/is_candidate(var/real_name)
	var/list/all_ballots = list()
	all_ballots |= gov
	all_ballots |= city_council
	for(var/datum/democracy/ballot in all_ballots)
		for(var/datum/candidate/candidate in ballot.candidates)
			if(candidate.real_name == real_name)
				return list(candidate, ballot)



/datum/world_faction/democratic/proc/start_election(var/datum/election/election)
	for(var/datum/democracy/ballot in election.ballots)
		for(var/datum/candidate/candidate in ballot.candidates)
			candidate.votes = list()

	current_election = election
	if(election.typed)
		election_toggle = !election_toggle
	command_announcement.Announce("An Election has started! [election.name]. Citizens will have twelve hours to cast their votes.","Election Start")

/datum/world_faction/democratic/proc/start_trial(var/datum/judge_trial/trial)
	command_announcement.Announce("A trial should be starting soon! [trial.name] with Judge [trial.judge] presiding.","Trial Start")
	scheduled_trials -= trial


/datum/world_faction/democratic/proc/end_election()
	for(var/datum/democracy/ballot in current_election.ballots)
		if(!ballot.candidates.len)
			continue
		var/list/leaders = list()
		var/datum/candidate/leader
		for(var/datum/candidate/candidate in ballot.candidates)
			if(!leader || candidate.votes.len > leader.votes.len)
				leaders.Cut()
				leader = candidate
				leaders |= candidate
			else if(candidate.votes.len == leader.votes.len)
				leaders |= candidate
				leader = candidate
		if(!leaders.len)
			command_announcement.Announce("In the election for [ballot.title], no one was elected!","Election Result")
		else if(leaders.len > 1)
			var/leaders_names = ""
			var/first = 1
			for(var/datum/candidate/candidate in leaders)
				if(first)
					leaders_names += candidate.real_name
					first = 0
				else
					leaders_names += ", [candidate.real_name]"
			leader = pick(leaders)
			command_announcement.Announce("In the election for [ballot.title], the election was tied between [leaders_names]. [leader.real_name] was randomly selected as the winner.","Election Result")
			if(ballot.real_name != leader.real_name)
				ballot.real_name = leader.real_name
				ballot.seeking_reelection = 1
			else
				ballot.consecutive_terms++
		else
			command_announcement.Announce("In the election for [ballot.title], the election was won by [leader.real_name].","Election Result")
			if(ballot.real_name != leader.real_name)
				ballot.real_name = leader.real_name
			else
				ballot.consecutive_terms++
		ballot.candidates.Cut()
		ballot.voted_ckeys.Cut()
		if(leader)
			leader.votes.Cut()
			ballot.candidates |= leader
			ballot.seeking_reelection = 1
	current_election = null




/datum/democracy
	var/real_name // real_name of elected
	var/term_start // real time
	var/title = "Councillor"
	var/description = "Vote on laws civil and criminal, the tax code and confirming judges nominated by the governor."
	var/consecutive_terms = 0

	var/election_desc = ""
	var/seeking_reelection = 1

	var/list/candidates = list()
	var/list/voted_ckeys = list() // to prevent double voting





