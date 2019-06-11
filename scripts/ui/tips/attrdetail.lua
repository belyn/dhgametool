-- Command line was: E:\github\dhgametool\scripts\ui\tips\attrdetail.lua 

local tips = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
tips.create = function(l_1_0)
  local layer = CCLayer:create()
  local width, height = 350, 380
  local board = img.createUI9Sprite(img.ui.tips_bg)
  board:setPreferredSize(CCSize(width, height))
  board:setPosition(210, 260)
  layer:addChild(board)
  local NAME = {"atk", "hp", "arm", "spd", "sklP", "hit", "miss", "crit", "critTime", "brk", "free", "decDmg", "trueAtk"}
  for i = 1, 13 do
    local name, val = buffString(NAME[i], l_1_0[NAME[i]], true)
    local showTitle = lbl.createFont1(18, name, ccc3(255, 246, 223))
    showTitle:setAnchorPoint(ccp(0, 0))
    showTitle:setPosition(40, height - i * 25 - 25)
    board:addChild(showTitle)
    local showVal = lbl.createFont1(18, val, ccc3(255, 246, 223))
    showVal:setAnchorPoint(ccp(1, 0))
    showVal:setPosition(width - 40, height - i * 25 - 25)
    board:addChild(showVal)
  end
  layer:registerScriptTouchHandler(function(l_1_0, l_1_1, l_1_2)
    if not board:boundingBox():containsPoint(layer:convertToNodeSpace(ccp(l_1_1, l_1_2))) then
      layer:removeFromParentAndCleanup(true)
    end
    return true
   end)
  layer:setTouchEnabled(true)
  return layer
end

return tips

