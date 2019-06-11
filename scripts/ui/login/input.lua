-- Command line was: E:\github\dhgametool\scripts\ui\login\input.lua 

local ui = {}
require("config")
require("framework.init")
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local userdata = require("data.userdata")
local BG_WIDTH = 446
local BG_HEIGHT = 336
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local darkBg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkBg)
  local bg = img.createLogin9Sprite(img.login.dialog)
  bg:setPreferredSize(CCSize(BG_WIDTH, BG_HEIGHT))
  bg:setScale(view.minScale)
  bg:setPosition(scalep(480, 314))
  layer:addChild(bg)
  local closeBtn0 = img.createLoginSprite(img.login.button_close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(BG_WIDTH - 30, BG_HEIGHT - 30)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  bg:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer.onAndroidBack()
   end)
  local titleText = i18n.global.sign_in_title.string
  local title = lbl.createFont1(24, titleText, ccc3(230, 208, 174))
  title:setPosition(BG_WIDTH / 2, BG_HEIGHT - 30)
  local titleS = lbl.createFont1(24, titleText, ccc3(89, 48, 27))
  titleS:setPosition(BG_WIDTH / 2, BG_HEIGHT - 32)
  bg:addChild(titleS)
  bg:addChild(title)
  local acct = userdata.getString(userdata.keys.account)
  local pass = userdata.getEncryptString(userdata.keys.password)
  local acctText = i18n.global.sign_in_username.string
  local acctLabel = lbl.createFont1(18, acctText, ccc3(113, 63, 22))
  acctLabel:setAnchorPoint(ccp(0, 0.5))
  acctLabel:setPosition(60, 247)
  bg:addChild(acctLabel)
  local passText = i18n.global.sign_in_password.string
  local passLabel = lbl.createFont1(18, passText, ccc3(113, 63, 22))
  passLabel:setAnchorPoint(ccp(0, 0.5))
  passLabel:setPosition(acctLabel:getPositionX(), 175)
  bg:addChild(passLabel)
  local inputAcctBg = img.createLogin9Sprite(img.login.input_border)
  local inputAcct = CCEditBox:create(CCSize(325 * view.minScale, 40 * view.minScale), inputAcctBg)
  inputAcct:setInputFlag(kEditBoxInputFlagInitialCapsSentence)
  inputAcct:setReturnType(kKeyboardReturnTypeDone)
  if device.platform == "android" then
    inputAcct:setFont("", 16 * view.minScale)
  else
    if device.platform == "ios" then
      inputAcct:setFont("", 16 * view.minScale)
    end
  end
  inputAcct:setFontColor(ccc3(0, 0, 0))
  inputAcct:setPosition(scalep(480, 359))
  layer:addChild(inputAcct, 1)
  local inputPassBg = img.createLogin9Sprite(img.login.input_border)
  local inputPass = CCEditBox:create(CCSize(325 * view.minScale, 40 * view.minScale), inputPassBg)
  inputPass:setInputFlag(kEditBoxInputFlagPassword)
  inputPass:setReturnType(kKeyboardReturnTypeDone)
  if device.platform == "android" then
    inputPass:setFont("", 16 * view.minScale)
  else
    if device.platform == "ios" then
      inputPass:setFont("", 14 * view.minScale)
    end
  end
  inputPass:setFontColor(ccc3(0, 0, 0))
  inputPass:setPosition(scalep(480, 286))
  layer:addChild(inputPass, 1)
  if acct ~= "" and pass ~= "" then
    inputAcct:setText(acct)
    inputPass:setText("_______________")
  end
  local forgetBtn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  forgetBtn0:setPreferredSize(CCSize(160, 50))
  local forgetBtn = SpineMenuItem:create(json.ui.button, forgetBtn0)
  local forgetSize = forgetBtn:getContentSize()
  forgetBtn:setPosition(BG_WIDTH / 2 - 85, 66)
  local forgetText = i18n.global.forget_password_btn.string
  local forgetLabel = lbl.createFont1(14, forgetText, ccc3(115, 59, 5))
  forgetLabel:setPosition(forgetSize.width / 2, forgetSize.height / 2)
  forgetBtn0:addChild(forgetLabel)
  local forgetMenu = CCMenu:createWithItem(forgetBtn)
  forgetMenu:setPosition(0, 0)
  bg:addChild(forgetMenu)
  forgetBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.login.forget").create(), 1000)
   end)
  local okBtn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  okBtn0:setPreferredSize(CCSize(160, 50))
  local okBtn = SpineMenuItem:create(json.ui.button, okBtn0)
  local okSize = okBtn:getContentSize()
  okBtn:setPosition(BG_WIDTH / 2 + 85, 66)
  local okText = i18n.global.dialog_button_confirm.string
  local okLabel = lbl.createFont1(16, okText, ccc3(115, 59, 5))
  okLabel:setPosition(okSize.width / 2, okSize.height / 2)
  okBtn0:addChild(okLabel)
  local okMenu = CCMenu:createWithItem(okBtn)
  okMenu:setPosition(0, 0)
  bg:addChild(okMenu)
  okBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local agree = userdata.getBool(userdata.keys.agree_user_protocol)
    local lan = i18n.getLanguageShortName()
    if lan == "cn" and not agree then
      showToast("\232\175\183\229\139\190\233\128\137\228\184\139\230\150\185\231\154\132\231\148\168\230\136\183\229\141\143\232\174\174\239\188\140\229\141\179\229\143\175\232\191\155\229\133\165\230\184\184\230\136\143")
      return 
    end
    local newAcct = string.lower(string.trim(inputAcct:getText()))
    local newPass = string.trim(inputPass:getText())
    if newAcct ~= "" and newPass ~= "" then
      newPass = crypto.md5(newPass, false)
      ui.switchAccount(newAcct, newPass, function(l_1_0)
        if l_1_0 == "ok" then
          layer.onAndroidBack()
          if onSuccess then
            onSuccess(newAcct)
          end
        end
         end)
    end
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParent()
   end
  layer:registerScriptHandler(function(l_5_0)
    if l_5_0 == "enter" then
      layer.notifyParentLock()
    elseif l_5_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

ui.switchAccount = function(l_2_0, l_2_1, l_2_2)
  local isDone = false
  addWaitNet(function()
    delWaitNet()
    net:close()
    upvalue_512 = true
    showToast(i18n.global.error_network_timeout.string)
   end)
  require("ui.login.auth").start({account = l_2_0, password = l_2_1}, function(l_2_0)
    delWaitNet()
    if not isDone then
      net:close()
      isDone = true
      if l_2_0 == "ok" then
        userdata.setString(userdata.keys.account, account)
        userdata.setEncryptString(userdata.keys.password, password)
        userdata.setBool(userdata.keys.accountFormal, true)
        userdata.clearWhenSwitchAccount()
      else
        showToast(l_2_0)
      end
      onSwitch(l_2_0)
    end
   end)
end

return ui

