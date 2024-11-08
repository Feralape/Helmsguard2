

//these mobs run away when attacked
/mob/living/simple_animal/hostile/retaliate/rogue
	turns_per_move = 5
	see_in_dark = 6
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	faction = list("rogueanimal")
	robust_searching = 1
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	attack_sound = PUNCHWOOSH
	health = 40
	maxHealth = 40
	move_to_delay = 5
	d_intent = INTENT_DODGE
	minbodytemp = 180
	lose_patience_timeout = 150
	vision_range = 5
	aggro_vision_range = 18
	harm_intent_damage = 5
	attack_same = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	blood_volume = BLOOD_VOLUME_NORMAL
	food_type = list(/obj/item/reagent_containers/food/snacks/grown)
	var/obj/item/udder/udder = null
	footstep_type = FOOTSTEP_MOB_SHOE
	var/milkies = FALSE
	stop_automated_movement_when_pulled = 0
	tame_chance = 0
	retreat_distance = 10
	minimum_distance = 10
	dodge_sound = 'sound/combat/dodge.ogg'
	dodge_prob = 0
	var/deaggroprob = 10
	var/eat_forever
	candodge = TRUE
	var/charge = 0
	var/charge_add = 0
	var/charge_power = 0
	var/def_val = 0
	var/atk_val = 0

/mob/living/simple_animal/hostile/retaliate/rogue/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE)
	..()
	if(damagetype == BRUTE)
		if(damage > 5 && prob(damage * 3))
			emote("pain")
		if(damage > 10)
			Immobilize(clamp(damage/2, 1, 30))
			shake_camera(src, 1, 1)
		if(damage < 10)
			flash_fullscreen("redflash1")
		else if(damage < 20)
			flash_fullscreen("redflash2")
		else if(damage >= 20)
			flash_fullscreen("redflash3")
	if(damagetype == BURN)
		if(damage > 10 && prob(damage))
			emote("pain")
			shake_camera(src, 1, 1)
		if(damage < 10)
			flash_fullscreen("redflash1")
		else if(damage < 20)
			flash_fullscreen("redflash2")
		else if(damage >= 20)
			flash_fullscreen("redflash3")

/mob/living/simple_animal/hostile/retaliate/rogue/death(gibbed)
	emote("death")
	..(gibbed)

/mob/living/simple_animal/hostile/retaliate/rogue/handle_automated_movement()
	set waitfor = FALSE
	if(!stop_automated_movement && wander && !doing)
		if(ssaddle && has_buckled_mobs())
			return 0
		if(find_food())
			return
		else
			..()

/mob/living/simple_animal/hostile/retaliate/rogue/proc/find_food()
	if(food > 50 && !eat_forever)
		return
	var/list/around = view(1, src)
	var/list/foundfood = list()
	if(stat)
		return
	for(var/obj/item/F in around)
		if(is_type_in_list(F, food_type))
			foundfood += F
			if(src.Adjacent(F))
				face_atom(F)
				playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
				qdel(F)
				food = max(food + 30, 100)
				return TRUE
	for(var/obj/item/F in foundfood)
		if(is_type_in_list(F, food_type))
			var/turf/T = get_turf(F)
			Goto(T,move_to_delay,0)
			return TRUE
	return FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/proc/eat_bodies()
	var/mob/living/L
//	var/list/around = view(aggro_vision_range, src)
	var/list/around = hearers(1, src)
	var/list/foundfood = list()
	if(stat)
		return
	for(var/mob/living/eattarg in around)
		if(!(eattarg in enemies)) //Makes a tamed rous not eat people on the floor unless instigated.
			return
		if(eattarg.stat != CONSCIOUS)
			foundfood += eattarg
			L = eattarg
			if(src.Adjacent(L))
				if(iscarbon(L))
					var/mob/living/carbon/C = L
					if(attack_sound)
						playsound(src, pick(attack_sound), 100, TRUE, -1)
					face_atom(C)
					src.visible_message(span_danger("[src] starts to rip apart [C]!"))
					if(do_after(src,100, target = L))
						var/obj/item/bodypart/limb
						var/list/limb_list = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
						for(var/zone in limb_list)
							limb = C.get_bodypart(zone)
							if(limb)
								limb.dismember()
								return TRUE
						limb = C.get_bodypart(BODY_ZONE_HEAD)
						if(limb)
							limb.dismember()
							return TRUE
						limb = C.get_bodypart(BODY_ZONE_CHEST)
						if(limb)
							if(!limb.dismember())
								C.gib()
							return TRUE
				else
					if(attack_sound)
						playsound(src, pick(attack_sound), 100, TRUE, -1)
					src.visible_message(span_danger("[src] starts to rip apart [L]!"))
					if(do_after(src,100, target = L))
						L.gib()
						return TRUE
	for(var/mob/living/eattarg in foundfood)
		var/turf/T = get_turf(eattarg)
		Goto(T,move_to_delay,0)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/Initialize()
	..()
	if(milkies)
		udder = new()
	if(tame)
		tamed()
	ADD_TRAIT(src, TRAIT_SIMPLE_WOUNDS, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/rogue/LoseTarget()
	..()
	retreat_distance = initial(retreat_distance)
	minimum_distance = initial(minimum_distance)

/mob/living/simple_animal/hostile/retaliate/rogue/tamed()
	del_on_deaggro = 0
	aggressive = 0
	if(enemies.len)
		if(prob(23))
			enemies = list()
			src.visible_message(span_notice("[src] calms down."))
			LoseTarget()
		else
			return
	..()

/mob/living/simple_animal/hostile/retaliate/rogue/Destroy()
	qdel(udder)
	udder = null
	..()

/mob/living/simple_animal/hostile/retaliate/rogue/Life()
	. = ..()
	if(.)
		if(enemies.len)
			if(prob(5))
				emote("cidle")
			if(prob(deaggroprob))
				if(mob_timers["aggro_time"])
					if(world.time > mob_timers["aggro_time"] + 30 SECONDS)
						enemies = list()
						src.visible_message(span_info("[src] calms down."))
						LoseTarget()
				else
					mob_timers["aggro_time"] = world.time
		else
			if(prob(8))
				emote("idle")
//			for(var/direction in shuffle(list(1,2,4,8,5,6,9,10)))
//				var/step = get_step(src, direction)
//				if(step)
//					var/obj/item/reagent_containers/food/I = locate(/obj/item/reagent_containers/food) in step
//					if(is_type_in_list(I, food_type))
//						Move(step, get_dir(src, step))
			if(adult_growth)
				growth_prog += 0.5
				if(growth_prog >= 100)
					if(isturf(loc))
						var/mob/living/simple_animal/A = new adult_growth(loc)
						if(tame)
							A.tame = TRUE
						qdel(src)
						return
			else
				if(childtype)
					make_babies()
		if(udder)
			if(production > 0)
				production--
				udder.generateMilk()

/mob/living/simple_animal/hostile/retaliate/rogue/Retaliate()
//	if(!enemies.len && message)
//		src.visible_message(span_warning("[src] panics!"))
//	if(flee)
//		retreat_distance = 10
//		minimum_distance = 10
	mob_timers["aggro_time"] = world.time
	..()

/mob/living/simple_animal/hostile/retaliate/rogue/attackby(obj/item/O, mob/user, params)
	if(!stat && istype(O, /obj/item/reagent_containers/glass))
		if(udder && tame)
			udder.milkAnimal(O, user)
			return 1
	else
		return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/proc/return_action()
	stop_automated_movement = FALSE
	walk(src,0)

/mob/living/simple_animal/hostile/retaliate/rogue/shood(mob/user)
	if(tame)
		Retaliate()

/mob/living/simple_animal/hostile/retaliate/rogue/onkick(mob/M)
	..()
	Retaliate()
	GiveTarget(M)

/mob/living/simple_animal/hostile/retaliate/rogue/beckoned(mob/user)
	if(tame && !stop_automated_movement)
		stop_automated_movement = TRUE
		Goto(user,move_to_delay)
		addtimer(CALLBACK(src, PROC_REF(return_action)), 3 SECONDS)

/mob/living/simple_animal/hostile/retaliate/rogue/food_tempted(obj/item/O, mob/user)
	testing("tempted")
	if(is_type_in_list(O, food_type) && !stop_automated_movement)
		testing("infoodtype")
		stop_automated_movement = TRUE
		Goto(user,move_to_delay)
		addtimer(CALLBACK(src, PROC_REF(return_action)), 3 SECONDS)

/mob/living/simple_animal/hostile/retaliate/rogue/proc/charge_power_add(added as num)
	charge_power += added
	return TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/Move()
	. = ..()
	if(has_buckled_mobs())
		var/mob/living/carbon/H = buckled_mobs[1]
		if(H.m_intent == MOVE_INTENT_RUN)
			charge_power_add(0.5)
		if(H.m_intent == MOVE_INTENT_WALK)
			charge_power = 0

/mob/living/simple_animal/hostile/retaliate/rogue/MobBump(mob/living/M) //CHARGE
	if(has_buckled_mobs())
		var/mob/living/carbon/H = buckled_mobs[1]
		if(H.m_intent == MOVE_INTENT_RUN && dir == get_dir(src, M)) //If you are charging
			var/mob/living/carbon/target = M
			var/riding_skill = (H?.mind ? H.mind.get_skill_level(/datum/skill/misc/riding) : 1)
			var/bonus = rand(1,10)
			var/bonus2 = rand(6,20)
			var/total_charge_val = charge_power + riding_skill
			var/lance = FALSE					//check if you're charging with a lance
			var/speared = FALSE					//check if your target is braced with a spear
			var/target_mounted  = FALSE
			atk_val = total_charge_val + (H.STASTR/2) + (STASTR/2) + bonus
			def_val = target.STACON + bonus
			H.canparry = FALSE
			H.candodge = FALSE
			if(target.has_buckled_mobs())
				var/mob/living/carbon/J = target.buckled_mobs[1]
				target = J
				target_mounted = TRUE
			else
				target = M
			target.canparry = FALSE
			target.candodge = FALSE
			var/obj/item/I = H.get_active_held_item()
			var/obj/item/U = target.get_active_held_item()
			if(istype(I, /obj/item/rogueweapon) && I.associated_skill == /datum/skill/combat/polearms && I.wielded && (H.cmode)) //You are charging with a lance
				var/pole_skill_atk = (H?.mind ? H.mind.get_skill_level(/datum/skill/combat/polearms) : 1)
				atk_val += (pole_skill_atk)
				lance = TRUE
			if(target.dir == get_dir(target, src)) //target is facing you
				def_val += 5
				if((istype(U, /obj/item/rogueweapon)) && U.associated_skill == /datum/skill/combat/polearms && U.wielded && (target.cmode)) //target bracing with a spear
					var/pole_skill_def = (target?.mind ? target.mind.get_skill_level(/datum/skill/combat/polearms) : 1)
					def_val += ((pole_skill_def)+2)
					speared = TRUE
			var/weapon_boost = charge_power + (H.STASTR/2)
			var/def_boost = charge_power + (target.STASTR/2)
			H.used_intent.damfactor += weapon_boost
			H.used_intent.penfactor += weapon_boost
			target.used_intent.damfactor += def_boost
			target.used_intent.penfactor += def_boost
			if(target_mounted && target.m_intent == MOVE_INTENT_RUN && target.dir == get_dir(target, src))
				if(target.buckled && istype(target.buckled, /mob/living/simple_animal/hostile/retaliate/rogue))
					var/mob/living/simple_animal/hostile/retaliate/rogue/R = target.buckled
					def_val = R.atk_val
			if(atk_val > def_val)
				if(lance)
					I.melee_attack_chain(H, target)
				if((charge_power + bonus2) > target.STACON)
					if(target_mounted)
						M.unbuckle_all_mobs()
					target.throw_at(get_edge_target_turf(src, dir),rand(2,5),2,src,TRUE)
				target.emote("scream")
				target.apply_damage((charge_power*2), BRUTE, "chest", target.run_armor_check("chest", "blunt", damage = (charge_power*2)))
				target.Knockdown(rand(15,30))
				target.Immobilize(30)
			if(atk_val < def_val)
				if(speared)
					U.melee_attack_chain(target, H)
				if((def_val + bonus2) > STACON)
					unbuckle_all_mobs()
					H.throw_at(get_ranged_target_turf(src, turn(src.dir, 180), rand(2,5)), rand(2,5),2,src,TRUE)
				H.emote("scream")
				H.apply_damage((charge_power*2), BRUTE, "chest", H.run_armor_check("chest", "blunt", damage = (charge_power*2)))
				Knockdown(1)
				H.Knockdown(rand(15,30))
				Immobilize(30)
				H.Immobilize(30)
			if(atk_val == def_val)
				H.emote("scream")
				H.apply_damage((charge_power*2), BRUTE, "chest", target.run_armor_check("chest", "blunt", damage = (charge_power*2)))
				H.Knockdown(rand(15,30))
				H.Immobilize(30)
				if(prob(50))
					unbuckle_all_mobs()
				if(target_mounted)
					if(prob(50))
						target.unbuckle_all_mobs()
				target.emote("scream")
				target.apply_damage((charge_power*2), BRUTE, "chest", target.run_armor_check("chest", "blunt", damage = (charge_power*2)))
				target.Knockdown(rand(15,30))
				target.Immobilize(30)
			H.used_intent.damfactor -= weapon_boost
			H.used_intent.penfactor -= weapon_boost
			target.used_intent.damfactor -= def_boost
			target.used_intent.penfactor -= def_boost
			for(var/mob/Q in range(3, src))
				if(!Q.stat)
					shake_camera(Q, 3, 1)
			visible_message(span_warning("[H] charges into [target] with [src]!"))
			H.canparry = TRUE
			H.candodge = TRUE
		Immobilize(30)
		playsound(src, "genblunt", 100, TRUE)
		emote("aggro")

/*		defending = FALSE
		weapon_boost = 0
		charge_power = 0
		charge = 0
		def_boost = 0
		weapon_boost = 0
		def_prob = 0
		atk_prob = 0 */

		charge_power = 0
	return TRUE
