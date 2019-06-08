-- Command line was: E:\github\dhgametool\scripts\ui\town\IdCardVerifyDialog.lua 

local ui = {}
require("common.const")
require("common.func")
require("framework.init")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local player = require("data.player")
local preventAddictionData = require("data.preventaddiction")
local BG_WIDTH = 494
local BG_HEIGHT = 369
ui.create = function()
  local layer = CCLayer:create()
  local darkBg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkBg)
  local bg = img.createLogin9Sprite(img.login.dialog)
  bg:setPreferredSize(CCSize(BG_WIDTH, BG_HEIGHT))
  bg:setScale(view.minScale)
  bg:setPosition(scalep(480, 314))
  layer:addChild(bg)
  local titleText = "\229\174\158\229\144\141\232\174\164\232\175\129"
  local title = lbl.createFontTTF(24, titleText, ccc3(230, 208, 174))
  title:setPosition(BG_WIDTH / 2, BG_HEIGHT - 30)
  local titleS = lbl.createFontTTF(24, titleText, ccc3(89, 48, 27))
  titleS:setPosition(BG_WIDTH / 2, BG_HEIGHT - 32)
  bg:addChild(titleS)
  bg:addChild(title)
  local closeBtn0 = img.createLoginSprite(img.login.button_close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(BG_WIDTH - 24, BG_HEIGHT - 24)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  bg:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer.onAndroidBack()
   end)
  local nameText = "\229\167\147\229\144\141"
  local nameLabel = lbl.createFontTTF(18, nameText, ccc3(113, 63, 22))
  nameLabel:setAnchorPoint(ccp(0, 0.5))
  nameLabel:setPosition(71, 264)
  bg:addChild(nameLabel)
  local idCardText = "\232\186\171\228\187\189\232\175\129\229\143\183"
  local idCardLabel = lbl.createFontTTF(18, idCardText, ccc3(113, 63, 22))
  idCardLabel:setAnchorPoint(ccp(0, 0.5))
  idCardLabel:setPosition(nameLabel:getPositionX(), 190)
  bg:addChild(idCardLabel)
  local nameBg = img.createLogin9Sprite(img.login.input_border)
  local nameEditBox = CCEditBox:create(CCSize(354 * view.minScale, 40 * view.minScale), nameBg)
  nameEditBox:setInputFlag(kEditBoxInputFlagInitialCapsSentence)
  nameEditBox:setReturnType(kKeyboardReturnTypeDone)
  if device.platform == "android" then
    nameEditBox:setFont("", 16 * view.minScale)
  else
    if device.platform == "ios" then
      nameEditBox:setFont("", 14 * view.minScale)
    end
  end
  nameEditBox:setFontColor(ccc3(0, 0, 0))
  nameEditBox:setPosition(scalep(480, 359))
  layer:addChild(nameEditBox, 1)
  local idCardBg = img.createLogin9Sprite(img.login.input_border)
  local idCardEditBox = CCEditBox:create(CCSize(354 * view.minScale, 40 * view.minScale), idCardBg)
  idCardEditBox:setReturnType(kKeyboardReturnTypeDone)
  if device.platform == "android" then
    idCardEditBox:setFont("", 16 * view.minScale)
  else
    if device.platform == "ios" then
      idCardEditBox:setFont("", 14 * view.minScale)
    end
  end
  idCardEditBox:setFontColor(ccc3(0, 0, 0))
  idCardEditBox:setPosition(scalep(480, 286))
  layer:addChild(idCardEditBox, 1)
  local okBtn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  okBtn0:setPreferredSize(CCSize(172, 50))
  local okBtn = SpineMenuItem:create(json.ui.button, okBtn0)
  local okSize = okBtn:getContentSize()
  okBtn:setPosition(BG_WIDTH / 2, 76)
  local okText = "\232\191\155\232\161\140\229\174\158\229\144\141\232\174\164\232\175\129"
  local okLabel = lbl.createFontTTF(16, okText, ccc3(115, 59, 5))
  okLabel:setPosition(okSize.width / 2, okSize.height / 2)
  okBtn0:addChild(okLabel)
  local okMenu = CCMenu:createWithItem(okBtn)
  okMenu:setPosition(0, 0)
  bg:addChild(okMenu)
  okBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local name = string.trim(nameEditBox:getText())
    local idCard = string.trim(idCardEditBox:getText())
    local params = {sid = player.sid, id = idCard, name = name}
    local isDone = false
    addWaitNet(function()
      delWaitNet()
      isDone = true
      net:close()
      showToast(i18n.global.error_network_timeout.string)
      end)
    net:idcard_verify(params, function(l_2_0)
      delWaitNet()
      if isDone then
        return 
      end
      isDone = true
      if l_2_0.status == 0 then
        showToast("\229\174\158\229\144\141\232\174\164\232\175\129\230\136\144\229\138\159")
        layer:removeFromParent()
        if l_2_0.adult then
          preventAddictionData.setAdult(l_2_0.adult)
        elseif l_2_0.status == -1 then
          showToast("\232\175\183\232\190\147\229\133\165\230\173\163\231\161\174\231\154\132\229\144\141\229\173\151\229\146\140\232\186\171\228\187\189\232\175\129\229\143\183\231\160\129")
        elseif l_2_0.status == -2 then
          showToast("\232\175\183\232\190\147\229\133\165\230\173\163\231\161\174\231\154\132\229\144\141\229\173\151\229\146\140\232\186\171\228\187\189\232\175\129\229\143\183\231\160\129")
        elseif l_2_0.status == -3 then
          showToast("\232\175\183\232\190\147\229\133\165\230\173\163\231\161\174\231\154\132\229\144\141\229\173\151\229\146\140\232\186\171\228\187\189\232\175\129\229\143\183\231\160\129")
        else
          showToast("\232\175\183\232\190\147\229\133\165\230\173\163\231\161\174\231\154\132\229\144\141\229\173\151\229\146\140\232\186\171\228\187\189\232\175\129\229\143\183\231\160\129")
        end
      end
      end)
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParent()
   end
  layer:registerScriptHandler(function(l_4_0)
    if l_4_0 == "enter" then
      layer.notifyParentLock()
    elseif l_4_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

