-- Command line was: E:\github\dhgametool\scripts\data\airisland.lua 

local airisland = {}
local cfghero = require("config.hero")
local cfgMonster = require("config.monster")
local cfgSpk = require("config.spk")
local cfgSpkWave = require("config.spkwave")
local cfgMonster = require("config.monster")
local cfgDrug = require("config.spkdrug")
local cfgTrader = require("config.spktrader")
local heros = require("data.heros")
local userdata = require("data.userdata")
local airConf = require("config.homeworld")
airisland.setCount = function()
  airisland.count = 0
end

airisland.initRedDot = function(l_2_0)
  airisland.reddot = bit.band(8, l_2_0)
  local isShow = airisland.reddot ~= 0 and true or false
  airisland.setShowRed(isShow)
end

airisland.setData = function(l_3_0)
  airisland.data = l_3_0
  airisland.fullBuilds = 0
  if airisland.data and airisland.data.mine then
    for k,v in pairs(airisland.data.mine) do
      local limit = airConf[v.id].max
      if limit <= v.val then
        airisland.fullBuilds = airisland.fullBuilds + 1
      end
    end
  end
  airisland.setShowRed(airisland.fullBuilds > 0 and true or false)
end

airisland.setShowRed = function(l_4_0)
  airisland.isShow = l_4_0 or false
end

airisland.getOutPut = function()
  airisland.fullBuilds = airisland.fullBuilds - 1
  airisland.setShowRed(airisland.fullBuilds > 0 and true or false)
end

airisland.showRedDot = function()
  return airisland.isShow
end

airisland.setLandData = function(l_7_0)
  airisland.data.land = l_7_0
  for i = 1, 27 do
    if l_7_0.land[i] then
      if l_7_0.land[i].cd == nil then
        airisland.data.land.land[i].cd = nil
      else
        airisland.data.land.land[i].cd = l_7_0.land[i].cd + os.time()
      end
    end
  end
end

airisland.calVit = function(l_8_0)
  airisland.data.vit.vit = l_8_0
end

airisland.changeVit = function(l_9_0)
  airisland.data.vit.vit = airisland.data.vit.vit + l_9_0
end

return airisland

