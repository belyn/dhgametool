-- Command line was: E:\github\dhgametool\scripts\fight\brave\win.lua 

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
  local layer = require("fight.base.win").create()
  layer.addOkButton(function()
    require("fight.brave.loading").backToUI(video)
   end)
  if l_1_0.hurts and  l_1_0.hurts > 0 then
    layer.addHurtsButton(l_1_0.atk.camp, l_1_0.def.camp, l_1_0.hurts, l_1_0)
  end
  if l_1_0.rewards and l_1_0.select then
    layer:addChild(require("fight.pvp.lucky").create(l_1_0.rewards, l_1_0.select), 10)
  end
  do
    local equips, items = {}, {}
    for _,r in ipairs(l_1_0.reward) do
      if r.type == 1 then
        items[ items + 1] = {id = r.id, num = r.num}
        for _,r in (for generator) do
        end
        equips[ equips + 1] = {id = r.id, num = r.num}
      end
      layer.addRewardIcons({equips = equips, items = items})
      return layer
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return ui

