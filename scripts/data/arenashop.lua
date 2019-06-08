-- Command line was: E:\github\dhgametool\scripts\data\arenashop.lua 

local arenashop = {}
local cfgarenashop = require("config.arenamarket")
arenashop.compareMarket = function(l_1_0, l_1_1)
  local rank1, rank2 = cfgarenashop[l_1_0.id].sort, cfgarenashop[l_1_1.id].sort
  return rank1 < rank2
end

arenashop.init = function(l_2_0)
  arenashop.goods = l_2_0.item
  for i = 1,  arenashop.goods do
    arenashop.goods[i]._id = i
  end
  table.sort(arenashop.goods, arenashop.compareMarket)
end

return arenashop

