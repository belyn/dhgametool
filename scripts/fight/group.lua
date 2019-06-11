-- Command line was: E:\github\dhgametool\scripts\fight\group.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local BG_WIDTH = 666
local BG_HEIGHT = 415
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setPreferredSize(CCSize(BG_WIDTH, BG_HEIGHT))
  bg:setScale(view.minScale * 0.1)
  bg:setAnchorPoint(ccp(0.5, 0.5))
  bg:setPosition(view.midX, view.midY)
  bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  layer:addChild(bg)
  local closeBtn0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(BG_WIDTH - 23, BG_HEIGHT - 26)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  bg:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer.onAndroidBack()
   end)
  local title = lbl.createFont1(24, i18n.global.fight_group_title.string, ccc3(255, 227, 134))
  title:setPosition(BG_WIDTH / 2, BG_HEIGHT - 36)
  bg:addChild(title)
  local line = img.createUISprite(img.ui.help_line)
  line:setScaleX(610 / line:getContentSize().width)
  line:setPosition(BG_WIDTH / 2, BG_HEIGHT - 64)
  bg:addChild(line)
  local text = CCSprite:create()
  text:setPosition(BG_WIDTH / 2, BG_HEIGHT - 100)
  bg:addChild(text)
  local textX = 0
  for i = 1, 5 do
    local l = nil
    if i == 2 or i == 4 then
      l = lbl.createMixFont1(18, i18n.global.fight_group_text" .. .string, ccc3(204, 255, 95))
    else
      l = lbl.createMixFont1(18, i18n.global.fight_group_text" .. .string, ccc3(254, 235, 202))
    end
    l:setAnchorPoint(ccp(0, 0.5))
    l:setPosition(textX, 5)
    text:addChild(l)
    textX = l:boundingBox():getMaxX()
  end
  text:setContentSize(textX, 10)
  local hintImage = img.createUISprite(img.ui.fight_group_help)
  hintImage:setAnchorPoint(ccp(0.5, 1))
  hintImage:setPosition(BG_WIDTH / 2, BG_HEIGHT - 155)
  bg:addChild(hintImage)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParent()
    if onClose then
      onClose()
    end
   end
  layer:registerScriptHandler(function(l_3_0)
    if l_3_0 == "enter" then
      layer.notifyParentLock()
    elseif l_3_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

