-- Command line was: E:\github\dhgametool\scripts\ui\solo\traderUI.lua 

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
ui.create = function(l_1_0)
  ui.widget = {}
  ui.data = {}
  ui.widget.items = {}
  ui.data.idList = {}
  for i,v in ipairs(soloData.traderList) do
    if traderConf[v].Body == l_1_0 then
      table.insert(ui.data.idList, v)
    end
  end
  local layer = CCLayer:create()
  ui.widget.layer = layer
  ui.widget.layer:setTouchEnabled(true)
  ui.widget.darkBg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  ui.widget.layer:addChild(ui.widget.darkBg)
  ui.widget.bg = img.createUI9Sprite(img.ui.dialog_1)
  ui.widget.bg:setPreferredSize(CCSizeMake(658, 508))
  ui.widget.bg:setScale(view.minScale)
  ui.widget.bg:setPosition(view.midX, view.midY)
  ui.widget.layer:addChild(ui.widget.bg)
  local width = ui.widget.bg:getContentSize().width
  local height = ui.widget.bg:getContentSize().height
  local title = i18n.global.solo_trader" .. l_1_.string
  ui.widget.title = lbl.createFont1(24, title, ccc3(230, 208, 174))
  ui.widget.title:setPosition(CCPoint(width / 2, height - 29))
  ui.widget.bg:addChild(ui.widget.title, 2)
  ui.widget.shadow = lbl.createFont1(24, title, ccc3(89, 48, 27))
  ui.widget.shadow:setPosition(CCPoint(width / 2, height - 31))
  ui.widget.bg:addChild(ui.widget.shadow)
  ui.widget.board = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  ui.widget.board:setPreferredSize(CCSizeMake(602, 400))
  ui.widget.board:setAnchorPoint(CCPoint(0.5, 0.5))
  ui.widget.board:setPosition(CCPoint(width / 2, 230))
  ui.widget.bg:addChild(ui.widget.board)
  ui.widget.totalLabel = lbl.createFont1(18, i18n.global.solo_total.string .. ":" .. #ui.data.idList, ccc3(81, 39, 18))
  ui.widget.totalLabel:setAnchorPoint(CCPoint(0, 0.5))
  ui.widget.totalLabel:setPosition(CCPoint(24, 360))
  ui.widget.board:addChild(ui.widget.totalLabel)
  ui.widget.ownGoldBg = img.createUI9Sprite(img.ui.main_coin_bg)
  ui.widget.ownGoldBg:setPreferredSize(CCSizeMake(148, 40))
  ui.widget.ownGoldBg:setPosition(ccp(338, 360))
  ui.widget.board:addChild(ui.widget.ownGoldBg)
  local goldIcon = img.createItemIcon2(ITEM_ID_COIN)
  goldIcon:setPosition(CCPoint(5, ui.widget.ownGoldBg:getContentSize().height / 2 + 2))
  ui.widget.ownGoldBg:addChild(goldIcon)
  local bagCost = bagdata.coin()
  local ownGoldLabel = lbl.createFont2(16, num2KM(bagCost), ccc3(255, 246, 223))
  ui.widget.ownGoldLabel = ownGoldLabel
  ui.widget.ownGoldLabel:setPosition(69, 23)
  ui.widget.ownGoldBg:addChild(ui.widget.ownGoldLabel)
  local goldPlusImg = img.createUISprite(img.ui.main_icon_plus)
  ui.widget.goldPlusBtn = HHMenuItem:create(goldPlusImg)
  ui.widget.goldPlusBtn:setPosition(ui.widget.ownGoldBg:getContentSize().width - 18, ui.widget.ownGoldBg:getContentSize().height / 2 + 2)
  ui.widget.goldPlusBtn:setVisible(false)
  local goldPlusMenu = CCMenu:createWithItem(ui.widget.goldPlusBtn)
  goldPlusMenu:setPosition(ccp(0, 0))
  ui.widget.ownGoldBg:addChild(goldPlusMenu)
  ui.widget.ownGemBg = img.createUI9Sprite(img.ui.main_coin_bg)
  ui.widget.ownGemBg:setPreferredSize(CCSizeMake(148, 40))
  ui.widget.ownGemBg:setPosition(ccp(508, 360))
  ui.widget.board:addChild(ui.widget.ownGemBg)
  local gemIcon = img.createItemIcon2(ITEM_ID_GEM)
  gemIcon:setPosition(CCPoint(5, ui.widget.ownGemBg:getContentSize().height / 2 + 2))
  ui.widget.ownGemBg:addChild(gemIcon)
  local bagCost = bagdata.gem()
  local ownLabel = lbl.createFont2(16, num2KM(bagCost), ccc3(255, 246, 223))
  ui.widget.ownLabel = ownLabel
  ui.widget.ownLabel:setPosition(68, 23)
  ui.widget.ownGemBg:addChild(ui.widget.ownLabel)
  local gemPlusImg = img.createUISprite(img.ui.main_icon_plus)
  ui.widget.gemPlusBtn = HHMenuItem:create(gemPlusImg)
  ui.widget.gemPlusBtn:setPosition(ui.widget.ownGemBg:getContentSize().width - 18, ui.widget.ownGemBg:getContentSize().height / 2 + 2)
  ui.widget.gemPlusBtn:setVisible(false)
  local gemPlusMenu = CCMenu:createWithItem(ui.widget.gemPlusBtn)
  gemPlusMenu:setPosition(ccp(0, 0))
  ui.widget.ownGemBg:addChild(gemPlusMenu)
  local ITEM_H = 88
  local SCROLL_INTERVAL = 4
  local SCROLL_VIEW_W = 560
  local SCROLL_VIEW_H = 320
  local SCROLL_CONTENT_W = 560
  local SCROLL_CONTENT_H = SCROLL_VIEW_H < (ITEM_H + SCROLL_INTERVAL) * #ui.data.idList and (ITEM_H + SCROLL_INTERVAL) * #ui.data.idList or SCROLL_VIEW_H
  ui.widget.scroll = CCScrollView:create()
  ui.widget.scroll:setDirection(kCCScrollViewDirectionVertical)
  ui.widget.scroll:setViewSize(CCSize(SCROLL_VIEW_W, SCROLL_VIEW_H))
  ui.widget.scroll:setContentSize(CCSize(SCROLL_CONTENT_W, SCROLL_CONTENT_H))
  ui.widget.scroll:setAnchorPoint(CCPoint(0, 0))
  ui.widget.scroll:setPosition(CCPoint(21, 15))
  ui.widget.scroll:setContentOffset(ccp(0, SCROLL_VIEW_H - SCROLL_CONTENT_H))
  ui.widget.board:addChild(ui.widget.scroll)
  local closeImg = img.createUISprite(img.ui.close)
  ui.widget.closeBtn = SpineMenuItem:create(json.ui.button, closeImg)
  ui.widget.closeBtn:setPosition(CCPoint(width - 25, height - 28))
  local closeMenu = CCMenu:createWithItem(ui.widget.closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  ui.widget.bg:addChild(closeMenu, 10)
  ui.widget.closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    ui.widget.layer:unscheduleUpdate()
    ui.widget.layer:removeFromParent()
    ui.widget.layer = nil
   end)
  ui.addItems()
  ui.widget.bg:setScale(0.5 * view.minScale)
  ui.widget.bg:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  local resetLabel = function()
    local gem = bagdata.gem()
    local coin = bagdata.coin()
    ownLabel:setString(num2KM(gem))
    ownGoldLabel:setString(num2KM(coin))
   end
  ui.widget.layer:scheduleUpdateWithPriorityLua(resetLabel, 0)
  ui.widget.layer.onAndroidBack = function()
    audio.play(audio.button)
    ui.widget.layer:unscheduleUpdate()
    ui.widget.layer:removeFromParent()
    ui.widget.layer = nil
   end
  addBackEvent(ui.widget.layer)
  layer:registerScriptHandler(function(l_4_0)
    if l_4_0 == "enter" then
      layer.notifyParentLock()
    elseif l_4_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
  return layer
end

ui.createItem = function(l_2_0)
  local bg = img.createUI9Sprite(img.ui.bottom_border_2)
  bg:setPreferredSize(CCSizeMake(554, 88))
  bg:ignoreAnchorPointForPosition(false)
  bg:setAnchorPoint(ccp(0.5, 0.5))
  local icon = nil
  print("id " .. l_2_0)
  local reward = traderConf[l_2_0].yes[1]
  if reward.type == 1 then
    icon = img.createItem(reward.id, reward.num)
  elseif reward.type == 2 then
    icon = img.createEquip(reward.id, reward.num)
  end
  icon:setAnchorPoint(CCPoint(0.5, 0.5))
  icon:setPosition(CCPoint(44, 44))
  icon:setScale(0.7)
  bg:addChild(icon)
  local buyImg = img.createLogin9Sprite(img.login.button_9_small_green)
  buyImg:setPreferredSize(CCSizeMake(155, 49))
  local buyBtn = SpineMenuItem:create(json.ui.button, buyImg)
  buyBtn:setPosition(CCPoint(456, 45))
  local buyMenu = CCMenu:createWithItem(buyBtn)
  buyMenu:setPosition(CCPoint(0, 0))
  bg:addChild(buyMenu)
  local buyLabel = lbl.createFont1(18, i18n.global.chip_btn_buy.string, ccc3(30, 99, 5))
  buyLabel:setPosition(CCPoint(90, buyImg:getContentSize().height / 2))
  buyImg:addChild(buyLabel)
  local buyIcon = nil
  local buyNum = lbl.createFont2(14, "0", ccc3(255, 255, 255))
  buyNum:setPosition(CCPoint(31, 16))
  buyImg:addChild(buyNum, 2)
  if traderConf[l_2_0].cost then
    buyIcon = img.createItemIcon2(ITEM_ID_GEM)
    buyNum:setString(num2KM(traderConf[l_2_0].cost))
  else
    if traderConf[l_2_0].gold then
      buyIcon = img.createItemIcon2(ITEM_ID_COIN)
      buyNum:setString(num2KM(traderConf[l_2_0].gold))
    end
  end
  buyIcon:setPosition(CCPoint(31, 29))
  buyIcon:setScale(0.7)
  buyImg:addChild(buyIcon)
  bg.id = l_2_0
  buyBtn:registerScriptTapHandler(function()
    if cfgTrader[bg.id].cost and bagdata.gem() < cfgTrader[bg.id].cost then
      showToast(i18n.global.gboss_fight_st6.string)
      return 
    else
      if cfgTrader[bg.id].gold and bagdata.coin() < cfgTrader[bg.id].gold then
        showToast(i18n.global.crystal_toast_coin.string)
        return 
      end
    end
    print("\232\180\173\228\185\176")
    audio.play(audio.button)
    local dialog_params = {title = "", body = string.format(i18n.global.blackmarket_buy_sure.string, 2), btn_count = 2, btn_color = {1 = dialog.COLOR_BLUE, 2 = dialog.COLOR_GOLD}, btn_text = {1 = i18n.global.dialog_button_cancel.string, 2 = i18n.global.dialog_button_confirm.string}, selected_btn = 0, callback = function(l_1_0)
      ui.widget.layer:removeChildByTag(dialog.TAG)
      if l_1_0.selected_btn == 2 then
        addWaitNet()
        local params = {sid = player.sid, id = bg.id, count = 1, variety = 2}
        net:spk_buy(params, function(l_1_0)
          delWaitNet()
          print("\232\180\173\228\185\176\232\191\148\229\155\158\230\149\176\230\141\174")
          tablePrint(l_1_0)
          if l_1_0.status == 0 then
            if traderConf[bg.id].cost then
              bagdata.subGem(traderConf[bg.id].cost)
            else
              if traderConf[bg.id].gold then
                bagdata.subCoin(traderConf[bg.id].gold)
              end
            end
            local reward = cfgTrader[bg.id].yes[1]
            if reward.type == 1 then
              bagdata.items.add(reward)
            elseif reward.type == 2 then
              bagdata.equips.add(reward)
            end
            ui.removeItem(bg)
          end
            end)
      elseif l_1_0.selected_btn == 1 then
         -- Warning: missing end command somewhere! Added here
      end
      end}
    local tip = dialog.create(dialog_params)
    ui.widget.layer:addChild(tip, 1000, dialog.TAG)
   end)
  return bg
end

ui.addItems = function()
  local ITEM_H = 88
  local SCROLL_INTERVAL = 4
  local SCROLL_H = ui.widget.scroll:getContentSize().height
  for i,v in ipairs(ui.data.idList) do
    local item = ui.createItem(v)
    item:setPositionX(ui.widget.scroll:getViewSize().width / 2)
    item:setPositionY(SCROLL_H - (i - 0.5) * (ITEM_H + SCROLL_INTERVAL))
    ui.widget.scroll:addChild(item)
    item:setAnchorPoint(ccp(0.5, 0.5))
    table.insert(ui.widget.items, item)
  end
end

ui.removeItem = function(l_4_0)
  local ITEM_H = 88
  local SCROLL_INTERVAL = 4
  local viewH = ui.widget.scroll:getViewSize().height
  local viewW = ui.widget.scroll:getViewSize().width
  local contentH = ui.widget.scroll:getContentSize().height
  local contentW = ui.widget.scroll:getContentSize().width
  local order = nil
  for i,v in ipairs(ui.widget.items) do
    if v == l_4_0 then
      soloData.removeTrader(l_4_0.id)
      ui.widget.items[i]:removeFromParent()
      table.remove(ui.widget.items, i)
      order = i
  else
    end
  end
  local height = contentH - ITEM_H - SCROLL_INTERVAL
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
ui.widget.scroll:setContentSize(CCSize(contentW, height))
if order <= 4 then
  ui.widget.scroll:setContentOffset(ccp(0, viewH - height))
end
for i,v in ipairs(ui.widget.items) do
  v:setPositionY(height - (i - 0.5) * (ITEM_H + SCROLL_INTERVAL))
end
ui.widget.totalLabel:setString(i18n.global.solo_total.string .. ":" .. #ui.widget.items)
end

return ui

