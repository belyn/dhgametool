-- Command line was: E:\github\dhgametool\scripts\ui\setting\server.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local player = require("data.player")
local userdata = require("data.userdata")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local slist = {1 = {sid = 3, sname = "s3", pname = "anney", plogo = 2, plv = 5, flag = 1}, 2 = {sid = 5, sname = "s5", pname = "jim", plogo = 3, plv = 7, flag = 0}, 3 = {sid = 2, sname = "s2", pname = "jim2", plogo = 5, plv = 9, flag = 0}}
local sortValue = function(l_1_0)
  if not l_1_0 then
    return 0
  end
  if l_1_0.sid == player.sid then
    return 100000
  elseif l_1_0.pname and l_1_0.pname ~= nil and l_1_0.pname ~= "" then
    return 80000 + l_1_0.sid
  else
    return l_1_0.sid
  end
end

local processServers = function(l_2_0)
  local rlist = {}
  local marksid = {}
  for ii = 1,  l_2_0 do
    local tobj = l_2_0[ii]
    if not marksid["" .. tobj.sid] then
      rlist[ rlist + 1] = tobj
      marksid["" .. tobj.sid] = tobj
    else
      if not marksid["" .. tobj.sid].extra then
        marksid["" .. tobj.sid].extra = {}
        local textra = marksid["" .. tobj.sid].extra
        textra[ textra + 1] = marksid["" .. tobj.sid]
      end
      local textra = marksid["" .. tobj.sid].extra
      textra[ textra + 1] = tobj
    end
  end
  return rlist
end

ui.pull = function(l_3_0)
  local params = {sid = player.sid}
  addWaitNet()
  netClient:servers(params, function(l_1_0)
    delWaitNet()
    tbl2string(l_1_0)
    local servers = processServers(l_1_0.servers)
    if callback then
      callback(servers)
    end
   end)
end

ui.create = function()
  local boardlayer = require("ui.setting.board")
  local layer = boardlayer.create(boardlayer.TAB.SERVER)
  local board = layer.inner_board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  layer.setTitle(i18n.global.setting_title_servers.string)
  local createScroll = function()
    local scroll_params = {width = 691, height = 385}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local createItem = function(l_2_0)
    local item = img.createUI9Sprite(img.ui.botton_fram_2)
    item:setPreferredSize(CCSizeMake(336, 86))
    local item_w = item:getContentSize().width
    local item_h = item:getContentSize().height
    local current = img.createUI9Sprite(img.ui.setting_server_sel)
    current:setPreferredSize(CCSizeMake(336, 86))
    current:setPosition(CCPoint(item_w / 2, item_h / 2))
    current:setVisible(l_2_0.sid == player.sid)
    item:addChild(current)
    local focus = img.createUI9Sprite(img.ui.setting_server_focus)
    focus:setPreferredSize(CCSizeMake(342, 92))
    focus:setPosition(CCPoint(item_w / 2, item_h / 2 + 2))
    focus:setVisible(false)
    item:addChild(focus)
    item.focus = focus
    local lbl_sname = lbl.createFont1(22, l_2_0.sname, ccc3(81, 39, 18))
    lbl_sname:setAnchorPoint(CCPoint(0, 0.5))
    lbl_sname:setPosition(CCPoint(22, item_h / 2))
    item:addChild(lbl_sname)
    if not l_2_0.extra and l_2_0.pname then
      local lbl_pname = lbl.createFontTTF(22, l_2_0.pname, ccc3(81, 39, 18))
      lbl_pname:setAnchorPoint(CCPoint(1, 0.5))
      lbl_pname:setPosition(CCPoint(256, item_h / 2))
      item:addChild(lbl_pname)
    end
    if l_2_0.extra then
      local head = img.createPlayerHead(118)
      head:setScale(0.7)
      head:setPosition(CCPoint(292, item_h / 2 + 2))
      item:addChild(head)
    elseif l_2_0.plogo then
      local head = img.createPlayerHead(l_2_0.plogo, l_2_0.plv)
      head:setScale(0.7)
      head:setPosition(CCPoint(292, item_h / 2 + 2))
      item:addChild(head)
    end
    if l_2_0.flag and bit.band(2, l_2_0.flag) > 0 then
      local icon_new = img.createUISprite(img.ui.setting_icon_new)
      icon_new:setPosition(CCPoint(lbl_sname:boundingBox():getMaxX() + 23, item_h / 2))
      item:addChild(icon_new)
    end
    item.height = item_h
    return item
   end
  local list_items = {}
  local showList = function(l_3_0)
    table.sort(l_3_0, function(l_1_0, l_1_1)
      return sortValue(l_1_1) < sortValue(l_1_0)
      end)
    if not l_3_0 or  l_3_0 == 0 then
      return 
    end
    arrayclear(list_items)
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(23, 16))
    board:addChild(scroll)
    board.scroll = scroll
    for ii = 1,  l_3_0, 2 do
      local tmp_item = CCSprite:create()
      tmp_item:setContentSize(CCSizeMake(685, 90))
      local tmp_server_item = createItem(l_3_0[ii])
      tmp_server_item.container = tmp_item
      tmp_server_item.obj = l_3_0[ii]
      list_items[ list_items + 1] = tmp_server_item
      tmp_server_item:setPosition(CCPoint(169, 45))
      tmp_item:addChild(tmp_server_item)
      if l_3_0[ii + 1] then
        local tmp_server_item2 = createItem(l_3_0[ii + 1])
        tmp_server_item2.container = tmp_item
        tmp_server_item2.obj = l_3_0[ii + 1]
        list_items[ list_items + 1] = tmp_server_item2
        tmp_server_item2:setPosition(CCPoint(517, 45))
        tmp_item:addChild(tmp_server_item2)
      end
      scroll.addItem(tmp_item)
    end
    scroll.setOffsetBegin()
   end
  ui.pull(showList)
  local showRoleList = function(l_4_0)
   end
  local onClickItem = function(l_5_0)
    audio.play(audio.button)
    if last_sel_sprite and not tolua.isnull(last_sel_sprite) then
      last_sel_sprite.focus:setVisible(false)
    end
    l_5_0.focus:setVisible(true)
    last_sel_sprite = l_5_0
    if l_5_0.obj.extra then
      layer:addChild(require("ui.setting.roles").create(l_5_0.obj.extra), 10000)
      return 
    end
    if l_5_0.obj.sid == player.sid and player.uid == l_5_0.obj.uid then
      return 
    end
    local dialog = require("ui.dialog")
    local process_dialog = function(l_1_0)
      layer:removeChildByTag(dialog.TAG)
      if l_1_0.selected_btn == 2 then
        replaceScene(require("ui.login.update").create(nil, itemObj.obj.sid, nil, {uid = itemObj.obj.uid}))
      elseif l_1_0.selected_btn == 1 then
         -- Warning: missing end command somewhere! Added here
      end
      end
    local params = {title = "", body = i18n.global.change_server_tips.string, btn_count = 2, btn_color = {1 = dialog.COLOR_BLUE, 2 = dialog.COLOR_GOLD}, btn_text = {1 = i18n.global.dialog_button_cancel.string, 2 = i18n.global.dialog_button_confirm.string}, callback = process_dialog}
    local dialog_ins = dialog.create(params, true)
    dialog_ins:setAnchorPoint(CCPoint(0, 0))
    dialog_ins:setPosition(CCPoint(0, 0))
    layer:addChild(dialog_ins, 10000, dialog.TAG)
   end
  local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
  local onTouchBegan = function(l_6_0, l_6_1)
    touchbeginx, upvalue_512 = l_6_0, l_6_1
    upvalue_1024 = true
    if not board.scroll or tolua.isnull(board.scroll) then
      upvalue_1024 = false
      return false
    end
    local content_layer = board.scroll.content_layer
    local p0 = board:convertToNodeSpace(ccp(l_6_0, l_6_1))
    if not board.scroll:boundingBox():containsPoint(p0) then
      upvalue_1024 = false
      return false
    end
    for ii = 1,  list_items do
      local p1 = list_items[ii].container:convertToNodeSpace(ccp(l_6_0, l_6_1))
      if list_items[ii]:boundingBox():containsPoint(p1) then
        playAnimTouchBegin(list_items[ii])
        upvalue_2560 = list_items[ii]
    else
      end
    end
    return true
   end
  local onTouchMoved = function(l_7_0, l_7_1)
    if isclick and (math.abs(touchbeginx - l_7_0) > 10 or math.abs(touchbeginy - l_7_1) > 10) then
      isclick = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        playAnimTouchEnd(last_touch_sprite)
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_8_0, l_8_1)
    if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
      playAnimTouchEnd(last_touch_sprite)
      last_touch_sprite = nil
    end
    if not board.scroll or tolua.isnull(board.scroll) then
      return 
    end
    if isclick then
      local content_layer = board.scroll.content_layer
      for ii = 1,  list_items do
        local p0 = list_items[ii].container:convertToNodeSpace(ccp(l_8_0, l_8_1))
        if list_items[ii]:boundingBox():containsPoint(p0) then
          onClickItem(list_items[ii])
      else
        end
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
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

