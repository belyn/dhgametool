-- Command line was: E:\github\dhgametool\scripts\ui\mcard\main.lua 

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
  img.unload(img.packedOthers.ui_mcard)
  img.unload(img.packedOthers.ui_mcard_cn)
  if i18n.getCurrentLanguage() == kLanguageChinese then
    img.load(img.packedOthers.ui_mcard_cn)
  else
    img.load(img.packedOthers.ui_mcard)
  end
  local origin_price = "\236\155\144\234\176\128 $194.99"
  local sale_price = "$14.99"
  if isOnestore() then
    origin_price = "\236\155\144\234\176\128 235,950"
    sale_price = "18,700"
  end
  local board = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    board = img.createUISprite("mcard_board_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      board = img.createUISprite("mcard_board_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        board = img.createUISprite("mcard_board_jp.png")
      else
        if i18n.getCurrentLanguage() == kLanguageRussian then
          board = img.createUISprite("mcard_board_ru.png")
        else
          if i18n.getCurrentLanguage() == kLanguageSpanish then
            board = img.createUISprite("mcard_board_ks.png")
          else
            if i18n.getCurrentLanguage() == kLanguagePortuguese then
              board = img.createUISprite("mcard_board_kp.png")
            else
              board = img.createUISprite(img.ui.mcard_board)
            end
          end
        end
      end
    end
  end
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(372, 9))
  layer:addChild(board)
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
  local costLab = lbl.createFontTTF(18, item_price, ccc3(255, 214, 116))
  costLab:setPosition(328, 122)
  board:addChild(costLab)
  local lbllef1 = lbl.createMixFont1(14, i18n.global.monthcard_left1.string, ccc3(255, 246, 223))
  lbllef1:setAnchorPoint(CCPoint(0, 0.5))
  lbllef1:setPosition(290, 100)
  board:addChild(lbllef1)
  local lbllef2 = lbl.createMixFont1(14, string.format(i18n.global.monthcard_left2.string, shop.pay[id]), ccc3(165, 253, 71))
  lbllef2:setAnchorPoint(CCPoint(0, 0.5))
  lbllef2:setPosition(lbllef1:boundingBox():getMaxX() + 4, 100)
  board:addChild(lbllef2)
  local btn_buy0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_buy0:setPreferredSize(CCSizeMake(156, 52))
  local lbl_buy = lbl.createFont1(18, i18n.global.chip_btn_buy.string, ccc3(73, 38, 4))
  lbl_buy:setPosition(CCPoint(78, 26))
  btn_buy0:addChild(lbl_buy)
  local btn_buy = SpineMenuItem:create(json.ui.button, btn_buy0)
  btn_buy:setPosition(CCPoint(328, 60))
  local btn_buy_menu = CCMenu:createWithItem(btn_buy)
  btn_buy_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_buy_menu)
  btn_buy:registerScriptTapHandler(function()
    audio.play(audio.button)
    local gemShop = require("ui.shop.main")
    layer:getParent():getParent():addChild(gemShop.create(), 1001)
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(false)
  return layer
end

return ui

