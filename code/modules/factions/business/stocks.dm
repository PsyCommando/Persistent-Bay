/datum/stockholder
	var/real_name = ""
	var/stocks = 0
	var/subscribed = 0

//-------------------------------
// Stocks Handling
//-------------------------------
/datum/world_faction/business/proc/pay_dividends(var/datum/money_account/account, var/amount)
	var/ceo_amount
	var/stock_amount
	if(ceo_tax)
		ceo_amount = round((amount/100)*ceo_tax)
	if(stockholder_tax)
		stock_amount = round((amount/100)*ceo_tax)
	if(ceo_amount)
		var/datum/money_account/target_account = get_account_record(leader_name)
		if(target_account)
			var/datum/transaction/T = new(leader_name, "CEO Revenue Share", -ceo_amount, "Nexus Economy Network")
			account.do_transaction(T)
			var/datum/transaction/Te = new("[account.owner_name]", "CEO Revenue Share", ceo_amount, "Nexus Economy Network")
			target_account.do_transaction(Te)
	if(stock_amount)
		var/amount_taken = 0
		for(var/x in stock_holders)
			var/datum/stockholder/holder = stock_holders[x]
			var/holder_amount = round((stock_amount/100)*holder.stocks)
			if(holder_amount)
				var/datum/money_account/target_account = get_account_record(holder.real_name)
				if(target_account)
					var/datum/transaction/Te = new("[account.owner_name]", "Stockholder Revenue Share", holder_amount, "Nexus Economy Network")
					target_account.do_transaction(Te)
					amount_taken += holder_amount
			if(amount_taken)
				var/datum/transaction/T = new("Shareholders", "Shareholder Revenue Share", -amount_taken, "Nexus Economy Network")
				account.do_transaction(T)

/datum/world_faction/business/proc/subscribe_stockholder(var/real_name)
	if(real_name in stock_holders)
		var/datum/stockholder/holder = stock_holders[real_name]
		holder.subscribed = 1

/datum/world_faction/business/proc/unsubscribe_stockholder(var/real_name)
	if(real_name in stock_holders)
		var/datum/stockholder/holder = stock_holders[real_name]
		holder.subscribed = 0

/datum/world_faction/business/proc/get_stockholder_datum(var/real_name)
	if(real_name in stock_holders)
		var/datum/stockholder/holder = stock_holders[real_name]
		return holder

/datum/world_faction/business/get_stockholder(var/real_name)
	if(real_name in stock_holders)
		var/datum/stockholder/holder = stock_holders[real_name]
		return holder.stocks

/datum/world_faction/business/proc/get_stockholder_subscribed(var/real_name)
	if(real_name in stock_holders)
		var/datum/stockholder/holder = stock_holders[real_name]
		return holder.subscribed

/datum/world_faction/business/proc/has_proposal(var/real_name)
	for(var/datum/stock_proposal/proposal in proposals)
		if(proposal.started_by == real_name) return 1

/datum/world_faction/business/proc/instant_dividend(var/target)
	if(target > 100) target = 100
	var/amount = (central_account.money/100)*target
	var/amount_taken = 0
	for(var/x in stock_holders)
		var/datum/stockholder/holder = stock_holders[x]
		var/holder_amount = round((amount/100)*holder.stocks)
		if(holder_amount)
			var/datum/money_account/target_account = get_account_record(holder.real_name)
			if(target_account)
				var/datum/transaction/Te = new("[central_account.owner_name]", "Instant Dividend", holder_amount, "Nexus Economy Network")
				target_account.do_transaction(Te)
				amount_taken += holder_amount
	if(amount_taken)
		var/datum/transaction/T = new("Shareholders", "Instant Dividend", -amount_taken, "Nexus Economy Network")
		central_account.do_transaction(T)

/datum/world_faction/business/proc/surrender_stocks(var/real_name)
	var/datum/stockholder/holder = get_stockholder_datum(real_name)
	if(holder)
		if(stock_holders.len == 1) // last stock holder
			stock_holders.Cut()
			LAZYREMOVE(GLOB.all_world_factions, src)
			qdel(src)
			return
		else
			var/remainder = holder.stocks % (stock_holders.len-1)
			var/division = (holder.stocks-remainder)/(stock_holders.len-1)
			stock_holders -= real_name
			for(var/datum/stockholder/secondholder in stock_holders)
				secondholder.stocks += division
			if(remainder)
				var/list/stock_holders_copy = stock_holders.Copy()
				for(var/x in 1 to remainder)
					if(!stock_holders_copy.len)
						stock_holders_copy = stock_holders.Copy()
					var/datum/stockholder/holderr = pick_n_take(stock_holders_copy)
					holderr.stocks++