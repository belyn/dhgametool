-- Command line was: E:\github\dhgametool\scripts\fight\pvpgmill\win.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local herosdata = require("data.heros")
ui.create = function(l_1_0)
  local layer = require("fight.base.win").create()
  layer.addOkButton(function()
    require("fight.pvpgmill.loading").backToUI(video)
   end)
  if l_1_0.rewards and #l_1_0.rewards > 0 then
    layer.addRewardIcons(l_1_0.rewards[1])
  end
  return layer
end

return ui

