local ADDON_NAME, PortablePins = ...

local L = PortablePins.L or {}
setmetatable(L, { __index = function(_, k) return k end })

-- =========================
-- DEFAULTS
-- =========================
local DEFAULT_PIN_SIZE = 28

PortablePinsDB = PortablePinsDB or {
    coords      = {},
    showPortals = true,
    pinSize     = DEFAULT_PIN_SIZE,
}

if PortablePinsDB.showPortals == nil then
    PortablePinsDB.showPortals = true
end

if PortablePinsDB.pinSize == nil then
    PortablePinsDB.pinSize = DEFAULT_PIN_SIZE
end

PortablePins.name = ADDON_NAME

local function IsEnabled()
    return PortablePinsDB.showPortals
end

local function ToggleEnabled()
    PortablePinsDB.showPortals = not PortablePinsDB.showPortals
    if PortablePins.Provider then
        PortablePins.Provider:RefreshAllData()
    end
end

local function InitHook()
    if Menu and Menu.ModifyMenu then
        Menu.ModifyMenu("MENU_WORLD_MAP_TRACKING", function(owner, rootDescription, contextData)
            rootDescription:CreateDivider()
            rootDescription:CreateTitle(L["PortablePins"])
            rootDescription:CreateCheckbox(L["Mage Portals"], IsEnabled, ToggleEnabled)
        end)
        return
    end

    if WorldMapTrackingOptionsButtonMixin then
        hooksecurefunc(WorldMapTrackingOptionsButtonMixin, "GenerateMenu", function(self, dropdown, rootDescription)
            rootDescription:CreateCheckbox(L["Mage Portals"], IsEnabled, ToggleEnabled)
        end)
    end
end

local function TryRegister()
    if not WorldMapFrame or not PortablePins.Provider then
        C_Timer.After(1, TryRegister)
        return
    end

    InitHook()

    local panel = CreateFrame("Frame")
    panel.name = L["PortablePins"]

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(L["PortablePins"])

    local slider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
    slider:SetMinMaxValues(20, 140)
    slider:SetValueStep(2)
    slider:SetObeyStepOnDrag(true)
    slider:SetWidth(260)

    slider.Low:SetText("20")
    slider.High:SetText("140")

    local function UpdateSliderLabel(value)
        value = math.floor((tonumber(value) or DEFAULT_PIN_SIZE) + 0.5)
        slider.Text:SetText(string.format("%s: %d", L["Map Pin Size"], value))
    end

    slider:SetValue(PortablePinsDB.pinSize)
    UpdateSliderLabel(PortablePinsDB.pinSize)

    slider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        PortablePinsDB.pinSize = value

        UpdateSliderLabel(value)

        if PortablePins.UpdateAllPinSizes then
            PortablePins:UpdateAllPinSizes()
        end
    end)

    if Settings and Settings.RegisterCanvasLayoutCategory then
        local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
        Settings.RegisterAddOnCategory(category)
    else
        InterfaceOptions_AddCategory(panel)
    end

    WorldMapFrame:AddDataProvider(PortablePins.Provider)
end

C_Timer.After(2, TryRegister)
