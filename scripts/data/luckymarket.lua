-- Command line was: E:\github\dhgametool\scripts\data\luckymarket.lua 

local luckymarket = {}
luckymarket.init = function(l_1_0, l_1_1)
  luckymarket.goods = l_1_0.goods
  if l_1_1 then
    luckymarket.refresh = l_1_0.cd + os.time()
  end
end

return luckymarket

