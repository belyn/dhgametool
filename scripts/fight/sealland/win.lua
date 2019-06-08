-- Command line was: E:\github\dhgametool\scripts\fight\sealland\win.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local cfgsealland = require("config.sealland")
ui.create = function(l_1_0)
  local layer = require("fight.base.win").create()
  layer.addRewardIcons(l_1_0.reward)
  local cfg = cfgsealland[l_1_0.stage]
  layer.addOkButton(function()
    require("fight.sealland.loading").backToUI(video)
   end)
  if l_1_0.hurts and  l_1_0.hurts > 0 then
    local camp = {}
    for i,m in ipairs(cfg.monster) do
      camp[ camp + 1] = {kind = "mons", id = m, pos = cfg.stand[i]}
    end
    layer.addHurtsButton(l_1_0.camp, camp, l_1_0.hurts, l_1_0)
  end
  return layer
end

ui.addScoreAndHurtsSum = function(l_2_0, l_2_1, l_2_2)
  local value = 0
  for _,h in ipairs(l_2_1) do
    if h.pos <= 6 then
      value = value + h.value
    end
  end
end

return ui

