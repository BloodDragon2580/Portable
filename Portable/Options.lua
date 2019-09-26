--[[ ==========================================================================
	© Feyawen Ariana 2007-2015
		If you use my code, please give me credit.
		
		
	Options UI for Portable
========================================================================== ]]--

local myName, me = ...
local L = me.L				-- Language
local lsm = me.lsm		-- Shared Media Library

me.Options = {}


local options = {
	type = "group",
	args = {
		-- Shows information pulled from the TOC file, version number and such.
		about = {
			order = 0,	type = "group",	name = L["About"],
			args = {
				aboutheader1 = {	order = 1,	type = "header",	name = "",	},
				aboutdesc1 = {	order = 2,	type = "description",	name = "|cff0088ff"..me:GetAddonInfo("Title"),	fontSize = "large",	width = "full",	},
				aboutdesc2 = {	order = 3,	type = "description",	name  = "\n|cffc0c0c0"..L["Version"].."|cff606060: |cffffff00"..me:GetAddonInfo("Version").."|r\n|cffc0c0c0"..L["Author"].."|cff606060: |cffffff00"..me:GetAddonInfo("Author").."|r\n",	fontSize = "medium",	width = "full",	},
				aboutdesc3 = {	order = 4,	type = "description",	name = "|cffa0a0a0    "..me:GetAddonInfo("Notes"),	fontSize = "small",	width = "full",	},
				aboutdesc4 = {	order = 5, type = "description", name = "\n\n\n\n|TInterface\\AddOns\\Portable\\Artwork\\PortableLogo.blp:160:160:0:0:512:512:0:256:256:512|t\n|TInterface\\AddOns\\Portable\\Artwork\\PortableLogo.blp:160:320:0:0:512:512:0:512:0:256|t\n|TInterface\\AddOns\\Portable\\Artwork\\PortableLogo.blp:160:160:0:0:512:512:256:512:256:512|t", width = "full", },
			},
		},
		
		
		-- Frame Style
		optframe = {
			type = "group",
			name = L["Frame"],
			order = 1,
			args = {
				header101 = {
					order = 1,
					type = "header",
					name = L["Main Frame Style"],
				},
				framestyle = {
					order = 2,
					type = "select",
					name = L["Frame Style"],
					desc = L["Select the Main Frame Style."],
					width = "double",
					values = {
						L["Simple"],
						L["Arcane"],
					},
					get = function() return me.db.profile.frameStyle end,
					set = function(self, v)
						me.db.profile.frameStyle = v
						me:UpdateOptions()
						end,
				},
				frameback = {
					order = 3,
					type = "select",
					name = L["Background Artwork"],
					desc = L["Background Artwork of the Main Frame."],
					width = "double",
					values = function() return lsm:HashTable(lsm.MediaType.BACKGROUND) end,
					dialogControl = "LSM30_Background",
					get = function() return me.db.profile.frameBack end,
					set = function(info, value)
						me.db.profile.frameBack = value
						me:UpdateOptions()
						end,
				},
				framebackcolor = {
					order = 4,
					type = "color",
					name = L["Background Color"],
					desc = L["Color to Tint the Background Artwork.\n|cffffff00Note, most images require White and Full Alpha to be seen|r."],
					hasAlpha = true,
					get = function()
						return me.db.profile.frameBackColor.R, me.db.profile.frameBackColor.G, me.db.profile.frameBackColor.B, me.db.profile.frameBackColor.A
						end,
					set = function(info, r,g,b,a)
						me.db.profile.frameBackColor.R = r
						me.db.profile.frameBackColor.G = g
						me.db.profile.frameBackColor.B = b
						me.db.profile.frameBackColor.A = a
						me:UpdateOptions()
						end,
				},
				spacer102 = {
					order = 5,
					type = "description",
					name = "\n",
				},
				header102 = {
					order = 6,
					type = "header",
					name = L["Button Icon Container Frame"],
				},
				conpadding = {
					order = 7,
					type = "range",
					name = L["Container Padding"],
					desc = L["Padding Space around the Button Icon Container Frame."],
					min = 0,
					max = 50,
					step = 1,
					width = "double",
					get = function() return me.db.profile.conPadding end,
					set = function(self, v)
						me.db.profile.conPadding = v
						me:UpdateOptions()
						end,
				},
				conbackcolor = {
					order = 8,
					type = "color",
					name = L["Container Background Color"],
					desc = L["Color to Tint the Container Background.\n|cffffff00Note, most images require White and Full Alpha to be seen|r."],
					hasAlpha = true,
					width = "double",
					get = function()
						return me.db.profile.conBackColor.R, me.db.profile.conBackColor.G, me.db.profile.conBackColor.B, me.db.profile.conBackColor.A
						end,
					set = function(info, r,g,b,a)
						me.db.profile.conBackColor.R = r
						me.db.profile.conBackColor.G = g
						me.db.profile.conBackColor.B = b
						me.db.profile.conBackColor.A = a
						me:UpdateOptions()
						end,
				},
				conbordercolor = {
					order = 9,
					type = "color",
					name = L["Container Border Color"],
					desc = L["Color to Tint the Container Border."],
					hasAlpha = true,
					width = "double",
					get = function()
						return me.db.profile.conBorderColor.R, me.db.profile.conBorderColor.G, me.db.profile.conBorderColor.B, me.db.profile.conBorderColor.A
						end,
					set = function(info, r,g,b,a)
						me.db.profile.conBorderColor.R = r
						me.db.profile.conBorderColor.G = g
						me.db.profile.conBorderColor.B = b
						me.db.profile.conBorderColor.A = a
						me:UpdateOptions()
						end,
				},
				spacer103 = {
					order = 10,
					type = "description",
					name = "\n",
				},
				header103 = {
					order = 11,
					type = "header",
					name = L["Simple Frame Style Only"],
				},
				frameborder = {
					order = 12,
					type = "select",
					name = L["Border Artwork"],
					desc = L["Border Artwork of the Simple Frame Style.\n|cffffff00Note, only for the Simple Frame style|r."],
					width = "double",
					values = function() return lsm:HashTable(lsm.MediaType.BORDER) end,
					dialogControl = "LSM30_Border",
					get = function() return me.db.profile.frameBorder end,
					set = function(info, value)
						me.db.profile.frameBorder = value
						me:UpdateOptions()
						end,
				},
				framebordercolor = {
					order = 13,
					type = "color",
					name = L["Border Color"],
					desc = L["Color to Tint the Border Artwork.\n|cffffff00Note, only for the Simple Frame style|r."],
					hasAlpha = true,
					get = function()
						return me.db.profile.frameBorderColor.R, me.db.profile.frameBorderColor.G, me.db.profile.frameBorderColor.B, me.db.profile.frameBorderColor.A
						end,
					set = function(info, r,g,b,a)
						me.db.profile.frameBorderColor.R = r
						me.db.profile.frameBorderColor.G = g
						me.db.profile.frameBorderColor.B = b
						me.db.profile.frameBorderColor.A = a
						me:UpdateOptions()
						end,
				},
				framebordersize = {
					order = 14,
					type = "range",
					name = L["Border Size"],
					desc = L["Thickness of the Border Artwork.\n|cffffff00Note, only for the Simple Frame style|r."],
					min = 1,
					max = 64,
					step = 1,
					width = "double",
					get = function() return me.db.profile.frameBorderSize end,
					set = function(self, v)
						me.db.profile.frameBorderSize = v
						me:UpdateOptions()
						end,
				},
				frameborderinset = {
					order = 15,
					type = "range",
					name = L["Border Inset"],
					desc = L["Inset of the Border Artwork and Background Artwork.\n|cffffff00Note, only for the Simple Frame style|r."],
					min = -64,
					max = 64,
					step = 1,
					width = "double",
					get = function() return me.db.profile.frameBorderInset end,
					set = function(self, v)
						me.db.profile.frameBorderInset = v
						me:UpdateOptions()
						end,
				},
			},
		},
		
		
		-- Icon Buttons / Image Sets
		opticon = {
			order = 2,
			type = "group",
			name = L["Icon Style"],
			args = {
				header201 = {
					order = 1,
					type = "header",
					name = L["Icon Artwork"],
				},
				iconstyle = {
					order = 2,
					type = "select",
					name = L["Icon Artwork Style"],
					desc = L["Style of the Button Icon Artwork."],
					width = "double",
					values = {
						["SimpleSquare"] = L["Simple Square"],
						["SimpleRound"] = L["Simple Round"],
					},
					get = function() return me.db.profile.iconStyle end,
					set = function(self, v)
						me.db.profile.iconStyle = v
						me:UpdateOptions()
						me:UpdateUI_ButtonActions()	-- This is to update the Textures
						end,
				},
				spacer202 = {
					order = 3,
					type = "description",
					name = "\n",
				},
				header202 = {
					order = 4,
					type = "header",
					name = L["Icon Layout"],
				},
				iconlayout = {
					order = 5,
					type = "select",
					name = L["Icon Layout"],
					desc = L["Layout of Button Icons."],
					width = "double",
					values = {
						L["Priority (Left)"],
						L["Simple Rows"],
						L["Center of Attention"],
						L["Look at Me! (Left)"],
						L["Look at Me! (Right)"],
						L["Priority (Right)"],
					},
					get = function() return me.db.profile.iconLayout end,
					set = function(self, v)
						me.db.profile.iconLayout = v
						me:UpdateOptions()
						end,
				},
				iconsize = {
					order = 6,
					type = "range",
					name = L["Icon Size"],
					desc = L["Size of the Button Icons.\n|cffffff00Note, this setting will change when manually resizing the main frame|r."],
					min = 16,
					max = 512,
					step = 1,
					bigStep = 8,
					width = "double",
					get = function() return me.db.profile.iconSize end,
					set = function(self, v)
						me.db.profile.iconSize = v
						me:UpdateOptions()
						end,
				},
				spacer203 = {
					order = 7,
					type = "description",
					name = "\n",
				},
				iconpadding = {
					order = 8,
					type = "range",
					name = L["Icon Padding"],
					desc = L["Padding Space Around the Button Icons."],
					min = 0,
					max = 50,
					step = 1,
					get = function() return me.db.profile.iconPadding end,
					set = function(self, v)
						me.db.profile.iconPadding = v
						me:UpdateOptions()
						end,
				},
				iconspacing = {
					order = 9,
					type = "range",
					name = L["Icon Spacing"],
					desc = L["Space between each Button Icon."],
					min = 0,
					max = 50,
					step = 1,
					get = function() return me.db.profile.iconSpacing end,
					set = function(self, v)
						me.db.profile.iconSpacing = v
						me:UpdateOptions()
						end,
				},
				spacer204 = {
					order = 10,
					type = "description",
					name = "\n",
				},
				header204 = {
					order = 11,
					type = "header",
					name = L["Simple Rows Icon Layout Only"],
				},
				frameiconsperrow = {
					order = 12,
					type = "range",
					name = L["Icons per Row"],
					desc = L["Number of Icon Buttons per Row.\n|cffffff00Note, only for Simple Rows icon layout|r."],
					min = 1,
					max = me.MAX_BUTTONS,
					step = 1,
					width = "double",
					get = function() return me.db.profile.frameIconsPerRow end,
					set = function(self, v)
						me.db.profile.frameIconsPerRow = v
						me:UpdateOptions()
						end,
				},
			},
		},
		
		
		-- Text Names
		opttext = {
			order = 3,
			type = "group",
			name = L["Text Style"],
			args = {
				header301 = {
					order = 1,
					type = "header",
					name = L["Button Text Behaviour"],
				},
				textstyle = {
					order = 2,
					type = "select",
					name = L["Text Behaviour"],
					desc = L["Behaviour of the Button Name Text."],
					width = "double",
					values = {
						L["Always Show"],
						L["On Mouse Over"],
						L["Never Show"],
					},
					get = function() return me.db.profile.textStyle end,
					set = function(self, v)
						me.db.profile.textStyle = v
						me:UpdateOptions()
						end,
				},
				spacer302 = {
					order = 3,
					type = "description",
					name = "\n",
				},
				header302 = {
					order = 4,
					type = "header",
					name = L["Text Style"],
				},
				textfont = {
					order = 5,
					type = "select",
					name = L["Font Face"],
					desc = L["Font type for the Button Text."],
					width = "double",
					values = function() return lsm:HashTable(lsm.MediaType.FONT) end,
					dialogControl = "LSM30_Font",
					get = function() return me.db.profile.textFont end,
					set = function(info, value)
						me.db.profile.textFont = value
						me:UpdateOptions()
						end,
				},
				textcolor = {
					order = 6,
					type = "color",
					name = L["Text Color"],
					desc = L["Color of the Name Text."],
					hasAlpha = true,
					get = function()
						return me.db.profile.textColor.R, me.db.profile.textColor.G, me.db.profile.textColor.B, me.db.profile.textColor.A
						end,
					set = function(info, r,g,b,a)
						me.db.profile.textColor.R = r
						me.db.profile.textColor.G = g
						me.db.profile.textColor.B = b
						me.db.profile.textColor.A = a
						me:UpdateOptions()
						end,
				},
				textflags = {
					order = 7,
					type = "select",
					name = L["Font Flags"],
					desc = L["Font Outline Options."],
					values = {
						["NONE"] = L["None"],
						["OUTLINE"] = L["Outline"],
						["THICKOUTLINE"] = L["Thick Outline"],
						["MONOCHROME"] = L["Monochrome"],
					},
					get = function() return me.db.profile.textFlags end,
					set = function(self, v)
						me.db.profile.textFlags = v
						me:UpdateOptions()
						end,
				},
				textsize = {
					order = 8,
					type = "range",
					name = L["Font Size"],
					desc = L["Size of the Font on the Button Icons.\n|cffffff00Note, this setting will change when manually resizing the main frame|r."],
					min = 1,
					max = 32,
					step = 1,
					get = function() return me.db.profile.textSize end,
					set = function(self, v)
						me.db.profile.textSize = v
						me:UpdateOptions()
						end,
				},
				spacer303 = {
					order = 9,
					type = "description",
					name = "\n",
				},
				textpos = {
					order = 10,
					type = "select",
					name = L["Text Position"],
					desc = L["Position on the Button of the Name Text."],
					values = {
						["TOP"] = L["Top"],
						["RIGHT"] = L["Right"],
						["BOTTOM"] = L["Bottom"],
						["LEFT"] = L["Left"],
						["TOPRIGHT"] = L["Top-Right"],
						["TOPLEFT"] = L["Top-Left"],
						["BOTTOMLEFT"] = L["Bottom-Left"],
						["BOTTOMRIGHT"] = L["Bottom-Right"],
						["CENTER"] = L["Center"],
					},
					get = function() return me.db.profile.textPos end,
					set = function(self, v)
						me.db.profile.textPos = v
						me:UpdateOptions()
						end,
				},
				textAlign = {
					order = 11,
					type = "select",
					name = L["Text Alignment"],
					desc = L["Alignment of the Text on the Button."],
					values = {
						["LEFT"] = L["Left"],
						["RIGHT"] = L["Right"],
						["CENTER"] = L["Center"],
					},
					get = function() return me.db.profile.textAlign end,
					set = function(self, v)
						me.db.profile.textAlign = v
						me:UpdateOptions()
						end,
				},
				spacer304 = {
					order = 12,
					type = "description",
					name = "\n",
				},
				textoffx = {
					order = 13,
					type = "range",
					name = L["Text Offset X"],
					desc = L["Offset of the Text on the X Axis (Horizontal, Left and Right)."],
					min = -100,
					max = 100,
					step = 1,
					get = function() return me.db.profile.textOffX end,
					set = function(self, v)
						me.db.profile.textOffX = v
						me:UpdateOptions()
						end,
				},
				textoffy = {
					order = 14,
					type = "range",
					name = L["Text Offset Y"],
					desc = L["Offset of the Text on the Y Axis (Vertical, Up and Down)."],
					min = -100,
					max = 100,
					step = 1,
					get = function() return me.db.profile.textOffY end,
					set = function(self, v)
						me.db.profile.textOffY = v
						me:UpdateOptions()
						end,
				},
			},
		},
		
		
		-- Spell Ordering
		optspells = {
			order = 4,
			type = "group",
			name = L["Spell Order"],
			args = {
				header401 = {
					order = 1,
					type = "header",
					name = L["Learn Spell Order"],
				},
				learnorder = {
					order = 2,
					type = "toggle",
					name = L["Learn Best Order Automatically"],
					desc = L["Remember each time a destination is chosen, then put the Spell Order from most popular at the top of the list to least popular.\n|cffffff00Note, when learning starts all spells are at zero popularity, so a default order is chosen to begin learning|r."],
					width = "double",
					get = function() return me.db.profile.learnOrder end,
					set = function(self, v) me.db.profile.learnOrder = v end,
				},
				learnresetalliance = {
					order = 3,
					type = "execute",
					name = L["Reset Alliance Learning"],
					desc = L["Reset the Alliance Spell Learning Order to start learning again."],
					width = "double",
					func = function()
						me:Helper_ResetLearning("alliance")
						me:UpdateOptions()
						me:UpdateUI_ButtonActions()
						end,
				},
				learnresethorde = {
					order = 4,
					type = "execute",
					name = L["Reset Horde Learning"],
					desc = L["Reset the Horde Spell Learning Order to start learning again."],
					width = "double",
					func = function()
						me:Helper_ResetLearning("horde")
						me:UpdateOptions()
						me:UpdateUI_ButtonActions()
						end,
				},
				spacer402 = {
					order = 5,
					type = "description",
					name = "\n",
				},
				header402 = {
					order =6,
					type = "header",
					name = L["Manually Change Spell Order"],
				},
				alliance = {
					order = 7,
					type = "execute",
					name = L["Reorder Alliance Spells"],
					desc = L["Manually change the Order of the Alliance Spells.\n|cffffff00Note that manually rearranging spell order will deactivate Learning if active|r."],
					width = "double",
					func = function() me:ShowReorderUI("alliance") end,
				},
				alliancereset = {
					order = 8,
					type = "execute",
					name = L["Reset Alliance"],
					desc = L["Reset the Order of Alliance Spells to their Defaults."],
					func = function()
						me:Helper_ResetOrder("alliance")
						me:UpdateOptions()
						me:UpdateUI_ButtonActions()
						end,
				},
				horde = {
					order = 9,
					type = "execute",
					name = L["Reorder Horde Spells"],
					desc = L["Manualy change the Order of the Horde Spells.\n|cffffff00Note that manually rearranging spell order will deactivate Learning if active|r."],
					width = "double",
					func = function() me:ShowReorderUI("horde") end,
				},
				hordereset = {
					order = 10,
					type = "execute",
					name = L["Reset Horde"],
					desc = L["Reset the Order of Horde Spells to their Defaults."],
					func = function()
						me:Helper_ResetOrder("horde")
						me:UpdateOptions()
						me:UpdateUI_ButtonActions()
						end,
				},
			},
		},
		
		
		opthearthstone = {
			order = 5,
			type = "group",
			name = L["Hearthstone"],
			args = {
				header501 = {
					order = 1,
					type = "header",
					name = L["Hearthstone Behaviour"],
				},
				hearthstone = {
					order = 2,
					type = "select",
					name = L["Hearthstone Artwork"],
					desc = L["Artwork to use for your hearthstone."],
					width = "double",
					values = {
						["hearthstone"] = L["Hearthstone"],
						["garrison"] = L["Faction Garrison"],
					},
					get = function() return me.db.profile.hearthStone end,
					set = function(self, v)
						me.db.profile.hearthStone = v
						me:UpdateOptions()
						me:UpdateUI_ButtonActions()	-- This is to update the Textures
						end,
				},
				hearthtext = {
					order = 3,
					type = "select",
					name = L["Hearthstone Button Text"],
					desc = L["Text to display on your hearthstone button."],
					width = "double",
					values = {
						["hearthstone"] = L["Hearthstone Bind Location"],
						["garrison"] = L["Garrison Name"],
						["both"] =L["Both, Garrison and Hearthstone"],
					},
					get = function() return me.db.profile.hearthText end,
					set = function(self, v)
						me.db.profile.hearthText = v
						me:UpdateOptions()
						me:UpdateUI_ButtonActions()	-- This is to update the Text
						end,
				},
				spacer502 = {
					order = 4,
					type = "description",
					name = "\n",
				},
				hearthleft = {
					order = 5,
					type = "select",
					name = L["Left-Click Action"],
					desc = L["Where you go when you Left-Click."],
					values = {
						["hearthstone"] = L["Hearthstone"],
						["garrison"] = L["Garrison Hearthstone"],
					},
					get = function() return me.db.profile.hearthLeft end,
					set = function(self, v)
						me.db.profile.hearthLeft = v
						me:UpdateOptions()
						me:UpdateUI_ButtonActions()	-- This is to update the Left-Click Action
						end,
				},
				hearthright = {
					order = 6,
					type = "select",
					name = L["Right-Click Action"],
					desc = L["Where you go when you Right-Click."],
					values = {
						["hearthstone"] = L["Hearthstone"],
						["garrison"] = L["Garrison Hearthstone"],
					},
					get = function() return me.db.profile.hearthRight end,
					set = function(self, v)
						me.db.profile.hearthRight = v
						me:UpdateOptions()
						me:UpdateUI_ButtonActions()	-- This is to update the Right-Click Action
						end,
				},
			},
		},
		
		-- Extra Stuff, ESCape Key
		optextras = {
			order = 6,
			type = "group",
			name = L["Extra Stuff"],
			args = {
				header601 = {
					order = 1,
					type = "header",
					name = L["Extra Stuff"],
				},
				keyescape = {
					order = 2,
					type = "toggle",
					name = L["Use ESCAPE to Close."],
					desc = L["Press the ESCape key to close the Portable frame."],
					width = "double",
					get = function() return me.db.profile.keyEscape end,
					set = function(self, v)
						me.db.profile.keyEscape = v
						me:UpdateOptions()
						end,
				},
				spacer602 = {
					order = 3,
					type = "description",
					name = "\n",
				},
				header602 = {
					order =4,
					type = "header",
					name = L["Minimap Button"],
				},
				minimapbutton = {
					order = 5,
					type = "toggle",
					name = L["Hide Minimap Button."],
					desc = L["Hide the Minimap Button for Portable."],
					width = "double",
					get = function() return me.db.profile.minimap.hide end,
					set = function(self, v)
							me.db.profile.minimap.hide = v
							me:UpdateUI_MinimapIcon()
						end,
				},
				spacer603 = {
					order = 6,
					type = "description",
					name = "\n",
				},
				header603 = {
					order =7,
					type = "header",
					name = L["Toolbar Size"],
				},
				toolbarsize = {
					order = 8,
					type = "select",
					name = L["Toolbar Size"],
					desc = L["Size of the Toolbar on the Main Portable Frame."],
					width = "double",
					values = {
						["full"] = L["Large"],
						["half"] = L["Small"],
						["off"] = L["None"],
					},
					get = function() return me.db.profile.toolbarSize end,
					set = function(self, v)
						me.db.profile.toolbarSize = v
						me:UpdateOptions()
						end,
				},
			},
		},
		
		
	},
}


--[[
	Initialize the Configuration UI and Add it to the Blizzard Interface.
]]--
function me.Options:Initialize()
	-- Add a Profile section to the "options" table (Before registering options table)
	options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(me.db)
	
	-- Register Options Table with Ace Config library
	LibStub("AceConfig-3.0"):RegisterOptionsTable(myName, options)
	
	-- Options UI
	local myTitle = me:GetAddonInfo("Title")
	local ACD = LibStub("AceConfigDialog-3.0")
	ACD:AddToBlizOptions(myName, myTitle, nil, "about")	-- This is the Parent category, everything else falls under this
	ACD:AddToBlizOptions(myName, L["Frame Style  |c00000000Portable"], myTitle, "optframe")
	ACD:AddToBlizOptions(myName, L["Button Icons  |c00000000Portable"], myTitle, "opticon")
	ACD:AddToBlizOptions(myName, L["Text Font  |c00000000Portable"], myTitle, "opttext")
	ACD:AddToBlizOptions(myName, L["Spell Order  |c00000000Portable"], myTitle, "optspells")
	ACD:AddToBlizOptions(myName, L["Hearthstone  |c00000000Portable"], myTitle, "opthearthstone")
	ACD:AddToBlizOptions(myName, L["Extra Stuff  |c00000000Portable"], myTitle, "optextras")
	ACD:AddToBlizOptions(myName, L["Profiles  |c00000000Portable"], myTitle, "profile")	-- Adds a Profiles sub-category

end










