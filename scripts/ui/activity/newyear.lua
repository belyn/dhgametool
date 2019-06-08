-- Command line was: E:\github\dhgametool\scripts\ui\activity\newyear.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.activity")
local cfggift = require("config.gift")
local player = require("data.player")
local activityData = require("data.activity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local particle = require("res.particle")
local bagData = require("data.bag")
local helper = require("fight.helper.fx")
local IDS = activityData.IDS
local act_ids = {IDS.NEWYEAR.ID}
local MONSID = 1609
local ITEMID = 183
local showReward = function()
  local tipslayer = CCLayer:create()
  local tipsbg = img.createUI9Sprite(img.ui.tips_bg)
  tipsbg:setPreferredSize(CCSize(536, 205))
  tipsbg:setScale(view.minScale)
  tipsbg:setPosition(view.physical.w / 2, view.physical.h / 2)
  tipslayer:addChild(tipsbg)
  local tipstitle = lbl.createFont1(18, i18n.global.newyear_randomreward.string, ccc3(255, 228, 156))
  tipstitle:setPosition(268, 175)
  tipsbg:addChild(tipstitle)
  local line = img.createUISprite(img.ui.help_line)
  line:setScaleX(470 / line:getContentSize().width)
  line:setPosition(CCPoint(268, 150))
  tipsbg:addChild(line)
  local plusIcon = img.createUISprite(img.ui.herotask_add_icon)
  plusIcon:setPosition(226, 82)
  tipsbg:addChild(plusIcon)
  local giftPer = {25, 40, 35}
  tipslayer.tipsTag = false
  for i = 1,  cfgactivity[IDS.NEWYEAR.ID].rewards do
    do
      if cfgactivity[IDS.NEWYEAR.ID].rewards[i].type == 3 then
        local giftId = cfgactivity[IDS.NEWYEAR.ID].rewards[i].id
        do
          for ii = 1,  cfggift[giftId].randomGoods do
            do
              local item = img.createItem(cfggift[giftId].randomGoods[ii].id, cfggift[giftId].randomGoods[ii].num)
              local itembtn = SpineMenuItem:create(json.ui.button, item)
              itembtn:setScale(0.9)
              itembtn:setPosition(tipsbg:getContentSize().width / 2 - 195 + (i + ii - 2) * 86 + 48, 82)
              local iconMenu = CCMenu:createWithItem(itembtn)
              iconMenu:setPosition(0, 0)
              tipsbg:addChild(iconMenu)
              local labelPer = lbl.createFont1(16, string.format("%d%%", giftPer[ii]), ccc3(255, 246, 243))
              labelPer:setPosition(tipsbg:getContentSize().width / 2 - 195 + (i + ii - 2) * 86 + 48, 30)
              tipsbg:addChild(labelPer)
              itembtn:registerScriptTapHandler(function()
                audio.play(audio.button)
                if tipslayer.tipsTag == false then
                  tipslayer.tipsTag = true
                  local tipsitem = require("ui.tips.item")
                  tips = tipsitem.createForShow({id = cfggift[giftId].randomGoods[ii].id, num = cfggift[giftId].randomGoods[ii].num})
                  tipslayer:addChild(tips, 200)
                  tips.setClickBlankHandler(function()
                    tips:removeFromParent()
                    tipslayer.tipsTag = false
                           end)
                end
                     end)
            end
          end
        end
      else
        local item = img.createItem(cfgactivity[IDS.NEWYEAR.ID].rewards[i].id, cfgactivity[IDS.NEWYEAR.ID].rewards[i].num)
        local itembtn = SpineMenuItem:create(json.ui.button, item)
        itembtn:setScale(0.9)
        itembtn:setPosition(tipsbg:getContentSize().width / 2 - 195 + (i - 1) * 86, 82)
        local iconMenu = CCMenu:createWithItem(itembtn)
        iconMenu:setPosition(0, 0)
        tipsbg:addChild(iconMenu)
        itembtn:registerScriptTapHandler(function()
          audio.play(audio.button)
          if tipslayer.tipsTag == false then
            tipslayer.tipsTag = true
            local tipsitem = require("ui.tips.item")
            tips = tipsitem.createForShow({id = cfgactivity[IDS.NEWYEAR.ID].rewards[i].id, num = cfgactivity[IDS.NEWYEAR.ID].rewards[i].num})
            tipslayer:addChild(tips, 200)
            tips.setClickBlankHandler(function()
              tips:removeFromParent()
              tipslayer.tipsTag = false
                  end)
          end
            end)
      end
    end
  end
  local clickBlankHandler = nil
  tipslayer.setClickBlankHandler = function(l_3_0)
    clickBlankHandler = l_3_0
   end
  tipslayer.setClickBlankHandler(function()
    tipslayer:removeFromParent()
   end)
  local onTouch = function(l_5_0, l_5_1, l_5_2)
    if l_5_0 == "began" then
      return true
    elseif l_5_0 == "moved" then
      return 
    else
      if not tipsbg:boundingBox():containsPoint(ccp(l_5_1, l_5_2)) then
        tipslayer.onAndroidBack()
      end
    end
   end
  addBackEvent(tipslayer)
  tipslayer.onAndroidBack = function()
    if clickBlankHandler then
      clickBlankHandler()
    else
      tipslayer:removeFromParent()
    end
   end
  tipslayer:setTouchEnabled(true)
  tipslayer:setTouchSwallowEnabled(true)
  tipslayer:registerScriptTouchHandler(onTouch)
  return tipslayer
end

ui.create = function()
  local layer = CCLayer:create()
  local act = activityData.getStatusById(IDS.NEWYEAR.ID)
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(570, 438))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(352, 57))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local link_url = nil
  local btnFlag = false
  local titleBg = img.createUISprite(img.ui.activity_newyear_bg)
  titleBg:setPosition(CCPoint(board_w / 2, board_h / 2))
  board:addChild(titleBg, 100)
  json.load(json.ui.wanshengjie_bg)
  local banner = DHSkeletonAnimation:createWithKey(json.ui.wanshengjie_bg)
  banner:scheduleUpdateLua()
  banner:playAnimation("animation", -1)
  banner:setPosition(CCPoint(board_w / 2, board_h / 2))
  board:addChild(banner, 100)
  local btn_reward0 = img.createUISprite(img.ui.reward)
  local btn_reward = SpineMenuItem:create(json.ui.button, btn_reward0)
  btn_reward:setPosition(CCPoint(488, board_h - 32))
  local btn_reward_menu = CCMenu:createWithItem(btn_reward)
  btn_reward_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_reward_menu, 100)
  btn_reward:registerScriptTapHandler(function()
    audio.play(audio.button)
    local tipslayer = showReward()
    layer:getParent():getParent():addChild(tipslayer, 1001)
   end)
  local btnInfoSprite = img.createUISprite(img.ui.btn_help)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  btnInfo:setPosition(534, board_h - 32)
  local menuInfo = CCMenu:createWithItem(btnInfo)
  menuInfo:setPosition(0, 0)
  board:addChild(menuInfo, 100)
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:getParent():getParent():addChild(require("ui.help").create(i18n.global.newyear_help.string, i18n.global.help_title.string), 1000)
   end)
  local scrollUI = require("ui.pet.scrollUI")
  local Scroll = scrollUI.create()
  Scroll:setDirection(kCCScrollViewDirectionHorizontal)
  Scroll:setPosition(-8, 0)
  Scroll:setTouchEnabled(false)
  Scroll:setViewSize(CCSize(board_w, board_h))
  Scroll:setContentSize(CCSize(board_w, board_h))
  board:addChild(Scroll, 1001)
  local titleBg = img.createUISprite(img.ui.activity_newyear_titlebg)
  titleBg:setAnchorPoint(CCPoint(0.5, 1))
  titleBg:setPosition(CCPoint(board_w / 2, board_h - 1))
  board:addChild(titleBg, 100)
  local titleLab = lbl.createFont2(18, i18n.global.activity_des_hallowmas_sugar.string, ccc3(246, 214, 108))
  titleLab:setPosition(CCPoint(board_w / 2, board_h - 18))
  board:addChild(titleLab, 100)
  local bloodBar = img.createUI9Sprite(img.ui.activity_newyear_barbg)
  bloodBar:setPreferredSize(CCSize(322, 24))
  bloodBar:setPosition(board_w / 2, 368)
  board:addChild(bloodBar, 101)
  local progress0 = img.createUISprite(img.ui.activity_newyear_bar)
  local bloodProgress = createProgressBar(progress0)
  bloodProgress:setPosition(bloodBar:getContentSize().width / 2, bloodBar:getContentSize().height / 2)
  bloodProgress:setPercentage(act.limits)
  bloodBar:addChild(bloodProgress)
  local progressStr = string.format("%d%%", act.limits)
  local progressLabel = lbl.createFont2(16, progressStr, ccc3(255, 246, 223))
  progressLabel:setPosition(CCPoint(161, bloodBar:getContentSize().height / 2 + 5))
  bloodBar:addChild(progressLabel)
  json.loadUnit(MONSID)
  local monster = DHSkeletonAnimation:createWithKey(json.unit[MONSID])
  monster:scheduleUpdateLua()
  monster:playAnimation("stand", -1)
  monster:setPosition(board_w / 2, 40)
  board:addChild(monster, 100)
  local itemObj1 = bagData.items.find(109)
  if not itemObj1 then
    itemObj1 = {id = 109, num = 0}
  end
  local itemObj2 = bagData.items.find(ITEMID)
  if not itemObj2 then
    itemObj2 = {id = ITEMID, num = 0}
  end
  local icon1Bg = img.createUISprite(img.ui.hero_skill_bg)
  local icon1 = img.createItemIcon(109)
  icon1:setPosition(icon1Bg:getContentSize().width / 2, icon1Bg:getContentSize().height / 2)
  icon1Bg:addChild(icon1)
  local num1 = string.format("%d", itemObj1.num)
  local label1 = lbl.createFont2(16, num1)
  label1:setPosition(CCPoint(icon1Bg:getContentSize().width - 20, 10))
  icon1Bg:addChild(label1)
  local btn1 = SpineMenuItem:create(json.ui.button, icon1Bg)
  btn1:setScale(0.84)
  btn1:setPosition(CCPoint(board_w / 2 - 150, 58))
  local btn1_menu = CCMenu:createWithItem(btn1)
  btn1_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn1_menu, 100)
  btn1:setVisible(false)
  local icon2Bg = img.createUISprite(img.ui.hero_skill_bg)
  local icon2 = img.createItemIcon(ITEMID)
  icon2:setPosition(icon2Bg:getContentSize().width / 2, icon2Bg:getContentSize().height / 2)
  icon2Bg:addChild(icon2)
  local num2 = string.format("%d", itemObj2.num)
  local label2 = lbl.createFont2(16, num2)
  label2:setPosition(CCPoint(icon2Bg:getContentSize().width / 2, 10))
  icon2Bg:addChild(label2)
  local btn2 = SpineMenuItem:create(json.ui.button, icon2Bg)
  btn2:setScale(0.84)
  btn2:setPosition(CCPoint(board_w / 2, 58))
  local btn2_menu = CCMenu:createWithItem(btn2)
  btn2_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn2_menu, 100)
  btn1:registerScriptTapHandler(function()
    disableObjAWhile(btn1, 0.2)
    audio.play(audio.fire_1)
    if itemObj1.num <= 0 then
      showToast(i18n.global.hallowmas_sugar_no.string)
      return 
    end
    local param = {sid = player.sid, id = act.id, key = 109}
    addWaitNet()
    netClient:beat_nien(param, function(l_1_0)
      tbl2string(l_1_0)
      delWaitNet()
      if l_1_0.status ~= 0 then
        showToast(i18n.global.hallowmas_sugar_no.string)
        return 
      end
      itemObj1.num = itemObj1.num - 1
      act.limits = act.limits - 1
      local rx = math.random(-70, 70)
      local ry = math.random(-80, 50)
      local explosion = particle.create("explosionA")
      explosion:setPosition(CCPoint(board_w / 2 + rx, board_h / 2 + ry))
      board:addChild(explosion, 1001)
      bloodProgress:setPercentage(act.limits)
      local numNode = helper.createDamageNumber({}, {value = -888888})
      local anim = json.create(json.ui.bt_numbers)
      anim:setVisible(false)
      local animationName = "normal"
      anim:setPosition(CCPoint(board_w / 2, board_h / 2 + 20))
      anim:addChildFollowSlot("code_normal", numNode)
      board:addChild(anim, 1001)
      local duration = anim:getAnimationTime(animationName)
      anim:runAction(createSequence({}))
       -- DECOMPILER ERROR: Overwrote pending register.

      label1:setString(string.format("%d", CCDelayTime:create(0).num))
      if act.limits <= 0 then
        bloodProgress:setPercentage(0)
        progressLabel:setString(string.format("%d%%", 0))
        monster:playAnimation("dead")
        local ban = CCLayer:create()
        do
          ban:setTouchEnabled(true)
          ban:setTouchSwallowEnabled(true)
          board:addChild(ban, 1000)
          schedule(board, 0.5, function()
            monster:runAction(CCFadeOut:create(0.5))
            board:runAction(createSequence({}))
             -- Warning: undefined locals caused missing assignments!
               end)
        end
      else
        monster:playAnimation("hurt")
        monster:appendNextAnimation("stand", -1)
        bloodProgress:setPercentage(act.limits)
        progressLabel:setString(string.format("%d%%", act.limits))
      end
       -- Warning: undefined locals caused missing assignments!
      end)
   end)
  btn2:registerScriptTapHandler(function()
    disableObjAWhile(btn2, 0.2)
    audio.play("skill/shandianshu")
    if itemObj2.num <= 0 then
      showToast(i18n.global.hallowmas_sugar_no.string)
      return 
    end
    local param = {sid = player.sid, id = act.id, key = ITEMID}
    addWaitNet()
    netClient:beat_nien(param, function(l_1_0)
      tbl2string(l_1_0)
      delWaitNet()
      if l_1_0.status ~= 0 then
        showToast(i18n.global.hallowmas_sugar_no.string)
        return 
      end
      itemObj2.num = itemObj2.num - 1
      if act.limits <= 5 then
        act.limits = 0
      else
        act.limits = act.limits - 5
      end
      local rx = math.random(-70, 70)
      local ry = math.random(-80, 30)
      local rs = math.random(600, 800)
      json.load(json.ui.wanshengjie_boss)
      local bannerboss = DHSkeletonAnimation:createWithKey(json.ui.wanshengjie_boss)
      bannerboss:scheduleUpdateLua()
      bannerboss:playAnimation("animation")
      bannerboss:setPosition(CCPoint(board_w / 2 + rx, board_h / 2 + ry))
      bannerboss:setScale(rs / 1000)
      board:addChild(bannerboss, 100)
      local numNode = helper.createDamageNumber({}, {crit = true, value = -500000})
      local anim = json.create(json.ui.bt_numbers)
      anim:setVisible(false)
      anim:setPosition(CCPoint(board_w / 2, board_h / 2 + 40))
      local animationName = "baoji"
      anim:addChildFollowSlot("code_baoji", numNode)
      board:addChild(anim, 1001)
      local duration = anim:getAnimationTime(animationName)
      anim:runAction(createSequence({}))
       -- DECOMPILER ERROR: Overwrote pending register.

      label2:setString(string.format("%d", CCDelayTime:create(0).num))
      if act.limits <= 0 then
        bloodProgress:setPercentage(0)
        progressLabel:setString(string.format("%d%%", 0))
        monster:playAnimation("dead")
        local ban = CCLayer:create()
        do
          ban:setTouchEnabled(true)
          ban:setTouchSwallowEnabled(true)
          board:addChild(ban, 1000)
          schedule(board, 0.5, function()
            monster:runAction(CCFadeOut:create(0.5))
            board:runAction(createSequence({}))
             -- Warning: undefined locals caused missing assignments!
               end)
        end
      else
        monster:playAnimation("hurt")
        monster:appendNextAnimation("stand", -1)
        bloodProgress:setPercentage(act.limits)
        progressLabel:setString(string.format("%d%%", act.limits))
      end
       -- Warning: undefined locals caused missing assignments!
      end)
   end)
  return layer
end

return ui

