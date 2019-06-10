-- Command line was: E:\github\dhgametool\scripts\ui\hero\info.lua 

local info = {}
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
local cfgexphero = require("config.exphero")
local cfgskill = require("config.skill")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local cfgtalen = (require("config.talen"))
local showHeroLayer, showBoardLayer, heroData = nil, nil, nil
local createEvolve = function(l_1_0, l_1_1)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 204))
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(648, 500))
  board:setScale(view.minScale)
  board:setPosition(scalep(480, 288))
  layer:addChild(board)
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(621, 473)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local title = lbl.createFont1(24, i18n.global.hero_advance.string, ccc3(230, 208, 174))
  title:setPosition(324, 472)
  board:addChild(title, 1)
  local titleShade = lbl.createFont1(24, i18n.global.hero_advance.string, ccc3(89, 48, 27))
  titleShade:setPosition(324, 470)
  board:addChild(titleShade)
  local attrBg = img.createUI9Sprite(img.ui.hero_evolve_cost_bg)
  attrBg:setPreferredSize(CCSize(344, 200))
  attrBg:setAnchorPoint(ccp(0, 0))
  attrBg:setPosition(36, 180)
  board:addChild(attrBg)
  local skillBg = img.createUI9Sprite(img.ui.select_hero_buff_bg)
  skillBg:setPreferredSize(CCSize(222, 200))
  skillBg:setAnchorPoint(ccp(0, 0))
  skillBg:setPosition(391, 180)
  board:addChild(skillBg, 100)
  local helper = require("fight.helper.attr")
  local preData = helper.attr(l_1_0, l_1_0.star)
  local aftData = helper.attr(l_1_0, l_1_0.star + 1)
  local coin = 0
  local evolve = 0
  if bag.items.find(ITEM_ID_COIN) then
    coin = bag.items.find(ITEM_ID_COIN).num
  end
  if bag.items.find(ITEM_ID_EVOLVE_EXP) then
    evolve = bag.items.find(ITEM_ID_EVOLVE_EXP).num
  end
  local coinCost, evolveCost = cfghero[l_1_0.id].starExp" .. l_1_0.star + [2], cfghero[l_1_0.id].starExp" .. l_1_0.star + [1]
  local evolve_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  evolve_bg:setPreferredSize(CCSizeMake(174, 40))
  evolve_bg:setAnchorPoint(CCPoint(0, 0.5))
  evolve_bg:setPosition(CCPoint(340, 418))
  board:addChild(evolve_bg)
  local evolve_coin = img.createItemIcon(ITEM_ID_EVOLVE_EXP)
  evolve_coin:setScale(0.6)
  evolve_coin:setPosition(CCPoint(5, evolve_bg:getContentSize().height / 2 + 2))
  evolve_bg:addChild(evolve_coin)
  local lbl_evolve = lbl.createFont2(16, evolve, ccc3(255, 246, 223))
  lbl_evolve:setPosition(CCPoint(evolve_bg:getContentSize().width / 2 - 10, evolve_bg:getContentSize().height / 2 + 3))
  evolve_bg:addChild(lbl_evolve)
  local coin_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  coin_bg:setPreferredSize(CCSizeMake(174, 40))
  coin_bg:setAnchorPoint(CCPoint(1, 0.5))
  coin_bg:setPosition(CCPoint(310, 418))
  board:addChild(coin_bg)
  local icon_coin = img.createItemIcon2(ITEM_ID_COIN)
  icon_coin:setPosition(CCPoint(5, coin_bg:getContentSize().height / 2 + 2))
  coin_bg:addChild(icon_coin)
  local coin_num = bag.coin()
  local lbl_coin = lbl.createFont2(16, num2KM(coin_num), ccc3(255, 246, 223))
  lbl_coin:setPosition(CCPoint(coin_bg:getContentSize().width / 2 - 10, coin_bg:getContentSize().height / 2 + 3))
  coin_bg:addChild(lbl_coin)
  lbl_coin.num = coin_num
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local DATA = {1 = {title = i18n.global.hero_info_level.string, pre = cfghero[l_1_0.id].starLv" .. l_1_0.star + , aft = cfghero[l_1_0.id].maxLv}, 2 = {title = i18n.global.hero_info_power.string, pre = math.floor(preData.power), aft = math.floor(aftData.power)}, 3 = {title = i18n.global.hero_info_health.string, pre = math.floor(preData.hp), aft = math.floor(aftData.hp)}, 4 = {title = i18n.global.hero_info_attack.string, pre = math.floor(preData.atk), aft = math.floor(aftData.atk)}, 5 = {title = i18n.global.hero_info_armor.string, pre = math.floor(preData.arm), aft = math.floor(aftData.arm)}}
for i = 1, 5 do
  local showTitle = lbl.createFont2(18, DATA[i].title, ccc3(253, 235, 135))
  showTitle:setAnchorPoint(ccp(1, 0.5))
  showTitle:setPosition(90, 203 - 33 * i)
  attrBg:addChild(showTitle)
  local showPre = lbl.createFont2(18, DATA[i].pre, ccc3(255, 246, 223))
  showPre:setPosition(143, 203 - 33 * i)
  attrBg:addChild(showPre)
  local showArrow = img.createUISprite(img.ui.arrow)
  showArrow:setPosition(219, 203 - 33 * i)
  attrBg:addChild(showArrow)
  local showAft = lbl.createFont2(18, DATA[i].aft, ccc3(157, 244, 38))
  showAft:setPosition(286, 203 - 33 * i)
  attrBg:addChild(showAft)
end
local skillId = nil
for i = 1, 3 do
  if cfghero[l_1_0.id].pasTier" ..  == l_1_0.star + 1 then
    skillId = cfghero[l_1_0.id].pasSkill" .. i .. "Id
  end
end
local skillIconBg, skillTips = nil, nil
if skillId then
  local skillTitle = lbl.createFont1(20, i18n.global.hero_unlock.string, ccc3(148, 98, 66))
  skillTitle:setPosition(111, 165)
  skillBg:addChild(skillTitle)
  skillIconBg = img.createUISprite(img.ui.hero_skill_bg)
  skillIconBg:setPosition(111, 86)
  skillBg:addChild(skillIconBg)
  local skillIcon = img.createSkill(skillId)
  skillIcon:setPosition(skillIconBg:getContentSize().width / 2, skillIconBg:getContentSize().height / 2)
  skillIconBg:addChild(skillIcon)
  if cfgskill[skillId].skiL then
    local skillLB = img.createUISprite(img.ui.hero_skilllevel_bg)
    skillLB:setPosition(skillIconBg:getContentSize().width - 15, skillIconBg:getContentSize().height - 15)
    skillIconBg:addChild(skillLB)
    local skilllab = lbl.createFont1(18, cfgskill[skillId].skiL, ccc3(255, 246, 223))
    skilllab:setPosition(skillLB:getContentSize().width / 2, skillLB:getContentSize().height / 2)
    skillLB:addChild(skilllab)
  end
  skillTips = require("ui.tips.skill").create(skillId)
  skillTips:setAnchorPoint(ccp(1, 0))
  skillTips:setPosition(skillIconBg:boundingBox():getMaxX(), skillIconBg:boundingBox():getMaxY())
  skillBg:addChild(skillTips)
  skillTips:setVisible(false)
end
local coinBg = img.createUI9Sprite(img.ui.hero_evolve_cost_bg)
coinBg:setPreferredSize(CCSize(178, 33))
coinBg:setAnchorPoint(ccp(0, 0))
coinBg:setPosition(136, 123)
board:addChild(coinBg)
local evolveBg = img.createUI9Sprite(img.ui.hero_evolve_cost_bg)
evolveBg:setPreferredSize(CCSize(178, 33))
evolveBg:setAnchorPoint(ccp(0, 0))
evolveBg:setPosition(342, 123)
board:addChild(evolveBg)
local coinIcon = img.createItemIcon2(ITEM_ID_COIN)
coinIcon:setPosition(10, 17)
coinBg:addChild(coinIcon)
local evolveIcon = img.createItemIcon(ITEM_ID_EVOLVE_EXP)
evolveIcon:setScale(0.6)
evolveIcon:setPosition(10, 17)
evolveBg:addChild(evolveIcon)
local showCoin = lbl.createFont2(16, num2KM(coinCost), ccc3(255, 246, 223))
showCoin:setAnchorPoint(ccp(0, 0.5))
showCoin:setPosition(40, 16)
coinBg:addChild(showCoin)
if coin_num < coinCost then
  showCoin:setColor(ccc3(255, 44, 44))
end
local showEvolve = lbl.createFont2(16, num2KM(evolveCost), ccc3(255, 246, 223))
showEvolve:setAnchorPoint(ccp(0, 0.5))
showEvolve:setPosition(40, 16)
evolveBg:addChild(showEvolve)
if evolve < evolveCost then
  showEvolve:setColor(ccc3(255, 44, 44))
end
local btnEvolveSp = img.createLogin9Sprite(img.login.button_9_small_gold)
btnEvolveSp:setPreferredSize(CCSize(175, 70))
local labEvolve = lbl.createFont1(20, i18n.global.hero_advance.string, ccc3(115, 59, 5))
labEvolve:setPosition(btnEvolveSp:getContentSize().width / 2, btnEvolveSp:getContentSize().height / 2)
btnEvolveSp:addChild(labEvolve)
local btnEvolve = SpineMenuItem:create(json.ui.button, btnEvolveSp)
local menuEvolve = CCMenu:createWithItem(btnEvolve)
btnEvolve:setAnchorPoint(ccp(0.5, 0))
btnEvolve:setPosition(324, 35)
menuEvolve:setPosition(0, 0)
board:addChild(menuEvolve)
local onEvolve = function()
  if layer and not tolua.isnull(layer) then
    layer:runAction(CCRemoveSelf:create())
    local animLayer = CCLayer:create()
    do
      layer:getParent():addChild(animLayer, 10000)
      json.load(json.ui.hero_et)
      local animStar = DHSkeletonAnimation:createWithKey(json.ui.hero_et)
      animStar:scheduleUpdateLua()
      animStar:setScale(view.minScale)
      animStar:setPosition(scalep(480, 288))
      if skillId then
        animStar:playAnimation("animation")
        animStar:appendNextAnimation("loop", -1)
      else
        animStar:playAnimation("animation2")
        animStar:appendNextAnimation("loop2", -1)
      end
      animLayer:addChild(animStar)
      local title = nil
      if i18n.getCurrentLanguage() == kLanguageChinese or i18n.getCurrentLanguage() == kLanguageChineseTW then
        title = img.createUISprite(img.ui.language_advance_cn)
      else
        if i18n.getCurrentLanguage() == kLanguageEnglish then
          title = img.createUISprite(img.ui.language_advance_us)
        else
          title = lbl.createFont3(30, i18n.global.hero_advance.string, ccc3(255, 204, 51))
        end
      end
      animStar:addChildFollowSlot("code_title", title)
      for i = 1, 5 do
        local textNode = CCNode:create()
        textNode:setCascadeOpacityEnabled(true)
        animStar:addChildFollowSlot("code_text" .. i, textNode)
        local showTitle = lbl.createFont2(18, DATA[i].title, ccc3(253, 235, 135))
        showTitle:setAnchorPoint(ccp(0, 0.5))
        showTitle:setPositionX(-160)
        textNode:addChild(showTitle)
        showTitle:setCascadeOpacityEnabled(true)
        local showPre = lbl.createFont2(18, DATA[i].pre, ccc3(255, 246, 223))
        showPre:setPositionX(-35)
        textNode:addChild(showPre)
        showPre:setCascadeOpacityEnabled(true)
        local showAft = lbl.createFont2(18, DATA[i].aft, ccc3(157, 244, 38))
        showAft:setPositionX(140)
        textNode:addChild(showAft)
        showAft:setCascadeOpacityEnabled(true)
      end
      local showSkillLayer = CCLayer:create()
      animStar:addChildFollowSlot("code_icon", showSkillLayer)
      showSkillLayer:setCascadeOpacityEnabled(true)
      local showTextLayer = CCNode:create()
      animStar:addChild(showTextLayer)
      if skillId then
        local skillTitle = lbl.createMixFont2(20, i18n.global.hero_advance_unlock_skill.string)
        skillTitle:setPosition(0, -104)
        showTextLayer:addChild(skillTitle)
        skillTitle:setCascadeOpacityEnabled(true)
        local skillIconBg = img.createUISprite(img.ui.hero_skill_bg)
        skillIconBg:setPosition(0, 0)
        showSkillLayer:addChild(skillIconBg)
        skillIconBg:setCascadeOpacityEnabled(true)
        local skillIcon = img.createSkill(skillId)
        skillIcon:setPosition(skillIconBg:getContentSize().width / 2, skillIconBg:getContentSize().height / 2)
        skillIconBg:addChild(skillIcon)
        skillIcon:setCascadeOpacityEnabled(true)
        local skillName = lbl.createMixFont1(18, i18n.skill[skillId].skillName, ccc3(172, 237, 58))
        skillName:setPosition(0, -224)
        showTextLayer:addChild(skillName)
        skillName:setCascadeOpacityEnabled(true)
      end
      local tick = 0
      animLayer:registerScriptTouchHandler(function()
        if tick >= 90 then
          animLayer:removeFromParentAndCleanup(true)
        end
        return true
         end)
      animLayer:setTouchEnabled(true)
      animLayer:scheduleUpdateWithPriorityLua(function()
        tick = tick + 1
        if tick > 300 then
          tick = 300
        end
         end)
    end
  end
end

btnEvolve:registerScriptTapHandler(function()
  disableObjAWhile(btnEvolve)
  if evolve < evolveCost then
    showToast(i18n.global.toast_hero_need_evolve.string)
    return 
  else
    if coin < coinCost then
      showToast(i18n.global.toast_hero_need_coin.string)
      return 
    else
      if heroData.lv < cfghero[heroData.id].starLv" .. heroData.star +  then
        showToast(i18n.global.toast_hero_need_lvup.string)
        return 
      end
    end
    do
      local params = {sid = player.sid, hid = heroData.hid, type = 2}
      addWaitNet()
      net:hero_up(params, function(l_1_0)
      delWaitNet()
      if l_1_0.status < 0 then
        showToast("status:" .. l_1_0.status)
        return 
      end
      audio.play(audio.hero_advance)
      bag.items.sub({id = ITEM_ID_EVOLVE_EXP, num = evolveCost})
      bag.items.sub({id = ITEM_ID_COIN, num = coinCost})
      heroData.star = heroData.star + 1
      onEvolve()
      callback()
      end)
    end
     -- Warning: missing end command somewhere! Added here
  end
end
)
local onTouch = function(l_4_0, l_4_1, l_4_2)
  if (l_4_0 == "began" or l_4_0 == "moved") and skillTips and skillIconBg:boundingBox():containsPoint(skillBg:convertToNodeSpace(ccp(l_4_1, l_4_2))) then
    skillTips:setVisible(true)
  end
  return true
end

layer:registerScriptTouchHandler(onTouch)
layer:setTouchEnabled(true)
board:setScale(0.5 * view.minScale)
local anim_arr = CCArray:create()
anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
anim_arr:addObject(CCDelayTime:create(0.15))
anim_arr:addObject(CCCallFunc:create(function()
end
))
board:runAction(CCSequence:create(anim_arr))
return layer
end

info.create = function(l_2_0, l_2_1)
  local layer = CCLayer:create()
  if not cfghero[l_2_0.id].starLv" .. l_2_0.star +  then
    local lvMax = cfghero[l_2_0.id].maxLv
  end
  if l_2_0.wake then
    if l_2_0.wake < 4 then
      lvMax = lvMax + l_2_0.wake * 20
    end
    if l_2_0.wake >= 5 then
      lvMax = cfgtalen[l_2_0.wake - 4].addMaxLv
    end
  end
  local board = img.createUI9Sprite(img.ui.hero_bg)
  board:setAnchorPoint(ccp(0, 0))
  board:setPreferredSize(CCSize(428, 503))
  board:setPosition(465, 15)
  layer:addChild(board)
  json.load(json.ui.hero_up)
  local animLv = DHSkeletonAnimation:createWithKey(json.ui.hero_up)
  animLv:scheduleUpdateLua()
  animLv:setPosition(230, 160)
  layer:addChild(animLv, 100)
  local onLvUp = function(l_1_0, l_1_1)
    local stat = {1 = {num = l_1_1.atk - l_1_0.atk, title = i18n.global.hero_detail_1.string}, 2 = {num = l_1_1.hp - l_1_0.hp, title = i18n.global.hero_detail_2.string}, 3 = {num = l_1_1.arm - l_1_0.arm, title = i18n.global.hero_detail_3.string}, 4 = {num = l_1_1.spd - l_1_0.spd, title = i18n.global.hero_detail_4.string}}
    local showStat = {}
    for i,v in ipairs(stat) do
      if v.num > 0 then
        showStat[#showStat + 1] = v.title .. "     +" .. v.num
      end
    end
    local showLayer = CCLayer:create()
    layer:addChild(showLayer)
    for i,v in ipairs(showStat) do
      json.load(json.ui.hero_numbers)
      local anim = DHSkeletonAnimation:createWithKey(json.ui.hero_numbers)
      anim:scheduleUpdateLua()
      anim:setPosition(230, 230 + i * 24)
      anim:playAnimation("up")
      showLayer:addChild(anim)
      local shownum = lbl.createMixFont2(16, v, ccc3(165, 253, 71))
      anim:addChildFollowSlot("code_numbers", shownum)
    end
    showLayer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(2), CCRemoveSelf:create()))
   end
  local title = lbl.createFont1(24, i18n.global.hero_title_hero.string, ccc3(230, 208, 174))
  title:setPosition(214, 474)
  board:addChild(title, 1)
  local titleShade = lbl.createFont1(24, i18n.global.hero_title_hero.string, ccc3(89, 48, 27))
  titleShade:setPosition(214, 472)
  board:addChild(titleShade)
  local powerIcon = img.createUISprite(img.ui.power_icon)
  powerIcon:setScale(0.48)
  powerIcon:setAnchorPoint(ccp(0, 0))
  powerIcon:setPosition(47, 408)
  board:addChild(powerIcon)
  local titleLv = lbl.createFont1(20, "LV : ", ccc3(147, 58, 54))
  titleLv:setAnchorPoint(ccp(0, 0.5))
  titleLv:setPosition(264, powerIcon:boundingBox():getMidY())
  board:addChild(titleLv)
  local showPower = lbl.createFont1(22, heros.power(l_2_0.hid), ccc3(81, 39, 18))
  showPower:setAnchorPoint(ccp(0, 0.5))
  showPower:setPosition(powerIcon:boundingBox():getMaxX() + 8, powerIcon:boundingBox():getMidY())
  board:addChild(showPower)
  local showLv = lbl.createFont1(22, l_2_0.lv .. "/" .. lvMax, ccc3(81, 39, 18))
  showLv:setAnchorPoint(ccp(0, 0.5))
  showLv:setPosition(titleLv:boundingBox():getMaxX() + 8, titleLv:boundingBox():getMidY())
  board:addChild(showLv)
  local scale = showPower:getScale()
  local fgLine = img.createUI9Sprite(img.ui.hero_panel_fgline)
  fgLine:setPreferredSize(CCSize(356, 4))
  fgLine:setPosition(214, 401)
  board:addChild(fgLine)
  local updatePowerAndLv = function()
    if not cfghero[heroData.id].starLv" .. heroData.star +  then
      lvMax = cfghero[heroData.id].maxLv
    end
    if heroData.wake then
      if heroData.wake < 4 then
        lvMax = lvMax + heroData.wake * 20
      end
      if heroData.wake >= 5 then
        lvMax = cfgtalen[heroData.wake - 4].addMaxLv
      end
    end
    if showPower and not tolua.isnull(showPower) then
      showPower:setString(heros.power(heroData.hid))
      showPower:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.2, 1.2 * scale), CCScaleTo:create(0.2, 1 * scale)))
    end
    if showLv and not tolua.isnull(showLv) then
      showLv:setString(heroData.lv .. "/" .. lvMax)
      showLv:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.2, 1.2 * scale), CCScaleTo:create(0.2, 1 * scale)))
    end
   end
  local updateState = function()
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
    local btnLvUpSprite = img.createUISprite(img.ui.hero_btn_lvup)
    local btnStarUpSprite = img.createUISprite(img.ui.hero_btn_lvup)
    if heroData.lv < lvMax then
      btnStarUpSprite:setOpacity(120)
    end
    if lvMax <= heroData.lv then
      btnLvUpSprite:setVisible(false)
      if heroData.star < cfghero[heroData.id].qlt then
        local showRed = img.createUISprite(img.ui.main_red_dot)
        showRed:setPosition(btnStarUpSprite:getContentSize().width - 5, btnStarUpSprite:getContentSize().height - 5)
        btnStarUpSprite:addChild(showRed)
      end
    end
    local Lvup, expCostBg, expIcon, goldIcon, showCostExp, showCostGold = nil, nil, nil, nil, nil, nil
    if heroData.lv < lvMax then
      expCostBg = img.createUI9Sprite(img.ui.hero_lv_cost_bg)
      expCostBg:setPreferredSize(CCSize(208, 40))
      expCostBg:setAnchorPoint(ccp(0, 0.5))
      expCostBg:setPosition(titleExp:boundingBox():getMaxX() + 12, titleExp:boundingBox():getMidY())
      showUpdateLayer:addChild(expCostBg)
      expIcon = img.createItemIcon(ITEM_ID_HERO_EXP)
      expIcon:setScale(0.4)
      expIcon:setAnchorPoint(ccp(0, 0.5))
      expIcon:setPosition(11, 20)
      expCostBg:addChild(expIcon)
      goldIcon = img.createItemIcon(ITEM_ID_COIN)
      goldIcon:setScale(0.4)
      goldIcon:setAnchorPoint(ccp(0, 0.5))
      goldIcon:setPosition(99, 20)
      expCostBg:addChild(goldIcon)
      showCostExp = lbl.createFont2(16, cfgexphero[heroData.lv + 1].needExp)
      showCostExp:setAnchorPoint(ccp(0, 0.5))
      showCostExp:setPosition(expIcon:boundingBox():getMaxX() + 6, 20)
      expCostBg:addChild(showCostExp)
      if cfgexphero[heroData.lv + 1].needExp > 100000 then
        showCostExp:setString(tostring(math.ceil(cfgexphero[heroData.lv + 1].needExp / 1000)) .. "k")
      end
      showCostGold = lbl.createFont2(16, cfgexphero[heroData.lv + 1].needGold)
      showCostGold:setAnchorPoint(ccp(0, 0.5))
      showCostGold:setPosition(goldIcon:boundingBox():getMaxX() + 6, 20)
      expCostBg:addChild(showCostGold)
      if cfgexphero[heroData.lv + 1].needGold > 100000 then
        showCostGold:setString(tostring(math.ceil(cfgexphero[heroData.lv + 1].needGold / 1000)) .. "k")
      end
      local exp = 0
      local coin = 0
      if bag.items.find(ITEM_ID_HERO_EXP) then
        exp = bag.items.find(ITEM_ID_HERO_EXP).num
      end
      if bag.items.find(ITEM_ID_COIN) then
        coin = bag.items.find(ITEM_ID_COIN).num
      end
      if exp < cfgexphero[heroData.lv + 1].needExp then
        showCostExp:setColor(ccc3(255, 44, 44))
      end
      if coin < cfgexphero[heroData.lv + 1].needGold then
        showCostGold:setColor(ccc3(255, 44, 44))
      end
      if require("data.tutorial").exists() then
        local btnLvUpSprite1 = img.createUISprite(img.ui.hero_btn_lvup)
        local btnLvUp = SpineMenuItem:create(json.ui.button, btnLvUpSprite1)
        local menuLvUp = CCMenu:createWithItem(btnLvUp)
        btnLvUp:setPosition(369, titleExp:boundingBox():getMidY())
        menuLvUp:setPosition(0, 0)
        showUpdateLayer:addChild(menuLvUp)
        btnLvUp:registerScriptTapHandler(function()
          Lvup()
            end)
      else
        btnLvUpSprite:setPosition(369, titleExp:boundingBox():getMidY())
        showUpdateLayer:addChild(btnLvUpSprite)
      end
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
      local showMaxLv = img.createUISprite(img_maxlv)
      showMaxLv:setAnchorPoint(ccp(0, 0.5))
      showMaxLv:setPosition(titleExp:boundingBox():getMaxX() + 12, titleExp:boundingBox():getMidY())
      showUpdateLayer:addChild(showMaxLv)
    end
  end
  for i = 1, cfghero[heroData.id].qlt do
    local showStar = nil
    if i <= heroData.star then
      showStar = img.createUISprite(img.ui.hero_star1)
    else
      showStar = img.createUISprite(img.ui.hero_star0)
    end
    showStar:setAnchorPoint(ccp(0, 0.5))
    showStar:setPosition(titleExp:boundingBox():getMaxX() + 12 + (i - 1) * 32, titleEvolve:boundingBox():getMidY())
    showUpdateLayer:addChild(showStar)
  end
  local btnStarUp = nil
  if heroData.star < cfghero[heroData.id].qlt and lvMax <= heroData.lv then
    btnStarUp = SpineMenuItem:create(json.ui.button, btnStarUpSprite)
    local menuStarUp = CCMenu:createWithItem(btnStarUp)
    btnStarUp:setAnchorPoint(ccp(0, 0.5))
    btnStarUp:setPosition(346, titleEvolve:boundingBox():getMidY())
    menuStarUp:setPosition(0, 0)
    showUpdateLayer:addChild(menuStarUp)
    btnStarUp:registerScriptTapHandler(function()
      audio.play(audio.button)
      if lvMax <= heroData.lv then
        superlayer:addChild(createEvolve(heroData, function()
        showUpdateLayer:runAction(CCRemoveSelf:create())
        updatePowerAndLv()
        updateState()
         end), 10000)
      else
        showToast(i18n.global.toast_hero_need_lvup.string)
      end
      end)
  end
  local attriBg = img.createUI9Sprite(img.ui.hero_attribute_lab_frame)
  attriBg:setPreferredSize(CCSize(366, 141))
  attriBg:setAnchorPoint(ccp(0.5, 0))
  attriBg:setPosition(214, 138)
  showUpdateLayer:addChild(attriBg)
  local showTitle = lbl.createFont1(18, i18n.global.hero_job_" .. cfghero[heroData.id].jo.string, ccc3(148, 98, 66))
  showTitle:setPosition(184, 117)
  attriBg:addChild(showTitle)
  local showJob = img.createUISprite(img.ui.job_" .. cfghero[heroData.id].jo)
  showJob:setPosition(showTitle:boundingBox():getMinX() - 25, 117)
  attriBg:addChild(showJob)
  local btnInfoSprite = img.createUISprite(img.ui.btn_detail)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  btnInfo:setScale(0.9)
  local menuInfo = CCMenu:createWithItem(btnInfo)
  btnInfo:setPosition(334, 115)
  menuInfo:setPosition(0, 0)
  attriBg:addChild(menuInfo)
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    board:addChild(require("ui.tips.attrdetail").create(heroData.attr()), 100)
   end)
  local attrData = heroData.attr()
  local attriInfo = {1 = {icon = img.ui.hero_attr_hp, num = attrData.hp}, 2 = {icon = img.ui.hero_attr_atk, num = attrData.atk}, 3 = {icon = img.ui.hero_attr_def, num = attrData.arm}, 4 = {icon = img.ui.hero_attr_spd, num = attrData.spd}}
  local showNum = {}
  for i = 1, 4 do
    local eachBg = img.createUI9Sprite(img.ui.hero_icon_bg)
    eachBg:setPreferredSize(CCSize(80, 80))
    eachBg:setAnchorPoint(ccp(0, 0))
    eachBg:setPosition(87 * i - 76 + 2, 12)
    attriBg:addChild(eachBg)
    local icon = img.createUISprite(attriInfo[i].icon)
    icon:setPosition(40, 50)
    eachBg:addChild(icon)
    showNum[i] = lbl.createFont1(16, math.floor(attriInfo[i].num), ccc3(111, 76, 56))
    showNum[i]:setPosition(40, 20)
    eachBg:addChild(showNum[i])
  end
  local skillId = {}
  if heroData.wake == nil or heroData.wake >= 4 then
    if cfghero[heroData.id].actSkillId then
      skillId[#skillId + 1] = {id = cfghero[heroData.id].actSkillId, lock = 0}
    end
    for i = 1, 6 do
      if cfghero[heroData.id].pasSkill" .. i .. "Id then
        skillId[#skillId + 1] = {id = cfghero[heroData.id].pasSkill" .. i .. "Id, lock = cfghero[heroData.id].pasTier" .. }
      end
    end
  else
    if cfghero[heroData.id].disillusSkill[heroData.wake].disi[1] then
      skillId[#skillId + 1] = {id = cfghero[heroData.id].disillusSkill[heroData.wake].disi[1], lock = 0}
    end
    for i = 1, 6 do
      if cfghero[heroData.id].disillusSkill[heroData.wake].disi[i + 1] then
        skillId[#skillId + 1] = {id = cfghero[heroData.id].disillusSkill[heroData.wake].disi[i + 1], lock = cfghero[heroData.id].pasTier" .. }
      end
    end
  end
  local showSkill = {}
  local skillTips = {}
  for i,v in ipairs(skillId) do
    showSkill[i] = img.createUISprite(img.ui.hero_skill_bg)
    showSkill[i]:setPosition(78 + 90 * (i - 1), 77)
    showUpdateLayer:addChild(showSkill[i])
    local skillIcon = img.createSkill(v.id, v.lock)
    skillIcon:setPosition(showSkill[i]:getContentSize().width / 2, showSkill[i]:getContentSize().height / 2)
    showSkill[i]:addChild(skillIcon)
    if cfgskill[v.id].skiL then
      local skillLB = img.createUISprite(img.ui.hero_skilllevel_bg)
      skillLB:setPosition(showSkill[i]:getContentSize().width - 15, showSkill[i]:getContentSize().height - 15)
      showSkill[i]:addChild(skillLB)
      local skilllab = lbl.createFont1(18, cfgskill[v.id].skiL, ccc3(255, 246, 223))
      skilllab:setPosition(skillLB:getContentSize().width / 2 - 1, skillLB:getContentSize().height / 2 + 1)
      skillLB:addChild(skilllab)
    end
    local lock = v.lock
    if v.lock <= heroData.star then
      lock = 0
    end
    skillTips[i] = require("ui.tips.skill").create(v.id, lock)
    skillTips[i]:setAnchorPoint(ccp(1, 0))
    skillTips[i]:setPosition(409, showSkill[i]:boundingBox():getMaxY() + 10)
    showUpdateLayer:addChild(skillTips[i])
    skillTips[i]:setVisible(false)
    if heroData.star < v.lock then
      setShader(skillIcon, SHADER_GRAY, true)
    end
  end
  local updateAttrAndLvm = function()
    if heroData.lv < lvMax then
      showCostExp:setString(cfgexphero[heroData.lv + 1].needExp)
      if cfgexphero[heroData.lv + 1].needExp > 100000 then
        showCostExp:setString(tostring(math.ceil(cfgexphero[heroData.lv + 1].needExp / 1000)) .. "k")
      end
      showCostGold:setString(cfgexphero[heroData.lv + 1].needGold)
      if cfgexphero[heroData.lv + 1].needGold > 100000 then
        showCostGold:setString(tostring(math.ceil(cfgexphero[heroData.lv + 1].needGold / 1000)) .. "k")
      end
      local exp = 0
      local coin = 0
      if bag.items.find(ITEM_ID_HERO_EXP) then
        exp = bag.items.find(ITEM_ID_HERO_EXP).num
      end
      if bag.items.find(ITEM_ID_COIN) then
        coin = bag.items.find(ITEM_ID_COIN).num
      end
      if exp < cfgexphero[heroData.lv + 1].needExp then
        showCostExp:setColor(ccc3(255, 44, 44))
      end
      if coin < cfgexphero[heroData.lv + 1].needGold then
        showCostGold:setColor(ccc3(255, 44, 44))
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
        local showMaxLv = img.createUISprite(img_maxlv)
        showMaxLv:setAnchorPoint(ccp(0, 0.5))
        showMaxLv:setPosition(titleExp:boundingBox():getMaxX() + 12, titleExp:boundingBox():getMidY())
        showUpdateLayer:addChild(showMaxLv)
        showCostExp:setVisible(false)
        showCostGold:setVisible(false)
        expCostBg:setVisible(false)
        expIcon:setVisible(false)
        goldIcon:setVisible(false)
      end
    end
    if lvMax <= heroData.lv and btnLvUpSprite and not tolua.isnull(btnLvUpSprite) then
      btnLvUpSprite:setVisible(false)
      btnLvUpSprite:removeFromParent()
      upvalue_6656 = nil
    end
    if heroData.star < cfghero[heroData.id].qlt and lvMax <= heroData.lv then
      upvalue_7680 = nil
      upvalue_7680 = img.createUISprite(img.ui.hero_btn_lvup)
      local showRed = img.createUISprite(img.ui.main_red_dot)
      showRed:setPosition(btnStarUpSprite:getContentSize().width - 5, btnStarUpSprite:getContentSize().height - 5)
      btnStarUpSprite:addChild(showRed)
      upvalue_8192 = SpineMenuItem:create(json.ui.button, btnStarUpSprite)
      local menuStarUp = CCMenu:createWithItem(btnStarUp)
      btnStarUp:setAnchorPoint(ccp(0, 0.5))
      btnStarUp:setPosition(346, titleEvolve:boundingBox():getMidY())
      menuStarUp:setPosition(0, 0)
      showUpdateLayer:addChild(menuStarUp)
      btnStarUp:registerScriptTapHandler(function()
        audio.play(audio.button)
        if lvMax <= heroData.lv then
          superlayer:addChild(createEvolve(heroData, function()
          if showUpdateLayer and not tolua.isnull(showUpdateLayer) then
            showUpdateLayer:runAction(CCRemoveSelf:create())
            updatePowerAndLv()
            updateState()
          end
            end), 10000)
        else
          showToast(i18n.global.toast_hero_need_lvup.string)
        end
         end)
    end
    upvalue_12288 = heroData.attr()
    upvalue_12800 = {1 = {icon = img.ui.hero_attr_hp, num = attrData.hp}, 2 = {icon = img.ui.hero_attr_atk, num = attrData.atk}, 3 = {icon = img.ui.hero_attr_def, num = attrData.arm}, 4 = {icon = img.ui.hero_attr_spd, num = attrData.spd}}
    for i = 1, 4 do
      showNum[i]:setString(math.floor(attriInfo[i].num))
    end
   end
  Lvup = function()
    local exp = 0
    local coin = 0
    if bag.items.find(ITEM_ID_HERO_EXP) then
      exp = bag.items.find(ITEM_ID_HERO_EXP).num
    end
    if bag.items.find(ITEM_ID_COIN) then
      coin = bag.items.find(ITEM_ID_COIN).num
    end
    if lvMax <= heroData.lv then
      showToast(i18n.global.toast_hero_need_starup.string)
      return 
    else
      if exp < cfgexphero[heroData.lv + 1].needExp then
        showToast(i18n.global.toast_hero_need_exp.string)
        return 
      else
        if coin < cfgexphero[heroData.lv + 1].needGold then
          showToast(i18n.global.toast_hero_need_coin.string)
          return 
        end
      end
      audio.play(audio.hero_lv_up)
      require("data.tutorial").goNext("hero", 2, true)
      require("data.tutorial").goNext("hero", 1, true)
      bag.items.sub({id = ITEM_ID_HERO_EXP, num = cfgexphero[heroData.lv + 1].needExp})
      bag.items.sub({id = ITEM_ID_COIN, num = cfgexphero[heroData.lv + 1].needGold})
      local attr = heroData.attr()
      heroData.lv = heroData.lv + 1
      local nattr = heroData.attr()
      onLvUp(attr, nattr)
      animLv:playAnimation("animation", 1)
      updatePowerAndLv()
      updateAttrAndLvm()
      do
        local params = {sid = player.sid, hid = heroData.hid, type = 1}
        net:hero_up(params, function(l_1_0)
        if l_1_0.status < 0 then
          showToast("status:" .. l_1_0.status)
          return 
        end
        tbl2string(l_1_0)
         end)
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local scheduler, myupdate = nil, nil
  scheduler = CCDirector:sharedDirector():getScheduler()
  local timer = 0
  local onTouch = function(l_6_0, l_6_1, l_6_2)
    local point = showUpdateLayer:convertToNodeSpace(ccp(l_6_1, l_6_2))
    for i,v in ipairs(showSkill) do
      if v:boundingBox():containsPoint(point) then
        skillTips[i]:setVisible(true)
        for i,v in (for generator) do
        end
        skillTips[i]:setVisible(false)
      end
      do
        local onUpdate = function(l_1_0)
        if btnLvUpSprite == nil and myupdate then
          scheduler:unscheduleScriptEntry(myupdate)
          upvalue_512 = nil
        end
        Lvup()
        upvalue_2048 = timer + l_1_0
        if timer >= 30 and myupdate then
          scheduler:unscheduleScriptEntry(myupdate)
          upvalue_512 = nil
        end
         end
        if l_6_0 == "began" and btnLvUpSprite and not tolua.isnull(btnLvUpSprite) and btnLvUpSprite:boundingBox():containsPoint(point) then
          playAnimTouchBegin(btnLvUpSprite)
          Lvup()
          upvalue_2048 = scheduler:scheduleScriptFunc(onUpdate, 0.2, false)
        end
        if myupdate and l_6_0 ~= "began" then
          if btnLvUpSprite and not tolua.isnull(btnLvUpSprite) then
            playAnimTouchEnd(btnLvUpSprite)
          end
          scheduler:unscheduleScriptEntry(myupdate)
          upvalue_2048 = nil
        end
        if l_6_0 ~= "began" and l_6_0 ~= "moved" then
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
  showUpdateLayer:setTouchEnabled(true)
  showUpdateLayer:setTouchSwallowEnabled(false)
   end
  updateState()
  return layer
end

return info

