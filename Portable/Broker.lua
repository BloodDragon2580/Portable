--[[ ==========================================================================
	© Feyawen Ariana 2007-2015
		If you use my code, please give me credit.
	
	Data Broker Feed for Portable
	
	Notes:
		Originally I was going to use the "LibQTip-1.0" Library, but as I was
		coding for it I realized that it doesn't support secure actions, which
		of course is needed to cast spells and use items.  So I thought about
		using "Dewdrop-2.0" but it hasn't been updated for years.  Thus, I'm
		writting a full frame with secure action buttons, which I really didn't
		want to do, but it seems the only way.
========================================================================== ]]--

local myName, me = ...
local L = me.L		-- Language shorthand


-- Data Broker Feed
me.LDB = LibStub:GetLibrary("LibDataBroker-1.1")	-- Data Broker library
me.brokerFeed = me.LDB:NewDataObject(myName, { type = "data source", text = "" } )


-- Default Data
me.brokerFeed.text = L["Portable "]
me.brokerFeed.icon = "Interface\\Icons\\spell_arcane_portaldalaran"

-- There has to be a better way to handle the hearthstone, but for now, this works
local HEARTHSTONEID = 8690			-- Spell ID used to identify hearthstone special button
local ITEM_HEARTHSTONE = 6948	-- Item ID for the Hearthstone
local ITEM_GARRISON = 110560		-- Item ID for the Garrison Hearthstone
local ITEM_INNKEEPERSDAUGHTER = 64488		-- Item ID for the Archeology item The Innkeeper's Daughter


-- Broker Data Feed Script Events
function me.brokerFeed:OnEnter(...)
	me.broker.hasCellFocus = true
	me:ShowUI_Broker(self)
end

function me.brokerFeed:OnLeave(...)
	me.broker.hasCellFocus = nil
	me.broker.isInGroup = IsInGroup()	-- Watch for this to change if we need to update the tooltip while it's already showing
	me:Helper_BrokerWatchMouse()
end

function me.brokerFeed:OnClick(...)
	local button = select(1, ...)
	if (button == "LeftButton") then
		if (me.ui:IsVisible()) then me.ui:Hide() else me.ui:Show() end
		me:HideUI_Broker()
	elseif (button == "RightButton") then
		me:Helper_ShowConfig()
		me:HideUI_Broker()
	end
end



function me:CreateUI_Broker()
	-- Tooltip Frame
	me["broker"] = CreateFrame("Frame", myName.."BrokerTip", UIParent)
	me.broker:Hide()
	me:SetFrameStyle(me.broker, nil, nil, nil, nil, 0,0,0,0.8, 0.5,0.5,0.5,0.8)
	me.broker:SetSize(400, 100)
	me.broker:SetFrameStrata("TOOLTIP")
	
	
	-- Header
	me.broker["header"] = CreateFrame("Frame", myName.."BrokerTipHeader", me.broker)
	--me:SetFrameStyle(me.broker.header, nil, nil, nil, nil, 0.0,0.0,1.0,0.5, 0.0,0.0,1.0,1.0)
	me.broker.header.text = me.broker.header:CreateFontString(nil)
	me.broker.header.text:SetPoint("TOP", me.broker.header, "TOP", 0, 0)
	me.broker.header.text:SetFont("Fonts\\ARHei.ttf", 14, "")
	me.broker.header.text:SetJustifyV("TOP")
	me.broker.header.text:SetTextColor(0.0,0.5,1.0, 1.0)
	me.broker.header.text:SetNonSpaceWrap(false)
	me.broker.header.text:SetText(L["Portable "])
	me.broker.header:SetHeight(me.broker.header.text:GetStringHeight())
	
	-- Buttons
	local n
	for n = 1, me.MAX_BUTTONS do
		local button = "button"..tostring(n)
		me.broker[button] = CreateFrame("Frame", myName.."BrokerUIButton"..tostring(n), me.broker)
		me.broker[button].ID = n
		me:SetFrameStyle(me.broker[button], nil, nil, nil, nil, 0,0,0,0, 0,0,0,0)
		
		me.broker[button].sab = CreateFrame("Button", myName.."BrokerUIButton"..tostring(n).."SAB", me.broker[button], "SecureActionButtonTemplate")
		me.broker[button].sab:SetAllPoints(me.broker[button])
		me.broker[button].sab:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		me.broker[button].sab:HookScript("OnClick", function(self, ...)
				me:DoScript_OnClick(self, ...)
				me:HideUI_Broker()
			end)
		me.broker[button].sab:SetScript("OnEnter", function(self, ...)
				if (self:IsEnabled()) then self:SetBackdropBorderColor(1,1,1,1) end
			end)
		me.broker[button].sab:SetScript("OnLeave", function(self, ...)
				if (self:IsEnabled()) then self:SetBackdropBorderColor(0,0,0,0) end
			end)
		me:SetFrameStyle(me.broker[button].sab, nil, nil, nil, nil, 0.0,0.0,0.0,0.0, 0.0,0.0,0.0,0.0)
		
		me.broker[button].text = me.broker[button]:CreateFontString(nil)
		me.broker[button].text:SetFont("Fonts\\ARHei.ttf", 12, "")	-- Default font, we don't want a nil font
		me.broker[button].text:SetJustifyV("TOP")
		me.broker[button].text:SetTextColor(1.0,1.0,1.0, 1.0)
	end
	
	-- Info
	me.broker["info"] = CreateFrame("Frame", myName.."BrokerTipInfo", me.broker)
	--me:SetFrameStyle(me.broker.info, nil, nil, nil, nil, 1.0,0.0,0.0,0.5, 1.0,0.0,0.0,1.0)
	me.broker.info.text = me.broker.info:CreateFontString(nil)
	me.broker.info.text:SetFont("Fonts\\ARHei.ttf", 10, "")
	me.broker.info.text:SetPoint("TOPLEFT", me.broker.info, "TOPLEFT", 0, 0)
	me.broker.info.text:SetJustifyV("TOP")
	me.broker.info.text:SetJustifyH("LEFT")
	me.broker.info.text:SetTextColor(0.7,0.7,0.7, 1.0)
	me.broker.info.text:SetNonSpaceWrap(false)
	me.broker.info.text:SetText(L["Left-Click to Toggle Portable Frame.\nRight-Click for Portable Options."])
	me.broker.info:SetHeight(me.broker.info.text:GetStringHeight())
end


function me:UpdateUI_Broker()
	local spells, order, n
	local buttonWidth, buttonHeight = me.broker.info.text:GetStringWidth(), 0
	local color1 = { r=0.1, g=0.1, b=0.2 }
	local color2 = { r=0.2, g=0.2, b=0.3 }
	
	-- Horde or Alliance?
	if (UnitFactionGroup("player") == "Horde") then
		spells = me.hSpell
		order = me.db.profile.hordeSpellOrder
		if (me.db.profile.learnOrder) then me:Helper_LearnOrder("horde") end
		color1 = { r=0.2, g=0.1, b=0.1 }
		color2 = { r=0.3, g=0.2, b=0.2 }
	else
		spells = me.aSpell
		order = me.db.profile.allianceSpellOrder
		if (me.db.profile.learnOrder) then me:Helper_LearnOrder("alliance") end
	end
	
	-- Set the Secure Actions
	local toggle = true
	for n = 1, me.MAX_BUTTONS do
		local button = "button"..tostring(n)
		local name = spells[order[n]].name
		local portal = spells[order[n]].pid
		local teleport = spells[order[n]].tid
		local canPortal = IsSpellKnown(portal)
		local canTeleport = IsSpellKnown(teleport)
		
		me.broker[button].sab.ID = order[n]
		
		-- Hearthstone?
		if (teleport == HEARTHSTONEID) then
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
			-- Sort out the name text
			if (me.db.profile.hearthText == "hearthstone") then
				name = format(L["%s"], GetBindLocation())
			elseif (me.db.profile.hearthText == "garrison") then
				name = format(L["%s's Garrison"], UnitName("player"))
			elseif (me.db.profile.hearthText == "both") then
				name = format(L["%s's Garrison - %s"], UnitName("player"), GetBindLocation())
			end
			-- Hearthstone macro
			me.broker[button].sab:SetAttribute("type", "macro")
			local macro = L["/use "]
			if (canTeleport) then macro = macro .. format(L["[btn:1] item:%d;"], teleport) end
			if (canPortal) then macro = macro .. format(L["[btn:2] item:%d;"], portal) end
			me.broker[button].sab:SetAttribute("macrotext", macro)
		else
		-- Spells
			me.broker[button].sab:SetAttribute("type", "spell")
			if (IsInGroup()) then
				me.broker[button].sab:SetAttribute("spell1", portal)
				me.broker[button].sab:SetAttribute("spell2", teleport)
				if (canPortal) then
					me.broker[button].text:SetTextColor(1,1,1)
					me.broker[button].sab:Enable()
				else
					me.broker[button].text:SetTextColor(0.5,0.5,0.5)
					me.broker[button].sab:Disable()
				end
			else
				me.broker[button].sab:SetAttribute("spell1", teleport)
				me.broker[button].sab:SetAttribute("spell2", portal)
				if (canTeleport) then
					me.broker[button].text:SetTextColor(1,1,1)
					me.broker[button].sab:Enable()
				else
					me.broker[button].text:SetTextColor(0.5,0.5,0.5)
					me.broker[button].sab:Disable()
				end
			end
		end
		-- Text
		me.broker[button].text:SetPoint("CENTER", me.broker[button], "CENTER", 0, 1)
		me.broker[button].text:SetText(name)
		
		if (me.broker[button].text:GetStringWidth() > buttonWidth) then
			buttonWidth = me.broker[button].text:GetStringWidth()
		end
		if (me.broker[button].text:GetStringHeight() > buttonHeight) then
			buttonHeight = me.broker[button].text:GetStringHeight()
		end
		
		if (toggle) then
			me.broker[button]:SetBackdropColor(color1.r, color1.g, color1.b, 0.8)
		else
			me.broker[button]:SetBackdropColor(color2.r, color2.g, color2.b, 0.8)
		end
		toggle = not toggle
	end
	
	-- Set all the buttons to the same size
	buttonHeight = buttonHeight + 2
	for n = 1, me.MAX_BUTTONS do
		me.broker["button"..tostring(n)]:SetSize(buttonWidth, buttonHeight)
	end
	
	me:Helper_UpdateBrokerInfoText()
	
	
	-- Layout
	local padding = 5
	local spacing = 1
	
	local width = padding * 2
	width = width + buttonWidth
	
	local height = padding * 2
	height = height + me.broker.header:GetHeight()
	height = height + (buttonHeight + spacing) * me.MAX_BUTTONS
	height = height + me.broker.info:GetHeight()
	height = height + spacing + padding * 2
	
	me.broker:SetSize(width, height)
	
	me.broker.header:SetPoint("TOP", me.broker, "TOP", 0, -padding)
	me.broker.header:SetWidth(buttonWidth)
	
	me.broker.button1:SetPoint("TOP", me.broker.header, "BOTTOM", 0, -padding)
	me.broker.button1:SetSize(buttonWidth, buttonHeight)
	for n = 2, me.MAX_BUTTONS do
		me.broker["button"..tostring(n)]:SetPoint("TOP", me.broker["button"..tostring(n-1)], "BOTTOM", 0, -spacing)
		me.broker["button"..tostring(n)]:SetSize(buttonWidth, buttonHeight)
	end
	
	me.broker.info:SetPoint("BOTTOMLEFT", me.broker, "BOTTOMLEFT", padding, padding)
	me.broker.info:SetWidth(buttonWidth)
end





function me:ShowUI_Broker(anchorFrame)
	-- Clear points & keep on screen
	me.broker:ClearAllPoints()
	me.broker:SetClampedToScreen(true)
	
	-- Find the best anchor point (depending on where the broker cell is on screen)
	local anchor, anchorParent = "", ""
	local x, y = anchorFrame:GetCenter()
	-- Top or Bottom?
	if (y > (UIParent:GetHeight() / 2)) then
		anchor = "TOP"
		anchorParent = "BOTTOM"
	else
		anchor = "BOTTOM"
		anchorParent = "TOP"
	end
	-- Left, Right, or Center
	if (x > UIParent:GetWidth() / 4) then
		if (x > (UIParent:GetWidth() * 1.5 / 2)) then
			anchor = anchor.."RIGHT"
			anchorParent = anchorParent.."RIGHT"
		end
	else
		anchor = anchor.."LEFT"
		anchorParent = anchorParent.."LEFT"
	end
	me.broker:SetPoint(anchor, anchorFrame, anchorParent)
	
	me:UpdateUI_Broker()
	me.broker:SetScript("OnUpdate", nil)
	
	me.broker:Show()
end



function me:Helper_UpdateBrokerInfoText()
	local infoText = L["|cff00ff00Left-Click|r to Toggle |cff00ffffPortable|r.\n|cff00ff00Right-Click|r for Portable |cff00ffffOptions|r.\n\n"]
	if (IsInGroup()) then
		infoText = infoText..L["|cff00ff00Left-Click|cffffff00 Destination|r to Open a |cff00ffffPortal|r.\n|cff00ff00Right-Click|cffffff00 Destination|r to |cff00ffffTeleport|r."]
	else
		infoText = infoText..L["|cff00ff00Left-Click|cffffff00 Destination|r to |cff00ffffTeleport|r.\n|cff00ff00Right-Click|cffffff00 Destination|r to Open a |cff00ffffPortal|r."]
	end
	me.broker.info.text:SetText(infoText)
	me.broker.info:SetHeight(me.broker.info.text:GetStringHeight())
end



function me:Helper_BrokerWatchMouse()
	me.broker.elapsed = 0
	me.broker:SetScript("OnUpdate", function(self, elapsed)
			me.broker.elapsed = me.broker.elapsed + elapsed
			if (me.broker.elapsed > 0.2) then
				me.broker.elapsed = 0
				if (me.isInGroup ~= IsInGroup()) then
					me.isInGroup = IsInGroup()
					me:UpdateUI_Broker()
				end
				if (not me.broker.hasCellFocus) then
					if (not me.broker:IsMouseOver()) then
						me:HideUI_Broker()
					end
				end
			end
		end)
end

function me:HideUI_Broker()
	me.broker:SetScript("OnUpdate", nil)
	me.broker:Hide()
end



