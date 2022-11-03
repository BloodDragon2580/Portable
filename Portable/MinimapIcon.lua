local myName, me = ...
local L = me.L

local minimapIcon = LibStub:GetLibrary("LibDBIcon-1.0")	-- Minimap Icon Library


local function MinimapIcon_Click(self, button)
	if (button == "LeftButton") then
		if (me.ui:IsVisible()) then me.ui:Hide() else me.ui:Show() end
	elseif (button == "RightButton") then
		me:Helper_ShowConfig()
	end
end

local function MinimapIcon_Enter(self)
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:AddLine(L["Portable "], 1.0, 1.0, 1.0)
	GameTooltip:AddLine(L["Left-Click to Toggle Main Frame.\nRight-Click for Options.\n"], 0.0, 1.0, 0.0, 1)
	GameTooltip:AddLine(L["Use \n\n|cffFF3F40/console ActionButtonUseKeyDown 1|r\n\n in chat to make portable work."], 0.0, 1.0, 0.0, 1)
	GameTooltip:Show()
end

local function MinimapIcon_Leave(self)
	GameTooltip:Hide()
end



function me:CreateUI_MinimapIcon()
	local fakeLDB = {		-- Pretend to be a LibDataBroker
		type = "data source",
		text = "",
		icon = "Interface\\Icons\\spell_arcane_portaloribos",
		OnClick = MinimapIcon_Click,
		OnEnter = MinimapIcon_Enter,
		OnLeave = MinimapIcon_Leave,
	}
	minimapIcon:Register(myName, fakeLDB, me.db.profile.minimap)
end


function me:UpdateUI_MinimapIcon()
	if (me.db.profile.minimap.hide) then
		minimapIcon:Hide(myName)
	else
		minimapIcon:Show(myName)
	end
end
