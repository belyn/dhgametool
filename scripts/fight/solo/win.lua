-- Command line was: E:\github\dhgametool\scripts\fight\solo\win.lua 

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
  l_1_0.noscore = true
  ui.addVsInfo(layer, l_1_0)
  layer.addOkButton(function()
    if video.auto then
      ui.backToUI(layer, video)
    else
      require("fight.solo.loading").backToUI(video)
    end
   end)
  if l_1_0.hurts and #l_1_0.hurts > 0 then
    layer.addHurtsButton(l_1_0.atk.camp, l_1_0.def.camp, l_1_0.hurts, l_1_0)
  end
  return layer
end

ui.addVsInfo = function(l_2_0, l_2_1)
  local vs = img.createUISprite(img.ui.fight_pay_vs)
  vs:setScale(view.minScale)
  vs:setPosition(scalep(480, 300))
  l_2_0.content:addChild(vs)
  local addInfo = function(l_1_0, l_1_1, l_1_2, l_1_3)
    local y = 303
    local head = img.createHeroHead(l_1_0.id, l_1_0.lv, l_1_0.group, l_1_0.star, l_1_0.wake)
    head:setScale(view.minScale)
    head:setPosition(scalep(l_1_3, y))
    head:setCascadeOpacityEnabled(true)
    layer.content:addChild(head, 1)
    if l_1_1 and not l_1_2 then
      setShader(head, SHADER_GRAY, true)
    elseif not l_1_1 and l_1_2 then
      setShader(head, SHADER_GRAY, true)
    end
   end
  addInfo(l_2_1.atk.camp[1], l_2_1.win, true, 330)
  addInfo(l_2_1.def.camp[1], l_2_1.win, false, 630)
end

ui.backToUI = function(l_3_0, l_3_1)
  l_3_0:removeFromParentAndCleanup(true)
  if l_3_1.callback then
    l_3_1.callback()
  end
end

return ui

