-- Command line was: E:\github\dhgametool\scripts\ui\setting\fix.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local userdata = require("data.userdata")
ui.create = function()
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 204))
  local d = 100
  local minX = 0
  local maxX = scalex(d)
  local offset = userdata.getInt(userdata.keys.fix_bar_offset, 0)
  local bg2 = img.createUI9Sprite(img.ui.ui_fix_bar_bg_2)
  bg2:setPreferredSize(CCSizeMake(scalex(106 + d), view.physical.h))
  bg2:setAnchorPoint(0, 0)
  bg2:setPosition(0, 0)
  layer:addChild(bg2)
  local bg1 = img.createUI9Sprite(img.ui.ui_fix_bar_bg_1)
  bg1:setPreferredSize(CCSizeMake(106 * view.minScale, view.physical.h))
  bg1:setPosition(offset, 0)
  bg1:setAnchorPoint(0, 0)
  layer:addChild(bg1)
  local top = img.createUISprite(img.ui.ui_fix_bar_top)
  top:setAnchorPoint(CCPointMake(0, 1))
  top:setPosition(0 + offset, view.physical.h)
  top:setScale(view.minScale)
  layer:addChild(top)
  local center = img.createUISprite(img.ui.ui_fix_bar_center)
  center:setAnchorPoint(CCPointMake(0, 0.5))
  center:setPosition(0 + offset, view.midY)
  center:setScale(view.minScale)
  layer:addChild(center)
  local bottom = img.createUISprite(img.ui.ui_fix_bar_bottom)
  bottom:setAnchorPoint(CCPointMake(0, 0))
  bottom:setPosition(0 + offset, 0)
  center:setScale(view.minScale)
  layer:addChild(bottom)
  local text = lbl.createFont1(18, i18n.global.fix_bar_text.string, ccc3(255, 255, 255))
  text:setScale(view.minScale)
  text:setPosition(view.midX, view.midY)
  layer:addChild(text)
  local raw = img.createUISprite(img.ui.hero_btn_raw)
  raw:setScale(view.minScale)
  raw:setAnchorPoint(0, 0.5)
  raw:setPosition(132 * view.minScale + offset, view.midY)
  layer:addChild(raw)
  local cancelBg = img.createUI9Sprite(img.ui.btn_1)
  cancelBg:setPreferredSize(CCSizeMake(154, 57))
  local cancelLabel = lbl.createFont1(16, i18n.global.dialog_button_cancel.string, ccc3(115, 59, 5))
  cancelLabel:setPosition(CCPoint(cancelBg:getContentSize().width / 2, cancelBg:getContentSize().height / 2))
  cancelBg:addChild(cancelLabel)
  local cancel = SpineMenuItem:create(json.ui.button, cancelBg)
  cancel:setPosition(CCPointMake(view.midX - 14 * view.minScale, scaley(34)))
  cancel:setAnchorPoint(1, 0)
  cancel:setScale(view.minScale)
  cancel:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local cancelMenu = CCMenu:createWithItem(cancel)
  cancelMenu:setPosition(CCPoint(0, 0))
  layer:addChild(cancelMenu)
  local okBg = img.createUI9Sprite(img.ui.btn_7)
  okBg:setPreferredSize(CCSizeMake(154, 57))
  local okLabel = lbl.createFont1(16, i18n.global.dialog_button_confirm.string, ccc3(37, 107, 6))
  okLabel:setPosition(CCPoint(okBg:getContentSize().width / 2, okBg:getContentSize().height / 2))
  okBg:addChild(okLabel)
  local ok = SpineMenuItem:create(json.ui.button, okBg)
  ok:setPosition(CCPointMake(view.midX + 14 * view.minScale, scaley(34)))
  ok:setAnchorPoint(0, 0)
  ok:setScale(view.minScale)
  ok:registerScriptTapHandler(function()
    audio.play(audio.button)
    if bg1:getPositionX() < minX then
      layer:removeFromParentAndCleanup(true)
      return 
    end
    if maxX < bg1:getPositionX() then
      layer:removeFromParentAndCleanup(true)
      return 
    end
    local offset = bg1:getPositionX() - minX
    userdata.setInt(userdata.keys.fix_bar_offset, offset)
    view.safeOffset = offset
    replaceScene(require("ui.town.main").create())
   end)
  local okMenu = CCMenu:createWithItem(ok)
  okMenu:setPosition(CCPoint(0, 0))
  layer:addChild(okMenu)
  local touchX = 0
  local onTouch = function(l_3_0, l_3_1, l_3_2)
    if l_3_0 == "began" then
      touchX = l_3_1
      return true
    elseif l_3_0 == "moved" then
      local move = (l_3_1 - touchX) * 0.6
      touchX = l_3_1
      local posX = bg1:getPositionX() + move
      if minX <= posX and posX <= maxX then
        top:setPositionX(top:getPositionX() + move)
        center:setPositionX(center:getPositionX() + move)
        bottom:setPositionX(bottom:getPositionX() + move)
        raw:setPositionX(raw:getPositionX() + move)
        bg1:setPositionX(bg1:getPositionX() + move)
      elseif l_3_0 == "ended" then
        touchX = 0
      end
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

