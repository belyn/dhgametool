-- Command line was: E:\github\dhgametool\scripts\data\push.lua 

local m = {}
local inited = false
m.init = function()
  if inited then
    return 
  end
  inited = true
  if HHUtils.initFirebase then
    HHUtils:initFirebase()
  end
end

m.getToken = function()
  local token = ""
  if not inited then
    return token
  end
  if HHUtils.getDeviceToken then
    return HHUtils:getDeviceToken()
  end
  return token
end

m.subscribeFCMTopic = function(l_3_0)
  if not inited then
    return 
  end
  if HHUtils.subscribeFCMTopic then
    HHUtils:subscribeFCMTopic(l_3_0)
  end
end

m.unsubscribeFCMTopic = function(l_4_0)
  if not inited then
    return 
  end
  if HHUtils.unsubscribeFCMTopic then
    HHUtils:unsubscribeFCMTopic(l_4_0)
  end
end

return m

