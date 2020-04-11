//GLOBAL_DATUM_INIT(material_marketplace, /datum/material_marketplace, new)
GLOBAL_DATUM_INIT(contract_database, /datum/contract_database, new)
GLOBAL_DATUM_INIT(module_objective_manager, /datum/module_objective_manager, new)
//GLOBAL_DATUM_INIT(stock_market, /datum/stock_market, new)

SUBSYSTEM_DEF(market)
	name = "Market"
	wait = 30 SECONDS
	flags = SS_NO_INIT

/datum/controller/subsystem/market/fire(resumed = FALSE)
	// GLOB.material_marketplace.process()
	GLOB.contract_database.process()
	GLOB.module_objective_manager.process()
	//GLOB.stock_market.process()
