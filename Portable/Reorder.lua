local myName, me = ...
local L = me.L


local itemSize = 18


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
	
	me.rui = CreateFrame("Frame", myName.."ReorderUI", UIParent)
	me.rui:Hide()
	me.rui:EnableMouse(true)
	me.rui:SetMovable(true)
	me.rui:SetClampedToScreen(true)
	me.rui:SetFrameStrata("FULLSCREEN")	-- Keep us above the main Portable frame (we're not really full screen)
	me.rui:SetSize(300 + pad * 4, 300)
	me.rui:ClearAllPoints()
	me.rui:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	me.rui:SetScript("OnMouseDown", function(self, button) self:StartMoving() end)
	me.rui:SetScript("OnMouseUp", function(self, button) self:StopMovingOrSizing() end)
	me.rui:SetScript("OnHide", function(self) self:StopMovingOrSizing() end)
	me:SetFrameStyle(me.rui)
	
	me.rui.container = CreateFrame("Frame", myName.."ReorderUIContainer", me.rui)
	me.rui.container:SetSize(300 + pad * 2, 300)
	me.rui.container:SetPoint("TOP", me.rui, "TOP", 0, -32)
	me:SetFrameStyle(me.rui.container)
	
	
	local n
	me.rui.list = {}
	for n = 1, me.MAX_BUTTONS do
		-- List Item Frame
		me.rui.list[n] = CreateFrame("Frame", myName.."ReorderUIList"..tostring(n), me.rui)
		local li = me.rui.list[n]
		li:SetID(n)
		li:EnableMouse(true)
		li:SetMovable(true)
		li:SetUserPlaced(false)
		li:SetSize(300, 40)
		me:SetFrameStyle(li, nil, nil, nil, nil, 0,0.1,0.2,0.8, 0.2,0.2,0.2,1)
		
		-- List Item Text
		me:MakeText(li, "text", itemSize, "GgPpYy")
		li.text:SetJustifyV("MIDDLE")
		li.text:SetJustifyH("CENTER")
		li.text:SetPoint("TOPLEFT", li, "TOPLEFT", 2, -2)
		li.text:SetPoint("BOTTOMRIGHT", li, "BOTTOMRIGHT", -2, 2)
		li:SetHeight(li.text:GetStringHeight() + 8)
		li.text:SetFont("Fonts\\FRIZQT__.TTF", 18, "")
		--me:MakeText(li, "icontid", itemSize, "")
		--li.icontid:SetPoint("LEFT", li, "LEFT", 2, 0)
		--me:MakeText(li, "iconpid", itemSize, "")
		--li.iconpid:SetPoint("RIGHT", li, "RIGHT", -2, 0)
		
		-- Handlers
		li:SetScript("OnEnter", function(self)
			self:SetBackdropBorderColor(1,1,1,1)
		end)
		li:SetScript("OnLeave", function(self)
			self:SetBackdropBorderColor(0.2,0.2,0.2,1)
		end)
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
	
	
	me:MakeButton(me.rui, "okay", L["Okay"])
	me.rui.okay:SetScript("OnClick", function()
			me:Apply_Reorder()	-- No idea why, but the 1st time of the 1st time, this fails
			me:Apply_Reorder()	-- So we call it twice
			me.db.profile.learnOrder = false
			me.rui:Hide()
		end)
	me:MakeButton(me.rui, "apply", L["Apply"])
	me.rui.apply:SetScript("OnClick", function()
			me:Apply_Reorder()	-- No idea why, but the 1st time of the 1st time, this fails
			me:Apply_Reorder()
			me.db.profile.learnOrder = false
		end)
	me:MakeButton(me.rui, "cancel", L["Cancel"])
	me.rui.cancel:SetScript("OnClick", function()
			me.rui:Hide()
		end)
	me.rui.okay:SetPoint("BOTTOMLEFT", me.rui, "BOTTOMLEFT", pad, pad)
	me.rui.apply:SetPoint("BOTTOMLEFT", me.rui.okay, "BOTTOMRIGHT", pad, 0)
	me.rui.cancel:SetPoint("BOTTOMRIGHT", me.rui, "BOTTOMRIGHT", -pad, pad)
	
	
	me:MakeText(me.rui, "info", 12, L["Drag and Drop a List Item to Reorder the Spells."])
	me.rui.info:SetJustifyH("CENTER")
	me.rui.info:SetPoint("TOPLEFT", me.rui, "TOPLEFT", pad, -pad)
	me.rui.info:SetPoint("TOPRIGHT", me.rui, "TOPRIGHT", -pad, -pad)
	
	itemHeight = me.rui.list[1]:GetHeight()
	me.rui.container:SetHeight((itemHeight + 1) * me.MAX_BUTTONS + pad + pad)
	me.rui:SetHeight((itemHeight + 1) * me.MAX_BUTTONS + pad * 2 + 64)
end


function me:UpdateUI_Reorder()
	local pad = 6
	local n
	for n = 1, me.MAX_BUTTONS do
		local pos = -pad - ((n - 1) * (itemHeight + 1))
		local name = spells[order[n]].name
		--local _, _, iconTeleport = GetSpellInfo(spells[order[n]].tid)
		--local _, _, iconPortal = GetSpellInfo(spells[order[n]].pid)
		me.rui.list[n]:ClearAllPoints()
		me.rui.list[n]:SetPoint("TOP", me.rui.container, "TOP", 0, pos)
		me.rui.list[n].text:SetText(name)
		me.rui.list[n].text:SetFont("Fonts\\FRIZQT__.TTF", 18, "")

		--me.rui.list[n].icontid:SetText(format("|T%s:%d|t", iconTeleport, itemSize))
		--me.rui.list[n].iconpid:SetText(format("|T%s:%d|t", iconPortal, itemSize))
		me.rui.list[n]:Show()
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
