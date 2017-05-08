// i think its slightly faster to do this with compiler macros instead of procs. i might be a moron, not sure - drsingh
// it is. no comment on the moron bit. -- marq
#define isclient(x) istype(x, /client)
#define ismob(x) istype(x, /mob)
#define isobserver(x) istype(x, /mob/dead)
#define isadminghost(x) x.client && x.client.holder && rank_to_level(x.client.holder.rank) >= LEVEL_MOD && (istype(x, /mob/dead/observer) || istype(x, /mob/dead/target_observer)) // For antag overlays.

#define isliving(x) istype(x, /mob/living)

#define iscarbon(x) istype(x, /mob/living/carbon)
#define ismonkey(x) (istype(x, /mob/living/carbon/human) && istype(x:mutantrace, /datum/mutantrace/monkey))
#define ishuman(x) istype(x, /mob/living/carbon/human)
#define iscritter(x) istype(x, /mob/living/critter)

#define issilicon(x) istype(x, /mob/living/silicon)
#define isrobot(x) istype(x, /mob/living/silicon/robot)
#define ishivebot(x) istype(x, /mob/living/silicon/hivebot)
#define ismainframe(x) istype(x, /mob/living/silicon/hive_mainframe)
#define isAI(x) istype(x, /mob/living/silicon/ai)
#define isshell(x) istype(x, /mob/living/silicon/hivebot/eyebot)//istype(x, /mob/living/silicon/shell)
#define isdrone(x) istype(x, /mob/living/silicon/hivebot/drone)
#define isghostdrone(x) istype(x, /mob/living/silicon/ghostdrone)

// I'm grump that we don't already have these so I'm adding them.  will we use all of them? probably not.  but we have them. - Haine
// Hi, Marquesas here. Eliminating all ':' would be nice. Can we do that somehow? Thanks.

// Macros with abilityHolder or mutantrace defines are used for more than antagonist checks, so don't replace them with mind.special_role.
#define istraitor(x) (istype(x, /mob/living/carbon/human) && x:mind && x:mind:special_role == "traitor")
#define ischangeling(x) (istype(x, /mob/living/carbon/human) && x:get_ability_holder(/datum/abilityHolder/changeling) != null)
#define isabomination(x) (istype(x, /mob/living/carbon/human) && x:mutantrace && istype(x:mutantrace, /datum/mutantrace/abomination))
#define isnukeop(x) (istype(x, /mob/living/carbon/human) && x:mind && x:mind:special_role == "nukeop")
#define isvampire(x) ((istype(x, /mob/living/carbon/human) || istype(x, /mob/living/critter)) && x:get_ability_holder(/datum/abilityHolder/vampire) != null)
#define iswizard(x) ((istype(x, /mob/living/carbon/human) || istype(x, /mob/living/critter)) && x:get_ability_holder(/datum/abilityHolder/wizard) != null)
#define ispredator(x) (istype(x, /mob/living/carbon/human) && x:mutantrace && istype(x:mutantrace, /datum/mutantrace/predator))
#define iswerewolf(x) (istype(x, /mob/living/carbon/human) && x:mutantrace && istype(x:mutantrace, /datum/mutantrace/werewolf))
#define iswrestler(x) ((istype(x, /mob/living/carbon/human) || istype(x, /mob/living/critter)) && x:get_ability_holder(/datum/abilityHolder/wrestler) != null)
#define iswraith(x) istype(x, /mob/wraith)
#define isintangible(x) istype(x, /mob/living/intangible)

// Why the separate mask check? NPCs don't use assigned_role and we still wanna play the cluwne-specific sound effects.
#define iscluwne(x) (istype(x, /mob/living/carbon/human) && ((x:mind && x:mind.assigned_role && x:mind:assigned_role == "Cluwne") || istype(x:wear_mask, /obj/item/clothing/mask/cursedclown_hat)))

#define ishellbanned(x) istype(x, /mob) && x:client && x:client.hellbanned

#define isrestrictedz(z) ((z) == 2 || (z) == 4)

#define islist(x) istype(x, /list)
#define isitem(x) istype(x, /obj/item)


#define OMNITOOL_MULTITOOL 1
#define OMNITOOL_SCREWDRIVER 2
#define OMNITOOL_CROWBAR 4
#define OMNITOOL_WIRECUTTERS 8
#define OMNITOOL_WRENCH 16

#define ismultitool(x) ((istype(x, /obj/item/device/multitool)) || (istype(x, /obj/item/omnitool) && x:omni_mode == OMNITOOL_MULTITOOL))
#define isscrewdriver(x) ((istype(x, /obj/item/screwdriver)) || (istype(x, /obj/item/omnitool) && x:omni_mode == OMNITOOL_SCREWDRIVER))
#define iscrowbar(x) ((istype(x, /obj/item/crowbar)) || (istype(x, /obj/item/omnitool) && x:omni_mode == OMNITOOL_CROWBAR))
#define iswrench(x) ((istype(x, /obj/item/wrench)) || (istype(x, /obj/item/omnitool) && x:omni_mode == OMNITOOL_WRENCH))
#define iswirecutters(x) ((istype(x, /obj/item/wirecutters)) || (istype(x, /obj/item/omnitool) && x:omni_mode == OMNITOOL_WIRECUTTERS))

#define LASER_SCALPEL 1
#define LASER_SAW 2
#define LASER_SPOON 4

#define isscalpel(x) ((istype(x, /obj/item/scalpel) || istype(x, /obj/item/raw_material/shard) || istype(x, /obj/item/kitchen/utensil/knife) || istype(x, /obj/item/knife_butcher) || istype(x, /obj/item/razor_blade)) || (istype(x, /obj/item/surgical_laser) && x:omni_mode == LASER_SCALPEL))
#define issaw(x) ((istype(x, /obj/item/circular_saw) || istype(x, /obj/item/saw) || istype(x, /obj/item/kitchen/utensil/fork)) || (istype(x, /obj/item/surgical_laser) && x:omni_mode == LASER_SAW))
#define isspoon(x) ((istype(x, /obj/item/surgical_spoon) || istype(x, /obj/item/kitchen/utensil/spoon)) || (istype(x, /obj/item/surgical_laser) && x:omni_mode == LASER_SPOON))

// pick strings from cache-- code/procs/string_cache.dm
#define pick_string(filename, key) pick(strings(filename, key))

#define DEBUG(x) if (debug_messages) message_coders(x)
#define __red(x) text("<span style='color:red'>[]</span>", x)
#define __blue(x) text("<span style='color:blue'>[]</span>", x)
#define __green(x) text("<span style='color:green'>[]</span>", x)

#ifdef PRECISE_TIMER_AVAILABLE
var/global/__btime__lastTimeOfHour = 0
var/global/__btime__callCount = 0
var/global/__btime__lastTick = 0
#define TimeOfHour __btime__timeofhour()
#define __extern__timeofhour text2num(call("btime.[world.system_type==MS_WINDOWS?"dll":"so"]", "gettime")())
proc/__btime__timeofhour()
	if (!(__btime__callCount++ % 50))
		if (world.time > __btime__lastTick)
			__btime__callCount = 0
			__btime__lastTick = world.time
		global.__btime__lastTimeOfHour = __extern__timeofhour
	return global.__btime__lastTimeOfHour
#else
#define TimeOfHour world.timeofday % 36000
#endif

#define CLAMP(V, MN, MX) max(MN, min(MX, V))

#define LAGCHECK(x) while (world.tick_usage > x) sleep(world.tick_lag)
