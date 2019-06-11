-- Command line was: E:\github\dhgametool\scripts\ui\activity\dinner.lua 

local ui = {}
local view = require("common.view")
local img = require("res.img")
local i18n = require("res.i18n")
local audio = require("res.audio")
local json = require("res.json")
local lbl = require("res.lbl")
local activityData = require("data.activity")
local net = require("net.netClient")
local player = require("data.player")
local bag = require("data.bag")
local reward = require("ui.reward")
local shareReasure = require("config.sharetreasure")
local rewardLevel = {shareReasure[1].count, shareReasure[2].count, shareReasure[3].count, shareReasure[4].count}
local res = {img.packedOthers.spine_ui_yuanzheng_baoxiang, img.packedOthers.spine_ui_ganenwancan}
ui.create = function()
  img.loadAll(res)
  local data = activityData.getStatusById(activityData.IDS.DINNER.ID)
  local layer = CCLayer:create()
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(574, 434))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_dinner)
  local animation = json.create(json.ui.ganenwancan)
  animation:playAnimation("loop", -1)
  animation:setPosition(CCPoint(board_w / 2, board_h / 2))
  board:addChild(animation)
  local bg = CCSprite:create()
  bg:setContentSize(563, 435)
  bg:setPosition(CCPoint(board_w / 2, board_h / 2))
  board:addChild(bg)
  local titleBg = img.createUISprite(img.ui.activity_dinner_topback)
  titleBg:setAnchorPoint(0.5, 1)
  titleBg:setPosition(bg:getContentSize().width / 2, bg:getContentSize().height)
  bg:addChild(titleBg)
  local title = lbl.createFont2(18, i18n.global.activity_des_dinner.string, ccc3(246, 214, 108))
  title:setPosition(titleBg:getContentSize().width / 2, titleBg:getContentSize().height / 2 + 6)
  titleBg:addChild(title)
  if i18n.getCurrentLanguage() == kLanguageFrench then
    title:setScale(0.8 * title:getScale())
  end
  local helpBg = img.createUISprite(img.ui.btn_help)
  local help = SpineMenuItem:create(json.ui.button, helpBg)
  help:setPosition(530, 402)
  help:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:getParent():getParent():addChild(require("ui.help").create(i18n.global.help_activity_dinner.string), 1000)
   end)
  local helpMenu = CCMenu:createWithItem(help)
  helpMenu:setPosition(CCPoint(0, 0))
  bg:addChild(helpMenu)
  local items = {}
  local grids = {}
  local showRewardItems = function(l_2_0)
    local tipsLayer = CCLayer:create()
    tipsLayer.tipsTag = false
    local cfg = require("config.sharetreasure")
    local rewardCount = #cfg[l_2_0].rewards1
    local width = 200 + (rewardCount - 1) * 110
    local tipsBg = img.createUI9Sprite(img.ui.tips_bg)
    tipsBg:setPreferredSize(CCSize(width, 206))
    tipsBg:setScale(view.minScale)
    tipsBg:setPosition(view.physical.w / 2, view.physical.h / 2)
    tipsLayer:addChild(tipsBg)
    local tipsTitle = lbl.createFont1(18, i18n.global.brave_baoxiang_tips.string, ccc3(255, 228, 156))
    tipsTitle:setPosition(width / 2, 174)
    tipsBg:addChild(tipsTitle)
    local line = img.createUISprite(img.ui.help_line)
    line:setScaleX(242 / line:getContentSize().width)
    line:setPosition(CCPoint(width / 2, 150))
    tipsBg:addChild(line)
    for i = 1, #cfg[l_2_0].rewards1 do
      local reward = cfg[l_2_0].rewards1[i]
      do
        local item = nil
        if reward.type == 1 then
          item = img.createItem(reward.id, reward.num)
        elseif reward.type == 2 then
          item = img.createEquip(reward.id, reward.num)
        end
        local itemBtn = SpineMenuItem:create(json.ui.button, item)
        itemBtn:setPosition(tipsBg:getContentSize().width / 2 - (rewardCount - 1) / 2 * 110 + (i - 1) * 110, 78)
        itemBtn:registerScriptTapHandler(function()
          audio.play(audio.button)
          if tipsLayer.tipsTag == false then
            tipsLayer.tipsTag = true
            local tips = nil
            do
              if reward.type == 1 then
                tips = require("ui.tips.item").createForShow({id = reward.id, num = reward.num})
              else
                tips = require("ui.tips.equip").createById(reward.id)
              end
              tips.setClickBlankHandler(function()
                tips:removeFromParent()
                tipsLayer.tipsTag = false
                     end)
              tipsLayer:addChild(tips, 200)
            end
          end
            end)
        local iconMenu = CCMenu:createWithItem(itemBtn)
        iconMenu:setPosition(0, 0)
        tipsBg:addChild(iconMenu)
      end
    end
    local clickBlankHandler = nil
    tipsLayer.setClickBlankHandler = function(l_2_0)
      clickBlankHandler = l_2_0
      end
    tipsLayer.setClickBlankHandler(function()
      items[pos].gridSelected:setVisible(false)
      tipsLayer:removeFromParent()
      end)
    local onTouch = function(l_4_0, l_4_1, l_4_2)
      if l_4_0 == "began" then
        return true
      elseif l_4_0 == "moved" then
        return 
      else
        if not tipsBg:boundingBox():containsPoint(ccp(l_4_1, l_4_2)) then
          tipsLayer.onAndroidBack()
        end
      end
      end
    addBackEvent(tipsLayer)
    tipsLayer.onAndroidBack = function()
      if clickBlankHandler then
        clickBlankHandler()
      else
        tipsLayer:removeFromParent()
        items[i].gridSelected:setVisible(false)
      end
      end
    tipsLayer:setTouchEnabled(true)
    tipsLayer:setTouchSwallowEnabled(true)
    tipsLayer:registerScriptTouchHandler(onTouch)
    return tipsLayer
   end
  local startX = 173
  local dx = 98
  for i = 1, 4 do
    do
      local num = lbl.createFont1(20, rewardLevel[i], ccc3(255, 248, 243))
      do
        num:setPosition(startX + (i - 1) * dx, 16)
        bg:addChild(num)
        local gridSelected = img.createUISprite(img.ui.bag_grid_selected)
        gridSelected:setAnchorPoint(ccp(0, 0))
        gridSelected:setVisible(false)
        local grid = img.createUISprite(img.ui.grid)
        grid:setScale(grid:getScale() * 0.74)
        grid:addChild(gridSelected)
        local item = SpineMenuItem:create(json.ui.button, grid)
        item:setPosition(startX + (i - 1) * dx, 98)
        item.gridSelected = gridSelected
        item.open = function(l_3_0)
          l_3_0:setEnabled(false)
          l_3_0.animation:stopAnimation()
          l_3_0.animation:playAnimation("1")
          local blackicon = img.createUISprite(img.ui.activity_dinner_black)
          blackicon:setPosition(grid:getContentSize().width / 2, grid:getContentSize().height / 2)
          blackicon:setOpacity(85)
          blackicon:setScale(0.74)
          l_3_0:addChild(blackicon, 1001)
          local tickIcon = img.createUISprite(img.ui.hook_btn_sel)
          tickIcon:setPosition(grid:getContentSize().width / 2, grid:getContentSize().height / 2)
          tickIcon:setScale(0.74)
          l_3_0:addChild(tickIcon, 1001)
            end
        local rewardMenu = CCMenu:createWithItem(item)
        rewardMenu:setPosition(0, 0)
        bg:addChild(rewardMenu)
        item:registerScriptTapHandler(function()
          audio.play(audio.button)
          if data.limits < rewardLevel[i] then
            item.gridSelected:setVisible(true)
            local tipsLayer = showRewardItems(i)
            layer:addChild(tipsLayer)
            return 
          end
            end)
        local animation = json.create(json.ui.yuanzheng_baoxiang)
        animation:setPosition(grid:getContentSize().width / 2, grid:getContentSize().height / 2)
        grid:addChild(animation, 1000)
        item.animation = animation
        if rewardLevel[i] <= data.limits then
          item:open()
        else
          animation:stopAnimation()
          animation:playAnimation("1")
        end
        items[i] = item
        grids[i] = grid
      end
    end
  end
  local percent = function()
    local percent = 0
    if data.limits <= rewardLevel[1] then
      percent = 0.2441 / rewardLevel[1] * data.limits
    else
      if data.limits <= rewardLevel[2] then
        percent = 0.2441 + 0.2303 / (rewardLevel[2] - rewardLevel[1]) * (data.limits - rewardLevel[1])
      else
        if data.limits <= rewardLevel[3] then
          percent = 0.4744 + 0.2325 / (rewardLevel[3] - rewardLevel[2]) * (data.limits - rewardLevel[2])
        else
          if data.limits < rewardLevel[4] then
            percent = 0.7069 + 0.2279 / (rewardLevel[4] - rewardLevel[3]) * (data.limits - rewardLevel[3])
          else
            percent = 1
          end
        end
      end
    end
    return percent
   end
  local raw = img.createUISprite(img.ui.activity_dinner_schedule1)
  raw:setAnchorPoint(0, 1)
  raw:setPosition(68, 66)
  bg:addChild(raw)
  local progress0 = img.createUISprite(img.ui.activity_dinner_schedule2)
  local powerProgress = createProgressBar(progress0)
  powerProgress:setPosition(raw:getContentSize().width / 2, raw:getContentSize().height / 2 - 4)
  powerProgress:setPercentage(percent() * 100)
  raw:addChild(powerProgress)
  local circle = img.createUISprite(img.ui.activity_dinner_level_circle)
  circle:setPosition(percent() * 430, 13)
  raw:addChild(circle)
  local progressNum = lbl.createFont1(16, data.limits, ccc3(29, 103, 0))
  progressNum:setPosition(circle:getContentSize().width / 2, circle:getContentSize().height / 2)
  circle:addChild(progressNum)
  if rewardLevel[#rewardLevel] <= data.limits then
    circle:setVisible(false)
  end
  local iconBg = img.createUISprite(img.ui.activity_dinner_roundback)
  iconBg:setPosition(bg:getContentSize().width / 2, 176)
  bg:addChild(iconBg)
  local item = bag.items.find(ITEM_ID_CHICKEN)
  local chicken = 0
  if item and item.num then
    chicken = item.num
  end
  local foods = lbl.createFont2(18, string.format("%d", chicken), ccc3(255, 248, 243))
  foods:setPosition(iconBg:getContentSize().width / 2, 16)
  iconBg:addChild(foods, 1000)
  local icon = img.createItemIcon(190)
  local iconBtn = SpineMenuItem:create(json.ui.button, icon)
  iconBtn:setPosition(iconBg:getContentSize().width / 2, iconBg:getContentSize().height / 2)
  iconBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local count = 0
    local item = bag.items.find(ITEM_ID_CHICKEN)
    if item and item.num then
      count = item.num
    end
    if count <= 0 then
      showToast(i18n.global.activity_dinner_chicken0.string)
      return 
    end
    animation:registerAnimation("animation")
    local nParams = {sid = player.sid, id = activityData.IDS.DINNER.ID}
    tbl2string(nParams)
    addWaitNet()
    net:activity_skim(nParams, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0 and l_1_0.status and l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
      end
      data.limits = data.limits + 1
      if l_1_0.reward then
        local rw = tablecp(l_1_0.reward)
        do
          arrayfilter(rw.items, function(l_1_0)
            return l_1_0.id ~= ITEM_ID_VIP_EXP
               end)
          layer:addChild(require("ui.reward").createFloating(rw), 1000)
          bag.addRewards(l_1_0.reward)
        end
      end
      if l_1_0.extra then
        local ban = CCLayer:create()
        ban:setTouchEnabled(true)
        ban:setTouchSwallowEnabled(true)
        layer:addChild(ban, 1001)
        for i = 1, #rewardLevel do
          if data.limits == rewardLevel[i] then
            items[i].animation:stopAnimation()
            items[i].animation:playAnimation("3")
          end
        end
        schedule(layer, 1, function()
          ban:removeFromParent()
          layer:addChild(reward.showRewardForbraveBox(__data.extra), 1002)
          for i = 1, #rewardLevel do
            if data.limits == rewardLevel[i] then
              items[i]:open()
            end
          end
            end)
        bag.addRewards(l_1_0.extra)
      end
      bag.items.sub({id = ITEM_ID_CHICKEN, num = 1})
      foods:setString(string.format("%d", count - 1))
      powerProgress:setPercentage(percent() * 100)
      circle:setPosition(percent() * 430, 13)
      progressNum:setString(string.format("%d", data.limits))
      if rewardLevel[#rewardLevel] <= data.limits then
        circle:setVisible(false)
      end
      end)
   end)
  local iconMenu = CCMenu:createWithItem(iconBtn)
  iconMenu:setPosition(CCPoint(0, 0))
  iconBg:addChild(iconMenu)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  layer:registerScriptHandler(function(l_7_0)
    if l_7_0 == "enter" then
      do return end
    end
    if l_7_0 == "exit" then
      do return end
    end
    if l_7_0 == "cleanup" then
      img.unloadAll(res)
    end
   end)
  return layer
end

return ui

