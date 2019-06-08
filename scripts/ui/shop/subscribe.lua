-- Command line was: E:\github\dhgametool\scripts\ui\shop\subscribe.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.activity")
local player = require("data.player")
local activityData = require("data.activity")
local shop = require("data.shop")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
ui.create = function()
  local layer = CCLayer:create()
  img.load("ui_sub")
  local bg = img.createUISprite("sub_bg.png")
  bg:setScale(view.minScale)
  bg:setPosition(scalep(480, 288))
  layer:addChild(bg)
  local bg_w = bg:getContentSize().width
  local bg_h = bg:getContentSize().height
  local x_offset = 160
  local y_offset = 96
  local term_text = nil
  local tip1_txt = "Gold coin in auto-battle +100%"
  local tip2_txt = "A special gold dragon avatar"
  local lbl_buy_txt = "USD 0.99/week"
  local toast_1 = "you have subscribed this."
  local toast_2 = "subscribed"
  local lbl_restore_txt = "Restore Purchase"
  if i18n.getCurrentLanguage() == kLanguageChinese then
    term_text = img.createUISprite("sub_term_text_cn.png")
    tip1_txt = "\229\156\168\230\140\130\230\156\186\228\184\173\233\135\145\229\184\129\230\148\182\231\155\138 +100%"
    tip2_txt = "\228\184\128\228\184\170\229\174\154\229\136\182\231\154\132\233\135\145\233\190\153\229\164\180\229\131\143"
    lbl_buy_txt = "0.99 \231\190\142\229\133\131/\229\145\168"
    toast_1 = "\230\130\168\229\183\178\231\187\143\232\180\173\228\185\176\230\173\164\233\161\185\232\174\162\233\152\133"
    toast_2 = "\232\174\162\233\152\133\230\136\144\229\138\159"
    lbl_restore_txt = "\230\129\162\229\164\141\232\180\173\228\185\176"
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      term_text = img.createUISprite("sub_term_text_cn.png")
      tip1_txt = "\229\156\168\230\140\130\230\156\186\228\184\173\233\135\145\229\184\129\230\148\182\231\155\138 +100%"
      tip2_txt = "\228\184\128\228\184\170\229\174\154\229\136\182\231\154\132\233\135\145\233\190\153\229\164\180\229\131\143"
      lbl_buy_txt = "0.99 \231\190\142\229\133\131/\229\145\168"
      toast_1 = "\230\130\168\229\183\178\231\187\143\232\180\173\228\185\176\230\173\164\233\161\185\232\174\162\233\152\133"
      toast_2 = "\232\174\162\233\152\133\230\136\144\229\138\159"
      lbl_restore_txt = "\230\129\162\229\164\141\232\180\173\228\185\176"
    else
      term_text = img.createUISprite("sub_term_text.png")
    end
  end
  term_text:setPosition(CCPoint(214 + x_offset, 288 + y_offset))
  bg:addChild(term_text)
  local logo = img.createUISprite("sub_logo.png")
  logo:setPosition(CCPoint(690 + x_offset, 478 + y_offset))
  bg:addChild(logo)
  local tip1 = lbl.createMixFont1(20, tip1_txt, ccc3(255, 255, 255))
  tip1:setPosition(CCPoint(690 + x_offset, 362 + y_offset))
  bg:addChild(tip1)
  local tip2 = lbl.createMixFont1(20, tip2_txt, ccc3(255, 255, 255))
  tip2:setPosition(CCPoint(690 + x_offset, 320 + y_offset))
  bg:addChild(tip2)
  local btn_buy0 = img.createUI9Sprite("sub_button_yellow.png")
  btn_buy0:setPreferredSize(CCSizeMake(300, 56))
  local lbl_buy = CCLabelTTF:create(lbl_buy_txt, "", 22)
  lbl_buy:setColor(ccc3(101, 66, 5))
  lbl_buy:setPosition(CCPoint(btn_buy0:getContentSize().width / 2, btn_buy0:getContentSize().height / 2))
  btn_buy0:addChild(lbl_buy)
  local btn_buy = SpineMenuItem:create(json.ui.button, btn_buy0)
  btn_buy:setPosition(CCPoint(690 + x_offset, 207 + y_offset))
  local btn_buy_menu = CCMenu:createWithItem(btn_buy)
  btn_buy_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_buy_menu)
  btn_buy:registerScriptTapHandler(function()
    audio.play(audio.button)
    if shop.pay and shop.pay[33] and shop.pay[33] > 0 then
      showToast(toast_1)
      return 
    end
    local waitnet = addWaitNet()
    waitnet.setTimeout(90)
    local iap = require("common.iap")
    local cfg = require("config.store")
    iap.pay(cfg[33].payId, function(l_1_0)
      delWaitNet()
      if l_1_0 then
        shop.setPay(33, 1)
        shop.addSubHead()
        showToast(toast_2)
        replaceScene(require("ui.town.main").create({from_layer = "shop"}))
      end
      end)
   end)
  local btn_restore0 = img.createUI9Sprite("sub_button_green.png")
  btn_restore0:setPreferredSize(CCSizeMake(300, 56))
  local lbl_restore = CCLabelTTF:create(lbl_restore_txt, "", 22)
  lbl_restore:setColor(ccc3(48, 79, 5))
  lbl_restore:setPosition(CCPoint(btn_restore0:getContentSize().width / 2, btn_restore0:getContentSize().height / 2))
  btn_restore0:addChild(lbl_restore)
  local btn_restore = SpineMenuItem:create(json.ui.button, btn_restore0)
  btn_restore:setPosition(CCPoint(690 + x_offset, 127 + y_offset))
  local btn_restore_menu = CCMenu:createWithItem(btn_restore)
  btn_restore_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_restore_menu)
  btn_restore:registerScriptTapHandler(function()
    audio.play(audio.button)
    if shop.pay and shop.pay[33] and shop.pay[33] > 0 then
      showToast(toast_1)
      return 
    end
    local waitnet = addWaitNet()
    waitnet.setTimeout(90)
    DHPayment:getInstance():restore(function(l_1_0, l_1_1)
      print("iap pull {")
      print("status", l_1_0)
      if l_1_0 ~= "ok" or  l_1_1 == 0 then
        delWaitNet()
        print("iap pull }")
        return 
      end
      local iap = require("common.iap")
      iap.verify(l_1_1, function(l_1_0)
        delWaitNet()
        print("iap pull }")
        if l_1_0 then
          shop.setPay(33, 1)
          shop.addSubHead()
          showToast("restored.")
          replaceScene(require("ui.town.main").create({from_layer = "shop"}))
        end
         end)
      end)
   end)
  local tip3 = CCLabelTTF:create("Continue means that you accept", "", 14)
  tip3:setColor(ccc3(255, 255, 255))
  tip3:setPosition(CCPoint(690 + x_offset, 66 + y_offset))
  bg:addChild(tip3)
  local tip4 = CCLabelTTF:create("[ Terms Of Service & Privacy Policy ]", "", 14)
  tip4:setColor(ccc3(255, 255, 255))
  local btn_tip4_0 = CCSprite:create()
  btn_tip4_0:setContentSize(tip4:getContentSize())
  tip4:setPosition(CCPoint(btn_tip4_0:getContentSize().width / 2, btn_tip4_0:getContentSize().height / 2))
  btn_tip4_0:addChild(tip4)
  local btn_tip4 = CCMenuItemSprite:create(btn_tip4_0, nil)
  btn_tip4:setPosition(CCPoint(610 + x_offset, 40 + y_offset))
  local btn_tip4_menu = CCMenu:createWithItem(btn_tip4)
  btn_tip4_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_tip4_menu)
  btn_tip4:registerScriptTapHandler(function()
    audio.play(audio.button)
    print("click tip4")
    layer:addChild(require("ui.shop.privacy").create(), 1000)
   end)
  local tip5 = CCLabelTTF:create("[ Payment Terms ]", "", 14)
  tip5:setColor(ccc3(255, 255, 255))
  local btn_tip5_0 = CCSprite:create()
  btn_tip5_0:setContentSize(tip5:getContentSize())
  tip5:setPosition(CCPoint(btn_tip5_0:getContentSize().width / 2, btn_tip5_0:getContentSize().height / 2))
  btn_tip5_0:addChild(tip5)
  local btn_tip5 = CCMenuItemSprite:create(btn_tip5_0, nil)
  btn_tip5:setPosition(CCPoint(810 + x_offset, 40 + y_offset))
  local btn_tip5_menu = CCMenu:createWithItem(btn_tip5)
  btn_tip5_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_tip5_menu)
  btn_tip5:registerScriptTapHandler(function()
    audio.play(audio.button)
    print("click tip5")
    layer:addChild(require("ui.shop.payment").create(), 1000)
   end)
  local backEvent = function()
    layer:removeFromParent()
   end
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = SpineMenuItem:create(json.ui.button, btnBackSprite)
  btnBack:setScale(view.minScale)
  btnBack:setPosition(scalep(35, 546))
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  layer:addChild(menuBack, 10)
  btnBack:registerScriptTapHandler(function()
    backEvent()
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    backEvent()
   end
  local onEnter = function()
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_10_0)
    if l_10_0 == "enter" then
      onEnter()
    elseif l_10_0 == "exit" then
      onExit()
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

