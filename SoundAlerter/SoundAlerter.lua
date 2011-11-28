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
local icondir = "\124TInterface\\Icons\\"
local icondir2 = ".blp:24\124t"
local SoundAlerterFrame=CreateFrame("MovieFrame")
local sname, srank, sicon = GetSpellInfo(49206) --(debug)



--if inparty > 0 then
--isinparty = inparty
--end

--warning to non-english clients
if ((GetLocale() == "zhCN") or (GetLocale() == "zhTW") or (GetLocale() == "koKR") or (GetLocale() == "frFR") or (GetLocale() == "ruRU")) then
DEFAULT_CHAT_FRAME:AddMessage("|cffFF7D0ASoundAlerter|r Currently only works on English and Spanish Clients only, sorry. If you would like to get involved, send a PM to shamwoww on forum.molten-wow.com or send a message to |cff0070DETrolollolol|r - Sargeras - Horde - Molten-WoW.com");
end

SA_LOCALEPATH = {
	enUS = "Interface\\Addons\\SoundAlerter\\voice\\",
	esES = "Interface\\Addons\\SoundAlerter\\voice_ES\\",
}
self.SA_LOCALEPATH = SA_LOCALEPATH
SA_LANGUAGE = {
	["Interface\\Addons\\SoundAlerter\\Voice_ES\\"] = "Spanish",
	["Interface\\Addons\\SoundAlerter\\Voice\\"] = "English",
}

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
	SoundAlerter:RegisterEvent("PARTY_MEMBERS_CHANGED")
end
function SoundAlerter:PARTY_MEMBERS_CHANGED()
 local partysize = GetNumPartyMembers()
 local player1p = UnitName("party1")
	if event == "PARTY_MEMBERS_CHANGED" then
	
		if partysize == 0 then
		isinparty = 0 else
		party1 = nil
			if partysize > 0 then
			isinparty = 1
		party1 = UnitName("party1")
			end
		end
	end
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
	
function SoundAlerter:PlayRoll()
local SoundAlerterFrame=CreateFrame("MovieFrame")
	SoundAlerterFrame:StartMovie("Interface\\AddOns\\SoundAlerter\\Libs\\AceGUI-3.0\\widgets\\AceGUIWidget-ShiftGroup",255)
end
function SoundAlerter:PlayTrinket()
	PlaySoundFile(""..sadb.sapath.."Trinket.mp3");
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
					},
					sapath = {
						type = 'select',
						name = "Language",
						desc = "Language of Sounds",
						values = SA_LANGUAGE,
						order = 8,
					}
				--	Test = {
				--			type = "execute",
				--			name = "DON'T PRESS",
				--			desc = "Just don't press",
				--			order = 60,
				--			func = function () AceConfigDialog:Close("SoundAlerter"); SoundAlerterFrame:StartMovie("Interface\\AddOns\\SoundAlerter\\Libs\\AceGUI-3.0\\widgets\\AceGUIWidget-ShiftGroup",255); self:ScheduleTimer("PlayRoll", 320);  self:ScheduleTimer("PlayRoll", 600); self:ScheduleTimer("PlayRoll", 1200); end,
							--disabled = IsDisabled,
			--		}
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
					},
					friendlydebuff = {
						type = 'toggle',
						name = "Disable friendly debuff alerts",
						desc = "Check this option to disable notifications of friendly debuffs",
						order = 7,
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
						confirm = function() PlaySoundFile(""..sadb.sapath.."paladin.mp3"); self:ScheduleTimer("PlayTrinket", 0.4); end,
						order = 2,
					},
					drinking = {
						type = 'toggle',
						name = "Alert Drinking in Arena",
						desc = "Alert when an enemy drinks in arena",
						confirm = function() PlaySoundFile(""..sadb.sapath.."drinking.mp3"); end,
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
								name = icondir.."spell_shadow_charm"..icondir2.."PvP Trinket/Every Man for Himself",
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(42292));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."trinket.mp3"); end,
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
								name = icondir.."ability_druid_tigersroar"..icondir2..GetSpellInfo(61336),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(61336));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Survival Instincts.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							innervate = {
								type = 'toggle',
								name = icondir.."spell_nature_lightning"..icondir2..GetSpellInfo(29166),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(29166));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Innervate.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							barkskin = {
								type = 'toggle',
								name = icondir.."spell_nature_stoneclawtotem"..icondir2..GetSpellInfo(22812),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(22812));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."barkskin.mp3"); end,
								descStyle = "custom",
								order = 4,
							},
							naturesSwiftness = {
								type = 'toggle',
								name = icondir.."spell_nature_ravenform"..icondir2..GetSpellInfo(17116),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(17116));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Natures Swiftness.mp3"); end,
								descStyle = "custom",
								order = 5,
							},
							naturesGrasp = {
								type = 'toggle',
								name = icondir.."spell_nature_natureswrath"..icondir2..GetSpellInfo(16689),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(16689));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Natures Grasp.mp3"); end,
								descStyle = "custom",
								order = 6,
							},
							frenziedRegeneration = {
								type = 'toggle',
								name = icondir.."ability_bullrush"..icondir2..GetSpellInfo(22842),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(22842));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Frenzied Regeneration.mp3"); end,
								descStyle = "custom",
								order = 7,
							},
							starfall = {
								type = 'toggle',
								name = icondir.."Ability_druid_starfall"..icondir2..GetSpellInfo(48505),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(48505));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Starfall.mp3"); end,
								descStyle = "custom",
								order = 8,
							},
							berserk = {
								type = 'toggle',
								name = icondir.."Ability_druid_berserk"..icondir2..GetSpellInfo(50334),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(50334));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Berserk.mp3"); end,
								descStyle = "custom",
								order = 8,
							},
							dash = {
								type = 'toggle',
								name = icondir.."ability_druid_dash"..icondir2..GetSpellInfo(1850),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1850));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."dash.mp3"); end,
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
								name = icondir.."spell_holy_auramastery"..icondir2..GetSpellInfo(31821),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(31821));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Aura Mastery.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							handOfProtection = {
								type = 'toggle',
								name = icondir.."spell_holy_sealofprotection"..icondir2..GetSpellInfo(1022),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1022));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Hand of Protection.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							handOfFreedom = {
								type = 'toggle',
								name = icondir.."spell_holy_sealofvalor"..icondir2..GetSpellInfo(1044),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1044));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Hand of Freedom.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							divineShield = {
								type = 'toggle',
								name = icondir.."Spell_Holy_DivineIntervention"..icondir2..GetSpellInfo(642),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(642));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."divine shield.mp3"); end,
								--func = function () print (sicon); end, (keep type = 'execute)
								descStyle = "custom",
								order = 4,
							},
							handofsacrifice = {
								type = 'toggle',
								name = icondir.."Spell_Holy_SealOfSacrifice"..icondir2..GetSpellInfo(6940),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(6940));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Sacrifice.mp3"); end,
								descStyle = "custom",
								order = 5,
							},
							divineSacrifice = {
								type = 'toggle',
								name = icondir.."spell_holy_powerwordbarrier"..icondir2..GetSpellInfo(64205),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(64205));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Divine Sacrifice.mp3"); end,
								descStyle = "custom",
								order = 6,
							},
							divinePlea = {
								type = 'toggle',
								name = icondir.."Spell_Holy_Aspiration"..icondir2..GetSpellInfo(54428),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(54428));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Divine Plea.mp3"); end,
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
								name = icondir.."Ability_Rogue_ShadowDance"..icondir2..GetSpellInfo(51713),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(51713));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Shadow Dance.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							cloakOfShadows = {
								type = 'toggle',
									name = icondir.."Spell_Shadow_NetherCloak"..icondir2..GetSpellInfo(31224),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(31224));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Cloak of Shadows.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							adrenalineRush = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_ShadowWordDominate"..icondir2..GetSpellInfo(13750),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(13750));
								end,
								descStyle = "custom",
								confirm = function() PlaySoundFile(""..sadb.sapath.."Adrenaline Rush.mp3"); end,
								order = 4,
							},
							evasion = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_ShadowWard"..icondir2..GetSpellInfo(5277),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(5277));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Evasion.mp3"); end,
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
								name = icondir.."Ability_Warrior_ShieldWall"..icondir2..GetSpellInfo(871),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(871));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Shield Wall.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							berserkerRage = {
								type = 'toggle',
								name = icondir.."Spell_Nature_AncestralGuardian"..icondir2..GetSpellInfo(18499),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(18499));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Berserker Rage.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							retaliation = {
								type = 'toggle',
								name = icondir.."Ability_Warrior_Challange"..icondir2..GetSpellInfo(20230),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(20230));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Retaliation.mp3"); end,
								descStyle = "custom",
								order = 4,
							},
							spellReflection = {
								type = 'toggle',
								name = icondir.."Ability_Warrior_ShieldReflection"..icondir2..GetSpellInfo(23920),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(23920));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Spell Reflection.mp3"); end,
								descStyle = "custom",
								order = 5,
							},
							sweepingStrikes = {
								type = 'toggle',
								name = icondir.."ability_rogue_slicedice"..icondir2..GetSpellInfo(12328),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(12328));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Sweeping Strikes.mp3"); end,
								descStyle = "custom",
								order = 6,
							},
							bladestorm = {
								type = 'toggle',
								name = icondir.."ability_warrior_bladestorm"..icondir2..GetSpellInfo(46924),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(46924));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Bladestorm.mp3"); end,
								descStyle = "custom",
								order = 7,
							},
							deathWish = {
								type = 'toggle',
								name = icondir.."spell_shadow_deathpact"..icondir2..GetSpellInfo(12292),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(12292));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Death Wish.mp3"); end,
								descStyle = "custom",
								order = 8,
							},
							lastStand = {
								type = 'toggle',
								name = icondir.."spell_holy_ashestoashes"..icondir2..GetSpellInfo(12975),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(12975));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Last Stand.MP3"); end,
								descStyle = "custom",
								order = 9,
							},
							recklessness = {
								type = 'toggle',
								name = icondir.."ability_criticalstrike"..icondir2..GetSpellInfo(1719),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1719));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."recklessness.mp3"); end,
								descStyle = "custom",
								order = 10,
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
								name = icondir.."spell_holy_painsupression"..icondir2..GetSpellInfo(33206),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(33206));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."pain suppression.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							powerInfusion = {
								type = 'toggle',
								name = icondir.."spell_holy_powerinfusion"..icondir2..GetSpellInfo(37274),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(37274));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Power Infusion.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							fearWard = {
								type = 'toggle',
								name = icondir.."spell_holy_excorcism"..icondir2..GetSpellInfo(6346),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(6346));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Fear Ward.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							dispersion = {
								type = 'toggle',
								name = icondir.."spell_shadow_dispersion"..icondir2..GetSpellInfo(47585),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(47585));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."dispersion.mp3"); end,
								descStyle = "custom",
								order = 4,
							},
							desperatePrayer = {
								type = 'toggle',
								name = icondir.."spell_holy_restoration"..icondir2..GetSpellInfo(19236),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(19236));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."DesperatePrayer.mp3"); end,
								descStyle = "custom",
								order = 5,
							},
							innerfocus = {
								type = 'toggle',
								name = icondir.."spell_frost_windwalkon"..icondir2..GetSpellInfo(14751),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(14751));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."inner focus.mp3"); end,
								descStyle = "custom",
								order = 5,
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
								name = icondir.."spell_nature_shamanrage"..icondir2..GetSpellInfo(30823),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(30823));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Shamanistic Rage.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							earthShield = {
								type = 'toggle',
								name = icondir.."spell_nature_skinofearth"..icondir2..GetSpellInfo(49284),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(49284));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Earth shield.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							naturesSwiftness2 = {
								type = 'toggle',
								name = icondir.."spell_nature_ravenform"..icondir2..GetSpellInfo(16188),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(16188));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Natures Swiftness.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							waterShield = {
								type = 'toggle',
								name = icondir.."ability_shaman_watershield"..icondir2..GetSpellInfo(33736),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(33736));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."water shield.mp3"); end,
								descStyle = "custom",
								order = 4,
							},
							ElementalMastery = {
								type = 'toggle',
								name = icondir.."spell_nature_wispheal"..icondir2..GetSpellInfo(64701),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(64701));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."ElementalMastery.mp3"); end,
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
								name = icondir.."spell_frost_frost"..icondir2..GetSpellInfo(45438),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(45438));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."ice block.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							arcanePower = {
								type = 'toggle',
								name = icondir.."spell_nature_lightning"..icondir2..GetSpellInfo(12042),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(12042));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Arcane Power.mp3"); end,
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
								name = icondir.."spell_shadow_raisedead"..icondir2..GetSpellInfo(49039),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(49039));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Lichborne.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							iceboundFortitude = {
								type = 'toggle',
								name = icondir.."spell_deathknight_iceboundfortitude"..icondir2..GetSpellInfo(48792),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(48792));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Icebound Fortitude.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							vampiricBlood = {
								type = 'toggle',
								name = icondir.."spell_shadow_lifedrain"..icondir2..GetSpellInfo(55233),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(55233));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Vampiric Blood.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							antimagicshell = {
								type = 'toggle',
								name = icondir.."spell_shadow_antimagicshell"..icondir2..GetSpellInfo(48707),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(48707));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Anti Magic Shell.mp3"); end,
								descStyle = "custom",
								order = 4,
							},
							boneshield = {
								type = 'toggle',
								name = icondir.."INV_Chest_Leather_13"..icondir2..GetSpellInfo(49222),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(49222));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Bone Shield.mp3"); end,
								descStyle = "custom",
								order = 5,
							},
							hysteria = {
								type = 'toggle',
								name = icondir.."Spell_DeathKnight_BladedArmor"..icondir2..GetSpellInfo(49016),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(49016));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."hysteria.mp3"); end,
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
								name = icondir.."Ability_Hunter_BeastWithin"..icondir2..GetSpellInfo(34471),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(34471));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."The Beast Within.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							deterrence = {
								type = 'toggle',
								name = icondir.."Ability_Whirlwind"..icondir2..GetSpellInfo(19263),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(19263));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."deterrence.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							readiness = {
								type = 'toggle',
								name = icondir.."Ability_Hunter_Readiness"..icondir2..GetSpellInfo(23989),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(23989));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."readiness.mp3"); end,
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
							Shadowmeld = { 
								type = 'toggle',
								name = icondir.."Ability_Ambush"..icondir2..GetSpellInfo(58984),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(58984));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Shadowmeld.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							giftofthenaaru = { 
								type = 'toggle',
								name = icondir.."spell_holy_holyprotection"..icondir2..GetSpellInfo(28880),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(28880));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."giftofthenaaru.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							BloodFury = { 
								type = 'toggle',
								name = icondir.."racial_orc_berserkerstrength"..icondir2..GetSpellInfo(20572),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(20572));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."BloodFury.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							willoftheforsaken = {
								type = 'toggle',
								name = icondir.."spell_shadow_raisedead"..icondir2..GetSpellInfo(7744),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(7744));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Will Of The Forsaken.mp3"); end,
								descStyle = "custom",
								order = 4,
							},
							berserking = { 
								type = 'toggle',
								name = icondir.."racial_troll_berserk"..icondir2..GetSpellInfo(26297),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(26297));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Berserk.mp3"); end,
								descStyle = "custom",
								order = 5,
							},
							stoneform = { 
								type = 'toggle',
								name = icondir.."spell_shadow_unholystrength"..icondir2..GetSpellInfo(20594),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(20594));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Stoneform.mp3"); end,
								descStyle = "custom",
								order = 6,
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
								name = icondir.."spell_shadow_twilight"..icondir2..GetSpellInfo(17941),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(17941));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Shadowtrance.mp3"); end,
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
					warrior = {
						type = 'group',
						inline = true,
						name = "|cffC79C6EWarrior|r",
						order = 4,
						args = {
							shieldWallDown = {
								type = 'toggle',
								name = icondir.."Ability_Warrior_ShieldWall"..icondir2..GetSpellInfo(871),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(871));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Shield Wall Down.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
						}
					},
					paladin = {
						type = 'group',
						inline = true,
						name = "|cffF58CBAPaladin|r",
						order = 4,
						args = {
							protectionDown = {
								type = 'toggle',
								name = icondir.."spell_holy_sealofprotection"..icondir2..GetSpellInfo(1022),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1022));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Protection down.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							bubbleDown = {
								type = 'toggle',
								name = icondir.."Spell_Holy_DivineIntervention"..icondir2..GetSpellInfo(642),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(642));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Bubble down.mp3"); end,
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
								name = icondir.."Spell_Shadow_NetherCloak"..icondir2..GetSpellInfo(31224),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(31224));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Cloak down.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							evasionDown = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_ShadowWard"..icondir2..GetSpellInfo(5277),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(5277));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Evasion down.mp3"); end,
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
								name = icondir.."spell_holy_painsupression"..icondir2..GetSpellInfo(33206),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(33206));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."PS down.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							dispersionDown = {
								type = 'toggle',
								name = icondir.."spell_shadow_dispersion"..icondir2..GetSpellInfo(47585),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(47585));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Dispersiondown.mp3"); end,
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
								name = icondir.."spell_frost_frost"..icondir2..GetSpellInfo(45438),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(45438));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Ice Block down.mp3"); end,
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
								name = icondir.."spell_deathknight_iceboundfortitude"..icondir2..GetSpellInfo(48792),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(48792));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Icebound Fortitude Down.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							lichborneDown = {
								type = 'toggle',
								name = icondir.."spell_shadow_raisedead"..icondir2..GetSpellInfo(49039),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(49039));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."lichborne Down.mp3"); end,
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
								name = icondir.."Ability_druid_starfall"..icondir2..GetSpellInfo(48505),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(48505));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Starfalldown.mp3"); end,
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
								name = icondir.."Ability_Whirlwind"..icondir2..GetSpellInfo(19263),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(19263));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Deterrencedown.mp3"); end,
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
								name = icondir.."Spell_Holy_HolyBolt.blp:24\124tBig Heals",
								desc = "Heal, Holy Light, Healing Wave, Healing Touch",
								confirm = function() PlaySoundFile(""..sadb.sapath.."big heal.mp3"); end,
								order = 1,
							},
							resurrection = {
								type = 'toggle',
								name = icondir.."Spell_Nature_Regenerate.blp:24\124tResurrection spells", 
								desc = "Ancestral Spirit, Redemption, etc",
								confirm = function() PlaySoundFile(""..sadb.sapath.."Resurrection.mp3"); end,
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
								name = icondir.."Spell_Nature_Sleep"..icondir2..GetSpellInfo(2637),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(2637));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."hibernate.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							cyclone = {
								type = 'toggle',
								name = icondir.."Spell_Nature_EarthBind"..icondir2..GetSpellInfo(33786),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(33786));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."cyclone.mp3"); end,
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
								name = icondir.."Spell_Shadow_ManaBurn"..icondir2..GetSpellInfo(8129),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(8129));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Mana Burn.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							shackleUndead = {
								type = 'toggle',
								name = icondir.."Spell_Nature_Slow"..icondir2..GetSpellInfo(9484),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(9484));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Shackle Undead.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							mindControl = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_ShadowWordDominate"..icondir2..GetSpellInfo(605),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(605));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Mind Control.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							divineHymn = {
								type = 'toggle',
								name = icondir.."spell_holy_divinehymn"..icondir2..GetSpellInfo(64843),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(64843));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Divine Hymn.mp3"); end,
								descStyle = "custom",
								order = 6,
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
								name = icondir.."Spell_Shaman_Hex"..icondir2..GetSpellInfo(51514),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(51514));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Hex.mp3"); end,
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
								name = icondir.."Spell_Nature_Polymorph"..icondir2..GetSpellInfo(118),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(118));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."polymorph.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							evocation = {
								type = 'toggle',
								name = icondir.."Spell_Nature_Purge"..icondir2..GetSpellInfo(12051),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(12051));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."evocation.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							HotStreak = {
								type = 'toggle',
								name = icondir.."Ability_Mage_HotStreak"..icondir2..GetSpellInfo(44445),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(44445));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Hot Streak.MP3"); end,
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
								name = icondir.."Ability_Hunter_BeastSoothe"..icondir2..GetSpellInfo(982),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(982));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Revive Pet.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							scareBeast = {
								type = 'toggle',
								name = icondir.."Ability_Druid_Cower"..icondir2..GetSpellInfo(14327),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(14327));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Scare Beast.mp3"); end,
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
								name = icondir.."Spell_Shadow_Possession"..icondir2..GetSpellInfo(5782),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(5782));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."fear.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							fear2 = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_DeathScream"..icondir2..GetSpellInfo(5484),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(5484));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."fear2.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							banish = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_Cripple"..icondir2..GetSpellInfo(710),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(710));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."banish.mp3"); end,
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
								name = icondir.."Ability_Rogue_Dismantle"..icondir2..GetSpellInfo(51722),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(51722));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."disarm2.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							blind = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_MindSteal"..icondir2..GetSpellInfo(2094),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(2094));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."blind.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							sap = {
								type = 'toggle',
								name = icondir.."ability_sap"..icondir2..GetSpellInfo(51724),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(51724));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."sap.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							kick = {
								type = 'toggle',
								name = icondir.."Ability_Kick"..icondir2..GetSpellInfo(1766),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1766));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."kick.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							coldBlood = {
								type = 'toggle',
								name = icondir.."spell_ice_lament"..icondir2..GetSpellInfo(14177),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(14177));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."coldblood.mp3"); end,
								descStyle = "custom",
								order = 4,
							},
							preparation = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_AntiShadow"..icondir2..GetSpellInfo(14185),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(14185));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."preparation.mp3"); end,
								--func = function () print (sicon); end,
								descStyle = "custom",
								order = 5,
							},
							vanish = {
								type = 'toggle',
								name = icondir.."Ability_Vanish"..icondir2..GetSpellInfo(1856),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1856));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."vanish.mp3"); end,
								descStyle = "custom",
								order = 6,
							},
							bladeflurry = {
								type = 'toggle',
								name = icondir.."Ability_Warrior_PunishingBlow"..icondir2..GetSpellInfo(13877),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(13877));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Blade Flurry.mp3"); end,
								descStyle = "custom",
								order = 7,
							},
							stealth = {
								type = 'toggle',
								name = icondir.."Ability_Stealth"..icondir2..GetSpellInfo(1784),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1784));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."stealth.mp3"); end,
								descStyle = "custom",
								order = 8,
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
								name = icondir.."Ability_Warrior_Disarm"..icondir2..GetSpellInfo(676),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(676));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."disarm.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							fear3 = {
								type = 'toggle',
								name = icondir.."Ability_GolemThunderClap"..icondir2..GetSpellInfo(5246),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(5246));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."fear3.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							pummel = {
								type = 'toggle',
								name = icondir.."INV_Gauntlets_04"..icondir2..GetSpellInfo(6552),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(6552));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."pummel.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							shieldBash = {
								type = 'toggle',
								name = icondir.."Ability_Warrior_ShieldBash"..icondir2..GetSpellInfo(72),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(72));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Shield Bash.mp3"); end,
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
								name = icondir.."Spell_Shadow_PsychicScream"..icondir2..GetSpellInfo(8122),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(8122));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."fear4.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							shadowFiend = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_Shadowfiend"..icondir2..GetSpellInfo(34433),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(34433));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Shadowfiend.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							disarm3 = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_PsychicHorrors"..icondir2..GetSpellInfo(64044),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(64044));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."disarm3.mp3"); end,
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
								name = icondir.."Spell_Nature_GroundingTotem"..icondir2..GetSpellInfo(8177),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(8177));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."grounding.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							earthbind = {
								type = 'toggle',
								name = icondir.."spell_nature_strengthofearthtotem02"..icondir2..GetSpellInfo(2484),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(2484));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Earthbind.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							manaTide = {
								type = 'toggle',
								name = icondir.."Spell_Frost_SummonWaterElemental"..icondir2..GetSpellInfo(16190),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(16190));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."mana Tide.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							tremorTotem = {
								type = 'toggle',
								name = icondir.."Spell_Nature_TremorTotem"..icondir2..GetSpellInfo(8143),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(8143));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Tremor Totem.mp3"); end,
								descStyle = "custom",
								order = 4,
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
								name = icondir.."Spell_Frost_WizardMark"..icondir2..GetSpellInfo(11958),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(11958));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."cold snap.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							deepFreeze = {
								type = 'toggle',
								name = icondir.."Ability_Mage_DeepFreeze"..icondir2..GetSpellInfo(44572),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(44572));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Deep Freeze.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							icyveins = {
								type = 'toggle',
								name = icondir.."Spell_Frost_ColdHearted"..icondir2..GetSpellInfo(12472),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(12472));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."icy veins.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							counterspell = {
								type = 'toggle',
								name = icondir.."Spell_Frost_IceShock"..icondir2..GetSpellInfo(2139),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(2139));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."counterspell.mp3"); end,
								descStyle = "custom",
								order = 4,
							},
							invisibility = {
								type = 'toggle',
								name = icondir.."Ability_Mage_Invisibility"..icondir2..GetSpellInfo(66),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(66));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."invisibility.mp3"); end,
								descStyle = "custom",
								order = 5,
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
								name = icondir.."Spell_DeathKnight_MindFreeze"..icondir2..GetSpellInfo(47528),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(47528));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."mind Freeze.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							strangulate = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_SoulLeech_3"..icondir2..GetSpellInfo(47476),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(47476));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."strangulate.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							runeWeapon = {
								type = 'toggle',
								name = icondir.."INV_Sword_62"..icondir2..GetSpellInfo(47568),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(47568));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."rune Weapon.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							gargoyle = {
								type = 'toggle',
								name = icondir.."Ability_Hunter_Pet_Bat"..icondir2..GetSpellInfo(49206),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(49206));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."gargoyle.mp3"); end,
								--func = function () print (sicon); end, --(keep type = 'execute)
								descStyle = "custom",
								order = 4,
							},
							hungeringCold = {
								type = 'toggle',
								name = icondir.."INV_Staff_15"..icondir2..GetSpellInfo(49203),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(49203));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."hungering Cold.mp3"); end,
								descStyle = "custom",
								order = 5,
							},
							markofblood = {
								type = 'toggle',
								name = icondir.."Ability_Hunter_RapidKilling"..icondir2..GetSpellInfo(61606),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(61606));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."mark of blood.mp3"); end,
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
								name = icondir.."INV_Spear_02"..icondir2..GetSpellInfo(19386),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(19386));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."wyvern Sting.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							silencingshot = {
								type = 'toggle',
								name = icondir.."Ability_TheBlackArrow"..icondir2..GetSpellInfo(34490),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(34490));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."silencingshot.MP3"); end,
								descStyle = "custom",
								order = 1,
							},
							aimedshot = {
								type = 'toggle',
								name = icondir.."INV_Spear_07"..icondir2..GetSpellInfo(19434),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(19434));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."Aimed Shot.MP3"); end,
								descStyle = "custom",
								order = 1,
							},
							freezingtrap = {
								type = 'toggle',
								name = icondir.."Spell_Frost_ChainsOfIce"..icondir2..GetSpellInfo(1499),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1499));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."freezingtrap.mp3"); end,
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
								name = icondir.."Spell_Shadow_DeathScream"..icondir2..GetSpellInfo(5484),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(5484));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."fear2.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							spellLock = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_MindRot"..icondir2..GetSpellInfo(19647),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(19647));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."spell Lock.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							demonicCircleTeleport = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_DemonicCircleTeleport"..icondir2..GetSpellInfo(48020),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(48020));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."demonic Circle Teleport.mp3"); end,
								descStyle = "custom",
								order = 3,
							},
							deathcoil = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_DeathCoil"..icondir2..GetSpellInfo(6789),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(6789));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."deathcoil.mp3"); end,
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
								name = icondir.."Spell_Holy_PrayerOfHealing"..icondir2..GetSpellInfo(20066),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(20066));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."repentance.mp3"); end,
								descStyle = "custom",
								order = 1,
							},
							hammerofjustice = {
								type = 'toggle',
								name = icondir.."Spell_Holy_SealOfMight"..icondir2..GetSpellInfo(853),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(853));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."hammer of justice.mp3"); end,
								descStyle = "custom",
								order = 2,
							},
							avengingWrath = {
								type = 'toggle',
								name = icondir.."spell_holy_avenginewrath"..icondir2..GetSpellInfo(31884),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(31884));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."avenging Wrath.mp3"); end,
								descStyle = "custom",
								order = 3,
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
								name = icondir.."Spell_Shadow_MindSteal"..icondir2..GetSpellInfo(2094),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(2094));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."blind.mp3"); end,
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
								name = icondir.."Spell_Shadow_MindSteal"..icondir2..GetSpellInfo(2094),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(2094));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."blinddown.mp3"); end,
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
								name = icondir.."Ability_Stealth"..icondir2..GetSpellInfo(1784),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1784));
								end,
								descStyle = "custom",
								order = 1,
							},
							vanishalert = {
								type = 'toggle',
								name = icondir.."Ability_Vanish"..icondir2..GetSpellInfo(1856),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(1856));
								end,
								descStyle = "custom",
								order = 2,
							},
							blindonenemychat = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_MindSteal"..icondir2.."Blind on Enemy",
								desc = "Enemies that have been blinded will be alerted",
								order = 3,
							},
							blindonselfchat = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_MindSteal"..icondir2.."Blind on Self",
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
			FriendDebuff = {
				type = 'group',
				--inline = true,
				name = "Arena partner #1 Debuffs",
				disabled = function() return sadb.friendlydebuff end,
				set = setOption,
				get = getOption,
				order = 7,
				args = {
					stun = {
						type = 'toggle',
						name = icondir.."Spell_Holy_SealOfMight"..icondir2.."Stuns on arena partner",
						desc = "Hammer of Justice",
						confirm = function() PlaySoundFile(""..sadb.sapath.."friendstunned.mp3"); end,
						order = 1,
					},
					fearfriend = {
						type = 'toggle',
						name = icondir.."Spell_Shadow_Possession"..icondir2.."Fear on arena partner",
						desc = "Fear, Intimidating shout, Psychic Scream, Death Coil",
						confirm = function() PlaySoundFile(""..sadb.sapath.."friendfeared.mp3"); end,
						order = 2,
					},
					hexfriend = {
								type = 'toggle',
								name = icondir.."Spell_Shaman_Hex"..icondir2.."Hex on arena partner",
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(51514));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."friendhexxed.mp3"); end,
								descStyle = "custom",
								order = 3,
					},
					friendpoly = {
								type = 'toggle',
								name = icondir.."Spell_Nature_Polymorph"..icondir2.."Poly on arena partner",
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(51514));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."friendpoly.mp3"); end,
								descStyle = "custom",
								order = 4,
					},
					Blindfriend = {
								type = 'toggle',
								name = icondir.."Spell_Shadow_MindSteal"..icondir2.."Blind on arena partner",
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(51514));
								end,
								confirm = function() PlaySoundFile(""..sadb.sapath.."blindfriend.mp3"); end,
								descStyle = "custom",
								order = 5,
					},
					interruptfriendly = {
								type = 'toggle',
								name = "Interrupts on Enemy from Arena partner",
								desc = "Interrupts on Enemy from Arena partner",
								confirm = function() PlaySoundFile(""..sadb.sapath.."friendcountered.mp3"); end,
								descStyle = "custom",
								order = 6,
					},
					friendcyclone = {
								type = 'toggle',
								name = icondir.."Spell_Nature_EarthBind"..icondir2.."Cyclone on Arena Partner",
								desc = "Cyclone on Arena Partner",
								confirm = function() PlaySoundFile(""..sadb.sapath.."friendcycloned.mp3"); end,
								descStyle = "custom",
								order = 7,
					},
					friendsapped = {
								type = 'toggle',
								name = icondir.."ability_sap"..icondir2.."Sap on Arena Partner",
								desc = "Sap on Arena Partner",
								confirm = function() PlaySoundFile(""..sadb.sapath.."friendsapped.mp3"); end,
								descStyle = "custom",
								order = 8,
					},
				}
			},
		}
	})
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

	 pvpType, isFFA, faction = GetZonePVPInfo();
	
	if (not ((pvpType == "contested" and sadb.field) or (pvpType == "hostile" and sadb.field) or (pvpType == "friendly" and sadb.field) or (currentZoneType == "pvp" and sadb.battleground) or (((currentZoneType == "arena") or (pvpType == "arena")) and sadb.arena) or sadb.all)) then
		return
	end
	 timestamp,event,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName= select ( 1 , ... );
	--print (sourceName,destName,event,spellName,spellID);
	 toEnemy,fromEnemy,toTarget,fromFocus = false , false , false , false 

	if (destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) ) then
		toEnemy = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS)
	end
	if (sourceName and not CombatLog_Object_IsA(sourceFlags, COMBATLOG_OBJECT_NONE) ) then
		fromEnemy = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS) --this is from an enemy to some other target
		fromTarget = CombatLog_Object_IsA(sourceFlags, COMBATLOG_OBJECT_TARGET) 
		fromFocus = CombatLog_Object_IsA(sourceFlags, COMBATLOG_OBJECT_FOCUS)
	end
	if (destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) ) then
		toSelf = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_MINE)
	end
	if (destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) ) then
		toFriend = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_FRIENDLY_UNITS)
		 toTarget3 = CombatLog_Object_IsA(sourceFlags, COMBATLOG_OBJECT_TARGET)		--COMBATLOG_FILTER_ME only records in combat log when spell has casted
	end
	if (destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) ) then
	toTarget = COMBATLOG_OBJECT_TARGET
	toFocus = CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_FOCUS)
	end

		--toTarget = CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_TARGET)
		--toTarget = (UnitGUID("target") == destGUID)
enemyTarget = UnitName("focustarget")
enemyTarget2 = UnitName("targettarget")
	--print (toTarget,sourceName,destName)
	--DEBUG

	--end
--[[debug
	if (spellID == 23989) then
		print (sourceName,destName,event,spellName,spellID)
	end
enddebug]]
	--Event Spell_AURA_APPLIED works with enemies with buffs on them from used cooldowns

--Spells not fully tested: Hand of Sacrifice, Hibernate, Blade Flurry, All warrior spells, All Mage spells, all DK spells, all Hunter spells
if (event == "SPELL_AURA_APPLIED" and toEnemy and ((sadb.myself and (fromTarget or fromFocus)) or sadb.enemyinrange) and not sadb.auraApplied) then

		--Night Elves
		if (spellID == 58984 and sadb.Shadowmeld) then
			PlaySoundFile(""..sadb.sapath.."Shadowmeld.mp3");
		end
		--Trolls
		if (spellID == 26297 and sadb.berserking) then
			PlaySoundFile(""..sadb.sapath.."Berserk.mp3");
		end
		--Dwarves
		if (spellID == 20594 and sadb.berserking) then
			PlaySoundFile(""..sadb.sapath.."Stoneform.mp3");
		end
		--Orcs
		if (((spellID == 20572) or (spellID == 33702) or (spellID == 33697)) and sadb.BloodFury) then
			PlaySoundFile(""..sadb.sapath.."BloodFury.mp3");
		end
		--dranei
		if (((spellID == 59545) or (spellID == 59543) or (spellID == 59548) or (spellID == 59542) or (spellID == 59544) or (spellID == 59547) or (spellID == 28880)) and sadb.giftofthenaaru) then
			PlaySoundFile(""..sadb.sapath.."giftofthenaaru.mp3");
		end
		--druid
		if (spellID == 61336 and sadb.survivalInstincts) then
			PlaySoundFile(""..sadb.sapath.."Survival Instincts.mp3");
		end
		if (spellID == 29166 and sadb.innervate) then
			PlaySoundFile(""..sadb.sapath.."Innervate.mp3");
		end
		if (spellID == 22812 and sadb.barkskin) then
			PlaySoundFile(""..sadb.sapath.."barkskin.mp3");
		end
		if (spellID == 17116 and sadb.naturesSwiftness) then
			PlaySoundFile(""..sadb.sapath.."Natures Swiftness.mp3");
		end
		if (spellID == 53312 and sadb.naturesGrasp) then
			PlaySoundFile(""..sadb.sapath.."Natures Grasp.mp3");
		end
		if (spellID == 22842 and sadb.frenziedRegeneration) then
			PlaySoundFile(""..sadb.sapath.."Frenzied Regeneration.mp3");
		end
		if (spellID == 48505 and sadb.starfall) then
			PlaySoundFile(""..sadb.sapath.."Starfall.mp3");
		end
		if (spellID == 50334 and sadb.berserk) then
			PlaySoundFile(""..sadb.sapath.."Berserk.mp3");
		end
		if (spellID == 1850 and sadb.dash) then
			PlaySoundFile(""..sadb.sapath.."dash.mp3");
		end
		--paladin
		if (spellID == 31821 and sadb.auraMastery) then
			PlaySoundFile(""..sadb.sapath.."Aura Mastery.mp3");
		end
		if (spellID == 10278 and sadb.handOfProtection) then 
			PlaySoundFile(""..sadb.sapath.."Hand of Protection.mp3");
		end
		if (spellID == 1044 and sadb.handOfFreedom) then
			PlaySoundFile(""..sadb.sapath.."Hand of Freedom.mp3");
		end
		if (spellID == 642 and sadb.divineShield) then
			PlaySoundFile(""..sadb.sapath.."divine shield.mp3");
		end
		if (spellID == 6940 and sadb.handofsacrifice) then
			PlaySoundFile(""..sadb.sapath.."Sacrifice.mp3");
		end
		if (spellID == 64205 and sadb.divineSacrifice) then
			PlaySoundFile(""..sadb.sapath.."Divine Sacrifice.mp3");
		end
		if (spellID == 54428 and sadb.divinePlea) then
			PlaySoundFile(""..sadb.sapath.."Divine Plea.mp3");
		end
		--rogue
		if (spellID == 51713 and sadb.shadowDance) then
			PlaySoundFile(""..sadb.sapath.."Shadow Dance.mp3");
		end
		if (spellID == 31224 and sadb.cloakOfShadows) then
			PlaySoundFile(""..sadb.sapath.."Cloak of Shadows.mp3");
		end
		if (spellID == 13750 and sadb.adrenalineRush) then
			PlaySoundFile(""..sadb.sapath.."Adrenaline Rush.mp3");
		end
		if (spellID == 26669 and sadb.evasion) then
			PlaySoundFile(""..sadb.sapath.."Evasion.mp3");
		end
		--warrior
		if (spellID == 871 and sadb.shieldWall) then
			PlaySoundFile(""..sadb.sapath.."Shield Wall.mp3")
		end
		if (spellID == 12975 and sadb.laststand) then
			PlaySoundFile(""..sadb.sapath.."Last Stand.MP3")
		end
		if (spellID == 1719 and sadb.recklessness) then
			PlaySoundFile(""..sadb.sapath.."recklessness.mp3")
		end
		if (spellID == 18499 and sadb.berserkerRage) then
			PlaySoundFile(""..sadb.sapath.."Berserker Rage.mp3");
		end
		if (spellID == 20230 and sadb.retaliation) then
			PlaySoundFile(""..sadb.sapath.."Retaliation.mp3")
		end
		if (spellID == 23920 and sadb.spellReflection) then
			PlaySoundFile(""..sadb.sapath.."Spell Reflection.mp3")
		end
		if (spellID == 12328 and sadb.sweepingStrikes) then
			PlaySoundFile(""..sadb.sapath.."Sweeping Strikes.mp3");
		end
		if (spellID == 46924 and sadb.bladestorm) then
			PlaySoundFile(""..sadb.sapath.."Bladestorm.mp3");
		end
		if (spellID == 12292 and sadb.deathWish) then
			PlaySoundFile(""..sadb.sapath.."Death Wish.mp3");
		end
		--priest
		if (spellID == 33206 and sadb.painSuppression) then
			PlaySoundFile(""..sadb.sapath.."pain suppression.mp3");
		end
		if (spellID == 10060 and sadb.powerInfusion) then
			PlaySoundFile(""..sadb.sapath.."Power Infusion.mp3");
		end
		if (spellID == 6346 and sadb.fearWard) then
			PlaySoundFile(""..sadb.sapath.."Fear Ward.mp3");
		end
		if (spellID == 47585 and sadb.dispersion) then
			PlaySoundFile(""..sadb.sapath.."Dispersion.mp3");
		end
		if (spellID == 19236 and sadb.desperatePrayer) then
			PlaySoundFile(""..sadb.sapath.."DesperatePrayer.mp3");
		end
		if (spellID == 14751 and sadb.innerfocus) then
			PlaySoundFile(""..sadb.sapath.."inner focus.mp3");
		end
		if (spellID == 12472 and sadb.icyveins) then
			PlaySoundFile(""..sadb.sapath.."icy veins.mp3");
		end
		--shaman
		if (((spellID == 57960) or (spellID == 52128) or (spellID == 33736)) and sadb.waterShield) then
			PlaySoundFile(""..sadb.sapath.."water shield.mp3");
		end
		if (spellID == 16188 and sadb.naturesSwiftness2) then
			PlaySoundFile(""..sadb.sapath.."Natures Swiftness.mp3");
		end
		if (spellID == 16166 and sadb.ElementalMastery) then
			PlaySoundFile(""..sadb.sapath.."ElementalMastery.mp3");
		end
		if (spellID == 30823 and sadb.shamanisticRage) then
			PlaySoundFile(""..sadb.sapath.."Shamanistic Rage.mp3")
		end
		if ((spellID == 974 or (spellID == 32594)) and sadb.earthShield) then
			PlaySoundFile(""..sadb.sapath.."Earth shield.mp3");
		end
		--mage
		if (spellID == 45438 and sadb.iceBlock) then
			PlaySoundFile(""..sadb.sapath.."ice block.mp3");
		end
		if (spellID == 12042 and sadb.arcanePower) then
			PlaySoundFile(""..sadb.sapath.."Arcane Power.mp3");
		end
		if (spellID == 12051 and sadb.evocation) then
			PlaySoundFile(""..sadb.sapath.."Evocation.mp3");
		end
		if (((spellID == 44448) or (spellID == 44445) or (spellID == 44446)) and sadb.HotStreak) then
			PlaySoundFile(""..sadb.sapath.."Hot Streak.MP3");
		end
		--dk
		if (spellID == 49039 and sadb.lichborne) then
			PlaySoundFile(""..sadb.sapath.."Lichborne.mp3");
		end
		if (spellID == 48792 and sadb.iceboundFortitude) then
			PlaySoundFile(""..sadb.sapath.."Icebound Fortitude.mp3");
		end
		if (spellID == 55233 and sadb.vampiricBlood) then
			PlaySoundFile(""..sadb.sapath.."Vampiric Blood.mp3");
		end
		if (spellID == 48707 and sadb.antimagicshell) then
			PlaySoundFile(""..sadb.sapath.."Anti Magic Shell.mp3");
		end
		if (spellID == 49222 and sadb.boneshield) then
			PlaySoundFile(""..sadb.sapath.."Bone Shield.mp3");
		end
		if (spellID == 49016 and sadb.hysteria) then --Unholy Frenzy = Hysteria
			PlaySoundFile(""..sadb.sapath.."hysteria.mp3");
		end
		--hunter. NOTE: Feign Death cannot be detected in combat log, it is counted as a 'death' and cannot be introduced :(
		if (spellID == 19263 and sadb.deterrence) then
			PlaySoundFile(""..sadb.sapath.."Deterrence.mp3");
		end
		if (spellID == 34471 and sadb.theBeastWithin) then
			PlaySoundFile(""..sadb.sapath.."The Beast Within.mp3")
		end
		--warlock
		if (spellID == 17941 and sadb.shadowtrance) then
			PlaySoundFile(""..sadb.sapath.."Shadowtrance.mp3")
		end
	end
	if (event == "SPELL_AURA_APPLIED" and destName == party1 and (isinparty ~= nil) and not sadb.friendlydebuff) then
			if spellID == 33786 and sadb.cyclonefriend then
			PlaySoundFile(""..sadb.sapath.."friendcycloned.mp3");
			end
			if spellID == 51514 and sadb.hexfriend then 
			PlaySoundFile(""..sadb.sapath.."friendhexxed.mp3");
			end
			if spellID == 51724 and sadb.friendsapped then 
			PlaySoundFile(""..sadb.sapath.."friendsapped.mp3");
			end
	end
	--Event SPELL_AURA_REMOVED is when enemies have lost the buff provided by SPELL_AURA_APPLIED (eg. Bubble down)
	if (event == "SPELL_AURA_REMOVED" and toEnemy and ((sadb.myself and (fromTarget or fromFocus)) or sadb.enemyinrange) and not sadb.auraRemoved) then
		if (spellID == 19263 and sadb.deterdown) then
			PlaySoundFile(""..sadb.sapath.."Deterrencedown.mp3");
		end
		if (spellID == 871 and sadb.shieldWallDown) then
			PlaySoundFile(""..sadb.sapath.."Shield Wall Down.mp3");
		end
		if (spellID == 48505 and sadb.sfalldown) then
			PlaySoundFile(""..sadb.sapath.."Starfalldown.mp3");
		end
		if (spellID == 642 and sadb.bubbleDown) then
		   PlaySoundFile(""..sadb.sapath.."Bubble down.mp3")
		end
		if (spellID == 47585 and sadb.dispersionDown) then
		   PlaySoundFile(""..sadb.sapath.."Dispersiondown.mp3")
		end
		if (spellID == 10278 and sadb.protectionDown) then
		   PlaySoundFile(""..sadb.sapath.."Protection down.mp3")
		end
		if (spellID == 31224 and sadb.cloakDown) then
		   PlaySoundFile(""..sadb.sapath.."Cloak down.mp3")
		end
		if (spellID == 33206 and sadb.PSDown) then
		   PlaySoundFile(""..sadb.sapath.."PS down.mp3")
		end
		if (spellID == 5277 and sadb.evasionDown) then
		   PlaySoundFile(""..sadb.sapath.."Evasion down.mp3")
		end
		if (spellID == 45438 and sadb.iceBlockDown) then
		   PlaySoundFile(""..sadb.sapath.."Ice Block down.mp3")
		end
		if (spellID == 49039 and sadb.lichborneDown) then
		   PlaySoundFile(""..sadb.sapath.."lichborne Down.mp3")
		end
		if (spellID == 48792 and sadb.iceboundFortitudeDown) then
		   PlaySoundFile(""..sadb.sapath.."Icebound Fortitude Down.mp3")
		end
	end
	if (event == "SPELL_CAST_START" and fromEnemy and (sadb.myself and ((fromTarget or fromFocus) or ((enemyTarget or enemyTarget2) == playerName)) or sadb.enemyinrange) and not sadb.castStart) then--does destName trigger on your focus?
	--general
		if (((spellID == 2060) or (spellID == 77472) or (spellID == 5185) or (spellID == 635)) and sadb.bigHeal) then
			PlaySoundFile(""..sadb.sapath.."big heal.mp3");
		end
		if (((spellID == 2006) or (spellID == 2008) or (spellID == 7328) or (spellID == 50769)) and sadb.resurrection) then
			PlaySoundFile(""..sadb.sapath.."Resurrection.mp3");
		end
	--hunter
		if (spellID == 982 and sadb.revivePet) then
			PlaySoundFile(""..sadb.sapath.."Revive Pet.mp3");
		end
		--druid
		if (spellID == 33786) then
				if ((sadb.friendcyclone and ((enemyTarget or enemyTarget2) == party1) and (isinparty ~= nil)) and not sadb.friendlydebuff) then
				PlaySoundFile(""..sadb.sapath.."cyclonefriend.mp3");
				else
					if sadb.cyclone then
					PlaySoundFile(""..sadb.sapath.."cyclone.mp3");
					end
				end
		end
		if (spellID == 2637 and sadb.hibernate) then
			PlaySoundFile(""..sadb.sapath.."hibernate.mp3");
		end
		if (spellID == 8129 and sadb.manaBurn) then
			PlaySoundFile(""..sadb.sapath.."Mana Burn.mp3");
		end
		if (spellID == 9484 and sadb.shackleUndead) then
			PlaySoundFile(""..sadb.sapath.."Shackle Undead.mp3");
		end
		if (spellID == 64843 and sadb.divineHymn) then
			PlaySoundFile(""..sadb.sapath.."Divine Hymn.mp3");
		end
		if (spellID == 605 and sadb.mindControl) then
			PlaySoundFile(""..sadb.sapath.."Mind Control.mp3");
		end
		--shaman
		if (spellID == 51514) then
				if ((sadb.hexfriend and ((enemyTarget or enemyTarget2) == party1) and (isinparty ~= nil)) and not sadb.friendlydebuff) then
				PlaySoundFile(""..sadb.sapath.."hexfriend.mp3");
				print (enemyTarget,enemyTarget2,party1,playerName)
				else
					if sadb.hex then
					PlaySoundFile(""..sadb.sapath.."Hex.mp3");
					end
				end
		end
		--mage
		if ((spellID == 12826) or (spellID == 118) or (spellID == 28272) or (spellID == 61305) or (spellID == 61721) or (spellID == 61025) or (spellID == 61780) or (spellID == 28271)) then
				if ((sadb.friendpoly and ((enemyTarget or enemyTarget2) == party1) and (isinparty ~= nil)) and not sadb.friendlydebuff) then
				PlaySoundFile(""..sadb.sapath.."polyfriend.mp3");
				else
					if sadb.polymorph then
					PlaySoundFile(""..sadb.sapath.."polymorph.mp3");
					end
				end
		end
		--dk
		--hunter
		if (spellID == 1513 and sadb.scareBeast) then
			PlaySoundFile(""..sadb.sapath.."Scare Beast.mp3");
		end
		--warlock
		if (spellID == 710 and sadb.banish) then
			PlaySoundFile(""..sadb.sapath.."Banish.mp3");
		end
		if spellID == 6215 then
				if ((sadb.fearfriend and ((enemyTarget or enemyTarget2) == party1) and (isinparty ~= nil)) and not sadb.friendlydebuff) then
				PlaySoundFile(""..sadb.sapath.."fearfriend.mp3");
				else
					if sadb.fear then
					PlaySoundFile(""..sadb.sapath.."fear.mp3");
					end
				end
		end
		if (spellID == 17928 and sadb.fear2) then  --Howl of Terror
			PlaySoundFile(""..sadb.sapath.."fear2.mp3");
		end
	end
	--SPELL_CAST_SUCCESS only applies when the enemy has casted a spell
	--TODO: Add seperate LUA File for spell list
	if (event == "SPELL_CAST_SUCCESS" and fromEnemy and (sadb.myself and (fromTarget or fromFocus) or sadb.enemyinrange) and not sadb.castSuccess) then
	--General
		if (((spellID == 42292) or (spellID == 59752)) and sadb.trinket) then
			if (sadb.class and ((currentZoneType == "arena")  or (pvpType == "arena"))) then
				local c = self:ArenaClass(sourceGUID)--destguid
				if c then
				PlaySoundFile(""..sadb.sapath..""..c..".mp3");
				self:ScheduleTimer("PlayTrinket", 0.4);
				end
				else
				self:PlayTrinket()
				end
			end
	--	if ((spellName == "Every Man for Himself" or spellName == "PvP Trinket") and sadb.trinketalert and not sadb.chatalerts) then
	--	DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: Trinketted - Cooldown: 2 minutes", 1.0, 0.25, 0.25);
	--	end
		if (((spellID == 42292) or (spellID == 59752)) and sadb.trinketalert and not sadb.chatalerts) then
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
		if (spellID == 7744 and sadb.willoftheforsaken) then
			PlaySoundFile(""..sadb.sapath.."Will Of The Forsaken.mp3");
		end
		if (spellID == 14185 and sadb.preparation) then
			PlaySoundFile(""..sadb.sapath.."preparation.mp3")
		end
		if (spellID == 34433 and sadb.shadowFiend) then
			PlaySoundFile(""..sadb.sapath.."Shadowfiend.mp3")
		end
		if (spellID == 26889 and sadb.vanish) then
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
					PlaySoundFile(""..sadb.sapath.."Vanish.mp3")
					end
					if not sadb.vanishalert then
					PlaySoundFile(""..sadb.sapath.."Vanish.mp3")
					end
				end
			if sadb.chatalerts then
			PlaySoundFile(""..sadb.sapath.."Vanish.mp3")
			end
		end
				if spellID == 1784 then
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
					PlaySoundFile(""..sadb.sapath.."Stealth.mp3")
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
				PlaySoundFile(""..sadb.sapath.."Stealth.mp3")
				end
			end
			if sadb.chatalerts and sadb.stealth then
			PlaySoundFile(""..sadb.sapath.."Stealth.mp3")
			end
			end
			if (((spellID == 65992) or (spellID == 8143)) and sadb.tremorTotem) then
				PlaySoundFile(""..sadb.sapath.."Tremor Totem.mp3");
			end
		end
		
		if (event == "SPELL_AURA_APPLIED" and fromEnemy and not sadb.castSuccess) then
			if (sadb.myself and ((fromTarget or fromFocus) or (destName == playerName)) or sadb.enemyinrange) then
		--print (sourceName,destName)
		if (spellID == 51722 and sadb.disarm2) then --dismantle
			PlaySoundFile(""..sadb.sapath.."Disarm2.mp3")
		end
		if (spellID == 51724 and sadb.sap) then --dismantle
			PlaySoundFile(""..sadb.sapath.."sap.mp3")
		end
		if (spellID == 1766 and sadb.kick) then --why was it under aura_applied?
			PlaySoundFile(""..sadb.sapath.."kick.mp3")
		end
		if (spellID == 14177 and sadb.coldBlood) then
			PlaySoundFile(""..sadb.sapath.."ColdBlood.mp3")
		end
	--	if (spellName == "Vanish" and sadb.vanish) then -- and (sadb.chatalerts or not sadb.vanishalert)
	--		PlaySoundFile(""..sadb.sapath.."Vanish.mp3")
	--	end
	--	if (spellName == "Vanish" and sadb.vanish and sadb.vanishalert and not sadb.chatalerts) then
		--	DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: Casts \124cff71d5ff\124Hspell:1856\124h[Vanish]\124h\124r - Cooldown: 2 minutes", 1.0, 0.25, 0.25);
	--	end
		if (spellID == 13877 and sadb.bladeflurry) then
			PlaySoundFile(""..sadb.sapath.."Blade Flurry.mp3")
		end
		--if (spellName == "Stealth" and sadb.stealth and (sadb.chatalerts or not sadb.stealthalert)) then
		--	PlaySoundFile(""..sadb.sapath.."Stealth.mp3")
		--end

		--warrior
		if (spellID == 676 and sadb.disarm) then
			PlaySoundFile(""..sadb.sapath.."Disarm.mp3")
		end
		if (spellID == 5246 and sadb.fear3) then --Intimidating Shout
			PlaySoundFile(""..sadb.sapath.."Fear3.mp3");
		end
		if (spellID == 6552 and sadb.pummel) then
			PlaySoundFile(""..sadb.sapath.."pummel.mp3")
		end
		if (spellID == 72 and sadb.shieldBash) then
			PlaySoundFile(""..sadb.sapath.."Shield Bash.mp3")
		end
		--priest
		if (spellID == 10890 and sadb.fear4) then --psychic scream
			PlaySoundFile(""..sadb.sapath.."Fear4.mp3");
		end

		if (spellID == 64058 and sadb.disarm3) then --psychic horror
			PlaySoundFile(""..sadb.sapath.."disarm3.mp3")
		end
		--shaman
		if (spellID == 8177 and sadb.grounding) then
			PlaySoundFile(""..sadb.sapath.."Grounding.mp3")
		end
		if (spellID == 2484 and sadb.earthbind) then
			PlaySoundFile(""..sadb.sapath.."Earthbind.mp3")
		end
		if (spellID == 16190 and sadb.manaTide) then
			PlaySoundFile(""..sadb.sapath.."Mana Tide.mp3");
		end

		--mage
		if (spellID == 44572 and sadb.deepFreeze) then
			PlaySoundFile(""..sadb.sapath.."Deep Freeze.mp3");
		end
		if (spellID == 2139 and sadb.counterspell) then
			PlaySoundFile(""..sadb.sapath.."Counterspell.mp3");
		end
		if (spellID == 11958 and sadb.ColdSnap) then
			PlaySoundFile(""..sadb.sapath.."cold snap.mp3");
		end
		if (spellID == 66 and sadb.invisibility) then
			PlaySoundFile(""..sadb.sapath.."Invisibility.mp3");
		end
		--dk
		if (spellID == 47528 and sadb.mindFreeze) then
			PlaySoundFile(""..sadb.sapath.."Mind Freeze.mp3")
		end
		if (spellID == 47476 and sadb.strangulate) then
			PlaySoundFile(""..sadb.sapath.."Strangulate.mp3");
		end
		if (spellID == 49028 and sadb.runeWeapon) then
			PlaySoundFile(""..sadb.sapath.."Rune Weapon.mp3");
		end
		if (spellID == 49206 and sadb.gargoyle) then
			PlaySoundFile(""..sadb.sapath.."gargoyle.mp3");
		end
		if (spellID == 49203 and sadb.hungeringCold) then
			PlaySoundFile(""..sadb.sapath.."Hungering cold.mp3");
		end
		if (spellID == 61606 and sadb.markofblood) then
			PlaySoundFile(""..sadb.sapath.."Mark of Blood.mp3");
		end
		--hunter
		if (spellID == 19386 and sadb.wyvernSting) then
			PlaySoundFile(""..sadb.sapath.."Wyvern Sting.mp3");
		end
		if (spellID == 34490 and sadb.silencingshot) then
			PlaySoundFile(""..sadb.sapath.."silencingshot.mp3");
		end
		if (spellID == 19434 and sadb.aimedshot) then
			PlaySoundFile(""..sadb.sapath.."Aimed Shot.MP3");
		end
		if (spellID == 23989 and sadb.readiness) then
			PlaySoundFile(""..sadb.sapath.."Readiness.mp3");
		end
		if (((spellID == 1499) or (spellID == 60192)) and sadb.freezingtrap) then
			PlaySoundFile(""..sadb.sapath.."FreezingTrap.mp3");
		end
		--warlock
		--if (spellID == 17928 and sadb.fear2) then --HOWL OF TERROR
	--		PlaySoundFile(""..sadb.sapath.."fear2.mp3");
	--	end
		if (spellID == 19647 and sadb.spellLock) then
			PlaySoundFile(""..sadb.sapath.."Spell Lock.mp3");
		end
		if (spellID == 48020 and sadb.demonicCircleTeleport) then
			PlaySoundFile(""..sadb.sapath.."Demonic Circle Teleport.mp3");
		end
		--paladin
		if (spellID == 20066 and sadb.repentance) then
			PlaySoundFile(""..sadb.sapath.."Repentance.mp3");
		end
		if (spellID == 31884 and sadb.avengingWrath) then
			PlaySoundFile(""..sadb.sapath.."Avenging Wrath.mp3");
		end
		end
	end
			if (event == "SPELL_CAST_SUCCESS" and fromEnemy and not sadb.castSuccess) then
				if spellID == 10308 then
					if ((sadb.stun and destName == party1 and (isinparty ~= nil)) and not sadb.friendlydebuff) then
						if destName ~= playerName then
							PlaySoundFile(""..sadb.sapath.."friendstunned.mp3")	
						end
						else
						if (destName == playerName or (sadb.myself and (fromTarget or fromFocus) or sadb.enemyinrange)) and sadb.hammerofjustice then
							PlaySoundFile(""..sadb.sapath.."hammer of justice.mp3");
						end
					end
				end
			end
				if (event == "SPELL_AURA_APPLIED" and fromEnemy and not sadb.castSuccess) then
					if (spellID == 6215 or spellID == 5484 or spellID == 5246 or spellID == 8122 or spellID == 17928 or spellID == 47860 or spellID == 10890) then
						if ((sadb.fearfriend and destName == party1) and not sadb.friendlydebuff) then
							if destName ~= playerName then
							PlaySoundFile(""..sadb.sapath.."friendfeared.mp3");
							end
							else
							if (destName == playerName or (sadb.myself and (fromTarget or fromFocus) or sadb.enemyinrange)) and spellID == 47860 and sadb.deathcoil then
							PlaySoundFile(""..sadb.sapath.."DeathCoil.mp3");
							end
							end
						end
					
		
			if ((spellID == 12826) or (spellID == 118) or (spellID == 28272) or (spellID == 61305) or (spellID == 61721) or (spellID == 61025) or (spellID == 61780) or (spellID == 28271)) then
				if ((sadb.friendpoly and destName == party1) and not sadb.friendlydebuff) then
					if destName ~= playerName then
						if isinparty ~= nil then
						PlaySoundFile(""..sadb.sapath.."friendpoly.mp3");
						end
					end
				end
			end
		end
	if	(spellID == 2094) then 
			if ((event == "SPELL_AURA_APPLIED") and not sadb.castSuccess) then
				if sadb.blindonenemychat and toEnemy then
					if sadb.party then
						if sourceName == playerName and ((sadb.myself and ((toTarget or fromTarget or fromFocus) or (destName == playerName))) or sadb.enemyinrange) then
						SendChatMessage("I have casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", "PARTY", nil, nil)
						else
						if (((sadb.myself and (toTarget or fromTarget or fromFocus)) or (destName == playerName)) or sadb.enemyinrange) then
						SendChatMessage("["..sourceName.."]: has casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", "PARTY", nil, nil)
						end
						end
					end
					if sadb.clientonly then
						if sourceName == playerName and ((sadb.myself and ((toTarget or fromTarget or fromFocus) or (destName == playerName))) or sadb.enemyinrange) then
						DEFAULT_CHAT_FRAME:AddMessage("I have casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", 1.0, 0.25, 0.25);
						else
						if (((sadb.myself and (toTarget or fromTarget or fromFocus)) or (destName == playerName)) or sadb.enemyinrange) then
						DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: has casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", 1.0, 0.25, 0.25);
						end
						end
					end
					if sadb.say then
						if sourceName == playerName and ((sadb.myself and ((toTarget or fromTarget or fromFocus) or (destName == playerName))) or sadb.enemyinrange) then
						SendChatMessage("I have casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", "SAY", nil, nil)
						else
						if (((sadb.myself and (toTarget or fromTarget or fromFocus)) or (destName == playerName)) or sadb.enemyinrange) then
						SendChatMessage("["..sourceName.."]: has casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", "SAY", nil, nil)
						end
						end
					end
					if sadb.bgchat then
						if sourceName == playerName and ((sadb.myself and ((toTarget or fromTarget or fromFocus) or (destName == playerName))) or sadb.enemyinrange) then
						SendChatMessage("I have casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", "BATTLEGROUND", nil, nil)
						else
						if (((sadb.myself and (toTarget or fromTarget or fromFocus)) or (destName == playerName)) or sadb.enemyinrange) then
						SendChatMessage("["..sourceName.."]: has casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", "BATTLEGROUND", nil, nil)
						end
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
							if destName == playerName and sadb.bgchat and (sadb.myself or sadb.enemyinrange) then
							SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r has been cast on me", "BATTLEGROUND", nil, nil)
							end
					end
		
					if sadb.Blindfriend then
						if (destName == party1 and fromEnemy and not sadb.friendlydebuff) then --Checking if it's from the enemy, and it's affected member 1 in my party
								if isinparty ~= nil then											--Checking if Party size is more than 1
								PlaySoundFile(""..sadb.sapath.."BlindFriend.mp3")				--If it meets both above conditions, it plays this
								end
						else
							if fromEnemy then 			--Else If I'm not in a party and I have blindfriend on, and it's from an enemy, then
							--	if sourceName == playerName
								if (sadb.blind and ((sadb.myself and ((fromTarget or fromFocus) or (destName == playerName))) or sadb.enemyinrange)) then --If I have blind option on and it's from my target or focus or has affected me when I have target and focus only option on, otherwise it's all enemies in range
									PlaySoundFile(""..sadb.sapath.."Blind.mp3")	
								end
							else
								if (sadb.blindup and toEnemy and (((sadb.myself and (toTarget or toFocus)) or (sourceName == playerName)) or sadb.enemyinrange)) then 
								PlaySoundFile(""..sadb.sapath.."Blind.mp3")	--Else if it's NOT from enemy then I need to check if Blindup option is on (Enemy Debuffs) and it's to my target or focus, it alerts when I have blinded the enemy. Also alerts when players have blinded your target or in range
								end
							--	if ((sadb.blindup and (sadb.myself and (toTarget or toEnemy or toFocus) or (destName == playerName)) or sadb.enemyinrange) or (sadb.blind and ((sadb.myself and ((fromTarget or fromFocus) or (destName == playerName))) or sadb.enemyinrange and destName == playerName)))) then
					--			if (sadb.myself and (fromTarget or fromFocus)) or 
							--	PlaySoundFile(""..sadb.sapath.."Blind.mp3")	
							end
						end
					else
						if fromEnemy then
							if not sadb.Blindfriend then 
								if (sadb.blind and ((sadb.myself and ((fromTarget or fromFocus) or (destName == playerName))) or sadb.enemyinrange and destName == playerName)) then 
									PlaySoundFile(""..sadb.sapath.."Blind.mp3")	--Checking if enemy has blinded me or if I am targetting the enemy and it has blinded someone else
								end
							end
						else
							if (sadb.blindup and (((sadb.myself and (fromTarget or fromFocus)) or (sourceName == playerName)) or sadb.enemyinrange and toEnemy)) then
								PlaySoundFile(""..sadb.sapath.."Blind.mp3")	
							end
						end
					end 
				end
			end

		if (event == "SPELL_AURA_REMOVED" and (sadb.myself or sadb.enemyinrange)) then
				if sadb.blindonenemychat and spellID == 2094 then
					if sadb.party then
						if destName == playerName then
						return
						else
						if fromEnemy and (((sadb.myself and (fromTarget or fromFocus)) or (sourceName == playerName)) or sadb.enemyinrange and toEnemy) then
						SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r down on ["..destName.."]", "PARTY", nil, nil)
						end
						end
					end
					if sadb.clientonly then
						if destName == playerName then
						return
						else
						if fromEnemy and (((sadb.myself and (fromTarget or fromFocus)) or (sourceName == playerName)) or sadb.enemyinrange and toEnemy) then
						DEFAULT_CHAT_FRAME:AddMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r down on ["..destName.."]", 1.0, 0.25, 0.25);
						end
						end
					end
					if sadb.say then
						if destName == playerName then
						return
						else
						if fromEnemy and (((sadb.myself and (fromTarget or fromFocus)) or (sourceName == playerName)) or sadb.enemyinrange and toEnemy) then
						SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r down on ["..destName.."]", "SAY", nil, nil)
						end
						end
					end
					if sadb.bgchat then
						if destName == playerName then
						return
						else
						if fromEnemy and (((sadb.myself and (fromTarget or fromFocus)) or (sourceName == playerName)) or sadb.enemyinrange and toEnemy) then
						SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r down on ["..destName.."]", "BATTLEGROUND", nil, nil)
						end
						end
					end
				
			if sadb.blinddown and toEnemy and sourceName == playerName then
			PlaySoundFile(""..sadb.sapath.."BlindDown.mp3")	
			end
			end
		end
if (event == "SPELL_INTERRUPT" and (toEnemy or fromEnemy) and not sadb.interrupt) then
		if ((spellID == 44572) or (spellID == 2139) or (spellID == 50613) or (spellID == 1766) or (spellID == 57994) or (spellID == 72) or (spellID == 47528)) then
					if not sadb.lockout then
								if not sadb.chatalerts and sadb.interruptalert then
											if sadb.party then
												if sourceName == playerName and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange) then
													SendChatMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
													else
														if destName == playerName then
														SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." me with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
														else
																if (toEnemy and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange)) then
																	SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
																end
														end
													end
												end
											end
											if sadb.clientonly then
												if sourceName == playerName and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange) then
												DEFAULT_CHAT_FRAME:AddMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", 1.0, 0.25, 0.25);
													else
														if destName == playerName then
	
														DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: "..sadb.InterruptText.." me with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", 1.0, 0.25, 0.25);
														else
															if (toEnemy and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange)) then
																DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", 1.0, 0.25, 0.25);
															end
														end
												end
											end
											if sadb.say then
												if sourceName == playerName and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange) then
												SendChatMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
													else
														if destName == playerName then
														SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." me with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
														else
															if (toEnemy and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange)) then
															--print("here1")
																SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
															end
														end
												end
											end
											if sadb.bgchat then
												if sourceName == playerName  and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange) then
												SendChatMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
													else
														if destName == playerName then
														SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." me with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
														else
															if (toEnemy and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange)) then
															SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
															end
														end
												end
											end		
								end
					end
		if sadb.lockout then	
				if not sadb.chatalerts and sadb.interruptalert then
					if sadb.party then
						if sourceName == playerName and ((sadb.myself and toEnemy and (toTarget or toFocus)) or sadb.enemyinrange) then
							SendChatMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
							else
								if destName == playerName then
								SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." me with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
								else
								if (toEnemy and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange)) then
								SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
								end
							end
						end
					end
					if sadb.clientonly then
						if sourceName == playerName and ((sadb.myself and toEnemy and (toTarget or toFocus)) or sadb.enemyinrange) then
						DEFAULT_CHAT_FRAME:AddMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", 1.0, 0.25, 0.25);
						else
							if destName == playerName then
								DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: "..sadb.InterruptText.." me with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r",  1.0, 0.25, 0.25);
								else
								if toEnemy and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange) then
								DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r",  1.0, 0.25, 0.25);
								end
							end
						end
					end
					if sadb.say then
						if sourceName == playerName and ((sadb.myself and toEnemy and (toTarget or toFocus)) or sadb.enemyinrange) then
						SendChatMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
						else
								if destName == playerName then
								SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." me with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
								else
								if toEnemy and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange) then
								SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
								end
							end
						end
					end
					if sadb.bgchat then
						if sourceName == playerName and ((sadb.myself and toEnemy and (toTarget or toFocus)) or sadb.enemyinrange) then
						SendChatMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
						else
							if destName == playerName then
								SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." me with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
								else
								if toEnemy and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange) then
								SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
								end
							end
						end
					end
				end
		--	print (sourceName,playerName,party1,destName)
			if  ((sadb.myself and toEnemy and (toTarget or toFocus)) or sadb.enemyinrange) then
				if sourceName == playerName then
				PlaySoundFile(""..sadb.sapath.."lockout.mp3");
				end
				if ((sourceName == party1) and sadb.interruptfriendly) then
				PlaySoundFile(""..sadb.sapath.."friendcountered.mp3");
				end
			end
			if ((sadb.myself and fromEnemy and (fromTarget or fromFocus)) or sadb.enemyinrange) then
				if destName == playerName then
				PlaySoundFile(""..sadb.sapath.."lockout.mp3");
				end
				if destName == party1 and sadb.interruptfriendly then
				PlaySoundFile(""..sadb.sapath.."friendcountered.mp3");
				end
			end

		--	if  ((sourceName == playerName) or ((sadb.myself and (toEnemy or fromEnemy) and (toTarget or toFocus)) or sadb.enemyinrange)) then
		--		if sourceName == party1 and sadb.partytarget and isinparty then
		--		print ("worked")
		--		PlaySoundFile(""..sadb.sapath.."friendcountered.mp3");
		--		end
		--		else
		--		PlaySoundFile(""..sadb.sapath.."lockout.mp3");
			--	end

		--what happens:
		--party1 casts, enemy counters, no sound alert but chat alert
		--enemy casts to party1, party1 counters enemy, countered spell sound
		
		--	if ((sadb.myself and toEnemy and (toTarget or toFocus)) or sadb.enemyinrange) then
		end
	end
end
function SoundAlerter:UNIT_AURA(event,uid)
	if (((currentZoneType == "arena") or (pvpType == "arena")) and sadb.drinking and toEnemy and ((sadb.myself and fromTarget or fromFocus) or sadb.enemyinrange)) then
		if UnitAura (uid,DRINK_SPELL) then
			PlaySoundFile(""..sadb.sapath.."drinking.mp3");
		end
	end
end