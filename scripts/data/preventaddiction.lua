-- Command line was: E:\github\dhgametool\scripts\data\preventaddiction.lua 

local preventAddiction = {}
require("common.const")
require("common.func")
local i18n = require("res.i18n")
preventAddiction.THREE_HOUR = 10800
preventAddiction.FIVE_HOUR = 18000
preventAddiction.MAX_HOUR = 360000
local onlineTime = 0
local adult = 0
local locale = "unknown"
local popped = false
local dialogShowTime = preventAddiction.THREE_HOUR
local startTime = 0
preventAddiction.init = function(l_1_0, l_1_1)
  onlineTime = l_1_0 or 0
  upvalue_512 = l_1_1 or 0
  upvalue_1024 = os.time()
  preventAddiction.print()
end

preventAddiction.init2 = function(l_2_0)
  onlineTime = l_2_0.online_time or 0
  upvalue_512 = l_2_0.adult or 0
  upvalue_1024 = l_2_0.locale or "unknown"
  upvalue_1536 = os.time()
  preventAddiction.print()
end

preventAddiction.getTotalTime = function()
  local currentTime = os.time()
  return onlineTime + (currentTime - startTime)
end

preventAddiction.getDialogShowTime = function()
  return dialogShowTime
end

preventAddiction.setDialogShowTime = function(l_5_0)
  dialogShowTime = l_5_0
end

preventAddiction.shouldShowDialog = function()
  if adult == 1 then
    return false
  end
  if dialogShowTime <= preventAddiction.getTotalTime() then
    return true
  end
  return false
end

preventAddiction.needPreventAddiction = function()
  local isChannel = isChannel()
  local lan = i18n.getLanguageShortName()
  return (lan == "cn" and #isChannel)
end

preventAddiction.getAdult = function()
  return adult
end

preventAddiction.setAdult = function(l_9_0)
  adult = l_9_0
end

preventAddiction.isChinese = function()
  if not locale then
    return false
  end
  if string.lower(locale) == "china" then
    return true
  end
  return false
end

preventAddiction.popped = function(l_11_0)
  if l_11_0 then
    popped = l_11_0
  end
  return popped
end

preventAddiction.shouldPop = function()
  if popped then
    return false
  end
  if isChannel() then
    return false
  end
  if require("data.player").lv() > 1 then
    return false
  end
  local lan = i18n.getLanguageShortName()
  if not preventAddiction.isChinese() and lan ~= "cn" then
    return false
  end
  if adult == 0 then
    return true
  end
  return false
end

preventAddiction.print = function()
  print("--------------- prevent addiction --------------- {")
  print("onlineTime:", onlineTime)
  print("dialogShowTime:", dialogShowTime)
  print("adult:", adult)
  print("locale:", locale)
  print("--------------- prevent addictions --------------- }")
end

return preventAddiction

