-- Command line was: E:\github\dhgametool\scripts\ui\solo\rewardUI.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local netClient = require("net.netClient")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local soloData = require("data.solo")
ui.create = function(l_1_0, l_1_1)
  ui.widget = {}
  ui.data = {}
  ui.data.params = l_1_0
  ui.data.mainUI = l_1_1
  ui.widget.layer = CCLayer:create()
  ui.widget.layer:setTouchEnabled(true)
  ui.widget.darkLayer = CCLayerColor:create(ccc4(0, 0, 0, 200))
  ui.widget.layer:addChild(ui.widget.darkLayer)
  ui.widget.bg = img.createLogin9Sprite(img.login.dialog)
  ui.widget.bg:setPreferredSize(CCSizeMake(444, 318))
  ui.widget.bg:setScale(view.minScale)
  ui.widget.bg:setPosition(view.midX, view.midY)
  ui.widget.layer:addChild(ui.widget.bg)
  ui.widget.title = lbl.createFont1(24, i18n.global.mail_rewards.string, ccc3(230, 208, 174))
  ui.widget.title:setPosition(ccp(ui.widget.bg:getContentSize().width / 2, 290))
  ui.widget.bg:addChild(ui.widget.title, 2)
  ui.widget.shadow = lbl.createFont1(24, i18n.global.mail_rewards.string, ccc3(89, 48, 27))
  ui.widget.shadow:setPosition(CCPoint(ui.widget.bg:getContentSize().width / 2, 288))
  ui.widget.bg:addChild(ui.widget.shadow)
  if l_1_0.goodsType == 1 then
    ui.widget.itemIcon = img.createItem(l_1_0.id, l_1_0.num)
  else
    ui.widget.itemIcon = img.createEquip(l_1_0.id, l_1_0.num)
  end
  ui.widget.itemIcon:setPosition(ccp(ui.widget.bg:getContentSize().width / 2, 180))
  ui.widget.bg:addChild(ui.widget.itemIcon)
  local confirmImg = img.createLogin9Sprite(img.login.button_9_small_gold)
  confirmImg:setPreferredSize(CCSizeMake(153, 52))
  local confirmLabel = lbl.createFont1(18, i18n.global.dialog_button_confirm.string, ccc3(115, 59, 5))
  confirmLabel:setPosition(CCPoint(confirmImg:getContentSize().width / 2, confirmImg:getContentSize().height / 2))
  confirmImg:addChild(confirmLabel)
  ui.widget.confirmBtn = SpineMenuItem:create(json.ui.button, confirmImg)
  ui.widget.confirmBtn:setPosition(ccp(ui.widget.bg:getContentSize().width / 2, 80))
  local confirmMenu = CCMenu:createWithItem(ui.widget.confirmBtn)
  confirmMenu:setPosition(CCPoint(0, 0))
  ui.widget.bg:addChild(confirmMenu)
  ui.widget.confirmBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    ui.data.mainUI.refreshBoss()
    ui.widget.layer:removeFromParent()
   end)
  ui.widget.layer:registerScriptTouchHandler(function(l_2_0, l_2_1, l_2_2)
    if l_2_0 == "began" then
      local p = ccp(l_2_1, l_2_2)
      if ui.widget.bg:boundingBox():containsPoint(p) then
        return false
      else
        return true
      end
    elseif l_2_0 == "ended" then
      ui.data.mainUI.refreshBoss()
      ui.widget.layer:removeFromParent()
    end
   end)
  ui.widget.layer.onAndroidBack = function()
    audio.play(audio.button)
    ui.data.mainUI.refreshBoss()
    ui.widget.layer:removeFromParent()
   end
  addBackEvent(ui.widget.layer)
  ui.widget.layer:registerScriptHandler(function(l_4_0)
    if l_4_0 == "enter" then
      ui.widget.layer.notifyParentLock()
    elseif l_4_0 == "exit" then
      ui.widget.layer.notifyParentUnlock()
    end
   end)
  ui.widget.bg:setScale(0.5 * view.minScale)
  ui.widget.bg:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  return ui.widget.layer
end

return ui

