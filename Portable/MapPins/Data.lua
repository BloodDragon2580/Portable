local _, PortablePins = ...

PortablePins.CITIES = {
    { city = "Stormwind",        x = 0.53, y = 0.68, mapID = 84,   teleport = 3561,   portal = 10059 },
    { city = "Ironforge",        x = 0.47, y = 0.27, mapID = 87,   teleport = 3562,   portal = 11416 },
    { city = "Darnassus",        x = 0.19, y = 0.13, mapID = 89,   teleport = 3565,   portal = 11419 },
    { city = "Exodar",           x = 0.08, y = 0.18, mapID = 103,  teleport = 32271,  portal = 32266 },
    { city = "Theramore",        x = 0.62, y = 0.64, mapID = 70,   teleport = 49359,  portal = 49360 },
    { city = "Shattrath",        x = 0.46, y = 0.42, mapID = 111,  teleport = 33690,  portal = 33691 },
    { city = "Dalaran",          x = 0.49, y = 0.26, mapID = 125,  teleport = 53140,  portal = 53142 },

    { city = "Tol Barad",        x = 0.46, y = 0.49, mapID = 241,  teleport = 88342,  portal = 88345, faction = "Alliance" },
    { city = "Tol Barad (Horde)",x = 0.46, y = 0.49, mapID = 241,  teleport = 88344,  portal = 88345, faction = "Horde" },

    { city = "Pandaria",         x = 0.64, y = 0.26, mapID = 390,  teleport = 132621, portal = 132627, faction = "Alliance" },
    { city = "Pandaria (Horde)", x = 0.64, y = 0.26, mapID = 390,  teleport = 132627, portal = 132626, faction = "Horde" },

    { city = "Stormshield",      x = 0.55, y = 0.32, mapID = 588,  teleport = 176248, portal = 176246 },
    { city = "Broken Isles",     x = 0.61, y = 0.45, mapID = 627,  teleport = 224869, portal = 224871 },
    { city = "Boralus",          x = 0.61, y = 0.50, mapID = 895,  teleport = 281403, portal = 281400 },
    { city = "Oribos",           x = 0.49, y = 0.51, mapID = 1550, teleport = 344587, portal = 344597 },
    { city = "Valdrakken",       x = 0.57, y = 0.48, mapID = 2022, teleport = 395277, portal = 395289 },
    { city = "Dornogal",         x = 0.48, y = 0.46, mapID = 2248, teleport = 446540, portal = 446534 },
    { city = "Hall of Guardian", x = 0.61, y = 0.45, mapID = 627,  teleport = 193759 },
    { city = "Ancient Dalaran",  x = 0.45, y = 0.58, mapID = 267,  teleport = 120145, portal = 120146 },

    { city = "Undercity",        x = 0.84, y = 0.44, mapID = 947,  teleport = 3563,   portal = 11418 },
    { city = "Thunder Bluff",    x = 0.16, y = 0.56, mapID = 947,  teleport = 3566,   portal = 11420 },
    { city = "Orgrimmar",        x = 0.22, y = 0.51, mapID = 947,  teleport = 3567,   portal = 11417 },
    { city = "Stonard",          x = 0.90, y = 0.68, mapID = 947,  teleport = 49358,  portal = 49361 },
    { city = "Warspear",         x = 0.72, y = 0.39, mapID = 572,  teleport = 176242, portal = 176274 },
    { city = "Dazar'alor",       x = 0.58, y = 0.62, mapID = 875,  teleport = 281404, portal = 281402 },
    { city = "Silvermoon",       x = 0.92, y = 0.31, mapID = 947,  teleport = 32272,  portal = 32267 },
}

PortablePins.MAP_OVERRIDES = {
    ["Warspear"] = {
        [572] = { x = 0.72, y = 0.39 },
        [588] = { x = 0.45, y = 0.15 },
        [624] = { x = 0.59, y = 0.52 },
    },
    ["Dazar'alor"] = {
        [875]  = { x = 0.58, y = 0.62 },
        [862]  = { x = 0.58, y = 0.44 },
        [1163] = { x = 0.66, y = 0.74 },
        [1165] = { x = 0.51, y = 0.46 },
    },
    ["Silvermoon"] = {
        [13]  = { x = 0.56, y = 0.13 },
        [94]  = { x = 0.53, y = 0.31 },
        [110] = { x = 0.58, y = 0.19 },
    },
    ["Shattrath"] = {
        [101] = { x = 0.43, y = 0.66 },
        [111] = { x = 0.55, y = 0.40 },
    },
    ["Theramore"] = {
        [947] = { x = 0.22, y = 0.61 },
        [12]  = { x = 0.58, y = 0.65 },
        [70]  = { x = 0.65, y = 0.48 },
    },
    ["Valdrakken"] = {
        [947]  = { x = 0.78, y = 0.21 },
        [1978] = { x = 0.57, y = 0.48 },
        [2025] = { x = 0.41, y = 0.58 },
        [2112] = { x = 0.60, y = 0.37 },
    },
    ["Boralus"] = {
        [947]  = { x = 0.74, y = 0.49 },
        [876]  = { x = 0.61, y = 0.50 },
        [895]  = { x = 0.74, y = 0.24 },
        [1161] = { x = 0.71, y = 0.16 },
    },
    ["Tol Barad"] = {
        [947] = { x = 0.80, y = 0.52 },
        [13]  = { x = 0.35, y = 0.49 },
        [245] = { x = 0.74, y = 0.61 },
    },
    ["Tol Barad (Horde)"] = {
        [947] = { x = 0.80, y = 0.52 },
        [13]  = { x = 0.35, y = 0.49 },
        [245] = { x = 0.56, y = 0.80 },
    },
    ["Stormshield"] = {
        [572] = { x = 0.71, y = 0.48 },
        [588] = { x = 0.44, y = 0.87 },
        [622] = { x = 0.63, y = 0.35 },
    },
    ["Oribos"] = {
        [1550] = { x = 0.45, y = 0.51 },
        [1670] = { x = 0.20, y = 0.49 },
    },
    ["Dalaran"] = {
        [127] = { x = 0.28, y = 0.35 },
        [113] = { x = 0.49, y = 0.41 },
        [947] = { x = 0.49, y = 0.13 },
    },
    ["Pandaria"] = {
        [947] = { x = 0.49, y = 0.82 },
        [424] = { x = 0.55, y = 0.56 },
        [390] = { x = 0.86, y = 0.61 },
    },
    ["Pandaria (Horde)"] = {
        [947] = { x = 0.48, y = 0.81 },
        [424] = { x = 0.50, y = 0.49 },
        [390] = { x = 0.63, y = 0.22 },
    },
    ["Dornogal"] = {
        [947]  = { x = 0.29, y = 0.82 },
        [2274] = { x = 0.71, y = 0.18 },
        [2248] = { x = 0.48, y = 0.39 },
    },
    ["Exodar"] = {
        [12]  = { x = 0.30, y = 0.26 },
        [103] = { x = 0.48, y = 0.60 },
    },
    ["Stormwind"] = {
        [947] = { x = 0.84, y = 0.65 },
    },
    ["Ironforge"] = {
        [947] = { x = 0.87, y = 0.56 },
        [13]  = { x = 0.47, y = 0.58 },
        [87]  = { x = 0.26, y = 0.08 },
    },
    ["Darnassus"] = {
        [947] = { x = 0.16, y = 0.40 },
        [12]  = { x = 0.46, y = 0.20 },
        [62]  = { x = 0.46, y = 0.19 },
    },
    ["Orgrimmar"] = {
        [12] = { x = 0.59, y = 0.44 },
        [1]  = { x = 0.48, y = 0.10 },
        [85] = { x = 0.57, y = 0.90 },
    },
    ["Stonard"] = {
        [13] = { x = 0.53, y = 0.80 },
        [51] = { x = 0.50, y = 0.56 },
    },
    ["Broken Isles"] = {
        [947] = { x = 0.59, y = 0.46 },
    },
    ["Hall of Guardian"] = {
        [947] = { x = 0.61, y = 0.46 },
        [619] = { x = 0.50, y = 0.644 },
        [627] = { x = 0.65, y = 0.45 },
    },
    ["Undercity"] = {
        [13]   = { x = 0.44, y = 0.35 },
        [18]   = { x = 0.62, y = 0.73 },
        [2070] = { x = 0.69, y = 0.63 },
    },
    ["Thunder Bluff"] = {
        [12] = { x = 0.46, y = 0.54 },
        [7]  = { x = 0.35, y = 0.22 },
        [88] = { x = 0.22, y = 0.17 },
    },
}

-- Du hast es schon leer gesetzt -> bleibt absichtlich leer
PortablePins.LARGE_ICON_MAPS = {}
