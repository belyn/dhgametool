-- Command line was: E:\github\dhgametool\scripts\ui\shop\buylayer.lua 

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
ui.create = function(l_1_0, l_1_1, l_1_2)
  local storeBuyLayer = CCLayer:create()
  local itemNum = 7
  if shop.showSub() then
    itemNum = 8
  end
  local SCROLL_CONTAINER_SIZE = math.max(itemNum * 220 + 30, 930)
  local Scroll = CCScrollView:create()
  Scroll:setDirection(kCCScrollViewDirectionHorizontal)
  Scroll:setPosition(22, 40)
  Scroll:setViewSize(CCSize(820, 338))
  Scroll:setContentSize(CCSize(SCROLL_CONTAINER_SIZE + 20, 400))
  storeBuyLayer:addChild(Scroll)
  local itemBg = {}
  local createItem = function(l_1_0)
    itemBg[l_1_0] = img.createUISprite(img.ui.gemstore_item_bg)
    if itemNum == 8 then
      itemBg[l_1_0]:setPosition(-190 + 224 * cfgstore[l_1_0].rank + itemBg[l_1_0]:getContentSize().width / 2, 25 + itemBg[l_1_0]:getContentSize().height / 2)
    else
      itemBg[l_1_0]:setPosition(-190 + 224 * (cfgstore[l_1_0].rank - 1) + itemBg[l_1_0]:getContentSize().width / 2, 25 + itemBg[l_1_0]:getContentSize().height / 2)
    end
    Scroll:getContainer():addChild(itemBg[l_1_0])
    if shop.pay[l_1_0] == 0 then
      local doubleValue = nil
      if isAmazon() then
        doubleValue = img.createUISprite(img.ui.gemstore_double_icon)
      else
        if isOnestore() then
          doubleValue = img.createUISprite(img.ui.gemstore_double_icon_kr)
        elseif APP_CHANNEL and APP_CHANNEL ~= "" then
          doubleValue = img.createUISprite(img.ui.gemstore_double_icon_cn)
        else
          if i18n.getCurrentLanguage() == kLanguageChinese then
            doubleValue = img.createUISprite(img.ui.gemstore_double_icon_cn)
          else
            if i18n.getCurrentLanguage() == kLanguageChineseTW then
              doubleValue = img.createUISprite(img.ui.gemstore_double_icon_tw)
            else
              if i18n.getCurrentLanguage() == kLanguageJapanese then
                doubleValue = img.createUISprite(img.ui.gemstore_double_icon_jp)
              else
                if i18n.getCurrentLanguage() == kLanguageKorean then
                  doubleValue = img.createUISprite(img.ui.gemstore_double_icon_kr)
                else
                  if i18n.getCurrentLanguage() == kLanguageRussian then
                    doubleValue = img.createUISprite(img.ui.gemstore_double_icon_ru)
                  else
                    if i18n.getCurrentLanguage() == kLanguageSpanish then
                      doubleValue = img.createUISprite(img.ui.gemstore_double_icon_sp)
                    else
                      if i18n.getCurrentLanguage() == kLanguagePortuguese then
                        doubleValue = img.createUISprite(img.ui.gemstore_double_icon_pt)
                      else
                        if i18n.getCurrentLanguage() == kLanguageTurkish then
                          doubleValue = img.createUISprite(img.ui.gemstore_double_icon_tr)
                        else
                          doubleValue = img.createUISprite(img.ui.gemstore_double_icon)
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      doubleValue:setAnchorPoint(ccp(0, 0))
      doubleValue:setPosition(-1, 45)
      itemBg[l_1_0]:addChild(doubleValue, 10000, 101)
    end
    local Icon = img.createUISprite(img.ui.gemstore_item" .. cfgstore[l_1_0].iconId - )
    Icon:setPosition(itemBg[l_1_0]:getContentSize().width / 2, itemBg[l_1_0]:getContentSize().height / 2 + 30)
    itemBg[l_1_0]:addChild(Icon)
    if l_1_0 == 3 then
      Icon:setScale(0.95)
      Icon:setPosition(itemBg[l_1_0]:getContentSize().width / 2 + 5, itemBg[l_1_0]:getContentSize().height / 2 + 30)
    elseif l_1_0 == 4 then
      Icon:setPosition(itemBg[l_1_0]:getContentSize().width / 2, itemBg[l_1_0]:getContentSize().height / 2 + 27)
    elseif l_1_0 == 5 then
      Icon:setPosition(itemBg[l_1_0]:getContentSize().width / 2, itemBg[l_1_0]:getContentSize().height / 2 + 25)
    end
    local showDesc = lbl.createFont2(26, cfgstore[l_1_0].diamonds, ccc3(255, 246, 223))
    showDesc:setPosition(itemBg[l_1_0]:getContentSize().width / 2, itemBg[l_1_0]:getContentSize().height / 2 - 34)
    itemBg[l_1_0]:addChild(showDesc)
    if cfgstore[l_1_0].extra then
      local extraBg = img.createUISprite(img.ui.gemstore_extra_icon)
      extraBg:setPosition(173, 268)
      itemBg[l_1_0]:addChild(extraBg)
      local showName = lbl.createFont1(14, i18n.global.shop_extra.string, ccc3(174, 73, 33))
      showName:setPosition(extraBg:getContentSize().width / 2, 55)
      extraBg:addChild(showName)
      local showNum = lbl.createFont1(24, cfgstore[l_1_0].extra, ccc3(174, 73, 33))
      showNum:setScaleX(0.7)
      showNum:setPosition(extraBg:getContentSize().width / 2, 31)
      extraBg:addChild(showNum)
    end
    local item_price = cfgstore[l_1_0].priceStr
    if isAmazon() then
      do return end
    end
    if APP_CHANNEL and APP_CHANNEL ~= "" then
      item_price = cfgstore[l_1_0].priceCnStr
    else
      if i18n.getCurrentLanguage() == kLanguageChinese then
        item_price = cfgstore[l_1_0].priceCnStr
      end
    end
    item_price = shop.getPrice(l_1_0, item_price)
    local costLab = lbl.createFontTTF(18, item_price, ccc3(115, 59, 5))
    costLab:setAnchorPoint(ccp(1, 0.5))
    costLab:setPosition(182, 30)
    itemBg[l_1_0]:addChild(costLab)
   end
  local lbllef1 = {}
  local lbllef2 = {}
  local createMonth = function(l_2_0)
    local id = l_2_0
    local Icon, titlename, totallab = nil, nil, nil
    local font = 16
    local scores = 250
    local scale = 1
    if l_2_0 == 8 then
      id = 33
      Icon = img.createUISprite(img.ui.gemstore_item" .. cfgstore[id].iconId - )
      titlename = i18n.global.activity_des_sub.string
      totallab = i18n.global.shop_vip_loot.string
      scores = 0
      font = 14
    elseif l_2_0 == 7 then
      id = 32
      Icon = img.createUISprite(img.ui.gemstore_item" .. cfgstore[id].iconId - )
      titlename = i18n.global.activity_des_mini_i.string
      totallab = i18n.global.shop_vip_total.string
      font = 14
    else
      Icon = img.createUISprite(img.ui.gemstore_item" .. cfgstore[id].iconId - )
      titlename = i18n.global.activity_des_mcard_i.string
      totallab = i18n.global.shop_vip_total.string
      scores = 750
      scale = 0.8
    end
    itemBg[l_2_0] = img.createUISprite(img.ui.gemstore_item_bg)
    itemBg[l_2_0]:setPosition(-190 + 224 * cfgstore[id].rank + itemBg[l_2_0]:getContentSize().width / 2, 25 + itemBg[l_2_0]:getContentSize().height / 2)
    Scroll:getContainer():addChild(itemBg[l_2_0])
    Icon:setPosition(itemBg[l_2_0]:getContentSize().width / 2, itemBg[l_2_0]:getContentSize().height / 2 + 10)
    itemBg[l_2_0]:addChild(Icon)
    local detailSprite = img.createUISprite(img.ui.btn_detail)
    local detailBtn = SpineMenuItem:create(json.ui.button, detailSprite)
    detailBtn:setPosition(172, 269)
    local detailMenu = CCMenu:create()
    detailMenu:setPosition(0, 0)
    itemBg[l_2_0]:addChild(detailMenu)
    detailMenu:addChild(detailBtn)
    detailBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if pos == 8 then
        layer:addChild(require("ui.help").create(string.format(i18n.global.help_sub_card.string, cfgstore[id].priceStr)), 1000)
      elseif pos == 7 then
        layer:addChild(require("ui.help").create(i18n.global.help_mini_card_i.string), 1000)
      else
        layer:addChild(require("ui.help").create(i18n.global.help_month_card_i.string), 1000)
      end
      end)
    local totalValue = img.createUISprite(img.ui.gemstore_blue_icon)
    totalValue:setAnchorPoint(ccp(0, 0))
    totalValue:setPosition(-2, 45)
    itemBg[l_2_0]:addChild(totalValue, 10000)
    local showTitle = lbl.createFont1(font, titlename, ccc3(115, 59, 5))
    showTitle:setPosition(itemBg[l_2_0]:getContentSize().width / 2 - 25, 270)
    itemBg[l_2_0]:addChild(showTitle)
    local isScale = function()
      if i18n.getCurrentLanguage() == kLanguageChinese then
        return false
      end
      if i18n.getCurrentLanguage() == kLanguageChineseTW then
        return false
      end
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        return false
      end
      if i18n.getCurrentLanguage() == kLanguageKorean then
        return false
      end
      return true
      end
    if isScale() then
      showTitle:setScale(showTitle:getScale() * scale)
    end
    if l_2_0 == 8 then
      subTitle = showTitle
      local vipgemIcon = img.createItemIcon(ITEM_ID_COIN)
      vipgemIcon:setScale(0.6)
      vipgemIcon:setPosition(35, 42)
      totalValue:addChild(vipgemIcon)
      local vipgemLab = lbl.createFont2(24, string.format("%d%%", cfgstore[id].outputPercent), ccc3(255, 246, 223))
      vipgemLab:setPosition(90, 42)
      totalValue:addChild(vipgemLab)
    else
      local vipgemIcon = img.createItemIcon(ITEM_ID_GEM)
      vipgemIcon:setScale(0.6)
      vipgemIcon:setPosition(35, 42)
      totalValue:addChild(vipgemIcon)
      local vipgemLab = lbl.createFont2(24, cfgstore[id].diamonds + cfgstore[id].dailyGems * cfgstore[id].days, ccc3(255, 246, 223))
      vipgemLab:setPosition(90, 42)
      totalValue:addChild(vipgemLab)
    end
    local totalLab = lbl.createMixFont1(14, totallab, ccc3(42, 73, 150))
    totalLab:setAnchorPoint(ccp(1, 0))
    totalLab:setPosition(170, 26)
    totalValue:addChild(totalLab)
    local lbl_vip_exp = lbl.createFont1(14, "+" .. scores, ccc3(42, 73, 150))
    lbl_vip_exp:setAnchorPoint(ccp(1, 0.5))
    lbl_vip_exp:setPosition(CCPoint(170, 20))
    totalValue:addChild(lbl_vip_exp)
    local lbl_vip_des = lbl.createFont1(14, "VIP EXP", ccc3(42, 73, 150))
    lbl_vip_des:setAnchorPoint(ccp(1, 0.5))
    lbl_vip_des:setPosition(CCPoint(lbl_vip_exp:boundingBox():getMidX() - 20, 20))
    totalValue:addChild(lbl_vip_des)
    local item_price = cfgstore[id].priceStr
    if isAmazon() then
      do return end
    end
    if APP_CHANNEL and APP_CHANNEL ~= "" then
      item_price = cfgstore[id].priceCnStr
    else
      if i18n.getCurrentLanguage() == kLanguageChinese then
        item_price = cfgstore[id].priceCnStr
      end
    end
    item_price = shop.getPrice(id, item_price)
    local costLab = lbl.createFontTTF(18, item_price, ccc3(115, 59, 5))
    costLab:setAnchorPoint(ccp(1, 0.5))
    costLab:setPosition(182, 30)
    itemBg[l_2_0]:addChild(costLab)
    if shop.pay[id] ~= 0 then
      if id ~= 33 then
        lbllef1[l_2_0] = lbl.createMixFont1(14, i18n.global.monthcard_left1.string, ccc3(255, 246, 223))
        lbllef1[l_2_0]:setAnchorPoint(CCPoint(0, 0.5))
        lbllef1[l_2_0]:setPosition(10, -12)
        itemBg[l_2_0]:addChild(lbllef1[l_2_0])
        lbllef2[l_2_0] = lbl.createMixFont1(14, string.format(i18n.global.monthcard_left2.string, shop.pay[id]), ccc3(165, 253, 71))
        lbllef2[l_2_0]:setAnchorPoint(CCPoint(0, 0.5))
        lbllef2[l_2_0]:setPosition(lbllef1[l_2_0]:boundingBox():getMaxX() + 4, -12)
        itemBg[l_2_0]:addChild(lbllef2[l_2_0])
      else
        showTitle:setString(i18n.global.activity_des_subed.string)
      end
    end
   end
  for i = 1, itemNum do
    lbllef1[i] = nil
    lbllef2[i] = nil
    if itemNum == 8 then
      if i ~= itemNum and i ~= itemNum - 1 and i ~= itemNum - 2 then
        createItem(i)
      else
        createMonth(i)
      end
    elseif i ~= itemNum and i ~= itemNum - 1 then
      createItem(i)
    else
      createMonth(i)
    end
  end
  local clickHandler = nil
  storeBuyLayer.setClickHandler = function(l_3_0)
    clickHandler = l_3_0
   end
  local touchbeginx, touchbeginy, isclick, touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil, nil, nil, nil
  local onTouchBegan = function(l_4_0, l_4_1)
    touchbeginx, upvalue_512 = l_4_0, l_4_1
    upvalue_1024 = true
    local p0 = Scroll:getContainer():convertToNodeSpace(ccp(l_4_0, l_4_1))
    for _,bg in ipairs(itemBg) do
      local id = _
      if _ == 7 then
        id = 32
      end
      if _ == 8 then
        id = 33
      end
      if p0 and bg:boundingBox():containsPoint(p0) then
        playAnimTouchBegin(itemBg[_])
        upvalue_2560 = itemBg[_]
      end
    end
    return true
   end
  local onTouchMoved = function(l_5_0, l_5_1)
    local p0 = Scroll:getContainer():convertToNodeSpace(ccp(touchbeginx, l_5_1))
    local p1 = Scroll:getContainer():convertToNodeSpace(ccp(l_5_0, l_5_1))
    if isclick and math.abs(p1.x - p0.x) > 25 then
      upvalue_1024 = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        playAnimTouchEnd(last_touch_sprite)
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_6_0, l_6_1)
    if isclick then
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        playAnimTouchEnd(last_touch_sprite)
        upvalue_512 = nil
      end
      local p0 = Scroll:getContainer():convertToNodeSpace(ccp(l_6_0, l_6_1))
      do
        for ii = 1, #itemBg do
          do
            if itemBg[ii]:boundingBox():containsPoint(p0) then
              audio.play(audio.button)
              local id = ii
              do
                if ii == 7 then
                  id = 32
                end
                if ii == 8 then
                  id = 33
                end
                if itemNum == 8 and ii == itemNum and shop.pay[id] ~= 0 then
                  showToast(i18n.global.activity_des_subed.string)
                  return true
                end
                local cfg = cfgstore[id]
                local payFunc = function()
                  local waitnet = addWaitNet()
                  waitnet.setTimeout(60)
                  local iap = require("common.iap")
                  iap.pay(cfg.payId, function(l_1_0)
                    delWaitNet()
                    local pbbag = {}
                    pbbag.items = {}
                    if l_1_0 then
                      tbl2string(l_1_0)
                      if l_1_0.items then
                        for i = 1, #l_1_0.items do
                          if l_1_0.items[i].id == 2 then
                            bag.addGem(l_1_0.items[i].num)
                            pbbag.items[#pbbag.items + 1] = l_1_0.items[i]
                          else
                            bag.items.add(l_1_0.items[i])
                          end
                        end
                        if itemBg[ii] and not tolua.isnull(itemBg[ii]) and itemBg[ii]:getChildByTag(101) then
                          itemBg[ii]:removeChildByTag(101)
                        end
                        if id == 6 or id == 32 or id == 33 then
                          if shop.pay[id] == 0 then
                            shop.pay[id] = shop.pay[id] + 29
                          else
                            shop.pay[id] = shop.pay[id] + 30
                          end
                        else
                          shop.pay[id] = shop.pay[id] + 1
                        end
                        if #itemBg == 8 and (ii == #itemBg or ii == #itemBg - 1 or ii == #itemBg - 2) then
                          if id ~= 33 then
                            if lbllef1[ii] == nil then
                              lbllef1[ii] = lbl.createMixFont1(14, i18n.global.monthcard_left1.string, ccc3(255, 246, 223))
                              lbllef1[ii]:setAnchorPoint(CCPoint(0, 0.5))
                              lbllef1[ii]:setPosition(10, -12)
                              itemBg[ii]:addChild(lbllef1[ii])
                            end
                            if lbllef2[ii] == nil then
                              lbllef2[ii] = lbl.createMixFont1(14, string.format(i18n.global.monthcard_left2.string, shop.pay[id]), ccc3(165, 253, 71))
                              lbllef2[ii]:setAnchorPoint(CCPoint(0, 0.5))
                              lbllef2[ii]:setPosition(lbllef1[ii]:boundingBox():getMaxX() + 4, -12)
                              itemBg[ii]:addChild(lbllef2[ii])
                            else
                              lbllef2[ii]:setString(string.format(i18n.global.monthcard_left2.string, shop.pay[id]))
                            end
                          else
                            shop.addSubHead()
                            subTitle:setString(i18n.global.activity_des_subed.string)
                          end
                        end
                        if #itemBg == 7 and (ii == #itemBg or ii == #itemBg - 1) then
                          if lbllef1[ii] == nil then
                            lbllef1[ii] = lbl.createMixFont1(14, i18n.global.monthcard_left1.string, ccc3(255, 246, 223))
                            lbllef1[ii]:setAnchorPoint(CCPoint(0, 0.5))
                            lbllef1[ii]:setPosition(10, -12)
                            itemBg[ii]:addChild(lbllef1[ii])
                          end
                          if lbllef2[ii] == nil then
                            lbllef2[ii] = lbl.createMixFont1(14, string.format(i18n.global.monthcard_left2.string, shop.pay[id]), ccc3(165, 253, 71))
                            lbllef2[ii]:setAnchorPoint(CCPoint(0, 0.5))
                            lbllef2[ii]:setPosition(lbllef1[ii]:boundingBox():getMaxX() + 4, -12)
                            itemBg[ii]:addChild(lbllef2[ii])
                          else
                            lbllef2[ii]:setString(string.format(i18n.global.monthcard_left2.string, shop.pay[id]))
                          end
                        end
                        specialLayer:removeAllChildrenWithCleanup(true)
                        createSpecial()
                        local curpos = 0
                        if itemNum == 8 then
                          curpos = 1
                        end
                      end
                      local rewardlayer = reward.createFloating(pbbag, 1000)
                      if layer and not tolua.isnull(layer) then
                        layer:addChild(rewardlayer, 1000)
                      end
                       -- Warning: missing end command somewhere! Added here
                    end
                           end)
                        end
                if id ~= 33 then
                  payFunc()
                else
                  if device.platform == "ios" then
                    local subscribe = require("ui.shop.subscribe")
                    layer:addChild(subscribe.create(), 1000)
                  else
                    payFunc()
                  end
                end
                do return end
              end
            end
          end
        end
      end
    end
   end
  local onTouch = function(l_7_0, l_7_1, l_7_2)
    if l_7_0 == "began" then
      return onTouchBegan(l_7_1, l_7_2)
    elseif l_7_0 == "moved" then
      return onTouchMoved(l_7_1, l_7_2)
    else
      return onTouchEnded(l_7_1, l_7_2)
    end
   end
  storeBuyLayer:registerScriptTouchHandler(onTouch, false, -128, false)
  storeBuyLayer:setTouchEnabled(true)
  return storeBuyLayer
end

return ui

