-- Command line was: E:\github\dhgametool\scripts\ui\casino\selectcasino.lua 

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
local daredata = require("data.dare")
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSizeMake(596, 398))
  board:setScale(view.minScale)
  board:setPosition(view.midX - 0 * view.minScale, view.midY)
  layer:addChild(board)
  layer.board = board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  if l_1_0 and l_1_0._anim then
    board:setScale(0.5 * view.minScale)
    board:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  end
  local lbl_title = lbl.createFont1(24, i18n.global.casino_main_title.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_w / 2, board_h - 29))
  board:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.casino_main_title.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_w / 2, board_h - 31))
  board:addChild(lbl_title_shadowD)
  local casinoSprite = img.createUISprite(img.ui.casino_common)
  local casinoBtn = SpineMenuItem:create(json.ui.button, casinoSprite)
  casinoBtn:setPosition(172, 202)
  local menucasino = CCMenu:createWithItem(casinoBtn)
  menucasino:setPosition(0, 0)
  board:addChild(menucasino, 100)
  casinoBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_CASINO_LEVEL then
      showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_CASINO_LEVEL))
      return 
    end
    local params = {sid = player.sid, type = 1}
    addWaitNet()
    local casinodata = require("data.casino")
    casinodata.pull(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      casinodata.init(l_1_0)
      replaceScene(require("ui.casino.main").create())
      end)
   end)
  local highcasinoSprite = img.createUISprite(img.ui.casino_advanced)
  local highcasinoBtn = SpineMenuItem:create(json.ui.button, highcasinoSprite)
  highcasinoBtn:setPosition(426, 202)
  local menuhighcasino = CCMenu:createWithItem(highcasinoBtn)
  menuhighcasino:setPosition(0, 0)
  board:addChild(menuhighcasino, 100)
  highcasinoBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_ADVANCED_CASINO_LEVEL and player.vipLv() < 3 then
      showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_ADVANCED_CASINO_LEVEL) .. "\n" .. string.format(i18n.global.func_need_lv_vip.string, 3))
      return 
    end
    local params = {sid = player.sid, type = 1, up = true}
    addWaitNet()
    local highcasinodata = require("data.highcasino")
    highcasinodata.pull(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      highcasinodata.init(l_1_0)
      replaceScene(require("ui.highcasino.main").create())
      end)
   end)
  local lbl_casino = lbl.createFont1(20, i18n.global.casino_common.string, ccc3(115, 59, 5))
  lbl_casino:setPosition(CCPoint(172, 56))
  board:addChild(lbl_casino)
  local lbl_highcasino = lbl.createFont1(20, i18n.global.casino_advanced.string, ccc3(115, 59, 5))
  lbl_highcasino:setPosition(CCPoint(426, 56))
  board:addChild(lbl_highcasino)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(board_w - 25, board_h - 28))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_close_menu, 100)
  layer.btn_close = btn_close
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
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
  layer:registerScriptHandler(function(l_8_0)
    if l_8_0 == "enter" then
      onEnter()
    elseif l_8_0 == "exit" then
      onExit()
    end
   end)
  if l_1_0 and l_1_0.from_layer == "dareStage" then
    layer:runAction(CCCallFunc:create(function()
    layer:addChild(require("ui.dare.stage").create({_anim = true, type = uiParams.type}), 1000)
   end))
  end
  return layer
end

return ui

