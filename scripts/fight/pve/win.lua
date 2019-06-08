-- Command line was: E:\github\dhgametool\scripts\fight\pve\win.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local cfgstage = require("config.stage")
ui.create = function(l_1_0)
  local layer = require("fight.base.win").create()
  layer.addRewardIcons(l_1_0.reward)
  layer.addOkButton(function()
    require("fight.pve.loading").backToUI(video)
   end)
  if l_1_0.hurts and  l_1_0.hurts > 0 then
    local camp = {}
    local cfg = cfgstage[l_1_0.stage]
    for i,m in ipairs(cfg.monster) do
      camp[ camp + 1] = {kind = "mons", id = m, pos = cfg.stand[i]}
    end
    layer.addHurtsButton(l_1_0.camp, camp, l_1_0.hurts, l_1_0)
  end
  if l_1_0.preLv and l_1_0.curLv and l_1_0.preLv < l_1_0.curLv then
    schedule(layer, 2, function()
    showLevelUp(video.preLv, video.curLv, function()
      require("fight.pve.loading").backToTown(video)
      end)
   end)
  end
  return layer
end

return ui

