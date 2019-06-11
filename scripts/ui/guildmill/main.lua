-- Command line was: E:\github\dhgametool\scripts\ui\guildmill\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local order = require("ui.guildmill.order")
local upgrade = require("ui.guildmill.upgrade")
local harry = require("ui.guildmill.harry")
local drank = require("ui.guildmill.drank")
local guildmill = require("data.guildmill")
local player = require("data.player")
local net = require("net.netClient")
local TAB = {ORDER = 1, UPGRADE = 2, DRANK = 3}
local currentmillTab = TAB.ORDER
local titles = {TAB.ORDER = i18n.global.friend_friend_list.global, TAB.UPGRADE = i18n.global.friend_friend_apply.global, TAB.DRANK = i18n.global.friend_apply_list.global}
ui.create = function(l_1_0)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  currentmillTab = TAB.ORDER
  if l_1_0 then
    currentmillTab = l_1_0
  end
  img.load(img.packedOthers.spine_ui_mofang)
  local board_w = 718
  local board_h = 520
  local board = img.createUI9Sprite(img.ui.dialog_1)
  board:setPreferredSize(CCSizeMake(board_w, board_h))
  board:setScale(view.minScale)
  board:setPosition(view.physical.w / 2, view.physical.h / 2)
  layer:addChild(board)
  board:setScale(0.5 * view.minScale)
  board:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  local bottom = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  bottom:setPreferredSize(CCSizeMake(660, 422))
  bottom:setAnchorPoint(0, 0)
  bottom:setPosition(CCPoint(28, 29))
  board:addChild(bottom)
  local milllayer = nil
  local initlayer = function()
    milllayer:removeFromParentAndCleanup(true)
    milllayer = nil
   end
  local showmill = function()
    if milllayer then
      initlayer()
    end
    if currentmillTab == TAB.ORDER then
      milllayer = order.create()
      board:addChild(milllayer, 1000)
    else
      if currentmillTab == TAB.UPGRADE then
        milllayer = upgrade.create()
        board:addChild(milllayer, 1000)
      else
        milllayer = drank.create()
        board:addChild(milllayer, 1000)
      end
    end
   end
  local orderTab0 = img.createUISprite(img.ui.guild_mill_order_0)
  local orderTab1 = img.createUISprite(img.ui.guild_mill_order_1)
  local orderTab = CCMenuItemSprite:create(orderTab0, nil, orderTab1)
  orderTab:setAnchorPoint(0, 0)
  orderTab:setPosition(CCPoint(684, 333))
  orderTab:setEnabled(currentmillTab ~= TAB.ORDER)
  local orderMenu = CCMenu:createWithItem(orderTab)
  orderMenu:setPosition(0, 0)
  board:addChild(orderMenu, 1003)
  local upgradeTab0 = img.createUISprite(img.ui.guild_mill_upgrade_0)
  local upgradeTab1 = img.createUISprite(img.ui.guild_mill_upgrade_1)
  local upgradeTab = CCMenuItemSprite:create(upgradeTab0, nil, upgradeTab1)
  upgradeTab:setAnchorPoint(0, 0)
  upgradeTab:setPosition(CCPoint(684, 241))
  upgradeTab:setEnabled(currentmillTab ~= TAB.UPGRADE)
  local upgradeMenu = CCMenu:createWithItem(upgradeTab)
  upgradeMenu:setPosition(0, 0)
  board:addChild(upgradeMenu, 1003)
  local harryTab0 = img.createUISprite(img.ui.guild_mill_drank_0)
  local harryTab1 = img.createUISprite(img.ui.guild_mill_drank_1)
  local harryTab = CCMenuItemSprite:create(harryTab0, nil, harryTab1)
  harryTab:setAnchorPoint(0, 0)
  harryTab:setPosition(CCPoint(684, 149))
  harryTab:setEnabled(currentmillTab ~= TAB.DRANK)
  local harryMenu = CCMenu:createWithItem(harryTab)
  harryMenu:setPosition(0, 0)
  board:addChild(harryMenu, 1003)
  local setTabstatus = function()
    orderTab:setEnabled(currentmillTab ~= TAB.ORDER)
    upgradeTab:setEnabled(currentmillTab ~= TAB.UPGRADE)
    harryTab:setEnabled(currentmillTab ~= TAB.DRANK)
   end
  orderTab:registerScriptTapHandler(function()
    audio.play(audio.button)
    upvalue_512 = TAB.ORDER
    setTabstatus()
    showmill()
   end)
  upgradeTab:registerScriptTapHandler(function()
    audio.play(audio.button)
    upvalue_512 = TAB.UPGRADE
    setTabstatus()
    showmill()
   end)
  harryTab:registerScriptTapHandler(function()
    audio.play(audio.button)
    upvalue_512 = TAB.DRANK
    setTabstatus()
    showmill()
   end)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup()
   end
  local close0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, close0)
  closeBtn:setPosition(CCPoint(692, 495))
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  board:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    backEvent()
   end)
  layer:setTouchEnabled(true)
  layer.onAndroidBack = function()
    backEvent()
   end
  addBackEvent(layer)
  local onEnter = function()
    layer.notifyParentLock()
    showmill()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_12_0)
    if l_12_0 == "enter" then
      onEnter()
    elseif l_12_0 == "exit" then
      onExit()
    elseif l_12_0 == "cleanup" then
      img.unload(img.packedOthers.spine_ui_mofang)
    end
   end)
  return layer
end

return ui

