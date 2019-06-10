-- Command line was: E:\github\dhgametool\scripts\ui\activity\crushbossrank.lua 

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
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local net = require("net.netClient")
local space_height = 1
local icon_rank = {1 = img.ui.arena_rank_1, 2 = img.ui.arena_rank_2, 3 = img.ui.arena_rank_3}
local createItem = function(l_1_0, l_1_1)
  local item = img.createUI9Sprite(img.ui.botton_fram_2)
  item:setPreferredSize(CCSizeMake(575, 82))
  local item_w = item:getContentSize().width
  local item_h = item:getContentSize().height
  local rank = nil
  if l_1_1 < 4 then
    rank = img.createUISprite(icon_rank[l_1_1])
  else
    rank = lbl.createFont1(18, "" .. l_1_1, ccc3(81, 39, 18))
  end
  rank:setPosition(CCPoint(46, item_h / 2))
  item:addChild(rank)
  local flag = img.createPlayerHead(l_1_0.logo)
  flag:setScale(0.7)
  flag:setPosition(CCPoint(117, item_h / 2))
  item:addChild(flag)
  local lbl_name = lbl.createFontTTF(20, l_1_0.name, ccc3(81, 39, 18))
  lbl_name:setAnchorPoint(CCPoint(0, 0))
  lbl_name:setPosition(CCPoint(220, item:getContentSize().height / 2 - 12))
  item:addChild(lbl_name)
  local lvbottom = img.createUISprite(img.ui.main_lv_bg)
  lvbottom:setPosition(CCPoint(175, item:getContentSize().height / 2))
  item:addChild(lvbottom)
  local lvlab = lbl.createFont1(14, string.format("%d", l_1_0.lv), ccc3(255, 246, 223))
  lvlab:setPosition(CCPoint(lvbottom:getContentSize().width / 2, lvbottom:getContentSize().height / 2))
  lvbottom:addChild(lvlab)
  local serverBg = img.createUISprite(img.ui.anrea_server_bg)
  serverBg:setPosition(404, item_h / 2)
  item:addChild(serverBg)
  local serverLabel = lbl.createFont1(16, getSidname(l_1_0.sid), ccc3(255, 251, 215))
  serverLabel:setPosition(serverBg:getContentSize().width * 0.5, serverBg:getContentSize().height * 0.5)
  serverBg:addChild(serverLabel)
  local lbl_hurt = lbl.createFont1(22, num2KM(l_1_0.hurt), ccc3(156, 69, 45))
  lbl_hurt:setPosition(CCPoint(517, item_h / 2))
  item:addChild(lbl_hurt)
  return item
end

local createSelfItem = function(l_2_0, l_2_1)
  local item = img.createUI9Sprite(img.ui.item_yellow)
  item:setPreferredSize(CCSizeMake(606, 82))
  local item_w = item:getContentSize().width
  local item_h = item:getContentSize().height
  local offset_x = 13
  if l_2_0 and l_2_0 > 0 then
    local rankicon = nil
    if l_2_1 < 4 then
      rankicon = img.createUISprite(icon_rank[l_2_1])
    else
      rankicon = lbl.createFont1(18, "" .. l_2_1, ccc3(81, 39, 18))
    end
    rankicon:setPosition(CCPoint(offset_x + 46, item_h / 2))
    item:addChild(rankicon)
  end
  local flag = img.createPlayerHead(player.logo)
  flag:setScale(0.7)
  flag:setPosition(CCPoint(offset_x + 120, item_h / 2))
  item:addChild(flag)
  local lbl_name = lbl.createFontTTF(18, player.name, ccc3(81, 39, 18))
  lbl_name:setAnchorPoint(CCPoint(0, 0))
  lbl_name:setPosition(CCPoint(238, item:getContentSize().height / 2 - 12))
  item:addChild(lbl_name)
  local lvbottom = img.createUISprite(img.ui.main_lv_bg)
  lvbottom:setPosition(CCPoint(192, item:getContentSize().height / 2))
  item:addChild(lvbottom)
  local lvlab = lbl.createFont1(14, string.format("%d", player.lv()), ccc3(255, 246, 223))
  lvlab:setPosition(CCPoint(lvbottom:getContentSize().width / 2, lvbottom:getContentSize().height / 2))
  lvbottom:addChild(lvlab)
  local serverBg = img.createUISprite(img.ui.anrea_server_bg)
  serverBg:setPosition(420, item_h / 2)
  item:addChild(serverBg)
  local serverLabel = lbl.createFont1(16, getSidname(player.sid), ccc3(255, 251, 215))
  serverLabel:setPosition(serverBg:getContentSize().width * 0.5, serverBg:getContentSize().height * 0.5)
  serverBg:addChild(serverLabel)
  if l_2_0 then
    local lbl_hurt = lbl.createFont1(22, num2KM(l_2_0), ccc3(156, 69, 45))
    lbl_hurt:setPosition(CCPoint(530, item_h / 2))
    item:addChild(lbl_hurt)
  end
  return item
end

ui.create = function()
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board_bg = img.createUI9Sprite(img.ui.dialog_1)
  board_bg:setPreferredSize(CCSizeMake(662, 514))
  board_bg:setScale(view.minScale)
  board_bg:setPosition(view.midX, view.midY)
  layer:addChild(board_bg)
  local board_bg_w = board_bg:getContentSize().width
  local board_bg_h = board_bg:getContentSize().height
  board_bg:setScale(0.5 * view.minScale)
  board_bg:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  local lbl_title = lbl.createFont1(24, i18n.global.guildvice_info_rank.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 29))
  board_bg:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.guildvice_info_rank.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 31))
  board_bg:addChild(lbl_title_shadowD)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(board_bg_w - 25, board_bg_h - 28))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  board_bg:addChild(btn_close_menu, 100)
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local board = img.createUI9Sprite(img.ui.inner_bg)
  board:setPreferredSize(CCSizeMake(604, 413))
  board:setAnchorPoint(CCPoint(0.5, 0))
  board:setPosition(CCPoint(board_bg_w / 2, 38))
  board_bg:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local createScroll = function()
    local scroll_params = {width = 604, height = 320}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local showList = function(l_4_0)
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(0, 82))
    board:addChild(scroll)
    board.scroll = scroll
    scroll.addSpace(4)
    for ii = 1, #l_4_0 do
      local tmp_item = createItem(l_4_0[ii], ii)
      tmp_item.guildObj = l_4_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = 302
      scroll.addItem(tmp_item)
      if ii ~= #l_4_0 then
        scroll.addSpace(space_height)
      end
    end
    scroll.setOffsetBegin()
   end
  local init = function()
    local gParams = {sid = player.sid}
    addWaitNet()
    net:bboss_rank(gParams, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if not l_1_0.mbrs then
        showList({})
      end
      local self_item = createSelfItem(l_1_0.score, l_1_0.rank)
      self_item:setPosition(CCPoint(board_w / 2, 36))
      board:addChild(self_item, 3)
      end)
   end
  init()
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
  layer:registerScriptHandler(function(l_9_0)
    if l_9_0 == "enter" then
      onEnter()
    elseif l_9_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

