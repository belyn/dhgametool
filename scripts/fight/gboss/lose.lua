-- Command line was: E:\github\dhgametool\scripts\fight\gboss\lose.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local cfggboss = require("config.guildboss")
ui.create = function(l_1_0)
  local layer = require("fight.base.lose").create()
  local cfg = cfggboss[l_1_0.boss]
  layer.addOkButton(function()
    require("fight.gboss.loading").backToUI(video)
   end)
  if l_1_0.hurts and  l_1_0.hurts > 0 then
    local camp = {}
    for i,m in ipairs(cfg.monster) do
      camp[ camp + 1] = {kind = "mons", id = m, pos = cfg.stand[i]}
    end
    layer.addHurtsButton(l_1_0.camp, camp, l_1_0.hurts, l_1_0)
    layer.addHurtsSum(l_1_0.hurts)
  end
  do
    local equips, items = {}, {}
    for _,r in ipairs(cfg.reward) do
      if r.type == 1 then
        items[ items + 1] = {id = r.id, num = r.num}
        for _,r in (for generator) do
        end
        equips[ equips + 1] = {id = r.id, num = r.num}
      end
      layer.addRewardIcons({equips = equips, items = items}, true)
      return layer
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return ui

