-- Command line was: E:\github\dhgametool\scripts\ui\login\gate.lua 

local gate = {}
require("common.const")
require("common.func")
local userdata = require("data.userdata")
local LIST = {{host = "adyyb.gate-dhgames.com", port = 5000}}
local PING_TIMEOUT = 8
local PING_REFRESH = 604800
gate.init = function(l_1_0)
  gate.info = nil
  local info = gate.getInfo()
  if info.best and info.timestamp and os.time() - info.timestamp < PING_REFRESH then
    gate.ping(info.best, 1, function(l_1_0)
    if l_1_0 ~= -1 then
      gate.info = info
      gate.print("in gate.init")
      handler("ok", info.best)
    else
      gate.pingBest(info, handler)
    end
   end)
  else
    gate.pingBest(info, l_1_0)
  end
end

gate.get = function()
  gate.update()
  if gate.info and gate.info.best then
    return gate.info.best
  end
end

gate.pingBest = function(l_3_0, l_3_1)
  local list = l_3_0.list
  local minPing, index = nil, nil
  local pingRecursively = function(l_1_0)
    if  list < l_1_0 then
      if index == nil then
        print("gate.pingBest: no gate available!")
        handler("error")
        return 
      end
      info.best = list[index]
      info.timestamp = os.time()
      gate.info = info
      gate.save(info)
      gate.print("in gate.pingBest")
      handler("ok", info.best)
      return 
    end
    gate.ping(list[l_1_0], 1, function(l_1_0)
      print("gate.pingBest: host", list[i].host, "port", list[i].port, "ping", l_1_0)
      if l_1_0 ~= -1 and (minPing == nil or l_1_0 < minPing) then
        upvalue_1024, upvalue_1536 = l_1_0, i
      end
      pingRecursively(i + 1)
      end)
   end
  pingRecursively(1)
end

gate.ping = function(l_4_0, l_4_1, l_4_2)
  local isDone = false
  local startTime = getMilliSecond()
  local net = require("net.netClient")
  net:connect({host = l_4_0.host, port = l_4_0.port}, function()
    local echoGate = function(l_1_0)
      net:echo({sid = 0, echo = l_1_0}, function()
        if not isDone then
          if i == num then
            isDone = true
            net:close(function()
              handler(getMilliSecond() - startTime)
                  end)
            return 
          end
          echoGate(i + 1)
        end
         end)
      end
    echoGate(1)
   end)
  local scene = CCDirector:sharedDirector():getRunningScene()
  schedule(scene, PING_TIMEOUT, function()
    if not isDone then
      isDone = true
      net:close(function()
        handler(-1)
         end)
    end
   end)
end

gate.getInfo = function()
  local info = gate.getLocalInfo()
  if info then
    for _,s in ipairs(LIST) do
      if not gate.contains(info.list, s) then
        info.list[ info.list + 1] = {host = s.host, port = s.port}
      end
    end
    if not gate.contains(info.list, info.best) then
      info.best = nil
    end
    return info
  end
  return {list = LIST}
end

gate.getLocalInfo = function()
  local info = {list = {}}
  local infoStr = string.split(userdata.getString(userdata.keys.gateServer), "|")
  reportEvent({event_type = "gate", event_name = "local gate", silence = "1", event_value = {desc = infoStr}})
  if  infoStr ~= 3 then
    return 
  end
  for _,serverStr in ipairs(string.split(infoStr[1], ",")) do
    local host, port = gate.getHostAndPort(serverStr)
    if host == nil or port == nil then
      return 
    end
    info.list[ info.list + 1] = {host = host, port = port}
  end
  local bestHost, bestPort = gate.getHostAndPort(infoStr[2])
  if bestHost == nil or bestPort == nil then
    return 
  end
  info.best = {host = bestHost, port = bestPort}
  local timestamp = tonumber(infoStr[3], 10)
  if timestamp == nil or timestamp < 0 then
    return 
  end
  info.timestamp = timestamp
  return info
end

gate.getHostAndPort = function(l_7_0)
  local server = string.split(l_7_0, ":")
  if  server ~= 2 then
    return 
  end
  local host = string.trim(server[1])
  if host == "" then
    return 
  end
  local port = tonumber(server[2], 10)
  if port == nil or port < 0 then
    return 
  end
  return host, port
end

gate.contains = function(l_8_0, l_8_1)
  for _,serv in ipairs(l_8_0) do
    if serv.host == l_8_1.host and serv.port == l_8_1.port then
      return true
    end
  end
  return false
end

gate.isSameList = function(l_9_0, l_9_1)
  if  l_9_0 ==  l_9_1 then
    for _,s in ipairs(l_9_0) do
      if not gate.contains(l_9_1, s) then
        return false
      end
    end
    return true
  end
  return false
end

gate.update = function()
  if gate.info == nil then
    gate.info = gate.getLocalInfo()
  end
  if not gate.isSameList(gate.info.list, LIST) then
    gate.print("in gate.update modify userdata")
    gate.save({list = LIST, best = gate.info.best, timestamp = 0})
  end
end

gate.save = function(l_11_0)
  local serverStr = {}
  for _,s in ipairs(l_11_0.list) do
    serverStr[ serverStr + 1] = s.host .. ":" .. s.port
  end
  local bestStr = l_11_0.best.host .. ":" .. l_11_0.best.port
  local str = table.concat(serverStr, ",") .. "|" .. bestStr .. "|" .. l_11_0.timestamp
  userdata.setString(userdata.keys.gateServer, str)
end

gate.print = function(l_12_0)
  print("------ gate ------ {")
  if l_12_0 then
    print(l_12_0)
  end
  if gate.info then
    if gate.info.list then
      for _,s in ipairs(gate.info.list) do
        print("list:", s.host, s.port)
      end
    end
    if gate.info.best then
      print("best:", gate.info.best.host, gate.info.best.port)
    end
    if gate.info.timestamp then
      print("timestamp:", gate.info.timestamp)
    end
  end
  print("------ gate ------ }")
end

return gate

