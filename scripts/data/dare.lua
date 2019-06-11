-- Command line was: E:\github\dhgametool\scripts\data\dare.lua 

local dare = {}
local cfgdare = require("config.dare")
local Type = {COIN = 1, EXP = 2, SOUL = 3}
dare.Type = Type
local stage = {coin = {}, exp = {}, soul = {}}
dare.stage = stage
dare.pull_time = os.time()
local init = function()
  for idx,item in pairs(cfgdare) do
    local ptbl = nil
    if item.type == Type.COIN then
      ptbl = stage.coin
    else
      if item.type == Type.EXP then
        ptbl = stage.exp
      else
        if item.type == Type.SOUL then
          ptbl = stage.soul
        end
      end
    end
    item.idx = idx
    ptbl[#ptbl + 1] = item
  end
end

init()
dare.sort = function(l_2_0, l_2_1)
  return l_2_0.idx < l_2_1.idx
end

dare.sync = function(l_3_0)
  dare.pulled = true
  dare.pull_time = os.time()
  dare.cd = l_3_0.cd
  dare.dares = l_3_0.dares
  dare.video = {}
end

dare.reset = function()
  dare.pull_time = os.time()
  dare.cd = 86400
  for ii = 1, 3 do
    dare.dares[ii].fight = 0
    dare.dares[ii].buy = 0
  end
  dare.pulled = false
end

dare.win = function(l_5_0)
  if dare.dares and dare.dares[l_5_0] then
    dare.dares[l_5_0].fight = dare.dares[l_5_0].fight + 1
  end
end

dare.getStage = function(l_6_0)
  if l_6_0 == Type.COIN then
    return dare.stage.coin
  else
    if l_6_0 == Type.EXP then
      return dare.stage.exp
    else
      if l_6_0 == Type.SOUL then
        return dare.stage.soul
      end
    end
  end
  return nil
end

dare.getDare = function(l_7_0)
  if l_7_0 == Type.COIN then
    return dare.dares[1]
  else
    if l_7_0 == Type.EXP then
      return dare.dares[2]
    else
      if l_7_0 == Type.SOUL then
        return dare.dares[3]
      end
    end
  end
end

return dare

