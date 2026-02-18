local myName, me = ...
local L = me.L


local itemSize = 18
local textFont = "Arial Narrow"

local itemHeight = 0	-- this is a placeholder, the code will change this value
local listFaction = ""	-- are we editing the alliance or the horde?
local order = {}		-- holds the list order we are editing
local spells = nil

local draggingIndex = nil	-- which list row is currently being dragged
local hoverIndex = nil		-- which row we are hovering while dragging


local function SetRowBorder(row, r, g, b, a)
	-- Use an inner border frame so the highlight isn't clipped by the ScrollFrame.
	if row and row.dragBorder then
		row.dragBorder:SetBackdropBorderColor(r, g, b, a)
		if a and a > 0 then row.dragBorder:Show() else row.dragBorder:Hide() end
	elseif row and row.SetBackdropBorderColor then
		-- no-op: row itself has no border
		if a and a > 0 then
			row:SetBackdropBorderColor(r, g, b, a)
		else
			row:SetBackdropBorderColor(0, 0, 0, 0)
		end
	end
end
		-- Pointer to the aSpell or hSpell table depending if order alliance or horde spell order

function me:ShowReorderUI(mode)
	if (me.rui) and (me.rui:IsVisible()) then return end	-- Don't start if we're already running
	
	wipe(order)
	spells = nil
	
	if (mode == "alliance") then	-- Alliance
		for n = 1, me.MAX_BUTTONS do
			order[n] = me.db.profile.allianceSpellOrder[n]
		end
		spells = me.aSpell
	elseif (mode == "horde") then	-- Horde
		for n = 1, me.MAX_BUTTONS do
			order[n] = me.db.profile.hordeSpellOrder[n]
		end
		spells = me.hSpell
	else
		me:print("error", L["Invalid Order List Faction Mode in ShowReorderUI"])
		return
	end
	
	listFaction = mode
	if (not me.rui) then me:CreateUI_Reorder() end
	me:UpdateUI_Reorder()
	me.rui:Show()
end


function me:Apply_Reorder()
	if (listFaction == "alliance") then
		for n = 1, me.MAX_BUTTONS do
			me.db.profile.allianceSpellOrder[n] = order[n]
		end
	elseif (listFaction == "horde") then
		for n = 1, me.MAX_BUTTONS do
			me.db.profile.hordeSpellOrder[n] = order[n]
		end
	else
		me:print("error", L["Invalid Order List Faction Mode in Apply_Reorder"])
		return
	end
	me:UpdateOptions()
	me:UpdateUI_ButtonActions()
end


function me:CreateUI_Reorder()
	local pad = 6
	local buttonRowH = 34 -- space reserved for buttons at the bottom
	local frameW, frameH = 360, 430

	me.rui = CreateFrame("Frame", myName.."ReorderUI", UIParent, "BackdropTemplate")
	me.rui:Hide()
	me.rui:EnableMouse(true)
	me.rui:SetMovable(true)
	me.rui:SetClampedToScreen(true)
	me.rui:SetFrameStrata("FULLSCREEN") -- Keep us above the main Portable frame (we're not really full screen)
	me.rui:SetSize(frameW, frameH)
	me.rui:ClearAllPoints()
	me.rui:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	me.rui:SetScript("OnMouseDown", function(self, button) self:StartMoving() end)
	me.rui:SetScript("OnMouseUp", function(self, button) self:StopMovingOrSizing() end)
	me.rui:SetScript("OnHide", function(self) self:StopMovingOrSizing() end)
	me:SetFrameStyle(me.rui)

	-- Info text
	me:MakeText(me.rui, "info", 12, L["Drag and Drop a List Item to Reorder the Spells."])
	me.rui.info:SetJustifyH("CENTER")
	me.rui.info:SetPoint("TOPLEFT", me.rui, "TOPLEFT", pad, -pad)
	me.rui.info:SetPoint("TOPRIGHT", me.rui, "TOPRIGHT", -pad, -pad)

	-- Container (frame area that holds the scrolling list)
	me.rui.container = CreateFrame("Frame", myName.."ReorderUIContainer", me.rui, "BackdropTemplate")
	me.rui.container:SetPoint("TOPLEFT", me.rui, "TOPLEFT", pad, -32)
	me.rui.container:SetPoint("BOTTOMRIGHT", me.rui, "BOTTOMRIGHT", -pad, pad + buttonRowH)
	me:SetFrameStyle(me.rui.container)

	-- ScrollFrame inside container
	local sbw = 16
	me.rui.scrollFrame = CreateFrame("ScrollFrame", myName.."ReorderUIScroll", me.rui.container, "UIPanelScrollFrameTemplate")
	me.rui.scrollFrame:SetPoint("TOPLEFT", me.rui.container, "TOPLEFT", pad, -pad)
	me.rui.scrollFrame:SetPoint("BOTTOMRIGHT", me.rui.container, "BOTTOMRIGHT", -(pad + sbw + 2), pad)

	-- Put scrollbar INSIDE the container.
	-- NOTE: UIPanelScrollFrameTemplate scrollbar includes up/down buttons, so
	-- we need extra top/bottom inset, otherwise it will look "too high/too low".
	local sb = _G[me.rui.scrollFrame:GetName().."ScrollBar"]
	if sb then
		sb:ClearAllPoints()
		local btnInset = 18 -- roughly the height of the scroll up/down buttons
		sb:SetPoint("TOPRIGHT", me.rui.container, "TOPRIGHT", -(pad + 4), -(pad + btnInset))
		sb:SetPoint("BOTTOMRIGHT", me.rui.container, "BOTTOMRIGHT", -(pad + 4), (pad + btnInset))
	end

	-- Scroll child (content)
	me.rui.scrollChild = CreateFrame("Frame", myName.."ReorderUIScrollChild", me.rui.scrollFrame)
	me.rui.scrollChild:SetPoint("TOPLEFT", me.rui.scrollFrame, "TOPLEFT", 0, 0)
	me.rui.scrollChild:SetPoint("TOPRIGHT", me.rui.scrollFrame, "TOPRIGHT", 0, 0)
	me.rui.scrollFrame:SetScrollChild(me.rui.scrollChild)

	-- Mouse wheel scrolling (clamped)
	me.rui.scrollFrame:EnableMouseWheel(true)
	me.rui.scrollFrame:SetScript("OnMouseWheel", function(self, delta)
		local step = 24
		local child = me.rui.scrollChild
		local maxScroll = 0
		if child and child.GetHeight then
			maxScroll = math.max(0, child:GetHeight() - self:GetHeight())
		end
		local cur = self:GetVerticalScroll() or 0
		local new = cur - (delta * step)
		if new < 0 then new = 0 end
		if new > maxScroll then new = maxScroll end
		self:SetVerticalScroll(new)
	end)
-- List rows (fixed-position buttons; "drag" without moving frames to avoid buggy StartMoving taint/overlaps)
me.rui.list = {}
for n = 1, me.MAX_BUTTONS do
	local li = CreateFrame("Button", myName.."ReorderUIList"..tostring(n), me.rui.scrollChild, "BackdropTemplate")
	me.rui.list[n] = li
	li:SetID(n)
	li:EnableMouse(true)
	li:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
	li:SetSize(300, 34)

	-- Style: rows should NOT have a default border (we draw our own drag/hover border)
	li:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground" })
	li:SetBackdropColor(0, 0, 0, 0.10)

	-- Inner highlight border (drawn inside the row so it won't be clipped)
	li.dragBorder = CreateFrame("Frame", nil, li, "BackdropTemplate")
	li.dragBorder:SetPoint("TOPLEFT", li, "TOPLEFT", 1, -1)
	li.dragBorder:SetPoint("BOTTOMRIGHT", li, "BOTTOMRIGHT", -1, 1)
	li.dragBorder:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	li.dragBorder:Hide()
	-- Make sure the base row has no visible border.
	if li.SetBackdropBorderColor then li:SetBackdropBorderColor(0, 0, 0, 0) end

	SetRowBorder(li, 1, 1, 1, 0)
	if (n % 2 == 0) then
		-- subtle alternate shading (keep alpha low so it matches most frame styles)
		if li.SetBackdropColor then li:SetBackdropColor(0, 0, 0, 0.15) end
	else
		if li.SetBackdropColor then li:SetBackdropColor(0, 0, 0, 0.05) end
	end

	-- Text
	me:MakeText(li, "text", itemSize)
	li.text:SetFont("Fonts\\ARIALN.TTF", 16, "")
		if (not draggingIndex) or (draggingIndex ~= n) then
			SetRowBorder(li, 1, 1, 1, 0)
		end
	li.text:SetJustifyV("MIDDLE")
	li.text:SetJustifyH("LEFT")
	li.text:SetPoint("LEFT", li, "LEFT", 10, 0)
	li.text:SetPoint("RIGHT", li, "RIGHT", -10, 0)

-- Hover highlight
li:SetScript("OnEnter", function(self)
	if draggingIndex and draggingIndex ~= self:GetID() then
		hoverIndex = self:GetID()
		-- Ziel beim Drag = GELB
		SetRowBorder(self, 1, 0.82, 0, 1)
	else
		-- normal hover = leicht gelblich
		SetRowBorder(self, 1, 0.82, 0, 0.45)
	end
end)
li:SetScript("OnLeave", function(self)
	-- Drag-row bleibt grün, alle anderen aus
	if draggingIndex and draggingIndex == self:GetID() then return end
	-- Wenn wir eine hover row verlassen während drag: border aus
	if hoverIndex and hoverIndex == self:GetID() then hoverIndex = nil end
	SetRowBorder(self, 1, 1, 1, 0)
end)

-- "Drag" start (no StartMoving!)
li:SetScript("OnMouseDown", function(self, button)
	if button ~= "LeftButton" then return end
	draggingIndex = self:GetID()
	hoverIndex = nil
	-- gezogene Row = GRÜN
	SetRowBorder(self, 0, 1, 0, 1)
end)

	-- Drop / finish
	li:SetScript("OnMouseUp", function(self, button)
		if button ~= "LeftButton" then return end
		if not draggingIndex then return end

		-- Find which row we are dropping onto (prefer hoverIndex, fallback to mouseover scan)
		local over = hoverIndex
		if not over then
			for i = 1, me.MAX_BUTTONS do
				if me.rui.list[i]:IsMouseOver() then
					over = i
					break
				end
			end
		end

		local from = draggingIndex
		draggingIndex = nil
		hoverIndex = nil

		-- Reset border colors
		for i = 1, me.MAX_BUTTONS do
			local row = me.rui.list[i]
			if row and row.SetBackdropBorderColor then
				SetRowBorder(row, 1, 1, 1, 0)
			end
		end

		if over and over ~= from then
			me:Do_ReorderList(from, over)
		end
	end)
end

	
	-- Buttons
	me:MakeButton(me.rui, "okay", L["Okay"])
	me.rui.okay:SetScript("OnClick", function()
		me:Apply_Reorder() -- No idea why, but the 1st time of the 1st time, this fails
		me:Apply_Reorder() -- So we call it twice
		me.db.profile.learnOrder = false
		me.rui:Hide()
	end)

	me:MakeButton(me.rui, "apply", L["Apply"])
	me.rui.apply:SetScript("OnClick", function()
		me:Apply_Reorder()
		me:Apply_Reorder()
		me.db.profile.learnOrder = false
	end)

	me:MakeButton(me.rui, "cancel", L["Cancel"])
	me.rui.cancel:SetScript("OnClick", function() me.rui:Hide() end)

	me.rui.okay:SetPoint("BOTTOMLEFT", me.rui, "BOTTOMLEFT", pad, pad)
	me.rui.apply:SetPoint("BOTTOMLEFT", me.rui.okay, "BOTTOMRIGHT", pad, 0)
	me.rui.cancel:SetPoint("BOTTOMRIGHT", me.rui, "BOTTOMRIGHT", -pad, pad)

	-- Cache row height for layout
	itemHeight = me.rui.list[1]:GetHeight()

	-- Keep scroll child width in sync with the scroll frame
	me.rui.scrollFrame:SetScript("OnSizeChanged", function(self)
		if me.rui and me.rui.scrollChild then
			me.rui.scrollChild:SetWidth(self:GetWidth())
		end
	end)
end
function me:UpdateUI_Reorder()
	local pad = 6
	local n

	-- Layout list items inside scrollChild
	for n = 1, me.MAX_BUTTONS do
		local posY = -pad - ((n - 1) * (itemHeight + 1))
		local name = spells[order[n]].name

		local li = me.rui.list[n]
		li:ClearAllPoints()
		li:SetPoint("TOPLEFT", me.rui.scrollChild, "TOPLEFT", 0, posY)
		li:SetPoint("TOPRIGHT", me.rui.scrollChild, "TOPRIGHT", 0, posY)
		li.text:SetText(name)
		li.text:SetFont("Fonts\\ARIALN.TTF", 16, "")
		li:Show()
	end

	-- Update scroll child size so the scroll frame knows how tall the content is
	local totalH = (itemHeight + 1) * me.MAX_BUTTONS + pad * 2
	me.rui.scrollChild:SetHeight(totalH)

	-- Clamp scroll position so we never show empty/black space
	local sf = me.rui.scrollFrame
	local maxScroll = math.max(0, me.rui.scrollChild:GetHeight() - sf:GetHeight())
	local cur = sf:GetVerticalScroll() or 0
	if cur > maxScroll then
		sf:SetVerticalScroll(maxScroll)
	elseif cur < 0 then
		sf:SetVerticalScroll(0)
	end
end
function me:Do_ReorderList(fromIndex, toIndex)
	-- Move the spell order entry from fromIndex to toIndex
	if (not fromIndex) or (not toIndex) or (fromIndex == toIndex) then
		me:UpdateUI_Reorder()
		return
	end

	local item = order[fromIndex]
	if (toIndex > fromIndex) then
		for n = fromIndex, toIndex - 1 do
			order[n] = order[n + 1]
		end
	else
		for n = fromIndex, toIndex + 1, -1 do
			order[n] = order[n - 1]
		end
	end
	order[toIndex] = item

	me:UpdateUI_Reorder()
end
