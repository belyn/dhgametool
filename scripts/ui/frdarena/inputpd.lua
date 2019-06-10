-- Command line was: E:\github\dhgametool\scripts\ui\frdarena\inputpd.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local net = require("net.netClient")
local player = require("data.player")
local databag = require("data.bag")
local audio = require("res.audio")
ui.create = function(l_1_0, l_1_1)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 210))
  local board_w = 465
  local board_h = 320
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(board_w, board_h))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local btnCloseSp = img.createLoginSprite(img.login.button_close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSp)
  btnClose:setPosition(438, 294)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local showText = lbl.createMixFont1(18, i18n.global.frdpvp_team_inputpwd.string, ccc3(113, 63, 22))
  showText:setPosition(board:getContentSize().width / 2, 214)
  board:addChild(showText)
  local edit_normal = img.createLogin9Sprite(img.login.input_border)
  local edit_click = img.createLogin9Sprite(img.login.input_border)
  local edit = CCEditBox:create(CCSizeMake(300 * view.minScale, 40 * view.minScale), edit_normal, edit_click)
  edit:setInputFlag(kEditBoxInputFlagInitialCapsSentence)
  edit:setFontColor(ccc3(115, 59, 5))
  edit:setReturnType(kKeyboardReturnTypeDone)
  edit:setMaxLength(240)
  edit:setFont("", 16 * view.minScale)
  edit:setPosition(view.midX, view.midY + 5)
  layer:addChild(edit, 10000)
  local btnConfirm = nil
  local btnConfirmSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnConfirmSprite:setPreferredSize(CCSize(168, 52))
  local labConfirm = lbl.createFont1(16, i18n.global.player_change_name_confirm.string, ccc3(113, 63, 22))
  labConfirm:setPosition(btnConfirmSprite:getContentSize().width / 2, btnConfirmSprite:getContentSize().height / 2)
  btnConfirmSprite:addChild(labConfirm)
  btnConfirm = SpineMenuItem:create(json.ui.button, btnConfirmSprite)
  btnConfirm:setPosition(board_w / 2, 86)
  local menuConfirm = CCMenu:create()
  menuConfirm:setPosition(0, 0)
  menuConfirm:addChild(btnConfirm)
  board:addChild(menuConfirm)
  btnConfirm:registerScriptTapHandler(function()
    audio.play(audio.button)
    local input_pwd = edit:getText()
    input_pwd = string.trim(input_pwd)
    if not input_pwd or string.len(input_pwd) < 4 or string.len(input_pwd) > 11 then
      showToast(i18n.global.setting_invalid_passwd.string)
      return 
    end
    local params = {sid = player.sid, password = input_pwd}
    tbl2string(params)
    addWaitNet()
    net:set_gpvppwd(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status < 0 then
        showToast("status:" .. l_1_0.status)
        return 
      end
      layer:removeFromParentAndCleanup(true)
      end)
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_6_0)
    if l_6_0 == "enter" then
      onEnter()
    elseif l_6_0 == "exit" then
      onExit()
    end
   end)
  layer:registerScriptTouchHandler(function()
    return true
   end)
  layer:setTouchEnabled(true)
  return layer
end

return ui

