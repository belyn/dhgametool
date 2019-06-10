-- Command line was: E:\github\dhgametool\scripts\ui\vip\mcard.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local player = require("data.player")
local shopData = require("data.shop")
local activityData = require("data.activity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local cfgstore = require("config.store")
local shop = require("data.shop")
local IDS = activityData.IDS
ui.create = function()
  local layer = CCLayer:create()
  local origin_price = "\236\155\144\234\176\128 $194.99"
  local sale_price = "$14.99"
  if isOnestore() then
    origin_price = "\236\155\144\234\176\128 235,950"
    sale_price = "18,700"
  end
  local bg = img.createUISprite(img.ui.vip_mcard_bg)
  bg:setPosition(view.midX, view.midY)
  bg:setScale(view.minScale)
  layer:addChild(bg)
  local suffix = "us"
  if i18n.getCurrentLanguage() == kLanguageChinese then
    suffix = "cn"
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      suffix = "tw"
    else
      if i18n.getCurrentLanguage() == kLanguageEnglish then
        suffix = "us"
      else
        if i18n.getCurrentLanguage() == kLanguageJapanese then
          suffix = "jp"
        else
          if i18n.getCurrentLanguage() == kLanguageFrench then
            suffix = "fr"
          else
            if i18n.getCurrentLanguage() == kLanguageGerman then
              suffix = "ge"
            else
              if i18n.getCurrentLanguage() == kLanguageKorean then
                suffix = "kr"
              else
                if i18n.getCurrentLanguage() == kLanguagePortuguese then
                  suffix = "pt"
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
  local des = img.createUISprite(string.format("vip_mcard_des_%s.png", suffix))
  des:setAnchorPoint(CCPoint(0, 0.5))
  des:setPosition(300, bg:getContentSize().height / 2)
  bg:addChild(des)
  if i18n.getCurrentLanguage() == kLanguageKorean then
    local id = 6
  end
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
  local lbllef1 = lbl.createFont1(14, i18n.global.monthcard_left1.string, ccc3(255, 246, 223))
  lbllef1:setAnchorPoint(CCPoint(0, 0.5))
  lbllef1:setPosition(570, 130)
  bg:addChild(lbllef1)
  local lbllef2 = lbl.createFont1(14, string.format(i18n.global.monthcard_left2.string, shop.pay[id]), ccc3(165, 253, 71))
  lbllef2:setAnchorPoint(CCPoint(0, 0.5))
  lbllef2:setPosition(lbllef1:boundingBox():getMaxX() + 4, 130)
  bg:addChild(lbllef2)
  local btn_buy0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_buy0:setPreferredSize(CCSizeMake(156, 52))
  local lbl_buy = lbl.createFont1(18, item_price, ccc3(73, 38, 4))
  lbl_buy:setPosition(CCPoint(78, 26))
  btn_buy0:addChild(lbl_buy)
  local btn_buy = SpineMenuItem:create(json.ui.button, btn_buy0)
  btn_buy:setPosition(CCPoint(630, 86))
  local btn_buy_menu = CCMenu:createWithItem(btn_buy)
  btn_buy_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_buy_menu)
  btn_buy:registerScriptTapHandler(function()
    audio.play(audio.button)
    local gemShop = require("ui.shop.main")
    layer:getParent():addChild(gemShop.create(), 1001)
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(false)
  local last_update = os.time() - 1
  local onUpdate = function(l_2_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    lbllef2:setString(string.format(i18n.global.monthcard_left2.string, shop.pay[id]))
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  return layer
end

return ui

