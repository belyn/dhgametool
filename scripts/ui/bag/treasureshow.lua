-- Command line was: E:\github\dhgametool\scripts\ui\bag\treasureshow.lua 

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
local player = require("data.player")
local bagdata = require("data.bag")
local hookdata = require("data.hook")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local ItemType = {Item = 1, Equip = 2}
ui.create = function()
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board_bg = img.createUI9Sprite(img.ui.dialog_1)
  board_bg:setPreferredSize(CCSizeMake(740, 491))
  board_bg:setScale(view.minScale)
  board_bg:setPosition(view.midX - 0 * view.minScale, view.midY)
  layer:addChild(board_bg)
  local board_bg_w = board_bg:getContentSize().width
  local board_bg_h = board_bg:getContentSize().height
  board_bg:setScale(0.5 * view.minScale)
  board_bg:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  local lbl_title = lbl.createFont1(24, i18n.global.bag_treasureshow_title.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 29))
  board_bg:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.bag_treasureshow_title.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 31))
  board_bg:addChild(lbl_title_shadowD)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local board = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  board:setPreferredSize(CCSizeMake(684, 337))
  board:setAnchorPoint(CCPoint(0.5, 0))
  board:setPosition(CCPoint(board_bg_w / 2, 84))
  board_bg:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(board_bg_w - 25, board_bg_h - 28))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  board_bg:addChild(btn_close_menu, 100)
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local SCROLL_VIEW_W = 650
  local SCROLL_VIEW_H = 315
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setViewSize(CCSize(SCROLL_VIEW_W, SCROLL_VIEW_H))
  scroll:setContentSize(CCSize(SCROLL_VIEW_W, SCROLL_VIEW_H))
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(25, 12))
  board:addChild(scroll)
  local content_layer = CCLayer:create()
  content_layer:setAnchorPoint(CCPoint(0, 0))
  content_layer:setPosition(CCPoint(0, 0))
  scroll:getContainer():addChild(content_layer)
  scroll.content_layer = content_layer
  local items = {}
  local item_offset_x = 46
  local item_offset_y = 54
  local item_step_x = 91
  local item_step_y = 95
  local row_count = 7
  local equips = {}
  local currentfilter = 0
  local compareTreasure = function(l_3_0, l_3_1)
    local qlt1, qlt2 = cfgequip[l_3_0.id].qlt, cfgequip[l_3_1.id].qlt
    if qlt1 < qlt2 then
      return true
    elseif qlt2 < qlt1 then
      return false
    end
    return l_3_0.id < l_3_1.id
   end
  for i = 5000, 6000 do
    if cfgequip[i] == nil then
      do return end
    end
    if cfgequip[i].treasureNext == nil then
      equips[#equips + 1] = cfgequip[i]
      equips[#equips].id = i
    end
  end
  table.sort(equips, compareTreasure)
  local showList = function(l_4_0)
    arrayclear(items)
    content_layer:removeAllChildrenWithCleanup(true)
    local height = 0
    local count = 0
    for ii = 1, #equips do
      if l_4_0 == 0 or l_4_0 == cfgequip[equips[ii].id].qlt then
        local tmp_item = img.createEquip(equips[ii].id)
        count = count + 1
        tmp_item.obj = equips[ii]
        local pos_x = item_offset_x + item_step_x * ((count - 1) % row_count)
        local pos_y = item_offset_y + item_step_y * (math.floor((count + row_count - 1) / row_count) - 1)
        tmp_item:setPosition(CCPoint(pos_x, 0 - pos_y))
        content_layer:addChild(tmp_item)
        items[#items + 1] = tmp_item
        height = pos_y + 47
      end
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
  showList(currentfilter)
  local onClickItem = function(l_5_0)
    layer:addChild(tipsequip.createById(l_5_0.obj.id), 100)
   end
  local orangeBatchbtn0 = img.createUISprite(img.ui.bag_btn_orange)
  local orangeBatchBtn = HHMenuItem:create(orangeBatchbtn0)
  orangeBatchBtn:setPosition(216, 50)
  local orangeBatchMenu = CCMenu:createWithItem(orangeBatchBtn)
  orangeBatchMenu:setPosition(0, 0)
  board_bg:addChild(orangeBatchMenu)
  local redBatchbtn0 = img.createUISprite(img.ui.bag_btn_red)
  local redBatchBtn = HHMenuItem:create(redBatchbtn0)
  redBatchBtn:setPosition(275, 50)
  local redBatchMenu = CCMenu:createWithItem(redBatchBtn)
  redBatchMenu:setPosition(0, 0)
  board_bg:addChild(redBatchMenu)
  local greenBatchbtn0 = img.createUISprite(img.ui.bag_btn_green)
  local greenBatchBtn = HHMenuItem:create(greenBatchbtn0)
  greenBatchBtn:setPosition(338, 50)
  local greenBatchMenu = CCMenu:createWithItem(greenBatchBtn)
  greenBatchMenu:setPosition(0, 0)
  board_bg:addChild(greenBatchMenu)
  local purpleBatchbtn0 = img.createUISprite(img.ui.bag_btn_purple)
  local purpleBatchBtn = HHMenuItem:create(purpleBatchbtn0)
  purpleBatchBtn:setPosition(400, 50)
  local purpleBatchMenu = CCMenu:createWithItem(purpleBatchBtn)
  purpleBatchMenu:setPosition(0, 0)
  board_bg:addChild(purpleBatchMenu)
  local yellowBatchbtn0 = img.createUISprite(img.ui.bag_btn_yellow)
  local yellowBatchBtn = HHMenuItem:create(yellowBatchbtn0)
  yellowBatchBtn:setPosition(462, 50)
  local yellowBatchMenu = CCMenu:createWithItem(yellowBatchBtn)
  yellowBatchMenu:setPosition(0, 0)
  board_bg:addChild(yellowBatchMenu)
  local blueBatchbtn0 = img.createUISprite(img.ui.bag_btn_blue)
  local blueBatchBtn = HHMenuItem:create(blueBatchbtn0)
  blueBatchBtn:setPosition(524, 50)
  local blueBatchMenu = CCMenu:createWithItem(blueBatchBtn)
  blueBatchMenu:setPosition(0, 0)
  board_bg:addChild(blueBatchMenu)
  local selectBatch = img.createUISprite(img.ui.bag_dianji)
  selectBatch:setPosition(-1000, -1000)
  board_bg:addChild(selectBatch)
  orangeBatchBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if currentfilter == 6 then
      upvalue_512 = 0
      selectBatch:setVisible(false)
      showList(currentfilter)
      return 
    end
    selectBatch:setVisible(true)
    selectBatch:setPosition(216, 52)
    upvalue_512 = 6
    showList(currentfilter)
   end)
  redBatchBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if currentfilter == 5 then
      upvalue_512 = 0
      selectBatch:setVisible(false)
      showList(currentfilter)
      return 
    end
    selectBatch:setVisible(true)
    selectBatch:setPosition(275, 52)
    upvalue_512 = 5
    showList(currentfilter)
   end)
  greenBatchBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if currentfilter == 4 then
      upvalue_512 = 0
      selectBatch:setVisible(false)
      showList(currentfilter)
      return 
    end
    selectBatch:setVisible(true)
    selectBatch:setPosition(338, 52)
    upvalue_512 = 4
    showList(currentfilter)
   end)
  purpleBatchBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if currentfilter == 3 then
      upvalue_512 = 0
      selectBatch:setVisible(false)
      showList(currentfilter)
      return 
    end
    selectBatch:setVisible(true)
    selectBatch:setPosition(400, 52)
    upvalue_512 = 3
    showList(currentfilter)
   end)
  yellowBatchBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if currentfilter == 2 then
      upvalue_512 = 0
      selectBatch:setVisible(false)
      showList(currentfilter)
      return 
    end
    selectBatch:setVisible(true)
    selectBatch:setPosition(462, 52)
    upvalue_512 = 2
    showList(currentfilter)
   end)
  blueBatchBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if currentfilter == 1 then
      upvalue_512 = 0
      selectBatch:setVisible(false)
      showList(currentfilter)
      return 
    end
    selectBatch:setVisible(true)
    selectBatch:setPosition(524, 52)
    upvalue_512 = 1
    showList(currentfilter)
   end)
  local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
  local onTouchBegan = function(l_12_0, l_12_1)
    touchbeginx, upvalue_512 = l_12_0, l_12_1
    upvalue_1024 = true
    if scroll and not tolua.isnull(scroll) then
      local p0 = content_layer:convertToNodeSpace(ccp(l_12_0, l_12_1))
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
  local onTouchMoved = function(l_13_0, l_13_1)
    if isclick and (math.abs(touchbeginx - l_13_0) > 10 or math.abs(touchbeginy - l_13_1) > 10) then
      isclick = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        playAnimTouchEnd(last_touch_sprite)
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_14_0, l_14_1)
    if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
      playAnimTouchEnd(last_touch_sprite)
      last_touch_sprite = nil
    end
    if isclick and scroll and not tolua.isnull(scroll) then
      local p0 = content_layer:convertToNodeSpace(ccp(l_14_0, l_14_1))
      for ii = 1, #items do
        if items[ii]:boundingBox():containsPoint(p0) then
          audio.play(audio.button)
          onClickItem(items[ii])
      else
        end
      end
    end
   end
  local onTouch = function(l_15_0, l_15_1, l_15_2)
    if l_15_0 == "began" then
      return onTouchBegan(l_15_1, l_15_2)
    elseif l_15_0 == "moved" then
      return onTouchMoved(l_15_1, l_15_2)
    else
      return onTouchEnded(l_15_1, l_15_2)
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
  layer:registerScriptHandler(function(l_19_0)
    if l_19_0 == "enter" then
      onEnter()
    elseif l_19_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

