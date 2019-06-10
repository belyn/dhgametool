-- Command line was: E:\github\dhgametool\scripts\ui\activity\midautumngift.lua 

local ui = {}
local view = require("common.view")
local img = require("res.img")
local i18n = require("res.i18n")
local audio = require("res.audio")
local json = require("res.json")
local lbl = require("res.lbl")
local cfgstore = require("config.store")
local cfgactivity = require("config.activity")
local activityData = require("data.activity")
local shop = require("data.shop")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local net = require("net.netClient")
local player = require("data.player")
ui.create = function()
  local layer = CCLayer:create()
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(570, 438))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(352, 57))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_mid_autumn_gift)
  local topBg = img.createUISprite(img.ui.activity_mid_autumn_gift_board)
  topBg:setAnchorPoint(CCPoint(0.5, 1))
  topBg:setPosition(CCPoint(board_w / 2, board_h - 8))
  board:addChild(topBg)
  local banner = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    banner = img.createUISprite("activity_mid_autumn_gift_board_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      banner = img.createUISprite("activity_mid_autumn_gift_board_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        banner = img.createUISprite("activity_mid_autumn_gift_board_jp.png")
      else
        if i18n.getCurrentLanguage() == kLanguageRussian then
          banner = img.createUISprite("activity_mid_autumn_gift_board_ru.png")
        else
          if i18n.getCurrentLanguage() == kLanguageChinese then
            banner = img.createUISprite("activity_mid_autumn_gift_board_cn.png")
          else
            if i18n.getCurrentLanguage() == kLanguagePortuguese then
              banner = img.createUISprite("activity_mid_autumn_gift_board_pt.png")
            else
              banner = img.createUISprite("activity_mid_autumn_gift_board_us.png")
            end
          end
        end
      end
    end
  end
  banner:setAnchorPoint(CCPoint(1, 1))
  banner:setPosition(CCPoint(560, 210))
  topBg:addChild(banner)
  local lbl_cd_des = lbl.createFont2(14, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(1, 0.5))
  lbl_cd_des:setPosition(CCPoint(426, 28))
  topBg:addChild(lbl_cd_des)
  local lbl_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(1, 0.5))
  lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMinX() - 6, 28))
  topBg:addChild(lbl_cd)
  local bottomBg = img.createUI9Sprite(img.ui.bottom_border_2)
  bottomBg:setAnchorPoint(CCPoint(0.5, 0))
  bottomBg:setPreferredSize(CCSizeMake(536, 192))
  bottomBg:setPosition(CCPoint(board_w / 2, 10))
  board:addChild(bottomBg)
  local des = lbl.createMix({text = i18n.global.mid_autumn_gift_des.string, size = 16, color = ccc3(113, 63, 22), width = 492, font = 1})
  des:setPosition(bottomBg:getPreferredSize().width / 2, 152)
  bottomBg:addChild(des)
  local flag = img.createUISprite(img.ui.activity_mid_autumn_gift_flag)
  flag:setPosition(CCPoint(bottomBg:getPreferredSize().width / 2 + 20, 69))
  bottomBg:addChild(flag)
  local rewardContainer = CCSprite:create()
  rewardContainer:setContentSize(CCSizeMake(64, 63))
  rewardContainer:setPosition(CCPoint(bottomBg:getPreferredSize().width / 2, 69))
  bottomBg:addChild(rewardContainer)
  local rewards = cfgactivity[activityData.IDS.MID_AUTUMN_GIFT.ID].rewards
  local reward = rewards[1]
  local rewardNode = nil
  if reward.type == 1 then
    rewardNode = CCMenuItemSprite:create((img.createItem(reward.id, reward.num)), nil)
  elseif reward.type == 2 then
    rewardNode = CCMenuItemSprite:create((img.createEquip(reward.id, reward.num)), nil)
  end
  rewardNode:setPosition(CCPoint(32, 32))
  rewardNode:registerScriptTapHandler(function()
    audio.play(audio.button)
    local tmp_tip = nil
    if reward.type == 1 then
      tmp_tip = tipsitem.createForShow({id = reward.id})
      layer:getParent():getParent():getParent():addChild(tmp_tip, 10000)
    else
      if reward.type == 2 then
        tmp_tip = tipsequip.createById(reward.id)
        layer:addChild(tmp_tip, 100)
      end
    end
   end)
  local rewardNodeMenu = CCMenu:createWithItem(rewardNode)
  rewardNodeMenu:setPosition(CCPoint(0, 0))
  local mask = img.createUISprite(img.ui.hook_btn_mask)
  mask:setPosition(CCPoint(rewardNode:getContentSize().width / 2, rewardNode:getContentSize().height / 2))
  mask:setVisible(false)
  rewardNode:addChild(mask, 100)
  local okImage = img.createUISprite(img.ui.activity_mid_autumn_gift_sel)
  okImage:setPosition(rewardNode:getContentSize().width / 2, rewardNode:getContentSize().height / 2)
  okImage:setVisible(false)
  rewardNode:addChild(okImage)
  rewardContainer:addChild(rewardNodeMenu)
  local nParams = {sid = player.sid, id = activityData.IDS.MID_AUTUMN_GIFT.ID}
  tbl2string(nParams)
  addWaitNet()
  net:fetch_activity(nParams, function(l_2_0)
    delWaitNet()
    tbl2string(l_2_0)
    if l_2_0 and l_2_0.status and l_2_0.status ~= 0 then
      showToast(i18n.global.error_server_status_wrong.string .. tostring(l_2_0.status))
    end
    if l_2_0.act and l_2_0.act.limits and l_2_0.act.limits >= 6999 then
      okImage:setVisible(true)
      mask:setVisible(true)
    else
      okImage:setVisible(false)
      mask:setVisible(false)
    end
   end)
  local last_update = os.time() - 1
  local onUpdate = function(l_3_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    local status = activityData.getStatusById(activityData.IDS.MID_AUTUMN_GIFT.ID)
    local remain_cd = status.cd - (os.time() - activityData.pull_time)
    if remain_cd >= 0 then
      local time_str = time2string(remain_cd)
      lbl_cd:setString(time_str)
    else
       -- Warning: missing end command somewhere! Added here
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui

