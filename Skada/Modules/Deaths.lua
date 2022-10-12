local _, Skada = ...
local Private = Skada.Private
Skada:RegisterModule("Deaths", function(L, P, _, _, M)
	local mod = Skada:NewModule("Deaths")
	local playermod = mod:NewModule("Player's deaths")
	local deathlogmod = mod:NewModule("Death log")
	-- local ignored_buffs = Skada.dummyTable -- Edit Skada\Core\Tables.lua
	local ignored_debuffs = Skada.dummyTable -- Edit Skada\Core\Tables.lua
	local WATCH = nil -- true to watch those alive

	local tinsert, tremove, tsort, tconcat = table.insert, Private.tremove, table.sort, table.concat
	local strmatch, format, uformat = strmatch, string.format, Private.uformat
	local max, floor, abs = math.max, math.floor, math.abs
	local new, del, clear = Private.newTable, Private.delTable, Private.clearTable
	local UnitHealthInfo = Skada.UnitHealthInfo
	local UnitIsFeignDeath = UnitIsFeignDeath
	local GetSpellInfo = Private.spell_info or GetSpellInfo
	local GetSpellLink = Private.spell_link or GetSpellLink
	local IsInGroup, IsInPvP = Skada.IsInGroup, Skada.IsInPvP
	local GetTime, time, date = GetTime, time, date
	local mod_cols, submod_cols = nil, nil

	-- cache colors
	local GRAY_COLOR = GRAY_FONT_COLOR
	local GREEN_COLOR = GREEN_FONT_COLOR
	local ORANGE_COLOR = ORANGE_FONT_COLOR
	local RED_COLOR = RED_FONT_COLOR
	local YELLOW_COLOR = YELLOW_FONT_COLOR
	local PURPLE_COLOR = {r = 0.69, g = 0.38, b = 1}
	-- local BLUE_COLOR = {r = 0.176, g = 0.318, b = 1}
	local icon_mode = [[Interface\Icons\Ability_Rogue_FeignDeath]]
	local icon_death = [[Interface\Icons\Spell_Shadow_Soulleech_1]]

	local function get_color(key)
		if P.usecustomcolors and P.customcolors and P.customcolors["deathlog_" .. key] then
			return P.customcolors["deathlog_" .. key]
		elseif key == "orange" then
			return ORANGE_COLOR
		elseif key == "yellow" then
			return YELLOW_COLOR
		elseif key == "green" then
			return GREEN_COLOR
		elseif key == "purple" then
			return PURPLE_COLOR
		-- elseif key == "blue" then
		-- 	return BLUE_COLOR
		else
			return RED_COLOR
		end
	end

	local data = {}
	local function log_deathlog(set, override)
		if not set or (set == Skada.total and not P.totalidc) then return end

		local player = Skada:GetPlayer(set, data.playerid, data.playername, data.playerflags)
		if not player then return end

		local deathlog = player.deathlog and player.deathlog[1]
		if not deathlog or (deathlog.timeod and not override) then
			player.deathlog = player.deathlog or {}
			tinsert(player.deathlog, 1, {log = new()})
			deathlog = player.deathlog[1]
		end

		-- seet player maxhp if not already set
		if not deathlog.hpm or deathlog.hpm == 0 then
			_, _, deathlog.hpm = UnitHealthInfo(player.name, player.id, "group")
			deathlog.hpm = deathlog.hpm or 0
		end

		local log = new()
		log.id = data.spellid
		log.sch = data.school
		log.src = data.srcName
		log.cri = data.critical
		log.time = set.last_time or GetTime()
		_, log.hp = UnitHealthInfo(player.name, player.id, "group")

		if data.amount then
			deathlog.time = log.time
			log.aur = nil
			log.rem = nil

			if data.amount == true then -- instakill
				log.amt = -log.hp
				deathlog.id = log.id
				deathlog.sch = log.sch
				deathlog.src = log.src
			elseif data.amount ~= 0 then
				log.amt = data.amount

				if log.amt < 0 then
					deathlog.id = log.id
					deathlog.sch = log.sch
					deathlog.src = log.src
				end
			end
		elseif data.aura then
			log.aur = 1
			log.rem = data.remove and 1 or nil
		end

		if data.overheal and data.overheal > 0 then
			log.ovh = data.overheal
		end
		if data.overkill and data.overkill > 0 then
			log.ovk = data.overkill
		end
		if data.resisted and data.resisted > 0 then
			log.res = data.resisted
		end
		if data.blocked and data.blocked > 0 then
			log.blo = data.blocked
		end
		if data.absorbed and data.absorbed > 0 then
			log.abs = data.absorbed
		end

		tinsert(deathlog.log, 1, log)

		-- trim things and limit to deathlogevents (defaul: 14)
		if #deathlog.log > M.deathlogevents then
			del(tremove(deathlog.log))
		end
	end

	local function spell_damage(_, event, _, srcName, _, dstGUID, dstName, dstFlags, ...)
		if event == "SWING_DAMAGE" then
			data.spellid, data.school = 6603, 0x01
			data.amount, data.overkill, _, data.resisted, data.blocked, data.absorbed, data.critical = ...
			data.amount = 0 - data.amount
		elseif event == "SPELL_INSTAKILL" then
			data.spellid, _, data.school = ...
			data.amount = true
		else
			data.spellid, _, data.school, data.amount, data.overkill, _, data.resisted, data.blocked, data.absorbed, data.critical = ...
			data.amount = 0 - data.amount
		end

		if data.amount then
			data.srcName = srcName
			data.playerid = dstGUID
			data.playername = dstName
			data.playerflags = dstFlags

			data.overheal = nil

			Skada:DispatchSets(log_deathlog)
		end
	end

	local missTypes = {RESIST = true, BLOCK = true, ABSORB = true}
	local function spell_missed(_, event, _, srcName, _, dstGUID, dstName, dstFlags, ...)
		local misstype, amount

		if event == "SWING_MISSED" then
			data.spellid, data.school = 6603, 0x01
			misstype, amount = ...
		else
			data.spellid, _, data.school, misstype, amount = ...
		end

		if amount and amount > 0 and misstype and missTypes[misstype] then
			data.srcName = srcName
			data.playerid = dstGUID
			data.playername = dstName
			data.playerflags = dstFlags

			data.amount = nil
			data.overkill = nil
			data.overheal = nil
			data.critical = nil
			data.aura = nil
			data.remove = nil

			if misstype == "RESIST" then
				data.resisted = amount
				data.blocked = nil
				data.absorbed = nil
			elseif misstype == "BLOCK" then
				data.resisted = nil
				data.blocked = amount
				data.absorbed = nil
			elseif misstype == "ABSORB" then
				data.resisted = nil
				data.blocked = nil
				data.absorbed = amount
			end

			Skada:DispatchSets(log_deathlog)
		end
	end

	local function environment_damage(_, _, _, _, _, dstGUID, dstName, dstFlags, envtype, amount)
		local spellid, spellschool = nil, 0x01

		if envtype == "Falling" or envtype == "FALLING" then
			spellid = 3
		elseif envtype == "Drowning" or envtype == "DROWNING" then
			spellid = 4
		elseif envtype == "Fatigue" or envtype == "FATIGUE" then
			spellid = 5
		elseif envtype == "Fire" or envtype == "FIRE" then
			spellid, spellschool = 6, 0x04
		elseif envtype == "Lava" or envtype == "LAVA" then
			spellid, spellschool = 7, 0x04
		elseif envtype == "Slime" or envtype == "SLIME" then
			spellid, spellschool = 8, 0x08
		end

		if spellid then
			spell_damage(nil, nil, nil, L["Environment"], nil, dstGUID, dstName, dstFlags, spellid, nil, spellschool, amount)
		end
	end

	local function spell_heal(_, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellid, _, _, amount, overheal)
		if spellid and amount and (not M.deathlogthreshold or amount > M.deathlogthreshold) then
			srcGUID, srcName = Skada:FixMyPets(srcGUID, srcName, srcFlags)
			dstGUID, dstName = Skada:FixMyPets(dstGUID, dstName, dstFlags)

			data.srcName = srcName

			data.playerid = dstGUID
			data.playername = dstName
			data.playerflags = dstFlags

			data.spellid = spellid
			data.amount = amount

			data.school = nil
			data.overheal = nil
			data.overkill = nil
			data.resisted = nil
			data.blocked = nil
			data.absorbed = nil
			data.critical = nil
			data.aura = nil
			data.remove = nil

			if overheal and overheal > 0 then
				data.amount = max(0, data.amount - overheal)
				data.overheal = overheal
			end

			Skada:DispatchSets(log_deathlog)
		end
	end

	local function log_death(set, playerid, playername, playerflags)
		local player = Skada:GetPlayer(set, playerid, playername, playerflags)
		if not player then return end

		set.death = (set.death or 0) + 1
		player.death = (player.death or 0) + 1

		-- saving this to total set may become a memory hog deluxe.
		if set == Skada.total and not P.totalidc then return end

		local deathlog = player.deathlog and player.deathlog[1]
		if not deathlog then return end

		deathlog.time = set.last_time or GetTime()
		deathlog.timeod = set.last_action or time()

		for i = #deathlog.log, 1, -1 do
			local e = deathlog.log[i]
			if (deathlog.time - e.time) >= 60 then
				-- in certain situations, such us The Ruby Sanctum,
				-- deathlog contain old data which are irrelevant to keep.
				del(tremove(deathlog.log, i))
			else
				-- sometimes multiple close events arrive with the same timestamp
				-- so we add a small correction to ensure sort stability.
				e.time = e.time + (i * 0.001)
			end
		end

		-- no entry left? insert an unknown entry
		if #deathlog.log == 0 then
			local log = new()
			log.amt = -deathlog.hpm
			log.time = deathlog.time - 0.001
			log.hp = deathlog.hpm
			deathlog.log[#deathlog.log + 1] = log
		end

		-- announce death
		if M.deathannounce and set ~= Skada.total then
			mod:Announce(deathlog.log, player.name)
		end
	end

	local function unit_died(_, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags)
		if not UnitIsFeignDeath(dstName) then
			Skada:DispatchSets(log_death, dstGUID, dstName, dstFlags)
		end
	end

	local function sor_applied(_, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellid)
		if spellid == 27827 then -- Spirit of Redemption (Holy Priest)
			Skada:ScheduleTimer(function() unit_died(nil, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags) end, 0.01)
		end
	end

	local resurrectSpells = {
		-- Rebirth
		[20484] = true,
		[20739] = true,
		[20742] = true,
		[20747] = true,
		[20748] = true,
		[26994] = true,
		[48477] = true,
		-- Reincarnation
		[16184] = true,
		[16209] = true,
		[20608] = true,
		[21169] = true,
		-- Use Soulstone
		[3026] = true,
		[20758] = true,
		[20759] = true,
		[20760] = true,
		[20761] = true,
		[27240] = true,
		[47882] = true
	}

	local function spell_resurrect(_, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellid)
		if spellid and (event == "SPELL_RESURRECT" or resurrectSpells[spellid]) then
			data.spellid = spellid

			if event == "SPELL_RESURRECT" then
				data.srcName = srcName
				data.playerid = dstGUID
				data.playername = dstName
				data.playerflags = dstFlags
			else
				data.srcName = srcName
				data.playerid = srcGUID
				data.playername = srcName
				data.playerflags = srcFlags
			end

			data.school = nil
			data.amount = nil
			data.overkill = nil
			data.overheal = nil
			data.resisted = nil
			data.blocked = nil
			data.absorbed = nil
			data.critical = nil
			data.aura = nil
			data.remove = nil

			Skada:DispatchSets(log_deathlog, true)
		end
	end

	local function handle_aura(dstGUID, dstName, dstFlags, srcName, spellid, spellschool, removed)
		data.spellid = spellid
		data.school = spellschool
		data.aura = true
		data.remove = removed or nil

		data.srcName = (srcName ~= dstName) and srcName or nil
		data.playerid = dstGUID
		data.playername = dstName
		data.playerflags = dstFlags

		data.amount = nil
		data.overkill = nil
		data.overheal = nil
		data.resisted = nil
		data.blocked = nil
		data.absorbed = nil
		data.critical = nil

		Skada:DispatchSets(log_deathlog)
	end

	-- local function handle_buff(_, event, _, srcName, _, dstGUID, dstName, dstFlags, spellid, _, spellschool, auratype)
	-- 	if auratype == "BUFF" and spellid and not ignored_buffs[spellid] then
	-- 		handle_aura(dstGUID, dstName, dstFlags, srcName, spellid, spellschool, event == "SPELL_AURA_REMOVED")
	-- 	end
	-- end

	local function handle_debuff(_, event, _, srcName, _, dstGUID, dstName, dstFlags, spellid, _, spellschool, auratype)
		if auratype == "DEBUFF" and spellid and not ignored_debuffs[spellid] then
			handle_aura(dstGUID, dstName, dstFlags, srcName, -spellid, spellschool, event == "SPELL_AURA_REMOVED")
		end
	end

	function deathlogmod:Enter(win, id, label)
		if M.alternativedeaths then
			win.actorid, win.datakey = strmatch(id, "(%w+)::(%d+)")
			win.datakey = tonumber(win.datakey or 0)
			win.actorname = label
		else
			win.datakey = id
		end

		win.title = uformat(L["%s's death log"], win.actorname)
	end

	do
		local function sort_logs(a, b)
			return a and b and a.time > b.time
		end

		function deathlogmod:Update(win, set)
			win.title = uformat(L["%s's death log"], win.actorname)

			local player = win.datakey and Skada:FindPlayer(set, win.actorid, win.actorname)
			local deathlog = player and player.deathlog and player.deathlog[win.datakey]
			if not deathlog then return end

			if M.alternativedeaths then
				local num = #player.deathlog
				if win.datakey ~= num then
					win.title = format("%s (%d)", win.title, num - win.datakey + 1)
				end
			end

			if win.metadata then
				win.metadata.maxvalue = deathlog.hpm
			end

			local nr = 0

			-- 1. remove "datakey" from ended logs.
			-- 2. postfix empty table
			-- 3. add a fake entry for the actual death
			if deathlog.timeod then
				win.datakey = nil -- [1]

				if #deathlog.log == 0 then -- [2]
					local log = new()
					log.time = deathlog.time - 0.001
					if deathlog.hpm then
						log.amt = -deathlog.hpm
						log.hp = deathlog.hpm
					else
						log.amt = 0
						log.hp = 0
					end
					deathlog.log[1] = log
				end

				if win.metadata then -- [3]
					nr = nr + 1
					local d = win:nr(nr)

					d.id = nr
					d.label = date("%H:%M:%S", deathlog.timeod)
					d.icon = icon_mode
					d.color = nil
					d.value = 0
					d.valuetext = format(L["%s dies"], player.name)
				end
			end

			tsort(deathlog.log, sort_logs)

			local curtime = deathlog.time or set.last_time or GetTime()
			for i = #deathlog.log, 1, -1 do
				local log = deathlog.log[i]
				local diff = tonumber(log.time) - tonumber(curtime)
				if diff > -60 then
					nr = i + 1
					local d = win:nr(nr)

					if log.id then
						d.spellid = log.id
						d.label, _, d.icon = GetSpellInfo(abs(log.id))
					else
						d.label = L["Unknown"]
						d.spellid = nil
						d.icon = icon_death
					end

					d.id = i
					d.text = format("%s%02.2fs: %s", diff > 0 and "+" or "", diff, d.label)

					-- used for tooltip
					d.value = log.hp or 0

					local src = log.src or L["Unknown"]

					if d.spellid and resurrectSpells[d.spellid] then
						d.color = nil
						d.valuetext = src
					else
						local color = get_color("red")
						local change = log.amt or 0

						-- if log.aur and d.spellid > 0 then
						-- 	change = format("%s %s", log.rem and "-" or "+", L["buff"])
						-- 	color = get_color("blue")
						if log.aur or log.deb then
							change = format("%s %s", log.rem and "-" or "+", L["debuff"])
							color = get_color("purple")
						elseif change > 0 then
							change = "+" .. Skada:FormatNumber(change)
							color = get_color("green")
						elseif change == 0 and (log.res or log.blo or log.abs) then
							change = "+" .. Skada:FormatNumber(log.res or log.blo or log.abs)
							color = get_color("orange")
						elseif log.ovh then
							change = "+" .. Skada:FormatNumber(log.ovh)
							color = get_color("yellow")
						elseif log.cri then
							change = format("%s (%s)", Skada:FormatNumber(change), L["Crit"])
						else
							change = Skada:FormatNumber(change)
						end

						d.changed = (WATCH and color ~= d.color) and true or (WATCH and d.changed) and nil
						d.color = color

						-- only format report for ended logs
						if deathlog.timeod ~= nil then
							d.reportlabel = "%02.2fs: %s (%s)   %s [%s]"

							if P.reportlinks and log.id then
								d.reportlabel = format(d.reportlabel, diff, GetSpellLink(log.id) or d.label, src, change, Skada:FormatNumber(d.value))
							else
								d.reportlabel = format(d.reportlabel, diff, d.label, src, change, Skada:FormatNumber(d.value))
							end

							local extra = new()

							if log.ovh and log.ovh > 0 then
								extra[#extra + 1] = "O:" .. Skada:FormatNumber(log.ovh)
							end
							if log.ovk and log.ovk > 0 then
								extra[#extra + 1] = "O:" .. Skada:FormatNumber(log.ovk)
							end
							if log.res and log.res > 0 then
								extra[#extra + 1] = "R:" .. Skada:FormatNumber(log.res)
							end
							if log.blo and log.blo > 0 then
								extra[#extra + 1] = "B:" .. Skada:FormatNumber(log.blo)
							end
							if log.abs and log.abs > 0 then
								extra[#extra + 1] = "A:" .. Skada:FormatNumber(log.abs)
							end

							if next(extra) then
								d.reportlabel = format("%s (%s)", d.reportlabel, tconcat(extra, " - "))
							end

							extra = del(extra)
						end

						d.valuetext = Skada:FormatValueCols(
							submod_cols.Change and change,
							submod_cols.Health and Skada:FormatNumber(d.value),
							submod_cols.Percent and Skada:FormatPercent(log.hp or 0, deathlog.hpm or 1)
						)
					end
				else
					del(tremove(deathlog.log, i))
				end
			end
		end
	end

	function playermod:Enter(win, id, label)
		win.actorid, win.actorname = id, label
		win.title = format(L["%s's deaths"], label)
	end

	function playermod:Update(win, set)
		win.title = uformat(L["%s's deaths"], win.actorname)
		if not set or not win.actorid then return end

		local actor, enemy = set:GetActor(win.actorname, win.actorid)
		if not actor or enemy then return end

		local deathlog = (actor.death or WATCH) and actor.deathlog
		if not deathlog then
			return
		elseif win.metadata then
			win.metadata.maxvalue = 0
		end

		local nr = 0
		local curtime = set.last_time or GetTime()

		for i = 1, #deathlog do
			local death = deathlog[i]
			if death and (death.timeod or WATCH) then
				nr = nr + 1

				local d = win:nr(nr)
				d.id = i

				if death.id then -- spell id
					d.label, _, d.icon = GetSpellInfo(death.id)
					d.spellschool = death.sch
				end

				d.icon = d.icon or icon_death
				d.label = d.label or L["Unknown"]
				if mod_cols.Source and death.src then
					d.text = format("%s (%s)", d.label, death.src)
				end

				d.value = death.time or curtime
				if death.timeod then
					d.valuetext = Skada:FormatValueCols(
						mod_cols.Time and date("%H:%M:%S", death.timeod),
						mod_cols.Survivability and Skada:FormatTime(death.timeod - set.starttime, true)
					)
				else
					d.valuetext = "..."
				end

				if win.metadata and d.value > win.metadata.maxvalue then
					win.metadata.maxvalue = d.value
				end
			end
		end
	end

	-- default Deaths module:
	local function mod_update(self, win, set)
		win.title = win.class and format("%s (%s)", L["Deaths"], L[win.class]) or L["Deaths"]

		if not set or not (set.death or WATCH) then
			return
		elseif win.metadata then
			win.metadata.maxvalue = 0
		end

		local nr = 0
		local curtime = set.last_time or GetTime()

		local actors = set.players -- players
		for i = 1, #actors do
			local p = actors[i]
			if win:show_actor(p, set) and (p.death or WATCH) then
				nr = nr + 1
				local d = win:actor(nr, p)

				if p.death then
					d.value = p.death
					d.valuetext = p.death

					if p.deathlog then
						local first_death = p.deathlog[#p.deathlog]
						if first_death and first_death.time then
							d.value = first_death.time
							d.color = (WATCH and first_death.time) and GRAY_COLOR or nil
						end
					end
				else
					d.value = curtime
					d.valuetext = "..."
					d.color = nil
				end
			end
		end
	end

	-- alternative Deaths module:
	local function alt_update(self, win, set)
		win.title = win.class and format("%s (%s)", L["Deaths"], L[win.class]) or L["Deaths"]

		if not set or not (set.death or WATCH) then
			return
		elseif win.metadata then
			win.metadata.maxvalue = 0
		end

		local nr = 0
		local curtime = set.last_time or GetTime()

		local actors = set.players -- players
		for i = 1, #actors do
			local p = actors[i]
			if win:show_actor(p, set) and p.deathlog and (p.death or WATCH) then
				local num = #p.deathlog
				for j = 1, num do
					local death = p.deathlog[j]
					if death and (death.timeod or WATCH) then
						nr = nr + 1
						local d = win:actor(nr, p)
						d.id = format("%s::%d", p.id, j)

						if death.timeod then
							d.color = WATCH and GRAY_COLOR or nil
							d.value = death.time
							d.valuetext = Skada:FormatValueCols(
								mod_cols.Time and date("%H:%M:%S", death.timeod),
								mod_cols.Survivability and Skada:FormatTime(death.timeod - set.starttime, true)
							)
						else
							d.color = nil
							d.value = curtime or GetTime()
							d.valuetext = "..."
						end

						local src = mod_cols.Source and death.src
						if num ~= 1 then
							d.text = format(src and "%s (%d) (%s)" or "%s (%d)", d.text or d.label, num, src)
							d.reportlabel = format("%s   %s", d.text, d.valuetext)
						else
							d.text = src and format("%s (%s)", d.text or d.label, src) or nil
							d.reportlabel = d.text and format("%s   %s", d.text, d.valuetext) or nil
						end

						num = num - 1
					end
				end
			end
		end
	end

	function mod:Update(win, set)
		if M.alternativedeaths and (set ~= Skada.total or P.totalidc) then
			alt_update(self, win, set)
		else
			mod_update(self, win, set)
		end
	end

	function mod:GetSetSummary(set, win)
		if not set then return end
		local deaths = set:GetTotal(win and win.class, nil, "death") or 0
		return set.last_time or GetTime(), deaths
	end

	function mod:AddToTooltip(set, tooltip)
		if set.death and set.death > 0 then
			tooltip:AddDoubleLine(DEATHS, set.death, 1, 1, 1)
		end
	end

	local function entry_tooltip(win, id, label, tooltip)
		local set = win:GetSelectedSet()
		local actor = set and set:GetActor(win.actorname, win.actorid)
		local deathlog = actor and actor.deathlog and win.datakey and actor.deathlog[win.datakey]
		local entry = deathlog and deathlog.log and deathlog.log[id]
		if not entry or not entry.id then return end

		tooltip:AddLine(L["Spell details"])
		tooltip:AddDoubleLine(L["Spell"], label, 1, 1, 1, 1, 1, 1)

		if entry.src then
			tooltip:AddDoubleLine(L["Source"], entry.src, 1, 1, 1, 1, 1, 1)
		end

		if entry.hp and entry.hp ~= 0 then
			tooltip:AddDoubleLine(HEALTH, Skada:FormatNumber(entry.hp), 1, 1, 1)
		end

		local c = nil

		if entry.amt and entry.amt ~= 0 then
			c = get_color(entry.amt < 0 and "red" or "green")
			tooltip:AddDoubleLine(L["Amount"], Skada:FormatNumber(entry.amt), 1, 1, 1, c.r, c.g, c.b)
		end

		if entry.ovk and entry.ovk > 0 then
			tooltip:AddDoubleLine(L["Overkill"], Skada:FormatNumber(entry.ovk), 1, 1, 1, 0.77, 0.64, 0)
		elseif entry.ovh and entry.ovh > 0 then
			c = get_color("yellow")
			tooltip:AddDoubleLine(L["Overheal"], Skada:FormatNumber(entry.ovh), 1, 1, 1, c.r, c.g, c.b)
		end

		if entry.res and entry.res > 0 then
			c = get_color("orange")
			tooltip:AddDoubleLine(L["RESIST"], Skada:FormatNumber(entry.res), 1, 1, 1, c.r, c.g, c.b)
		end

		if entry.blo and entry.blo > 0 then
			c = get_color("orange")
			tooltip:AddDoubleLine(L["BLOCK"], Skada:FormatNumber(entry.blo), 1, 1, 1, c.r, c.g, c.b)
		end

		if entry.abs and entry.abs > 0 then
			c = get_color("orange")
			tooltip:AddDoubleLine(L["ABSORB"], Skada:FormatNumber(entry.abs), 1, 1, 1, c.r, c.g, c.b)
		end
	end

	function mod:OnEnable()
		deathlogmod.metadata = {
			ordersort = true,
			tooltip = entry_tooltip,
			columns = {Change = true, Health = true, Percent = true},
			icon = icon_death
		}
		playermod.metadata = {click1 = deathlogmod}
		self.metadata = {
			click1 = playermod,
			click4 = Skada.FilterClass,
			click4_label = L["Toggle Class Filter"],
			columns = {Time = true, Survivability = false, Source = false},
			icon = icon_mode
		}

		-- alternative display
		if M.alternativedeaths then
			playermod.metadata.click1 = nil
			self.metadata.click1 = deathlogmod
		end

		mod_cols = self.metadata.columns
		submod_cols = deathlogmod.metadata.columns

		-- no total click.
		deathlogmod.nototal = true
		playermod.nototal = true

		local flags_dst_nopets = {dst_is_interesting_nopets = true}

		Skada:RegisterForCL(
			sor_applied,
			flags_dst_nopets,
			"SPELL_AURA_APPLIED"
		)

		Skada:RegisterForCL(
			spell_damage,
			flags_dst_nopets,
			"DAMAGE_SHIELD",
			"DAMAGE_SPLIT",
			"RANGE_DAMAGE",
			"SPELL_BUILDING_DAMAGE",
			"SPELL_DAMAGE",
			"SPELL_PERIODIC_DAMAGE",
			"SWING_DAMAGE",
			"SPELL_INSTAKILL"
		)

		Skada:RegisterForCL(
			spell_missed,
			flags_dst_nopets,
			"DAMAGE_SHIELD_MISSED",
			"RANGE_MISSED",
			"SPELL_BUILDING_MISSED",
			"SPELL_MISSED",
			"SPELL_PERIODIC_MISSED",
			"SWING_MISSED"
		)

		Skada:RegisterForCL(
			environment_damage,
			flags_dst_nopets,
			"ENVIRONMENTAL_DAMAGE"
		)

		Skada:RegisterForCL(
			spell_heal,
			flags_dst_nopets,
			"SPELL_HEAL",
			"SPELL_PERIODIC_HEAL"
		)

		Skada:RegisterForCL(
			unit_died,
			flags_dst_nopets,
			"UNIT_DIED",
			"UNIT_DESTROYED",
			"UNIT_DISSIPATES"
		)

		Skada:RegisterForCL(
			spell_resurrect,
			flags_dst_nopets,
			"SPELL_RESURRECT"
		)

		Skada:RegisterForCL(
			spell_resurrect,
			{src_is_interesting = true, dst_is_not_interesting = true},
			"SPELL_CAST_SUCCESS"
		)

		-- Skada:RegisterForCL(
		-- 	handle_buff,
		-- 	{dst_is_interesting_nopets = true},
		-- 	"SPELL_AURA_APPLIED",
		-- 	"SPELL_AURA_REFRESH",
		-- 	"SPELL_AURA_REMOVED",
		-- 	"SPELL_AURA_APPLIED_DOSE"
		-- )

		Skada:RegisterForCL(
			handle_debuff,
			{src_is_not_interesting = true, dst_is_interesting_nopets = true},
			"SPELL_AURA_APPLIED",
			"SPELL_AURA_REFRESH",
			"SPELL_AURA_REMOVED",
			"SPELL_AURA_APPLIED_DOSE"
		)

		Skada.RegisterMessage(self, "COMBAT_PLAYER_LEAVE", "CombatLeave")
		Skada:AddMode(self)

		if Skada.ignoredSpells then
			-- ignored_buffs = Skada.ignoredSpells.buffs or ignored_buffs
			ignored_debuffs = Skada.ignoredSpells.debuffs or ignored_debuffs
		end
	end

	function mod:OnDisable()
		Skada.UnregisterAllMessages(self)
		Skada:RemoveMode(self)
	end

	function mod:CombatLeave()
		clear(data)
	end

	function mod:SetComplete(set)
		-- clean deathlogs.
		for i = 1, #set.players do
			local player = set.players[i]
			if player and (not set.death or not player.death) then
				player.death, player.deathlog = nil, del(player.deathlog, true)
			elseif player and player.deathlog then
				while #player.deathlog > (player.death or 0) do
					del(tremove(player.deathlog, 1), true)
				end
				if #player.deathlog == 0 then
					player.deathlog = del(player.deathlog)
				end
			end
		end
	end

	function mod:Announce(logs, playername)
		-- announce only if:
		-- 	1. we have a valid deathlog.
		-- 	2. player is not in a pvp (spam caution).
		-- 	3. player is in a group or channel set to self or guild.
		if not logs or IsInPvP() then return end

		local channel = M.deathchannel
		if channel ~= "SELF" and channel ~= "GUILD" and not IsInGroup() then return end

		local log = nil
		for i = 1, #logs do
			local l = logs[i]
			if l and l.amt and l.amt < 0 then
				log = l
				break
			end
		end

		if not log then return end

		-- prepare the output.
		local output = format(
			(channel == "SELF") and "%s > %s (%s) %s" or "Skada: %s > %s (%s) %s",
			log.src or L["Unknown"], -- source name
			playername or L["Unknown"], -- player name
			log.id and GetSpellInfo(log.id) or L["Unknown"], -- spell name
			log.amt and Skada:FormatNumber(0 - log.amt, 1) or 0 -- spell amount
		)

		-- prepare any extra info.
		if log.ovk or log.res or log.blo or log.abs then
			local extra = new()

			if log.ovk then
				extra[#extra + 1] = format("O:%s", Skada:FormatNumber(log.ovk, 1))
			end
			if log.res then
				extra[#extra + 1] = format("R:%s", Skada:FormatNumber(log.res, 1))
			end
			if log.blo then
				extra[#extra + 1] = format("B:%s", Skada:FormatNumber(log.blo, 1))
			end
			if log.abs then
				extra[#extra + 1] = format("A:%s", Skada:FormatNumber(log.abs, 1))
			end
			if next(extra) then
				output = format("%s [%s]", output, tconcat(extra, " - "))
			end

			extra = del(extra)
		end

		Skada:SendChat(output, channel, "preset")
	end

	do
		local options
		local function get_options()
			if not options then
				options = {
					type = "group",
					name = mod.localeName,
					desc = format(L["Options for %s."], L["Death log"]),
					args = {
						header = {
							type = "description",
							name = mod.localeName,
							fontSize = "large",
							image = icon_mode,
							imageWidth = 18,
							imageHeight = 18,
							imageCoords = {0.05, 0.95, 0.05, 0.95},
							width = "full",
							order = 0
						},
						sep = {
							type = "description",
							name = " ",
							width = "full",
							order = 1
						},
						deathlog = {
							type = "group",
							name = L["Death log"],
							inline = true,
							order = 10,
							args = {
								deathlogevents = {
									type = "range",
									name = L["Events Amount"],
									desc = L["Set the amount of events the death log should record."],
									min = 4,
									max = 34,
									step = 1,
									order = 10
								},
								deathlogthreshold = {
									type = "range",
									name = L["Minimum Healing"],
									desc = L["Ignore heal events that are below this threshold."],
									min = 0,
									max = 10000,
									step = 1,
									bigStep = 10,
									order = 20
								}
							}
						},
						announce = {
							type = "group",
							name = L["Announce Deaths"],
							inline = true,
							order = 20,
							args = {
								anndesc = {
									type = "description",
									name = L["Announces information about the last hit the player took before they died."],
									fontSize = "medium",
									width = "full",
									order = 10
								},
								deathannounce = {
									type = "toggle",
									name = L["Enable"],
									order = 20
								},
								deathchannel = {
									type = "select",
									name = L["Channel"],
									values = {AUTO = INSTANCE, SELF = L["Self"], GUILD = GUILD},
									order = 30,
									disabled = function()
										return not M.deathannounce
									end
								}
							}
						},
						alternativedeaths = {
							type = "toggle",
							name = L["Alternative Display"],
							desc = L["If a player dies multiple times, each death will be displayed as a separate bar."],
							set = function(_, value)
								if M.alternativedeaths then
									M.alternativedeaths = nil
									mod.metadata.click1 = playermod
									playermod.metadata.click1 = deathlogmod
								else
									M.alternativedeaths = true
									mod.metadata.click1 = deathlogmod
									playermod.metadata.click1 = nil
								end

								mod:Reload()
								Skada:Wipe(true)
								Skada:UpdateDisplay(true)
							end,
							width = "full",
							order = 30
						}
					}
				}
			end
			return options
		end

		function mod:OnInitialize()
			M.deathlogevents = M.deathlogevents or 14
			M.deathlogthreshold = M.deathlogthreshold or 1000
			M.deathchannel = M.deathchannel or "AUTO"

			Skada.options.args.modules.args.deathlog = get_options()

			-- add colors to tweaks
			local color_opt = Skada.options.args.tweaks.args.advanced.args.colors
			if not color_opt then return end
			color_opt.args.deathlog = {
				type = "group",
				name = L["Death log"],
				order = 50,
				hidden = Skada.options.args.tweaks.args.advanced.args.colors.args.custom.disabled,
				disabled = Skada.options.args.tweaks.args.advanced.args.colors.args.custom.disabled,
				get = function(i)
					local color = get_color(i[#i])
					return color.r, color.g, color.b
				end,
				set = function(i, r, g, b)
					P.customcolors = P.customcolors or {}
					local key = "deathlog_" .. i[#i]
					P.customcolors[key] = P.customcolors[key] or {}
					P.customcolors[key].r = r
					P.customcolors[key].g = g
					P.customcolors[key].b = b
				end,
				args = {
					green = {
						type = "color",
						name = L["Healing Taken"],
						desc = format(L["Color for %s."], L["Healing Taken"]),
						order = 10
					},
					red = {
						type = "color",
						name = L["Damage Taken"],
						desc = format(L["Color for %s."], L["Damage Taken"]),
						order = 20
					},
					yellow = {
						type = "color",
						name = L["Overheal"],
						desc = format(L["Color for %s."], L["Overhealing"]),
						order = 20
					},
					orange = {
						type = "color",
						name = L["Avoidance & Mitigation"],
						desc = format(L["Color for %s."], L["Avoidance & Mitigation"]),
						order = 20
					},
					purple = {
						type = "color",
						name = L["Debuffs"],
						desc = format(L["Color for %s."], L["Debuffs"]),
						order = 30
					-- },
					-- blue = {
					-- 	type = "color",
					-- 	name = L["Buffs"],
					-- 	desc = format(L["Color for %s."], L["Debuffs"]),
					-- 	order = 40
					}
				}
			}
		end
	end
end)
