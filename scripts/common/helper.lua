-- Command line was: E:\github\dhgametool\scripts\common\helper.lua 

local helper = {}
local lowMemoryFlag = false
local resMap = {}
helper.isLowMem = function()
  if lowMemoryFlag then
    return true
  end
  if HHUtils:isLowMemory() then
    lowMemoryFlag = true
    return true
  end
  return false
end

helper.loadResource = function(l_2_0)
  if resMap[l_2_0] then
    return false
  end
  resMap[l_2_0] = true
  return true
end

helper.unloadResource = function(l_3_0)
  resMap[l_3_0] = nil
end

helper.getJsonCacheCount = function()
  return 10000
end

helper.checkMemory = function()
  if helper.isLowMem() then
    collectgarbage("collect")
  end
end

return helper

