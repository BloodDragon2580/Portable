local myName, me = ...
local L = me.L


local itemSize = 18
local textFont = "Arial Narrow"

local itemHeight = 0	-- this is a placeholder, the code will change this value
local listFaction = ""	-- are we editing the alliance or the horde?
local order = {}		-- holds the list order we are editing
local spells = nil		-- Pointer to the aSpell or hSpell table depending if order alliance or horde spell order

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

	-- Put scrollbar INSIDE the container and keep it off the buttons
	local sb = _G[me.rui.scrollFrame:GetName().."ScrollBar"]
	if sb then
		sb:ClearAllPoints()
		sb:SetPoint("TOPRIGHT", me.rui.container, "TOPRIGHT", -pad, -pad)
		sb:SetPoint("BOTTOMRIGHT", me.rui.container, "BOTTOMRIGHT", -pad, pad)
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

	-- List rows
	local n
	me.rui.list = {}
	for n = 1, me.MAX_BUTTONS do
		me.rui.list[n] = CreateFrame("Frame", myName.."ReorderUIList"..tostring(n), me.rui.scrollChild, "BackdropTemplate")
		local li = me.rui.list[n]
		li:SetID(n)
		li:EnableMouse(true)
		li:SetMovable(true)
		li:SetUserPlaced(false)
		li:SetSize(300, 40)

		-- List Item Text
		me:MakeText(li, "text", itemSize)
		li.text:SetFont("Fonts\ARIALN.TTF", 16, "")
		li.text:SetJustifyV("MIDDLE")
		li.text:SetJustifyH("CENTER")
		li.text:SetPoint("TOPLEFT", li, "TOPLEFT", 2, -2)
		li.text:SetPoint("BOTTOMRIGHT", li, "BOTTOMRIGHT", -2, 2)
		li:SetHeight(li.text:GetStringHeight() + 16)

		-- Handlers
		li:SetScript("OnMouseDown", function(self, button)
			self:StartMoving()
			self:SetUserPlaced(false)
			self.level = self:GetFrameLevel()
			self:SetFrameLevel(100)
		end)
		li:SetScript("OnMouseUp", function(self, button)
			self:StopMovingOrSizing()
			self:SetFrameLevel(self.level or 2)
			me:Do_ReorderList(self:GetID())
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
		li.text:SetFont("Fonts\ARIALN.TTF", 16, "")
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
function me:Do_ReorderList(node)
	local n, over = 0, nil
	for n = 1, me.MAX_BUTTONS do
		if (me.rui.list[n]:IsMouseOver()) then
			if (n ~= node) then
				over = n
				break
			end
		end
	end
	if (over) then
		local item = order[node]
		if (over > node) then
			for n = node, over-1, 1 do
				order[n] = order[n+1]
			end
		else
			for n = node, over, -1 do
				order[n] = order[n-1]
			end
		end
		order[over] = item
	end
	me:UpdateUI_Reorder()
end
