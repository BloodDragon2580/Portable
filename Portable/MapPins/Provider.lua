local ADDON_NAME, PortablePins = ...

-- MapCanvas DataProvider using projected pins (TeleportAssist-style)

PortablePins.Provider = CreateFromMixins(MapCanvasDataProviderMixin)

-- ==================== MULTI-LEVEL PIN PROJECTION ====================
-- Project coordinates between parent/child maps using C_Map.GetMapRectOnMap

---@type table<number, table<number, boolean>>
local ancestorCache = {}

---@param mapId number
---@return table<number, boolean>
local function BuildAncestorSet(mapId)
    if ancestorCache[mapId] then
        return ancestorCache[mapId]
    end

    local ancestors = {}
    local current = mapId
    for _ = 1, 25 do
        local info = C_Map.GetMapInfo(current)
        if not info or not info.parentMapID or info.parentMapID == 0 then
            break
        end
        ancestors[info.parentMapID] = true
        current = info.parentMapID
    end

    ancestorCache[mapId] = ancestors
    return ancestors
end

---@type table<number, boolean>
local descendantCache = {}

---@param childMapId number
---@param parentMapId number
---@return boolean
local function IsDescendantOf(childMapId, parentMapId)
    if childMapId == parentMapId then
        return true
    end

    local cacheKey = childMapId * 100000 + parentMapId
    if descendantCache[cacheKey] ~= nil then
        return descendantCache[cacheKey]
    end

    local ancestors = BuildAncestorSet(childMapId)
    local result = ancestors[parentMapId] or false
    descendantCache[cacheKey] = result
    return result
end

local function NormalizeCoord(v)
    v = tonumber(v)
    if not v then return nil end
    -- Allow 0-100 percentage coordinates
    if v > 1.01 then
        return v / 100
    end
    return v
end

---@param entryMapId number
---@param entryX number
---@param entryY number
---@param targetMapId number
---@return number|nil
---@return number|nil
local function TransformCoordinates(entryMapId, entryX, entryY, targetMapId)
    if not entryMapId or not targetMapId then
        return nil, nil
    end

    entryX = NormalizeCoord(entryX)
    entryY = NormalizeCoord(entryY)
    if not entryX or not entryY then
        return nil, nil
    end

    -- Same map
    if entryMapId == targetMapId then
        return entryX, entryY
    end

    -- Child -> Parent projection
    if IsDescendantOf(entryMapId, targetMapId) then
        local minX, maxX, minY, maxY = C_Map.GetMapRectOnMap(entryMapId, targetMapId)
        if minX and maxX and minY and maxY then
            local projX = minX + entryX * (maxX - minX)
            local projY = minY + entryY * (maxY - minY)
            return projX, projY
        end
        return nil, nil
    end

    -- Parent -> Child projection
    if IsDescendantOf(targetMapId, entryMapId) then
        local minX, maxX, minY, maxY = C_Map.GetMapRectOnMap(targetMapId, entryMapId)
        if minX and maxX and minY and maxY then
            local width = maxX - minX
            local height = maxY - minY
            if width > 0 and height > 0 then
                local projX = (entryX - minX) / width
                local projY = (entryY - minY) / height
                if projX >= -0.05 and projX <= 1.05 and projY >= -0.05 and projY <= 1.05 then
                    return projX, projY
                end
            end
        end
        return nil, nil
    end

    -- Fallback: worldpos conversion (sometimes works even without parent chain)
    local continentID, worldPos = C_Map.GetWorldPosFromMapPos(entryMapId, CreateVector2D(entryX, entryY))
    if continentID and worldPos then
        local _, mapPos = C_Map.GetMapPosFromWorldPos(continentID, worldPos, targetMapId)
        if mapPos then
            local x, y = mapPos:GetXY()
            if x and y and x >= 0 and x <= 1 and y >= 0 and y <= 1 then
                return x, y
            end
        end
    end

    return nil, nil
end

-- ==================== PROVIDER ====================

function PortablePins.Provider:RemoveAllData()
    if self:GetMap() and PortablePins.PIN_TEMPLATE then
        self:GetMap():RemoveAllPinsByTemplate(PortablePins.PIN_TEMPLATE)
    end
end

function PortablePins.Provider:RefreshAllData(fromOnShow)
    if not self:GetMap() then return end

    self:RemoveAllData()

    if not (PortablePinsDB and PortablePinsDB.showPortals) then
        return
    end

    -- Ensure our pool exists
    if PortablePins.EnsurePinPoolRegistered and not PortablePins:EnsurePinPoolRegistered() then
        return
    end

    local mapId = self:GetMap():GetMapID()
    if not mapId then
        return
    end

    local faction = UnitFactionGroup('player')

    for _, city in ipairs(PortablePins.CITIES or {}) do
        if not (city.faction and city.faction ~= faction) then
            local hasTeleport = city.teleport and IsSpellKnown(city.teleport)
            local hasPortal = city.portal and IsSpellKnown(city.portal)

            if hasTeleport or hasPortal then
                -- Prefer per-map overrides if present
                local x, y

                local db = PortablePinsDB and PortablePinsDB.coords and PortablePinsDB.coords[city.city]
                if db and db[mapId] and db[mapId].x then
                    x, y = db[mapId].x, db[mapId].y
                elseif PortablePins.MAP_OVERRIDES and PortablePins.MAP_OVERRIDES[city.city] and PortablePins.MAP_OVERRIDES[city.city][mapId] then
                    local data = PortablePins.MAP_OVERRIDES[city.city][mapId]
                    x, y = data.x, data.y
                else
                    x, y = TransformCoordinates(city.mapID, city.x, city.y, mapId)
                end

                x = NormalizeCoord(x)
                y = NormalizeCoord(y)

                if x and y then
                    local pinData = {
                        x = x,
                        y = y,
                        teleport = city.teleport,
                        portal = city.portal,
                        city = city.city,
                    }
                    self:GetMap():AcquirePin(PortablePins.PIN_TEMPLATE, pinData)
                end
            end
        end
    end
end

function PortablePins.Provider:OnShow()
    self:RefreshAllData(true)
end
