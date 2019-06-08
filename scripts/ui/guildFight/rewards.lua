-- Command line was: E:\github\dhgametool\scripts\ui\guildFight\rewards.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local cfgSeasons = (require("config.guildwar"))
local superlayer = nil
local createSeasonRewards = function(l_1_0, l_1_1, l_1_2)
  local layer = CCLayer:create()
  local height = 0
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(0, 1)
  scroll:setViewSize(CCSize(682, 405))
  scroll:setContentSize(CCSize(682, 0))
  layer:addChild(scroll)
  local showItems = {}
  local cfgSeason = {}
  do
    for i = 1,  cfgSeasons do
      if cfgSeasons[i].type == 1 then
        cfgSeason[ cfgSeason + 1] = cfgSeasons[i]
      end
    end
  end
  for i = 1,  cfgSeason do
    local idx =  cfgSeason - i + 1
    local taskBg = img.createUI9Sprite(img.ui.botton_fram_2)
    taskBg:setPreferredSize(CCSize(650, 84))
    taskBg:setAnchorPoint(ccp(0.5, 0))
    taskBg:setPosition(341, i * 84 - 80)
    scroll:getContainer():addChild(taskBg)
    local showRank = nil
    if cfgSeason[idx].rank[1] <= 3 then
      showRank = img.createUISprite(img.ui.arena_rank_" .. cfgSeason[idx].rank[1)
    else
      if cfgSeason[idx].rank[1] == cfgSeason[idx].rank[2] then
        showRank = lbl.createMixFont1(20, cfgSeason[idx].rank[1], ccc3(130, 90, 61))
      else
        if cfgSeason[idx].rank[2] >= 99999 then
          showRank = lbl.createMixFont1(16, cfgSeason[idx].rank[1] .. "+", ccc3(130, 90, 61))
        else
          showRank = lbl.createMixFont1(16, cfgSeason[idx].rank[1] .. "-" .. cfgSeason[idx].rank[2], ccc3(130, 90, 61))
        end
      end
    end
    showRank:setPosition(70, 40)
    taskBg:addChild(showRank)
    for j,v in ipairs(cfgSeason[idx].rewards) do
      local showItem = nil
      if v.type == 3 then
        v = {id = 18, num = v.num, type = 1}
      end
      if v.type == 1 then
        showItem = img.createItem(v.id, v.num)
      else
        showItem = img.createEquip(v.id)
      end
      showItem:setScale(0.7)
      showItem:setAnchorPoint(ccp(0, 0))
      showItem:setPosition(118 + 64 * j, taskBg:getPositionY() + 14)
      scroll:getContainer():addChild(showItem)
      showItems[ showItems + 1] = showItem
      showItems[ showItems].Info = v
    end
    height = taskBg:boundingBox():getMaxY()
  end
  local showText = lbl.createMix({font = 1, size = 14, text = i18n.global.arena_reward_season_info.string, color = ccc3(93, 45, 18), width = 682, align = kCCTextAlignmentLeft})
  showText:setAnchorPoint(ccp(0, 0))
  showText:setPosition(17, height + 4)
  scroll:getContainer():addChild(showText)
  if l_1_0 then
    local rankIdx = nil
    for idx,value in ipairs(cfgSeason) do
      if value.rank[1] <= l_1_0 and l_1_0 <= value.rank[2] then
        rankIdx = idx
    else
      end
    end
    if rankIdx then
      local str = nil
      if cfgSeason[rankIdx].rank[1] == cfgSeason[rankIdx].rank[2] then
        str = string.format(i18n.global.arena_reward_end_rank1.string, cfgSeason[rankIdx].rank[1])
      else
        str = string.format(i18n.global.arena_reward_end_rank2.string, cfgSeason[rankIdx].rank[1], cfgSeason[rankIdx].rank[2])
      end
      local showRank = lbl.createFont2(16, str, ccc3(255, 246, 223))
      showRank:setAnchorPoint(ccp(0, 0))
      showRank:setPosition(17, showText:boundingBox():getMaxY() + 24)
      scroll:getContainer():addChild(showRank)
      local showCdLab = lbl.createMixFont1(14, i18n.global.gwar_cd_reward.string, ccc3(93, 45, 18))
      showCdLab:setAnchorPoint(ccp(0, 0.5))
      showCdLab:setPosition(17, showText:boundingBox():getMaxY() + 12)
      scroll:getContainer():addChild(showCdLab)
      local timeLab = string.format("%02d:%02d:%02d", math.floor(0), math.floor(0), math.floor(0))
      local showTimeLab = lbl.createFont2(14, timeLab, ccc3(165, 253, 71))
      showTimeLab:setAnchorPoint(0, 0.5)
      showTimeLab:setPosition(showCdLab:boundingBox():getMaxX() + 2, showText:boundingBox():getMaxY() + 12)
      scroll:getContainer():addChild(showTimeLab)
      showTimeLab:setVisible(false)
      local onUpdate = function(l_1_0)
        if cd then
          lcd = math.max(0, cd + pull_time - os.time())
          if lcd > 0 then
            upvalue_1024 = string.format("%02d:%02d:%02d", math.floor(lcd / 3600), math.floor(lcd % 3600 / 60), math.floor(lcd % 60))
            showTimeLab:setString(timeLab)
            showTimeLab:setVisible(true)
          else
            showTimeLab:setVisible(false)
          end
        end
         end
      layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
      scroll:setContentSize(CCSize(682, showRank:boundingBox():getMaxY() + 10))
    else
      scroll:setContentSize(CCSize(682, showText:boundingBox():getMaxY() + 2 + 10))
    end
  else
    scroll:setContentSize(CCSize(682, showText:boundingBox():getMaxY() + 2 + 10))
  end
  scroll:setContentOffset(ccp(0, 405 - scroll:getContentSize().height))
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
        if v.Info.type == 3 then
          v.Info = {type = 1, id = 18, num = 1}
        end
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

ui.create = function(l_2_0, l_2_1, l_2_2, l_2_3)
  if l_2_1 == 1 then
    l_2_2 = l_2_2 + 57600
  end
  if l_2_1 == 3 or l_2_1 == 4 then
    l_2_2 = 0
  end
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  superlayer = layer
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(726, 510))
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local showTitle = lbl.createFont1(26, i18n.global.arena_reward_title.string, ccc3(230, 208, 174))
  showTitle:setPosition(board:getContentSize().width / 2, 481)
  board:addChild(showTitle, 1)
  local showTitleShade = lbl.createFont1(26, i18n.global.arena_reward_title.string, ccc3(89, 48, 27))
  showTitleShade:setPosition(board:getContentSize().width / 2, 479)
  board:addChild(showTitleShade)
  local showRewardBg = img.createUI9Sprite(img.ui.inner_bg)
  showRewardBg:setPreferredSize(CCSize(682, 409))
  showRewardBg:setAnchorPoint(ccp(0, 0))
  showRewardBg:setPosition(22, 27)
  board:addChild(showRewardBg)
  showRewardBg:addChild(createSeasonRewards(l_2_0, l_2_2, l_2_3), 100)
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
  layer:registerScriptHandler(function(l_5_0)
    if l_5_0 == "enter" then
      onEnter()
    elseif l_5_0 == "exit" then
      onExit()
    end
   end)
  layer:registerScriptTouchHandler(function()
    return true
   end)
  layer:setTouchEnabled(true)
  board:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, view.minScale))
  anim_arr:addObject(CCDelayTime:create(0.15))
  anim_arr:addObject(CCCallFunc:create(function()
   end))
  board:runAction(CCSequence:create(anim_arr))
  return layer
end

return ui

