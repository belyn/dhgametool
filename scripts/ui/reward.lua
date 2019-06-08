-- Command line was: E:\github\dhgametool\scripts\ui\reward.lua 

local reward = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local lbl = require("res.lbl")
local i18n = require("res.i18n")
local audio = require("res.audio")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
reward.showRewardForbraveBox = function(l_1_0)
  local layer = (reward.createLayer())
  local title = nil
  if i18n.getCurrentLanguage() == kLanguageChinese then
    title = img.createUISprite(img.ui.language_reward_cn)
  else
    if i18n.getCurrentLanguage() == kLanguageEnglish then
      title = img.createUISprite(img.ui.language_reward_us)
    else
      title = lbl.createFont2(36, i18n.global.reward_will_get.string)
    end
  end
  layer.aniReward:addChildFollowSlot("code_reward_text", title)
  schedule(layer, 1, function()
    layer.confirmBtn:setVisible(true)
   end)
  json.load(json.ui.reward_particle)
  local aniRewardTitle = DHSkeletonAnimation:createWithKey(json.ui.reward_particle)
  aniRewardTitle:setScale(view.minScale)
  aniRewardTitle:scheduleUpdateLua()
  aniRewardTitle:playAnimation("play", -1)
  aniRewardTitle:setPosition(scalep(480, 288))
  layer:addChild(aniRewardTitle)
  local itemslayer = reward.showItems(l_1_0)
  layer:addChild(itemslayer, 1)
  return layer
end

reward.showRewardFortreasure = function(l_2_0)
  local layer = (reward.createLayer())
  local title = nil
  if i18n.getCurrentLanguage() == kLanguageChinese then
    title = img.createUISprite(img.ui.language_reward_cn)
  else
    if i18n.getCurrentLanguage() == kLanguageEnglish then
      title = img.createUISprite(img.ui.language_reward_us)
    else
      title = lbl.createFont2(36, i18n.global.reward_will_get.string)
    end
  end
  layer.aniReward:addChildFollowSlot("code_reward_text", title)
  schedule(layer, 1, function()
    layer.confirmBtn:setVisible(true)
   end)
  json.load(json.ui.reward_particle)
  local aniRewardTitle = DHSkeletonAnimation:createWithKey(json.ui.reward_particle)
  aniRewardTitle:setScale(view.minScale)
  aniRewardTitle:scheduleUpdateLua()
  aniRewardTitle:playAnimation("play", -1)
  aniRewardTitle:setPosition(scalep(480, 288))
  layer:addChild(aniRewardTitle)
  local pbbag = {}
  local equips = {}
  local items = {}
  pbbag.equips = equips
  equips[ equips + 1] = l_2_0
  local itemslayer = reward.showItems(pbbag)
  layer:addChild(itemslayer, 1)
  return layer
end

reward.showReward = function(l_3_0, l_3_1, l_3_2)
  local layer = (reward.createLayer())
  local title = nil
  if i18n.getCurrentLanguage() == kLanguageChinese then
    title = img.createUISprite(img.ui.language_reward_cn)
  else
    if i18n.getCurrentLanguage() == kLanguageEnglish then
      title = img.createUISprite(img.ui.language_reward_us)
    else
      title = lbl.createFont2(36, i18n.global.reward_will_get.string)
    end
  end
  layer.aniReward:addChildFollowSlot("code_reward_text", title)
  title:setPositionX(4)
  json.load(json.ui.reward_particle)
  local aniRewardTitle = DHSkeletonAnimation:createWithKey(json.ui.reward_particle)
  aniRewardTitle:setScale(view.minScale)
  aniRewardTitle:scheduleUpdateLua()
  aniRewardTitle:playAnimation("play", -1)
  aniRewardTitle:setPosition(scalep(480, 288))
  layer:addChild(aniRewardTitle)
  local itemslayer = reward.showItems(l_3_0)
  layer:addChild(itemslayer, 1)
  local allnum = 0
  if l_3_0.items then
    allnum = allnum +  l_3_0.items
  end
  if l_3_0.equips then
    allnum = allnum +  l_3_0.equips
  end
  local time = 0.6 + 0.3 * (allnum - 1)
  if l_3_1 then
    local times = i18n.global.casino_btn_10time.string
    if l_3_1 and l_3_1.count == 1 then
      times = i18n.global.casino_btn_1time.string
    end
    local casino1 = img.createUI9Sprite(img.ui.btn_1)
    casino1:setPreferredSize(CCSizeMake(172, 72))
    local casinoLab = lbl.createFont1(18, times, ccc3(115, 59, 5))
    casinoLab:setPosition(CCPoint(casino1:getContentSize().width / 2 + 20, casino1:getContentSize().height / 2 - 2))
    casino1:addChild(casinoLab)
    local casinoBtn = SpineMenuItem:create(json.ui.button, casino1)
    casinoBtn:setScale(view.minScale)
    casinoBtn:setPosition(scalep(610, 80))
    casinoBtn:setVisible(false)
    layer.casinoBtn = casinoBtn
    local casinoMenu = CCMenu:createWithItem(casinoBtn)
    casinoMenu:setPosition(0, 0)
    layer:addChild(casinoMenu)
    local costLab = lbl.createFont2(16, tostring(l_3_1.count), ccc3(255, 246, 223))
    costLab:setPosition(CCPoint(41, 28))
    casino1:addChild(costLab, 2)
    local icon1 = nil
    if l_3_2 then
      icon1 = img.createItemIcon(ITEM_ID_ADVANCED_CHIP)
    else
      icon1 = img.createItemIcon(ITEM_ID_CHIP)
    end
    icon1:setScale(0.5)
    icon1:setPosition(CCPoint(41, 36))
    casino1:addChild(icon1)
    casinoBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer:removeFromParentAndCleanup(true)
      param.callback()
      end)
    layer.confirmBtn:setPosition(scalep(350, 80))
  end
  schedule(layer, time, function()
    layer.confirmBtn:setVisible(true)
    if param then
      layer.casinoBtn:setVisible(true)
    end
   end)
  return layer
end

reward.showItems = function(l_4_0)
  local layer = CCLayer:create()
  local gridWidth = 102
  local getPosition = function(l_1_0, l_1_1)
    if l_1_1 <= 5 then
      y = 281
    elseif l_1_0 <= 5 then
      y = 331
    else
      y = 224
    end
    if l_1_1 % 5 == 0 then
      x = 278
    elseif l_1_1 % 5 == 4 then
      x = 278 + gridWidth / 2
    elseif l_1_1 % 5 == 3 then
      x = 278 + gridWidth
    elseif l_1_1 % 5 == 2 then
      x = 278 + gridWidth * 3 / 2
    elseif l_1_1 % 5 == 1 then
      x = 278 + gridWidth * 2
    end
    x = x + gridWidth * ((l_1_0 - 1) % 5)
    return x, y
   end
  local icons = {}
  local cur = 1
  local time = 0.2
  layer.tipsTag = false
  layer.allnum = 0
  if l_4_0.items then
    layer.allnum = layer.allnum +  l_4_0.items
  end
  if l_4_0.equips then
    layer.allnum = layer.allnum +  l_4_0.equips
  end
  if l_4_0.equips then
    for i,pb in ipairs(l_4_0.equips) do
      do
        schedule(layer, time, function()
          local x, y = getPosition(cur, layer.allnum)
          json.load(json.ui.equip_in)
          local aniEquipin = DHSkeletonAnimation:createWithKey(json.ui.equip_in)
          aniEquipin:setScale(view.minScale)
          aniEquipin:scheduleUpdateLua()
          aniEquipin:setPosition(scalep(x, y))
          layer:addChild(aniEquipin)
          if pb.cool then
            audio.play(audio.casino_get_nb)
            aniEquipin:playAnimation("good")
            schedule(layer, 1.5, function()
              aniEquipin:playAnimation("loop", -1)
                  end)
          else
            audio.play(audio.casino_get_common)
            aniEquipin:playAnimation("normal")
          end
          local icon = img.createEquip(pb.id, pb.num)
          icons[cur] = CCMenuItemSprite:create(icon, nil)
          icons[cur].menu = CCMenu:createWithItem(icons[cur])
          icons[cur].menu:ignoreAnchorPointForPosition(false)
          aniEquipin:addChildFollowSlot("code_equip", icons[cur].menu)
          icons[cur]:registerScriptTapHandler(function()
            if not layer.tipsTag then
              layer.tipsTag = true
              layer.tips = tipsequip.createForShow(pb)
              layer:addChild(layer.tips, 100)
              layer.tips.setClickBlankHandler(function()
                layer.tips:removeFromParent()
                layer.tipsTag = false
                     end)
            end
               end)
          upvalue_512 = cur + 1
            end)
        if pb.cool then
          time = time + 0.66
        else
          time = time + 0.2
        end
      end
    end
  end
  if l_4_0.items then
    for i,pb in ipairs(l_4_0.items) do
      schedule(layer, time, function()
        local x, y = getPosition(cur, layer.allnum)
        json.load(json.ui.equip_in)
        local aniEquipin = DHSkeletonAnimation:createWithKey(json.ui.equip_in)
        aniEquipin:setScale(view.minScale)
        aniEquipin:scheduleUpdateLua()
        aniEquipin:setPosition(scalep(x, y))
        layer:addChild(aniEquipin)
        if pb.cool then
          audio.play(audio.casino_get_nb)
          aniEquipin:playAnimation("good")
          schedule(layer, 1.5, function()
            aniEquipin:playAnimation("loop", -1)
               end)
        else
          audio.play(audio.casino_get_common)
          aniEquipin:playAnimation("normal")
        end
        local icon = img.createItem(pb.id, pb.num)
        icons[cur] = CCMenuItemSprite:create(icon, nil)
        icons[cur].menu = CCMenu:createWithItem(icons[cur])
        icons[cur].menu:ignoreAnchorPointForPosition(false)
        aniEquipin:addChildFollowSlot("code_equip", icons[cur].menu)
        icons[cur]:registerScriptTapHandler(function()
          if not layer.tipsTag then
            layer.tipsTag = true
            layer.tips = tipsitem.createForShow(pb)
            layer:addChild(layer.tips, 100)
            layer.tips.setClickBlankHandler(function()
              layer.tips:removeFromParent()
              layer.tipsTag = false
                  end)
          end
            end)
        upvalue_512 = cur + 1
         end)
      if pb.cool then
        time = time + 0.66
      else
        time = time + 0.2
      end
    end
  end
  return layer
end

reward.createRewardForSmith1 = function(l_5_0)
  local layer = reward.createLayer()
  layer.tipsTag = false
  schedule(layer, 1, function()
    layer.confirmBtn:setVisible(true)
   end)
  json.load(json.ui.reward_particle)
  local aniRewardTitle = DHSkeletonAnimation:createWithKey(json.ui.reward_particle)
  aniRewardTitle:setScale(view.minScale)
  aniRewardTitle:scheduleUpdateLua()
  aniRewardTitle:playAnimation("play", -1)
  aniRewardTitle:setPosition(scalep(480, 288))
  layer:addChild(aniRewardTitle)
  local title1 = reward.setTitle(i18n.global.reward_successful.string)
  layer.aniReward:addChildFollowSlot("code_reward_text", title1)
  local title2 = reward.setTitle(i18n.global.reward_successful.string)
  layer.aniReward:addChildFollowSlot("code_reward_text2", title2)
  schedule(layer, 0.4, function()
    json.load(json.ui.equip_in)
    local aniEquipin = DHSkeletonAnimation:createWithKey(json.ui.equip_in)
    aniEquipin:setScale(view.minScale)
    aniEquipin:scheduleUpdateLua()
    aniEquipin:setPosition(scalep(480, 301))
    layer:addChild(aniEquipin)
    if cfgequip[equip.id].qlt >= 5 then
      aniEquipin:playAnimation("good")
      schedule(layer, 1.5, function()
        aniEquipin:playAnimation("loop", -1)
         end)
    else
      aniEquipin:playAnimation("normal")
    end
    local icon = img.createEquip(equip.id, equip.num)
    local iconBtn = CCMenuItemSprite:create(icon, nil)
    local iconMenu = CCMenu:createWithItem(iconBtn)
    iconMenu:ignoreAnchorPointForPosition(false)
    aniEquipin:addChildFollowSlot("code_equip", iconMenu)
    iconBtn:registerScriptTapHandler(function()
      if not layer.tipsTag then
        layer.tipsTag = true
        layer.tips = tipsequip.createForShow(equip)
        layer:addChild(layer.tips, 100)
        layer.tips.setClickBlankHandler(function()
          layer.tips:removeFromParent()
          layer.tipsTag = false
            end)
      end
      end)
   end)
  return layer
end

reward.createLayer = function()
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  img.load(img.packedOthers.spine_ui_blacksmith_1)
  img.load(img.packedOthers.spine_ui_blacksmith_2)
  json.load(json.ui.reward)
  local aniReward = DHSkeletonAnimation:createWithKey(json.ui.reward)
  aniReward:setScale(view.minScale)
  aniReward:scheduleUpdateLua()
  aniReward:playAnimation("reward")
  aniReward:setPosition(scalep(480, 288))
  layer.aniReward = aniReward
  layer:addChild(aniReward)
  local lefFrame = img.createUISprite(img.ui.reward_frame)
  aniReward:addChildFollowSlot("code_reward_01_2_left", lefFrame)
  local rigFrame = img.createUISprite(img.ui.reward_frame)
  aniReward:addChildFollowSlot("code_reward_01_2_right", rigFrame)
  local titleStr = reward.title
  local confirm = img.createUI9Sprite(img.ui.btn_1)
  confirm:setPreferredSize(CCSizeMake(172, 72))
  local confirmLab = lbl.createFont1(18, i18n.global.summon_comfirm.string, ccc3(115, 59, 5))
  confirmLab:setPosition(CCPoint(confirm:getContentSize().width / 2, confirm:getContentSize().height / 2 - 2))
  confirm:addChild(confirmLab)
  local confirmBtn = SpineMenuItem:create(json.ui.button, confirm)
  confirmBtn:setScale(view.minScale)
  confirmBtn:setPosition(scalep(480, 80))
  confirmBtn:setVisible(false)
  layer.confirmBtn = confirmBtn
  local confirmMenu = CCMenu:createWithItem(confirmBtn)
  confirmMenu:setPosition(0, 0)
  layer:addChild(confirmMenu)
  confirmBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  layer:setTouchEnabled(true)
  layer.onAndroidBack = function()
    audio.play(audio.button)
    img.unload(img.packedOthers.spine_ui_blacksmith_1)
    img.unload(img.packedOthers.spine_ui_blacksmith_2)
    layer:removeFromParentAndCleanup(true)
   end
  addBackEvent(layer)
  local onEnter = function()
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
  return layer
end

reward.setTitle = function(l_7_0)
  local titleLabel = lbl.createFont2(30, l_7_0, ccc3(255, 225, 107))
  return titleLabel
end

reward.playEquipsAni = function(l_8_0, l_8_1, l_8_2)
  local upDuration = 0.8
  local fadeoutDuration = 0.8
  local icons = {}
  local board = img.createLogin9Sprite(img.login.toast_bg)
  board:setPreferredSize(CCSize(300, 64))
  board:setScale(view.minScale)
  board:setVisible(false)
  board:setPosition(CCPoint(view.physical.w / 2, view.physical.h / 2 + 100 * view.minScale))
  board:setCascadeOpacityEnabled(true)
  local icon = img.createEquip(l_8_0.id, l_8_0.num)
  icon:setScale(0.6)
  icon:setPosition(board:getContentSize().width / 4, board:getContentSize().height / 2)
  board:addChild(icon)
  local name = lbl.createMixFont1(16, i18n.equip[l_8_0.id].name, ccc3(255, 246, 223))
  name:setAnchorPoint(ccp(0, 0.5))
  name:setPosition(board:getContentSize().width / 2.5, board:getContentSize().height / 2)
  board:addChild(name)
  local arr = CCArray:create()
  arr:addObject(CCDelayTime:create(l_8_1))
  arr:addObject(CCCallFunc:create(function()
    board:setVisible(true)
   end))
  arr:addObject(CCMoveBy:create(upDuration, CCPoint(0, 54 * view.minScale)))
  if reward.allnum ~= 1 and l_8_2 ~= reward.allnum then
    arr:addObject(CCMoveBy:create(0.1, CCPoint(0, 54 * view.minScale)))
  end
  arr:addObject(CCFadeOut:create(fadeoutDuration))
  board:runAction(CCSequence:create(arr))
  return board
end

reward.playItemsAni = function(l_9_0, l_9_1, l_9_2)
  local upDuration = 0.8
  local fadeoutDuration = 0.8
  local icons = {}
  local board = img.createLogin9Sprite(img.login.toast_bg)
  board:setPreferredSize(CCSize(300, 64))
  board:setScale(view.minScale)
  board:setPosition(CCPoint(view.physical.w / 2, view.physical.h / 2 + 100 * view.minScale))
  board:setVisible(false)
  board:setCascadeOpacityEnabled(true)
  local icon = nil
  if l_9_0.id == 4302 then
    icon = img.createUISprite(img.ui.grid)
    local size = icon:getContentSize()
    local iconImg = img.createItemIconForId(4302)
    iconImg:setPosition(size.width / 2, size.height / 2)
    iconImg:setScale(1.6666666666667)
    icon:addChild(iconImg)
    local l = lbl.createFont2(14, convertItemNum(l_9_0.num))
    l:setAnchorPoint(ccp(1, 0))
    l:setPosition(74, 6)
    icon:addChild(l)
    icon:setCascadeOpacityEnabled(true)
  else
    icon = img.createItem(l_9_0.id, l_9_0.num)
  end
  icon:setScale(0.6)
  icon:setPosition(board:getContentSize().width / 4, board:getContentSize().height / 2)
  board:addChild(icon)
  if l_9_0.id ~= 4302 or not i18n.global.airisland_stamina.string then
    local nameStr = i18n.item[l_9_0.id].name
  end
  local name = lbl.createMixFont1(16, nameStr, ccc3(255, 246, 223))
  name:setAnchorPoint(ccp(0, 0.5))
  name:setPosition(board:getContentSize().width / 2.5, board:getContentSize().height / 2)
  board:addChild(name)
  local arr = CCArray:create()
  arr:addObject(CCDelayTime:create(l_9_1))
  arr:addObject(CCCallFunc:create(function()
    board:setVisible(true)
   end))
  arr:addObject(CCMoveBy:create(upDuration, CCPoint(0, 54 * view.minScale)))
  if reward.allnum ~= 1 and l_9_2 ~= reward.allnum then
    arr:addObject(CCMoveBy:create(0.1, CCPoint(0, 54 * view.minScale)))
  end
  arr:addObject(CCFadeOut:create(fadeoutDuration))
  board:runAction(CCSequence:create(arr))
  return board
end

reward.createFloating = function(l_10_0)
  local layer = CCLayer:create()
  local delaytime = 0
  local cur = 1
  reward.allnum = 0
  if l_10_0.items then
    reward.allnum = reward.allnum +  l_10_0.items
  end
  if l_10_0.equips then
    reward.allnum = reward.allnum +  l_10_0.equips
  end
  if l_10_0.equips then
    for i,pb in ipairs(l_10_0.equips) do
      layer:addChild(reward.playEquipsAni(pb, delaytime, cur))
      delaytime = delaytime + 0.8
      cur = cur + 1
    end
  end
  if l_10_0.items then
    for i,pb in ipairs(l_10_0.items) do
      layer:addChild(reward.playItemsAni(pb, delaytime, cur))
      delaytime = delaytime + 0.8
      cur = cur + 1
    end
  end
  return layer
end

return reward

