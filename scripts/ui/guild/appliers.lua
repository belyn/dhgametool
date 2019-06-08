-- Command line was: E:\github\dhgametool\scripts\ui\guild\appliers.lua 

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
ui.create = function(l_1_0)
  if l_1_0 and  l_1_0 > 0 then
    gdata.setApplyCount( l_1_0)
  else
    gdata.setApplyCount(0)
  end
  local layer = board2.create(board2.TAB.APPLY)
  local board = layer.board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  layer.setTitle(i18n.global.guild_applylist_board_title.string)
  local removeMem = function(l_1_0)
    if not members or  members == 0 then
      return 
    end
    for ii = 1,  members do
      if members[ii].uid == l_1_0 then
        table.remove(members, ii)
        return 
      end
    end
   end
  local showList = nil
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
  local createItem = function(l_3_0)
    local item = img.createUI9Sprite(img.ui.botton_fram_2)
    item:setPreferredSize(CCSizeMake(614, 79))
    local item_w = item:getContentSize().width
    local item_h = item:getContentSize().height
    local head0 = img.createPlayerHead(l_3_0.logo)
    local head = SpineMenuItem:create(json.ui.button, head0)
    head:setScale(0.65)
    head:setPosition(CCPoint(39, item_h / 2 + 2))
    local head_menu = CCMenu:createWithItem(head)
    head_menu:setPosition(CCPoint(0, 0))
    item:addChild(head_menu)
    head:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer:addChild(require("ui.tips.player1").create(clone(memObj, "none")), 100)
      end)
    local lv_bg = img.createUISprite(img.ui.main_lv_bg)
    lv_bg:setPosition(CCPoint(92, item_h / 2))
    item:addChild(lv_bg)
    local lbl_mem_lv = lbl.createFont1(14, "" .. l_3_0.lv)
    lbl_mem_lv:setPosition(CCPoint(lv_bg:getContentSize().width / 2, lv_bg:getContentSize().height / 2))
    lv_bg:addChild(lbl_mem_lv)
    local lbl_mem_name = lbl.createFontTTF(20, l_3_0.name, ccc3(81, 39, 18))
    lbl_mem_name:setAnchorPoint(CCPoint(0, 0.5))
    lbl_mem_name:setPosition(CCPoint(122, item_h / 2 + 1))
    item:addChild(lbl_mem_name)
    local btn_agree0 = img.createLogin9Sprite(img.login.button_9_small_green)
    btn_agree0:setPreferredSize(CCSizeMake(90, 42))
    local icon_tick = img.createUISprite(img.ui.friends_tick)
    icon_tick:setPosition(CCPoint(btn_agree0:getContentSize().width / 2, btn_agree0:getContentSize().height / 2 + 1))
    btn_agree0:addChild(icon_tick)
    local btn_agree = SpineMenuItem:create(json.ui.button, btn_agree0)
    btn_agree:setPosition(CCPoint(448, item_h / 2 + 2))
    local btn_agree_menu = CCMenu:createWithItem(btn_agree)
    btn_agree_menu:setPosition(CCPoint(0, 0))
    item:addChild(btn_agree_menu)
    local btn_deny0 = img.createLogin9Sprite(img.login.button_9_small_orange)
    btn_deny0:setPreferredSize(CCSizeMake(90, 42))
    local icon_x = img.createUISprite(img.ui.friends_x)
    icon_x:setPosition(CCPoint(btn_deny0:getContentSize().width / 2, btn_deny0:getContentSize().height / 2 + 1))
    btn_deny0:addChild(icon_x)
    local btn_deny = SpineMenuItem:create(json.ui.button, btn_deny0)
    btn_deny:setPosition(CCPoint(550, item_h / 2 + 2))
    local btn_deny_menu = CCMenu:createWithItem(btn_deny)
    btn_deny_menu:setPosition(CCPoint(0, 0))
    item:addChild(btn_deny_menu)
    btn_agree:registerScriptTapHandler(function()
      audio.play(audio.button)
      if gdata.selfTitle() <= gdata.TITLE.RESIDENT then
        showToast(i18n.global.permission_denied.string)
        return 
      end
      local params = {sid = player.sid, type = 4, muid = memObj.uid}
      addWaitNet()
      netClient:gmember_opt(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        removeMem(memObj.uid)
        if l_1_0.status == -1 then
          showToast(i18n.global.guild_joined_other.string)
        elseif l_1_0.status == -2 then
          showToast(i18n.global.guild_max_mem.string)
        end
        showList(members)
        gdata.deApplyCount()
         end)
      end)
    btn_deny:registerScriptTapHandler(function()
      audio.play(audio.button)
      if gdata.selfTitle() <= gdata.TITLE.RESIDENT then
        showToast(i18n.global.permission_denied.string)
        return 
      end
      local params = {sid = player.sid, type = 5, muid = memObj.uid}
      addWaitNet()
      netClient:gmember_opt(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        removeMem(memObj.uid)
        showList(members)
        gdata.deApplyCount()
         end)
      end)
    return item
   end
  showList = function(l_4_0)
    mem_container:removeAllChildrenWithCleanup(true)
    if not l_4_0 or  l_4_0 <= 0 then
      local ui_empty = require("ui.empty").create({text = i18n.global.empty_shenqing.string, color = ccc3(101, 54, 36)})
      ui_empty:setPosition(CCPoint(317, 220))
      mem_container:addChild(ui_empty)
      return 
    end
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(0, 2))
    mem_container:addChild(scroll)
    mem_container.scroll = scroll
    scroll.addSpace(8)
    for ii = 1,  l_4_0 do
      local tmp_item = createItem(l_4_0[ii])
      tmp_item.memObj = l_4_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = 317
      scroll.addItem(tmp_item)
      if ii ~=  l_4_0 then
        scroll.addSpace(space_height)
      end
    end
    scroll.setOffsetBegin()
   end
  if not l_1_0 then
    showList({})
  end
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

