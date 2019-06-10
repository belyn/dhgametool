-- Command line was: E:\github\dhgametool\scripts\data\gacha.lua 

local gacha = {}
require("common.const")
require("common.func")
gacha.init = function(l_1_0)
  local now = os.time()
  gacha.item = l_1_0.item + now
  gacha.gem = l_1_0.gem + now
end

gacha.initspacesummon = function(l_2_0)
  gacha.spacesummon = l_2_0
end

gacha.print = function()
  print("--------- gacha --------- {")
  print("item:", gacha.item, "gem:", gacha.gem, "gachaspaceid:", gacha.spacesummon)
  print("--------- gahca --------- }")
end

gacha.showRedDot = function()
  local now = os.time()
  if gacha.item == nil or gacha.gem == nil then
    return false
  end
  if gacha.item <= now or gacha.gem <= now then
    return true
  end
  return false
end

return gacha

