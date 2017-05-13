//Moon related contents:
//Moon Areas
//Moon turfs
//Moon emails
//A tourguid bud
//Museum objects
//Some kind of control panel puzzle thing ???
//A li'l fake bomb for an exhibit.

#define MOON_IS_LIVE

/area/moon
	name = "moon"
	icon_state = "blue"
	filler_turf = "/turf/unsimulated/floor/lunar"
	requires_power = 0
	RL_Lighting = 1
	luminosity = 1
	RL_AmbientRed = 0.9
	RL_AmbientGreen = 0.9
	RL_AmbientBlue = 0.9

var/list/lunar_fx_sounds = list('sound/ambience/ambiatm1.ogg','sound/ambience/ambicomp2.ogg', 'sound/ambience/ambicomp3.ogg')

/area/moon/museum
	name = "Museum of Lunar History"
	icon_state = "purple"
	luminosity = 0
	RL_AmbientRed = 0.5
	RL_AmbientGreen = 0.5
	RL_AmbientBlue = 0.5

	var/sound/ambientSound = 'sound/ambience/lavamoon_interior_amb1.ogg'
	var/list/fxlist = null
	var/list/soundSubscribers = null

	New()
		..()
		fxlist = lunar_fx_sounds
		if (ambientSound)

			spawn (60)
				var/sound/S = new/sound()
				S.file = ambientSound
				S.repeat = 0
				S.wait = 0
				S.channel = 123
				S.volume = 60
				S.priority = 255
				S.status = SOUND_UPDATE
				ambientSound = S

				soundSubscribers = list()
				process()

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if(ambientSound && ismob(Obj))
			if (!soundSubscribers:Find(Obj))
				soundSubscribers += Obj

		return

	proc/process()
		if (!soundSubscribers)
			return

		var/sound/S = null
		var/sound_delay = 0


		while(ticker && ticker.current_state < GAME_STATE_FINISHED)
			sleep(60)

			if(prob(10) && fxlist)
				S = sound(file=pick(fxlist), volume=50)
				sound_delay = rand(0, 50)
			else
				S = null
				continue

			for(var/mob/living/H in soundSubscribers)
				var/area/mobArea = get_area(H)
				if (!istype(mobArea) || mobArea.type != src.type)
					soundSubscribers -= H
					if (H.client)
						ambientSound.status = SOUND_PAUSED | SOUND_UPDATE
						ambientSound.volume = 0
						H << ambientSound
					continue

				if(H.client)
					ambientSound.status = SOUND_UPDATE
					ambientSound.volume = 60
					H << ambientSound
					if(S)
						spawn(sound_delay)
							H << S

/area/moon/museum/west
	icon_state = "red"

/area/moon/museum/giftshop
	icon_state = "green"

/turf/unsimulated/floor/lunar
	name = "lunar surface"
	desc = "Regolith.  Wait, isn't moon dust actually really sticky, just from how incredibly dry it is?"
	icon_state = "lunar"
	carbon_dioxide = 0
	nitrogen = 0
	oxygen = 0
	RL_Ignore = 1

	New()
		..()
		//icon_state = "moon[rand(1,3)]"


/turf/unsimulated/wall/setpieces/lunar
	name = "moon rock"
	desc = "More regolith, now in big solid chunk form!"
	icon = 'icons/turf/walls.dmi'
	icon_state = "lunar"
	carbon_dioxide = 0
	nitrogen = 0
	oxygen = 0
	RL_Ignore = 1


/turf/unsimulated/wall/setpieces/leadwall/white/lunar
	name = "Shielded Wall"
	desc = "Painted white, of course."


/turf/unsimulated/wall/setpieces/leadwindow/white
	name = "Shielded Wall"
	desc = "Painted white, of course."
	icon_state = "leadwindow_white_1"


/datum/computer/file/record/moon_mail
	New()
		..()
		src.name = "[copytext("\ref[src]", 4, 12)]GENERIC"

	renovation_it
		New()
			..()
			fields = list("MLH_INTERNAL",
"*ALL",
"HJANSSENAA@WMLH",
"JWILLETMM@WMLH",
"MEDIUM",
"Network Outages",
"Due to the ongoing renovations, connections between museum sections may be temporarily disrupted.",
"This includes connections to the central mainframe.  Local control systems will remain operative.",
"We apologize for the inconvenience.",
"Regards",
"Harold Janssen",
"World Museum of Lunar History Information Technology Services")

	no_journalists
		New()
			..()
			fields = list("MLH_INTERNAL",
"*SEC",
"LOCALHOST",
"JWILLETMM@WMLH",
"HIGH",
"SECURITY LEVEL ELEVATED",
"The security level has been automatically elevated to GUARDED",
"due to arrival of potential threat agent.",
"Threat agent designation:  Hartman, Wallace A. ",
" DOB: 03/12/04",
" OCCUPATION: Journalist",
" Reason for inclusion in threat agent database:",
" Production of articles unfavorable to NT corporate interests",
" May attempt to produce material detrimental to museum profitability",
"",
"Recommended action: Detention of agent and confiscation of recording materials.")

	no_radicals
		New()
			..()
			fields = list("MLH_INTERNAL",
"*SEC",
"LOCALHOST",
"JWILLETMM@WMLH",
"HIGH",
"SECURITY LEVEL ELEVATED",
"The security level has been automatically elevated to GUARDED",
"due to arrival of potential threat agent.",
"Threat agent designation:  Leary, Samantha H. ",
" DOB: 11/21/22",
" OCCUPATION: Office Worker",
" Reason for inclusion in threat agent database:",
" Participation in leftist / anticorporate group WEATHER OUTERSPACE",
" Production of material expressing these views as recently as:07 MAY 2045",
"",
"Recommended action: Detention of agent.")

	ex_employee
		New()
			fields = list("MLH_INTERNAL",
"*SEC",
"LOCALHOST",
"JWILLETMM@WMLH",
"HIGH",
"SECURITY LEVEL ELEVATED",
"The security level has been automatically elevated to GUARDED",
"due to arrival of potential threat agent.",
"Threat agent designation:  Sullivan, Gerald D. ",
" DOB: 08/01/17",
" OCCUPATION: UNEMPLOYED",
" Reason for inclusion in threat agent database:",
" Former museum employee.  Employment terminated 07/31/52 due",
" to budget cuts.",
" May make revenge attempt.",
"",
"Recommended action: Monitor agent, full measures authorized if",
"agent turns violent or attempts to enter secure area.")

	saw_a_thing
		New()
			..()
			fields = list("MLH_GENERAL",
"*SEC",
"SHUGHESAF@WMLH",
"JWILLETMM@WMLH",
"LOW",
"something fucked up",
"johnny, i just saw something fucked up and I don't know who to talk to",
"okay, so I'm in the booth, right, and the only person outside is this suit",
"inspecting the renovations, this tiny indian chick",
"i'm only half paying attention and then CRASH and I look out and a bunch of",
"gantry shit has fallen on her and like there's this rebar going through her",
"shoulder. I'm all \"oh shit\" and reach for the call button but then she",
"just kinda pulls it out?? like, calmly pulls out this fuckin jagged rebar",
"that's taller than she is?  And its not the craziest part, like, she has this",
"hole in her shoulder and then all the fuckin blood just sucks back into it",
"and the hole is fuckin gone like nothing even happened",
"",
"jesus christ im glad the booth window is dark tinted because i don't",
"think she knew I was there",
"what kind of fuckin monster am I stuck in here with")

	saw_a_thing2
		New()
			..()
			fields = list("MLH_GENERAL",
"*SEC",
"SHUGHESAF@WMLH",
"JWILLETMM@WMLH",
"LOW",
"re: re: something fucked up",
"what do you mean 'yeah but is she cute' you dumb fucker")


	weird_guest
		New()
			..()
			fields = list("MLH_GENERAL",
"*ALL",
"ZGARRETTFN@WMLH",
"JWILLETMM@WMLH",
"LOW",
"Pretty Weird Guest",
"Hey Johnny, it's a shame you're on first shift because we just had the weirdest",
"fucker come by.  Dude came in dressed like some kind of hobo biker or whatever,",
"absolutely reeking of cheap booze.  We fixed him up for a \"random\" search and",
"jesus christ the dude was like a noah's ark of narcotics.  But here's the weird",
"part:  He had an NT employee ID on him, though it looked like he left it in a",
"bathtub for a week, and hey the thing still scanned...and the computer refused",
"to show any information, it's all confidential (???), and we were told to let him",
"go.  He staggered around for an hour mumbling to himself and I swear that every",
"security camera was locked on him the whole time.",
"Maybe this was a test and he's from some kinda secret shopper kinda thing? For",
"security?  I have no fuckin idea.",
"",
"Anyway, see you at the tournament.  Laters, Zack.")

	weirder_guest
		New()
			..()
			fields = list("MLH_GENERAL",
"*ALL",
"ZGARRETTFN@WMLH",
"JWILLETMM@WMLH",
"LOW",
"Another Weirdo",
"Hey Johnny, I must be cursed or something because another weirdo showed up.",
"Some dude in a torn white straightjacket thing, ranting about angels and ",
"screaming.  Maybe an escaped mental patient, but the weird thing is that he",
"showed up inside a sealed exhibit.  We got him out and took him to the",
"holding room.  Here's the even weirder thing: we left him in there alone for",
"like 30 seconds, and he just disappeared.  Not escaped, disappeared.  From a",
"locked room.  We're going to go over the security tapes, but he's not in the",
"museum.  What's up with all this spooky shit lately?")


/obj/item/disk/data/fixed_disk/lunar
	New()
		..()

		var/datum/computer/folder/currentFolder = new /datum/computer/folder {name="mails";} (src)
		src.root.add_file(currentFolder)

		currentFolder.add_file( new /datum/computer/file/record/moon_mail/renovation_it (src) )
		currentFolder.add_file( new /datum/computer/file/record/moon_mail/no_journalists (src) )
		currentFolder.add_file( new /datum/computer/file/record/moon_mail/no_radicals (src) )
		currentFolder.add_file( new /datum/computer/file/record/moon_mail/ex_employee (src) )
		currentFolder.add_file( new /datum/computer/file/record/moon_mail/saw_a_thing (src) )
		currentFolder.add_file( new /datum/computer/file/record/moon_mail/saw_a_thing2 (src) )
		currentFolder.add_file( new /datum/computer/file/record/moon_mail/weird_guest (src) )
		currentFolder.add_file( new /datum/computer/file/record/moon_mail/weirder_guest (src) )

		currentFolder = new /datum/computer/folder {name="bin";} (src)
		src.root.add_file(currentFolder)

		currentFolder.add_file( new /datum/computer/file/terminal_program/email (src) )

		src.root.add_file( new /datum/computer/file/terminal_program/secure_records {req_access = list(999);} (src) )

/obj/machinery/computer3/generic/lunarsec
	name = "Security computer"
	icon_state = "datasec"
	base_icon_state = "datasec"
	setup_drive_type = /obj/item/disk/data/fixed_disk/lunar
	setup_starting_peripheral1 = /obj/item/peripheral/network/powernet_card

#ifndef MOON_IS_LIVE
	New()
		..()

		qdel(src)
#endif

/obj/item/audio_tape/lunar_01
	New()
		..()

		messages = list("This the stuff from that journo?",

"Yeah, you want anything?  You, uh, have any interest in photography?",
"How about a nice microphone?  Your kid still have that band?",

"Ugh, yeah.  \"Thanks for the microphone, dad, now let me sing about how totally unfair and lame you are all the time.\"",
"No thanks.",

"So, did you hear that they're going to try and, uh, move the Channel closer to Earth?",

"Can they even do that?  How the hell do you move a wormhole?",
"I sucked at high school physics but that just sounds like it breaks some rule.",

"Well, it's got those solid bits generating it or whatever, don't it?  Maybe they pull that?",
"I hope they don't, personally.  Who the hell is going to come to the moon if they can go right through to a goddamn plasma goldmine without travelling for months?",

"Maybe they want to see the, um.  Fuck if I know, man.")

		speakers = list("Male voice", "Other male voice", "Other male voice", "Male voice", "Male voice", "Other male voice", "Male voice", "Male voice", "Other male voice", "Other male voice", "Male voice")

/obj/item/device/audio_log/lunar_01

	New()
		..()
		src.tape = new /obj/item/audio_tape/lunar_01(src)

/obj/machinery/bot/guardbot/old/tourguide/lunar
	name = "Molly"
	desc = "A PR-4 Robuddy. These are pretty old, guess the museum doesn't change often.  This one has a little name tag on the front labeled 'Molly'"
	setup_default_startup_task = /datum/computer/file/guardbot_task/tourguide/lunar
	no_camera = 1
	setup_charge_maximum = 3000
	setup_charge_percentage = 100
	flashlight_lum = 4

	New()
		..()
#ifndef MOON_IS_LIVE
		del(src)
#endif
		spawn (10)
			if (src.botcard)
				src.botcard.access += 999


//"Oh, hello!  I apologize, I wasn't expecting guests before the renovations were done!  Welcome to the Museum of Lunar History!"
//"Before we begin, there is a request that all guests from Soviet bloc countries move down the hall to my right for special screening."
//"This, um, includes those from Zvezda.  Even if you have a day pass.  I'm sorry, I hope this isn't too much of a bother!"

//"Nanotrasen employees may be eligible for an employee discount.  Now checking Museum Central, please hold..."
//"Oh, I'm sorry.  Your position is not eligible.  Actually, um, well this is weird."
//"There is a log indicating that all employees of Research Station #13 are to be charged 10% extra.  I've never seen that before.  Huh."

//"FAAE or, as it is commonly called, Plasma, was first discovered here on the moon in 1969."
//"It's not actually native to the moon, though!  It was discovered embedded in the site of a meteorite impact."

//"This is the actual, genuine recreation of the site where Neil Armstrong first walked on the moon!  Of course, it now sits much lower due to extensive strip mining."
//"As you have selected the surface tour option, we will get to walk in Neil's reconstructed footprints!  Wow!  Please, ensure your helmets are latched and follow me through the airlock in an orderly manner!"

//"This is a model of the NASA LESA base, the first permanent lunar base.  Construction finished in fall 1971 and it wasn't decommissioned until 1996!"
//"It was the main site for plasma mining before Nanotrasen received mineral rights."

//"I hope I'm around for the centennial!"

//"This is Yuri Gagarin, the first man to go to outer space. He orbited the Earth on April 12, 1961. He um, died. MOVING ON"

//"This exhibit remembers the 2004 Lunar Port Hostage Crisis, where the primary spaceport was seized for a terrifying four days by the Space Irish Republican Army.|pIn the aftermath, laws were passed boosting the size and capability of corporate security forces--boosting our safety without violating the 1967 Outer Space Treaty!"

/obj/machinery/navbeacon/lunar
	name = "tour beacon"
	freq = 1441

	tour0
		name = "tour beacon - start"
		location = "tour0"
		codes_txt = "tour;next_tour=tour1;desc=Oh, hello!  I apologize, I wasn't expecting guests before the renovations were done!  Welcome to the Museum of Lunar History!\nBefore we begin, there is a request that all guests from Soviet bloc countries move down the hall to my right for special screening.\nThis, um, includes those from Zvezda.  Even if you have a day pass.  I'm sorry, I hope this isn't too much of a bother!"

	tour1
		location = "tour1"
		codes_txt = "tour;next_tour=tour2;desc=FAAE or, as it is commonly called, Plasma, was first discovered here on the moon in 1969.\nIt's not actually native to the moon, though!  It was discovered embedded in the site of a meteorite impact, extending down really far, almost like it grew outward!|pBut it didn't, because plasma crystals can't grow, ha ha..|pIt makes sense that more plasma was found in the asteroid belt.  Oh, and through the Channel, um, as much as weird holes in space time make sense."

	tour2
		location = "tour2"
		codes_txt = "tour;next_tour=tour3;desc=Lunar plasma deposits were almost entirely in crystalline form.  Mining efforts went pretty slowly before Nanotrasen arrived!"

	tour3
		location = "tour3"
		codes_txt = "tour;next_tour=tour4;desc=Nanotrasen, then the newly-diversifying National Notary Supply Company, first acquired plasma samples from the Apollo missions through connections to this man, the visionary Victor Jam, head of the Senate Committee on Aeronau--|pOh, um, I guess this is down for renovations.  Nevermind."

	tour4
		location = "tour4"
		codes_txt = "tour;next_tour=tour5;desc=This is the site of our star exhibit, the Apollo 11 Experience!  Well, it will be the star when renovations are done and it has more displays and material.  Eventually.|pI'm really sorry that it isn't done yet.  Did I mention that?"

	tour5
		location = "tour5"
		codes_txt = "tour;next_tour=tour6;desc=Outside that window is the actual, genuine recreation of the site where Neil Armstrong first walked on the moon!  Of course, it now sits much lower due to extensive strip mining.|pAs you have selected the surface tour option, we will get to walk in Neil's reconstructed footprints!  Wow!  Please, ensure your helmets are latched and follow me through the airlock in an orderly manner!"

	tour6
		location = "tour6"
		codes_txt = "tour;next_tour=tour7;desc=Again, please make sure your suit is secured!  As I understand, air is kinda important."

	tour7
		location = "tour7"
		New()
			var/goofy_story = pick_string("lunar.txt", "mary_stories")
			codes_txt = "tour;next_tour=tour8;desc=This is the lunar surf..oh! You probably can't hear me, being that we are outside and my audio systems aren't hooked to the radio.  Ha ha.  I guess I can just say anything I want now.  [goofy_story]"
			..()

	tour8
		location = "tour8"
		codes_txt = "tour;next_tour=tour9;desc=Wow, That sure was fun!  And nobody was hurt, which is important.  Please disregard this message if anyone was hurt or did not have fun."

	tour9
		location = "tour9"
		codes_txt = "tour;next_tour=tour10;desc=This is a model of the NASA LESA base, the first permanent lunar base.  Construction finished in fall 1971 and it wasn't decommissioned until 1996!|pIt was the main site for plasma mining before Nanotrasen received mineral rights.|pThe base accomplished a great deal of scientific discovery and answered age-old questions, such as \"is the moon made of cheese?\" and \"is the moon full of tiny little men named Gary?\""

	tour10
		location = "tour10"
		codes_txt = "tour;next_tour=tour11;desc=Oh, um, I guess this compartment is sealed.  And decompressed.  Okay then.  That just covers the spaceport that became the city.  Nothing important..."

	tour11
		location = "tour11"
		codes_txt = "tour;next_tour=tour12;desc=This is also normally open.  And working.  I'll try to get your ticket fees refunded because this is just completely unacceptable."

	tour12
		location = "tour12"
		codes_txt = "tour;next_tour=tour13;desc=Oh, the Lunaport exhibits are still in this hall!  Good!"

	tour13
		location = "tour13"
		codes_txt = "tour;next_tour=tour14;desc=This exhibit remembers the 2004 Lunar Port Hostage Crisis, where the primary spaceport was seized for a terrifying four days by the Space Irish Republican Army.|pIn the aftermath, laws were passed boosting the size and capability of corporate security forces--boosting our safety without violating the 1967 Outer Space Treaty!"

	tour14
		location = "tour14"
		codes_txt = "tour;next_tour=tour15;desc=This exhibit is on Wallace Jam, the longest-serving administrator of the Lunaport, during the economic boom times of 2001 to 2024.  Please note the whimsical bag of jellybeans on his desk.  He was known for throwing them at people."

	tour15
		location = "tour15"
		codes_txt = "tour;next_tour=tour16;desc=This is the MNX-12, the first master computer of Lunaport, operational from the 2021 administration sector expansion until 2041.  It managed a ton of tasks across the growing city.|pThis was Thinktronic Data System's first big contract with Nanotrasen!  Fun fact: the first robuddy United States senator, Lloyd-019, started out working under MNX in 2031!"

	tour16
		location = "tour16"
		codes_txt = "tour;next_tour=tour17;desc=This is Greg, also affectionately called \"Lousy Greg,\" beloved town character known for...laying down apparently?  Um, maybe this would be a good time to hit the gift shop?  Yes."

	tour17
		location = "tour17"
		codes_txt = "tour;"

#define NT_DISCOUNT  1
#define NT_CLOAKER   2
#define NT_OTHERGUIDE 4
#define NT_PONZI     8
#define NT_SPY		16
#define NT_BILL		32
#define NT_BEE		64
#define NT_SOLARIUM	128
#define NT_CHEGET	256

/datum/computer/file/guardbot_task/tourguide/lunar

	wait_for_guests = 1

	look_for_neat_thing()

		if (istype(get_area(src.master), /area/solarium) && !(src.neat_things & NT_SOLARIUM))
			src.neat_things |= NT_SOLARIUM

			master.speak("Huh, this place is weird!  This is some ship and that's our sun, right?")
			if (prob(25))
				spawn (10)
					if (master)
						master.speak("I, um, am going to need to go back to work.  My shift isn't over yet.")
			return

		for (var/atom/movable/AM in view(7, master))
			if (istype(AM, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = AM
				if (!(src.neat_things & NT_BILL) && cmptext(H.real_name, "shitty bill"))
					src.neat_things |= NT_BILL

					master.visible_message("<b>[master]</b> points at [H].")
					master.speak("Oh no, not you again.  Uh, I mean...hey...guyyy.")

				if (!(src.neat_things & NT_DISCOUNT) && H.stat != 2 && (istype(H.wear_id, /obj/item/card/id) || (istype(H.wear_id, /obj/item/device/pda2) && H.wear_id:ID_card)))
					src.neat_things |= NT_DISCOUNT

					master.speak("Nanotrasen employees may be eligible for an employee discount.  Now checking Museum Central, please hold...")
					spawn (15)
						if (master)
							master.speak("Oh, I'm sorry.  Your position is not eligible.  Actually, um, well this is weird.")
						sleep(8)
						if (master)
							master.speak("There is a log indicating that all employees of Research Station #13 are to be charged 10% extra.  I've never seen that before.  Huh.")

					return

				if (!(src.neat_things & NT_CLOAKER) && H.invisibility > 0)
					src.master.speak("This is a reminder that cloaking technology is illegal within the inner solar system.  Please remain opaque to the visible spectrum as a courtesy to your fellow guests.  Thanks!")
					src.neat_things |= NT_CLOAKER
					return

				if (!(src.neat_things & NT_PONZI) && (locate(/obj/item/spacecash/buttcoin) in AM.contents))
					src.neat_things |= NT_PONZI
					src.master.speak("Um, I'm sorry [AM], we do not accept blockchain-based cryptocurrency as payment.  You aren't one of those guys who yell about gold on the apollo flag or something, right?")
					H.unlock_medal("To the Moon!",1)
					return

			if (istype(AM, /obj/machinery/bot/guardbot) && AM != src.master)
				if (istype(AM, /obj/machinery/bot/guardbot/old/tourguide) && !(src.neat_things & NT_OTHERGUIDE))
					src.neat_things |= NT_OTHERGUIDE
					src.master.visible_message("<b>[master]</b> nods professionally at [AM].<br>Well, really it's more of a shake from suddenly halting the drive motors, but you get the intent.")

					animate(master, pixel_x = -4, time = 10, loop = 1, easing = SINE_EASING)

					animate(pixel_x = 0, transform = matrix(10, MATRIX_ROTATE), time = 10, loop = 1, easing = SINE_EASING)
					animate(transform = matrix(-10, MATRIX_ROTATE), time = 10, loop = 1, easing = SINE_EASING)

					return

			if (istype(AM, /obj/critter/moonspy) && !(src.neat_things & NT_SPY))
				src.neat_things |= NT_SPY
				master.visible_message("<b>[master]</b> points at [AM].")
				src.master.speak("Attention guests, there appears to be a coat rack or something available if needed.")
				spawn (10)
					if (src.master)
						src.master.speak("You know, because of all the coats that you are clearly wearing.")

				return

			if (istype(AM, /obj/critter/domestic_bee) && !(src.neat_things & NT_BEE))
				src.neat_things |= NT_BEE
				master.visible_message("<b>[master]</b> points at [AM].")
				src.master.speak("Ah, a space bee!  Space bees count as minors under 12 for the purposes of ticket pricing.")

				return

			if ((istype(AM, /obj/item/luggable_computer/cheget) || istype(AM, /obj/machinery/computer3/luggable/cheget)) && !(src.neat_things & NT_CHEGET))
				src.neat_things |= NT_CHEGET
				src.master.speak("Huh, what's with the briefcase?  Did that come out of the security annex?  Somebody should probably call security or the embassy or something.")
				spawn (10)
					if (src.master)
						src.master.speak("I think they dealt with some kind of briefcase key the week before renovations started?  There's some sad office worker out there right now.")
				return

		//wip

		return

	task_input(var/input)
		if (..())
			return

		if (input == "broken_door")
			if (src.master.mover)
				src.master.mover.master = null //master mover master mover master mover help HELP
				src.master.mover = null
			master.moving = 0

			sleep(10)
			src.master.speak("Uh.  That isn't supposed to happen.")
			src.state = 0	//Yeah, let's find that route.

			spawn(10)
				if (src.master)
					src.master.speak("I guess we need to take another route.  Please follow me.")
					src.state = 0
					src.awaiting_beacon = 0
					next_beacon_id = current_beacon_id
					src.task_act()


#undef NT_DISCOUNT
#undef NT_CLOAKER
#undef NT_OTHERGUIDE
#undef NT_PONZI
#undef NT_SPY
#undef NT_BILL
#undef NT_BEE
#undef NT_SOLARIUM
#undef NT_CHEGET

/obj/machinery/door/poddoor/blast/lunar
	name = "security door"
	desc = "A security door used to separate museum compartments."
	autoclose = 0
	req_access_txt = ""

/obj/machinery/door/poddoor/blast/lunar/tour

	isblocked()
		return (src.density && src.operating == -1)

	open(var/obj/callerDoor)
		if (src.operating == 1) //doors can still open when emag-disabled
			return
		if (!density)
			return 0

		for (var/obj/machinery/door/poddoor/blast/lunar/tourDoor in orange(1, src))
			if (tourDoor == callerDoor)
				continue

			spawn (0)
				tourDoor.open(src)

		if(!src.operating) //in case of emag
			src.operating = 1
		flick("bdoor[doordir]c0", src)
		src.icon_state = "bdoor[doordir]0"
		sleep(10)
		src.density = 0
		src.RL_SetOpacity(0)
		update_nearby_tiles()

		if(operating == 1) //emag again
			src.operating = 0
		if(autoclose)
			spawn(150)
				autoclose()
		return 1


	close(var/obj/callerDoor)
		if (src.operating)
			return
		if (src.density)
			return
		src.operating = 1

		for (var/obj/machinery/door/poddoor/blast/lunar/tour/tourDoor in orange(1, src))
			if (tourDoor == callerDoor)
				continue

			spawn (0)
				tourDoor.close(src)

		flick("bdoor[doordir]c1", src)
		src.icon_state = "bdoor[doordir]1"
		src.density = 1
		if (src.visible)
			src.RL_SetOpacity(1)
		update_nearby_tiles()

		sleep(10)
		src.operating = 0
		return

	attackby(obj/item/C as obj, mob/user as mob)
		src.add_fingerprint(user)
		return


/obj/machinery/door/lunar_breakdoor
	name = "External Airlock"
	icon = 'icons/misc/lunar.dmi'
	icon_state = "breakairlock0"
	anchored = 1
	density = 1
	opacity = 1
	autoclose = 0
	cant_emag = 1
	req_access = list(999)

	var/broken = 0

	New()
		..()
		UnsubscribeProcess()

	close()
		return

	isblocked()
		return broken

	open()
		if (src.broken)
			return

		src.broken = 1

		playsound(src.loc, 'sound/machines/airlock_break_very_temp.ogg', 50, 1)
		spawn (0)
			flick("breakairlock1", src)
			src.icon_state = "breakairlock2"
			sleep (2)
			src.opacity = 0
			sleep(6)
			var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
			s.set_up(3, 1, src)
			s.start()
			pool(s)

		for (var/obj/machinery/door/airlock/otherDoor in view(7, src))
			if (777 in otherDoor.req_access)
				otherDoor.req_access -= 777

		var/obj/machinery/bot/guardbot/old/theTourguide = locate() in view(src)
		if (istype(theTourguide) && theTourguide.task)
			theTourguide.task.task_input("broken_door")



/obj/decal/lunar_bootprint
	name = "Neil Armstrong's genuine lunar bootprint"
	desc = "The famous photographed bootprint is actually from Buzz Aldrin, but this is the genuine actual real replica of the FIRST step on the moon.  A corner of another world that is forever mankind."
	anchored = 1
	density = 0
	layer = TURF_LAYER
	icon = 'icons/misc/lunar.dmi'
	icon_state = "footprint"
	pixel_x = -8
	var/somebody_fucked_up = 0

	attack_hand(mob/user as mob)
		if (!user)
			return

		if (user.loc != src.loc)
			boutput(user, "If you got really close, you could probably compare foot sizes.")
			return

		user.visible_message("<b>[user]</b> steps right into [src.name].", "<span style=\"color:blue\">You step into the footprint. Ha ha, oh man, your foot fits right into that!</span>")
		if (!somebody_fucked_up)
			desc += " There's some total idiot fucker's footprint smooshed into the center."
			boutput(user, "<span style=\"color:red\">OH FUCK you left your footprint over it!  You fucked up a 90 year old famous footprint. You assumed it was covered in some kind of protective resin or something, shit!!</span>")

		somebody_fucked_up = 1


/obj/decal/fakeobjects/moon_on_a_stick
	name = "Moon model"
	desc = "A really large mockup of the Earth's moon."
	icon = 'icons/misc/lunar64.dmi'
	icon_state = "moon"
	anchored = 1
	density = 1
	layer = MOB_LAYER + 1

	New()
		..()

#ifndef MOON_IS_LIVE
		del(src)
#endif

		var/image/stand = image('icons/misc/lunar.dmi', "moonstand")
		stand.pixel_x = 16
		src.pixel_y = 24
		stand.pixel_y = -24
		stand.layer = OBJ_LAYER
		src.underlays += stand

/obj/decal/fakeobjects/lunar_lander
	name = "Lunar module descent stage"
	desc = "The descent stage of the Apollo 11 lunar module, which landed the first astronauts on the moon."
	anchored = 1
	density = 1
	icon = 'icons/misc/lunar64.dmi'
	icon_state = "LEM"
	bound_height = 64
	bound_width = 64

#ifndef MOON_IS_LIVE
	New ()
		..()

		del (src)
#endif

/obj/decal/fakeobjects/moonrock
	name = "moon rock"
	desc = "A piece of regolith. Or something. It is a heavy rock from the moon.  These used to be worth more."
	icon = 'icons/misc/lunar.dmi'
	icon_state = "moonrock"
	anchored = 1
	density = 1

#ifndef MOON_IS_LIVE
	New()
		..()

		del(src)
#endif

/obj/critter/mannequin
	name = "mannequin"
	desc = "It's a dummy, dummy."
	icon = 'icons/misc/lunar.dmi'
	icon_state = "mannequin"
	atkcarbon = 0
	atksilicon = 0
	health = 10
	firevuln = 1	//Typical store display mannequin has a styrofoam body and metal skeleton.  Styrofoam /burns/
	brutevuln = 0.5
	aggressive = 0
	defensive = 0
	wanderer = 0
	generic = 0
	flying = 0
	death_text = "%src% tips over, its joints seizing and locking up.  It does not move again."
	angertext = "seems to stare at"

	var/does_creepy_stuff = 0
	var/typeName = "Generic"

#ifndef MOON_IS_LIVE
	New()
		..()

		del(src)
#endif

	CritterAttack(mob/M)
		src.attacking = 1
		src.visible_message("<span style=\"color:red\"><B>[src]</B> awkwardly bashes [src.target]!</span>")
		random_brute_damage(src.target, rand(5,15))
		playsound(src.loc, "sound/misc/automaton_spaz.ogg", 50, 1)
		spawn(10)
			src.attacking = 0

	process()
		if(!..())
			return 0
		if (!alive || !does_creepy_stuff)
			return

		if (prob(6))
			playsound(src.loc, "sound/misc/automaton_tickhum.ogg", 60, 1)
			src.visible_message("<span style=\"color:red\"><b>[src] emits [pick("a soft", "a quiet", "a curious", "an odd", "an ominous", "a strange", "a forboding", "a peculiar", "a faint")] [pick("ticking", "tocking", "humming", "droning", "clicking")] sound.</span>")

		if (prob(6))
			playsound(src.loc, "sound/misc/automaton_ratchet.ogg", 60, 1)
			src.visible_message("<span style=\"color:red\"><b>[src] emits [pick("a peculiar", "a worried", "a suspicious", "a reassuring", "a gentle", "a perturbed", "a calm", "an annoyed", "an unusual")] [pick("ratcheting", "rattling", "clacking", "whirring")] noise.</span>")

		if (prob(5))
			playsound(src.loc, "sound/misc/automaton_spaz.ogg", 50, 1)
			src.visible_message("<span style=\"color:red\"><b>[src]</b> [pick("turns", "pivots", "twitches", "spins")].</span>")
			src.dir = pick(alldirs)

/obj/critter/moonspy
	name = "\proper not a syndicate spy probe"
	desc = "It's probably a coat rack or something."
	icon = 'icons/misc/worlds.dmi'
	icon_state = "drone_service_bot"
	density = 1
	health = 35
	aggressive = 0
	defensive = 1
	wanderer = 0
	opensdoors = 1
	atkcarbon = 1
	atksilicon = 1
	atcritter = 0
	firevuln = 0.5
	brutevuln = 0.5
	sleeping_icon_state = "drone_service_bot_off"
	flying = 0
	generic = 0
	death_text = "%src% stops moving."

	var/static/list/non_spy_weapons = list("something that isn't a high gain microphone", "an object distinct from a tape recorder", "object that is, in all likelihood, not a spy camera")

#ifndef MOON_IS_LIVE
	New()
		..()

		del(src)
#endif

	ChaseAttack(mob/M)
		src.visible_message("<span style=\"color:red\"><B>[src]</B> launches itself towards [M]!</span>")
		if (prob(20)) M.stunned += rand(1,3)
		random_brute_damage(M, rand(2,5))

	CritterAttack(mob/M)
		src.attacking = 1
		src.visible_message("<span style=\"color:red\">The <B>[src.name]</B> [pick("conks", "whacks", "bops")] [src.target] with [pick(non_spy_weapons)]!</span>")
		random_brute_damage(src.target, rand(2,4))
		spawn(10)
			src.attacking = 0

	CritterDeath()
		if (!src.alive) return
		src.alive = 0
		walk_to(src,0)
		src.visible_message("<b>[src]</b> blows apart!  But not in a way at all like surveillance equipment.  More like a washing machine or something.")

		spawn(0)
			var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
			s.set_up(3, 1, src)
			s.start()
			qdel(src)


/obj/item/clothing/suit/lunar_tshirt
	name = "museum of lunar history t-shirt"
	desc = "Size small.  However, just fifty years ago this would have been considered an XXL."
	icon = 'icons/obj/clothing/overcoats/item_suit_gimmick.dmi'
	wear_image_icon = 'icons/mob/overcoats/worn_suit_gimmick.dmi'
	inhand_image_icon = 'icons/mob/inhand/overcoat/hand_suit_gimmick.dmi'
	icon_state = "moon_tshirt"
	item_state = "moon_tshirt"
	body_parts_covered = TORSO|ARMS


#define REASON_NONE			0
#define REASON_ADDTEXT		1
#define REASON_CLEARSCREEN	2
#define REASON_UPDATETEXT	4
obj/machinery/embedded_controller/radio/maintpanel
	name = "maintenance access panel"
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "museum_control"
	anchored = 1
	density = 0

	var/id_tag = null
	var/net_id = null
	var/locked = 0
	var/blinking = 0
	var/obj/machinery/power/data_terminal/wired_connection = null
	var/setup_string
	var/datum/light/light

	var/updateFlags = 0
	var/the_goddamn_regex = "/\\s/gm"
	//req_access

	New()
		..()
		light = new /datum/light/point
		light.attach(src)
		light.set_color(0.6, 1, 0.66)
		light.set_brightness(0.4)
		light.enable()

		spawn (5)
			if (src.tag)
				src.id_tag = src.tag
				src.tag = null

			src.net_id = generate_net_id(src)

			if(!src.wired_connection)	//Find the data terminal if there is one around.
				var/turf/T = get_turf(src)
				var/obj/machinery/power/data_terminal/test_link = locate() in T
				if(test_link && !test_link.is_valid_master(test_link.master))
					src.wired_connection = test_link
					src.wired_connection.master = src

	attackby(obj/item/I, mob/user)
		if (istype(I, /obj/item/card/id))
			if (user && src.allowed(user, req_only_one_required))
				boutput(user, "<font style='color: green;'>Access approved..</font>")
				src.locked = !src.locked
				updateUsrDialog()
			else
				boutput(user, "<font style='color: red;'>Access denied.</font>")

		else
			return ..()

	post_signal(datum/signal/signal, comm_line)
		if (!signal || (stat & NOPOWER))
			return

		signal.source = src
		signal.data["sender"] = src.net_id
		if (comm_line)
			signal.transmission_method = TRANSMISSION_WIRE
			if (wired_connection)
				wired_connection.post_signal(src, signal)

		else
			signal.transmission_method = TRANSMISSION_RADIO
			if(radio_connection)
				return radio_connection.post_signal(src, signal, 100)

	initialize()
		..()

		var/datum/computer/file/embedded_program/maintpanel/new_prog = new
		new_prog.master = src
		program = new_prog

		if (setup_string)
			new_prog.do_setup(setup_string)


	receive_signal(datum/signal/signal, receive_method, receive_param)
		if(!signal || signal.encryption)
			return

		if (!cmptext(signal.data["address_1"], src.net_id))
			if (cmptext(signal.data["address_1"], "ping"))
				var/datum/signal/pingsignal = get_free_signal()
				pingsignal.data["device"] = "MCU_CONTROL"
				pingsignal.data["netid"] = src.net_id
				pingsignal.data["address_1"] = signal.data["sender"]
				pingsignal.data["command"] = "ping_reply"

				post_signal(pingsignal)

			return

		if(program)
			return program.receive_signal(signal, receive_method, receive_param)


	process()
		if (stat & NOPOWER)
			update_icon()
			return

		return ..()

	update_icon()
		if (stat & NOPOWER)
			icon_state = "museum_control_off"
		else
			icon_state = blinking ? "museum_control_blink" : "museum_control"

	attack_hand(mob/user)
		user.machine = src
		var/dat = {"<!DOCTYPE html>
<html>
<head>
<TITLE>Intelligent Maintenance Panel</TITLE>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<style>

	@font-face
	{
		font-family: 'Glass_TTY_VT220';
		src: url('glass_tty_vt220.eot');
		src: url('glass_tty_vt220.eot') format('embedded-opentype'),
			 url('glass_tty_vt220.ttf') format('truetype'),
			 url('glass_tty_vt220.woff') format('woff'),
			 url('glass_tty_vt220.svg') format('svg');
	}

	body {background-color:#999876;}

	img {border-style: none;}

	hr {
		color:#31A131;
		border-style:solid;
		background-color:#31A131;
		height:14px;
		}

	a:link {text-decoration:none}


	#outputscreen
	{
		border: 1px solid gray;
		height: 13em;
		width: 36ex;
		position: absolute;
		left: 60px;
		overflow-y: hidden;
		overflow-x: hidden;
		word-wrap: break-word;
		word-break: break-all;
		background-color:#111F10;
		color:#31C131;
		font-size:14pt;
	}

	.outputline
	{
		border: 0;
		height: 1.4em;
		width: 32ex;
		overflow-y: hidden;
		overflow-x: hidden;
		word-wrap: break-word;
		word-break: break-all;
		background-color:#111F10;
		color:#31C131;
		font-family: Glass_TTY_VT220;
		font-size: 14pt;
	}

	#alertpanel
	{
		border: 8px solid #31A131;
		text-align: center;
		margin: auto auto auto auto;
		width: 10ex;
		top: 40%;
	}

	.controlbutton
	{
		border: 1px solid black;
		background-color: #CF6300;
		width: 40px;
		height: 20px;
		position: absolute;
		left: 20px;
		display:block;
		text-align: center;
		color: #D0D0D0;
		font-size: small;
	}

</style>
</head>

<body scroll=no><br>

<div id="outputscreen">
"}
		for (var/screenlineIndex = 0, screenlineIndex < 13, screenlineIndex++)
			dat += "<div id=\"screenline[screenlineIndex]\" class=\"outputline\"></div>"

		dat +={"</div>
<a id="button1" class='controlbutton' style="top:290px; left:76px"  href='byond://?src=\ref[src];command=button1'>&#8678;</a>
<a id="button2" class='controlbutton' style="top:290px; left:151px" href='byond://?src=\ref[src];command=button2'>&#8680;</a>
<a id="button3" class='controlbutton' style="top:290px; left:226px" href='byond://?src=\ref[src];command=button3'>SEL</a>
<a id="button4" class='controlbutton' style="top:290px; left:301px" href='byond://?src=\ref[src];command=button4'>BACK</a>

<a id="button5" class='controlbutton' style="top:330px; left:76px"  href='byond://?src=\ref[src];command=button5'>&#8681;</a>
<a id="button6" class='controlbutton' style="top:330px; left:151px" href='byond://?src=\ref[src];command=button6'>&#8679;</a>
<a id="button7" class='controlbutton' style="top:330px; left:226px" href='byond://?src=\ref[src];command=button7'>ACT</a>
<a id="button8" class='controlbutton' style="top:330px; left:301px" href='byond://?src=\ref[src];command=button8'>DEAC</a>


<script type="text/javascript">
	var printing = \["","","","","","","","","","","","",""];
	var t_count = 0;
	var last_output;


	function setLocked ()
	{
		if (last_output)
		{
			window.clearTimeout(last_output);
			last_output = null;
		}

		var line = 0;
		for (; line < 13; line++)
		{
			document.getElementById("screenline" + line).innerHTML = "&#8199;";
		}
		document.getElementById("screenline4").innerHTML = "<div id='alertpanel'>&#8199;LOCKED&#8199;</div>";
	}

	function clearScreen ()
	{
		if (last_output)
		{
			window.clearTimeout(last_output);
			last_output = null;
		}

		var line = 0;
		for (; line < 13; line++)
		{
			document.getElementById("screenline" + line).innerHTML = "&#8199;";
		}
	}

	function setDisplay (output, line)
	{
		if (last_output)
		{
			window.clearTimeout(last_output);
			last_output = null;
		}
		if (isNaN(line))
		{
			line = 1;
		}
		else
		{
			line = Math.round(line);
			if (line < 1 || line > 13)
			{
				return;
			}
		}

		output = output.substr(0,32);
		output = output.replace([the_goddamn_regex], "&#8288; ");
		document.getElementById("screenline" + (line-1)).innerHTML = output;
	}


	function consoleTextOut(t, line)
	{
		var callPrint = 0;
		if (isNaN(line))
		{
			line = 1;
		}
		else
		{
			line = Math.round(line);
			if (line < 1 || line > 13)
			{
				return;
			}
		}

		var splitT = t.split("<br>");
		var splitTIndex = 0;
		for (; splitTIndex < splitT.length && line <= 13; splitTIndex++, line++)
		{
			t = splitT\[splitTIndex];
			if (t.length > 32)
			{
				t = t.toUpperCase();
				while (t.length > 32)
				{
					printing\[line-1] = t.substr(0,32);
					document.getElementById("screenline" + (line-1)).innerHTML = "";
					t = t.substr(32);

					if (line >= 13)
					{
						break;
					}
					line++;
				}

				callPrint = 1;

			}
			else
			{
				callPrint += printing\[line-1].length < 1;
			}
			printing\[line-1] = t.toUpperCase();
			document.getElementById("screenline" + (line-1)).innerHTML = "";
		}

		if (callPrint)
		{
			last_output = window.setInterval((function () {consoleTextOutInterval();}), 10);
		}


	}

	function consoleTextOutInterval()
	{
		var i = 0;
		for (; i < 13; i++)
		{
			if (!printing\[i].length)
			{
				continue;
			}
			var t_bit = printing\[i].substr(0,1);
			printing\[i] = printing\[i].substr(1);
			if (t_bit == " ")
			{
				t_bit = "&#8288; ";
			}

			document.getElementById("screenline" + i).innerHTML += t_bit;

			document.getElementById("outputscreen").scrollTop = document.getElementById("outputscreen").scrollHeight;
			return;
		}

		window.clearTimeout(last_output);
		last_output = null;
		return;
	}"}
		if (locked)
			dat += "setLocked();"
		else if (program)
			for (var/indexNum = 1, indexNum < 13, indexNum++)
				dat += "setDisplay(\"[program.memory["display[indexNum]"]]\", [indexNum]); "

		dat += "</script></body></html>"

		user << browse(dat, "window=maintpanel;size=435x380;can_resize=0")
		onclose(user, "maintpanel")

	Topic(href, href_list)
		if (stat & NOPOWER)
			return

		if (get_dist(src, usr) > 1 && !issilicon(usr))
			return

		if(program)
			program.receive_user_command(href_list["command"])

		usr.machine = src

	process()
		if(!(stat & NOPOWER) && program)
			program.process()

		update_icon()

	updateUsrDialog(var/reason)
		var/list/nearby = viewers(1, src)
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				if (reason || updateFlags)
					src.dynamicUpdate(M, reason|updateFlags)
					updateFlags = REASON_NONE
				else
					src.attack_hand(M)

		if (istype(usr, /mob/living/silicon))
			if (!(usr in nearby))
				if (usr.client && usr.machine==src)
					if (reason || updateFlags)
						src.dynamicUpdate(usr, reason|updateFlags)
						updateFlags = REASON_NONE
					else
						src.attack_ai(usr)

		if (program)
			for (var/line = 1, line <= 13, line++)
				if (program.memory["display_add[line]"])
					program.memory["display[line]"] = program.memory["display_add[line]"]
					program.memory["display_add[line]"] = null

	proc/dynamicUpdate(mob/user, reasonFlags)
		if (reasonFlags & REASON_CLEARSCREEN)
			user << output(null, "maintpanel.browser:clearScreen")
		if (program)
			if (reasonFlags & REASON_ADDTEXT)
				for (var/line = 1, line < 14, line++)
					if (program.memory["display_add[line]"])
						user << output(url_encode(program.memory["display_add[line]"])+"&[line]", "maintpanel.browser:consoleTextOut")


			else
				for (var/line = 1, line < 14, line++)
					if (program.memory["display[line]"])
						user << output(url_encode(program.memory["display[line]"])+"&[line]", "maintpanel.browser:setDisplay")

/*
	return_text()
		if (stat & NOPOWER)
			return ""

		if (locked)
			return "<div id='alertpanel'>&#8199;LOCKED&#8199;</div>"

		if (program)
			return program.memory["display"]
*/

#define ENTRY_MAX	24
#define PANELSTATE_MAIN_MENU	0
#define PANELSTATE_ENTRY_MENU	1

datum/computer/file/embedded_program/maintpanel
	name = "maintpnl"
	extension = "EPG"
	state = PANELSTATE_MAIN_MENU

	var/tmp/list/device_entries = list()
	var/tmp/selected_entry = 0
	var/tmp/list/sessions = list()

	New()
		..()
		for (var/line = 1, line <= 13, line++)
			memory += "display[line]"
			memory["display[line]"] = ""

			memory += "display_add[line]"
			memory["display_add[line]"] = ""

		spawn (10)
			updateDisplay()

	disposing()
		if (device_entries)
			for (var/datum/entry in device_entries)
				entry.disposing()

			device_entries = null

		sessions = null

		..()

	proc/do_setup(var/setupString)
		var/list/setupList = dd_text2list(setupString, ";")
		if (!setupList || !setupList.len)
			return

		for (var/setupEntry in setupList)
			var/entryName = ""
			. = findtext(setupEntry, ",")
			if (.)
				entryName = copytext(setupEntry, .+1)
				setupEntry = copytext(setupEntry, 1, .)

			if (cmptext(copytext(setupEntry, 1, 5), "fake"))
				. = text2path("/datum/maintpanel_device_entry/dummy[copytext(setupEntry, 5)]")
				if (.)
					src.device_entries += new . (src, entryName)
				else
					src.device_entries += new /datum/maintpanel_device_entry/dummy (src, entryName)
				continue

			var/obj/controlTarget = locate(setupEntry)
			if (!controlTarget)
				logTheThing("debug", null, null, "Maint control panel at \[[master.x], [master.y], [master.z]] had invalid setup tag \"[setupEntry]\"")
				continue

			if (istype(controlTarget, /obj/machinery/door/airlock))
				src.device_entries += new /datum/maintpanel_device_entry/airlock (src, controlTarget, entryName)

			else if (istype(controlTarget, /obj/machinery/door/poddoor))
				src.device_entries += new /datum/maintpanel_device_entry/podlock (src, controlTarget, entryName)

			else if (istype(controlTarget, /obj/critter/mannequin))
				src.device_entries += new /datum/maintpanel_device_entry/mannequin (src, controlTarget, entryName)

		while (src.device_entries.len < 16)
			src.device_entries += new /datum/maintpanel_device_entry/dummy (src, pick("GEN$$E$C", "MANNEA83IN 13", "M@____$CC DOOR $$S9", "########?3"))

	receive_user_command(command)
		switch (command)
			if ("button1")	//Left arrow
				if (state == PANELSTATE_MAIN_MENU)
					selected_entry &= ~1		//Left side is all evens

			if ("button2")	//Right arrow
				if (state == PANELSTATE_MAIN_MENU)
					selected_entry |= 1			//Right side is all odds.

			if ("button5")	//Down arrow
				if (state == PANELSTATE_MAIN_MENU)
					selected_entry = min(selected_entry + 2, ENTRY_MAX)

			if ("button6")	//Up arrow
				if (state == PANELSTATE_MAIN_MENU)
					selected_entry = max(selected_entry - 2, 0)

			if ("button3")	//Select
				if (state == PANELSTATE_MAIN_MENU)
					state = PANELSTATE_ENTRY_MENU

			if ("button4")	//Back
				if (state != PANELSTATE_MAIN_MENU)
					state = PANELSTATE_MAIN_MENU

			if ("button7")	//Activate
				if (state == PANELSTATE_ENTRY_MENU && selected_entry < device_entries.len)
					var/datum/maintpanel_device_entry/currentEntry = src.device_entries[selected_entry + 1]
					if (!istype(currentEntry))
						return

					currentEntry.activate()


			if ("button8")	//Deactivate
				if (state == PANELSTATE_ENTRY_MENU && selected_entry < device_entries.len)
					var/datum/maintpanel_device_entry/currentEntry = src.device_entries[selected_entry + 1]
					if (!istype(currentEntry))
						return

					currentEntry.deactivate()

		updateDisplay()

		return

	receive_signal(datum/signal/signal, receive_method, receive_param)
		if (signal.data["sender"] in src.sessions)
			var/datum/maintpanel_device_entry/entry = src.sessions[signal.data["sender"]]
			src.sessions -= signal.data["sender"]
			if (istype(entry) && (entry in src.device_entries) && signal.data["lock_status"])

				entry.receive_signal(signal)

				updateDisplay()

		return

	process()
		return

	proc/updateDisplay()
		if (state == PANELSTATE_MAIN_MENU)
			var/list/printList = list(" *       KNOWN  DEVICES       * ","","","","","","","","","","","","")
			var/printedCounter
			for (printedCounter = 0, printedCounter < ENTRY_MAX, printedCounter++)
				var/datum/maintpanel_device_entry/entry
				if (printedCounter < device_entries.len)
					entry = device_entries[printedCounter+1]

				var/nextEntry
				printList[round(printedCounter/2) + 2] += (selected_entry == printedCounter) ? ">" : (istype(entry) && entry.active ? "*" : " ")
				if (!istype(entry))
					printList[round(printedCounter/2) + 2] += "               " //This makes half a display row of spaces.  16 spaces.  2^4 spaces.

					continue

				nextEntry = "[copytext(entry.name, 1, 16)]"

				while (length(nextEntry) < 15)
					nextEntry += " "

				printList[round(printedCounter/2) + 2] += nextEntry


			printToDisplay(printList, 0)

		else if (state == PANELSTATE_ENTRY_MENU)
			if ((selected_entry+1) > device_entries.len)
				state = PANELSTATE_MAIN_MENU
				return

			var/datum/maintpanel_device_entry/entry = device_entries[selected_entry + 1]
			if (!istype(entry))
				state = PANELSTATE_MAIN_MENU
				return

			. = copytext(entry.name, 1, 17)
			while (length(.) < 28)
				. = " [.] "

			var/list/outList = list(" *[.]* ")
			. = entry.getControlMenu()
			if (.)
				outList += .
			else
				outList += "   N / A"

			printToDisplay(outList, 0)

		return

	proc/printToDisplay(var/list/newText, var/add)
		if (!istype(newText))
			return

		if (add)
			for (var/line = 1, line <= 13 && line <= newText.len, line++)
				memory["display_add[line]"] += newText[line]
		else
			for (var/line = 1, line <= 13, line++)
				if (line <= newText.len)
					memory["display[line]"] = newText[line]
				else
					memory["display[line]"] = " "

		if (master)
			master.updateUsrDialog(add ? REASON_ADDTEXT : REASON_UPDATETEXT)

datum/maintpanel_device_entry
	var/name = "GENERIC"
	var/datum/computer/file/embedded_program/maintpanel/master
	var/active = 0
	var/needs_hack = 0

	disposing()
		master = null

		..()

	proc/activate()
		return 0

	proc/deactivate()
		return 0

	proc/toggle()
		if (active)
			return deactivate()
		else
			return activate()

	proc/getControlMenu()
		return "  ACTIVE: [src.active ? "YES" : "NO"]"

	proc/receive_signal(datum/signal/signal)

	airlock
		name = "AIRLOCK"
		var/ourDoorID
		var/open = 0
		var/locked = 0

		New(datum/computer/file/embedded_program/maintpanel/newMaster, obj/machinery/door/airlock/targetDoor, entryName)
			..()

			if (!istype(newMaster) || !istype(targetDoor))
				return

			ourDoorID = targetDoor.net_id
			master = newMaster
			if (entryName)
				src.name = uppertext(entryName)

			locked = targetDoor.locked
			open = !targetDoor.density

			active = open || !locked

		getControlMenu()
			return list("  SEALED: [src.active ? "NO" : "YES"]",\
			"  LOCKED: [src.locked ? "YES" : "NO"]",\
			"  CLASS: AIRLOCK - GENERIC")

		receive_signal(datum/signal/signal)

			open = signal.data["door_status"] == "open"
			locked = signal.data["lock_status"] == "locked"

			active = open || !locked

		activate()
			if (!ourDoorID || !master)
				return 1

			if (active)
				return 0

			var/datum/signal/signal = get_free_signal()
			signal.data["address_1"] = ourDoorID
			signal.data["command"] = "secure_open"

			master.sessions["[ourDoorID]"] = src

			master.post_signal(signal)
			return 0


		deactivate()
			if (!ourDoorID || !master)
				return 1

			if (!active)
				return 0

			var/datum/signal/signal = get_free_signal()
			signal.data["address_1"] = ourDoorID
			signal.data["command"] = "secure_close"

			master.sessions["[ourDoorID]"] = src

			master.post_signal(signal)
			return 0


	podlock
		name = "BLASTDOOR"
		var/obj/machinery/door/poddoor/ourDoor

		New(datum/computer/file/embedded_program/maintpanel/newMaster, obj/machinery/door/poddoor/targetDoor, entryName)
			..()

			if (!istype(newMaster) || !istype(targetDoor))
				return

			//ourDoorID = targetDoor.net_id
			master = newMaster
			if (entryName)
				src.name = uppertext(entryName)

			ourDoor = targetDoor

		getControlMenu()
			if (ourDoor)
				src.active = !ourDoor.density

			return list("  DOOR TYPE: BLAST DOOR","  SEALED: [src.active ? "NO" : "YES"]","  ACTUATOR PRESSURE:","    ACT 1:  OK","    ACT 2:  OK","    ACT 3:  OK")

		activate()
			if (!ourDoor)
				return 1

			if (ourDoor.disposed)
				ourDoor = null
				return 1

			if (ourDoor.open())
				src.active = 1

			return 0

		deactivate()
			if (!ourDoor)
				return 1

			if (ourDoor.disposed)
				ourDoor = null
				return 1

			if (ourDoor.close())
				src.active = 0

			return 0

	mannequin
		name = "ANIMATRONIC"
		var/obj/critter/mannequin/ourMannequin
		var/mannequinName = "GENERIC"

		getControlMenu()
			return list("  ACTOR ID: [mannequinName]",\
			"  ACTIVE: [(ourMannequin && ourMannequin.alive) ? (src.active ? "YES" : "NO") : "NO"]",\
			"  CONDITION: [ourMannequin && ourMannequin.alive ? "OK" : "REPAIRS NEEDED"]")

		New(datum/computer/file/embedded_program/maintpanel/newMaster, obj/critter/mannequin/mannequin, entryName)
			..()

			if (!istype(newMaster) || !istype(mannequin))
				return

			master = newMaster
			src.active = mannequin.does_creepy_stuff
			if (mannequin.typeName)
				src.mannequinName = uppertext(mannequin.typeName)

			ourMannequin = mannequin
			if (entryName)
				src.name = uppertext(entryName)

		activate()
			if (ourMannequin)
				if (ourMannequin.disposed)
					ourMannequin = null
					return 1

				active = 1
				ourMannequin.does_creepy_stuff = 1
				return 0

			return 1

		deactivate()
			if (ourMannequin)
				if (ourMannequin.disposed)
					ourMannequin = null
					return 1

				active = 0
				ourMannequin.does_creepy_stuff = 0

			return 1

	dummy	//This is a fake entry that exists to fill space, not to be confused with the mannequin type.

		New(datum/computer/file/embedded_program/maintpanel/newMaster, entryName)
			..()

			if (istype(newMaster))
				master = newMaster
				if (entryName)
					src.name = uppertext(entryName)

		getControlMenu()
			. = list()
			for (var/n = 0, n < 10, n++)
				var/toAdd = ""
				while (length(toAdd) < 25)
					toAdd += ascii2text( prob(50) ? rand(48, 59) : rand(63, 90) )

				. += toAdd

	dummyreactor

		New(datum/computer/file/embedded_program/maintpanel/newMaster, entryName)
			..()

			if (istype(newMaster))
				master = newMaster
				if (entryName)
					src.name = uppertext(entryName)


		getControlMenu()
			return list("  CLASS MSTAR-80A", "  STATUS:  INACTIVE", "  OUTPUT: 0 W", "", " !! CHECK COOLANT PUMPS !!", " !! TURBINE TRIP !!")

	dummyatmos
		New(datum/computer/file/embedded_program/maintpanel/newMaster, entryName)
			..()

			if (istype(newMaster))
				master = newMaster
				if (entryName)
					src.name = uppertext(entryName)


		getControlMenu()
			return list("  ATMOS PROCESSOR","  STATUS: LOW FUNCTION", "  REFRIGERANT LEVELS LOW","  FILTER 0 STATUS: OK", "  FILTER 1 STATUS: REPLACE", "  FILTER 2 STATUS: REPLACE")

#undef PANELSTATE_MAIN_MENU
#undef PANELSTATE_ENTRY_MENU
#undef REASON_NONE
#undef REASON_ADDTEXT
#undef REASON_CLEARSCREEN
#undef REASON_UPDATETEXT

/obj/item/kitchen/everyflavor_box/wax
	attack_hand(mob/user as mob, unused, flag)
		if (flag)
			return ..()
		if(user.r_hand == src || user.l_hand == src)
			if(src.amount == 0)
				boutput(user, "<span style=\"color:red\">You're out of beans. You feel strangely sad.</span>")
				return
			else
				var/obj/item/reagent_containers/food/snacks/candy/B = new /obj/item/reagent_containers/food/snacks/candy {name = "A Farty Snott's Every Flavour Bean"; desc = "A favorite halloween sweet worldwide!"; icon_state = "bean"; amount = 1; initial_volume = 100;} (user)

				user.put_in_hand_or_drop(B)
				src.amount--

				if (B.reagents)
					B.reagents.clear_reagents()
					B.reagents.add_reagent("wax", 20)

				if(src.amount == 0)
					src.icon_state = "beans_empty"
					src.name = "An empty Farty Snott's bag."
		else
			return ..()
		return

/obj/fake_dwarf_bomb
	name = "historic \"dwarf\" plasma bomb"
	desc = "This is a model of the \"dwarf\" plasma bomb held by the Space IRA in the 2004 Lunar Port Hostage Crisis.  At least, you hope it's a model."
	icon = 'icons/misc/lunar.dmi'
	icon_state = "dwarf_bomb"
	anchored = 0
	density = 1

	var/well_fuck_its_armed = 0

	attackby(obj/item/I, mob/user)
		return attack_hand(user)

	attack_hand(mob/living/user)
		if (!istype(user) || user.stat || (get_dist(src, user) > 1) || well_fuck_its_armed)
			return

		well_fuck_its_armed = 1
		user.visible_message("<b>[user]</b> prods [src].", "You prod at [src].  It's a pretty accurate replica, it seems.  Neat.")
		spawn (10)
			src.visible_message("<span style='color:red'>[src] gives a grumpy beep! <b><font style='font-size:200%;'>OH FUCK</font></b></span>")

			playsound(src.loc, "sound/weapons/armbomb.ogg", 50)

			sleep(30)
			//do tiny baby explosion noise
			//Todo: a squeakier blast sound.
			playsound(src.loc, "sound/effects/Explosion2.ogg", 40, 0, 0, 4)

			new /obj/effects/explosion/tiny_baby (src.loc)
			for (var/mob/living/carbon/unfortunate_jerk in range(1, src))
				if (unfortunate_jerk.stat != 2 && unfortunate_jerk.client)
					shake_camera(unfortunate_jerk, 12, 4)
				unfortunate_jerk.stunned += 4
				unfortunate_jerk.stuttering += 4
				unfortunate_jerk.lying = 1
				unfortunate_jerk.set_clothing_icon_dirty()

			qdel(src)


/obj/effects/explosion/tiny_baby
	New()
		..()
		src.transform = matrix(0.5, MATRIX_SCALE)

//Shelving for the gift shop
/obj/rack/lunar
	name = "shop shelf"
	desc = "A shelf as is used in many stores."
	icon = 'icons/misc/lunar.dmi'
	icon_state = "aisleshelf"

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/wrench))
			return

		return ..()

/obj/item/basketball/lunar
	name = "moon basketball"
	desc = "A basketball that is printed to resemble the moon."
	icon = 'icons/misc/lunar.dmi'
	icon_state = "bball"
	item_state = "bbmoon"