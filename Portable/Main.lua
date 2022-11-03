local myName, me = ...
local L = me.L

-- Bindings
BINDING_HEADER_Portable = L["Portable"]
BINDING_NAME_PortableToggle = L["Toggle Frame"]



-- Initialize the Shared Media Library
me.lsm = LibStub("LibSharedMedia-3.0")
local lsm = me.lsm	-- libSharedMedia shorthand

-- Register a SOLID option for the Border library
lsm:Register("border", "Solid", [[Interface\Buttons\WHITE8X8]])



--	Default values for all options.
local defaults = {
	profile = {
		-- Main Frame Style
		frameStyle	= 2,				-- 1=Simple / 2=Arcane
		frameBack = "Solid",
		frameBackColor = { R=0, G=0, B=0, A=0.5 },
		-- These only matter with frameStyle == 1 (Simple)
		frameIconsPerRow = 4,
		frameBorder = "Solid",
		frameBorderSize = 1,
		frameBorderInset = 0,
		frameBorderColor = { R=1, G=1, B=1, A=0 },
		
		-- Button Container Frame
		conPadding 	= 5,
		conBackColor = { R=0, G=0, B=0, A=0.5 },
		conBorderColor = { R=0, G=0, B=0, A=0 },
		
		-- Button Icons
		iconStyle		= "SimpleSquare",		-- SimpleSquare / SimpleRound
		iconLayout	= 3,				-- 1=Priority(Left) / 2=SimpleRow / 3=CenterOfAttention / 4=LookAtMe(Left) / 5=LookAtMe(Right) / 6=Priority(Right)
		iconSize		= 96,
		iconPadding	= 3,				-- Padding around the icons to the container
		iconSpacing	= 1,				-- Spacing between the icons
		
		-- Button Text
		textStyle		= 1,			-- 1=Always / 2=OnMouseOver / 3=Never
		textFont		= "Friz Quadrata TT",	-- Default Game Font
		textSize		= 12,
		textFlags		= "OUTLINE",
		textPos			= "BOTTOM",
		textAlign		= "CENTER",
		textOffX		= 0,
		textOffY		= 3,
		textColor = { R=1, G=1, B=1, A=1 },
		
		-- Spell Ordering
		learnOrder = false,
		allianceCounter = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },		-- This is for the Learning option, everything starts at zero
		hordeCounter =  { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },		-- This is for the Learning option, everything starts at zero
		allianceSpellOrder = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },		-- Default Ordering for Priority
		hordeSpellOrder =  { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },		-- Default Ordering for Priority
		
		-- Extra Stuff
		keyEscape = true,	-- Close when ESCAPE is pressed
		
		hearthLeft = "garrison",				-- Left-Click hearthstone button does this action (hearthstone / garrison)
		hearthRight = "hearthstone",		-- Right-Click hearthstone button does this action (hearthstone / garrison)
		hearthStone = "garrison",			-- Which graphic to provide, a Hearthstone or your Faction Garrison (hearthstone / garrison)
		hearthText = "both",					-- What text to display on the button (garrion / hearthstone / both)
		
		minimap = {		-- LibDBIcon
			hide = false,
			minimapPos = 180,
		},
		--[[ Removed, using LibDBIcon instead
		enableMinimapButton = true,		-- Show Minimap Button
		MinimapAngle = 0,					-- Angle around the Minimap to place the Button
		]]--
		toolbarSize = "full"		-- Size of the Toolbar (full, half, off)
	},
}

-- Alliance Portal/Teleport Spell ID's + Friendly Names + Artwork Filenames
me.aSpell = {}
me.aSpell = {
	{ pid = 10059, tid = 3561, name = L["Stormwind"], art="aStormwind" }, --1
	{ pid = 11416, tid = 3562, name = L["Ironforge"], art="aIronforge" },	--2
	{ pid = 11419, tid = 3565, name = L["Darnassus"], art="aDarnassus" },	--3
	{ pid = 32266, tid = 32271, name = L["Exodar"], art="aExodar" }, --4
	{ pid = 49360, tid = 49359, name = L["Theramore"], art="aTheramore" },	--5
	{ pid = 33691, tid = 33690, name = L["Shattrath"], art="nShattrath" },	--6
	{ pid = 53142, tid = 53140, name = L["Dalaran - Northrend"], art="nDalaran" },	--7
	{ pid = 88345, tid = 88342, name = L["Tol Barad"], art="nTolBarad" },	--8
	{ pid = 132620, tid = 132621, name = L["Vale of Eternal Blossoms"], art="aVale" },	--9
	{ pid = 176246, tid = 176248, name = L["Stormshield"], art="aStormshield" },	--10
	{ pid = 224871, tid = 224869, name = L["Dalaran - Broken Isles"], art="nDalaran2" },	--11
	{ pid = 193759, tid = 193759, name = L["Hall of the Guardian"], art="nHalloftheGuardian" },	--12
	{ pid = 281400, tid = 281403, name = L["Boralus"], art="nBoralus" },	--13
	{ pid = 344597, tid = 344587, name = L["Oribos"], art="nOribos" },	--14
	{ pid = 395289, tid = 395277, name = L["Valdrakken"], art="nValdrakken" },	--15
	{ pid = 171253, tid = 8690, name = L["Hearthstone"], art="aHearthstone" },	--16	
}

-- Horde Portal/Teleport Spell ID's + Friendly Names
me.hSpell = {}
me.hSpell = {
	{ pid = 11417, tid = 3567, name = L["Orgrimmar"], art="hOrgrimmar" },	--1
	{ pid = 11418, tid = 3563, name = L["Undercity"], art="hUndercity" },	--2
	{ pid = 11420, tid = 3566, name = L["Thunder Bluff"], art="hThunderBluff" },	--3
	{ pid = 32267, tid = 32272, name = L["Silvermoon City"], art="hSilvermoon" },	--4
	{ pid = 49361, tid = 49358, name = L["Stonard"], art="hStonard" },	--5
	{ pid = 35717, tid = 35715, name = L["Shattrath"], art="nShattrath" },	--6
	{ pid = 53142, tid = 53140, name = L["Dalaran - Northrend"], art="nDalaran" },	--7
	{ pid = 88346, tid = 88344, name = L["Tol Barad"], art="nTolBarad" },	--8
	{ pid = 132626, tid = 132627, name = L["Vale of Eternal Blossoms"], art="aVale" },	--9
	{ pid = 176244, tid = 176242, name = L["Warspear"], art="hWarspear" },	--10
	{ pid = 224871, tid = 224869, name = L["Dalaran - Broken Isles"], art="nDalaran2" },	--11
	{ pid = 193759, tid = 193759, name = L["Hall of the Guardian"], art="nHalloftheGuardian" },	--12
	{ pid = 281402, tid = 281404, name = L["Dazaralor"], art="nDazaralor" },	--13
	{ pid = 344597, tid = 344587, name = L["Oribos"], art="nOribos" },	--14
	{ pid = 395289, tid = 395277, name = L["Valdrakken"], art="nValdrakken" },	--15
	{ pid = 171253, tid = 8690, name = L["Hearthstone"], art="hHearthstone" },	--16	
}

-- Hearthstones are ITEMS not SPELLS!
-- Hearthstone: item:6948						[8690]	 	<-Spell ID, these can not be called directly, but still provide icon texture data
-- Garrison Hearthstone: item:110560		[171253]


-- Local Variables
me.MAX_BUTTONS = #(me.aSpell)
-- Possibly add options for TitleBar (Large / Small / Hidden) ?  (DEV: Currently Doesn't)
local TITLE_SIZE = 48			-- Size of the Title Area, where the Logo and Toolbar go
local TOOLBAR_SIZE = 32	-- Size of the Toolbar Icons
local MIN_WIDTH = 320		-- Minimum Size should asjust depending on the Frame Style (DEV: Currently Doesn't)

local HEARTHSTONEID = 8690		-- Spell ID used to identify hearthstone special button
local ITEM_HEARTHSTONE = 6948	-- Item ID for the Hearthstone
local ITEM_GARRISON = 110560		-- Item ID for the Garrison Hearthstone
local ITEM_INNKEEPERSDAUGHTER = 64488		-- Item ID for the Archeology item The Innkeeper's Daughter
--[[ There is also, but not included for reasons...
	Ruby Slippers	28585	(Old Content from Karazhan)
	Dark Portal		93672	(Trading Card Game, not included because FUCK TCG!)
	Ethereal Portal	54452	(Trading Card Game, *see above*)
]]--



--[[
	Event Handling Frame.
]]--
me.EventFrame = CreateFrame("Frame", myName.."EventFrame", UIParent)
local Event = me.EventFrame
Event:Hide()
Event:SetScript("OnEvent", function(self, event, ...)
	if (self[event]) then
		self[event](self, ...)
	end
end)
Event:RegisterEvent("ADDON_LOADED")



--[[
	Event: AddOn Loaded
		Initialize the Options Database and Call the Config function (separate lua file)
]]--
function Event:ADDON_LOADED(addonName)
	if (addonName ~= myName) then return end
	Event:UnregisterEvent("ADDON_LOADED")	-- Don't care about other addon being loaded
	
	-- Initialize our Options into the AceDB library
	me.db = LibStub("AceDB-3.0"):New(myName.."DB", defaults, true)
	
	-- When changes to the profile happen, update appearance options
	local function doUpdate() me:UpdateOptions(); me:UpdateUI_ButtonActions(); end
	me.db:RegisterCallback("OnNewProfile", doUpdate)
	me.db:RegisterCallback("OnProfileChanged", doUpdate)
	me.db:RegisterCallback("OnProfileReset", doUpdate)
	
	-- Create the UI
	me:CreateUI()
	
	-- Initialize our Options UI
	me.Options:Initialize()
	
	-- Update any appearance options used by the Add-on
	me:UpdateOptions()
	
	-- Minimap Button
	me:CreateUI_MinimapIcon()
	--[[ Removed, using LibDBIcon instead
	me:MinimapButton_Create("Interface\\Icons\\spell_arcane_portaldalaran", L["Portable "], L["Left-Click to Toggle Main Frame.\nRight-Click for Options."])
	if (not me.db.profile.enableMinimapButton) then me:MinimapButton_Hide() end
	]]--
	
	-- Data Broker
	me:CreateUI_Broker()
	
	-- Info
	me:print(format(L["Version |cffffff00%s |cff00ff00Loaded|r.  Use |cffffff00%s|r to Toggle UI |cffa0a0a0(or use a Key Binding)|r, |cffffff00%s %s|r for Command List."], me:GetAddonInfo("Version"), L["/portable"], L["/portable"], L["help"]))
end


--[[
	Callback of the AceDB profile changes.
	Used to update graphical alterations to the UI.
]]--
function me:UpdateOptions()
	me.UpdateUI()
end


--[[ ==========================================================================
	Create the UI Elements
		me.ui				= Main Artwork Frame
		me.ui.area		= Resizing Area Display
		me.ui.sizer		= Grabable Space for the User to Resize the Frame
		me.ui.container	= Main Button Container
		me.ui.button#	= Button
========================================================================== ]]--
function me:CreateUI()
	me:CreateUI_Frame()
	me:CreateUI_Container()
	me:CreateUI_Buttons()
	me:CreateUI_Sizer()
	
	me.ui.container:SetFrameLevel(1)
	me.ui.area:SetFrameLevel(10)			-- Make sure the Area display is on top of the buttons container
end


-- Create the Main Frame, everything else is attached to this frame
function me:CreateUI_Frame()
	me.ui = CreateFrame("Frame", "PortableUIFrame", UIParent)
	me.ui:Hide()
	me.ui:SetFrameStrata("DIALOG")
	me.ui:EnableMouse(true)
	me.ui:SetMovable(true)
	me.ui:SetResizable(true)
	me.ui:SetClampedToScreen(true)
	me.ui:SetResizeBounds(MIN_WIDTH, 100)
	me.ui:SetSize(MIN_WIDTH, 100) --If a frame size is not given, weird things happen (this value is temporary)
	me.ui:SetPoint("CENTER", UIParent, "CENTER", 50, 0)
	me.ui:SetScript("OnSizeChanged", function(self, w, h)
			me:UpdateUI_FrameSize(w, h)
		end)
	me.ui:SetScript("OnMouseDown", function(self, ...)
			me.ui:StartMoving()
		end)
	me.ui:SetScript("OnMouseUp", function(self, ...)
			me.ui:StopMovingOrSizing()
		end)
	me.ui:SetScript("OnHide", function(self, ...)
			me.Resizing = false
			me.ui:StopMovingOrSizing()
		end)
	me.ui:SetScript("OnShow", function(self, ...)
			me:UpdateUI_IconSizeFrame()	-- Force a Size Fix, this fixes issues if the Style changes while the frame is hidden
			me:UpdateUI_ButtonActions()
		end)
	
	-- Create the Artwork Textures
	me.ui.artHeader = me.ui:CreateTexture(nil, "ARTWORK")	-- Header (Top-Center)
	me.ui.artT = me.ui:CreateTexture(nil, "BORDER")				-- Top
	me.ui.artB = me.ui:CreateTexture(nil, "BORDER")				-- Bottom
	me.ui.artL = me.ui:CreateTexture(nil, "BORDER")				-- Right
	me.ui.artR = me.ui:CreateTexture(nil, "BORDER")				-- Left
	me.ui.artTL = me.ui:CreateTexture(nil, "ARTWORK")			-- TopLeft
	me.ui.artTR = me.ui:CreateTexture(nil, "ARTWORK")			-- TopRight
	me.ui.artBL = me.ui:CreateTexture(nil, "ARTWORK")			-- BottomLeft
	me.ui.artBR = me.ui:CreateTexture(nil, "ARTWORK")			-- BottomRight
	
	-- Logo Texture only needs to be setup once as it never changes
	me.ui.artLogo = me.ui:CreateTexture(nil, "ARTWORK")		-- Portable
	me.ui.artLogoL = me.ui:CreateTexture(nil, "ARTWORK")	-- Gnome In
	me.ui.artLogoR = me.ui:CreateTexture(nil, "ARTWORK")	-- Gnome Out
	me.ui.artLogo:SetTexture("Interface\\AddOns\\Portable\\Artwork\\PortableLogo.blp", false)
	me.ui.artLogo:SetTexCoord(0.0, 1.0,   0.0, 0.5)	--     0>512        0^256
	me.ui.artLogo:SetPoint("TOP", me.ui, "TOP", 0, 0)
	
	-- Titlebar Buttons
	me.ui.btnClose = CreateFrame("Button", "PortableUICloseButton", me.ui)
	me.ui.btnClose:SetNormalTexture("Interface\\AddOns\\Portable\\Artwork\\PortableClose.blp")
	me.ui.btnClose:SetHighlightTexture("Interface\\AddOns\\Portable\\Artwork\\PortableCloseH.blp")
	me.ui.btnClose:SetSize(TOOLBAR_SIZE, TOOLBAR_SIZE)
	me.ui.btnClose:SetPoint("TOPRIGHT", me.ui, "TOPRIGHT", 0, 0)
	me.ui.btnClose:SetScript("OnClick", function(self, ...)
			me.ui:Hide()
		end)
	me:MakeTooltip(me.ui.btnClose, L["Close Portable."])
	
	me.ui.btnConfig = CreateFrame("Button", "PortableUIConfigurationButton", me.ui)
	me.ui.btnConfig:SetNormalTexture("Interface\\AddOns\\Portable\\Artwork\\PortableConfiguration.blp")
	me.ui.btnConfig:SetHighlightTexture("Interface\\AddOns\\Portable\\Artwork\\PortableConfigurationH.blp")
	me.ui.btnConfig:SetSize(TOOLBAR_SIZE, TOOLBAR_SIZE)
	me.ui.btnConfig:SetPoint("TOPRIGHT", me.ui.btnClose, "TOPLEFT", -8, 0)
	me.ui.btnConfig:SetScript("OnClick", function(self, ...)
			me:Helper_ShowConfig()	-- Show the configuration
			me.ui:Hide()	-- hide ourself because we're above the Options Frame Strata
		end)
	me:MakeTooltip(me.ui.btnConfig, L["Open Portable Configuration."])
	
	me.ui.btnSort = CreateFrame("Button", "PortableUISortButton", me.ui)
	me.ui.btnSort:SetNormalTexture("Interface\\AddOns\\Portable\\Artwork\\PortableSortOrder.blp")
	me.ui.btnSort:SetHighlightTexture("Interface\\AddOns\\Portable\\Artwork\\PortableSortOrderH.blp")
	me.ui.btnSort:SetSize(TOOLBAR_SIZE, TOOLBAR_SIZE)
	me.ui.btnSort:SetPoint("TOPRIGHT", me.ui.btnConfig, "TOPLEFT", -8, 0)
	me.ui.btnSort:SetScript("OnClick", function(self, ...)
			me:ShowReorderUI(strlower(UnitFactionGroup("player")))	-- Show the Reorder frame for Alliance or Horde depending on current player faction
		end)
	me:MakeTooltip(me.ui.btnSort, format(L["Manually Change the Spell Order for %s."], UnitFactionGroup("Player")))
	
end


-- Create a "Sizer" allowing the user to resize the frame, with an area display
function me:CreateUI_Sizer()
	-- This will cover the entire main frame while resizing
	me.ui.area = CreateFrame("Frame", "PortableUIArea", me.ui)
	me.ui.area:Hide()
	me.ui.area:SetAllPoints(me.ui)
	me:SetFrameStyle(me.ui.area, nil, nil, nil, nil, 0,0,0,0.75, 1,1,0,1)
	
	-- Create a simple text to display the size as we're being resized
	me:MakeText(me.ui.area, "size", 18, "X")	-- This is temporary text
	me.ui.area.size:SetJustifyH("CENTER")
	me.ui.area.size:SetPoint("CENTER", me.ui.area, "CENTER", 0, 0)
	
	
	-- Create a space the user can "grab" to resize
	me.ui.sizer = CreateFrame("Frame", "PortableUISizer", me.ui)
	me.ui.sizer:EnableMouse(true)
	me.ui.sizer:SetSize(32, 32)
	me.ui.sizer:SetPoint("BOTTOMRIGHT", me.ui, "BOTTOMRIGHT", 0, 0)
	me.ui.sizer:SetScript("OnEnter", function(self, ...)
			me:SetFrameStyle(me.ui.sizer, "Interface\\AddOns\\Portable\\Artwork\\PortableSizer.blp", nil, nil, nil, 1,1,1,1, 0,0,0,0)
		end)
	me.ui.sizer:SetScript("OnLeave", function(self, ...)
			me:SetFrameStyle(me.ui.sizer, nil, nil, nil, nil, 0,0,0,0, 0,0,0,0)
		end)
	me.ui.sizer:SetScript("OnMouseDown", function(self, ...)
			me.Resizing = true
			me.ui.area:Show()
			me.ui:StartSizing()
			me:UpdateUI_FrameSize(me.ui:GetWidth(), me.ui:GetHeight())
		end)
	me.ui.sizer:SetScript("OnMouseUp", function(self, ...)
			me.ui.area:Hide()
			me.ui:StopMovingOrSizing()
			me:UpdateUI_FrameSize(me.ui:GetWidth(), me.ui:GetHeight(), true)
			me.Resizing = false
		end)
end


-- Simple Container Frame that will hold all the Portable Buttons
function me:CreateUI_Container()
	me.ui.container = CreateFrame("Frame", "PortableUIContainer", me.ui)
end


-- Create the Clickable Portable Buttons
function me:CreateUI_Buttons()
	local n
	-- Create each button using a Secure Action template
	for n = 1, me.MAX_BUTTONS do
		local button = "button"..tostring(n)
		
		-- Each "button" is really a Frame with a Button, Texture, and Text
		me.ui[button] = CreateFrame("Frame", "PortableUIButton"..tostring(n), me.ui.container)
		me.ui[button].ID = n
		me.ui[button]:SetScript("OnEnter", function(self, ...)
				me:DoScript_OnEnter(self, ...)
			end)
		me.ui[button]:SetScript("OnLeave", function(self, ...)
				me:DoScript_OnLeave(self, ...)
			end)
		
		-- The Secure Action Button
		me.ui[button].sab = CreateFrame("Button", "PortableUIButton"..tostring(n).."SAB", me.ui[button], "SecureActionButtonTemplate")
		me.ui[button].sab:RegisterForClicks("LeftButtonDown", "RightButtonDown")
		me.ui[button].sab:SetScript("OnEnter", function(self, ...)
				me:DoScript_OnEnter(self, ...)
			end)
		me.ui[button].sab:SetScript("OnLeave", function(self, ...)
				me:DoScript_OnLeave(self, ...)
			end)
		me.ui[button].sab:HookScript("OnClick", function(self, ...)
				me:DoScript_OnClick(self, ...)
			end)
		me.ui[button].sab:SetAllPoints(me.ui[button])
		
		-- Disabled Texture (If a mage doesn't know a spell, it will be greyed out)
		me.ui[button].disabled = me.ui[button]:CreateTexture(nil, "ARTWORK")
		me.ui[button].disabled:SetAllPoints(me.ui[button])
		
		-- Text (Shows the name of the destination)
		me.ui[button].text = CreateFrame("Frame", nil, me.ui[button])
		me.ui[button].text:SetAllPoints(me.ui[button])
		me.ui[button].text.name = me.ui[button].text:CreateFontString(nil)
		me.ui[button].text.name:SetFont("Fonts\\ARHei.ttf", 12, "")	-- Default font, we don't want a nil font
		me.ui[button].text.name:SetJustifyV("TOP")
	end
end

--[[ ==========================================================================
	Update UI
========================================================================== ]]--
function me:UpdateUI()
	me:UpdateUI_FrameStyle()
	me:UpdateUI_ButtonGrid()
	me:UpdateUI_IconSizeFrame()
	me:UpdateUI_TextStyle()
end


-- Update the Frame as it is being Resized
function me:UpdateUI_FrameSize(width, height, fix)
	if (not me.Resizing) then return end
	
	local pad = me.db.profile.iconPadding
	local space = me.db.profile.iconSpacing
	local perRow = me.db.profile.frameIconsPerRow
	local w = width
	local h = 0
	
	-- Get the Toolbar Size
	local titleSize, toolSize = me:Helper_GetToolbarSize()

	-- Remove the Outter Padding
	if (me.db.profile.frameStyle == 1) then		-- Simple
		w = w - (me.db.profile.conPadding * 2)
		h = h + (me.db.profile.conPadding * 2) + titleSize
	elseif (me.db.profile.frameStyle == 2) then	-- Arcane
		w = w - 40
		h = h + 40 + titleSize
	else
	end
	
	-- Remove the Inner Padding
	w = w - (pad * 2)	
	h = h + (pad * 2)
	
	-- Remove the Inner Spacing & Get New Icon Size
	if (me.db.profile.iconLayout == 1) or (me.db.profile.iconLayout == 6) then		-- Priority (Left / Right)
		w = w - (space * 7)
		size = floor(w / 8)
		h = h +(size * 3) + (space * 2)
	elseif (me.db.profile.iconLayout == 2) then	-- Simple
		w = w - (space * (perRow - 1))
		size = floor(w / perRow)
		local numRows = floor(me.MAX_BUTTONS / perRow) + 1
		h = h + (size * numRows) + (space * (numRows - 1))
	elseif (me.db.profile.iconLayout == 3) then -- Center of Attention
		w = w - (space * 8)
		size = floor(w / 9)
		h = h +(size * 3) + (space * 2)
	elseif (me.db.profile.iconLayout == 4) or (me.db.profile.iconLayout == 5) then -- Look at Me (Left / Right)
		w = w - (space * 6)
		size = floor(w / 7)
		h = h +(size * 4) + (space * 3)
	else
	end
	
	-- Set the Icon Size
	me.ui:SetHeight(h)
	me.db.profile.iconSize = size
	local fontSize = floor((12 * (size / 96)) + 0.5)	-- Adjust Font Size to fit new frame size
	me.db.profile.textSize = fontSize
	me:UpdateUI_ButtonGrid()
	
	-- Display
	me.ui.area.size:SetText(format("%d x %d\n(Icon: %d) (Font: %d)", width, height, size, fontSize))
	
	-- Only fix once resizing has stopped
	if (fix) then
		me:UpdateUI_IconSizeFrame()
	end
end


-- Size the Frame around the Icon Size
function me:UpdateUI_IconSizeFrame()
	local width, height = 0, 0
	local size = me.db.profile.iconSize
	local pad = me.db.profile.iconPadding
	local space = me.db.profile.iconSpacing
	
	-- Get the Inner Sizes
	if (me.db.profile.iconLayout == 1) or (me.db.profile.iconLayout == 6) then	-- Priority (Left / Right)
		width = (size * 8) + (space * 7)
		height = (size * 3) + (space * 2)
	elseif (me.db.profile.iconLayout == 2) then	-- Simple
		width = (size * me.db.profile.frameIconsPerRow) + (space * (me.db.profile.frameIconsPerRow - 1))
		local numRows = floor(me.MAX_BUTTONS / me.db.profile.frameIconsPerRow) + 1
		height = (size * numRows) + (space * (numRows - 1))
	elseif (me.db.profile.iconLayout == 3) then -- Center of Attention
		width = (size * 9) + (space * 8)
		height = (size * 3) + (space * 2)
	elseif (me.db.profile.iconLayout == 4) or (me.db.profile.iconLayout == 5) then -- Look at Me (Left / Right)
		width = (size * 8) + (space * 6)
		height = (size * 4) + (space * 3)
	else
		me:print("error", L["Invalid Icon Layout in UpdateUI_IconSizeFrame"])
	end
	
	-- Add the Inner Padding
	width = width + (pad * 2)
	height = height + (pad * 2)
	
	-- Get the Toolbar Size
	local titleSize, toolSize = me:Helper_GetToolbarSize()
	
	-- Add the Outter Padding
	if (me.db.profile.frameStyle == 1) then	-- Simple
		width = width + (me.db.profile.conPadding * 2)
		height = height + (me.db.profile.conPadding * 2) + titleSize
	elseif (me.db.profile.frameStyle == 2) then	-- Arcane
		width = width + 40
		height = height + 40 + titleSize
	else
		me:print("error", L["Invalid Frame Style in UpdateUI_IconSizeFrame"])
	end
	
	-- Set the size
	me.ui:SetSize(width, height)
end


-- Update the Container frame's simple style
function me:UpdateUI_Container(titlePad, pad)
	me:SetFrameStyle(me.ui.container, nil, nil, nil, nil, me.db.profile.conBackColor.R, me.db.profile.conBackColor.G, me.db.profile.conBackColor.B, me.db.profile.conBackColor.A, me.db.profile.conBorderColor.R, me.db.profile.conBorderColor.G, me.db.profile.conBorderColor.B, me.db.profile.conBorderColor.A)
	me.ui.container:ClearAllPoints()
	me.ui.container:SetPoint("TOPLEFT", me.ui, "TOPLEFT", pad, -titlePad - pad)
	me.ui.container:SetPoint("BOTTOMRIGHT", me.ui, "BOTTOMRIGHT", -pad, pad)
end


-- Show/Hide Artwork Textures
function me:UpdateUI_ShowTextures(on)
	if (on) then
		me.ui.artHeader:Show()
		me.ui.artT:Show()
		me.ui.artB:Show()
		me.ui.artL:Show()
		me.ui.artR:Show()
		me.ui.artTL:Show()
		me.ui.artTR:Show()
		me.ui.artBL:Show()
		me.ui.artBR:Show()
	else
		me.ui.artHeader:Hide()
		me.ui.artT:Hide()
		me.ui.artB:Hide()
		me.ui.artL:Hide()
		me.ui.artR:Hide()
		me.ui.artTL:Hide()
		me.ui.artTR:Hide()
		me.ui.artBL:Hide()
		me.ui.artBR:Hide()
	end
end

-- Update the Main Frame's Style
function me:UpdateUI_FrameStyle()
	-- Extra Stuff
	me:Helper_EscapeToClose()
	
	local lsmback = lsm:Fetch(lsm.MediaType.BACKGROUND, me.db.profile.frameBack)
	local lsmborder = lsm:Fetch(lsm.MediaType.BORDER, me.db.profile.frameBorder)
	
	-- Get the Toolbar Size
	local titleSize, toolSize = me:Helper_GetToolbarSize()
	
	if (me.db.profile.toolbarSize == "full") then	-- Only show the Logo on FULL toolbar (it's too damn small otherwise)
		me.ui.artLogo:SetSize(titleSize * 2, titleSize)
		me.ui.artLogoL:SetSize(titleSize, titleSize)
		me.ui.artLogoR:SetSize(titleSize, titleSize)
		me.ui.artLogo:Show()
		me.ui.artLogoL:Show()
		me.ui.artLogoR:Show()
	else
		me.ui.artLogo:Hide()
		me.ui.artLogoL:Hide()
		me.ui.artLogoR:Hide()
	end
	if (me.db.profile.toolbarSize ~= "off") then	-- No toolbar at all
		me.ui.btnClose:SetSize(toolSize, toolSize)
		me.ui.btnConfig:SetSize(toolSize, toolSize)
		me.ui.btnSort:SetSize(toolSize, toolSize)
		me.ui.btnClose:Show()
		me.ui.btnConfig:Show()
		me.ui.btnSort:Show()
	else
		me.ui.btnClose:Hide()
		me.ui.btnConfig:Hide()
		me.ui.btnSort:Hide()
	end
	
	-- Simple
	if (me.db.profile.frameStyle == 1) then
		me:UpdateUI_Container(titleSize, me.db.profile.conPadding)
		me:SetFrameStyle(me.ui, lsmback, lsmborder, me.db.profile.frameBorderSize, me.db.profile.frameBorderInset, me.db.profile.frameBackColor.R, me.db.profile.frameBackColor.G, me.db.profile.frameBackColor.B, me.db.profile.frameBackColor.A, me.db.profile.frameBorderColor.R, me.db.profile.frameBorderColor.G, me.db.profile.frameBorderColor.B, me.db.profile.frameBorderColor.A)
		-- Logo
		me.ui.artLogo:ClearAllPoints()
		me.ui.artLogo:SetPoint("TOP", me.ui, "TOP", 0, -2)
		-- Toolbar
		me.ui.btnClose:ClearAllPoints()
		me.ui.btnClose:SetPoint("TOPRIGHT", me.ui, "TOPRIGHT", -4, -4)
		-- Art Textures
		me:UpdateUI_ShowTextures(false)
		
		
	-- Arcane
	elseif (me.db.profile.frameStyle == 2) then
		me:UpdateUI_Container(titleSize, 20)
		me:SetFrameStyle(me.ui, lsmback, nil, nil, nil, me.db.profile.frameBackColor.R, me.db.profile.frameBackColor.G, me.db.profile.frameBackColor.B, me.db.profile.frameBackColor.A, 0,0,0,0)
		
		-- Logo
		me.ui.artLogo:ClearAllPoints()
		me.ui.artLogo:SetPoint("TOP", me.ui, "TOP", 0, -20)
		--[[	Removed because reasons
		-- Put the Portal Gnomes on the sides of the Portable frame
		me.ui.artLogoL:ClearAllPoints()
		me.ui.artLogoR:ClearAllPoints()
		me.ui.artLogoL:SetPoint("RIGHT", me.ui, "LEFT", 0, 0)
		me.ui.artLogoR:SetPoint("LEFT", me.ui, "RIGHT", 0, 0)
		me.ui.artLogoL:SetSize(256, 256)
		me.ui.artLogoR:SetSize(256, 256)
		]]--
		-- Tool Buttons
		me.ui.btnClose:ClearAllPoints()
		me.ui.btnClose:SetPoint("TOPRIGHT", me.ui, "TOPRIGHT", -24, -24)
		
		-- Header Art
		me.ui.artHeader:SetTexture("Interface\\VoidStorage\\VoidStorage.blp", false)
		me.ui.artHeader:SetTexCoord(0.0, 0.65,   0.0, 0.16)
		me.ui.artHeader:SetSize(335, 83)
		me.ui.artHeader:SetPoint("BOTTOM", me.ui, "TOP", 0, -16)
		
		--[[	BORDERS ]]--
		-- Top
		me.ui.artT:SetTexture("Interface\\Transmogrify\\HorizontalTiles.blp", true)
		me.ui.artT:SetTexCoord(0, 10,   0.3906, 0.7343 )
		me.ui.artT:SetSize(64, 23)
		me.ui.artT:SetPoint("TOPLEFT", me.ui, "TOPLEFT", 24, 0)
		me.ui.artT:SetPoint("TOPRIGHT", me.ui, "TOPRIGHT", -24, 0)
		-- Bottom
		me.ui.artB:SetTexture("Interface\\Transmogrify\\HorizontalTiles.blp", true)
		me.ui.artB:SetTexCoord(0, 10,   0.0312, 0.3750 )
		me.ui.artB:SetSize(64, 23)
		me.ui.artB:SetPoint("BOTTOMLEFT", me.ui, "BOTTOMLEFT", 24, 0)
		me.ui.artB:SetPoint("BOTTOMRIGHT", me.ui, "BOTTOMRIGHT", -24, 0)
		-- Left
		me.ui.artL:SetTexture("Interface\\Transmogrify\\VerticalTiles.blp", true)
		me.ui.artL:SetTexCoord(0.4062, 0.7500,   0, 10)
		me.ui.artL:SetSize(23, 64)
		me.ui.artL:SetPoint("TOPLEFT", me.ui, "TOPLEFT", 0, -48)
		me.ui.artL:SetPoint("BOTTOMLEFT", me.ui, "BOTTOMLEFT", 0, 48)
		-- Right
		me.ui.artR:SetTexture("Interface\\Transmogrify\\VerticalTiles.blp", true)
		me.ui.artR:SetTexCoord(0.0156, 0.3593,   0, 10)
		me.ui.artR:SetSize(23, 64)
		me.ui.artR:SetPoint("TOPRIGHT", me.ui, "TOPRIGHT", 0, -48)
		me.ui.artR:SetPoint("BOTTOMRIGHT", me.ui, "BOTTOMRIGHT", 0, 48)
		
		--[[	CORNERS ]]--
		-- Top-Left
		me.ui.artTL:SetTexture("Interface\\Transmogrify\\Textures.blp", false)
		me.ui.artTL:SetTexCoord(0.0078, 0.4921,   0.0019, 0.1230)
		me.ui.artTL:SetSize(64, 64)
		me.ui.artTL:SetPoint("TOPLEFT", me.ui, "TOPLEFT", -4, 4)
		-- Top-Right
		me.ui.artTR:SetTexture("Interface\\Transmogrify\\Textures.blp", false)
		me.ui.artTR:SetTexCoord(0.0156, 0.5000,   0.3847, 0.5058)
		me.ui.artTR:SetSize(64, 64)
		me.ui.artTR:SetPoint("TOPRIGHT", me.ui, "TOPRIGHT", 4, 4)
		-- Bottom-Left
		me.ui.artBL:SetTexture("Interface\\Transmogrify\\Textures.blp", false)
		me.ui.artBL:SetTexCoord(0.0078, 0.4921,   0.2578, 0.3789)
		me.ui.artBL:SetSize(64, 64)
		me.ui.artBL:SetPoint("BOTTOMLEFT", me.ui, "BOTTOMLEFT", -4, -4)
		-- Bottom-Right
		me.ui.artBR:SetTexture("Interface\\Transmogrify\\Textures.blp", false)
		me.ui.artBR:SetTexCoord(0.0156, 0.5000,   0.1308, 0.2519)
		me.ui.artBR:SetSize(64, 64)
		me.ui.artBR:SetPoint("BOTTOMRIGHT", me.ui, "BOTTOMRIGHT", 4, -4)
		
		-- Art Textures
		me:UpdateUI_ShowTextures(true)
		
		
	-- Error
	else
		me:print("error", L["Invalid Frame Style in UpdateUI_FrameStyle"])
	end
end


-- Update the Portable Buttons grid
function me:UpdateUI_ButtonGrid()
	local pad = me.db.profile.iconPadding
	local space = me.db.profile.iconSpacing
	local size = me.db.profile.iconSize
	
	local n
	for n = 1, me.MAX_BUTTONS do
		local button = "button"..tostring(n)
		me.ui[button]:ClearAllPoints()
		me.ui[button]:SetSize(me.db.profile.iconSize, me.db.profile.iconSize)
		me.ui[button].text.name:SetJustifyH(me.db.profile.textAlign)
		me.ui[button].text.name:ClearAllPoints()
		me.ui[button].text.name:SetPoint(me.db.profile.textPos, me.ui[button].text, me.db.profile.textPos, me.db.profile.textOffX, me.db.profile.textOffY)
		me:Helper_AdjustFont(me.ui[button].text.name, me.db.profile.textFont, me.db.profile.textSize, me.db.profile.textFlags)
	end
	
	-- Priority (LEFT) 优先 (左)
	if (me.db.profile.iconLayout == 1) then
		me.ui.button1:SetPoint("TOPLEFT", me.ui.container, "TOPLEFT",  pad, -pad)
		me.ui.button1:SetSize(size * 3 + space + space, size * 3 + space + space)
		me.ui.button1.text.name:ClearAllPoints()
		me.ui.button1.text.name:SetPoint(me.db.profile.textPos, me.ui.button1.text, me.db.profile.textPos, me.db.profile.textOffX * 2, me.db.profile.textOffY * 2)
		me:Helper_AdjustFont(me.ui.button1.text.name, me.db.profile.textFont, me.db.profile.textSize * 2, me.db.profile.textFlags)
		
		me.ui.button2:SetPoint("TOPLEFT", me.ui.button1, "TOPRIGHT", space, 0)
		--me.ui.button2:SetSize(size * 1 + space, size * 1 + space)
		--me.ui.button2.text.name:ClearAllPoints()
		--me.ui.button2.text.name:SetPoint(me.db.profile.textPos, me.ui.button2.text, me.db.profile.textPos, me.db.profile.textOffX * 1, me.db.profile.textOffY * 1)
		--me:Helper_AdjustFont(me.ui.button2.text.name, me.db.profile.textFont, me.db.profile.textSize * 1, me.db.profile.textFlags)
		
		me.ui.button3:SetPoint("TOPLEFT", me.ui.button2, "TOPRIGHT", space, 0)
		me.ui.button4:SetPoint("TOPLEFT", me.ui.button3, "TOPRIGHT", space, 0)
		me.ui.button5:SetPoint("TOPLEFT", me.ui.button4, "TOPRIGHT", space, 0)		
		me.ui.button6:SetPoint("TOPLEFT", me.ui.button5, "TOPRIGHT", space, 0)
		
		me.ui.button7:SetPoint("BOTTOMLEFT", me.ui.button1, "BOTTOMRIGHT", space, 0)
		me.ui.button8:SetPoint("TOPLEFT", me.ui.button7, "TOPRIGHT", space, 0)
		me.ui.button9:SetPoint("TOPLEFT", me.ui.button8, "TOPRIGHT", space, 0)	
		me.ui.button10:SetPoint("TOPLEFT", me.ui.button9, "TOPRIGHT", space, 0)	
		me.ui.button11:SetPoint("TOPLEFT", me.ui.button10, "TOPRIGHT", space, 0)

		me.ui.button12:SetPoint("LEFT", me.ui.button1, "RIGHT", space, 0)
		me.ui.button13:SetPoint("TOPLEFT", me.ui.button12, "TOPRIGHT", space, 0)
		me.ui.button14:SetPoint("TOPLEFT", me.ui.button13, "TOPRIGHT", space, 0)	
		me.ui.button15:SetPoint("TOPLEFT", me.ui.button14, "TOPRIGHT", space, 0)
		me.ui.button16:SetPoint("TOPLEFT", me.ui.button15, "TOPRIGHT", space, 0)
	
	-- Simple Rows
	elseif (me.db.profile.iconLayout  == 2) then
		local perRow = me.db.profile.frameIconsPerRow
		local x, y, r, c = 0, 0, 0, 0
		
		for n = 1, me.MAX_BUTTONS do
			local button = "button"..tostring(n)
			x = pad + ((size + space) * c)
			y = pad + ((size + space) * r)
			me.ui[button]:SetPoint("TOPLEFT", me.ui.container, "TOPLEFT", x, -y)
			
			c = c + 1	-- Column++
			if (c == perRow) then
				c = 0		-- Column Reset
				r = r + 1	-- Row++
			end
		end
	
	
	-- Center of Attention 中间为主
	elseif (me.db.profile.iconLayout == 3) then
		me.ui.button4:SetPoint("TOPLEFT", me.ui.container, "TOPLEFT", pad, -pad)
		
		me.ui.button2:SetPoint("TOPLEFT", me.ui.button4, "TOPRIGHT", space, 0)
		me.ui.button2:SetSize(size * 1 + space, size * 1 + space)
		me.ui.button2.text.name:ClearAllPoints()
		me.ui.button2.text.name:SetPoint(me.db.profile.textPos, me.ui.button2.text, me.db.profile.textPos, me.db.profile.textOffX * 1, me.db.profile.textOffY * 1)
		me:Helper_AdjustFont(me.ui.button2.text.name, me.db.profile.textFont, me.db.profile.textSize * 1, me.db.profile.textFlags)
		
		me.ui.button1:SetPoint("TOPLEFT", me.ui.button14, "TOPRIGHT",  space, 0)
		me.ui.button1:SetSize(size * 3 + space + space, size * 3 + space + space)
		me.ui.button1.text.name:ClearAllPoints()
		me.ui.button1.text.name:SetPoint(me.db.profile.textPos, me.ui.button1.text, me.db.profile.textPos, me.db.profile.textOffX * 2, me.db.profile.textOffY * 2)
		me:Helper_AdjustFont(me.ui.button1.text.name, me.db.profile.textFont, me.db.profile.textSize * 2, me.db.profile.textFlags)
		
		me.ui.button3:SetPoint("TOPLEFT", me.ui.button1, "TOPRIGHT", space, 0)
		me.ui.button3:SetSize(size * 2 + space, size * 2 + space)
		me.ui.button3.text.name:ClearAllPoints()
		me.ui.button3.text.name:SetPoint(me.db.profile.textPos, me.ui.button3.text, me.db.profile.textPos, me.db.profile.textOffX * 1.5, me.db.profile.textOffY * 1.5)
		me:Helper_AdjustFont(me.ui.button3.text.name, me.db.profile.textFont, me.db.profile.textSize * 1.5, me.db.profile.textFlags)
		
		me.ui.button5:SetPoint("TOPLEFT", me.ui.button3, "TOPRIGHT", space, 0)
		--
		me.ui.button6:SetPoint("TOPLEFT", me.ui.button4, "BOTTOMLEFT", 0, -space)
		me.ui.button7:SetPoint("TOPLEFT", me.ui.button5, "BOTTOMLEFT", 0, -space)
		--
		me.ui.button8:SetPoint("TOPLEFT", me.ui.button6, "BOTTOMLEFT", 0, -space)
		me.ui.button9:SetPoint("TOPLEFT", me.ui.button2, "BOTTOMLEFT", 0, -space)
		me.ui.button10:SetPoint("TOPRIGHT", me.ui.button9, "BOTTOMRIGHT", 0, -space)
		me.ui.button11:SetPoint("TOPLEFT", me.ui.button3, "BOTTOMLEFT", 0, -space)
		me.ui.button12:SetPoint("TOPRIGHT", me.ui.button3, "BOTTOMRIGHT", 0, -space)
		me.ui.button13:SetPoint("TOPLEFT", me.ui.button7, "BOTTOMLEFT", 0, -space)
		
		me.ui.button14:SetPoint("TOPLEFT", me.ui.button2, "TOPRIGHT", 0, -space)	
		me.ui.button15:SetPoint("TOPLEFT", me.ui.button2, "BOTTOMRIGHT", 0, -space)
		me.ui.button16:SetPoint("TOPLEFT", me.ui.button9, "BOTTOMRIGHT", 0, -space)
		
	-- Look at Me (LEFT) 超大! (左)
	elseif (me.db.profile.iconLayout == 4) then
		me.ui.button1:SetPoint("TOPLEFT", me.ui.container, "TOPLEFT",  pad, -pad)
		me.ui.button1:SetSize(size * 4 + (space * 3), size * 4 + (space * 3))
		me.ui.button1.text.name:ClearAllPoints()
		me.ui.button1.text.name:SetPoint(me.db.profile.textPos, me.ui.button1.text, me.db.profile.textPos, me.db.profile.textOffX * 2.5, me.db.profile.textOffY * 2.5)
		me:Helper_AdjustFont(me.ui.button1.text.name, me.db.profile.textFont, me.db.profile.textSize * 2.5, me.db.profile.textFlags)
		
		me.ui.button2:SetPoint("TOPLEFT", me.ui.button1, "TOPRIGHT", space, 0)
		me.ui.button3:SetPoint("TOPLEFT", me.ui.button2, "BOTTOMLEFT", 0, -space)
		me.ui.button4:SetPoint("TOPLEFT", me.ui.button3, "BOTTOMLEFT", 0, -space)
		me.ui.button5:SetPoint("TOPLEFT", me.ui.button4, "BOTTOMLEFT", 0, -space)
		
		me.ui.button6:SetPoint("TOPLEFT", me.ui.button2, "TOPRIGHT", space, 0)
		me.ui.button7:SetPoint("TOPLEFT", me.ui.button6, "BOTTOMLEFT", 0, -space)
		me.ui.button8:SetPoint("TOPLEFT", me.ui.button7, "BOTTOMLEFT", 0, -space)
		me.ui.button9:SetPoint("TOPLEFT", me.ui.button8, "BOTTOMLEFT", 0, -space)
		
		me.ui.button10:SetPoint("TOPLEFT", me.ui.button6, "TOPRIGHT", space, 0)
		me.ui.button11:SetPoint("TOPLEFT", me.ui.button10, "BOTTOMLEFT", 0, -space)
		me.ui.button12:SetPoint("TOPLEFT", me.ui.button11, "BOTTOMLEFT", 0, -space)
		me.ui.button13:SetPoint("TOPLEFT", me.ui.button12, "BOTTOMLEFT", 0, -space)
		
		me.ui.button14:SetPoint("TOPLEFT", me.ui.button10, "TOPRIGHT", 0, -space)
		me.ui.button15:SetPoint("TOPLEFT", me.ui.button12, "TOPRIGHT", 0, -space)
		me.ui.button16:SetPoint("TOPLEFT", me.ui.button13, "TOPRIGHT", 0, -space)
		
		
	-- Look at Me (RIGHT) 超大! (右)
	elseif (me.db.profile.iconLayout == 5) then
		me.ui.button1:SetPoint("TOPRIGHT", me.ui.container, "TOPRIGHT",  -pad, -pad)
		me.ui.button1:SetSize(size * 4 + (space * 3), size * 4 + (space * 3))
		me.ui.button1.text.name:ClearAllPoints()
		me.ui.button1.text.name:SetPoint(me.db.profile.textPos, me.ui.button1.text, me.db.profile.textPos, me.db.profile.textOffX * 2.5, me.db.profile.textOffY * 2.5)
		me:Helper_AdjustFont(me.ui.button1.text.name, me.db.profile.textFont, me.db.profile.textSize * 2.5, me.db.profile.textFlags)
		
		me.ui.button2:SetPoint("TOPRIGHT", me.ui.button1, "TOPLEFT", -space, 0)
		me.ui.button3:SetPoint("TOPLEFT", me.ui.button2, "BOTTOMLEFT", 0, -space)
		me.ui.button4:SetPoint("TOPLEFT", me.ui.button3, "BOTTOMLEFT", 0, -space)
		me.ui.button5:SetPoint("TOPLEFT", me.ui.button4, "BOTTOMLEFT", 0, -space)
		
		me.ui.button6:SetPoint("TOPRIGHT", me.ui.button2, "TOPLEFT", -space, 0)
		me.ui.button7:SetPoint("TOPLEFT", me.ui.button6, "BOTTOMLEFT", 0, -space)
		me.ui.button8:SetPoint("TOPLEFT", me.ui.button7, "BOTTOMLEFT", 0, -space)
		me.ui.button9:SetPoint("TOPLEFT", me.ui.button8, "BOTTOMLEFT", 0, -space)
		
		me.ui.button10:SetPoint("TOPRIGHT", me.ui.button6, "TOPLEFT", -space, 0)
		me.ui.button11:SetPoint("TOPLEFT", me.ui.button10, "BOTTOMLEFT", 0, -space)
		me.ui.button12:SetPoint("TOPLEFT", me.ui.button11, "BOTTOMLEFT", 0, -space)
		me.ui.button13:SetPoint("TOPLEFT", me.ui.button12, "BOTTOMLEFT", 0, -space)

		me.ui.button14:SetPoint("TOPRIGHT", me.ui.button10, "TOPLEFT", 0, -space)
		me.ui.button15:SetPoint("TOPRIGHT", me.ui.button12, "TOPLEFT", 0, -space)
		me.ui.button16:SetPoint("TOPRIGHT", me.ui.button13, "TOPLEFT", 0, -space)
		
		
	-- Priority (RIGHT) 优先 (右) ... A few guildies have asked for a backwards Priority Layout, so here it is
	elseif (me.db.profile.iconLayout == 6) then
		me.ui.button1:SetPoint("TOPRIGHT", me.ui.container, "TOPRIGHT",  -pad, -pad)
		me.ui.button1:SetSize(size * 3 + space + space, size * 3 + space + space)
		me.ui.button1.text.name:ClearAllPoints()
		me.ui.button1.text.name:SetPoint(me.db.profile.textPos, me.ui.button1.text, me.db.profile.textPos, me.db.profile.textOffX * 2, me.db.profile.textOffY * 2)
		me:Helper_AdjustFont(me.ui.button1.text.name, me.db.profile.textFont, me.db.profile.textSize * 2, me.db.profile.textFlags)
		
		me.ui.button2:SetPoint("TOPRIGHT", me.ui.button1, "TOPLEFT", -space, 0)
		--me.ui.button2:SetSize(size * 1 + space, size * 1 + space)
		--me.ui.button2.text.name:ClearAllPoints()
		--me.ui.button2.text.name:SetPoint(me.db.profile.textPos, me.ui.button2.text, me.db.profile.textPos, me.db.profile.textOffX * 1, me.db.profile.textOffY * 1)
		--me:Helper_AdjustFont(me.ui.button2.text.name, me.db.profile.textFont, me.db.profile.textSize * 1, me.db.profile.textFlags)
		
		me.ui.button3:SetPoint("TOPRIGHT", me.ui.button2, "TOPLEFT", -space, 0)
		me.ui.button4:SetPoint("TOPRIGHT", me.ui.button3, "TOPLEFT", -space, 0)
		me.ui.button5:SetPoint("TOPRIGHT", me.ui.button4, "TOPLEFT", -space, 0)
		me.ui.button6:SetPoint("TOPRIGHT", me.ui.button5, "TOPLEFT", -space, 0)

		
		me.ui.button7:SetPoint("BOTTOMRIGHT", me.ui.button1, "BOTTOMLEFT", -space, 0)
		me.ui.button8:SetPoint("TOPRIGHT", me.ui.button7, "TOPLEFT", -space, 0)
		me.ui.button9:SetPoint("TOPRIGHT", me.ui.button8, "TOPLEFT", -space, 0)
		me.ui.button10:SetPoint("TOPRIGHT", me.ui.button9, "TOPLEFT", -space, 0)
		me.ui.button11:SetPoint("TOPRIGHT", me.ui.button10, "TOPLEFT", -space, 0)
		
		
		me.ui.button12:SetPoint("RIGHT", me.ui.button1, "LEFT", -space, 0)
		me.ui.button13:SetPoint("TOPRIGHT", me.ui.button12, "TOPLEFT", -space, 0)
		me.ui.button14:SetPoint("TOPRIGHT", me.ui.button13, "TOPLEFT", -space, 0)
		me.ui.button15:SetPoint("TOPRIGHT", me.ui.button14, "TOPLEFT", -space, 0)
		me.ui.button16:SetPoint("TOPRIGHT", me.ui.button15, "TOPLEFT", -space, 0)		
		
	-- Invalid
	else
		me:print("error", L["Invalid Icon Layout in UpdateUI_ButtonGrid"])
	end
end


-- Update Button Actions, this makes the buttons cast spells when you click them
function me:UpdateUI_ButtonActions()
	local spells, order, n
	local artPath = "Interface\\AddOns\\Portable\\Artwork\\"..me.db.profile.iconStyle.."\\"
	local isAlliance = false
	
	-- Horde or Alliance?
	if (UnitFactionGroup("player") == "Horde") then
		spells = me.hSpell
		order = me.db.profile.hordeSpellOrder
		if (me.db.profile.learnOrder) then me:Helper_LearnOrder("horde") end
	else
		isAlliance = true
		spells = me.aSpell
		order = me.db.profile.allianceSpellOrder
		if (me.db.profile.learnOrder) then me:Helper_LearnOrder("alliance") end
	end
	local total = #(spells)
	
	for n = 1, total do
		local button = "button"..tostring(n)
		local isHearthstone = false
		
		local name = spells[order[n]].name
		local art = spells[order[n]].art
		local portal = spells[order[n]].pid
		local teleport = spells[order[n]].tid
		
		local canPortal = IsSpellKnown(portal)
		local canTeleport = IsSpellKnown(teleport)
		
		
		-- Is this the Hearthstone Button?
		if (teleport == HEARTHSTONEID) then
			isHearthstone = true
			-- Sort out the Left and Right Clicks
			if (me.db.profile.hearthLeft == "hearthstone") then
				teleport = ITEM_HEARTHSTONE
				canTeleport = me:Helper_IsInBags(ITEM_HEARTHSTONE)
				if (not canTeleport) then
					teleport = ITEM_INNKEEPERSDAUGHTER
					canTeleport = me:Helper_IsInBags(ITEM_INNKEEPERSDAUGHTER)
				end
			elseif (me.db.profile.hearthLeft == "garrison") then
				teleport = ITEM_GARRISON
				canTeleport = me:Helper_IsInBags(ITEM_GARRISON)
			else
				canTeleport = false
			end
			if (me.db.profile.hearthRight == "hearthstone") then
				portal = ITEM_HEARTHSTONE
				canPortal = me:Helper_IsInBags(ITEM_HEARTHSTONE)
				if (not canPortal) then
					portal = ITEM_INNKEEPERSDAUGHTER
					canPortal = me:Helper_IsInBags(ITEM_INNKEEPERSDAUGHTER)
				end
			elseif (me.db.profile.hearthRight == "garrison") then
				portal = ITEM_GARRISON
				canPortal = me:Helper_IsInBags(ITEM_GARRISON)
			else
				canPortal = false
			end
			-- Sort out the graphic
			if (me.db.profile.hearthStone == "hearthstone") then
			   if (UnitFactionGroup("player") == "Horde") then
				art = "hHearthstone"
			   else
				art = "aHearthstone"
			   end
			elseif (me.db.profile.hearthStone == "garrison") then
				if (isAlliance) then
					art = "aGarrison"
				else
					art = "hGarrison"
				end
			else
			   if (UnitFactionGroup("player") == "Horde") then
				art = "hHearthstone"
			   else
				art = "aHearthstone"
			   end
			end
			-- Sort out the name text
			if (me.db.profile.hearthText == "hearthstone") then
				name = format(L["%s"], GetBindLocation())
			elseif (me.db.profile.hearthText == "garrison") then
				name = format(L["%s's Garrison"], UnitName("player"))
			elseif (me.db.profile.hearthText == "both") then
				name = format(L["%s's Garrison ----- %s"], UnitName("player"), GetBindLocation())
			else
				name = ""
			end
		end
		
		-- Set the Name, Texture, & ID
		me.ui[button].text.name:SetText(gsub(name, " ", "\n"))
		me.ui[button].sab:SetNormalTexture(artPath..art..".blp")
		me.ui[button].sab:SetHighlightTexture(artPath.."sHighlight.blp")
		me.ui[button].sab.ID = order[n]
		
		-- Is this the hearthstone?
		if (isHearthstone) then
			me.ui[button].sab:SetAttribute("type", "macro")
			local macro = L["/use "]
			if (canTeleport) then macro = macro .. format(L["[btn:1] item:%d;"], teleport) end
			if (canPortal) then macro = macro .. format(L["[btn:2] item:%d;"], portal) end
			me.ui[button].sab:SetAttribute("macrotext", macro)
		
		-- This is a spell
		else
			me.ui[button].sab:SetAttribute("type", "spell")
			--if (IsInGroup()) then
				--me.ui[button].sab:SetAttribute("spell1", portal)
				--me.ui[button].sab:SetAttribute("spell2", teleport)
				--me:Helper_ShowDisabled(canPortal, button, artPath..art..".blp")
			--else
				me.ui[button].sab:SetAttribute("spell1", teleport)
				me.ui[button].sab:SetAttribute("spell2", portal)
				me:Helper_ShowDisabled(canTeleport, button, artPath..art..".blp")
			--end
		end
		-- Show the button
		me.ui[button]:Show()
	end
	
	-- Hide Remaining Buttons
	for n = total + 1, me.MAX_BUTTONS do
		me.ui["button"..tostring(n)]:Hide()
	end
end


-- Update the Text Display
function me:UpdateUI_TextStyle()
	local n
	if (me.db.profile.textStyle == 1) then	-- Always
		for n = 1, me.MAX_BUTTONS do
			me.ui["button"..tostring(n)].text.name:Show()
		end
	else		-- OnMouseOver & Never (In both cases we hide the text)
		for n = 1, me.MAX_BUTTONS do
			me.ui["button"..tostring(n)].text.name:Hide()
		end
	end
end









--[[ ==========================================================================
	Helpers
========================================================================== ]]--
-- Show the Disabled Texture and Hide the Button
function me:Helper_ShowDisabled(on, button, file)
	--if (on) then
		--me.ui[button].sab:Show()
		--me.ui[button].disabled:Hide() 
	--else
		--me.ui[button].sab:Hide()
		--me.ui[button].disabled:SetTexture(file)
		--me.ui[button].disabled:SetVertexColor(0.5, 0.5, 0.5)
		--me.ui[button].disabled:SetDesaturated(true)
		--me.ui[button].disabled:Show()
	--end
end


-- Adjust font Face, Size, & Flags settings Only if changed, each time a new font instance is created, so we don't want to change unless needed
function me:Helper_AdjustFont(frame, newface, newsize, newflags)
	local face, size, flags = frame:GetFont()
	local lsmnewface = lsm:Fetch(lsm.MediaType.FONT, newface)
	if (lsmnewface ~= face) or (size ~= newsize) or (flags ~= newflags) then
		frame:SetFont(lsmnewface, newsize, newflags)
	end
	-- Set the color
	frame:SetTextColor(me.db.profile.textColor.R, me.db.profile.textColor.G, me.db.profile.textColor.B, me.db.profile.textColor.A)
end


-- Set the Spell Order to the Learning Spell Order
function me:Helper_LearnOrder(faction)
	local n, k, total
	local order = {}
	local neworder = {}
	local sorted = {}
	local used = {}
	
	if (faction == "alliance") then
		-- Sort the array by highest number of click count to lowest
		total = #(defaults.profile.allianceSpellOrder)
		for n = 1, total do
			order[n] = me.db.profile.allianceCounter[n]
			sorted[n] = order[n]
			used[n] = false
		end
		sort(sorted, function(a,b) return a>b end)
		
		-- figure out which key goes to which number
		for n = 1, total do
			for k = 1, total do
				if (sorted[n] == order[k]) and (used[k] == false) then
					neworder[n] = k
					used[k] = true
					break
				end
			end
		end
		
		-- Set the new spell order
		for n = 1, total do
			me.db.profile.allianceSpellOrder[n] = neworder[n]
		end
		
	elseif (faction == "horde") then
		-- Sort the array by highest number of click count to lowest
		total = #(defaults.profile.hordeSpellOrder)
		for n = 1, total do
			order[n] = me.db.profile.hordeCounter[n]
			sorted[n] = order[n]
			used[n] = false
		end
		sort(sorted, function(a,b) return a>b end)
		
		-- figure out which key goes to which number
		for n = 1, total do
			for k = 1, total do
				if (sorted[n] == order[k]) and (used[k] == false) then
					neworder[n] = k
					used[k] = true
					break
				end
			end
		end
		
		-- Set the new spell order
		for n = 1, total do
			me.db.profile.hordeSpellOrder[n] = neworder[n]
		end
		
	else
		me:print("error", L["Invalid Faction in Helper_LearnOrder"])
	end
end


-- Reset the Learning Spell Order
function me:Helper_ResetLearning(faction)
	local n, total
	if (faction == "alliance") then
		total = #(defaults.profile.allianceCounter)
		for n = 1, total do
			me.db.profile.allianceCounter[n] = defaults.profile.allianceCounter[n]
		end
	elseif (faction == "horde") then
		total = #(defaults.profile.hordeCounter)
		for n = 1, total do
			me.db.profile.hordeCounter[n] = defaults.profile.hordeCounter[n]
		end
	elseif (faction == "both") then
		total = #(defaults.profile.allianceCounter)
		for n = 1, total do
			me.db.profile.allianceCounter[n] = defaults.profile.allianceCounter[n]
			me.db.profile.hordeCounter[n] = defaults.profile.hordeCounter[n]
		end
	else
		me:print("error", L["Invalid Faction in Helper_ResetLearning."])
	end
end


-- Reset a Faction's Spell Order
function me:Helper_ResetOrder(faction)
	local n, total
	if (faction == "alliance") then
		total = #(defaults.profile.allianceSpellOrder)
		for n = 1, total do
			me.db.profile.allianceSpellOrder[n] = defaults.profile.allianceSpellOrder[n]
		end
	elseif (faction == "horde") then
		total = #(defaults.profile.hordeSpellOrder)
		for n = 1, total do
			me.db.profile.hordeSpellOrder[n] = defaults.profile.hordeSpellOrder[n]
		end
	elseif (faction == "both") then
		total = #(defaults.profile.allianceSpellOrder)
		for n = 1, total do
			me.db.profile.allianceSpellOrder[n] = defaults.profile.allianceSpellOrder[n]
			me.db.profile.hordeSpellOrder[n] = defaults.profile.hordeSpellOrder[n]
		end
	else
		me:print("error", L["Invalid Faction in Helper_ResetOrder."])
	end
end


-- Is item in player's bags?
function me:Helper_IsInBags(itemID)
	local bag, slot
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			if (GetContainerItemID(bag, slot)) == itemID then
				return true
			end
		end
	end
	return false
end


-- Get the Height for the Toolbar
function me:Helper_GetToolbarSize()
	local titleSize = TITLE_SIZE				-- Default Size
	local toolSize = TOOLBAR_SIZE		-- Default Size
	if (me.db.profile.toolbarSize == "half") then	-- Half Size
		titleSize = TITLE_SIZE / 2
		toolSize = TOOLBAR_SIZE / 2
	elseif (me.db.profile.toolbarSize == "off") then	-- Off
		titleSize = 2
		toolSize = 0
	end
	return titleSize, toolSize
end


-- Show the Configuration
function me:Helper_ShowConfig()
--	InterfaceAddOnsList_Update()	-- If the Blizzard Options Frame hasn't been Opened yet, OpenToCategory will fail, so we force a refresh first
	InterfaceOptionsFrame_OpenToCategory(L["Frame Style  |c00000000Portable"])	-- By selecting a SubCategory first, the Options Tree will be open when we select the main Category
	InterfaceOptionsFrame_OpenToCategory(myName)	-- Select the main category (which is setup as an About frame)
end


-- Enable/Disable close with ESCape key
function me:Helper_EscapeToClose()
	if (me.db.profile.keyEscape) then		-- Enable ESCape
		-- Only add use to the Special Frames if we're not already there
		local i = me:Helper_IsSpecialFrame()
		if (not i) then
			tinsert(UISpecialFrames, me.ui:GetName())
		end
	else	-- Disable ESCape
		-- Find and remove us from the Special Frames
		local i = me:Helper_IsSpecialFrame()
		if (i) then
			tremove(UISpecialFrames, i)
		end
	end
end
function me:Helper_IsSpecialFrame()
	local n, name = 0, me.ui:GetName()
	for n = 1, #(UISpecialFrames) do
		if (UISpecialFrames[n] == name) then
			return n
		end
	end
	return nil
end









--[[ ==========================================================================
	Widget Handlers
========================================================================== ]]--
function me:DoScript_OnEnter(self, ...)
	if (me.db.profile.textStyle == 2) then
		if (self.text) then	-- parent, the parent will get the OnEnter for spells the player hasn't learned
			self.text.name:Show()
		else	-- button
			self:GetParent().text.name:Show()
		end
	end
end

function me:DoScript_OnLeave(self, ...)
	if (me.db.profile.textStyle == 2) then
		if (self.text) then	-- parent, the parent will get the OnEnter for spells the player hasn't learned
			self.text.name:Hide()
		else	-- button
			self:GetParent().text.name:Hide()
		end
	end
end

function me:DoScript_OnClick(self, ...)
	if (me.db.profile.learnOrder) then
		if (UnitFactionGroup("player") == "Horde") then
			me.db.profile.hordeCounter[self.ID] = me.db.profile.hordeCounter[self.ID] + 1
		else
			me.db.profile.allianceCounter[self.ID] = me.db.profile.allianceCounter[self.ID] + 1
		end
	end
	me.ui:Hide()
end










--[[ ==========================================================================
	Minimap Button
========================================================================== ]]--
--[[	Removed, using LibDBIcon instead
function me:MinimapButtonClick(button)
	if (button == "LeftButton") then
		if (me.ui:IsVisible()) then me.ui:Hide() else me.ui:Show() end
	elseif (button == "RightButton") then
		me:Helper_ShowConfig()
	end
end
]]--









--[[ ==========================================================================
	Simple Command Line
========================================================================== ]]--
SlashCmdList["PORTABLE"] = function(command)
	if (command) and (command ~= "") then
		if (command == L["config"]) then
			me:Helper_ShowConfig()
		elseif (command == L["sort"]) then
			me:ShowReorderUI(strlower(UnitFactionGroup("player")))
		elseif (command == L["show"]) then
			if (not me.ui:IsVisible()) then me.ui:Show() end
		elseif (command == L["hide"]) then
			if (me.ui:IsVisible()) then me.ui:Hide() end
		elseif (command == L["toggle"]) then
			if (me.ui:IsVisible()) then me.ui:Hide() else me.ui:Show() end
		elseif (command == L["help"]) or (command == L["?"]) then
			me:Slash_Help()
		else
			me:print("warning", format(L["|cffffffffInvalid Command |cffffff00\"|cffff8800%s|cffffff00\"|r."], command))
		end
	else
		if (me.ui:IsVisible()) then me.ui:Hide() else me.ui:Show() end
	end
end
SLASH_PORTABLE1 = L["/portable"]


function me:Slash_Help()
	me:print(format(L["Usage: |cffffff00%s |cffff8800[command]"], L["/portable"]))
	me:print(L["|cff00ff00No command will toggle the Portable UI."])
	me:print(L["Optional Commands:"])
	me:print(format(L["    |cffff8800%s|r : Show the Portable Configuration UI."], L["config"]))
	me:print(format(L["    |cffff8800%s|r : Show the Portable UI."], L["show"]))
	me:print(format(L["    |cffff8800%s|r : Hide the Portable UI."], L["hide"]))
	me:print(format(L["    |cffff8800%s|r : Toggle the Portable UI."], L["toggle"]))
	me:print(format(L["    |cffff8800%s|r : Show the Manage Spell Order UI for %s."], L["sort"], UnitFactionGroup("player")))
	me:print(format(L["    |cffff8800%s|r : Show usage and command list."], L["help"]))
end










