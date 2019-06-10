-- Command line was: E:\github\dhgametool\scripts\ui\dialog.lua 

local dialog = {}
require("common.func")
local view = require("common.view")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
dialog.TAG = 123333
dialog.COLOR_BLUE = "blue"
dialog.COLOR_GOLD = "gold"
dialog.COLOR_RED = "red"
dialog.COLOR_GREEN = "green"
local btn_pos = {1 = {1 = {x = 180, y = 55}}, 2 = {1 = {x = 86, y = 55}, 2 = {x = 273, y = 55}}, 3 = {1 = {x = 52, y = 55}, 2 = {x = 180, y = 55}, 3 = {x = 308, y = 55}}}
local btn_blue = img.login.button_9_small_gold
local btn_gold = img.login.button_9_small_gold
local btn_red = img.login.button_9_small_gold
local btn_green = img.login.button_9_small_green
local init_params = function(l_1_0)
  l_1_0.title = l_1_0.title or ""
  l_1_0.body = l_1_0.body or ""
  if not l_1_0.text_color then
    l_1_0.text_color = ccc3(99, 52, 24)
  end
  l_1_0.text_fontsize = l_1_0.text_fontsize or 20
  l_1_0.board_w = l_1_0.board_w or 474
  l_1_0.board_h = l_1_0.board_h or 327
  if not l_1_0.btn_color then
    l_1_0.btn_color = {}
    for ii = 1, l_1_0.btn_count do
      l_1_0.btn_color[ii] = "gold"
    end
  end
end

dialog.create = function(l_2_0, l_2_1)
  init_params(l_2_0)
  if not l_2_0.scale_factor then
    local scale_factor = view.minScale
  end
  local layer = CCLayer:create()
  layer.setCallback = function(l_1_0)
    params.callback = l_1_0
   end
  local clickBlankHandler = nil
  layer.setClickBlankHandler = function(l_2_0)
    clickBlankHandler = l_2_0
   end
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board = img.createLogin9Sprite(img.login.dialog)
  local board_w = l_2_0.board_w
  local board_h = l_2_0.board_h
  board:setPreferredSize(CCSize(board_w, board_h))
  board:setScale(scale_factor)
  board:setAnchorPoint(CCPoint(0.5, 0.5))
  board:setPosition(CCPoint(view.physical.w / 2, view.physical.h / 2))
  layer:addChild(board, 100)
  layer.board = board
  board:setScale(0.1 * scale_factor)
  board:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, scale_factor)))
  if l_2_0.title then
    local lbl_title = lbl.createMixFont1(24, l_2_0.title, ccc3(230, 208, 174))
    lbl_title:setPosition(CCPoint(board_w / 2, board_h - 29))
    board:addChild(lbl_title, 2)
    local lbl_title_shadowD = lbl.createMixFont1(24, l_2_0.title, ccc3(89, 48, 27))
    lbl_title_shadowD:setPosition(CCPoint(board_w / 2, board_h - 31))
    board:addChild(lbl_title_shadowD)
  end
  if l_2_0.body then
    local lbl_body = lbl.createMix({font = 1, size = 18, text = l_2_0.body, color = ccc3(120, 70, 39), width = 400})
    lbl_body:setAnchorPoint(CCPoint(0.5, 1))
    lbl_body:setPosition(CCPoint(board_w / 2, board_h - 100))
    board:addChild(lbl_body)
    layer.bodyLabel = lbl_body
  end
  local btn_size = nil
  if l_2_0.btn_count < 3 then
    btn_size = CCSize(153, 50)
  else
    btn_size = CCSize(115, 50)
  end
  layer.btns = {}
  do
    for ii = 1, l_2_0.btn_count do
      local btn_image = btn_gold
      if l_2_0.btn_color[ii] == dialog.COLOR_RED then
        btn_image = btn_red
      else
        if l_2_0.btn_color[ii] == dialog.COLOR_BLUE then
          btn_image = btn_blue
        else
          if l_2_0.btn_color[ii] == dialog.COLOR_GOLD then
            btn_image = btn_gold
          else
            if l_2_0.btn_color[ii] == dialog.COLOR_GREEN then
              btn_image = btn_green
            end
          end
        end
      end
      local btn_sprite1 = img.createLogin9Sprite(btn_image)
      btn_sprite1:setPreferredSize(btn_size)
      local btn = SpineMenuItem:create(json.ui.button, btn_sprite1)
      btn:setPosition(CCPoint(btn_pos[l_2_0.btn_count][ii].x + 57, btn_pos[l_2_0.btn_count][ii].y + 27))
      btn:setEnabled(true)
      btn:registerScriptTapHandler(function()
        audio.play(audio.button)
        params.callback({selected_btn = ii, button = btn})
         end)
      local lbl_btn_text = lbl.createFont1(18, l_2_0.btn_text[ii], ccc3(115, 59, 5))
      lbl_btn_text:setAnchorPoint(CCPoint(0.5, 0.5))
      lbl_btn_text:setPosition(CCPoint(btn:getContentSize().width / 2, btn:getContentSize().height / 2))
      btn_sprite1:addChild(lbl_btn_text, 1000)
      local btn_menu = CCMenu:createWithItem(btn)
      btn_menu:setPosition(CCPoint(0, 0))
      board:addChild(btn_menu)
      layer.btns[ii] = btn
    end
  end
  layer.moveBtnPosition = function(l_4_0, l_4_1)
    for ii = 1, params.btn_count do
      layer.btns[ii]:setPosition(CCPoint(layer.btns[ii]:getPositionX() + l_4_0, layer.btns[ii]:getPositionY() + l_4_1))
    end
   end
  local touchbeginx, touchbeginy, isclick = nil, nil, nil
  local onTouchBegan = function(l_5_0, l_5_1)
    touchbeginx, upvalue_512 = l_5_0, l_5_1
    upvalue_1024 = true
    return true
   end
  local onTouchMoved = function(l_6_0, l_6_1)
    if isclick and (math.abs(touchbeginx - l_6_0) > 10 or math.abs(touchbeginy - l_6_1) > 10) then
      isclick = false
    end
   end
  local onTouchEnded = function(l_7_0, l_7_1)
    if not outside_remove and params.btn_count ~= nil and params.btn_count > 0 then
      return 
    end
    if isclick and not board:boundingBox():containsPoint(ccp(l_7_0, l_7_1)) then
      if clickBlankHandler then
        clickBlankHandler()
      else
        layer:removeFromParentAndCleanup(true)
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
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  addBackEvent(layer)
  local onEnter = function()
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

dialog.setCallback = function(l_3_0)
  __callback = l_3_0
end

return dialog

