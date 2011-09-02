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

		aruaApplied = false,
		aruaRemoved = false,
		castStart = false,
		castSuccess = false,
		interrupt = false,

		onlyTarget = false,
		class = false,
		shadowmeld = true,
		trinket = true,

		thorns = true,
		survivalInstincts = true,
		innervate = true,
		barkskin = true,
		naturesSwiftness = true,
		naturesGrasp = true,
		frenziedRegeneration = true,
		enrage = false,
		desh = false,

		auraMastery = true,
		handOfProtection = true,
		handOfFreedom = true,
		divineShield = true,
		sacrifice = true,
		divineGuardian = true,
		divinePlea = true,

		shadowDance = true,
		sprint = true,
		cloakOfShadows = true,
		adrenalineRush = true,
		evasion = true,
		vanish = true,

		deathWish = true,
		enragedRegeneration = true,
		shieldWall = true,
		berserkerRage = true,
		retaliation = true,
		spellReflection = true,
		sweepingStrikes = true,
		bladestorm = true,

		painSuppression = true,
		powerInfusion = true,
		fearWard = true,
		dispersion = true,

		waterShield = false,
		shamanisticRage = true,
		earthShield = true,
		naturesSwiftness2 = true,

		iceBlock = true,
		arcanePower = true,
		invisibility = true,

		iceboundFortitude = true,
		lichborne = true,
		vampiricBlood = true,

		theBeastWithin = true,
		deterrence = true,
		feignDeath = true,

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

		bigHeal = true,
		resurrection = true,

		hibernate = true,
		cyclone = true,

		manaBurn = true,
		shackleUndead = true,
		mindControl = true,

		hex = true,

		polymorph = true,

		revivePet = true,
		scareBeast = true,

		fear = true,
		fear2 = true,
		banish = true,


		skullBash = false,

		rebuke = false,
		repentance = true,

		disarm2 = true,
		blind = true,
		kick = true,
		preparation = true,

		disarm = true,
		fear3 = true,
		pummel = true,
		shieldBash = true,

		fear4 = true,
		shadowFiend = true,
		disarm3 = true,

		grounding = true,
		manaTide = true,
		tremorTotem = true,

		coldSnap = true,
		deepFreeze = true,
		counterspell = true,

		mindFreeze = true,
		strangulate = true,
		runeWeapon = true,
		gargoyle = true,
		hungeringCold = true,

		wyvernSting = true,

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
		name = "加载配置",
		desc = "加载配置选项",
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
	self:AddOption('一般', {
		type = 'group',
		name = "一般",
		desc = "一般选项",
		order = 1,
		args = {
			enableArea = {
				type = 'group',
				inline = true,
				name = "当何时启用",
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
		name = "Skill",
		desc = "Skill Options",
		order = 1,
		args = {
			spellGeneral = {
				type = 'group',
				name = "Skills module control",
				desc = "Skills of each module to disable options",
				inline = true,
				set = setOption,
				get = getOption,
				order = -1,
				args = {
					aruaApplied = {
						type = 'toggle',
						name = "Disable buff applied", --Disable Enemy spell notifications
						desc = "Disables sound notifications of buffs applied",
						order = 1,
					},
					aruaRemoved = {
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
				disabled = function() return SOUNDALERTERdb.aruaApplied end,
				order = 1,
				args = {
					onlyTarget = {
						type = 'toggle',
						name = "Only enabled on target",
						desc = "Only when hostile spells on your target body that is enabled voice prompts",
						order = 1,
					},
					class = {
						type = 'toggle',
						name = "徽章职业提示",
						desc = "在竞技场中,通报徽章的同时提示使用徽章的职业",
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
						name = "|cffFF7D0A德鲁伊|r",
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
					preist	= {
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
						}
					},
				},
			},
			spellAuraRemoved = {
				type = 'group',
				--inline = true,
				name = "敌方增益结束",
				set = setOption,
				get = getOption,
				disabled = function() return SOUNDALERTERdb.aruaRemoved end,
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
					preist	= {
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
				name = "敌方读条技能",
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
					preist	= {
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
				name = "敌方特殊技能",
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
						name = "|cffC79C6E战士|r",
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
					preist	= {
						type = 'group',
						inline = true,
						name = "|cffFFFFFF牧师|r",
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
						name = "|cff0070DE萨满|r",
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
						name = "|cff69CCF0法师|r",
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
						name = "|cffC41F3B死亡骑士|r",
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
						name = "|cffABD473猎人|r",
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
						}
					},
					warlock = {
						type = 'group',
						inline = true,
						name = "|cff9482C9术士|r",
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
				name = "友方打断技能",
				disabled = function() return SOUNDALERTERdb.interrupt end,
				set = setOption,
				get = getOption,
				order = 4,
				args = {
					lockout = {
						type = 'toggle',
						name = "友方打断技能",
						desc = "法术封锁 法术反制 脚踢 拳击 盾击 心智冰封",
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
	--[[debug
	if (spellID == 80964 or spellID == 80965 or spellID == 85285) then
		print (sourceName,destName,event,spellName,spellID)
	end
	enddebug]]--
	if (event == "SPELL_AURA_APPLIED" and toEnemy and (not SOUNDALERTERdb.onlyTarget or toTarget) and not SOUNDALERTERdb.aruaApplied) then
		--general
		if ( (spellName == "自利" or spellName == "PvP饰品") and SOUNDALERTERdb.trinket) then -- 徽章
			if (SOUNDALERTERdb.class and currentZoneType == "arena" ) then
				local c = self:ArenaClass(destGUID)
				PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\"..c..".mp3");
				self:ScheduleTimer("PlayTrinket", 0.3)
			else
				self:PlayTrinket()
			end
			--PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Trinket.mp3");
		end
		--druid
		if (spellName == "Survival Instincts" and SOUNDALERTERdb.survivalInstincts) then -- 求生本能
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Survival Instincts.mp3");
		end
		if (spellName == "Innervate" and SOUNDALERTERdb.innervate) then -- 启动
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Innervate.mp3");
		end
		if (spellName == "Barkskin" and SOUNDALERTERdb.barkskin) then -- 树皮术
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\barkskin.mp3");
		end
		if (spellName == "Natures Swiftness" and SOUNDALERTERdb.naturesSwiftness) then -- 自然迅捷
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Natures Swiftness.mp3");
		end
		if (spellName == "Natures Grasp" and SOUNDALERTERdb.naturesGrasp) then -- 自然之握
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Natures Grasp.mp3");
		end
		if (spellName == "Frenzied Regeneration" and SOUNDALERTERdb.frenziedRegeneration) then -- 狂暴恢复
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Frenzied Regeneration.mp3");
		end
		--paladin
		if (spellName == "Aura Mastery" and SOUNDALERTERdb.auraMastery) then -- 光环精通
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Aura Mastery.mp3");
		end
		if (spellName == "Hand of Protection" and SOUNDALERTERdb.handOfProtection) then -- 保护
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Hand of Protection.mp3");
		end
		if (spellName == "Hand of Freedom" and SOUNDALERTERdb.handOfFreedom) then -- 自由
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Hand of Freedom.mp3");
		end
		if (spellName == "Divine Shield" and SOUNDALERTERdb.divineShield) then -- 无敌
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\divine shield.mp3");
		end
		if (spellName == "Hand of Sacrifice" and SOUNDALERTERdb.sacrifice) then -- 牺牲祝福
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Sacrifice.mp3");
		end
		if (spellName == "Divine Guardian" and SOUNDALERTERdb.divineGuardian) then -- 神性牺牲
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Divine Guardian.mp3");
		end
		if (spellName == "Divine Plea" and SOUNDALERTERdb.divinePlea) then -- 神性恳求
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Divine Plea.mp3");
		end
		--rogue
		if (spellName == "Shadow Dance" and SOUNDALERTERdb.shadowDance) then -- 暗影之舞
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Shadow Dance.mp3");
		end
		if (spellName == "Cloak of Shadows" and SOUNDALERTERdb.cloakOfShadows) then -- 斗篷
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Cloak of Shadows.mp3");
		end
		if (spellName == "Adrenaline Rush" and SOUNDALERTERdb.adrenalineRush) then -- 冲动
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Adrenaline Rush.mp3");
		end
		if (spellName == "Evasion" and SOUNDALERTERdb.evasion) then -- 闪避
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Evasion.mp3");
		end
		--warrior
		if (spellName == "Shield Wall" and SOUNDALERTERdb.shieldWall) then --盾墙
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Shield Wall.mp3")
		end
		if (spellName == "Berserker Rage" and SOUNDALERTERdb.berserkerRage) then -- 狂暴之怒
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Berserker Rage.mp3");
		end
		if (spellName == "Retaliation" and SOUNDALERTERdb.retaliation) then -- 反击风暴
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Retaliation.mp3")
		end
		if (spellName == "Spell Reflection" and SOUNDALERTERdb.spellReflection) then -- 盾反
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Spell Reflection.mp3")
		end
		if (spellName == "Sweeping Strikes" and SOUNDALERTERdb.sweepingStrikes) then -- 横扫攻击
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Sweeping Strikes.mp3");
		end
		if (spellName == "Bladestorm" and SOUNDALERTERdb.bladestorm) then -- 剑刃风暴
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Bladestorm.mp3");
		end
		if (spellName == "Death Wish" and SOUNDALERTERdb.deathWish) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Death Wish.mp3");
		end
		--preist
		if (spellName == "Pain Suppression" and SOUNDALERTERdb.painSuppression) then -- 痛苦压制
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\pain suppression.mp3");
		end
		if (spellName == "Power Infusion" and SOUNDALERTERdb.powerInfusion) then -- 能量灌注
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Power Infusion.mp3");
		end
		if (spellName == "Fear Ward" and SOUNDALERTERdb.fearWard) then -- 反恐
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Fear Ward.mp3");
		end
		if (spellName == "Dispersion" and SOUNDALERTERdb.dispersion) then -- 消散
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Dispersion.mp3");
		end
		--shaman

		if (spellName == "Water Shield" and SOUNDALERTERdb.waterShield) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\water shield.mp3");
		end
		if (spellName == "Shamanistic Rage" and SOUNDALERTERdb.shamanisticRage) then -- 萨满之怒
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Shamanistic Rage.mp3")
		end
		if (spellName == "Earth Shield" and SOUNDALERTERdb.earthShield) then -- 大地之盾
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Earth shield.mp3");
		end
		--mage
		if (spellName == "Ice Block" and SOUNDALERTERdb.iceBlock) then -- 寒冰屏障
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\ice block.mp3");
		end
		if (spellName == "Arcane Power" and SOUNDALERTERdb.arcanePower) then -- 秘法强化
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Arcane Power.mp3");
		end
		--dk
		if (spellName == "Lichborne" and SOUNDALERTERdb.lichborne) then -- 巫妖之躯
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Lichborne.mp3");
		end
		if (spellName == "Icebound Fortitude" and SOUNDALERTERdb.iceboundFortitude) then -- 冰固
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Icebound Fortitude.mp3");
		end
		if (spellName == "Vampiric Blood" and SOUNDALERTERdb.vampiricBlood) then -- 血族之裔
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Vampiric Blood.mp3");
		end
		--hunter
		if (spellName == "Deterrence" and SOUNDALERTERdb.deterrence) then -- 威慑
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Deterrence.mp3");
		end
		if (spellName == "The Beast Within" and SOUNDALERTERdb.theBeastWithin) then -- 野兽之心
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\The Beast Within.mp3")
		end
		--warlock
	end
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
		--preist
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
		--maga
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
	if (event == "SPELL_CAST_SUCCESS" and fromEnemy and not SOUNDALERTERdb.castSuccess) then
		--general
		--druid
		--paladin
		--rogue
		if (spellName == "Dismantle" and SOUNDALERTERdb.disarm2) then -- 拆卸
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Disarm2.mp3")
		end
		if (spellName == "Blind" and SOUNDALERTERdb.blind) then -- 致盲
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Blind.mp3")
		end
		if (spellName == "Kick" and SOUNDALERTERdb.kick) then -- 脚踢
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\kick.mp3")
		end
		if (spellName == "Preparation" and SOUNDALERTERdb.kick) then -- 伺机待发
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\preparation.mp3")
		end
		if (spellName == "Vanish" and SOUNDALERTERdb.vanish) then -- 消失
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Vanish.mp3")
		end
		--warrior
		if (spellName == "Disarm" and SOUNDALERTERdb.disarm) then -- 缴械
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Disarm.mp3")
		end
		if (spellName == "Intimidating Shout" and SOUNDALERTERdb.fear3) then -- 破胆怒吼
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Fear3.mp3");
		end
		if (spellName == "Pummel" and SOUNDALERTERdb.pummel) then -- 拳击
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\pummel.mp3")
		end
		if (spellName == "Shield Bash" and SOUNDALERTERdb.shieldBash) then -- 盾击
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Shield Bash.mp3")
		end
		--preist
		if (spellName == "Psychic Scream" and SOUNDALERTERdb.fear4) then -- 心灵尖啸
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Fear4.mp3");
		end
		if (spellName == "Shadowfiend" and SOUNDALERTERdb.shadowFiend) then -- 暗影恶魔
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Shadowfiend.mp3")
		end
		if (spellName == "Psychic Horror" and SOUNDALERTERdb.disarm3) then -- 心灵惊骇
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\disarm3.mp3")
		end
		--shaman
		if (spellName == "Grounding Totem" and SOUNDALERTERdb.grounding) then -- 根基图腾
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Grounding.mp3")
		end
		if (spellName == "Mana Tide Totem" and SOUNDALERTERdb.manaTide) then -- 法力之潮
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Mana Tide.mp3");
		end
		if (spellName == "Tremor Totem" and SOUNDALERTERdb.tremorTotem) then -- 战栗图腾
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\tremor Totem.mp3");
		end
		--mage
		if (spellName == "Deep Freeze" and SOUNDALERTERdb.deepFreeze) then -- 深结
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Deep Freeze.mp3");
		end
		if (spellName == "Counterspell" and SOUNDALERTERdb.counterspell) then -- 法术反制
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Counterspell.mp3");
		end
		if (spellName == "Cold Snap" and SOUNDALERTERdb.counterspell) then -- 急速冷却
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\cold snap.mp3");
		end
		if (spellName == "Invisibility" and SOUNDALERTERdb.invisibility) then -- 隐形术
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Invisibility.mp3");
		end
		--dk
		if (spellName == "Mind Freeze" and SOUNDALERTERdb.mindFreeze) then -- 心智冰封
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Mind Freeze.mp3")
		end
		if (spellName == "Strangulate" and SOUNDALERTERdb.strangulate) then -- 绞杀
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Strangulate.mp3");
		end
		if (spellName == "Dancing Rune Weapon" and SOUNDALERTERdb.runeWeapon) then -- 强力符文武器
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Rune Weapon.mp3");
		end
		if (spellName == "Summon Gargoyle" and SOUNDALERTERdb.gargoyle) then -- 召唤石像鬼
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\gargoyle.mp3");
		end
		if (spellName == "Hungering Cold" and SOUNDALERTERdb.hungeringCold) then -- 饥饿之寒
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Hungering cold.mp3");
		end
		--hunter
		if (spellName == "Wyvern Sting" and SOUNDALERTERdb.wyvernSting) then -- 翼龙钉刺
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Wyvern Sting.mp3");
		end
		--warlock
		if (spellName == "Howl of Terror" and SOUNDALERTERdb.fear2) then -- 恐惧嚎叫
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\fear2.mp3");
		end
		if (spellName == "Spell Lock" and SOUNDALERTERdb.spellLock) then -- 法术封锁
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Spell Lock.mp3");
		end
		if (spellName == "Demonic Circle: Teleport" and SOUNDALERTERdb.demonicCircleTeleport) then -- 恶魔法阵:传送
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\voice\\Demonic Circle Teleport.mp3");
		end
	end
	if (event == "SPELL_INTERRUPT" and toEnemy and not SOUNDALERTERdb.interrupt) then -- 法术封锁 法术反制 脚踢 拳击 盾击 心智冰封 碎颅猛击 责难
		if ((spellName == "法术封锁" or spellName == "法术反制" or spellName == "脚踢" or spellName == "拳击" or spellName == "盾击" or spellName == "心灵冰冻" ) and SOUNDALERTERdb.lockout) then
			PlaySoundFile("Interface\\Addons\\SoundAlerter\\Voice\\lockout.mp3");
		end
	end
end



