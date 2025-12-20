--[[ ==========================================================================
	© Feyawen Ariana 2007-2015
		If you use my code, please give me credit.
		
		
	enUS - English (United States)
	
	All English language clients return "enUS" now, so we don't need to check
	for "enGB" (English - Great Brittan / United Kingdom) anymore.
	
	The AddOn is written in this language so we don't need this line;
		if (GetLocale() ~= "enUS") then return end
========================================================================== ]]--
local myName, me = ...
local L = me.L

--[[
	Even though the AddOn is written in this language, some text overrides
	can be used as a sort of shorthand which can be useful for long text or
	commonly used text.
		Example;
			L["longText"] = "This is a long string of characters."
		
		In the AddOn, now we can simply use L["longText"] and it will be
		replaced with; This is a long string of characters.
]]--

L[myName] = "|cffd6266cPortable|cff808080: |r"	-- Provide a "friendly name" of our AddOn to prefix any output messages.
L["Show Minimap Icon (Mage only)"] = "Show Minimap Icon (Mage only)"
L["Shows the Portable minimap icon. Only visible for Mages."] = "Shows the Portable minimap icon. Only visible for Mages."

L["PortablePins"] = "|cffd6266cPortablePins|r"
L["Mage Portals"] = "Mage Portals"
L["Map Pin Size"] = "Map Pin Size"
L["Left-Click: %s"] = "Left-Click: %s"
L["Right-Click: %s"] = "Right-Click: %s"
L["Adjust the size of the portal icons on the World Map."] = "Adjust the size of the portal icons on the World Map."
