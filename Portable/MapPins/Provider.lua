local ADDON_NAME, PortablePins = ...

PortablePins.Provider = CreateFromMixins(MapCanvasDataProviderMixin)

function PortablePins.Provider:OnShow()
    self:RefreshAllData()
end

function PortablePins.Provider:OnHide()
    if PortablePins.pinPool then
        PortablePins.pinPool:ReleaseAll()
    end
end

function PortablePins.Provider:RemoveAllData()
    if PortablePins.pinPool then
        PortablePins.pinPool:ReleaseAll()
    end
end

function PortablePins.Provider:GetPinPosition(city, targetMapID)
    local db = PortablePinsDB.coords[city.city]
    if db and db[targetMapID] and db[targetMapID].x then
        return db[targetMapID].x, db[targetMapID].y
    end

    if PortablePins.MAP_OVERRIDES and PortablePins.MAP_OVERRIDES[city.city] and PortablePins.MAP_OVERRIDES[city.city][targetMapID] then
        local data = PortablePins.MAP_OVERRIDES[city.city][targetMapID]
        return data.x, data.y
    end

    if city.mapID and city.x and city.y then
        if city.mapID == targetMapID then
            return city.x, city.y
        end

        local continentID, worldPos = C_Map.GetWorldPosFromMapPos(city.mapID, CreateVector2D(city.x, city.y))
        if continentID and worldPos then
            local _, mapPos = C_Map.GetMapPosFromWorldPos(continentID, worldPos, targetMapID)
            if mapPos then
                local tempX, tempY = mapPos:GetXY()
                if tempX >= 0 and tempX <= 1 and tempY >= 0 and tempY <= 1 then
                    return tempX, tempY
                end
            end
        end
    end

    return nil, nil
end

function PortablePins.Provider:RefreshAllData(fromOnShow)
    if not PortablePins.pinPool then return end

    -- WICHTIG: Alle Pins komplett freigeben
    PortablePins.pinPool:ReleaseAll()

    if not PortablePinsDB.showPortals then return end

    local mapID = WorldMapFrame:GetMapID()
    if not mapID then return end

    if PortablePins.MapIDLabel then
        PortablePins.MapIDLabel:SetText("ID: " .. mapID)
    end

    local faction = UnitFactionGroup("player")

    for _, city in ipairs(PortablePins.CITIES or {}) do
        if not (city.faction and city.faction ~= faction) then
            local hasTeleport = city.teleport and IsSpellKnown(city.teleport)
            local hasPortal = city.portal and IsSpellKnown(city.portal)

            if hasTeleport or hasPortal then
                local x, y = self:GetPinPosition(city, mapID)
                if x and y then
                    PortablePins:CreatePortalPin({
                        x        = x,
                        y        = y,
                        teleport = city.teleport,
                        portal   = city.portal,
                        city     = city.city,
                    })
                end
            end
        end
    end
end

WorldMapFrame:AddDataProvider(PortablePins.Provider)
