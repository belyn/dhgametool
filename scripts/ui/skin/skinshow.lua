-- Command line was: E:\github\dhgametool\scripts\ui\skin\skinshow.lua 

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
local cfgstage = require("config.stage")
local cfghero = require("config.hero")
local player = require("data.player")
local bagdata = require("data.bag")
local hookdata = require("data.hook")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local tipshero = require("ui.tips.hero")
local ItemType = {Item = 1, Equip = 2}
ui.create = function(l_1_0, l_1_1)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board_bg = img.createUI9Sprite(img.ui.dialog_1)
  board_bg:setPreferredSize(CCSizeMake(645, 486))
  board_bg:setScale(view.minScale)
  board_bg:setPosition(view.midX - 0 * view.minScale, view.midY)
  layer:addChild(board_bg)
  local board_bg_w = board_bg:getContentSize().width
  local board_bg_h = board_bg:getContentSize().height
  board_bg:setScale(0.5 * view.minScale)
  board_bg:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  if not l_1_1 then
    l_1_1 = i18n.global.hook_drop_board_title.string
  end
  local lbl_title = lbl.createFont1(24, l_1_1, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 29))
  board_bg:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, l_1_1, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 31))
  board_bg:addChild(lbl_title_shadowD)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local board = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  board:setPreferredSize(CCSizeMake(594, 334))
  board:setAnchorPoint(CCPoint(0.5, 0))
  board:setPosition(CCPoint(board_bg_w / 2, 92))
  board_bg:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local btn_hook0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_hook0:setPreferredSize(CCSizeMake(158, 54))
  local closeText = i18n.global.dialog_button_confirm.string
  local lbl_btn_hook = lbl.createFont1(22, closeText, ccc3(115, 59, 5))
  lbl_btn_hook:setPosition(CCPoint(btn_hook0:getContentSize().width / 2, btn_hook0:getContentSize().height / 2))
  btn_hook0:addChild(lbl_btn_hook)
  local btn_hook = SpineMenuItem:create(json.ui.button, btn_hook0)
  btn_hook:setPosition(CCPoint(board_bg_w / 2, 53))
  local btn_hook_menu = CCMenu:createWithItem(btn_hook)
  btn_hook_menu:setPosition(CCPoint(0, 0))
  board_bg:addChild(btn_hook_menu)
  local SCROLL_VIEW_W = 545
  local SCROLL_VIEW_H = 306
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setViewSize(CCSize(SCROLL_VIEW_W, SCROLL_VIEW_H))
  scroll:setContentSize(CCSize(SCROLL_VIEW_W, SCROLL_VIEW_H))
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(25, 15))
  board:addChild(scroll)
  local content_layer = CCLayer:create()
  content_layer:setAnchorPoint(CCPoint(0, 0))
  content_layer:setPosition(CCPoint(0, 0))
  scroll:getContainer():addChild(content_layer)
  scroll.content_layer = content_layer
  local createItem = function(l_2_0)
    return img.createHeroHead(l_2_0.id, 1, true, true)
   end
  local items = {}
  local item_offset_x = 56
  local item_offset_y = 87
  local item_step_x = 140
  local item_step_y = 174
  local row_count = 4
  local showList = function()
    arrayclear(items)
    content_layer:removeAllChildrenWithCleanup(true)
    local height = 0
    local showbag = _bag
    for ii = 1,  showbag do
      local tmp_item = img.createSkinIcon(showbag[ii].id)
      tmp_item.obj = showbag[ii]
      local pos_x = item_offset_x + item_step_x * ((ii - 1) % row_count)
      local pos_y = item_offset_y + item_step_y * (math.floor((ii + row_count - 1) / row_count) - 1)
      tmp_item:setScale(0.7)
      tmp_item:setPosition(CCPoint(pos_x, 0 - pos_y))
      content_layer:addChild(tmp_item)
      items[ items + 1] = tmp_item
      local framBg = nil
      if cfgequip[showbag[ii].id].powerful and cfgequip[showbag[ii].id].powerful == 1 then
        framBg = img.createUISprite(img.ui.skin_frame_sp)
      else
        framBg = img.createUISprite(img.ui.skin_frame)
      end
      framBg:setScale(0.7)
      framBg:setPosition(pos_x, 0 - pos_y)
      content_layer:addChild(framBg, 1)
      local groupBg = img.createUISprite(img.ui.skin_circle)
      groupBg:setPosition(pos_x - 43, 0 - pos_y + 61)
      content_layer:addChild(groupBg, 1)
      local groupIcon = img.createUISprite(img.ui.herolist_group_" .. cfghero[cfgequip[showbag[ii].id].heroId[1]].grou)
      groupIcon:setScale(0.48)
      groupIcon:setPosition(pos_x - 43, 0 - pos_y + 61)
      content_layer:addChild(groupIcon, 1)
      height = pos_y + 100
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
    layer:addChild(require("ui.skin.preview").create(l_4_0.obj.id, i18n.equip[l_4_0.obj.id].name), 10000)
   end
  local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
  local onTouchBegan = function(l_5_0, l_5_1)
    touchbeginx, upvalue_512 = l_5_0, l_5_1
    upvalue_1024 = true
    if scroll and not tolua.isnull(scroll) then
      local p0 = content_layer:convertToNodeSpace(ccp(l_5_0, l_5_1))
      for ii = 1,  items do
        if items[ii]:boundingBox():containsPoint(p0) then
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
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_7_0, l_7_1)
    if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
      last_touch_sprite = nil
    end
    if isclick and scroll and not tolua.isnull(scroll) then
      local p0 = content_layer:convertToNodeSpace(ccp(l_7_0, l_7_1))
      for ii = 1,  items do
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
  btn_hook:registerScriptTapHandler(function()
    backEvent()
   end)
  return layer
end

return ui

