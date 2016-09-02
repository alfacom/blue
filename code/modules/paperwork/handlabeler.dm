/obj/item/weapon/hand_labeler
	name = "hand labeler"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	item_state = "flight"
	var/label = null
	var/labels_left = 30
	var/mode = 0	//off or on.

/obj/item/weapon/hand_labeler/attack()
	return

/atom
	var/pasted_label = null

/obj/item/weapon/hand_labeler/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(mode)	//if it's off, give up.
		if(A == loc)	// if placing the labeller into something (e.g. backpack)
			return		// don't set a label

		if(!labels_left)
			user << "<span class='notice'>No labels left.</span>"
			return
		if(!label || !length(label))
			user << "<span class='notice'>No text set.</span>"
			return
		if(length(A.name) + length(label) > 64)
			user << "<span class='notice'>Label too big.</span>"
			return
		if(ishuman(A))
			user << "<span class='notice'>The label refuses to stick to [A.name].</span>"
			return
		if(issilicon(A))
			user << "<span class='notice'>The label refuses to stick to [A.name].</span>"
			return
		if(isobserver(A))
			user << "<span class='notice'>[src] passes through [A.name].</span>"
			return
		if(istype(A, /obj/item/weapon/reagent_containers/glass))
			user << "<span class='notice'>The label can't stick to the [A.name].  (Try using a pen)</span>"
			return
		if(A.pasted_label)
			user << "\red [A] already have a label."
			return
		if(istype(A, /obj/machinery/portable_atmospherics/hydroponics))
			var/obj/machinery/portable_atmospherics/hydroponics/tray = A
			if(!tray.mechanical)
				user << "<span class='notice'>How are you going to label that?</span>"
				return
			tray.labelled = label
			spawn(1)
				tray.update_icon()

		user.visible_message("<span class='notice'>[user] labels [A] as [label].</span>", \
							 "<span class='notice'>You label [A] as [label].</span>")

		A.pasted_label = " ([label])"
		A.name = "[A.name] ([label])"
	else
		if(A.pasted_label)
			user.visible_message("<span class='notice'>[user] starts to scrap away label from [A].</span>", \
							 "<span class='notice'>You start to scrap away label from [A].</span>")
			if(do_after(user,100,A,1,1))
				if(prob(75))
					if(prob(99))
						var/fibertext = copytext(A.pasted_label,3,-1)
						var/scrambled_fibertext = ""
						for(var/i=1;i<=length(fibertext);i+=1)
							if(prob(5))
								scrambled_fibertext += copytext(fibertext,i,i+1)
							else
								scrambled_fibertext += "*"
						A.suit_fibers += "Traces of scraped label \"[scrambled_fibertext]\"."
					A.name = replacetext(A.name,A.pasted_label,"",1,0)
					user.visible_message("<span class='notice'>[user] succesfully scraped label from [A].</span>", \
							 "<span class='notice'>You succesfully scraped label from [A].</span>")
					A.pasted_label = null
				else
					user.visible_message("<span class='warning'>[user] fails to scrap away label from [A].</span>", \
							 "<span class='warning'>You failed to scrap away label from [A].</span>")
			A.add_fingerprint(user)

/obj/item/weapon/hand_labeler/attack_self(mob/user as mob)
	mode = !mode
	icon_state = "labeler[mode]"
	if(mode)
		user << "<span class='notice'>You turn on \the [src].</span>"
		//Now let them chose the text.
		var/str = sanitizeSafe(input(user,"Label text?","Set label",""), MAX_NAME_LEN)
		if(!str || !length(str))
			user << "<span class='notice'>Invalid text.</span>"
			return
		label = str
		user << "<span class='notice'>You set the text to '[str]'.</span>"
	else
		user << "<span class='notice'>You turn off \the [src].</span>"