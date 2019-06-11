-- Command line was: E:\github\dhgametool\scripts\ui\solo\useDrugUI.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local soloData = require("data.solo")
ui.create = function(l_1_0, l_1_1, l_1_2, l_1_3)
  ui.widget = {}
  ui.data = {}
  print("\232\141\175\230\176\180" .. l_1_0 .. l_1_1)
  ui.data.drugType = l_1_0
  ui.data.drugId = l_1_1
  ui.data.hid = l_1_3
  ui.data.mainUI = l_1_2
  ui.widget.layer = CCLayer:create()
  ui.widget.layer:setTouchEnabled(true)
  ui.widget.darkLayer = CCLayerColor:create(ccc4(0, 0, 0, 200))
  ui.widget.layer:addChild(ui.widget.darkLayer)
  ui.widget.bg = img.createLogin9Sprite(img.login.dialog)
  ui.widget.bg:setPreferredSize(CCSizeMake(444, 318))
  ui.widget.bg:setScale(view.minScale)
  ui.widget.bg:setPosition(view.midX, view.midY)
  ui.widget.layer:addChild(ui.widget.bg)
  local bg_w = ui.widget.bg:getContentSize().width
  local bg_h = ui.widget.bg:getContentSize().height
  ui.widget.title = lbl.createFont1(24, i18n.global.solo_drugUse.string, ccc3(230, 208, 174))
  ui.widget.title:setPosition(ccp(ui.widget.bg:getContentSize().width / 2, 290))
  ui.widget.bg:addChild(ui.widget.title, 2)
  ui.widget.titleShadow = lbl.createFont1(24, i18n.global.solo_drugUse.string, ccc3(89, 48, 27))
  ui.widget.titleShadow:setPosition(CCPoint(ui.widget.bg:getContentSize().width / 2, 288))
  ui.widget.bg:addChild(ui.widget.titleShadow, 1)
  local itemImgStr = {speed = img.ui.solo_speed_potion, power = img.ui.solo_power_potion, crit = img.ui.solo_crit_potion, milk = img.ui.solo_milk, angel = img.ui.solo_angel_potion, evil = img.ui.solo_evil_potion}
  ui.widget.itemIcon = img.createUISprite(img.ui.grid)
  ui.widget.itemIcon:setPosition(ccp(ui.widget.bg:getContentSize().width / 2, 180))
  ui.widget.bg:addChild(ui.widget.itemIcon)
  local size = ui.widget.itemIcon:getContentSize()
  ui.widget.itemContent = img.createUISprite(itemImgStr[ui.data.drugType])
  ui.widget.itemContent:setPosition(ccp(size.width / 2, size.height / 2))
  ui.widget.itemContent:setScale(size.width / ui.widget.itemContent:getContentSize().width)
  ui.widget.itemIcon:addChild(ui.widget.itemContent)
  local sprite = CCSprite:create()
  sprite:setContentSize(ui.widget.itemIcon:getContentSize())
  ui.widget.iconBtn = SpineMenuItem:create(json.ui.button, sprite)
  ui.widget.iconBtn:setPosition(ui.widget.itemIcon:getPosition())
  local btnMenu = CCMenu:createWithItem(ui.widget.iconBtn)
  btnMenu:setPosition(CCPoint(0, 0))
  ui.widget.bg:addChild(btnMenu)
  local confirmImg = img.createLogin9Sprite(img.login.button_9_small_gold)
  confirmImg:setPreferredSize(CCSizeMake(153, 52))
  local confirmLabel = lbl.createFont1(18, i18n.global.herotast_use_sco.string, ccc3(115, 59, 5))
  confirmLabel:setPosition(CCPoint(confirmImg:getContentSize().width / 2, confirmImg:getContentSize().height / 2))
  confirmImg:addChild(confirmLabel)
  ui.widget.confirmBtn = SpineMenuItem:create(json.ui.button, confirmImg)
  ui.widget.confirmBtn:setPosition(ccp(ui.widget.bg:getContentSize().width / 2, 80))
  local confirmMenu = CCMenu:createWithItem(ui.widget.confirmBtn)
  confirmMenu:setPosition(CCPoint(0, 0))
  ui.widget.bg:addChild(confirmMenu)
  if l_1_0 == "milk" or l_1_0 == "angel" or l_1_0 == "evil" then
    confirmLabel:setString(i18n.global.crystal_btn_save.string)
  end
  local closeImg = img.createUISprite(img.ui.close)
  ui.widget.closeBtn = SpineMenuItem:create(json.ui.button, closeImg)
  ui.widget.closeBtn:setPosition(CCPoint(bg_w - 30, bg_h - 30))
  local closeMenu = CCMenu:createWithItem(ui.widget.closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  ui.widget.bg:addChild(closeMenu, 100)
  ui.widget.bg:setScale(0.5 * view.minScale)
  ui.widget.bg:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  ui.callBack()
  return ui.widget.layer
end

ui.callBack = function()
  ui.widget.confirmBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    addWaitNet()
    local params = nil
    if ui.data.drugType == "milk" or ui.data.drugType == "angel" or ui.data.drugType == "evil" then
      params = {sid = player.sid, buf = ui.data.drugId, save = 1}
      print("\228\191\157\229\173\152\232\141\175\230\176\180")
    else
      params = {sid = player.sid, buf = ui.data.drugId, hid = ui.data.hid}
      print("\228\189\191\231\148\168\232\141\175\230\176\180")
    end
    tablePrint(params)
    net:spk_buf(params, function(l_1_0)
      delWaitNet()
      print("\232\141\175\230\176\180\232\191\148\229\155\158\230\149\176\230\141\174")
      tablePrint(l_1_0)
      if l_1_0.status == 0 then
        ui.data.mainUI.setStage(l_1_0.nstage)
        if ui.data.drugType == "milk" or ui.data.drugType == "angel" or ui.data.drugType == "evil" then
          ui.data.mainUI.savePotion()
          ui.widget.layer:removeFromParent()
        else
          ui.data.mainUI.usePotion()
          ui.widget.layer:removeFromParent()
        end
      end
      end)
   end)
  ui.widget.closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    ui.widget.layer:removeFromParent()
   end)
  ui.widget.iconBtn:registerScriptTapHandler(function()
    print("\231\130\185\228\184\173\228\186\134\230\140\137\233\146\174")
    audio.play(audio.button)
    ui.showItemIntro()
   end)
  ui.widget.layer.onAndroidBack = function()
    audio.play(audio.button)
    ui.widget.layer:removeFromParent()
   end
  addBackEvent(ui.widget.layer)
  ui.widget.layer:registerScriptHandler(function(l_5_0)
    if l_5_0 == "enter" then
      ui.widget.layer.notifyParentLock()
    elseif l_5_0 == "exit" then
      ui.widget.layer.notifyParentUnlock()
    end
   end)
end

ui.showItemIntro = function()
  local layer = CCLayer:create()
  layer:setTouchEnabled(true)
  ui.widget.layer:addChild(layer)
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setPreferredSize(CCSize(355, 248))
  bg:setScale(view.minScale)
  bg:setPosition(ccp(view.midX, view.midY))
  layer:addChild(bg)
  local itemImgStr = {speed = img.ui.solo_speed_potion, power = img.ui.solo_power_potion, crit = img.ui.solo_crit_potion, milk = img.ui.solo_milk, angel = img.ui.solo_angel_potion, evil = img.ui.solo_evil_potion}
  local itemIcon = img.createUISprite(img.ui.grid)
  itemIcon:setScale(0.8)
  itemIcon:setAnchorPoint(ccp(0, 1))
  itemIcon:setPositionX(21)
  bg:addChild(itemIcon)
  local size = ui.widget.itemIcon:getContentSize()
  local itemContent = img.createUISprite(itemImgStr[ui.data.drugType])
  itemContent:setPosition(ccp(size.width / 2, size.height / 2))
  itemContent:setScale(size.width / itemContent:getContentSize().width)
  itemIcon:addChild(itemContent)
  local nameLabel = lbl.createMixFont1(18, i18n.spkdrug[ui.data.drugId].name, lbl.qualityColors[1])
  nameLabel:setAnchorPoint(ccp(0, 1))
  nameLabel:setPositionX(21)
  bg:addChild(nameLabel)
  local typeLabel = lbl.createMixFont1(18, i18n.spkdrug[ui.data.drugId].brief, ccc3(251, 251, 251))
  typeLabel:setAnchorPoint(ccp(0, 1))
  typeLabel:setPositionX(itemIcon:boundingBox():getMaxX() + 22)
  bg:addChild(typeLabel)
  local introLabel = lbl.createMix({font = 1, size = 18, width = 320, text = i18n.spkdrug[ui.data.drugId].explain, color = ccc3(251, 251, 251), align = kCCTextAlignmentLeft})
  introLabel:setAnchorPoint(ccp(0, 1))
  introLabel:setPositionX(21)
  bg:addChild(introLabel)
  local introH = introLabel:boundingBox():getMaxY() - introLabel:boundingBox():getMinY()
  local iconH = itemIcon:boundingBox():getMaxY() - itemIcon:boundingBox():getMinY()
  local nameH = nameLabel:boundingBox():getMaxY() - nameLabel:boundingBox():getMinY()
  bg:setPreferredSize(CCSize(355, introH + 182))
  introLabel:setPositionY(introH + 34)
  itemIcon:setPositionY(introH + 121)
  typeLabel:setPositionY(introH + 117)
  nameLabel:setPositionY(introH + 156)
  local sprite = CCSprite:create()
  sprite:setContentSize(bg:getContentSize())
  local btn = SpineMenuItem:create(json.ui.button, sprite)
  btn:setPosition(ccp(btn:getContentSize().width / 2, btn:getContentSize().height / 2))
  local btnMenu = CCMenu:createWithItem(btn)
  btnMenu:setPosition(CCPoint(0, 0))
  bg:addChild(btnMenu)
  layer:registerScriptTouchHandler(function(l_1_0, l_1_1, l_1_2)
    if l_1_0 == "began" then
      return true
    elseif l_1_0 == "ended" then
      layer:removeFromParent()
    end
   end)
end

return ui

