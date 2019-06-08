-- Command line was: E:\github\dhgametool\scripts\ui\guild\recruit.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local player = require("data.player")
local i18n = require("res.i18n")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local bg = img.createLogin9Sprite(img.login.dialog)
  bg:setPreferredSize(CCSizeMake(512, 330))
  bg:setScale(view.minScale)
  bg:setPosition(CCPoint(view.midX, view.midY - 0 * view.minScale))
  layer:addChild(bg)
  local bg_w = bg:getContentSize().width
  local bg_h = bg:getContentSize().height
  bg:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  bg:runAction(CCSequence:create(anim_arr))
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local lbl_title = lbl.createFont1(24, "", ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(bg_w / 2, bg_h - 29))
  bg:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, "", ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(bg_w / 2, bg_h - 31))
  bg:addChild(lbl_title_shadowD)
  layer.setTitle = function(l_2_0)
    lbl_title:setString(l_2_0)
    lbl_title_shadowD:setString(l_2_0)
   end
  layer.setTitle(i18n.global.guild_btn_recruit.string)
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(bg_w - 25, bg_h - 28))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_close_menu, 100)
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local lbl_desc = lbl.createMixFont1(18, i18n.global.guild_recruit_desc.string, ccc3(112, 74, 43))
  lbl_desc:setPosition(CCPoint(bg_w / 2, 238))
  bg:addChild(lbl_desc)
  local btn_msg0 = img.createLogin9Sprite(img.login.input_border)
  btn_msg0:setPreferredSize(CCSizeMake(415, 116))
  local btn_msg = CCMenuItemSprite:create(btn_msg0, nil)
  btn_msg:setPosition(CCPoint(bg_w / 2, 160))
  local btn_msg_menu = CCMenu:createWithItem(btn_msg)
  btn_msg_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_msg_menu)
  local lbl_msg = lbl.create({kind = "ttf", size = 18, text = "", color = ccc3(112, 74, 43)})
  lbl_msg:setHorizontalAlignment(kCCTextAlignmentLeft)
  lbl_msg:setDimensions(CCSizeMake(385, 0))
  lbl_msg:setAnchorPoint(CCPoint(0, 1))
  lbl_msg:setPosition(CCPoint(15, btn_msg:getContentSize().height - 15))
  btn_msg:addChild(lbl_msg)
  btn_msg:registerScriptTapHandler(function()
    audio.play(audio.button)
    local inputlayer = require("ui.inputlayer")
    local onmsg = function(l_1_0)
      local msg_str = l_1_0 or ""
      msg_str = string.trim(msg_str)
      if containsInvalidChar(msg_str) then
        showToast(i18n.global.input_invalid_char.string)
        return 
      end
      lbl_msg:setString(msg_str)
      end
    layer:addChild(inputlayer.create(onmsg, lbl_msg:getString(), {maxLen = 60}), 1000)
   end)
  local btn_send0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_send0:setPreferredSize(CCSizeMake(160, 52))
  local lbl_send = lbl.createFont1(16, i18n.global.chat_btn_send.string, ccc3(115, 59, 5))
  lbl_send:setPosition(CCPoint(btn_send0:getContentSize().width / 2, 26))
  btn_send0:addChild(lbl_send)
  local btn_send = SpineMenuItem:create(json.ui.button, btn_send0)
  btn_send:setPosition(CCPoint(bg_w / 2, 60))
  local btn_send_menu = CCMenu:createWithItem(btn_send)
  btn_send_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_send_menu)
  btn_send:registerScriptTapHandler(function()
    disableObjAWhile(btn_send, 2)
    audio.play(audio.button)
    local msg = lbl_msg:getString()
    msg = string.trim(msg or "")
    if isBanWord(msg) or isBanWord(msg) then
      showToast(i18n.global.input_invalid_char.string)
      return 
    end
    local params = {sid = player.sid, type = 3, gud_imsg = msg}
    addWaitNet()
    netClient:chat(params, function(l_1_0)
      delWaitNet()
      showToast(i18n.global.mail_send_ok.string)
      backEvent()
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

