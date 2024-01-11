local myName, me = ...
local L = me.L



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
	frame[name]:SetFont("Fonts\\ARIALN.TTF", size or 12, "")
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
