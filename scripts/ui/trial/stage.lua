-- Command line was: E:\github\dhgametool\scripts\ui\trial\stage.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local player = require("data.player")
local cfgwave = require("config.wavetrial")
local cfgmonster = require("config.monster")
ui.create = function(l_1_0, l_1_1)
  local layer = CCLayer:create()
  local board = CCSprite:create()
  board:setPosition(0, 0)
  board:setContentSize(960, 576)
  layer:addChild(board)
  local showTitleBg = CCSprite:create()
  showTitleBg:setContentSize(CCSizeMake(328, 58))
  showTitleBg:setPosition(480, 524)
  board:addChild(showTitleBg)
  local showStageId = lbl.createFont3(26, i18n.global.trial_stage_title.string .. " " .. l_1_0, ccc3(250, 216, 105))
  showStageId:setPosition(showTitleBg:getContentSize().width / 2, showTitleBg:getContentSize().height / 2 - 4)
  showTitleBg:addChild(showStageId)
  local powerIcon = img.createUISprite(img.ui.power_icon)
  powerIcon:setScale(0.46)
  powerIcon:setAnchorPoint(ccp(0, 0.5))
  board:addChild(powerIcon)
  local showPower = lbl.createFont2(20, cfgwave[l_1_0].power)
  showPower:setAnchorPoint(ccp(1, 0.5))
  board:addChild(showPower)
  local wid = powerIcon:boundingBox().size.width + showPower:boundingBox().size.width
  powerIcon:setPosition(480 - wid / 2 - 10, 469)
  showPower:setPosition(480 + wid / 2 + 10, 469)
  local tabEnemy = lbl.createFont1(18, i18n.global.trial_stage_enemy.string, ccc3(255, 244, 147))
  tabEnemy:setPosition(board:getContentSize().width / 2, 404)
  board:addChild(tabEnemy)
  local mons = cfgwave[l_1_0].trial
  local offset = 485 -  mons * 44
  for i = 1,  mons do
    print(mons[i])
    local info = cfgmonster[mons[i]]
    local head = nil
    do
      if info.star == 10 then
        head = img.createHeroHead(info.heroLink, info.lvShow, true, info.star, 4)
      else
        head = img.createHeroHead(info.heroLink, info.lvShow, true, info.star)
      end
      head:setScale(0.8)
      head:setAnchorPoint(ccp(0, 0))
      head:setPosition(offset + (i - 1) * 88, 310)
      board:addChild(head)
    end
  end
  local rewards = cfgwave[l_1_0].reward
  local showRewards = {}
  offset = 470 -  rewards * 33
  for i = 1,  rewards do
    local showRewardsSp = nil
    if rewards[i].type == 1 then
      showRewardsSp = img.createItem(rewards[i].id, rewards[i].num)
    else
      showRewardsSp = img.createEquip(rewards[i].id)
    end
    showRewards[i] = CCMenuItemSprite:create(showRewardsSp, nil)
    local menuReward = CCMenu:createWithItem(showRewards[i])
    menuReward:setPosition(0, 0)
    board:addChild(menuReward)
    showRewards[i]:setScale(0.8)
    showRewards[i]:setAnchorPoint(ccp(0, 0))
    showRewards[i]:setPosition(offset + (i - 1) * 82, 185)
    showRewards[i]:registerScriptTapHandler(function()
      audio.play(audio.button)
      if rewards[i].type == 1 then
        local tips = require("ui.tips.item").createForShow(rewards[i])
        superlayer:addChild(tips, 100)
      else
        local tips = require("ui.tips.equip").createById(rewards[i].id)
        superlayer:addChild(tips, 100)
      end
      end)
  end
  local tabReward = lbl.createFont1(18, i18n.global.trial_stage_reward.string, ccc3(255, 244, 147))
  tabReward:setPosition(board:getContentSize().width / 2, 270)
  board:addChild(tabReward)
  local btnBattleSprite = img.createUI9Sprite(img.ui.btn_1)
  btnBattleSprite:setPreferredSize(CCSize(190, 70))
  local labBattle = lbl.createFont1(18, i18n.global.trial_stage_btn_battle.string, ccc3(115, 59, 5))
  labBattle:setPosition(btnBattleSprite:getContentSize().width / 2, btnBattleSprite:getContentSize().height / 2)
  btnBattleSprite:addChild(labBattle)
  local btnBattle = SpineMenuItem:create(json.ui.button, btnBattleSprite)
  local menuBattle = CCMenu:createWithItem(btnBattle)
  btnBattle:setPosition(board:getContentSize().width / 2, 124)
  menuBattle:setPosition(0, 0)
  board:addChild(menuBattle)
  btnBattle:registerScriptTapHandler(function()
    disableObjAWhile(btnBattle)
    audio.play(audio.button)
    print("BATTLE")
    local params = {type = "trial"}
    superlayer:addChild(require("ui.selecthero.main").create(params), 1000)
   end)
  local btnVideoSprite = img.createUISprite(img.ui.arena_button_video)
  local btnVideo = SpineMenuItem:create(json.ui.button, btnVideoSprite)
  btnVideo:setPosition(710, 524)
  local menuVideo = CCMenu:createWithItem(btnVideo)
  menuVideo:setPosition(0, 0)
  board:addChild(menuVideo)
  btnVideo:registerScriptTapHandler(function()
    audio.play(audio.button)
    superlayer:addChild(require("ui.trial.record").create(), 100)
   end)
  return layer
end

return ui

