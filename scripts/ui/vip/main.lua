-- Command line was: E:\github\dhgametool\scripts\ui\vip\main.lua 

local ui = {}
require("common.func")
require("common.const")
local img = require("res.img")
local json = require("res.json")
local view = require("common.view")
local audio = require("res.audio")
local res = {}
ui.create = function()
  if device.platform == "ios" then
    res[ res + 1] = img.packedOthers.ui_vip_subscribe
  end
  res[ res + 1] = img.packedOthers.ui_vip_mcard
  res[ res + 1] = img.packedOthers.ui_vip_minicard
  img.loadAll(res)
  local layer = CCLayer:create()
  local darkBg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkBg)
  local tabViews = {}
  local circleDots = {}
  local currentTab = 1
  local selectTab = nil
  local createTabViews = function()
    if device.platform == "ios" then
      tabViews[ tabViews + 1] = require("ui.vip.subscribe").create()
    end
    tabViews[ tabViews + 1] = require("ui.vip.mcard").create()
    tabViews[ tabViews + 1] = require("ui.vip.minicard").create()
    for i = 1,  tabViews do
      layer:addChild(tabViews[i])
    end
   end
  local createCircleDotView = function()
    if  tabViews <= 1 then
      return 
    end
    local containerWidth = ( tabViews - 1) * 30 + 24
    local circleDotContainer = CCSprite:create()
    circleDotContainer:setColor(ccc3(255, 0, 0))
    circleDotContainer:setContentSize(containerWidth, 24)
    circleDotContainer:setScale(view.minScale)
    for i = 1,  tabViews do
      local circleDark = img.createUISprite(img.ui.shop_circle_dark)
      circleDark:setPosition(12 + (i - 1) * 30, 12)
      circleDotContainer:addChild(circleDark, 10000)
      circleDark.select = function(l_1_0)
        local circleLight = img.createUISprite(img.ui.shop_circle_light)
        circleLight:setPosition(l_1_0:getContentSize().width / 2, l_1_0:getContentSize().height / 2)
        l_1_0:addChild(circleLight, 10000)
         end
      circleDark.unSelect = function(l_2_0)
        l_2_0:removeAllChildrenWithCleanup(true)
         end
      circleDots[ circleDots + 1] = circleDark
    end
    circleDotContainer:setPosition(view.midX, view.midY - view.minScale * 253)
    layer:addChild(circleDotContainer)
   end
  local leftBg = img.createUISprite(img.ui.hero_raw)
  local left = SpineMenuItem:create(json.ui.button, leftBg)
  left:setPosition(scalex(57), view.midY)
  left:setScale(view.minScale)
  left:registerScriptTapHandler(function()
    audio.play(audio.button)
    selectTab(currentTab - 1)
   end)
  local leftMenu = CCMenu:createWithItem(left)
  leftMenu:setPosition(0, 0)
  layer:addChild(leftMenu, 1000)
  local rightBg = img.createUISprite(img.ui.hero_raw)
  rightBg:setFlipX(true)
  local right = SpineMenuItem:create(json.ui.button, rightBg)
  right:setPosition(view.physical.w - scalex(57), view.midY)
  right:setScale(view.minScale)
  right:registerScriptTapHandler(function()
    audio.play(audio.button)
    selectTab(currentTab + 1)
   end)
  local rightMenu = CCMenu:createWithItem(right)
  rightMenu:setPosition(0, 0)
  layer:addChild(rightMenu, 1000)
  selectTab = function(l_5_0)
    if l_5_0 <= 0 or  tabViews < l_5_0 then
      return 
    end
    upvalue_512 = l_5_0
    if l_5_0 == 1 then
      left:setVisible(false)
    else
      left:setVisible(true)
    end
    if l_5_0 ==  tabViews then
      right:setVisible(false)
    else
      right:setVisible(true)
    end
    for i = 1,  tabViews do
      tabViews[i]:setVisible(i == l_5_0)
    end
    for i = 1,  circleDots do
      if i == l_5_0 then
        circleDots[i]:select()
      else
        circleDots[i]:unSelect()
      end
    end
   end
  createTabViews()
  createCircleDotView()
  selectTab(1)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParent()
   end
  local onTouchEnd = function(l_7_0, l_7_1)
    local rect = CCRectMake(view.midX - 345 * view.minScale, view.midY - 218 * view.minScale, 690 * view.minScale, 436 * view.minScale)
    if not rect:containsPoint(CCPointMake(l_7_0, l_7_1)) then
      layer:removeFromParentAndCleanup(true)
    end
    return true
   end
  local onTouch = function(l_8_0, l_8_1, l_8_2)
    if l_8_0 == "began" then
      return true
    elseif l_8_0 == "moved" then
      return true
    else
      return onTouchEnd(l_8_1, l_8_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:registerScriptHandler(function(l_9_0)
    if l_9_0 == "enter" then
      layer.notifyParentLock()
    elseif l_9_0 == "exit" then
      layer.notifyParentUnlock()
    elseif l_9_0 == "cleanup" then
      img.unloadAll(res)
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

