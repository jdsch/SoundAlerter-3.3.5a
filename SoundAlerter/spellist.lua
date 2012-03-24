--[[SoundAlerter for 3.3.5a by Trolollolol - Sargeras - Molten-WoW.com
				Credits to Abatorlos of Spinebreaker, Duskashes, Superk
								Notes: Check spell IDs by rank first
								add death wish down, starfire, bladestorm down]]
function SoundAlerter:GetSpellList () 
	return {
		auraApplied = {					-- aura applied [spellid] = ".mp3 file name",
			--Races
			[58984] = "Shadowmeld",
			[26297] = "berserking", --works
			[20594] = "stoneform",
			[20572] = "BloodFury", --works
			[33702] = "BloodFury", --works
			[7744] = "willoftheforsaken",
			[28880] = "giftofthenaaru",
			--Druid
			[61336] = "survivalInstincts",
			[29166] = "innervate",  --works
			[22812] = "barkskin",  --works
			[17116] = "naturesSwiftness", 
			[53312] = "naturesGrasp", --works
			[22842] = "frenziedRegeneration", 
			[53201] = "starfall",
			[50334] = "berserk", --works
			[1850] = "dash",
			--Paladin
			[31821] = "auraMastery", --works
			[10278] = "handOfProtection", --works
			[1044] = "handOfFreedom", --works
			[642] = "divineShield", --works
			[6940] = "handofsacrifice", --don't know
			[64205] = "divineSacrifice", --works
			[54428] = "divinePlea",		--works
			--Rogue
			[11305] = "sprint", --test2983
			[51713] = "shadowDance", --works
			[31224] = "cloakOfShadows", --works
			[13750] = "adrenalineRush",
			[26669] = "evasion", --works
			[14177] = "coldBlood",
			--Warrior
			[55694] = "EnragedRegeneration", --works
			[1719] = "Recklessness",
			[871] = "shieldWall", --works
			[12975] = "lastStand", --don't know
			[18499] = "berserkerRage", --works
			[20230] = "Retaliation", --works
			[23920] = "spellReflection", --works
			[12328] = "sweepingStrikes", --works
			[46924] = "bladestorm", --works
			[12292] = "deathWish", --dont know
			--Priest
			[33206] = "painSuppression", --works
			[10060] = "powerInfusion", --works
			[6346] = "fearWard", --works
			[47585] = "dispersion", --works
			[14751] = "innerfocus",
			[47788] = "GuardianSpirit",
			--Shaman
			[30823] = "shamanisticRage", --works
			[974] = "earthShield", --works
			[16188] = "naturesSwiftness2", --works
			[57960] = "waterShield", --works
			[16166] = "ElementalMastery", --works
			--Mage
			[45438] = "iceBlock",
			[12042] = "arcanePower",
			[12472] = "icyveins",
			[12043] = "PresenceofMind",
			[28682] = "combustion",
			--DK
			[49039] = "lichborne",
			[48792] = "iceboundFortitude",
			[55233] = "vampiricBlood",
			[48707] = "antimagicshell",
			[49222] = "boneshield",	--works
			[49016] = "hysteria",
			--Hunter
			[34471] = "theBeastWithin",
			[19263] = "deterrence",	
			--Warlock
			[17941] = "shadowtrance",
		},
		auraRemoved = {
			--Warrior
			[46924] = "bladestormdown", --works
			[1719] = "RecklessnessDown",
			[871] = "shieldWallDown", --works
			[12292] = "deathWishdown", --dont know
			--Paladin
			[10278] = "protectionDown",
			[642] = "bubbleDown",
			--Rogue
			[31224] = "cloakDown",
			[26669] = "evasionDown", --works 
			--Priest
			[33206] = "PSDown", --works
			[47585] = "dispersionDown", --works
			--Mage
			[45438] = "iceBlockDown",
			--DK
			[48792] = "iceboundFortitudeDown",
			[49039] = "lichborneDown",
			--Druid
			[53201] = "Starfalldown",
			--Hunter
			[19263] = "Deterrencedown",
			[34471] = "beastwithindown",
		},
		castStart = {
			--general
			[48782] = "bigHeal",
			[2060] = "bigHeal",
			[635] = "bigHeal",
			[49273] = "bigHeal",
			[5185] = "bigHeal",
			[25391] = "bigHeal", --healing wave rank 11
			[2006] = "resurrection",
			[7328] = "resurrection",
			[2008] = "resurrection",
			[50769] = "resurrection", 
			--druid
			[2637] = "hibernate", 
			[33786] = "cyclone",  --works
			[48465] = "starfire", --rank 10
			--paladin
			--rogue
			--warrior
			--priest		
			[8129] = "manaBurn", 
			[9484] = "shackleUndead",
			[64843] = "divineHymn",
			[605] = "mindControl",
			--shaman
			[51514] = "hex", --works
			[60043] = "lavaburst",
			--mage
			[118] = "polymorph", --Can be poly:turtle, cat, sheep, etc
			[12826] = "polymorph",
			[28272] = "polymorph",
			[61305] = "polymorph",
			[61721] = "polymorph",
			[61025] = "polymorph",
			[61780] = "polymorph",
			[28271] = "polymorph", 
			--Hunter
			[982] = "revivePet", 
			[14327] = "scareBeast",
			--Warlock
			[6215] = "fear", --works
			--[5484] = "fear2", -- Howl of Terror
			[17928] = "fear2", --Howl of Terror
			[710] = "banish",
			[688] = "summonpet", --works
			[691] = "summonpet", --works
			[712] =  "summonpet", --works
			[697] = "summonpet", --works
			[30146] = "summonpet", --felguard, works
		},
		castSuccess = { --Used for abilities that affect the player
			--mage
			[12051] = "evocation",
			[11958] = "coldSnap",
			[44572] = "deepFreeze",
			[44445] = "hotStreak", --double check spell ID
			[2139] = "counterspell",
			[66] = "invisibility",
			--DK
			[47528] = "mindFreeze",
			[47476] = "strangulate",
			[47568] = "runeWeapon",
			[49206] = "gargoyle",
			[49203] = "hungeringCold",
			[61606] = "markofblood",
			--hunter
			[23989] = "readiness", 
			[19386] = "wyvernSting", 
			[49010] = "wyvernSting", 
			[34490] = "silencingshot",
			[49050] = "aimedshot", --rank9
			[19434] = "aimedshot", --rank1
			[60192] = "freezingtrap", --double check
			[14309] = "freezingtrap", --freezing trap effect
			[13810] = "frosttrap", --frost trap aura
			[13809] = "frosttrap", --frost trap aura
			[14311] = "freezingtrap",
			[1499] = "frosttrap",
			--warlock
			[17928] = "fear2", --Howl of Terror
			[19647] = "spellLock",
			[48020] = "demonicCircleTeleport",
			--[6789] = "deathcoil",-- old
			[47860] = "deathcoil",-- works
			--paladin
			[20066] = "repentance", --works
			[10308] = "hammerofjustice", --works
			[31884] = "avengingWrath", --works
			--rogue
			[51722] = "disarm2", --dismantle, works
			[51724] = "sap", --works
			[2094] = "blind", --works
			[1766] = "kick", --works
			[14185] = "preparation", --works
			[26889] = "vanish", --works
			[13877] = "bladeflurry", --works
			[1784] = "stealth",	--works
			--shaman
			[8143] = "tremorTotem", --works
			[65992] = "tremorTotem", --dont know which one
			[16190] = "manaTide",
			[2484] = "earthbind", --works
			[8177] = "grounding", --works
			--warrior
			[2457] = "battlestance",
			[71] = "defensestance",
			[2458] = "berserkerstance",
			[676] = "disarm", --works
			[5246] = "fear3", --intimidating shout, works
			[6552] = "pummel", --works
			[72] = "shieldBash", --works
			--priest
			[10890] = "fear4", -- Psychic Scream
			[34433] = "shadowFiend", -- works
			[64044] = "disarm3", --psychic horror, works
			[48173] = "desperatePrayer", --works
		},
		enemyDebuffs = {
			[2094] = "blind", --works
			[51724] = "sap", --works
			[12826] = "EnemyPollied",
			[118] = "EnemyPollied",
			[33786] = "EnemyCycloned",--menu
			[51514] = "EnemyHexxed",
		},
		enemyDebuffdown = {
			[2094] = "blinddown", --works
			[51724] = "sapdown", --works
			[118] = "polydown",
			[12826] = "polydown",
			[33786] = "CycloneDown", --menu
			[51514] = "hexdown", 
		},
		friendlyInterrupt = {			
			[50613] = "lockout", --arcane torrent
			[1766] = "lockout",
			[57994] = "lockout", --wind shear
			[72] = "lockout", --shield bash
			[47528] = "lockout", 
			[2139] = "lockout",
		},
		interruptFriend = {
			[2139] = "friendcountered", 
			[50613] = "friendcountered",
			[1766] = "friendcountered",
			[57994] = "friendcountered",
			[72] = "friendcountered", 
			[47528] = "friendcountered", 
		},
		friendCCs = {
			[33786] = "cyclonefriend",
			[51514] = "hexfriend", 
			[12826] = "polyfriend",
			[118] = "polyfriend",
			[28272] = "polyfriend",
			[61305] = "polyfriend", 
			[61721] = "polyfriend", 
			[61025] = "polyfriend", 
			[61780] = "polyfriend", 
			[28271] = "polyfriend", 
			[6215] = "fearfriend",
		},
		friendCCSuccess = {
			[14309] = "friendfrozen",
			[2094] = "blindfriend",
			[5246] = "friendfeared", --intimidating shout
			[51724] = "friendsapped",
			[33786] = "friendcycloned",
			[10308] = "friendstunned",
			[2139] = "friendcountered", 
			[51514] = "friendhexxed", 
			[118] = "friendpollied",
			[12826] = "friendpollied",
			[6215] = "friendfeared",
			[10890] = "friendfeared",
			[17928] = "friendfeared",
		},
		friendCCenemy = {
			[2094] = "enemyblinded",
			[51724] = "enemysapped",
			[51514] = "EnemyHexxed",
			[12826] = "EnemyPollied",
			[118] = "EnemyPollied",
			[33786] = "EnemyCycloned",--menu
		},
		friendCCenemyDown = {
			[2094] = "blinddown", 
			[51724] = "sapdown", 
			[51514] = "hexdown", 
			[12826] = "polydown", 
			[118] = "polydown",
			[33786] = "CycloneDown", --menu
		},
	}
end
--args = listOptions({58984,26297,20594,20572,7744,28880},"auraApplied"),


--PlaySoundFile(""..sadb.sapath..list[spellID]..".mp3");