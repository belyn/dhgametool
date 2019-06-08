-- Command line was: E:\github\dhgametool\scripts\ui\pet\petInfo.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local lbl = require("res.lbl")
local audio = require("res.audio")
local i18n = require("res.i18n")
local net = require("net.netClient")
local petData = require("config.pet")
local skilldata = require("config.skill")
local buffdata = require("config.petskill")
local petExpData = require("config.exppet")
local DHComponents = require("dhcomponents.DroidhangComponents")
local netClient = require("net.netClient")
local player = require("data.player")
local petNetData = require("data.pet")
local bagdata = require("data.bag")
local advancedMax = 4
local buffMaxLv = 30
ui.create = function(l_1_0, l_1_1, l_1_2)
  ui.data = {}
  ui.widget = {}
  ui.data = l_1_0
  ui.widget.petJson = l_1_1
  ui.widget.mainLayer = l_1_2
  ui.data.buffEff = 1
  ui.widget.pet_card_layer = CCLayer:create()
  ui.widget.pet_card_layer:setCascadeOpacityEnabled(true)
  ui.widget.pet_card_layer:setPosition(CCPoint(0, 0))
  l_1_1:addChildFollowSlot("code_card_position2", ui.widget.pet_card_layer)
  ui.widget.pet_info = img.createLogin9Sprite(img.login.dialog)
  ui.widget.pet_info:setPreferredSize(CCSize(470, 455))
  ui.widget.pet_info:setAnchorPoint(CCPoint(0.5, 0.5))
  ui.widget.pet_info:setCascadeOpacityEnabled(true)
  l_1_1:addChildFollowSlot("code_attribute_position", ui.widget.pet_info)
  ui.widget.info_tag = CCMenuItemSprite:create((img.createUISprite(img.ui.pet_info_unsele)), nil, img.createUISprite(img.ui.pet_info_sele))
  ui.widget.info_tag:setEnabled(false)
  ui.widget.info_tag:setPosition(CCPoint(0, 0))
  ui.widget.buff_tag = CCMenuItemSprite:create((img.createUISprite(img.ui.pet_buff_unsele)), nil, img.createUISprite(img.ui.pet_buff_sele))
  ui.widget.buff_tag:setEnabled(true)
  ui.widget.buff_tag:setPosition(CCPoint(0, 0))
  local infoMenu = CCMenu:createWithItem(ui.widget.info_tag)
  ui.widget.pet_info:addChild(infoMenu)
  local buffMenu = CCMenu:createWithItem(ui.widget.buff_tag)
  ui.widget.pet_info:addChild(buffMenu)
  local btnSp = img.createLogin9Sprite(img.login.button_9_small_orange)
  btnSp:setPreferredSize(CCSize(160, 50))
  local labReStore = lbl.createFont1(18, i18n.global.pet_reStore_btn.string, ccc3(118, 37, 5))
  labReStore:setPosition(btnSp:getContentSize().width / 2, btnSp:getContentSize().height / 2 + 2)
  btnSp:addChild(labReStore)
  ui.widget.btnReStore = SpineMenuItem:create(json.ui.button, btnSp)
  local menuReStore = CCMenu:createWithItem(ui.widget.btnReStore)
  menuReStore:setPosition(CCPoint(0, 0))
  ui.widget.pet_card_layer:addChild(menuReStore, 20)
  DHComponents:mandateNode(infoMenu, "yw_petInfo_infoMenu")
  DHComponents:mandateNode(buffMenu, "yw_petInfo_buffMenu")
  DHComponents:mandateNode(ui.widget.btnReStore, "yw_petInfo_btnReStore")
  ui.showMainCard()
  ui.showInfo(true)
  ui.showBuff(false)
  ui.CallFun()
  local onUpdate = function()
    ui.showUpLvNeed()
    ui.showUpBuffNeed()
   end
  ui.widget.pet_card_layer:scheduleUpdateWithPriorityLua(onUpdate)
  return ui.widget
end

ui.createJsonCard = function(l_2_0)
  local stencil = img.createUISprite(img.ui.pet_deer_1)
  stencilSize = stencil:getContentSize()
  local mySize = CCSize(stencilSize.width - 20, stencilSize.height - 40)
  local Scroll = CCScrollView:create()
  Scroll:setAnchorPoint(CCPoint(0.5, 0.5))
  Scroll:setPosition(10, 15)
  Scroll:setDirection(kCCScrollViewDirectionHorizontal)
  Scroll:setViewSize(mySize)
  Scroll:setContentSize(mySize)
  Scroll:setTouchEnabled(false)
  Scroll:setCascadeOpacityEnabled(true)
  Scroll:getContainer():setCascadeOpacityEnabled(true)
  local rightAnimBg = json.create(l_2_0)
  rightAnimBg:setPosition(stencilSize.width / 2, 0)
  rightAnimBg:playAnimation("stand", -1)
  Scroll:addChild(rightAnimBg)
  return Scroll
end

ui.showInfo = function(l_3_0)
  if ui.widget.infoLayer == nil then
    ui.widget.infoLayer = CCLayer:create()
    ui.widget.infoLayer:setPosition(CCPoint(300, 300))
    ui.widget.infoLayer:setCascadeOpacityEnabled(true)
    ui.widget.pet_info:addChild(ui.widget.infoLayer)
    local labInfo = lbl.createFont1(24, i18n.global.pet_info.string, ccc3(230, 208, 174))
    ui.widget.infoLayer:addChild(labInfo, 2)
    local labInfoShade = lbl.createFont1(24, i18n.global.pet_info.string, ccc3(89, 48, 27))
    ui.widget.infoLayer:addChild(labInfoShade, 1)
    local framInfo = img.createUI9Sprite(img.ui.botton_fram_2)
    framInfo:setPreferredSize(CCSizeMake(410, 240))
    framInfo:setAnchorPoint(CCPoint(0, 0))
    ui.widget.infoLayer:addChild(framInfo)
    ui.widget.infoLvSpine = json.create(json.ui.pet2_json)
    ui.widget.infoLvSpine:setScaleY(0.95)
    ui.widget.infoLvSpine:setScaleX(1.15)
    ui.widget.infoLvSpine:setPosition(-244, -50)
    ui.widget.infoLayer:addChild(ui.widget.infoLvSpine, 50)
    local labAdv = lbl.createFont1(20, i18n.global.pet_advanced.string, ccc3(114, 59, 15))
    ui.widget.infoLayer:addChild(labAdv)
    local starLayer = CCLayer:create()
    starLayer:setContentSize(CCSize(100, 50))
    starLayer:setCascadeOpacityEnabled(true)
    ui.widget.infoLayer:addChild(starLayer)
    ui.widget.advStar = {}
    for i = 1, advancedMax do
      local advStarBg = img.createUISprite(img.ui.hero_star0)
      advStarBg:setPosition(CCPoint(i * 30, 0))
      starLayer:addChild(advStarBg)
      ui.widget.advStar[i] = img.createUISprite(img.ui.hero_star1)
      ui.widget.advStar[i]:setPosition(CCPoint(i * 30, 0))
      starLayer:addChild(ui.widget.advStar[i])
    end
    ui.showStar()
    local labLV = lbl.createFont1(20, "LV:", ccc3(145, 59, 56))
    ui.widget.infoLayer:addChild(labLV)
    ui.widget.petMainLV = lbl.createFont1(20, "/", ccc3(80, 39, 21))
    ui.widget.infoLayer:addChild(ui.widget.petMainLV)
    ui.showLv()
    ui.widget.btnUpLV = SpineMenuItem:create(json.ui.button, img.createUISprite(img.ui.hero_btn_lvup))
    ui.widget.btnAdvanced = SpineMenuItem:create(json.ui.button, img.createUISprite(img.ui.hero_btn_lvup))
    local menuAdvanced = CCMenu:createWithItem(ui.widget.btnAdvanced)
    menuAdvanced:setPosition(CCPoint(0, 0))
    ui.widget.infoLayer:addChild(menuAdvanced, 20)
    local menuUpLV = CCMenu:createWithItem(ui.widget.btnUpLV)
    menuUpLV:setPosition(CCPoint(0, 0))
    ui.widget.infoLayer:addChild(menuUpLV, 20)
    ui.showUpLvNeed()
    local skillIconBg = ui.creatSkillBtn(petData[ui.data.id].actSkillId, ui.widget.infoLayer)
    ui.widget.nameMainSkill = lbl.createMix({font = 1, size = 20, text = i18n.skill[petData[ui.data.id].actSkillId].skillName, width = 380, color = ccc3(114, 63, 35), align = kCCTextAlignmentLeft})
    ui.widget.nameMainSkill:setAnchorPoint(CCPoint(0, 0))
    ui.widget.infoLayer:addChild(ui.widget.nameMainSkill, 20)
    ui.widget.lvMainSkill = lbl.createFont1(20, "LV:", ccc3(145, 59, 56))
    ui.widget.infoLayer:addChild(ui.widget.lvMainSkill, 20)
    ui.widget.labSkill = lbl.createMix({font = 1, size = 16, text = "--", width = 350, color = ccc3(142, 93, 67), align = kCCTextAlignmentLeft})
    ui.widget.infoLayer:addChild(ui.widget.labSkill, 20)
    DHComponents:mandateNode(ui.widget.btnAdvanced, "yw_petInfo_btnAdvanced")
    DHComponents:mandateNode(ui.widget.btnUpLV, "yw_petInfo_btnUpLV")
    DHComponents:mandateNode(starLayer, "yw_petInfo_starLayer")
    DHComponents:mandateNode(framInfo, "yw_petInfo_framInfo")
    DHComponents:mandateNode(labAdv, "yw_petInfo_labAdv")
    DHComponents:mandateNode(labInfo, "yw_petInfo_labTitle")
    DHComponents:mandateNode(labInfoShade, "yw_petInfo_labTitleShade")
    DHComponents:mandateNode(labLV, "yw_petInfo_labLV")
    DHComponents:mandateNode(ui.widget.petMainLV, "yw_petInfo_petMainLV")
    DHComponents:mandateNode(skillIconBg, "yw_petInfo_skillIcon")
    DHComponents:mandateNode(ui.widget.lvMainSkill, "yw_petInfo_lvMainSkill")
    DHComponents:mandateNode(ui.widget.labSkill, "yw_petInfo_labSkill")
    ui.showMainSkillLable()
  end
  ui.widget.infoLayer:setVisible(l_3_0)
end

ui.showBuff = function(l_4_0)
  if ui.widget.buffLayer == nil then
    ui.widget.buffLayer = CCLayer:create()
    ui.widget.buffLayer:setCascadeOpacityEnabled(true)
    ui.widget.buffLayer:setPosition(CCPoint(300, 300))
    ui.widget.pet_info:addChild(ui.widget.buffLayer)
    local framBuff = img.createUI9Sprite(img.ui.botton_fram_2)
    framBuff:setPreferredSize(CCSizeMake(430, 120))
    framBuff:setAnchorPoint(CCPoint(0, 0))
    ui.widget.buffLayer:addChild(framBuff)
    local labBuff = lbl.createFont1(24, i18n.global.pet_buff.string, ccc3(230, 208, 174))
    ui.widget.buffLayer:addChild(labBuff, 2)
    local labBuffShade = lbl.createFont1(24, i18n.global.pet_buff.string, ccc3(89, 48, 27))
    ui.widget.buffLayer:addChild(labBuffShade, 1)
    btnSp = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnSp:setPreferredSize(CCSize(180, 56))
    local labUpgrade = lbl.createFont1(18, i18n.global.pet_upLevel.string, ccc3(118, 37, 5))
    labUpgrade:setPosition(btnSp:getContentSize().width / 2, btnSp:getContentSize().height / 2 + 2)
    btnSp:addChild(labUpgrade)
    ui.widget.btnUpgrade = SpineMenuItem:create(json.ui.button, btnSp)
    ui.widget.btnUpgrade:setPosition(CCPoint(0, 0))
    local menuUpgrade = CCMenu:createWithItem(ui.widget.btnUpgrade)
    menuUpgrade:setPosition(CCPoint(0, 0))
    ui.widget.buffLayer:addChild(menuUpgrade)
    ui.widget.skillIconBg = {}
    ui.widget.skillIconBg[1] = ui.creatSkillBtn(petData[ui.data.id].pasSkillId[1], ui.widget.buffLayer, 1)
    ui.widget.skillIconBg[2] = ui.creatSkillBtn(petData[ui.data.id].pasSkillId[2], ui.widget.buffLayer, 2)
    ui.widget.skillIconBg[3] = ui.creatSkillBtn(petData[ui.data.id].pasSkillId[3], ui.widget.buffLayer, 3)
    ui.widget.skillIconBg[4] = ui.creatSkillBtn(petData[ui.data.id].pasSkillId[4], ui.widget.buffLayer, 4)
    ui.widget.skillIconBg[1].lv = lbl.create({font = 2, size = 16, text = "LV:--", color = ccc3(255, 246, 223)})
    ui.widget.skillIconBg[1]:addChild(ui.widget.skillIconBg[1].lv, 21)
    ui.widget.skillIconBg[2].lv = lbl.create({font = 2, size = 16, text = "LV:--", color = ccc3(255, 246, 223)})
    ui.widget.skillIconBg[2]:addChild(ui.widget.skillIconBg[2].lv, 21)
    ui.widget.skillIconBg[3].lv = lbl.create({font = 2, size = 16, text = "LV:--", color = ccc3(255, 246, 223)})
    ui.widget.skillIconBg[3]:addChild(ui.widget.skillIconBg[3].lv, 21)
    ui.widget.skillIconBg[4].lv = lbl.create({font = 2, size = 16, text = "LV:--", color = ccc3(255, 246, 223)})
    ui.widget.skillIconBg[4]:addChild(ui.widget.skillIconBg[4].lv, 21)
    ui.widget.buffLvSpine = json.create(json.ui.pet2_json)
    ui.widget.buffLvSpine:setScale(view.minScale)
    ui.widget.buffLayer:addChild(ui.widget.buffLvSpine, 50)
    ui.showBuffLv()
    ui.showBuffSele(ui.data.buffEff)
    ui.showBuffuffBtnShader()
    ui.showUpBuffNeed()
    ui.showBuffAllAddData()
    DHComponents:mandateNode(framBuff, "yw_petBuff_framBuff")
    DHComponents:mandateNode(labBuff, "yw_petInfo_labTitle")
    DHComponents:mandateNode(labBuffShade, "yw_petInfo_labTitleShade")
    DHComponents:mandateNode(ui.widget.btnUpgrade, "yw_petBuff_btnUpgrade")
    DHComponents:mandateNode(ui.widget.skillIconBg[1], "yw_petBuff_skillIconBg_1")
    DHComponents:mandateNode(ui.widget.skillIconBg[2], "yw_petBuff_skillIconBg_2")
    DHComponents:mandateNode(ui.widget.skillIconBg[3], "yw_petBuff_skillIconBg_3")
    DHComponents:mandateNode(ui.widget.skillIconBg[4], "yw_petBuff_skillIconBg_4")
    DHComponents:mandateNode(ui.widget.skillIconBg[1].lv, "yw_petBuff_skillIconBg_LV")
    DHComponents:mandateNode(ui.widget.skillIconBg[2].lv, "yw_petBuff_skillIconBg_LV")
    DHComponents:mandateNode(ui.widget.skillIconBg[3].lv, "yw_petBuff_skillIconBg_LV")
    DHComponents:mandateNode(ui.widget.skillIconBg[4].lv, "yw_petBuff_skillIconBg_LV")
  end
  ui.widget.buffLayer:setVisible(l_4_0)
end

ui.clear = function(l_5_0)
  l_5_0:removeChildFollowSlot("code_card_position2")
  l_5_0:removeChildFollowSlot("code_attribute_position")
  l_5_0:removeChildFollowSlot("code_attribute_position2")
  l_5_0:removeChildFollowSlot("code_icon")
  l_5_0:removeChildFollowSlot("code_black")
  l_5_0:removeChildFollowSlot("code_card2")
  ui.data = nil
  ui.widget = nil
end

ui.showBuffLv = function()
  for i = 1, advancedMax do
    if ui.data.advanced < i then
      ui.widget.skillIconBg[i].lv:setVisible(false)
    else
      ui.widget.skillIconBg[i].lv:setVisible(true)
      if ui.data.buffLv[i] == 30 then
        ui.widget.skillIconBg[i].lv:setString("LV:Max")
      else
        if ui.data.buffLv[i] == nil then
          ui.data.buffLv[i] = 1
        end
        ui.widget.skillIconBg[i].lv:setString("LV:" .. ui.data.buffLv[i])
      end
    end
  end
end

ui.showMainCard = function()
  if ui.widget.pet_image ~= nil then
    ui.widget.pet_image:removeFromParent()
    ui.widget.pet_image = nil
  end
  if ui.widget.pet_card ~= nil then
    ui.widget.pet_card:removeFromParent()
    ui.widget.pet_card = nil
  end
  local path = img.ui.pet_card
  if petNetData.getData(ui.data.id).advanced == 2 or petNetData.getData(ui.data.id).advanced == 3 then
    path = img.ui.pet_card2
  else
    if petNetData.getData(ui.data.id).advanced == 4 then
      path = img.ui.pet_card3
    end
  end
  ui.widget.pet_card = img.createUISprite(path)
  ui.widget.pet_card:setPosition(CCPoint(0, 0))
  ui.widget.pet_card_layer:addChild(ui.widget.pet_card, 20)
  ui.widget.pet_image = img.createUISprite(img.ui[petData[ui.data.id].petBody .. ui.data.advanced])
  ui.widget.pet_image:setCascadeOpacityEnabled(true)
  ui.widget.pet_card_layer:addChild(ui.widget.pet_image, 10)
  local name = string.gsub(petData[ui.data.id].petBody, "pet_", "spine_")
  ui.widget.pet_spine = ui.createJsonCard(json.ui[name .. ui.data.advanced])
  ui.widget.pet_image:addChild(ui.widget.pet_spine, 12)
  if ui.data.advanced == 4 then
    local lightJson = json.create(json.ui.pet_json)
    do
      lightJson:setCascadeOpacityEnabled(true)
      lightJson:setScale(1.21)
      lightJson:setPositionX(ui.widget.pet_image:getContentSize().width / 2)
      lightJson:setPositionY(ui.widget.pet_image:getContentSize().height / 2)
      lightJson:playAnimation(petData[ui.data.id].petEff, -1)
      lightJson:setVisible(false)
      ui.widget.pet_image:addChild(lightJson, 5)
      lightJson:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCCallFunc:create(function()
        lightJson:setVisible(true)
         end)))
    end
  end
end

ui.showBuffSele = function(l_8_0)
  if ui.data.advanced < l_8_0 then
    return 
  end
  if ui.widget.buffSele ~= nil then
    ui.widget.buffSele:removeFromParent()
    ui.widget.buffSele = nil
  end
  ui.widget.buffLvSpine:setPosition(ui.widget.skillIconBg[l_8_0]:getPosition())
  ui.data.buffEff = l_8_0
  ui.widget.buffSele = img.createUISprite(img.ui.pet_skill_sele)
  ui.widget.buffSele:setPosition(CCPoint(42, 42))
  ui.widget.skillIconBg[l_8_0]:addChild(ui.widget.buffSele)
end

ui.showBuffAllAddData = function()
  local allData = {}
  for key,val in pairs(petData[ui.data.id].pasSkillId) do
    if ui.data.advanced < key then
      do return end
    end
    local effect = buffdata[ui.data.skl[key]].effect
    for k,v in pairs(effect) do
      if allData[effect[k].type] == nil then
        allData[effect[k].type] = effect[k].num
        for k,v in (for generator) do
        end
        allData[effect[k].type] = allData[effect[k].type] + effect[k].num
      end
    end
    if ui.widget.allBuffLayer ~= nil then
      ui.widget.allBuffLayer:removeFromParent()
      ui.widget.allBuffLayer = nil
    end
    ui.widget.allBuffLayer = CCLayer:create()
    do
      local numberLab = 1
      for k,v in pairs(allData) do
        local name, number = buffString(k, v)
        local labName = lbl.createFont1(16, name, ccc3(145, 59, 56))
        if labName == nil then
          print("\229\189\147K =  " .. k .. "\230\151\182\239\188\140labName = nil\239\188\140and name = ", name)
        else
          labName:setAnchorPoint(0, 0.5)
          ui.widget.allBuffLayer:addChild(labName)
        end
        local lblNumber = lbl.createFont1(16, "+" .. number, ccc3(80, 39, 21))
        if lblNumber ~= nil then
          lblNumber:setAnchorPoint(0, 0.5)
          ui.widget.allBuffLayer:addChild(lblNumber)
        end
        DHComponents:mandateNode(labName, "yw_petBuff_labName" .. numberLab)
        DHComponents:mandateNode(lblNumber, "yw_petBuff_number" .. numberLab)
        numberLab = numberLab + 1
      end
      ui.widget.allBuffLayer:setPosition(CCPoint(0, 0))
      ui.widget.buffLayer:addChild(ui.widget.allBuffLayer, 30)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.showUpLvNeed = function()
  if not petData[ui.data.id].starLv[ui.data.advanced] then
    local maxLv = petData[ui.data.id].maxLv
  end
  ui.widget.infoLayer:removeChildByTag(1001)
  if ui.data.lv < maxLv then
    setShader(ui.widget.btnAdvanced, SHADER_GRAY, true)
    local CostBg = img.createUI9Sprite(img.ui.hero_lv_cost_bg)
    CostBg:setPreferredSize(CCSize(220, 40))
    ui.widget.infoLayer:addChild(CostBg, 20, 1001)
    local expPetID = math.floor(ui.data.id / 100) * 1000 + ui.data.lv
    local i = 0
    for k,v in pairs(petExpData[expPetID].need) do
      local icon = img.createItemIcon2(v.type)
      icon:setPosition(CCPoint(i * 110 + 21, 20))
      CostBg:addChild(icon, 20, 100)
      local numLab = lbl.create({font = 2, size = 16, text = num2KM(v.count), color = ccc3(255, 246, 223)})
      numLab:setPosition(CCPoint(i * 100 + 65, 20))
      CostBg:addChild(numLab)
      local bagCount = bagdata.items.find(v.type)
      if bagCount.num < tonumber(v.count) then
        numLab:setColor(ccc3(255, 44, 44))
      end
      i = i + 1
    end
    DHComponents:mandateNode(CostBg, "yw_petInfo_CostBg")
  else
    local img_maxlv = img.ui.hero_maxlv
    if i18n.getCurrentLanguage() == kLanguageChinese then
      img_maxlv = img.ui.hero_maxlv_cn
    else
      if i18n.getCurrentLanguage() == kLanguageChineseTW then
        img_maxlv = img.ui.hero_maxlv_tw
      else
        if i18n.getCurrentLanguage() == kLanguageJapanese then
          img_maxlv = img.ui.hero_maxlv_jp
        else
          if i18n.getCurrentLanguage() == kLanguageRussian then
            img_maxlv = img.ui.hero_maxlv_ru
          else
            if i18n.getCurrentLanguage() == kLanguageKorean then
              img_maxlv = img.ui.hero_maxlv_kr
            end
          end
        end
      end
    end
    local CostBg = img.createUI9Sprite(img_maxlv)
    ui.widget.infoLayer:addChild(CostBg, 20, 1001)
    DHComponents:mandateNode(CostBg, "yw_petInfo_CostBgSp")
    clearShader(ui.widget.btnAdvanced, true)
  end
  if maxLv <= ui.data.lv then
    ui.widget.btnUpLV:setVisible(false)
  else
    ui.widget.btnUpLV:setVisible(true)
  end
  if advancedMax <= ui.data.advanced then
    ui.widget.btnAdvanced:setVisible(false)
  else
    ui.widget.btnAdvanced:setVisible(true)
  end
end

ui.showUpBuffNeed = function()
  ui.widget.buffLayer:removeChildByTag(1001)
  ui.widget.buffLayer:removeChildByTag(1002)
  if ui.data.buffLv[ui.data.buffEff] >= 30 then
    return 
  end
  local CostBg = {}
  CostBg[1] = img.createUI9Sprite(img.ui.hero_evolve_cost_bg)
  CostBg[1]:setPreferredSize(CCSize(170, 30))
  ui.widget.buffLayer:addChild(CostBg[1], 20, 1001)
  CostBg[2] = img.createUI9Sprite(img.ui.hero_evolve_cost_bg)
  CostBg[2]:setPreferredSize(CCSize(170, 30))
  ui.widget.buffLayer:addChild(CostBg[2], 20, 1002)
  local i = 1
  if buffdata[ui.data.skl[ui.data.buffEff]] == nil or buffdata[ui.data.skl[ui.data.buffEff]].need == nil then
    return 
  end
  for k,v in pairs(buffdata[ui.data.skl[ui.data.buffEff]].need) do
    local icon = img.createItemIcon2(v.type)
    icon:setPosition(CCPoint(5, 15))
    CostBg[i]:addChild(icon, 20)
    local numLab = lbl.create({font = 2, size = 16, text = v.count, color = ccc3(255, 247, 230)})
    numLab:setPosition(CCPoint(85, 16))
    numLab:setAnchorPoint(CCPoint(0.5, 0.5))
    CostBg[i]:addChild(numLab)
    i = i + 1
    local bagCount = bagdata.items.find(v.type)
    if bagCount.num < tonumber(v.count) then
      numLab:setColor(ccc3(255, 44, 44))
    end
  end
  DHComponents:mandateNode(CostBg[1], "yw_buffInfo_CostBg_1")
  DHComponents:mandateNode(CostBg[2], "yw_buffInfo_CostBg_2")
end

ui.showStar = function()
  for i = 1, advancedMax do
    ui.widget.advStar[i]:setVisible(true)
    if ui.data.advanced < i then
      ui.widget.advStar[i]:setVisible(false)
    end
  end
end

ui.showMainSkillLable = function()
  print(petData[ui.data.id].actSkillId + ui.data.lv - 1 .. "\230\138\128\232\131\189\229\134\133\229\174\185 = " .. i18n.skill[petData[ui.data.id].actSkillId + ui.data.lv - 1].desc)
  ui.widget.labSkill:setString(i18n.skill[petData[ui.data.id].actSkillId + ui.data.lv - 1].desc)
  ui.widget.lvMainSkill:setString("LV." .. ui.data.lv)
  local x = ui.widget.lvMainSkill:getPositionX() + (152 + ui.widget.lvMainSkill:boundingBox():getMaxX())
  ui.widget.nameMainSkill:setPosition(CCPoint(x, ui.widget.lvMainSkill:getPositionY()))
end

ui.showBuffuffBtnShader = function()
  for k,v in pairs(ui.widget.skillIconBg) do
    if ui.data.advanced < v._key then
      setShader(v, SHADER_GRAY, true)
      for k,v in (for generator) do
      end
      clearShader(v, true)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.showLv = function()
  if not petData[ui.data.id].starLv[ui.data.advanced] then
    local maxLv = petData[ui.data.id].maxLv
  end
  ui.widget.petMainLV:setString(ui.data.lv .. "/" .. maxLv)
end

ui.creatSkillBtn = function(l_16_0, l_16_1, l_16_2)
  local skillIconBg = img.createUISprite(img.ui.hero_skill_bg)
  skillIconBg:setCascadeOpacityEnabled(true)
  skillIconBg._key = l_16_2
  local skillIcon = nil
  if skillIconBg._key == nil then
    skillIcon = img.createSkill(l_16_0)
  else
    skillIcon = img.createPetBuff(l_16_0)
  end
  skillIcon:setPosition(skillIconBg:getContentSize().width / 2, skillIconBg:getContentSize().height / 2)
  skillIconBg:addChild(skillIcon)
  l_16_1:addChild(skillIconBg, 20)
  local tip = {}
  local onTouch = function(l_1_0, l_1_1, l_1_2)
    if skillIconBg._key == nil then
      return true
    end
    if l_1_0 == "began" then
      local skillID = ui.data.skl[key]
      if ui.data.skl[key] == nil then
        print("petID = " .. ui.data.id)
        skillID = petData[ui.data.id].pasSkillId[key]
      end
      upvalue_2048 = require("ui.tips.skill").createForPet(skillID)
      tip:setPosition(CCPoint(240, 320))
      ui.widget.pet_info:addChild(tip, 21)
    elseif l_1_0 == "ended" then
      ui.showBuffSele(skillIconBg._key)
      ui.showUpBuffNeed()
      tip:removeFromParent()
    end
    return true
   end
  skillIconBg:registerScriptTouchHandler(onTouch)
  skillIconBg:setTouchEnabled(true)
  skillIconBg:setTouchSwallowEnabled(true)
  return skillIconBg
end

ui.refreshAllShow = function()
  ui.showBuffSele(1)
  ui.showBuffLv()
  ui.showMainCard()
  ui.showBuffAllAddData()
  ui.showUpLvNeed()
  ui.showUpBuffNeed()
  ui.showStar()
  ui.showMainSkillLable()
  ui.showBuffuffBtnShader()
  ui.showLv()
end

ui.createAdvancedWindow = function()
  local layer = CCLayer:create()
  ui.widget.mainLayer:getParent():addChild(layer, 1000)
  local darkBg = CCLayer:create()
  darkBg:setTouchEnabled(true)
  darkBg:setScale(view.maxScale)
  darkBg:addChild(CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY)))
  darkBg:registerScriptTouchHandler(function(l_1_0)
    if l_1_0 == "began" then
      return false
    end
   end)
  ui.widget.mainLayer:getParent():addChild(darkBg, 999)
  local bg = img.createUI9Sprite(img.ui.dialog_1)
  bg:setPreferredSize(CCSizeMake(490, 470))
  bg:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(bg)
  bg:setScale(0.5)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  bg:runAction(CCSequence:create(anim_arr))
  local lbl_title = lbl.createFont1(24, i18n.global.pet_war_advanced.string, ccc3(230, 208, 174))
  bg:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.pet_war_advanced.string, ccc3(89, 48, 27))
  bg:addChild(lbl_title_shadowD)
  local lvLabel = lbl.createFont2(20, i18n.global.hero_wake_level_up.string, ccc3(252, 234, 141))
  bg:addChild(lvLabel)
  local nowLv = petData[ui.data.id].starLv[ui.data.advanced]
  local nextLv = nowLv
  if ui.data.advanced ==  petData[ui.data.id].starLv then
    nextLv = petData[ui.data.id].maxLv
  else
    nextLv = petData[ui.data.id].starLv[ui.data.advanced + 1]
  end
  local nowLvLabel = lbl.createFont2(20, nowLv, ccc3(255, 246, 223))
  bg:addChild(nowLvLabel)
  local nextLvLabel = lbl.createFont2(20, nextLv, ccc3(159, 242, 62))
  bg:addChild(nextLvLabel)
  local arrowPic = img.createUISprite(img.ui.arrow)
  bg:addChild(arrowPic)
  local bottomBox = img.createUI9Sprite(img.ui.hero_attribute_lab_frame)
  bottomBox:setOpacity(200)
  bottomBox:setPreferredSize(CCSizeMake(370, 170))
  bg:addChild(bottomBox)
  local unlockLabel = lbl.createFont1(20, i18n.global.hero_unlock.string, ccc3(147, 98, 69))
  bg:addChild(unlockLabel)
  local auraBg = img.createUISprite(img.ui.hero_skill_bg)
  bg:addChild(auraBg)
  local unlockAura = img.createPetBuff(petData[ui.data.id].pasSkillId[ui.data.advanced + 1])
  bg:addChild(unlockAura)
  local goldBg = img.createUI9Sprite(img.ui.hero_evolve_cost_bg)
  goldBg:setPreferredSize(CCSize(160, 30))
  bg:addChild(goldBg)
  local soulBg = img.createUI9Sprite(img.ui.hero_evolve_cost_bg)
  soulBg:setPreferredSize(CCSize(160, 30))
  bg:addChild(soulBg)
  local goldIcon = img.createItemIcon2(ITEM_ID_COIN)
  goldBg:addChild(goldIcon)
  local soulIcon = img.createItemIcon2(ITEM_ID_PET_DEVIL)
  soulBg:addChild(soulIcon)
  local goldNum = 0
  local soulNum = 0
  local starTable = petData[ui.data.id].starExp
  for k,v in pairs(starTable) do
    if v.type == ITEM_ID_COIN and ui.data.advanced == v.star then
      goldNum = v.count
      for k,v in (for generator) do
      end
      if v.type == ITEM_ID_PET_DEVIL and ui.data.advanced == v.star then
        soulNum = v.count
      end
    end
    local goldLabel = lbl.createFont2(16, goldNum, ccc3(255, 246, 223))
    goldBg:addChild(goldLabel)
    local soulLabel = lbl.createFont2(16, soulNum, ccc3(255, 246, 223))
    soulBg:addChild(soulLabel)
    if bagdata.items.find(ITEM_ID_COIN).num < goldNum then
      goldLabel:setColor(ccc3(255, 44, 44))
    end
    if bagdata.items.find(ITEM_ID_PET_DEVIL).num < soulNum then
      soulLabel:setColor(ccc3(255, 44, 44))
    end
    local btn_close = SpineMenuItem:create(json.ui.button, img.createUISprite(img.ui.close))
    btn_close:setPosition(CCPoint(bg:getContentSize().width - 25, bg:getContentSize().height - 28))
    local btn_close_menu = CCMenu:createWithItem(btn_close)
    btn_close_menu:setPosition(CCPoint(0, 0))
    bg:addChild(btn_close_menu, 100)
    btn_close:registerScriptTapHandler(function()
      audio.play(audio.button)
      ui.widget.petJson:removeChildFollowSlot("code_card2")
      ui.widget.petJson:removeChildFollowSlot("code_icon")
      ui.widget.petJson:removeChildFollowSlot("code_black")
      layer:removeFromParent()
      darkBg:removeFromParent()
      end)
    local advanceImg = img.createUI9Sprite(img.ui.btn_2)
    advanceImg:setPreferredSize(CCSize(200, 60))
    local advanceBtn = SpineMenuItem:create(json.ui.button, advanceImg)
    local advanceMenu = CCMenu:createWithItem(advanceBtn)
    advanceMenu:setPosition(CCPoint(0, 0))
    bg:addChild(advanceMenu)
    do
      local advanceLabel = lbl.createFont1(20, i18n.global.hero_advance.string, ccc3(114, 59, 15))
      advanceLabel:setPosition(CCPoint(100, 30))
      advanceImg:addChild(advanceLabel)
      advanceBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer:setVisible(false)
      darkBg:setVisible(false)
      local starExp = tablecp(petData[ui.data.id].starExp)
      for k,v in pairs(starExp) do
        if v.star ~= ui.data.advanced then
          starExp[k] = nil
        end
      end
      if require("ui.pet.main").subItem(starExp) == false then
        return 
      end
      local playAni = function()
        ui.widget.petJson:playAnimation("upgrade")
        local pasSkillId = petData[ui.data.id].pasSkillId
        local myPetBuffKey = pasSkillId[ui.data.advanced + 1]
        local showSkill = img.createPetBuff(myPetBuffKey)
        setShader(showSkill, SHADER_GRAY, true)
        ui.widget.petJson:addChildFollowSlot("code_icon", showSkill)
        local nameSkill = lbl.createMix({font = 1, size = 24, text = i18n.petskill[pasSkillId[ui.data.advanced + 1]].skillName, width = 200, color = ccc3(255, 255, 255)})
        nameSkill:setPositionY(-20)
        ui.widget.petJson:addChildFollowSlot("code_text", nameSkill)
        local myUpTime = ui.widget.petJson:getEventTime("upgrade", "fx")
        ui.widget.petJson:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(myUpTime), CCCallFunc:create(function()
          local showSkill2 = img.createPetBuff(myPetBuffKey)
          ui.widget.petJson:addChildFollowSlot("code_icon", showSkill2)
            end)))
        local card = img.createUISprite(img.ui[petData[ui.data.id].petBody .. ui.data.advanced])
        card:setCascadeOpacityEnabled(true)
        card:setPosition(CCPoint(card:getContentSize().width / 2, card:getContentSize().height / 2))
        local mySize = card:getContentSize()
        local name = string.gsub(petData[ui.data.id].petBody, "pet_", "spine_")
        local clippingSp = ui.createJsonCard(json.ui[name .. ui.data.advanced])
        local path = img.ui.pet_card
        if petNetData.getData(ui.data.id).advanced == 2 or petNetData.getData(ui.data.id).advanced == 3 then
          path = img.ui.pet_card2
        else
          if petNetData.getData(ui.data.id).advanced == 4 then
            path = img.ui.pet_card3
          end
        end
        do
          local card_bg = img.createUISprite(path)
          card_bg:setCascadeOpacityEnabled(true)
          card_bg:setPosition(CCPoint(0, 0))
          card:addChild(clippingSp, 12)
          card_bg:addChild(card, -1)
          ui.widget.petJson:addChildFollowSlot("code_card2", card_bg)
          require("ui.pet.main").createMaskLayer(1.8)
          ui.widget.btnAdvanced:runAction(createSequence({}))
        end
         -- Warning: undefined locals caused missing assignments!
         end
      local params = {sid = player.sid, id = ui.data.id, opcode = 3}
      addWaitNet()
      netClient:pet_op(params, function(l_2_0)
        if l_2_0.status == 0 then
          playAni()
        end
        petNetData.coutRsult(3, l_2_0.status)
        delWaitNet()
         end)
      end)
      DHComponents:mandateNode(lbl_title, "lpx_petInfo_title")
      DHComponents:mandateNode(lbl_title_shadowD, "lpx_petInfo_titleShadow")
      DHComponents:mandateNode(lvLabel, "lpx_petInfo_lvLabel")
      DHComponents:mandateNode(nowLvLabel, "lpx_petInfo_nowLvLabel")
      DHComponents:mandateNode(nextLvLabel, "lpx_petInfo_nextLvLabel")
      DHComponents:mandateNode(arrowPic, "lpx_petInfo_arrowPic")
      DHComponents:mandateNode(bottomBox, "lpx_petInfo_bottomBox")
      DHComponents:mandateNode(unlockLabel, "lpx_petInfo_unlockLabel")
      DHComponents:mandateNode(auraBg, "lpx_petInfo_unlockAura")
      DHComponents:mandateNode(unlockAura, "lpx_petInfo_unlockAura")
      DHComponents:mandateNode(goldBg, "lpx_petInfo_goldBg")
      DHComponents:mandateNode(soulBg, "lpx_petInfo_soulBg")
      DHComponents:mandateNode(goldIcon, "lpx_petInfo_goldIcon")
      DHComponents:mandateNode(soulIcon, "lpx_petInfo_soulIcon")
      DHComponents:mandateNode(goldLabel, "lpx_petInfo_goldLabel")
      DHComponents:mandateNode(soulLabel, "lpx_petInfo_soulLabel")
      DHComponents:mandateNode(advanceBtn, "lpx_petInfo_advanceBtn")
      return layer
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.getAllback = function()
  local allBack = {}
  local toAllBack = function(l_1_0)
    for k,v in pairs(l_1_0) do
      if not allBack[v.type] then
        allBack[v.type] = (v.count == 0 or 0) + v.count
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  toAllBack(petExpData[math.floor(ui.data.id / 100) * 1000 + ui.data.lv].back)
  for i = 1, advancedMax do
    if ui.data.skl[i] ~= nil then
      toAllBack(buffdata[ui.data.skl[i]].back)
    end
  end
  local retrunTable = {}
  for k,v in pairs(allBack) do
    table.insert(retrunTable, {count = v, type = k})
  end
  return retrunTable
end

ui.CallFun = function()
  ui.widget.buff_tag:registerScriptTapHandler(function()
    ui.widget.buff_tag:setEnabled(false)
    ui.widget.info_tag:setEnabled(true)
    ui.showInfo(false)
    ui.showBuff(true)
   end)
  ui.widget.info_tag:registerScriptTapHandler(function()
    ui.widget.buff_tag:setEnabled(true)
    ui.widget.info_tag:setEnabled(false)
    ui.showInfo(true)
    ui.showBuff(false)
   end)
  ui.widget.btnAdvanced:registerScriptTapHandler(function()
    if not petData[ui.data.id].starLv[ui.data.advanced] then
      local maxLv = petData[ui.data.id].maxLv
    end
    if ui.data.lv < maxLv then
      showToast(string.format(i18n.global.pet_upSfail_forLv.string))
      return 
    end
    local starExp = tablecp(petData[ui.data.id].starExp)
    for k,v in pairs(starExp) do
      if v.star ~= ui.data.advanced then
        starExp[k] = nil
      end
    end
    if advancedMax <= ui.data.advanced then
      showToast(string.format(i18n.global.pet_stars_lv_max.string))
      return 
    end
    local advanceUI = ui.createAdvancedWindow()
   end)
  ui.widget.btnUpLV:registerScriptTapHandler(function()
    audio.play(audio.button)
    if not petData[ui.data.id].starLv[ui.data.advanced] then
      local maxLv = petData[ui.data.id].maxLv
    end
    if maxLv <= ui.data.lv then
      showToast(string.format(i18n.global.pet_skill_lv_max.string))
      return 
    end
    local expPetID = math.floor(ui.data.id / 100) * 1000 + ui.data.lv
    if require("ui.pet.main").subItem(petExpData[expPetID].need) == false then
      return 
    end
    local params = {sid = player.sid, id = ui.data.id, opcode = 2}
    addWaitNet()
    netClient:pet_op(params, function(l_1_0)
      if l_1_0.status == 0 then
        ui.widget.infoLvSpine:playAnimation("info_refresh")
        ui.data.lv = ui.data.lv + 1
        ui.showLv()
        ui.showMainSkillLable()
        ui.showUpLvNeed()
      end
      petNetData.coutRsult(2, l_1_0.status)
      delWaitNet()
      end)
   end)
  ui.widget.btnUpgrade:registerScriptTapHandler(function()
    if ui.data.buffLv[ui.data.buffEff] >= 30 then
      showToast(string.format(i18n.global.pet_buff_lv_max.string))
      return 
    end
    local buffId = ui.data.skl[ui.data.buffEff]
    if require("ui.pet.main").subItem(buffdata[buffId].need) == false then
      return 
    end
    local params = {sid = player.sid, id = ui.data.id, opcode = 4, skl = buffId}
    addWaitNet()
    netClient:pet_op(params, function(l_1_0)
      if l_1_0.status == 0 then
        ui.data.buffLv[ui.data.buffEff] = ui.data.buffLv[ui.data.buffEff] + 1
        ui.data.skl[ui.data.buffEff] = ui.data.skl[ui.data.buffEff] + 1
        ui.showBuffSele(ui.data.buffEff)
        ui.showUpBuffNeed()
        ui.showBuffLv()
        ui.showBuffAllAddData()
        ui.widget.buffLvSpine:playAnimation("skill_upgrade")
      end
      petNetData.coutRsult(4, l_1_0.status)
      delWaitNet()
      end)
   end)
  ui.widget.btnReStore:registerScriptTapHandler(function()
    if ui.data.lv == 1 and ui.data.buffLv[1] == 1 then
      showToast(string.format(i18n.global.pet_reStore_fail.string))
      return 
    end
    local onhandle = function()
      local backTable = ui.getAllback()
      require("ui.pet.main").addItem(backTable)
      ui.data.lv = 1
      for k,v in pairs(ui.data.buffLv) do
        ui.data.buffLv[k] = 1
      end
      local card = img.createUISprite(img.ui[petData[ui.data.id].petBody .. ui.data.advanced])
      card:setCascadeOpacityEnabled(true)
      card:setPosition(CCPoint(card:getContentSize().width / 2, card:getContentSize().height / 2))
      local name = string.gsub(petData[ui.data.id].petBody, "pet_", "spine_")
      local clippingSp = ui.createJsonCard(json.ui[name .. ui.data.advanced])
      card:addChild(clippingSp, 12)
      local path = img.ui.pet_card
      if petNetData.getData(ui.data.id).advanced == 2 or petNetData.getData(ui.data.id).advanced == 3 then
        path = img.ui.pet_card2
      else
        if petNetData.getData(ui.data.id).advanced == 4 then
          path = img.ui.pet_card3
        end
      end
      local card_bg = img.createUISprite(path)
      card_bg:setCascadeOpacityEnabled(true)
      card_bg:setPosition(CCPoint(0, 0))
      card_bg:addChild(card, -1)
      ui.widget.petJson:addChildFollowSlot("code_card2", card_bg)
      ui.widget.petJson:playAnimation("degrade")
      require("ui.pet.main").createMaskLayer(1.8)
      local params = {sid = player.sid, id = ui.data.id, opcode = 5}
      addWaitNet()
      netClient:pet_op(params, function(l_1_0)
        if l_1_0.status == 0 then
          local seq = createSequence({})
           -- DECOMPILER ERROR: Overwrote pending register.

           -- DECOMPILER ERROR: Overwrote pending register.

          ui.widget.btnReStore:runAction(CCCallFunc:create(function()
          card:removeFromParent()
          card_bg:removeFromParent()
          petNetData.Reset(ui.data.id)
          ui.refreshAllShow()
          local path = img.ui.pet_card
          if petNetData.getData(ui.data.id).advanced == 2 or petNetData.getData(ui.data.id).advanced == 3 then
            path = img.ui.pet_card2
          else
            if petNetData.getData(ui.data.id).advanced == 4 then
              path = img.ui.pet_card3
            end
          end
          local card_bg = img.createUISprite(path)
          card_bg:setCascadeOpacityEnabled(true)
          card_bg:setPosition(CCPoint(0, 0))
          card = img.createUISprite(img.ui[petData[ui.data.id].petBody .. ui.data.advanced])
          card:setCascadeOpacityEnabled(true)
          card:setPosition(CCPoint(card:getContentSize().width / 2, card:getContentSize().height / 2))
          local name = string.gsub(petData[ui.data.id].petBody, "pet_", "spine_")
          local clippingSp = ui.createJsonCard(json.ui[name .. ui.data.advanced])
          card:addChild(clippingSp, 12)
          card_bg:addChild(card, -1)
          ui.widget.petJson:addChildFollowSlot("code_card2", card_bg)
            end))
        end
        petNetData.coutRsult(5, l_1_0.status)
        delWaitNet()
         -- Warning: undefined locals caused missing assignments!
         end)
      end
    local reStoreTip = require("ui.tips.confirm").create({title = "", text = i18n.global.pet_reStore.string, handle = onhandle})
    ui.widget.mainLayer:getParent():addChild(reStoreTip, 1000)
   end)
end

return ui

