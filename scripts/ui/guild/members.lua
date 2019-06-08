-- Command line was: E:\github\dhgametool\scripts\ui\guild\members.lua 

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
local gdata = require("data.guild")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local dialog = require("ui.dialog")
local board2 = require("ui.guild.board2")
local gitem = require("ui.guild.gitem")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local space_height = 5
local memOpt = function(l_1_0, l_1_1, l_1_2)
  local params = {sid = player.sid, type = l_1_0, muid = l_1_1}
  addWaitNet()
  netClient:gmember_opt(params, l_1_2)
end

local guildSync = function()
  local gparams = {sid = player.sid}
  addWaitNet()
  netClient:guild_sync(gparams, function(l_1_0)
    delWaitNet()
    tbl2string(l_1_0)
    if l_1_0.status ~= 0 then
      showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
      return 
    end
    gdata.init(l_1_0)
    replaceScene(require("ui.guild.main").create())
   end)
end

ui.create = function(l_3_0)
  local layer = board2.create(board2.TAB.MEMBER)
  local board = layer.board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  layer.setTitle(i18n.global.guild_memopt_dlg_title.string)
  local mem_container = CCSprite:create()
  mem_container:setContentSize(CCSizeMake(634, 440))
  mem_container:setAnchorPoint(CCPoint(0.5, 0))
  mem_container:setPosition(CCPoint(board_w / 2, 0))
  board:addChild(mem_container)
  local container_w = mem_container:getContentSize().width
  local container_h = mem_container:getContentSize().height
  local createScroll = function()
    local scroll_params = {width = 634, height = 436}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local createItem = function(l_2_0)
    local item = img.createUI9Sprite(img.ui.botton_fram_2)
    item:setPreferredSize(CCSizeMake(614, 79))
    local item_w = item:getContentSize().width
    local item_h = item:getContentSize().height
    local head = img.createPlayerHead(l_2_0.logo)
    head:setScale(0.65)
    head:setPosition(CCPoint(39, item_h / 2 + 1))
    item:addChild(head)
    local lv_bg = img.createUISprite(img.ui.main_lv_bg)
    lv_bg:setPosition(CCPoint(92, item_h / 2))
    item:addChild(lv_bg)
    local lbl_mem_lv = lbl.createFont1(14, l_2_0.lv)
    lbl_mem_lv:setPosition(CCPoint(lv_bg:getContentSize().width / 2, lv_bg:getContentSize().height / 2))
    lv_bg:addChild(lbl_mem_lv)
    local lbl_mem_name = lbl.createFontTTF(20, l_2_0.name, ccc3(81, 39, 18))
    lbl_mem_name:setAnchorPoint(CCPoint(0, 0))
    lbl_mem_name:setPosition(CCPoint(122, item_h / 2))
    item:addChild(lbl_mem_name)
    local lbl_mem_title = lbl.createFont1(14, gdata.getTitleStr(l_2_0.title), ccc3(138, 96, 76))
    lbl_mem_title:setAnchorPoint(CCPoint(0, 1))
    lbl_mem_title:setPosition(CCPoint(122, item_h / 2))
    item:addChild(lbl_mem_title)
    local lbl_mem_status = lbl.createFont1(16, gdata.onlineStatus(l_2_0.last), ccc3(138, 96, 76))
    lbl_mem_status:setAnchorPoint(CCPoint(1, 0.5))
    lbl_mem_status:setPosition(CCPoint(item_w - 25, item_h / 2))
    item:addChild(lbl_mem_status)
    return item
   end
  local items = {}
  local showList = function(l_3_0)
    mem_container:removeAllChildrenWithCleanup(true)
    arrayclear(items)
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(0, 2))
    mem_container:addChild(scroll)
    mem_container.scroll = scroll
    scroll.addSpace(8)
    for ii = 1,  l_3_0 do
      local tmp_item = createItem(l_3_0[ii])
      tmp_item.memObj = l_3_0[ii]
      tmp_item.ax = 0.5
      tmp_item.ay = 0.5
      tmp_item.px = 317
      scroll.addItem(tmp_item)
      items[ items + 1] = tmp_item
      if ii ~=  l_3_0 then
        scroll.addSpace(space_height)
      end
    end
    scroll.setOffsetBegin()
   end
  if not gdata.members then
    showList({})
  end
  local onClickItem = function(l_4_0)
      audio.play(audio.button)
      if not l_4_0 or tolua.isnull(l_4_0) then
        return 
      end
      local memObj = l_4_0.memObj
      local mParams = {name = memObj.name, logo = memObj.logo, lv = memObj.lv, uid = memObj.uid, guild = gdata.guildObj.name, power = 1000, defens = {}}
      local infolayer = nil
      if memObj.uid == player.uid then
        infolayer = require("ui.tips.player").create(mParams)
        layer:addChild(infolayer, 1000)
        return 
      else
        mParams.buttons = {}
        infolayer = require("ui.tips.player").create(mParams)
      end
      local info_board = infolayer.board
      local info_board_w = info_board:getContentSize().width
      local info_board_h = info_board:getContentSize().height
      if gdata.selfTitle() == gdata.TITLE.PRESIDENT then
        if memObj.title == gdata.TITLE.RESIDENT then
          local btn_appoint0 = img.createLogin9Sprite(img.login.button_9_small_gold)
          btn_appoint0:setPreferredSize(CCSizeMake(150, 50))
          local lbl_appoint = lbl.createFont1(16, i18n.global.guild_memopt_btn_assign2.string, ccc3(115, 59, 5))
          lbl_appoint:setPosition(CCPoint(btn_appoint0:getContentSize().width / 2, btn_appoint0:getContentSize().height / 2))
          btn_appoint0:addChild(lbl_appoint)
          local btn_appoint = SpineMenuItem:create(json.ui.button, btn_appoint0)
          btn_appoint:setPosition(CCPoint(100, 46))
          local btn_appoint_menu = CCMenu:createWithItem(btn_appoint)
          btn_appoint_menu:setPosition(CCPoint(0, 0))
          info_board:addChild(btn_appoint_menu)
          btn_appoint:registerScriptTapHandler(function()
            audio.play(audio.button)
            memOpt(1, memObj.uid, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              if l_1_0.status ~= 0 then
                if l_1_0.status == -1 then
                  showToast(i18n.global.guild_memopt_mem_offical_limit.string)
                  return 
                end
                showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
                return 
              end
              memObj.title = gdata.TITLE.OFFICER
              showToast("Ok.")
              infolayer:removeFromParentAndCleanup(true)
              if not gdata.members then
                showList({})
              end
                  end)
               end)
        else
          if memObj.title == gdata.TITLE.OFFICER then
            local btn_appoint0 = img.createLogin9Sprite(img.login.button_9_small_gold)
            btn_appoint0:setPreferredSize(CCSizeMake(150, 50))
            local lbl_appoint = lbl.createFont1(16, i18n.global.guild_memopt_btn_assign3.string, ccc3(115, 59, 5))
            lbl_appoint:setPosition(CCPoint(btn_appoint0:getContentSize().width / 2, btn_appoint0:getContentSize().height / 2))
            btn_appoint0:addChild(lbl_appoint)
            local btn_appoint = SpineMenuItem:create(json.ui.button, btn_appoint0)
            btn_appoint:setPosition(CCPoint(100, 46))
            local btn_appoint_menu = CCMenu:createWithItem(btn_appoint)
            btn_appoint_menu:setPosition(CCPoint(0, 0))
            info_board:addChild(btn_appoint_menu)
            btn_appoint:registerScriptTapHandler(function()
              audio.play(audio.button)
              memOpt(2, memObj.uid, function(l_1_0)
                delWaitNet()
                tbl2string(l_1_0)
                if l_1_0.status ~= 0 then
                  showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
                  return 
                end
                memObj.title = gdata.TITLE.RESIDENT
                showToast("Ok.")
                infolayer:removeFromParentAndCleanup(true)
                if not gdata.members then
                  showList({})
                end
                     end)
                  end)
          end
        end
        local btn_transfer0 = img.createLogin9Sprite(img.login.button_9_small_gold)
        btn_transfer0:setPreferredSize(CCSizeMake(150, 50))
        local lbl_transfer = lbl.createFont1(16, i18n.global.guild_memopt_btn_assign1.string, ccc3(115, 59, 5))
        lbl_transfer:setPosition(CCPoint(btn_transfer0:getContentSize().width / 2, btn_transfer0:getContentSize().height / 2))
        btn_transfer0:addChild(lbl_transfer)
        local btn_transfer = SpineMenuItem:create(json.ui.button, btn_transfer0)
        btn_transfer:setPosition(CCPoint(262, 46))
        local btn_transfer_menu = CCMenu:createWithItem(btn_transfer)
        btn_transfer_menu:setPosition(CCPoint(0, 0))
        info_board:addChild(btn_transfer_menu)
        btn_transfer:registerScriptTapHandler(function()
          audio.play(audio.button)
          local transfer = function()
            memOpt(3, memObj.uid, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              if l_1_0.status ~= 0 then
                showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
                return 
              end
              memObj.title = gdata.TITLE.PRESIDENT
              gdata.deInit()
              guildSync()
                  end)
               end
          local process_dialog = function(l_2_0)
            layer:removeChildByTag(dialog.TAG)
            if l_2_0.selected_btn == 2 then
              transfer()
            end
               end
          local params = {title = "", body = i18n.global.guild_memopt_assign_tip.string, btn_count = 2, btn_color = {1 = dialog.COLOR_BLUE, 2 = dialog.COLOR_GOLD}, btn_text = {1 = i18n.global.dialog_button_cancel.string, 2 = i18n.global.dialog_button_confirm.string}, callback = process_dialog}
          local dialog_ins = dialog.create(params, true)
          dialog_ins:setAnchorPoint(CCPoint(0, 0))
          dialog_ins:setPosition(CCPoint(0, 0))
          layer:addChild(dialog_ins, 10000, dialog.TAG)
            end)
        local btn_chase0 = img.createLogin9Sprite(img.login.button_9_small_gold)
        btn_chase0:setPreferredSize(CCSizeMake(150, 50))
        local lbl_chase = lbl.createFont1(16, i18n.global.guild_memopt_btn_chase.string, ccc3(115, 59, 5))
        lbl_chase:setPosition(CCPoint(btn_chase0:getContentSize().width / 2, btn_chase0:getContentSize().height / 2))
        btn_chase0:addChild(lbl_chase)
        local btn_chase = SpineMenuItem:create(json.ui.button, btn_chase0)
        btn_chase:setPosition(CCPoint(424, 46))
        local btn_chase_menu = CCMenu:createWithItem(btn_chase)
        btn_chase_menu:setPosition(CCPoint(0, 0))
        info_board:addChild(btn_chase_menu)
        btn_chase:registerScriptTapHandler(function()
          audio.play(audio.button)
          memOpt(6, memObj.uid, function(l_1_0)
            delWaitNet()
            tbl2string(l_1_0)
            if l_1_0.status ~= 0 then
              showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
              return 
            end
            gdata.removeMemByUid(memObj.uid)
            infolayer:removeFromParentAndCleanup(true)
            if not gdata.members then
              showList({})
            end
               end)
            end)
      else
        if gdata.selfTitle() == gdata.TITLE.OFFICER and memObj.title <= gdata.TITLE.RESIDENT then
          local btn_chase0 = img.createLogin9Sprite(img.login.button_9_small_gold)
          btn_chase0:setPreferredSize(CCSizeMake(150, 50))
          local lbl_chase = lbl.createFont1(16, i18n.global.guild_memopt_btn_chase.string, ccc3(115, 59, 5))
          lbl_chase:setPosition(CCPoint(btn_chase0:getContentSize().width / 2, btn_chase0:getContentSize().height / 2))
          btn_chase0:addChild(lbl_chase)
          local btn_chase = SpineMenuItem:create(json.ui.button, btn_chase0)
          btn_chase:setPosition(CCPoint(424, 46))
          local btn_chase_menu = CCMenu:createWithItem(btn_chase)
          btn_chase_menu:setPosition(CCPoint(0, 0))
          info_board:addChild(btn_chase_menu)
          btn_chase:registerScriptTapHandler(function()
            audio.play(audio.button)
            memOpt(6, memObj.uid, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              if l_1_0.status ~= 0 then
                showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
                return 
              end
              gdata.removeMemByUid(memObj.uid)
              infolayer:removeFromParentAndCleanup(true)
              if not gdata.members then
                showList({})
              end
                  end)
               end)
        end
      end
      layer:addChild(infolayer, 1000)
      end
  local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
  local onTouchBegan = function(l_5_0, l_5_1)
    touchbeginx, upvalue_512 = l_5_0, l_5_1
    upvalue_1024 = true
    if mem_container.scroll and not tolua.isnull(mem_container.scroll) then
      local p0 = mem_container.scroll.content_layer:convertToNodeSpace(ccp(l_5_0, l_5_1))
      for ii = 1,  items do
        if items[ii]:boundingBox():containsPoint(p0) then
          playAnimTouchBegin(items[ii])
          upvalue_2560 = items[ii]
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
    if isclick and mem_container.scroll and not tolua.isnull(mem_container.scroll) then
      local p0 = mem_container.scroll.content_layer:convertToNodeSpace(ccp(l_7_0, l_7_1))
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
  return layer
end

return ui

