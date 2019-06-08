-- Command line was: E:\github\dhgametool\scripts\ui\activity\midautumnlogin.lua 

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
  img.load(img.packedOthers.ui_activity_mid_autumn_login)
  local topBg = img.createUISprite(img.ui.activity_mid_autumn_login_board)
  topBg:setAnchorPoint(CCPoint(0.5, 1))
  topBg:setPosition(CCPoint(board_w / 2, board_h - 8))
  board:addChild(topBg)
  local banner = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    banner = img.createUISprite("activity_mid_autumn_login_board_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      banner = img.createUISprite("activity_mid_autumn_login_board_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        banner = img.createUISprite("activity_mid_autumn_login_board_jp.png")
      else
        if i18n.getCurrentLanguage() == kLanguageRussian then
          banner = img.createUISprite("activity_mid_autumn_login_board_ru.png")
        else
          if i18n.getCurrentLanguage() == kLanguageChinese then
            banner = img.createUISprite("activity_mid_autumn_login_board_cn.png")
          else
            if i18n.getCurrentLanguage() == kLanguagePortuguese then
              banner = img.createUISprite("activity_mid_autumn_login_board_pt.png")
            else
              banner = img.createUISprite("activity_mid_autumn_login_board_us.png")
            end
          end
        end
      end
    end
  end
  banner:setAnchorPoint(CCPoint(1, 1))
  banner:setPosition(CCPoint(512, 165))
  topBg:addChild(banner)
  local lbl_cd_des = lbl.createFont2(14, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(1, 0.5))
  lbl_cd_des:setPosition(CCPoint(418, 28))
  topBg:addChild(lbl_cd_des)
  local lbl_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(1, 0.5))
  lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMinX() - 6, 28))
  topBg:addChild(lbl_cd)
  local createItem = function(l_1_0, l_1_1)
    local itemBg = img.createUI9Sprite(img.ui.bottom_border_2)
    itemBg:setPreferredSize(CCSizeMake(540, 84))
    local item_w = itemBg:getContentSize().width
    local item_h = itemBg:getContentSize().height
    local desString = string.format(i18n.global.mid_autumn_login_title.string, l_1_0.instruct)
    local des = lbl.createMixFont1(16, desString, ccc3(93, 45, 18))
    des:setAnchorPoint(CCPoint(0, 0.5))
    des:setPosition(CCPoint(18, 55))
    itemBg:addChild(des)
    local pgb_bg = img.createUI9Sprite(img.ui.playerInfo_process_bar_bg)
    pgb_bg:setPreferredSize(CCSizeMake(203, 20))
    pgb_bg:setPosition(CCPoint(120, 26))
    itemBg:addChild(pgb_bg)
    local pgb_fg = img.createUISprite(img.ui.activity_pgb_casino)
    local pgb = createProgressBar(pgb_fg)
    pgb:setPosition(CCPoint(pgb_bg:getContentSize().width / 2, pgb_bg:getContentSize().height / 2))
    pgb_bg:addChild(pgb)
    local numerator = activityData.getStatusById(l_1_0.id).limits
    local finish = false
    if l_1_0.instruct <= numerator then
      numerator = l_1_0.instruct
      finish = true
    end
    local lbl_pgb = lbl.createFont2(14, numerator .. "/" .. l_1_0.instruct)
    lbl_pgb:setAnchorPoint(CCPoint(0.5, 0))
    lbl_pgb:setPosition(CCPoint(pgb_bg:getContentSize().width / 2, pgb_bg:getContentSize().height / 2))
    pgb_bg:addChild(lbl_pgb)
    pgb:setPercentage(numerator * 100 / l_1_0.instruct)
    local count = 0
    for ii =  l_1_0.rewards, 1, -1 do
      count = count + 1
      local reward = l_1_0.rewards[ii]
      do
        local rewardNode = nil
        if reward.type == 1 then
          rewardNode = CCMenuItemSprite:create((img.createItem(reward.id, reward.num)), nil)
        elseif reward.type == 2 then
          rewardNode = CCMenuItemSprite:create((img.createEquip(reward.id, reward.num)), nil)
        end
        rewardNode:setScale(0.7)
        rewardNode:setAnchorPoint(CCPoint(1, 0.5))
        rewardNode:setPosition(CCPoint(520 - (count - 1) * 72, item_h / 2))
        rewardNode:registerScriptTapHandler(function()
          audio.play(audio.button)
          local tmp_tip = nil
          if reward.type == 1 then
            tmp_tip = tipsitem.createForShow({id = reward.id})
            layer:addChild(tmp_tip, 100)
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
        mask:setVisible(finish)
        rewardNode:addChild(mask, 100)
        local okImage = img.createUISprite(img.ui.activity_mid_autumn_login_sel)
        okImage:setPosition(rewardNode:getContentSize().width / 2, rewardNode:getContentSize().height / 2)
        okImage:setVisible(finish)
        rewardNode:addChild(okImage)
        itemBg:addChild(rewardNodeMenu)
      end
    end
    itemBg.height = item_h
    return itemBg
   end
  local lineScroll = require("ui.lineScroll")
  local scroll_params = {width = 540, height = 244}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(16, 2))
  board:addChild(scroll)
  layer.scroll = scroll
  local activityItems = {}
  for i = activityData.IDS.MID_AUTUMN_LOGIN_1.ID, activityData.IDS.MID_AUTUMN_LOGIN_3.ID do
    activityItems[ activityItems + 1] = clone(cfgactivity[i])
    activityItems[ activityItems].id = i
  end
  local showList = function(l_2_0)
    for ii = 1,  l_2_0 do
      local tmp_item = createItem(l_2_0[ii], ii)
      tmp_item.obj = l_2_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = scroll_params.width / 2
      scroll.addItem(tmp_item)
    end
    scroll.setOffsetBegin()
   end
  tbl2string(activityItems)
  showList(activityItems)
  local last_update = os.time() - 1
  local onUpdate = function(l_3_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    local status = activityData.getStatusById(activityData.IDS.MID_AUTUMN_LOGIN_1.ID)
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

