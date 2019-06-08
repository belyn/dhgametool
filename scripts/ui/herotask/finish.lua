-- Command line was: E:\github\dhgametool\scripts\ui\herotask\finish.lua 

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
local cfgtask = require("config.herotask")
local cfgequip = require("config.equip")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local htaskData = require("data.herotask")
local achieveData = require("data.achieve")
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  darkbg:setScale(2)
  layer:addChild(darkbg)
  local showReward = {}
  local showHero = {}
  local showPowerBg = CCSprite:create()
  showPowerBg:setContentSize(CCSize(960, 576))
  showPowerBg:setPosition(480, 288)
  layer:addChild(showPowerBg)
  showPowerBg:setScale(0.5)
  showPowerBg:runAction(CCScaleTo:create(0.15, 1, 1))
  local lbg = img.createUISprite(img.ui.herotask_dialog)
  lbg:setAnchorPoint(1, 0.5)
  lbg:setPosition(480, 288)
  showPowerBg:addChild(lbg)
  local rbg = img.createUISprite(img.ui.herotask_dialog)
  rbg:setFlipX(true)
  rbg:setAnchorPoint(0, 0.5)
  rbg:setPosition(479, 288)
  showPowerBg:addChild(rbg)
  local board = img.createUI9Sprite(img.ui.select_hero_camp_bg)
  board:setPreferredSize(CCSize(656, 268))
  board:setAnchorPoint(ccp(0, 0))
  board:setPosition(152, 228)
  showPowerBg:addChild(board)
  local powerBg = img.createUI9Sprite(img.ui.select_tab_tab_bg)
  powerBg:setPreferredSize(CCSize(646, 38))
  powerBg:setAnchorPoint(ccp(0, 0))
  powerBg:setPosition(158, 455)
  showPowerBg:addChild(powerBg)
  local showTime = lbl.createFont2(16, time2string(math.max(0, l_1_0.cd - os.time())), ccc3(182, 255, 68))
  showTime:setAnchorPoint(ccp(1, 0.5))
  showTime:setPosition(110, 19)
  powerBg:addChild(showTime)
  json.load(json.ui.clock)
  local timeIcon = DHSkeletonAnimation:createWithKey(json.ui.clock)
  timeIcon:scheduleUpdateLua()
  timeIcon:playAnimation("animation", -1)
  timeIcon:setAnchorPoint(ccp(1, 0.5))
  timeIcon:setPosition(showTime:boundingBox():getMinX() - 20, 19)
  powerBg:addChild(timeIcon)
  local reward = conquset2items(l_1_0.reward)
  local offsetX = 480 - 46 *  reward + 9
  for i,v in ipairs(reward) do
    do
      local showRewardSprite = nil
      if v.type == 1 then
        showRewardSprite = img.createItem(v.id, v.num)
      else
        showRewardSprite = img.createEquip(v.id, v.num)
      end
      showReward[i] = CCMenuItemSprite:create(showRewardSprite, nil)
      local menuReward = CCMenu:createWithItem(showReward[i])
      menuReward:setPosition(0, 0)
      showPowerBg:addChild(menuReward)
      showReward[i]:setAnchorPoint(ccp(0, 0))
      showReward[i]:setScale(0.80434782608696)
      showReward[i]:setPosition(offsetX + (i - 1) * 92, 127)
      showReward[i]:registerScriptTapHandler(function()
        local superlayer = layer:getParent():getParent():getParent()
        if v.type == 1 then
          local tips = require("ui.tips.item").createForShow(v)
          superlayer:addChild(tips, 10000)
        else
          local tips = require("ui.tips.equip").createById(v.id)
          superlayer:addChild(tips, 10000)
        end
         end)
    end
  end
  offsetX = 480 - 50 * cfgtask[l_1_0.id].heroNum + 9
  local heroes = l_1_0.heroes
  for i = 1,  heroes do
    local param = {id = heroes[i].id, lv = heroes[i].lv, showGroup = true, showStar = heroes.star, wake = heroes[i].wake, orangeFx = nil, petID = nil, hid = heroes[i].hid}
    showHero[i] = img.createHeroHeadByParam(param)
    showHero[i]:setAnchorPoint(ccp(0, 0))
    showHero[i]:setScale(0.8936170212766)
    showHero[i]:setPosition(offsetX + (i - 1) * 100, 323)
    showPowerBg:addChild(showHero[i])
  end
  local offsetX = 480 - 26 *  l_1_0.conds + 5
  local condition = {}
  for i,v in ipairs(l_1_0.conds) do
    condition[i] = img.createUISprite(img.ui.hook_rate_bg)
    condition[i]:setScale(0.8)
    condition[i]:setAnchorPoint(ccp(0, 0))
    condition[i]:setPosition(offsetX + 52 * (i - 1), 238)
    showPowerBg:addChild(condition[i])
    do
      if v.type == 1 then
        local showJob = img.createUISprite(img.ui.herotask_job_" .. v.factio)
        showJob:setPosition(condition[i]:getContentSize().width / 2, condition[i]:getContentSize().height / 2)
        condition[i]:addChild(showJob)
      end
      for i,v in (for generator) do
      end
      if v.type == 2 then
        local showStar = img.createUISprite(img.ui.star)
        showStar:setScale(0.95)
        showStar:setPosition(condition[i]:getContentSize().width / 2, condition[i]:getContentSize().height / 2)
        condition[i]:addChild(showStar)
        do
          local showNum = lbl.createFont2(18, v.faction)
          showNum:setPosition(condition[i]:getContentSize().width / 2, condition[i]:getContentSize().height / 2)
          condition[i]:addChild(showNum)
        end
        for i,v in (for generator) do
        end
        do
          if v.type == 3 then
            local showGroup = img.createUISprite(img.ui.herolist_group_" .. v.factio)
            showGroup:setPosition(condition[i]:getContentSize().width / 2, condition[i]:getContentSize().height / 2)
            condition[i]:addChild(showGroup)
          end
          for i,v in (for generator) do
          end
          if v.type == 4 then
            local showQlt = img.createUISprite(img.ui.evolve)
            showQlt:setScale(0.7)
            showQlt:setPosition(condition[i]:getContentSize().width / 2, condition[i]:getContentSize().height / 2)
            condition[i]:addChild(showQlt)
            local showNum = lbl.createFont2(18, v.faction)
            showNum:setPosition(condition[i]:getContentSize().width / 2, condition[i]:getContentSize().height / 2)
            condition[i]:addChild(showNum)
          end
        end
        local titleCondition = lbl.createFont1(18, i18n.global.herotask_title_condition.string, ccc3(91, 39, 6))
        titleCondition:setPosition(480, 298)
        showPowerBg:addChild(titleCondition)
        local showLfgline = img.createUISprite(img.ui.herotask_fgline)
        showLfgline:setAnchorPoint(ccp(1, 0.5))
        showLfgline:setPosition(titleCondition:boundingBox():getMinX() - 30, titleCondition:boundingBox():getMidY())
        showPowerBg:addChild(showLfgline)
        local showRfgline = img.createUISprite(img.ui.herotask_fgline)
        showRfgline:setAnchorPoint(ccp(0, 0.5))
        showRfgline:setFlipX(true)
        showRfgline:setPosition(titleCondition:boundingBox():getMaxX() + 30, titleCondition:boundingBox():getMidY())
        showPowerBg:addChild(showRfgline)
        local backEvent = function()
          layer:removeFromParentAndCleanup()
            end
        local close0 = img.createUISprite(img.ui.close)
        local closeBtn = SpineMenuItem:create(json.ui.button, close0)
        closeBtn:setPosition(CCPoint(814, 525))
        local closeMenu = CCMenu:createWithItem(closeBtn)
        closeMenu:setPosition(CCPoint(0, 0))
        showPowerBg:addChild(closeMenu)
        closeBtn:registerScriptTapHandler(function()
          backEvent()
            end)
        layer.onAndroidBack = function()
          backEvent()
            end
        addBackEvent(layer)
        local onEnter = function()
          layer.notifyParentLock()
            end
        do
          local onExit = function()
          layer.notifyParentUnlock()
            end
          layer:registerScriptHandler(function(l_7_0)
          if l_7_0 == "enter" then
            onEnter()
          elseif l_7_0 == "exit" then
            onExit()
          end
            end)
          layer:setTouchEnabled(true)
          return layer
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return ui

