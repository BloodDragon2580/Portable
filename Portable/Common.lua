--[[ ==========================================================================
	© Feyawen Ariana 2007-2015
		If you use my code, please give me credit.
	
	
	Common Functions
		This module loads the AddOn name-space with commonly used helper functions.
========================================================================== ]]--

local myName, me = ...
local L = me.L			-- Language



-- Print a message with the AddOn name prefixing
function me:print(what, message)
	what = strlower(what)
	if (not message) then message = what end	-- If no "what kind of message", then "what" IS the "message"
	if (what == "warning") then
		print(L[myName]..L["|cffff8800Warning|cff808080: |cffffff00"]..message)
	elseif (what == "error") then
		print(L[myName]..L["|cffff0000Error|cff808080: |cffffff00"]..message)
	elseif (what == "debug") and (me.debug == true) then
		print(myName.."_Debug: "..message)	-- Don't use anything special, debug is simple output
	else
		print(L[myName]..message)
	end
end



-- Get information from the Add-on .toc file localized if possible.
function me:GetAddonInfo(key)
	-- Get Localized Value First
	local value = GetAddOnMetadata(myName, key.."-"..GetLocale())
	if (value) then return value end
	
	-- Default to Non-Localized Value
	return GetAddOnMetadata(myName, key)
end



--[[ ==========================================================================
	Simple Widgets
	
		Attach a simple Widget to an existing Frame.
========================================================================== ]]--

-- Create a Button using the default Blizzard style
function me:MakeButton(frame, name, text)
	frame[name] = CreateFrame("Button", frame:GetName()..name, frame, "GameMenuButtonTemplate")
	frame[name]:SetText(text)
	local w = frame[name]:GetTextWidth() + 24
	local h = frame[name]:GetTextHeight() + 12
	w = min(max(w, 48), 250)	-- Minimum / Maximum allowed width
	h = min(max(h, 24), 100)	-- Minimum / Maximum allowed width
	frame[name]:SetSize(w, h)
end

-- Create a simple Text area
function me:MakeText(frame, name, size, text)
	frame[name] = frame:CreateFontString(frame:GetName()..name)
	frame[name]:SetFont("Fonts\\ARHei.ttf", size or 12, "")
	frame[name]:SetNonSpaceWrap(true)
	frame[name]:SetJustifyH("LEFT")
	frame[name]:SetJustifyV("TOP")
	frame[name]:SetText(text or "")
end

-- Attach Tooltip
function me:MakeTooltip(frame, text)
	frame:SetScript("OnEnter", function(self, ...)
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:SetText(text, nil, nil, nil, nil, 1, 1)
			GameTooltip:Show()
		end)
	frame:SetScript("OnLeave", function(self, ...)
		GameTooltip:Hide()
	end)
end


--[[ ==========================================================================
	UI Style Helpers
	
		Helpers to adjust settings of existing widgets
========================================================================== ]]--

-- Frame Style
function me:SetFrameStyle(frame, back, border, size, inset, red,green,blue,alpha, borderRed,borderGreen,borderBlue,borderAlpha)
    local function fixSetBackdrop(frame,backdrop)
        if frame.SetBackdrop then return frame:SetBackdrop(backdrop) end
        Mixin(frame,BackdropTemplateMixin)
        frame:SetBackdrop(backdrop)
        frame:OnBackdropLoaded()
    end
    fixSetBackdrop(frame,{
        bgFile = back or "Interface\\Buttons\\WHITE8X8",
        edgeFile = border or "Interface\\Buttons\\WHITE8X8",
        tile = false,
        tileSize = 16,
        edgeSize = size or 1,
        insets = { left = inset or 0, right = inset or 0, top = inset or 0, bottom = inset or 0 },
    } )
    frame:SetBackdropColor(red or 0, green or 0, blue or 0, alpha or 0.75)
    frame:SetBackdropBorderColor(borderRed or 1, borderGreen or 1, borderBlue or 1, borderAlpha or 1)
end

-- Adjust the Font Size without changing the Font or Flags
function me:SetFontSize(textFrame, newSize)
	local name, size, flags = textFrame:GetFont()
	if (size ~= newSize) then
		textFrame:SetFont(name, newSize, flags)
	end
end





--[[ ==========================================================================
	Minimap Button
		Load Options into the [defaults][profile] Table in the Main.lua
			MinimapAngle	= Position around the minimap
		
		Define Function to be Called OnClick
			me:MinimapButtonClick(button)
		
		Call With
			tIcon	= Texture Path used for the button
			sTitle	= Localized addon name for tooltip title
			sInfo	= Localized tooltip information
========================================================================== ]]--
--[[	Removed, using LibDBIcon now
function me:MinimapButton_Create(tIcon, sTitle, sInfo)
	if (me.hasMinimapButton) then return end
	
	-- Button & Textures
	local buttonName = myName.."MinimapButton"
	
	me["MinimapButton"] = CreateFrame("Button", buttonName, Minimap)
	local mmb = me["MinimapButton"]
	mmb:SetSize(31, 31)		-- Seems to be the standard size
	mmb:SetFrameStrata("LOW")	-- Set below most other frames
	mmb:SetToplevel(true)		-- Button should raise itself when clicked
	mmb:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	mmb:SetPoint("CENTER", Minimap, "CENTER")	-- Just a default placeholder
	
	mmb["icon"] = mmb:CreateTexture(buttonName.."Icon", "BACKGROUND")
	local icon = mmb["icon"]
	icon:SetTexture(tIcon)
	icon:SetSize(20, 20)
	icon:SetPoint("TOPLEFT", mmb, "TOPLEFT", 7, -5)
	
	mmb["overlay"] = mmb:CreateTexture(buttonName.."Overlay", "OVERLAY")
	local overlay = mmb["overlay"]
	overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	overlay:SetSize(53, 53)
	overlay:SetPoint("TOPLEFT", mmb, "TOPLEFT")
	
	-- Load the Button Namespace with Position functions
	mmb["SetPosByAngle"] = function(self)
			local a = math.rad(me.db.profile.MinimapAngle)
			local x = 80 * math.cos(a)
			local y = 80 * math.sin(a)
			me["MinimapButton"]:SetPoint("CENTER", "Minimap", "CENTER", x, y)
		end
	mmb["DoUpdate"] = function(self)
			local s = Minimap:GetEffectiveScale()
			local px, py = GetCursorPosition()
			local mx, my = Minimap:GetCenter()
			px = px / s
			py = py / s
			me.db.profile.MinimapAngle = math.deg(math.atan2(py - my, px - mx)) % 360
			me["MinimapButton"]:SetPosByAngle()
		end
		
	-- Scripts
	mmb:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	mmb:SetScript("OnClick", function(self, button)
			if (me["MinimapButtonClick"]) then
				me:MinimapButtonClick(button)
			end
		end)
	mmb:SetScript("OnMouseDown", function(self, button)
		end)
	mmb:SetScript("OnMouseUp", function(self, button)
		end)
	mmb:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:AddLine(sTitle, 1.0, 1.0, 1.0)
			GameTooltip:AddLine(sInfo, 0.0, 1.0, 0.0, 1)
			GameTooltip:Show()
		end)
	mmb:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	
	mmb:RegisterForDrag("LeftButton")
	mmb:SetScript("OnDragStart", function(self)
			self:LockHighlight()
			self:SetScript("OnUpdate", mmb.DoUpdate)
		end)
	mmb:SetScript("OnDragStop", function(self)
			self:SetScript("OnUpdate", nil)
			self:UnlockHighlight()
		end)
	
	-- Update Position and Done
	mmb:SetPosByAngle()
	me.hasMinimapButton = true
end

function me:MinimapButton_Show()
	if (not me.hasMinimapButton) then return end
	me.MinimapButton:Show()
end

function me:MinimapButton_Hide()
	if (not me.hasMinimapButton) then return end
	me.MinimapButton:Hide()
end
]]--





