-- Command line was: E:\github\dhgametool\scripts\fight\pvpgmill\lose.lua 

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
    require("fight.pvpgmill.loading").backToSmith(video)
   end, backToHero = function()
    require("fight.pvpgmill.loading").backToHero(video)
   end, backToSummon = function()
    require("fight.pvpgmill.loading").backToSummon(video)
   end})
  layer.addOkButton(function()
    require("fight.pvpgmill.loading").backToUI(video)
   end)
  return layer
end

return ui

