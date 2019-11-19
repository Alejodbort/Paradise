// SCP-106 HAS BREACHED CONTAINMENT
/mob/living/simple_animal/hostile/oldman
	name = "old man"
	real_name = "old man"
	desc = "A putrid, rotten humanoid, leaving a trail of death and decay. Has an unpleasant smile and is looking at you..."
	speak = list("spuaj...", "bletz...", "grur...", "hungry...", "blood...", "jaks...", "blerg...", "ajj...", "kreg...")
	speak_emote = list("gurgles")
	emote_hear = list("wails","screeches")
	response_help  = "thinks better of touching"
	response_disarm = "flails at"
	response_harm   = "punches"
	icon = 'icons/hispania/mob/oldman.dmi'
	icon_state = "oldman"
	icon_living = "oldman"
	speed = 7
	a_intent = INTENT_HARM
	stop_automated_movement = 1
	status_flags = CANPUSH
	attack_sound = 'sound/hallucinations/growl1.ogg'
	var/feast_sound = 'sound/misc/demon_consume.ogg'
	death_sound = 'sound/misc/demon_dies.ogg'
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = INFINITY
	attacktext = "lashes"
	maxHealth = 2000
	health = 2000
	environment_smash = 1
	universal_understand = 1
	obj_damage = 500
	melee_damage_lower = 5
	melee_damage_upper = 5
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE

	var/devoured = 0
	var/list/consumed_mobs = list()

	var/list/nearby_mortals = list()
	var/cooldown = 0
	var/gorecooldown = 0
	var/vialspawned = FALSE
	loot = list(/obj/effect/decal/cleanable/blood/innards, /obj/effect/decal/cleanable/blood, /obj/effect/gibspawner/generic, /obj/effect/gibspawner/generic, /obj/item/organ/internal/heart/demon)
	var/playstyle_string = "<B>You are the Old Man, an ancient entity who has been hunting humanity for centuries and still hungers for more.  \
						You are slow, but very durable. Your attacks slows and corrode your victims. \
						You may Click on walls to travel through them, appearing and disappearing from the station at will. \
						Pulling a dead or critical mob while you enter a wall will pull them in with you, sending them to your pocket dimension. </B>"
	del_on_death = 1
	deathmessage = "lets out a screeching scream as it escapes to its pocket dimension!"

	vision_range = 1
	aggro_vision_range = 1


/mob/living/simple_animal/hostile/oldman/New()
	..()
	remove_from_all_data_huds()
	if(mind)
		to_chat(src, src.playstyle_string)
		to_chat(src, "<B><span class ='notice'>You are not currently in the same plane of existence as the station. Click a wall to emerge.</span></B>")
		if(!(vialspawned))
			to_chat(src, "<B>Objective #[1]</B>: Hunt down as much of the crew as you can.")

/mob/living/simple_animal/hostile/oldman/Destroy()
	// Only execute the below if we successfully died
	for(var/mob/living/M in consumed_mobs)
		release_consumed(M)
	. = ..()

/mob/living/simple_animal/hostile/oldman/proc/release_consumed(mob/living/M)
	M.forceMove(get_turf(src))

/mob/living/simple_animal/hostile/oldman/AttackingTarget()
	. = ..()
	if(isturf(target))
		var/turf/simulated/wall/T = target
		usr.forceMove(get_turf(T))
		client.eye = src
		return
	else if(. && isliving(target) && (!client || a_intent == INTENT_HARM))
		var/mob/living/carbon/human/L = target
		L.staminaloss += 30
		if(prob(30))
			for(var/obj/item/organ/O in (L.bodyparts))
				O.necrotize(FALSE)
				if(O.status & ORGAN_DEAD)
					O.germ_level = INFECTION_LEVEL_THREE
					L.update_body()
		return
