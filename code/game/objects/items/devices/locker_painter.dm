/obj/item/device/closet_painter
	name = "closet painter"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler1"
	item_state = "flight"

	var/colour =        "plain"
	var/colour_secure = "plain"

	var/list/colours = list(
		"plain" = 				list("open" = "open", "closed" = "closed"),
		"blue" = 				list("open" = "open", "closed" = "blue"),
		"mixed" = 				list("open" = "open", "closed" = "mixed"),
		"grey" = 				list("open" = "open", "closed" = "grey"),
		"green" = 				list("open" = "open", "closed" = "green"),
		"orange" = 				list("open" = "open", "closed" = "orange"),
		"pink" = 				list("open" = "open", "closed" = "pink"),
		"red" = 				list("open" = "open", "closed" = "red"),
		"white" = 				list("open" = "open", "closed" = "white"),
		"yellow" = 				list("open" = "open", "closed" = "yellow"),
		"black" = 				list("open" = "open", "closed" = "black"),
		"bio" = 				list("open" = "bioopen", "closed" = "bio"),
		"bio-virology" = 		list("open" = "bio_virologyopen", "closed" = "bio_virology"),
		"bio-security" = 		list("open" = "bio_securityopen", "closed" = "bio_security"),
		"bio-janitor" = 		list("open" = "bio_janitoropen", "closed" = "bio_janitor"),
		"bio-scientist" = 		list("open" = "bio_scientistopen", "closed" = "bio_scientist"),
		"bombsuit" = 			list("open" = "bombsuitopen", "closed" = "bombsuit"),
		"bombsuit-security" = 	list("open" = "bombsuitsecopen", "closed" = "bombsuitsec"),
		"full-red" = 			list("open" = "syndicateopen", "closed" = "syndicate"),
		"full-green" = 			list("open" = "syndicate1open", "closed" = "syndicate1"),
		"full-purple" = 		list("open" = "aclosetopen", "closed" = "acloset"),
		"mining" = 				list("open" = "miningopen", "closed" = "mining"),
		"emergency" = 			list("open" = "emergencyopen", "closed" = "emergency"),
		"fire" = 				list("open" = "fireclosetopen", "closed" = "firecloset"),
		"tool" = 				list("open" = "toolclosetopen", "closed" = "toolcloset"),
		"radiation" = 			list("open" = "toolclosetopen", "closed" = "radsuitcloset")
		)

	var/list/colours_secure = list(
		"plain" = 			list("open" = "open", "closed" = "secure", "broken" = "securebroken"),
		"medical-red" = 	list("open" = "medicalopen", "closed" = "medical", "broken" = "medicalbroken"),
		"medical-green" = 	list("open" = "securemedopen", "closed" = "securemed", "broken" = "securemedbroken"),
		"CMO" = 			list("open" = "cmosecureopen", "closed" = "cmosecure", "broken" = "cmosecurebroken"),
		"cargo" = 			list("open" = "securecargoopen", "closed" = "securecargo", "broken" = "securecargobroken"),
		"mining" = 			list("open" = "miningsecopen", "closed" = "miningsec", "broken" = "miningsecbroken"),
		"QM" = 				list("open" = "secureqmopen", "closed" = "secureqm", "broken" = "secureqmbroken"),
		"hydroponics" = 	list("open" = "hydrosecureopen", "closed" = "hydrosecure", "broken" = "hydrosecurebroken"),
		"atmospherics" = 	list("open" = "secureatmopen", "closed" = "secureatm", "broken" = "secureatmbroken"),
		"engineer" = 		list("open" = "secureengopen", "closed" = "secureeng", "broken" = "secureengbroken"),
		"CE" = 				list("open" = "secureceopen", "closed" = "securece", "broken" = "securecebroken"),
		"electrical" = 		list("open" = "toolclosetopen", "closed" = "secureengelec", "broken" = "secureengelecbroken"),
		"welding" = 		list("open" = "toolclosetopen", "closed" = "secureengweld", "broken" = "secureengweldbroken"),
		"research" = 		list("open" = "secureresopen", "closed" = "secureres", "broken" = "secureresbroken"),
		"RD" = 				list("open" = "rdsecureopen", "closed" = "rdsecure", "broken" = "rdsecurebroken"),
		"security" = 		list("open" = "secopen", "closed" = "sec", "broken" = "secbroken"),
		"warden" = 			list("open" = "wardensecureopen", "closed" = "wardensecure", "broken" = "wardensecurebroken"),
		"HoS" = 			list("open" = "hossecureopen", "closed" = "hossecure", "broken" = "hossecurebroken"),
		"HoP" = 			list("open" = "hopsecureopen", "closed" = "hopsecure", "broken" = "hopsecurebroken"),
		"Captain" = 		list("open" = "capsecureopen", "closed" = "capsecure", "broken" = "capsecurebroken")
		)/obj/item/device/closet_painter/afterattack(atom/A, var/mob/user, proximity)
	if(!proximity)
		return

	if(!istype(A,/obj/structure/closet))
		user << "<span class='warning'>\The [src] can only be used on closets.</span>"
		return

	var/config_error

	if(istype(A,/obj/structure/closet/secure_closet))
		var/obj/structure/closet/secure_closet/F = A
		if(F.broken)
			user << "<span class='warning'>\The [src] cannot paint broken closets.</span>"
			return

		var/list/colour_data = colours_secure[colour_secure]
		if(!islist(colour_data))
			config_error = 1
		if(!config_error)
			F.icon_opened = colour_data["open"]
			F.icon_closed = colour_data["closed"]
			F.icon_locked = colour_data["locked"]
			F.icon_broken = colour_data["broken"]
			F.icon_off = colour_data["off"]
			F.update_icon()

	else
		var/obj/structure/closet/F = A
		var/list/colour_data = colours[colour]
		if(!islist(colour_data))
			config_error = 1
		if(!config_error)
			F.icon_opened = colour_data["open"]
			F.icon_closed = colour_data["closed"]
			F.update_icon()

	if(config_error)
		user << "<span class='warning'>\The [src] flashes an error light. You might need to reconfigure it.</span>"
		return

/obj/item/device/closet_painter/attack_self(var/mob/user)
	var/choice = input("Do you wish to change the regular closet colour or the secure closet colour?")\
								as null|anything in list("Regular Closet Colour","Secure Closet Colour")
	if(choice == "Regular Closet Colour")
		choose_colour()
	else if(choice == "Secure Closet Colour")
		choose_colour_secure()

/obj/item/device/closet_painter/examine(mob/user)
	..(user)
	user << "It is configured to produce the '[colour]' paint scheme or the '[colour_secure]' secure closet paint scheme."

/obj/item/device/closet_painter/verb/choose_colour()
	set name = "Choose Colour"
	set desc = "Choose a regular closet painter colour."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return

	var/new_colour = input("Select a colour.") as null|anything in colours
	if(new_colour && !isnull(colours[new_colour]))
		colour = new_colour
		usr << "<span class='notice'>You set \the [src] regular closet colour to '[colour]'.</span>"

/obj/item/device/closet_painter/verb/choose_colour_secure()
	set name = "Choose Secure Colour"
	set desc = "Choose a secure closet painter colour."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return

	var/new_colour_secure = input("Select a colour.") as null|anything in colours_secure
	if(new_colour_secure && !isnull(colours_secure[new_colour_secure]))
		colour_secure = new_colour_secure
		usr << "<span class='notice'>You set \the [src] secure closet colour to '[colour_secure]'.</span>"