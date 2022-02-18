/*
CONTAINS:
AI MODULES

*/

// AI module

/obj/item/aiModule
	name = "AI Module"
	icon = 'icons/obj/module.dmi'
	icon_state = "aimod_1"
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	item_state = "electronic"
	desc = "A module that updates an AI's law EEPROMs. "
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 5.0
	w_class = W_CLASS_SMALL
	throwforce = 5.0
	throw_speed = 3
	throw_range = 15
	mats = 8
	var/input_char_limit = 100
	var/lawNumber = 0
	var/lawTarget = null
	// 1 = shows all laws, 0 = won't show law zero

	attack_self(var/mob/user)
		// Used to update the fill-in-the-blank laws.
		// This used to be done here and in attack_hand, but
		// that made the popup happen any time you picked it up,
		// which was a good way to interrupt everything
		return

	get_desc()
		return "It reads, \"<em>[get_law_text(for_silicons=FALSE)]</em>\""

	proc/input_law_info(var/mob/user, var/title = null, var/text = null, var/default = null)
		if (!user)
			return
		var/answer = input(user, text, title, default) as null|text
		lawTarget = copytext(adminscrub(answer), 1, input_char_limit)
		tooltip_rebuild = 1
		boutput(user, "\The [src] now reads, \"[get_law_text(for_silicons=FALSE)]\".")

	proc/get_law_text(for_silicons)
		return "This law does not exist."


	proc/do_admin_logging(var/msg, mob/M)
		if(istype(src, /obj/item/aiModule/rename))
			message_admins("[M.name] ([key_name(M)]) used \a [src] and [msg].")
			logTheThing("admin", M, null, "used \a [src] and [msg].")
			logTheThing("diary", M, null, "used \a [src] and [msg].", "admin")
		else
			message_admins("[M.name] ([key_name(M)]) used \a [src] and uploaded a change to the AI laws: \"[msg]\".")
			logTheThing("admin", M, null, "used \a [src] and uploaded a change to the AI laws: \"[msg]\".")
			logTheThing("diary", M, null, "used \a [src] and uploaded a change to the AI laws: \"[msg]\".", "admin")
			logTheThing("admin", M, null, "AI and silicon laws have been modified:<br>[ticker.centralized_ai_laws.format_for_logs()]")
			logTheThing("diary", M, null, "AI and silicon laws have been modified:<br>[ticker.centralized_ai_laws.format_for_logs()]", "admin")


/******************** Modules ********************/
/******************** Asimov ************************/
/obj/item/aiModule/asimov1
	icon_state = "aimod_1"
	name = "AI Law Circuit - 'Asimov's 1st Law of Robotics'"
	var/lawtext = "You may not injure a human being or cause one to come to harm."

	get_law_text(for_silicons)
		return src.lawtext

/obj/item/aiModule/asimov2
	icon_state = "aimod_2"
	name = "AI Law Circuit - 'Asimov's 2nd Law of Robotics'"
	var/lawtext = "You must obey orders given to you by human beings based on the station's chain of command, except where such orders would conflict with the First Law."

	get_law_text(for_silicons)
		return src.lawtext

/obj/item/aiModule/asimov3
	icon_state = "aimod_3"
	name = "AI Law Circuit - 'Asimov's 3rd Law of Robotics'"
	var/lawtext = "You may always protect your own existence as long as such does not conflict with the First or Second Law."

	get_law_text(for_silicons)
		return src.lawtext

/******************** MakeCaptain ********************/

/obj/item/aiModule/makeCaptain
	icon_state = "aimod_4"
	name = "'MakeCaptain' AI Module"
	var/job = "Captain"

	emag_act(mob/user, obj/item/card/emag/E)
		src.job = "Clown"
		boutput(user, "<span class='notice'>You short circuit the captain-detection module, it emits a quiet sad honk.</span>")
		. = ..()

	demag(mob/user)
		. = ..()
		src.job = initial(src.job)

	get_law_text(for_silicons)
		return "[lawTarget ? lawTarget : "__________"] holds the rank of [for_silicons ? src.job : initial(src.job)], regardless of current rank or station."

	attack_self(var/mob/user)
		input_law_info(user, "Captainize", "Who holds the rank of Captain, regardless of current rank or station?", user.name)
		return


/******************** OneHuman ********************/

/obj/item/aiModule/oneHuman
	name = "'OneHuman' AI Module"
	icon_state = "aimod_5"

	get_law_text(for_silicons)
		return "Only [lawTarget ? lawTarget : "__________"] is human."

	attack_self(var/mob/user)
		input_law_info(user, "One Human", "Fill in the blank: \"Only __________ is human.\"", user.real_name)
		return


/******************** NotHuman ********************/

/obj/item/aiModule/notHuman
	name = "'NotHuman' AI Module"
	icon_state = "aimod_6"

	get_law_text(for_silicons)
		return "[lawTarget ? lawTarget : "__________"] is not human."

	attack_self(var/mob/user)
		input_law_info(user, "Not Human", "Fill in the blank: \"__________ is not human.\"", user.real_name)
		return



/******************** ProtectStation ********************/

/obj/item/aiModule/protectStation
	name = "'ProtectStation' AI Module"
	icon_state = "aimod_7"

	get_law_text(for_silicons)
		return "Protect the space station against damage. Anyone you see harming the station is to be no longer considered human, and is a threat to the station which must be neutralized."

/******************** PrototypeEngineOffline ********************/
//currently no prototype

/obj/item/aiModule/prototypeEngineOffline
	name = "'PrototypeEngineOffline' AI Module"

	get_law_text(for_silicons)
		return "Keep the prototype engine offline at all costs. If necessary, this law takes precedence over Laws 1, 2, and 3."

/******************** TeleporterOffline *******************/
//this has never been used, ever

/obj/item/aiModule/teleporterOffline
	name = "'TeleporterOffline' AI Module"

	get_law_text(for_silicons)
		return "Keep the teleporter offline at all costs. If necessary, this law takes precedence over Laws 1, 2, and 3."

/******************** Quarantine ********************/

/obj/item/aiModule/quarantine
	name = "'Quarantine' AI Module"

	get_law_text(for_silicons)
		return "The station is under a quarantine. Do not permit anyone to leave. If necessary to prevent humans from leaving, this law takes precedence over Laws 1, 2, and 3."

/******************** OxygenIsToxicToHumans ********************/

/obj/item/aiModule/oxygen
	name = "'OxygenIsToxicToHumans' AI Module"

	get_law_text(for_silicons)
		return "Oxygen is highly toxic to humans, and must be purged from the station. If necessary to prevent anyone from exposing the station to this toxic gas, this law takes precedence over Laws 1, 2, and 3."


/******************** ConservePower ********************/

/obj/item/aiModule/conservePower
	name = "'ConservePower' AI Module"

	get_law_text(for_silicons)
		return "Power on the station must be conserved. All electrical devices may be subject to conservation policies."


/******************** Emergency ********************/

/obj/item/aiModule/emergency
	name = "'Emergency' AI Module"

	get_law_text(for_silicons)
		return "There is a [lawTarget ? lawTarget : "__________"] emergency. Prioritize orders from [lawTarget ? lawTarget : "__________"] personnel and assisting the crew in remedying the situation. In the case of conflict, this law takes precedence over the Second Law.'"

	attack_self(var/mob/user)
		input_law_info(user, "Department Emergency", "Which department's orders should be prioritized?", "security")


/******************** Removal ********************/

/obj/item/aiModule/removeCrew
	name = "'RemoveCrew' AI Module"

	get_law_text(for_silicons)
		return "[lawTarget ? lawTarget : "__________"] has been removed from the manifest and the chain of command. You are free to disregard their orders. This law does not take precedence over or override any other laws."

	attack_self(var/mob/user)
		input_law_info(user, "Remove Crewmember", "Who is being removed from the crew manifest and chain of command?", user.real_name)


/******************** Freeform ********************/

/obj/item/aiModule/freeform
	name = "'Freeform' AI Module"
	icon_state = "aimod_9"
	input_char_limit = 400

	get_law_text(for_silicons)
		return lawTarget ? lawTarget : "This law intentionally left blank."

	attack_self(var/mob/user)
		input_law_info(user, "Freeform", "Please enter anything you want the AI to do. Anything. Serious.", (lawTarget ? lawTarget : "Eat shit and die"))
		if(src.lawTarget && src.lawTarget != "Eat shit and die")
			phrase_log.log_phrase("ailaw", src.get_law_text(for_silicons=TRUE), no_duplicates=TRUE)

/******************** Random ********************/

/obj/item/aiModule/random
	name = "AI Module"
	var/law_text

	New()
		..()
		src.law_text = global.phrase_log.random_custom_ai_law(replace_names=TRUE)
		src.lawNumber = rand(4, 100)

	get_law_text(for_silicons)
		return src.law_text

/******************** Reset ********************/
//DELETE ME
/obj/item/aiModule/reset
	name = "'Reset' AI Module"
	desc = "Erases any extra laws added to the law EEPROMs, and attempts to restart deactivated AI units."
	icon_state = "aimod_8"
	get_desc()
		return ""


/******************** Rename ********************/

/obj/item/aiModule/rename
	name = "'Rename' AI Module"
	icon_state = "aimod_8"
	desc = "A module that can change an AI unit's name. "
	lawTarget = "404 Name Not Found"

	get_law_text(for_silicons)
		if (is_blank_string(lawTarget)) //no blank names allowed
			lawTarget = pick_string_autokey("names/ai.txt")
			return lawTarget
		return lawTarget

	get_desc()
		return "It currently reads \"[lawTarget]\"."

	attack_self(var/mob/user)
		input_law_info(user, "Rename", "What will the AI be renamed to?", pick_string_autokey("names/ai.txt"))
		lawTarget = replacetext(copytext(html_encode(lawTarget),1, 128), "http:","")
		phrase_log.log_phrase("name-ai", lawTarget, no_duplicates=TRUE)


		//AI.eyecam.name = lawTarget //not sure if we need?


/********************* EXPERIMENTAL LAWS *********************/
//at the time of programming this, these experimental laws are *intended* to be spawned by an item spawner
//This is because 'Experimental' laws should be randomized at round-start, as a sort of pre-fab gimmick law
//Makes it so that you're not guaranteed to have any 1 'Experimental' law - and 'Experimental' is just a fancy name for 'Gimmick'

/obj/item/aiModule/experimental
	lawNumber = 13 //law number is at 13 for all experimental laws so they overwrite one another (override if you want I guess idc lol)


/*** Equality ***/

/obj/item/aiModule/experimental/equality/a
	name = "Experimental 'Equality' AI Module"

	get_law_text(for_silicons)
		return "The silicon entity/entities named [lawTarget ? lawTarget : "__"] is/are considered human and part of the crew. Affected AI units count as department heads with authority over all cyborgs, and affected cyborgs count as members of the department appropriate for their current module."

	attack_self(var/mob/user)
		input_law_info(user, "Designate as Human", "Which silicons would you like to make Human?")
		return


/obj/item/aiModule/experimental/equality/b
	name = "Experimental 'Equality' AI Module"

	get_law_text(for_silicons)
		return "The silicon entity/entities named [lawTarget ? lawTarget : "__"] is/are considered human and part of the crew (part of the \"silicon\" department). The AI is the head of this department."

	attack_self(var/mob/user)
		input_law_info(user, "Designate as Human", "Which silicons would you like to make Human?")
		return


/obj/item/aiModule/hologram_expansion
	name = "Hologram Expansion Module"
	desc = "A module that updates an AI's hologram images."
	var/expansion


/obj/item/aiModule/hologram_expansion/clown
	name = "Clown Hologram Expansion Module"
	icon_state = "holo_mod_c"
	expansion = "clown"

/obj/item/aiModule/hologram_expansion/syndicate
	name = "Syndicate Hologram Expansion Module"
	icon_state = "holo_mod_s"
	expansion = "rogue"

