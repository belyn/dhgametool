-- Command line was: E:\github\dhgametool\scripts\ui\tips\skill.lua 

local tips = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local cfgskill = require("config.skill")
local cfgpetskill = require("config.petskill")
tips.create = function(l_1_0, l_1_1)
  local board = img.createUI9Sprite(img.ui.tips_bg)
  local base = 10
  if l_1_1 and l_1_1 > 0 then
    local showUnlock = lbl.createFont1(16, i18n.global.hero_title_evolve.string .. l_1_1 .. " " .. i18n.global.hero_unlock.string, ccc3(250, 53, 57))
    showUnlock:setAnchorPoint(ccp(0, 0))
    showUnlock:setPosition(20, base + 7)
    board:addChild(showUnlock)
    base = showUnlock:boundingBox():getMaxY()
  end
  local showText = lbl.createMix({font = 1, size = 16, text = i18n.skill[l_1_0].desc, width = 348, color = ccc3(255, 251, 236), align = kCCTextAlignmentLeft})
  showText:setAnchorPoint(ccp(0, 0))
  showText:setPosition(20, base + 7)
  board:addChild(showText)
  local fgLine = img.createUI9Sprite(img.ui.hero_tips_fgline)
  fgLine:setPreferredSize(CCSize(349, 1))
  fgLine:setPosition(194, showText:boundingBox():getMaxY() + 12)
  board:addChild(fgLine)
  local showSkillBg = img.createUISprite(img.ui.hero_skill_bg)
  showSkillBg:setScale(0.7)
  showSkillBg:setPosition(47, fgLine:boundingBox():getMaxY() + 32 + 7)
  board:addChild(showSkillBg)
  local skillIcon = img.createSkill(l_1_0)
  skillIcon:setPosition(showSkillBg:getContentSize().width / 2, showSkillBg:getContentSize().height / 2)
  showSkillBg:addChild(skillIcon)
  if cfgskill[l_1_0].skiL then
    local skillLB = img.createUISprite(img.ui.hero_skilllevel_bg)
    skillLB:setPosition(showSkillBg:getContentSize().width - 15, showSkillBg:getContentSize().height - 15)
    showSkillBg:addChild(skillLB)
    local skilllab = lbl.createFont1(18, cfgskill[l_1_0].skiL, ccc3(255, 246, 223))
    skilllab:setPosition(skillLB:getContentSize().width / 2, skillLB:getContentSize().height / 2)
    skillLB:addChild(skilllab)
  end
  local showTitle = lbl.createMixFont1(22, i18n.skill[l_1_0].skillName, ccc3(255, 228, 156))
  showTitle:setAnchorPoint(ccp(0, 0))
  showTitle:setPosition(85, fgLine:boundingBox():getMaxY() + 9 + 7)
  board:addChild(showTitle)
  board:setPreferredSize(CCSize(390, showSkillBg:boundingBox():getMaxY() + 20))
  return board
end

tips.createForPet = function(l_2_0)
  local board = img.createUI9Sprite(img.ui.tips_bg)
  local base = 10
  local showText = lbl.createMix({font = 1, size = 16, text = i18n.petskill[l_2_0].desc, width = 348, color = ccc3(255, 251, 236), align = kCCTextAlignmentLeft})
  showText:setAnchorPoint(ccp(0, 0))
  showText:setPosition(18, base + 5)
  board:addChild(showText)
  local fgLine = img.createUI9Sprite(img.ui.hero_tips_fgline)
  fgLine:setPreferredSize(CCSize(349, 1))
  fgLine:setPosition(192, showText:boundingBox():getMaxY() + 10)
  board:addChild(fgLine)
  local showSkillBg = img.createUISprite(img.ui.hero_skill_bg)
  showSkillBg:setScale(0.7)
  showSkillBg:setPosition(45, fgLine:boundingBox():getMaxY() + 32 + 5)
  board:addChild(showSkillBg)
  local skillIcon = img.createPetBuff(l_2_0)
  skillIcon:setPosition(showSkillBg:getContentSize().width / 2, showSkillBg:getContentSize().height / 2)
  showSkillBg:addChild(skillIcon)
  local showTitle = lbl.createMixFont1(22, i18n.petskill[l_2_0].skillName, ccc3(255, 228, 156))
  showTitle:setAnchorPoint(ccp(0, 0))
  showTitle:setPosition(83, fgLine:boundingBox():getMaxY() + 9 + 8)
  board:addChild(showTitle)
  board:setPreferredSize(CCSize(384, showSkillBg:boundingBox():getMaxY() + 15))
  return board
end

return tips

