--[[
SoundAlerter by Trolollolol
If you have any issues or concerns with the addon, Send me an ingame message at  Trolollol - Realm:Sargeras Server:Molten-WoW.com
Bugs: Check auraApplied for strangulate
]]

SoundAlerter = LibStub("AceAddon-3.0"):NewAddon("SoundAlerter", "AceEvent-3.0","AceConsole-3.0","AceTimer-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local self , SoundAlerter = SoundAlerter , SoundAlerter
local sadb
local playerName = UnitName("player")
local DRINK_SPELL = GetSpellInfo(57073)
local icondir = "\124TInterface\\Icons\\"
local icondir2 = ".blp:24\124t"



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
	if not self.spellList then
		self.spellList = self:GetSpellList()
	end
	for _,v in pairs(self.spellList) do
		for _,spell in pairs(v) do
			if dbDefaults.profile[spell] == nil then dbDefaults.profile[spell] = true end
		end
	end
	self.db1 = LibStub("AceDB-3.0"):New("sadb",dbDefaults, "Default");
	DEFAULT_CHAT_FRAME:AddMessage("|cffFF7D0ASoundAlerter|r by |cff0070DETrolollolol|r - Sargeras - Molten-WoW.com  - /SOUNDALERTER ");
	--LibStub("AceConfig-3.0"):RegisterOptionsTable("SoundAlerter", SoundAlerter.Options, {"SoundAlerter", "SS"})
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
	if event == "PARTY_MEMBERS_CHANGED" then
		if partysize == 0 then
				if sadb.debugmode then
				print("<SA> Debug: Party Members have changed")
				end
		isinparty = 0 else
		--party1 = nil
			if partysize > 0 then
			isinparty = 1
			party1 = UnitName("party1")
			party2 = UnitName("party2")
			party3 = UnitName("party3")
			party4 = UnitName("party4")
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
function SoundAlerter:PlayTrinket()
	PlaySoundFile(""..sadb.sapath.."Trinket.mp3");
end
function SoundAlerter:Interrupted()
	PlaySoundFile(""..sadb.sapath.."Interrupted.mp3");
end
 function spellOptions2(order, spellID, ...)
	local spellname,_,icon = GetSpellInfo(spellID)
	return {
		type = 'toggle',
		name = "\124T"..icon..":24\124t"..spellname,							
		desc = function () 
			GameTooltip:SetHyperlink(GetSpellLink(spellID));
			--GameTooltip:Show();
		end,
		descStyle = "custom",
		order = order,
	}
end
 function listOptions(spellList, listType, ...)
	local args = {}
	for k,v in pairs(spellList) do
		rawset (args, self.spellList[listType][v] ,spellOptions2(k, v))
	end
	return args
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
					},
					debugmode = {
						type = 'toggle',
						name = "Debug Mode",
						desc = "Enable Debugging",
						order = 9,
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
					aruaApplied = {
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
						name = "Disable enemy cooldown abilities",
						desc = "Disbles sound notifications of cooldown abilities",
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
						name = "Disable Interrupted Spells",
						desc = "Check this option to disable notifications of friendly interrupted spells",
						order = 6,
					},
					ArenaPartner = {
						type = 'toggle',
						name = "Disable Arena Partner debuff/CC alerts",
						desc = "Check this option to disable notifications of Arena Partner debuff/CC alerts",
						order = 7,
					}
				},
			},
			spellAuraApplied = {
				type = 'group',
				--inline = true,
				name = "Enemy Buffs",
				desc = "Alerts you when your enemy gains a buff, or uses a cooldown",
				set = setOption,
				get = getOption,
				disabled = function() return sadb.aruaApplied end,
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
						args = listOptions({61336,29166,22812,17116,53312,22842,53201,50334,1850},"auraApplied"),	
					},
					paladin = {
						type = 'group',
						inline = true,
						name = "|cffF58CBAPaladin|r",
						order = 5,
						args = listOptions({31821,10278,1044,642,6940,64205,54428},"auraApplied")
					},
					rogue = {
						type = 'group',
						inline = true,
						name = "|cffFFF569Rogue|r",
						order = 6,
						args = listOptions({11305,14177,51713,31224,13750,26669},"auraApplied")
					},
					warrior	= {
						type = 'group',
						inline = true,
						name = "|cffC79C6EWarrior|r",
						order = 7,
						args = listOptions({1719,55694,871,12975,18499,20230,23920,12328,46924,12292},"auraApplied")
					},
					priest	= {
						type = 'group',
						inline = true,
						name = "|cffFFFFFFPriest|r",
						order = 8,
						args = listOptions({33206,10060,6346,47585,14751,47788},"auraApplied")
					},
					shaman	= {
						type = 'group',
						inline = true,
						name = "|cff0070DEShaman|r",
						order = 9,
						args = listOptions({30823,974,16188,57960,16166},"auraApplied"),
					},
					mage = {
						type = 'group',
						inline = true,
						name = "|cff69CCF0Mage|r",
						order = 10,
						args = listOptions({45438,12042,12472,12043},"auraApplied"),
					},
					dk	= {
						type = 'group',
						inline = true,
						name = "|cffC41F3BDeath Knight|r",
						order = 11,
						args = listOptions({49039,48792,55233,48707,49222,49016},"auraApplied"),
					},
					hunter = {
						type = 'group',
						inline = true,
						name = "|cffABD473Hunter|r",
						order = 12,
						args = listOptions({34471,19263,34471},"auraApplied"),
					},
					races = {
						type = 'group',
						inline = true,
						name = "|cffFFFFFFGeneral Races|r",
						order = 14,
						args = listOptions({58984,26297,20594,33702,7744,28880},"auraApplied"),
					},
					warlock	= {
						type = 'group',
						inline = true,
						name = "|cff9482C9Warlock|r",
						order = 13,
						args = listOptions({17941},"auraApplied"),
						},
					}
				},
			spellAuraRemoved = {
				type = 'group',
				--inline = true,
				name = "Enemy Buff Down",
				desc = "Alerts you when enemy buffs or used cooldowns are off the enemy",
				set = setOption,
				get = getOption,
				disabled = function() return sadb.aruaRemoved end,
				order = 2,
				args = {
					warrior = {
						type = 'group',
						inline = true,
						name = "|cffC79C6EWarrior|r",
						order = 4,
						args = listOptions({871},"auraRemoved"),
					},
					paladin = {
						type = 'group',
						inline = true,
						name = "|cffF58CBAPaladin|r",
						order = 4,
						args = listOptions({10278,642},"auraRemoved"),
					},
					rogue = {
						type = 'group',
						inline = true,
						name = "|cffFFF569Rogue|r",
						order = 5,
						args = listOptions({31224,26669},"auraRemoved"),
					},
					priest	= {
						type = 'group',
						inline = true,
						name = "|cffFFFFFFPriest|r",
						order = 7,
						args = listOptions({47585,33206},"auraRemoved"),
					},
					mage = {
						type = 'group',
						inline = true,
						name = "|cff69CCF0Mage|r",
						order = 9,
						args = listOptions({45438},"auraRemoved"),
					},
					dk = {
						type = 'group',
						inline = true,
						name = "|cffC41F3BDeath Knight|r",
						order = 10,
						args = listOptions({48792,49039},"auraRemoved"),
					},
					druid = {
						type = 'group',
						inline = true,
						name = "|cffFF7D0ADruid|r",
						order = 11,
						args = listOptions({53201},"auraRemoved"),
					},
					hunter = {
						type = 'group',
						inline = true,
						name = "|cffABD473Hunter|r",
						order = 12,
						args = listOptions({19263},"auraRemoved"),
					},
				}
			},
			spellCastStart = {
				type = 'group',
				--inline = true,
				name = "Enemy Spell Casting",
				desc = "Alerts you when an enemy is attempting to cast a spell on you or another player",
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
								order = 1,
							},
							resurrection = {
								type = 'toggle',
								name = icondir.."Spell_Nature_Regenerate.blp:24\124tResurrection spells", 
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
						args = listOptions({2637,33786},"castStart"),
					},
					priest	= {
						type = 'group',
						inline = true,
						name = "|cffFFFFFFPriest|r",
						order = 6,
						args = listOptions({8129,9484,64843,605},"castStart"),
					},
					shaman	= {
						type = 'group',
						inline = true,
						name = "|cff0070DEShaman|r",
						order = 7,
						args = listOptions({51514},"castStart"),
						},
					hunter = {
						type = 'group',
						inline = true,
						name = "|cffABD473Hunter|r",
						order = 10,
						args = listOptions({982,14327},"castStart"),
					},
					warlock	= { --fear/howlofterror/banish
						type = 'group',
						inline = true,
						name = "|cff9482C9Warlock|r",
						order = 9,
						args = listOptions({6215,17928,710,712},"castStart"),
					},
					mage = {
						type = 'group',
						inline = true,
						name = "|cff69CCF0Mage|r",
						order = 8,
						args = listOptions({118},"castStart"),
					},
				
				},
			},
			spellCastSuccess = {
				type = 'group',
				--inline = true,
				name = "Enemy Cooldown Abilities",
				desc = "Alerts you when enemies have used cooldowns",
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
						args = listOptions({51722,51724,2094,1766,14185,26889,13877,1784},"castSuccess"),
					},
					warrior	= {
						type = 'group',
						inline = true,
						name = "|cffC79C6EWarrior|r",
						order = 5,
						args = listOptions({2457,2458,71,676,5246,6552,72},"castSuccess"),
					},
					priest	= {
						type = 'group',
						inline = true,
						name = "|cffFFFFFFPriest|r",
						order = 6,
						args = listOptions({10890,34433,64044,48173},"castSuccess"),
					},
					shaman	= {
						type = 'group',
						inline = true,
						name = "|cff0070DEShaman|r",
						order = 7,
						args = listOptions({8143,16190,2484,8177},"castSuccess"),
					},
					mage = {
						type = 'group',
						inline = true,
						name = "|cff69CCF0Mage|r",
						order = 8,
						args = listOptions({44445,12051,44572,11958,2139,66},"castSuccess"),
					},
					dk	= {
						type = 'group',
						inline = true,
						name = "|cffC41F3BDeath Knight|r",
						order = 9,
						args = listOptions({47528,47476,47568,49206,49203,61606},"castSuccess"),
					},
					hunter = {
						type = 'group',
						inline = true,
						name = "|cffABD473Hunter|r",
						order = 10,
						args = listOptions({23989,19386,34490,49050,14311,13810},"castSuccess"),
					},
					warlock = {
						type = 'group',
						inline = true,
						name = "|cff9482C9Warlock|r",
						order = 11,
						args = listOptions({19647,48020,47860},"castSuccess"),
					},
					paladin = {
						type = 'group',
						inline = true,
						name = "|cffF58CBAPaladin|r",
						order = 11,
						args = listOptions({20066,10308,31884},"castSuccess"),
					},
				},
			},
		enemydebuff = {
				type = 'group',
				--inline = true,
				name = "Enemy Debuff",
				desc = "Alerts you when you (or your arena partner) have casted a CC on an enemy",
				disabled = function() return sadb.enemydebuff end,
				set = setOption,
				get = getOption,
				order = 4,
				args = {
						fromself = {
						type = 'group',
						inline = true,
						name = "|cffFFF569From Self|r",
						order = 1,
						args = listOptions({2094,51724,51514,12826,118,33786},"enemyDebuffs"),
					},
					fromarenapartner = {
						type = 'group',
						inline = true,
						name = "|cffFFF569From Arena Partner or affecting your Target|r",
						order = 2,
						args = listOptions({2094,51724,51514,12826,118,33786},"friendCCenemy"),
					}
				},
			},
			enemydebuffdown = {
				type = 'group',
				--inline = true,
				name = "Enemy Debuff Down",
				desc = "Alerts you when your (or your arena partner) casted CC's on an enemy is down",
				disabled = function() return sadb.enemydebuffdown end,
				set = setOption,
				get = getOption,
				order = 5,
				args = {
						fromself = {
						type = 'group',
						inline = true,
						name = "|cffFFF569From Self|r",
						order = 1,
						args = listOptions({2094,51724,51514,12826,118,33786},"enemyDebuffdown"),
					},
						fromarenapartner = {
						type = 'group',
						inline = true,
						name = "|cffFFF569From Arena Partner or affecting your Target|r",
						desc = "Alerts you if your arena partner casts a spell or your target gets afflicted by a spell",
						order = 2,
						args = listOptions({2094,51724,51514,12826,118,33786},"friendCCenemyDown"),
					}
				},
			},
			chatalerter = {
				type = 'group',
				--inline = true,
				name = "Chat Alerts",
				desc = "Alerts you and others via sending a chat message",
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
						order = 7,
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
								name = icondir.."Ability_Vanish"..icondir2..GetSpellInfo(26889),
								desc = function ()
									GameTooltip:SetHyperlink(GetSpellLink(26889));
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
								order = 4,
							},
							sapalert = {
								type = 'toggle',
								name = icondir.."ability_sap"..icondir2.."Sap on Self or Friend",
								desc = "Enemies that have blinded you will be alerted",
								order = 5,
							},
						},
					},
					paladin = {
					type = 'group',
					inline = true,
					name = "|cffF58CBAPaladin|r",
					order = 6,
					args = {
							bubblealert = {
							type = 'toggle',
							name = icondir.."Spell_Holy_DivineIntervention"..icondir2.."Divine Shield",
							desc = "Enemies that have casted Divine Shield will be alerted",
							order = 1,
							},
							bubblealerttext = {
							type = 'input',
							name = icondir.."Spell_Holy_DivineIntervention"..icondir2.."Divine Shield Text",
							desc = "Example: [PlayerName]: Bubbled!",
							order = 2,
							},
						},
					},
					general = {
						type = 'group',
						inline = true,
						name = "|cffFFFFFFGeneral|r",
						order = 8,
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
						order = 9,
						width = full,
					},
					spelltext = {
						type = "input",
						name = "Vanish/Stealth Casting Text",
						desc = "Example: Casted = [PlayerName] Casted [Vanish/Stealth]",
						order = 10,
						width = full,
					},
					saptext = {
						type = "input",
						name = "Sap text - if you're sapped",
						order = 11,
						width = full,
					},
					saptextfriend = {
						type = "input",
						name = "Sap text - if your arena partner is sapped",
						desc = "Example: [PlayerName] is sapped!",
						order = 11,
						width = full,
					}
				},
			},
			spellInterrupt = {
				type = 'group',
				--inline = true,
				name = "Interrupts",
				desc = "Alerts you when you get interrupted, or interrupt someone",
				disabled = function() return sadb.interrupt end,
				set = setOption,
				get = getOption,
				order = 6,
				args = {
					lockout = {
						type = 'toggle',
						name = "Say 'countered' when you interrupt or get interrupted",
						desc = "Example: Countered",
						confirm = function() PlaySoundFile(""..sadb.sapath.."lockout.mp3");end,
						order = 1,
					},
				}
			},
			FriendDebuff = {
				type = 'group',
				--inline = true,
				name = "Arena partner Enemy Spell Casting",
				desc = "Alerts you when an enemy is casting a spell targetted at your arena partner",
				disabled = function() return sadb.ArenaPartner end,
				set = setOption,
				get = getOption,
				order = 8,
				args = listOptions({51514,118,33786,6215},"friendCCs"),
			},
			FriendDebuffSuccess = {
			type = 'group',
			name = "Arena partner CCs/Debuffs",
			desc = "Alerts you when your arena partner gets CC'd",
			disabled = function() return sadb.ArenaPartner end,
			set = setOption,
			get = getOption,
			order = 9,
			args = listOptions({14309,2094,10308,51514,12826,33786,6215,2139,51724},"friendCCSuccess"),
			}
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
	if (IsAddOnLoaded("SpellAlerter")) or (IsAddOnLoaded("SunnArt")) then
	print("|cffFF7D0ASoundAlerter|r detected that you have SpellAlerter or SunnArt loaded. Use /soundalerter or /salerter instead of /sa")
	self:RegisterChatCommand("SoundAlerter", "ShowConfig")
	self:RegisterChatCommand("SALERTER", "ShowConfig")
	else
	self:RegisterChatCommand("SoundAlerter", "ShowConfig")
	self:RegisterChatCommand("SALERTER", "ShowConfig")
	self:RegisterChatCommand("sa", "ShowConfig")
	end
end
function SoundAlerter:PlaySpell(list, spellID, ...)
	if list[spellID] then
		if not sadb[list[spellID]] then return	end
		PlaySoundFile(sadb.sapath..list[spellID]..".mp3");
		if sadb.debugmode then
		print("<SA> DEBUG: Playing sound file: "..list[spellID]..".mp3");
		end
	end
end

function SoundAlerter:COMBAT_LOG_EVENT_UNFILTERED(event , ...)

local _,currentZoneType = IsInInstance()
local pvpType, isFFA, faction = GetZonePVPInfo();
	if (not ((pvpType == "contested" and sadb.field) or (pvpType == "hostile" and sadb.field) or (pvpType == "friendly" and sadb.field) or (currentZoneType == "pvp" and sadb.battleground) or (((currentZoneType == "arena") or (pvpType == "arena")) and sadb.arena) or sadb.all)) then
		return
	end
	local timestamp,event,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName= select ( 1 , ... );
	local toSelf,toEnemy,fromEnemy,toTarget,fromFocus = false , false , false , false , false

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
	--toTarget = COMBATLOG_OBJECT_TARGET
	toTarget = (UnitGUID("target") == destGUID)
	toFocus = CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_FOCUS)
	end

local focusTarget = UnitName("focustarget")
local enemyTarget2 = UnitName("targettarget")
local arena1 = UnitName("arena1target")
local arena2 = UnitName("arena2target")
local arena3 = UnitName("arena3target")
local arena4 = UnitName("arena4target")
local arena5 = UnitName("arena5target")
local myTarget = UnitName("target")
local myFocus = UnitName("focus")
--[[debug
	if (spellName == "Wyvern Sting") then
		print (sourceName,destName,event,spellName,spellID)
	end
enddebug]]
	if (event == "SPELL_AURA_APPLIED" and not sadb.castSuccess) then
								if toEnemy and (spellID == 33786 or spellID == 2094 or spellID == 51724 or spellID == 12826 or spellID == 118 or spellID == 51514) and not sadb.enemydebuff then
									if (sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange then
										if sourceName == playerName then
										self:PlaySpell (self.spellList.enemyDebuffs,spellID)
										end
										if sourceName ~= playerName and myTarget == destName then
											if sadb.debugmode then
											print(myTarget,destName,sourceName,playerName)
											end
										self:PlaySpell (self.spellList.friendCCenemy,spellID)
										end
									end
								end
						if (spellID == 14309 --[[freezingtrap]]or spellID == 33786 --[[cyclone]] or spellID == 5246--[[intimidatingshout]] or spellID == 2094 or spellID == 118 or spellID == 12826 or spellID == 10308 or spellID == 5246 or spellID == 17928 or spellID == 51724 or spellID == 33786 or spellID == 10308 or spellID == 2139 or spellID == 51514 or spellID == 12826 or spellID ==  6215 or spellID == 10890) then
							if ((currentZoneType ~= "arena" and currentZoneType ~= nil) or (pvpType ~= "arena" and pvpType ~= nil)) then
								if fromEnemy and destName ~= playerName and toFriend and ((myTarget == destName) or (myFocus == destName) or (focusTarget == destName)) and not sadb.ArenaPartner then
								self:PlaySpell (self.spellList.friendCCSuccess,spellID) 
								end
								if toSelf and destName == playerName and (spellID == 6215 or spellID == 33786 or spellID == 118 or spellID == 12826 or spellID == 51514) and (myTarget ~= sourceName) and (myFocus ~= sourceName) then
								self:PlaySpell (self.spellList.castStart,spellID) 
								end
								if sadb.myself and toSelf and myTarget ~= sourceName and not fromFocus and (spellID == 14309 or spellID == 5246 or spellID == 2094 or spellID == 17928 or spellID == 51724 or spellID == 10308 or spellID == 2139 or spellID == 10890) then
								self:PlaySpell (self.spellList.castSuccess,spellID)
								end
							else
							if ((currentZoneType == "arena") or (pvpType == "arena")) then
								if toSelf and destName == playerName and myTarget ~= sourceName and myFocus ~= sourceName and (spellID == 33786 or spellID == 118 or spellID == 12826 or spellID == 51514) then
								self:PlaySpell (self.spellList.castStart,spellID) 
								end
								if sadb.myself and toSelf and destName == playerName and myTarget ~= sourceName and not fromFocus and (spellID == 14309 or spellID == 5246 or spellID == 2094 or spellID == 10308 or spellID == 5246 or spellID == 17928 or spellID == 51724 or spellID == 33786 or spellID == 10308 or spellID == 2139 or spellID == 12826 or spellID ==  6215 or spellID == 10890) then
								self:PlaySpell (self.spellList.castSuccess,spellID)
								end
								if toFriend and ((currentZoneType == "arena") or (pvpType == "arena")) and destName ~= playerName and (spellID == 118 or spellID == 14309 or spellID == 33786 --[[cyclone]] or spellID == 5246--[[fear]] or spellID == 51514 or spellID == 2094 or spellID == 51724 or spellID == 33786 or spellID == 10308 or spellID == 2139 or spellID == 51514 or spellID == 12826 or spellID == 6215 or spellID == 10890) and not sadb.ArenaPartner then
								self:PlaySpell (self.spellList.friendCCSuccess,spellID) 
								end	
							end
							end
						else
						if sadb.myself and toSelf and myTarget ~= sourceName and (spellID == 44572 or spellID == 72 or spellID == 20066 or spellID == 13810 or spellID == 34490--[[silencingshot]] or spellID == 47476 --[[strangulate]]or spellID == 1766 or spellID == 51722 --[[dismantle]] or spellID == 2094 or spellID == 61606 or spellID == 19386 or spellID == 49010 or spellID == 49050 or spellID == 19434) and not fromFocus then
						self:PlaySpell (self.spellList.castSuccess,spellID) 
						else
						if spellID == 51724 and toFriend and isinparty ~= nil and ((myTarget == destName) or (myFocus == destName)) and not sadb.ArenaPartner then
						self:PlaySpell (self.spellList.friendCCSuccess,spellID) 
						else
						if fromEnemy and ((sadb.myself and ((myTarget == sourceName) or fromFocus)) or sadb.enemyinrange) and (--[[races]]spellID == 58984 or spellID == 26297 or spellID == 20594 or spellID == 20572 or spellID == 33702 or spellID == 7744 or spellID == 28880 --[[/races, druid]]or spellID == 61336 or spellID == 29166 or spellID == 22812 or spellID == 17116 or spellID == 53312 or spellID == 53201 or spellID == 22842 or spellID == 53201 or spellID == 50334 or spellID == 1850 --[[/druid, paladin]]or spellID == 31821 or spellID == 10278 or spellID == 1044 or spellID == 642 or spellID == 6940 or spellID == 64205 or spellID == 54428 --[[/paladin, rogue]]or spellID == 51713 or spellID == 31224 or spellID == 13750 or spellID == 26669 or spellID == 14177 or spellID == 11305 --[[/rogue, warrior]]or spellID == 55694 or spellID == 1719 or spellID == 871 or spellID == 12975 or spellID == 18499 or spellID == 20230 or spellID == 23920 or spellID == 12328 or spellID == 46924 or spellID == 12292--[[/warrior, priest]] or spellID == 33206 or spellID == 10060 or spellID == 6346 or spellID == 47585 or spellID == 14751 or spellID == 47788 --[[/priest, shaman]]or spellID == 30823 or spellID == 974 or spellID == 16188 or spellID == 33736 or spellID == 16166 or spellID == 57960--[[/shaman,mage]] or spellID == 45438 or spellID == 12042 or spellID == 12472 or spellID == 12043--[[/mage, DK]] or spellID == 49039 or spellID == 48792 or spellID == 55233 or spellID == 48707 or spellID == 49222 or spellID == 49016 --[[/dk, hunter]] or spellID == 34471 or spellID == 19263 --[[hunter, lock]] or spellID == 17941) then
						self:PlaySpell (self.spellList.auraApplied,spellID) 
						end
						end	
			end
		end
	end
	if (event == "SPELL_AURA_REMOVED" and not sadb.aruaRemoved) then
		if toEnemy and (spellID == 871 or spellID == 10278 or spellID == 642 or spellID == 31224 or spellID == 26669 or spellID == 33206 or spellID == 47585 or spellID == 45438 or spellID == 48792 or spellID == 49039 or spellID == 53201 or spellID == 19263 or spellID == 34471) then
			if ((sadb.myself and (fromTarget or fromFocus)) or sadb.enemyinrange) then
			self:PlaySpell (self.spellList.auraRemoved,spellID)
			end
		end
			if toEnemy and (spellID == 33786 or spellID == 2094 or spellID == 51724 or spellID == 12826 or spellID == 118 or spellID == 51514) and not sadb.enemydebuff then
					if sourceName == playerName then
					self:PlaySpell (self.spellList.enemyDebuffdown,spellID)
					end
					if sourceName ~= playerName and myTarget == destName then
					self:PlaySpell (self.spellList.friendCCenemyDown,spellID)
					end
			end
	end
	if (event == "SPELL_CAST_START" and fromEnemy and (sadb.myself and ((myTarget == sourceName) or fromFocus or (focusTarget ~= playerName) or (enemyTarget2 ~= playerName)) or (sadb.enemyinrange and ((focusTarget ~= playerName) or (enemyTarget2 ~= playerName)))) and not sadb.castStart) then
		if (spellID == 48782 or spellID == 30146 or spellID == 2060 or spellID == 635 or spellID == 49273 or spellID == 5185 or spellID == 2006 or spellID == 7328 or spellID == 2008 or spellID == 50769 or spellID == 2637 or spellID == 33786 or spellID == 8129 or spellID == 9484 or spellID == 64843 or spellID == 605 or spellID == 51514 or spellID == 118 or spellID == 12826 or spellID == 28272 or spellID == 28272 or spellID == 61305 or spellID == 61721 or spellID == 61025 or spellID == 61780 or spellID == 28271 or spellID == 982 or spellID == 14327 or spellID == 6215 or spellID == 17928 or spellID == 710 or spellID == 688 or spellID == 691 or spellID == 712 or spellID == 697) then
			if ((currentZoneType == "arena") or (pvpType == "arena")) and (spellID == 33786 or spellID == 51514 or spellID == 12826 or spellID == 118 or spellID == 28272 or spellID == 61305 or spellID == 61721 or spellID == 61025 or spellID == 61780 or spellID == 28271 or spellID == 6215) and not sadb.ArenaPartner then
				if isinparty ~= nil and isinparty ~= 0 and (arena1 ~= playerName and arena2 ~= playerName and arena3 ~= playerName and arena4 ~= playerName and arena5 ~= playerName) and not sadb.ArenaPartner then
					if sadb.debugmode then
					print(arena1,arena2,spellName)
					end
					self:PlaySpell (self.spellList.friendCCs,spellID)
				end
				if (focusTarget == playerName or enemyTarget2 == playerName or arena1 == playerName or arena2 == playerName or arena3 == playerName or arena4 == playerName or arena5 == playerName) and not sadb.ArenaPartner then
				self:PlaySpell (self.spellList.castStart,spellID)
				end
			else
				if ((sadb.myself and ((myTarget == sourceName) or fromFocus)) or sadb.enemyinrange) and (spellID == 48782 or spellID == 2060 or spellID == 635 or spellID == 49273 or spellID == 5185) and sadb.bigHeal then
				self:PlaySpell (self.spellList.castStart,spellID)
				else
				if ((sadb.myself and ((myTarget == sourceName) or fromFocus)) or sadb.enemyinrange) and (spellID == 7328 or spellID == 2008 or spellID == 2006 or spellId == 50769) and sadb.resurrection then
				self:PlaySpell (self.spellList.castStart,spellID)
				else
				if ((sadb.myself and ((myTarget == sourceName) or fromFocus)) or sadb.enemyinrange) then
				self:PlaySpell (self.spellList.castStart,spellID)
				end
				end
				end
			end
		end
	end
	if (event == "SPELL_CAST_SUCCESS" and fromEnemy and ((sadb.myself and (fromTarget or fromFocus)) or sadb.enemyinrange) and not sadb.castSuccess) then
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
--Trinket Chat Alerts
		if (((spellID == 42292) or (spellID == 59752)) and sadb.trinketalert and not sadb.chatalerts) then
							if sadb.party then
							SendChatMessage("["..sourceName.."]: Trinketted", "PARTY", nil, nil)
							end
							if sadb.clientonly then
							DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: Trinketted", 1.0, 0.25, 0.25);
							end
							if sadb.say then
							SendChatMessage("["..sourceName.."]: Trinketted", "SAY", nil, nil)
							end
							if sadb.bgchat then
							SendChatMessage("["..sourceName.."]: Trinketted", "BATTLEGROUND", nil, nil)
							end
		end
			if spellID == 642 and sadb.bubblealert and not sadb.chatalerts then
							if sadb.party then
							SendChatMessage("["..sourceName.."]: "..sadb.bubblealerttext.."", "PARTY", nil, nil)
							end
							if sadb.clientonly then
							DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: "..sadb.bubblealerttext.."", 1.0, 0.25, 0.25);
							end
							if sadb.say then
							SendChatMessage("["..sourceName.."]: "..sadb.bubblealerttext.."", "SAY", nil, nil)
							end
							if sadb.bgchat then
							SendChatMessage("["..sourceName.."]: "..sadb.bubblealerttext.."", "BATTLEGROUND", nil, nil)
							end
			end
--Vanish Chat Alerts
		if (spellID == 26889) then
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
					end
				end
		end
--Stealth Chat Alerts
			if spellID == 1784 then
				if not sadb.chatalerts then
					if sadb.stealthalert then
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
						self:PlaySpell (self.spellList.castSuccess,spellID)
					end
				end
			end
	end
	--SPELL_CAST_SUCCESS means that spell cast was successfull, not interrupted, but still can be missed on a player (refer to aura_applied)
			if ((event == "SPELL_CAST_SUCCESS") and not sadb.castSuccess) then
				if (spellID == 2139 or spellID == 72 or spellID == 1766 or spellID == 47528 or spellID == 2094 or spellID == 51724 or spellID == 48173 or spellID == 10890 or spellID == 33786 or spellID == 10308 or spellID == 51514 or spellID == 12826 or spellID == 6215 or spellID == 12051 or spellID == 11958 or spellID == 44445 or spellID == 66 or spellID == 47476 or spellID == 47568 or spellID == 49206 or spellID == 49203 or spellID == 61606 or spellID == 23989 or spellID == 19386 or spellID == 49010 or spellID == 34490 or spellID == 19434 or spellID == 49050 or spellID == 60192 or spellID == 14311 or spellID == 17928 or spellID == 19647 or spellID == 48020 or spellID == 47860 or spellID == 20066 or spellID == 31884 or spellID == 51722 or spellID == 14185 or spellID == 26889 or spellID == 13877 or spellID == 8143 or spellID == 65992 or spellID == 16190 or spellID == 2484 or spellID == 8177 or spellID == 676 or spellID == 5246 or spellID == 6552 or spellID == 2457 or spellID == 71 or spellID == 2458 or spellID == 34433 or spellID == 64044) then				
						if ((((sadb.myself and ((fromFocus and fromEnemy) or ((sourceName == myTarget) and fromEnemy))) or sadb.enemyinrange and fromEnemy) or (toSelf and spellID == 51724) or (toSelf and fromEnemy)) and not sadb.castSuccess) then
							if toFriend and (spellID == 2139 or spellID == 2094 or spellID == 51724 or spellID == 33786 or spellID == 10308 or spellID == 51514 or spellID == 12826 or spellID ==  6215 or spellID == 10890) then
								if ((currentZoneType == "arena") or (pvpType == "arena")) and isinparty ~= nil and not sadb.ArenaPartner then
								self:PlaySpell (self.spellList.friendCCsuccess,spellID)
								end
								if ((currentZoneType ~= "arena") or (pvpType ~= "arena")) and isinparty ~= nil then
									if myTarget == destName and destName ~= playerName and isinparty ~= nil and isinparty ~= 0 then
									self:PlaySpell (self.spellList.friendCCsuccess,spellID)
									end
								end
							else
							if fromEnemy and ((sadb.myself and (myTarget == sourceName) or (myFocus == sourceName)) or sadb.enemyinrange) then
							self:PlaySpell (self.spellList.castSuccess,spellID)
							end
							end
						end
				end
		end
		if fromEnemy and event == "SPELL_CREATE" and spellID == 13809 and ((sadb.myself and ((myTarget == sourceName) or (myFocus == sourceName))) or sadb.enemyinrange) then
		self:PlaySpell (self.spellList.castSuccess,spellID)
		end
--Sap Chat Alerts
	if ((spellID == 51724) and (event == "SPELL_AURA_APPLIED") and ((sadb.myself and ((toTarget or fromTarget or fromFocus) or ((toSelf) or destName ~= playerName))) or sadb.enemyinrange)) then --We cannot know if it came from a friend or enemy
			if sadb.sapalert and not sadb.chatalerts then
				if toSelf and sadb.party then 
				SendChatMessage(sadb.saptext, "PARTY", nil, nil)
				end
				if destName ~= playerName and toFriend and ((currentZoneType == "arena") or (pvpType == "arena")) and sadb.party and sourceName ~= playerName then 
				SendChatMessage(destName.." "..sadb.saptextfriend, "PARTY", nil, nil)
				end
				if toSelf and sadb.clientonly then
				DEFAULT_CHAT_FRAME:AddMessage(sadb.saptext, 1.0, 0.25, 0.25);
				end
				if destName ~= playerName and toFriend and ((currentZoneType == "arena") or (pvpType == "arena")) and sadb.clientonly and sourceName ~= playerName then 
				DEFAULT_CHAT_FRAME:AddMessage(destName.." "..sadb.saptextfriend, 1.0, 0.25, 0.25);
				end
				if toSelf and sadb.say then
				SendChatMessage(sadb.saptext, "SAY", nil, nil)
				end
				if destName ~= playerName and toFriend and ((currentZoneType == "arena") or (pvpType == "arena")) and sadb.say and sourceName ~= playerName then 
				SendChatMessage(destName.." "..sadb.saptextfriend, "SAY", nil, nil)
				end
				if toSelf and sadb.bgchat then
				SendChatMessage(sadb.saptext, "BATTLEGROUND", nil, nil)
				end
			end
	end 
--Blind Chat Alerts
			if spellID == 2094 and ((event == "SPELL_AURA_APPLIED") and ((sadb.myself and (toTarget or fromTarget or fromFocus)) or sadb.enemyinrange) and not sadb.castSuccess) then
				if sadb.blindonenemychat and (toEnemy or fromEnemy) and not sadb.chatalerts then
					if sadb.party then
						if sourceName == playerName or ((sourceName == party1 or sourceName == party2 or sourceName == party3 or sourceName == party4) and ((currentZoneType == "arena") or (pvpType == "arena"))) then
						SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r up on ["..destName.."]", "PARTY", nil, nil)
						end
						if toSelf then
						SendChatMessage("["..sourceName.."]: Blinded me!", "PARTY", nil, nil)
						end
						if fromEnemy and ((currentZoneType == "arena") or (pvpType == "arena")) and destName ~= playerName and isinparty ~= nil then
						SendChatMessage("["..sourceName.."]: has casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", "PARTY", nil, nil)
						end
					end
					if sadb.clientonly then
						if sourceName == playerName or ((sourceName == party1 or sourceName == party2 or sourceName == party3 or sourceName == party4) and ((currentZoneType == "arena") or (pvpType == "arena"))) then
						DEFAULT_CHAT_FRAME:AddMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r up on ["..destName.."]", 1.0, 0.25, 0.25);
						end
						if toSelf then
						DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: Blinded me!", 1.0, 0.25, 0.25);
						end
						if fromEnemy and ((currentZoneType == "arena") or (pvpType == "arena")) and destName ~= playerName and isinparty ~= nil then
						DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: has casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", 1.0, 0.25, 0.25);
						end
					end
					if sadb.say then
						if sourceName == playerName or ((sourceName == party1 or sourceName == party2 or sourceName == party3 or sourceName == party4) and ((currentZoneType == "arena") or (pvpType == "arena"))) then
						SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r up on ["..destName.."]", "SAY", nil, nil)
						end
						if toSelf then
						SendChatMessage("["..sourceName.."]: Blinded me!", "SAY", nil, nil)
						end
						if fromEnemy and ((currentZoneType == "arena") or (pvpType == "arena")) and destName ~= playerName and isinparty ~= nil then
						SendChatMessage("["..sourceName.."]: has casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", "SAY", nil, nil)
						end
					end
					if sadb.bgchat then
						if ((sourceName == playerName) or (sourceName == myFocus)) and toEnemy then
						SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r up on ["..destName.."]", "BATTLEGROUND", nil, nil)
						end
						if toSelf then
						SendChatMessage("["..sourceName.."]: Blinded me!", "BATTLEGROUND", nil, nil)
						end
						if fromEnemy and ((currentZoneType == "arena") or (pvpType == "arena")) and destName ~= playerName and isinparty ~= nil then
						SendChatMessage("["..sourceName.."]: has casted \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r on ["..destName.."]", "	BATTLEGROUND", nil, nil)
						end
					end
				end
			end
	if (event == "SPELL_AURA_REMOVED" and (sadb.myself or sadb.enemyinrange) and sourceName == playerName) then
				if sadb.blindonenemychat and spellID == 2094 and not sadb.chatalerts then
					if sadb.party then
						SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r down on ["..destName.."]", "PARTY", nil, nil)
					end
					if sadb.clientonly then
						DEFAULT_CHAT_FRAME:AddMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r down on ["..destName.."]", 1.0, 0.25, 0.25);
					end
					if sadb.say then
						SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r down on ["..destName.."]", "SAY", nil, nil)
					end
					if sadb.bgchat then
						SendChatMessage("\124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r down on ["..destName.."]", "BATTLEGROUND", nil, nil)
					end
			end
		end
if (event == "SPELL_INTERRUPT" and (toEnemy or fromEnemy) and not sadb.interrupt) then
		if (spellID == 44572 --[[deepfreeze]]or spellID == 2139--[[counterspell]] or spellID == 50613--[[arcanetorrent]] or spellID == 57994--[[windshear]] or spellID == 72--[[shieldbash]] or spellID == 47528--[[mindfreeze]] or spellID == 1766) --[[kick]]then
					if toSelf or ((sadb.myself and toEnemy and (toTarget or toFocus)) or sadb.enemyinrange) then
						if (sourceName == playerName) or (toSelf and sadb.lockout) then
							PlaySoundFile(""..sadb.sapath.."lockout.mp3");
						end
						if fromEnemy and toFriend and not sadb.ArenaPartner and sadb.lockout then
						self:PlaySpell (self.spellList.interruptFriend,spellID)
						end
					end	
	
			if toSelf or (sadb.myself and (toEnemy or ((fromEnemy and (fromTarget or fromFocus)) or (toEnemy and (toTarget or toFocus)))) or sadb.enemyinrange) then
				if not sadb.chatalerts and sadb.interruptalert then -- Event>Targetting>Spell>Options
					if sadb.party then
						if sourceName == playerName and ((sadb.myself and toEnemy and (toTarget or toFocus)) or sadb.enemyinrange) then
							SendChatMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
							else
								if toSelf then
								SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." me with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
								else
								--if (toEnemy and ((sadb.myself and (toTarget or toFocus)) or sadb.enemyinrange)) then
								if ((currentZoneType == "arena") or (pvpType == "arena")) and ((destName ~= playerName) or (sourceName ~= playerName)) and isinparty ~= nil then
								SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "PARTY", nil, nil)
								end
							end
						end
					end
					if sadb.clientonly then
						if sourceName == playerName and ((sadb.myself and toEnemy and (toTarget or toFocus)) or sadb.enemyinrange) then
						DEFAULT_CHAT_FRAME:AddMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", 1.0, 0.25, 0.25);
						else
							if toSelf then
								DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: "..sadb.InterruptText.." me with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r",  1.0, 0.25, 0.25);
								else
								if ((currentZoneType == "arena") or (pvpType == "arena")) and ((destName ~= playerName) or (sourceName ~= playerName)) and isinparty ~= nil then
								DEFAULT_CHAT_FRAME:AddMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r",  1.0, 0.25, 0.25);
								end
							end
						end
					end
					if sadb.say then
						if sourceName == playerName and ((sadb.myself and toEnemy and (toTarget or toFocus)) or sadb.enemyinrange) then
						SendChatMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
						else
								if toSelf then
								SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." me with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
								else
								if ((currentZoneType == "arena") or (pvpType == "arena")) and ((destName ~= playerName) or (sourceName ~= playerName)) and isinparty ~= nil then
								SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "SAY", nil, nil)
								end
							end
						end
					end
					if sadb.bgchat then
						if sourceName == playerName and ((sadb.myself and toEnemy and (toTarget or toFocus)) or sadb.enemyinrange) then
						SendChatMessage(""..sadb.InterruptText.." ["..destName.."]: with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
						else
							if toSelf then
								SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." me with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
								else
								if ((currentZoneType == "arena") or (pvpType == "arena")) and ((destName ~= playerName) or (sourceName ~= playerName)) and isinparty ~= nil then
								SendChatMessage("["..sourceName.."]: "..sadb.InterruptText.." ["..destName.."]:  with \124cff71d5ff\124Hspell:"..spellID.."\124h["..spellName.."]\124h\124r", "BATTLEGROUND", nil, nil)
								end
							end
						end
					end
				end
			end
		end
	end
end
--Drink Spell in Arenas
function SoundAlerter:UNIT_AURA(event,uid)
	if ((currentZoneType == "arena") or (pvpType == "arena")) and sadb.drinking and toEnemy then
		if UnitAura (uid,DRINK_SPELL) then
			PlaySoundFile(""..sadb.sapath.."drinking.mp3");
		end
	end
end