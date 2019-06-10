-- Command line was: E:\github\dhgametool\scripts\ui\levelUplayer.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local i18n = require("res.i18n")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local particle = require("res.particle")
local audio = require("res.audio")
local cfgexpplayer = require("config.expplayer")
local cfghooklock = require("config.hooklock")
local player = require("data.player")
local bagdata = require("data.bag")
local hookdata = require("data.hook")
local showRemark = function()
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    return 
  end
  local director = CCDirector:sharedDirector()
  director:getRunningScene():addChild(require("ui.remark").create(), 1000000)
end

ui.create = function(l_2_0, l_2_1, l_2_2)
  local gems = 0
  for ii = l_2_0 + 1, l_2_1 do
    gems = gems + cfgexpplayer[ii].levelReward[1].num
  end
  bagdata.addGem(gems)
  local layer = CCLayer:create()
  layer:setCascadeOpacityEnabled(true)
  local lv_bg = img.createUISprite(img.ui.levelup_lv_bg)
  lv_bg:setScale(view.minScale)
  lv_bg:setPosition(scalep(480, 286))
  layer:addChild(lv_bg, 3)
  local lbl_lv = lbl.createFont1(28, "LV" .. l_2_1, ccc3(255, 222, 107))
  lbl_lv:setPosition(CCPoint(lv_bg:getContentSize().width / 2, lv_bg:getContentSize().height / 2))
  lv_bg:addChild(lbl_lv)
  local lbl_hero_count = lbl.createFont1(20, i18n.global.unlock_battle_field.string, ccc3(255, 246, 223), true)
  local lbl_hero_count2 = lbl.createFont1(20, "" .. hookdata.getMaxHeroes(), ccc3(165, 253, 71), true)
  if cfghooklock[l_2_1].show == 1 then
    lbl_hero_count:setPosition(scalep(470, 242))
    layer:addChild(lbl_hero_count, 3)
    lbl_hero_count2:setPosition(CCPoint(lbl_hero_count:boundingBox():getMaxX() + 10 * view.minScale, lbl_hero_count:boundingBox():getMidY()))
    layer:addChild(lbl_hero_count2, 3)
  end
  local lbl_reward = lbl.createFont1(20, i18n.global.mail_rewards.string, ccc3(255, 212, 82), true)
  lbl_reward:setPosition(scalep(480, 194))
  layer:addChild(lbl_reward, 3)
  local tmp_item = img.createItem(ITEM_ID_GEM, gems)
  tmp_item:setScale(view.minScale)
  tmp_item:setPosition(scalep(480, 136))
  layer:addChild(tmp_item, 3)
  local title = nil
  if i18n.getCurrentLanguage() == kLanguageChinese then
    title = img.createUISprite(img.ui.language_upgrade_cn)
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      title = img.createUISprite(img.ui.language_upgrade_tw)
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        title = img.createUISprite(img.ui.language_upgrade_jp)
      else
        if i18n.getCurrentLanguage() == kLanguageKorean then
          title = img.createUISprite(img.ui.language_upgrade_kr)
        else
          if i18n.getCurrentLanguage() == kLanguageRussian then
            title = img.createUISprite(img.ui.language_upgrade_ru)
          else
            if i18n.getCurrentLanguage() == kLanguageTurkish then
              title = img.createUISprite(img.ui.language_upgrade_tr)
            else
              title = img.createUISprite(img.ui.language_upgrade_us)
            end
          end
        end
      end
    end
  end
  title:setPosition(lv_bg:getContentSize().width / 2, 150)
  lv_bg:addChild(title)
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  json.load(json.ui.shengji)
  local level_up = DHSkeletonAnimation:createWithKey(json.ui.shengji)
  level_up:setScale(view.minScale)
  level_up:scheduleUpdateLua()
  level_up:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(level_up, 2)
  level_up:registerLuaHandler(function(l_1_0)
    print("event str:", l_1_0)
    if l_1_0 == "birth_a" then
      local particle_scale = view.minScale
      local particle_lv_a = particle.create("shengji_particle_a")
      particle_lv_a:setPosition(scalep(480, 421.26))
      particle_lv_a:setStartSize(particle_scale * particle_lv_a:getStartSize())
      particle_lv_a:setStartSizeVar(particle_scale * particle_lv_a:getStartSizeVar())
      particle_lv_a:setEndSize(particle_scale * particle_lv_a:getEndSize())
      particle_lv_a:setEndSizeVar(particle_scale * particle_lv_a:getEndSizeVar())
      layer:addChild(particle_lv_a, 1000)
    elseif l_1_0 == "birth_b" then
       -- Warning: missing end command somewhere! Added here
    end
   end)
  local arr = CCArray:create()
  arr:addObject(CCCallFunc:create(function()
    level_up:playAnimation("animation", 1)
   end))
  arr:addObject(CCDelayTime:create(level_up:getAnimationTime("animation") + 1))
  arr:addObject(CCCallFunc:create(function()
    layer:removeFromParentAndCleanup(true)
    local tutorialData = require("data.tutorial")
    if tutorialData.getVersion() == 1 then
      local unlockFunclayer = require("ui.unlockFunclayer")
      if pre_level < UNLOCK_BLACKMARKET_LEVEL and UNLOCK_BLACKMARKET_LEVEL <= level then
        showUnlockFunc(unlockFunclayer.WHICH.BLACKMARKET, callback)
      else
        if pre_level < UNLOCK_CASINO_LEVEL and UNLOCK_CASINO_LEVEL <= level then
          showUnlockFunc(unlockFunclayer.WHICH.CASINO, callback)
        else
          if pre_level < UNLOCK_ARENA_LEVEL and UNLOCK_ARENA_LEVEL <= level then
            showUnlockFunc(unlockFunclayer.WHICH.ARENA, callback)
          else
            if pre_level < UNLOCK_GUILD_LEVEL and UNLOCK_GUILD_LEVEL <= level then
              showUnlockFunc(unlockFunclayer.WHICH.GUILD, callback)
            else
              if pre_level < UNLOCK_TRIAL_LEVEL and UNLOCK_TRIAL_LEVEL <= level then
                showUnlockFunc(unlockFunclayer.WHICH.TRIAL, callback)
              else
                if pre_level < UNLOCK_TAVERN_LEVEL and UNLOCK_TAVERN_LEVEL <= level then
                  showUnlockFunc(unlockFunclayer.WHICH.TAVERN, callback)
                else
                  if pre_level < REMARK_LEVEL and REMARK_LEVEL <= level then
                    showRemark()
                  else
                    if tutorialData.exists() then
                      return 
                    end
                    local unlockFunclayer = require("ui.unlockFunclayer")
                    if pre_level < UNLOCK_CASINO_LEVEL and UNLOCK_CASINO_LEVEL <= level then
                      showUnlockFunc(unlockFunclayer.WHICH.CASINO, callback)
                    else
                      if pre_level < UNLOCK_ARENA_LEVEL and UNLOCK_ARENA_LEVEL <= level then
                        showUnlockFunc(unlockFunclayer.WHICH.ARENA, callback)
                      else
                        if pre_level < UNLOCK_GUILD_LEVEL and UNLOCK_GUILD_LEVEL <= level then
                          showUnlockFunc(unlockFunclayer.WHICH.GUILD, callback)
                        else
                          if pre_level < UNLOCK_TRIAL_LEVEL and UNLOCK_TRIAL_LEVEL <= level then
                            showUnlockFunc(unlockFunclayer.WHICH.TRIAL, callback)
                          else
                            if pre_level < UNLOCK_TAVERN_LEVEL and UNLOCK_TAVERN_LEVEL <= level then
                              showUnlockFunc(unlockFunclayer.WHICH.TAVERN, callback)
                            else
                              if pre_level < REMARK_LEVEL and REMARK_LEVEL <= level then
                                showRemark()
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
   end))
  audio.play(audio.player_lv_up)
  layer:runAction(CCSequence:create(arr))
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  addBackEvent(layer)
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
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
  return layer
end

return ui

