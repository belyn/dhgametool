-- Command line was: E:\github\dhgametool\scripts\data\toutiao.lua 

local m = {}
local cjson = json
m.isSupport = function()
  if APP_CHANNEL and APP_CHANNEL == "IAS" then
    return true
  end
  return false
end

m.eventRegister = function(l_2_0)
  if not m.isSupport() then
    return 
  end
  if not l_2_0 then
    l_2_0 = "email"
  end
  local params = {eventName = "register", method = l_2_0}
  local paramstr = cjson.encode(params)
  SDKHelper:getInstance():submitRoleData(paramstr, function(l_1_0)
   end)
end

m.eventPurchase = function(l_3_0, l_3_1, l_3_2)
  if not m.isSupport() then
    return 
  end
  if not l_3_0 then
    l_3_0 = ""
  end
  if not l_3_1 then
    l_3_1 = ""
  end
  if not l_3_2 then
    l_3_2 = ""
  end
  local params = {eventName = "purchase", content_name = l_3_0, content_id = l_3_1, currency_amount = l_3_2}
  local paramstr = cjson.encode(params)
  SDKHelper:getInstance():submitRoleData(paramstr, function(l_1_0)
   end)
end

m.eventLevel = function()
  local player = require("data.player")
  if not m.isSupport() then
    return 
  end
  local paramstr = cjson.encode(params)
  local params = {eventName = "update_level"}
  params.roleId = player.uid or "empty"
  params.serverId = player.sid
  params.roleLevel = player.lv() or 1
  local paramstr = cjson.encode(params)
  SDKHelper:getInstance():submitRoleData(paramstr, function(l_1_0)
   end)
end

return m

