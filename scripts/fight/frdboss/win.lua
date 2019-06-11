-- Command line was: E:\github\dhgametool\scripts\fight\frdboss\win.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local cfgfrdstage = require("config.friendstage")
ui.create = function(l_1_0)
  local layer = require("fight.base.win").create()
  local cfg = cfgfrdstage[l_1_0.stage]
  layer.addOkButton(function()
    require("fight.frdboss.loading").backToUI(video)
   end)
  if l_1_0.hurts and #l_1_0.hurts > 0 then
    local camp = {}
    for i,m in ipairs(cfg.monster) do
      camp[#camp + 1] = {kind = "mons", id = m, pos = cfg.stand[i]}
    end
    layer.addHurtsButton(l_1_0.camp, camp, l_1_0.hurts, l_1_0)
    ui.addScoreAndHurtsSum(layer, l_1_0.hurts, cfg)
  end
  if l_1_0.rewards and l_1_0.select then
    layer:addChild(require("fight.pvp.lucky").create(l_1_0.rewards, l_1_0.select), 10)
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
  local text1 = lbl.createFont2(18, i18n.global.fight_pvp_score.string .. ":", ccc3(252, 215, 117), true)
  text1:setAnchorPoint(ccp(1, 0.5))
  text1:setPosition(scalep(480, 320))
  l_2_0.content:addChild(text1)
  local num1 = lbl.createFont2(18, "+" .. math.ceil((value) / l_2_2.coefficient), lbl.whiteColor, true)
  num1:setAnchorPoint(ccp(0, 0.5))
  num1:setPosition(scalep(490, 320))
  l_2_0.content:addChild(num1)
  local text2 = lbl.createFont2(18, i18n.global.fight_hurts_sum.string .. ":", ccc3(252, 215, 117), true)
  text2:setAnchorPoint(ccp(1, 0.5))
  text2:setPosition(scalep(480, 280))
  l_2_0.content:addChild(text2)
  local num2 = lbl.createFont2(18, value, lbl.whiteColor, true)
  num2:setAnchorPoint(ccp(0, 0.5))
  num2:setPosition(scalep(490, 280))
  l_2_0.content:addChild(num2)
end

return ui

