-- Command line was: E:\github\dhgametool\scripts\ui\firstpay\main.lua 

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
local bagdata = require("data.bag")
local activityData = require("data.activity")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local IDS = activityData.IDS
ui.create = function()
  local layer = CCLayer:create()
  local status = activityData.getStatusById(IDS.FIRST_PAY.ID)
  if not status then
    return 
  end
  img.unload(img.packedOthers.ui_firstpay)
  img.unload(img.packedOthers.ui_firstpay_cn)
  if i18n.getCurrentLanguage() == kLanguageChinese or i18n.getCurrentLanguage() == kLanguageChineseTW then
    img.load(img.packedOthers.ui_firstpay_cn)
  else
    img.load(img.packedOthers.ui_firstpay)
  end
  local bg = CCSprite:create()
  bg:setContentSize(CCSizeMake(576, 436))
  bg:setScale(view.minScale)
  bg:setAnchorPoint(CCPoint(0, 0))
  bg:setPosition(scalep(363, 9))
  layer:addChild(bg)
  local board_w = bg:getContentSize().width
  local board_h = bg:getContentSize().height
  local board = img.createUISprite(img.ui.firstpay_board)
  board:setAnchorPoint(CCPoint(0.5, 1))
  board:setPosition(board_w / 2, board_h + 23)
  bg:addChild(board)
  local posOffset = 10
  local lable_des, lable = nil, nil
  if i18n.getCurrentLanguage() == kLanguageChinese then
    lable = img.createUISprite("limit_first_label_cn.png")
    lable_des = img.createUISprite("limit_first_label_des_cn.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      lable = img.createUISprite("limit_first_label_tw.png")
      lable_des = img.createUISprite("limit_first_label_des_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageRussian then
        lable = img.createUISprite("limit_first_label_ru.png")
        lable_des = img.createUISprite("limit_first_label_des_ru.png")
      else
        if i18n.getCurrentLanguage() == kLanguageJapanese then
          lable = img.createUISprite("limit_first_label_jp.png")
          lable_des = img.createUISprite("limit_first_label_des_jp.png")
        else
          if i18n.getCurrentLanguage() == kLanguageKorean then
            lable = img.createUISprite("limit_first_label_kr.png")
            lable_des = img.createUISprite("limit_first_label_des_kr.png")
          else
            if i18n.getCurrentLanguage() == kLanguagePortuguese then
              lable = img.createUISprite("limit_first_label_kp.png")
              lable_des = img.createUISprite("limit_first_label_des_kp.png")
            else
              if i18n.getCurrentLanguage() == kLanguageSpanish then
                lable = img.createUISprite("limit_first_label_ks.png")
                lable_des = img.createUISprite("limit_first_label_des_ks.png")
              else
                if i18n.getCurrentLanguage() == kLanguageTurkish then
                  lable = img.createUISprite("limit_first_label_tr.png")
                  lable_des = img.createUISprite("limit_first_label_des_tr.png")
                else
                  lable = img.createUISprite("limit_first_label.png")
                  lable_des = img.createUISprite("limit_first_label_des.png")
                end
              end
            end
          end
        end
      end
    end
  end
  lable:setPosition(CCPoint(371 + posOffset, 315))
  board:addChild(lable)
  lable_des:setPosition(CCPoint(371 + posOffset, 370))
  board:addChild(lable_des)
  local rewards = cfgactivity[IDS.FIRST_PAY.ID].rewards
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
        layer:getParent():getParent():getParent():addChild(tmp_tip, 1000)
      else
        if itemObj.type == 2 then
          tmp_tip = tipsequip.createById(itemObj.id)
          layer:getParent():getParent():getParent():addChild(tmp_tip, 1000)
        end
      end
      tmp_tip.setClickBlankHandler(function()
        tmp_tip:removeFromParentAndCleanup(true)
         end)
      end)
    return tmp_item
   end
  local pos_y = 218
  local offset_x = 336 + posOffset
  local step_x = 72
  local first_item = createSpineItem(rewards[1])
  first_item:setPosition(CCPoint(253 + posOffset, pos_y))
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
  local btn_get0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_get0:setPreferredSize(CCSizeMake(140, 52))
  local lbl_get = lbl.createFontTTF(18, i18n.global.chip_btn_buy.string, ccc3(73, 38, 4))
  lbl_get:setPosition(CCPoint(70, 26))
  btn_get0:addChild(lbl_get)
  local btn_get = SpineMenuItem:create(json.ui.button, btn_get0)
  btn_get:setPosition(CCPoint(371 + posOffset, 115))
  local btn_get_menu = CCMenu:createWithItem(btn_get)
  btn_get_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_get_menu)
  btn_get:registerScriptTapHandler(function()
    audio.play(audio.button)
    local gemShop = require("ui.shop.main")
    layer:getParent():getParent():getParent():addChild(gemShop.create(), 1001)
   end)
  local btn_claim0 = img.createLogin9Sprite(img.login.button_9_small_green)
  btn_claim0:setPreferredSize(CCSizeMake(140, 52))
  local lbl_claim = lbl.createFont1(18, i18n.global.mail_btn_get.string, ccc3(29, 103, 0))
  lbl_claim:setPosition(CCPoint(70, 26))
  btn_claim0:addChild(lbl_claim)
  local btn_claim = SpineMenuItem:create(json.ui.button, btn_claim0)
  btn_claim:setPosition(CCPoint(371 + posOffset, 115))
  if status.status == 2 then
    setShader(btn_claim, SHADER_GRAY, true)
    btn_claim:setEnabled(false)
  end
  local btn_claim_menu = CCMenu:createWithItem(btn_claim)
  btn_claim_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_claim_menu)
  btn_claim:registerScriptTapHandler(function()
    audio.play(audio.button)
    local params = {sid = player.sid}
    addWaitNet()
    netClient:fpay(params, function(l_1_0)
      delWaitNet()
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      status.status = 2
      local tmp_bag = {items = {}, equips = {}}
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
      local rewardsKit = require("ui.reward")
      CCDirector:sharedDirector():getRunningScene():addChild(rewardsKit.showReward(tmp_bag), 100000)
      setShader(btn_claim, SHADER_GRAY, true)
      btn_claim:setEnabled(false)
      end)
   end)
  local checkStatus = function()
    if status.status == 0 then
      btn_get:setVisible(true)
      btn_claim:setVisible(false)
    else
      if status.status == 1 then
        btn_get:setVisible(false)
        btn_claim:setVisible(true)
      else
        btn_get:setVisible(false)
        btn_claim:setVisible(true)
      end
    end
   end
  checkStatus()
  local onUpdate = function(l_5_0)
    checkStatus()
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  return layer
end

return ui

