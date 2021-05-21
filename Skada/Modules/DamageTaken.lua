assert(Skada, "Skada not found!")

-- cache frequently used globals
local _pairs, _ipairs, _select = pairs, ipairs, select
local _format, math_max = string.format, math.max
local _GetSpellInfo = Skada.GetSpellInfo or GetSpellInfo
local _UnitClass = Skada.UnitClass

-- list of miss types
local misstypes = {"ABSORB", "BLOCK", "DEFLECT", "DODGE", "EVADE", "IMMUNE", "MISS", "PARRY", "REFLECT", "RESIST"}

-- =================== --
-- Damage Taken Module --
-- =================== --

Skada:AddLoadableModule("Damage Taken", function(Skada, L)
	if Skada:IsDisabled("Damage Taken") then return end

	local mod = Skada:NewModule(L["Damage Taken"])
	local playermod = mod:NewModule(L["Damage spell list"])
	local spellmod = mod:NewModule(L["Damage spell details"])
	local sourcemod = mod:NewModule(L["Damage source list"])

	local function log_extra_data(spell, dmg, set, player)
		if not (spell and dmg) then return end

		spell.totalhits = (spell.totalhits or 0) + 1
		spell.amount = spell.amount + dmg.amount

		if spell.max == nil or dmg.amount > spell.max then
			spell.max = dmg.amount
		end

		if (spell.min == nil or dmg.amount < spell.min) and not dmg.missed then
			spell.min = dmg.amount
		end
		if dmg.critical then
			spell.critical = (spell.critical or 0) + 1
			spell.criticalamount = (spell.criticalamount or 0) + dmg.amount

			if not spell.criticalmax or dmg.amount > spell.criticalmax then
				spell.criticalmax = dmg.amount
			end

			if not spell.criticalmin or dmg.amount < spell.criticalmin then
				spell.criticalmin = dmg.amount
			end
		elseif dmg.missed ~= nil then
			spell[dmg.missed] = (spell[dmg.missed] or 0) + 1
		elseif dmg.glancing then
			spell.glancing = (spell.glancing or 0) + 1
		elseif dmg.crushing then
			spell.crushing = (spell.crushing or 0) + 1
		else
			spell.hit = (spell.hit or 0) + 1
			spell.hitamount = (spell.hitamount or 0) + dmg.amount
			if not spell.hitmax or dmg.amount > spell.hitmax then
				spell.hitmax = dmg.amount
			end
			if not spell.hitmin or dmg.amount < spell.hitmin then
				spell.hitmin = dmg.amount
			end
		end

		if dmg.absorbed then
			spell.absorbed = (spell.absorbed or 0) + dmg.absorbed
			if set and set.damagetaken then
				set.damagetaken.absorbed = (set.damagetaken.absorbed or 0) + dmg.absorbed
			end
			if player and player.damagetaken then
				player.damagetaken.absorbed = (player.damagetaken.absorbed or 0) + dmg.absorbed
			end
		end

		if dmg.blocked then
			spell.blocked = (spell.blocked or 0) + dmg.blocked
			if set and set.damagetaken then
				set.damagetaken.blocked = (set.damagetaken.blocked or 0) + dmg.blocked
			end
			if player and player.damagetaken then
				player.damagetaken.blocked = (player.damagetaken.blocked or 0) + dmg.blocked
			end
		end

		if dmg.resisted then
			spell.resisted = (spell.resisted or 0) + dmg.resisted
			if set and set.damagetaken then
				set.damagetaken.resisted = (set.damagetaken.resisted or 0) + dmg.resisted
			end
			if player and player.damagetaken then
				player.damagetaken.resisted = (player.damagetaken.resisted or 0) + dmg.resisted
			end
		end

		if dmg.overkill and dmg.overkill > 0 then
			spell.overkill = (spell.overkill or 0) + dmg.overkill
			if set and set.damagetaken then
				set.damagetaken.overkill = (set.damagetaken.overkill or 0) + dmg.overkill
			end
			if player then
				player.damagetaken.overkill = (player.damagetaken.overkill or 0) + dmg.overkill
			end
		end
	end

	local function log_damage(set, dmg, tick)
		local player = Skada:get_player(set, dmg.playerid, dmg.playername, dmg.playerflags)
		if not player then return end

		player.damagetaken = player.damagetaken or {amount = 0}
		player.damagetaken.amount = (player.damagetaken.amount or 0) + dmg.amount
		set.damagetaken = set.damagetaken or {amount = 0}
		set.damagetaken.amount = (set.damagetaken.amount or 0) + dmg.amount

		local spellname = dmg.spellname
		local spell = player.damagetaken.spells and player.damagetaken.spells[spellname]
		if not spell then
			player.damagetaken.spells = player.damagetaken.spells or {}
			spell = {id = dmg.spellid, school = dmg.spellschool, amount = 0}
			player.damagetaken.spells[spellname] = spell
		elseif dmg.spellschool and dmg.spellschool ~= spell.school then
			spellname = spellname .. " (" .. (Skada.schoolnames[dmg.spellschool] or OTHER) .. ")"
			if not player.damagetaken.spells[spellname] then
				player.damagetaken.spells[spellname] = {id = dmg.spellid, school = dmg.spellschool, amount = 0}
			end
			spell = player.damagetaken.spells[spellname]
		end

		spell.isdot = tick or nil -- DoT
		log_extra_data(spell, dmg, set, player)

		if dmg.srcName then
			spell.sources = spell.sources or {}
			spell.sources[dmg.srcName] = spell.sources[dmg.srcName] or {id = dmg.srcGUID, amount = 0}
			log_extra_data(spell.sources[dmg.srcName], dmg)

			player.damagetaken.sources = player.damagetaken.sources or {}
			player.damagetaken.sources[dmg.srcName] = player.damagetaken.sources[dmg.srcName] or {id = dmg.srcGUID, amount = 0}
			log_extra_data(player.damagetaken.sources[dmg.srcName], dmg)

			set.damagetaken.sources = set.damagetaken.sources or {}
			set.damagetaken.sources[dmg.srcName] = (set.damagetaken.sources[dmg.srcName] or 0) + dmg.amount

			if not spell.sources[dmg.srcName].class then
				local class = _select(2, _UnitClass(dmg.srcGUID, dmg.srcFlags))
				spell.sources[dmg.srcName].class = class
				player.damagetaken.sources[dmg.srcName].class = class
			end
		end
	end

	local dmg = Skada:WeakTable()

	local function SpellDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		local spellid, spellname, spellschool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = ...

		dmg.srcGUID = srcGUID
		dmg.srcName = srcName
		dmg.srcFlags = srcFlags

		dmg.playerid = dstGUID
		dmg.playername = dstName
		dmg.playerflags = dstFlags

		dmg.spellid = spellid
		dmg.spellname = spellname
		dmg.spellschool = school

		dmg.amount = amount
		dmg.resisted = resisted
		dmg.blocked = blocked
		dmg.absorbed = absorbed
		dmg.critical = critical
		dmg.glancing = glancing
		dmg.crushing = crushing
		dmg.missed = nil

		log_damage(Skada.current, dmg, eventtype == "SPELL_PERIODIC_DAMAGE")
		log_damage(Skada.total, dmg, eventtype == "SPELL_PERIODIC_DAMAGE")
	end

	local function SwingDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		SpellDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, 6603, L["Auto Attack"], 1, ...)
	end

	local function EnvironmentDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		local envtype = ...
		local spellid, spellname, spellschool

		if envtype == "Falling" or envtype == "FALLING" then
			spellid, spellschool, spellname = 3, 1, ACTION_ENVIRONMENTAL_DAMAGE_FALLING
		elseif envtype == "Drowning" or envtype == "DROWNING" then
			spellid, spellschool, spellname = 4, 1, ACTION_ENVIRONMENTAL_DAMAGE_DROWNING
		elseif envtype == "Fatigue" or envtype == "FATIGUE" then
			spellid, spellschool, spellname = 5, 1, ACTION_ENVIRONMENTAL_DAMAGE_FATIGUE
		elseif envtype == "Fire" or envtype == "FIRE" then
			spellid, spellschool, spellname = 6, 4, ACTION_ENVIRONMENTAL_DAMAGE_FIRE
		elseif envtype == "Lava" or envtype == "LAVA" then
			spellid, spellschool, spellname = 7, 4, ACTION_ENVIRONMENTAL_DAMAGE_LAVA
		elseif envtype == "Slime" or envtype == "SLIME" then
			spellid, spellschool, spellname = 8, 8, ACTION_ENVIRONMENTAL_DAMAGE_SLIME
		end

		if spellid and spellname then
			dstGUID, dstName = Skada:FixMyPets(dstGUID, dstName)
			SpellDamage(timestamp, eventtype, nil, ENVIRONMENTAL_DAMAGE, nil, dstGUID, dstName, dstFlags, spellid, spellname, nil, select(2, ...))
		end
	end

	local function SpellMissed(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		local spellid, spellname, spellschool, misstype, amount = ...

		dmg.srcGUID = srcGUID
		dmg.srcName = srcName
		dmg.srcFlags = srcFlags

		dmg.playerid = dstGUID
		dmg.playername = dstName
		dmg.playerflags = dstFlags

		dmg.spellid = spellid
		dmg.spellname = spellname
		dmg.spellschool = spellschool

		dmg.amount = 0
		dmg.overkill = 0
		dmg.missed = misstype

		if misstype == "ABSORB" then
			dmg.absorbed = amount
		elseif misstype == "BLOCK" then
			dmg.blocked = amount
		elseif misstype == "RESIST" then
			dmg.resisted = amount
		end

		log_damage(Skada.current, dmg)
		log_damage(Skada.total, dmg)
	end

	local function SwingMissed(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		SpellMissed(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, 6603, L["Auto Attack"], 1, ...)
	end

	local function getDTPS(set, player)
		local amount = player.damagetaken and player.damagetaken.amount or 0
		if set.time > 0 then
			return amount / math_max(1, set.time), amount
		else
			return amount / math_max(1, (set.endtime or time()) - set.starttime), amount
		end
	end
	mod.getDTPS = getDTPS

	local function getRaidDTPS(set)
		local amount = set.damagetaken and set.damagetaken.amount or 0
		if set.time > 0 then
			return amount / math_max(1, set.time), amount
		else
			return amount / math_max(1, (set.endtime or time()) - set.starttime), amount
		end
	end
	mod.getRaidDTPS = getRaidDTPS

	local function playermod_tooltip(win, id, label, tooltip)
		local player = Skada:find_player(win:get_selected_set(), win.playerid)
		if player and player.damagetaken then
			local spell = player.damagetaken.spells and player.damagetaken.spells[label]
			if spell then
				tooltip:AddLine(label .. " - " .. player.name)

				if spell.school then
					local c = Skada.schoolcolors[spell.school]
					local n = Skada.schoolnames[spell.school]
					if c and n then tooltip:AddLine(n, c.r, c.g, c.b) end
				end

				local total = (spell.amount or 0)
				local overkill, absorbed, blocked, resisted

				if (spell.overkill or 0) > 0 then
					overkill = spell.overkill
					total = total + spell.overkill
				end

				if (spell.absorbed or 0) > 0 then
					absorbed = spell.absorbed
					total = total + spell.absorbed
				end

				if (spell.blocked or 0) > 0 then
					blocked = spell.blocked
					total = total + spell.blocked
				end

				if (spell.resisted or 0) > 0 then
					resisted = spell.resisted
					total = total + spell.resisted
				end

				tooltip:AddDoubleLine(L["Total"], Skada:FormatNumber(total), 1, 1, 1)
				tooltip:AddDoubleLine(L["Damage Taken"], Skada:FormatNumber(spell.amount or 0), 1, 1, 1)

				if overkill then
					tooltip:AddDoubleLine(L["Overkill"], _format("%s (%02.1f%%)", Skada:FormatNumber(overkill), 100 * overkill / math_max(total)), 1, 1, 1)
				end

				if absorbed then
					tooltip:AddDoubleLine(ABSORB, _format("%s (%02.1f%%)", Skada:FormatNumber(absorbed), 100 * absorbed / math_max(total)), 1, 1, 1)
				end
				if blocked then
					tooltip:AddDoubleLine(BLOCK, _format("%s (%02.1f%%)", Skada:FormatNumber(blocked), 100 * blocked / math_max(total)), 1, 1, 1)
				end
				if resisted then
					tooltip:AddDoubleLine(RESIST, _format("%s (%02.1f%%)", Skada:FormatNumber(resisted), 100 * resisted / math_max(total)), 1, 1, 1)
				end

				if spell.max and spell.min then
					tooltip:AddLine(" ")
					tooltip:AddDoubleLine(L["Minimum"], Skada:FormatNumber(spell.min), 1, 1, 1)
					tooltip:AddDoubleLine(L["Maximum"], Skada:FormatNumber(spell.max), 1, 1, 1)
				end
				tooltip:AddDoubleLine(L["Average"], Skada:FormatNumber(spell.amount / spell.totalhits), 1, 1, 1)
			end
		end
	end

	local function sourcemod_tooltip(win, id, label, tooltip)
		local player = Skada:find_player(win:get_selected_set(), win.playerid)
		if player and player.damagetaken then
			local source = player.damagetaken.sources and player.damagetaken.sources[label]
			if source then
				tooltip:AddLine(_format(L["%s's damage on %s"], label, player.name))

				-- real total
				local total = (source.amount or 0)
				local absorbed, blocked, resisted, overkill

				if (source.overkill or 0) > 0 then
					overkill = source.overkill
					total = total + source.overkill
				end

				if (source.absorbed or 0) > 0 then
					absorbed = source.absorbed
					total = total + source.absorbed
				end

				if (source.blocked or 0) > 0 then
					blocked = source.blocked
					total = total + source.blocked
				end

				if (source.resisted or 0) > 0 then
					resisted = source.resisted
					total = total + source.resisted
				end

				tooltip:AddDoubleLine(L["Total"], Skada:FormatNumber(total), 1, 1, 1)
				tooltip:AddDoubleLine(L["Damage"], Skada:FormatNumber(source.amount or 0), 1, 1, 1)

				if overkill then
					tooltip:AddDoubleLine(L["Overkill"], _format("%s (%02.1f%%)", Skada:FormatNumber(overkill), 100 * overkill / math_max(total)), 1, 1, 1)
				end

				if absorbed then
					tooltip:AddDoubleLine(ABSORB, _format("%s (%02.1f%%)", Skada:FormatNumber(absorbed), 100 * absorbed / math_max(total)), 1, 1, 1)
				end
				if blocked then
					tooltip:AddDoubleLine(BLOCK, _format("%s (%02.1f%%)", Skada:FormatNumber(blocked), 100 * blocked / math_max(total)), 1, 1, 1)
				end
				if resisted then
					tooltip:AddDoubleLine(RESIST, _format("%s (%02.1f%%)", Skada:FormatNumber(resisted), 100 * resisted / math_max(total)), 1, 1, 1)
				end

				if source.max and source.min then
					tooltip:AddDoubleLine(L["Minimum"], Skada:FormatNumber(source.min), 1, 1, 1)
					tooltip:AddDoubleLine(L["Maximum"], Skada:FormatNumber(source.max), 1, 1, 1)
				end

				tooltip:AddLine(" ")
				tooltip:AddLine(_format(L["%s's damage breakdown"], player.name))
				tooltip:AddDoubleLine(L["Total hits"], source.totalhits or 0, 1, 1, 1)
				if (source.hit or 0) > 0 then
					tooltip:AddDoubleLine(HIT, _format("%d (%02.1f%%)", source.hit, 100 * source.hit / math_max(1, source.totalhits or 0)), 1, 1, 1)
				end
				if (source.critical or 0) > 0 then
					tooltip:AddDoubleLine(CRIT_ABBR, _format("%d (%02.1f%%)", source.critical, 100 * source.critical / math_max(1, source.totalhits or 0)), 1, 1, 1)
				end
				for _, misstype in _ipairs(misstypes) do
					if (source[misstype] or 0) > 0 then
						local title = _G[misstype] or _G["ACTION_SPELL_MISSED" .. misstype] or misstype
						tooltip:AddDoubleLine(title, _format("%d (%02.1f%%)", source[misstype], 100 * source[misstype] / math_max(1, source.totalhits or 0)), 1, 1, 1)
					end
				end
			end
		end
	end

	local function spellmod_tooltip(win, id, label, tooltip)
		if label == CRIT_ABBR or label == HIT or label == ABSORB or label == BLOCK or label == RESIST then
			local player = Skada:find_player(win:get_selected_set(), win.playerid)
			if player and player.damagetaken then
				local spell = player.damagetaken.spells and player.damagetaken.spells[win.spellname]
				if spell then
					tooltip:AddLine(player.name .. " - " .. win.spellname)

					if spell.school then
						local c = Skada.schoolcolors[spell.school]
						local n = Skada.schoolnames[spell.school]
						if c and n then tooltip:AddLine(n, c.r, c.g, c.b) end
					end

					if label == CRIT_ABBR and spell.criticalamount then
						tooltip:AddDoubleLine(L["Minimum"], Skada:FormatNumber(spell.criticalmin), 1, 1, 1)
						tooltip:AddDoubleLine(L["Maximum"], Skada:FormatNumber(spell.criticalmax), 1, 1, 1)
						tooltip:AddDoubleLine(L["Average"], Skada:FormatNumber(spell.criticalamount / spell.critical), 1, 1, 1)
					elseif label == HIT and spell.hitamount then
						tooltip:AddDoubleLine(L["Minimum"], Skada:FormatNumber(spell.hitmin), 1, 1, 1)
						tooltip:AddDoubleLine(L["Maximum"], Skada:FormatNumber(spell.hitmax), 1, 1, 1)
						tooltip:AddDoubleLine(L["Average"], Skada:FormatNumber(spell.hitamount / spell.hit), 1, 1, 1)
					elseif label == ABSORB and spell.absorbed and spell.absorbed > 0 then
						tooltip:AddDoubleLine(L["Amount"], Skada:FormatNumber(spell.absorbed), 1, 1, 1)
					elseif label == BLOCK and spell.blocked and spell.blocked > 0 then
						tooltip:AddDoubleLine(L["Amount"], Skada:FormatNumber(spell.blocked), 1, 1, 1)
					elseif label == RESIST and spell.resisted and spell.resisted > 0 then
						tooltip:AddDoubleLine(L["Amount"], Skada:FormatNumber(spell.resisted), 1, 1, 1)
					end
				end
			end
		end
	end

	function playermod:Enter(win, id, label)
		win.playerid, win.playername = id, label
		win.title = _format(L["Damage taken by %s"], label)
	end

	function playermod:Update(win, set)
		local player = Skada:find_player(set, win.playerid, win.playername)

		if player then
			win.title = _format(L["Damage taken by %s"], player.name)
			local total = _select(2, getDTPS(set, player))

			if total > 0 and player.damagetaken.spells then
				local maxvalue, nr = 0, 1

				for spellname, spell in _pairs(player.damagetaken.spells) do
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = spellname
					d.spellid = spell.id
					d.label = spellname
					d.text = spellname .. (spell.isdot and L["DoT"] or "")
					d.icon = _select(3, _GetSpellInfo(spell.id))
					d.spellschool = spell.school

					d.value = spell.amount
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(spell.amount),
						mod.metadata.columns.Damage,
						_format("%02.1f%%", 100 * spell.amount / total),
						mod.metadata.columns.Percent
					)

					if spell.amount > maxvalue then
						maxvalue = spell.amount
					end
					nr = nr + 1
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	function sourcemod:Enter(win, id, label)
		win.playerid, win.playername = id, label
		win.title = _format(L["%s's damage sources"], label)
	end

	function sourcemod:Update(win, set)
		local player = Skada:find_player(set, win.playerid)

		if player then
			win.title = _format(L["%s's damage sources"], player.name)
			local total = _select(2, getDTPS(set, player))

			if total > 0 then
				local maxvalue, nr = 0, 1

				for sourcename, source in _pairs(player.damagetaken.sources) do
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = source.id or sourcename
					d.label = sourcename
					d.class = source.class

					d.value = source.amount or 0
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(d.value),
						mod.metadata.columns.Damage,
						_format("%02.1f%%", 100 * d.value / total),
						mod.metadata.columns.Percent
					)

					if d.value > maxvalue then
						maxvalue = d.value
					end
					nr = nr + 1
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	local function add_detail_bar(win, nr, title, value)
		local d = win.dataset[nr] or {}
		win.dataset[nr] = d

		d.id = title
		d.label = title
		d.value = value
		if title == L["Total"] then
			d.valuetext = value
		else
			d.valuetext = Skada:FormatValueText(
				value,
				mod.metadata.columns.Damage,
				_format("%02.1f%%", 100 * value / math_max(1, win.metadata.maxvalue)),
				mod.metadata.columns.Percent
			)
		end
		nr = nr + 1
		return nr
	end

	function spellmod:Enter(win, id, label)
		win.spellname = label
		win.title = _format(L["%s damage on %s"], label, win.playername or UNKNOWN)
	end

	function spellmod:Update(win, set)
		local player = Skada:find_player(set, win.playerid)

		if player then
			win.title = _format(L["%s damage on %s"], win.spellname or UNKNOWN, player.name)

			local spell
			if player.damagetaken and player.damagetaken.spells and player.damagetaken.spells[win.spellname] then
				spell = player.damagetaken.spells[win.spellname]
			end

			if spell then
				win.metadata.maxvalue = spell.totalhits

				local nr = 1
				nr = add_detail_bar(win, nr, L["Total"], spell.totalhits)

				if (spell.hit or 0) > 0 then
					nr = add_detail_bar(win, nr, HIT, spell.hit)
				end
				if (spell.critical or 0) > 0 then
					nr = add_detail_bar(win, nr, CRIT_ABBR, spell.critical)
				end
				if (spell.glancing or 0) > 0 then
					nr = add_detail_bar(win, nr, L["Glancing"], spell.glancing)
				end
				if (spell.crushing or 0) > 0 then
					nr = add_detail_bar(win, nr, L["Crushing"], spell.crushing)
				end

				for _, misstype in _ipairs(misstypes) do
					if (spell[misstype] or 0) > 0 then
						local title = _G[misstype] or _G["ACTION_SPELL_MISSED" .. misstype] or misstype
						nr = add_detail_bar(win, nr, title, spell[misstype])
					end
				end
			end
		end
	end

	function mod:Update(win, set)
		win.title = L["Damage Taken"]
		local total = _select(2, getRaidDTPS(set))

		if total > 0 then
			local maxvalue, nr = 0, 1

			for _, player in _ipairs(set.players) do
				local dtps, amount = getDTPS(set, player)

				if amount > 0 then
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = player.id
					d.label = player.name
					d.class = player.class or "PET"
					d.role = player.role or "DAMAGER"
					d.spec = player.spec or 1

					d.value = amount
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(amount),
						self.metadata.columns.Damage,
						Skada:FormatNumber(dtps),
						self.metadata.columns.DTPS,
						_format("%02.1f%%", 100 * amount / total),
						self.metadata.columns.Percent
					)

					if amount > maxvalue then
						maxvalue = amount
					end
					nr = nr + 1
				end
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	function mod:OnEnable()
		spellmod.metadata = {tooltip = spellmod_tooltip}
		playermod.metadata = {post_tooltip = playermod_tooltip, click1 = spellmod}
		sourcemod.metadata = {tooltip = sourcemod_tooltip}
		self.metadata = {
			showspots = true,
			click1 = playermod,
			click2 = sourcemod,
			columns = {Damage = true, DTPS = true, Percent = true},
			icon = "Interface\\Icons\\ability_mage_frostfirebolt"
		}

		Skada:RegisterForCL(SpellDamage, "DAMAGE_SHIELD", {dst_is_interesting_nopets = true})
		Skada:RegisterForCL(SpellDamage, "DAMAGE_SPLIT", {dst_is_interesting_nopets = true})
		Skada:RegisterForCL(SpellDamage, "RANGE_DAMAGE", {dst_is_interesting_nopets = true})
		Skada:RegisterForCL(SpellDamage, "SPELL_BUILDING_DAMAGE", {dst_is_interesting_nopets = true})
		Skada:RegisterForCL(SpellDamage, "SPELL_DAMAGE", {dst_is_interesting_nopets = true})
		Skada:RegisterForCL(SpellDamage, "SPELL_EXTRA_ATTACKS", {dst_is_interesting_nopets = true})
		Skada:RegisterForCL(SpellDamage, "SPELL_PERIODIC_DAMAGE", {dst_is_interesting_nopets = true})
		Skada:RegisterForCL(SwingDamage, "SWING_DAMAGE", {dst_is_interesting_nopets = true})
		Skada:RegisterForCL(EnvironmentDamage, "ENVIRONMENTAL_DAMAGE", {dst_is_interesting_nopets = true})

		Skada:RegisterForCL(SpellMissed, "DAMAGE_SHIELD_MISSED", {dst_is_interesting_nopets = true})
		Skada:RegisterForCL(SpellMissed, "RANGE_MISSED", {dst_is_interesting_nopets = true})
		Skada:RegisterForCL(SpellMissed, "SPELL_BUILDING_MISSED", {dst_is_interesting_nopets = true})
		Skada:RegisterForCL(SpellMissed, "SPELL_MISSED", {dst_is_interesting_nopets = true})
		Skada:RegisterForCL(SpellMissed, "SPELL_PERIODIC_MISSED", {dst_is_interesting_nopets = true})
		Skada:RegisterForCL(SwingMissed, "SWING_MISSED", {dst_is_interesting_nopets = true})

		Skada:AddMode(self, L["Damage Taken"])
	end

	function mod:OnDisable()
		Skada:RemoveMode(self)
	end

	function mod:AddToTooltip(set, tooltip)
		local dps, amount = getRaidDTPS(set)
		if amount > 0 then
			tooltip:AddDoubleLine(L["Damage Taken"], Skada:FormatNumber(amount), 1, 1, 1)
			tooltip:AddDoubleLine(L["DTPS"], Skada:FormatNumber(dps), 1, 1, 1)
		end
	end

	function mod:GetSetSummary(set)
		local dtps, total = getRaidDTPS(set)
		return Skada:FormatValueText(
			Skada:FormatNumber(total),
			self.metadata.columns.Damage,
			Skada:FormatNumber(dtps),
			self.metadata.columns.DTPS
		)
	end

	function mod:SetComplete(set)
		-- clear set.
		if set.damagetaken and set.damagetaken.amount == 0 then
			set.damagetaken.sources = nil
		end
		-- clear players.
		for _, player in _ipairs(set.players) do
			if player.damagetaken and player.damagetaken.amount == 0 then
				player.damagetaken.spells = nil
				player.damagetaken.sources = nil
			end
		end
	end
end)

-- ============================== --
-- Damage taken per second module --
-- ============================== --

Skada:AddLoadableModule("DTPS", function(Skada, L)
	if Skada:IsDisabled("Damage Taken", "DTPS") then return end

	local parentmod = Skada:GetModule(L["Damage Taken"], true)
	if not parentmod then return end

	local mod = Skada:NewModule(L["DTPS"])
	local getDTPS = parentmod.getDTPS
	local getRaidDTPS = parentmod.getRaidDTPS

	function mod:Update(win, set)
		win.title = L["DTPS"]
		local total = getRaidDTPS(set)

		if total > 0 then
			local maxvalue, nr = 0, 1

			for _, player in _ipairs(set.players) do
				local amount = getDTPS(set, player)

				if amount > 0 then
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = player.id
					d.label = player.name
					d.class = player.class or "PET"
					d.role = player.role or "DAMAGER"
					d.spec = player.spec or 1

					d.value = amount
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(amount),
						self.metadata.columns.DTPS,
						_format("%02.1f%%", 100 * amount / total),
						self.metadata.columns.Percent
					)

					if amount > maxvalue then
						maxvalue = amount
					end
					nr = nr + 1
				end
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	function mod:OnEnable()
		self.metadata = {
			showspots = true,
			click1 = parentmod.metadata.click1,
			click2 = parentmod.metadata.click2,
			columns = {DTPS = true, Percent = true},
			icon = "Interface\\Icons\\spell_fire_twilightpyroblast"
		}

		Skada:AddMode(self, L["Damage Taken"])
	end

	function mod:OnDisable()
		Skada:RemoveMode(self)
	end

	function mod:GetSetSummary(set)
		return Skada:FormatNumber(getRaidDTPS(set))
	end
end)

-- ============================ --
-- Damage taken by spell Module --
-- ============================ --

Skada:AddLoadableModule("Damage Taken By Spell", function(Skada, L)
	if Skada:IsDisabled("Damage Taken", "Damage Taken By Spell") then return end

	local mod = Skada:NewModule(L["Damage Taken By Spell"])
	local playermod = mod:NewModule(L["Damage spell targets"])

	local cached = Skada:WeakTable()

	function playermod:Enter(win, id, label)
		win.spellname = label
		win.title = _format(L["%s's targets"], label)
	end

	function playermod:Update(win, set)
		if win.selectedset ~= "total" and win.spellname and cached[win.spellname] then
			win.title = _format(L["%s's targets"], win.spellname or UNKNOWN)
			local total = math_max(1, cached[win.spellname].amount)
			local maxvalue, nr = 0, 1

			for playername, player in _pairs(cached[win.spellname].players) do
				local d = win.dataset[nr] or {}
				win.dataset[nr] = d

				d.id = player.id
				d.label = playername
				d.class = player.class or "PET"
				d.role = player.role or "DAMAGER"
				d.spec = player.spec or 1

				d.value = player.amount
				d.valuetext = Skada:FormatValueText(
					Skada:FormatNumber(player.amount),
					mod.metadata.columns.Damage,
					_format("%02.1f%%", 100 * player.amount / total),
					mod.metadata.columns.Percent
				)

				if player.amount > maxvalue then
					maxvalue = player.amount
				end
				nr = nr + 1
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	-- for performance purposes, we ignore total segment
	function mod:Update(win, set)
		win.title = L["Damage Taken By Spell"]

		if win.selectedset ~= "total" then
			local total = set.damagetaken and set.damagetaken.amount or 0
			if total == 0 then return end

			cached = {}
			for _, player in _ipairs(set.players) do
				if player.damagetaken and (player.damagetaken.amount or 0) > 0 then
					for spellname, spell in _pairs(player.damagetaken.spells) do
						if spell.amount > 0 then
							if not cached[spellname] then
								cached[spellname] = {
									id = spell.id,
									school = spell.school,
									amount = (spell.amount or 0),
									isdot = spell.isdot,
									players = {}
								}
							else
								cached[spellname].amount = cached[spellname].amount + spell.amount
							end

							-- add the players
							if not cached[spellname].players[player.name] then
								cached[spellname].players[player.name] = {
									id = player.id,
									class = player.class or "PET",
									role = player.role or "DAMAGER",
									spec = player.spec or 1,
									amount = spell.amount
								}
							else
								cached[spellname].players[player.name].amount = cached[spellname].players[player.name].amount + spell.amount
							end
						end
					end
				end
			end

			local maxvalue, nr = 0, 1

			for spellname, spell in _pairs(cached) do
				local d = win.dataset[nr] or {}
				win.dataset[nr] = d

				d.id = spellname
				d.spellid = spell.id
				d.label = spellname
				d.text = spellname .. (spell.isdot and L["DoT"] or "")
				d.icon = _select(3, _GetSpellInfo(spell.id))
				d.spellschool = spell.school

				d.value = spell.amount
				d.valuetext = Skada:FormatValueText(
					Skada:FormatNumber(spell.amount),
					self.metadata.columns.Damage,
					_format("%02.1f%%", 100 * spell.amount / total),
					self.metadata.columns.Percent
				)

				if spell.amount > maxvalue then
					maxvalue = spell.amount
				end
				nr = nr + 1
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	function mod:OnEnable()
		playermod.metadata = {showspots = true}
		self.metadata = {
			showspots = true,
			click1 = playermod,
			columns = {Damage = true, Percent = true},
			icon = "Interface\\Icons\\spell_arcane_starfire"
		}
		Skada:AddMode(self, L["Damage Taken"])
	end

	function mod:OnDisable()
		Skada:RemoveMode(self)
	end
end)

-- ============================= --
-- Avoidance & Mitigation Module --
-- ============================= --

Skada:AddLoadableModule("Avoidance & Mitigation", function(Skada, L)
	if Skada:IsDisabled("Damage Taken", "Avoidance & Mitigation") then return end

	local mod = Skada:NewModule(L["Avoidance & Mitigation"])
	local playermod = mod:NewModule(L["Damage Breakdown"])

	local temp = Skada:WeakTable()

	function playermod:Enter(win, id, label)
		win.playerid, win.playername = id, label
		win.title = _format(L["%s's damage breakdown"], label)
	end

	function playermod:Update(win, set)
		if temp[win.playerid] then
			local player = temp[win.playerid]
			local maxvalue, nr = 0, 1
			win.title = _format(L["%s's damage breakdown"], player.name)

			for event, count in _pairs(player.data) do
				local d = win.dataset[nr] or {}
				win.dataset[nr] = d

				d.id = event
				d.label = _G[event] or event

				d.value = 100 * count / player.total
				d.valuetext = Skada:FormatValueText(
					_format("%02.1f%%", d.value), mod.metadata.columns.Percent,
					count, mod.metadata.columns.Count,
					player.total, mod.metadata.columns.Total
				)

				if d.value > maxvalue then
					maxvalue = d.value
				end
				nr = nr + 1
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	function mod:Update(win, set)
		win.title = L["Avoidance & Mitigation"]
		if set.damagetaken and (set.damagetaken.amount or 0) > 0 then
			local maxvalue, nr = 0, 1

			for _, player in _ipairs(set.players) do
				if player.damagetaken and (player.damagetaken.amount or 0) > 0 then
					local tmp = {name = player.name, data = {}}

					local total, avoid = 0, 0
					if player.damagetaken.spells then
						for spellname, spell in _pairs(player.damagetaken.spells) do
							total = total + spell.totalhits

							for _, t in _ipairs(misstypes) do
								if (spell[t] or 0) > 0 then
									avoid = avoid + spell[t]
									if not tmp.data[t] then
										tmp.data[t] = spell[t]
									else
										tmp.data[t] = tmp.data[t] + spell[t]
									end
								end
							end
						end
					end

					if avoid > 0 then
						-- cache the player first.
						tmp.total = total
						tmp.avoid = avoid
						temp[player.id] = tmp

						local d = win.dataset[nr] or {}
						win.dataset[nr] = d

						d.id = player.id
						d.label = player.name
						d.class = player.class or "PET"
						d.role = player.role or "DAMAGER"
						d.spec = player.spec or 1

						d.value = 100 * avoid / total
						d.valuetext = Skada:FormatValueText(
							_format("%02.1f%%", d.value), self.metadata.columns.Percent,
							avoid, self.metadata.columns.Count,
							total, self.metadata.columns.Total
						)

						if d.value > maxvalue then
							maxvalue = d.value
						end
						nr = nr + 1
					end
				end
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	function mod:OnEnable()
		self.metadata = {
			showspots = true,
			click1 = playermod,
			columns = {Percent = true, Count = true, Total = true},
			icon = "Interface\\Icons\\ability_warrior_shieldwall"
		}

		Skada:AddMode(self, L["Damage Taken"])
	end

	function mod:OnDisable()
		Skada:RemoveMode(self)
	end
end)

-- ================ --
-- Damage mitigated --
-- ================ --

Skada:AddLoadableModule("Damage Mitigated", function(Skada, L)
	if Skada:IsDisabled("Damage Taken", "Damage Mitigated") then return end

	local mod = Skada:NewModule(L["Damage Mitigated"])
	local playermod = mod:NewModule(L["Damage spell list"])
	local spellmod = mod:NewModule(L["Damage spell details"])

	local function getMIT(player)
		local amount, total = 0, 0
		if player and player.damagetaken then
			amount =
				(player.damagetaken.absorbed or 0) + (player.damagetaken.blocked or 0) +
				(player.damagetaken.resisted or 0)
			total = (player.damagetaken.amount or 0) + amount
		end
		return amount, total
	end

	local function getRaidMIT(set)
		if set and set.damagetaken then
			amount =
				(set.damagetaken.absorbed or 0) + (set.damagetaken.blocked or 0) + (set.damagetaken.resisted or 0)
			total = (set.damagetaken.amount or 0) + amount
		end
		return amount or 0, total or 0
	end

	function spellmod:Enter(win, id, label)
		win.spellname = id
		win.title = _format(L["%s's <%s> mitigated damage"], win.playername or UNKNOWN, label)
	end

	function spellmod:Update(win, set)
		local player = Skada:find_player(set, win.playerid, win.playername)

		if player then
			win.title = _format(L["%s's <%s> mitigated damage"], player.name, win.spellname or UNKNOWN)

			local spell
			if player.damagetaken and player.damagetaken.spells and player.damagetaken.spells[win.spellname] then
				spell = player.damagetaken.spells[win.spellname]
			end

			if spell then
				local mit = (spell.blocked or 0) + (spell.absorbed or 0) + (spell.resisted or 0)
				local total = mit + spell.amount
				local maxvalue, nr = total, 1

				-- start of total bar --
				local d = win.dataset[nr] or {}
				win.dataset[nr] = d
				d.id = L["Total"]
				d.label = L["Total"]
				d.value = total
				d.valuetext = Skada:FormatNumber(total)
				-- endstart of total bar --

				-- start of amount bar --
				nr = nr + 1
				d = win.dataset[nr] or {}
				win.dataset[nr] = d
				d.id = L["Damage Taken"]
				d.label = L["Damage Taken"]
				d.value = spell.amount or 0
				d.valuetext =
					Skada:FormatValueText(
					Skada:FormatNumber(spell.amount),
					mod.metadata.columns.Amount,
					_format("%02.1f%%", 100 * spell.amount / math_max(1, total)),
					mod.metadata.columns.Percent
				)
				-- endstart of amount bar --

				if (spell.absorbed or 0) > 0 then
					nr = nr + 1
					d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = ABSORB
					d.label = ABSORB
					d.value = spell.absorbed
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(spell.absorbed),
						mod.metadata.columns.Amount,
						_format("%02.1f%%", 100 * spell.absorbed / math_max(1, total)),
						mod.metadata.columns.Percent
					)

					if spell.absorbed > maxvalue then
						maxvalue = spell.absorbed
					end
				end

				if (spell.blocked or 0) > 0 then
					nr = nr + 1
					d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = BLOCK
					d.label = BLOCK
					d.value = spell.blocked
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(spell.blocked),
						mod.metadata.columns.Amount,
						_format("%02.1f%%", 100 * spell.blocked / math_max(1, total)),
						mod.metadata.columns.Percent
					)

					if spell.blocked > maxvalue then
						maxvalue = spell.blocked
					end
				end

				if (spell.resisted or 0) > 0 then
					nr = nr + 1
					d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = RESIST
					d.label = RESIST
					d.value = spell.resisted
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(spell.resisted),
						mod.metadata.columns.Amount,
						_format("%02.1f%%", 100 * spell.resisted / math_max(1, total)),
						mod.metadata.columns.Percent
					)

					if spell.resisted > maxvalue then
						maxvalue = spell.resisted
					end
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	function playermod:Enter(win, id, label)
		win.playerid, win.playername = id, label
		win.title = _format(L["%s's mitigated damage"], label)
	end

	function playermod:Update(win, set)
		local player = Skada:find_player(set, win.playerid, win.playername)
		if player then
			win.title = _format(L["%s's mitigated damage"], player.name)
			local total = getMIT(player)

			if total > 0 then
				local maxvalue, nr = 0, 1

				for spellname, spell in pairs(player.damagetaken.spells) do
					local amount = (spell.blocked or 0) + (spell.absorbed or 0) + (spell.resisted or 0)
					if amount > 0 then
						local d = win.dataset[nr] or {}
						win.dataset[nr] = d

						d.id = spellname
						d.spellid = spell.id
						d.label = spellname
						d.text = spellname .. (spell.isdot and L["DoT"] or "")
						d.icon = _select(3, _GetSpellInfo(spell.id))
						d.spellschool = spell.school

						d.value = amount
						d.valuetext = Skada:FormatValueText(
							Skada:FormatNumber(amount),
							mod.metadata.columns.Amount,
							Skada:FormatNumber(total),
							mod.metadata.columns.Total,
							_format("%02.1f%%", 100 * amount / total),
							mod.metadata.columns.Percent
						)

						if amount > maxvalue then
							maxvalue = amount
						end
						nr = nr + 1
					end
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	function mod:Update(win, set)
		win.title = L["Damage Mitigated"]

		if set.damagetaken and (set.damagetaken.amount) > 0 then
			local maxvalue, nr = 0, 1

			for _, player in _ipairs(set.players) do
				local amount, total = getMIT(player)

				if amount > 0 then
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = player.id
					d.label = player.name
					d.class = player.class or "PET"
					d.role = player.role or "DAMAGER"
					d.spec = player.spec or 1

					d.value = amount
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(amount),
						self.metadata.columns.Amount,
						Skada:FormatNumber(total),
						self.metadata.columns.Total,
						_format("%02.1f%%", 100 * amount / total),
						self.metadata.columns.Percent
					)

					if amount > maxvalue then
						maxvalue = amount
					end

					nr = nr + 1
				end
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	function mod:OnEnable()
		playermod.metadata = {click1 = spellmod}
		self.metadata = {
			showspots = true,
			click1 = playermod,
			columns = {Amount = true, Total = true, Percent = true},
			icon = "Interface\\Icons\\spell_shadow_shadowward"
		}
		Skada:AddMode(self, L["Damage Taken"])
	end

	function mod:OnDisable()
		Skada:RemoveMode(self)
	end

	function mod:GetSetSummary(set)
		local amount, total = getRaidMIT(set)
		return Skada:FormatValueText(
			Skada:FormatNumber(amount),
			self.metadata.columns.Amount,
			Skada:FormatNumber(total),
			self.metadata.columns.Total,
			_format("%02.1f%%", 100 * amount / math_max(1, total)),
			self.metadata.columns.Percent
		)
	end
end)