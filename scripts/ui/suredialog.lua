-- Command line was: E:\github\dhgametool\scripts\ui\suredialog.lua 

local dialog = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local net = require("net.netClient")
local player = require("data.player")
dialog.create = function(l_1_0, l_1_1)
  local params = {}
  params.btn_count = 0
  params.body = string.format(l_1_0, 20)
  local board_w = 474
  local dialoglayer = require("ui.dialog").create(params)
  local btnYesSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnYesSprite:setPreferredSize(CCSize(153, 50))
  local btnYes = SpineMenuItem:create(json.ui.button, btnYesSprite)
  btnYes:setPosition(board_w / 2 + 95, 100)
  local labYes = lbl.createFont1(18, i18n.global.board_confirm_yes.string, ccc3(115, 59, 5))
  labYes:setPosition(btnYes:getContentSize().width / 2, btnYes:getContentSize().height / 2)
  btnYesSprite:addChild(labYes)
  local menuYes = CCMenu:create()
  menuYes:setPosition(0, 0)
  menuYes:addChild(btnYes)
  dialoglayer.board:addChild(menuYes)
  local btnNoSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnNoSprite:setPreferredSize(CCSize(153, 50))
  local btnNo = SpineMenuItem:create(json.ui.button, btnNoSprite)
  btnNo:setPosition(board_w / 2 - 95, 100)
  local labNo = lbl.createFont1(18, i18n.global.board_confirm_no.string, ccc3(115, 59, 5))
  labNo:setPosition(btnNo:getContentSize().width / 2, btnNo:getContentSize().height / 2)
  btnNoSprite:addChild(labNo)
  local menuNo = CCMenu:create()
  menuNo:setPosition(0, 0)
  menuNo:addChild(btnNo)
  dialoglayer.board:addChild(menuNo)
  btnYes:registerScriptTapHandler(function()
    dialoglayer:removeFromParentAndCleanup(true)
    callback()
   end)
  btnNo:registerScriptTapHandler(function()
    dialoglayer:removeFromParentAndCleanup(true)
    audio.play(audio.button)
   end)
  local diabackEvent = function()
    dialoglayer:removeFromParentAndCleanup(true)
   end
  dialoglayer.onAndroidBack = function()
    diabackEvent()
   end
  addBackEvent(dialoglayer)
  local onEnter = function()
    dialoglayer.notifyParentLock()
   end
  local onExit = function()
    dialoglayer.notifyParentUnlock()
   end
  dialoglayer:registerScriptHandler(function(l_7_0)
    if l_7_0 == "enter" then
      onEnter()
    elseif l_7_0 == "exit" then
      onExit()
    end
   end)
  return dialoglayer
end

return dialog

