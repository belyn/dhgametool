-- Command line was: E:\github\dhgametool\scripts\ui\selecthero\camp.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local cfgcamp = require("config.camp")
local BG_WIDTH = 666
local BG_HEIGHT = 415
local SCROLL_MARGIN_TOP = 70
local SCROLL_MARGIN_BOTTOM = 10
local SCROLL_VIEW_WIDTH = BG_WIDTH
local SCROLL_VIEW_HEIGHT = BG_HEIGHT - SCROLL_MARGIN_TOP - SCROLL_MARGIN_BOTTOM
ui.create = function()
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
  local title = lbl.createFont1(24, i18n.global.camp_buff_title.string, ccc3(255, 227, 134))
  title:setPosition(BG_WIDTH / 2, BG_HEIGHT - 36)
  bg:addChild(title)
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setViewSize(CCSize(SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT))
  scroll:setPosition(0, SCROLL_MARGIN_BOTTOM)
  bg:addChild(scroll)
  local height = nil
   -- DECOMPILER ERROR: Unhandled construct in list

   -- DECOMPILER ERROR: Unhandled construct in table

  local xy = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: unhandled table 

  for i =  {105, 12}, 105, -1 do
    local cfg = cfgcamp[i]
    local container = scroll:getContainer()
    local x, y = 44, 157 * ( cfgcamp + 1 - i)
    local icon = json.create(json.ui.campbuff[i])
    icon:playAnimation("animation", -1)
    icon:setScale(0.72)
    icon:setPosition(x + 28, y)
    container:addChild(icon)
    height = y + 53
    local box = img.createUI9Sprite(img.ui.tutorial_stand_info_bg)
    box:setPreferredSize(CCSize(495, 70))
    box:setAnchorPoint(ccp(0, 0.5))
    box:setPosition(x + 82, y)
    container:addChild(box)
    for j,b in ipairs(cfg.effect) do
      local n, v = buffString(b.type, b.num)
      local name = lbl.createMixFont1(16, n, ccc3(255, 217, 64))
      name:setAnchorPoint(ccp(0, 0.5))
      name:setPosition(x + xy[j][1], y + xy[j][2])
      xy = {}
      container:addChild(name)
      local value = lbl.createMixFont1(16, "+" .. v, ccc3(251, 251, 251))
      value:setAnchorPoint(ccp(0, 0.5))
      value:setPosition(name:boundingBox():getMaxX() + 20, y + xy[j][2])
      container:addChild(value)
    end
    local desc = lbl.createMix({font = 1, size = 16, text = i18n.global.camp_require_" .. .string, color = ccc3(254, 235, 202), width = 586, align = kCCTextAlignmentLeft})
    desc:setAnchorPoint(ccp(0, 1))
    desc:setPosition(x - 5, y - 50)
    container:addChild(desc)
  end
   -- DECOMPILER ERROR: unhandled table 

  scroll:setContentSize(CCSize(SCROLL_VIEW_WIDTH, height))
   -- DECOMPILER ERROR: unhandled table 

  scroll:setContentOffset(ccp(0, SCROLL_VIEW_HEIGHT - (height)))
   -- DECOMPILER ERROR: unhandled table 

  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParent()
   end
   -- DECOMPILER ERROR: unhandled table 

  layer:registerScriptHandler(function(l_3_0)
    if l_3_0 == "enter" then
      layer.notifyParentLock()
    elseif l_3_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
   -- DECOMPILER ERROR: unhandled table 

  layer:setTouchEnabled(true)
   -- DECOMPILER ERROR: unhandled table 

  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

