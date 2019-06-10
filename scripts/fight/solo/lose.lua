-- Command line was: E:\github\dhgametool\scripts\fight\solo\lose.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
ui.create = function(l_1_0)
  local layer = require("fight.base.lose").create()
  l_1_0.noscore = true
  require("fight.solo.win").addVsInfo(layer, l_1_0)
  layer.addOkButton(function()
    if video.auto then
      require("fight.solo.win").backToUI(layer, video)
    else
      require("fight.solo.loading").backToUI(video)
    end
   end)
  if l_1_0.hurts and #l_1_0.hurts > 0 then
    layer.addHurtsButton(l_1_0.atk.camp, l_1_0.def.camp, l_1_0.hurts, l_1_0)
  end
  return layer
end

return ui

