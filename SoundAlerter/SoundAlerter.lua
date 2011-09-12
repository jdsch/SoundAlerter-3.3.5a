SoundAlerter = LibStub("AceAddon-3.0"):NewAddon("SoundAlerter", "AceEvent-3.0","AceConsole-3.0","AceTimer-3.0")

local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local self , SoundAlerter = SoundAlerter , SoundAlerter
local SOUNDALERTER_TEXT="SoundAlerter"
local SOUNDALERTER_VERSION= " r335.01"
local SOUNDALERTER_AUTHOR=" updated by Trololol"
local SOUNDALERTERdb
local PlaySoundFile = PlaySoundFile
local dbDefaults = {
	profile = {
		all = false,
		arena = true,
		battleground = true,
		field = true,

		auraApplied = false,
		auraRemoved = false,
		castStart = false,
		castSuccess = false,
		interrupt = false,

		onlyTarget = false,
		class = false,
		shadowmeld = true,
		trinket = true,
--Druid
		thorns = true,
		survivalInstincts = true,
		innervate = true,
		barkskin = true,
		naturesSwiftness = true,
		naturesGrasp = true,
		frenziedRegeneration = true,
		enrage = false,
		desh = false,
--Paladin
		auraMastery = true,
		handOfProtection = true,
		handOfFreedom = true,
		divineShield = true,
		sacrifice = true,
		divineGuardian = true,
		divinePlea = true,
--Rogue
		shadowDance = true,
		sprint = true,
		cloakOfShadows = true,
		adrenalineRush = true,
		evasion = true,
		CheatDeath = true,
		vanish = true,
--Death Knight
		deathWish = true,
		enragedRegeneration = true,
		shieldWall = true,
		berserkerRage = true,
		retaliation = true,
		spellReflection = true,
		sweepingStrikes = true,
		bladestorm = true,
--Priest
		painSuppression = true,
		powerInfusion = true,
		fearWard = true,
		dispersion = true,

		waterShield = false,
		shamanisticRage = true,
		earthShield = true,
		naturesSwiftness2 = true,
		ElementalMastery = true,
--Mage
		iceBlock = true,
		arcanePower = true,
		invisibility = true,
--Death Knight
		iceboundFortitude = true,
		lichborne = true,
		vampiricBlood = true,
		antimagicshell = true,
--Hunter
		theBeastWithin = true,
		deterrence = true,
		readiness = true,

--SPELL_AURA_REMOVED
		protectionDown = true,
		bubbleDown = true,
		cloakDown = true,
		evasionDown = true,
		PSDown = true,
		dispersionDown = true,
		iceBlockDown = true,
		lichborneDown = false,
		iceboundFortitudeDown = false,

		onlySelf = false,
--General Heals
		bigHeal = true,
		resurrection = true,
--Druid
		hibernate = true,
		cyclone = true,
--Priest
		manaBurn = true,
		shackleUndead = true,
		mindControl = true,
--Shaman
		hex = true,
--Mage
		polymorph = true,
		evocation = true,
--Hunter
		revivePet = true,
		scareBeast = true,
--Warlock
		fear = true,
		fear2 = true,
		banish = true,

--Druid
		skullBash = false,
--Paladin
		rebuke = false,
		repentance = true,
--Rogue
		disarm2 = true,
		blind = true,
		kick = true,
		preparation = true,
--Warrior
		disarm = true,
		fear3 = true,
		pummel = true,
		shieldBash = true,
--Priest
		fear4 = true,
		shadowFiend = true,
		disarm3 = true,
--Shaman
		grounding = true,
		manaTide = true,
		tremorTotem = true,
--Mage
		coldSnap = true,
		deepFreeze = true,
		counterspell = true,
--Death Knight
		mindFreeze = true,
		strangulate = true,
		runeWeapon = true,
		gargoyle = true,
		hungeringCold = true,
--Hunter
		wyvernSting = true,
		silencingshot = true,
--Warlock
		fear2 = true,
		spellLock = true,
		demonicCircleTeleport = true,

		lockout = true,

	}
}
function SoundAlerter:OnInitialize()
	self.db1 = LibStub("AceDB-3.0"):New("SoundAlerterDB",dbDefaults, "Default");
	DEFAULT_CHAT_FRAME:AddMessage(SOUNDALERTER_TEXT .. SOUNDALERTER_VERSION .. SOUNDALERTER_AUTHOR .."  - /SOUNDALERTER ");
	--LibStub("AceConfig-3.0"):RegisterOptionsTable("SoundAlerter", SoundAlerter.Options, {"SoundAlerter", "SS"})
	self:RegisterChatCommand("SoundAlerter", "ShowConfig")
	self:RegisterChatCommand("SOUNDALERTER", "ShowConfig")
	self.db1.RegisterCallback(self, "OnProfileChanged", "ChangeProfile")
	self.db1.RegisterCallback(self, "OnProfileCopied", "ChangeProfile")
	self.db1.RegisterCallback(self, "OnProfileReset", "ChangeProfile")
	SOUNDALERTERdb = self.db1.profile
	SoundAlerter.options = {
		name = "SoundAlerter",
		desc = "PVP技能语音提示",
		type = 'group',
		icon = [[Interface\Icons\Spell_Nature_ForceOfNature]],
		args = {},
	}
	local bliz_options = CopyTable(SoundAlerter.options)
	bliz_options.args.load = {
		name = "Load configuration",
		desc = "Load configuration options",
		type = 'execute',
		func = "ShowConfig",
		handler = SoundAlerter,
	}

	LibStub("AceConfig-3.0"):RegisterOptionsTable("SoundAlerter_bliz", bliz_options)
	AceConfigDialog:AddToBlizOptions("SoundAlerter_bliz", "SoundAlerter")
end
function SoundAlerter:OnEnable()
	SoundAlerter:RegisterEvent("PLAYER_ENTERING_WORLD")
	SoundAlerter:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
function SoundAlerter:OnDisable()
end
local function initOptions()
	if SoundAlerter.options.args.general then
		return
	end

	SoundAlerter:OnOptionsCreate()

	for k, v in SoundAlerter:IterateModules() do
		if type(v.OnOptionsCreate) == "function" then
			v:OnOptionsCreate()
		end
	end
	AceConfig:RegisterOptionsTable("SoundAlerter", SoundAlerter.options)
end
function SoundAlerter:ShowConfig()
	initOptions()
	AceConfigDialog:Open("SoundAlerter")
end
function SoundAlerter:ChangeProfile()
	SOUNDALERTERdb = self.db1.profile
	for k,v in SoundAlerter:IterateModules() do
		if type(v.ChangeProfile) == 'function' then
			v:ChangeProfile()
		end
	end
end
function SoundAlerter:AddOption(key, table)
	self.options.args[key] = table
end

local function setOption(info, value)
	local name = info[#info]
	SOUNDALERTERdb[name] = value
end
local function getOption(info)
	local name = info[#info]
	return SOUNDALERTERdb[name]
end
function SoundAlerter:OnOptionsCreate()
	self:AddOption("profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db1))
	self.options.args.profiles.order = -1
	self:AddOption('General', {
		type = 'group',
		name = "General",
		desc = "General Options",
		order = 1,
		args = {
			enableArea = {
				type = 'group',
				inline = true,
				name = "General options",
				set = setOption,
				get = getOption,
				args = {
					all = {
						type = 'toggle',
						name = "Enable Everything",
						desc = "Enables Sound Alerter for BGs, world and arena",
						order = 1,
					},
					arena = {
						type = 'toggle',
						name = "Arena",
						desc = "Enabled in the arena",
						disabled = function() return SOUNDALERTERdb.all end,
						order = 2,
					},
					battleground = {
						type = 'toggle',
						name = "Battleground",
						desc = "Enable Battleground",
						disabled = function() return SOUNDALERTERdb.all end,
						order = 3,
					},
					field = {
						type = 'toggle',
						name = "World",
						desc = "Enabled outside Battlegrounds and arenas",
						disabled = function() return SOUNDALERTERdb.all end,
						order = 4,
					}
				},
			},
		}
	})
	self:AddOption('Skill', {
		type = 'group',
		name = "Spells", --skills
		desc = "Spell Options",
		order = 1,
		args = {
			spellGeneral = {
				type = 'group',
				name = "Spell module control",
				desc = "Customise enabling and disabling of certain spells",  --Skills of each module to disable options
				inline = true,
				set = setOption,
				get = getOption,
				order = -1,
				args = {
					auraApplied = {
						type = 'toggle',
						name = "Disable buff applied", --Disable Enemy spell notifications
						desc = "Disables sound notifications of buffs applied",
						order = 1,
					},
					auraRemoved = {
						type = 'toggle',
						name = "Disable Buff down",
						desc = "Disables sound notifications of buffs down",
						order = 2,
					},
					castStart = {
						type = 'toggle',
						name = "Disable spell casting",
						desc = "Disables spell casting notifications",
						order = 3,
					},
					castSuccess = {
						type = 'toggle',
						name = "Disable enemy special spells",
						desc = "Disbles sound notifications of special abilities",
						order = 4,
					},
					interrupt = {
						type = 'toggle',
						name = "Disable friendly interrupted spells",
						desc = "Check this option to disable notifications of friendly interrupted spells",
						order = 5,
					}
				},
			},
			spellAuraApplied = {
				type = 'group',
				--inline = true,
				name = "Buffs",
				set = setOption,
				get = getOption,
				disabled = function() return SOUNDALERTERdb.auraApplied end,
				order = 1,
				args = {
					onlyTarget = {
						type = 'toggle',
						name = "Target and Focus only",
						desc = "Alert works only when your current target or focus gains the buff effect or use the ability",
						order = 1,
					},
					class = {
						type = 'toggle',
						name = "Alert Drinking",
						desc = "In arena, alert when enemy is drinking",
						order = 2,
					},
					general = {
						type = 'group',
						inline = true,
						name = "General spells",
						order = 3,
						args = {
							trinket = {
								type = 'toggle',
								name = GetSpellInfo(42292).."("..GetSpellInfo(59752)..")",
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(42292));
								end,
								descStyle = "custom",
								order = 2,
							},
						}
					},
					druid = {
						type = 'group',
						inline = true,
						name = "|cffFF7D0ADruid|r",
						order = 4,
						args = {
							survivalInstincts = {
								type = 'toggle',
								name = GetSpellInfo(61336),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(61336));
								end,
								descStyle = "custom",
								order = 2,
							},
							innervate = {
								type = 'toggle',
								name = GetSpellInfo(29166),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(29166));
								end,
								descStyle = "custom",
								order = 3,
							},
							barkskin = {
								type = 'toggle',
								name = GetSpellInfo(22812),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(22812));
								end,
								descStyle = "custom",
								order = 4,
							},
							naturesSwiftness = {
								type = 'toggle',
								name = GetSpellInfo(17116),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(17116));
								end,
								descStyle = "custom",
								order = 5,
							},
							naturesGrasp = {
								type = 'toggle',
								name = GetSpellInfo(16689),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(16689));
								end,
								descStyle = "custom",
								order = 6,
							},
							frenziedRegeneration = {
								type = 'toggle',
								name = GetSpellInfo(22842),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(22842));
								end,
								descStyle = "custom",
								order = 7,
							},
						}
					},
					paladin = {
						type = 'group',
						inline = true,
						name = "|cffF58CBAPaladin|r",
						order = 5,
						args = {
							auraMastery = {
								type = 'toggle',
								name = GetSpellInfo(31821),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(31821));
								end,
								descStyle = "custom",
								order = 1,
							},
							handOfProtection = {
								type = 'toggle',
								name = GetSpellInfo(1022),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1022));
								end,
								descStyle = "custom",
								order = 2,
							},
							handOfFreedom = {
								type = 'toggle',
								name = GetSpellInfo(1044),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1044));
								end,
								descStyle = "custom",
								order = 3,
							},
							divineShield = {
								type = 'toggle',
								name = GetSpellInfo(642),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(642));
								end,
								descStyle = "custom",
								order = 4,
							},
							sacrifice = {
								type = 'toggle',
								name = GetSpellInfo(6940),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(6940));
								end,
								descStyle = "custom",
								order = 5,
							},
							divineGuardian = {
								type = 'toggle',
								name = GetSpellInfo(64205),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(64205));
								end,
								descStyle = "custom",
								order = 6,
							},
							divinePlea = {
								type = 'toggle',
								name = GetSpellInfo(54428),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(54428));
								end,
								descStyle = "custom",
								order = 7,
							},
						}
					},
					rogue = {
						type = 'group',
						inline = true,
						name = "|cffFFF569Rogue|r",
						order = 6,
						args = {
							shadowDance = {
								type = 'toggle',
								name = GetSpellInfo(51713),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(51713));
								end,
								descStyle = "custom",
								order = 1,
							},
							cloakOfShadows = {
								type = 'toggle',
								name = GetSpellInfo(31224),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(31224));
								end,
								descStyle = "custom",
								order = 3,
							},
							adrenalineRush = {
								type = 'toggle',
								name = GetSpellInfo(13750),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(13750));
								end,
								descStyle = "custom",
								order = 4,
							},
							evasion = {
								type = 'toggle',
								name = GetSpellInfo(5277),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(5277));
								end,
								descStyle = "custom",
								order = 5,
							},
							CheatDeath = {
								type = 'toggle',
								name = GetSpellInfo(45182),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(45182));
								end,
								descStyle = "custom",
								order = 6,
							},
						}
					},
					warrior	= {
						type = 'group',
						inline = true,
						name = "|cffC79C6EWarrior|r",
						order = 7,
						args = {
							shieldWall = {
								type = 'toggle',
								name = GetSpellInfo(871),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(871));
								end,
								descStyle = "custom",
								order = 2,
							},
							berserkerRage = {
								type = 'toggle',
								name = GetSpellInfo(18499),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(18499));
								end,
								descStyle = "custom",
								order = 3,
							},
							retaliation = {
								type = 'toggle',
								name = GetSpellInfo(20230),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(20230));
								end,
								descStyle = "custom",
								order = 4,
							},
							spellReflection = {
								type = 'toggle',
								name = GetSpellInfo(23920),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(23920));
								end,
								descStyle = "custom",
								order = 5,
							},
							sweepingStrikes = {
								type = 'toggle',
								name = GetSpellInfo(12328),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(12328));
								end,
								descStyle = "custom",
								order = 6,
							},
							bladestorm = {
								type = 'toggle',
								name = GetSpellInfo(46924),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(46924));
								end,
								descStyle = "custom",
								order = 7,
							},
							deathWish = {
								type = 'toggle',
								name = GetSpellInfo(12292),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(12292));
								end,
								descStyle = "custom",
								order = 8,
							},
						}
					},
					priest	= {
						type = 'group',
						inline = true,
						name = "|cffFFFFFFPriest|r",
						order = 8,
						args = {
							painSuppression = {
								type = 'toggle',
								name = GetSpellInfo(33206),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(33206));
								end,
								descStyle = "custom",
								order = 1,
							},
							powerInfusion = {
								type = 'toggle',
								name = GetSpellInfo(37274),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(37274));
								end,
								descStyle = "custom",
								order = 2,
							},
							fearWard = {
								type = 'toggle',
								name = GetSpellInfo(6346),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(6346));
								end,
								descStyle = "custom",
								order = 3,
							},
							dispersion = {
								type = 'toggle',
								name = GetSpellInfo(47585),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(47585));
								end,
								descStyle = "custom",
								order = 4,
							},
						}
					},
					shaman	= {
						type = 'group',
						inline = true,
						name = "|cff0070DEShaman|r",
						order = 9,
						args = {
							shamanisticRage = {
								type = 'toggle',
								name = GetSpellInfo(30823),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(30823));
								end,
								descStyle = "custom",
								order = 1,
							},
							earthShield = {
								type = 'toggle',
								name = GetSpellInfo(49284),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(49284));
								end,
								descStyle = "custom",
								order = 2,
							},
							naturesSwiftness2 = {
								type = 'toggle',
								name = GetSpellInfo(16188),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(16188));
								end,
								descStyle = "custom",
								order = 3,
							},
							waterShield = {
								type = 'toggle',
								name = GetSpellInfo(33736),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(33736));
								end,
								descStyle = "custom",
								order = 4,
							},
							ElementalMastery = {
								type = 'toggle',
								name = GetSpellInfo(64701),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(64701));
								end,
								descStyle = "custom",
								order = 5,
							},
						}
					},
					mage = {
						type = 'group',
						inline = true,
						name = "|cff69CCF0Mage|r",
						order = 10,
						args = {
							iceBlock = {
								type = 'toggle',
								name = GetSpellInfo(45438),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(45438));
								end,
								descStyle = "custom",
								order = 1,
							},
							arcanePower = {
								type = 'toggle',
								name = GetSpellInfo(12042),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(12042));
								end,
								descStyle = "custom",
								order = 2,
							},
						}
					},
					dk	= {
						type = 'group',
						inline = true,
						name = "|cffC41F3BDeath Knight|r",
						order = 11,
						args = {
							lichborne = {
								type = 'toggle',
								name = GetSpellInfo(49039),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(49039));
								end,
								descStyle = "custom",
								order = 1,
							},
							iceboundFortitude = {
								type = 'toggle',
								name = GetSpellInfo(48792),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(48792));
								end,
								descStyle = "custom",
								order = 2,
							},
							vampiricBlood = {
								type = 'toggle',
								name = GetSpellInfo(55233),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(55233));
								end,
								descStyle = "custom",
								order = 3,
							},
							antimagicshell = {
								type = 'toggle',
								name = GetSpellInfo(48707),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(48707));
								end,
								descStyle = "custom",
								order = 3,
							},
						}
					},
					hunter = {
						type = 'group',
						inline = true,
						name = "|cffABD473Hunter|r",
						order = 12,
						args = {
							theBeastWithin = {
								type = 'toggle',
								name = GetSpellInfo(34471),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(34471));
								end,
								descStyle = "custom",
								order = 1,
							},
							deterrence = {
								type = 'toggle',
								name = GetSpellInfo(19263),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(19263));
								end,
								descStyle = "custom",
								order = 2,
							},
							readiness = {
								type = 'toggle',
								name = GetSpellInfo(23989),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(23989));
								end,
								descStyle = "custom",
								order = 3,
							},
						}
					},
				},
			},
			spellAuraRemoved = {
				type = 'group',
				--inline = true,
				name = "Buff Down",
				set = setOption,
				get = getOption,
				disabled = function() return SOUNDALERTERdb.auraRemoved end,
				order = 2,
				args = {
					paladin = {
						type = 'group',
						inline = true,
						name = "|cffF58CBAPaladin|r",
						order = 4,
						args = {
							protectionDown = {
								type = 'toggle',
								name = GetSpellInfo(1022),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1022));
								end,
								descStyle = "custom",
								order = 2,
							},
							bubbleDown = {
								type = 'toggle',
								name = GetSpellInfo(642),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(642));
								end,
								descStyle = "custom",
								order = 4,
							},
						}
					},
					rogue = {
						type = 'group',
						inline = true,
						name = "|cffFFF569Rogue|r",
						order = 5,
						args = {
							cloakDown = {
								type = 'toggle',
								name = GetSpellInfo(31224),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(31224));
								end,
								descStyle = "custom",
								order = 3,
							},
							evasionDown = {
								type = 'toggle',
								name = GetSpellInfo(5277),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(5277));
								end,
								descStyle = "custom",
								order = 5,
							},
						}
					},
					priest	= {
						type = 'group',
						inline = true,
						name = "|cffFFFFFFPriest|r",
						order = 7,
						args = {
							PSDown = {
								type = 'toggle',
								name = GetSpellInfo(33206),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(33206));
								end,
								descStyle = "custom",
								order = 1,
							},
							dispersionDown = {
								type = 'toggle',
								name = GetSpellInfo(47585),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(47585));
								end,
								descStyle = "custom",
								order = 2,
							},
						}
					},
					mage = {
						type = 'group',
						inline = true,
						name = "|cff69CCF0Mage|r",
						order = 9,
						args = {
							iceBlockDown = {
								type = 'toggle',
								name = GetSpellInfo(45438),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(45438));
								end,
								descStyle = "custom",
								order = 1,
							},
						},
					},
					dk = {
						type = 'group',
						inline = true,
						name = "|cffC41F3BDeath Knight|r",
						order = 10,
						args = {
							iceboundFortitudeDown = {
								type = 'toggle',
								name = GetSpellInfo(48792),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(48792));
								end,
								descStyle = "custom",
								order = 1,
							},
							lichborneDown = {
								type = 'toggle',
								name = GetSpellInfo(49039),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(49039));
								end,
								descStyle = "custom",
								order = 2,
							},
						},
					}
				},
			},
			spellCastStart = {
				type = 'group',
				--inline = true,
				name = "Spell Casting",
				disabled = function() return SOUNDALERTERdb.castStart end,
				set = setOption,
				get = getOption,
				order = 2,
				args = {
					general = {
						type = 'group',
						inline = true,
						name = "General Spells",
						order = 2,
						args = {
							bigHeal = {
								type = 'toggle',
								name = "Big Heals",
								desc = "Heal Holy Light Healing Wave Healing Touch",
								order = 1,
							},
							resurrection = {
								type = 'toggle',
								name = "Resurrection spells",
								desc = "Ancestral Spirit, Redemption, etc",
								order = 2,
							},
						}
					},
					druid = {
						type = 'group',
						inline = true,
						name = "|cffFF7D0ADruid|r",
						order = 3,
						args = {
							hibernate = {
								type = 'toggle',
								name = GetSpellInfo(2637),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(2637));
								end,
								descStyle = "custom",
								order = 1,
							},
							cyclone = {
								type = 'toggle',
								name = GetSpellInfo(33786),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(33786));
								end,
								descStyle = "custom",
								order = 2,
							},
						}
					},
					priest	= {
						type = 'group',
						inline = true,
						name = "|cffFFFFFFPriest|r",
						order = 6,
						args = {
							manaBurn = {
								type = 'toggle',
								name = GetSpellInfo(8129),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(8129));
								end,
								descStyle = "custom",
								order = 1,
							},
							shackleUndead = {
								type = 'toggle',
								name = GetSpellInfo(9484),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(9484));
								end,
								descStyle = "custom",
								order = 2,
							},
							mindControl = {
								type = 'toggle',
								name = GetSpellInfo(605),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(605));
								end,
								descStyle = "custom",
								order = 3,
							},
						}
					},
					shaman	= {
						type = 'group',
						inline = true,
						name = "|cff0070DEShaman|r",
						order = 7,
						args = {
							hex = {
								type = 'toggle',
								name = GetSpellInfo(51514),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(51514));
								end,
								descStyle = "custom",
								order = 1,
							},
						}
					},
					mage = {
						type = 'group',
						inline = true,
						name = "|cff69CCF0Mage|r",
						order = 8,
						args = {
							polymorph = {
								type = 'toggle',
								name = GetSpellInfo(118),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(118));
								end,
								descStyle = "custom",
								order = 1,
							},
							evocation = {
								type = 'toggle',
								name = GetSpellInfo(12051),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(12051));
								end,
								descStyle = "custom",
								order = 2,
							},
						}
					},
					hunter = {
						type = 'group',
						inline = true,
						name = "|cffABD473Hunter|r",
						order = 10,
						args = {
							revivePet = {
								type = 'toggle',
								name = GetSpellInfo(982),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(982));
								end,
								descStyle = "custom",
								order = 1,
							},
							scareBeast = {
								type = 'toggle',
								name = GetSpellInfo(14327),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(14327));
								end,
								descStyle = "custom",
								order = 2,
							},
						}
					},
					warlock	= {
						type = 'group',
						inline = true,
						name = "|cff9482C9Warlock|r",
						order = 11,
						args = {
							fear = {
								type = 'toggle',
								name = GetSpellInfo(5782),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(5782));
								end,
								descStyle = "custom",
								order = 1,
							},
							fear2 = {
								type = 'toggle',
								name = GetSpellInfo(5484),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(5484));
								end,
								descStyle = "custom",
								order = 2,
							},
							banish = {
								type = 'toggle',
								name = GetSpellInfo(710),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(710));
								end,
								descStyle = "custom",
								order = 3,
							},
						}
					},
				},
			},
			spellCastSuccess = {
				type = 'group',
				--inline = true,
				name = "Special Abilities",
				disabled = function() return SOUNDALERTERdb.castSuccess end,
				set = setOption,
				get = getOption,
				order = 3,
				args = {
					rogue = {
						type = 'group',
						inline = true,
						name = "|cffFFF569Rogue|r",
						order = 4,
						args = {
							disarm2 = {
								type = 'toggle',
								name = GetSpellInfo(51722),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(51722));
								end,
								descStyle = "custom",
								order = 1,
							},
							blind = {
								type = 'toggle',
								name = GetSpellInfo(2094),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(2094));
								end,
								descStyle = "custom",
								order = 2,
							},
							kick = {
								type = 'toggle',
								name = GetSpellInfo(1766),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1766));
								end,
								descStyle = "custom",
								order = 3,
							},
							preparation = {
								type = 'toggle',
								name = GetSpellInfo(14185),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(14185));
								end,
								descStyle = "custom",
								order = 4,
							},
							vanish = {
								type = 'toggle',
								name = GetSpellInfo(1856),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1856));
								end,
								descStyle = "custom",
								order = 5,
							},
						}
					},
					warrior	= {
						type = 'group',
						inline = true,
						name = "|cffC79C6EWarrior|r",
						order = 5,
						args = {
							disarm = {
								type = 'toggle',
								name = GetSpellInfo(676),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(676));
								end,
								descStyle = "custom",
								order = 1,
							},
							fear3 = {
								type = 'toggle',
								name = GetSpellInfo(5246),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(5246));
								end,
								descStyle = "custom",
								order = 2,
							},
							pummel = {
								type = 'toggle',
								name = GetSpellInfo(6552),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(6552));
								end,
								descStyle = "custom",
								order = 3,
							},
							shieldBash = {
								type = 'toggle',
								name = GetSpellInfo(72),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(72));
								end,
								descStyle = "custom",
								order = 4,
							},
						}
					},
					priest	= {
						type = 'group',
						inline = true,
						name = "|cffFFFFFFPriest|r",
						order = 6,
						args = {
							fear4 = {
								type = 'toggle',
								name = GetSpellInfo(8122),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(8122));
								end,
								descStyle = "custom",
								order = 1,
							},
							shadowFiend = {
								type = 'toggle',
								name = GetSpellInfo(34433),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(34433));
								end,
								descStyle = "custom",
								order = 2,
							},
							disarm3 = {
								type = 'toggle',
								name = GetSpellInfo(64044),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(64044));
								end,
								descStyle = "custom",
								order = 3,
							},
						}
					},
					shaman	= {
						type = 'group',
						inline = true,
						name = "|cff0070DEShaman|r",
						order = 7,
						args = {
							grounding = {
								type = 'toggle',
								name = GetSpellInfo(8177),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(8177));
								end,
								descStyle = "custom",
								order = 1,
							},
							manaTide = {
								type = 'toggle',
								name = GetSpellInfo(16190),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(16190));
								end,
								descStyle = "custom",
								order = 2,
							},
							tremorTotem = {
								type = 'toggle',
								name = GetSpellInfo(8143),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(8143));
								end,
								descStyle = "custom",
								order = 3,
							},
						}
					},
					mage = {
						type = 'group',
						inline = true,
						name = "|cff69CCF0Mage|r",
						order = 8,
						args = {
							coldSnap = {
								type = 'toggle',
								name = GetSpellInfo(11958),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(11958));
								end,
								descStyle = "custom",
								order = 1,
							},
							deepFreeze = {
								type = 'toggle',
								name = GetSpellInfo(44572),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(44572));
								end,
								descStyle = "custom",
								order = 2,
							},
							counterspell = {
								type = 'toggle',
								name = GetSpellInfo(2139),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(2139));
								end,
								descStyle = "custom",
								order = 3,
							},
							invisibility = {
								type = 'toggle',
								name = GetSpellInfo(66),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(66));
								end,
								descStyle = "custom",
								order = 4,
							},
						}
					},
					dk	= {
						type = 'group',
						inline = true,
						name = "|cffC41F3BDeath Knight|r",
						order = 9,
						args = {
							mindFreeze = {
								type = 'toggle',
								name = GetSpellInfo(47528),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(47528));
								end,
								descStyle = "custom",
								order = 1,
							},
							strangulate = {
								type = 'toggle',
								name = GetSpellInfo(47476),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(47476));
								end,
								descStyle = "custom",
								order = 2,
							},
							runeWeapon = {
								type = 'toggle',
								name = GetSpellInfo(47568),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(47568));
								end,
								descStyle = "custom",
								order = 3,
							},
							gargoyle = {
								type = 'toggle',
								name = GetSpellInfo(49206),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(49206));
								end,
								descStyle = "custom",
								order = 4,
							},
							hungeringCold = {
								type = 'toggle',
								name = GetSpellInfo(49203),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(49203));
								end,
								descStyle = "custom",
								order = 5,
							},
						}
					},
					hunter = {
						type = 'group',
						inline = true,
						name = "|cffABD473Hunter|r",
						order = 10,
						args = {
							wyvernSting = {
								type = 'toggle',
								name = GetSpellInfo(19386),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(19386));
								end,
								descStyle = "custom",
								order = 1,
							},
							silencingshot = {
								type = 'toggle',
								name = GetSpellInfo(34490),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(34490));
								end,
								descStyle = "custom",
								order = 1,
							},
						}
					},
					warlock = {
						type = 'group',
						inline = true,
						name = "|cff9482C9Warlock|r",
						order = 11,
						args = {
							fear2 = {
								type = 'toggle',
								name = GetSpellInfo(5484),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(5484));
								end,
								descStyle = "custom",
								order = 1,
							},
							spellLock = {
								type = 'toggle',
								name = GetSpellInfo(19647),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(19647));
								end,
								descStyle = "custom",
								order = 2,
							},
							demonicCircleTeleport = {
								type = 'toggle',
								name = GetSpellInfo(48020),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(48020));
								end,
								descStyle = "custom",
								order = 3,
							},
						}
					},
				},
			},
			spellInterrupt = {
				type = 'group',
				--inline = true,
				name = "Friendly Interrupts",
				disabled = function() return SOUNDALERTERdb.interrupt end,
				set = setOption,
				get = getOption,
				order = 4,
				args = {
					lockout = {
						type = 'toggle',
						name = "Self Interrupted spells",
						desc = "Counterspell, Kick, Mind Freeze etc",
						order = 1,
					},
				}
			},
		}
	})
end
function SoundAlerter:PlayTrinket()
	PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Trinket.mp3")
end
function SoundAlerter:ArenaClass(id)
	for i = 1 , 5 do
		if id == UnitGUID("arena"..i) then
			return select(2, UnitClass ("arena"..i))
		end
	end
end
function SoundAlerter:PLAYER_ENTERING_WORLD()
	CombatLogClearEntries()
end
function SoundAlerter:COMBAT_LOG_EVENT_UNFILTERED(event , ...)
	local _,currentZoneType = IsInInstance()
	if (not ((currentZoneType == "none" and SOUNDALERTERdb.field) or (currentZoneType == "pvp" and SOUNDALERTERdb.battleground) or (currentZoneType == "arena" and SOUNDALERTERdb.arena) or SOUNDALERTERdb.all)) then
		--print (currentZoneType,SOUNDALERTERdb.field,SOUNDALERTERdb.battleground,SOUNDALERTERdb.arena,SOUNDALERTERdb.all)
		return
	end
	local timestamp,event,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName= select ( 1 , ... );
	--print (sourceName,destName,event,spellName,spellID);
	local toEnemy,fromEnemy,toSelf,toTarget = false , false , false , false
	if (destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) ) then
		toEnemy = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS)
	end
	if (sourceName and not CombatLog_Object_IsA(sourceFlags, COMBATLOG_OBJECT_NONE) ) then
		fromEnemy = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS)
	end
	if (destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) ) then
		toSelf = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_MINE)
	end
	if (destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) ) then
		toFriend = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_FRIENDLY_UNITS)
	end
	if (destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) ) then
		toTarget = (UnitGUID("target") == destGUID)
	end
	--print (toTarget,sourceName,destName)
	--DEBUG
	--Adding spells to SoundAlerter will require you to know the ID, and know the type of event.
	--If you would like to add a spell, PM me with the event, sourcename, destname and spell
	--I cannot implement Feign death, as it isn't recorded by combat log, It's counted as a 'death'
	--To do this, remove the "--[[debug and enddebug]]--" and insert a the spell ID
	--To get the Spell ID, go to wowhead, search for a spell, click on the page, and your URL will show the ID at the end
--[[debug
	if (spellID == 23989) then
		print (sourceName,destName,event,spellName,spellID)
	end
enddebug]]
	--Event Spell_AURA_APPLIED works with enemies with buffs on them from used cooldowns
	if (event == "SPELL_AURA_APPLIED" and toEnemy and (not SOUNDALERTERdb.onlyTarget or toTarget) and not SOUNDALERTERdb.auraApplied) then
	--General
		if ( (spellName == "Every Man for Himself" or spellName == "PvP Trinket") and SOUNDALERTERdb.trinket) then
			if (SOUNDALERTERdb.class and currentZoneType == "arena" ) then
				local c = self:ArenaClass(destGUID)
				PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Trinket.mp3");
				self:ScheduleTimer("PlayTrinket", 0.3)
			else
				self:PlayTrinket()
			end
			--PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Trinket.mp3");
		end
		--druid
		if (spellName == "Survival Instincts" and SOUNDALERTERdb.survivalInstincts) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Survival Instincts.mp3");
		end
		if (spellName == "Innervate" and SOUNDALERTERdb.innervate) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Innervate.mp3");
		end
		if (spellName == "Barkskin" and SOUNDALERTERdb.barkskin) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\barkskin.mp3");
		end
		if (spellName == "Natures Swiftness" and SOUNDALERTERdb.naturesSwiftness) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Natures Swiftness.mp3");
		end
		if (spellName == "Natures Grasp" and SOUNDALERTERdb.naturesGrasp) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Natures Grasp.mp3");
		end
		if (spellName == "Frenzied Regeneration" and SOUNDALERTERdb.frenziedRegeneration) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Frenzied Regeneration.mp3");
		end
		--paladin
		if (spellName == "Aura Mastery" and SOUNDALERTERdb.auraMastery) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Aura Mastery.mp3");
		end
		if (spellName == "Hand of Protection" and SOUNDALERTERdb.handOfProtection) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Hand of Protection.mp3");
		end
		if (spellName == "Hand of Freedom" and SOUNDALERTERdb.handOfFreedom) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Hand of Freedom.mp3");
		end
		if (spellName == "Divine Shield" and SOUNDALERTERdb.divineShield) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\divine shield.mp3");
		end
		if (spellName == "Hand of Sacrifice" and SOUNDALERTERdb.sacrifice) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Sacrifice.mp3");
		end
		if (spellName == "Divine Guardian" and SOUNDALERTERdb.divineGuardian) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Divine Guardian.mp3");
		end
		if (spellName == "Divine Plea" and SOUNDALERTERdb.divinePlea) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Divine Plea.mp3");
		end
		--rogue
		if (spellName == "Shadow Dance" and SOUNDALERTERdb.shadowDance) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Shadow Dance.mp3");
		end
		if (spellName == "Cloak of Shadows" and SOUNDALERTERdb.cloakOfShadows) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Cloak of Shadows.mp3");
		end
		if (spellName == "Adrenaline Rush" and SOUNDALERTERdb.adrenalineRush) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Adrenaline Rush.mp3");
		end
		if (spellName == "Evasion" and SOUNDALERTERdb.evasion) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Evasion.mp3");
		end
		if (spellName == "Cheat Death" and SOUNDALERTERdb.cheatdeath) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Cheatdeath.mp3");
		end
		--warrior
		if (spellName == "Shield Wall" and SOUNDALERTERdb.shieldWall) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Shield Wall.mp3")
		end
		if (spellName == "Berserker Rage" and SOUNDALERTERdb.berserkerRage) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Berserker Rage.mp3");
		end
		if (spellName == "Retaliation" and SOUNDALERTERdb.retaliation) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Retaliation.mp3")
		end
		if (spellName == "Spell Reflection" and SOUNDALERTERdb.spellReflection) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Spell Reflection.mp3")
		end
		if (spellName == "Sweeping Strikes" and SOUNDALERTERdb.sweepingStrikes) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Sweeping Strikes.mp3");
		end
		if (spellName == "Bladestorm" and SOUNDALERTERdb.bladestorm) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Bladestorm.mp3");
		end
		if (spellName == "Death Wish" and SOUNDALERTERdb.deathWish) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Death Wish.mp3");
		end
		--priest
		if (spellName == "Pain Suppression" and SOUNDALERTERdb.painSuppression) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\pain suppression.mp3");
		end
		if (spellName == "Power Infusion" and SOUNDALERTERdb.powerInfusion) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Power Infusion.mp3");
		end
		if (spellName == "Fear Ward" and SOUNDALERTERdb.fearWard) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Fear Ward.mp3");
		end
		if (spellName == "Dispersion" and SOUNDALERTERdb.dispersion) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Dispersion.mp3");
		end
		--shaman
		if (spellName == "Water Shield" and SOUNDALERTERdb.waterShield) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\water shield.mp3");
		end
		if (spellName == "Elemental Mastery" and SOUNDALERTERdb.ElementalMastery) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\ElementalMastery.mp3");
		end
		if (spellName == "Shamanistic Rage" and SOUNDALERTERdb.shamanisticRage) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Shamanistic Rage.mp3")
		end
		if (spellName == "Earth Shield" and SOUNDALERTERdb.earthShield) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Earth shield.mp3");
		end
		--mage
		if (spellName == "Ice Block" and SOUNDALERTERdb.iceBlock) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\ice block.mp3");
		end
		if (spellName == "Arcane Power" and SOUNDALERTERdb.arcanePower) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Arcane Power.mp3");
		end
		if (spellName == "Evocation" and SOUNDALERTERdb.evocation) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Evocation.mp3");
		end
		--dk
		if (spellName == "Lichborne" and SOUNDALERTERdb.lichborne) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Lichborne.mp3");
		end
		if (spellName == "Icebound Fortitude" and SOUNDALERTERdb.iceboundFortitude) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Icebound Fortitude.mp3");
		end
		if (spellName == "Vampiric Blood" and SOUNDALERTERdb.vampiricBlood) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Vampiric Blood.mp3");
		end
		if (spellName == "Anti-Magic Shell" and SOUNDALERTERdb.antimagicshell) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Anti Magic Shell.mp3");
		end
		--hunter. NOTE: Feign Death cannot be detected in combat log, it is counted as a 'death' and cannot be introduced :(
		if (spellName == "Deterrence" and SOUNDALERTERdb.deterrence) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Deterrence.mp3");
		end
		if (spellName == "The Beast Within" and SOUNDALERTERdb.theBeastWithin) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\The Beast Within.mp3")
		end
		--warlock, anyone got any worth putting in?
	end
	--Event SPELL_AURA_REMOVED is when enemies have lost the buff provided by SPELL_AURA_APPLIED (eg. Bubble down)
	if (event == "SPELL_AURA_REMOVED" and toEnemy and not SOUNDALERTERdb.auraRemoved) then
		if (spellName == "Divine Shield" and SOUNDALERTERdb.bubbleDown) then
		   PlaySoundFile("Interface\\Addons\\SoundAlerter\\Voice\\Bubble down.mp3")
		end
		if (spellName == "Dispersion" and SOUNDALERTERdb.dispersionDown) then
		   PlaySoundFile("Interface\\Addons\\SoundAlerter\\Voice\\Dispersion down.mp3")
		end
		if (spellName == "Hand of Protection" and SOUNDALERTERdb.protectionDown) then
		   PlaySoundFile("Interface\\Addons\\SoundAlerter\\Voice\\Protection down.mp3")
		end
		if (spellName == "Cloak of Shadows" and SOUNDALERTERdb.cloakDown) then
		   PlaySoundFile("Interface\\Addons\\SoundAlerter\\Voice\\Cloak down.mp3")
		end
		if (spellName == "Pain Suppression" and SOUNDALERTERdb.PSDown) then
		   PlaySoundFile("Interface\\Addons\\SoundAlerter\\Voice\\PS down.mp3")
		end
		if (spellName == "Evasion" and SOUNDALERTERdb.evasionDown) then
		   PlaySoundFile("Interface\\Addons\\SoundAlerter\\Voice\\Evasion down.mp3")
		end
		if (spellName == "Ice Block" and SOUNDALERTERdb.iceBlockDown) then
		   PlaySoundFile("Interface\\Addons\\SoundAlerter\\Voice\\Ice Block down.mp3")
		end
		if (spellName == "Lichborne" and SOUNDALERTERdb.lichborneDown) then
		   PlaySoundFile("Interface\\Addons\\SoundAlerter\\Voice\\lichborne Down.mp3")
		end
		if (spellName == "Icebound Fortitude" and SOUNDALERTERdb.iceboundFortitudeDown) then
		   PlaySoundFile("Interface\\Addons\\SoundAlerter\\Voice\\Icebound Fortitude Down.mp3")
		end
	end
	if (event == "SPELL_CAST_START" and fromEnemy and not SOUNDALERTERdb.castStart) then
	--general
		if ((spellName == "Heal" or spellName == "Holy Light" or spellName == "Healing Wave" or spellName == "Healing Touch") and SOUNDALERTERdb.bigHeal) then -- 强效治疗术 神光术 强效治疗波 治疗之触
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\Voice\\big heal.mp3");
		end
		if ((spellName == "Resurrection" or spellName == "Ancestral Spirit" or spellName == "Redemption" or spellName == "Revive") and SOUNDALERTERdb.resurrection) then -- 复活术 救赎 先祖之魂 复活
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Resurrection.mp3");
		end
	--hunter
		if (spellName == "Revive Pet" and SOUNDALERTERdb.revivePet) then -- 复活宠物
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Revive Pet.mp3");
		end
	end
	if (event == "SPELL_CAST_START" and fromEnemy and not SOUNDALERTERdb.castStart) then

		--druid
		if (spellName == "Cyclone" and SOUNDALERTERdb.cyclone) then -- 吹风
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\cyclone.mp3");
		end
		if (spellName == "Hibernate" and SOUNDALERTERdb.hibernate) then -- 休眠
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\hibernate.mp3");
		end
		--paladin
		--rogue
		--warrior
		--priest
		if (spellName == "Mana Burn" and SOUNDALERTERdb.manaBurn) then -- 法力燃烧
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Mana Burn.mp3");
		end
		if (spellName == "Shackle Undead" and SOUNDALERTERdb.shackleUndead) then -- 束缚亡灵
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Shackle Undead.mp3");
		end
		if (spellName == "Mind Control" and SOUNDALERTERdb.mindControl) then -- 精神控制
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Mind Control.mp3");
		end
		--shaman
		if (spellName == "Hex" and SOUNDALERTERdb.hex) then -- 妖术
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Hex.mp3");
		end
		--mage
		if (spellName == "Polymorph" and SOUNDALERTERdb.polymorph) then -- 变形术 羊猪猫兔蛇鸡龟
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\polymorph.mp3");
		end
		--dk
		--hunter
		if (spellName == "Scare Beast" and SOUNDALERTERdb.scareBeast) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Scare Beast.mp3");
		end
		--warlock
		if (spellName == "Banish" and SOUNDALERTERdb.banish) then -- 放逐术
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Banish.mp3");
		end
		if (spellName == "Fear" and SOUNDALERTERdb.fear) then -- 恐惧
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\fear.mp3");
		end
		if (spellName == "Howl of Terror" and SOUNDALERTERdb.fear2) then -- 恐惧嚎叫
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\fear2.mp3");
		end
	end
	--SPELL_CAST_SUCCESS only applies when the enemy has casted a spell
	if (event == "SPELL_CAST_SUCCESS" and fromEnemy and not SOUNDALERTERdb.castSuccess) then
		--general
		--druid
		--paladin
		--rogue
		if (spellName == "Dismantle" and SOUNDALERTERdb.disarm2) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Disarm2.mp3")
		end
		if (spellName == "Blind" and SOUNDALERTERdb.blind) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Blind.mp3")
		end
		if (spellName == "Kick" and SOUNDALERTERdb.kick) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\kick.mp3")
		end
		if (spellName == "Preparation" and SOUNDALERTERdb.kick) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\preparation.mp3")
		end
		if (spellName == "Vanish" and SOUNDALERTERdb.vanish) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Vanish.mp3")
		end
		--warrior
		if (spellName == "Disarm" and SOUNDALERTERdb.disarm) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Disarm.mp3")
		end
		if (spellName == "Intimidating Shout" and SOUNDALERTERdb.fear3) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Fear3.mp3");
		end
		if (spellName == "Pummel" and SOUNDALERTERdb.pummel) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\pummel.mp3")
		end
		if (spellName == "Shield Bash" and SOUNDALERTERdb.shieldBash) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Shield Bash.mp3")
		end
		--priest
		if (spellName == "Psychic Scream" and SOUNDALERTERdb.fear4) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Fear4.mp3");
		end
		if (spellName == "Shadowfiend" and SOUNDALERTERdb.shadowFiend) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Shadowfiend.mp3")
		end
		if (spellName == "Psychic Horror" and SOUNDALERTERdb.disarm3) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\disarm3.mp3")
		end
		--shaman
		if (spellName == "Grounding Totem" and SOUNDALERTERdb.grounding) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Grounding.mp3")
		end
		if (spellName == "Mana Tide Totem" and SOUNDALERTERdb.manaTide) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Mana Tide.mp3");
		end
		if (spellName == "Tremor Totem" and SOUNDALERTERdb.tremorTotem) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Tremor Totem.mp3");
		end
		--mage
		if (spellName == "Deep Freeze" and SOUNDALERTERdb.deepFreeze) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Deep Freeze.mp3");
		end
		if (spellName == "Counterspell" and SOUNDALERTERdb.counterspell) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Counterspell.mp3");
		end
		if (spellName == "Cold Snap" and SOUNDALERTERdb.ColdSnap) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\cold snap.mp3");
		end
		if (spellName == "Invisibility" and SOUNDALERTERdb.invisibility) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Invisibility.mp3");
		end
		--dk
		if (spellName == "Mind Freeze" and SOUNDALERTERdb.mindFreeze) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Mind Freeze.mp3")
		end
		if (spellName == "Strangulate" and SOUNDALERTERdb.strangulate) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Strangulate.mp3");
		end
		if (spellName == "Dancing Rune Weapon" and SOUNDALERTERdb.runeWeapon) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Rune Weapon.mp3");
		end
		if (spellName == "Summon Gargoyle" and SOUNDALERTERdb.gargoyle) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\gargoyle.mp3");
		end
		if (spellName == "Hungering Cold" and SOUNDALERTERdb.hungeringCold) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Hungering cold.mp3");
		end
		--hunter
		if (spellName == "Wyvern Sting" and SOUNDALERTERdb.wyvernSting) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Wyvern Sting.mp3");
		end
		if (spellName == "Silencing Shot" and SOUNDALERTERdb.silencingshot) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\silencingshot.mp3");
		end
		if (spellName == "Readiness" and SOUNDALERTERdb.readiness) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Readiness.mp3");
		end
		--warlock
		if (spellName == "Howl of Terror" and SOUNDALERTERdb.fear2) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\fear2.mp3");
		end
		if (spellName == "Spell Lock" and SOUNDALERTERdb.spellLock) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Spell Lock.mp3");
		end
		if (spellName == "Demonic Circle: Teleport" and SOUNDALERTERdb.demonicCircleTeleport) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Demonic Circle Teleport.mp3");
		end
	end
	if (event == "SPELL_INTERRUPT" and toEnemy and not SOUNDALERTERdb.interrupt) then
		if ((spellName == "Deep Freeze" or spellName == "Counterspell" or spellName == "Kick" or spellName == "Wind Shear" or spellName == "Shield Bash" or spellName == "Mind Freeze" ) and SOUNDALERTERdb.lockout) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\Voice\\lockout.mp3");
		end
	end
end


