-- Command line was: E:\github\dhgametool\scripts\fight\trialrep\lose.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local cfgwavetrial = require("config.wavetrial")
ui.create = function(l_1_0)
  local layer = require("fight.base.lose").create()
  layer.addEnhanceGuide({backToSmith = function()
    require("fight.trialrep.loading").backToSmith(video)
   end, backToHero = function()
    require("fight.trialrep.loading").backToHero(video)
   end, backToSummon = function()
    require("fight.trialrep.loading").backToSummon(video)
   end})
  layer.addOkButton(function()
    require("fight.trialrep.loading").backToUI(video)
   end)
  if l_1_0.hurts and  l_1_0.hurts > 0 then
    local camp = {}
    local cfg = cfgwavetrial[l_1_0.stage]
    for i,m in ipairs(cfg.trial) do
      camp[ camp + 1] = {kind = "mons", id = m, pos = cfg.stand[i]}
    end
    layer.addHurtsButton(l_1_0.camp, camp, l_1_0.hurts, l_1_0)
  end
  return layer
end

return ui

