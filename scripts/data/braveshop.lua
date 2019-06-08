-- Command line was: E:\github\dhgametool\scripts\data\braveshop.lua 

local braveshop = {}
local cfgbraveshop = require("config.bravemarket")
braveshop.compareMarket = function(l_1_0, l_1_1)
  local rank1, rank2 = cfgbraveshop[l_1_0.id].sort, cfgbraveshop[l_1_1.id].sort
  return rank1 < rank2
end

braveshop.init = function(l_2_0)
  braveshop.goods = l_2_0.item
  for i = 1,  braveshop.goods do
    braveshop.goods[i]._id = i
  end
  table.sort(braveshop.goods, braveshop.compareMarket)
end

return braveshop

