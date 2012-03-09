dbDefaults = {
	profile = {
	--general
		all = false,
		arena = true,
		battleground = true,
		field = true,
		myself = true,
		sapath = SA_LOCALEPATH[GetLocale()] or "Interface\\Addons\\SoundAlerter\\voice\\",
		debugmode = false,
		trinket = true,
		drinking = true,
		class = true,
		mouseover = false,	
	--disables
		aruaApplied = false,
		aruaRemoved = false,
		castStart = false,
		castSuccess = false,
		interrupt = false,
	--spells
		sapenemy = true,
		ArenaPartner = false,
		enemyinrange = false,
		lockout = true,
		sayspell = false,
	--chat
		bubblealert = true,
		bubblealerttext = "Bubbled!",
		stealthalert = true,
		vanishalert = true,
		trinketalert = true,
		interruptalert = true,
		sapalert = true,
		blindonenemychat = true,
		blindonselfchat = true,
	--chat channel	
		party = false,
		say = false,
		clientonly = true,
		bgchat = false,
	--chat text
		InterruptText = "INTERRUPTED:",
		spelltext = "Casted", 
		saptext = "I'm Sapped!",
		saptextfriend = "Is Sapped!",

	}
}