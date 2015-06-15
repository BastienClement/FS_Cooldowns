local LGIST = LibStub:GetLibrary("LibGroupInSpecT-1.1")
local FSCD  = LibStub("AceAddon-3.0"):NewAddon("FSCooldowns", "AceEvent-3.0", "AceConsole-3.0", "AceComm-3.0")
local Media = LibStub("LibSharedMedia-3.0")

--------------------------------------------------------------------------------

local function dump(t)
	local print_r_cache = {}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						print(indent.."["..pos.."] => "..tostring(t).." {")
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
						print(indent..string.rep(" ",string.len(pos)+6).."}")
					elseif (type(pos)=="table") then
						print(indent.."["..tostring(pos).."] => "..tostring(t).." {")
						sub_print_r(pos,indent..string.rep(" ",string.len(tostring(pos))+8))
						print(indent..string.rep(" ",string.len(tostring(pos))+6).."}")
					else
						print(indent.."["..tostring(pos).."] => "..tostring(val))
					end
				end
			else
				print(indent..tostring(t))
			end
		end
	end
	sub_print_r(t," ")
end

--------------------------------------------------------------------------------

local order = 0
local function getOrder()
	order = order + 1
	return order
end

local class_colors = {
	[1]  = {0.78, 0.61, 0.43, "c79c6e"}, -- Warrior
	[2]  = {0.96, 0.55, 0.73, "f58cba"}, -- Paladin
	[3]  = {0.67, 0.83, 0.45, "abd473"}, -- Hunter
	[4]  = {1.00, 0.96, 0.41, "fff569"}, -- Rogue
	[5]  = {1.00, 1.00, 1.00, "ffffff"}, -- Priest
	[6]  = {0.77, 0.12, 0.23, "c41f3b"}, -- Death Knight
	[7]  = {0.00, 0.44, 0.87, "0070de"}, -- Shaman
	[8]  = {0.41, 0.80, 0.94, "69ccf0"}, -- Mage
	[9]  = {0.58, 0.51, 0.79, "9482c9"}, -- Warlock
	[10] = {0.33, 0.54, 0.52, "00ff96"}, -- Monk
	[11] = {1.00, 0.49, 0.04, "ff7d0a"}, -- Druid
}

local cooldowns = {
-- Paladin
--[[	[20473] = { -- Holy Shock
		cooldown = 6,
		spec = 65,
		class = 2,
		order = getOrder()
	},]]
	[31821] = { -- Devotion Aura
		cooldown = 180,
		duration = 6,
		spec = 65,
		class = 2,
		order = getOrder()
	},
	[31842] = { -- Avenging Wrath (Holy)
		cooldown = 180,
		duration = function(player)
			return player.talents[17599] and 30 or 20
		end,
		spec = 65,
		class = 2,
		order = getOrder()
	},
	[6940] = { -- Hand of Sacrifice
		cooldown = 120,
		duration = 12,
		charges = function(player)
			return player.talents[17593] and 2 or 1
		end,
		class = 2,
		order = getOrder()
	},
	[1022] = { -- Hand of Protection
		cooldown = 300,
		duration = 10,
		charges = function(player)
			return player.talents[17593] and 2 or 1
		end,
		class = 2,
		order = getOrder()
	},
	[114039] = { -- Hand of Purity
		cooldown = 30,
		duration = 6,
		talent = 17589,
		class = 2,
		order = getOrder()
	},
-- Priest
	[62618] = { -- Power Word: Barrier
		cooldown = 180,
		duration = 10,
		spec = 256,
		class = 5,
		order = getOrder()
	},
	[33206] = { -- Pain Suppression
		cooldown = 180,
		duration = 8,
		spec = 256,
		class = 5,
		order = getOrder()
	},
	[64843] = { -- Divine Hymn
		cooldown = 180,
		duration = 8,
		spec = 257,
		class = 5,
		order = getOrder()
	},
	[47788] = { -- Guardian Spirit
		cooldown = 180,
		duration = 10,
		spec = 257,
		class = 5,
		order = getOrder()
	},
	[15286] = { -- Vampiric Embrace
		cooldown = 180,
		duration = 15,
		spec = 258,
		class = 5,
		order = getOrder()
	},
-- Druid
	[740] = { -- Tranquility
		cooldown = 180,
		duration = 8,
		spec = 105,
		class = 11,
		order = getOrder()
	},
	[102342] = { -- Ironbark
		cooldown = 60,
		duration = 12,
		spec = 105,
		class = 11,
		order = getOrder()
	},
	[106898] = { -- Stampeding Roar
		cooldown = 120,
		duration = 8,
		class = 11,
		order = getOrder()
	},
	[124974] = { -- Nature's Vigil
		cooldown = 90,
		duration = 30,
		talent = 18586,
		class = 11,
		order = getOrder()
	},
-- Shaman
	[98008] = { -- Spirit Link Totem
		cooldown = 180,
		duration = 6,
		charges = function(player)
			return player.talents[19273] and 2 or 1
		end,
		spec = 264,
		class = 7,
		order = getOrder()
	},
	[108280] = { -- Healing Tide Totem
		cooldown = 180,
		duration = 10,
		spec = 264,
		class = 7,
		order = getOrder()
	},
	[114052] = { -- Ascendance
		cooldown = 180,
		duration = 15,
		spec = 264,
		class = 7,
		order = getOrder()
	},
	[8143] = { -- Tremor Totem
		cooldown = 60,
		duration = 10,
		class = 7,
		order = getOrder()
	},
	[108281] = { -- Ancestral Guidance
		cooldown = 120,
		duration = 10,
		talent = 19269,
		class = 7,
		order = getOrder()
	},
 -- Monk
	[116849] = { -- Life Cocoon
		cooldown = 100,
		duration = 12,
		spec = 270,
		class = 10,
		order = getOrder()
	},
	[115310] = { -- Revival
		cooldown = 180,
		spec = 270,
		class = 10,
		order = getOrder()
	},
--[[	[115072] = { -- Expel Harm
		cooldown = 15,
		duration = 5,
		spec = 270,
		class = 10,
		order = getOrder()
	},]]
-- Death Knight
	[51052] = { -- Anti-Magic Zone
		cooldown = 120,
		duration = 3,
		talent = 19219,
		class = 6,
		order = getOrder()
	},
	[108199] = { -- Gorefiend's Grasp
		cooldown = 60,
		talent = 19230,
		class = 6,
		order = getOrder()
	},
-- Warrior
	[97462] = { -- Rallying Cry
		cooldown = 180,
		duration = 10,
		spec = { 71, 72 },
		class = 1,
		order = getOrder()
	},
	[114030] = { -- Vigilance
		cooldown = 120,
		duration = 12,
		talent = 19676,
		class = 1,
		order = getOrder()
	},
	[3411] = { -- Intervene
		cooldown = 30,
		duration = 10,
		class = 1,
		order = getOrder()
	},
-- Mage
	[159916] = { -- Amplify Magic
		cooldown = 120,
		duration = 6,
		class = 8,
		order = getOrder()
	},
-- Rogue
	[76577] = { -- Smoke Bomb
		cooldown = 180,
		duration = 5,
		class = 4,
		order = getOrder()
	},
-- Hunter
	[172106] = { -- Aspect of the Fox
		cooldown = 180,
		duration = 6,
		class = 3,
		order = getOrder()
	},
}

--------------------------------------------------------------------------------

local cooldowns_list = {}
do
	for id in pairs(cooldowns) do
		table.insert(cooldowns_list, id)
	end
	table.sort(cooldowns_list, function(a, b)
		local a, b = cooldowns[a], cooldowns[b]
		return a.order < b.order
	end)
end

local cooldowns_idx = {}
local roster = {}

local displays = {}

local players_available = {}

--------------------------------------------------------------------------------

local defaults = {
	profile = {
		groups = {
			["**"] = {
				position = { "TOPLEFT", nil, "TOPLEFT", 250, -250 },
				size = 24,
				border = 1,
				spacing = 2,
				attach = "LEFTDOWN",
				texture = "Blizzard",
				missing = true,
				charges = true,
				cooldowns = {},
				unlocked = false
			}
		}
	}
}

local settings

local config = {
	type = "group",
	args = {
		groups = {
			name = "Display groups",
			type = "group",
			args = {
				["$New"] = {
					order = 0,
					name = "New group name",
					type = "input",
					get = function() return "" end,
					set = function(_, name) FSCD:CreateDisplayGroup(name) end
				},
			}
		}
	}
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("FS Cooldowns", config, "fsrc")

function FSCD:OnInitialize()
	LGIST.RegisterCallback(self, "GroupInSpecT_Update", "RosterUpdate")
	LGIST.RegisterCallback(self, "GroupInSpecT_Remove", "RosterRemove")
	
	self:RegisterChatCommand("fsc", function()
		LibStub("AceConfigDialog-3.0"):Open("FS Cooldowns")
	end)
	
	self.db = LibStub("AceDB-3.0"):New("FSCooldownsSettings", defaults, true)
	config.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	settings = self.db.profile
	
	self.db.RegisterCallback(self, "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("ENCOUNTER_END")
	
	self:RegisterComm("FSCD", "OnCommReceived")
	
	C_Timer.NewTicker(2, function()
		local one_changed = false
		for lku, available in pairs(players_available) do
			if not UnitExists(lku) then
				players_available[lku] = nil
			else
				local a = UnitIsVisible(lku) and not UnitIsDeadOrGhost(lku)
				if a ~= available then
					players_available[lku] = a
					one_changed = true
				end
			end
		end
		
		if one_changed then
			FSCD:RefreshAllCooldowns()
		end
	end)
	
	for name in pairs(settings.groups) do
		self:CreateDisplayGroup(name)
	end
end

function FSCD:OnProfileChanged()
	for name in pairs(displays) do
		self:RemoveDisplayGroup(name, true)
	end
	
	settings = self.db.profile
	
	for name in pairs(settings.groups) do
		self:CreateDisplayGroup(name)
	end
end

function FSCD:CreateDisplayGroup(name)
	if displays[name] then return end
	
	-- Create settings entry
	if not settings.groups[name] then
		settings.groups[name] = {}
	end
	
	-- Create config entry
	local group = {
		name = name,
		type = "group",
		args = {
			unlock = {
				order = 1,
				name = "Display anchor",
				type = "toggle",
				get = function() return settings.groups[name].unlocked end,
				set = function(_, value)
					settings.groups[name].unlocked = value
					FSCD:RebuildDisplay(name)
				end
			},
			remove = {
				order = 2,
				name = "Delete group",
				type = "execute",
				func = function()
					FSCD:RemoveDisplayGroup(name)
				end
			},
			void1 = {
				order = 3,
				name = "\n",
				type = "description"
			},
			size = {
				order = 10,
				name = "Icon size",
				min = 16,
				max = 64,
				type = "range",
				step = 1,
				get = function() return settings.groups[name].size end,
				set = function(_, value)
					settings.groups[name].size = value
					FSCD:RebuildDisplay(name)
				end
			},
			border = {
				order = 11,
				name = "Border size",
				min = 0,
				max = 5,
				type = "range",
				step = 1,
				get = function() return settings.groups[name].border end,
				set = function(_, value)
					settings.groups[name].border = value
					FSCD:RebuildDisplay(name)
				end
			},
			spacing = {
				order = 12,
				name = "Spacing",
				min = 0,
				max = 50,
				type = "range",
				step = 1,
				get = function() return settings.groups[name].spacing end,
				set = function(_, value)
					settings.groups[name].spacing = value
					FSCD:RebuildDisplay(name)
				end
			},
			attach = {
				order = 13,
				name = "Attach - Grow",
				type = "select",
				values = {
					LEFTDOWN = "Left - Down",
					LEFTUP = "Left - Up",
					RIGHTDOWN = "Right - Down",
					RIGHTUP = "Right - Up",
				},
				get = function() return settings.groups[name].attach end,
				set = function(_, value)
					settings.groups[name].attach = value
					FSCD:RebuildDisplay(name)
				end
			},
			texture = {
				order = 14,
				name = "Texture",
				type = "select",
				width = "double",
				dialogControl = "LSM30_Statusbar",
				values = Media:HashTable("statusbar"),
				get = function() return settings.groups[name].texture end,
				set = function(_, value)
					settings.groups[name].texture = value
					FSCD:RebuildDisplay(name)
				end
			},
			void2 = {
				order = 20,
				name = "\n",
				type = "description"
			},
			missing = {
				order = 21,
				name = "Display missing cooldowns",
				type = "toggle",
				width = "full",
				get = function() return settings.groups[name].missing end,
				set = function(_, value)
					settings.groups[name].missing = value
					FSCD:RebuildDisplay(name)
				end
			},
			missingDesc = {
				order = 22,
				name = "Display cooldown icon even if nobody in the group can use it",
				type = "description"
			},
			charges = {
				order = 23,
				name = "Display charges",
				type = "toggle",
				width = "full",
				get = function() return settings.groups[name].charges end,
				set = function(_, value)
					settings.groups[name].charges = value
					FSCD:RefreshAllCooldowns()
				end
			},
			chargesDesc = {
				order = 24,
				name = "Display charges count next to the player's name if more than one charge of the cooldown is available",
				type = "description"
			},
			voidx = {
				order = 100,
				name = "\n",
				type = "description"
			},
			--[[cooldowns = {
				order = 10,
				name = "Cooldowns",
				type = "header"
			},]]
		}
	}
	
	for _, id in ipairs(cooldowns_list) do
		local spell, _, icon = GetSpellInfo(id)
		if spell then
			local cd_data = cooldowns[id]
			group.args["Spell" .. id] = {
				order = 1000 + cd_data.order * 10,
				name = "|T" .. icon .. ":21|t |cff" .. class_colors[cd_data.class][4] .. spell .. "|h|r",
				desc = GetSpellDescription(id) .. "\n|cff999999" .. id .. "|r",
				type = "toggle",
				get = function()
					return settings.groups[name].cooldowns[id]
				end,
				set = function(_, enabled)
					settings.groups[name].cooldowns[id] = enabled and true or nil
					FSCD:RebuildDisplay(name)
				end
			}
		end
	end
	
	config.args.groups.args[name] = group
	
	-- Create group anchor
	local anchor = CreateFrame("Frame", nil, UIParent)
	
	anchor:SetPoint(unpack(settings.groups[name].position))

	local backdrop = {
		bgFile = "Interface\\BUTTONS\\WHITE8X8",
		edgeFile = "",
		tile = false, tileSize = 0, edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	}

	anchor:SetBackdrop(backdrop)
	anchor:SetSize(80, 80)

	anchor:SetClampedToScreen(true)
	anchor:SetMovable(true)
	anchor:RegisterForDrag("LeftButton")
	anchor:SetScript("OnDragStart", anchor.StartMoving)
	anchor:SetScript("OnDragStop", function()
		anchor:StopMovingOrSizing()
		settings.groups[name].position = { anchor:GetPoint() }
	end)
	
	anchor:Show()
	displays[name] = anchor
	
	self:RebuildDisplay(name)
end

function FSCD:RemoveDisplayGroup(name, leave_config)
	config.args.groups.args[name] = nil
	if not leave_config then settings.groups[name] = nil end
	displays[name]:Hide()
	for id, icon in pairs(displays[name].icons) do
		for _, bar in ipairs(icon.bars) do
			bar:Hide()
		end
	end
	displays[name] = nil
end

function FSCD:PlayerHasCooldown(player, spell)
	if spell.class and player.class_id ~= spell.class then
		return false
	end
	
	local function spec_match()
		if type(spell.spec) == "table" then
			for _, spec in pairs(spell.spec) do
				if spec == player.global_spec_id then
					return true
				end
			end
		elseif spell.spec == player.global_spec_id then
			return true
		end
		return false
	end
	
	if spell.spec and not spec_match() then
		return false
	end
	
	if spell.talent and not player.talents[spell.talent] then
		return false
	end
	
	return true
end

function FSCD:CreatePlayerCooldown(player, cooldown, id)
	local cd = {
		player = player,
		template = cooldown,
		id = id,
		used = 0,
		cast = 0,
		duration = 0,
		cooldown = 0
	}
	
	function cd:Evaluate(key, default)
		local value = cooldown[key]
		if value == nil then return default end
		if type(value) == "function" then return value(player) end
		return value
	end
	
	return cd
end

function FSCD:PlayerCooldowns(player)
	local player_cds = {}
	for id, cd in pairs(cooldowns) do
		if (self:PlayerHasCooldown(player, cd)) then
			player_cds[id] = self:CreatePlayerCooldown(player, cd, id)
		end
	end
	return player_cds
end

function FSCD:RebuildIndex()
	cooldowns_idx = {}
	for guid, rpl in pairs(roster) do
		for cd, data in pairs(rpl.cooldowns) do
			if not cooldowns_idx[cd] then cooldowns_idx[cd] = {} end
			table.insert(cooldowns_idx[cd], data)
		end
	end
	
	FSCD:RefreshAllCooldowns()
end

function FSCD:CreateCooldownIcon(anchor, id)
	local icon = CreateFrame("BUTTON", nil, anchor);
	icon:SetFrameStrata("BACKGROUND")
	icon:SetWidth(24)
	icon:SetHeight(24)
	icon:SetPoint("CENTER", 0, 0)
	
	local back = icon:CreateTexture(nil, "BACKGROUND")
	back:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	back:SetAllPoints()
	icon.back = back
	
	local tex = icon:CreateTexture(nil, "MEDIUM")
	tex:SetTexture(select(3, GetSpellInfo(id)))
	tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	icon.tex = tex
	
	icon.cd = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
	
	local glowing = false
	function icon:SetGlow(glow)
		if glow and not glowing then
			glowing = true
			ActionButton_ShowOverlayGlow(icon);
		elseif not glow and glowing then
			glowing = false
			ActionButton_HideOverlayGlow(icon);
		end
	end
	
	function icon:SetCooldown(from, to)
		icon.cd:SetCooldown(from, to - from)
	end
	
	function icon:SetDesaturated(desaturated)
		if desaturated then
			icon.tex:SetDesaturated(1)
			icon.back:SetVertexColor(0.5, 0.5, 0.5, 1)
		else
			icon.tex:SetDesaturated()
			local r, g, b = unpack(class_colors[cooldowns[id].class])
			icon.back:SetVertexColor(r, g, b, 1)
		end
	end
	
	icon.bars = {}
	
	icon:EnableMouse(false)
	return icon
end

function FSCD:CreateCooldownBar(icon, group)
	local wrapper = CreateFrame("Frame", nil, icon)
	
	local backdrop = {
		bgFile = "Interface\\BUTTONS\\WHITE8X8",
		edgeFile = "",
		tile = false, tileSize = 0, edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	}

	wrapper:SetBackdrop(backdrop)
	wrapper:SetBackdropColor(0.12, 0.12, 0.12, 0.4)
	wrapper:SetFrameStrata("BACKGROUND")
	
	local bar = CreateFrame("StatusBar", nil, wrapper)
	bar:SetStatusBarTexture(Media:Fetch("statusbar", group.texture))
	--bar:SetPoint("TOPLEFT", wrapper, "TOPLEFT", 1, -1)
	--bar:SetPoint("BOTTOMRIGHT", wrapper, "BOTTOMRIGHT", -1, 1)
	bar:SetAllPoints(wrapper)
	wrapper.bar = bar
	
	local text = bar:CreateFontString()
	text:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
	text:SetJustifyV("MIDDLE")
	text:SetJustifyH("LEFT")
	text:SetTextColor(1, 1, 1, 1)
	text:SetPoint("LEFT", wrapper, "LEFT", 2, 0)
	text:SetPoint("RIGHT", wrapper, "RIGHT", -35, 0)
	text:SetWordWrap(false)
	
	local time = bar:CreateFontString()
	time:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
	time:SetJustifyV("MIDDLE")
	time:SetJustifyH("RIGHT")
	time:SetTextColor(1, 1, 1, 1)
	time:SetPoint("LEFT", text, "RIGHT", 2, 0)
	time:SetPoint("RIGHT", wrapper, "RIGHT", 0, 0)
	
	function wrapper:SetData(data)
		wrapper.data = data
		self:Update()
	end
	
	local throttler = 0
	local function duration_updater(cast_start, duration_end, cd)
		return function()
			bar:SetValue(duration_end - GetTime() + cast_start)
			
			throttler = throttler + 1
			if throttler % 10 == 0 then
				local remaining = math.ceil(cd.duration - GetTime())
				local sec = remaining % 60
				local min = math.floor(remaining / 60)
				time:SetFormattedText("%d:%02d", min, sec)
			end
		end
	end
	
	local function cd_updater(cd)
		return function()
			bar:SetValue(GetTime())
			
			throttler = throttler + 1
			if throttler % 10 == 0 then
				local remaining = math.ceil(cd.cooldown - GetTime())
				local sec = remaining % 60
				local min = math.floor(remaining / 60)
				time:SetFormattedText("%d:%02d", min, sec)
			end
		end
	end
	
	function wrapper:Update()
		local cd = wrapper.data
		local r, g, b = unpack(class_colors[cd.template.class])
		
		local max_charges = cd:Evaluate("charges", 1)
		
		if max_charges > 1 and group.charges then
			local charges_avail = max_charges - cd.used
			text:SetText(charges_avail .. " - " .. cd.player.name)
		else
			text:SetText(cd.player.name)
		end
		
		local color_ratio = 0.8
		local animating = false
		local animate_duration = false
		wrapper:SetAlpha(1.0)
		
		if cd.duration > GetTime() then
			color_ratio = 2
			animating = true
			animate_duration = true
		elseif not players_available[cd.player.lku] then
			color_ratio = 0.2
			wrapper:SetAlpha(0.4)
		elseif cd.cooldown > GetTime() then
			if cd.used >= cd:Evaluate("charges", 1) then
				color_ratio = 0
			end
			animating = true
		end
		
		local function blend(color) return color * color_ratio + 0.3 * (1 - color_ratio) end
		bar:SetStatusBarColor(blend(r), blend(g), blend(b), 1)
		
		if animating then
			throttler = 0
			bar:SetMinMaxValues(cd.cast, animate_duration and cd.duration or cd.cooldown)
			if animate_duration then
				wrapper:SetScript("OnUpdate", duration_updater(cd.cast, cd.duration, cd))
			else
				wrapper:SetScript("OnUpdate", cd_updater(cd))
			end
		else
			wrapper:SetScript("OnUpdate", nil)
			bar:SetMinMaxValues(0, 1)
			bar:SetValue(1)
			time:SetText("")
		end
	end
	
	return wrapper
end

function FSCD:RebuildDisplay(name)
	local anchor = displays[name]
	local group = settings.groups[name]
	
	if not anchor.icons then
		anchor.icons = {}
	end
	
	if group.unlocked then
		anchor:SetBackdropColor(0.39, 0.71, 1.00, 0.3)
		anchor:EnableMouse(true)
	else
		anchor:SetBackdropColor(0, 0, 0, 0)
		anchor:EnableMouse(false)
	end
	
	for id, icon in pairs(anchor.icons) do
		icon:Hide()
		icon.visible = false
		for i, bar in ipairs(icon.bars) do
			bar:Hide()
		end
	end
	
	local last_icon
	for _, id in ipairs(cooldowns_list) do
		if group.cooldowns[id] and (group.missing or cooldowns_idx[id]) then
			if not anchor.icons[id] then
				anchor.icons[id] = self:CreateCooldownIcon(anchor, id)
			end
			
			local icon = anchor.icons[id]
			icon:ClearAllPoints()
			
			icon:SetSize(group.size, group.size)
			icon.tex:SetPoint("TOPLEFT", icon, "TOPLEFT", group.border, -group.border)
			icon.tex:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -group.border, group.border)
			icon.cd:SetPoint("TOPLEFT", icon, "TOPLEFT", group.border, -group.border)
			icon.cd:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -group.border, group.border)
			
			if last_icon then
				local bars_height = (last_icon.bars_count * 17) - 2
				local overflow = (bars_height > group.size) and bars_height - group.size or 0
				
				if group.attach == "LEFTUP" or group.attach == "RIGHTUP" then
					icon:SetPoint("BOTTOMLEFT", last_icon, "TOPLEFT", 0, group.spacing + overflow)
				else
					icon:SetPoint("TOPLEFT", last_icon, "BOTTOMLEFT", 0, -(group.spacing + overflow))
				end
			else
				local attach_to = {
					LEFTDOWN = "TOPLEFT",
					LEFTUP = "BOTTOMLEFT",
					RIGHTDOWN = "TOPRIGHT",
					RIGHTUP = "BOTTOMRIGHT"
				}
				icon:SetPoint(attach_to[group.attach], anchor, attach_to[group.attach], 0, 0)
			end
			
			icon.visible = true
			icon:Show()
			
			local available = false
			
			icon.bars_count = 0
			if cooldowns_idx[id] then
				for i, data in ipairs(cooldowns_idx[id]) do
					if not icon.bars[i] then
						icon.bars[i] = FSCD:CreateCooldownBar(icon, group)
					end
					
					local bar = icon.bars[i]
					bar:SetWidth(100)
					bar:SetHeight(15)
					
					bar:ClearAllPoints()
					if group.attach == "RIGHTUP" then
						bar:SetPoint("BOTTOMRIGHT", icon, "BOTTOMLEFT", -math.min(5, group.spacing), (i - 1) * 17)
					elseif group.attach == "RIGHTDOWN" then
						bar:SetPoint("TOPRIGHT", icon, "TOPLEFT", -math.min(5, group.spacing), (1 - i) * 17)
					elseif group.attach == "LEFTUP" then
						bar:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", math.min(5, group.spacing), (i -1) * 17)
					else
						bar:SetPoint("TOPLEFT", icon, "TOPRIGHT", math.min(5, group.spacing), (1 - i) * 17)
					end
					
					bar.bar:SetStatusBarTexture(Media:Fetch("statusbar", group.texture))
					bar:Show()
					bar:SetData(data)
					
					available = true
					icon.bars_count = icon.bars_count + 1
				end
			end
			
			if available then
				icon:SetAlpha(1)
				icon:SetDesaturated(false)
			else
				icon:SetAlpha(0.5)
				icon:SetDesaturated(true)
			end
			
			last_icon = icon
		end
	end
end

function FSCD:RebuildAllDisplays()
	for name in pairs(displays) do
		self:RebuildDisplay(name)
	end
	FSCD:RefreshAllCooldowns()
end

--------------------------------------------------------------------------------

local function sortCooldowns(a, b)
	local now = GetTime()
	local aActive, bActive = now < a.duration, now < b.duration
	
	if aActive ~= bActive then
		return aActive
	else
		if aActive then
			return a.duration < b.duration
		else
			local paAvail = players_available[a.player.lku]
			local pbAvail = players_available[b.player.lku]
			
			if paAvail ~= pbAvail then
				return paAvail
			else
				local aMax, bMax = a:Evaluate("charges", 1), b:Evaluate("charges", 1)
				local aAvail = a.used < aMax
				local bAvail = b.used < bMax
				
				if aAvail ~= bAvail then
					return aAvail
				else
					if aAvail then
						if a.used ~= b.used then
							return a.used < b.used
						else
							return aMax > bMax
						end
					else
						return a.cooldown < b.cooldown
					end
				end
			end
		end
	end
end

function FSCD:RefreshCooldown(id)
	if not cooldowns_idx[id] then return end
	table.sort(cooldowns_idx[id], sortCooldowns)
	local now = GetTime()
			
	for _, display in pairs(displays) do
		local icon = display.icons[id]
		if icon and icon.visible then
			local one_available = false
			local glow = false
			
			for i, data in ipairs(cooldowns_idx[id]) do
				local bar = icon.bars[i]
				if bar then
					bar:SetData(data)
					if data.duration > now then
						glow = true
					end
					
					if data.used < data:Evaluate("charges", 1) then
						one_available = true
					end
				end
			end
			
			icon:SetGlow(glow)
			
			if one_available or glow then
				icon:SetDesaturated(false)
				icon:SetCooldown(0, 0)
			else
				icon:SetDesaturated(true)
				icon:SetCooldown(cooldowns_idx[id][1].cast, cooldowns_idx[id][1].cooldown)
			end
		end
	end
end

function FSCD:RefreshAllCooldowns()
	for id in pairs(cooldowns_idx) do
		self:RefreshCooldown(id)
	end
end

--------------------------------------------------------------------------------

function FSCD:RosterUpdate(_, guid, _, player)
	local rpl = roster[guid] or {}
	local cds = self:PlayerCooldowns(player);
	
	if rpl.cooldowns then
		for id, cd in pairs(rpl.cooldowns) do
			if cds[id] then
				cd.player = player
				cds[id] = cd
			end
		end
	end
	
	rpl.cooldowns = cds
	rpl.player = player
	roster[guid] = rpl
	
	players_available[player.lku] = true
	
	self:RebuildIndex()
	self:RebuildAllDisplays()
end

function FSCD:RosterRemove(_, guid)
	roster[guid] = nil
	self:RebuildIndex()
	self:RebuildAllDisplays()
end

--------------------------------------------------------------------------------

local function modCharges(cd, delta)
	cd.used = cd.used + delta
	
	local max_charges = cd:Evaluate("charges", 1)
	if cd.used > max_charges then cd.used = max_charges end
	if cd.used < 0 then cd.used = 0 end
end

local function handleCharge(cd)
	return function()
		modCharges(cd, -1)
		cd.timer = nil
		FSCD:RefreshCooldown(cd.id)
		if cd.used > 0 then
			cd.cooldown = GetTime() + cd:Evaluate("cooldown", 15)
			cd.timer = C_Timer.NewTimer(cd.cooldown - GetTime(), handleCharge(cd))
		end
	end
end

function FSCD:OnCommReceived(chan, data)
	if chan ~= "FSCD" then return end
	
	local action, id, owner, updated = data:match("(.*):(.*):(.*):(.*)")
	id, updated = tonumber(id), tonumber(updated)
	
	if action == "1" then
		local instances = cooldowns_idx[id]
		if instances then
			for _, cd in ipairs(instances) do
				if cd.player.guid == owner then
					local now = GetTime()
					cd.cooldown = now + updated
					if cd.timer then cd.timer:Cancel() end
					cd.timer = C_Timer.NewTimer(cd.cooldown - now, handleCharge(cd))
					FSCD:RefreshCooldown(cd.id)
					return
				end
			end
		end
	end
end

function FSCD:AdjustCD(id, owner, cooldown)
	self:SendCommMessage("FSCD", "1:" .. id .. ":" .. owner .. ":" .. cooldown, "RAID")
	self:SendCommMessage("FSCD", "1:" .. id .. ":" .. owner .. ":" .. cooldown, "GUILD")
end

local PLAYER_GUID = UnitGUID("player")
function FSCD:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, _, source, _, _, dest, _, _, _, _, id)
	if event == "SPELL_CAST_SUCCESS" then
		local instances = cooldowns_idx[id]
		
		if instances then
			for _, cd in ipairs(instances) do
				if cd.player.guid == source then
					local now = GetTime()
					
					modCharges(cd, 1)
					cd.cast = now
					cd.duration = now + cd:Evaluate("duration", 1.5)
					
					if cd.used == 1 then
						cd.cooldown = now + cd:Evaluate("cooldown", 15)
						if cd.timer then cd.timer:Cancel() end
						cd.timer = C_Timer.NewTimer(cd.cooldown - now, handleCharge(cd))
					end
					
					C_Timer.After(cd.duration - now, function()
						FSCD:RefreshCooldown(cd.id)
					end)
					
					FSCD:RefreshCooldown(cd.id)
					
					-- Special AW handling
					if source == PLAYER_GUID and id == 31842 then
						if select(4, GetGlyphSocketInfo(2)) == 162604
						or select(4, GetGlyphSocketInfo(4)) == 162604
						or select(4, GetGlyphSocketInfo(6)) == 162604 then
							self:AdjustCD(cd.id, source, 90)
						end
					end
					
					return
				end
			end
		end
	end
end

function FSCD:ENCOUNTER_END()
	for id, instances in pairs(cooldowns_idx) do
		if cooldowns[id].cooldown >= 180 then
			for i, cd in ipairs(instances) do
				cd.used = 0
				cd.cast = 0
				cd.duration = 0
				cd.cooldown = 0
			end
			self:RefreshCooldown(id)
		end
	end
end
