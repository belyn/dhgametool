-- Command line was: E:\github\dhgametool\scripts\ui\hero\upherotips.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local player = require("data.player")
local net = require("net.netClient")
local cfghero = require("config.hero")
local BG_WIDTH = 574
local BG_HEIGHT = 460
ui.create = function(l_1_0, l_1_1)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  tbl2string(l_1_1)
  local id = l_1_0.id
  local exstar = l_1_0.wake
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setPreferredSize(CCSize(BG_WIDTH, BG_HEIGHT))
  bg:setScale(0.1 * view.minScale)
  bg:setPosition(scalep(480, 273))
  bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, 1 * view.minScale)))
  layer:addChild(bg)
  local ltitlebg = img.createUISprite(img.ui.hero_up_titlebg)
  ltitlebg:setAnchorPoint(1, 0.5)
  ltitlebg:setPosition(BG_WIDTH / 2, BG_HEIGHT - 15)
  bg:addChild(ltitlebg, 1)
  local rtitlebg = img.createUISprite(img.ui.hero_up_titlebg)
  rtitlebg:setAnchorPoint(0, 0.5)
  rtitlebg:setPosition(BG_WIDTH / 2, BG_HEIGHT - 15)
  rtitlebg:setFlipX(true)
  bg:addChild(rtitlebg)
  local titlelbl = lbl.createFont2(24, i18n.global.hero_wake_tips_title.string, ccc3(250, 216, 105))
  titlelbl:setPosition(ltitlebg:getContentSize().width, ltitlebg:getContentSize().height / 2 + 12)
  ltitlebg:addChild(titlelbl)
  local heroraw = img.createUISprite(img.ui.hero_btn_raw)
  heroraw:setScale(0.45)
  heroraw:setPosition(BG_WIDTH / 2, 360)
  bg:addChild(heroraw)
  local lheadbg = img.createHeroHead(l_1_1.id, l_1_0.lv, true, true, exstar - 1)
  lheadbg:setScale(0.8)
  lheadbg:setPosition(BG_WIDTH / 2 - 90, 360)
  bg:addChild(lheadbg)
  local rheadbg = img.createHeroHead(l_1_0.id, l_1_0.lv, true, true, exstar)
  rheadbg:setScale(0.8)
  rheadbg:setPosition(BG_WIDTH / 2 + 90, 360)
  bg:addChild(rheadbg)
  local infobg1 = img.createUISprite(img.ui.guild_vtitle_bg)
  infobg1:setPosition(BG_WIDTH / 2, 290)
  bg:addChild(infobg1)
  local info1 = lbl.createFont1(16, i18n.global.hero_wake_attr_up.string, ccc3(235, 170, 94))
  info1:setPosition(infobg1:getContentSize().width / 2, infobg1:getContentSize().height / 2)
  infobg1:addChild(info1)
  local helper = (require("fight.helper.attr"))
  local preData = nil
  if l_1_0.wake < 4 then
    preData = helper.attr(l_1_0, l_1_0.star, l_1_0.lv, l_1_0.wake - 1)
  else
    preData = helper.attr(l_1_1, l_1_1.star, l_1_1.lv, l_1_1.wake)
  end
  local aftData = helper.attr(l_1_0, l_1_0.star, l_1_0.lv, l_1_0.wake)
  local lbllv = lbl.createMixFont1(18, i18n.global.hero_wake_level_up.string, ccc3(253, 235, 135))
  lbllv:setAnchorPoint(1, 0.5)
  lbllv:setPosition(162, 252)
  bg:addChild(lbllv)
  local lvraw = img.createUISprite(img.ui.hero_btn_raw)
  lvraw:setScale(0.42)
  lvraw:setPosition(326, 252)
  bg:addChild(lvraw)
  if not cfghero[l_1_0.id].starLv" .. l_1_0.star +  then
    local lvMax = cfghero[l_1_0.id].maxLv
  end
  if l_1_0.wake and l_1_0.wake < 4 then
    lvMax = lvMax + l_1_0.wake * 20
  end
  local lv1 = lbl.createMixFont1(18, lvMax - 20, ccc3(255, 246, 223))
  lv1:setPosition(226, 252)
  bg:addChild(lv1)
  local lv2 = lbl.createMixFont1(18, lvMax, ccc3(255, 246, 223))
  lv2:setPosition(426, 252)
  bg:addChild(lv2)
  if l_1_0.wake == 4 then
    lv1:setString(lvMax - 50)
  end
  local lblhealth = lbl.createMixFont1(18, i18n.global.hero_info_health.string, ccc3(253, 235, 135))
  lblhealth:setAnchorPoint(1, 0.5)
  lblhealth:setPosition(162, 222)
  bg:addChild(lblhealth)
  local healthraw = img.createUISprite(img.ui.hero_btn_raw)
  healthraw:setScale(0.42)
  healthraw:setPosition(326, 222)
  bg:addChild(healthraw)
  local hp1 = lbl.createMixFont1(18, preData.hp, ccc3(255, 246, 223))
  hp1:setPosition(226, 222)
  bg:addChild(hp1)
  local hp2 = lbl.createMixFont1(18, aftData.hp, ccc3(255, 246, 223))
  hp2:setPosition(426, 222)
  bg:addChild(hp2)
  local lblatt = lbl.createMixFont1(18, i18n.global.hero_info_attack.string, ccc3(253, 235, 135))
  lblatt:setAnchorPoint(1, 0.5)
  lblatt:setPosition(162, 192)
  bg:addChild(lblatt)
  local attraw = img.createUISprite(img.ui.hero_btn_raw)
  attraw:setScale(0.42)
  attraw:setPosition(326, 192)
  bg:addChild(attraw)
  local atk1 = lbl.createMixFont1(18, preData.atk, ccc3(255, 246, 223))
  atk1:setPosition(226, 192)
  bg:addChild(atk1)
  local atk2 = lbl.createMixFont1(18, aftData.atk, ccc3(255, 246, 223))
  atk2:setPosition(426, 192)
  bg:addChild(atk2)
  local infobg2 = img.createUISprite(img.ui.guild_vtitle_bg)
  infobg2:setPosition(BG_WIDTH / 2, 154)
  bg:addChild(infobg2)
  local info2 = lbl.createFont1(16, i18n.global.hero_wake_skill_up.string, ccc3(235, 170, 94))
  info2:setPosition(infobg2:getContentSize().width / 2, infobg2:getContentSize().height / 2)
  infobg2:addChild(info2)
  local skillraw = img.createUISprite(img.ui.hero_btn_raw)
  skillraw:setScale(0.75)
  skillraw:setPosition(BG_WIDTH / 2, 84)
  bg:addChild(skillraw)
  local skillId1 = cfghero[id].actSkillId
  if exstar - 1 > 0 and exstar < 4 then
    skillId1 = cfghero[id].disillusSkill[exstar - 1].disi[1]
  end
  local skillId2 = cfghero[id].actSkillId
  if exstar < 4 then
    if skillId1 ~= cfghero[id].disillusSkill[exstar].disi[1] then
      skillId2 = cfghero[id].disillusSkill[exstar].disi[1]
    end
    if skillId1 == skillId2 then
      for i = 1, 3 do
        if exstar - 1 > 0 then
          skillId1 = cfghero[id].disillusSkill[exstar - 1].disi[i + 1]
        else
          skillId1 = cfghero[id].pasSkill" .. i .. "Id
        end
        if skillId1 ~= cfghero[id].disillusSkill[exstar].disi[i + 1] then
          skillId2 = cfghero[id].disillusSkill[exstar].disi[i + 1]
      else
        end
      end
    end
  end
  local skillIconBg1 = img.createUISprite(img.ui.hero_skill_bg)
  skillIconBg1:setScale(0.9)
  skillIconBg1:setPosition(BG_WIDTH / 2 - 90, 84)
  bg:addChild(skillIconBg1, 100)
  local skillIcon1 = img.createSkill(skillId1)
  skillIcon1:setPosition(skillIconBg1:getContentSize().width / 2, skillIconBg1:getContentSize().height / 2)
  skillIconBg1:addChild(skillIcon1)
  local skillIconBg2 = img.createUISprite(img.ui.hero_skill_bg)
  skillIconBg2:setScale(0.9)
  skillIconBg2:setPosition(BG_WIDTH / 2 + 90, 84)
  bg:addChild(skillIconBg2, 100)
  local skillIcon2 = img.createSkill(skillId2)
  skillIcon2:setPosition(skillIconBg2:getContentSize().width / 2, skillIconBg2:getContentSize().height / 2)
  skillIconBg2:addChild(skillIcon2)
  if exstar < 4 then
    local skillLB1 = img.createUISprite(img.ui.hero_skilllevel_bg)
    skillLB1:setPosition(skillIconBg1:getContentSize().width - 15, skillIconBg1:getContentSize().height - 15)
    skillIconBg1:addChild(skillLB1)
    local skilllab1 = lbl.createFont1(18, "2", ccc3(255, 246, 223))
    skilllab1:setPosition(skillLB1:getContentSize().width / 2, skillLB1:getContentSize().height / 2)
    skillLB1:addChild(skilllab1)
    local skillLB2 = img.createUISprite(img.ui.hero_skilllevel_bg)
    skillLB2:setPosition(skillIconBg2:getContentSize().width - 15, skillIconBg2:getContentSize().height - 15)
    skillIconBg2:addChild(skillLB2)
    local skilllab2 = lbl.createFont1(18, "3", ccc3(255, 246, 223))
    skilllab2:setPosition(skillLB2:getContentSize().width / 2, skillLB2:getContentSize().height / 2)
    skillLB2:addChild(skilllab2)
  end
  local closeBtn0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(BG_WIDTH - 23, BG_HEIGHT - 26)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  bg:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer.onAndroidBack()
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParent()
   end
  layer:registerScriptHandler(function(l_3_0)
    if l_3_0 == "enter" then
      layer.notifyParentLock()
    elseif l_3_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

