-- Command line was: E:\github\dhgametool\scripts\ui\activity\nationaldaylogin.lua 

local ui = {}
local view = require("common.view")
local img = require("res.img")
local i18n = require("res.i18n")
local audio = require("res.audio")
local json = require("res.json")
local lbl = require("res.lbl")
local activityData = require("data.activity")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local bagdata = require("data.bag")
local player = require("data.player")
local net = require("net.netClient")
local activityLogin = require("config.activitylogin")
ui.create = function()
  local activityId = 1625
  local rewardNodes = {}
  local progressLabel = nil
  local rewardsBg = {}
  local data = activityData.getStatusById(activityId)
  img.load(img.packedOthers.spine_ui_guoqing_qiandao)
  img.load(img.packedOthers.ui_activity_national_day_login)
  local layer = CCLayer:create()
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(570, 438))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(352, 57))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local topBg = img.createUISprite(img.ui.activity_national_day_login_top)
  topBg:setAnchorPoint(CCPoint(0.5, 1))
  topBg:setPosition(CCPoint(board_w / 2, board_h - 8))
  board:addChild(topBg)
  local banner = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    banner = img.createUISprite("activity_national_day_login_board_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      banner = img.createUISprite("activity_national_day_login_board_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        banner = img.createUISprite("activity_national_day_login_board_jp.png")
      else
        if i18n.getCurrentLanguage() == kLanguageRussian then
          banner = img.createUISprite("activity_national_day_login_board_ru.png")
        else
          if i18n.getCurrentLanguage() == kLanguageChinese then
            banner = img.createUISprite("activity_national_day_login_board_cn.png")
          else
            if i18n.getCurrentLanguage() == kLanguagePortuguese then
              banner = img.createUISprite("activity_national_day_login_board_pt.png")
            else
              banner = img.createUISprite("activity_national_day_login_board_us.png")
            end
          end
        end
      end
    end
  end
  banner:setAnchorPoint(CCPoint(1, 1))
  banner:setPosition(CCPoint(425, 139))
  topBg:addChild(banner)
  local createItem = function(l_1_0, l_1_1)
    local itemBg = img.createUI9Sprite(img.ui.bottom_border_2)
    itemBg:setPreferredSize(CCSizeMake(236, 166))
    itemBg:setAnchorPoint(CCPoint(0, 0.5))
    itemBg:setPosition((l_1_1 - 1) * 242, itemBg:getContentSize().height / 2)
    local item_w = itemBg:getContentSize().width
    local item_h = itemBg:getContentSize().height
    if data.next < l_1_1 and l_1_1 <= data.limits then
      local bg = img.createUI9Sprite(img.ui.activity_national_day_login_bg)
      bg:setPreferredSize(CCSizeMake(item_w, item_h))
      bg:setPosition(item_w / 2, item_h / 2)
      itemBg:addChild(bg)
      local animation = json.create(json.ui.guoqing_qiandao2)
      animation:setAnchorPoint(0.5, 0.5)
      animation:setPosition(item_w / 2, item_h / 2)
      animation:playAnimation("animation", -1)
      bg:addChild(animation)
      local animation2 = json.create(json.ui.guoqing_qiandao1)
      animation2:setAnchorPoint(0.5, 0.5)
      animation2:setPosition(item_w / 2, item_h / 2)
      animation2:playAnimation("animation", -1)
      bg:addChild(animation2)
      rewardsBg[l_1_1] = bg
    end
    local desString = string.format(i18n.global.national_day_login_day.string, l_1_1)
    local des = lbl.createFont1(16, desString, ccc3(93, 45, 18))
    des:setAnchorPoint(CCPoint(0.5, 0.5))
    des:setPosition(CCPoint(item_w / 2, 126))
    itemBg:addChild(des)
    local line1 = img.createUI9Sprite(img.ui.gemstore_fgline)
    line1:setPreferredSize(CCSize(198, 2))
    line1:setPosition(CCPoint(item_w / 2, 102))
    itemBg:addChild(line1)
    local startPosition = (#l_1_0.rewards * 60 + (#l_1_0.rewards - 1) * 6) / 2
    do
      for ii = 1, #l_1_0.rewards do
        local reward = l_1_0.rewards[ii]
        local rewardNode = nil
        if reward.type == 1 then
          rewardNode = CCMenuItemSprite:create((img.createItem(reward.id, reward.num)), nil)
        elseif reward.type == 2 then
          rewardNode = CCMenuItemSprite:create((img.createEquip(reward.id, reward.num)), nil)
        end
        rewardNode:setScale(0.7)
        rewardNode:setAnchorPoint(CCPoint(0, 0.5))
        rewardNode:setPosition(CCPoint(item_w / 2 - startPosition + (ii - 1) * 66, 55))
        rewardNode:registerScriptTapHandler(function()
            end)
        rewardNode:setEnabled(false)
        rewardNode.showTips = function()
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
            end
        local rewardNodeMenu = CCMenu:createWithItem(rewardNode)
        rewardNodeMenu:setPosition(CCPoint(0, 0))
        rewardNode.checkIn = function(l_3_0)
          local mask = img.createUISprite(img.ui.hook_btn_mask)
          mask:setPosition(CCPoint(l_3_0:getContentSize().width / 2, l_3_0:getContentSize().height / 2))
          l_3_0:addChild(mask, 100)
          local okImage = img.createUISprite(img.ui.activity_national_day_login_sel)
          okImage:setPosition(l_3_0:getContentSize().width / 2, l_3_0:getContentSize().height / 2)
          l_3_0:addChild(okImage)
            end
        if l_1_1 <= data.next then
          rewardNode:checkIn()
        end
        if not rewardNodes[l_1_1] then
          rewardNodes[l_1_1] = {}
        end
        rewardNodes[l_1_1][ii] = rewardNode
        itemBg:addChild(rewardNodeMenu)
      end
    end
    return itemBg
   end
  local SCROLL_CONTAINER_SIZE = 242 * #activityLogin
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionHorizontal)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(12, 88)
  scroll:setViewSize(CCSize(548, 166))
  scroll:setContentSize(CCSize(SCROLL_CONTAINER_SIZE, 166))
  scroll:setContentOffset(CCPoint(not math.max(0, data.limits * 242 - 548), 0))
  board:addChild(scroll)
  local scrollNode = CCSprite:create()
  scrollNode:setPosition(scroll:getPosition())
  scrollNode:setContentSize(CCSize(548, 166))
  scrollNode:setAnchorPoint(ccp(0, 0))
  board:addChild(scrollNode)
  local showList = function()
    for ii = 1, #activityLogin do
      local item = createItem(activityLogin[ii], ii)
      scroll:getContainer():addChild(item)
    end
   end
  showList()
  local bottomBg = img.createLogin9Sprite(img.login.toast_bg)
  bottomBg:setPreferredSize(CCSize(550, 75))
  bottomBg:setAnchorPoint(CCPoint(0.5, 0))
  bottomBg:setPosition(board_w / 2, 10)
  board:addChild(bottomBg, 10)
  progressLabel = lbl.createFont1(16, data.next .. "/" .. 14, ccc3(204, 244, 42))
  progressLabel:setAnchorPoint(1, 0.5)
  progressLabel:setPosition(388, bottomBg:getContentSize().height / 2)
  bottomBg:addChild(progressLabel, 10)
  local progressDes = lbl.createMixFont1(14, i18n.global.month_login_checkinnum.string, ccc3(255, 246, 223))
  progressDes:setAnchorPoint(1, 0.5)
  progressDes:setPosition(progressLabel:boundingBox():getMinX() - 10, bottomBg:getContentSize().height / 2)
  bottomBg:addChild(progressDes, 10)
  local checkInSprite = img.createLogin9Sprite(img.login.button_9_small_green)
  checkInSprite:setPreferredSize(CCSize(140, 50))
  local checkInLabel = lbl.createFont1(12, i18n.global.month_login_checkin.string, ccc3(29, 103, 0))
  checkInLabel:setPosition(CCPoint(checkInSprite:getContentSize().width / 2, checkInSprite:getContentSize().height / 2))
  checkInSprite:addChild(checkInLabel)
  local checkInBtn = SpineMenuItem:create(json.ui.button, checkInSprite)
  checkInBtn:setAnchorPoint(CCPoint(0, 0.5))
  checkInBtn:setPosition(405, bottomBg:getContentSize().height / 2)
  checkInBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if data.limits <= data.next or data.next >= 14 then
      return 
    end
    local param = {}
    param.sid = player.sid
    param.id = activityId
    addWaitNet()
    net:activity_sign(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      bagdata.addRewards(l_1_0.reward)
      layer:getParent():getParent():addChild(require("ui.tips.reward").create(l_1_0.reward), 1000)
      for j = 1, #rewardNodes[data.next + 1] do
        rewardNodes[data.next + 1][j]:checkIn()
      end
      rewardsBg[data.next + 1]:removeFromParentAndCleanup(true)
      rewardsBg[data.next + 1] = nil
      data.next = data.next + 1
      progressLabel:setString(data.next .. "/" .. 14)
      if data.limits <= data.next or data.next >= 14 then
        checkInBtn:setEnabled(false)
        setShader(checkInBtn, SHADER_GRAY, true)
      end
      end)
   end)
  local checkInMenu = CCMenu:createWithItem(checkInBtn)
  checkInMenu:setPosition(0, 0)
  bottomBg:addChild(checkInMenu, 10)
  if data.limits <= data.next or data.next >= 14 then
    checkInBtn:setEnabled(false)
    setShader(checkInBtn, SHADER_GRAY, true)
  end
  local onTouchedRewardNode = nil
  local touchInScroll = false
  local onTouchBeganPoint = nil
  local onTouchBegan = function(l_4_0, l_4_1)
    onTouchedRewardNode = nil
    upvalue_512 = CCPoint(l_4_0, l_4_1)
    local pos = scrollNode:convertToNodeSpace(CCPoint(l_4_0, l_4_1))
    do
      local rect = scrollNode:boundingBox()
      rect.origin.x = 0
      rect.origin.y = 0
      upvalue_1536 = rect:containsPoint(pos)
      for i = 1, #rewardNodes do
        for j = 1, #rewardNodes[i] do
          pos = rewardNodes[i][j]:convertToNodeSpace(CCPoint(l_4_0, l_4_1))
          rect = rewardNodes[i][j]:boundingBox()
          rect.origin.x = 0
          rect.origin.y = 0
          rect.size.width = rect.size.width / 0.7
          rect.size.height = rect.size.height / 0.7
          if rect:containsPoint(pos) then
            onTouchedRewardNode = rewardNodes[i][j]
        else
          end
        end
        if onTouchedRewardNode then
          (for index) = true
          return (for index)
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local onTouchMoved = function(l_5_0, l_5_1)
    if math.abs(onTouchBeganPoint.x - l_5_0) > 10 or math.abs(onTouchBeganPoint.y - l_5_1) > 10 then
      upvalue_512 = false
    end
   end
  local onTouchEnded = function(l_6_0, l_6_1)
    if onTouchedRewardNode then
      local pos = onTouchedRewardNode:convertToNodeSpace(CCPoint(l_6_0, l_6_1))
      local rect = onTouchedRewardNode:boundingBox()
      rect.origin.x = 0
      rect.origin.y = 0
      rect.size.width = rect.size.width / 0.7
      rect.size.height = rect.size.height / 0.7
      if touchInScroll and rect:containsPoint(pos) then
        onTouchedRewardNode.showTips()
      end
    end
   end
  local onTouch = function(l_7_0, l_7_1, l_7_2)
    if l_7_0 == "began" then
      return onTouchBegan(l_7_1, l_7_2)
    elseif l_7_0 == "moved" then
      return onTouchMoved(l_7_1, l_7_2)
    else
      return onTouchEnded(l_7_1, l_7_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  local onUpdate = function(l_8_0)
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui

