-- Command line was: E:\github\dhgametool\scripts\ui\tips\itemlist.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local BG_WIDTH = 666
local BG_HEIGHT = 415
local SCROLL_MARGIN_TOP = 70
local SCROLL_MARGIN_BOTTOM = 10
local SCROLL_VIEW_WIDTH = BG_WIDTH
local SCROLL_VIEW_HEIGHT = BG_HEIGHT - SCROLL_MARGIN_TOP - SCROLL_MARGIN_BOTTOM
ui.heroFunc = function(l_1_0)
  local cfghero = require("config.hero")
  local headBg = img.createUISprite(img.ui.herolist_head_bg)
  local item_w = headBg:getContentSize().width
  local item_h = headBg:getContentSize().height
  local headIcon = img.createHeroHeadIcon(l_1_0)
  headIcon:setPosition(CCPoint(item_w / 2, item_h / 2))
  headBg:addChild(headIcon)
  local groupBg = img.createUISprite(img.ui.herolist_group_bg)
  groupBg:setScale(0.42)
  groupBg:setPosition(CCPoint(16, item_h - 16))
  headBg:addChild(groupBg)
  local groupIcon = img.createUISprite(img.ui.herolist_group_" .. cfghero[l_1_0].grou)
  groupIcon:setPosition(CCPoint(groupBg:getContentSize().width / 2, groupBg:getContentSize().height / 2))
  groupBg:addChild(groupIcon)
  local groupIcon = img.createUISprite(img.ui.herolist_group_" .. cfghero[l_1_0].grou)
  local qlt = 5
  if qlt <= 5 then
    for i = qlt, 1, -1 do
      local star = img.createUISprite(img.ui.star_s)
      star:setPosition(46 + (i - (qlt + 1) / 2) * 12, 16)
      headBg:addChild(star)
    end
  end
  return headBg
end

ui.create = function(l_2_0, l_2_1, l_2_2)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  img.loadAll(img.packedLogin.common)
  local bg = img.createLogin9Sprite(img.login.tips_bg)
  bg:setPreferredSize(CCSize(BG_WIDTH, BG_HEIGHT))
  bg:setScale(view.minScale * 0.1)
  bg:setAnchorPoint(ccp(0.5, 0.5))
  bg:setPosition(view.midX, view.midY)
  bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  layer:addChild(bg)
  local closeBtn0 = img.createLoginSprite(img.login.button_close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(BG_WIDTH - 23, BG_HEIGHT - 26)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  bg:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer.onAndroidBack()
   end)
  if not l_2_1 then
    l_2_1 = i18n.global.help_title.string
  end
  local titleLabel = lbl.createMixFont1(24, l_2_1, ccc3(255, 227, 134))
  titleLabel:setPosition(BG_WIDTH / 2, BG_HEIGHT - 36)
  bg:addChild(titleLabel)
  local line = img.createLoginSprite(img.login.help_line)
  line:setScaleX(610 / line:getContentSize().width)
  line:setPosition(BG_WIDTH / 2, BG_HEIGHT - 64)
  bg:addChild(line)
  local lineScroll = require("ui.lineScroll")
  local scroll = lineScroll.create({width = SCROLL_VIEW_WIDTH, height = SCROLL_VIEW_HEIGHT})
  scroll:setPosition(0, SCROLL_MARGIN_BOTTOM)
  bg:addChild(scroll)
  local cols = 6
  local item_w, item_h = 104, 106
  local start_x, start_y = 71, -56
  local pos_x, pos_y = 0, 0
  local content_h = start_y - math.floor(( l_2_0 + cols - 1) / cols) * item_h
  for ii = 1,  l_2_0 do
    local row_idx = math.floor((ii + cols - 1) / cols)
    local col_idx = (ii - 1) % 6 + 1
    pos_x = start_x + (col_idx - 1) * item_w
    pos_y = start_y - (row_idx - 1) * item_h
    local item = l_2_2(l_2_0[ii])
    item:setPosition(CCPoint(pos_x, pos_y))
    scroll.content_layer:addChild(item)
  end
  scroll.cur_height = 0 - content_h
  scroll.addSpace(0)
  scroll.setOffsetBegin()
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParent()
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

