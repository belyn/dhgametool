-- Command line was: E:\github\dhgametool\scripts\ui\setting\register.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local player = require("data.player")
local userdata = require("data.userdata")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
ui.create = function()
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board = img.createUI9Sprite(img.ui.dialog_1)
  board:setPreferredSize(CCSizeMake(510, 400))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local lbl_title = lbl.createFont1(24, i18n.global.setting_btn_reg.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_w / 2, board_h - 29))
  board:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.setting_btn_reg.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_w / 2, board_h - 31))
  board:addChild(lbl_title_shadowD)
  local lbl_acct = lbl.createMixFont1(18, i18n.global.setting_account.string, ccc3(113, 63, 22))
  lbl_acct:setAnchorPoint(CCPoint(0, 0))
  lbl_acct:setPosition(CCPoint(79, 305))
  board:addChild(lbl_acct)
  local lbl_passwd = lbl.createMixFont1(18, i18n.global.setting_passwd.string, ccc3(113, 63, 22))
  lbl_passwd:setAnchorPoint(CCPoint(0, 0))
  lbl_passwd:setPosition(CCPoint(79, 232))
  board:addChild(lbl_passwd)
  local lbl_cpasswd = lbl.createMixFont1(18, i18n.global.setting_cpasswd.string, ccc3(113, 63, 22))
  lbl_cpasswd:setAnchorPoint(CCPoint(0, 0))
  lbl_cpasswd:setPosition(CCPoint(79, 161))
  board:addChild(lbl_cpasswd)
  local edit_acct0 = img.createLogin9Sprite(img.login.input_border)
  local edit_acct = CCEditBox:create(CCSizeMake(354 * view.minScale, 44 * view.minScale), edit_acct0)
  edit_acct:setInputFlag(kEditBoxInputFlagInitialCapsSentence)
  edit_acct:setReturnType(kKeyboardReturnTypeDone)
  edit_acct:setMaxLength(150)
  edit_acct:setFont("", 18 * view.minScale)
  edit_acct:setFontColor(ccc3(113, 63, 22))
  edit_acct:setPlaceHolder("mail")
  edit_acct:setVisible(false)
  edit_acct:setPosition(scalep(480, 371))
  layer:addChild(edit_acct, 100)
  local edit_passwd0 = img.createLogin9Sprite(img.login.input_border)
  local edit_passwd = CCEditBox:create(CCSizeMake(354 * view.minScale, 44 * view.minScale), edit_passwd0)
  edit_passwd:setInputFlag(kEditBoxInputFlagPassword)
  edit_passwd:setReturnType(kKeyboardReturnTypeDone)
  edit_passwd:setMaxLength(14)
  if device.platform == "android" then
    edit_passwd:setFont("", 16 * view.minScale)
  else
    if device.platform == "ios" then
      edit_passwd:setFont("", 14 * view.minScale)
    end
  end
  edit_passwd:setFontColor(ccc3(113, 63, 22))
  edit_passwd:setPlaceHolder("")
  edit_passwd:setVisible(false)
  edit_passwd:setPosition(scalep(480, 299))
  layer:addChild(edit_passwd, 100)
  local edit_cpasswd0 = img.createLogin9Sprite(img.login.input_border)
  local edit_cpasswd = CCEditBox:create(CCSizeMake(354 * view.minScale, 44 * view.minScale), edit_cpasswd0)
  edit_cpasswd:setInputFlag(kEditBoxInputFlagPassword)
  edit_cpasswd:setReturnType(kKeyboardReturnTypeDone)
  edit_cpasswd:setMaxLength(14)
  if device.platform == "android" then
    edit_cpasswd:setFont("", 16 * view.minScale)
  else
    if device.platform == "ios" then
      edit_cpasswd:setFont("", 14 * view.minScale)
    end
  end
  edit_cpasswd:setFontColor(ccc3(113, 63, 22))
  edit_cpasswd:setPlaceHolder("")
  edit_cpasswd:setVisible(false)
  edit_cpasswd:setPosition(scalep(480, 227))
  layer:addChild(edit_cpasswd, 100)
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
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local btn_cancel0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_cancel0:setPreferredSize(CCSizeMake(160, 55))
  local lbl_cancel = lbl.createFont1(18, i18n.global.dialog_button_cancel.string, ccc3(115, 59, 5))
  lbl_cancel:setPosition(CCPoint(btn_cancel0:getContentSize().width / 2, btn_cancel0:getContentSize().height / 2))
  btn_cancel0:addChild(lbl_cancel)
  local btn_cancel = SpineMenuItem:create(json.ui.button, btn_cancel0)
  btn_cancel:setPosition(CCPoint(board_w / 2 - 98, 66))
  local btn_cancel_menu = CCMenu:createWithItem(btn_cancel)
  btn_cancel_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_cancel_menu)
  local btn_regist0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_regist0:setPreferredSize(CCSizeMake(160, 55))
  local lbl_regist = lbl.createFont1(18, i18n.global.setting_btn_reg.string, ccc3(115, 59, 5))
  lbl_regist:setPosition(CCPoint(btn_regist0:getContentSize().width / 2, btn_regist0:getContentSize().height / 2))
  btn_regist0:addChild(lbl_regist)
  local btn_regist = SpineMenuItem:create(json.ui.button, btn_regist0)
  btn_regist:setPosition(CCPoint(board_w / 2 + 98, 66))
  local btn_regist_menu = CCMenu:createWithItem(btn_regist)
  btn_regist_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_regist_menu)
  edit_acct:setVisible(true)
  edit_passwd:setVisible(true)
  edit_cpasswd:setVisible(true)
  btn_cancel:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  btn_regist:registerScriptTapHandler(function()
    audio.play(audio.button)
    print("onRegist")
    local input_account = edit_acct:getText()
    input_account = string.trim(input_account)
    input_account = string.lower(input_account)
    if isEmail(input_account) then
      do return end
    end
    showToast(i18n.global.setting_bad_email.string)
    return 
    if containsInvalidChar(input_account) then
      showToast(i18n.global.input_invalid_char.string)
      return 
    end
    local input_pwd = edit_passwd:getText()
    input_pwd = string.trim(input_pwd)
    if not input_pwd or string.len(input_pwd) < 6 then
      showToast(i18n.global.setting_invalid_passwd.string)
      return 
    end
    local input_cpwd = edit_cpasswd:getText()
    input_cpwd = string.trim(input_cpwd)
    if input_cpwd ~= input_pwd then
      showToast(i18n.global.setting_passwd_same.string)
      return 
    end
    input_pwd = crypto.md5(input_pwd, false)
    local params = {sid = player.sid, account = input_account, password = input_pwd}
    addWaitNet()
    netClient:bind(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status == -1 then
        showToast(i18n.global.setting_account_binded.string)
        return 
      end
      userdata.setString(userdata.keys.account, params.account)
      userdata.setEncryptString(userdata.keys.password, params.password)
      userdata.setBool(userdata.keys.accountFormal, true)
      local achieveData = require("data.achieve")
      achieveData.add(ACHIEVE_TYPE_REGISTER, 1)
      replaceScene(require("ui.town.main").create({from_layer = "language"}))
      end)
   end)
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
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

