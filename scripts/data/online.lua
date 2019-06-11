-- Command line was: E:\github\dhgametool\scripts\data\online.lua 

local online = {}
local cfgonline = require("config.online")
online.pull_time = os.time()
online.sync = function(l_1_0)
  online.pull_time = os.time()
  online.id = l_1_0.id or 0
  online.cd = l_1_0.cd or 0
end

online.getRewardById = function(l_2_0)
  if not l_2_0 then
    l_2_0 = online.id
  end
  return cfgonline[l_2_0].reward
end

return online

