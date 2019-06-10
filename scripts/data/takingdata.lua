-- Command line was: E:\github\dhgametool\scripts\data\takingdata.lua 

local m = {}
local isSupport = function()
  if not APP_CHANNEL or APP_CHANNEL == "" then
    return false
  else
    local sdkcfg = require("common/sdkcfg")
    if not sdkcfg[APP_CHANNEL] then
      return false
    else
      if sdkcfg[APP_CHANNEL].support_takingdata then
        return true
      else
        return false
      end
    end
  end
  return false
end

m.statAccount = function(l_2_0, l_2_1)
  if not isSupport() then
    return 
  end
  HHUtils:statAccount(l_2_0, l_2_1)
end

m.onChargeReq = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
  if not isSupport() then
    return 
  end
  if not l_3_0 then
    l_3_0 = ""
  end
  if not l_3_1 then
    l_3_1 = ""
  end
  l_3_2 = "" .. (l_3_2 or "0")
  l_3_2 = math.floor(l_3_2)
  l_3_3 = "CNY"
  l_3_4 = 0
  l_3_5 = "third"
  HHUtils:onChargeReq(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
end

m.onChargeSuc = function(l_4_0)
  if not isSupport() then
    return 
  end
  if not l_4_0 then
    l_4_0 = ""
  end
  HHUtils:onChargeSuc(l_4_0)
end

m.statAccount = function(l_5_0, l_5_1)
  if not isSupport() then
    return 
  end
  HHUtils:statAccount(l_5_0, l_5_1)
end

m.onCustom = function(l_6_0)
  if not isSupport() then
    return 
  end
  HHUtils:onCustom(l_6_0)
end

m.onVirtual = function(l_7_0, l_7_1)
  if not isSupport() then
    return 
  end
  HHUtils:onVirtual(l_7_0, l_7_1)
end

m.onMission = function(l_8_0, l_8_1)
  if not isSupport() then
    return 
  end
  HHUtils:onMission(l_8_0, l_8_1)
end

m.onItem = function(l_9_0, l_9_1, l_9_2)
  if not isSupport() then
    return 
  end
  HHUtils:onItem(l_9_0, l_9_1, l_9_2)
end

return m

