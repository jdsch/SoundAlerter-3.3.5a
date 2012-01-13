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
		sayspell = true,
		lockout = false,
	--chat
		bubblealert = true,
		bubblealerttext = "Bubbled!",
		stealthalert = true,
		vanishalert = true,
		trinketalert = false,
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