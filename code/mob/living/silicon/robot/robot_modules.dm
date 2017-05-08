/obj/item/robot_module
	name = "Cyborg Module"
	desc = "A blank cyborg module. It has no function in its current state."
	icon = 'icons/obj/robot_parts.dmi'
	icon_state = "mod-sta"
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	w_class = 2.0
	item_state = "electronic"
	flags = FPRINT|TABLEPASS | CONDUCT
	var/list/modules = list()
	var/mod_hudicon = "unknown"
	var/mod_appearance = "robot"
	var/cosmetic_mods = null

	New() //Shit all the mods have - make sure to call ..() at the top of any New() in this class of item
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/unilyzer(src)  //fuck it, they can all get this.
		src.modules += new /obj/item/omnitool(src) //same here

		var/obj/item/device/pda2/cyborg/C = new /obj/item/device/pda2/cyborg(src)
		var/mob/living/silicon/robot/R = src.loc
		if(istype(R))
			C.name = "[R.name]'s PDA"
			C.owner = "[R.name]"
			src.modules += C

/obj/item/robot_module/standard
	name = "Civilian Module"
	desc = "A general-purpose module. Intended to cover a wide variety of tasks."
	mod_hudicon = "standard"
	mod_appearance = "StaBot"

	New()
		..()
		src.cosmetic_mods = new /datum/robot_cosmetic/standard(src)
		src.cosmetic_mods += new /datum/robot_cosmetic/janitor(src)
		src.cosmetic_mods += new /datum/robot_cosmetic/hydro(src)
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/robojumper(src)
		src.modules += new /obj/item/extinguisher(src)
		//src.modules += new /obj/item/wrench(src)
		src.modules += new /obj/item/pen(src)
		src.modules += new /obj/submachine/chef_oven(src) //Incredibly, this works perfectly.
		src.modules += new /obj/item/seedplanter(src)
		src.modules += new /obj/item/plantanalyzer(src)
		src.modules += new /obj/item/device/igniter(src)
		src.modules += new /obj/item/saw/borg(src)
		src.modules += new /obj/item/satchel/heavy(src)
		src.modules += new /obj/item/reagent_containers/glass/bucket/borg
		src.modules += new /obj/item/spraybottle/cleaner(src)
		src.modules += new /obj/item/mop(src)
		src.modules += new /obj/item/device/camera_viewer(src)

/datum/robot_cosmetic/standard
	fx = list(255,0,0)
	painted = 1
	paint = list(0,0,0)

/obj/item/robot_module/medical
	name = "Medical Module"
	desc = "Incorporates medical tools intended for use to save and preserve human life."
	icon_state = "mod-med"
	mod_hudicon = "medical"
	mod_appearance = "MedBot"

	New()
		..()
		src.cosmetic_mods = new /datum/robot_cosmetic/medical(src)

		src.modules += new /obj/item/robodefibrilator(src)
		//src.modules += new /obj/item/scalpel(src)
		//src.modules += new /obj/item/circular_saw(src)
		src.modules += new /obj/item/surgical_laser(src)
		src.modules += new /obj/item/hemostat(src)
		src.modules += new /obj/item/suture(src)
		src.modules += new /obj/item/reagent_containers/iv_drip/blood(src)
		src.modules += new /obj/item/reagent_containers/patch/burn/medbot(src)
		src.modules += new /obj/item/reagent_containers/patch/bruise/medbot(src)
		//src.modules += new /obj/item/patch_stack(src)
		src.modules += new /obj/item/reagent_containers/hypospray/deluxe(src)
		src.modules += new /obj/item/reagent_containers/hypospray/deluxe(src)
		src.modules += new /obj/item/reagent_containers/syringe(src)
		src.modules += new /obj/item/reagent_containers/syringe(src)
		src.modules += new /obj/item/reagent_containers/glass/beaker/large/epinephrine(src)
		src.modules += new /obj/item/reagent_containers/glass/beaker/large/brute(src)
		src.modules += new /obj/item/reagent_containers/glass/beaker/large/burn(src)
		src.modules += new /obj/item/reagent_containers/glass/beaker/large/antitox(src)
		src.modules += new /obj/item/reagent_containers/dropper(src)

/datum/robot_cosmetic/medical
	head_mod = "Medical Mirror"
	ches_mod = "Medical Insignia"
	fx = list(0,255,0)
	painted = 1
	paint = list(150,150,150)

/obj/item/robot_module/engineering
	name = "Engineering and Contruction Module"
	desc = "A module designed to allow for station maintenance, repair work, and construction projects." //god, I hope merging those two isn't a bad idea.
	icon_state = "mod-eng"
	mod_hudicon = "engineer"
	mod_appearance = "EngBot"

	New()
		..()
		src.cosmetic_mods = new /datum/robot_cosmetic/engineering(src)
		src.modules += new /obj/item/device/flashlight
		src.modules += new /obj/item/robojumper(src)
		src.modules += new /obj/item/porter/atmos(src)
		src.modules += new /obj/item/extinguisher/large(src)
		src.modules += new /obj/item/weldingtool(src)
		src.modules += new /obj/item/device/t_scanner(src)
		var/obj/item/cable_coil/W = new /obj/item/cable_coil(src)
		W.amount = 1500 //combination of construction and engineering amounts
		src.modules += W
		src.modules += new /obj/item/electronics/scanner(src)
		src.modules += new /obj/item/electronics/soldering(src)
		var/obj/item/rcd/R = new /obj/item/rcd(src)
		R.matter = 30
		src.modules += R
		var/obj/item/tile/steel/T = new /obj/item/tile/steel(src)
		T.amount = 500
		src.modules += T
		var/obj/item/rods/steel/Ro = new /obj/item/rods/steel(src)
		Ro.amount = 500
		src.modules += Ro
		var/obj/item/sheet/steel/M = new /obj/item/sheet/steel(src)
		M.amount = 500
		src.modules += M
		var/obj/item/sheet/glass/G = new /obj/item/sheet/glass(src)
		G.amount = 500
		src.modules += G

/datum/robot_cosmetic/engineering
	fx = list(255,255,0)
	painted = 1
	paint = list(130,150,0)

/* /obj/item/robot_module/janitor
	name = "Janitorial Module"
	desc = "Cleaning and sanitation tools to keep the station clean and the crew healthy."
	icon_state = "mod-jan"
	mod_hudicon = "janitor"
	mod_appearance = "JanBot"

	New()
		..()
		src.cosmetic_mods = new /datum/robot_cosmetic/janitor(src)
		src.modules += new /obj/item/spraybottle/cleaner(src)
		src.modules += new /obj/item/mop(src)
		src.modules += new /obj/item/reagent_containers/glass/bucket(src)
		src.modules += new /obj/item/extinguisher(src)
		src.modules += new /obj/item/device/analyzer(src) */

/datum/robot_cosmetic/janitor
	head_mod = "Janitor Cap"
	fx = list(0,255,0)
	painted = 1
	paint = list(90,0,90)

/obj/item/robot_module/brobot //TO DO: add magic pen/crayon
	name = "Bro Bot Module"
	desc = "Become the life of the party using tools for fun and entertainment."
	icon_state = "mod-bro"
	mod_hudicon = "brobot"
	mod_appearance = "BroBot"

	New()
		..()
		src.cosmetic_mods = new /datum/robot_cosmetic/brobot(src)
		src.modules += new /obj/item/device/flashlight/brobot //this doubles as the borg siren light
		src.modules += new /obj/item/noisemaker(src) //this doubles as the borg siren itself, but I need to figure out a better way since it's really awkward to keep honking the siren.
		src.modules += new /obj/item/robot_foodsynthesizer(src)
		src.modules += new /obj/item/reagent_containers/food/drinks/bottle/beer/borg(src)
		src.modules += new /obj/item/reagent_containers/food/drinks/drinkingglass(src)
		src.modules += new /obj/item/coin_bot(src)
		src.modules += new /obj/item/dice_bot(src)
		src.modules += new /obj/item/c_tube(src) //tube can now disarm people!
		src.modules += new /obj/item/zippo/borg(src)

/obj/item/robot_module/brobot/brobocop //this is the secbot module
	name = "Brobocop Module" //the main reason being that I like the idea of the secborgs being half-rate discount dan style mallcops
	desc = "Become the life of security using tools for fun, entertainment, and justice."
	icon_state = "mod-bro"
	mod_hudicon = "brobot"
	mod_appearance = "BroBot"

	New()
		..()
		src.modules += new /obj/item/robot_grenade_fabricator_security(src)
		src.modules += new /obj/item/handcuffs/tape_roll/borg(src)
		src.modules += new /obj/item/device/radio/headset/security/borg(src)
		src.modules += new /obj/item/device/detective_scanner(src)
		src.modules += new /obj/item/device/audio_log/borg(src)
		var/obj/item/device/pda2/ticket/Q = new /obj/item/device/pda2/ticket(src)
		var/mob/living/silicon/robot/B = src.loc
		if(istype(B))
			Q.name = "[B.name]'s Ticketing PDA"
			Q.owner = "[B.name]"
			src.modules += Q

/datum/robot_cosmetic/brobot
	head_mod = "Afro and Shades"
	legs_mod = "Disco Flares"
	fx = list(90,0,90)
	painted = 0

/*/obj/item/robot_module/hydro
	name = "Hydroponics Module"
	desc = "Assist in the production of healthy and hearty crops with these gardening tools."
	icon_state = "mod-gar"
	mod_hudicon = "hydroponics"
	mod_appearance = "GarBot"

	New()
		..()
		src.cosmetic_mods = new /datum/robot_cosmetic/hydro(src)
		src.modules += new /obj/item/reagent_containers/glass/wateringcan(src)
		src.modules += new /obj/item/reagent_containers/glass/compostbag(src)
		src.modules += new /obj/item/seedplanter(src)
		src.modules += new /obj/item/plantanalyzer(src)
		src.modules += new /obj/item/wrench(src)
		src.modules += new /obj/item/device/igniter(src)
		src.modules += new /obj/item/saw/cyborg(src)
		src.modules += new /obj/item/satchel/hydro(src) */
//		src.modules += new /obj/item/borghose(src)
//		src.modules += new /obj/item/reagent_containers/food/drinks/juicer(src)

/datum/robot_cosmetic/hydro
	fx = list(0,255,255)
	painted = 1
	paint = list(0,120,0)

/*/obj/item/robot_module/construction
	name = "Construction Module"
	desc = "Engage in construction projects using tools for rapid building."
	icon_state = "mod-con"
	mod_hudicon = "construction"
	mod_appearance = "ConBot"

	New()
		..()
		src.cosmetic_mods = new /datum/robot_cosmetic/construction(src)
		src.modules += new /obj/item/wrench(src)
		src.modules += new /obj/item/wirecutters(src)

		var/obj/item/rcd/R = new /obj/item/rcd(src)
		R.matter = 30
		src.modules += R

		var/obj/item/tile/steel/T = new /obj/item/tile/steel(src)
		T.amount = 500
		src.modules += T

		var/obj/item/rods/steel/Ro = new /obj/item/rods/steel(src)
		Ro.amount = 500
		src.modules += Ro

		var/obj/item/sheet/steel/M = new /obj/item/sheet/steel(src)
		M.amount = 500
		src.modules += M

		var/obj/item/sheet/glass/G = new /obj/item/sheet/glass(src)
		G.amount = 500
		src.modules += G

		var/obj/item/cable_coil/W = new /obj/item/cable_coil(src)
		W.amount = 500
		src.modules += W */

/datum/robot_cosmetic/construction
	fx = list(0,240,160)
	painted = 1
	paint = list(0,120,80)

/obj/item/robot_module/mining //todo: crate porter, internal reclaimer, borg hammer
	name = "Mining Module"
	desc = "Tools for use in the excavation and transportation of valuable minerals."
	icon_state = "mod-min"
	mod_hudicon = "mining"
	mod_appearance = "MinBot"

	New()
		..()
		src.cosmetic_mods = new /datum/robot_cosmetic/mining(src)
		src.modules += new /obj/item/satchel/heavy(src)
		src.modules += new /obj/item/mining_tool/powerhammer/borg(src) //would you believe this already existed?
		src.modules += new /obj/item/ore_scoop/borg(src)
		src.modules += new /obj/item/cargotele(src)
		src.modules += new /obj/item/porter/cargo(src)
		src.modules += new /obj/item/oreprospector(src)
		src.modules += new /obj/item/satchel/mining/large(src)
		src.modules += new /obj/item/satchel/mining/large(src)
		src.modules += new /obj/item/device/gps(src)
		src.modules += new /obj/item/extinguisher(src)
		src.modules += new /obj/machinery/portable_reclaimer(src) //this should work, in theory

/datum/robot_cosmetic/mining
	head_mod = "Hard Hat"
	fx = list(0,255,255)
	painted = 1
	paint = list(130,90,0)

/obj/item/robot_module/chemistry
	name = "Chemistry Module"
	desc = "Beakers, syringes and other tools to enable a cyborg to assist in the research of chemicals."
	icon_state = "mod-chem"
	mod_hudicon = "chemistry"
	mod_appearance = "ChemBot"

	New()
		..()
		src.cosmetic_mods = new /datum/robot_cosmetic/chemistry(src)
		src.modules += new /obj/item/robot_chemaster(src)
		src.modules += new /obj/item/robot_grenade_fabricator_utility(src)
		src.modules += new /obj/item/reagent_containers/syringe(src)
		src.modules += new /obj/item/reagent_containers/syringe(src)
		src.modules += new /obj/item/reagent_containers/dropper(src)
		src.modules += new /obj/item/reagent_containers/dropper/mechanical(src)
		src.modules += new /obj/item/borghose/chem(src)
		src.modules += new /obj/item/reagent_containers/food/drinks/drinkingglass(src)
		src.modules += new /obj/item/reagent_containers/glass/beaker/large(src)
		src.modules += new /obj/item/reagent_containers/glass/beaker/large(src)
		src.modules += new /obj/item/reagent_containers/glass/beaker/large(src)
		src.modules += new /obj/item/extinguisher(src)

/datum/robot_cosmetic/chemistry
	ches_mod = "Lab Coat"
	fx = list(0,0,255)
	painted = 1
	paint = list(0,0,100)

/obj/item/robot_module/construction_worker
	name = "Construction Worker Module"
	desc = "Everything a construction worker requires."
	icon_state = "mod-con"
	mod_hudicon = "construction"
	mod_appearance = "ConBot"

	New()
		..()
		src.cosmetic_mods = new /datum/robot_cosmetic/construction(src)
		src.modules += new /obj/item/wrench(src)
		src.modules += new /obj/item/wirecutters(src)
		src.modules += new /obj/item/weldingtool(src)

		var/obj/item/rcd/R = new /obj/item/rcd(src)
		R.matter = 30
		src.modules += R

		var/obj/item/tile/steel/T = new /obj/item/tile/steel(src)
		T.amount = 500
		src.modules += T

		var/obj/item/rods/steel/Ro = new /obj/item/rods/steel(src)
		Ro.amount = 500
		src.modules += Ro

		var/obj/item/sheet/steel/M = new /obj/item/sheet/steel(src)
		M.amount = 500
		src.modules += M

		var/obj/item/sheet/glass/G = new /obj/item/sheet/glass(src)
		G.amount = 500
		src.modules += G

		var/obj/item/cable_coil/W = new /obj/item/cable_coil(src)
		W.amount = 500
		src.modules += W

		src.modules += new /obj/item/electronics/scanner(src)
		src.modules += new /obj/item/electronics/soldering(src)
		src.modules += new /obj/item/room_planner(src)
		src.modules += new /obj/item/room_marker(src)
		src.modules += new /obj/item/extinguisher(src)

/obj/item/robot_module/construction_ai
	New()
		..()
		var/obj/item/rcd/R = new /obj/item/rcd(src)
		R.matter = 30
		src.modules += R

		var/obj/item/cable_coil/W = new /obj/item/cable_coil(src)
		W.amount = 500
		src.modules += W

		src.modules += new /obj/item/electronics/scanner(src)
		src.modules += new /obj/item/electronics/soldering(src)
		src.modules += new /obj/item/room_planner(src)
		src.modules += new /obj/item/room_marker(src)
