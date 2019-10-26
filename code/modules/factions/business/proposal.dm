/datum/stock_proposal
	var/func = 0
	var/required = 0
	var/list/supporting = list()
	var/datum/stockholder/started_by
	var/name
	var/target
	var/datum/world_faction/business/connected_faction

/datum/stock_proposal/proc/is_supporting(var/real_name)
	for(var/datum/stockholder/holder in supporting)
		if(holder.real_name == real_name) return 1

/datum/stock_proposal/proc/is_started_by(var/real_name)
	if(started_by == real_name) return 1

/datum/stock_proposal/proc/get_support()
	var/amount = 0
	for(var/datum/stockholder/holder in supporting)
		amount += holder.stocks
	if(amount > required)
		pass_proposal()
	return amount

/datum/stock_proposal/proc/pass_proposal()
	connected_faction.pass_proposal(src)

//
//
//
/datum/world_faction/business/proc/pass_proposal(var/datum/stock_proposal/proposal)
	if(!proposal) return
	switch(proposal.func)
		if(STOCKPROPOSAL_CEOFIRE)
			leader_name = ""
		if(STOCKPROPOSAL_CEOREPLACE)
			leader_name = proposal.target
			if(!get_record(proposal.target))
				var/datum/computer_file/report/crew_record/record = new()
				if(record.load_from_global(proposal.target))
					records.faction_records |= record
		if(STOCKPROPOSAL_CEOWAGE)
			var/datum/accesses/access = CEO.accesses[1]
			access.pay = proposal.target
		if(STOCKPROPOSAL_CEOTAX)
			ceo_tax = proposal.target
		if(STOCKPROPOSAL_STOCKHOLDERTAX)
			stockholder_tax = proposal.target
		if(STOCKPROPOSAL_INSTANTDIVIDEND)
			instant_dividend(proposal.target)
		if(STOCKPROPOSAL_PUBLIC)
			public_stock = 1
		if(STOCKPROPOSAL_UNPUBLIC)
			public_stock = 0
			buyorders.L.Cut()
			sellorders.L.Cut()

	proposals -= proposal

/datum/world_faction/business/proc/create_proposal(var/real_name, var/func, var/target)
	var/datum/stock_proposal/proposal = new()
	proposal.started_by = real_name
	proposal.func = func
	proposal.target = target
	switch(func)
		if(STOCKPROPOSAL_CEOFIRE)
			proposal.required = 51
			proposal.name = "Proposal to fire the current CEO."
		if(STOCKPROPOSAL_CEOREPLACE)
			proposal.required = 51
			proposal.name = "Proposal to make [target] the CEO of the business."
		if(STOCKPROPOSAL_CEOWAGE)
			proposal.name = "Proposal to change CEO wage to [target]."
			if(target > get_ceo_wage())
				proposal.required = 75
			else
				proposal.required = 51
		if(STOCKPROPOSAL_CEOTAX)
			proposal.name = "Proposal to change CEO revenue share to [target]."
			if(target > ceo_tax)
				proposal.required = 75
			else
				proposal.required = 51
		if(STOCKPROPOSAL_STOCKHOLDERTAX)
			proposal.name = "Proposal to change stockholders revenue share to [target]."
			if(target < ceo_tax)
				proposal.required = 61
			else
				proposal.required = 51
		if(STOCKPROPOSAL_INSTANTDIVIDEND)
			proposal.name = "Proposal to enact an instant dividend of [target]%."
			proposal.required = 51
		if(STOCKPROPOSAL_PUBLIC)
			proposal.name = "Proposal to publically list the business on the stock market."
			proposal.required = 51
		if(STOCKPROPOSAL_UNPUBLIC)
			proposal.name = "Proposal to remove the business from the stock market listings.."
			proposal.required = 75
	proposals |= proposal
	proposal.connected_faction = src
