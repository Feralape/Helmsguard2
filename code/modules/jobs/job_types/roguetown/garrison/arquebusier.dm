/datum/job/roguetown/arquebusier
	title = "Arquebusier"
	flag = ARQUEBUSIER
	department_flag = GARRISON
	faction = "Station"
	total_positions = 8
	spawn_positions = 8
	selection_color = JCOLOR_SOLDIER
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	tutorial = "TEST ROLE"
	display_order = JDO_TOWNGUARD
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/arquebusier

	give_bank_account = 16
	min_pq = 0
	max_pq = null

	cmode_music = 'sound/music/combat_guard.ogg'

//Universal stuff for all guards.
/datum/outfit/job/roguetown/arquebusier/pre_equip(mob/living/carbon/human/H)
	. = ..()
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	shoes = /obj/item/clothing/shoes/roguetown/boots
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	head = /obj/item/clothing/head/roguetown/tricorn
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/footmanchestplate
	beltl = /obj/item/storage/keyring/guard
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/ammopouch/bullets
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/gun/ballistic/arquebus
	gloves = /obj/item/clothing/gloves/roguetown/leather
	backpack_contents = list(/obj/item/powderflask = 1)

	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/firearms, 4, TRUE)
	H.change_stat("strength", 2)
	H.change_stat("constitution", 1)
	H.change_stat("endurance", 1)
	H.change_stat("speed", 1)

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)		//Still can wear medium armor; maybe remove if too strong with stats/skills. They'll live with light armor + speed anyway.
