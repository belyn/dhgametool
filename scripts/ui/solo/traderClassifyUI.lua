-- Command line was: E:\github\dhgametool\scripts\ui\solo\traderClassifyUI.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local net = require("net.netClient")
local audio = require("res.audio")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local player = require("data.player")
local bagdata = require("data.bag")
local casinodata = require("data.casino")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local soloData = require("data.solo")
local traderConf = require("config.spktrader")
local dialog = require("ui.dialog")
local cfgTrader = require("config.spktrader")
ui.create = function()
  local layer = CCLayer:create()
  layer:setTouchEnabled(true)
  local darkBg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkBg)
  local bg = img.createUI9Sprite(img.ui.dialog_1)
  bg:setPreferredSize(CCSizeMake(864, 515))
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
  local width = bg:getContentSize().width
  local height = bg:getContentSize().height
  local title = i18n.global.solo_trader_title.string
  local titleLabel = lbl.createFont1(24, title, ccc3(230, 208, 174))
  titleLabel:setPosition(CCPoint(width / 2, height - 29))
  bg:addChild(titleLabel, 2)
  local shadow = lbl.createFont1(24, title, ccc3(89, 48, 27))
  shadow:setPosition(CCPoint(width / 2, height - 31))
  bg:addChild(shadow)
  local closeImg = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeImg)
  closeBtn:setPosition(CCPoint(width - 25, height - 28))
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  bg:addChild(closeMenu, 10)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParent()
   end)
  local startX = 178
  local intervalX = 253
  local labelPosY = 418
  local iconPosY = 263
  local btnPosY = 88
  for i = 1, 3 do
    do
      local traderLabel = lbl.createFont2(18, i18n.global.solo_trader_level" .. .string, ccc3(255, 246, 223))
      do
        local traderIcon = img.createUISprite(img.ui.solo_trader_" .. )
        local traderBtnImg = img.createLogin9Sprite(img.login.button_9_small_gold)
        traderBtnImg:setPreferredSize(CCSizeMake(164, 60))
        local confirmLabel = lbl.createFont1(18, i18n.global.chip_btn_buy.string, ccc3(115, 59, 5))
        confirmLabel:setPosition(CCPoint(traderBtnImg:getContentSize().width / 2, traderBtnImg:getContentSize().height / 2))
        traderBtnImg:addChild(confirmLabel)
        local traderBtn = SpineMenuItem:create(json.ui.button, traderBtnImg)
        local traderMenu = CCMenu:createWithItem(traderBtn)
        traderMenu:setPosition(ccp(0, 0))
        bg:addChild(traderMenu)
        bg:addChild(traderIcon)
        bg:addChild(traderLabel)
        traderLabel:setPositionX(startX + intervalX * (i - 1))
        traderIcon:setPositionX(traderLabel:getPositionX())
        traderBtn:setPositionX(traderLabel:getPositionX())
        traderLabel:setPositionY(labelPosY)
        traderIcon:setPositionY(iconPosY)
        traderBtn:setPositionY(btnPosY)
        traderBtn:registerScriptTapHandler(function()
          audio.play(audio.button)
          traderBtn:setEnabled(false)
          local delay = CCDelayTime:create(0.8)
          local callfunc = CCCallFunc:create(function()
            traderBtn:setEnabled(true)
               end)
          local sequence = CCSequence:createWithTwoActions(delay, callfunc)
          traderBtn:runAction(sequence)
          local traderUI = require("ui.solo.traderUI").create(i)
          layer:addChild(traderUI, 99999)
            end)
      end
    end
  end
  layer.onAndroidBack = function()
    audio.play(audio.button)
    layer:removeFromParent()
   end
  addBackEvent(layer)
  layer:registerScriptHandler(function(l_4_0)
    if l_4_0 == "enter" then
      layer.notifyParentLock()
    elseif l_4_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
  bg:setScale(0.5 * view.minScale)
  bg:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  return layer
end

return ui

