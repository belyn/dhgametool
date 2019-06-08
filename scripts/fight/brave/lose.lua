-- Command line was: E:\github\dhgametool\scripts\fight\brave\lose.lua 

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
  layer.addEnhanceGuide({backToSmith = function()
    require("fight.brave.loading").backToSmith(video)
   end, backToHero = function()
    require("fight.brave.loading").backToHero(video)
   end, backToSummon = function()
    require("fight.brave.loading").backToSummon(video)
   end})
  layer.addOkButton(function()
    require("fight.brave.loading").backToUI(video)
   end)
  if l_1_0.hurts and  l_1_0.hurts > 0 then
    layer.addHurtsButton(l_1_0.atk.camp, l_1_0.def.camp, l_1_0.hurts, l_1_0)
  end
  return layer
end

return ui

