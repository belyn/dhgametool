-- Command line was: E:\github\dhgametool\scripts\ui\activity\blackcard.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local player = require("data.player")
local activityData = require("data.activity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local cfgactivity = require("config.activity")
local cfgstore = require("config.store")
local shop = require("data.shop")
local IDS = activityData.IDS
local bc_id = IDS.BLACKCARD.ID
ui.create = function()
  local layer = CCLayer:create()
  local aStatus = activityData.getStatusById(bc_id)
  img.unload(img.packedOthers.ui_activity_blackcard)
  img.load(img.packedOthers.ui_activity_blackcard)
  local board = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    board = img.createUISprite("activity_blackcard_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChinese then
      board = img.createUISprite("activity_blackcard_cn.png")
    else
      if i18n.getCurrentLanguage() == kLanguageChineseTW then
        board = img.createUISprite("activity_blackcard_tw.png")
      else
        if i18n.getCurrentLanguage() == kLanguageJapanese then
          board = img.createUISprite("activity_blackcard_jp.png")
        else
          if i18n.getCurrentLanguage() == kLanguageRussian then
            board = img.createUISprite("activity_blackcard_ru.png")
          else
            if i18n.getCurrentLanguage() == kLanguagePortuguese then
              board = img.createUISprite("activity_blackcard_pt.png")
            else
              board = img.createUISprite("activity_blackcard.png")
            end
          end
        end
      end
    end
  end
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(360, 64))
  layer:addChild(board)
  local id = 34
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
  costLab:setPosition(248, 110)
  board:addChild(costLab)
  local btn_buy0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_buy0:setPreferredSize(CCSizeMake(160, 50))
  local lbl_buy = lbl.createFont1(18, i18n.global.chip_btn_buy.string, ccc3(73, 38, 4))
  lbl_buy:setPosition(CCPoint(78, 26))
  btn_buy0:addChild(lbl_buy)
  local btn_buy = SpineMenuItem:create(json.ui.button, btn_buy0)
  btn_buy:setPosition(CCPoint(248, 72))
  local btn_buy_menu = CCMenu:createWithItem(btn_buy)
  btn_buy_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_buy_menu)
  local checkBtn = function()
    if not aStatus or not aStatus.limits or aStatus.limits < 1 then
      btn_buy:setEnabled(false)
      setShader(btn_buy, SHADER_GRAY, true)
    end
   end
  checkBtn()
  local payId = cfgstore[cfgactivity[bc_id].storeId].payId
  btn_buy:registerScriptTapHandler(function()
    audio.play(audio.button)
    addWaitNet().setTimeout(60)
    require("common.iap").pay(payId, function(l_1_0)
      delWaitNet()
      if l_1_0 then
        require("data.bag").addRewards(l_1_0)
        btn_buy:setEnabled(false)
        setShader(btn_buy, SHADER_GRAY, true)
        aStatus.limits = 0
        showToast(i18n.global.toast_buy_okay.string)
      end
      end)
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(false)
  return layer
end

return ui

