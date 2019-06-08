-- Command line was: E:\github\dhgametool\scripts\ui\activity\fridaycard.lua 

local ui = {}
local view = require("common.view")
local img = require("res.img")
local i18n = require("res.i18n")
local audio = require("res.audio")
local json = require("res.json")
local lbl = require("res.lbl")
local cfgstore = require("config.store")
local activityConfig = require("config.activity")
local activityData = require("data.activity")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local bagdata = require("data.bag")
ui.create = function()
  local layer = CCLayer:create()
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(570, 438))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(352, 57))
  layer:addChild(board)
  local data = activityData.getStatusById(activityData.IDS.FRIDAY_CARD.ID)
  local cfg = cfgstore[activityConfig[activityData.IDS.FRIDAY_CARD.ID].storeId]
  img.load(img.packedOthers.ui_activity_friday_card)
  local bg = img.createUISprite(img.ui.activity_friday_card_bg)
  bg:setPosition(board:getContentSize().width / 2, board:getContentSize().height / 2)
  board:addChild(bg)
  local w = board:getContentSize().width
  local h = board:getContentSize().height
  local suffix = "us"
  if i18n.getCurrentLanguage() == kLanguageKorean then
    suffix = "kr"
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      suffix = "tw"
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        suffix = "jp"
      else
        if i18n.getCurrentLanguage() == kLanguageRussian then
          suffix = "us"
        else
          if i18n.getCurrentLanguage() == kLanguageChinese then
            suffix = "cn"
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
  local banner = img.createUISprite(string.format("activity_friday_card_title_%s.png", suffix))
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(326, h - 50))
  bg:addChild(banner)
  local des = lbl.createMixFont2(16, i18n.global.activity_friday_card_des.string, ccc3(255, 246, 243))
  des:setPosition(CCPoint(326, h - 156))
  bg:addChild(des)
  local reward = lbl.createMixFont1(14, i18n.global.activity_friday_card_reward.string, ccc3(233, 186, 255))
  reward:setPosition(CCPoint(326, h - 185))
  bg:addChild(reward)
  local rewards = {{id = 2, num = 800, type = 1}, {id = 170, num = 2, type = 1}, {id = 1, num = 88000, type = 1}}
  for ii = 1,  rewards do
    local reward = rewards[ii]
    do
      local rewardNode = nil
      if reward.type == 1 then
        rewardNode = CCMenuItemSprite:create((img.createItem(reward.id, reward.num)), nil)
      elseif reward.type == 2 then
        rewardNode = CCMenuItemSprite:create((img.createEquip(reward.id, reward.num)), nil)
      end
      rewardNode:setPosition(CCPoint(326 - ( rewards - 1) / 2 * 92 + (ii - 1) * 92, 188))
      rewardNode:registerScriptTapHandler(function()
        audio.play(audio.button)
        local tip = nil
        if reward.type == 1 then
          tip = tipsitem.createForShow({id = reward.id})
          layer:addChild(tip, 100)
        else
          if reward.type == 2 then
            tip = tipsequip.createById(reward.id)
            layer:addChild(tip, 100)
          end
        end
         end)
      local rewardNodeMenu = CCMenu:createWithItem(rewardNode)
      rewardNodeMenu:setPosition(CCPoint(0, 0))
      bg:addChild(rewardNodeMenu)
    end
  end
  local lv = img.createUI9Sprite(img.ui.activity_friday_card_lv)
  lv:setPosition(438, 200)
  lv:setAnchorPoint(0, 0)
  bg:addChild(lv)
  local limitLabel = lbl.createFont2(16, i18n.global.limitact_limit.string .. 1, ccc3(255, 255, 255))
  limitLabel:setPosition(CCPoint(326, 120))
  bg:addChild(limitLabel)
  local btnBg = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnBg:setPreferredSize(CCSizeMake(158, 48))
  local getPriceStr = function()
    if i18n.getCurrentLanguage() == kLanguageChinese then
      return cfg.priceCnStr
    else
      return cfg.priceStr
    end
   end
  local price = lbl.createFont1(20, getPriceStr(), ccc3(115, 59, 5))
  price:setPosition(btnBg:getContentSize().width / 2, btnBg:getContentSize().height / 2)
  btnBg:addChild(price)
  local buy = SpineMenuItem:create(json.ui.button, btnBg)
  buy:setPosition(326, 78)
  buy:registerScriptTapHandler(function()
    audio.play(audio.button)
    disableSeconds(buy, 8, price, getPriceStr())
    local wait = addWaitNet()
    wait.setTimeout(60)
    local iap = require("common.iap")
    iap.pay(cfg.payId, function(l_1_0)
      delWaitNet()
      if l_1_0 then
        if not l_1_0 then
          tbl2string({})
        end
        data.limits = data.limits - 1
        bagdata.items.add({id = ITEM_ID_VIP_EXP, num = cfg.vipExp})
        if buy and not tolua.isnull(buy) then
          setShader(buy, SHADER_GRAY, true)
          buy:setEnabled(false)
        end
        if limitLabel and not tolua.isnull(limitLabel) then
          limitLabel:setString(i18n.global.limitact_limit.string .. 0)
        end
      end
      end)
   end)
  if data.status ~= 0 or data.limits <= 0 then
    setShader(buy, SHADER_GRAY, true)
    buy:setEnabled(false)
    limitLabel:setString(i18n.global.limitact_limit.string .. 0)
  end
  local buyMenu = CCMenu:createWithItem(buy)
  buyMenu:setPosition(CCPoint(0, 0))
  bg:addChild(buyMenu)
  layer:registerScriptHandler(function(l_4_0)
    if l_4_0 == "enter" then
      do return end
    end
    if l_4_0 == "exit" then
      do return end
    end
    if l_4_0 == "cleanup" then
      img.unload(img.packedOthers.ui_activity_friday_card)
    end
   end)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui

