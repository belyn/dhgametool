-- Command line was: E:\github\dhgametool\scripts\data\blackmarket.lua 

local blackmarket = {}
require("common.func")
blackmarket.init = function(l_1_0, l_1_1)
  local cfgblackmarket = require("config.blackmarket")
  blackmarket.buy = l_1_0.buy
  blackmarket.goods = {}
  for i = 1, #l_1_0.good do
    local g = l_1_0.good[i]
    local item = {}
    item.type = g.type
    item.excelId = g.id
    item.numb = g.count
    item.id = g.excel_id
    local configItem = cfgblackmarket[g.excel_id]
    item.rank = configItem.rank
    item.limitNumb = configItem.limitNumb
    item.cost = configItem.cost
    blackmarket.goods[#blackmarket.goods + 1] = item
  end
  table.sort(blackmarket.goods, function(l_1_0, l_1_1)
    return l_1_0.rank < l_1_1.rank
   end)
  if l_1_1 then
    blackmarket.refresh = l_1_0.cd + os.time()
  end
end

return blackmarket

