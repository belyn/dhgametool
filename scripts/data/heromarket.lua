-- Command line was: E:\github\dhgametool\scripts\data\heromarket.lua 

local heromarket = {}
local cfgheromarket = require("config.heromarket")
cfgguildMarket = function(l_1_0, l_1_1)
  local rank1, rank2 = cfgheromarket[l_1_0.id].rank, cfgheromarket[l_1_1.id].rank
  if rank1 < rank2 then
    return true
  elseif rank2 < rank1 then
    return false
  end
end

heromarket.getMaxPage = function()
  local maxPage = math.floor(( heromarket.goods - 1) / 8) + 1
  return maxPage
end

heromarket.init = function(l_3_0)
  heromarket.goods = l_3_0.item
  heromarket.pull_time = os.time()
  for i = 1,  heromarket.goods do
    heromarket.goods[i]._id = i
  end
  table.sort(heromarket.goods, cfgguildMarket)
end

heromarket.rm = function(l_4_0)
  for i = 1,  heromarket.goods do
    if i == l_4_0 then
      table.remove(heromarket.goods, l_4_0)
  else
    end
  end
end

return heromarket

