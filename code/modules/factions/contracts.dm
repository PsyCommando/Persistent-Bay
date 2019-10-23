
/obj/item/weapon/paper/contract
	name = "contract"
	icon_state = "contract"
	var/required_cash = 0
	var/datum/linked
	var/cancelled = 0
	var/signed = 0
	var/signed_by = ""
	var/approved = 0
	var/purpose = ""
	var/datum/money_account/signed_account
	var/datum/computer_file/report/crew_record/signed_record

	var/ownership = 0 // how many stocks the contract is worth (if a stock contract)
	var/org_uid = "" // what org this belongs to

	var/pay_to = ""
	var/created_by = ""
	var/func = 1

/obj/item/weapon/paper/contract/proc/is_solvent()
	if(signed_account)
		if(signed_account.money < required_cash)
			return 0
		return 1
	return 0

/obj/item/weapon/paper/contract/after_load()
	. = ..()
	cancel()
	update_icon()

/obj/item/weapon/paper/contract/update_icon()
	if(approved)
		icon_state = "contract-approved"
	else if(cancelled || !linked)
		icon_state = "contract-cancelled"
	else if(signed)
		icon_state = "contract-pending"
	else
		icon_state = "contract"

/obj/item/weapon/paper/contract/show_content(mob/user, forceshow)
	var/can_read = (istype(user, /mob/living/carbon/human) || isghost(user) || istype(user, /mob/living/silicon)) || forceshow
	if(!forceshow && istype(user,/mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = user
		can_read = get_dist(src, AI.camera) < 2
	var/info2 = info
	if(cancelled || !linked)
		info2 += "<br>This contract has been cancelled. This can be shredded."
	else if(approved)
		info2 += "<br>This contract has been finalized. This is just for record keeping."
	else if(signed)
		info2 += "<br>This contract has been signed and is pending finalization."
	else if(src.Adjacent(user) && !signed)
		info2 += "<br><A href='?src=\ref[src];pay=1'>Scan lace to sign contract.</A>"
	else
		info2 += "<br>Scan lace to sign contract."
	user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY bgcolor='[color]'>[can_read ? info2 : stars(info)][stamps]</BODY></HTML>", "window=[name]")
	onclose(user, "[name]")

/obj/item/weapon/paper/contract/attackby(obj/item/weapon/P as obj, mob/user as mob)
	if(istype(P, /obj/item/weapon/pen))
		return
	return ..()

/obj/item/weapon/paper/contract/Topic(href, href_list)
	if(!usr || (usr.stat || usr.restrained()))
		return
	if(href_list["pay"])
		var/datum/computer_file/report/crew_record/R = Retrieve_Record(usr.real_name)
		if(!R)
			to_chat(usr, "Record not found. Contact AI.")
			message_admins("record not found for user [usr.real_name]")
			return
		var/datum/money_account/linked_account = R.linked_account

		if((R.get_holdings() + ownership) > R.get_stock_limit())
			to_chat(usr, "This stock contract will exceed your stock limit.")
			return
		if(linked_account)
			if(linked_account.suspended)
				linked_account = null
				to_chat(usr, "\icon[src]<span class='warning'>Account has been suspended.</span>")
			if(required_cash > linked_account.money)
				to_chat(usr, "Unable to complete transaction: insufficient funds.")
				return
			signed_account = linked_account
			signed_record = R
		else
			to_chat(usr, "\icon[src]<span class='warning'>Account not found.</span>")
			return
		signed_by = usr.real_name
		if(linked.contract_signed(src))
			signed = 1
			info = replacetext(info, "*Unsigned*", "[signed_account.owner_name]")
		else
			signed_by = ""
			signed_account = null
		update_icon()
	..()

/obj/item/weapon/paper/contract/proc/cancel()
	if(linked)
		linked.contract_cancelled(src)
	if(signed_account)
		signed_account.reserved -= required_cash
		if(signed_account.reserved < 0)
			signed_account.reserved = 0
	cancelled = 1
	info = replacetext(info, "*Unsigned*", "*Cancelled*")
	update_icon()

/obj/item/weapon/paper/contract/proc/finalize()
	if(!signed_by || signed_by == "")
		return 0
	if(required_cash && (!signed_account || signed_account.money < required_cash))
		return 0
	if(required_cash)
		var/datum/transaction/T = new("[pay_to] (via digital contract)", purpose, -required_cash, "Digital Contract")
		signed_account.do_transaction(T)
		signed_account.reserved -= required_cash
		if(signed_account.reserved < 0)
			signed_account.reserved = 0
	approved = 1
	update_icon()
	return 1

/datum/proc/contract_signed(var/obj/item/weapon/paper/contract/contract)
	return 0

/datum/proc/contract_cancelled(var/obj/item/weapon/paper/contract/contract)
	return 0

/datum/stock_contract

/datum/stock_contract/contract_signed(var/obj/item/weapon/paper/contract/contract)
	var/datum/world_faction/business/connected_faction = get_faction(contract.org_uid)
	if(connected_faction && istype(connected_faction))
		var/datum/stockholder/holder = connected_faction.get_stockholder_datum(contract.created_by)
		if(!holder || holder.stocks < contract.ownership)
			contract.cancelled = 1
			contract.linked = null
			contract.update_icon()
			return 0
		var/datum/computer_file/report/crew_record/R = Retrieve_Record(contract.signed_by)
		if((contract.ownership + R.get_holdings()) > R.get_stock_limit())
			contract.cancelled = 1
			contract.linked = null
			contract.update_icon()
			return 0
		if(contract.finalize())
			var/datum/computer_file/report/crew_record/Rec = Retrieve_Record(contract.created_by)
			if(Rec && Rec.linked_account)
				var/datum/transaction/T = new("Stock Contract", "Stock Contract", contract.required_cash, "Stock Contract")
				Rec.linked_account.do_transaction(T)
			var/datum/stockholder/newholder
			newholder = connected_faction.get_stockholder_datum(contract.signed_by)
			if(!newholder)
				newholder = new()
				newholder.real_name = contract.signed_by
				connected_faction.stock_holders[contract.signed_by] = newholder
			newholder.stocks += contract.ownership
			holder.stocks -= contract.ownership
			if(!holder.stocks)
				connected_faction.stock_holders -= holder.real_name
			return 1

/obj/item/weapon/paper/contract/recurring
	var/sign_type = CONTRACT_BUSINESS
	var/contract_payee = ""
	var/contract_desc = ""
	var/contract_title = ""
	var/additional_function = CONTRACT_SERVICE_NONE
	var/contract_paytype = CONTRACT_PAY_NONE
	var/contract_balance = 0
	var/contract_pay = 0

/obj/item/weapon/paper/contract/recurring/update_icon()
	if(approved)
		icon_state = "contract-approved"
	else if(cancelled)
		icon_state = "contract-cancelled"
	else if(signed)
		icon_state = "contract-pending"
	else
		icon_state = "contract"


/obj/item/weapon/paper/contract/recurring/show_content(mob/user, forceshow)
	var/can_read = (istype(user, /mob/living/carbon/human) || isghost(user) || istype(user, /mob/living/silicon)) || forceshow
	if(!forceshow && istype(user,/mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = user
		can_read = get_dist(src, AI.camera) < 2
	var/info2 = info
	if(sign_type == CONTRACT_PERSON)
		if(cancelled)
			info2 += "<br>This contract has been cancelled. This can be shredded."
		else if(approved)
			info2 += "<br>This contract has been finalized. This is just for record keeping."
		else if(signed)
			info2 += "<br>This contract has been signed and is pending finalization."
		else if(src.Adjacent(user) && !signed)
			info2 += "<br><A href='?src=\ref[src];pay=1'>Scan lace to sign contract.</A>"
		else
			info2 += "<br>Scan lace to sign contract."
	else
		if(cancelled)
			info2 += "<br>This contract has been cancelled. This can be shredded."
		else if(approved)
			info2 += "<br>This contract has been finalized. This is just for record keeping."
		else if(signed)
			info2 += "<br>This contract has been signed and is pending finalization."
		else if(src.Adjacent(user) && !signed)
			info2 += "<br>This contract must be signed by an organization.<br><A href='?src=\ref[src];pay=1'>Scan or swipe ID linked to organization.</A>"
		else
			info2 += "<br>This contract must be signed by an organization.<br><A href='?src=\ref[src];pay=1'>Scan or swipe ID linked to organization.</A>"


	user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY bgcolor='[color]'>[can_read ? info2 : stars(info)][stamps]</BODY></HTML>", "window=[name]")
	onclose(user, "[name]")

/obj/item/weapon/paper/contract/recurring/Topic(href, href_list)
	if(!usr || (usr.stat || usr.restrained()))
		return
	if(href_list["pay"])
		if(signed) return
		if(sign_type == CONTRACT_BUSINESS)
			var/obj/item/weapon/card/id/id = usr.GetIdCard()
			if(id)
				if(id.selected_faction == contract_payee)
					to_chat(usr, "An organization cannot sign its own contract.")
					return 0
				var/datum/world_faction/connected_faction = get_faction(id.selected_faction)
				if(connected_faction)
					if(has_access(list(core_access_contracts), list(), usr.GetAccess(connected_faction.uid)))
						if(contract_paytype == CONTRACT_PAY_NONE || contract_pay <= connected_faction.central_account.money)
							var/datum/recurring_contract/new_contract = new()
							new_contract.name = contract_title
							new_contract.payer_type = sign_type

							new_contract.payee = contract_payee

							new_contract.payer = connected_faction.uid
							new_contract.details = contract_desc

							new_contract.auto_pay = contract_paytype
							new_contract.pay_amount = contract_pay
							new_contract.balance = contract_balance
							new_contract.func = additional_function
							new_contract.signer_name = usr.real_name

							GLOB.contract_database.add_contract(new_contract)
							signed = 1
							approved = 1
							info = replacetext(info, "*Unsigned*", "[connected_faction.uid]")
							signed_by = usr.real_name
							update_icon()
						else
							to_chat(usr, "Insufficent funds to sign contract.")
							return

					else
						to_chat(usr, "Access denied. Cannot sign contracts for [connected_faction.name].")
						return
		else

			var/datum/computer_file/report/crew_record/R = Retrieve_Record(usr.real_name)
			if(!R)
				to_chat(usr, "Record not found. Contact AI.")
				message_admins("record not found for user [usr.real_name]")
				return
			if(contract_paytype == CONTRACT_PAY_NONE || contract_pay <= R.linked_account.money)
				var/datum/recurring_contract/new_contract = new()
				new_contract.name = contract_title
				new_contract.payer_type = sign_type

				new_contract.payee = contract_payee

				new_contract.payer = usr.real_name
				new_contract.details = contract_desc

				new_contract.auto_pay = contract_paytype
				new_contract.pay_amount = contract_pay
				new_contract.balance = contract_balance
				new_contract.func = additional_function
				new_contract.signer_name = usr.real_name

				GLOB.contract_database.add_contract(new_contract)
				signed = 1

				info = replacetext(info, "*Unsigned*", "[usr.real_name]")
				signed_by = usr.real_name
			else
				to_chat(usr, "Insufficent funds to sign contract.")
				return
	else
		..()



