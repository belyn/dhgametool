-- Command line was: E:\github\dhgametool\scripts\ui\frdarena\rewards.lua 

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
local arenaData = require("data.arena")
local frdarena = (require("data.frdarena"))
local superlayer = nil
local createSeasonRewards = function()
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
  for i = 1, #cfgSeasons do
    if cfgSeasons[i].arenaId == 4 then
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
    showRank:setPosition(58, 40)
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
      showItem:setPosition(132 + 64 * (j - 1), taskBg:getPositionY() + 12)
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
  local rankIdx, str = nil, nil
  if frdarena.team == nil then
    str = string.format(i18n.global.frdpvp_norank.string)
  else
    if frdarena.team.rank then
      rankIdx = 1
      for i,v in ipairs(cfgSeason) do
        if frdarena.team.rank and v.rank < frdarena.team.rank and i <= 11 then
          rankIdx = i + 1
        end
      end
      if rankIdx == 1 or cfgSeason[rankIdx].rank == cfgSeason[rankIdx - 1].rank + 1 then
        str = string.format(i18n.global.arena_reward_end_rank1.string, cfgSeason[rankIdx].rank)
      else
        str = string.format(i18n.global.arena_reward_end_rank2.string, cfgSeason[rankIdx - 1].rank, cfgSeason[rankIdx].rank)
      end
    else
      rankIdx = #cfgSeason
      str = string.format(i18n.global.frdpvp_norank.string)
    end
  end
  local showRank = lbl.createMixFont2(14, str)
  showRank:setAnchorPoint(ccp(0, 0))
  showRank:setPosition(17, showText:boundingBox():getMaxY() + 2)
  scroll:getContainer():addChild(showRank)
  scroll:setContentSize(CCSize(682, showRank:boundingBox():getMaxY() + 10))
  scroll:setContentOffset(ccp(0, 405 - scroll:getContentSize().height))
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
  local showRewardBg = img.createUI9Sprite(img.ui.inner_bg)
  showRewardBg:setPreferredSize(CCSize(682, 412))
  showRewardBg:setAnchorPoint(ccp(0, 0))
  showRewardBg:setPosition(22, 27)
  board:addChild(showRewardBg)
  showRewardBg:addChild(createSeasonRewards(), 1, 1)
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
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  anim_arr:addObject(CCDelayTime:create(0.15))
  anim_arr:addObject(CCCallFunc:create(function()
   end))
  board:runAction(CCSequence:create(anim_arr))
  return layer
end

return ui

