----- main script

  UID = "+988050+989831+229295+113008+"

  function TextOverlay(text)
    SendVariantList({
      [0] = "OnTextOverlay",
      [1] = text
    })
  end
  
  local function toint(v)
    return math.floor(tonumber(v or 0) or 0)
  end

  Android = Android == nil and false or Android
  Windows = Windows == nil and false or Windows
  BackgroundID = BackgroundID or 12840
  VerticalPNB = VerticalPNB == nil and false or VerticalPNB
  pnbX = tonumber(pnbX) or 0
  pnbY = tonumber(pnbY) or 0
  TelX = tonumber(TelX) or 0 
  TelY = tonumber(TelY) or 0
  AutoBuff = AutoBuff == nil and false or AutoBuff
  AutoRemote = AutoRemote == nil and false or AutoRemote
  ConsumeArroz = ConsumeArroz == nil and false or ConsumeArroz
  ConsumeClover = ConsumeClover == nil and false or ConsumeClover
  ConsumeSongpyeon = ConsumeSongpyeon == nil and false or ConsumeSongpyeon
  AutoBuyWL = AutoBuyWL == nil and false or AutoBuyWL
  ConvertBGL = ConvertBGL == nil and false or ConvertBGL
  ConvertDLBGL = ConvertDLBGL == nil and true or ConvertDLBGL
  MaxGems = MaxGems or 400000
  DelayTake = DelayTake or 1000
  WorldConsume = WorldConsume or WorldConsume
  TakeConsumable = TakeConsumable == nil and false or TakeConsumable
  AutoBuyCheats = AutoBuyCheats == nil and true or AutoBuyCheats
  WebhookPNB = WebhookPNB == nil and true or WebhookPNB
  WebhookUrl = WebhookUrl or (WebhookPNB and "https://discord.com/api/webhooks/1433001434177081354/_F7ciCPCeznNDrHu_zR97U_AKP15IJYo5vg-gfodFHRbjhAPjsEH9zAWwZ3dM6sRi7V_" or "")
  DiscordID = DiscordID or 0
  IgnoreOther = IgnoreOther == nil and false or IgnoreOther
  MirrorPNB = MirrorPNB == nil and false or MirrorPNB
  PublicPNB = PublicPNB == nil and false or PublicPNB
  BypassPaywall = BypassPaywall == nil and false or BypassPaywall
  BypassWayBlock = BypassWayBlock == nil and false or BypassWayBlock
  SuckBgems = SuckBgems == nil and false or SuckBgems
  NoGemsDrop = NoGemsDrop == nil and true or false or NoGemsDrop
  AntiLag = AntiLag == nil and false or AntiLag

  function inv(id)
    for _, item in pairs(GetInventory()) do
      if item.id == id then
        return item.amount
      end
    end
    return 0
  end
  
  function obj(id)
    local total = 0
    for _, object in pairs(GetObjectList()) do
      if object.id == id then
        total = total + object.amount
      end
    end
    return total
  end
  
  PGems = pcall(obj) and obj(PinkGems) or 0
  BGems = pcall(obj) and obj(BlackGems) or 0
  Songpyeon = pcall(inv) and inv(1056) or 0
  Clover = pcall(inv) and inv(528) or 0
  Arroz = pcall(inv) and inv(4604) or 0
  BLK = pcall(inv) and inv(11550) or 0
  BGL = pcall(inv) and inv(7188) or 0
  DL = pcall(inv) and inv(1796) or 0
  TotalLocks = tonumber(BLK .. BGL .. DL)
  LockBefore = TotalLocks
  BGems = pcall(obj) and obj(BlackGems) or BGems
  BGemsBefore = BGems
  
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

  function FindTPVertical(x, y)
    SendPacketRaw(false, {
      state = 32,
      x = x * 32 - 1,
      y = y * 32 - 1,
      px = -1,
      py = -1
    })
  end

  function FindTPLeft(x, y)
    SendPacketRaw(false, {
      state = 48,
      x = x * 32,
      y = y * 32,
      px = x,
      py = y
    })
  end

  function CheatTurnOff()
    SendPacket(2, [[
action|dialog_return
dialog_name|cheats
check_autofarm|0
check_bfg|0
check_gems|1

check_lonely|]] .. CheckIgnore .. [[

check_ignoreo|]] .. CheckIgnore .. [[

check_ignoref|]] .. CheckIgnore)
  end
  
  function CheatTurnOn()
    SendPacket(2, [[
action|dialog_return
dialog_name|cheats
check_autofarm|1
check_bfg|1
check_autobuff|]] .. CheckBuff .. [[

check_autoremote|]] .. CheckRemote .. [[

check_gems|]] .. CheckGems .. [[

check_lonely|]] .. CheckIgnore .. [[

check_ignoreo|]] .. CheckIgnore .. [[

check_ignoref|]] .. CheckIgnore)
  end

function ActiveLag()
  if AntiLag then
    ChangeValue("[C] No render name", true)
    ChangeValue("[C] No render particle", true)
    ChangeValue("[C] No render shadow", true)
    ChangeValue("[C] No render world", true)
    ChangeValue("[C] No render object", true)
    ChangeValue("[C] No render player", true)
  else
    ChangeValue("[C] No render name", false)
    ChangeValue("[C] No render particle", false)
    ChangeValue("[C] No render shadow", false)
    ChangeValue("[C] No render world", false)
    ChangeValue("[C] No render object", false)
    ChangeValue("[C] No render player", false)
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
  
  function Wrench(x, y)
    SendPacketRaw(false, {
      type = 3,
      state = 32,
      value = 32,
      px = x,
      py = y,
      x = x * 32,
      y = y * 32
    })
  end
  
  function SendWebhook(url, data)
    MakeRequest(url, "POST", {
      ["Content-Type"] = "application/json"
    }, data)
  end

function CheckTime()
  if not os then return end
  local now = os.time()
  if now - (LastTime or 0) >= 1800 and GetWorld() ~= nil and GetRemote and WebhookPNB then
    if WebhookPNB then
      SendInfoPNB()
      Sleep(1000)
    end
    LastTime = now
  end
end
  
function GoPath(t, s, v, x, y)
    if GetWorld() == nil then return end
    SendPacketRaw(false, {type = t, state = s, value = v, px = x, py = y, x = x * 32, y = y * 32})
    if t == nil then
        SendVariantList({[0] = "OnSetPos",[1] = {x = x*32, y = y*32}}, GetLocal().netid)
    end
end

function PrivatePath(x, y, delay)
  if GetWorld() == nil then return end
  delay = 100
  iX, iY = math.floor(GetLocal().pos.x / 32), math.floor(GetLocal().pos.y / 32)
  DistX = x - iX
  DistY = y - iY
  if DistY > 1 then
    for i = 1, math.floor(DistY / 1) do
      iY = iY + 1
      GoPath(3, 1, 0, iX, iY)
      GoPath(nil, nil, nil, iX, iY)
      Sleep(delay)
    end
  elseif DistY < -1 then
    for i = 1, math.floor(DistY / -1) do
      iY = iY - 1
      GoPath(3, 1, 0, iX, iY)
      GoPath(nil, nil, nil, iX, iY)
      Sleep(delay)
    end
  end
  if DistX > 1 then
    for i = 1, math.floor(DistX / 1) do
      iX = iX + 1
      GoPath(3, 1, 0, iX, iY)
      GoPath(nil, nil, nil, iX, iY)
      Sleep(delay)
    end
  elseif DistX < -1 then
    for i = 1, math.floor(DistX / -1) do
      iX = iX - 1
      GoPath(3, 1, 0, iX, iY)
      GoPath(nil, nil, nil, iX, iY)
      Sleep(delay)
    end
  end
  if not Path then
    LogToConsole("`9No Path Found!")
  end
  iX, iY = x, y
  FindPath(x, y, 550)
  Sleep(delay)
end

local currentUser = GetLocal().userid
if string.find(UID, "+" .. tostring(currentUser) .. "+") then
    Intevoir = true
    print("`2UID Authorized: " .. currentUser)
else
    Intevoir = false
    print("`4UID Not Authorized: " .. currentUser)
end

function GetWorldSize()
    if GetWorld() == nil then return end
    if GetTile(209, 0) then
        return 209, 209
    elseif GetTile(199, 0) then
        return 199, 199
    elseif GetTile(149, 0) then
        return 149, 149
    elseif GetTile(99, 0) then
        return 99, 59
    elseif GetTile(29, 0) then
        return 29, 29
    else
        return 199, 199
    end
end

local PAYWALL_BLOCK = 16308

local ALLOWED_BLOCKS = {
    [0] = true, 
    [3898] = true,
    [15858] = true,
}

local NOT_ALLOWED_BLOCKS = {
    [3796] = true, 
}

local function UpdatePaywallBlocks()
  ALLOWED_BLOCKS = ALLOWED_BLOCKS or {}
  NOT_ALLOWED_BLOCKS = NOT_ALLOWED_BLOCKS or {}
  if BypassPaywall then
    ALLOWED_BLOCKS[PAYWALL_BLOCK] = true
    NOT_ALLOWED_BLOCKS[PAYWALL_BLOCK] = nil
    LogToConsole("`2Paywall block " .. PAYWALL_BLOCK .. " -> ALLOWED")
  else
    ALLOWED_BLOCKS[PAYWALL_BLOCK] = nil
    NOT_ALLOWED_BLOCKS[PAYWALL_BLOCK] = true
    LogToConsole("`4Paywall block " .. PAYWALL_BLOCK .. " -> NOT ALLOWED")
  end
  if BypassWayBlock then
    ALLOWED_BLOCKS[3796] = true
    NOT_ALLOWED_BLOCKS[3796] = nil
    LogToConsole("`2One way block 3796 -> ALLOWED")
  else
    ALLOWED_BLOCKS[3796] = nil
    NOT_ALLOWED_BLOCKS[3796] = true
    LogToConsole("`4One way block 3796 -> NOT ALLOWED")
  end
end

local function GetTileBlockId(tile)
    if GetWorld() == nil then return end
    if not tile then return 0 end
    if tile.fg and tile.fg ~= 0 then return tile.fg end
    if tile.bg and tile.bg ~= 0 then return tile.bg end
    return 0
end

function IsTileWalkable(x, y)
    if GetWorld() == nil then return end
    local maxX, maxY = GetWorldSize()
    if x < 0 or y < 0 or x > maxX or y > maxY then
        return false
    end
    local tile = GetTile(x, y)
    if not tile then 
        return false 
    end
    local blockid = GetTileBlockId(tile)
    if (blockid ~= 0) and (ALLOWED_BLOCKS[blockid] or PASSED_BLOCKS[blockid]) then
        return true
    end
    if (blockid ~= 0) and (NOT_ALLOWED_BLOCKS[blockid] or PASSED_BLOCKS[blockid]) then
        return false
    end
    if tile.fg == 0 and tile.bg == 0 then
        return true
    end
    if tile.flags and tile.flags.locked then
        return false
    end
    if CheckPath then
        local ok, res = pcall(CheckPath, x, y)
        if ok and res then
            return true
        end
    end
    return false
end

function FindSafePath(startX, startY, targetX, targetY, maxIterations)
    if GetWorld() == nil then return end
    maxIterations = maxIterations or 2000
    local openSet = {}
    local closedSet = {}
    local cameFrom = {}
    local function heuristic(x1, y1, x2, y2)
        return math.abs(x1 - x2) + math.abs(y1 - y2)
    end
    local function getNeighbors(x, y)
        return {
            {x = x, y = y - 1}, -- Up
            {x = x, y = y + 1}, -- Down
            {x = x - 1, y = y}, -- Left
            {x = x + 1, y = y}, -- Right
        }
    end
    local startKey = startX .. "," .. startY
    openSet[startKey] = {
        x = startX,
        y = startY,
        g = 0,
        h = heuristic(startX, startY, targetX, targetY),
        f = heuristic(startX, startY, targetX, targetY)
    }
    local iterations = 0
    while next(openSet) and iterations < maxIterations do
        iterations = iterations + 1
        local currentKey, current = nil, nil
        for key, node in pairs(openSet) do
            if not current or node.f < current.f then
                current = node
                currentKey = key
            end
        end
        if not current then break end
        if current.x == targetX and current.y == targetY then
            local path = {}
            local temp = current
            while temp do
                table.insert(path, 1, {x = temp.x, y = temp.y})
                temp = cameFrom[temp.x .. "," .. temp.y]
            end
            return path
        end
        openSet[currentKey] = nil
        closedSet[currentKey] = true
        local neighbors = getNeighbors(current.x, current.y)
        for _, neighbor in ipairs(neighbors) do
            local neighborKey = neighbor.x .. "," .. neighbor.y
            if not closedSet[neighborKey] and IsTileWalkable(neighbor.x, neighbor.y) then
                local tentative_g = current.g + 1
                if not openSet[neighborKey] or tentative_g < openSet[neighborKey].g then
                    cameFrom[neighborKey] = current
                    openSet[neighborKey] = {
                        x = neighbor.x,
                        y = neighbor.y,
                        g = tentative_g,
                        h = heuristic(neighbor.x, neighbor.y, targetX, targetY),
                        f = tentative_g + heuristic(neighbor.x, neighbor.y, targetX, targetY)
                    }
                end
            end
        end
    end
    return nil
end

local function FindNearestReachable(targetX, targetY, maxRadius, curX, curY)
    if GetWorld() == nil then return end
    maxRadius = maxRadius or 5
    local maxX, maxY = GetWorldSize()
    local candidates = {}
    for dx = -maxRadius, maxRadius do
        for dy = -maxRadius, maxRadius do
            local dist = math.abs(dx) + math.abs(dy)
            if dist <= maxRadius then
                local cx, cy = targetX + dx, targetY + dy
                if cx >= 0 and cy >= 0 and cx <= maxX and cy <= maxY then
                    if IsTileWalkable(cx, cy) then
                        table.insert(candidates, {x = cx, y = cy, d = dist})
                    end
                end
            end
        end
    end
    table.sort(candidates, function(a,b) return a.d < b.d end)
    for _, cand in ipairs(candidates) do
        local path = FindSafePath(curX, curY, cand.x, cand.y, 1500)
        if path and #path > 0 then
            return path, cand.x, cand.y
        end
    end
    return nil
end

function SafeFindPath(x, y, delay)
    if Ghost and not PublicPNB then return end
    if not PublicPNB then 
        return PrivatePath(x, y, 100) 
    end
    if GetWorld() == nil then 
        return false
    end
    delay = 100
    local iX, iY = math.floor(GetLocal().pos.x / 32), math.floor(GetLocal().pos.y / 32)
    if iX == x and iY == y then
        return true
    end
    local path = FindSafePath(iX, iY, x, y, 1000)
    if path and #path > 0 then
        for i, pos in ipairs(path) do
            if i > 1 then
                if IsTileWalkable(pos.x, pos.y) then
                    GoPath(3, 1, 0, pos.x, pos.y)
                    GoPath(nil, nil, nil, pos.x, pos.y)
                    Sleep(delay)
                    local currentX, currentY = math.floor(GetLocal().pos.x / 32), math.floor(GetLocal().pos.y / 32)
                    if currentX ~= pos.x or currentY ~= pos.y then
                        return
                    end
                else
                    local tile = GetTile(pos.x, pos.y)
                    local blockid = tile and GetTileBlockId(tile) or 0
                    GoPath(3,1,0,pos.x,pos.y)
                    GoPath(nil,nil,nil,pos.x,pos.y)
                    Sleep(delay)
                    local currentX, currentY = math.floor(GetLocal().pos.x / 32), math.floor(GetLocal().pos.y / 32)
                    if currentX == pos.x and currentY == pos.y then
                        if blockid ~= 0 then
                            PASSED_BLOCKS[blockid] = true
                        end
                    else
                        return 
                    end
                end
            end
        end
        return true
    end
    LogToConsole("`9No Path Found!")
    local candidatePath, cx, cy = FindNearestReachable(x, y, 10, iX, iY)
    if candidatePath and #candidatePath > 0 then
        for i, pos in ipairs(candidatePath) do
            if i > 1 then
                if IsTileWalkable(pos.x, pos.y) then
                    GoPath(3,1,0,pos.x,pos.y)
                    GoPath(nil,nil,nil,pos.x,pos.y)
                    Sleep(delay)
                    local curX, curY = math.floor(GetLocal().pos.x / 32), math.floor(GetLocal().pos.y / 32)
                    if curX ~= pos.x or curY ~= pos.y then
                        return 
                    end
                else
                    GoPath(3,1,0,pos.x,pos.y)
                    GoPath(nil,nil,nil,pos.x,pos.y)
                    Sleep(delay)
                    local curX, curY = math.floor(GetLocal().pos.x / 32), math.floor(GetLocal().pos.y / 32)
                    if curX ~= pos.x or curY ~= pos.y then
                        return 
                    end
                end
            end
        end
        local finalX, finalY = math.floor(GetLocal().pos.x / 32), math.floor(GetLocal().pos.y / 32)
        local manh = math.abs(finalX - x) + math.abs(finalY - y)
        if manh <= 10 then
            GoPath(3,1,0,x,y)
            GoPath(nil,nil,nil,x,y)
            Sleep(delay)
            local curX, curY = math.floor(GetLocal().pos.x / 32), math.floor(GetLocal().pos.y / 32)
            if curX == x and curY == y then
                return true
            else
                return 
            end
        else
            return 
        end
    end
    return 
end

function AutoConvert()
  MaxGems = MaxGems or 300000
  local Gems = Windows and GetPlayerInfo().gems or GetPlayerItems().gems
  if SuckBgems then
    BGems = pcall(obj) and obj(BlackGems) or BGems
    if BGems >= 100000 then
      SendPacket(2, [[
action|dialog_return
dialog_name|popup
buttonClicked|bgem_suckall
]])
    end
  end
  if AutoBuyWL then
    if inv(242) < 100 and inv(1796) < 100 and inv(7188) < 100 and Gems >= MaxGems then
      SendPacket(2, "action|buy\nitem|buy_worldlockpack")
    elseif inv(242) >= 100 and inv(1796) < 100 and inv(7188) < 100 then
      SendPacketRaw(false, {type = 10, value = 242})
    elseif inv(1796) >= 100 and inv(7188) < 100 then
      SendPacket(2, [[
action|dialog_return
dialog_name|telephone
num|53785|
x|]] .. TelX .. [[
|
y|]] .. TelY .. [[
|
buttonClicked|bglconvert]])
    elseif inv(7188) >= 100 then
      SendPacket(2, [[
action|dialog_return
dialog_name|info_box
buttonClicked|make_bgl]])
    end
  end
  if ConvertDLBGL then
    if Gems >= MaxGems and inv(1796) < 100 and inv(7188) < 100 then
      SendPacket(2, [[
action|dialog_return
dialog_name|telephone
num|53785|
x|]] .. TelX .. [[
|
y|]] .. TelY .. [[
|
buttonClicked|dlconvert]])
    elseif inv(1796) >= 100 and inv(7188) < 100 then
      SendPacket(2, [[
action|dialog_return
dialog_name|telephone
num|53785|
x|]] .. TelX .. [[
|
y|]] .. TelY .. [[
|
buttonClicked|bglconvert]])
    elseif inv(7188) >= 100 then
      SendPacket(2, [[
action|dialog_return
dialog_name|info_box
buttonClicked|make_bgl]]) 
    end
  end
  if ConvertBGL then
    if Gems > MaxGems and inv(7188) < 100 then
      SendPacket(2, "action|dialog_return\ndialog_name|telephone\nnum|53785|\nx|" .. TelX .. "|\ny|" .. TelY .. "|\nbuttonClicked|bglconvert2")
    elseif inv(7188) >= 100 then
      SendPacket(2, [[
action|dialog_return
dialog_name|info_box
buttonClicked|make_bgl]])
    end
  end
end

function AutoPNB()
  if not ScriptRunning then return end

  -- [FITUR BARU] Webhook Reconnect / Kembali ke World
  if PendingReconnect and GetWorld() ~= nil then
    PendingReconnect = false
    if WebhookPNB then
       local currentWorldName = GetWorld().name or "Unknown"
       local reconnectPayload = [[
{
  "embeds": [
    {
      "title": "<:eaa:1440243162080612374> DOUGHLAS PNB RECONNECTED",
      "description": "**Bot is back online!**",
      "color": 65280,
      "fields": [
        {
          "name": "『<:ava:1443432607726571660>』 **Account**",
          "value": "]] .. Nick .. [[",
          "inline": true
        },
        {
          "name": "『<:globe:1443460850248716308>』 **Current World**",
          "value": "]] .. currentWorldName .. [[",
          "inline": true
        }
      ],
      "thumbnail": {
        "url": "https://cdn.discordapp.com/attachments/961043626782228500/1443455382071804035/Doughlas_Jasa.jpg"
      },
      "footer": {
        "text": "PNB Alert • ]] .. os.date("%H:%M") .. [["
      }
    }
  ]
}
]]
      SendWebhook(WebhookUrl, reconnectPayload)
    end
  end
  -- [END FITUR RECONNECT]

  if not Mag or #Mag == 0 then return false end
  if not Now or Now < 1 then Now = 1 end
  if Now > #Mag then Now = 1 end
  if Ghost and not PublicPNB then
    Ghost = false
    Sleep(500)
    SendPacket(2, [[
action|input
|text|/ghost]])
    if IgnoreOther then
      SendPacket(3, [[
action|join_request
name|]] .. WorldName .. [[
|
invitedWorld|0]])
      Sleep(2000)
    end
  end
  if Ghost and not PublicPNB then return end
  if BlockSB and GetWorld() ~= nil then
    BlockSB = false
    Sleep(500)
    SendPacket(2, [[
action|input
|text|/radio]])
  end
  if AllMagEmpty then
    SendWebhook(WebhookUrl, "{\"content\": \"<@" .. DiscordID .. "> ALL Magplants Are Empty!\"}")
    AllMagEmpty = false
  end
  if inv(cid) < 1 then
    TakeConsumes()
  end
  if reconnect then
    reconnect = false
    if ReconnectWebhook then
      ReconnectWebhook = false
      -- [FITUR BARU] Embed Webhook Disconnect
      PendingReconnect = true -- Menandakan bot sedang offline
      local disconnectPayload = [[
{
  "embeds": [
    {
      "title": "<:eaa:1440243162080612374> DOUGHLAS PNB DISCONNECTED",
      "description": "<@]] .. DiscordID .. [[> **WARNING:** Bot Disconnected!",
      "color": 16711680,
      "fields": [
        {
          "name": "『<:ava:1443432607726571660>』 **Account**",
          "value": "]] .. Nick .. [[",
          "inline": true
        },
        {
          "name": "『<:globe:1443460850248716308>』 **Last World**",
          "value": "]] .. WorldName .. [[",
          "inline": true
        }
      ],
      "thumbnail": {
        "url": "https://cdn.discordapp.com/attachments/961043626782228500/1443455382071804035/Doughlas_Jasa.jpg"
      },
      "footer": {
        "text": "PNB Alert • ]] .. os.date("%H:%M") .. [["
      }
    }
  ]
}
]]
      SendWebhook(WebhookUrl, disconnectPayload)
    end
    Sleep(2000)
    if GetWorld() == nil then
      SendPacket(3, [[
action|join_request
name|]] .. WorldName .. [[
|
invitedWorld|0]])
      Sleep(7000)
    else
      return
    end
  elseif arroz and ConsumeArroz and GetRemote and not AutoBuff then
    SafeFindPath(pnbX, pnbY, 550)
    Sleep(2000)
    AutoConsume(4604)
    return true
  elseif clover and ConsumeSongpyeon and GetRemote and not AutoBuff then
    SafeFindPath(pnbX, pnbY, 550)
    Sleep(2000)
    AutoConsume(1056)
    return true
  elseif clover and ConsumeClover and GetRemote and not AutoBuff then
    SafeFindPath(pnbX, pnbY, 550)
    Sleep(2000)
    AutoConsume(528)
    return true
  elseif cheat and AutoBuyCheats then
    SendPacket(2, [[
action|dialog_return
dialog_name|buycheat
dialog_name|cheats
buttonClicked|1
]])
    Sleep(5000)
    MagW = false
    GetRemote = false
    CheatOff = true
    Sleep(2000)
    return true
  end
  if CheatOff and not GetRemote then
    Sleep(500)
    CheatOff = false
    CheatTurnOff()
    if PublicPNB then
      Sleep(800)
      SendPacket(2, [[
action|respawn
]])
      Sleep(3000)
    end
    LogToConsole(("`bDOUGHLAS `1Stop PnB! Last Magplant On #%d"):format(Now))
    CheatStopped = true
  end
  if GetRemote then
    if pnbX and pnbY then
      if not Taking then
        local loc = GetLocal()
        if loc and loc.pos then
          local lx = math.floor(loc.pos.x/32)
          local ly = math.floor(loc.pos.y/32)
          if lx ~= pnbX or ly ~= pnbY then
            CheatTurnOff()
            SafeFindPath(pnbX, pnbY, 550)
            PendingCheatOn = true
            CheatOn = false
          else
            if PendingCheatOn then
              local loc = GetLocal()
              if loc and pnbX and pnbY then
                local lx = loc.pos.x // 32
                local ly = loc.pos.y // 32
                if lx == pnbX and ly == pnbY then
                  PendingCheatOn = false
                  CheatOn = true
                  LogToConsole("`bDOUGHLAS `1Arrived at PnB: enabling CheatOn.")
                  if VerticalPNB then
                    ChangeValue("[C] Ghost mode", true)
                    FindTPVertical(pnbX, pnbY)
                  elseif MirrorPNB then
                    ChangeValue("[C] Ghost mode", true)
                    FindTPLeft(pnbX, pnbY)
                  end
                  Sleep(2000)
                else
                  return
                end
              else
                return
              end
            end
            if CheatOn then
              CheatOn = false
              CheatTurnOn()
              LogToConsole(string.format(
                "`bDOUGHLAS `1Start PnB! On Position X : `2%d, `1Y : `2%d",
                pnbX, pnbY
              ))
            end
            AutoConvert()
          end
        end
        CheckTime()
      end
      return true
    elseif GetWorld() == nil then
      return
    end
  else
    local m = Mag[Now]
    if m and m.x and m.y then
      if CheatStopped then
        Sleep(500)
        if PublicPNB then
          if IsTileWalkable(m.x, m.y - 1) then
            SafeFindPath(m.x, m.y - 1, 550)
            Wrench(Mag[Now].x, Mag[Now].y)
          else
            LogToConsole("`bDOUGHLAS `1AutoPNB: Current mag blocked, advancing to next.")
            Now = (Now == #Mag) and 1 or (Now + 1)
          end
        else
          SafeFindPath(m.x, m.y - 1, 550)
          Wrench(Mag[Now].x, Mag[Now].y)
        end
        return true
      else
        Sleep(500)
      end
    elseif not m and m.x and m.y then
      Now = (Now == #Mag) and 1 or (Now + 1)
      LogToConsole("`bDOUGHLAS `1AutoPNB: Current mag missing, advancing to next.")
      local nextm = Mag[Now]
      if nextm and nextm.x and nextm.y then
        SafeFindPath(nextm.x, nextm.y - 1, 550)
        return true
      end
    elseif GetWorld() == nil then
      return
    end
  end
  return false
end

function onvariant(var)
  local ev = var[0]
  local v1 = var[1]
  local v2 = var[2]
  if GetWorld() == nil then
    reconnect = true
    if WebhookPNB then
      ReconnectWebhook = true
    end
  elseif ev == "OnSDBroadcast" then
    SendPacket(2, [[
action|input
|text|/radio]])
  elseif type(v1) == "string" and v1:find("backpack slots.") then
    if v1:find("Ghost in the shell") then
      Ghost = false
    else
      Ghost = true
    end
    if v1:find("Breaking Gems") then
      arroz = false
    else
      arroz = true
    end
    if v1:find("Lucky!") then
      clover = false
    else
      clover = true
    end
    if v1:find("Cheater") then
      cheat = false
    else
      cheat = true
    end
    return true
  elseif ev == "OnConsoleMessage" then
    if type(v1) == "string" and v1:find("Radio enabled,") then
      BlockSB = true
    end
    if type(v1) == "string" and v1:find("World Locked") then
      if v1:find(WorldName) then
        MagW = false
        GetRemote = false
      else
        MagW = false
        GetRemote = false
        Ghost = true
        SendPacket(3, [[
action|join_request
name|]] .. WorldName .. [[
|
invitedWorld|0]])
      end
    end
    if type(v1) == "string" and v1:find("Your luck has worn off.") then
      clover = true
    end
    if type(v1) == "string" and v1:find("Your stomach's rumbling.") then
      arroz = true
    end
    if type(v1) == "string" and v1:find("boringness.") then
      cheat = true
    end
    if type(v1) == "string" and v1:find("You're luckier than before!") then
      clover = false
    end
    if type(v1) == "string" and v1:find("chance of a gem") then
      arroz = false
    end
    if type(v1) == "string" and v1:find("cheater!") then
      cheat = false
    end
  end
  if not MagW then
    if not Ghost then
      MagW = true
    end
  end
  if ev == "OnTalkBubble" then
    if v2 and v2:find("You received a MAGPLANT 5000 Remote") then
      GetRemote = true
      PendingCheatOn = true
      Taking = false
    elseif v2 and v2:find("The MAGPLANT 5000 is empty") and not CheatOff then
      GetRemote = false
      CheatOff = true
      MagW = false
      CheatStopped = false
      Taking = true
    end
  elseif ev == "OnDialogRequest" and not GetRemote then
    if not Mag or #Mag == 0 then return false end
    local cur = Mag[Now]
    if not cur then return false end
    if v1 and v1:find("ACTIVE") and v1:find(cur.x .. "\n") and v1:find(cur.y .. "\n") then
      if v1:find("Seed") then
        Now = (Now == #Mag) and 1 or (Now + 1)
      else
        SendPacket(2, [[
action|dialog_return
dialog_name|magplant_edit
x|]] .. cur.x .. [[
|
y|]] .. cur.y .. [[
|
buttonClicked|getRemote
]])
      end
    elseif v1 and v1:find("DISABLED") and v1:find(cur.x .. "\n") and v1:find(cur.y .. "\n") then
      if WebhookPNB and Now == #Mag then
        AllMagEmpty = true
      end
      Now = (Now == #Mag) and 1 or (Now + 1)
    elseif v1 and v1:find("The machine is disabled.") and v1:find(cur.x .. "\n") and v1:find(cur.y .. "\n") then
      if WebhookPNB and Now == #Mag then
        AllMagEmpty = true
      end
      Now = (Now == #Mag) and 1 or (Now + 1)
    end
  end
  return false
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
  
  function FTime(sec)
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
  
  function SendInfoPNB()
    math.randomseed(os.time())
    PGems = pcall(obj) and obj(PinkGems) or PGems
    BGems = pcall(obj) and obj(BlackGems) or BGems
    Gems = Windows and GetPlayerInfo().gems or GetPlayerItems().gems
    Songpyeon = pcall(inv) and inv(1056) or Songpyeon
    Clover = pcall(inv) and inv(528) or Clover
    Arroz = pcall(inv) and inv(4604) or Arroz
    BLK = pcall(inv) and inv(11550) or BLK
    BGL = pcall(inv) and inv(7188) or BGL
    DL = pcall(inv) and inv(1796) or DL
    if NoGemsDrop then
      if ConvertDL then
        TotalLocks = tonumber(BLK .. BGL .. DL)
        LockBefore = TotalLocks
      end
    else
      BGemsBefore = BGems
    end
   Payload = [[
{
  "embeds": [
    {
      "title": "<:eaa:1440243162080612374> DOUGHLAS PNB STATUS",
      "color": 2895667,
      "thumbnail": {
        "url": "https://cdn.discordapp.com/attachments/961043626782228500/1443455382071804035/Doughlas_Jasa.jpg"
      },

      "fields": [
        {
          "name": "**Information Account**",
          "value": " 『 <:ava:1443432607726571660> 』**Name:** `]] .. Nick .. [[`\n 『 <:globe:1443460850248716308> 』**World:** `]] .. WorldName .. [[`\n 『 <:magplant:1443461129258008730> 』**Magplant:** `]] .. Now .. [[ / ]] .. #Mag .. [[`",
          "inline": false
        },

        {
          "name": "**Consumable Stock**",
          "value": "『 <:arroz:1435565886638526598> 』 **Arroz:** `]] .. Arroz .. [[`\n『 <:clover:1432995542367211561> 』 **Clover:** `]] .. Clover .. [[`\n『 <:songpyeon:1432995023682801664> 』 **Songpyeon:** `]] .. Songpyeon .. [[`",
          "inline": false
        },

        {
          "name": "**Gems Information**",
          "value": "『 <:gems:1443458682896777286> 』**Gems:** `]] .. FNum(Gems) .. [[`\n『 <:bgems:1443432737317982342> 』 **Bgems:** `]] .. FNum(BGems) .. [[`",
          "inline": false
        },

        {
          "name": "**Floating Items**",
          "value": "『 <:bgems:1443432737317982342> 』 **Bgems:**`]] .. BGems .. [[`\n『 <:pgems:1443432703365087385> 』 **Pgems** `]] .. PGems .. [[`",
          "inline": false
        },

        {
          "name": "**Total Lock**",
          "value": "  『 <:ireng:1443432671949881436> 』 `]] .. BLK .. [[`\n 『 <:bgl:1435564733796323348> 』 `]] .. BGL .. [[`\n 『 <:dl:1435564709913956373> 』 `]] .. DL .. [[`",
          "inline": false
        },

        {
          "name": "**PNB Uptime**",
          "value": "`]] .. FTime(os.time() - StartTime) .. [[`",
          "inline": false
        }
      ],

      "footer": {
        "text": "PNB Log • Updated at ]] .. os.date("%H:%M") .. [["
      }
    }
  ]
}
]]

    SendWebhook(WebhookUrl, Payload)  
end

function AutoConsume(id)
  SendPacketRaw(false, {
    type  = 3,
    value = id,
    px    = pnbX,
    py    = pnbY,
    x     = pnbX * 32,
    y     = pnbY * 32
  })
  Sleep(500)
end
  
  local inv = inv
  local GetObjectList = GetObjectList
  local SendPacketRaw = SendPacketRaw
  local Sleep = Sleep
  initialDone = false
  waitingForRemote = false
  
function TakeConsumes()
  if ConsumeArroz and ConsumeClover then
    ConsumableID = {4604, 528}
  elseif ConsumeArroz and ConsumeSongpyeon then
    ConsumableID = {4604, 1056}
  elseif ConsumeArroz and not ConsumeSongpyeon and not ConsumeClover then
    ConsumableID = {4604}
  elseif ConsumeClover and not ConsumeArroz and not ConsumeSongpyeon then
    ConsumableID = {528}
  elseif ConsumeSongpyeon and not ConsumeArroz and not ConsumeClover then
    ConsumableID = {1056}
  else
    ConsumableID = ConsumableID or {}
  end
  if TakeConsumable then
    if GetWorld() ~= nil then
      if not ConsumableID or #ConsumableID == 0 then
        LogToConsole("`bDOUGHLAS `4No ConsumableID configured.")
        return
      end
      for _, cid in ipairs(ConsumableID) do
        if inv(cid) < 1 then
          Taking = true
          GetRemote = false
          CheatOn   = false
          CheatOff = false
          MagW = false
          RemoveHooks("onvariant")
          AddHook("OnDraw", "PNB_GUI", PNB_GUI)
          repeat
            if GetWorld().name ~= WorldConsume then
              SendPacket(3, [[
action|join_request
name|]] .. WorldConsume .. [[
|
invitedWorld|0]])
              Sleep(7000)
            else
              Sleep(800)
            end
            LogToConsole("`bDOUGHLAS `1Taking Consumable...")
            local objects = GetObjectList() or {}
            for _, obj in pairs(objects) do  
              if obj.id == cid then
                Sleep(500)
                SendPacket(2, [[
action|dialog_return
dialog_name|cheats
check_autofarm|0
check_bfg|0
check_gems|1
check_lonely|0
check_ignoreo|0
check_ignoref|0
]])
                Sleep(5000)
                SendPacket(2, [[
action|respawn
]])
                Sleep(5000)
                SafeFindPath(math.floor(obj.pos.x/32), math.floor(obj.pos.y/32), 500)
                ChangeValue("[C] Modfly", true)
                Sleep(DelayTake)
                if ghost then
                  SendPacket(2, "action|input\n|text|/ghost")
                  ghost = false
                end
                Sleep(DelayTake)
                if inv(cid) > 0 then
                  LogToConsole("`bDOUGHLAS `2Successfully Take Item! ID=" .. cid)
                  took = true
                end
                if not ghost then
                  SendPacket(2, "action|input\n|text|/ghost")
                  ghost = true
                end
                ChangeValue("[C] Modfly", false)
                Sleep(DelayTake)
                break
              end
            end
          until inv(cid) >= 1
          LogToConsole("`bDOUGHLAS `2Consumables is ready! BFG Mode Actived!")
          SendPacket(3, [[
action|join_request
name|]] .. WorldName .. [[
|
invitedWorld|0]])
          Sleep(7000)
          Taking = false
          Sleep(1200)
          AddHook("onvariant", "onvariant", onvariant)
        end
      end
    elseif GetWorld() == nil then
      Sleep(2000)
    end
  end
end
  
  function dialog(teks)
    Var0 = "OnDialogRequest"
    Var1 = [[
add_label_with_icon|big|`2PNB DOUGHLAS  ||16224|
add_spacer|small|
add_textbox|GrowID : ]] .. GetLocal().name:match("%S+") .. [[
||
add_textbox|World : `2]] .. WorldName .. [[
||
add_textbox|Position BFG : `6]] .. pnbX .. [[ `0, `6]] .. pnbY .. [[
||
add_textbox|`8]] .. teks .. [[
||
add_spacer|small|
add_smalltext|DOUGHLAS COMUNITY.|
add_url_button||`0Discord``|NOFLAGS|https://discord.gg/AF3REYDqps|Join my server.|0|
add_quick_exit|]]
    SendVariantList({
      [0] = Var0,
      [1] = Var1
    })
  end

  function StartPNB()
    if Intevoir then
      if os or not WebhookPNB then
        WorldName = GetWorld().name or "Unknown"
        if 0 == #Mag then
          dialog("`7Please Set Magplant Background")
        else
          dialog("`8Please Wait A Moment...")
          Sleep(200)
          LastTime = os and os.time() or 0
          DelayRemote = 2
          MaxGems = MaxGems or 0
          Nick = GetLocal().name:gsub("`(%S)", ""):match("%S+")
          NoGemsDrop = NoGemsDrop
          PinkGems = GetItemInfo("Pink Gemstone").id
          CheckIgnore = IgnoreOther and 1 or 0
          BlackGems = GetItemInfo("Black Gems").id
          if MOD then
          end
          CheckBuff = AutoBuff and 1 or 0
          CheckRemote = AutoRemote and 1 or 0
          CheckGems = NoGemsDrop and 1 or 0
          StartTime = os and os.time() or 0
          Now = 1
          BlockSB = true
          reconnect = false
          PendingReconnect = false
          GetRemote = false
          CheatOff = false
          CheatOn = false
          CheatStopped = true
          Ghost = false
          MagW = false
          RemoveHooks()
          AddHook("OnDraw", "PNB_GUI", PNB_GUI)
          ghost = true
          exitSent = false
          PASSED_BLOCKS = {}
          FAILED_BLOCKS = {}
          Sleep(1000)
          if AutoBuyCheats then
            SendPacket(2, [[
action|dialog_return
dialog_name|buycheat
dialog_name|cheats
buttonClicked|1
]])
            Sleep(1000)
          end
          if BlockSB then
            BlockSB = false
            Sleep(500)
            SendPacket(2, [[
action|input
|text|/radio]])
            Sleep(1000)
          end
          AddHook("onvariant", "onvariant", onvariant)
          Sleep(1000)
          CheatTurnOff()
          LogToConsole("`bDOUGHLAS `1PnB On Progress...")
          Sleep(1000)
          if PublicPNB then
            SendPacket(2, [[
action|respawn
]])
            Sleep(3000)
          end
          while ScriptRunning do
            Sleep(500)
            AutoPNB()
          end
        end
      else
        dialog("`5Turn On API MakeRequest & os for Webhook PNB")
      end
    else
      RemoveHooks()
      error("BELI DULU AJG")
    end
  end

-- =========================
-- ImGui PNB
-- =========================

GUI_open = GUI_open == nil and true or GUI_open
ScriptRunning = false
StopRequested = StopRequested == nil and false or StopRequested
ConfigPath = ConfigPath or "PNB-SETTING.json"

local defaultConfig = {
  Android = false,
  Windows = false,
  BackgroundID = 12840,
  VerticalPNB = false,
  AutoBuff = false,
  AutoRemote = false,
  ConsumeArroz = false,
  ConsumeClover = false,
  ConsumeSongpyeon = false,
  AutoBuyWL = false,
  ConvertBGL = false,
  ConvertDLBGL = true,
  MaxGems = 400000,
  DelayTake = 1000,
  TakeConsumable = false,
  WorldConsume = "WISNHH",
  AutoBuyCheats = true,
  WebhookPNB = true,
  WebhookUrl = "https://discord.com/api/webhooks/1433001434177081354/_F7ciCPCeznNDrHu_zR97U_AKP15IJYo5vg-gfodFHRbjhAPjsEH9zAWwZ3dM6sRi7V_",
  DiscordID = 0,
  IgnoreOther = false,
  MirrorPNB = false,
  PublicPNB = false,
  BypassPaywall = false,
  BypassWayBlock = false,
  SuckBgems = false,
  NoGemsDrop = true,
  AntiLag = false
}

for k, v in pairs(defaultConfig) do
  if _G[k] == nil then _G[k] = v end
end

if _G.VerticalPlant == nil then VerticalPlant = VerticalPNB end
if _G.WebhookPTHT == nil then WebhookPTHT = WebhookPNB end

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

local function ensure_dir(path)
  local dir = path:match("^(.*)[/\\]")
  if not dir or dir == "" then return true end
  local ok = os.execute(('mkdir -p "%s"'):format(dir))
  if ok == 0 or ok == true then return true end
  ok = os.execute(('mkdir "%s"'):format(dir))
  return ok == 0 or ok == true
end

local function get_save_paths(filename)
  local paths = {}
  filename = filename or "PNB-SETTING.json"

  if Android then
    table.insert(paths, "/storage/emulated/0/Android/media/com.rtsoft.growtopia/scripts/" .. filename)
    table.insert(paths, "/sdcard/Android/media/com.rtsoft.growtopia/scripts/" .. filename)
    table.insert(paths, filename)
  end

  if Windows then
    local ok, localapp = pcall(function() return os.getenv("LOCALAPPDATA") end)
    if ok and localapp and localapp ~= "" then
      local p = localapp:gsub("\\", "\\\\") .. "\\Growtopia\\scripts\\" .. filename
      table.insert(paths, p)
    end
    table.insert(paths, filename)
  end

  if #paths == 0 then table.insert(paths, filename) end
  return paths
end

function SaveConfig(path)
  path = path or ConfigPath or "PNB-SETTING.json"
  local cfg = {
    Android = Android,
    Windows = Windows,
    BackgroundID = BackgroundID,
    VerticalPNB = VerticalPNB,
    pnbX = pnbX,
    pnbY = pnbY,
    TelX = TelX,
    TelY = TelY,
    AutoBuff = AutoBuff,
    AutoRemote = AutoRemote,
    ConsumeArroz = ConsumeArroz,
    ConsumeClover = ConsumeClover,
    ConsumeSongpyeon = ConsumeSongpyeon,
    AutoBuyWL = AutoBuyWL,
    ConvertBGL = ConvertBGL,
    ConvertDLBGL = ConvertDLBGL,
    MaxGems = MaxGems,
    DelayTake = DelayTake,
    TakeConsumable = TakeConsumable,
    WorldConsume = WorldConsume,
    AutoBuyCheats = AutoBuyCheats,
    WebhookPNB = WebhookPNB,
    WebhookUrl = WebhookUrl,
    DiscordID = DiscordID,
    IgnoreOther = IgnoreOther,
    MirrorPNB = MirrorPNB,
    PublicPNB = PublicPNB,
    BypassPaywall = BypassPaywall,
    BypassWayBlock = BypassWayBlock,
    SuckBgems = SuckBgems,
    NoGemsDrop = NoGemsDrop,
    AntiLag = AntiLag
  }

  local content = serialize_table(cfg)
  local paths = get_save_paths(path)
  local last_err

  for _, p in ipairs(paths) do
    ensure_dir(p)

    local f, ferr = io.open(p, "w") -- io.open langsung mengembalikan (file, errmsg)
    if not f then
      last_err = tostring(ferr or "io.open failed")
    else
      local ok, werr = pcall(function() f:write(content); f:close() end)
      if ok then
        if TextOverlay then TextOverlay("`2Config saved: " .. tostring(p)) end
        if LogToConsole then LogToConsole("SaveConfig -> " .. tostring(p)) end
        return true
      else
        last_err = tostring(werr or "write failed")
      end
    end
  end

  if TextOverlay then TextOverlay("`4Failed save config: " .. (last_err or "unknown")) end
  if LogToConsole then LogToConsole("SaveConfig error: " .. tostring(last_err)) end
  return false
end
function LoadConfig(path)
  path = path or ConfigPath or "PNB-SETTING.json"
  local paths = get_save_paths(path)

  local android_paths = {
    "/storage/emulated/0/Android/media/com.rtsoft.growtopia/scripts/" .. path,
    "/sdcard/Android/media/com.rtsoft.growtopia/scripts/" .. path
  }
  for _, ap in ipairs(android_paths) do table.insert(paths, ap) end

  for _, p in ipairs(paths) do
    local f = io.open(p, "r")
    if f then
      f:close()
      local ok, res = pcall(function() return dofile(p) end)
      if ok and type(res) == "table" then
        local cfg = res
        Android = (cfg.Android ~= nil) and cfg.Android or Android
        Windows = (cfg.Windows ~= nil) and cfg.Windows or Windows
        BackgroundID = cfg.BackgroundID or BackgroundID
        VerticalPNB = (cfg.VerticalPNB ~= nil) and cfg.VerticalPNB or VerticalPNB

        pnbX = (cfg.pnbX ~= nil) and toint(cfg.pnbX) or pnbX
        pnbY = (cfg.pnbY ~= nil) and toint(cfg.pnbY) or pnbY
        TelX = (cfg.TelX ~= nil) and toint(cfg.TelX) or TelX
        TelY = (cfg.TelY ~= nil) and toint(cfg.TelY) or TelY

        AutoBuff = (cfg.AutoBuff ~= nil) and cfg.AutoBuff or AutoBuff
        AutoRemote = (cfg.AutoRemote ~= nil) and cfg.AutoRemote or AutoRemote
        ConsumeArroz = (cfg.ConsumeArroz ~= nil) and cfg.ConsumeArroz or ConsumeArroz
        ConsumeClover = (cfg.ConsumeClover ~= nil) and cfg.ConsumeClover or ConsumeClover
        ConsumeSongpyeon = (cfg.ConsumeSongpyeon ~= nil) and cfg.ConsumeSongpyeon or ConsumeSongpyeon
        AutoBuyWL = (cfg.AutoBuyWL ~= nil) and cfg.AutoBuyWL or AutoBuyWL
        ConvertBGL = (cfg.ConvertBGL ~= nil) and cfg.ConvertBGL or ConvertBGL
        ConvertDLBGL = (cfg.ConvertDLBGL ~= nil) and cfg.ConvertDLBGL or ConvertDLBGL
        MaxGems = cfg.MaxGems or MaxGems
        DelayTake = cfg.DelayTake or DelayTake
        TakeConsumable = (cfg.TakeConsumable ~= nil) and cfg.TakeConsumable or TakeConsumable
        WorldConsume = cfg.WorldConsume or WorldConsume
        AutoBuyCheats = (cfg.AutoBuyCheats ~= nil) and cfg.AutoBuyCheats or AutoBuyCheats
        WebhookPNB = (cfg.WebhookPNB ~= nil) and cfg.WebhookPNB or WebhookPNB
        WebhookUrl = cfg.WebhookUrl or WebhookUrl
        DiscordID = cfg.DiscordID or DiscordID
        IgnoreOther = (cfg.IgnoreOther ~= nil) and cfg.IgnoreOther or IgnoreOther
        MirrorPNB = (cfg.MirrorPNB ~= nil) and cfg.MirrorPNB or MirrorPNB
        PublicPNB = (cfg.PublicPNB ~= nil) and cfg.PublicPNB or PublicPNB
        BypassPaywall = (cfg.BypassPaywall ~= nil) and cfg.BypassPaywall or BypassPaywall
        BypassWayBlock = (cfg.BypassWayBlock ~= nil) and cfg.BypassWayBlock or BypassWayBlock
        SuckBgems = (cfg.SuckBgems ~= nil) and cfg.SuckBgems or SuckBgems
        NoGemsDrop = (cfg.NoGemsDrop ~= nil) and cfg.NoGemsDrop or NoGemsDrop
        AntiLag = (cfg.AntiLag ~= nil) and cfg.AntiLag or AntiLag

        CheckIgnore = IgnoreOther and 1 or 0

        if TextOverlay then TextOverlay("`2Config loaded: " .. tostring(p)) end
        if LogToConsole then LogToConsole("LoadConfig -> " .. tostring(p)) end

        if type(ApplyGUI) == "function" then ApplyGUI() end

        return true
      else
        if TextOverlay then TextOverlay("`4Invalid config format: " .. tostring(p)) end
      end
    end
  end
  if TextOverlay then TextOverlay("`4Config not found Please Check Name Config.") end
  return false
end

local function ResetDefaults()
  for k, v in pairs(defaultConfig) do _G[k] = v end
  VerticalPlant = VerticalPNB
  WebhookPTHT = WebhookPNB
  CheckIgnore = IgnoreOther and 1 or 0
  if TextOverlay then TextOverlay("`2Defaults restored") end
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
  BackgroundID = tonumber(BackgroundID) or defaultConfig.BackgroundID
  VerticalPNB = VerticalPNB and true or false
  VerticalPlant = VerticalPNB

  AutoBuyWL = AutoBuyWL and true or false
  ConvertBGL = ConvertBGL and true or false
  ConvertDLBGL = ConvertDLBGL and true or false
  MaxGems = tonumber(MaxGems) or defaultConfig.MaxGems
  DelayTake = tonumber(DelayTake) or defaultConfig.DelayTake
  TakeConsumable = TakeConsumable and true or false
  WorldConsume = tostring(WorldConsume or "")
  AutoBuyCheats = AutoBuyCheats and true or false
  WebhookPNB = WebhookPNB and true or false
  WebhookPTHT = WebhookPNB
  WebhookUrl = tostring(WebhookUrl or "")
  DiscordID = tonumber(DiscordID) or 0
  IgnoreOther = IgnoreOther and true or false
  MirrorPNB = MirrorPNB and true or false
  PublicPNB = PublicPNB and true or false
  BypassPaywall = BypassPaywall and true or false
  BypassWayBlock = BypassWayBlock and true or false
  SuckBgems = SuckBgems and true or false
  NoGemsDrop = NoGemsDrop and true or false
  AntiLag = AntiLag and true or false

  pnbX = tonumber(pnbX) or pnbX
  pnbY = tonumber(pnbY) or pnbY
  TelX = tonumber(TelX) or TelX
  TelY = tonumber(TelY) or TelY

  CheckIgnore = IgnoreOther and 1 or 0

  RecalcMag()
  UpdatePaywallBlocks()
  ActiveLag()

  if TextOverlay then TextOverlay("`2GUI applied to script settings") end
  if LogToConsole then LogToConsole("ApplyGUI -> settings applied") end
end

function PNB_GUI()
  GUI_open = GUI_open == nil and true or GUI_open
  local ok = ImGui.Begin("PNB - DOUGHLAS")
  if not ok then ImGui.End(); return end

  if ImGui.Button("Save") then
    if type(SaveConfig) == "function" then SaveConfig(ConfigPath) else TextOverlay("`4SaveConfig() tidak tersedia") end
  end
  ImGui.SameLine()
  if ImGui.Button("Load") then
    if type(LoadConfig) == "function" then
      LoadConfig(ConfigPath)
    else
      TextOverlay("`4LoadConfig() tidak tersedia")
    end
  end
  ImGui.SameLine()
  if ImGui.Button("Defaults") then ResetDefaults() end

  ImGui.Separator()

  ImGui.Text("Config File:")
  local changed_path, new_path = ImGui.InputText("##configpath", ConfigPath or "PNB-SETTING.json", 256)
  if changed_path and new_path and new_path ~= "" then ConfigPath = new_path end

  ImGui.Separator()

  ImGui.Text("Device Used")
  local ch_and, new_and = ImGui.Checkbox("Android", Android or false)
  if ch_and then Android = new_and end
  ImGui.SameLine()
  local ch_win, new_win = ImGui.Checkbox("Windows", Windows or false)
  if ch_win then Windows = new_win end

  ImGui.Separator()

  ImGui.Text("Magplant & Background")
  local ch_bg, new_bg = ImGui.InputInt("BackgroundID", BackgroundID or 0)
  if ch_bg then BackgroundID = new_bg end

  ImGui.Separator()

  ImGui.Text("Mode PNB")
  local ch_vp, new_vp = ImGui.Checkbox("VerticalPNB (Mneck)", VerticalPNB == nil and false or VerticalPNB)
  if ch_vp then VerticalPNB = new_vp; VerticalPlant = new_vp end
  local ch_publicpnb, new_publicpnb = ImGui.Checkbox("PublicPNB", PublicPNB == nil and false or PublicPNB)
  if ch_publicpnb then PublicPNB = new_publicpnb end
  local ch_BypassPaywall, new_BypassPaywall = ImGui.Checkbox("Bypass Paywall", BypassPaywall == nil and false or BypassPaywall)
  if ch_BypassPaywall then 
    BypassPaywall = new_BypassPaywall
    UpdatePaywallBlocks() 
  end
  local ch_BypassWayBlock, new_BypassWayBlock = ImGui.Checkbox("Bypass One-Way Block", BypassWayBlock == nil and false or BypassWayBlock)
  if ch_BypassWayBlock then 
    BypassWayBlock = new_BypassWayBlock
    UpdatePaywallBlocks() 
  end

  ImGui.Separator()

  ImGui.Text("Positions (PNB / TEL)")
  local px, npx = ImGui.InputInt("pnbX", pnbX or 0) if px then pnbX = npx end
  local py, npy = ImGui.InputInt("pnbY", pnbY or 0) if py then pnbY = npy end
  local tx, ntx = ImGui.InputInt("TelX", TelX or 0) if tx then TelX = ntx end
  local ty, nty = ImGui.InputInt("TelY", TelY or 0) if ty then TelY = nty end

  if ImGui.Button("Capture current PNB pos (pnbX,pnbY)") then
    if GetLocal and GetLocal().pos then
      pnbX = GetLocal().pos.x // 32
      pnbY = GetLocal().pos.y // 32
      TextOverlay("`2PNB Pos saved: X=" .. tostring(pnbX) .. " Y=" .. tostring(pnbY))
    else
      TextOverlay("`4Can't access local pos")
    end
  end
  ImGui.SameLine()
  if ImGui.Button("Capture current TEL pos (TelX,TelY)") then
    if GetLocal and GetLocal().pos then
      TelX = GetLocal().pos.x // 32
      TelY = GetLocal().pos.y // 32
      TextOverlay("`2TEL Pos saved: X=" .. tostring(TelX) .. " Y=" .. tostring(TelY))
    else
      TextOverlay("`4Can't access local pos")
    end
  end

  ImGui.Text(("Current PNB: %s,%s   TEL: %s,%s"):format(tostring(pnbX or "-"), tostring(pnbY or "-"), tostring(TelX or "-"), tostring(TelY or "-")))

  ImGui.Separator()

  ImGui.Text("Conversion & Timing")
  local ch_convwl, new_convwl = ImGui.Checkbox("Auto Buy WL", AutoBuyWL == nil and false or AutoBuyWL)
  if ch_convwl then AutoBuyWL = new_convwl end
  local ch_convbgl, new_convbgl = ImGui.Checkbox("Convert BGL", ConvertBGL == nil and false or ConvertBGL)
  if ch_convbgl then ConvertBGL = new_convbgl end
  local ch_convdlbgl, new_convdlbgl = ImGui.Checkbox("Convert DL to BGL", ConvertDLBGL == nil and true or ConvertDLBGL)
  if ch_convdlbgl then ConvertDLBGL = new_convdlbgl end
  local ch_dcdl, new_dcdl = ImGui.InputInt("Max Earn Gems (Auto Convert)", MaxGems or 400000)
  if ch_dcdl then MaxGems = math.max(0, new_dcdl) end

  ImGui.Separator()

  ImGui.Text("Auto Consumable (auto eat)")
  local ch_arroz, new_arroz = ImGui.Checkbox("ConsumeArroz", ConsumeArroz == nil and false or ConsumeArroz)
  if ch_arroz then ConsumeArroz = new_arroz end
  local ch_clover, new_clover = ImGui.Checkbox("ConsumeClover", ConsumeClover == nil and false or ConsumeClover)
  if ch_clover then ConsumeClover = new_clover end
  local ch_songpyeon, new_songpyeon = ImGui.Checkbox("ConsumeSongpyeon", ConsumeSongpyeon == nil and false or ConsumeSongpyeon)
  if ch_songpyeon then ConsumeSongpyeon = new_songpyeon end

  ImGui.Separator()

  ImGui.Text("Auto Take Consumable")
  local ch_takecons, new_takecons = ImGui.Checkbox("TakeConsumable (auto pickup/eat)", TakeConsumable == nil and false or TakeConsumable)
  if ch_takecons then TakeConsumable = new_takecons end
  local changed_wc, new_wc = ImGui.InputText("World Consume (Dropped)", WorldConsume or "", 256)
  if changed_wc then WorldConsume = new_wc end

  ImGui.Separator()

  ImGui.Text("Auto Cheat (Buff & Remote)")
  local ch_buff, new_buff = ImGui.Checkbox("Auto Buff (Consume)", AutoBuff == nil and false or AutoBuff)
  if ch_buff then AutoBuff = new_buff; CheckBuff = AutoBuff and 1 or 0 end
  local ch_remote, new_remote = ImGui.Checkbox("Auto Magplant Remote", AutoRemote == nil and false or AutoRemote)
  if ch_remote then AutoRemote = new_remote; CheckRemote = AutoRemote and 1 or 0 end

  ImGui.Separator()

  ImGui.Text("Other Setting")
  local ch_autobuy, new_autobuy = ImGui.Checkbox("AutoBuyCheats", AutoBuyCheats == nil and true or AutoBuyCheats)
  if ch_autobuy then AutoBuyCheats = new_autobuy end
  local ch_suck, new_suck = ImGui.Checkbox("SuckBgems (auto suck black gems)", SuckBgems == nil and false or SuckBgems)
  if ch_suck then SuckBgems = new_suck end

  local ch_NoGemsDrop, new_NoGemsDrop = ImGui.Checkbox("NoGemsDrop (prevent gem drop)", NoGemsDrop == nil and false or NoGemsDrop)
  if ch_NoGemsDrop then
    NoGemsDrop = new_NoGemsDrop
    CheckGems = NoGemsDrop and 1 or 0
  end

  local ch_ignore, new_ignore = ImGui.Checkbox("IgnoreOther (ignore other players)", IgnoreOther == nil and false or IgnoreOther)
  if ch_ignore then
    IgnoreOther = new_ignore
    CheckIgnore = IgnoreOther and 1 or 0
  end

  local ch_mirrorpnb, new_mirrorpnb = ImGui.Checkbox("MirrorPNB", MirrorPNB == nil and false or MirrorPNB)
  if ch_mirrorpnb then MirrorPNB = new_mirrorpnb end

  local ch_antilag, new_antilag = ImGui.Checkbox("AntiLag (Reduce Lag)", AntiLag == nil and false or AntiLag)
  if ch_antilag then 
    AntiLag = new_antilag 
    ActiveLag()
  end

  ImGui.Separator()

  ImGui.Text("Webhook")
  local ch_web, new_web = ImGui.Checkbox("Enable WebhookPNB", WebhookPNB == nil and true or WebhookPNB)
  if ch_web then WebhookPNB = new_web; WebhookPTHT = new_web end
  local changed_wu, new_wu = ImGui.InputText("Webhook URL", WebhookUrl or "", 256)
  if changed_wu then WebhookUrl = new_wu end
  local ch_did, new_did = ImGui.InputText("Discord ID (mention)", DiscordID or 0, 256)
  if ch_did then DiscordID = new_did end

  ImGui.Separator()

  if ImGui.Button("Start PNB (GUI)") then
    if not ScriptRunning then
      StopRequested = false
      ScriptRunning = true
      if type(StartPNB) == "function" then
        ApplyGUI()
        RunThread(function() StartPNB() end)
      else
        TextOverlay("`4StartPNB() tidak tersedia di script ini")
        ScriptRunning = false
      end
    else
      TextOverlay("`9Script already running")
    end
  end
  ImGui.SameLine()
  if ImGui.Button("Stop PNB") then
    if ScriptRunning then
      StopRequested = true
      ScriptRunning = false
      GetRemote = false
      CheatOn   = false
      RemoveHooks()
      AddHook("OnDraw", "PNB_GUI", PNB_GUI)
      TextOverlay("`4Stop requested")
    else
      TextOverlay("`9Script not running")
    end
  end

  ImGui.Separator()

  if ImGui.Button("Save Config") then
    if type(SaveConfig) == "function" then SaveConfig(ConfigPath) else TextOverlay("`4SaveConfig() tidak tersedia") end
  end
  ImGui.SameLine()
  if ImGui.Button("Load Config") then
    if type(LoadConfig) == "function" then
      LoadConfig(ConfigPath)
    else
      TextOverlay("`4LoadConfig() tidak tersedia")
    end
  end

  ImGui.Separator()

  ImGui.Text("Status: " .. ((ScriptRunning) and "Running" or "Stopped"))
  ImGui.Text("Config path: " .. tostring(ConfigPath))
  ImGui.Text(("pnbX: %s  pnbY: %s  TelX: %s  TelY: %s  MagCount: %s"):format(
    tostring(pnbX or "-"), tostring(pnbY or "-"), tostring(TelX or "-"), tostring(TelY or "-"),
    tostring(type(Mag) == "table" and #Mag or 0)
  ))

  ImGui.End()
end

AddHook("OnDraw", "PNB_GUI", PNB_GUI)
LoadConfig(ConfigPath)
