local ADDON_NAME, PortablePins = ...

-- MapCanvas pin implementation inspired by TeleportAssist's WorldMapIntegration
-- Focus: Mage teleports/portals only

local L = PortablePins.L or {}
setmetatable(L, { __index = function(_, k) return k end })

-- Unique template key for the WorldMapFrame pin pool
local PIN_TEMPLATE = 'PORTABLE_MAGE_TELEPORT_PIN'
PortablePins.PIN_TEMPLATE = PIN_TEMPLATE

local function GetSpellName(spellID)
    if not spellID then return nil end
    local info = C_Spell.GetSpellInfo(spellID)
    return info and info.name or nil
end

local function GetSpellIcon(spellID)
    if not spellID then return 134400 end
    local info = C_Spell.GetSpellInfo(spellID)
    return (info and info.iconID) or 134400
end

local function NormalizeCoord(v)
    v = tonumber(v)
    if not v then return nil end
    -- Accept both normalized (0-1) and percent (0-100)
    if v > 1.01 then
        return v / 100
    end
    return v
end

-- Pin mixin
PortablePins.PinMixin = CreateFromMixins(MapCanvasPinMixin)

function PortablePins.PinMixin:OnLoad()
    self:UseFrameLevelType('PIN_FRAME_LEVEL_AREA_POI')
    self:SetScalingLimits(1, 1.0, 1.2)
end

---@param pinData table
function PortablePins.PinMixin:OnAcquired(pinData)
    self.data = pinData

    local x = NormalizeCoord(pinData.x)
    local y = NormalizeCoord(pinData.y)
    if x and y then
        self:SetPosition(x, y)
    end

    local teleportID = pinData.teleport
    local portalID = pinData.portal

    local hasTeleport = teleportID and IsSpellKnown(teleportID)
    local hasPortal = portalID and IsSpellKnown(portalID)

    -- Create action button once
    if not self.ActionButton then
        self.ActionButton = CreateFrame('Button', nil, self, 'SecureActionButtonTemplate')
        self.ActionButton:SetAllPoints(self)
        self.ActionButton:RegisterForClicks('AnyUp', 'AnyDown')

        -- Icon
        self.ActionButton.Texture = self.ActionButton:CreateTexture(nil, 'BACKGROUND')
        self.ActionButton.Texture:SetAllPoints(self.ActionButton)

        -- Border
        self.ActionButton.Border = self.ActionButton:CreateTexture(nil, 'OVERLAY')
        self.ActionButton.Border:SetPoint('CENTER')
        self.ActionButton.Border:SetAtlas('communities-ring-blue')

        -- Highlight
        local highlight = self.ActionButton:CreateTexture(nil, 'HIGHLIGHT')
        highlight:SetPoint('CENTER')
        highlight:SetAtlas('communities-ring-blue')
        highlight:SetAlpha(0.5)
        highlight:SetBlendMode('ADD')
        self.ActionButton.Highlight = highlight

        -- Tooltip
        self.ActionButton:SetScript('OnEnter', function(btn)
            if not self.data then return end

            GameTooltip:SetOwner(btn, 'ANCHOR_RIGHT')
            GameTooltip:ClearLines()

            local cityKey = self.data.city
            local localizedCity = L[cityKey] or cityKey
            local cleanName = localizedCity:gsub(' %(.+%)', '')
            GameTooltip:AddLine(cleanName, 1, 1, 1)

            local tName = GetSpellName(self.data.teleport)
            local pName = GetSpellName(self.data.portal)

            local tKnown = self.data.teleport and IsSpellKnown(self.data.teleport)
            local pKnown = self.data.portal and IsSpellKnown(self.data.portal)

            GameTooltip:AddLine(' ')
            if tName then
                if tKnown then
                    GameTooltip:AddLine(string.format(L['Left-Click: %s'], tName), 0.6, 0.8, 1)
                else
                    GameTooltip:AddLine(string.format(L['Left-Click: %s'], tName), 0.5, 0.5, 0.5)
                end
            end
            if pName then
                if pKnown then
                    GameTooltip:AddLine(string.format(L['Right-Click: %s'], pName), 0.6, 0.8, 1)
                else
                    GameTooltip:AddLine(string.format(L['Right-Click: %s'], pName), 0.5, 0.5, 0.5)
                end
            end

            GameTooltip:Show()
        end)

        self.ActionButton:SetScript('OnLeave', function()
            GameTooltip:Hide()
        end)
    end

    -- Size from DB
    local pinSize = (PortablePinsDB and PortablePinsDB.pinSize) or 28
    self:SetSize(pinSize, pinSize)
    self.ActionButton:SetAllPoints(self)
    self.ActionButton.Border:SetSize(pinSize + 4, pinSize + 4)
    self.ActionButton.Highlight:SetSize(pinSize + 6, pinSize + 6)

    -- Icon choice: prefer teleport icon, fallback to portal icon
    local icon = hasTeleport and GetSpellIcon(teleportID) or GetSpellIcon(portalID)
    self.ActionButton.Texture:SetTexture(icon or 134400)

    -- Secure actions
    if not InCombatLockdown() then
        if hasTeleport and teleportID then
            self.ActionButton:SetAttribute('type', 'spell')
            self.ActionButton:SetAttribute('spell', teleportID)
        elseif hasPortal and portalID then
            self.ActionButton:SetAttribute('type', 'spell')
            self.ActionButton:SetAttribute('spell', portalID)
        else
            self.ActionButton:SetAttribute('type', nil)
            self.ActionButton:SetAttribute('spell', nil)
        end

        if hasPortal and portalID then
            self.ActionButton:SetAttribute('type2', 'spell')
            self.ActionButton:SetAttribute('spell2', portalID)
        else
            self.ActionButton:SetAttribute('type2', nil)
            self.ActionButton:SetAttribute('spell2', nil)
        end
    end
end

function PortablePins.PinMixin:OnReleased()
    if self.ActionButton then
        self.ActionButton:Hide()
        if not InCombatLockdown() then
            self.ActionButton:SetAttribute('type', nil)
            self.ActionButton:SetAttribute('spell', nil)
            self.ActionButton:SetAttribute('type2', nil)
            self.ActionButton:SetAttribute('spell2', nil)
        end
        self.ActionButton:Show()
    end

    self.data = nil
end

-- Pin pool + DataProvider registration helper
function PortablePins:EnsurePinPoolRegistered()
    if not WorldMapFrame or not WorldMapFrame.GetCanvas then
        return false
    end

    WorldMapFrame.pinPools = WorldMapFrame.pinPools or {}

    if WorldMapFrame.pinPools[PIN_TEMPLATE] then
        return true
    end

    local pinPool
    if CreateUnsecuredRegionPoolInstance then
        pinPool = CreateUnsecuredRegionPoolInstance(PIN_TEMPLATE)
    else
        pinPool = CreateFramePool('FRAME')
    end

    pinPool.parent = WorldMapFrame:GetCanvas()

    local function createPin()
        local frame = CreateFrame('Frame', nil, WorldMapFrame:GetCanvas())
        frame:SetSize(1, 1)
        Mixin(frame, PortablePins.PinMixin)
        frame:OnLoad()
        return frame
    end

    local function resetPin(pool, pin)
        pin:Hide()
        pin:ClearAllPoints()
        if pin.OnReleased then
            pin:OnReleased()
        end
        pin.data = nil
    end

    -- Compatibility with different pool field names
    pinPool.createFunc = createPin
    pinPool.creationFunc = createPin
    pinPool.resetFunc = resetPin
    pinPool.resetterFunc = resetPin

    WorldMapFrame.pinPools[PIN_TEMPLATE] = pinPool

    return true
end
