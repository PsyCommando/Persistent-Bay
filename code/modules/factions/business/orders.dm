/datum/world_faction/business/proc/verify_orders()
	for(var/datum/stock_order/order in buyorders.L)
		var/datum/computer_file/report/crew_record/R = Retrieve_Record(order.real_name)
		if(!R || !R.linked_account)
			buyorders.L -= order
			continue
		if(R.linked_account.money < order.get_total_value())
			buyorders.L -= order
			continue
	for(var/datum/stock_order/order in sellorders.L)
		if(get_stockholder(order.real_name) < order.get_remaining_volume())
			sellorders.L -= order
			continue

/datum/world_faction/business/proc/get_last_hour()
	if(!stock_sales_data.len) return 0
	return text2num(stock_sales_data[stock_sales_data.len])

/datum/world_faction/business/proc/get_last_24()
	var/total = 0
	for(var/x in stock_sales_data)
		total += text2num(x)
	return total

/datum/world_faction/business/proc/get_best_buy()
	if(!buyorders.L.len) return null
	var/datum/stock_order/order = buyorders.L[1]
	if(order)
		return order.price
/datum/world_faction/business/proc/get_best_sell()
	if(!sellorders.L.len) return null
	var/datum/stock_order/order = sellorders.L[1]
	if(order)
		return order.price

/datum/world_faction/business/proc/fill_order(var/datum/stock_order/buyorder, var/datum/stock_order/sellorder)
	if(buyorder.price > sellorder.price) return
	var/buyer_name = buyorder.real_name
	var/datum/computer_file/report/crew_record/buyer = Retrieve_Record(buyorder.real_name)
	var/datum/computer_file/report/crew_record/seller = Retrieve_Record(sellorder.real_name)
	var/datum/stockholder/initial_holder = get_stockholder_datum()
	if(!buyer || !seller) return
	var/moving = min(buyorder.get_remaining_volume(), sellorder.get_remaining_volume())
	if(initial_holder.stocks < moving)
		moving = initial_holder.stocks
	var/cost = moving*sellorder.price

	if(!buyer.linked_account.money >= cost || ((moving + buyer.get_holdings()) > buyer.get_stock_limit()))
		var/datum/stockholder/new_holder = get_stockholder_datum(buyer_name)
		if(!new_holder)
			new_holder = new()
			new_holder.real_name = buyer_name
			stock_holders |= new_holder
		var/datum/transaction/T = new("Stock Buy", "Buy Order for [moving] stocks of [uid]", -cost, "Stock Market")
		buyer.linked_account.do_transaction(T)
		var/datum/transaction/Te = new("Stock Sale", "Sell Order for [moving] stocks of [uid]", cost, "Stock Market")
		seller.linked_account.do_transaction(Te)
		sellorder.filled += moving
		buyorder.filled += moving
		stock_sales += moving
		if(!sellorder.get_remaining_volume())
			sellorders.L -= sellorder
		if(!buyorder.get_remaining_volume())
			buyorders.L -= buyorder
	else
		buyorders.L -= buyorder
		return 0

/datum/world_faction/business/proc/cancel_order(var/datum/stock_order/order)
	buyorders.L -= order
	sellorders.L -= order

/datum/world_faction/business/proc/add_buyorder(var/price, var/volume, var/real_name)
	var/datum/stock_order/order = new()
	order.price = price
	order.volume = volume
	order.real_name = real_name
	for(var/datum/stock_order/sell_order in sellorders.L)
		if(!order.get_remaining_volume()) break
		if(sell_order.price <= order.price)
			fill_order(order, sell_order)
	if(!order.get_remaining_volume()) // order filled
		return 1
	buyorders.Enqueue(order)

/datum/world_faction/business/proc/add_sellorder(var/price, var/volume, var/real_name)
	var/datum/stock_order/order = new()
	order.price = price
	order.volume = volume
	order.real_name = real_name
	for(var/datum/stock_order/buy_order in buyorders.L)
		if(!order.get_remaining_volume()) break
		if(order.price <= buy_order.price)
			fill_order(buy_order, order)
	if(!order.get_remaining_volume()) // order filled
		return 1
	sellorders.Enqueue(order)

/datum/world_faction/business/proc/get_buyvolume()
	var/volume = 0
	for(var/datum/stock_order/buy_order in buyorders.L)
		volume += buy_order.volume
	return volume

/datum/world_faction/business/proc/get_sellvolume()
	var/volume = 0
	for(var/datum/stock_order/sell_order in sellorders.L)
		volume += sell_order.volume
	return volume


/datum/world_faction/business/proc/get_buyprice(var/volume)
	var/final_price = 0
	var/remaining_volume = volume
	for(var/datum/stock_order/sell_order in sellorders.L)
		if(!remaining_volume) break
		var/transact = min(sell_order.get_remaining_volume(), remaining_volume)
		final_price += transact*sell_order.price
		remaining_volume -= transact
	return final_price
