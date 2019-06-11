-- Command line was: E:\github\dhgametool\scripts\ui\guild\log.lua 

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
local player = require("data.player")
local i18n = require("res.i18n")
local space_height = 5
local proc = function(l_1_0)
  if not l_1_0 then
    return {}
  end
  table.sort(l_1_0, function(l_1_0, l_1_1)
    if not l_1_1 then
      return true
    elseif not l_1_0 then
      return false
    else
      return l_1_1.time < l_1_0.time
    end
   end)
  local dates = {}
  do
    local last_date = ""
    for ii = 1, #l_1_0 do
      if last_date ~= os.date("%y%m%d", l_1_0[ii].time) then
        last_date = os.date("%y%m%d", l_1_0[ii].time)
        dates[#dates + 1] = {}
        dates[#dates].title = os.date("%m-%d", l_1_0[ii].time)
        dates[#dates].list = {}
      else
        local tmp_list = dates[#dates].list
        tmp_list[#tmp_list + 1] = l_1_0[ii]
      end
      return dates
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.create = function(l_2_0)
  local layer = CCLayer:create()
  local sortLogs = proc(l_2_0)
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
    audio.play(audio.button)
    backEvent()
   end)
  local lbl_title = lbl.createFont1(22, i18n.global.guild_log_board_title.string, ccc3(255, 227, 134))
  lbl_title:setPosition(CCPoint(board_w / 2, board_h - 32))
  board:addChild(lbl_title)
  local tips_line = img.createUI9Sprite(img.ui.hero_tips_fgline)
  tips_line:setPreferredSize(CCSizeMake(594, 1))
  tips_line:setPosition(CCPoint(board_w / 2, board_h - 62))
  board:addChild(tips_line)
  local createItem = function(l_3_0)
    local t_str = (os.date("%H:%M  ", l_3_0.time))
    local e_str = nil
    if l_3_0.type == 1 then
      e_str = string.format(i18n.global.guild_log_create.string, l_3_0.do_name)
    elseif l_3_0.type == 2 then
      e_str = string.format(i18n.global.guild_log_new.string, l_3_0.do_name)
    elseif l_3_0.type == 3 then
      e_str = string.format(i18n.global.guild_log_appoint.string, l_3_0.obj_name)
    elseif l_3_0.type == 4 then
      e_str = string.format(i18n.global.guild_log_downgrade.string, l_3_0.obj_name)
    elseif l_3_0.type == 5 then
      e_str = string.format(i18n.global.guild_log_chase.string, l_3_0.obj_name)
    elseif l_3_0.type == 6 then
      e_str = string.format(i18n.global.guild_log_transfer.string, l_3_0.do_name, l_3_0.obj_name)
    elseif l_3_0.type == 7 then
      e_str = string.format(i18n.global.guild_log_quit.string, l_3_0.do_name)
    end
    local item = lbl.createFontTTF(18, t_str .. e_str, ccc3(254, 235, 202))
    return item
   end
  local createTitleItem = function(l_4_0)
    local item = img.createUISprite(img.ui.guild_vtitle_bg)
    local item_title = lbl.createFont1(18, l_4_0.title, ccc3(235, 170, 94))
    item_title:setPosition(CCPoint(item:getContentSize().width / 2, item:getContentSize().height / 2))
    item:addChild(item_title)
    return item
   end
  local createScroll = function()
    local scroll_params = {width = 594, height = 310}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local showList = function(l_6_0)
    board.scroll = nil
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(35, 35))
    board:addChild(scroll)
    board.scroll = scroll
    for ii = 1, #l_6_0 do
      local tmp_item = createTitleItem(l_6_0[ii])
      tmp_item.ax = 0
      tmp_item.px = 0
      scroll.addItem(tmp_item)
      local tmp_list = l_6_0[ii].list
      for jj = 1, #tmp_list do
        local tmp_item = createItem(tmp_list[jj])
        tmp_item.ax = 0
        tmp_item.px = 0
        scroll.addItem(tmp_item)
        if jj ~= #tmp_list then
          scroll.addSpace(space_height)
        end
      end
      if ii ~= #l_6_0 then
        scroll.addSpace(space_height)
      end
    end
    scroll.setOffsetBegin()
   end
  showList(sortLogs)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  local touchbeginx, touchbeginy, isclick = nil, nil, nil
  local onTouchBegan = function(l_7_0, l_7_1)
    touchbeginx, upvalue_512 = l_7_0, l_7_1
    upvalue_1024 = true
    return true
   end
  local onTouchMoved = function(l_8_0, l_8_1)
    if isclick and (math.abs(touchbeginx - l_8_0) > 10 or math.abs(touchbeginy - l_8_1) > 10) then
      isclick = false
    end
   end
  local onTouchEnded = function(l_9_0, l_9_1)
    if isclick then
      local p0 = layer:convertToNodeSpace(ccp(l_9_0, l_9_1))
      if not board:boundingBox():containsPoint(p0) then
        return 
      end
    end
   end
  local onTouch = function(l_10_0, l_10_1, l_10_2)
    if l_10_0 == "began" then
      return onTouchBegan(l_10_1, l_10_2)
    elseif l_10_0 == "moved" then
      return onTouchMoved(l_10_1, l_10_2)
    else
      return onTouchEnded(l_10_1, l_10_2)
    end
   end
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
  layer:registerScriptHandler(function(l_14_0)
    if l_14_0 == "enter" then
      onEnter()
    elseif l_14_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

