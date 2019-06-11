-- Command line was: E:\github\dhgametool\scripts\ui\activitylimit\level.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfglimitgift = require("config.limitgift")
local cfgstore = require("config.store")
local player = require("data.player")
local bagdata = require("data.bag")
local activitylimitData = require("data.activitylimit")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local IDS = activitylimitData.IDS
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  img.unload(img.packedOthers.ui_limit_level)
  img.unload(img.packedOthers.ui_limit_level_cn)
  if i18n.getCurrentLanguage() == kLanguageChinese or i18n.getCurrentLanguage() == kLanguageChineseTW then
    img.load(img.packedOthers.ui_limit_level_cn)
  else
    img.load(img.packedOthers.ui_limit_level)
  end
  local bg = CCSprite:create()
  bg:setContentSize(CCSizeMake(576, 436))
  bg:setScale(view.minScale)
  bg:setAnchorPoint(CCPoint(0, 0))
  bg:setPosition(scalep(363, 9))
  layer:addChild(bg)
  local board_w = bg:getContentSize().width
  local board_h = bg:getContentSize().height
  local board = img.createUISprite(img.ui.limit_level_gift)
  board:setAnchorPoint(CCPoint(0.5, 1))
  board:setPosition(board_w / 2, board_h + 23)
  bg:addChild(board)
  local posOffset = 10
  json.load(json.ui.clock)
  local clockIcon = DHSkeletonAnimation:createWithKey(json.ui.clock)
  clockIcon:scheduleUpdateLua()
  clockIcon:playAnimation("animation", -1)
  clockIcon:setPosition(326 + posOffset, 380)
  board:addChild(clockIcon, 100)
  local showTimeLab = lbl.createFont2(18, "", ccc3(165, 253, 71))
  showTimeLab:setPosition(344 + posOffset, 380)
  showTimeLab:setColor(ccc3(165, 253, 71))
  showTimeLab:setAnchorPoint(0, 0.5)
  board:addChild(showTimeLab)
  local lable = nil
  if i18n.getCurrentLanguage() == kLanguageChinese then
    lable = img.createUISprite("limit_level_label_cn.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      lable = img.createUISprite("limit_level_label_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageRussian then
        lable = img.createUISprite("limit_level_label_ru.png")
      else
        if i18n.getCurrentLanguage() == kLanguageJapanese then
          lable = img.createUISprite("limit_level_label_jp.png")
        else
          if i18n.getCurrentLanguage() == kLanguageKorean then
            lable = img.createUISprite("limit_level_label_kr.png")
          else
            if i18n.getCurrentLanguage() == kLanguageSpanish then
              lable = img.createUISprite("limit_level_label_sp.png")
            else
              if i18n.getCurrentLanguage() == kLanguagePortuguese then
                lable = img.createUISprite("limit_level_label_pt.png")
              else
                lable = img.createUISprite("limit_level_label.png")
              end
            end
          end
        end
      end
    end
  end
  lable:setPosition(CCPoint(371 + posOffset, 330))
  board:addChild(lable)
  local rewards, storeID, ids = nil, nil, nil
  if l_1_0 == cfglimitgift[IDS.LEVEL_3_15.ID].parameter then
    rewards = cfglimitgift[IDS.LEVEL_3_15.ID].rewards
    storeID = cfglimitgift[IDS.LEVEL_3_15.ID].storeId
    ids = IDS.LEVEL_3_15.ID
  end
  local cfg = cfgstore[storeID]
  local vipLab = lbl.createFont1(16, string.format("+%d VIP EXP", cfg.vipExp), ccc3(255, 243, 163))
  vipLab:setPosition(371 + posOffset, 285)
  board:addChild(vipLab, 100)
  local item_status = activitylimitData.getStatusById(ids)
  local limitNumLab = string.format(i18n.global.limitact_limit.string .. item_status.limits)
  local limitLbl = lbl.createFont1(16, limitNumLab, ccc3(255, 246, 223))
  limitLbl:setPosition(370 + posOffset, 155)
  board:addChild(limitLbl)
  local onUpdate = function()
    cd = math.max(0, item_status.cd + activitylimitData.pull_time - os.time())
    if cd > 0 then
      local timeLab = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
      showTimeLab:setString(timeLab)
    else
      layer:removeFromParentAndCleanup(true)
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  local createSpineItem = function(l_2_0)
    local tmp_item = nil
    if l_2_0.type == 1 then
      local tmp_item0 = img.createItem(l_2_0.id, l_2_0.num)
      tmp_item = SpineMenuItem:create(json.ui.button, tmp_item0)
    elseif l_2_0.type == 2 then
      local tmp_item0 = img.createEquip(l_2_0.id, l_2_0.num)
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
  local pos_y = 240
  local offset_x = 372 + posOffset
  local step_x = 82
  if #rewards == 2 then
    offset_x = 406 + posOffset
  end
  for ii = 1, #rewards do
    local tmp_item = createSpineItem(rewards[ii])
    tmp_item:setScale(0.9)
    tmp_item:setPosition(CCPoint(offset_x + (ii - 2) * step_x, pos_y - 12))
    local tmp_item_menu = CCMenu:createWithItem(tmp_item)
    tmp_item_menu:setPosition(CCPoint(0, 0))
    board:addChild(tmp_item_menu)
  end
  local btn_get0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_get0:setPreferredSize(CCSizeMake(140, 52))
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
  local lbl_get = lbl.createFontTTF(18, item_price, ccc3(115, 59, 5))
  lbl_get:setPosition(CCPoint(70, 26))
  btn_get0:addChild(lbl_get)
  local btn_get = SpineMenuItem:create(json.ui.button, btn_get0)
  btn_get:setPosition(CCPoint(371 + posOffset, 110))
  if item_status.status == 1 then
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
        bagdata.items.add({id = ITEM_ID_VIP_EXP, num = cfg.vipExp})
        bagdata.addRewards(tmp_bag)
        local rewardsKit = require("ui.reward")
        CCDirector:sharedDirector():getRunningScene():addChild(rewardsKit.showReward(tmp_bag), 100000)
        item_status.limits = item_status.limits - 1
        upvalue_2048 = string.format(i18n.global.limitact_limit.string .. item_status.limits)
        limitLbl:setString(limitNumLab)
        if item_status.limits == 0 then
          item_status.status = 1
          setShader(btn_get, SHADER_GRAY, true)
          btn_get:setEnabled(false)
        end
      end
      end)
   end)
  return layer
end

return ui

