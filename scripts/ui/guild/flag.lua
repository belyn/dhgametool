-- Command line was: E:\github\dhgametool\scripts\ui\guild\flag.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local cfgguildflag = require("config.guildflag")
local gdata = require("data.guild")
local player = require("data.player")
local i18n = require("res.i18n")
ui.create = function(l_1_0, l_1_1)
  if not l_1_1 then
    l_1_1 = 0
  end
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local board = img.createUI9Sprite(img.ui.tips_bg)
  board:setPreferredSize(CCSizeMake(664, 414))
  board:setScale(view.minScale)
  board:setPosition(view.midX - 0 * view.minScale, view.midY)
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  board:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  board:runAction(CCSequence:create(anim_arr))
  local lbl_title = lbl.createFont1(22, i18n.global.guild_flag_select_flag.string, ccc3(255, 227, 134))
  lbl_title:setPosition(CCPoint(board_w / 2, board_h - 36))
  board:addChild(lbl_title)
  local line = img.createUISprite(img.ui.help_line)
  line:setScaleX(610 / line:getContentSize().width)
  line:setPosition(board_w / 2, board_h - 64)
  board:addChild(line)
  local SCROLL_VIEW_W = 540
  local SCROLL_VIEW_H = 268
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setViewSize(CCSize(SCROLL_VIEW_W, SCROLL_VIEW_H))
  scroll:setContentSize(CCSize(SCROLL_VIEW_W, SCROLL_VIEW_H))
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(62, 53))
  board:addChild(scroll)
  local content_layer = CCLayer:create()
  content_layer:setAnchorPoint(CCPoint(0, 0))
  content_layer:setPosition(CCPoint(0, 0))
  scroll:getContainer():addChild(content_layer)
  scroll.content_layer = content_layer
  local createItem = function(l_2_0)
    local item = img.createGFlag(l_2_0.resId)
    local item_sel = img.createUISprite(img.ui.guild_icon_sel)
    item_sel:setAnchorPoint(CCPoint(1, 0))
    item_sel:setPosition(CCPoint(item:getContentSize().width, 0))
    item:addChild(item_sel)
    item.sel = item_sel
    item_sel:setVisible(_sel_flag == l_2_0.resId)
    return item
   end
  local items = {}
  local item_offset_x = 38
  local item_offset_y = 36
  local item_step_x = 91
  local item_step_y = 96
  local row_count = 6
  local showList = function()
    arrayclear(items)
    content_layer:removeAllChildrenWithCleanup(true)
    local height = 0
    for ii = 1, #cfgguildflag do
      local tmp_item = createItem(cfgguildflag[ii])
      tmp_item.obj = cfgguildflag[ii]
      local pos_x = item_offset_x + item_step_x * ((ii - 1) % row_count)
      local pos_y = item_offset_y + item_step_y * (math.floor((ii + row_count - 1) / row_count) - 1)
      tmp_item:setPosition(CCPoint(pos_x, 0 - pos_y))
      content_layer:addChild(tmp_item)
      items[#items + 1] = tmp_item
      height = pos_y + 45
    end
    if height < SCROLL_VIEW_H then
      scroll:setContentSize(CCSizeMake(SCROLL_VIEW_W, SCROLL_VIEW_H))
      content_layer:setPosition(CCPoint(0, SCROLL_VIEW_H))
      scroll:setContentOffset(CCPoint(0, 0))
    else
      scroll:setContentSize(CCSizeMake(SCROLL_VIEW_W, height))
      content_layer:setPosition(CCPoint(0, height))
      scroll:setContentOffset(CCPoint(0, SCROLL_VIEW_H - (height)))
    end
   end
  showList()
  local onClickItem = function(l_4_0)
    audio.play(audio.button)
    if not l_4_0 or tolua.isnull(l_4_0) then
      return 
    end
    for ii = 1, #items do
      items[ii].sel:setVisible(false)
    end
    l_4_0.sel:setVisible(true)
    if callback then
      callback(l_4_0.obj.resId)
    end
    layer:removeFromParentAndCleanup(true)
   end
  local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
  local onTouchBegan = function(l_5_0, l_5_1)
    touchbeginx, upvalue_512 = l_5_0, l_5_1
    upvalue_1024 = true
    if scroll and not tolua.isnull(scroll) then
      local p0 = content_layer:convertToNodeSpace(ccp(l_5_0, l_5_1))
      for ii = 1, #items do
        if items[ii]:boundingBox():containsPoint(p0) then
          playAnimTouchBegin(items[ii])
          upvalue_3072 = items[ii]
      else
        end
      end
    end
    return true
   end
  local onTouchMoved = function(l_6_0, l_6_1)
    if isclick and (math.abs(touchbeginx - l_6_0) > 10 or math.abs(touchbeginy - l_6_1) > 10) then
      isclick = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        playAnimTouchEnd(last_touch_sprite)
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_7_0, l_7_1)
    if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
      playAnimTouchEnd(last_touch_sprite)
      last_touch_sprite = nil
    end
    if isclick then
      local p0 = layer:convertToNodeSpace(ccp(l_7_0, l_7_1))
      if not board:boundingBox():containsPoint(p0) then
        backEvent()
        return 
      end
    end
    if isclick and scroll and not tolua.isnull(scroll) then
      local p0 = content_layer:convertToNodeSpace(ccp(l_7_0, l_7_1))
      for ii = 1, #items do
        if items[ii]:boundingBox():containsPoint(p0) then
          audio.play(audio.button)
          onClickItem(items[ii])
      else
        end
      end
    end
   end
  local onTouch = function(l_8_0, l_8_1, l_8_2)
    if l_8_0 == "began" then
      return onTouchBegan(l_8_1, l_8_2)
    elseif l_8_0 == "moved" then
      return onTouchMoved(l_8_1, l_8_2)
    else
      return onTouchEnded(l_8_1, l_8_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    backEvent()
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_12_0)
    if l_12_0 == "enter" then
      onEnter()
    elseif l_12_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

