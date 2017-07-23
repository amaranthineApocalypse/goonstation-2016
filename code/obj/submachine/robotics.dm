// Robotics Stuff

/obj/submachine/robomoduler
	name = "Module Rewriter"
	desc = "A device used to rewrite robotic and cybernetic software modules."
	icon = 'icons/obj/objects.dmi'
	icon_state = "moduler-off"
	anchored = 1
	density = 1
	mats = 15
	var/working = 0
	var/modules = 0

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(var/mob/user as mob)
		user.machine = src
		if (!src.working)
			var/dat = {"<B>Module Rewriter</B><BR>
			<HR><BR>
			<B>Modules Available:</B> [modules]<BR>
			<HR><BR>
			<A href='?src=\ref[src];module=std'>Write Standard Module<BR>
			<A href='?src=\ref[src];module=med'>Write Medical Module<BR>
			<A href='?src=\ref[src];module=eng'>Write Engineering<BR>
			<A href='?src=\ref[src];module=bro'>Write Brobocop Module<BR>
			<A href='?src=\ref[src];module=min'>Write Mining Module<BR>
			<A href='?src=\ref[src];module=chem'>Write Chemistry Module<BR>"}
			if (ticker && ticker.mode)
				if (istype(ticker.mode, /datum/game_mode/construction))
					dat += "<A href='?src=\ref[src];module=con'>Write Construction Worker Module</A><BR>"
			user << browse(dat, "window=mwriter;size=400x500")
			onclose(user, "mwriter")
		else
			var/dat = {"<B>Module Rewriter</B><BR>
			<HR><BR>
			<B>Modules Available:</B> [modules]<BR>
			<HR><BR>
			The Rewriter is currently busy!"}
			user << browse(dat, "window=mwriter;size=400x500")
			onclose(user, "mwriter")

		return

	Topic(href, href_list)
		if ((get_dist(src, usr) > 1 && !issilicon(usr)) || !isliving(usr) || iswraith(usr) || isintangible(usr))
			return
		if (usr.stunned > 0 || usr.weakened > 0 || usr.paralysis > 0 || usr.stat != 0 || usr.restrained())
			return
		if (src.working)
			usr.show_text("[src] is currently busy.", "red")
			return

		if (href_list["module"])
			if (src.modules < 1)
				for (var/mob/O in hearers(src, null))
					O.show_message(text("<b>[]</b> states, 'No modules available for write.'", src), 1)
				return

			src.working = 1
			var/output = null

			switch (href_list["module"])
				if ("std") output = /obj/item/robot_module/standard
				if ("med") output = /obj/item/robot_module/medical
				if ("eng") output = /obj/item/robot_module/engineering
		//	if ("jan") output = /obj/item/robot_module/janitor
		//	if ("hyd") output = /obj/item/robot_module/hydro
				if ("bro") output = /obj/item/robot_module/brobot/brobocop //no more normal brobots
				if ("min") output = /obj/item/robot_module/mining
		//	if ("cst") output = /obj/item/robot_module/construction
				if ("chem") output = /obj/item/robot_module/chemistry
				if ("con")
					if (ticker && ticker.mode)
						if (istype(ticker.mode, /datum/game_mode/construction))
							output = /obj/item/robot_module/construction_worker
/*	//Deprecated due to merging with engineering module - AmaranthineApocalypse
						else
							output = /obj/item/robot_module/construction
					else
						output = /obj/item/robot_module/construction
*/

			src.icon_state = "moduler-on"
			src.updateUsrDialog()

			spawn (50)
				if (src)
					src.working = 0
					src.icon_state = "moduler-off"
					new output(src.loc)
					if (src.modules > 0)
						src.modules = max(0, src.modules - 1)
					for (var/mob/O in hearers(src, null))
						O.show_message(text("<b>[]</b> states, 'Work complete.'", src), 1)
					src.updateUsrDialog()

		return

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/robot_module/) && !issilicon(user))
			boutput(user, "You insert the module.")
			user.u_equip(W)
			W.set_loc(src)
			src.modules = max(0, src.modules + 1)
			qdel(W)

		else ..()
		return

/obj/item/robojumper
	name = "Cell Cables"
	desc = "Used by Engineering Cyborgs for emergency recharging of APCs."
	icon = 'icons/obj/items.dmi'
	icon_state = "robojumper"

/obj/item/porter //this is the parent of atmosporters and cargoporters. It was really dumb to have all the code excuted by the item to be stored. This way is much more extensible
	name = "Porter Parent"
	desc = "You really shouldn't be able to see this, but since you can try not to fuck up everything too much"
	icon = 'icons/obj/items.dmi'
	icon_state = "bedbin"
	var/list/allowed = list(/obj) //ONLY FOR TESTING. WILL BREAK THINGS HORRIBLY IF USED LIVE.
	var/capacity = 3

	afterattack(atom/target as obj|mob, var/mob/user as mob, flag )
		var/proceed = 0
		for(var/check_path in src.allowed)
			if(istype(target, check_path))
				proceed = 1
				break

		if (!proceed)
			boutput(user, "<span style=\"color:red\">[src] cannot hold that!</span>")
			return


		var/canamt = src.contents.len
		if (canamt >= src.capacity)
			boutput(user, "<span style=\"color:red\">Your [src] is full!</span>")

		else
			user.visible_message("<span style=\"color:blue\">[user] collects the [target].</span>", "<span style=\"color:blue\">You collect the [target].</span>")
			contents += target
			var/atom/movable/target2 = target
			target2.set_loc(src)
			if (!istype(target, /obj/item/reagent_containers/glass/vial) && istype(target, /obj/machinery/portable_atmospherics))
				var/obj/machinery/portable_atmospherics/canetc = target
				canetc.contained = 1 //No running around venting plasma thank you very much - AmaranthineApocalypse

			var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
			s.set_up(5, 1, user)
			s.start()

			if (isrobot(user)) // Carbon mobs might end up using the porter?
				var/mob/living/silicon/robot/R = user
				if (R.cell) R.cell.charge -= 100 //If this is too low, feel free to bump it up

			if (isghostdrone(user)) //Drones aren't getting away with this bullshit either
				var/mob/living/silicon/ghostdrone/D = user
				if (D.cell) D.cell.charge -= 100


	attack_self(var/mob/user as mob)
		if (src.contents.len == 0) boutput(user, "<span style=\"color:red\">You have nothing stored!</span>")
		else

			var/list/stuff_in_here = list()
			var/num_of_stuff = 1
			for (var/atom/movable/AM in src.contents)
				stuff_in_here["([num_of_stuff]) [AM.name]"] = AM
				num_of_stuff++

			var/selection = input("What do you want to drop?", "Atmos Transporter") as null|anything in stuff_in_here
			if(!selection)
				return
			var/atom/movable/selection2 = stuff_in_here[selection]
			if (!selection2)
				return
			selection2.set_loc(user.loc)

			/*if(hasvar(selection, "contained"))
				selection:contained = 0*/

			if (!istype(selection, /obj/item/reagent_containers/glass/vial) && istype(selection, /obj/machinery/portable_atmospherics))
				var/obj/machinery/portable_atmospherics/canetc = selection
				canetc.contained = 0
			//selection:contained = 0 //Hello free runtimes - AmaranthineApocalypse
			var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
			s.set_up(5, 1, user)
			s.start()

/obj/item/porter/atmos
	name = "Atmosporter"
	desc = "Used by Engineering Cyborgs for convenient transport of siphons and tanks."
	allowed = list(/obj/machinery/portable_atmospherics)

/obj/item/porter/cargo
	name = "Crate Holder"
	desc = "Used by Cargo Cyborgs for convenient carrying of heavy storage containers."
	capacity = 1 //I know it seems a bit excessive, but I feel like it needs to be excessive in order to properly accomodate the sheer number of crates a QM will typically order.
	allowed = list(/obj/storage)

/obj/item/robot_chemaster
	name = "Mini-ChemMaster"
	desc = "A cybernetic tool designed for chemistry cyborgs to do their work with. Use a beaker on it to begin."
	icon = 'icons/obj/device.dmi'
	icon_state = "minichem"
	flags = NOSPLASH
	var/working = 0

	attackby(obj/item/W as obj, mob/user as mob)
		if (!istype(W,/obj/item/reagent_containers/glass/)) return
		var/obj/item/reagent_containers/glass/B = W

		if(!B.reagents.reagent_list.len || B.reagents.total_volume < 1)
			boutput(user, "<span style=\"color:red\">That beaker is empty! There are no reagents for the [src.name] to process!</span>")
			return
		if (working)
			boutput(user, "<span style=\"color:red\">Chemmaster is working, be patient</span>")
			return

		working = 1
		var/the_reagent = input("Which reagent do you want to manipulate?","Mini-ChemMaster",null,null) in B.reagents.reagent_list
		if (!the_reagent) return
		var/action = input("What do you want to do with the [the_reagent]?","Mini-ChemMaster",null,null) in list("Isolate","Purge","Remove One Unit","Remove Five Units","Create Pill","Create Pill Bottle","Create Bottle","Do Nothing")
		if (!action || action == "Do Nothing")
			working = 0
			return

		switch(action)
			if("Isolate") B.reagents.isolate_reagent(the_reagent)
			if("Purge") B.reagents.del_reagent(the_reagent)
			if("Remove One Unit") B.reagents.remove_reagent(the_reagent, 1)
			if("Remove Five Units") B.reagents.remove_reagent(the_reagent, 5)
			if("Create Pill")
				var/obj/item/reagent_containers/pill/P = new/obj/item/reagent_containers/pill(user.loc)
				var/name = copytext(html_encode(input(usr,"Name:","Name your pill!",B.reagents.get_master_reagent_name())), 1, 32)
				if(!name || name == " ") name = B.reagents.get_master_reagent_name()
				P.name = "[name] pill"
				B.reagents.trans_to(P,B.reagents.total_volume)
			if("Create Pill Bottle")
				// copied from chem_master because fuck fixing everything at once jeez
				var/pillname = copytext( html_encode( input( usr, "Name:", "Name the pill!", B.reagents.get_master_reagent_name() ) ), 1, 32)
				if(!pillname || pillname == " ")
					pillname = B.reagents.get_master_reagent_name()

				var/pillvol = input( usr, "Volume:", "Volume of chemical per pill!", "5" ) as num
				if( !pillvol || !isnum(pillvol) || pillvol < 5 )
					pillvol = 5

				var/pillcount = round( B.reagents.total_volume / pillvol ) // round with a single parameter is actually floor because byond
				if(!pillcount)
					boutput(usr, "[src] makes a weird grinding noise. That can't be good.")
				else
					var/obj/item/chem_pill_bottle/pillbottle = new /obj/item/chem_pill_bottle(user.loc)
					pillbottle.create_from_reagents(B.reagents, pillname, pillvol, pillcount)
			if("Create Bottle")
				var/obj/item/reagent_containers/glass/bottle/P = new/obj/item/reagent_containers/glass/bottle(user.loc)
				var/name = copytext(html_encode(input(usr,"Name:","Name your bottle!",B.reagents.get_master_reagent_name())), 1, 32)
				if(!name || name == " ") name = B.reagents.get_master_reagent_name()
				P.name = "[name] bottle"
				B.reagents.trans_to(P,30)

		working = 0

/obj/item/robot_foodsynthesizer
	name = "Food Synthesizer"
	desc = "A portable food synthesizer."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "synthesizer"
	var/vend_this = null
	var/last_use = 0

	attack_self(var/mob/user as mob)
		if (!vend_this)
			var/pickme = input("Please make your selection!", "Item selection", src.vend_this) in list("Burger", "Cheeseburger", "Meat sandwich", "Cheese sandwich", "Snack", "Cola", "Milk")
			src.vend_this = pickme
			user.show_text("[pickme] selected. Click with the synthesizer on yourself to pick a different item.", "blue")
			return

		if (src.last_use && world.time < src.last_use + 50)
			user.show_text("The synthesizer is recharging!", "red")
			return

		else
			switch(src.vend_this)

				if ("Burger")
					new /obj/item/reagent_containers/food/snacks/burger/synthburger(get_turf(src))
				if ("Cheeseburger")
					new /obj/item/reagent_containers/food/snacks/burger/cheeseburger(get_turf(src))
				if ("Meat sandwich")
					new /obj/item/reagent_containers/food/snacks/sandwich/meat_s(get_turf(src))
				if ("Cheese sandwich")
					new /obj/item/reagent_containers/food/snacks/sandwich/cheese(get_turf(src))
				if ("Snack")
					var/pick_snack = rand(1,6)
					switch(pick_snack)
						if(1)
							new /obj/item/reagent_containers/food/snacks/fries(get_turf(src))
						if(2)
							new /obj/item/reagent_containers/food/snacks/popcorn(get_turf(src))
						if(3)
							new /obj/item/reagent_containers/food/snacks/donut(get_turf(src))
						if(4)
							new /obj/item/reagent_containers/food/snacks/ice_cream/goodrandom(get_turf(src))
						if(5)
							new /obj/item/reagent_containers/food/snacks/candy/negativeonebar(get_turf(src))
						if(6)
							new /obj/item/reagent_containers/food/snacks/moon_pie/jaffa(get_turf(src))
				if ("Cola")
					new /obj/item/reagent_containers/food/drinks/cola(get_turf(src))
				if ("Milk")
					new /obj/item/reagent_containers/food/drinks/milk(get_turf(src))
				else
					user.show_text("<b>ERROR</b> - Invalid item! Resetting...", "red")
					logTheThing("debug", user, null, "<b>Convair880</b>: [user]'s food synthesizer was set to an invalid value.")
					src.vend_this = null
					return

			if (isrobot(user)) // Carbon mobs might end up using the synthesizer somehow, I guess?
				var/mob/living/silicon/robot/R = user
				if (R.cell) R.cell.charge -= 100
			playsound(src.loc, "sound/machines/click.ogg", 50, 1)
			user.visible_message("<span style=\"color:blue\">[user] dispenses a [src.vend_this]!</span>", "<span style=\"color:blue\">You dispense a [src.vend_this]!</span>")
			src.last_use = world.time
			return

	attack(mob/M as mob, mob/user as mob, def_zone)
		src.vend_this = null
		user.show_text("Selection cleared.", "red")
		return

/obj/item/reagent_containers/glass/oilcan
	name = "oil can"
	desc = "Contains oil intended for use on cyborgs and robots."
	icon = 'icons/obj/robot_parts.dmi'
	icon_state = "oilcan"
	amount_per_transfer_from_this = 15
	splash_all_contents = 0
	w_class = 3.0
	rc_flags = RC_FULLNESS

	New()
		var/datum/reagents/R = new/datum/reagents(120)
		reagents = R
		R.my_atom = src
		R.add_reagent("oil", 60)

/*
Jucier container.
By: SARazage
For: LLJK Goonstation
ported and crapped up by: haine
*/

/obj/item/reagent_containers/food/drinks/juicer
	name = "\improper Juice-O-Matic 3000"
	desc = "It's the Juice-O-Matic 3000! The pinicle of juicing technology! A revolutionary new juicing system!"
	icon = 'icons/obj/device.dmi'
	icon_state = "juicer"
	amount_per_transfer_from_this = 10
	initial_volume = 200

	afterattack(obj/target, mob/user)
		if (get_dist(user, src) > 1 || get_dist(user, target) > 1)
			user.show_text("You're too far away!", "red")

		if (istype(target, /obj/machinery) || ismob(target) || isturf(target)) // Do nothing if the user is trying to put it in a machine or feeding a mob.
			return

		if (target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
			if (!src.reagents.total_volume)
				user.show_text("[src] is empty!", "red")
				return

			if (target.reagents.total_volume >= target.reagents.maximum_volume)
				user.show_text("[target] is full!", "red")
				return

			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			user.show_text("You transfer [trans] unit\s of the solution to [target].")

		if (reagents.total_volume == reagents.maximum_volume) // See if the juicer is full.
			user.show_text("[src] is full!", "red")
			return

		if (istype(target, /obj/item/reagent_containers/food/snacks/plant)) // Check to make sure they're juicing food.
			if ((target.reagents.total_volume + src.reagents.total_volume) > src.reagents.maximum_volume)
				var/transamnt = src.reagents.maximum_volume - src.reagents.total_volume
				target.reagents.trans_to(src, transamnt)
				user.show_text("[src] makes a slicing sound as it destroys [target].<br>[src] juiced [transamnt] units, the rest is wasted.")
				playsound(src.loc, "sound/machines/mixer.ogg", 50, 1) // Play a sound effect.
				qdel(target) // delete the fruit, it got juiced!
				return

			else
				user.show_text("[src] makes a slicing sound as it destroys [target].<br>[src] juiced [target.reagents.total_volume] units.")
				target.reagents.trans_to(src, target.reagents.total_volume) // Transfer it all!
				playsound(src.loc, "sound/machines/mixer.ogg", 50, 1)
				qdel(target)
				return
		else
			user.show_text("Dang, the hopper only accepts food!", "red")


	get_desc(dist)
		if (dist <= 0)
			if (src.reagents && src.reagents.reagent_list.len)
				. += "<br>It contains:"
				for (var/datum/reagent/R in src.reagents.reagent_list)
					. += "[R.volume] units of [R.name]"

/*
Hydroponics Borg formula hose.
By: SARazage
For: LLJK Goonstation
ported and crapped up by: haine
*/

/obj/item/borghose
	name = "\improper Nutrient Hose 3000" // Name of the Module
	desc = "A nutrient hose for hydroponics work." // Description that shows up when examined
	icon = 'icons/obj/device.dmi' // Icon, just using a green cable coil for now.
	icon_state = "nutrient"
	flags = FPRINT | TABLEPASS | SUPPRESSATTACK
	var/amt_to_transfer = 10  // How much it transfers at once.
	var/charge_cost = 20 // How much the thing costs, I'm not sure if this is per tick or what. Can be adjusted.
	var/charge_tick = 0 // regulates if the borg is in a recharge station, to recharge reagents.
	var/recharge_time = 3 // How fast the module recharges, not really sure how this works yet.
	var/recharge_per_tick = 5 // how many units to add back to the tanks each tick

	var/list/hydro_reagents = list("saltpetre", "ammonia", "potash", "poo", "space_fungus", "water") // IDs of what we should dispense
	var/list/hydro_reagent_names = list() // the tank creation proc adds the names of the above reagents to this list
	var/list/tanks = list() // what tanks we have
	var/obj/item/reagent_containers/borghose_tank/active_tank = null // what tank is active

	New() // So this goes through and adds all the reagents to the hose on creation. Pretty good for expandability.
		..()
		for (var/reagent in hydro_reagents)
			create_tank(reagent)

	process() //Every [recharge_time] seconds, recharge some reagents for the cyborg
		src.charge_tick ++
		if (src.charge_tick >= src.recharge_time)
			src.regenerate_reagents()
			src.charge_tick = 0

	proc/create_tank(var/reagent) // The actual add_reagent function to add new reagents to the hose.
		var/obj/item/reagent_containers/borghose_tank/new_tank = new /obj/item/reagent_containers/borghose_tank(src)
		new_tank.reagents.add_reagent(reagent, 40)
		new_tank.label = reagent
		new_tank.label_name = reagent_id_to_name(reagent)
		new_tank.name = "[new_tank.label_name] tank"
		src.tanks += new_tank
		src.hydro_reagent_names += new_tank.label_name // the name list is so we don't have to call reagent_id_to_name() each time we wanna know the names of our reagents

	attack(mob/M as mob, mob/user as mob)
		return // Don't attack people with the hoses, god you people!

	proc/regenerate_reagents()
		if (isrobot(src.loc))
			var/mob/living/silicon/robot/R = src.loc // I'm not sure why it's src.loc and not src. (src is the hose, src.loc is where the hose is)
			if (R && R.cell) // If the robot's alive and there's power.
				var/full_tanks = 0 // to keep track of when we're good to remove ourselves from processing_items
				for (var/obj/item/reagent_containers/borghose_tank/tank in src.tanks) // Regenerate all formulas at once.
					var/tank_max = tank.reagents.maximum_volume // easier than writing tank.reagents.total_volume/etc over and over
					var/tank_vol = tank.reagents.total_volume
					if (tank_vol >= tank_max) // if it's already full
						full_tanks ++ // add to the list of full tanks
						continue // then skip it
					var/add_amt = min((tank_max - tank_vol), src.recharge_per_tick) // how much we'll be adding, in case the room left in the tank is less than recharge_per_tick
					if (tank.label) // who knows, maybe somehow you ended up with no label?
						tank.reagents.add_reagent(tank.label, add_amt)
						R.cell.use(src.charge_cost)
						if (tank.reagents.total_volume >= tank.reagents.maximum_volume)
							full_tanks ++
					else
						full_tanks ++ // just in case, we don't need this taking up extra processing if it's just gunna fail every time this runs
				if (full_tanks >= src.tanks.len && (src in processing_items))
					processing_items.Remove(src)

	attack_self(mob/user)
		var/switch_tank = input(user, "What reagent do you want to dispense?") as null|anything in src.hydro_reagent_names
		if (!switch_tank)
			return

		for (var/obj/item/reagent_containers/borghose_tank/tank in src.tanks)
			if (tank.label_name == switch_tank)
				src.active_tank = tank
				user.show_text("[src] is now dispensing [switch_tank].")
				playsound(loc, "sound/effects/pop.ogg", 50, 0) // Play a sound effect.
				return


	afterattack(obj/target, mob/user)
		if (istype(target, /obj/item/reagent_containers/glass) || istype(target, /obj/machinery/plantpot))
			if (!src.active_tank)
				user.show_text("No tank is currently active.", "red")
				return

			if (!src.active_tank.reagents || !src.active_tank.reagents.total_volume) // vOv
				user.show_text("[src] is currently out of this reagent.", "red")
				return

			if (target.reagents.total_volume >= target.reagents.maximum_volume)
				user.show_text("[target] is full.", "red")
				return

			var/trans = src.active_tank.reagents.trans_to(target, amt_to_transfer)
			user.show_text("You transfer [trans] unit\s of the solution to [target]. [active_tank.reagents.total_volume] unit\s remain.", "blue")
			playsound(loc, "sound/effects/slosh.ogg", 50, 0) // Play a sound effect.
			if (!(src in processing_items))
				processing_items.Add(src)
		else
			user.show_text("You can't put reagents in there!", "red")
			return ..() // call your parents!!

	get_desc(dist)
		if (dist <= 0)
			. += src.DescribeContents()

	proc/DescribeContents()
		var/data = null
		for (var/obj/item/reagent_containers/borghose_tank/tank in src.tanks)
			if (tank.reagents && tank.label)
				data += "<br>It currently has [tank.reagents.total_volume] unit\s of [tank.label_name] stored."
		if (data)
			return data

/obj/item/borghose/chem
	name = "\improper Chemworks Reagent Dispensing Hose 4000" // Name of the Module
	desc = "A hose that dispenses chemicals from slowly regenerating chemical tanks." // Description that shows up when examined
	hydro_reagents = list("oil", "phenol", "acetone", "ammonia", "diethylamine", "acid")

/obj/item/reagent_containers/borghose_tank
	name = "borghose reagent tank"
	desc = "you shouldn't see me!!"
	initial_volume = 40
	var/label = null // the ID of the reagent inside
	var/label_name = null // the name of the reagent inside, so we don't have to keep calling reagent_id_to_name()

/obj/item/robot_grenade_fabricator_utility
	name = "Utility Grenade Fabricator"
	desc = "A portable device that uses electricity to manufacture several types of general purpose chemical grenades."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "synthesizer"
	var/vend_this = null
	var/last_use = 0

	attack_self(var/mob/user as mob)
		if (!vend_this)
			var/pickme = input("Please make your selection!", "Item selection", src.vend_this) in list("Metal foam", "Fire fighting", "Cleaner")
			if (prob(1))
				src.vend_this = "Malfunctioning"
				user.show_text("<b>ERROR</b> - Fabrication fault! Reboot unsuccessful...", "red")
			else
				src.vend_this = pickme
				user.show_text("[pickme] selected. Click with the fabricator on yourself to pick a different item.", "blue")
			return

		if (src.last_use && world.time < src.last_use + 50)
			user.show_text("The fabricator is recharging!", "red")
			return

		else
			switch(src.vend_this)
				if ("Metal foam")
					new /obj/item/chem_grenade/metalfoam(get_turf(src))
				if ("Fire fighting")
					new /obj/item/chem_grenade/firefighting(get_turf(src))
				if ("Cleaner")
					new /obj/item/chem_grenade/cleaner(get_turf(src))
				if ("Malfunctioning")
					new /obj/item/chem_grenade/anticleaner(get_turf(src))
				else
					user.show_text("<b>ERROR</b> - Invalid item! Resetting...", "red")
					logTheThing("debug", user, null, "<b>Convair880</b>: [user]'s utility grenade fabricator was set to an invalid value.")
					src.vend_this = null
					return

			if (isrobot(user)) // Carbon mobs might end up using the synthesizer somehow, I guess?
				var/mob/living/silicon/robot/R = user
				if (R.cell)
					if (src.vend_this == "Malfunctioning")
						R.cell.charge -= 1000
					else
						R.cell.charge -= 500 //if this is too little, double this value and the above value.
			playsound(src.loc, "sound/machines/click.ogg", 50, 1)
			user.visible_message("<span style=\"color:blue\">[user] dispenses a [src.vend_this] grenade!</span>", "<span style=\"color:blue\">You dispense a [src.vend_this] grenade!</span>")
			src.last_use = world.time
			return

	attack(mob/M as mob, mob/user as mob, def_zone)
		src.vend_this = null
		user.show_text("Selection cleared.", "red")
		return

/obj/item/robot_grenade_fabricator_security //for secborgs
	name = "Security Grenade Fabricator"
	desc = "A portable device that uses electricity to manufacture several types of grenades for use by private security forces."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "synthesizer"
	var/vend_this = null
	var/last_use = 0

	attack_self(var/mob/user as mob)
		if (!vend_this)
			var/pickme = input("Please make your selection!", "Item selection", src.vend_this) in list("Flashbang", "Cryo", "Cheese sandwich", "Crowd dispersal")
			if (prob(1))
				src.vend_this = "Malfunctioning"
				user.show_text("<b>AUTHORIZATION ERROR</b> - Experimental grenade fault! Reboot unsuccessful...", "red")
			else
				src.vend_this = pickme
				user.show_text("[pickme] selected. Click with the fabricator on yourself to pick a different item.", "blue")
			return

		if (src.last_use && world.time < src.last_use + 50)
			user.show_text("The fabricator is recharging!", "red")
			return

		else
			switch(src.vend_this)
				if ("Flashbang")
					new /obj/item/chem_grenade/flashbang(get_turf(src))
				if ("Cryo")
					new /obj/item/chem_grenade/cryo(get_turf(src))
				if ("Crowd dispersal")
					new /obj/item/chem_grenade/pepper(get_turf(src))
				if ("Cheese sandwich")
					new /obj/item/old_grenade/banana/cheese_sandwich(get_turf(src)) //TO DO: make cheese sandwich grenade.
				if ("Malfunctioning")
					var/pick_nade = rand(1,13)
					switch(pick_nade)
						if(1)
							if(prob(5))
								new /obj/item/chem_grenade/incendiary(get_turf(src))
							else
								new /obj/item/old_grenade/banana(get_turf(src))
						if(2)
							if(prob(5))
								new /obj/item/chem_grenade/very_incendiary(get_turf(src))
							else
								new /obj/item/old_grenade/banana(get_turf(src))
						if(3)
							if(prob(5))
								new /obj/item/chem_grenade/shock(get_turf(src))
							else
								new /obj/item/old_grenade/banana(get_turf(src))
						if(4)
							if(prob(5))
								new /obj/item/old_grenade/smoke(get_turf(src))
							else
								new /obj/item/old_grenade/banana(get_turf(src))
						if(5)
							if(prob(5))
								new /obj/item/old_grenade/smoke/mustard(get_turf(src))
							else
								new /obj/item/old_grenade/banana(get_turf(src))
						if(6)
							if(prob(5))
								new /obj/item/old_grenade/moustache(get_turf(src))
							else
								new /obj/item/old_grenade/banana(get_turf(src))
						if(7)
							new /obj/item/old_grenade/banana(get_turf(src))
						if(8)
							if(prob(5))
								new /obj/item/chem_grenade/sarin(get_turf(src))
							else
								new /obj/item/old_grenade/banana(get_turf(src))
						if(9)
							if(prob(5))
								new /obj/item/old_grenade/gravaton(get_turf(src))
							else
								new /obj/item/old_grenade/banana(get_turf(src))
						if(10)
							if(prob(5))
								new /obj/item/old_grenade/sonic(get_turf(src))
							else
								new /obj/item/old_grenade/banana(get_turf(src))
						if(11)
							if(prob(5))
								new /obj/item/old_grenade/emp(get_turf(src))
							else
								new /obj/item/old_grenade/banana(get_turf(src))
						if(12)
							if(prob(5))
								new /obj/item/gimmickbomb/owlclothes(get_turf(src))
							else
								new /obj/item/old_grenade/banana(get_turf(src))
						if(13)
							if(prob(1))
								new /obj/item/pipebomb/bomb/syndicate(get_turf(src))
							else
								new /obj/item/old_grenade/banana(get_turf(src))
				else
					user.show_text("<b>ERROR</b> - Invalid item! Resetting...", "red")
					logTheThing("debug", user, null, "<b>Convair880</b>: [user]'s utility grenade fabricator was set to an invalid value.")
					src.vend_this = null
					return

			if (isrobot(user)) // Carbon mobs might end up using the synthesizer somehow, I guess?
				var/mob/living/silicon/robot/R = user
				if (R.cell)
					if (src.vend_this == "Malfunctioning")
						R.cell.charge -= 2000
					else
						R.cell.charge -= 1000 //if this is too little, double this value and the above value.
			playsound(src.loc, "sound/machines/click.ogg", 50, 1)
			user.visible_message("<span style=\"color:blue\">[user] dispenses a [src.vend_this] grenade!</span>", "<span style=\"color:blue\">You dispense a [src.vend_this] grenade!</span>")
			src.last_use = world.time
			return

	attack(mob/M as mob, mob/user as mob, def_zone)
		src.vend_this = null
		user.show_text("Selection cleared.", "red")
		return

/obj/item/borgcloneraid //Why is surgerycode so awful
	name = "\improper Genetek BioBuddy"
	desc = "An exciting new piece of technology from GeneTek! Allows for clone scanning, biomatter breakdown and human limb replacment on the fly!"
	icon = 'icons/obj/device.dmi'
	icon_state = "forensic0"
	var/maxmeatlevel = 40
	var/meatlevel = 40
	var/list/records = list()
	var/list/acceptable = list()
	var/selected = "none"


	attack(mob/living/carbon/human/subject as mob, mob/user as mob)
		if (subject && (selected == "none"))
			if ((isnull(subject)) || (!istype(subject, /mob/living/carbon/human)))
				boutput(user, "Error: Unable to locate valid genetic data.")
				return
			if(subject.decomp_stage)
				boutput(user, "Error: Failed to read genetic data from subject.<br>Necrosis of tissue has been detected.")
				return
			if (!subject.bioHolder || subject.bioHolder.HasEffect("husk"))
				boutput(user, "Error: Extreme genetic degredation present.")
				return

			var/datum/mind/subjMind = subject.mind
			if ((!subjMind) || (!subjMind.key))
				if (subject.ghost && subject.ghost.mind && subject.ghost.mind.key)
					subjMind = subject.ghost.mind
				else
					boutput(user, "Error: Mental interface failure.")
					return
			if (!isnull(find_record(ckey(subjMind.key))))
				boutput(user, "Subject already in database.")
				return

			var/datum/data/record/R = new /datum/data/record(  )
			R.fields["ckey"] = ckey(subjMind.key)
			R.fields["name"] = subject.real_name
			R.fields["id"] = copytext(md5(subject.real_name), 2, 6)

			var/datum/bioHolder/H = new/datum/bioHolder(null)
			H.CopyOther(subject.bioHolder)

			R.fields["holder"] = H

			R.fields["abilities"] = null
			if (subject.abilityHolder)
				var/datum/abilityHolder/A = subject.abilityHolder.deepCopy()
				R.fields["abilities"] = A

			R.fields["traits"] = list()
			if(subject.traitHolder && subject.traitHolder.traits.len)
				R.fields["traits"] = subject.traitHolder.traits.Copy()

			//Add an implant if needed
			var/obj/item/implant/health/imp = locate(/obj/item/implant/health, subject)
			if (isnull(imp))
				imp = new /obj/item/implant/health(subject)
				imp.implanted = 1
				imp.owner = subject
				subject.implant.Add(imp)
//				imp.implanted = subject // this isn't how this works with new implants sheesh
				R.fields["imp"] = "\ref[imp]"
			//Update it if needed
			else
				R.fields["imp"] = "\ref[imp]"

			if (!isnull(subjMind)) //Save that mind so traitors can continue traitoring after cloning.
				R.fields["mind"] = subjMind

			src.records += R
			boutput(user, "Subject successfully scanned.")

		else
			var/areaselect = zone_sel2name[user.zone_sel.selecting]
			switch(areaselect)
				if ("head")
					var/hand = "none"
					if (selected == "eye")
						if(issilicon(user))
							var/mob/living/silicon/robot/robodoc = user
							hand = robodoc.find_in_hand(src)
							if (hand == robodoc.module_states[1])
								hand = "left"
							else if (hand == robodoc.module_states[2])
								hand = "centre"
							else if (hand == robodoc.module_states[3])
								hand = "right"
						else
							hand = user.find_in_hand(src)
							if (hand == user.l_hand)
								hand = "left"
							else if ( hand == user.r_hand)
								hand = "right"
						var/fluff = pick("insert", "shove", "place", "drop", "smoosh", "squish")
						if (hand == "left" && !subject.organHolder.left_eye)
							subject.tri_message("<span style=\"color:red\"><b>[user]</b> [fluff][fluff == "smoosh" || fluff == "squish" ? "es" : "s"] the [selected] into [subject == user ? "[his_or_her(subject)]" : "[subject]'s"] left eye socket!</span>",\
							user, "<span style=\"color:red\">You [fluff] the [selected] into [user == subject ? "your" : "[subject]'s"] left eye socket!</span>",\
							subject, "<span style=\"color:red\">[subject == user ? "You" : "<b>[user]</b>"] [fluff][fluff == "smoosh" || fluff == "squish" ? "es" : "s"] the [selected] into your left socket!</span>")

							var/obj/item/organ/eye/newLeftEye = new /obj/item/organ/eye/left(subject.organHolder)
							subject.organHolder.left_eye = newLeftEye
							subject.organHolder.organ_list["left_eye"] = newLeftEye
							subject.update_body()
							src.selected = "none"
						else if (hand == "right" && !subject.organHolder.right_eye)
							subject.tri_message("<span style=\"color:red\"><b>[user]</b> [fluff][fluff == "smoosh" || fluff == "squish" ? "es" : "s"] the [selected] into [subject == user ? "[his_or_her(subject)]" : "[subject]'s"] right eye socket!</span>",\
							user, "<span style=\"color:red\">You [fluff] the [selected] into [user == subject ? "your" : "[subject]'s"] right eye socket!</span>",\
							subject, "<span style=\"color:red\">[subject == user ? "You" : "<b>[user]</b>"] [fluff][fluff == "smoosh" || fluff == "squish" ? "es" : "s"] the [selected] into your right socket!</span>")

							var/obj/item/organ/eye/newRightEye = new /obj/item/organ/eye/right(subject.organHolder)
							subject.organHolder.right_eye = newRightEye
							subject.organHolder.organ_list["right_eye"] = newRightEye
							subject.update_body()
							src.selected = "none"
				if("left arm")
					if(selected == "arm")
						subject.tri_message("<span style=\"color:red\"><b>[user]</b> cauterises the left arm onto [subject == user ? "[his_or_her(subject)]" : "[subject]'s"] stump.</span>",\
						user, "<span style=\"color:red\">You cauterise the left arm onto [user == subject ? "your" : "[subject]'s"] stump.</span>",\
						subject, "<span style=\"color:red\">[subject == user ? "You" : "<b>[user]</b>"] cauterise the left arm onto your stump!</span>")

						var/obj/item/parts/human_parts/part = new /obj/item/parts/human_parts/arm/left {remove_stage = 2;} (subject)
						subject.limbs.vars["l_arm"] = part
						part.holder = subject
						subject.update_body()
					else return

				if("right arm")
					if(selected == "arm")
						subject.tri_message("<span style=\"color:red\"><b>[user]</b> cauterises the right arm onto [subject == user ? "[his_or_her(subject)]" : "[subject]'s"] stump.</span>",\
						user, "<span style=\"color:red\">You cauterise the right arm onto [user == subject ? "your" : "[subject]'s"] stump.</span>",\
						subject, "<span style=\"color:red\">[subject == user ? "You" : "<b>[user]</b>"] cauterise the right arm onto your stump!</span>")
						var/obj/item/parts/human_parts/part = new /obj/item/parts/human_parts/arm/right {remove_stage = 2;} (subject)
						subject.limbs.vars["r_arm"] = part
						part.holder = subject
						subject.update_body()
					else return

				if("left leg")
					if(selected == "leg")

					else return
				if("right leg")
					if(selected == "leg")

					else return

				if("chest")
					if(selected == "heart")

					else return
			..()

	attack_self(mob/user as mob)
		var/inprogress = 0
		if (src.selected == "none" && inprogress == 0)
			inprogress = 1
			if (src.meatlevel > 9)
				src.selected = input("Select desired organ", "Confirm organ selection", src.selected) in list("arm", "leg", "heart", "eye")
				boutput(user, "You begin generating the [src.selected].")
				if (!do_after(user, 60))
					boutput(user, "You were interrupted!")
					src.selected = "none"
					inprogress = 0
					return
				meatlevel = meatlevel - 10
				boutput(user, "You generate the [src.selected].")
				inprogress = 0

			else
				boutput(user, "You don't have enough biomass for that!")
				inprogress = 0
		else if (inprogress = 0)
			inprogress = 1
			boutput(user, "You begin reclaiming the [src.selected].")
			if (!do_after(user, 60))
				boutput(user, "You were interrupted!")
				inprogress = 0
				return
			boutput(user, "You reclaim the [src.selected].")
			src.selected = "none"
			inprogress = 0
			meatlevel = meatlevel + 10
		..()

	afterattack(atom/target as mob|obj|turf, mob/user as mob)
		if (istype(target, /obj/machinery/computer/cloning))
			var/obj/machinery/computer/cloning/C = target
			var/already = 0
			for (var/R in src.records)
				for (var/CR in C.records)
					if (R == CR)
						already = 1
						break

				if (already == 0)
					C.records += R
				src.records -=R
				already = 0
			boutput(user, "Records transfered to cloning computer!")

		else if (istype(target, /obj/item))
			var/obj/item/meat = target
			src.acceptable = list(/obj/item/reagent_containers/food/snacks/ingredient/meat, /obj/item/parts/human_parts, /obj/item/clothing/head/butt, /obj/item/organ, /obj/item/raw_material/martian)
			for (var/C in src.acceptable)
				if (istype(meat, C))
					if (meatlevel < maxmeatlevel)
						meatlevel = meatlevel + 5
						qdel(meat)
						if (meatlevel > maxmeatlevel)
							meatlevel = maxmeatlevel
					else
						boutput(user, "[src] is full")
						break

			if (istype(meat, /obj/item/reagent_containers/food) && (findtext(meat.name, "meat")||findtext(meat.name,"bacon")))
				if (meatlevel < maxmeatlevel)
					meatlevel = meatlevel + 5
					qdel(meat)
					if (meatlevel > maxmeatlevel)
						meatlevel = maxmeatlevel
					else
						boutput(user, "[src] is full")
						return
		//else if (istype(target, /mob/living/carbon/human))

	proc/find_record(var/find_key)
		var/selected_record = null
		for (var/datum/data/record/R in src.records)
			if (R.fields["ckey"] == find_key)
				selected_record = R
				break
		return selected_record

/obj/item/borg_tube
	name = "Wifflebat"
	desc = "This all new EXCITING!!! product gives you ALL THE FUN of security with NONE OF THE HARM"
	icon = 'icons/obj/items.dmi'
	icon_state = "c_tube"
	inhand_image_icon = 'icons/mob/inhand/hand_weapons.dmi'
	w_class = 1.0
	stamina_damage = 1
	stamina_cost = 1
	w_class = 1.0
	throw_speed = 4
	throw_range = 5

	attack(mob/M as mob, mob/user as mob)
		if(user.a_intent == "harm") //this is so brobots can still attack people with cardboard tubes without disarming people
			var/pick = rand(1,10)
			stamina_damage = 120
			if (pick == 1)
				var/obj/item/I = M.equipped()
				if (I)
					if (I.cant_other_remove && ishuman(M))
						playsound(src.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
						src.loc.visible_message("<span style=\"color:red\"><B>[src] vainly tries to knock [I] out of [M]'s hand!</B></span>")
						user.visible_message("<span style=\"color:red\">Something is binding [I] to [M]. You won't be able to disarm [him_or_her(M)].</span>")
						M.visible_message("<span style=\"color:red\">Something is binding [I] to you. It cannot be knocked out of your hands.</span>")

					else
						if (ishuman(src))
							var/mob/living/carbon/human/H2 = src
							for (var/uid in H2.pathogens)
								var/datum/pathogen/P = H2.pathogens[uid]
								var/ret = P.ondisarm(M, 1)
								if (!ret)
									H2.loc.visible_message("<span style=\"color:red\"><B>[src] tries to knock [I] out of [M]'s hand!</B></span>")
									return
						user.loc.visible_message("<span style=\"color:red\"><B>[src] knocks [I] out of [M]'s hand!</B></span>")
						playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1)
						M.deliver_move_trigger("bump")
						M.drop_item()
				else
					..()
			else
				..()
		else
			stamina_damage = 1
			..()

/obj/item/robo_barcoder
	name = "Handheld Barcode Printer"
	desc = "This device acts as a trading and transport barcode printer. Convenient!"
	icon = 'icons/obj/writing.dmi'
	icon_state = "labeler"
	item_state = "flight"
	var/destination = "QM"
	var/list/destinations = list("Airbridge", "Cafeteria", "EVA", "Engine", "Disposals", "QM", "Catering", "MedSci", "Security")

	attack_self(mob/user as mob)
		if (..(user))
			return

		var/dat = ""
		dat += "<b>Available Destinations:</b><BR>"
		for(var/I in destinations)
			dat += "<b><A href='?src=\ref[src];confirm=[I]'>[I]</A></b><BR><BR>"

		dat += "<b>Available Traders:</b><BR>"
		for(var/datum/trader/T in shippingmarket.active_traders)
			if (!T.hidden)
				dat += "<br><b><A href='?src=\ref[src];confirm=[T.crate_tag]'>Sell to [T.name]</A></b><BR>"

		user.machine = src
		user << browse("<TITLE>Handheld Barcode Printer</TITLE><BR>[dat]", "window=bc_computer;size=400x300")
		onclose(user, "bc_computer")
		return

	Topic(href, href_list)
		if (..(href, href_list))
			return

		if (href_list["confirm"])
			src.desc = "This device acts as a trading and transport barcode printer. Convenient! It's currently set to deliver to ([href_list["print"]])"
			src.destination = href_list["confirm"]

		usr << browse(null, "window=bc_computer")
		src.updateUsrDialog()
		return

	proc/attachTo(atom/target)
		if(get_dist(get_turf(target), get_turf(src)) <= 1 && istype(target, /atom/movable))
			if(target==loc && target != usr) return //Backpack or something
			playsound(src.loc, "sound/machines/printer_thermal.ogg", 50, 0)
			target:delivery_destination = destination
			usr.visible_message("<span style=\"color:blue\">[usr] puts a barcode on [target].</span>")
			if (isrobot(usr)) // Carbon mobs might end up using this
				var/mob/living/silicon/robot/R = usr
				if (R.cell) R.cell.charge -= 100 //Might be too high honestly

			if (isghostdrone(usr)) //Drones aren't getting away with this bullshit either
				var/mob/living/silicon/ghostdrone/D = usr
				if (D.cell) D.cell.charge -= 100




	/*attack(mob/M as mob, mob/user as mob, def_zone)
		src.attachTo(M)
		return*/

	afterattack(atom/target as mob|obj|turf, mob/user as mob)
		src.attachTo(target)
		return

/obj/item/machine_holder
	name = "Machine Holder Parent"
	desc = "You shouldn't see this"
	var/holding = /obj/item/pipebomb/bomb/syndicate
	var/obj/my_machine = null

	New()
		..()
		my_machine = new holding(src)

	attackby(var/obj/item/W as obj, mob/user as mob)
		if (my_machine)
			return my_machine.attack_hand(W, user)
		return

	attack_hand(var/obj/item/W as obj, mob/user as mob)
		if (my_machine)
			return my_machine.attack_hand(W, user)
		return

	attack_self(var/obj/item/W as obj, mob/user as mob)
		if (my_machine)
			return my_machine.attack_hand(W, user)
		return

	MouseDrop_T(atom/movable/O as obj, mob/user as mob)
		if (my_machine && O != src)
			return my_machine.MouseDrop_T(O, user)
		return

	oven
		name = "Portable Oven"
		desc = "An internalised portable oven for cyborgs to create crimes against cooking with!"
		holding = /obj/submachine/chef_oven
		icon = 'icons/obj/kitchen.dmi'
		icon_state = "oven_off"

	reclaimer
		name = "Internal Reclaimer"
		desc = "An internalised ore processor for borgs!"
		holding = /obj/machinery/portable_reclaimer
		icon = 'icons/obj/scrap.dmi'
		icon_state = "reclaimer"

/obj/item/internal_siren
	name = "Brobocop Internal Siren"
	desc = "You probably shouldn't be seeing this!"
	var/datum/light/light
	var/weeoo_in_progress = 0
	icon = 'icons/obj/scrap.dmi'
	icon_state = "reclaimer"

	New()
		..()
		var/mob/living/user = src.loc
		if (user)
			pickup(user)

	attack_self(mob/user)
		if (!src.light)
			src.light = new /datum/light/point
			src.light.set_brightness(0.7)
			src.light.attach(src.loc)
			src.weeoo()
		else
			src.weeoo()

	proc/weeoo()
		if (weeoo_in_progress)
			return

		weeoo_in_progress = 10
		spawn (0)
			playsound(src.loc, "sound/machines/siren_police.ogg", 50, 1)
			light.enable()
			while (weeoo_in_progress--)
				light.set_color(0.9, 0.1, 0.1)
				sleep(3)
				light.set_color(0.1, 0.1, 0.9)
				sleep(3)
			light.disable()

			weeoo_in_progress = 0

/obj/item/internal_siren/abilities = list(/obj/ability_button/siren)

/obj/ability_button/siren
	name = "Police Siren"
	icon_state = "on"

	execute_ability()
		var/obj/item/device/flashlight/J = the_item
		J.attack_self(the_mob)