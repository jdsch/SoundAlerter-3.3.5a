SoundAlerter = LibStub("AceAddon-3.0"):NewAddon("SoundAlerter", "AceEvent-3.0","AceConsole-3.0","AceTimer-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local self , SoundAlerter = SoundAlerter , SoundAlerter
local SOUNDALERTER_TEXT="|cffFF7D0ASoundAlerter|r"
local SOUNDALERTER_VERSION= " r335.01"
local SOUNDALERTER_AUTHOR=" updated by |cff0070DETrolollolol|r - Sargeras - Molten-WoW.com"
local sadb
local PlaySoundFile = PlaySoundFile
local SendChatMessage = SendChatMessage
local playerName = UnitName("player")
local _,currentZoneType = IsInInstance()
local DRINK_SPELL = GetSpellInfo(57073)
local sapath = "Interface\\Addons\\SoundAlerter\\voice\\"


--warning to non-english clients
if ((GetLocale() == "zhCN") or (GetLocale() == "zhTW") or (GetLocale() == "koKR") or (GetLocale() == "frFR") or (GetLocale() == "esES") or (GetLocale() == "ruRU")) then
DEFAULT_CHAT_FRAME:AddMessage("|cffFF7D0ASoundAlerter|r Currently only works on English Clients only, sorry. If you would like to get involved, send a PM to shamwoww on forum.molten-wow.com or send a message to |cff0070DETrolollolol|r - Sargeras - Horde - Molten-WoW.com");
end

function SoundAlerter:OnInitialize()
	self.db1 = LibStub("AceDB-3.0"):New("sadb",dbDefaults, "Default");
	DEFAULT_CHAT_FRAME:AddMessage(SOUNDALERTER_TEXT .. SOUNDALERTER_VERSION .. SOUNDALERTER_AUTHOR .."  - /SOUNDALERTER ");
	--LibStub("AceConfig-3.0"):RegisterOptionsTable("SoundAlerter", SoundAlerter.Options, {"SoundAlerter", "SS"})
	self:RegisterChatCommand("SoundAlerter", "ShowConfig")
	self:RegisterChatCommand("SOUNDALERTER", "ShowConfig")
	self.db1.RegisterCallback(self, "OnProfileChanged", "ChangeProfile")
	self.db1.RegisterCallback(self, "OnProfileCopied", "ChangeProfile")
	self.db1.RegisterCallback(self, "OnProfileReset", "ChangeProfile")
	sadb = self.db1.profile
	SoundAlerter.options = {
		name = "SoundAlerter",
		desc = "Voice prompts from enemy used spells",
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
	SoundAlerter:RegisterEvent("UNIT_AURA")
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
	sadb = self.db1.profile
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
	sadb[name] = value
end
local function getOption(info)
	local name = info[#info]
	return sadb[name]
end
	GameTooltip:HookScript("OnTooltipSetUnit", function(tip)
        local name, server = tip:GetUnit()
		local Realm = GetRealmName()
        if (SA_sponsors[name] ) then if ( SA_sponsors[name]["Realm"] == Realm ) then
		tip:AddLine(SA_sponsors[SA_sponsors[name].Type], 1, 0, 0 ) end; end
    end)

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
						disabled = function() return sadb.all end,
						order = 2,
					},
					battleground = {
						type = 'toggle',
						name = "Battleground",
						desc = "Enable Battleground",
						disabled = function() return sadb.all end,
						order = 3,
					},
					field = {
						type = 'toggle',
						name = "World",
						desc = "Enabled outside Battlegrounds and arenas",
						disabled = function() return sadb.all end,
						order = 4,
					},
					myself = {
						type = 'toggle',
						name = "Target and Focus only",
						disabled = function() return sadb.enemyinrange end,
						desc = "Alert works only when your current target casts a spell, or an enemy casts a spell on you",
						order = 5,
					},
					enemyinrange = {
						type = 'toggle',
						name = "All Enemies in Range",
						desc = "Alerts are enabled for all enemies in range",
						disabled = function() return sadb.myself end,
						order = 6,
					},
					volumn = {
						type = 'range',
						max = 1,
						min = 0,
						step = 0.1,
						name = "Master Volume",
						desc = "Sets the master volume so sound alerts can be louder/softer",
						set = function (info, value) SetCVar ("Sound_MasterVolume",tostring (value)) end,
						get = function () return tonumber (GetCVar ("Sound_MasterVolume")) end,
						order = 7,
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
				desc = "Customise enabling and disabling of certain spells",
				inline = true,
				set = setOption,
				get = getOption,
				order = -1,
				args = {
					auraApplied = {
						type = 'toggle',
						name = "Disable buff applied",
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
					chatalerts = {
						type = 'toggle',
						name = "Disable Chat Alerts",
						desc = "Disbles Chat notifications of special abilities in the chat bar",
						order = 5,
					},
					interrupt = {
						type = 'toggle',
						name = "Disable friendly interrupted spells",
						desc = "Check this option to disable notifications of friendly interrupted spells",
						order = 6,
					}
				},
			},
			spellAuraApplied = {
				type = 'group',
				--inline = true,
				name = "Buffs",
				set = setOption,
				get = getOption,
				disabled = function() return sadb.auraApplied end,
				order = 1,
				args = {
					class = {
						type = 'toggle',
						name = "Alert Class calling for trinketting in Arena",
						desc = "Alert when an enemy class trinkets in arena",
						order = 2,
					},
					drinking = {
						type = 'toggle',
						name = "Alert Drinking in Arena",
						desc = "Alert when an enemy drinks in arena",
						order = 3,
					},
					general = {
						type = 'group',
						inline = true,
						name = "General spells",
						order = 4,
						args = {
							trinket = {
								type = 'toggle',
								name = GetSpellInfo(42292).."("..GetSpellInfo(59752)..")",
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(42292));
								end,
								descStyle = "custom",
								order = 1,
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
							starfall = {
								type = 'toggle',
								name = GetSpellInfo(48505),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(48505));
								end,
								descStyle = "custom",
								order = 8,
							},
							berserk = {
								type = 'toggle',
								name = GetSpellInfo(50334),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(50334));
								end,
								descStyle = "custom",
								order = 8,
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
							lastStand = {
								type = 'toggle',
								name = GetSpellInfo(12975),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(12975));
								end,
								descStyle = "custom",
								order = 9,
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
								order = 4,
							},
							boneshield = {
								type = 'toggle',
								name = GetSpellInfo(49222),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(49222));
								end,
								descStyle = "custom",
								order = 5,
							},
							hysteria = {
								type = 'toggle',
								name = GetSpellInfo(49016),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(49016));
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
					races = {
						type = 'group',
						inline = true,
						name = "|cffFFFFFFGeneral Races|r",
						order = 14,
						args = {
							Shadowmeld = { --need to add mp3
								type = 'toggle',
								name = GetSpellInfo(58984),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(58984));
								end,
								descStyle = "custom",
								order = 1,
							},
							giftofthenaaru = { --need to add mp3
								type = 'toggle',
								name = GetSpellInfo(28880),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(28880));
								end,
								descStyle = "custom",
								order = 2,
							},
							BloodFury = { --need to add mp3
								type = 'toggle',
								name = GetSpellInfo(20572),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(20572));
								end,
								descStyle = "custom",
								order = 3,
							},
							willoftheforsaken = {
								type = 'toggle',
								name = GetSpellInfo(7744),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(7744));
								end,
								descStyle = "custom",
								order = 4,
							},
							berserking = { --need to add mp3
								type = 'toggle',
								name = GetSpellInfo(26297),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(26297));
								end,
								descStyle = "custom",
								order = 5,
							},
						}
					},
					warlock	= {
						type = 'group',
						inline = true,
						name = "|cff9482C9Warlock|r",
						order = 13,
						args = {
							shadowtrance = {
								type = 'toggle',
								name = GetSpellInfo(17941),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(17941));
								end,
								descStyle = "custom",
								order = 1,
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
				disabled = function() return sadb.auraRemoved end,
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
					},
					druid = {
						type = 'group',
						inline = true,
						name = "|cffFF7D0ADruid|r",
						order = 11,
						args = {
							sfalldown = {
								type = 'toggle',
								name = GetSpellInfo(48505),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(48505));
								end,
								descStyle = "custom",
								order = 1,
							},
						},
					},
					hunter = {
						type = 'group',
						inline = true,
						name = "|cffABD473Hunter|r",
						order = 12,
						args = {
							deterdown = {
								type = 'toggle',
								name = GetSpellInfo(19263),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(19263));
								end,
								descStyle = "custom",
								order = 1,
							},
						}
					},
				}
			},
			spellCastStart = {
				type = 'group',
				--inline = true,
				name = "Spell Casting",
				disabled = function() return sadb.castStart end,
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
								desc = "Heal, Holy Light, Healing Wave, Healing Touch",
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
							HotStreak = {
								type = 'toggle',
								name = GetSpellInfo(44445),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(44445));
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
				disabled = function() return sadb.castSuccess end,
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
							bladeflurry = {
								type = 'toggle',
								name = GetSpellInfo(13877),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(13877));
								end,
								descStyle = "custom",
								order = 6,
							},
							stealth = {
								type = 'toggle',
								name = GetSpellInfo(1784),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1784));
								end,
								descStyle = "custom",
								order = 7,
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
							markofblood = {
								type = 'toggle',
								name = GetSpellInfo(61606),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(61606));
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
							aimedshot = {
								type = 'toggle',
								name = GetSpellInfo(19434),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(19434));
								end,
								descStyle = "custom",
								order = 1,
							},
							freezingtrap = {
								type = 'toggle',
								name = GetSpellInfo(1499),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1499));
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
							deathcoil = {
								type = 'toggle',
								name = GetSpellInfo(6789),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(6789));
								end,
								descStyle = "custom",
								order = 4,
							},
						}
					},
					paladin = {
						type = 'group',
						inline = true,
						name = "|cffF58CBAPaladin|r",
						order = 11,
						args = {
							repentance = {
								type = 'toggle',
								name = GetSpellInfo(20066),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(20066));
								end,
								descStyle = "custom",
								order = 1,
							},
							hammerofjustice = {
								type = 'toggle',
								name = GetSpellInfo(853),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(853));
								end,
								descStyle = "custom",
								order = 1,
							},
						}
					},
				},
			},
		enemydebuff = {
				type = 'group',
				--inline = true,
				name = "Enemy Debuff",
				disabled = function() return sadb.enemydebuff end,
				set = setOption,
				get = getOption,
				order = 4,
				args = {
						rogue = {
						type = 'group',
						inline = true,
						name = "|cffFFF569Rogue|r",
						order = 1,
						args = {
							blindup = {
								type = 'toggle',
								name = GetSpellInfo(2094),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(2094));
								end,
								descStyle = "custom",
								order = 1,
							},
						},
					}
				},
			},
			enemydebuffdown = {
				type = 'group',
				--inline = true,
				name = "Enemy Debuff Down",
				disabled = function() return sadb.enemydebuffdown end,
				set = setOption,
				get = getOption,
				order = 5,
				args = {
						rogue = {
						type = 'group',
						inline = true,
						name = "|cffFFF569Rogue|r",
						order = 1,
						args = {
							blinddown = {
								type = 'toggle',
								name = GetSpellInfo(2094),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(2094));
								end,
								descStyle = "custom",
								order = 1,
							},
						},
					}
				},
			},
			chatalerter = {
				type = 'group',
				--inline = true,
				name = "Chat Alerts",
				disabled = function() return sadb.chatalerts end,
				set = setOption,
				get = getOption,
				order = 4,
				args = {
				party = {
						type = 'toggle',
						name = "Alert in Party Chat",
						desc = "Chat Message alerts are shown in party chat",
						order = 1,
					},
				say = {
						type = 'toggle',
						name = "Alert in Say Chat",
						desc = "Chat Message alerts are shown in Say chat",
						order = 2,
					},
				clientonly = {
						type = 'toggle',
						name = "Alert in Client",
						desc = "Chat Message alerts are only visible to yourself",
						order = 3,
					},
				bgchat = {
						type = 'toggle',
						name = "Alert in BGs",
						desc = "Chat Message alerts are shown in BG chat",
						order = 4,
					},
						rogue = {
						type = 'group',
						inline = true,
						name = "|cffFFF569Rogue|r",
						order = 6,
						args = {
							stealthalert = {
								type = 'toggle',
								name = GetSpellInfo(1784),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1784));
								end,
								descStyle = "custom",
								order = 1,
							},
							vanishalert = {
								type = 'toggle',
								name = GetSpellInfo(1856),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1856));
								end,
								descStyle = "custom",
								order = 2,
							},
							blindonenemychat = {
								type = 'toggle',
								name = "Blind on Enemy",
								desc = "Enemies that have been blinded will be alerted",
								order = 3,
							},
							blindonselfchat = {
								type = 'toggle',
								name = "Blind on Self",
								desc = "Enemies that have blinded you will be alerted",
								order = 3,
							},
						},
					},
					general = {
						type = 'group',
						inline = true,
						name = "|cffFFFFFFGeneral|r",
						order = 5,
						args = {
							trinketalert = {
								type = 'toggle',
								name = GetSpellInfo(42292),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(42292));
								end,
								descStyle = "custom",
								order = 1,
							},
							interruptalert = {
								type = 'toggle',
								name = "Interrupts on Target",
								desc = "Alerts you if you have interrupted an enemys spell",
								descStyle = "custom",
								order = 2,
							},
						},
					},
					InterruptText = {
						type = "input",
						name = "Interrupt Text",
						desc = "Example: Interrupted = Interrupted [PlayerName]: with [SpellName]",
						order = 7,
						width = full,
					},
					spelltext = {
						type = "input",
						name = "Ability Casting Text",
						desc = "Example: Casted = [PlayerName] Casted [SpellName]",
						order = 8,
						width = full,
					}
				},
			},
			spellInterrupt = {
				type = 'group',
				--inline = true,
				name = "Friendly Interrupts",
				disabled = function() return sadb.interrupt end,
				set = setOption,
				get = getOption,
				order = 6,
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
	PlaySoundFile(""..sapath.."Trinket.mp3");
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

	local pvpType, isFFA, faction = GetZonePVPInfo();
	if (not ((pvpType == "contested" and sadb.field) or (pvpType == "hostile" and sadb.field) or (pvpType == "friendly" and sadb.field) or (currentZoneType == "pvp" and sadb.battleground) or (currentZoneType == "arena" and sadb.arena) or sadb.all)) then
		return
	end
	 timestamp,event,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName= select ( 1 , ... );
	--print (sourceName,destName,event,spellName,spellID);
	 toEnemy,fromEnemy,toSelf,toTarget,fromFocus = false , false , false , false , false
	if (destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) ) then
		toEnemy = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS)
	end
	if (sourceName and not CombatLog_Object_IsA(sourceFlags, COMBATLOG_OBJECT_NONE) ) then
		fromEnemy = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS)
		fromTarget = CombatLog_Object_IsA(sourceFlags, COMBATLOG_OBJECT_TARGET)
		fromFocus = CombatLog_Object_IsA(sourceFlags, COMBATLOG_OBJECT_FOCUS)
	end
	if (destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) ) then
		toSelf = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_MINE)
	end
	if (destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) ) then
		toFriend = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_FRIENDLY_UNITS)
	end
	if (destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) ) then
	toTarget = COMBATLOG_OBJECT_TARGET
	toFocus = CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_FOCUS)
		--toTarget = CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_TARGET)
		--toTarget = (UnitGUID("target") == destGUID)
	end
	--print (toTarget,sourceName,destName)
	--DEBUG
--[[debug
	if (spellID == 23989) then
		print (sourceName,destName,event,spellName,spellID)
	end
enddebug]]
	--Event Spell_AURA_APPLIED works with enemies with buffs on them from used cooldowns


if (event == "SPELL_AURA_APPLIED" and toEnemy and ((sadb.myself and (fromTarget or fromFocus)) or sadb.enemyinrange) and not sadb.auraApplied) then --(not sadb.onlyTarget or toTarget)

		--Night Elves
		if (spellName == "Shadowmeld" and sadb.Shadowmeld) then
			PlaySoundFile(""..sapath.."Shadowmeld.mp3");
		end
		--Trolls
		if (spellName == "Berserking" and sadb.berserking) then
			PlaySoundFile(""..sapath.."Beserk.mp3");
		end
		--Orcs
		if (spellName == "Blood Fury" and sadb.BloodFury) then
			PlaySoundFile(""..sapath.."BloodFury.mp3");
		end
		--dranei
		if (spellName == "Gift of the Naaru" and sadb.giftofthenaaru) then
			PlaySoundFile(""..sapath.."giftofthenaaru.mp3");
		end
		--druid
		if (spellName == "Survival Instincts" and sadb.survivalInstincts) then
			PlaySoundFile(""..sapath.."Survival Instincts.mp3");
		end
		if (spellName == "Innervate" and sadb.innervate) then
			PlaySoundFile(""..sapath.."Innervate.mp3");
		end
		if (spellName == "Barkskin" and sadb.barkskin) then
			PlaySoundFile(""..sapath.."barkskin.mp3");
		end
		if (spellName == "Natures Swiftness" and sadb.naturesSwiftness) then
			PlaySoundFile(""..sapath.."Natures Swiftness.mp3");
		end
		if (spellName == "Natures Grasp" and sadb.naturesGrasp) then
			PlaySoundFile(""..sapath.."Natures Grasp.mp3");
		end
		if (spellName == "Frenzied Regeneration" and sadb.frenziedRegeneration) then
			PlaySoundFile(""..sapath.."Frenzied Regeneration.mp3");
		end
		if (spellName == "Starfall" and sadb.starfall) then
			PlaySoundFile(""..sapath.."Starfall.mp3");
		end
		if (spellName == "Berserk" and sadb.beserk) then
			PlaySoundFile(""..sapath.."Beserk.mp3");
		end
		--paladin
		if (spellName == "Aura Mastery" and sadb.auraMastery) then
			PlaySoundFile(""..sapath.."Aura Mastery.mp3");
		end
		if (spellName == "Hand of Protection" and sadb.handOfProtection) then
			PlaySoundFile(""..sapath.."Hand of Protection.mp3");
		end
		if (spellName == "Hand of Freedom" and sadb.handOfFreedom) then
			PlaySoundFile(""..sapath.."Hand of Freedom.mp3");
		end
		if (spellName == "Divine Shield" and sadb.divineShield) then
			PlaySoundFile(""..sapath.."divine shield.mp3");
		end
		if (spellName == "Hand of Sacrifice" and sadb.sacrifice) then
			PlaySoundFile(""..sapath.."Sacrifice.mp3");
		end
		if (spellName == "Divine Guardian" and sadb.divineGuardian) then
			PlaySoundFile(""..sapath.."Divine Guardian.mp3");
		end
		if (spellName == "Divine Plea" and sadb.divinePlea) then
			PlaySoundFile(""..sapath.."Divine Plea.mp3");
		end
		--rogue
		if (spellName == "Shadow Dance" and sadb.shadowDance) then
			PlaySoundFile(""..sapath.."Shadow Dance.mp3");
		end
		if (spellName == "Cloak of Shadows" and sadb.cloakOfShadows) then
			PlaySoundFile(""..sapath.."Cloak of Shadows.mp3");
		end
		if (spellName == "Adrenaline Rush" and sadb.adrenalineRush) then
			PlaySoundFile(""..sapath.."Adrenaline Rush.mp3");
		end
		if (spellName == "Evasion" and sadb.evasion) then
			PlaySoundFile(""..sapath.."Evasion.mp3");
		end
		if (spellName == "Cheat Death" and sadb.cheatdeath) then
			PlaySoundFile(""..sapath.."Cheatdeath.mp3");
		end
		--warrior
		if (spellName == "Shield Wall" and sadb.shieldWall) then
			PlaySoundFile(""..sapath.."Shield Wall.mp3")
		end
		if (spellName == "Last Stand" and sadb.laststand) then
			PlaySoundFile(""..sapath.."Shield Wall.mp3")
		end
		if (spellName == "Berserker Rage" and sadb.berserkerRage) then
			PlaySoundFile(""..sapath.."Berserker Rage.mp3");
		end
		if (spellName == "Retaliation" and sadb.retaliation) then
			PlaySoundFile(""..sapath.."Retaliation.mp3")
		end
		if (spellName == "Spell Reflection" and sadb.spellReflection) then
			PlaySoundFile(""..sapath.."Spell Reflection.mp3")
		end
		if (spellName == "Sweeping Strikes" and sadb.sweepingStrikes) then
			PlaySoundFile(""..sapath.."Sweeping Strikes.mp3");
		end
		if (spellName == "Bladestorm" and sadb.bladestorm) then
			PlaySoundFile(""..sapath.."Bladestorm.mp3");
		end
		if (spellName == "Death Wish" and sadb.deathWish) then
			PlaySoundFile(""..sapath.."Death Wish.mp3");
		end
		--priest
		if (spellName == "Pain Suppression" and sadb.painSuppression) then
			PlaySoundFile(""..sapath.."pain suppression.mp3");
		end
		if (spellName == "Power Infusion" and sadb.powerInfusion) then
			PlaySoundFile(""..sapath.."Power Infusion.mp3");
		end
		if (spellName == "Fear Ward" and sadb.fearWard) then
			PlaySoundFile(""..sapath.."Fear Ward.mp3");
		end
		if (spellName == "Dispersion" and sadb.dispersion) then
			PlaySoundFile(""..sapath.."Dispersion.mp3");
		end
		--shaman
		if (spellName == "Water Shield" and sadb.waterShield) then
			PlaySoundFile(""..sapath.."water shield.mp3");
		end
		if (spellID == 16166 and sadb.ElementalMastery) then
			PlaySoundFile(""..sapath.."ElementalMastery.mp3");
		end
		if (spellName == "Shamanistic Rage" and sadb.shamanisticRage) then
			PlaySoundFile(""..sapath.."Shamanistic Rage.mp3")
		end
		if (spellName == "Earth Shield" and sadb.earthShield) then
			PlaySoundFile(""..sapath.."Earth shield.mp3");
		end
		--mage
		if (spellName == "Ice Block" and sadb.iceBlock) then
			PlaySoundFile(""..sapath.."ice block.mp3");
		end
		if (spellName == "Arcane Power" and sadb.arcanePower) then
			PlaySoundFile(""..sapath.."Arcane Power.mp3");
		end
		if (spellName == "Evocation" and sadb.evocation) then
			PlaySoundFile(""..sapath.."Evocation.mp3");
		end
		if (spellName == "Hot Streak" and sadb.HotStreak) then
			PlaySoundFile(""..sapath.."Hot Streak.MP3");
		end
		--dk
		if (spellName == "Lichborne" and sadb.lichborne) then
			PlaySoundFile(""..sapath.."Lichborne.mp3");
		end
		if (spellName == "Icebound Fortitude" and sadb.iceboundFortitude) then
			PlaySoundFile(""..sapath.."Icebound Fortitude.mp3");
		end
		if (spellName == "Vampiric Blood" and sadb.vampiricBlood) then
			PlaySoundFile(""..sapath.."Vampiric Blood.mp3");
		end
		if (spellName == "Anti-Magic Shell" and sadb.antimagicshell) then
			PlaySoundFile(""..sapath.."Anti Magic Shell.mp3");
		end
		if (spellName == "Bone Shield" and sadb.boneshield) then
			PlaySoundFile(""..sapath.."Bone Shield.mp3");
		end
		if (spellName == "Unholy Frenzy" and sadb.hysteria) then
			PlaySoundFile(""..sapath.."hysteria.mp3");
		end
		--hunter. NOTE: Feign Death cannot be detected in combat log, it is counted as a 'death' and cannot be introduced :(
		if (spellName == "Deterrence" and sadb.deterrence) then
			PlaySoundFile(""..sapath.."Deterrence.mp3");
		end
		if (spellName == "The Beast Within" and sadb.theBeastWithin) then
			PlaySoundFile(""..sapath.."The Beast Within.mp3")
		end
		--warlock
		if (spellName == "Shadow Trance" and sadb.shadowtrance) then
			PlaySoundFile(""..sapath.."Shadowtrance.mp3")
		end
	end
	--Event SPELL_AURA_REMOVED is when enemies have lost the buff provided by SPELL_AURA_APPLIED (eg. Bubble down)
	if (event == "SPELL_AURA_REMOVED" and toEnemy and ((sadb.myself and (fromTarget or fromFocus)) or sadb.enemyinrange) and not sadb.auraRemoved) then
		if (spellName == "Deterrence" and sadb.deterdown) then
			PlaySoundFile(""..sapath.."Deterrencedown.mp3");
		end
		if (spellName == "Starfall" and sadb.sfalldown) then
			PlaySoundFile(""..sapath.."Starfalldown.mp3");
		end
		if (spellName == "Divine Shield" and sadb.bubbleDown) then
		   PlaySoundFile(""..sapath.."Bubble down.mp3")
		end
		if (spellName == "Dispersion" and sadb.dispersionDown) then
		   PlaySoundFile(""..sapath.."Dispersion down.mp3")
		end
		if (spellName == "Hand of Protection" and sadb.protectionDown) then
		   PlaySoundFile(""..sapath.."Protection down.mp3")
		end
		if (spellName == "Cloak of Shadows" and sadb.cloakDown) then
		   PlaySoundFile(""..sapath.."Cloak down.mp3")
		end
		if (spellName == "Pain Suppression" and sadb.PSDown) then
		   PlaySoundFile(""..sapath.."PS down.mp3")
		end
		if (spellName == "Evasion" and sadb.evasionDown) then
		   PlaySoundFile(""..sapath.."Evasion down.mp3")
		end
		if (spellName == "Ice Block" and sadb.iceBlockDown) then
		   PlaySoundFile(""..sapath.."Ice Block down.mp3")
		end
		if (spellName == "Lichborne" and sadb.lichborneDown) then
		   PlaySoundFile(""..sapath.."lichborne Down.mp3")
		end
		if (spellName == "Icebound Fortitude" and sadb.iceboundFortitudeDown) then
		   PlaySoundFile(""..sapath.."Icebound Fortitude Down.mp3")
		end
	end
	if (event == "SPELL_CAST_START" and fromEnemy and ((sadb.myself and (fromTarget or fromFocus)) or sadb.enemyinrange) and not sadb.castStart) then--or not (sadb.myself or sadb.enemyinrange) and not sadb.castStart) then
	--general
		if ((spellName == "Heal" or spellName == "Holy Light" or spellName == "Healing Wave" or spellName == "Healing Touch") and sadb.bigHeal) then
			PlaySoundFile(""..sapath.."big heal.mp3");
		end
		if ((spellName == "Resurrection" or spellName == "Ancestral Spirit" or spellName == "Redemption" or spellName == "Revive") and sadb.resurrection) then
			PlaySoundFile(""..sapath.."Resurrection.mp3");
		end
	--hunter
		if (spellName == "Revive Pet" and sadb.revivePet) then
			PlaySoundFile(""..sapath.."Revive Pet.mp3");
		end
		--druid
		if (spellName == "Cyclone" and sadb.cyclone) then
			PlaySoundFile(""..sapath.."cyclone.mp3");
		end
		if (spellName == "Hibernate" and sadb.hibernate) then
			PlaySoundFile(""..sapath.."hibernate.mp3");
		end
		if (spellName == "Mana Burn" and sadb.manaBurn) then
			PlaySoundFile(""..sapath.."Mana Burn.mp3");
		end
		if (spellName == "Shackle Undead" and sadb.shackleUndead) then
			PlaySoundFile(""..sapath.."Shackle Undead.mp3");
		end
		if (spellName == "Mind Control" and sadb.mindControl) then
			PlaySoundFile(""..sapath.."Mind Control.mp3");
		end
		--shaman
		if (spellName == "Hex" and sadb.hex) then
			PlaySoundFile(""..sapath.."Hex.mp3");
		end
		--mage
		if (spellName == "Polymorph" and sadb.polymorph) then
			PlaySoundFile(""..sapath.."polymorph.mp3");
		end
		--dk
		--hunter
		if (spellName == "Scare Beast" and sadb.scareBeast) then
			PlaySoundFile(""..sapath.."Scare Beast.mp3");
		end
		--warlock
		if (spellName == "Banish" and sadb.banish) then
			PlaySoundFile(""..sapath.."Banish.mp3");
		end
		if (spellName == "Fear" and sadb.fear) then
			PlaySoundFile(""..sapath.."fear.mp3");
		end
		if (spellName == "Howl of Terror" and sadb.fear2) then
			PlaySoundFile(""..sapath.."fear2.mp3");
		end
	end
	--SPELL_CAST_SUCCESS only applies when the enemy has casted a spell
	--TODO: Add seperate LUA File for spell list
	if (event == "SPELL_CAST_SUCCESS" and fromEnemy and ((sadb.myself and (fromTarget or fromFocus)) or sadb.enemyinrange) and not sadb.castSuccess) then
	--General
		if ( (spellName == "Every Man for Himself" or spellName == "PvP Trinket") and sadb.trinket) then
			if (sadb.class and currentZoneType == "arena" ) then
				local c = self:ArenaClass(sourceGUID)--destguid
				if c then
				PlaySoundFile(""..sapath..""..c..".mp3");
				self:ScheduleTimer("PlayTrinket", 0.4);
				end
				else
				self:PlayTrinket()
				end
			end
	--	if ((spellName == "Every Man for Himself" or spellName == "PvP Trinket") and sadb.trinketalert and not sadb.chatalerts) then
	--	DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: Trinketted - Cooldown: 2 minutes", 1.0, 0.25, 0.25);
	--	end
		if ((spellName == "Every Man for Himself" or spellName == "PvP Trinket") and sadb.trinketalert and not sadb.chatalerts) then
							if sadb.party then
							SendChatMessage("["..sourceName.."]: Trinketted - Cooldown: 2 minutes", "PARTY", nil, nil)
							end
							if sadb.clientonly then
							DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: Trinketted - Cooldown: 2 minutes", 1.0, 0.25, 0.25);
							end
							if sadb.say then
							SendChatMessage("["..sourceName.."]: Trinketted - Cooldown: 2 minutes", "SAY", nil, nil)
							end
							if sadb.bgchat then
							SendChatMessage("["..sourceName.."]: Trinketted - Cooldown: 2 minutes", "BATTLEGROUND", nil, nil)
							end
		end
		--druid
		--paladin
		--rogue
		--Undead
		if (spellName == "Will of the Forsaken" and sadb.willoftheforsaken) then
			PlaySoundFile(""..sapath.."Will Of The Forsaken.mp3");
		end
		if (spellName == "Dismantle" and sadb.disarm2) then
			PlaySoundFile(""..sapath.."Disarm2.mp3")
		end
		if (spellName == "Kick" and sadb.kick) then
			PlaySoundFile(""..sapath.."kick.mp3")
		end
		if (spellName == "Preparation" and sadb.kick) then
			PlaySoundFile(""..sapath.."preparation.mp3")
		end
		if (spellName == "Vanish" and sadb.stealth) then
				if not sadb.chatalerts then
					if sadb.vanishalert then
							if sadb.party then
							SendChatMessage("["..sourceName.."]: "..sadb.spelltext.." \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
							end
							if sadb.clientonly then
							DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: "..sadb.spelltext.." \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", 1.0, 0.25, 0.25);
							end
							if sadb.say then
							SendChatMessage("["..sourceName.."]: "..sadb.spelltext.." \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
							end
							if sadb.bgchat then
							SendChatMessage("["..sourceName.."]: "..sadb.spelltext.." \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
							end
					PlaySoundFile(""..sapath.."Vanish.mp3")
					end
					if not sadb.vanishalert then
					PlaySoundFile(""..sapath.."Vanish.mp3")
					end
				end
			if sadb.chatalerts then
			PlaySoundFile(""..sapath.."Vanish.mp3")
			end
		end
	--	if (spellName == "Vanish" and sadb.vanish) then -- and (sadb.chatalerts or not sadb.vanishalert)
	--		PlaySoundFile(""..sapath.."Vanish.mp3")
	--	end
	--	if (spellName == "Vanish" and sadb.vanish and sadb.vanishalert and not sadb.chatalerts) then
		--	DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: Casts \124cff71d5ff\124Hspell:1856\124h[Vanish]\124h\124r - Cooldown: 2 minutes", 1.0, 0.25, 0.25);
	--	end
		if (spellName == "Blade Flurry" and sadb.bladeflurry) then
			PlaySoundFile(""..sapath.."Blade Flurry.mp3")
		end
		--if (spellName == "Stealth" and sadb.stealth and (sadb.chatalerts or not sadb.stealthalert)) then
		--	PlaySoundFile(""..sapath.."Stealth.mp3")
		--end
		if (spellName == "Stealth") then
			if not sadb.chatalerts then
					if sadb.stealthalert and sadb.stealth then
							if sadb.party then
							SendChatMessage("["..sourceName.."]: "..sadb.spelltext.." \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
							end
							if sadb.clientonly then
							DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: "..sadb.spelltext.." \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", 1.0, 0.25, 0.25);
							end
							if sadb.say then
							SendChatMessage("["..sourceName.."]: "..sadb.spelltext.." \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
							end
							if sadb.bgchat then
							SendChatMessage("["..sourceName.."]: "..sadb.spelltext.." \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
							end
					PlaySoundFile(""..sapath.."Stealth.mp3")
					end
					if sadb.stealthalert and not sadb.stealth then
							if sadb.party then
							SendChatMessage("["..sourceName.."]: "..sadb.spelltext.." \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
							end
							if sadb.clientonly then
							DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: "..sadb.spelltext.." \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", 1.0, 0.25, 0.25);
							end
							if sadb.say then
							SendChatMessage("["..sourceName.."]: "..sadb.spelltext.." \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
							end
							if sadb.bgchat then
							SendChatMessage("["..sourceName.."]: "..sadb.spelltext.." \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
							end
					end
				if not sadb.stealthalert and sadb.stealth then
				PlaySoundFile(""..sapath.."Stealth.mp3")
				end
			end
			if sadb.chatalerts and sadb.stealth then
			PlaySoundFile(""..sapath.."Stealth.mp3")
			end
		end
		--warrior
		if (spellName == "Disarm" and sadb.disarm) then
			PlaySoundFile(""..sapath.."Disarm.mp3")
		end
		if (spellName == "Intimidating Shout" and sadb.fear3) then
			PlaySoundFile(""..sapath.."Fear3.mp3");
		end
		if (spellName == "Pummel" and sadb.pummel) then
			PlaySoundFile(""..sapath.."pummel.mp3")
		end
		if (spellName == "Shield Bash" and sadb.shieldBash) then
			PlaySoundFile(""..sapath.."Shield Bash.mp3")
		end
		--priest
		if (spellName == "Psychic Scream" and sadb.fear4) then
			PlaySoundFile(""..sapath.."Fear4.mp3");
		end
		if (spellName == "Shadowfiend" and sadb.shadowFiend) then
			PlaySoundFile(""..sapath.."Shadowfiend.mp3")
		end
		if (spellName == "Psychic Horror" and sadb.disarm3) then
			PlaySoundFile(""..sapath.."disarm3.mp3")
		end
		--shaman
		if (spellName == "Grounding Totem" and sadb.grounding) then
			PlaySoundFile(""..sapath.."Grounding.mp3")
		end
		if (spellName == "Mana Tide Totem" and sadb.manaTide) then
			PlaySoundFile(""..sapath.."Mana Tide.mp3");
		end
		if (spellName == "Tremor Totem" and sadb.tremorTotem) then
			PlaySoundFile(""..sapath.."Tremor Totem.mp3");
		end
		--mage
		if (spellName == "Deep Freeze" and sadb.deepFreeze) then
			PlaySoundFile(""..sapath.."Deep Freeze.mp3");
		end
		if (spellName == "Counterspell" and sadb.counterspell) then
			PlaySoundFile(""..sapath.."Counterspell.mp3");
		end
		if (spellName == "Cold Snap" and sadb.ColdSnap) then
			PlaySoundFile(""..sapath.."cold snap.mp3");
		end
		if (spellName == "Invisibility" and sadb.invisibility) then
			PlaySoundFile(""..sapath.."Invisibility.mp3");
		end
		--dk
		if (spellName == "Mind Freeze" and sadb.mindFreeze) then
			PlaySoundFile(""..sapath.."Mind Freeze.mp3")
		end
		if (spellName == "Strangulate" and sadb.strangulate) then
			PlaySoundFile(""..sapath.."Strangulate.mp3");
		end
		if (spellName == "Dancing Rune Weapon" and sadb.runeWeapon) then
			PlaySoundFile(""..sapath.."Rune Weapon.mp3");
		end
		if (spellName == "Summon Gargoyle" and sadb.gargoyle) then
			PlaySoundFile(""..sapath.."gargoyle.mp3");
		end
		if (spellName == "Hungering Cold" and sadb.hungeringCold) then
			PlaySoundFile(""..sapath.."Hungering cold.mp3");
		end
		if (spellName == "Mark of Blood" and sadb.markofblood) then
			PlaySoundFile(""..sapath.."Mark of Blood.mp3");
		end
		--hunter
		if (spellName == "Wyvern Sting" and sadb.wyvernSting) then
			PlaySoundFile(""..sapath.."Wyvern Sting.mp3");
		end
		if (spellName == "Silencing Shot" and sadb.silencingshot) then
			PlaySoundFile(""..sapath.."silencingshot.mp3");
		end
		if (spellName == "Aimed Shot" and sadb.aimedshot) then
			PlaySoundFile(""..sapath.."Aimed Shot.MP3");
		end
		if (spellName == "Readiness" and sadb.readiness) then
			PlaySoundFile(""..sapath.."Readiness.mp3");
		end
		if (spellName == "Freezing Trap" and sadb.freezingtrap) then
			PlaySoundFile(""..sapath.."FreezingTrap.mp3");
		end
		--warlock
		if (spellName == "Howl of Terror" and sadb.fear2) then
			PlaySoundFile(""..sapath.."fear2.mp3");
		end
		if (spellName == "Spell Lock" and sadb.spellLock) then
			PlaySoundFile(""..sapath.."Spell Lock.mp3");
		end
		if (spellName == "Demonic Circle: Teleport" and sadb.demonicCircleTeleport) then
			PlaySoundFile(""..sapath.."Demonic Circle Teleport.mp3");
		end
		if (spellName == "Death Coil" and sadb.deathcoil) then
			PlaySoundFile(""..sapath.."DeathCoil.mp3");
		end
		--paladin
		if (spellName == "Repentance" and sadb.repentance) then
			PlaySoundFile(""..sapath.."Repentance.mp3");
		end
		if (spellName == "Hammer of Justice" and sadb.hammerofjustice) then
			PlaySoundFile(""..sapath.."hammer of justice.mp3");
		end
	end
	if	(spellName == "Blind") then
			if (event == "SPELL_AURA_APPLIED" and (sadb.myself or sadb.enemyinrange) and not sadb.castSuccess) then
				if sadb.blindonenemychat and toEnemy and sadb.blindup then
					if sadb.party then
						if sourceName == playerName and (sadb.myself or sadb.enemyinrange) then
						SendChatMessage("I have casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", "PARTY", nil, nil)
						else
						SendChatMessage("["..sourceName.."]: has casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", "PARTY", nil, nil)
						end
					end
					if sadb.clientonly then
						if sourceName == playerName and (sadb.myself or sadb.enemyinrange) then
						DEFAULT_CHAT_FRAME:AddMessage("I have casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", 1.0, 0.25, 0.25);
						else
						DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: has casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", 1.0, 0.25, 0.25);
						end
					end
					if sadb.say then
						if sourceName == playerName and (sadb.myself or sadb.enemyinrange) then
						SendChatMessage("I have casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", "SAY", nil, nil)
						else
						SendChatMessage("["..sourceName.."]: has casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", "SAY", nil, nil)
						end
					end
					if sadb.bgchat then
						if sourceName == playerName and (sadb.myself or sadb.enemyinrange) then
						SendChatMessage("I have casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", "BATTLEGROUND", nil, nil)
						else
						SendChatMessage("["..sourceName.."]: has casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", "BATTLEGROUND", nil, nil)
						end
					end
				end
					if (sadb.blindonselfchat and fromEnemy) then 
							if destName == playerName and sadb.party and (sadb.myself or sadb.enemyinrange) then
							SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r has been cast on me", "PARTY", nil, nil)
							end
							if destName == playerName and sadb.clientonly and (sadb.myself or sadb.enemyinrange) then
							DEFAULT_CHAT_FRAME:AddMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r has been cast on me", 1.0, 0.25, 0.25);
							end
							if destName == playerName and sadb.say and (sadb.myself or sadb.enemyinrange) then
							SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r has been cast on me", "SAY", nil, nil)
							end
							if destName == playerName and sadb.bgchat and(sadb.myself or sadb.enemyinrange) then
							SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r has been cast on me", "BATTLEGROUND", nil, nil)
							end
					end
					if ((sadb.blindup and toEnemy) or sadb.blind) then
					PlaySoundFile(""..sapath.."Blind.mp3")	
					end
			end
		if (event == "SPELL_AURA_REMOVED" and (sadb.myself or sadb.enemyinrange)) then
				if sadb.blindonenemychat then
					if sadb.party then
						if destName == playerName then
						return
						else
						if fromEnemy then
						SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r down on ["..destName.."]", "PARTY", nil, nil)
						end
						end
					end
					if sadb.clientonly then
						if destName == playerName then
						return
						else
						if fromEnemy then
						DEFAULT_CHAT_FRAME:AddMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r down on ["..destName.."]", 1.0, 0.25, 0.25);
						end
						end
					end
					if sadb.say then
						if destName == playerName then
						return
						else
						if fromEnemy then
						SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r down on ["..destName.."]", "SAY", nil, nil)
						end
						end
					end
					if sadb.bgchat then
						if destName == playerName then
						return
						else
						if fromEnemy then
						SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r down on ["..destName.."]", "BATTLEGROUND", nil, nil)
						end
						end
					end
				end
			if sadb.blinddown and toEnemy then
			PlaySoundFile(""..sapath.."BlindDown.mp3")	
			end
		end
	end
	if (event == "SPELL_INTERRUPT" and toEnemy and not sadb.interrupt) then
		if (spellName == "Deep Freeze" or spellName == "Counterspell" or spellName == "Arcane Torrent" or spellName == "Kick" or spellName == "Wind Shear" or spellName == "Shield Bash" or spellName == "Mind Freeze" ) then
					if not sadb.lockout then
								if not sadb.chatalerts and sadb.interruptalert then
											if sadb.party then
												if sourceName == playerName and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange) then
													SendChatMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
													else
													SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
												end
											end
											if sadb.clientonly then
												if sourceName == playerName and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange) then
												DEFAULT_CHAT_FRAME:AddMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", 1.0, 0.25, 0.25);
												else
												DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: has "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", 1.0, 0.25, 0.25);
												end
											end
											if sadb.say then
												if sourceName == playerName and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange) then
												SendChatMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
												else
												SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
												end
											end
											if sadb.bgchat then
												if sourceName == playerName  and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange) then
												SendChatMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
												else
												SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
												end
											end		
								end
					end
		if sadb.lockout then
				if not sadb.chatalerts and sadb.interruptalert then
					if sadb.party then
						if sourceName == playerName and (sadb.myself or sadb.enemyinrange) then
						SendChatMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
						else
						SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
						end
					end
					if sadb.clientonly then
						if sourceName == playerName and (sadb.myself or sadb.enemyinrange) then
						DEFAULT_CHAT_FRAME:AddMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", 1.0, 0.25, 0.25);
						else
						DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: has "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", 1.0, 0.25, 0.25);
						end
					end
					if sadb.say then
						if sourceName == playerName and (sadb.myself or sadb.enemyinrange) then
						SendChatMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
						else
						SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
						end
					end
					if sadb.bgchat then
						if sourceName == playerName and (sadb.myself or sadb.enemyinrange) then
						SendChatMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
						else
						SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
						end
					end
				end
		PlaySoundFile(""..sapath.."lockout.mp3");			
		end
		end
	end
end
function SoundAlerter:UNIT_AURA(event,uid)
	if (currentZoneType == "arena" and sadb.drinking and toEnemy and ((sadb.myself and fromTarget) or sadb.enemyinrange)) then
		if UnitAura (uid,DRINK_SPELL) then
			PlaySoundFile(""..sapath.."drinking.mp3");
		end
	end
end