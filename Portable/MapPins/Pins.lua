local ADDON_NAME, PortablePins = ...

local L = PortablePins.L or {}
setmetatable(L, { __index = function(t, k) return k end })

local function GetSpellIcon(spellID)
    if not spellID then return 134400 end
    local info = C_Spell.GetSpellInfo(spellID)
    if info and info.iconID then
        return info.iconID
    end
    return 134400
end

local function GetSpellName(spellID)
    if not spellID then return nil end
    local info = C_Spell.GetSpellInfo(spellID)
    if info and info.name then
        return info.name
    end
    return nil
end

local function ShowPinTooltip(self)
    if not self.data then return end

    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()

    local cityKey = self.data.city
    local localizedCity = L[cityKey] or cityKey
    local cleanName = localizedCity:gsub(" %(.+%)", "")
    GameTooltip:AddLine(cleanName, 1, 1, 1)

    local tName = GetSpellName(self.data.teleport)
    local pName = GetSpellName(self.data.portal)

    local hasTeleport = self.data.teleport and IsSpellKnown(self.data.teleport)
    local hasPortal = self.data.portal and IsSpellKnown(self.data.portal)

    if hasTeleport and tName then
        GameTooltip:AddLine(string.format(L["Left-Click: %s"], tName), 0.6, 0.8, 1)
    end

    if hasPortal and pName then
        GameTooltip:AddLine(string.format(L["Right-Click: %s"], pName), 0.6, 0.8, 1)
    end

    GameTooltip:Show()
end

local SecureClicker = CreateFrame("Button", "MapPortalsSecureClicker", UIParent, "SecureActionButtonTemplate")
SecureClicker:SetFrameStrata("TOOLTIP")
SecureClicker:SetFrameLevel(10000)
SecureClicker:RegisterForClicks("AnyUp", "AnyDown")
SecureClicker:Hide()

SecureClicker:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
SecureClicker:GetHighlightTexture():SetBlendMode("ADD")
SecureClicker:GetHighlightTexture():SetAllPoints()

SecureClicker:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
SecureClicker:GetPushedTexture():SetAllPoints()

local clickerMask = SecureClicker:CreateMaskTexture()
clickerMask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask")
clickerMask:SetAllPoints(SecureClicker)
SecureClicker:GetHighlightTexture():AddMaskTexture(clickerMask)
SecureClicker:GetPushedTexture():AddMaskTexture(clickerMask)

PortablePins.PinMixin = CreateFromMixins(MapCanvasPinMixin)

function PortablePins.PinMixin:OnLoad()
    self:SetFrameStrata("TOOLTIP")
    self:SetFrameLevel(9999)
    self:SetFixedFrameStrata(true)
    self:SetFixedFrameLevel(true)

    self.icon = self:CreateTexture(nil, "ARTWORK")
    self.icon:SetPoint("TOPLEFT", 0, 0)
    self.icon:SetPoint("BOTTOMRIGHT", 0, 0)
    self.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

    self.mask = self:CreateMaskTexture()
    self.mask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask")
    self.mask:SetAllPoints(self.icon)
    self.icon:AddMaskTexture(self.mask)

    self:EnableMouse(true)
    self:SetMouseClickEnabled(true)
end

function PortablePins.PinMixin:OnAcquired(data)
    self.data = data
    self.icon:SetTexture(GetSpellIcon(data.teleport))

    -- Größe bei jedem Acquire aktualisieren
    self:UpdateSize()

    self:SetFrameLevel(9900)
end

function PortablePins.PinMixin:UpdateSize()
    local size = (PortablePinsDB and PortablePinsDB.pinSize) or 40

    -- WorldMap Zoom/Canvas-Scale (wird auf Kontinent-Maps stark abweichen)
    local canvasScale = 1
    if WorldMapFrame and WorldMapFrame.ScrollContainer and WorldMapFrame.ScrollContainer.GetCanvasScale then
        canvasScale = WorldMapFrame.ScrollContainer:GetCanvasScale() or 1
    end
    if canvasScale <= 0 then canvasScale = 1 end

    -- Größe neutralisieren: je stärker die Map zoomt, desto kleiner setzen wir den Pin
    local finalSize = size / canvasScale
    self:SetSize(finalSize, finalSize)
end

function PortablePins.PinMixin:OnReleased()
    self:ClearAllPoints()
    self.data = nil
end

function PortablePins.PinMixin:ApplyFrameLevel()
    self:SetFrameLevel(9900)
end

SecureClicker:SetScript("OnUpdate", function(self)
    local pin = PortablePins.hoverPin
    if not pin or not pin:IsVisible() then
        self:Hide()
        return
    end

    local scale = pin:GetEffectiveScale() / UIParent:GetEffectiveScale()
    self:SetPoint("CENTER", pin, "CENTER", 0, 0)
    self:SetSize(pin:GetWidth() * scale, pin:GetHeight() * scale)
end)

function PortablePins.PinMixin:OnMouseEnter()
    if InCombatLockdown() then
        ShowPinTooltip(self)
        return
    end

    PortablePins.hoverPin = self

    SecureClicker:ClearAllPoints()
    SecureClicker:SetParent(UIParent)
    SecureClicker:SetFrameStrata("TOOLTIP")

    local scale = self:GetEffectiveScale() / UIParent:GetEffectiveScale()
    SecureClicker:SetPoint("CENTER", self, "CENTER", 0, 0)
    SecureClicker:SetSize(self:GetWidth() * scale, self:GetHeight() * scale)

    local teleportName = GetSpellName(self.data.teleport)
    local portalName = GetSpellName(self.data.portal)

    -- IMPORTANT:
    -- Do NOT use macrotext with "/run WorldMapFrame:Hide()" here.
    -- That pattern can leave the UI in a stuck modal state after an interrupted cast,
    -- which breaks ESC until /reload.
    -- Instead we use pure secure "spell" actions and simply hide our clicker/tooltip.

    if teleportName and IsSpellKnown(self.data.teleport) then
        SecureClicker:SetAttribute("type1", "spell")
        SecureClicker:SetAttribute("spell1", teleportName)
        SecureClicker:SetAttribute("unit", "player")
    else
        SecureClicker:SetAttribute("type1", nil)
        SecureClicker:SetAttribute("spell1", nil)
    end

    if portalName and IsSpellKnown(self.data.portal) then
        SecureClicker:SetAttribute("type2", "spell")
        SecureClicker:SetAttribute("spell2", portalName)
        SecureClicker:SetAttribute("unit", "player")
    else
        SecureClicker:SetAttribute("type2", nil)
        SecureClicker:SetAttribute("spell2", nil)
    end

    SecureClicker.data = self.data
    SecureClicker.tooltipFunc = ShowPinTooltip

    SecureClicker:Show()
    ShowPinTooltip(SecureClicker)
end

function PortablePins.PinMixin:OnMouseLeave()
    if InCombatLockdown() then
        GameTooltip_Hide()
    end
end

SecureClicker:SetScript("OnLeave", function(self)
    self:Hide()
    PortablePins.hoverPin = nil
    GameTooltip_Hide()
end)

-- Hide the helper clicker after a click so it can't keep interacting with input.
SecureClicker:SetScript("PostClick", function(self)
    GameTooltip_Hide()
    self:Hide()
    PortablePins.hoverPin = nil
end)

-- Defensive cleanup: interrupted casts (e.g. by movement) can leave cursor/targeting in a bad state.
local cleanupFrame = CreateFrame("Frame")
cleanupFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
cleanupFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
cleanupFrame:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET")
cleanupFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
cleanupFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
cleanupFrame:SetScript("OnEvent", function(_, _, unit)
    if unit ~= "player" then return end
    -- SpellStopTargeting() is a protected function and can raise
    -- ADDON_ACTION_FORBIDDEN (taint) when the player cancels targeting via ESC.
    -- ClearCursor() is safe and also clears spell-targeting state.
    if (SpellIsTargeting and SpellIsTargeting()) or (CursorHasSpell and CursorHasSpell()) then
        if ClearCursor then ClearCursor() end
    end
    if GetCurrentKeyBoardFocus and GetCurrentKeyBoardFocus() then
        local f = GetCurrentKeyBoardFocus()
        if f and f.ClearFocus then f:ClearFocus() end
    end
end)

-- Also cleanup when the map closes.
if WorldMapFrame then
    WorldMapFrame:HookScript("OnHide", function()
        -- Same rationale as above: avoid protected SpellStopTargeting().
        if (SpellIsTargeting and SpellIsTargeting()) or (CursorHasSpell and CursorHasSpell()) then
            if ClearCursor then ClearCursor() end
        end
    end)
end

SecureClicker:SetScript("OnEnter", function(self)
    if self.tooltipFunc then
        self.tooltipFunc(self)
    end
end)

-- Funktion um alle aktiven Pins zu aktualisieren
function PortablePins:UpdateAllPinSizes()
    if not self.pinPool then return end

    for pin in self.pinPool:EnumerateActive() do
        if pin.UpdateSize then
            pin:UpdateSize()
        end
    end
end

if not PortablePins.pinPool then
    PortablePins.pinPool = CreateFramePool("BUTTON", WorldMapFrame.ScrollContainer.Child, nil, function(pool, pin)
        pin:Hide()
        pin:SetParent(nil)

        if pin.OnReleased then
            pin:OnReleased()
        end

        pin.data = nil
    end)
end

function PortablePins:CreatePortalPin(data)
    local pin = PortablePins.pinPool:Acquire()

    if not pin.isInitialized then
        Mixin(pin, PortablePins.PinMixin)
        pin:OnLoad()
        pin.isInitialized = true
    end

    pin:OnAcquired(data)

    pin:SetScript("OnEnter", pin.OnMouseEnter)
    pin:SetScript("OnLeave", pin.OnMouseLeave)

    local map = WorldMapFrame.ScrollContainer.Child
    pin:SetParent(map)
    pin:ClearAllPoints()
    pin:SetPoint("CENTER", map, "TOPLEFT", data.x * map:GetWidth(), -data.y * map:GetHeight())
    pin:Show()
end
