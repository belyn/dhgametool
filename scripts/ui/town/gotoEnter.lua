-- Command line was: E:\github\dhgametool\scripts\ui\town\gotoEnter.lua 

local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local i18n = require("res.i18n")
local json = require("res.json")
local audio = require("res.audio")
local dataGuild = require("data.guild")
local dataPlayer = require("data.player")
local dataHeros = require("data.heros")
local net = require("net.netClient")
local player = require("data.player")
local userdata = require("data.userdata")
local droidhangComponents = require("dhcomponents.DroidhangComponents")
local gotoEnter = class("gotoEnter", function()
  return cc.LayerColor:create(cc.c4b(0, 0, 0, POPUP_DARK_OPACITY))
end
)
gotoEnter.create = function(l_2_0)
  if APP_CHANNEL and APP_CHANNEL == "IAS" then
    do return end
  end
  if isOnestore() then
    do return end
  end
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    return require("ui.town.gotoHelper").create()
  end
  local isFormal = userdata.getBool(userdata.keys.accountFormal)
  if isFormal then
    return require("ui.town.gotoHelper").create()
  else
    return gotoEnter.new(l_2_0)
  end
end

gotoEnter.ctor = function(l_3_0, l_3_1)
  img.load(img.packedOthers.ui_private_service)
  local BG_WIDTH = 600
  local BG_HEIGHT = 400
  local bg = img.createLogin9Sprite(img.login.dialog)
  bg:setPreferredSize(CCSize(BG_WIDTH, BG_HEIGHT))
  bg:setScale(view.minScale * 0.1)
  bg:setAnchorPoint(ccp(0.5, 0.5))
  bg:setPosition(scalep(480, 288))
  bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  l_3_0:addChild(bg)
  l_3_0.bg = bg
  local showTitle = lbl.createFont1(26, i18n.global.ui_private_service.string, ccc3(230, 208, 174))
  showTitle:setPosition(bg:getContentSize().width / 2, BG_HEIGHT - 28)
  bg:addChild(showTitle, 1)
  local showTitleShade = lbl.createFont1(26, i18n.global.ui_private_service.string, ccc3(89, 48, 27))
  showTitleShade:setPosition(bg:getContentSize().width / 2, BG_HEIGHT - 30)
  bg:addChild(showTitleShade)
  local left0 = img.createUISprite(img.ui.ui_private_service_left)
  local leftBtn = SpineMenuItem:create(json.ui.button, left0)
  droidhangComponents:mandateNode(leftBtn, "8qa8_isc49N")
  local leftMenu = CCMenu:createWithItem(leftBtn)
  leftMenu:setPosition(CCPoint(0, 0))
  bg:addChild(leftMenu, 1)
  leftBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    self:getParent():addChild(require("ui.setting.register").create(), 1000)
    self:removeFromParent()
   end)
  local leftDes = lbl.create({font = 1, size = 18, text = i18n.global.gotoHelper_enter_title_1.string, color = ccc3(115, 59, 5), width = 220, align = kCCTextAlignmentLeft})
  leftDes:setAnchorPoint(0.5, 1)
  leftDes:setPosition(CCPoint(leftBtn:getPositionX(), leftBtn:getPositionY() - leftBtn:getContentSize().height * 0.5 - 10))
  bg:addChild(leftDes)
  local right0 = img.createUISprite(img.ui.ui_private_service_right)
  local rightBtn = SpineMenuItem:create(json.ui.button, right0)
  droidhangComponents:mandateNode(rightBtn, "8qa8_xn7oEE")
  local rightMenu = CCMenu:createWithItem(rightBtn)
  rightMenu:setPosition(CCPoint(0, 0))
  bg:addChild(rightMenu, 1)
  rightBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    self:getParent():addChild(require("ui.town.gotoHelper").create(), 1000)
    self:removeFromParent()
   end)
  local rightDes = lbl.create({font = 1, size = 18, text = i18n.global.gotoHelper_enter_title_2.string, color = ccc3(115, 59, 5), width = 220, align = kCCTextAlignmentLeft})
  rightDes:setAnchorPoint(0.5, 1)
  rightDes:setPosition(CCPoint(rightBtn:getPositionX(), rightBtn:getPositionY() - rightBtn:getContentSize().height * 0.5 - 10))
  bg:addChild(rightDes)
  local onTouch = function(l_3_0, l_3_1, l_3_2)
    if l_3_0 == "began" then
      return true
    end
   end
  l_3_0:registerScriptTouchHandler(onTouch, false, -128, false)
  l_3_0:setTouchEnabled(true)
  local backEvent = function()
    self:removeFromParentAndCleanup(true)
   end
  local close0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, close0)
  droidhangComponents:mandateNode(closeBtn, "BZds_aASC8V")
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  bg:addChild(closeMenu, 1)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    backEvent()
   end)
  addBackEvent(l_3_0)
  l_3_0.onAndroidBack = function()
    backEvent()
   end
  l_3_0:registerScriptHandler(function(l_7_0)
    if l_7_0 == "cleanup" then
      img.unload(img.packedOthers.ui_private_service)
    elseif l_7_0 == "enter" then
      self.notifyParentLock()
    elseif l_7_0 == "exit" then
      self.notifyParentUnlock()
    end
   end)
end

return gotoEnter

