-- Command line was: E:\github\dhgametool\scripts\ui\sealland\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local sealLandData = require("data.sealland")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local res = {"spine_ui_time_rent_disc_1", "spine_ui_time_rent_disc2_1", "spine_ui_time_rent_disc2_2", "spine_ui_time_rent_icon", "ui_seal_land", "ui_seal_land_bg"}
local slots = {"code_bd_1", "code_bd_2", "code_bd_3", "code_bd_4", "code_bd_5", "code_bd_6"}
ui.translateCamp = function(l_1_0)
  local campConfig = {6, 3, 1, 5, 2, 4}
  return campConfig[l_1_0]
end

local attackCamp = function(l_2_0)
  local campConfig = {2, 3, 4, 1, 6, 5}
  return campConfig[l_2_0]
end

local monsterCamp = function(l_3_0)
  local campConfig = {4, 1, 2, 3, 6, 5}
  return campConfig[l_3_0]
end

ui.createScrollView = function(l_4_0, l_4_1, l_4_2)
  print("camp" .. l_4_2)
  l_4_1:removeChildByTag(10, true)
  local scrollView = require("ui.lineScroll").create({width = 642, height = l_4_1:getContentSize().height})
  scrollView:setPosition(0, 0)
  l_4_1:addChild(scrollView, 0, 10)
  local curlv = 0
  local createItem = function(l_1_0, l_1_1, l_1_2, l_1_3)
    local item = img.createUISprite(img.ui.seal_land_board_level)
    local item_w = item:getContentSize().width
    local item_h = item:getContentSize().height
    local level = lbl.createFont3(20, string.format(i18n.global.seal_land_challenge_lv.string, l_1_3), ccc3(225, 246, 243))
    level:setPosition(56, item_h / 2)
    item:addChild(level)
    local power_icon = img.createUISprite(img.ui.power_icon)
    power_icon:setScale(0.5)
    power_icon:setPosition(CCPoint(363, item_h / 2))
    item:addChild(power_icon)
    local lbl_power = lbl.createFont1(18, num2KM(l_1_0.power), ccc3(115, 59, 5))
    lbl_power:setPosition(CCPoint(413, item_h / 2))
    item:addChild(lbl_power)
    local currentLevelId = (sealLandData:getCurrentLevel(camp))
    local rewards = nil
    if l_1_1 <= currentLevelId then
      local btnDesc, btnImage, tapFunc, fontColor, costIcon = nil, nil, nil, nil, nil
      do
        if l_1_1 == currentLevelId then
          upvalue_2560 = l_1_2
          btnDesc = i18n.global.dare_btn_challenge.string
          btnImage = img.login.button_9_small_gold
          fontColor = ccc3(115, 59, 5)
          costIcon = img.ui.seal_land_challenge
          rewards = l_1_0.firstReward
          tapFunc = function()
            if sealLandData:availableChallengeTimes() <= 0 then
              showToast(i18n.global.seal_land_challenge_time0.string)
              return 
            end
            layer:addChild(require("ui.selecthero.main").create({type = "sealland", callback = function()
              ui.createScrollView(layer, container, camp)
                  end, data = {group = attackCamp(camp), id = id}}))
               end
        else
          btnDesc = i18n.global.act_bboss_sweep.string
          btnImage = img.login.button_9_small_green
          fontColor = ccc3(37, 107, 6)
          costIcon = img.ui.seal_land_sweep
          rewards = l_1_0.reward
          tapFunc = function()
            if sealLandData:availableSweepTimes() <= 0 then
              showToast(i18n.global.seal_land_sweep_times0.string)
              return 
            end
            require("ui.sealland.sweep").create(layer, id, function()
                  end)
               end
        end
        local challengeBtn = img.createLogin9Sprite(btnImage)
        do
          challengeBtn:setPreferredSize(CCSizeMake(148, 50))
          local icon = img.createUISprite(costIcon)
          icon:setPosition(28, 25)
          challengeBtn:addChild(icon)
          if costIcon ~= img.ui.seal_land_sweep then
            local costNum = lbl.createFont3(12, "1", ccc3(225, 246, 243))
            costNum:setPosition(28, 17)
            challengeBtn:addChild(costNum)
          end
          local lbl_btn_ch = lbl.createFont1(16, btnDesc, fontColor)
          lbl_btn_ch:setPosition(CCPoint(94, 24))
          challengeBtn:addChild(lbl_btn_ch)
          local btn_ch = SpineMenuItem:create(json.ui.button, challengeBtn)
          btn_ch:setPosition(CCPoint(540, item_h / 2))
          btn_ch:registerScriptTapHandler(function()
            disableObjAWhile(btn_ch)
            btn_ch:setEnabled(false)
            audio.play(audio.button)
            tapFunc()
               end)
          local btn_ch_menu = CCMenu:createWithItem(btn_ch)
          btn_ch_menu:setPosition(CCPoint(0, 0))
          item:addChild(btn_ch_menu)
        end
      else
        rewards = l_1_0.firstReward
        local lock = img.createUISprite(img.ui.seal_land_lock)
        lock:setPosition(540, item_h / 2)
        item:addChild(lock)
      end
      do
        local rewardContainer = CCSprite:create()
        rewardContainer:setContentSize(CCSizeMake(137, 63))
        rewardContainer:setPosition(CCPoint(234, item_h / 2))
        item:addChild(rewardContainer)
        if rewards then
          for ii = 1, #rewards do
            local reward = rewards[ii]
            local rewardNode = nil
            if reward.type == 1 then
              rewardNode = CCMenuItemSprite:create((img.createItem(reward.id, reward.num)), nil)
            elseif reward.type == 2 then
              rewardNode = CCMenuItemSprite:create((img.createEquip(reward.id, reward.num)), nil)
            end
            rewardNode:setScale(0.75)
            rewardNode:setPosition(CCPoint(32 + (ii - 1) * 71, 32))
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
            rewardContainer:addChild(rewardNodeMenu)
          end
        end
        return item
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local pairsTable = function(l_2_0)
    local a = {}
    for n in pairs(l_2_0) do
      a[#a + 1] = n
    end
    table.sort(a)
    local i = 0
    return function()
      i = i + 1
      return a[i], t[a[i]]
      end
   end
  local showList = function()
    local sealLandConfig = require("config.sealland")
    local currentLevel = sealLandData:getCurrentLevel(camp)
    local data = {}
    local s = 0
    local e = 0
    for k,v in pairsTable(sealLandConfig) do
      if v.type == camp then
        v.id = k
        data[#data + 1] = v
        if k == currentLevel then
          s = #data
          e = s + 5
        end
      end
    end
    if s > 1 then
      s = s - 1
      e = e - 1
    end
    if s == 0 or #data < e then
      s = #data - 5
      e = #data
    end
    for i = 0, e - (s) do
      local viewItem = createItem(data[s + i], data[s + i].id, i + 1, s + i)
      viewItem.ax = 0
      viewItem.px = 0
      scrollView.addItem(viewItem)
    end
    if curlv == 0 then
      do return end
    end
    if curlv < 6 then
      scrollView.setOffsetBegin()
    else
       -- Warning: missing end command somewhere! Added here
    end
   end
  showList()
end

ui.create = function(l_5_0)
  img.loadAll(res)
  l_5_0 = monsterCamp(l_5_0)
  local type = 0
  local layer = CCLayer:create()
  local bg = img.createUISprite(img.ui.seal_land_background)
  bg:setScale(view.minScale)
  bg:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(bg)
  local scrollHeight = 503 + view.minY * 2 / view.minScale
  local scrollViewNode = CCNode:create()
  scrollViewNode:setScale(view.minScale)
  scrollViewNode:setAnchorPoint(CCPoint(0.5, 0))
  scrollViewNode:setPosition(view.midX, 0)
  scrollViewNode:setContentSize(CCSizeMake(642, scrollHeight))
  layer:addChild(scrollViewNode)
  local main_ani = json.create(json.ui.seal_land_door)
  main_ani:setScale(view.minScale)
  main_ani:setPosition(ccp(view.midX, view.midY))
  main_ani.currentCamp = 1
  main_ani.selectCamp = function(l_1_0, l_1_1)
    local start, loop = nil, nil
    local camp = main_ani.currentCamp
    if not l_1_1 then
      l_1_1 = 1
    end
    if l_1_0 then
      camp = camp + l_1_1
    else
      camp = camp - l_1_1
    end
    if camp > 6 then
      camp = camp - 6
    end
    if camp < 1 then
      camp = camp + 6
    end
    start = "start_" .. main_ani.currentCamp .. "-" .. camp
    loop = "loop_" .. camp
    main_ani.currentCamp = camp
    print("start:" .. start)
    print("loop\239\188\154" .. loop)
    main_ani:stopAnimation()
    main_ani:clearNextAnimation()
    main_ani:playAnimation(start)
    main_ani:appendNextAnimation(loop, -1)
   end
  main_ani.playEnterAnimation = function()
    main_ani:stopAnimation()
    main_ani:clearNextAnimation()
    main_ani:playAnimation("start_1")
    main_ani:appendNextAnimation("loop_1", -1)
   end
  main_ani.playExitAnimation = function()
    main_ani:stopAnimation()
    main_ani:clearNextAnimation()
    local endAnimation = "end_" .. main_ani.currentCamp
    main_ani:playAnimation(endAnimation)
   end
  main_ani.addLevels = function()
    for i = 1, 6 do
      local code = "code_text" .. i
      main_ani:removeChildFollowSlot(code)
      local levelId = sealLandData:getCurrentLevel(ui.translateCamp(i))
      local level = levelId % 1000 - 1
      local allLevel = sealLandData:getLevelCount(ui.translateCamp(i))
      local shadow = img.createUISprite(img.ui.seal_land_shadow)
      main_ani:addChildFollowSlot(code, shadow)
      local text = lbl.createFont3(22, string.format("%d/%d", level, allLevel), ccc3(255, 246, 223))
      text:setPosition(CCPointMake(37, 9))
      shadow:addChild(text)
    end
   end
  main_ani.addLevels()
  layer:addChild(main_ani)
  local back0 = img.createUISprite(img.ui.back)
  local backBtn = HHMenuItem:create(back0)
  backBtn:setScale(view.minScale)
  backBtn:setPosition(scalep(35, 546))
  backBtn:registerScriptTapHandler(function()
    layer.onAndroidBack()
   end)
  local backMenu = CCMenu:createWithItem(backBtn)
  backMenu:setPosition(0, 0)
  layer:addChild(backMenu)
  autoLayoutShift(backBtn)
  local container = CCSprite:create()
  container:setContentSize(CCSizeMake(410, 40))
  container:setScale(view.minScale)
  container:setAnchorPoint(CCPoint(0.5, 1))
  container:setPosition(scalep(480, 568))
  layer:addChild(container)
  autoLayoutShift(container)
  local containerSize = container:getContentSize()
  local sweepBg = img.createUI9Sprite(img.ui.main_coin_bg)
  sweepBg:setPreferredSize(CCSizeMake(174, 40))
  sweepBg:setAnchorPoint(CCPoint(0, 0.5))
  sweepBg:setPosition(CCPoint(0, containerSize.height / 2))
  container:addChild(sweepBg)
  local sweepIcon = img.createUISprite(img.ui.seal_land_sweep)
  sweepIcon:setPosition(CCPoint(5, sweepBg:getContentSize().height / 2 + 2))
  sweepBg:addChild(sweepIcon)
  local sweepBtnBg = img.createUISprite(img.ui.main_icon_plus)
  local sweepBtn = HHMenuItem:create(sweepBtnBg)
  sweepBtn:setPosition(CCPoint(sweepBg:getContentSize().width - 1, sweepBg:getContentSize().height / 2 + 2))
  sweepBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if sealLandData:availableBuySweepTimes() <= 0 then
      showToast(string.format(i18n.global.seal_land_buy_sweep_times.string, sealLandData:availableBuySweepTimes()))
      return 
    end
    require("ui.sealland.buysweep").create(layer, function()
      end)
   end)
  local sweepBtnMenu = CCMenu:createWithItem(sweepBtn)
  sweepBtnMenu:setPosition(CCPoint(0, 0))
  sweepBg:addChild(sweepBtnMenu)
  local formatSweepString = function()
    return string.format("%d", sealLandData:availableSweepTimes())
   end
  local sweepLbl = lbl.createFont2(16, formatSweepString(), ccc3(255, 246, 223))
  sweepLbl:setPosition(sweepBg:getContentSize().width / 2, sweepBg:getContentSize().height / 2 + 3)
  sweepBg:addChild(sweepLbl)
  local challengeBg = img.createUI9Sprite(img.ui.main_coin_bg)
  challengeBg:setPreferredSize(CCSizeMake(174, 40))
  challengeBg:setAnchorPoint(CCPoint(1, 0.5))
  challengeBg:setPosition(CCPoint(container:getContentSize().width - 10, containerSize.height / 2))
  container:addChild(challengeBg)
  local challengeIcon = img.createUISprite(img.ui.seal_land_challenge)
  challengeIcon:setPosition(CCPoint(5, challengeBg:getContentSize().height / 2 + 2))
  challengeBg:addChild(challengeIcon)
  local challengeBtnBg = img.createUISprite(img.ui.main_icon_plus)
  local challengeBtn = HHMenuItem:create(challengeBtnBg)
  challengeBtn:setPosition(CCPoint(challengeBg:getContentSize().width - 1, challengeBg:getContentSize().height / 2 + 2))
  challengeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    require("ui.sealland.buychallenge").create(layer, function()
      end)
   end)
  local challengeBtnMenu = CCMenu:createWithItem(challengeBtn)
  challengeBtnMenu:setPosition(CCPoint(0, 0))
  challengeBg:addChild(challengeBtnMenu)
  local formatChallengeString = function()
    return string.format("%d", sealLandData:availableChallengeTimes())
   end
  local challengeLbl = lbl.createFont2(16, formatChallengeString(), ccc3(255, 246, 223))
  challengeLbl:setPosition(challengeBg:getContentSize().width / 2, challengeBg:getContentSize().height / 2 + 3)
  challengeBg:addChild(challengeLbl)
  local btn_help0 = img.createUISprite(img.ui.btn_help)
  local btn_help = SpineMenuItem:create(json.ui.button, btn_help0)
  btn_help:setPosition(scalep(798, 543))
  btn_help:setScale(view.minScale)
  btn_help:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.help").create(i18n.global.help_seal_land.string), 1000)
   end)
  btn_help.changePosition = function(l_11_0)
    if l_11_0 then
      btn_help:setPosition(scalep(798, 543))
    else
      btn_help:setPosition(scalep(920, 543))
    end
    autoLayoutShift(btn_help, true, false, false, true)
   end
  local btn_help_menu = CCMenu:createWithItem(btn_help)
  btn_help_menu:setPosition(CCPoint(0, 0))
  layer:addChild(btn_help_menu)
  autoLayoutShift(btn_help, true, false, false, true)
  local shopBg = img.createUISprite(img.ui.seal_land_shop_bg)
  shopBg:setPosition(scalep(835, 463))
  shopBg:setAnchorPoint(CCPointMake(0, 0))
  shopBg:setScale(view.minScale)
  layer:addChild(shopBg)
  local shopImage = img.createUISprite(img.ui.seal_land_shop_icon)
  local shopBtn = HHMenuItem:create(shopImage)
  shopBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local shop = require("ui.sealland.shop")
    layer:addChild(shop.create(), 1000)
   end)
  shopBtn:setPosition(0, 0)
  local shopMenu = CCMenu:createWithItem(shopBtn)
  shopMenu:setPosition(67, 68)
  shopBg:addChild(shopMenu)
  autoLayoutShift(shopBg)
  local left = img.createUISprite(img.ui.seal_land_next)
  left:setFlipY(true)
  local leftBtn = HHMenuItem:create(left)
  leftBtn:setPosition(scalep(90, 178))
  leftBtn:setScale(view.minScale)
  leftBtn:setRotation(180)
  leftBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    main_ani.selectCamp(true)
   end)
  local leftMenu = CCMenu:createWithItem(leftBtn)
  leftMenu:setPosition(0, 0)
  layer:addChild(leftMenu)
  autoLayoutShift(leftBtn)
  local right = img.createUISprite(img.ui.seal_land_next)
  local rightBtn = HHMenuItem:create(right)
  rightBtn:setPosition(scalep(870, 178))
  rightBtn:setScale(view.minScale)
  rightBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    main_ani.selectCamp(false)
   end)
  local rightMenu = CCMenu:createWithItem(rightBtn)
  rightMenu:setPosition(0, 0)
  layer:addChild(rightMenu)
  local battle = img.createLogin9Sprite(img.login.button_9_gold)
  battle:setPreferredSize(CCSizeMake(180, 70))
  local battleLabel = lbl.createFont1(22, i18n.global.trial_stage_btn_battle.string, ccc3(115, 59, 5))
  battleLabel:setPosition(CCPoint(89, 34))
  battle:addChild(battleLabel)
  local battleBtn = SpineMenuItem:create(json.ui.button, battle)
  local battleMenu = CCMenu:createWithItem(battleBtn)
  battleMenu:setPosition(CCPoint(0, 0))
  main_ani:addChildFollowSlot("code_fight", battleMenu)
  battleBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    disableObjAWhile(battleBtn)
    upvalue_1024 = 1
    btn_help.changePosition(false)
    shopBg:setVisible(false)
    leftMenu:setVisible(false)
    rightMenu:setVisible(false)
    battleMenu:setVisible(false)
    main_ani.playExitAnimation()
    scrollViewNode:setVisible(true)
    ui.createScrollView(layer, scrollViewNode, ui.translateCamp(main_ani.currentCamp))
   end)
  if l_5_0 then
    type = 1
    btn_help.changePosition(false)
    shopBg:setVisible(false)
    leftMenu:setVisible(false)
    rightMenu:setVisible(false)
    battleMenu:setVisible(false)
    main_ani.playExitAnimation()
    ui.createScrollView(layer, scrollViewNode, l_5_0)
  else
    type = 0
    btn_help.changePosition(true)
    shopBg:setVisible(true)
    leftMenu:setVisible(true)
    rightMenu:setVisible(true)
    battleMenu:setVisible(true)
    main_ani.playEnterAnimation()
  end
  addBackEvent(layer)
  layer.onAndroidBack = function()
    audio.play(audio.button)
    if type == 0 then
      layer:removeFromParentAndCleanup(true)
      replaceScene(require("ui.town.main").create())
    else
      upvalue_512 = 0
      main_ani.currentCamp = 1
      upvalue_2048 = nil
      btn_help.changePosition(true)
      shopBg:setVisible(true)
      leftMenu:setVisible(true)
      rightMenu:setVisible(true)
      battleMenu:setVisible(true)
      scrollViewNode:setVisible(false)
      main_ani.addLevels()
      main_ani.playEnterAnimation()
    end
   end
  layer:registerScriptHandler(function(l_17_0)
    if l_17_0 == "enter" then
      layer.notifyParentLock()
    elseif l_17_0 == "exit" then
      layer.notifyParentUnlock()
    elseif l_17_0 == "cleanup" then
       -- Warning: missing end command somewhere! Added here
    end
   end)
  local isClickCamp = function(l_18_0, l_18_1)
    if type == 0 then
      for i = 1, #slots do
        if main_ani:getAabbBoundingBoxBySlot(slots[i]):containsPoint(CCPoint(l_18_0, l_18_1)) and i ~= 1 then
          return i
        end
      end
    end
    return -1
   end
  local onTouch = function(l_19_0, l_19_1, l_19_2)
    if isClickCamp(l_19_1, l_19_2) <= 0 then
      return l_19_0 ~= "began"
    end
    do return end
    if l_19_0 == "moved" then
      do return end
    end
    if l_19_0 == "ended" then
      local i = isClickCamp(l_19_1, l_19_2)
      if i > 0 then
        audio.play(audio.button)
        if i > 3 then
          main_ani.selectCamp(false, 7 - i)
        else
          main_ani.selectCamp(true, i - 1)
        end
      end
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  local onUpdate = function()
    sealLandData:cdTime()
    sweepLbl:setString(formatSweepString())
    challengeLbl:setString(formatChallengeString())
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  return layer
end

return ui

