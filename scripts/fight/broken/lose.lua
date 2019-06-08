-- Command line was: E:\github\dhgametool\scripts\fight\broken\lose.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local cfgbrokenboss = require("config.brokenboss")
ui.create = function(l_1_0)
  local layer = require("fight.base.lose").create()
  local cfg = cfgbrokenboss[l_1_0.stage]
  layer.addOkButton(function()
    require("fight.broken.loading").backToUI(video)
   end)
  if l_1_0.hurts and  l_1_0.hurts > 0 then
    local camp = {}
    for i,m in ipairs(cfg.monster) do
      camp[ camp + 1] = {kind = "mons", id = m, pos = cfg.stand[i]}
    end
    layer.addHurtsButton(l_1_0.camp, camp, l_1_0.hurts, l_1_0)
    require("fight.broken.win").addScoreAndHurtsSum(layer, l_1_0.hurts, cfg)
  end
  if l_1_0.rewards and l_1_0.select then
    layer:addChild(require("fight.pvp.lucky").create(l_1_0.rewards, l_1_0.select), 10)
  end
  return layer
end

return ui

