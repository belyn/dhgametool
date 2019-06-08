-- Command line was: E:\github\dhgametool\scripts\ui\solo\shopUI.lua 

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
local rewards = require("ui.reward")
ui.create = function(l_1_0, l_1_1)
  ui.widget = {}
  ui.data = {}
  ui.data.params = l_1_0
  ui.data.mainUI = l_1_1
  ui.widget.layer = CCLayer:create()
  ui.widget.layer:setTouchEnabled(true)
  ui.widget.darkLayer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  ui.widget.layer:addChild(ui.widget.darkLayer)
  ui.widget.bg = img.createUI9Sprite(img.ui.dialog_1)
  ui.widget.bg:setPreferredSize(CCSizeMake(370, 386))
  ui.widget.bg:setScale(view.minScale)
  ui.widget.bg:setPosition(view.midX, view.midY)
  ui.widget.layer:addChild(ui.widget.bg)
  local board_bg_w = ui.widget.bg:getContentSize().width
  local board_bg_h = ui.widget.bg:getContentSize().height
  ui.widget.title = lbl.createFont1(24, i18n.global.chip_btn_buy.string, ccc3(230, 208, 174))
  ui.widget.title:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 29))
  ui.widget.bg:addChild(ui.widget.title, 2)
  ui.widget.titleShadow = lbl.createFont1(24, i18n.global.chip_btn_buy.string, ccc3(89, 48, 27))
  ui.widget.titleShadow:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 31))
  ui.widget.bg:addChild(ui.widget.titleShadow)
  ui.widget.ownGemBg = img.createUI9Sprite(img.ui.main_coin_bg)
  ui.widget.ownGemBg:setPreferredSize(CCSizeMake(174, 40))
  ui.widget.ownGemBg:setPosition(ccp(ui.widget.bg:getContentSize().width / 2, 300))
  ui.widget.bg:addChild(ui.widget.ownGemBg)
  local gemIcon = nil
  if l_1_0.gem then
    gemIcon = img.createItemIcon2(ITEM_ID_GEM)
  elseif l_1_0.coin then
    gemIcon = img.createItemIcon2(ITEM_ID_COIN)
  end
  gemIcon:setPosition(CCPoint(5, ui.widget.ownGemBg:getContentSize().height / 2 + 2))
  ui.widget.ownGemBg:addChild(gemIcon)
  if not l_1_0.gem or not bagdata.gem() then
    local bagCost = bagdata.coin()
  end
  ui.widget.ownLabel = lbl.createFont2(16, num2KM(bagCost), ccc3(255, 246, 223))
  ui.widget.ownLabel:setPosition(77, 23)
  ui.widget.ownGemBg:addChild(ui.widget.ownLabel)
  local gemPlusImg = img.createUISprite(img.ui.main_icon_plus)
  ui.widget.gemPlusBtn = HHMenuItem:create(gemPlusImg)
  ui.widget.gemPlusBtn:setPosition(ui.widget.ownGemBg:getContentSize().width - 18, ui.widget.ownGemBg:getContentSize().height / 2 + 2)
  local goldPlusMenu = CCMenu:createWithItem(ui.widget.gemPlusBtn)
  goldPlusMenu:setPosition(ccp(0, 0))
  ui.widget.ownGemBg:addChild(goldPlusMenu)
  if l_1_0.coin then
    ui.widget.gemPlusBtn:setVisible(false)
  end
  ui.widget.gemBg = img.createUI9Sprite(img.ui.casino_gem_bg)
  ui.widget.gemBg:setPreferredSize(CCSizeMake(220, 36))
  ui.widget.gemBg:setPosition(CCPoint(board_bg_w / 2, 141))
  ui.widget.bg:addChild(ui.widget.gemBg)
  if l_1_0.gem then
    ui.widget.gemIcon = img.createItemIcon2(ITEM_ID_GEM)
  elseif l_1_0.coin then
    ui.widget.gemIcon = img.createItemIcon2(ITEM_ID_COIN)
  end
  ui.widget.gemIcon:setScale(0.9)
  ui.widget.gemIcon:setPosition(CCPoint(44, ui.widget.gemBg:getContentSize().height / 2))
  ui.widget.gemBg:addChild(ui.widget.gemIcon)
  if not l_1_0.gem then
    local cost = l_1_0.coin
  end
  ui.widget.gemLabel = lbl.createFont2(18, num2KM(cost))
  ui.widget.gemLabel:setPosition(CCPoint(130, ui.widget.gemBg:getContentSize().height / 2))
  ui.widget.gemBg:addChild(ui.widget.gemLabel)
  if l_1_0.goodsType == 1 then
    ui.widget.goodsIcon = img.createItem(l_1_0.id, l_1_0.num)
  else
    ui.widget.goodsIcon = img.createEquip(l_1_0.id, l_1_0.num)
  end
  ui.widget.goodsIcon:setPosition(ccp(ui.widget.bg:getContentSize().width / 2, 220))
  ui.widget.bg:addChild(ui.widget.goodsIcon)
  local buyImg = img.createLogin9Sprite(img.login.button_9_small_gold)
  buyImg:setPreferredSize(CCSizeMake(155, 55))
  local buyLabel = lbl.createFont1(18, i18n.global.chip_btn_buy.string, ccc3(115, 59, 5))
  buyLabel:setPosition(CCPoint(buyImg:getContentSize().width / 2, buyImg:getContentSize().height / 2))
  buyImg:addChild(buyLabel)
  ui.widget.buyBtn = SpineMenuItem:create(json.ui.button, buyImg)
  ui.widget.buyBtn:setPosition(CCPoint(board_bg_w / 2, 70))
  local buyMenu = CCMenu:createWithItem(ui.widget.buyBtn)
  buyMenu:setPosition(CCPoint(0, 0))
  ui.widget.bg:addChild(buyMenu)
  local closeImg = img.createUISprite(img.ui.close)
  ui.widget.closeBtn = SpineMenuItem:create(json.ui.button, closeImg)
  ui.widget.closeBtn:setPosition(CCPoint(board_bg_w - 25, board_bg_h - 28))
  local closeMenu = CCMenu:createWithItem(ui.widget.closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  ui.widget.bg:addChild(closeMenu, 100)
  ui.widget.bg:setScale(0.5 * view.minScale)
  ui.widget.bg:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  ui.btnCallback()
  return ui.widget.layer
end

ui.btnCallback = function()
  local resetLabel = function()
    if not ui.data.params.gem or not bagdata.gem() then
      local bagCost = bagdata.coin()
    end
    ui.widget.ownLabel:setString(num2KM(bagCost))
   end
  ui.widget.layer:scheduleUpdateWithPriorityLua(resetLabel, 0)
  ui.widget.closeBtn:registerScriptTapHandler(function()
    print("\229\133\179\233\151\173")
    audio.play(audio.button)
    if ui.widget.layer then
      ui.widget.layer:removeFromParent()
      ui.widget.layer = nil
    end
   end)
  ui.widget.buyBtn:registerScriptTapHandler(function()
    print("\232\180\173\228\185\176\231\137\169\229\147\129")
    audio.play(audio.button)
    if ui.data.params.gem and bagdata.gem() < ui.data.params.gem then
      showToast(i18n.global.gboss_fight_st6.string)
      return 
    else
      if ui.data.params.coin and bagdata.coin() < ui.data.params.coin then
        showToast(i18n.global.crystal_toast_coin.string)
        return 
      end
    end
    addWaitNet()
    local params = {sid = player.sid, id = soloData.getTrader(), count = 1, variety = 1}
    print("\232\180\173\228\185\176\229\149\134\229\147\129")
    tablePrint(params)
    net:spk_buy(params, function(l_1_0)
      delWaitNet()
      print("\232\180\173\228\185\176\232\191\148\229\155\158\230\149\176\230\141\174")
      tablePrint(l_1_0)
      if l_1_0.status == 0 then
        local pbBag = {}
        local pb = {}
        if ui.data.params.goodsType == 1 then
          pb.id = ui.data.params.id
          pb.num = ui.data.params.num
          bagdata.items.add(pb)
          pbBag.items = {}
          pbBag.items[1] = {}
          pbBag.items[1].id = pb.id
          pbBag.items[1].num = pb.num
        else
          if ui.data.params.goodsType == 2 then
            pb.id = ui.data.params.id
            pb.num = ui.data.params.count
            bagdata.equips.add(pb)
            pbBag.equips = {}
            pbBag.equips[1] = {}
            pbBag.equips[1].id = pb.id
            pbBag.equips[1].num = pb.num
          end
        end
        if ui.data.params.gem then
          bagdata.subGem(ui.data.params.gem)
        else
          if ui.data.params.coin then
            bagdata.subCoin(ui.data.params.coin)
          end
        end
        CCDirector:sharedDirector():getRunningScene():addChild(rewards.createFloating(pbBag), 9999)
        ui.data.mainUI.setStage(l_1_0.nstage)
        ui.data.mainUI.endTraderSpine()
        ui.widget.layer:removeFromParent()
      end
      end)
   end)
  ui.widget.gemPlusBtn:registerScriptTapHandler(function()
    print("\232\180\173\228\185\176\233\146\187\231\159\179")
    audio.play(audio.button)
    local shopUI = require("ui.shop.main").create()
    ui.widget.layer:getParent():addChild(shopUI, 999999)
   end)
  ui.widget.layer.onAndroidBack = function()
    audio.play(audio.button)
    if ui.widget.layer then
      ui.widget.layer:removeFromParent()
      ui.widget.layer = nil
    end
   end
  addBackEvent(ui.widget.layer)
  ui.widget.layer:registerScriptHandler(function(l_6_0)
    if l_6_0 == "enter" then
      ui.widget.layer.notifyParentLock()
    elseif l_6_0 == "exit" then
      ui.widget.layer.notifyParentUnlock()
    end
   end)
end

ui.refreshLabel = function(l_3_0)
  ui.widget.ownLabel:setString(l_3_0)
end

return ui

