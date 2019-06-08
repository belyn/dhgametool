-- Command line was: E:\github\dhgametool\scripts\ui\tips\confirm.lua 

local tips = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
tips.create = function(l_1_0)
  local layer = CCLayer:create()
  local drak = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(drak)
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(508, 318))
  if l_1_0.scale == false then
    board:setPosition(480, 288)
    drak:ignoreAnchorPointForPosition(false)
    drak:setPosition(480, 288)
    drak:setScale(drak:getScale() / view.minScale)
  else
    board:setScale(view.minScale)
    board:setPosition(view.midX, view.midY)
  end
  layer:addChild(board)
  local showTitle = lbl.createFont1(26, l_1_0.title or "", ccc3(230, 208, 174))
  showTitle:setPosition(board:getContentSize().width / 2, 290)
  board:addChild(showTitle, 1)
  local showTitleShade = lbl.createFont1(26, l_1_0.title or "", ccc3(89, 48, 27))
  showTitleShade:setPosition(board:getContentSize().width / 2, 288)
  board:addChild(showTitleShade)
  local showText = lbl.createMix({font = 1, size = 18, text = l_1_0.text or "", color = ccc3(120, 70, 39), width = 450, align = kCCTextAlignmentLeft})
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
showText = lbl.createMixFont1(18, showText:boundingBox().size.height > 25 or "", ccc3(120, 70, 39))
showText:setAnchorPoint(ccp(0.5, 1))
showText:setPosition(board:getContentSize().width / 2, 218)
board:addChild(showText)
local btnYesSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
btnYesSprite:setPreferredSize(CCSize(165, 50))
local btnYes = SpineMenuItem:create(json.ui.button, btnYesSprite)
local menuYes = CCMenu:createWithItem(btnYes)
menuYes:setPosition(0, 0)
board:addChild(menuYes)
btnYes:setPosition(358, 87)
local labYes = lbl.createFont1(18, i18n.global.board_confirm_yes.string, lbl.buttonColor)
labYes:setPosition(btnYes:getContentSize().width / 2, btnYes:getContentSize().height / 2)
btnYes:addChild(labYes)
local btnNoSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
btnNoSprite:setPreferredSize(CCSize(165, 50))
local btnNo = SpineMenuItem:create(json.ui.button, btnNoSprite)
local menuNo = CCMenu:createWithItem(btnNo)
menuNo:setPosition(0, 0)
board:addChild(menuNo)
btnNo:setPosition(150, 87)
local labNo = lbl.createFont1(18, i18n.global.board_confirm_no.string, lbl.buttonColor)
labNo:setPosition(btnNo:getContentSize().width / 2, btnNo:getContentSize().height / 2)
btnNo:addChild(labNo)
btnYes:registerScriptTapHandler(function()
  audio.play(audio.button)
  if params.handle then
    params.handle()
  end
  layer:removeFromParentAndCleanup(true)
end
)
btnNo:registerScriptTapHandler(function()
  audio.play(audio.button)
  layer:removeFromParentAndCleanup(true)
end
)
layer:registerScriptTouchHandler(function()
  return true
end
)
layer:setTouchEnabled(true)
addBackEvent(layer)
layer.onAndroidBack = function()
  layer:removeFromParentAndCleanup(true)
end

local onEnter = function()
  print("onEnter")
  layer.notifyParentLock()
end

local onExit = function()
  layer.notifyParentUnlock()
end

layer:registerScriptHandler(function(l_7_0)
  if l_7_0 == "enter" then
    onEnter()
  elseif l_7_0 == "exit" then
    onExit()
  end
end
)
return layer
end

return tips

