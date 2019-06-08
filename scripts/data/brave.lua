-- Command line was: E:\github\dhgametool\scripts\data\brave.lua 

local brave = {}
brave.init = function(l_1_0)
  arrayclear(brave)
  tbl2string(l_1_0)
  brave.isPull = true
  brave.status = l_1_0.status
  brave.cd = l_1_0.cd + os.time()
  brave.enemys = {}
  brave.reddot = 0
  if l_1_0.nodes then
    brave.nodes = l_1_0.nodes
  else
    brave.nodes = nil
  end
  if brave.status == 0 then
    brave.id = l_1_0.id
    brave.stage = l_1_0.stage
    brave.enemys[brave.stage] = l_1_0.enemy
    if not l_1_0.team then
      brave.heros = {}
    end
  end
end

brave.initRedDot = function(l_2_0)
  brave.reddot = bit.band(1, l_2_0)
end

brave.showRedDot = function()
  if brave.reddot and brave.reddot == 1 then
    return true
  end
  return false
end

brave.clear = function()
  arrayclear(brave)
  brave.isPull = false
end

return brave

