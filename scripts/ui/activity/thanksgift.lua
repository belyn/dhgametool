-- Command line was: E:\github\dhgametool\scripts\ui\activity\thanksgift.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgstore = require("config.store")
local cfgactivity = require("config.activity")
local player = require("data.player")
local bagdata = require("data.bag")
local activityData = require("data.activity")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local IDS = activityData.IDS
ui.create = function()
  local layer = CCLayer:create()
  local status = activityData.getStatusById(IDS.THANKSGIVINGGIFT.ID)
  if not status then
    return 
  end
  img.load(img.packedOthers.ui_activity_thanksgiving)
  local board = img.createUISprite(img.ui.activity_thanksgiving_board)
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(362, 66))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local lable = nil
  if i18n.getCurrentLanguage() == kLanguageChinese then
    lable = img.createUISprite("activity_thanksgiving_cn.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      lable = img.createUISprite("activity_thanksgiving_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        lable = img.createUISprite("activity_thanksgiving_jp.png")
      else
        if i18n.getCurrentLanguage() == kLanguageKorean then
          lable = img.createUISprite("activity_thanksgiving_kr.png")
        else
          if i18n.getCurrentLanguage() == kLanguagePortuguese then
            lable = img.createUISprite("activity_thanksgiving_pt.png")
          else
            lable = img.createUISprite("activity_thanksgiving_us.png")
          end
        end
      end
    end
  end
  lable:setPosition(CCPoint(346, 315))
  board:addChild(lable)
  local rewards = cfgactivity[status.id].rewards
  local createSpineItem = function(l_1_0)
    local tmp_item = nil
    if l_1_0.type == 1 then
      local tmp_item0 = img.createItem(l_1_0.id, l_1_0.num)
      tmp_item = SpineMenuItem:create(json.ui.button, tmp_item0)
    elseif l_1_0.type == 2 then
      local tmp_item0 = img.createEquip(l_1_0.id, l_1_0.num)
      tmp_item = SpineMenuItem:create(json.ui.button, tmp_item0)
    end
    tmp_item:registerScriptTapHandler(function()
      audio.play(audio.button)
      local tmp_tip = nil
      if itemObj.type == 1 then
        tmp_tip = tipsitem.createForShow({id = itemObj.id})
        layer:getParent():getParent():addChild(tmp_tip, 1000)
      else
        if itemObj.type == 2 then
          tmp_tip = tipsequip.createById(itemObj.id)
          layer:addChild(tmp_tip, 100)
        end
      end
      tmp_tip.setClickBlankHandler(function()
        tmp_tip:removeFromParentAndCleanup(true)
         end)
      end)
    return tmp_item
   end
  local pos_y = 218
  local offset_x = 308
  local step_x = 72
  local first_item = createSpineItem(rewards[1])
  first_item:setPosition(CCPoint(228, pos_y))
  local first_item_menu = CCMenu:createWithItem(first_item)
  first_item_menu:setPosition(CCPoint(0, 0))
  board:addChild(first_item_menu)
  for ii = 2, #rewards do
    local tmp_item = createSpineItem(rewards[ii])
    tmp_item:setScale(0.8)
    tmp_item:setPosition(CCPoint(offset_x + (ii - 2) * step_x, pos_y - 7))
    local tmp_item_menu = CCMenu:createWithItem(tmp_item)
    tmp_item_menu:setPosition(CCPoint(0, 0))
    board:addChild(tmp_item_menu)
  end
  local storeID = cfgactivity[IDS.THANKSGIVINGGIFT.ID].storeId
  local cfg = cfgstore[storeID]
  local btn_get0 = img.createLogin9Sprite(img.login.button_9_gold)
  btn_get0:setPreferredSize(CCSizeMake(170, 60))
  local item_price = cfgstore[storeID].priceStr
  if isAmazon() then
    do return end
  end
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    item_price = cfgstore[storeID].priceCnStr
  else
    if i18n.getCurrentLanguage() == kLanguageChinese then
      item_price = cfgstore[storeID].priceCnStr
    end
  end
  local shopData = require("data.shop")
  item_price = shopData.getPrice(storeID, item_price)
  local lbl_get = lbl.createFontTTF(18, item_price, ccc3(73, 38, 4))
  lbl_get:setPosition(CCPoint(btn_get0:getContentSize().width / 2, btn_get0:getContentSize().height / 2))
  btn_get0:addChild(lbl_get)
  local btn_get = SpineMenuItem:create(json.ui.button, btn_get0)
  btn_get:setPosition(CCPoint(336, 115))
  if status.limits == 0 then
    setShader(btn_get, SHADER_GRAY, true)
    btn_get:setEnabled(false)
  end
  local btn_get_menu = CCMenu:createWithItem(btn_get)
  btn_get_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_get_menu)
  btn_get:registerScriptTapHandler(function()
    audio.play(audio.button)
    local waitnet = addWaitNet()
    waitnet.setTimeout(60)
    local iap = require("common.iap")
    iap.pay(cfg.payId, function(l_1_0)
      delWaitNet()
      local tmp_bag = {items = {}, equips = {}}
      if l_1_0 then
        tbl2string(l_1_0)
        for ii = 1, #rewards do
          if rewards[ii].type == 1 then
            local tbl_p = tmp_bag.items
            tbl_p[#tbl_p + 1] = {id = rewards[ii].id, num = rewards[ii].num}
          else
            if rewards[ii].type == 2 then
              local tbl_p = tmp_bag.equips
              tbl_p[#tbl_p + 1] = {id = rewards[ii].id, num = rewards[ii].num}
            end
          end
        end
        bagdata.addRewards(tmp_bag)
        bagdata.items.add({id = ITEM_ID_VIP_EXP, num = cfg.vipExp})
        local rewardsKit = require("ui.reward")
        CCDirector:sharedDirector():getRunningScene():addChild(rewardsKit.showReward(tmp_bag), 100000)
        status.limits = status.limits - 1
        if status.limits == 0 then
          setShader(btn_get, SHADER_GRAY, true)
          btn_get:setEnabled(false)
        end
      end
      end)
   end)
  return layer
end

return ui

