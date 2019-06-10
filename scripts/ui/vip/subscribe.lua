-- Command line was: E:\github\dhgametool\scripts\ui\vip\subscribe.lua 

local ui = {}
require("common.func")
require("common.const")
local img = require("res.img")
local json = require("res.json")
local view = require("common.view")
local audio = require("res.audio")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local store = require("config.store")
local shop = require("data.shop")
ui.create = function()
  local layer = CCLayer:create()
  local bg = img.createUISprite(img.ui.vip_subscribe_bg)
  bg:setPosition(view.midX, view.midY)
  bg:setScale(view.minScale)
  layer:addChild(bg)
  local h = bg:getContentSize().height
  local suffix = "us"
  local scale = 1
  local offsetY = 10
  if i18n.getCurrentLanguage() == kLanguageChinese then
    suffix = "cn"
    offsetY = 5
  else
    if i18n.getCurrentLanguage() == kLanguageEnglish then
      suffix = "us"
      scale = 0.9
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        suffix = "jp"
      else
        if i18n.getCurrentLanguage() == kLanguageFrench then
          suffix = "fr"
          scale = 0.85
        else
          if i18n.getCurrentLanguage() == kLanguageGerman then
            suffix = "ge"
            scale = 0.7
          else
            if i18n.getCurrentLanguage() == kLanguageItalian then
              suffix = "it"
              scale = 0.8
            else
              if i18n.getCurrentLanguage() == kLanguageKorean then
                suffix = "kr"
              else
                if i18n.getCurrentLanguage() == kLanguageMalay then
                  suffix = "ml"
                  scale = 0.8
                else
                  if i18n.getCurrentLanguage() == kLanguagePortuguese then
                    suffix = "pt"
                    scale = 0.8
                  else
                    if i18n.getCurrentLanguage() == kLanguageRussian then
                      suffix = "ru"
                    else
                      if i18n.getCurrentLanguage() == kLanguageSpanish then
                        suffix = "sp"
                        scale = 0.8
                      else
                        if i18n.getCurrentLanguage() == kLanguageTurkish then
                          suffix = "tk"
                          scale = 0.8
                        else
                          if i18n.getCurrentLanguage() == kLanguageThai then
                            suffix = "tl"
                            scale = 0.8
                          else
                            if i18n.getCurrentLanguage() == kLanguageChineseTW then
                              suffix = "tw"
                              offsetY = 5
                            else
                              if i18n.getCurrentLanguage() == kLanguageVietnamese then
                                suffix = "vn"
                                scale = 0.8
                              else
                                suffix = "us"
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
          end
        end
      end
    end
  end
  local title = img.createUISprite(string.format("vip_subscribe_title_%s.png", suffix))
  title:setPosition(57, h - 26 - 22)
  title:setAnchorPoint(0, 0.5)
  bg:addChild(title)
  local des = img.createUISprite(string.format("vip_subscribe_des_%s.png", suffix))
  des:setPosition(42, h - 70 - 20)
  des:setAnchorPoint(0, 1)
  bg:addChild(des)
  local appBg = img.createUISprite(img.ui.vip_subscribe_app)
  local app = SpineMenuItem:create(json.ui.button, appBg)
  app:setPosition(556, h - 20)
  app:setAnchorPoint(0.5, 1)
  app:registerScriptTapHandler(function()
    audio.play(audio.button)
    device.openURL("https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions")
   end)
  local appMenu = CCMenu:createWithItem(app)
  appMenu:setPosition(0, 0)
  bg:addChild(appMenu)
  local restoreBg0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  restoreBg0:setPreferredSize(CCSizeMake(120, 40))
  local restore_txt = "Restore"
  if i18n.getCurrentLanguage() == kLanguageChinese then
    restore_txt = "\230\129\162\229\164\141\232\174\162\233\152\133"
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      restore_txt = "\230\129\162\229\190\169\232\168\130\233\150\177"
    end
  end
  local lbl_restore = lbl.createFontTTF(18, restore_txt, ccc3(115, 59, 5))
  lbl_restore:setPosition(CCPoint(restoreBg0:getContentSize().width / 2, restoreBg0:getContentSize().height / 2))
  restoreBg0:addChild(lbl_restore)
  local restore = SpineMenuItem:create(json.ui.button, restoreBg0)
  restore:setAnchorPoint(0.5, 0.5)
  restore:setPosition(658, h - 46)
  restore:registerScriptTapHandler(function()
    audio.play(audio.button)
    local waitnet = addWaitNet()
    waitnet.setTimeout(90)
    DHPayment:getInstance():restore(function(l_1_0, l_1_1)
      print("iap pull {")
      print("status", l_1_0)
      if l_1_0 ~= "ok" or #l_1_1 == 0 then
        delWaitNet()
        print("iap pull }")
        showToast("have no subscription now.")
        return 
      end
      local iap = require("common.iap")
      iap.verify(l_1_1, function(l_1_0)
        delWaitNet()
        print("iap pull }")
        if l_1_0 then
          showToast("restored.")
        else
          showToast("have no subscription now.")
        end
         end)
      end)
   end)
  local restoreMenu = CCMenu:createWithItem(restore)
  restoreMenu:setPosition(0, 0)
  bg:addChild(restoreMenu)
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(42, h - 340 - 20)
  scroll:setViewSize(CCSize(479, 144))
  bg:addChild(scroll)
  local contentDetail = string.split(i18n.global.vip_subscribe_text.string, "|||")
  local height = 0
  for i = #contentDetail, 1, -1 do
    local label = lbl.create({kind = "ttf", font = 1, size = 14, text = contentDetail[i], color = ccc3(213, 215, 220), width = 479, align = kCCTextAlignmentLeft})
    label:setAnchorPoint(0, 1)
    scroll:getContainer():addChild(label)
    height = height + label:getContentSize().height + offsetY
    label:setPosition(0, height)
  end
  scroll:setContentSize(CCSize(479, height))
  scroll:setContentOffset(CCPoint(0, 144 - (height)))
  local getPrice = function(l_3_0)
    if i18n.getCurrentLanguage() == kLanguageChinese then
      return store[l_3_0].priceCnStr
    else
      return store[l_3_0].priceStr
    end
   end
  local quarterBg = img.createUI9Sprite(img.ui.btn_2)
  quarterBg:setPreferredSize(CCSizeMake(202, 73))
  local quarterBuy = img.createUISprite(img.ui.login_month_finish)
  quarterBuy:setPosition(quarterBg:getContentSize().width - 13, quarterBg:getContentSize().height - 13)
  quarterBg:addChild(quarterBuy)
  local quarterPrice = lbl.createFont1(18, getPrice(36), ccc3(115, 59, 5))
  quarterPrice:setPosition(quarterBg:getContentSize().width / 2, 48)
  quarterBg:addChild(quarterPrice)
  local quarterText = lbl.createFont1(18, i18n.global.vip_subscribe_quarter_text.string, ccc3(115, 59, 5))
  quarterText:setPosition(quarterBg:getContentSize().width / 2, 22)
  quarterText:setScale(scale * quarterText:getScale())
  quarterBg:addChild(quarterText)
  local quarter = SpineMenuItem:create(json.ui.button, quarterBg)
  quarter:setPosition(146, h - 380 - 20)
  quarter:setAnchorPoint(0.5, 1)
  local quarterMenu = CCMenu:createWithItem(quarter)
  quarterMenu:setPosition(0, 0)
  bg:addChild(quarterMenu)
  local monthBg = img.createUI9Sprite(img.ui.btn_2)
  monthBg:setPreferredSize(CCSizeMake(202, 73))
  local monthBuy = img.createUISprite(img.ui.login_month_finish)
  monthBuy:setPosition(monthBg:getContentSize().width - 13, monthBg:getContentSize().height - 13)
  monthBg:addChild(monthBuy)
  local monthPrice = lbl.createFont1(18, getPrice(35), ccc3(115, 59, 5))
  monthPrice:setPosition(monthBg:getContentSize().width / 2, 48)
  monthBg:addChild(monthPrice)
  local monthText = lbl.createFont1(18, i18n.global.vip_subscribe_month_text.string, ccc3(115, 59, 5))
  monthText:setPosition(monthBg:getContentSize().width / 2, 22)
  monthText:setScale(scale * monthText:getScale())
  monthBg:addChild(monthText)
  local month = SpineMenuItem:create(json.ui.button, monthBg)
  month:setPosition(376, h - 380 - 20)
  month:setAnchorPoint(0.5, 1)
  local monthMenu = CCMenu:createWithItem(month)
  monthMenu:setPosition(0, 0)
  bg:addChild(monthMenu)
  do
    local weekOriginPrice = lbl.createMix({font = 1, size = 14, text = i18n.global.vip_subscribe_week_tip.string, color = ccc3(112, 145, 233), width = 665, align = kCCTextAlignmentLeft})
    weekOriginPrice:setPosition(46, h - 344 - 20)
    weekOriginPrice:setAnchorPoint(0, 1)
    bg:addChild(weekOriginPrice)
  end
  local noFree = false
  local weekBg = img.createLogin9Sprite(img.login.button_9_small_gold)
  weekBg:setPreferredSize(CCSizeMake(202, 73))
  local weekBg1 = img.createLogin9Sprite(img.login.button_9_small_gold)
  weekBg1:setPreferredSize(CCSizeMake(202, 73))
  local weekPrice = lbl.createFont1(18, getPrice(33), ccc3(115, 59, 5))
  weekPrice:setPosition(weekBg1:getContentSize().width / 2, 48)
  weekBg1:addChild(weekPrice)
  local weekText1 = lbl.createFont1(18, i18n.global.vip_subscribe_week_text.string, ccc3(115, 59, 5))
  weekText1:setPosition(weekBg1:getContentSize().width / 2, 22)
  weekText1:setScale(scale * weekText1:getScale())
  weekBg1:addChild(weekText1)
  weekBg1:setPosition(CCPoint(weekBg:getContentSize().width / 2, weekBg:getContentSize().height / 2))
  weekBg:addChild(weekBg1)
  local weekBg2 = img.createLogin9Sprite(img.login.button_9_small_green)
  weekBg2:setPreferredSize(CCSizeMake(202, 73))
  local weekText2 = lbl.createFont1(18, i18n.global.vip_subscribe_week_free_text.string, ccc3(32, 101, 5))
  weekText2:setPosition(weekBg2:getContentSize().width / 2, weekBg2:getContentSize().height / 2)
  weekText2:setScale(scale * weekText2:getScale())
  weekBg2:addChild(weekText2)
  weekBg2:setPosition(CCPoint(weekBg:getContentSize().width / 2, weekBg:getContentSize().height / 2))
  weekBg:addChild(weekBg2)
  local updateWeekBg = function(l_4_0)
    if shop.everSubbed() then
      l_4_0 = true
    end
    weekBg1:setVisible(l_4_0)
    weekBg2:setVisible( l_4_0)
   end
  updateWeekBg(noFree)
  local weekBuy = img.createUISprite(img.ui.login_month_finish)
  weekBuy:setPosition(weekBg:getContentSize().width - 13, weekBg:getContentSize().height - 13)
  weekBg:addChild(weekBuy)
  local week = SpineMenuItem:create(json.ui.button, weekBg)
  week:setPosition(606, h - 380 - 20)
  week:setAnchorPoint(0.5, 1)
  local processUI = function(l_5_0)
    if l_5_0 == 33 then
      quarterBuy:setVisible(false)
      quarter:setEnabled(true)
      monthBuy:setVisible(false)
      month:setEnabled(true)
      weekBuy:setVisible(true)
      week:setEnabled(false)
    elseif l_5_0 == 35 then
      quarterBuy:setVisible(false)
      quarter:setEnabled(true)
      monthBuy:setVisible(true)
      month:setEnabled(false)
      weekBuy:setVisible(false)
      week:setEnabled(true)
    elseif l_5_0 == 36 then
      quarterBuy:setVisible(true)
      quarter:setEnabled(false)
      monthBuy:setVisible(false)
      month:setEnabled(true)
      weekBuy:setVisible(false)
      week:setEnabled(true)
    else
      quarterBuy:setVisible(false)
      quarter:setEnabled(true)
      monthBuy:setVisible(false)
      month:setEnabled(true)
      weekBuy:setVisible(false)
      week:setEnabled(true)
    end
    updateWeekBg(l_5_0 > 0)
   end
  processUI(shop.subId())
  local purchase = function(l_6_0)
    local cfg = store[l_6_0]
    local waitnet = addWaitNet()
    waitnet.setTimeout(60)
    local iap = require("common.iap")
    iap.pay(cfg.payId, function(l_1_0)
      delWaitNet()
      if not l_1_0 then
        tbl2string({})
      end
      if l_1_0 and l_1_0.items then
        shop.addSubHead()
        local o_storeid = shop.subId()
        if o_storeid < storeid then
          shop.subId(storeid)
          shop.setPay(33, 1)
          processUI(storeid)
        end
        local reward = require("ui.reward")
        local rewardlayer = reward.createFloating(l_1_0, 1000)
        if layer and not tolua.isnull(layer) then
          layer:addChild(rewardlayer, 1000)
        end
      end
      end)
   end
  quarter:registerScriptTapHandler(function()
    audio.play(audio.button)
    purchase(36)
   end)
  month:registerScriptTapHandler(function()
    audio.play(audio.button)
    purchase(35)
   end)
  week:registerScriptTapHandler(function()
    audio.play(audio.button)
    purchase(33)
   end)
  local weekMenu = CCMenu:createWithItem(week)
  weekMenu:setPosition(0, 0)
  bg:addChild(weekMenu)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(false)
  return layer
end

return ui

