-- Command line was: E:\github\dhgametool\scripts\ui\casino\log.lua 

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
local player = require("data.player")
local i18n = require("res.i18n")
local space_height = 3
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local board = img.createUI9Sprite(img.ui.tips_bg)
  board:setPreferredSize(CCSizeMake(664, 416))
  board:setScale(view.minScale)
  board:setPosition(view.midX - 0 * view.minScale, view.midY)
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  board:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  board:runAction(CCSequence:create(anim_arr))
  local closeBtn0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(board_w - 23, board_h - 26)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  board:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    backEvent()
   end)
  local lbl_title = lbl.createFont1(24, i18n.global.casino_records.string, ccc3(255, 227, 134))
  lbl_title:setPosition(CCPoint(board_w / 2, board_h - 36))
  board:addChild(lbl_title)
  local tips_line = img.createUI9Sprite(img.ui.hero_tips_fgline)
  tips_line:setPreferredSize(CCSizeMake(594, 1))
  tips_line:setPosition(CCPoint(board_w / 2, board_h - 64))
  board:addChild(tips_line)
  local createItem = function(l_3_0)
    local msg_str = l_3_0.name .. " " .. i18n.global.casino_log_gain.string
    if l_3_0.type == 1 then
      msg_str = msg_str .. " " .. i18n.item[l_3_0.id].name
    elseif l_3_0.type == 2 then
      msg_str = msg_str .. " " .. i18n.equip[l_3_0.id].name
    end
    if l_3_0.count and l_3_0.count > 1 then
      msg_str = msg_str .. " x " .. l_3_0.count
    end
    local lbl_msg = lbl.createFontTTF(18, msg_str, ccc3(254, 235, 202))
    lbl_msg.height = lbl_msg:getContentSize().height
    return lbl_msg
   end
  local createScroll = function()
    local scroll_params = {width = 594, height = 300}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local showList = function(l_5_0)
    if not l_5_0 then
      local ui_empty = require("ui.empty").create({text = i18n.global.empty_reward.string, color = ccc3(255, 246, 223)})
      ui_empty:setPosition(CCPoint(317, 220))
      board:addChild(ui_empty)
      return 
    end
    board.scroll = nil
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(35, 35))
    board:addChild(scroll)
    board.scroll = scroll
    for ii = 1,  l_5_0 do
      local tmp_item = createItem(l_5_0[ii])
      tmp_item.ax = 0
      tmp_item.px = 0
      scroll.addItem(tmp_item)
      if ii ~=  l_5_0 then
        scroll.addSpace(space_height)
      end
    end
    scroll.setOffsetBegin()
   end
  showList(l_1_0)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  local touchbeginx, touchbeginy, isclick = nil, nil, nil
  local onTouchBegan = function(l_6_0, l_6_1)
    touchbeginx, upvalue_512 = l_6_0, l_6_1
    upvalue_1024 = true
    return true
   end
  local onTouchMoved = function(l_7_0, l_7_1)
    if isclick and (math.abs(touchbeginx - l_7_0) > 10 or math.abs(touchbeginy - l_7_1) > 10) then
      isclick = false
    end
   end
  local onTouchEnded = function(l_8_0, l_8_1)
    if isclick then
      local p0 = layer:convertToNodeSpace(ccp(l_8_0, l_8_1))
      if not board:boundingBox():containsPoint(p0) then
        backEvent()
        return 
      end
    end
   end
  local onTouch = function(l_9_0, l_9_1, l_9_2)
    if l_9_0 == "began" then
      return onTouchBegan(l_9_1, l_9_2)
    elseif l_9_0 == "moved" then
      return onTouchMoved(l_9_1, l_9_2)
    else
      return onTouchEnded(l_9_1, l_9_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
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
  layer:registerScriptHandler(function(l_13_0)
    if l_13_0 == "enter" then
      onEnter()
    elseif l_13_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

