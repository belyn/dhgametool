-- Command line was: E:\github\dhgametool\scripts\ui\brave\gateinfo.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local heros = require("data.heros")
local cfghero = require("config.hero")
local player = require("data.player")
local cfgbrave = require("config.brave")
local databrave = require("data.brave")
ui.create = function(l_1_0)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local enemy = databrave.enemys[l_1_0]
  img.load(img.packedOthers.ui_brave)
  local board = img.createUI9Sprite(img.ui.dialog_1)
  board:setPreferredSize(CCSize(663, 498))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local innerBg = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  innerBg:setPreferredSize(CCSize(610, 316))
  innerBg:setPosition(332, 266)
  board:addChild(innerBg)
  local lefTitleBg = img.createUISprite(img.ui.brave_boss_bg)
  lefTitleBg:setAnchorPoint(ccp(1, 0))
  lefTitleBg:setPosition(board:getContentSize().width / 2 + 1, 421)
  board:addChild(lefTitleBg)
  local rigTitleBg = img.createUISprite(img.ui.brave_boss_bg)
  rigTitleBg:setFlipX(true)
  rigTitleBg:setAnchorPoint(ccp(0, 0))
  rigTitleBg:setPosition(board:getContentSize().width / 2 - 1, 421)
  board:addChild(rigTitleBg)
  local showHead = img.createPlayerHead(enemy.logo, enemy.lv)
  showHead:setScale(0.75)
  showHead:setPosition(235, 458)
  board:addChild(showHead)
  local showName = lbl.createFontTTF(16, enemy.name)
  showName:setAnchorPoint(ccp(0, 0.5))
  showName:setPosition(275, 475)
  board:addChild(showName)
  local powerIcon = img.createUISprite(img.ui.power_icon)
  powerIcon:setScale(0.5)
  powerIcon:setAnchorPoint(ccp(0, 0.5))
  powerIcon:setPosition(275, 445)
  board:addChild(powerIcon)
  local showPower = lbl.createFont2(16, enemy.power)
  showPower:setAnchorPoint(ccp(0, 0.5))
  showPower:setPosition(315, 445)
  board:addChild(showPower)
  local sidBg = img.createUISprite(img.ui.hero_circle_bg)
  sidBg:setScale(1.2)
  sidBg:setPosition(442, 458)
  board:addChild(sidBg)
  local showSid = lbl.createFont1(18, getSidname(enemy.sid))
  showSid:setPosition(sidBg:getContentSize().width / 2, sidBg:getContentSize().height / 2)
  sidBg:addChild(showSid)
  local btnBattle0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnBattle0:setPreferredSize(CCSizeMake(216, 52))
  local lblBattle = lbl.createFont1(22, i18n.global.brave_btn_battle.string, ccc3(115, 59, 5))
  lblBattle:setPosition(CCPoint(btnBattle0:getContentSize().width / 2, btnBattle0:getContentSize().height / 2))
  btnBattle0:addChild(lblBattle)
  local btnBattle = SpineMenuItem:create(json.ui.button, btnBattle0)
  btnBattle:setPosition(CCPoint(board:getContentSize().width / 2, 63))
  local btnBattleMenu = CCMenu:createWithItem(btnBattle)
  btnBattleMenu:setPosition(CCPoint(0, 0))
  board:addChild(btnBattleMenu)
  local btnClose0 = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnClose0)
  btnClose:setPosition(CCPoint(board:getContentSize().width - 25, board:getContentSize().height - 28))
  local btnCloseMenu = CCMenu:createWithItem(btnClose)
  btnCloseMenu:setPosition(CCPoint(0, 0))
  board:addChild(btnCloseMenu, 100)
  btnClose:registerScriptTapHandler(function()
    layer:removeFromParentAndCleanup(true)
   end)
  local heroCampBg = img.createUI9Sprite(img.ui.bottom_border_2)
  heroCampBg:setPreferredSize(CCSize(560, 155))
  heroCampBg:setPosition(305, 216)
  innerBg:addChild(heroCampBg)
  local titleHero = lbl.createFont1(18, i18n.global.brave_title_enemy.string, ccc3(163, 123, 96))
  titleHero:setPosition(heroCampBg:getContentSize().width / 2, 128)
  heroCampBg:addChild(titleHero)
  local titleRewards = lbl.createFont1(18, i18n.global.brave_title_reward.string, ccc3(99, 48, 16))
  titleRewards:setPosition(innerBg:getContentSize().width / 2, 115)
  innerBg:addChild(titleRewards)
  local POSX = {28, 114, 200, 286, 372, 458}
  local camp_len = #enemy.camp
  if camp_len > 6 then
    camp_len = 6
  end
  local pet_id = nil
  for i,v in ipairs(enemy.camp) do
    if v and v.pos == 7 then
      pet_id = v.id
  else
    end
  end
  local offset = 318 - 43 * camp_len + 5
  table.sort(enemy.camp, function(l_2_0, l_2_1)
    return l_2_0.pos < l_2_1.pos
   end)
  tbl2string(enemy)
  do
    for i,v in ipairs(enemy.camp) do
      if v and v.pos ~= 7 then
        local param = {id = v.id, lv = v.lv, showGroup = true, showStar = true, wake = v.wake, orangeFx = nil, petID = pet_id, skin = v.skin}
        local showHero = img.createHeroHeadByParam(param)
        showHero:setScale(0.8)
        showHero:setPosition((i - 1) * 86 + offset, 68)
        heroCampBg:addChild(showHero)
        if v.hpp <= 0 then
          setShader(showHero, SHADER_GRAY, true)
        end
        local showHpBg = img.createUISprite(img.ui.fight_hp_bg.small)
        showHpBg:setPosition(showHero:boundingBox():getMidX(), showHero:boundingBox():getMinY() - 10)
        heroCampBg:addChild(showHpBg)
        local showHpFgSp = img.createUISprite(img.ui.fight_hp_fg.small)
        local showHpFg = createProgressBar(showHpFgSp)
        showHpFg:setPosition(showHpBg:getContentSize().width / 2, showHpBg:getContentSize().height / 2)
        showHpFg:setPercentage(v.hpp)
        showHpBg:addChild(showHpFg)
      end
    end
  end
  local rewards = {}
  for i,v in ipairs(cfgbrave[databrave.id].rewards) do
    if v.stage == l_1_0 then
      rewards[#rewards + 1] = v
    end
  end
  local showRewards = {}
  offset = 314 - #rewards * 41
  for i = 1, #rewards do
    local showRewardsSp = nil
    if rewards[i].type == 1 then
      showRewardsSp = img.createItem(rewards[i].id, rewards[i].num)
    else
      showRewardsSp = img.createEquip(rewards[i].id)
    end
    showRewards[i] = CCMenuItemSprite:create(showRewardsSp, nil)
    local menuReward = CCMenu:createWithItem(showRewards[i])
    menuReward:setPosition(0, 0)
    innerBg:addChild(menuReward)
    showRewards[i]:setScale(0.8)
    showRewards[i]:setAnchorPoint(ccp(0, 0))
    showRewards[i]:setPosition(offset + (i - 1) * 82, 30)
    showRewards[i]:registerScriptTapHandler(function()
      audio.play(audio.button)
      if rewards[i].type == 1 then
        local tips = require("ui.tips.item").createForShow(rewards[i])
        layer:addChild(tips, 100)
      else
        local tips = require("ui.tips.equip").createById(rewards[i].id)
        layer:addChild(tips, 100)
      end
      end)
  end
  layer:registerScriptTouchHandler(function()
    return true
   end)
  layer:setTouchEnabled(true)
  btnBattle:registerScriptTapHandler(function()
    disableObjAWhile(btnBattle)
    layer:addChild(require("ui.brave.select").create({reward = rewards}), 1000)
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
  layer:registerScriptHandler(function(l_9_0)
    if l_9_0 == "enter" then
      onEnter()
    elseif l_9_0 == "exit" then
      onExit()
    end
   end)
  board:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  anim_arr:addObject(CCDelayTime:create(0.15))
  anim_arr:addObject(CCCallFunc:create(function()
   end))
  board:runAction(CCSequence:create(anim_arr))
  if l_1_0 ~= databrave.stage then
    btnBattle:setVisible(false)
  end
  return layer
end

return ui

