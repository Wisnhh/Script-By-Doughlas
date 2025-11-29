UID = "+988050+989831+229295+113008+" 

function TextOverlay(text)
    SendVariantList({
        [0] = "OnTextOverlay",
        [1] = text
    })
end

ConsumeLucky = ConsumeLucky == nil and false or ConsumeLucky
Android = Android == nil and false or Android
Windows = Windows == nil and false or Windows
SeedID = SeedID or 15955
VerticalPlant = VerticalPlant == nil and true or VerticalPlant
BackgroundID = BackgroundID or 298
StartCount = StartCount or 0
TotalPTHT = TotalPTHT or 3000

PlantY = PlantY or 0
DelayFindPath = DelayFindPath or 50
DelayStepPath = DelayStepPath or 100
DelayPlant = DelayPlant or 80
DelayHarvest = DelayHarvest or 200
UseMRAY = UseMRAY == nil and true or UseMRAY
UseUWS = UseUWS == nil and false or UseUWS
DelayUWS = DelayUWS or 10500
TakeUWS = TakeUWS == nil and false or TakeUWS
UseVending = UseVending == nil and false or UseVending
VendingX = VendingX or 0
VendingY = VendingY or 0
DelayTake = DelayTake or 1000
AutoRespawn = AutoRespawn == nil and false or AutoRespawn
PointX = PointX or 0
PointY = PointY or 0
MissTree = MissTree or 1000
MirrorPlant = MirrorPlant == nil and false or MirrorPlant
Radio = Radio == nil and false or Radio
Lonely = Lonely == nil and false or Lonely
AutoBuyCheats = AutoBuyCheats == nil and true or AutoBuyCheats
AntiLag = AntiLag == nil and false or AntiLag
WebhookPTHT = WebhookPTHT == nil and false or WebhookPTHT
WebhookUrl = WebhookUrl or (WebhookPTHT and "https://discord.com/api/webhooks/1432993029018357810/lq8l4jyVM7J5mYCUsz3EmfpJQL5hiGgnB5ZHlxf1EhcEg-cxf-hoSEnWiZQMezug9lN0" or "")
DiscordID = DiscordID or 0
File = File or "MAIN-PTHT-SCRIPTS-V2.bin"

function SendWebhook(url, data)
    MakeRequest(url, "POST", {
        ["Content-Type"] = "application/json"
    }, data)
end

function FTime(sec)
    if sec == nil then return "0 second" end
    days = math.floor(sec / 86400)
    hours = math.floor(sec % 86400 / 3600)
    minutes = math.floor(sec % 3600 / 60)
    seconds = math.floor(sec % 60)
    if days > 0 then
        return string.format("%s day %s hour %s minute %s second", days, hours, minutes, seconds)
    elseif hours > 0 then
        return string.format("%s hour %s minute %s second", hours, minutes, seconds)
    elseif minutes > 0 then
        return string.format("%s minute %s second", minutes, seconds)
    elseif seconds >= 0 then
        return string.format("%s second", seconds)
    end
end

function inv(id)
    for _, item in pairs(GetInventory()) do
        if item.id == id then
            return item.amount
        end
    end
    return 0
end

function onvariant(var)
    if "OnConsoleMessage" == var[0] and var[1]:find("boringness.") then
        SendPacket(2, [[
action|dialog_return
dialog_name|buycheat
dialog_name|cheats
buttonClicked|1
]])
    elseif "OnConsoleMessage" == var[0] and var[1]:find("Cheater") then
        SendPacket(2, [[
action|dialog_return
dialog_name|cheats
check_gems|1
check_lonely|]] .. CheckLonely .. [[
]])
    elseif "OnTalkBubble" == var[0] and var[2]:find("The MAGPLANT 5000 is empty") then
        Missed = Missed + 6
    elseif "OnConsoleMessage" == var[0] and var[1]:find("for cheating of type:") then
        if var[1]:find(Nick) then
            PauseAfterKick = true
        end
    elseif not InWorld() and WebhookPTHT then
        ReconnectWebhook = true
    end
end

function DoConsume()
    if not InWorld() then return end
    local pl = GetLocal()
    if not pl or not pl.pos then return end
    local cx = pl.pos.x // 32
    local cy = pl.pos.y // 32

    local Lucky = {528, 1056}
    if type(Lucky) ~= "table" then
        return
    end
    for _, item in pairs(Lucky) do
        SendPacketRaw(false, {
            type = 3,
            value = item,
            px = cx,
            py = cy,
            x = cx * 32,
            y = cy * 32
        })
        Sleep(500)
    end
    LastConsume = os and os.time() or LastConsume
    LogToConsole(string.format("`b[DOUGHLAS] `1Auto Consume! On Position X : `2%d, `1Y : `2%d", cx, cy))
end

function CheckConsume()
    if not os then return end
    local now = os.time()
    if now - (LastConsume or 0) >= 1800 then
        local cx = GetLocal().pos.x // 32
        local cy = GetLocal().pos.y // 32
        FindPath(cx, cy, 520)
        Sleep(500)
        DoConsume()
    end
end

UWS = pcall(inv) and inv(12600) or 0
ConsumableID = {12600, 12600}
ghost = true
exitSent = false

function AutoTakeConsumables()
    for _, cid in ipairs(ConsumableID) do
        if inv(cid) < 1 then
            repeat
                local took = false
                if UseVending then
                    TelePath(VendingX, VendingY, 300)
                    SendPacketRaw(false, {type = 3, value = 32, px = VendingX, py = VendingY, x = VendingX * 32, y = VendingY * 32})
                    Sleep(200)
                    SendPacket(2, "action|dialog_return\ndialog_name|vend_edit\nx|" .. VendingX .. "|\ny|" .. VendingY .. "|\nbuttonClicked|pullstock\n\n")
                    Sleep(500)
                    SendPacket(2, "action|dialog_return\ndialog_name|vend_buyconfirm|\nx|" .. VendingX .. "|\ny|" .. VendingY .. "|\nbuyamount|250|\n")
                    if inv(cid) > 0 then
                        LogToConsole("`b[DOUGHLAS] `2Successfully Take UWS!... ID="..cid)
                        took = true
                    end
                    Sleep(DelayTake)
                    break
                else
                    for _, obj in pairs(GetObjectList()) do
                        if obj.id == cid then
                            Sleep(1000)
                            SendPacket(2, [[
action|respawn
]])
                            Sleep(DelayEntering)
                            TelePath(math.floor(obj.pos.x/32), math.floor(obj.pos.y/32), 300)
                            Sleep(DelayTake)
                            if ghost then SendPacket(2, "action|input\n|text|/ghost") ghost = false end
                            Sleep(DelayTake)
                            if inv(cid) > 0 then
                                LogToConsole("`b[DOUGHLAS] `2Successfully Take UWS!... ID="..cid)
                                took = true
                            end
                            if not ghost then SendPacket(2, "action|input\n|text|/ghost") ghost = true end
                            Sleep(DelayTake)
                            break
                        end
                    end
                end
                if not took then Sleep(1000) end
            until inv(cid) >= 1
        end
    end
end

function GetFarm()
    local tiles = {}
    for x = MirrorPlant and PlantX or 0, MirrorPlant and 0 or PlantX, MirrorPlant and -10 or 10 do
        for y = MirrorPlant and StartY or PlantY, MirrorPlant and PlantY or StartY, MirrorPlant and 2 or -2 do
            local tile1 = GetTile(x, y)
            local tile2 = GetTile(x, y + 1)
            local tilefg = tile1 and tile1.fg or -1
            local tileb = tile2 and tile2.fg or -1
            if 0 ~= tileb and (tilefg == SeedID or 0 == tilefg) then
                table.insert(tiles, {x = x, y = y})
            end
        end
    end
    return tiles
end

function GetTree(int)
    if int then
        TotalTree = 0
        for _, tile in pairs(FarmTiles) do
            local tile1 = GetTile(tile.x, tile.y)
            local tilefg = tile1 and tile1.fg or -1
            local tiler = tilefg == SeedID and tile1.extra.progress or -1
            if tilefg == SeedID and 1 == tiler then
                TotalTree = TotalTree + 1
            end
        end
        return TotalTree
    else
        TotalLand = 0
        for _, tile in pairs(FarmTiles) do
            local tile1 = GetTile(tile.x, tile.y)
            local tilefg = tile1 and tile1.fg or -1
            if 0 == tilefg then
                TotalLand = TotalLand + 1
            end
        end
        return TotalLand
    end
end

function GetHarvest()
    local tiles = {}
    for x = MirrorPlant and PlantX or 0, MirrorPlant and 0 or PlantX, MirrorPlant and -PlantFar or PlantFar do
        for i = 1, 2 do
            for y = MirrorPlant and StartY or PlantY, MirrorPlant and PlantY or StartY, MirrorPlant and 2 or -2 do
                local tile1 = GetTile(x, y)
                local tile2 = GetTile(x, y + 1)
                local tilefg = tile1 and tile1.fg or -1
                local tileb = tile2 and tile2.fg or -1
                if 0 ~= tileb and (tilefg == SeedID or 0 == tilefg) then
                    table.insert(tiles, {x = x, y = y})
                end
            end
        end
    end
    return tiles
end

function GetVertical()
    local tiles = {}
    for x = MirrorPlant and PlantX or 0, MirrorPlant and 0 or PlantX, MirrorPlant and -PlantFar or PlantFar do
        for i = 1, 2 do
            for y = MirrorPlant and StartY or PlantY, MirrorPlant and PlantY or StartY, MirrorPlant and 2 or -2 do
                local tile1 = GetTile(x, y)
                local tile2 = GetTile(x, y + 1)
                local tilefg = tile1 and tile1.fg or -1
                local tileb = tile2 and tile2.fg or -1
                if 0 ~= tileb and (tilefg == SeedID or 0 == tilefg) then
                    table.insert(tiles, {x = x, y = y})
                end
            end
        end
    end
    return tiles
end

function GetHorizontal()
    local tiles = {}
    for y = MirrorPlant and StartY or PlantY, MirrorPlant and PlantY or StartY, MirrorPlant and 2 or -2 do
        for i = 1, 2 do
            for x = MirrorPlant and PlantX or 0, MirrorPlant and 0 or PlantX, MirrorPlant and -PlantFar or PlantFar do
                local tile1 = GetTile(x, y)
                local tile2 = GetTile(x, y + 1)
                local tilefg = tile1 and tile1.fg or -1
                local tileb = tile2 and tile2.fg or -1
                if 0 ~= tileb and (tilefg == SeedID or 0 == tilefg) then
                    table.insert(tiles, {x = x, y = y})
                end
            end
        end
    end
    return tiles
end

function GetMag(a, b)
    tile = {}
    for y = 0, b do
        for x = 0, a do
            if GetTile(x, y).fg == 5638 and GetTile(x, y).bg == BackgroundID then
                table.insert(tile, {x = x, y = y})
            end
        end
    end
    return tile
end

PlantFar = UseMRAY and 10 or 1
StartY = 0 == PlantY % 2 and 0 or 1

function ActiveLag()
    if AntiLag then
        ChangeValue("[C] No render name", true)
        ChangeValue("[C] No render particle", true)
        ChangeValue("[C] No render shadow", true)
        ChangeValue("[C] No render world", true)
        ChangeValue("[C] No render object", true)
    else
        ChangeValue("[C] No render name", false)
        ChangeValue("[C] No render particle", false)
        ChangeValue("[C] No render shadow", false)
        ChangeValue("[C] No render world", false)
        ChangeValue("[C] No render object", false)
    end
end

if GetTile(209, 0) then
    Mag = GetMag(209, 209)
elseif GetTile(199, 0) then
    Mag = GetMag(199, 199)
elseif GetTile(149, 0) then
    Mag = GetMag(149, 149)
elseif GetTile(99, 0) then
    Mag = GetMag(99, 59)
elseif GetTile(29, 0) then
    Mag = GetMag(29, 29)
end

function Scanning()
    if Plant then
        Plant = false
        CheckLand = GetTree(false)
        MissTreeE = MissTree / 10
        if CheckLand <= MissTreeE then
            SprayUWS = SprayUWS + 1
            Missed = 0
            if UseUWS then
                SendPacket(2, [[
action|dialog_return
dialog_name|ultraworldspray]])
                if AutoRespawn then
                    SendPacket(2, [[
action|respawn
]])
                end
                Sleep(DelayUWS)
                Harvest = true
            else
                if AutoRespawn then
                    SendPacket(2, [[
action|respawn
]])
                    Sleep(3000)
                else
                    TelePath(199, PlantY, 500)
                end
                Sleep(DelayUWS)
                Plant = true
            end
        else
            Plant = true
        end
        Sleep(MirrorPlant and 1500 or 500)
    elseif Harvest then
        Harvest = false
        CheckTree = GetTree(true)
        if 0 == CheckTree then
            Plant = true
            CheckTreeHarvest = false
            if WebhookPTHT then
                SendInfoPTHT()
            end
        else
            Harvest = true
            CheckTreeHarvest = true
        end
        Sleep(MirrorPlant and 1500 or 500)
    end
end

function GetRemote()
    if not Mag or not Mag[Now] then return end
    local m = Mag[Now]
    LogToConsole("`b[DOUGHLAS] `2Take Remote...")
    TelePath(m.x, m.y, 500)
    Sleep(200)
    SendPacketRaw(false, {
        type = 3,
        value = 32,
        px = m.x,
        py = m.y,
        x = m.x * 32,
        y = m.y * 32
    })
    Sleep(300)
    SendPacket(2, [[
action|dialog_return
dialog_name|magplant_edit
x|]] .. m.x .. [[|
y|]] .. m.y .. [[|
buttonClicked|getRemote]])
    Sleep(1000)
end

rangeTrigger = 500
function MoveAboveAndWait(tx, ty, rangeTrigger, timeout_ms)
    rangeTrigger = 500
    timeout_ms = timeout_ms or 5000
    local sleep_interval = 200
    if type(TelePath) == "function" then
        pcall(function() TelePath(tx, ty - 1, rangeTrigger) end)
    end
    local waited = 0
    while waited < timeout_ms and InWorld() do
        Sleep(sleep_interval)
        waited = waited + sleep_interval
        local loc = GetLocal()
        if loc and loc.pos then
            local lx = loc.pos.x // 32
            local ly = loc.pos.y // 32
            if lx == tx and (ly == ty - 1 or ly == ty) then
                return true
            end
        end
    end
    return false
end

function GoPath(t, s, v, x, y)
    if not InWorld() then return end
    SendPacketRaw(false, {type = t, state = s, value = v, px = x, py = y, x = x * 32, y = y * 32})
    if t == nil then
        SendVariantList({[0] = "OnSetPos",[1] = {x = x*32, y = y*32}}, GetLocal().netid)
    end
end

function gOgOPath(x, y)
    GoPath(nil, nil, nil, x, y)
    GoPath(3, 1, 0, x, y)
end

local _origFindPath = (type(FindPath) == "function") and FindPath or nil
local TELEPATH_STEP_SLEEP    = DelayStepPath
local TELEPATH_TRY_PER_STEP  = 5
local TELEPATH_MAX_STEPS     = 1000
local TELEPATH_FALLBACK      = true
local TELEPATH_NO_PROGRESS_LIMIT = 3
local TELEPATH_STEP_SIZE = 2

if type(_origFindPath) ~= "function" then
    _origFindPath = function(x, y, r) end
end
local function sign(v) return (v>0 and 1) or (v<0 and -1) or 0 end

function TelePath(tx, ty, rangeTrigger)
    rangeTrigger = rangeTrigger or DelayFindPath
    if not InWorld() then
        LogToConsole("[TelePath] not in world, fallback to original")
        return
    end
    local player = GetLocal()
    if player and player.pos then
        local px = math.floor(player.pos.x / 32)
        local py = math.floor(player.pos.y / 32)
        local distance = math.abs(px - tx) + math.abs(py - ty)
        if distance <= 10 then
            ShortDelay = true
            DelayShortPath = 0
        else
            ShortDelay = false
            DelayFindPath = DelayFindPath
        end
    end
    if ShortDelay and not CheckTreeHarvest then return GoPath(nil, nil, nil, tx, ty) end
    local pl = GetLocal()
    if not pl or not pl.pos then
        LogToConsole("[TelePath] no local pos, fallback to original")
        return _origFindPath(tx, ty, 520)
    end
    local cx = pl.pos.x // 32
    local cy = pl.pos.y // 32
    if cx == tx and cy == ty then
        DelayFindPath = 0
        return
    end
    local steps = 0
    local no_progress_count = 0
    local function loop_allowed(s)
        if TELEPATH_MAX_STEPS and TELEPATH_MAX_STEPS > 0 then
            return s < TELEPATH_MAX_STEPS
        else
            return true
        end
    end
    while (cx ~= tx or cy ~= ty) and InWorld() and loop_allowed(steps) do
        steps = steps + 1
        local dx = tx - cx
        local dy = ty - cy
        local nx, ny = cx, cy
        if math.abs(dx) >= math.abs(dy) then
            local step = math.min(TELEPATH_STEP_SIZE, math.abs(dx))
            nx = cx + sign(dx) * step
        else
            local step = math.min(TELEPATH_STEP_SIZE, math.abs(dy))
            ny = cy + sign(dy) * step
        end

        gOgOPath(nx, ny)
        Sleep(ShortDelay and DelayShortPath or DelayFindPath)
        local try = 0
        local reached = false
        while try < TELEPATH_TRY_PER_STEP and InWorld() do
            Sleep(TELEPATH_STEP_SLEEP)
            local pl2 = GetLocal()
            if pl2 and pl2.pos and pl2.pos.x // 32 == nx and pl2.pos.y // 32 == ny then
                reached = true
                break
            end
            try = try + 1
        end
        if reached then
            cx, cy = nx, ny
            no_progress_count = 0
        else
            local alt_done = false
            if nx ~= cx and cy ~= ty then
                local alt_step = math.min(TELEPATH_STEP_SIZE, math.abs(ty - cy))
                local alt_ny = cy + sign(ty - cy) * alt_step
                gOgOPath(cx, alt_ny)
                local try2 = 0
                while try2 < TELEPATH_TRY_PER_STEP and InWorld() do
                    Sleep(TELEPATH_STEP_SLEEP)
                    local pl3 = GetLocal()
                    if pl3 and pl3.pos and pl3.pos.x // 32 == cx and pl3.pos.y // 32 == alt_ny then
                        cy = alt_ny
                        alt_done = true
                        break
                    end
                    try2 = try2 + 1
                end
            end
            if alt_done then
                no_progress_count = 0
            else
                no_progress_count = no_progress_count + 1
                LogToConsole(string.format("[TelePath] no progress step %d (to %d,%d) try=%d", no_progress_count, tx, ty, steps))
            end
        end
        if no_progress_count >= TELEPATH_NO_PROGRESS_LIMIT then
            if TELEPATH_FALLBACK then
                _origFindPath(tx, ty, 520)
            end
            return
        end
        Sleep(10)
    end
    if cx == tx and cy == ty then
        return
    else
        if TELEPATH_MAX_STEPS > 0 and steps >= TELEPATH_MAX_STEPS then
            LogToConsole(string.format("[TelePath] max steps %d reached -> fallback to original at %d,%d", TELEPATH_MAX_STEPS, tx, ty))
            if TELEPATH_FALLBACK then
                _origFindPath(tx, ty, 520)
            end
        else
            return
        end
    end
end

function Loop()
    if AutoRespawn and not Harvest then
        SendPacket(2, [[
action|respawn
]])
        Sleep(3000)
    end
    if TakeUWS then
        AutoTakeConsumables()
    end
    if ConsumeLucky and not Plant then
        CheckConsume()
    end
    if VerticalPlant then
        local tiles_list = (Plant and VerticalTiles) or HarvestTiles
        if not tiles_list or #tiles_list == 0 then
            Scanning()
            return
        end
        local cols = {}
        for _, t in ipairs(tiles_list) do
            cols[t.x] = cols[t.x] or {}
            table.insert(cols[t.x], { x = t.x, y = t.y })
        end
        local x_keys = {}
        for x, _ in pairs(cols) do table.insert(x_keys, x) end
        table.sort(x_keys)
        if MirrorPlant then
            table.sort(x_keys, function(a, b) return a > b end)
        end
        local sent_tiles = {}
        for col_idx, x in ipairs(x_keys) do
            if not InWorld() or RemoteEmpty then return end
            local col_tiles = cols[x]
            table.sort(col_tiles, function(a, b) return a.y < b.y end)
            local ordered = {}
            local seen_local = {}
            local direction_down = Harvest and false or (col_idx % 2 == 0)
            if direction_down then
                for i = 1, #col_tiles do
                    local ky = col_tiles[i].x .. "," .. col_tiles[i].y
                    if not seen_local[ky] then
                        seen_local[ky] = true
                        ordered[#ordered + 1] = col_tiles[i]
                    end
                end
            else
                for i = #col_tiles, 1, -1 do
                    local ky = col_tiles[i].x .. "," .. col_tiles[i].y
                    if not seen_local[ky] then
                        seen_local[ky] = true
                        ordered[#ordered + 1] = col_tiles[i]
                    end
                end
            end
            if last_col ~= x then
                local startY = direction_down and ordered[1].y or ordered[#ordered].y
                LogToConsole(string.format("`b[DOUGHLAS] `1Planting / Harvesting At Position X:`2 %d`1 Y:`2 %d `6(%s)", x, startY, direction_down and "top to bottom" or "bottom to top"))
                last_col = x
            end
            if Plant then
                CheckLand = GetTree(false)
                MissTreeE = MissTree / 10
                if CheckLand <= MissTreeE then
                    Scanning()
                    return
                end
            end
            for _, tile in ipairs(ordered) do
                if not InWorld() or RemoteEmpty then return end
                if PauseAfterKick then
                    PauseAfterKick = false
                    return
                end
                local key = tile.x .. "," .. tile.y
                if not sent_tiles[key] then
                    local tileinfo = GetTile(tile.x, tile.y)
                    local tilefg1 = tileinfo and tileinfo.fg or -1
                    local progress = (tilefg1 == SeedID and tileinfo.extra and tileinfo.extra.progress) or -1
                    if (Plant and tilefg1 == 0) or (Harvest and progress == 1) then
                        TelePath(tile.x, tile.y, DelayFindPath)
                        Sleep(Plant and DelayPlant or DelayHarvest)
                        tileinfo = GetTile(tile.x, tile.y)
                        tilefg1 = tileinfo and tileinfo.fg or -1
                        progress = (tilefg1 == SeedID and tileinfo.extra and tileinfo.extra.progress) or -1
                        if Plant and tilefg1 ~= 0 then
                            sent_tiles[key] = true
                        elseif Harvest and progress ~= 1 then
                            sent_tiles[key] = true
                        else
                            if MirrorPlant then
                                SendPacketRaw(false, {
                                    state = 48,
                                    x = tile.x * 32,
                                    y = tile.y * 32
                                })
                            end
                            SendPacketRaw(false, {
                                type = 3,
                                value = Plant and 5640 or 18,
                                state = MirrorPlant and 48 or 32,
                                x = tile.x * 32,
                                y = tile.y * 32,
                                px = tile.x,
                                py = tile.y
                            })
                            sent_tiles[key] = true
                            Sleep(20)
                            if Plant and ((MirrorPlant and tile.x < PlantX) or (not MirrorPlant and tile.x > 0)) then
                                local tile2 = GetTile(MirrorPlant and tile.x + 1 or tile.x - 1, tile.y)
                                local tilefg2 = tile2 and tile2.fg or -1
                                if tilefg2 ~= SeedID then
                                    Missed = Missed + 0.5
                                end
                            end
                        end
                    else
                        sent_tiles[key] = true
                    end
                end
                if Missed >= 200 then
                    Now = Now < #Mag and Now + 1 or 1
                    Missed = 0
                    RemoteEmpty = true
                    return
                end
            end
        end
    end
    if not InWorld() then
        return
    else
        Scanning()
        if Plant and PTHT ~= SprayUWS then
            if UseUWS then
                PTHT = PTHT + 1
                SendPacket(2, [[
action|input
text|`b[DOUGHLAS] `1]] .. PTHT .. [[ `0PTHT])
            end
        end
    end
end

function SendInfoPTHT()
    math.randomseed(os.time())
    Gems = Windows and GetPlayerInfo().gems or GetPlayerItems().gems
    Songpyeon = pcall(inv) and inv(1056) or Songpyeon
    Clover = pcall(inv) and inv(528) or Clover
    UWS = (type(inv) == "function") and inv(12600) or UWS
    local duration = 0
    PTHT_durations = PTHT_durations or {}
    duration = os.time() - PTHT_startTime
    table.insert(PTHT_durations, duration)
    local total = 0
    for _, d in ipairs(PTHT_durations) do
        total = total + d
    end
    PTHT_startTime = os.time()
    SendWebhook(WebhookUrl, [[
{
  "embeds": [
    {
      "title": "『<:eaa:1440243162080612374> 』 DOUGHLAS PTHT LOG",
      "fields": [
        {
          "name": "『<:globe:1443460850248716308>』 **Name World**",
          "value": "]] .. WorldName .. [[",
          "inline": false
        },
        {
          "name": "『<:ava:1443432607726571660>』 **Account**",
          "value": "]] .. Nick .. [[",
          "inline": false
        },
        {
          "name": "『<:magplant:1443461129258008730>』 **Magplant**",
          "value": "]] .. Now .. [[ / ]] .. #Mag .. [[",
          "inline": false
        },
        {
          "name": "『<:uws:1444128570975715370>』 **UWS**",
          "value": "]] .. UWS .. [[ !",
          "inline": false
        },
        {
          "name": "『<:gems:1443458682896777286>』 **Gems**",
          "value": "]] .. FNum(Gems) .. [[",
          "inline": false
        },
        {
          "name": "『:evergreen_tree:』 **Total Ptht**",
          "value": "]] .. SprayUWS .. [[ / ]] .. TotalPTHT .. [[",
          "inline": false
        },
        {
          "name": "『<:globe:1419659253270052936>』 **Time**",
          "value": "]] .. FTime(duration) .. [[",
          "inline": false
        },
        {
          "name": "『<:time:1444131195964362843>』 **Total Time**",
          "value": "]] .. FTime(os.time() - StartTime) .. [[",
          "inline": false
        }
      ],
      "footer": {
        "text": "PTHT DOUGHLAS LOGS • Today At ]] .. os.date("%H:%M") .. [["
      },
      "thumbnail": {
        "url": "https://cdn.discordapp.com/attachments/961043626782228500/1443455382071804035/Doughlas_Jasa.jpg"
      }
    }
  ]
}
]])
end

function FNum(num)
    num = tonumber(num)
    if num >= 1.0E9 then
        return string.format("%.2fB", num / 1.0E9)
    elseif num >= 1000000.0 then
        return string.format("%.1fM", num / 1000000.0)
    elseif num >= 1000.0 then
        return string.format("%.0fK", num / 1000.0)
    else
        return tostring(num)
    end
end

function InWorld()
    return GetWorld() ~= nil
end

function Entering()
    if not InWorld() and WebhookPTHT and ReconnectWebhook then
        SendWebhook(WebhookUrl, [[
        {
          "embeds": [
            {
              "title": "『<:eaa:1440243162080612374> 』 **Reconect**",
              "fields": [
                {
                  "name": "『<:ava:1443432607726571660>』 **Account**",
                  "value": "<@]] .. DiscordID .. [[> • ]] .. Nick .. [[",
                  "inline": false
                },
                {
                  "name": "『<:globe:1443460850248716308>』 **Name World**",
                  "value": "]] .. WorldName .. [[",
                  "inline": false
                }
              ],
              "footer": {
                "text": "PTHT DOUGHLAS LOGS • Today At ]] .. os.date("%H:%M") .. [["
              },
              "thumbnail": {
                "url": "https://cdn.discordapp.com/attachments/961043626782228500/1443455382071804035/Doughlas_Jasa.jpg"
              }
            }
          ]
        }
        ]])
        ReconnectWebhook = false
    end
    if not InWorld() then
        Sukses = false
        Sleep(2000)
        SendPacket(3, [[
action|join_request
name|]] .. WorldName .. [[|
invitedWorld|0]])
        Sleep(DelayEntering)
        if InWorld() then
            Sleep(1000)
            if Radio then
                SendPacket(2, [[
action|input
|text|/radio]])
                Sleep(DelayEntering)
            end
            RemoteEmpty = true
            Sukses = true
        end
    elseif Sukses and InWorld() then
        if RemoteEmpty then
            GetRemote()
            RemoteEmpty = false
            PendingLoop = true
        end
        if AutoRespawn and PendingLoop then
            ChangeValue("[C] Modfly", false)
            ChangeValue("[C] Modfly v2", false)
            if MoveAboveAndWait(PointX, PointY, rangeTrigger, 5000) then
                LogToConsole("`b[DOUGHLAS] `1Arrived at CheckPoint: enabling Loop PTHT.")
                PendingLoop = false
                Sleep(1000)
                ChangeValue("[C] Modfly", true)
            else
                if InWorld() then
                    LogToConsole("`b[DOUGHLAS] `1Finding CheckPoint XY.. (failed to arrive)")
                    ChangeValue("[C] Modfly", false)
                    ChangeValue("[C] Modfly v2", false)
                    Sleep(2000)
                end
            end
        end
        Loop()
    end
end

function dialog(teks)
    Var0 = "OnDialogRequest"
    Var1 = [[
add_label_with_icon|big|`bPTHT DOUGHLAS||16224|
add_spacer|small|
add_textbox|GrowID : ]] .. GetLocal().name:match("%S+") .. [[|
add_textbox|World : `2]] .. WorldName .. [[|
add_textbox|Position PTHT : `60 `0, `6]] .. PlantY .. [[|
add_textbox|`8]] .. teks .. [[|
add_spacer|small|
add_smalltext|DOUGHLAS JASA!|
add_url_button||Discord|NOFLAGS|https://discord.gg/AF3REYDqps|`9DOUGHLAS JASA|0|0|
add_quick_exit|]]
    SendVariantList({
        [0] = Var0,
        [1] = Var1
    })
end

function StartPTHT()
    -- UID CHECK LOGIC (FIXED)
    local localUser = GetLocal()
    local my_uid = localUser and localUser.userid or 0
    -- Strict check: must match exactly "+UID+" inside the UID string
    if string.find(UID, "+" .. tostring(my_uid) .. "+", 1, true) then
        if os or not LogFilePTHT then
            if os or not WebhookPTHT then
                TotalPTHT = UseUWS and TotalPTHT or TotalPTHT
                WorldName = GetWorld().name or "Unknown"
                dialog("`8Please Wait A Moment...")
                Sleep(200)
                LastConsume = os and os.time() or 0
                Sukses = true
                DelayEntering = 8000
                CheckLonely = Lonely and 1 or 0
                Nick = GetLocal().name:gsub("`(%S)", ""):match("%S+")
                StartTime = os and os.time() or 0
                SprayUWS = StartCount
                RemoteEmpty = true
                PTHT = StartCount
                Harvest = true
                Plant = false
                RemoveHooks()
                AddHook("OnDraw", "PTHT_GUI", PTHT_GUI)
                Missed = 0
                Now = 1
                if WebhookPTHT then
                    PTHT_durations = {}
                    PTHT_startTime = os and os.time() or 0
                end
                if ConsumeLucky then
                    local cx = GetLocal().pos.x // 32
                    local cy = GetLocal().pos.y // 32
                    FindPath(cx, cy, 520)
                    Sleep(500)
                    DoConsume()
                end
                if AutoBuyCheats then
                    SendPacket(2, [[
action|dialog_return
dialog_name|buycheat
dialog_name|cheats
buttonClicked|1
]])
                    Sleep(2000)
                end
                if AutoBuyCheats then
                    AddHook("onvariant", "onvariant", onvariant)
                    Sleep(2000)
                end
                SendPacket(2, [[
action|dialog_return
dialog_name|cheats
check_gems|1
check_lonely|]] .. CheckLonely .. [[
]])
                Sleep(2000)
                if Radio then
                    SendPacket(2, [[
action|input
|text|/radio]])
                end
                Sleep(DelayEntering)
                Scanning()
                Sleep(200)
                if type(TotalPTHT) == "number" then
                    repeat
                        Entering()
                        if PTHT == TotalPTHT then
                            LogToConsole("`b[DOUGHLAS] `1 TOTAL PTHT " .. PTHT .. "X IS DONE!")
                            Sleep(820)
                            if WebhookPTHT then
                                SendWebhook(WebhookUrl, [[
                                {
                                  "embeds": [
                                    {
                                      "title": "PTHT Update",
                                      "description": "<@]] .. DiscordID .. [[> ALL PTHT TOTAL ]] .. PTHT .. [[X Is DONE!",
                                      "footer": {
                                        "text": "PTHT DOUGHLAS LOGS • Today At ]] .. os.date("%H:%M") .. [["
                                      },
                                      "thumbnail": {
                                        "url": "https://cdn.discordapp.com/attachments/961043626782228500/1443455382071804035/Doughlas_Jasa.jpg"
                                      }
                                    }
                                  ]
                                }
                                ]])
                            end
                        end
                    until PTHT == TotalPTHT
                elseif TotalPTHT then
                    while ScriptRunning do
                        Entering()
                    end
                end
            else
                dialog("`9Turn On API MakeRequest & os for Webhook")
            end
        else
            dialog("`9Turn On API io & os for Log PTHT")
        end
    else
        -- IF UID DOES NOT MATCH:
        RemoveHooks()
        ScriptRunning = false
        TextOverlay("`4ACCESS DENIED: UID " .. my_uid .. " IS NOT REGISTERED")
        LogToConsole("`4[ERROR] UID Check Failed. Your UID: " .. my_uid)
        return -- Stop execution
    end
end

-- =========================
-- ImGui PTHT
-- =========================

GUI_open = GUI_open == nil and true or GUI_open
ScriptRunning = false
StopRequested = StopRequested == nil and false or StopRequested
ConfigPath = ConfigPath or "PTHT-SETTING.json"

local defaultConfig = {
    Android = false,
    Windows = false,
    SeedID = 15955,
    BackgroundID = 298,
    StartCount = 0,
    TotalPTHT = 3000,
    PlantY = 0,
    DelayFindPath = 50,
    DelayStepPath = 100,
    DelayPlant = 80,
    DelayHarvest = 200,
    UseMRAY = true,
    UseUWS = false,
    DelayUWS = 10500,
    TakeUWS = false,
    UseVending = false,
    VendingX = 0,
    VendingY = 0,
    DelayTake = 1000,
    ConsumeLucky = false,
    AutoRespawn = false,
    PointX = 0,
    PointY = 0,
    MissTree = 1000,
    MirrorPlant = false,
    Radio = false,
    Lonely = false,
    AutoBuyCheats = true,
    AntiLag = false,
    WebhookPTHT = false,
    WebhookUrl = "https://discord.com/api/webhooks/1432993029018357810/lq8l4jyVM7J5mYCUsz3EmfpJQL5hiGgnB5ZHlxf1EhcEg-cxf-hoSEnWiZQMezug9lN0",
    DiscordID = 0
}

for k, v in pairs(defaultConfig) do
    if _G[k] == nil then _G[k] = v end
end

local function serialize_table(tbl, indent)
    indent = indent or ""
    local parts = {"return {\n"}
    local nextIndent = indent .. "  "
    for k, v in pairs(tbl) do
        local key
        if type(k) == "string" and k:match("^%a[%w_]*$") then
            key = k .. " = "
        else
            key = "[" .. tostring(k) .. "] = "
        end

        if type(v) == "number" then
            table.insert(parts, nextIndent .. key .. tostring(v) .. ",\n")
        elseif type(v) == "boolean" then
            table.insert(parts, nextIndent .. key .. (v and "true" or "false") .. ",\n")
        elseif type(v) == "string" then
            local s = v:gsub("\\", "\\\\"):gsub('"', '\\"')
            table.insert(parts, nextIndent .. key .. '"' .. s .. '",\n')
        elseif type(v) == "table" then
            local subparts = {"{\n"}
            local ni = nextIndent .. "  "
            for kk, vv in pairs(v) do
                local kstr = (type(kk) == "string" and ('["'..kk..'"] = ') or ("["..tostring(kk).."] = "))
                if type(vv) == "number" then
                    table.insert(subparts, ni .. kstr .. tostring(vv) .. ",\n")
                elseif type(vv) == "boolean" then
                    table.insert(subparts, ni .. kstr .. (vv and "true" or "false") .. ",\n")
                elseif type(vv) == "string" then
                    local sv = vv:gsub("\\", "\\\\"):gsub('"', '\\"')
                    table.insert(subparts, ni .. kstr .. '"' .. sv .. '",\n')
                else
                    table.insert(subparts, ni .. kstr .. '"' .. tostring(vv) .. '",\n')
                end
            end
            table.insert(subparts, nextIndent .. "},\n")
            table.insert(parts, nextIndent .. key .. table.concat(subparts))
        else
            table.insert(parts, nextIndent .. key .. '"' .. tostring(v) .. '",\n')
        end
    end
    table.insert(parts, indent .. "}\n")
    return table.concat(parts)
end

local function get_save_paths(filename)
    local paths = {}
    if Android then
        table.insert(paths, "storage/emulated/0/Android/media/com.rtsoft.growtopia/scripts/" .. filename)
        table.insert(paths, filename)
    end
    if Windows then
        local ok, localapp = pcall(function() return os.getenv("LOCALAPPDATA") end)
        if ok and localapp then
            local p = localapp:gsub("\\", "\\\\") .. "\\Growtopia\\scripts\\" .. filename
            table.insert(paths, p)
        end
        table.insert(paths, filename)
    end
    if #paths == 0 then table.insert(paths, filename) end
    return paths
end

function SaveConfig(path)
    path = path or ConfigPath or "PTHT-SETTING.json"
    local cfg = {
        Android = Android,
        Windows = Windows,
        SeedID = SeedID,
        BackgroundID = BackgroundID,
        StartCount = StartCount,
        TotalPTHT = TotalPTHT,
        PlantY = PlantY,
        DelayFindPath = DelayFindPath,
        DelayStepPath = DelayStepPath,
        DelayPlant = DelayPlant,
        DelayHarvest = DelayHarvest,
        UseMRAY = UseMRAY,
        UseUWS = UseUWS,
        DelayUWS = DelayUWS,
        TakeUWS = TakeUWS,
        UseVending = UseVending,
        VendingX = VendingX,
        VendingY = VendingY,
        DelayTake = DelayTake,
        ConsumeLucky = ConsumeLucky,
        AutoRespawn = AutoRespawn,
        PointX = PointX,
        PointY = PointY,
        MissTree = MissTree,
        MirrorPlant = MirrorPlant,
        Radio = Radio,
        Lonely = Lonely,
        AutoBuyCheats = AutoBuyCheats,
        AntiLag = AntiLag,
        WebhookPTHT = WebhookPTHT,
        WebhookUrl = WebhookUrl,
        DiscordID = DiscordID
    }

    local content = serialize_table(cfg)
    local paths = get_save_paths(path)
    local last_err
    for _, p in ipairs(paths) do
        local ok, f = pcall(function() return io.open(p, "w+") end)
        if ok and f then
            local suc, err = pcall(function() f:write(content); f:close() end)
            if suc then
                TextOverlay("`2Config saved: " .. tostring(p))
                LogToConsole("SaveConfig -> " .. tostring(p))
                return true
            else
                last_err = tostring(err)
            end
        else
            last_err = tostring(f)
        end
    end
    TextOverlay("`4Failed save config: " .. (last_err or "unknown"))
    LogToConsole("SaveConfig error: " .. tostring(last_err))
    return false
end

function LoadConfig(path)
    path = path or ConfigPath or "PTHT-SETTING.json"
    local paths = get_save_paths(path)
    for _, p in ipairs(paths) do
        local f = io.open(p, "r")
        if f then
            f:close()
            local ok, res = pcall(function() return dofile(p) end)
            if ok and type(res) == "table" then
                local cfg = res
                Android = cfg.Android ~= nil and cfg.Android or Android
                Windows = cfg.Windows ~= nil and cfg.Windows or Windows
                SeedID = cfg.SeedID or SeedID
                BackgroundID = cfg.BackgroundID or BackgroundID
                StartCount = cfg.StartCount or StartCount
                TotalPTHT = cfg.TotalPTHT or TotalPTHT
                PlantY = cfg.PlantY or PlantY
                DelayFindPath = cfg.DelayFindPath or DelayFindPath
                DelayStepPath = cfg.DelayStepPath or DelayStepPath
                DelayPlant = cfg.DelayPlant or DelayPlant
                DelayHarvest = cfg.DelayHarvest or DelayHarvest
                UseMRAY = cfg.UseMRAY ~= nil and cfg.UseMRAY or UseMRAY
                UseUWS = cfg.UseUWS ~= nil and cfg.UseUWS or UseUWS
                DelayUWS = cfg.DelayUWS or DelayUWS
                TakeUWS = cfg.TakeUWS ~= nil and cfg.TakeUWS or TakeUWS
                UseVending = cfg.UseVending ~= nil and cfg.UseVending or UseVending
                VendingX = cfg.VendingX or VendingX
                VendingY = cfg.VendingY or VendingY
                DelayTake = cfg.DelayTake or DelayTake
                ConsumeLucky = cfg.ConsumeLucky or ConsumeLucky
                AutoRespawn = cfg.AutoRespawn ~= nil and cfg.AutoRespawn or AutoRespawn
                PointX = cfg.PointX or PointX
                PointY = cfg.PointY or PointY
                MissTree = cfg.MissTree or MissTree
                MirrorPlant = cfg.MirrorPlant ~= nil and cfg.MirrorPlant or MirrorPlant
                Radio = cfg.Radio ~= nil and cfg.Radio or Radio
                Lonely = cfg.Lonely ~= nil and cfg.Lonely or Lonely
                AutoBuyCheats = cfg.AutoBuyCheats ~= nil and cfg.AutoBuyCheats or AutoBuyCheats
                AntiLag = cfg.AntiLag ~= nil and cfg.AntiLag or AntiLag
                WebhookPTHT = cfg.WebhookPTHT ~= nil and cfg.WebhookPTHT or WebhookPTHT
                WebhookUrl = cfg.WebhookUrl or WebhookUrl
                DiscordID = cfg.DiscordID or DiscordID

                TextOverlay("`2Config loaded: " .. tostring(p))
                LogToConsole("LoadConfig -> " .. tostring(p))
                return true
            else
                TextOverlay("`4Invalid config format: " .. tostring(p))
            end
        end
    end
    TextOverlay("`4Config not found")
    return false
end

function ResetDefaults()
    for k, v in pairs(defaultConfig) do _G[k] = v end
    TextOverlay("`2Defaults restored")
end

local function RecalcDerived()
    if GetTile(209, 0) then
        PlantX = 210
    elseif GetTile(199, 0) then
        PlantX = 200
    elseif GetTile(149, 0) then
        PlantX = 150
    elseif GetTile(99, 0) then
        PlantX = 100
    elseif GetTile(29, 0) then
        PlantX = 30
    else
        PlantX = 0
    end
    PlantX = MirrorPlant and (PlantX - 1) or (PlantX - PlantFar)

    PlantY = (0 == GetTile(20, 0 == PlantY % 2 and 20 or 21).fg or GetTile(20, 0 == PlantY % 2 and 20 or 21).fg == SeedID) and PlantY or PlantY - 1
    FarmTiles = GetFarm()
    HarvestTiles = GetHarvest()
    VerticalTiles = GetVertical()
    HorizontalTiles = GetHorizontal()
end

local function RecalcMag()
    local ok, ret = pcall(function()
        local mag_local = {}
        if GetTile and GetMag then
            if GetTile(209, 0) then
                mag_local = GetMag(209, 209)
            elseif GetTile(199, 0) then
                mag_local = GetMag(199, 199)
            elseif GetTile(149, 0) then
                mag_local = GetMag(149, 149)
            elseif GetTile(99, 0) then
                mag_local = GetMag(99, 59)
            elseif GetTile(29, 0) then
                mag_local = GetMag(29, 29)
            else
                mag_local = {}
            end
        else
            mag_local = {}
            for y = 0, 209 do
                for x = 0, 209 do
                    local t = GetTile and GetTile(x, y)
                    if t and t.fg == 5638 and t.bg == BackgroundID then
                        table.insert(mag_local, { x = x, y = y })
                    end
                end
            end
        end

        Mag = mag_local or {}
        Now = 1
        if TextOverlay then TextOverlay("`2Mag recalculated: " .. tostring(#Mag)) end
        if LogToConsole then LogToConsole("RecalcMag -> " .. tostring(#Mag) .. " magplants found (bg=" .. tostring(BackgroundID) .. ")") end
        return #Mag
    end)
    if not ok then
        if LogToConsole then LogToConsole("RecalcMag error: " .. tostring(ret)) end
    end
end

function ApplyGUI()
    Android = Android and true or false
    Windows = Windows and true or false
    SeedID = tonumber(SeedID) or SeedID
    VerticalPlant = VerticalPlant and true or false
    BackgroundID = tonumber(BackgroundID) or BackgroundID
    StartCount = tonumber(StartCount) or StartCount
    TotalPTHT = tonumber(TotalPTHT) or TotalPTHT
    PlantY = tonumber(PlantY) or PlantY
    DelayFindPath = tonumber(DelayFindPath) or DelayFindPath
    DelayStepPath = tonumber(DelayStepPath) or DelayStepPath
    DelayPlant = tonumber(DelayPlant) or DelayPlant
    DelayHarvest = tonumber(DelayHarvest) or DelayHarvest
    UseMRAY = UseMRAY and true or false
    UseUWS = UseUWS and true or false
    DelayUWS = tonumber(DelayUWS) or DelayUWS
    TakeUWS = TakeUWS and true or false
    UseVending = UseVending and true or false
    VendingX = tonumber(VendingX) or VendingX
    VendingY = tonumber(VendingY) or VendingY
    DelayTake = DelayTake or 1000
    ConsumeLucky = ConsumeLucky and true or false
    AutoRespawn = AutoRespawn and true or false
    PointX = tonumber(PointX) or PointX
    PointY = tonumber(PointY) or PointY
    MissTree = tonumber(MissTree) or MissTree
    MirrorPlant = MirrorPlant and true or false
    Radio = Radio and true or false
    Lonely = Lonely and true or false
    AutoBuyCheats = AutoBuyCheats and true or false
    AntiLag = AntiLag and true or false
    WebhookPTHT = WebhookPTHT and true or false
    WebhookUrl = tostring(WebhookUrl or "https://discord.com/api/webhooks/1432993029018357810/lq8l4jyVM7J5mYCUsz3EmfpJQL5hiGgnB5ZHlxf1EhcEg-cxf-hoSEnWiZQMezug9lN0")
    DiscordID = tonumber(DiscordID) or DiscordID

    RecalcMag()
    RecalcDerived()
    ActiveLag()

    if TextOverlay then TextOverlay("`2GUI applied to script settings") end
    if LogToConsole then LogToConsole("ApplyGUI -> settings applied") end
end

function PTHT_GUI()
    GUI_open = GUI_open == nil and true or GUI_open

    local ok = ImGui.Begin("PTHT BOTHAX V2 - Settings")
    if not ok then ImGui.End(); return end

    if ImGui.Button("Save") then SaveConfig(ConfigPath) end
    ImGui.SameLine()
    if ImGui.Button("Load") then LoadConfig(ConfigPath) end
    ImGui.SameLine()
    if ImGui.Button("Defaults") then ResetDefaults() end

    ImGui.Separator()

    ImGui.Text("Config File:")
    local changed_path, new_path = ImGui.InputText("##configpath", ConfigPath or "", 256)
    if changed_path then ConfigPath = new_path end
    ImGui.Separator()

    ImGui.Text("Device & Magplant")
    local ch_and, new_and = ImGui.Checkbox("Android", Android or false)
    if ch_and then Android = new_and end
    ImGui.SameLine()
    local ch_win, new_win = ImGui.Checkbox("Windows", Windows or false)
    if ch_win then Windows = new_win end

    ImGui.Separator()

    ImGui.Text("Seed & Background")
    local ch_seed, new_seed = ImGui.InputInt("SeedID", SeedID or 15955)
    if ch_seed then SeedID = new_seed end

    local ch_bg, new_bg = ImGui.InputInt("BackgroundID", BackgroundID or 0)
    if ch_bg then BackgroundID = new_bg end

    ImGui.Separator()

    local ch_vp, new_vp = ImGui.Checkbox("VerticalPlant", VerticalPlant == nil and true or VerticalPlant)
    if ch_vp then VerticalPlant = new_vp end

    ImGui.Separator()

    ImGui.Text("Positions")
    local ch_tot, new_tot = ImGui.InputInt("PlantY", PlantY or 0)
    if ch_tot then PlantY = math.max(0, new_tot) end
    if ImGui.Button("Save PlantY from Current") then
        if GetLocal and GetLocal().pos then
            PlantY = GetLocal().pos.y // 32
            TextOverlay("`2PlantY saved: " .. tostring(PlantY))
        else
            TextOverlay("`4Can't access local pos")
        end
    end

    ImGui.Separator()

    ImGui.Text("PTHT Count & Timing")
    local ch_sc, new_sc = ImGui.InputInt("StartCount", StartCount or 0)
    if ch_sc then StartCount = math.max(0, new_sc); SprayUWS = StartCount; PTHT = StartCount end

    local ch_tot, new_tot = ImGui.InputInt("TotalPTHT", TotalPTHT or 0)
    if ch_tot then TotalPTHT = math.max(0, new_tot) end

    local ch_dp, new_dp = ImGui.InputInt("DelayPlant (ms)", DelayPlant or 80)
    if ch_dp then DelayPlant = math.max(0, new_dp) end

    local ch_dh, new_dh = ImGui.InputInt("DelayHarvest (ms)", DelayHarvest or 200)
    if ch_dh then DelayHarvest = math.max(0, new_dh) end

    ImGui.Separator()

    ImGui.Text("FindPath Timing")
    local ch_dfp, new_dfp = ImGui.InputInt("DelayFindPath (ms)", DelayFindPath or 50)
    if ch_dfp then DelayFindPath = math.max(0, new_dfp) end

    local ch_msp, new_msp = ImGui.InputInt("DelayStepPath", DelayStepPath or 100)
    if ch_msp then DelayStepPath = math.max(0, new_msp) end

    ImGui.Separator()

    ImGui.Text("UWS Setting")
    local ch_uws, new_uws = ImGui.Checkbox("UseUWS", UseUWS == nil and false or UseUWS)
    if ch_uws then UseUWS = new_uws end
    local ch_du, new_du = ImGui.InputInt("DelayUWS (ms)", DelayUWS or 10500)
    if ch_du then DelayUWS = math.max(0, new_du) end

    ImGui.Separator()

    ImGui.Text("Auto Take UWS Setting")
    local ch_take, new_take = ImGui.Checkbox("TakeUWS", TakeUWS == nil and false or TakeUWS)
    if ch_take then TakeUWS = new_take end
    local ch_vending, new_vending = ImGui.Checkbox("Use Vending", UseVending == nil and false or UseVending)
    if ch_vending then UseVending = new_vending end
    local ch_vex, new_vex = ImGui.InputInt("VendingX", VendingX or 0)
    if ch_vex then VendingX = math.max(0, new_vex) end
    local ch_vey, new_vey = ImGui.InputInt("VendingY", VendingY or 0)
    if ch_vey then VendingY = math.max(0, new_vey) end
    if ImGui.Button("Save Vending Position from Current") then
        if GetLocal and GetLocal().pos then
            VendingX = GetLocal().pos.x // 32
            VendingY = GetLocal().pos.y // 32
            TextOverlay("`1Succes saved position")
        else
            TextOverlay("`4Can't access pos")
        end
    end

    ImGui.Separator()

    ImGui.Text("Auto Respawn Setting (With CheckPoint XY Coordinat) (note: turn off modfly)")
    local ch_respawn, new_respawn = ImGui.Checkbox("AutoRespawn (respawn after use uws)", AutoRespawn == nil and false or AutoRespawn)
    if ch_respawn then AutoRespawn = new_respawn end
    local ch_pox, new_pox = ImGui.InputInt("PointX", PointX or 0)
    if ch_pox then PointX = math.max(0, new_pox) end
    local ch_poy, new_poy = ImGui.InputInt("PointY", PointY or 0)
    if ch_poy then PointY = math.max(0, new_poy) end
    if ImGui.Button("Save CheckPoint Position from Current") then
        if GetLocal and GetLocal().pos then
            PointX = GetLocal().pos.x // 32
            PointY = GetLocal().pos.y // 32
            TextOverlay("`1Successfully saved position")
        else
            TextOverlay("`4Can't access pos")
        end
    end

    ImGui.Separator()

    ImGui.Text("Miss Tree (skipping tree planted)")
    ImGui.Text("Recommended MissTree : 1000")
    local ch_MissTree, new_MissTree = ImGui.InputInt("MissTree", MissTree or 1000)
    if ch_MissTree then MissTree = math.max(0, new_MissTree) end

    ImGui.Separator()

    ImGui.Text("Auto Consume Clover / Songpyeon")
    local ch_ConsumeLucky, new_ConsumeLucky = ImGui.Checkbox("ConsumeLucky", ConsumeLucky == nil and false or ConsumeLucky)
    if ch_ConsumeLucky then ConsumeLucky = new_ConsumeLucky end

    ImGui.Separator()

    ImGui.Text("Setting Hand")
    local ch_UseMRAY, new_UseMRAY = ImGui.Checkbox("UseMRAY", UseMRAY == nil and true or UseMRAY)
    if ch_UseMRAY then UseMRAY = new_UseMRAY end

    ImGui.Separator()

    ImGui.Text("Other Setting")
    local ch_mirror, new_mirror = ImGui.Checkbox("2 ACC", MirrorPlant == nil and false or MirrorPlant)
    if ch_mirror then MirrorPlant = new_mirror end
    local ch_radio, new_radio = ImGui.Checkbox("Radio", Radio == nil and false or Radio)
    if ch_radio then Radio = new_radio end
    local ch_lonely, new_lonely = ImGui.Checkbox("Lonely", Lonely == nil and false or Lonely)
    if ch_lonely then Lonely = new_lonely; CheckLonely = (Lonely and 1) or 0 end
    local ch_antilag, new_antilag = ImGui.Checkbox("AntiLag (Reduce Lag)", AntiLag == nil and false or AntiLag)
    if ch_antilag then
        AntiLag = new_antilag
        ActiveLag()
    end
    local ch_autobuy, new_autobuy = ImGui.Checkbox("AutoBuyCheats", AutoBuyCheats == nil and true or AutoBuyCheats)
    if ch_autobuy then AutoBuyCheats = new_autobuy end

    ImGui.Separator()

    ImGui.Text("Webhook Setting")
    local ch_web, new_web = ImGui.Checkbox("Enable WebhookPTHT", WebhookPTHT == nil and true or WebhookPTHT)
    if ch_web then WebhookPTHT = new_web end
    local changed_wu, new_wu = ImGui.InputText("Webhook URL", WebhookUrl or "", 256)
    if changed_wu then WebhookUrl = new_wu end
    local ch_did, new_did = ImGui.InputText("Discord ID (mention)", DiscordID or 0, 256)
    if ch_did then DiscordID = new_did end

    ImGui.Separator()

    if ImGui.Button("Start PTHT (GUI)") then
        if not ScriptRunning then
            StopRequested = false
            ScriptRunning = true
            ApplyGUI()
            RunThread(function() StartPTHT() end)
        else
            TextOverlay("`4Script running")
        end
    end
    ImGui.SameLine()
    if ImGui.Button("Stop PTHT") then
        if ScriptRunning then
            ScriptRunning = false
            StopRequested = true
            PTHT = 0
            TotalPTHT = 0
            SendPacket(3, [[
action|join_request
name|EXIT|
invitedWorld|0]])
            RemoveHooks()
            AddHook("OnDraw", "PTHT_GUI", PTHT_GUI)
            LogToConsole("`b[DOUGHLAS] `4Stopped")
        else
            TextOverlay("`1Script not running")
        end
    end

    ImGui.Separator()

    if ImGui.Button("Save Config") then SaveConfig(ConfigPath) end
    ImGui.SameLine()
    if ImGui.Button("Load Config") then LoadConfig(ConfigPath) end

    ImGui.Separator()

    ImGui.Text("Status: " .. ((ScriptRunning) and "Running" or "Stopped"))
    ImGui.Text("Config path: " .. tostring(ConfigPath))
    ImGui.Text(("PlantY: %s    MagCount: %s"):format(
        tostring(PlantY or "-"),
        tostring(type(Mag) == "table" and #Mag or 0)
    ))

    ImGui.End()
end

AddHook("OnDraw", "PTHT_GUI", PTHT_GUI)
LoadConfig(ConfigPath)
