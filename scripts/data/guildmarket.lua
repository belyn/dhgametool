-- Command line was: E:\github\dhgametool\scripts\data\guildmarket.lua 

local guildmarket = {}
local cfgguildmarket = require("config.guildstore")
guildmarket.compareMarket = function(l_1_0, l_1_1)
  local rank1, rank2 = cfgguildmarket[l_1_0.id].sort, cfgguildmarket[l_1_1.id].sort
  return rank1 < rank2
end

guildmarket.getMaxPage = function()
  local maxPage = math.floor(( guildmarket.goods - 1) / 8) + 1
  return maxPage
end

guildmarket.init = function(l_3_0)
  guildmarket.goods = l_3_0.item
  for i = 1,  guildmarket.goods do
    guildmarket.goods[i]._id = i
  end
  table.sort(guildmarket.goods, guildmarket.compareMarket)
end

return guildmarket

