local AceGUI = LibStub("AceGUI-3.0")

Portable_Settings = {
	MinimapPos = 45
}

function Portable_MinimapButton_Reposition()
	Portable_MinimapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(Portable_Settings.MinimapPos)),(80*sin(Portable_Settings.MinimapPos))-52)
end

function Portable_MinimapButton_DraggingFrame_OnUpdate()

	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

	xpos = xmin-xpos/UIParent:GetScale()+70
	ypos = ypos/UIParent:GetScale()-ymin-70

	Portable_Settings.MinimapPos = math.deg(math.atan2(ypos,xpos))
	Portable_MinimapButton_Reposition()
end

function Portable_MinimapButton_OnClick()
	DEFAULT_CHAT_FRAME.editBox:SetText("/portable") 
	ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
end
