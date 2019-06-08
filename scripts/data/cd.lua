-- Command line was: E:\github\dhgametool\scripts\data\cd.lua 

local cd = {}
cd.initCDS = function(l_1_0)
  if not l_1_0 or  l_1_0 <= 0 then
    return 
  end
  for ii = 1,  l_1_0 do
    if l_1_0[ii].id == 1 and l_1_0[ii].cd >= 0 then
      require("data.guildmill").setOrdercd(l_1_0[ii].cd)
    end
  end
end

return cd

