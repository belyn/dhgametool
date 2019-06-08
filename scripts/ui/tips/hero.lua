-- Command line was: E:\github\dhgametool\scripts\ui\tips\hero.lua 

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
local cfgskill = require("config.skill")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local particle = require("res.particle")
local attrHelper = (require("fight.helper.attr"))
local showBoardLayer, heroData = nil, nil
local getHeroData = function(l_1_0)
  local heroData = nil
  if type(l_1_0) == "table" then
    heroData = l_1_0
  else
    heroData = attrHelper.attr({id = l_1_0}, 0, 1)
    heroData.id = l_1_0
    heroData.lv = 1
    heroData.star = 0
    heroData.show = true
  end
  return heroData
end

ui.create = function(l_2_0, l_2_1)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local bg = img.createUI9Sprite(img.ui.dialog_2)
  bg:setPreferredSize(CCSize(423, 466))
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
  local btnCloseSp = img.createLoginSprite(img.login.button_close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSp)
  btnClose:setPosition(397, 438)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  bg:addChild(menuClose, 1000)
  btnClose:registerScriptTapHandler(function()
    layer:removeFromParentAndCleanup(true)
    audio.play(audio.button)
   end)
  local heroData = getHeroData(l_2_0)
  if l_2_1 then
    heroData = attrHelper.attr({id = l_2_0}, l_2_1.star, heroData.lv)
    heroData.id = l_2_0
    heroData.lv = heroData.lv
    heroData.star = l_2_1.star
    heroData.show = true
    heroData.wake = l_2_1.wake
  end
  local param = {id = heroData.id, lv = heroData.lv, showGroup = true, showStar = true, wake = heroData.wake, orangeFx = nil, petID = nil, skin = heroData.skin}
  local showHead = img.createHeroHeadByParam(param)
  showHead:setAnchorPoint(ccp(0, 0))
  showHead:setPosition(30, 346)
  bg:addChild(showHead)
  local heroName = lbl.createMixFont1(18, i18n.hero[heroData.id].heroName, ccc3(81, 39, 18))
  heroName:setAnchorPoint(ccp(0, 0))
  heroName:setPosition(136, 412)
  bg:addChild(heroName)
  local powerIcon = img.createUISprite(img.ui.power_icon)
  powerIcon:setScale(0.5)
  powerIcon:setAnchorPoint(ccp(0, 0))
  powerIcon:setPosition(136, 364)
  bg:addChild(powerIcon)
  local showPower = lbl.createFont2(18, heroData.power, ccc3(255, 228, 105))
  showPower:setAnchorPoint(ccp(0, 0.5))
  showPower:setPosition(powerIcon:boundingBox():getMaxX() + 10, powerIcon:boundingBox():getMidY())
  bg:addChild(showPower)
  local titleEvolve = lbl.createFont1(18, i18n.global.hero_title_evolve.string, ccc3(115, 59, 5))
  titleEvolve:setAnchorPoint(ccp(1, 0.5))
  titleEvolve:setPosition(106, 312)
  bg:addChild(titleEvolve)
  for i = 1, cfghero[heroData.id].qlt do
    local showStar = nil
    if i <= heroData.star then
      showStar = img.createUISprite(img.ui.hero_star1)
    else
      showStar = img.createUISprite(img.ui.hero_star0)
    end
    showStar:setAnchorPoint(ccp(0, 0.5))
    showStar:setPosition(powerIcon:boundingBox():getMinX() + (i - 1) * 32, titleEvolve:boundingBox():getMidY())
    bg:addChild(showStar)
  end
  local attriBg = img.createUI9Sprite(img.ui.hero_attribute_lab_frame)
  attriBg:setPreferredSize(CCSize(366, 141))
  attriBg:setAnchorPoint(ccp(0.5, 0))
  attriBg:setPosition(210, 138)
  bg:addChild(attriBg)
  local showTitle = lbl.createFont1(18, i18n.global.hero_job_" .. cfghero[heroData.id].jo.string, ccc3(148, 98, 66))
  showTitle:setPosition(182, 117)
  attriBg:addChild(showTitle)
  local showJob = img.createUISprite(img.ui.job_" .. cfghero[heroData.id].jo)
  showJob:setPosition(showTitle:boundingBox():getMinX() - 25, 117)
  attriBg:addChild(showJob)
  if heroData.show then
    local btnInfoSprite = img.createUISprite(img.ui.btn_detail)
    local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
    local menuInfo = CCMenu:createWithItem(btnInfo)
    btnInfo:setPosition(332, 115)
    btnInfo:setScale(0.9)
    menuInfo:setPosition(0, 0)
    attriBg:addChild(menuInfo)
    btnInfo:registerScriptTapHandler(function()
      audio.play(audio.button)
      bg:addChild(require("ui.tips.attrdetail").create(heroData))
      end)
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local attriInfo = {1 = {icon = img.ui.hero_attr_hp, num = heroData.hp}, 2 = {icon = img.ui.hero_attr_atk, num = heroData.atk}, 3 = {icon = img.ui.hero_attr_def, num = heroData.armor}, 4 = {icon = img.ui.hero_attr_spd, num = heroData.spd}}
for i = 1, 4 do
  local eachBg = img.createUI9Sprite(img.ui.hero_icon_bg)
  eachBg:setPreferredSize(CCSize(80, 80))
  eachBg:setAnchorPoint(ccp(0, 0))
  eachBg:setPosition(87 * i - 76, 12)
  attriBg:addChild(eachBg)
  local icon = img.createUISprite(attriInfo[i].icon)
  icon:setPosition(40, 50)
  eachBg:addChild(icon)
  local showNum = lbl.createFont1(16, math.floor(attriInfo[i].num), ccc3(111, 76, 56))
  showNum:setPosition(40, 20)
  eachBg:addChild(showNum)
end
local skillId = {}
if heroData.wake == nil then
  if cfghero[heroData.id].actSkillId then
    skillId[ skillId + 1] = {id = cfghero[heroData.id].actSkillId, lock = 0}
  end
  for i = 1, 6 do
    if cfghero[heroData.id].pasSkill" .. i .. "Id then
      skillId[ skillId + 1] = {id = cfghero[heroData.id].pasSkill" .. i .. "Id, lock = cfghero[heroData.id].pasTier" .. }
    end
  end
elseif heroData.wake < 4 then
  if cfghero[heroData.id].disillusSkill[heroData.wake].disi[1] then
    skillId[ skillId + 1] = {id = cfghero[heroData.id].disillusSkill[heroData.wake].disi[1], lock = 0}
  end
  for i = 1, 6 do
    if cfghero[heroData.id].disillusSkill[heroData.wake].disi[i + 1] then
      skillId[ skillId + 1] = {id = cfghero[heroData.id].disillusSkill[heroData.wake].disi[i + 1], lock = cfghero[heroData.id].pasTier" .. }
    end
  end
else
  if cfghero[heroData.id].actSkillId then
    skillId[ skillId + 1] = {id = cfghero[heroData.id].actSkillId, lock = 0}
  end
  for i = 1, 6 do
    if cfghero[heroData.id].pasSkill" .. i .. "Id then
      skillId[ skillId + 1] = {id = cfghero[heroData.id].pasSkill" .. i .. "Id, lock = cfghero[heroData.id].pasTier" .. }
    end
  end
end
local showSkill = {}
local skillTips = {}
for i,v in ipairs(skillId) do
  showSkill[i] = img.createUISprite(img.ui.hero_skill_bg)
  showSkill[i]:setPosition(74 + 90 * (i - 1), 77)
  bg:addChild(showSkill[i])
  local skillIcon = img.createSkill(v.id)
  skillIcon:setPosition(showSkill[i]:getContentSize().width / 2, showSkill[i]:getContentSize().height / 2)
  showSkill[i]:addChild(skillIcon)
  if cfgskill[v.id].skiL then
    local skillLB = img.createUISprite(img.ui.hero_skilllevel_bg)
    skillLB:setPosition(showSkill[i]:getContentSize().width - 15, showSkill[i]:getContentSize().height - 15)
    showSkill[i]:addChild(skillLB)
    local skilllab = lbl.createFont1(18, cfgskill[v.id].skiL, ccc3(255, 246, 223))
    skilllab:setPosition(skillLB:getContentSize().width / 2, skillLB:getContentSize().height / 2)
    skillLB:addChild(skilllab)
  end
  if v.lock <= heroData.star then
    v.lock = 0
  else
    setShader(skillIcon, SHADER_GRAY, true)
  end
  skillTips[i] = require("ui.tips.skill").create(v.id, v.lock)
  skillTips[i]:setAnchorPoint(ccp(1, 0))
  skillTips[i]:setPosition(showSkill[i]:boundingBox():getMaxX(), showSkill[i]:boundingBox():getMaxY() + 10)
  bg:addChild(skillTips[i])
  skillTips[i]:setVisible(false)
end
local onTouch = function(l_3_0, l_3_1, l_3_2)
  do
    local point = bg:convertToNodeSpace(ccp(l_3_1, l_3_2))
    for i,v in ipairs(showSkill) do
      if v:boundingBox():containsPoint(point) then
        skillTips[i]:setVisible(true)
        for i,v in (for generator) do
        end
        skillTips[i]:setVisible(false)
      end
      if l_3_0 ~= "began" and l_3_0 ~= "moved" then
        for i,v in ipairs(skillTips) do
          v:setVisible(false)
        end
      end
      return true
    end
     -- Warning: missing end command somewhere! Added here
  end
end

layer:registerScriptTouchHandler(onTouch)
layer:setTouchEnabled(true)
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

layer:registerScriptHandler(function(l_7_0)
  if l_7_0 == "enter" then
    onEnter()
  elseif l_7_0 == "exit" then
    onExit()
  end
end
)
return layer
end

return ui

