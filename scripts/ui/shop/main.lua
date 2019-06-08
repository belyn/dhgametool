-- Command line was: E:\github\dhgametool\scripts\ui\shop\main.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local lbl = require("res.lbl")
local audio = require("res.audio")
local i18n = require("res.i18n")
local player = require("data.player")
local bag = require("data.bag")
local cfgstore = require("config.store")
local cfgvip = require("config.vip")
local cfgitem = require("config.item")
local tipsitem = require("ui.tips.item")
local tipsequip = require("ui.tips.equip")
local net = require("net.netClient")
local shop = require("data.shop")
local reward = require("ui.reward")
local buylayer = require("ui.shop.buylayer")
local viplayer = require("ui.shop.viplayer")
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local shopType = "gem"
  if l_1_0 then
    shopType = l_1_0
  end
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board = img.createUISprite(img.ui.gemstore_bg)
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  board:setScale(0.1 * view.minScale)
  board:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local specialLayer = CCLayer:create()
  board:addChild(specialLayer)
  local vip_a = {1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4}
  vip_a[0] = 1
  local vip_c1 = ccc3(255, 209, 121)
  local vip_c2 = ccc3(232, 251, 255)
  local vip_c3 = ccc3(255, 244, 120)
  local vip_c4 = ccc3(138, 248, 255)
  local vip_c = {vip_c1, vip_c1, vip_c1, vip_c2, vip_c2, vip_c2, vip_c3, vip_c3, vip_c3, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4}
  vip_c[0] = vip_c1
  local createSpecial = function()
    if not player.vipLv() then
      local storeVip = player.maxVipLv()
    end
    local vipExpBg = img.createUI9Sprite(img.ui.gemstore_vip_bg)
    vipExpBg:setPreferredSize(CCSize(242, 26))
    vipExpBg:setAnchorPoint(CCPoint(0, 0.5))
    vipExpBg:setPosition(CCPoint(110, 433))
    specialLayer:addChild(vipExpBg)
    local expNow, needExp = 1, 1
    if storeVip ~= player.maxVipLv() then
      expNow = bag.items.find(ITEM_ID_VIP_EXP).num
      needExp = cfgvip[player.vipLv() + 1].exp
    end
    local vipExpFgSprite = img.createUISprite(img.ui.gemstore_vip_fg)
    local vipExpFg = createProgressBar(vipExpFgSprite)
    vipExpFg:setAnchorPoint(ccp(0, 0.5))
    vipExpFg:setPosition(4, vipExpBg:getContentSize().height / 2)
    vipExpFg:setPercentage(expNow / needExp * 100)
    vipExpBg:addChild(vipExpFg, 1)
    local ExpInfo = expNow .. " / " .. needExp
    if expNow == 1 and needExp == 1 then
      ExpInfo = bag.items.find(ITEM_ID_VIP_EXP).num
    end
    local showVipExp = lbl.createFont2(16, ExpInfo, ccc3(255, 246, 223))
    showVipExp:setPosition(vipExpBg:getContentSize().width / 2, vipExpBg:getContentSize().height / 2)
    vipExpBg:addChild(showVipExp, 2)
    local vip_bg1 = CCSprite:create()
    vip_bg1:setContentSize(CCSizeMake(58, 58))
    vip_bg1:setPosition(CCPoint(70, 433))
    specialLayer:addChild(vip_bg1)
    local ic_vip1 = DHSkeletonAnimation:createWithKey(json.ui.ic_vip)
    ic_vip1:scheduleUpdateLua()
    ic_vip1:playAnimation("" .. vip_a[storeVip], -1)
    ic_vip1:setPosition(CCPoint(29, 29))
    vip_bg1:addChild(ic_vip1)
    local lbl_player_vip1 = lbl.createFont2(18, storeVip, ccc3(255, 220, 130))
    lbl_player_vip1:setColor(vip_c[storeVip])
    ic_vip1:addChildFollowSlot("code_num", lbl_player_vip1)
    local buyLab = lbl.createFont2(18, i18n.global.shop_gem_buy.string)
    buyLab:setAnchorPoint(0, 0.5)
    buyLab:setPosition(CCPoint(360, 433))
    specialLayer:addChild(buyLab)
    local vipfullLab = lbl.createFont2(18, i18n.global.shop_vipexp_full.string, ccc3(255, 246, 223))
    vipfullLab:setAnchorPoint(0, 0.5)
    vipfullLab:setPosition(CCPoint(360, 433))
    vipfullLab:setVisible(false)
    specialLayer:addChild(vipfullLab)
    local gemIcon = img.createItemIcon2(ITEM_ID_GEM)
    gemIcon:setScale(0.9)
    gemIcon:setAnchorPoint(ccp(0, 0.5))
    gemIcon:setPosition(CCPoint(buyLab:boundingBox():getMaxX() + 6, 433))
    specialLayer:addChild(gemIcon)
    local needDiamond = lbl.createFont2(18, needExp - expNow, ccc3(255, 247, 132))
    needDiamond:setAnchorPoint(ccp(0, 0.5))
    needDiamond:setPosition(gemIcon:boundingBox():getMaxX() + 5, 433)
    specialLayer:addChild(needDiamond)
    local turntoLab = lbl.createFont2(18, i18n.global.shop_next_vip.string)
    turntoLab:setAnchorPoint(ccp(0, 0.5))
    turntoLab:setPosition(CCPoint(needDiamond:boundingBox():getMaxX() + 6, 433))
    specialLayer:addChild(turntoLab)
    json.load(json.ui.ic_vip)
    local vip_bg2 = CCSprite:create()
    vip_bg2:setContentSize(CCSizeMake(58, 58))
    vip_bg2:setAnchorPoint(ccp(0, 0.5))
    vip_bg2:setPosition(CCPoint(turntoLab:boundingBox():getMaxX() + 8, 433))
    specialLayer:addChild(vip_bg2)
    local ic_vip = DHSkeletonAnimation:createWithKey(json.ui.ic_vip)
    ic_vip:scheduleUpdateLua()
    ic_vip:playAnimation("" .. vip_a[storeVip + 1], -1)
    ic_vip:setPosition(CCPoint(29, 29))
    vip_bg2:addChild(ic_vip)
    local useless_node = CCNode:create()
    local lbl_player_vip = lbl.createFont2(18, storeVip + 1, ccc3(255, 220, 130))
    lbl_player_vip:setColor(vip_c[storeVip + 1])
    useless_node:addChild(lbl_player_vip)
    ic_vip:addChildFollowSlot("code_num", useless_node)
    if storeVip == player.maxVipLv() then
      gemIcon:setVisible(false)
      needDiamond:setVisible(false)
      vip_bg2:setVisible(false)
      buyLab:setVisible(false)
      turntoLab:setVisible(false)
      vipfullLab:setVisible(true)
    end
   end
  createSpecial()
  local subTitle = nil
  local storeBuyLayer = buylayer.create(layer, specialLayer, createSpecial)
  board:addChild(storeBuyLayer)
  storeBuyLayer:setVisible(shopType == "gem")
  local propertyLayer = viplayer.create(layer, vip_a, vip_c)
  board:addChild(propertyLayer)
  propertyLayer:setVisible(shopType == "vip")
  local menuPay = CCMenu:create()
  menuPay:setPosition(0, 0)
  board:addChild(menuPay)
  local btnPaySprite = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnPaySprite:setPreferredSize(CCSize(128, 48))
  local btnPay = SpineMenuItem:create(json.ui.button, btnPaySprite)
  local labPay = lbl.createFont1(18, i18n.global.shop_privilege.string, ccc3(115, 59, 5))
  labPay:setPosition(btnPaySprite:getContentSize().width / 2, btnPaySprite:getContentSize().height / 2)
  btnPaySprite:addChild(labPay)
  btnPay:setPosition(760, 435)
  menuPay:addChild(btnPay)
  local show = 1
  btnPay:registerScriptTapHandler(function()
    audio.play(audio.button)
    if show == 1 then
      storeBuyLayer:setVisible(false)
      propertyLayer:setVisible(true)
      labPay:setString(i18n.global.shop_enter.string)
      upvalue_512 = 2
      upvalue_3072 = "vip"
    else
      propertyLayer:setVisible(false)
      storeBuyLayer:setVisible(true)
      labPay:setString(i18n.global.shop_privilege.string)
      upvalue_512 = 1
      upvalue_3072 = "gem"
    end
   end)
  local close0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, close0)
  closeBtn:setPosition(CCPoint(840, 485))
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  board:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  layer.onAndroidBack = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  addBackEvent(layer)
  local onEnter = function()
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_7_0)
    if l_7_0 == "enter" then
      onEnter()
    elseif l_7_0 == "exit" then
      onExit()
    end
   end)
  layer:setTouchEnabled(true)
  return layer
end

return ui

