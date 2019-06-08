-- Command line was: E:\github\dhgametool\scripts\data\videoad.lua 

local videoad = {}
videoad.init = function(l_1_0)
  videoad.num = l_1_0
end

videoad.isAvailable = function()
  if isOnestore() then
    return false
  end
  return videoad.num and ((videoad.num > 0 and HHUtils:isVideoAdReady()))
end

videoad.watch = function()
  if videoad.num > 0 then
    videoad.num = videoad.num - 1
  end
  print("videoad num:", videoad.num)
end

videoad.print = function()
  print("--------- video ad -------- {")
  print("num:", videoad.num)
  print("--------- video ad -------- }")
end

return videoad

