-- Command line was: E:\github\dhgametool\scripts\ui\arena\rewards.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local cfghero = require("config.hero")
local cfgequip = require("config.equip")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local cfgDaily = require("config.dailyrewards")
local cfgSeasons = require("config.endrewards")
local arenaData = (require("data.arena"))
local superlayer = nil
local createDailyRewards = function()
  local layer = CCLayer:create()
  local height = 0
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(0, 1)
  scroll:setViewSize(CCSize(682, 340))
  scroll:setContentSize(CCSize(682, 0))
  layer:addChild(scroll)
  local showItems = {}
  for i = 1, #cfgDaily do
    local idx = #cfgDaily - i + 1
    local taskBg = img.createUI9Sprite(img.ui.botton_fram_2)
    taskBg:setPreferredSize(CCSize(650, 80))
    taskBg:setAnchorPoint(ccp(0.5, 0))
    taskBg:setPosition(341, i * 82 - 80)
    scroll:getContainer():addChild(taskBg)
    local showRank = nil
    if cfgDaily[idx].rank <= 3 then
      showRank = img.createUISprite(img.ui.arena_rank_" .. cfgDaily[idx].ran)
    else
      if cfgDaily[idx].rank == cfgDaily[idx - 1].rank + 1 then
        showRank = lbl.createMixFont1(20, cfgDaily[idx].rank, ccc3(130, 90, 61))
      else
        showRank = lbl.createMixFont1(16, cfgDaily[idx - 1].rank + 1 .. "-" .. cfgDaily[idx].rank, ccc3(130, 90, 61))
      end
    end
    showRank:setPosition(80, 40)
    taskBg:addChild(showRank)
    for j,v in ipairs(cfgDaily[idx].rewards) do
      local showItem = nil
      if v.type == 1 then
        showItem = img.createItem(v.id, v.num)
      else
        showItem = img.createEquip(v.id)
      end
      showItem:setScale(0.7)
      showItem:setAnchorPoint(ccp(0, 0))
      showItem:setPosition(118 + 64 * j, taskBg:getPositionY() + 12)
      scroll:getContainer():addChild(showItem)
      showItems[#showItems + 1] = showItem
      showItems[#showItems].Info = v
    end
    height = taskBg:boundingBox():getMaxY()
  end
  local showText = lbl.createMix({font = 1, size = 14, text = i18n.global.arena_reward_daily_title.string, color = ccc3(93, 45, 18), width = 650, align = kCCTextAlignmentLeft})
  showText:setAnchorPoint(ccp(0, 0))
  showText:setPosition(17, height + 4)
  scroll:getContainer():addChild(showText)
  local iconTime = img.createUISprite(img.ui.clock)
  iconTime:setAnchorPoint(ccp(0, 0))
  iconTime:setPosition(17, showText:boundingBox():getMaxY() + 2)
  scroll:getContainer():addChild(iconTime)
  local showTime = lbl.createFont2(14, time2string(arenaData.daily_cd - os.time()), ccc3(165, 253, 71))
  showTime:setAnchorPoint(ccp(0, 0))
  showTime:setPosition(45, showText:boundingBox():getMaxY() + 2)
  scroll:getContainer():addChild(showTime)
  local showHighestBg = img.createUI9Sprite(img.ui.arena_daily_bg)
  showHighestBg:setPreferredSize(CCSize(650, 151))
  showHighestBg:setAnchorPoint(ccp(0.5, 0))
  showHighestBg:setPosition(341, showTime:boundingBox():getMaxY() + 5)
  scroll:getContainer():addChild(showHighestBg)
  local titleRank = lbl.createFont2(14, i18n.global.arena_reward_high_rank.string)
  titleRank:setColor(ccc3(255, 246, 223))
  titleRank:setAnchorPoint(ccp(0, 0))
  titleRank:setPosition(19, 115)
  showHighestBg:addChild(titleRank)
  local showRank = lbl.createFont2(14, arenaData.trank, ccc3(179, 255, 80))
  showRank:setAnchorPoint(ccp(0, 0))
  showRank:setPosition(titleRank:boundingBox():getMaxX() + 5, titleRank:getPositionY())
  showHighestBg:addChild(showRank)
  local rankIdx = 1
  for i,v in ipairs(cfgDaily) do
    if v.rank < arenaData.rank then
      rankIdx = i + 1
    end
  end
  local str = nil
  if rankIdx == 1 or cfgDaily[rankIdx].rank == cfgDaily[rankIdx - 1].rank + 1 then
    str = string.format(i18n.global.arena_reward_cur_rank1.string, cfgDaily[rankIdx].rank)
  else
    str = string.format(i18n.global.arena_reward_cur_rank2.string, cfgDaily[rankIdx - 1].rank, cfgDaily[rankIdx].rank)
  end
  for i,v in ipairs(cfgDaily[rankIdx].rewards) do
    local showItem = nil
    if v.type == 1 then
      showItem = img.createItem(v.id, v.num)
    else
      showItem = img.createEquip(v.id)
    end
    showItem:setScale(0.7)
    showItem:setAnchorPoint(ccp(0, 0))
    showItem:setPosition(-28 + 64 * i, showHighestBg:getPositionY() + 25)
    scroll:getContainer():addChild(showItem)
    showItems[#showItems + 1] = showItem
    showItems[#showItems].Info = v
  end
  local titleRule = lbl.createMix({font = 1, size = 13, text = str, color = ccc3(93, 45, 18), width = 650, align = kCCTextAlignmentLeft})
  titleRule:setAnchorPoint(ccp(0, 0))
  titleRule:setPosition(21, 95)
  showHighestBg:addChild(titleRule)
  scroll:setContentSize(CCSize(682, showHighestBg:boundingBox():getMaxY() + 10))
  scroll:setContentOffset(ccp(0, 340 - scroll:getContentSize().height))
  layer:scheduleUpdateWithPriorityLua(function()
    showTime:setString(time2string(arenaData.daily_cd - os.time()))
    if arenaData.daily_cd <= os.time() then
      arenaData.daily_cd = arenaData.daily_cd + 86400
    end
   end)
  local lasty = nil
  local onTouchBegin = function(l_2_0, l_2_1)
    lasty = l_2_1
    return true
   end
  local onTouchMoved = function(l_3_0, l_3_1)
    return true
   end
  local onTouchEnd = function(l_4_0, l_4_1)
    local pointOnBoard = layer:convertToNodeSpace(ccp(l_4_0, l_4_1))
    if math.abs(l_4_1 - lasty) > 10 or not scroll:boundingBox():containsPoint(pointOnBoard) then
      return true
    end
    local point = scroll:getContainer():convertToNodeSpace(ccp(l_4_0, l_4_1))
    for i,v in ipairs(showItems) do
      if v:boundingBox():containsPoint(point) then
        local tips = nil
        if v.Info.type == 1 then
          tips = require("ui.tips.item").createForShow(v.Info)
        else
          tips = require("ui.tips.equip").createById(v.Info.id)
        end
        superlayer:addChild(tips)
      end
    end
    return true
   end
  local onTouch = function(l_5_0, l_5_1, l_5_2)
    if l_5_0 == "began" then
      return onTouchBegin(l_5_1, l_5_2)
    elseif l_5_0 == "moved" then
      return onTouchMoved(l_5_1, l_5_2)
    else
      return onTouchEnd(l_5_1, l_5_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  return layer
end

local createSeasonRewards = function()
  local layer = CCLayer:create()
  local height = 0
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(0, 1)
  scroll:setViewSize(CCSize(682, 340))
  scroll:setContentSize(CCSize(682, 0))
  layer:addChild(scroll)
  local showItems = {}
  local cfgSeason = {}
  for i = 1, #cfgSeasons do
    if cfgSeasons[i].arenaId == 1 then
      cfgSeason[#cfgSeason + 1] = cfgSeasons[i]
    end
  end
  for i = 1, #cfgSeason do
    local idx = #cfgSeason - i + 1
    local taskBg = img.createUI9Sprite(img.ui.botton_fram_2)
    taskBg:setPreferredSize(CCSize(650, 80))
    taskBg:setAnchorPoint(ccp(0.5, 0))
    taskBg:setPosition(341, i * 82 - 80)
    scroll:getContainer():addChild(taskBg)
    local showRank = nil
    if cfgSeason[idx].rank <= 3 then
      showRank = img.createUISprite(img.ui.arena_rank_" .. cfgSeason[idx].ran)
    else
      if cfgSeason[idx].rank == cfgSeason[idx - 1].rank + 1 then
        showRank = lbl.createMixFont1(20, cfgSeason[idx].rank, ccc3(130, 90, 61))
      else
        showRank = lbl.createMixFont1(16, cfgSeason[idx - 1].rank + 1 .. "-" .. cfgSeason[idx].rank, ccc3(130, 90, 61))
      end
    end
    showRank:setPosition(80, 40)
    taskBg:addChild(showRank)
    for j,v in ipairs(cfgSeason[idx].rewards) do
      local showItem = nil
      if v.type == 1 then
        showItem = img.createItem(v.id, v.num)
      else
        showItem = img.createEquip(v.id)
      end
      showItem:setScale(0.7)
      showItem:setAnchorPoint(ccp(0, 0))
      showItem:setPosition(118 + 64 * j, taskBg:getPositionY() + 12)
      scroll:getContainer():addChild(showItem)
      showItems[#showItems + 1] = showItem
      showItems[#showItems].Info = v
    end
    height = taskBg:boundingBox():getMaxY()
  end
  local showText = lbl.createMix({font = 1, size = 14, text = i18n.global.arena_reward_season_info.string, color = ccc3(93, 45, 18), width = 682, align = kCCTextAlignmentLeft})
  showText:setAnchorPoint(ccp(0, 0))
  showText:setPosition(17, height + 4)
  scroll:getContainer():addChild(showText)
  local rankIdx = 1
  for i,v in ipairs(cfgSeason) do
    if v.rank < arenaData.rank then
      rankIdx = i + 1
    end
  end
  local str = nil
  if rankIdx == 1 or cfgSeason[rankIdx].rank == cfgSeason[rankIdx - 1].rank + 1 then
    str = string.format(i18n.global.arena_reward_end_rank1.string, cfgSeason[rankIdx].rank)
  else
    str = string.format(i18n.global.arena_reward_end_rank2.string, cfgSeason[rankIdx - 1].rank, cfgSeason[rankIdx].rank)
  end
  local showRank = lbl.createMixFont2(14, str)
  showRank:setAnchorPoint(ccp(0, 0))
  showRank:setPosition(17, showText:boundingBox():getMaxY() + 2)
  scroll:getContainer():addChild(showRank)
  scroll:setContentSize(CCSize(682, showRank:boundingBox():getMaxY() + 10))
  scroll:setContentOffset(ccp(0, 340 - scroll:getContentSize().height))
  local lasty = nil
  local onTouchBegin = function(l_1_0, l_1_1)
    lasty = l_1_1
    return true
   end
  local onTouchMoved = function(l_2_0, l_2_1)
    return true
   end
  local onTouchEnd = function(l_3_0, l_3_1)
    local pointOnBoard = layer:convertToNodeSpace(ccp(l_3_0, l_3_1))
    if math.abs(l_3_1 - lasty) > 10 or not scroll:boundingBox():containsPoint(pointOnBoard) then
      return true
    end
    local point = scroll:getContainer():convertToNodeSpace(ccp(l_3_0, l_3_1))
    for i,v in ipairs(showItems) do
      if v:boundingBox():containsPoint(point) then
        local tips = nil
        if v.Info.type == 1 then
          tips = require("ui.tips.item").createForShow(v.Info)
        else
          tips = require("ui.tips.equip").createById(v.Info.id)
        end
        superlayer:addChild(tips)
      end
    end
    return true
   end
  local onTouch = function(l_4_0, l_4_1, l_4_2)
    if l_4_0 == "began" then
      return onTouchBegin(l_4_1, l_4_2)
    elseif l_4_0 == "moved" then
      return onTouchMoved(l_4_1, l_4_2)
    else
      return onTouchEnd(l_4_1, l_4_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  return layer
end

ui.create = function()
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  superlayer = layer
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(726, 510))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local showTitle = lbl.createFont1(26, i18n.global.arena_reward_title.string, ccc3(230, 208, 174))
  showTitle:setPosition(board:getContentSize().width / 2, 481)
  board:addChild(showTitle, 1)
  local showTitleShade = lbl.createFont1(26, i18n.global.arena_reward_title.string, ccc3(89, 48, 27))
  showTitleShade:setPosition(board:getContentSize().width / 2, 479)
  board:addChild(showTitleShade)
  local tabConfig = {1 = {icon0 = img.ui.arena_daily_btn0, icon1 = img.ui.arena_daily_btn1, text = i18n.global.arena_reward_daily_text.string, func = createDailyRewards}, 2 = {icon0 = img.ui.arena_season_btn0, icon1 = img.ui.arena_season_btn1, text = i18n.global.arena_reward_season_text.string, func = createSeasonRewards}}
  local showRewardBg = img.createUI9Sprite(img.ui.inner_bg)
  showRewardBg:setPreferredSize(CCSize(682, 341))
  showRewardBg:setAnchorPoint(ccp(0, 0))
  showRewardBg:setPosition(22, 27)
  board:addChild(showRewardBg)
  local btnList = {}
  for i,v in ipairs(tabConfig) do
    do
      local btnListSp0 = img.createUISprite(v.icon0)
      local btnListSp1 = img.createUISprite(v.icon1)
      btnList[i] = CCMenuItemSprite:create(btnListSp0, btnListSp1)
      local menu = CCMenu:createWithItem(btnList[i])
      btnList[i]:setAnchorPoint(ccp(0, 0))
      btnList[i]:setPosition(105 + 270 * (i - 1), 371)
      menu:setPosition(0, 0)
      board:addChild(menu)
      local showTitle = lbl.createFont1(16, v.text, lbl.buttonColor)
      showTitle:setPosition(160, btnList[i]:getContentSize().height / 2 + 2)
      btnList[i]:addChild(showTitle)
      btnList[i]:registerScriptTapHandler(function()
        audio.play(audio.button)
        for j,k in ipairs(btnList) do
          k:setEnabled(true)
          k:unselected()
        end
        btnList[i]:setEnabled(false)
        btnList[i]:selected()
        if showRewardBg:getChildByTag(1) then
          showRewardBg:removeChildByTag(1)
        end
        showRewardBg:addChild(v.func(showRewardBg), 1, 1)
         end)
    end
  end
  btnList[1]:setEnabled(false)
  btnList[1]:selected()
  showRewardBg:addChild(tabConfig[1].func(showRewardBg), 1, 1)
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(702, 483)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_6_0)
    if l_6_0 == "enter" then
      onEnter()
    elseif l_6_0 == "exit" then
      onExit()
    end
   end)
  layer:registerScriptTouchHandler(function()
    return true
   end)
  layer:setTouchEnabled(true)
  board:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  anim_arr:addObject(CCDelayTime:create(0.15))
  anim_arr:addObject(CCCallFunc:create(function()
   end))
  board:runAction(CCSequence:create(anim_arr))
  return layer
end

return ui

