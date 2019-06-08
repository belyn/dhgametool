-- Command line was: E:\github\dhgametool\scripts\ui\herolist\herobook.lua 

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
local helper = (require("common.helper"))
local showBoardLayer, heroData = nil, nil
local createInfo = function(l_1_0)
  local layer = CCLayer:create()
  local heroData = heros.maxAttr(l_1_0)
  heroData.id = l_1_0
  local lvMax = cfghero[heroData.id].maxLv
  local board = img.createUI9Sprite(img.ui.hero_bg)
  board:setAnchorPoint(ccp(0, 0))
  board:setPreferredSize(CCSize(428, 503))
  board:setPosition(465, 35)
  layer:addChild(board)
  json.load(json.ui.hero_up)
  local animLv = DHSkeletonAnimation:createWithKey(json.ui.hero_up)
  animLv:scheduleUpdateLua()
  animLv:setPosition(230, 160)
  layer:addChild(animLv, 100)
  local title = lbl.createFont1(24, i18n.global.hero_title_hero.string, ccc3(230, 208, 174))
  title:setPosition(214, 474)
  board:addChild(title, 1)
  local titleShade = lbl.createFont1(24, i18n.global.hero_title_hero.string, ccc3(89, 48, 27))
  titleShade:setPosition(214, 472)
  board:addChild(titleShade)
  local powerIcon = img.createUISprite(img.ui.power_icon)
  powerIcon:setScale(0.48)
  powerIcon:setAnchorPoint(ccp(0, 0))
  powerIcon:setPosition(52, 408)
  board:addChild(powerIcon)
  local titleLv = lbl.createFont1(20, "LV : ", ccc3(147, 58, 54))
  titleLv:setAnchorPoint(ccp(0, 0.5))
  titleLv:setPosition(264, powerIcon:boundingBox():getMidY())
  board:addChild(titleLv)
  local showPower = lbl.createFont1(22, heroData.power, ccc3(81, 39, 18))
  showPower:setAnchorPoint(ccp(0, 0.5))
  showPower:setPosition(powerIcon:boundingBox():getMaxX() + 8, powerIcon:boundingBox():getMidY())
  board:addChild(showPower)
  local showLv = lbl.createFont1(22, lvMax .. "/" .. lvMax, ccc3(81, 39, 18))
  showLv:setAnchorPoint(ccp(0, 0.5))
  showLv:setPosition(titleLv:boundingBox():getMaxX() + 8, titleLv:boundingBox():getMidY())
  board:addChild(showLv)
  local fgLine = img.createUI9Sprite(img.ui.hero_panel_fgline)
  fgLine:setPreferredSize(CCSize(356, 4))
  fgLine:setPosition(214, 401)
  board:addChild(fgLine)
  local showUpdateLayer = CCLayer:create()
  board:addChild(showUpdateLayer, 2)
  local titleEvolve = lbl.createFont1(18, i18n.global.hero_title_evolve.string, ccc3(115, 59, 5))
  titleEvolve:setAnchorPoint(ccp(1, 0.5))
  titleEvolve:setPosition(110, 367)
  showUpdateLayer:addChild(titleEvolve)
  local titleExp = lbl.createFont1(18, i18n.global.hero_title_exp.string, ccc3(115, 59, 5))
  titleExp:setAnchorPoint(ccp(1, 0.5))
  titleExp:setPosition(110, 316)
  showUpdateLayer:addChild(titleExp)
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
  local showMaxLv = img.createUISprite(img_maxlv)
  showMaxLv:setAnchorPoint(ccp(0, 0.5))
  showMaxLv:setPosition(titleExp:boundingBox():getMaxX() + 12, titleExp:boundingBox():getMidY())
  showUpdateLayer:addChild(showMaxLv)
  for i = 1, cfghero[heroData.id].qlt do
    local showStar = img.createUISprite(img.ui.hero_star1)
    showStar:setAnchorPoint(ccp(0, 0.5))
    showStar:setPosition(titleExp:boundingBox():getMaxX() + 12 + (i - 1) * 32, titleEvolve:boundingBox():getMidY())
    showUpdateLayer:addChild(showStar)
  end
  local attriBg = img.createUI9Sprite(img.ui.hero_attribute_lab_frame)
  attriBg:setPreferredSize(CCSize(366, 141))
  attriBg:setAnchorPoint(ccp(0.5, 0))
  attriBg:setPosition(214, 138)
  showUpdateLayer:addChild(attriBg)
  local showTitle = lbl.createFont1(18, i18n.global.hero_job_" .. cfghero[heroData.id].jo.string, ccc3(148, 98, 66))
  showTitle:setPosition(182, 117)
  attriBg:addChild(showTitle)
  local showJob = img.createUISprite(img.ui.job_" .. cfghero[heroData.id].jo)
  showJob:setPosition(showTitle:boundingBox():getMinX() - 25, 117)
  attriBg:addChild(showJob)
  local btnInfoSprite = img.createUISprite(img.ui.btn_detail)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  local menuInfo = CCMenu:createWithItem(btnInfo)
  btnInfo:setPosition(332, 115)
  btnInfo:setScale(0.9)
  menuInfo:setPosition(0, 0)
  attriBg:addChild(menuInfo)
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    board:addChild(require("ui.tips.attrdetail").create(heros.maxAttr(id)), 100)
   end)
  local attriInfo = {1 = {icon = img.ui.hero_attr_hp, num = heroData.hp}, 2 = {icon = img.ui.hero_attr_atk, num = heroData.atk}, 3 = {icon = img.ui.hero_attr_def, num = heroData.arm}, 4 = {icon = img.ui.hero_attr_spd, num = heroData.spd}}
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
  if cfghero[heroData.id].actSkillId then
    skillId[ skillId + 1] = {id = cfghero[heroData.id].actSkillId, lock = 0}
  end
  for i = 1, 6 do
    if cfghero[heroData.id].pasSkill" .. i .. "Id then
      skillId[ skillId + 1] = {id = cfghero[heroData.id].pasSkill" .. i .. "Id, lock = cfghero[heroData.id].pasTier" .. }
    end
  end
  local showSkill = {}
  local skillTips = {}
  for i,v in ipairs(skillId) do
    showSkill[i] = img.createUISprite(img.ui.hero_skill_bg)
    showSkill[i]:setPosition(78 + 90 * (i - 1), 77)
    showUpdateLayer:addChild(showSkill[i])
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
    skillTips[i] = require("ui.tips.skill").create(v.id, v.lock)
    skillTips[i]:setAnchorPoint(ccp(0, 0))
    skillTips[i]:setPosition(showSkill[1]:boundingBox():getMinX() - 14, showSkill[1]:boundingBox():getMaxY() + 10)
    showUpdateLayer:addChild(skillTips[i])
    skillTips[i]:setVisible(false)
  end
  local onTouch = function(l_2_0, l_2_1, l_2_2)
    do
      local point = showUpdateLayer:convertToNodeSpace(ccp(l_2_1, l_2_2))
      for i,v in ipairs(showSkill) do
        if v:boundingBox():containsPoint(point) then
          skillTips[i]:setVisible(true)
          for i,v in (for generator) do
          end
          skillTips[i]:setVisible(false)
        end
        if l_2_0 ~= "began" and l_2_0 ~= "moved" then
          for i,v in ipairs(skillTips) do
            v:setVisible(false)
          end
        end
        return true
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  showUpdateLayer:registerScriptTouchHandler(onTouch)
  showUpdateLayer:setTouchSwallowEnabled(false)
  showUpdateLayer:setTouchEnabled(true)
  return layer
end

ui.create = function(l_2_0, l_2_1, l_2_2, l_2_3)
  local layer = CCLayer:create()
  local createHeroLayer = function(l_1_0)
    local hlayer = CCLayer:create()
    if herolist then
      upvalue_512 = herolist[l_1_0].id
    else
      upvalue_512 = id
    end
    local bgPlistName = img.packedOthers.ui_hero_bg" .. cfghero[id].grou
    img.load(bgPlistName)
    local bgg = img.createUISprite(img.ui.hero_bg" .. cfghero[id].grou)
    bgg:setScale(view.minScale)
    bgg:setPosition(view.midX, view.midY)
    hlayer:addChild(bgg)
    local bg = CCSprite:create()
    bg:setContentSize(CCSizeMake(960, 576))
    bg:setScale(view.minScale)
    bg:setPosition(view.midX, view.midY)
    hlayer:addChild(bg)
    json.load(json.ui.hero_bg" .. cfghero[id].grou)
    local anim = DHSkeletonAnimation:createWithKey(json.ui.hero_bg" .. cfghero[id].grou)
    anim:scheduleUpdateLua()
    anim:setPosition(480, 288)
    anim:playAnimation("animation", -1)
    bg:addChild(anim)
    if cfghero[id].group == 2 then
      local part = particle.create("hero_bg2_d")
      part:setPosition(480, 0)
      bg:addChild(part)
    else
      if cfghero[id].group == 3 then
        local part = particle.create("hero_bg3_d")
        part:setPosition(480, 0)
        bg:addChild(part)
        local part = particle.create("hero_bg3_2d")
        part:setPosition(480, 0)
        bg:addChild(part)
      else
        if cfghero[id].group == 5 then
          local part = particle.create("hero_bg5_d")
          part:setPosition(480, 0)
          bg:addChild(part)
          local part = particle.create("hero_bg5_u")
          part:setPosition(480, 576)
          bg:addChild(part)
        else
          if cfghero[id].group == 6 then
            local part = particle.create("hero_bg6_rd")
            part:setPosition(960, 0)
            bg:addChild(part)
            local part = particle.create("hero_bg6_2rd")
            part:setPosition(960, 0)
            bg:addChild(part)
          end
        end
      end
    end
    local heroBg = img.createUISprite(img.ui.hero_pedestal)
    heroBg:setAnchorPoint(ccp(0.5, 0))
    heroBg:setPosition(230, 38)
    bg:addChild(heroBg)
    local heroBody = json.createSpineHero(id)
    heroBody:setScale(0.9)
    heroBody:setPosition(230, 160)
    bg:addChild(heroBody)
    local heroName = lbl.createFont2(20, i18n.hero[id].heroName)
    heroName:setPosition(230, 527)
    bg:addChild(heroName)
    local showGroup = img.createUISprite(img.ui.herolist_group_" .. cfghero[id].grou)
    showGroup:setScale(0.68)
    showGroup:setPosition(heroName:boundingBox():getMinX() - 30, heroName:getPositionY() + 2)
    bg:addChild(showGroup)
    local star = cfghero[id].maxStar
    if star <= 5 then
      baseX = 245 - 15 * star
      for i = 1, star do
        local starIcon = img.createUISprite(img.ui.star)
        starIcon:setScale(0.64)
        starIcon:setPosition(baseX + 29 * (i - 1), 492)
        bg:addChild(starIcon)
      end
    elseif star == 6 then
      starIcon = img.createUISprite(img.ui.hero_star_orange)
      starIcon:setPosition(230, 492)
      bg:addChild(starIcon)
    else
      starIcon = img.createUISprite(img.ui.hero_star_ten)
      starIcon:setPosition(230, 492)
      bg:addChild(starIcon)
    end
    upvalue_4608 = CCLayer:create()
    bg:addChild(showBoardLayer, 1)
    showBoardLayer:addChild(createInfo(id))
    hlayer:registerScriptTouchHandler(function(l_1_0, l_1_1, l_1_2)
      if heroBody:getAabbBoundingBox():containsPoint(ccp(l_1_1, l_1_2)) then
        if cfghero[id].words then
          audio.playHeroTalk(cfghero[id].words)
        end
        heroBody:playAnimation("attack")
        heroBody:appendNextAnimation("stand", -1)
        heroBody:registerLuaHandler(function(l_1_0)
          if l_1_0 == "hit" then
             -- Warning: missing end command somewhere! Added here
          end
            end)
      end
      end)
    hlayer:setTouchEnabled(true)
    return hlayer
   end
  local herolayer = createHeroLayer(l_2_3)
  layer:addChild(herolayer)
  if l_2_2 then
    local leftraw = img.createUISprite(img.ui.hero_raw)
    do
      local btnLeftraw = SpineMenuItem:create(json.ui.button, leftraw)
      btnLeftraw:setScale(view.minScale)
      btnLeftraw:setPosition(scalep(36, 286))
      local menuLeftraw = CCMenu:createWithItem(btnLeftraw)
      menuLeftraw:setPosition(0, 0)
      layer:addChild(menuLeftraw, 1)
      if l_2_3 <= 1 then
        setShader(btnLeftraw, SHADER_GRAY, true)
        btnLeftraw:setEnabled(false)
      end
      local rightraw = img.createUISprite(img.ui.hero_raw)
      rightraw:setFlipX(true)
      local btnRightraw = SpineMenuItem:create(json.ui.button, rightraw)
      btnRightraw:setScale(view.minScale)
      btnRightraw:setPosition(scalep(428, 286))
      local menuRightraw = CCMenu:createWithItem(btnRightraw)
      menuRightraw:setPosition(0, 0)
      layer:addChild(menuRightraw, 1)
      if  l_2_2 <= l_2_3 then
        setShader(btnRightraw, SHADER_GRAY, true)
        btnRightraw:setEnabled(false)
      end
      btnLeftraw:registerScriptTapHandler(function()
        audio.play(audio.button)
        if pos <= 1 then
          return 
        end
        upvalue_512 = pos - 1
        if pos <= 1 then
          setShader(btnLeftraw, SHADER_GRAY, true)
          btnLeftraw:setEnabled(false)
        end
        if pos ==  herolist - 1 then
          clearShader(btnRightraw, true)
          btnRightraw:setEnabled(true)
        end
        herolayer:removeFromParentAndCleanup(true)
        if helper.isLowMem() then
          json.unloadUnit(cfghero[id].heroBody)
        end
        if cfghero[id].anims then
          for i = 1,  cfghero[id].anims do
            local jsonname = "spinejson/unit/" .. cfghero[id].anims[i] .. ".json"
            json.unload(jsonname)
          end
        end
        upvalue_2560 = createHeroLayer(pos)
        layer:addChild(herolayer)
         end)
      btnRightraw:registerScriptTapHandler(function()
        audio.play(audio.button)
        if  herolist <= pos then
          return 
        end
        upvalue_512 = pos + 1
        if  herolist <= pos then
          setShader(btnRightraw, SHADER_GRAY, true)
          btnRightraw:setEnabled(false)
        end
        if pos == 2 then
          clearShader(btnLeftraw, true)
          btnLeftraw:setEnabled(true)
        end
        herolayer:removeFromParentAndCleanup(true)
        if helper.isLowMem() then
          json.unloadUnit(cfghero[id].heroBody)
        end
        if cfghero[id].anims then
          for i = 1,  cfghero[id].anims do
            local jsonname = "spinejson/unit/" .. cfghero[id].anims[i] .. ".json"
            json.unload(jsonname)
          end
        end
        upvalue_2560 = createHeroLayer(pos)
        layer:addChild(herolayer)
         end)
    end
  end
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = SpineMenuItem:create(json.ui.button, btnBackSprite)
  btnBack:setScale(view.minScale)
  btnBack:setPosition(scalep(35, 546))
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  layer:addChild(menuBack, 1000)
  layer.back = btnBack
  btnBack:registerScriptTapHandler(function()
    audio.stopAllEffects()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  autoLayoutShift(btnBack)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    if helper.isLowMem() then
      json.unloadUnit(cfghero[id].heroBody)
    end
    if cfghero[id].anims then
      for i = 1,  cfghero[id].anims do
        local jsonname = "spinejson/unit/" .. cfghero[id].anims[i] .. ".json"
        json.unload(jsonname)
      end
    end
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_8_0)
    if l_8_0 == "enter" then
      onEnter()
    elseif l_8_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

