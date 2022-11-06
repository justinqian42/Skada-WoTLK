local L = LibStub("AceLocale-3.0"):NewLocale(..., "enUS", true--[[, true]])
if not L then return end

L["A damage meter."] = true
L["Memory usage is high. You may want to reset Skada, and enable one of the automatic reset options."] = true
L["Skada is out of date. You can download the newest version from \124cffffbb00%s\124r"] = true
L["Skada: Modes"] = true
L["Skada: Fights"] = true
L["Data Collection"] = true
L["Enable"] = _G.ENABLE
L["ENABLED"] = true
L["Disable"] = _G.DISABLE
L["DISABLED"] = true
L["Enable All"] = true
L["Disable All"] = true
L["Stopping for wipe."] = true
L["Usage:"] = true
L["Commands:"] = true
L["Import"] = true
L["Export"] = true
L["Import/Export"] = true
L["Pets"] = _G.PETS or "Pets"
-- profiles
L["Profiles"] = true
L["Profile Import/Export"] = true
L["Import Profile"] = true
L["Export Profile"] = true
L["Paste here a profile in text format."] = true
L["Press CTRL-V to paste the text from your clipboard."] = true
L["This is your current profile in text format."] = true
L["Press CTRL-C to copy the text to your clipboard."] = true
L["Network Sharing"] = true
L["Player Name"] = true
L["Send Profile"] = true
L["Accept profiles from other players."] = true
L["opt_profile_received"] = "%s has sent you a profile configuration. Do you want to activate received profile?"
L["Progress"] = true
L["Data Size: \124cffffffff%.1f\124rKB"] = true
L["Transmision Progress: %02.f%%"] = true
L["Transmission Completed"] = true
-- common lines
L["ERROR"] = _G.ERROR_CAPS
L["Yes"] = _G.YES
L["No"] = _G.NO
L["None"] = _G.NONE
L["All"] = _G.ALL
L["Options"] = true
L["Options for %s."] = true
L["General"] = true
L["General options for %s."] = true
L["Text"] = true
L["Text options for %s."] = true
L["Format"] = true
L["Format options for %s."] = true
L["Appearance"] = true
L["Appearance options for %s."] = true
L["Advanced"] = true
L["Advanced options for %s."] = true
L["Position"] = true
L["Position settings for %s."] = true
L["Width"] = true
L["The width of %s."] = true
L["Height"] = true
L["The height of %s."] = true
L["More Details"] = true
L["Active Time"] = true
L["Segment Time"] = true
L["Click for \124cff00ff00%s\124r"] = true
L["Shift-Click for \124cff00ff00%s\124r"] = true
L["Control-Click for \124cff00ff00%s\124r"] = true
L["Alt-Click for \124cff00ff00%s\124r"] = true
L["Toggle Class Filter"] = true
L["Average"] = true
L["Minimum"] = _G.MINIMUM
L["Maximum"] = _G.MAXIMUM
L["Casts"] = true
L["Count"] = true
L["Refresh"] = true
L["Percent"] = true
L["sPercent"] = "Percent (subviews)"
L["General Options"] = true
L["HoT"] = true
L["DoT"] = true
L["Hits"] = true
L["Normal Hits"] = true
L["Crit"] = _G.CRIT_ABBR
L["Critical"] = true
L["Critical Hits"] = true
L["Crushing"] = true
L["Glancing"] = true
L["ABSORB"] = "Absorbed"
L["BLOCK"] = "Blocked"
L["DEFLECT"] = "Deflect"
L["DODGE"] = "Dodge"
L["EVADE"] = "Evade"
L["IMMUNE"] = "Immune"
L["MISS"] = "Miss"
L["PARRY"] = "Parry"
L["REFLECT"] = "Reflect"
L["RESIST"] = "Resisted"
L["Only for bosses."] = true
L["Enable this only against bosses."] = true
L["Melee"] = _G.MELEE
L["Unknown"] = _G.UNKNOWN
L["Other"] = _G.OTHER
L["Category"] = _G.CATEGORY
L["Categories"] = _G.CATEGORIES
-- windows section:
L["Window"] = true
L["Windows"] = true
L["Create Window"] = true
L["Window Name"] = true
L["Accept"] = _G.ACCEPT
L["Cancel"] = _G.CANCEL
L["Close"] = _G.CLOSE
L["Create"] = _G.CREATE
L["Enter the name for the new window."] = true
L["Delete Window"] = true
L["Choose the window to be deleted."] = true
L["Are you sure you want to delete this window?"] = true
L["Rename Window"] = true
L["Enter the name for the window."] = true
L["Test Mode"] = true
L["Creates fake data to help you configure your windows."] = true
L["Child Window"] = true
L["A child window will replicate the parent window actions."] = true
L["Child Window Mode"] = true
L["Lock Window"] = true
L["Locks the bar window in place."] = true
L["Hide Window"] = true
L["Hides the window."] = true
L["Sticky Window"] = true
L["Allows the window to stick to other Skada windows."] = true
L["Snap to best fit"] = true
L["Snaps the window size to best fit when resizing."] = true
L["Disable Resize Buttons"] = true
L["Resize and lock/unlock buttons won't show up when you hover over the window."] = true
L["Disable stretch button"] = true
L["Stretch button won't show up when you hover over the window."] = true
L["Reverse window stretch"] = true
L["opt_botstretch_desc"] = "Places the stretch button at the bottom of the window and makes the latter stretch downwards."
L["Display System"] = true
L["Choose the system to be used for displaying data in this window."] = true
L["Copy Settings"] = true
L["Choose the window from which you want to copy the settings."] = true
-- bars
L["Bars"] = true
L["Left Text"] = true
L["Right Text"] = true
L["Font"] = true
L["The font used by %s."] = true
L["Font Size"] = true
L["The font size of %s."] = true
L["Font Outline"] = true
L["Sets the font outline."] = true
L["Outline"] = true
L["Thick outline"] = true
L["Monochrome"] = true
L["Outlined monochrome"] = true
L["Bar Texture"] = true
L["The texture used by all bars."] = true
L["Spacing"] = true
L["Distance between %s."] = true
L["Displacement"] = true
L["The distance between the edge of the window and the first bar."] = true
L["Bar Orientation"] = true
L["The direction the bars are drawn in."] = true
L["Left to right"] = true
L["Right to left"] = true
L["Reverse bar growth"] = true
L["Bars will grow up instead of down."] = true
L["Disable bar highlight"] = true
L["Hovering a bar won't make it brighter."] = true
L["Bar Color"] = true
L["Choose the default color of the bars."] = true
L["Background Color"] = true
L["The color of the background."] = true
L["Custom Color"] = true
L["Use a different color for my bar."] = true
L["My Color"] = true
L["Spell school colors"] = true
L["Use spell school colors where applicable."] = true
L["When possible, bars will be colored according to player class."] = true
L["When possible, bar text will be colored according to player class."] = true
L["Class Icons"] = true
L["Use class icons where applicable."] = true
L["Spec Icons"] = true
L["Use specialization icons where applicable."] = true
L["Role Icons"] = true
L["Use role icons where applicable."] = true
L["Show Spark Effect"] = true
L["Click Through"] = true
L["Disables mouse clicks on bars."] = true
L["Smooth Bars"] = true
L["Animate bar changes smoothly rather than immediately."] = true
-- title bar
L["Title Bar"] = true
L["Enables the title bar."] = true
L["Include set"] = true
L["Include set name in title bar"] = true
L["Encounter Timer"] = true
L["When enabled, a stopwatch is shown on the left side of the text."] = true
L["Mode Icon"] = true
L["Shows mode's icon in the title bar."] = true
L["The texture used as the background of the title."] = true
L["Border texture"] = true
L["The texture used for the borders."] = true
L["Border Color"] = true
L["The color used for the border."] = true
L["Buttons"] = true
L["Auto Hide Buttons"] = true
L["Show window buttons only if the cursor is over the title bar."] = true
L["Buttons Style"] = true
-- general window
L["Background"] = _G.BACKGROUND
L["Background Texture"] = true
L["The texture used as the background."] = true
L["Tile"] = true
L["Tile the background texture."] = true
L["Tile Size"] = true
L["The size of the texture pattern."] = true
L["Border"] = true
L["Border Thickness"] = true
L["The thickness of the borders."] = true
L["Border Insets"] = true
L["The distance between the window and its border."] = true
L["Scale"] = true
L["Sets the scale of the window."] = true
L["Strata"] = true
L["This determines what other frames will be in front of the frame."] = true
L["Clamped To Screen"] = true
L["Toggle whether to permit movement out of screen."] = true
L["X Offset"] = true
L["Y Offset"] = true
-- switching
L["Mode Switching"] = true
L["Combat Mode"] = true
L["opt_combatmode_desc"] = "Automatically switch to set \124cffffbb00Current\124r and this mode when entering combat."
L["Wipe Mode"] = true
L["opt_wipemode_desc"] = "Automatically switch to set \124cffffbb00Current\124r and this mode after a wipe."
L["Return after combat"] = true
L["Return to the previous set and mode after combat ends."] = true
L["Auto switch to current"] = true
L["opt_autocurrent_desc"] = "Whenever a combat starts, this window automatically switches to \124cffffbb00Current\124r segment."
L["Auto Hide"] = true
L["While in combat"] = true
L["While out of combat"] = true
L["While not in a group"] = true
L["While inside an instance"] = true
L["While not inside an instance"] = true
L["In Battlegrounds"] = true
L["Inline Bar Display"] = true
L["mod_inline_desc"] = "Inline display is a horizontal window style."
L["Font Color"] = true
L["Font Color.\nClick \"Class Colors\" to begin."] = true
L["opt_barwidth_desc"] = 'Width of bars. This only applies if the "Fixed bar width" option is used.'
L["Fixed bar width"] = true
L["opt_fixedbarwidth_desc"] = "If checked, bar width is fixed. Otherwise, bar width depends on the text width."
L["Class Colors"] = _G.CLASS_COLORS or "Class Colors"
L["Use class colors for %s."] = true
L["opt_isusingclasscolors_desc"] = "Class colors:\n\124cFFF58CBAKader\124r - 5.71M (21.7K)\n\nWithout:\nKader - 5.71M (21.7K)"
L["Put values on new line."] = true
L["opt_isonnewline_desc"] = "New line:\nKader\n5.71M (21.7K)\n\nDivider:\nKader - 5.71M (21.7K)"
L["Use ElvUI skin if avaliable."] = true
L["opt_isusingelvuiskin_desc"] = "Check this to use ElvUI skin instead.\nDefault: checked"
L["Use solid background."] = true
L["Un-check this for an opaque background."] = true
L["Data Text"] = true
L["mod_broker_desc"] = "Data text acts as an LDB data feed. It can be integrated in any LDB display such as Titan Panel or ChocolateBar. It also has an optional internal frame."
L["Use frame"] = true
L["opt_useframe_desc"] = "Shows a standalone frame. Not needed if you are using an LDB display provider such as Titan Panel or ChocolateBar."
L["Text Color"] = true
L["The text color of %s."] = true
L["Choose the default color."] = true
L["Hint: Left-Click to set active mode."] = true
L["Right-Click to set active set."] = true
L["Shift+Left-Click to open menu."] = true
-- data resets
L["Data Resets"] = true
L["Reset"] = _G.RESET
L["Reset on entering instance"] = true
L["Controls if data is reset when you enter an instance."] = true
L["Reset on joining a group"] = true
L["Controls if data is reset when you join a group."] = true
L["Reset on leaving a group"] = true
L["Controls if data is reset when you leave a group."] = true
L["Ask"] = true
L["Do you want to reset Skada?\nHold SHIFT to reset all data."] = true
L["All data has been reset."] = true
L["There is no data to reset."] = true
L["Skip reset dialog"] = true
L["opt_skippopup_desc"] = "Enable this if you want Skada to reset without the confirmation dialog."
L["Are you sure you want to reinstall Skada?"] = true
-- general options
L["Show minimap button"] = true
L["Toggles showing the minimap button."] = true
L["Transliterate"] = true
L["Converts Cyrillic letters into Latin letters."] = true
L["Remove realm name"] = true
L["opt_realmless_desc"] = "When enabled, the character realm name isn't displayed."
L["Merge pets"] = true
L["Merges pets with their owners. Changing this only affects new data."] = true
L["Show totals"] = true
L["Shows a extra row with a summary in certain modes."] = true
L["Only keep boss fighs"] = true
L["Boss fights will be kept with this on, and non-boss fights are discarded."] = true
L["Always save boss fights"] = true
L["Boss fights will be kept with this on and will not be affected by Skada reset."] = true
L["Hide when solo"] = true
L["Hides Skada's window when not in a party or raid."] = true
L["Hide in PvP"] = true
L["Hides Skada's window when in Battlegrounds/Arenas."] = true
L["Hide in combat"] = true
L["Hides Skada's window when in combat."] = true
L["Show in combat"] = true
L["Shows Skada's window when in combat."] = true
L["Disable while hidden"] = true
L["Skada will not collect any data when automatically hidden."] = true
L["Sort modes by usage"] = true
L["The mode list will be sorted to reflect usage instead of alphabetically."] = true
L["Show rank numbers"] = true
L["Shows numbers for relative ranks for modes where it is applicable."] = true
L["Aggressive combat detection"] = true
L["opt_tentativecombatstart_desc"] = [[Skada usually uses a very conservative (simple) combat detection scheme that works best in raids.
With this option Skada attempts to emulate other damage meters.
Useful for running dungeons, meaningless on boss encounters.]]
L["Autostop"] = true
L["opt_autostop_desc"] = "Automatically stops the current segment after half of all raid members have died."
L["Always show self"] = true
L["opt_showself_desc"] = "Keeps the player shown last even if there is not enough space."
L["Number format"] = true
L["Controls the way large numbers are displayed."] = true
L["Condensed"] = true
L["Detailed"] = true
L["Combined"] = true
L["Comma"] = true
L["Numeral system"] = true
L["Select which numeral system to use."] = true
L["Auto"] = true
L["Western"] = true
L["East Asia"] = true
L["Brackets"] = true
L["Choose which type of brackets to use."] = true
L["Separator"] = true
L["Choose which character is used to separator values between brackets."] = true
L["Number of decimals"] = true
L["Controls the way percentages are displayed."] = true
L["Data Feed"] = true
L["opt_feed_desc"] = "Choose which data feed to show in the DataBroker view. This requires an LDB display addon, such as Titan Panel."
L["Time Measure"] = true
L["Activity Time"] = true
L["Effective Time"] = true
L["opt_timemesure_desc"] = [=[|cFFFFFF00Activity|r: the timer of each raid member is put on hold if their activity is ceased and back again to count when resumed, common way of measuring DPS and HPS.
|cFFFFFF00Effective|r: used on rankings, this method uses the elapsed combat time to measure the DPS and HPS of all raid members.]=]
L["Number set duplicates"] = true
L["Append a count to set names with duplicate mob names."] = true
L["Set Format"] = true
L["Controls the way set names are displayed."] = true
L["Links in reports"] = true
L["When possible, use links in the report messages."] = true
L["Segments to keep"] = true
L["The number of fight segments to keep. Persistent segments are not included in this."] = true
L["Persistent segments"] = true
L["The number of persistent fight segments to keep."] = true
L["Memory Check"] = true
L["Checks memory usage and warns you if it is greater than or equal to %dmb."] = true
L["Disable Comms"] = true
L["Minimum segment length"] = true
L["The minimum length required in seconds for a segment to be saved."] = true
L["Update frequency"] = true
L["How often windows are updated. Shorter for faster updates. Increases CPU usage."] = true
-- columns
L["Columns"] = true
-- tooltips
L["Tooltips"] = true
L["Show Tooltips"] = true
L["Shows tooltips with extra information in some modes."] = true
L["Informative Tooltips"] = true
L["Shows subview summaries in the tooltips."] = true
L["Subview Rows"] = true
L["The number of rows from each subview to show when using informative tooltips."] = true
L["Tooltip Position"] = true
L["Position of the tooltips."] = true
L["Default"] = _G.DEFAULT
L["Top Right"] = true
L["Top Left"] = true
L["Bottom Right"] = true
L["Bottom Left"] = true
L["Smart"] = true
L["Follow Cursor"] = true
L["Top"] = true
L["Bottom"] = true
L["Right"] = true
L["Left"] = true
-- disabled modules
L["\124cff00ff00Requires\124r: %s"] = true
L["Modules"] = true
L["Disabled Modules"] = true
L["Modules Options"] = true
L["Tick the modules you want to disable."] = true
L["This change requires a UI reload. Are you sure?"] = true
-- themes options
L["Theme"] = true
L["Themes"] = true
L["Manage Themes"] = true
L["Apply Theme"] = true
L["Apply"] = _G.APPLY
L["Theme applied!"] = true
L["Name of your new theme."] = true
L["Save Theme"] = true
L["Save"] = _G.SAVE
L["Delete Theme"] = true
L["Delete"] = _G.DELETE
L["Are you sure you want to delete this theme?"] = true
L["Paste here a theme in text format."] = true
L["This is your current theme in text format."] = true
-- scroll options
L["Scroll"] = true
L["Mouse"] = _G.MOUSE_LABEL
L["Wheel Speed"] = true
L["opt_wheelspeed_desc"] = "Changes how fast the scroll goes when rolling the mouse wheel over the window."
L["Scroll Icon"] = true
L["Scroll mouse button"] = true
L["Scroll Up"] = _G.COMBAT_TEXT_SCROLL_UP
L["Scroll Down"] = _G.COMBAT_TEXT_SCROLL_DOWN
L["Keybinding"] = _G.KEY_BINDINGS
L["Middle Button"] = _G.KEY_BUTTON3
L["Mouse Button 4"] = _G.KEY_BUTTON4
L["Mouse Button 5"] = _G.KEY_BUTTON5
-- minimap button
L["Skada Summary"] = true
L["\124cff00ff00Left-Click\124r to toggle windows."] = true
L["\124cff00ff00Ctrl+Left-Click\124r to show/hide windows."] = true
L["\124cff00ff00Shift+Left-Click\124r to reset."] = true
L["\124cff00ff00Right-Click\124r to open menu."] = true
-- skada menu
L["Skada Menu"] = true
L["Select Segment"] = true
L["Delete Segment"] = true
L["Keep Segment"] = true
L["Toggle Windows"] = true
L["Show/Hide Windows"] = true
L["Start New Segment"] = true
L["Start New Phase"] = true
L["Select All"] = true
L["Deselect All"] = true
L["Next"] = _G.NEXT
L["Previous"] = _G.PREVIOUS
-- window buttons
L["Configure"] = true
L["Open Config"] = true
L["btn_config_desc"] = "Opens the configuration window."
L["btn_reset_desc"] = "Resets all fight data except those marked as kept."
L["Segment"] = true
L["btn_segment_desc"] = "Jump to a specific segment.\n\124cff00ff00Shift-LMB\124r for \124cffffbb00next\124r segment.\n\124cff00ff00Shift-RMB\124r for \124cffffbb00previous\124r segment.\n\124cff00ff00Middle-Click\124r for \124cffffbb00current\124r segment."
L["Mode"] = true
L["Jump to a specific mode."] = true
L["Report"] = true
L["btn_report_desc"] = "Opens a dialog that lets you report your data to others in various ways.\n\124cff00ff00Shift-Click\124r to Quick Report."
L["Stop"] = "Stop/Resume"
L["btn_stop_desc"] = "Stops or resumes the current segment. Useful for discounting data after a wipe. Can also be set to automatically stop in the settings."
L["Segment Stopped."] = true
L["Segment Paused."] = true
L["Segment Resumed."] = true
L["Quick Access"] = true
-- default segments
L["Total"] = true
L["Current"] = "Current fight"
-- report module and window
L["Skada: %s for %s:"] = true
L["Channel"] = _G.CHANNEL
L["Self"] = true
L["Whisper"] = _G.WHISPER
L["Whisper Target"] = true
L["Say"] = _G.CHAT_MSG_SAY
L["Yell"] = _G.CHAT_MSG_YELL
L["Instance"] = _G.INSTANCE
L["Party"] = _G.CHAT_MSG_PARTY
L["Raid"] = _G.CHAT_MSG_RAID
L["Guild"] = _G.CHAT_MSG_GUILD
L["Officer"] = _G.CHAT_MSG_OFFICER
L["Raid Warning"] = _G.CHAT_MSG_RAID_WARNING
L["[General]"] = "General"
L["[LocalDefense]"] = "LocalDefense"
L["[LookingForGroup]"] = "LookingForGroup"
L["[Trade]"] = "Trade"
L["Line"] = true
L["Lines"] = true
L["There is nothing to report."] = true
L["No mode or segment selected for report."] = true
-- Bar Display Module --
L["Bar Display"] = true
L["mod_bar_desc"] = "Bar display is the normal bar window used by most damage meters. It can be extensively styled."
-- Bar Display (Legacy)
L["Legacy Bar Display"] = true
L["Max Bars"] = true
L["The maximum number of bars shown."] = true
L["Show Menu Button"] = true
L["Shows a button for opening the menu in the window title bar."] = true
L["Class Color Bars"] = true
L["Class Color Text"] = true
-- Threat Module --
L["Threat"] = true
L["Threat Warning"] = true
L["Flash Screen"] = true
L["This will cause the screen to flash as a threat warning."] = true
L["Shake Screen"] = true
L["This will cause the screen to shake as a threat warning."] = true
L["Warning Message"] = true
L["Print a message to screen when you accumulate too much threat."] = true
L["Play sound"] = true
L["This will play a sound as a threat warning."] = true
L["Message Output"] = true
L["Choose where warning messages should be displayed."] = true
L["Chat Frame"] = true
L["Blizzard Error Frame"] = true
L["opt_threat_soundfile_desc"] = "The sound that will be played when your threat percentage reaches a certain point."
L["Warning Frequency"] = true
L["Threat Threshold"] = true
L["opt_threat_threshold_desc"] = "When your threat reaches this level, relative to tank, warnings are shown."
L["Show raw threat"] = true
L["opt_threat_rawvalue_desc"] = "Shows raw threat percentage relative to tank instead of modified for range."
L["Use focus target"] = true
L["opt_threat_focustarget_desc"] = 'Tells Skada to additionally check your "focus" and "focustarget" before your "target" and "targettarget" in that order for threat display.'
L["Disable while tanking"] = true
L["opt_threat_notankwarnings_desc"] = "Do not give out any warnings if Defensive Stance, Bear Form, Righteous Fury or Frost Presence is active."
L["Ignore Pets"] = true
L["opt_threat_ignorepets_desc"] = [[Tells Skada to skip enemy player pets when determining which unit to display threat data on.

Player pets maintain a threat table when in |cffffff78Aggressive|r or |cffffff78Defensive|r mode and behave just like normal mobs, attacking the target with the highest threat. If the pet is instructed to attack a specific target, the pet still maintains the threat table, but sticks on the assigned target which by definition has 100% threat. Player pets can be taunted to force them to attack you.

However, player pets on |cffffff78Passive|r mode do not have a threat table, and taunt does not work on them. They only attack their assigned target when instructed and do so without any threat table.

When a player pet is instructed to |cffffff78Follow|r, the pet's threat table is wiped immediately and stops attacking, although it may immediately reacquire a target based on its Aggressive/Defensive mode.]]
L["> Pull Aggro <"] = true
L["Show Pull Aggro Bar"] = true
L["opt_threat_showaggrobar_desc"] = "Show a bar for the amount of threat you will need to reach in order to pull aggro."
L["Test Warnings"] = true
L["TPS"] = true
L["Threat: Personal Threat"] = true
L["Threat sound"] = true
L["%d%% Threat"] = _G.THREAT_TOOLTIP
L["High Threat"] = _G.COMBAT_THREAT_INCREASE_1
-- Absorbs & Healing Module --
L["Healing"] = true
L["Healing Done"] = true
L["Healing Taken"] = true
L["Healed target list"] = true
L["Healing spell list"] = true
L["%s's healing"] = true
L["%s's healed targets"] = true
L["actor heal spells"] = function(n1, n2) return ((not n2 or n1 == n2) and "%s's healing spells" or "%s's healing on %s"):format(n1, n2) end
L["HPS"] = true
L["sHPS"] = "HPS (subviews)"
L["Healing: Personal HPS"] = true
L["RHPS"] = true
L["Healing: Raid HPS"] = true
L["Total Healing"] = true
L["Overheal"] = true
L["Overhealing"] = true
L["Overhealed target list"] = true
L["Overheal spell list"] = true
L["%s's overheal targets"] = true
L["actor overheal spells"] = function(n1, n2) return ((not n2 or n1 == n2) and "%s's overheal spells" or "%s's overhealing on %s"):format(n1, n2) end
L["Absorbs"] = true
L["Absorbed target list"] = true
L["Absorb spell list"] = true
L["%s's absorbed targets"] = true
L["actor absorb spells"] = function(n1, n2) return ((not n2 or n1 == n2) and "%s's absorb spells" or "%s's absorbs on %s"):format(n1, n2) end
L["APS"] = true
L["sAPS"] = "APS (subviews)"
L["Absorbs and Healing"] = true
L["Absorbs and healing spells"] = true
L["Absorbed and healed targets"] = true
L["%s's absorbed and healed targets"] = true
L["actor absorb and heal spells"] = function(n1, n2) return ((not n2 or n1 == n2) and "%s's absorb and healing spells" or "%s's absorbs and healing on %s"):format(n1, n2) end
L["Healing received"] = true
L["Healing source list"] = true
L["%s's heal sources"] = true
L["Healing Done By Spell"] = true
L["Healing spell sources"] = true
-- Auras Module --
L["Uptime"] = true
L["Buffs and Debuffs"] = true
L["Buffs"] = true
L["Buff spell list"] = true
L["%s's buffs"] = true
L["Debuffs"] = true
L["Debuff spell list"] = true
L["Debuff target list"] = true
L["Debuff source list"] = true
L["actor debuffs"] = function(n1, n2) return ((not n2 or n1 == n2) and "%s's debuffs" or "%s's debuffs on %s"):format(n1, n2) end
L["%s's <%s> targets"] = true
L["%s's <%s> sources"] = true
L["Sunder Counter"] = true
L["Sunder target list"] = true
L["Sunder source list"] = true
L["Number of seconds after application to count refreshs."] = true
L["Enemy Buffs"] = true
L["Enemy Debuffs"] = true
-- CC Tracker Module --
L["Crowd Control"] = true
L["CC Done"] = true
L["CC Taken"] = true
L["CC Breaks"] = true
L["Crowd Control Spells"] = true
L["Crowd Control Targets"] = true
L["Crowd Control Sources"] = true
L["%s's control spells"] = true
L["%s's control targets"] = true
L["%s's control sources"] = true
L["Ignore Main Tanks"] = true
L["%s on %s removed by %s"] = true
L["%s on %s removed by %s's %s"] = true
-- Damage Module --
-- environmental damage
L["Environment"] = true
L["Falling"] = _G.ACTION_ENVIRONMENTAL_DAMAGE_FALLING
L["Drowning"] = _G.ACTION_ENVIRONMENTAL_DAMAGE_DROWNING
L["Fatigue"] = _G.ACTION_ENVIRONMENTAL_DAMAGE_FATIGUE
L["Fire"] = _G.ACTION_ENVIRONMENTAL_DAMAGE_FIRE
L["Lava"] = _G.ACTION_ENVIRONMENTAL_DAMAGE_LAVA
L["Slime"] = _G.ACTION_ENVIRONMENTAL_DAMAGE_SLIME
-- damage done module
L["Damage"] = true
L["Damage target list"] = true
L["Damage spell list"] = true
L["Damage spell details"] = true
L["Damage spell targets"] = true
L["Damage Done"] = true
L["Pet Damage"] = _G.SHOW_PET_MELEE_DAMAGE or "Pet Damage"
L["actor damage"] = function(n1, n2) return ((not n2 or n1 == n2) and "%s's damage" or "%s's damage on %s"):format(n1, n2) end
L["%s's <%s> damage"] = true
L["Useful Damage"] = true
L["Useful damage on %s"] = true
L["Damage Done By Spell"] = true
L["%s's sources"] = true
L["DPS"] = true
L["sDPS"] = "DPS (subviews)"
L["Damage: Personal DPS"] = true
L["RDPS"] = true
L["Damage: Raid DPS"] = true
L["Absorbed Damage"] = true
L["Enable this if you want the damage absorbed to be included in the damage done."] = true
-- damage taken module
L["Damage Taken"] = true
L["Damage taken by %s"] = true
L["Damage source list"] = true
L["Damage spell sources"] = true
L["Damage Taken By Spell"] = true
L["%s's targets"] = true
L["DTPS"] = true
L["sDTPS"] = "DTPS (subviews)"
-- enemy damage done module
L["Enemies"] = true
L["Enemy Damage Done"] = true
L["Damage done per player"] = true
L["Damage from %s"] = true
-- enemy damage taken module
L["Enemy Damage Taken"] = true
L["%s's damage sources"] = true
L["%s below %s%%"] = true
L["%s - %s%% to %s%%"] = true
L["Phase %s"] = true
L["%s - Phase %s"] = true
L["%s - Phase 1"] = true
L["%s - Phase 2"] = true
L["%s - Phase 3"] = true
L["\124cffffbb00%s\124r - \124cff00ff00Phase %s\124r started."] = true
L["\124cffffbb00%s\124r - \124cff00ff00Phase %s\124r stopped."] = true
L["\124cffffbb00%s\124r - \124cff00ff00Phase %s\124r resumed."] = true
-- enemy healing done module
L["Enemy Healing Done"] = true
-- avoidance and mitigation module
L["Avoidance & Mitigation"] = true
L["Damage Breakdown"] = true
L["%s's damage breakdown"] = true
-- friendly fire module
L["Friendly Fire"] = true
-- useful damage targets
L["Important targets"] = true
L["Oozes"] = true
L["Princes overkilling"] = true
L["Adds"] = true
L["Halion and Inferno"] = true
L["Valkyrs overkilling"] = true
-- Deaths Module --
L["Deaths"] = _G.DEATHS
L["%s's deaths"] = true
L["Death log"] = true
L["%s's death log"] = true
L["Player's deaths"] = true
L["%s dies"] = true
L["buff"] = true
L["debuff"] = true
L["Spell details"] = true
L["Spell"] = true
L["Amount"] = true
L["Source"] = true
L["Health"] = _G.HEALTH
L["Change"] = true
L["Time"] = true
L["Survivability"] = true
L["Events Amount"] = true
L["Set the amount of events the death log should record."] = true
L["Minimum Healing"] = true
L["Ignore heal events that are below this threshold."] = true
L["Announce Deaths"] = true
L["Announces information about the last hit the player took before they died."] = true
L["Alternative Display"] = true
L["If a player dies multiple times, each death will be displayed as a separate bar."] = true
-- activity module
L["Activity"] = true
L["Activity per Target"] = true
L["%s's activity"] = true
-- dispels module lines --
L["Dispels"] = _G.DISPELS
L["Dispel spell list"] = true
L["Dispelled spell list"] = true
L["Dispelled target list"] = true
L["%s's dispel spells"] = true
L["%s's dispelled spells"] = true
L["%s's dispelled targets"] = true
-- failbot module lines --
L["Fails"] = true
L["%s's fails"] = true
L["Player's failed events"] = true
L["Event's failed players"] = true
L["Report Fails"] = true
L["Reports the group fails at the end of combat if there are any."] = true
-- interrupts module lines --
L["Interrupts"] = _G.INTERRUPTS
L["Interrupt spells"] = true
L["Interrupted spells"] = true
L["Interrupted targets"] = true
L["%s's interrupt spells"] = true
L["%s's interrupted spells"] = true
L["%s's interrupted targets"] = true
L["%s interrupted!"] = true
-- Power gained module --
L["Resources"] = true
L["Mana"] = _G.MANA
L["Rage"] = _G.RAGE
L["Energy"] = _G.ENERGY
L["Runic Power"] = _G.RUNIC_POWER
L["Power gained: Mana"] = true
L["Power gained: Rage"] = true
L["Power gained: Energy"] = true
L["Power gained: Runic Power"] = true
L["Mana gained spells"] = true
L["Rage gained spells"] = true
L["Energy gained spells"] = true
L["Runic Power gained spells"] = true
L["%s's gained %s"] = true
-- Parry module lines --
L["Parry-Haste"] = true
L["Parry target list"] = true
L["%s's parry targets"] = true
L["%s's parry targets"] = true
L["%s parried %s (%s)"] = true
-- Potions module lines --
L["Potions"] = true
L["Potions list"] = true
L["Players list"] = true
L["%s's used potions"] = true
L["Pre-potion"] = true
L["pre-potion: %s"] = true
L["Prints pre-potion after the end of the combat."] = true
-- healthstone --
L["Healthstones"] = true
-- resurrect module lines --
L["Resurrects"] = true
L["Resurrect target list"] = true
L["%s's resurrect targets"] = true
-- nickname module lines --
L["Nickname"] = true
L["Name"] = _G.NAME
L["Nicknames are sent to group members and Skada can use them instead of your character name."] = true
L["Set a nickname for you."] = true
L["Nickname isn't a valid string."] = true
L["Your nickname is too long, max of 12 characters is allowed."] = true
L["Only letters and two spaces are allowed."] = true
L["Your nickname contains a forbidden word."] = true
L["You can't use the same letter three times consecutively, two spaces consecutively or more then two spaces."] = true
L["Ignore Nicknames"] = true
L["When enabled, nicknames set by Skada users are ignored."] = true
L["Name display"] = true
L["Choose how names are shown on your bars."] = true
L["Clear Cache"] = true
L["Are you sure you want clear cached nicknames?"] = true
-- overkill module lines --
L["Overkill"] = true
L["Overkill spell list"] = true
L["Overkill target list"] = true
L["%s's overkill spells"] = true
L["%s's overkill targets"] = true
-- tweaks module lines --
L["Improvement"] = true
L["Tweaks"] = true
L["First hit"] = true
L["\124cffffff00First Hit\124r: %s from %s"] = true
L["\124cffffbb00First Hit\124r: *?*"] = true
L["\124cffffbb00Boss First Target\124r: %s"] = true
L["opt_tweaks_firsthit_desc"] = "Prints a message of the first hit before combat.\nOnly works for boss encounters."
L["Filter DPS meters Spam"] = true
L["opt_tweaks_spamage_desc"] = "Suppresses chat messages from damage meters and provides single chat-link damage statistics in a popup."
L["Reported by: %s"] = true
L["Smart Stop"] = true
L["opt_tweaks_smarthalt_desc"] = "Automatically stops the current segment after the boss has died.\nUseful to avoid collecting data in case of a combat bug."
L["Duration"] = true
L["opt_tweaks_smartwait_desc"] = "For how long Skada should wait before stopping the segment."
L["Modes Icons"] = true
L["Show modes icons on bars and menus."] = true
L["Combat Log"] = _G.COMBAT_LOG
L["opt_tweaks_combatlogfix_desc"] = "Keeps the combat log from breaking without munging it completely."
L["Conservative Mode"] = true
L["Enable this if you want to ignore \124cffffbb00%s\124r."] = true
L["Colors"] = _G.COLORS
L["Custom Colors"] = true
L["Arena Teams"] = true
L["Are you sure you want to reset all colors?"] = true
L["Announce %s"] = true
L["Announces how long it took to apply %d stacks of %s and announces when it drops."] = true
L["%s dropped from %s!"] = true
L["%s stacks of %s applied on %s in %s sec!"] = true
L["My Spells"] = true
-- total data options
L["Total Segment"] = true
L["All Segments"] = true
L["Raid Bosses"] = true
L["Raid Trash"] = true
L["Dungeon Bosses"] = true
L["Dungeon Trash"] = true
L["opt_tweaks_total_all_desc"] = "All segments are added to total segment data."
L["opt_tweaks_total_fmt_desc"] = "Segments with %s are added to total segment data."
L["Detailed total segment"] = true
L["opt_tweaks_total_full_desc"] = "When enabled, Skada will record everything to the total segment, instead of total numbers (record spell details, their targets and their sources)."
-- arena
L["Player vs. Player"] = _G.PLAYER_V_PLAYER
L["mod_pvp_desc"] = "Adds specialization detection for arenas and battlegrounds, and shows arena opponents on the same window."
L["Gold Team"] = true
L["Green Team"] = true
L["Color"] = _G.COLOR
L["Color for %s."] = true
-- notifications
L["Opacity"] = _G.OPACITY
L["Notifications"] = true
L["opt_toast_desc"] = "Uses visual notifications instead of chat window messages whenever applicable."
L["Test Notifications"] = true
-- comparison module
L["Comparison"] = true
L["Damage Comparison"] = true
L["%s vs %s: %s"] = true
L["%s vs %s: Spells"] = true
L["%s vs %s: Targets"] = true
L["%s vs %s: Damage on %s"] = true
-- about
L["About"] = true
L["Author"] = true
L["Credits"] = true
L["Date"] = true
L["Discord"] = true
L["License"] = true
L["Localizations"] = true
L["Revision"] = true
L["Thanks"] = true
L["Version"] = true
L["Website"] = true
-- custom class names using globals
L["BOSS"] = _G.BOSS
L["ENEMY"] = _G.ENEMY
L["MONSTER"] = _G.EXAMPLE_TARGET_MONSTER
L["NEUTRAL"] = _G.FACTION_STANDING_LABEL4
L["PET"] = _G.PET
L["PLAYER"] = _G.PLAYER
L["UNKNOWN"] = _G.UNKNOWN
-- some bosses entries
L["World Boss"] = true
L["Acidmaw"] = true
L["Auriaya"] = true
L["Blood Prince Council"] = true
L["Champions of the Alliance"] = true
L["Champions of the Horde"] = true
L["Cult Adherent"] = true
L["Cult Fanatic"] = true
L["Darnavan"] = true
L["Deformed Fanatic"] = true
L["Dreadscale"] = true
L["Empowered Adherent"] = true
L["Faction Champions"] = true
L["Gas Cloud"] = true
L["General Vezax"] = true
L["Gluth"] = true
L["Halion"] = true
L["Hogger"] = true
L["Ice Sphere"] = true
L["Icecrown Gunship Battle"] = true
L["Icehowl"] = true
L["Kel'Thuzad"] = true
L["Kologarn"] = true
L["Lady Deathwhisper"] = true
L["Living Inferno"] = true
L["Mimiron"] = true
L["Onyxia"] = true
L["Prince Keleseth"] = true
L["Prince Taldaram"] = true
L["Prince Valanar"] = true
L["Raging Spirit"] = true
L["Reanimated Adherent"] = true
L["Reanimated Fanatic"] = true
L["Sapphiron"] = true
L["Shambling Horror"] = true
L["Sindragosa"] = true
L["Thaddius"] = true
L["The Four Horsemen"] = true
L["The Iron Council"] = true
L["The Lich King"] = true
L["The Northrend Beasts"] = true
L["Thorim"] = true
L["Twin Val'kyr"] = true
L["Val'kyr Shadowguard"] = true
L["Valithria Dreamwalker"] = true
L["Volatile Ooze"] = true
L["Wicked Spirit"] = true
L["Yogg-Saron"] = true
