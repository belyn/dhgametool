-- Command line was: E:\github\dhgametool\scripts\ui\pet\petDetails.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local petData = require("config.pet")
local skilldata = require("config.skill")
local buffdata = require("config.petskill")
local DHComponents = require("dhcomponents.DroidhangComponents")
local w = 470
local h = 460
ui.create = function(l_1_0)
  local actSkillMax = petData[l_1_0].actSkillId + 120 - 1
  ui.buffSkillMax = {}
  for k,v in pairs(petData[l_1_0].pasSkillId) do
    ui.buffSkillMax[k] = v + 30 - 1
  end
  ui.petDetailsLayer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  ui.petDetailsLayer:setTouchEnabled(true)
  ui.petDetailsLayer:setTouchSwallowEnabled(true)
  local container = CCSprite:create()
  container:setContentSize(CCSize(960, 576))
  container:setPosition(scalep(480, 288))
  container:setScale(view.minScale)
  ui.petDetailsLayer.container = container
  ui.petDetailsLayer:addChild(container)
  local bg = img.createLogin9Sprite(img.login.dialog)
  bg:setScale(0.1)
  bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, 1)))
  bg:setPreferredSize(CCSize(w, h))
  bg:setPosition(CCPoint(container:getContentSize().width / 2, container:getContentSize().height / 2))
  local labInfo = lbl.createFont1(24, i18n.global.ui_decompose_preview.string, ccc3(230, 208, 174))
  bg:addChild(labInfo, 2)
  local labInfoShade = lbl.createFont1(24, i18n.global.ui_decompose_preview.string, ccc3(89, 48, 27))
  bg:addChild(labInfoShade, 1)
  local closeBtn = SpineMenuItem:create(json.ui.button, img.createLoginSprite(img.login.button_close))
  closeBtn:setAnchorPoint(CCPoint(1, 1))
  closeBtn:setPosition(CCPoint(w, h))
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  bg:addChild(closeMenu, 12)
  closeBtn:registerScriptTapHandler(function()
    if ui.petDetailsLayer ~= nil then
      ui.petDetailsLayer:removeFromParent()
      ui.petDetailsLayer = nil
    end
   end)
  local framInfo = img.createUI9Sprite(img.ui.botton_fram_2)
  framInfo:setPreferredSize(CCSizeMake(410, 250))
  framInfo:setAnchorPoint(CCPoint(0, 0))
  framInfo:setPosition(CCPoint(30, 138))
  bg:addChild(framInfo)
  local skillIconBg = ui.creatSkillBtn(actSkillMax, framInfo)
  print(actSkillMax)
  local nameMainSkill = lbl.createMix({font = 1, size = 16, text = i18n.skill[actSkillMax].skillName, width = 380, color = ccc3(114, 63, 35), align = kCCTextAlignmentLeft})
  nameMainSkill:setAnchorPoint(CCPoint(0, 0))
  framInfo:addChild(nameMainSkill, 20)
  local lvMainSkill = lbl.createFont1(16, "LV:120", ccc3(145, 59, 56))
  framInfo:addChild(lvMainSkill, 20)
  local labSkill = lbl.createMix({font = 1, size = 14, text = i18n.skill[actSkillMax].desc, width = 350, color = ccc3(142, 93, 67), align = kCCTextAlignmentLeft})
  framInfo:addChild(labSkill, 20)
  local buffSkill1 = ui.creatSkillBtn(ui.buffSkillMax[1], framInfo, 1)
  local buffSkill2 = ui.creatSkillBtn(ui.buffSkillMax[2], framInfo, 2)
  local buffSkill3 = ui.creatSkillBtn(ui.buffSkillMax[3], framInfo, 3)
  local buffSkill4 = ui.creatSkillBtn(ui.buffSkillMax[4], framInfo, 4)
  local buffSkilllv1 = lbl.create({font = 2, size = 16, text = "LV:30", color = ccc3(255, 246, 223)})
  buffSkilllv1:setPosition(CCPoint(buffSkill1:getContentSize().width / 2, 13))
  buffSkill1:addChild(buffSkilllv1, 21)
  local buffSkilllv2 = lbl.create({font = 2, size = 16, text = "LV:30", color = ccc3(255, 246, 223)})
  buffSkilllv2:setPosition(CCPoint(buffSkill1:getContentSize().width / 2, 13))
  buffSkill2:addChild(buffSkilllv2, 21)
  local buffSkilllv3 = lbl.create({font = 2, size = 16, text = "LV:30", color = ccc3(255, 246, 223)})
  buffSkilllv3:setPosition(CCPoint(buffSkill1:getContentSize().width / 2, 13))
  buffSkill3:addChild(buffSkilllv3, 21)
  local buffSkilllv4 = lbl.create({font = 2, size = 16, text = "LV:30", color = ccc3(255, 246, 223)})
  buffSkilllv4:setPosition(CCPoint(buffSkill1:getContentSize().width / 2, 13))
  buffSkill4:addChild(buffSkilllv4, 21)
  DHComponents:mandateNode(labInfo, "yw_petDetails_labInfo")
  DHComponents:mandateNode(labInfoShade, "yw_petDetails_labInfoShade")
  DHComponents:mandateNode(skillIconBg, "yw_petDetails_skillIconBg")
  DHComponents:mandateNode(nameMainSkill, "yw_petDetails_nameMainSkill")
  DHComponents:mandateNode(lvMainSkill, "yw_petDetails_lvMainSkill")
  DHComponents:mandateNode(labSkill, "yw_petDetails_labSkill")
  DHComponents:mandateNode(buffSkill1, "yw_petDetails_buffSkill1")
  DHComponents:mandateNode(buffSkill2, "yw_petDetails_buffSkill2")
  DHComponents:mandateNode(buffSkill3, "yw_petDetails_buffSkill3")
  DHComponents:mandateNode(buffSkill4, "yw_petDetails_buffSkill4")
  container:addChild(bg)
  return ui.petDetailsLayer
end

ui.creatSkillBtn = function(l_2_0, l_2_1, l_2_2)
  local skillIconBg = img.createUISprite(img.ui.hero_skill_bg)
  skillIconBg:setCascadeOpacityEnabled(true)
  skillIconBg._key = l_2_2
  local skillIcon = nil
  if skillIconBg._key == nil then
    skillIcon = img.createSkill(l_2_0)
  else
    skillIcon = img.createPetBuff(l_2_0)
  end
  skillIcon:setPosition(skillIconBg:getContentSize().width / 2, skillIconBg:getContentSize().height / 2)
  skillIconBg:addChild(skillIcon)
  l_2_1:addChild(skillIconBg, 20)
  local tip = {}
  local onTouch = function(l_1_0, l_1_1, l_1_2)
    if skillIconBg._key == nil then
      return true
    end
    if l_1_0 == "began" then
      local skillID = ui.buffSkillMax[key]
      upvalue_1536 = require("ui.tips.skill").createForPet(skillID)
      local pObj = ui.petDetailsLayer.container
      tip:setPosition(CCPoint(pObj:getContentSize().width / 2, pObj:getContentSize().height / 2))
      ui.petDetailsLayer.container:addChild(tip, 21)
    elseif l_1_0 == "ended" then
      tip:removeFromParent()
    end
    return true
   end
  skillIconBg:registerScriptTouchHandler(onTouch)
  skillIconBg:setTouchEnabled(true)
  skillIconBg:setTouchSwallowEnabled(true)
  return skillIconBg
end

return ui

