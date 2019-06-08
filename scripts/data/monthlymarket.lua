-- Command line was: E:\github\dhgametool\scripts\data\monthlymarket.lua 

local monthlyshop = {}
local cfgmmarket = require("config.monthlymarket")
monthlyshop.compareMarket = function(l_1_0, l_1_1)
  local rank1, rank2 = cfgmmarket[l_1_0.id].rank, cfgmmarket[l_1_1.id].rank
  return rank1 < rank2
end

monthlyshop.init = function(l_2_0)
  monthlyshop.mpiece = l_2_0.mpiece
  monthlyshop.mequip = l_2_0.mequip
  monthlyshop.mskin = l_2_0.mskin
  for i = 1,  monthlyshop.mpiece do
    monthlyshop.mpiece[i]._id = i
  end
  for i = 1,  monthlyshop.mequip do
    monthlyshop.mequip[i]._id = i
  end
  for i = 1,  monthlyshop.mskin do
    monthlyshop.mskin[i]._id = i
  end
  monthlyshop.goods = monthlyshop.mpiece
  table.sort(monthlyshop.mpiece, monthlyshop.compareMarket)
  table.sort(monthlyshop.mequip, monthlyshop.compareMarket)
  table.sort(monthlyshop.mskin, monthlyshop.compareMarket)
end

return monthlyshop

