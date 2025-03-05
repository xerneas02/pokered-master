	object_const_def
	const_export FUCHSIABILLSGRANDPASHOUSE_MIDDLE_AGED_WOMAN
	const_export FUCHSIABILLSGRANDPASHOUSE_BILLS_GRANDPA
	const_export FUCHSIABILLSGRANDPASHOUSE_YOUNGSTER

FuchsiaBillsGrandpasHouse_Object:
	db $a ; border block

	def_warp_events
	warp_event  2,  7, LAST_MAP, 2
	warp_event  3,  7, LAST_MAP, 2

	def_bg_events

	def_object_events
	object_event  2,  3, SPRITE_MIDDLE_AGED_WOMAN, STAY, RIGHT, TEXT_FUCHSIABILLSGRANDPASHOUSE_MIDDLE_AGED_WOMAN
	object_event  7,  2, SPRITE_GAMBLER, STAY, UP, TEXT_FUCHSIABILLSGRANDPASHOUSE_BILLS_GRANDPA
	object_event  5,  5, SPRITE_YOUNGSTER, STAY, NONE, TEXT_FUCHSIABILLSGRANDPASHOUSE_YOUNGSTER

	def_warps_to FUCHSIA_BILLS_GRANDPAS_HOUSE
