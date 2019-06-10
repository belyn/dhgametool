-- Command line was: E:\github\dhgametool\scripts\ui\activity\fridayhappy.lua 

local ui = {}
local view = require("common.view")
local img = require("res.img")
local i18n = require("res.i18n")
local audio = require("res.audio")
local lbl = require("res.lbl")
local cfgactivity = require("config.activity")
local activityData = require("data.activity")
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
  img.load(img.packedOthers.ui_activity_friday_happy)
  local topBg = img.createUISprite(img.ui.activity_friday_happy_banner)
  topBg:setAnchorPoint(CCPoint(0.5, 1))
  topBg:setPosition(CCPoint(board_w / 2, board_h - 8))
  board:addChild(topBg)
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
  local banner = img.createUISprite(string.format("activity_friday_happy_title_%s.png", suffix))
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(347, 165))
  topBg:addChild(banner)
  local cdDes = lbl.createFont2(14, i18n.global.activity_to_end.string)
  cdDes:setAnchorPoint(CCPoint(1, 0.5))
  cdDes:setPosition(CCPoint(390, 28))
  topBg:addChild(cdDes)
  local cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  cd:setAnchorPoint(CCPoint(1, 0.5))
  cd:setPosition(CCPoint(cdDes:boundingBox():getMinX() - 6, 28))
  topBg:addChild(cd)
  local createItem = function(l_1_0)
    local itemBg = img.createUI9Sprite(img.ui.bottom_border_2)
    itemBg:setPreferredSize(CCSizeMake(540, 84))
    local item_w = itemBg:getContentSize().width
    local item_h = itemBg:getContentSize().height
    local desString = string.format(i18n.global.spesummon_gain.string .. " %d " .. i18n.global.arena_main_score.string, l_1_0.instruct)
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
    for ii = #l_1_0.rewards, 1, -1 do
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
            layer:getParent():getParent():addChild(tmp_tip, 100)
          else
            if reward.type == 2 then
              tmp_tip = tipsequip.createById(reward.id)
              layer:getParent():getParent():addChild(tmp_tip, 100)
            end
          end
            end)
        local rewardNodeMenu = CCMenu:createWithItem(rewardNode)
        rewardNodeMenu:setPosition(CCPoint(0, 0))
        local mask = img.createUISprite(img.ui.hook_btn_mask)
        mask:setPosition(CCPoint(rewardNode:getContentSize().width / 2, rewardNode:getContentSize().height / 2))
        mask:setVisible(finish)
        rewardNode:addChild(mask, 100)
        local okImage = img.createUISprite(img.ui.activity_friday_happy_sel)
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
  scroll:setPosition(CCPoint(15, 2))
  board:addChild(scroll)
  layer.scroll = scroll
  local activityItems = {}
  for i = activityData.IDS.FRIDAY_HAPPY_1.ID, activityData.IDS.FRIDAY_HAPPY_6.ID do
    activityItems[#activityItems + 1] = clone(cfgactivity[i])
    activityItems[#activityItems].id = i
  end
  local showList = function(l_2_0)
    if not scroll or tolua.isnull(scroll) then
      return 
    end
    scroll.content_layer:removeAllChildrenWithCleanup(true)
    for ii = 1, #l_2_0 do
      local item = createItem(l_2_0[ii])
      item.obj = l_2_0[ii]
      item.ax = 0.5
      item.px = scroll_params.width / 2
      scroll.addItem(item)
    end
    scroll.setOffsetBegin()
   end
  showList(activityItems)
  local last_update = os.time() - 1
  local onUpdate = function(l_3_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    local status = activityData.getStatusById(activityData.IDS.FRIDAY_HAPPY_1.ID)
    local remain_cd = status.cd - (os.time() - activityData.pull_time)
    if remain_cd >= 0 then
      local time_str = time2string(remain_cd)
      cd:setString(time_str)
    else
       -- Warning: missing end command somewhere! Added here
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  layer:registerScriptHandler(function(l_4_0)
    if l_4_0 == "enter" then
      do return end
    end
    if l_4_0 == "exit" then
      do return end
    end
    if l_4_0 == "cleanup" then
      img.unload(img.packedOthers.ui_activity_friday_happy)
    end
   end)
  require("ui.activity.ban").addBan(layer, scroll)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui

