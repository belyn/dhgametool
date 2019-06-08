-- Command line was: E:\github\dhgametool\scripts\fight\hurts.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local cfghero = require("config.hero")
local cfgmons = require("config.monster")
local herosdata = require("data.heros")
local progressbar = require("ui.progressbar")
local cfgPet = require("config.pet")
local BG_W, BG_H = 712, 546
local progress = {}
ui.create = function(l_1_0, l_1_1, l_1_2, l_1_3)
  local atkPet = nil
  if l_1_3.atk ~= nil then
    atkPet = l_1_3.atk.pet
  end
  print("******")
  tbl2string(l_1_0)
  local defPet = nil
  if l_1_3.def ~= nil then
    defPet = l_1_3.def.pet
  end
  local layer = CCLayer:create()
  progress = {}
  progress.dps = {}
  progress.heal = {}
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, 255))
  layer:addChild(darkbg)
  local bg = ui.createBg(l_1_0, l_1_1)
  bg:setScale(view.minScale / 10)
  bg:setPosition(view.midX, view.midY)
  bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  layer:addChild(bg)
  local closeBtn0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(BG_W - 26, BG_H - 26)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  bg:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer.onAndroidBack()
   end)
  local btn_unDps = img.createLogin9Sprite(img.login.button_9_small_mwhite)
  btn_unDps:setPreferredSize(CCSizeMake(142, 37))
  local doc = lbl.createFont1(18, i18n.global.hurts_dps.string, ccc3(96, 44, 15))
  doc:setPosition(71, 18.5)
  btn_unDps:addChild(doc)
  local btn_seleDps = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_seleDps:setPreferredSize(CCSizeMake(142, 37))
  btn_seleDps:setPosition(BG_W / 2 - 80, 462)
  local seleDoc = lbl.createFont1(18, i18n.global.hurts_dps.string, ccc3(96, 44, 15))
  seleDoc:setPosition(71, 18.5)
  btn_seleDps:addChild(seleDoc)
  local btn_Dps = SpineMenuItem:create(json.ui.button, btn_unDps)
  btn_Dps:setPosition(CCPoint(BG_W / 2 - 80, 462))
  local menu_Dps = CCMenu:createWithItem(btn_Dps)
  menu_Dps:setPosition(CCPoint(0, 0))
  menu_Dps:setVisible(false)
  bg:addChild(menu_Dps)
  bg:addChild(btn_seleDps)
  local btn_unHeat = img.createLogin9Sprite(img.login.button_9_small_mwhite)
  btn_unHeat:setPreferredSize(CCSizeMake(142, 37))
  local doc = lbl.createFont1(18, i18n.global.hurts_heal.string, ccc3(96, 44, 15))
  doc:setPosition(71, 18.5)
  btn_unHeat:addChild(doc)
  local btn_seleHeat = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_seleHeat:setPreferredSize(CCSizeMake(142, 37))
  btn_seleHeat:setPosition(BG_W / 2 + 80, 462)
  btn_seleHeat:setVisible(false)
  local seleDoc = lbl.createFont1(18, i18n.global.hurts_heal.string, ccc3(96, 44, 15))
  seleDoc:setPosition(71, 18.5)
  btn_seleHeat:addChild(seleDoc)
  local btn_Heat = SpineMenuItem:create(json.ui.button, btn_unHeat)
  btn_Heat:setPosition(CCPoint(BG_W / 2 + 80, 462))
  local menu_Heat = CCMenu:createWithItem(btn_Heat)
  menu_Heat:setPosition(CCPoint(0, 0))
  bg:addChild(menu_Heat)
  bg:addChild(btn_seleHeat)
  btn_Dps:registerScriptTapHandler(function()
    audio.play(audio.button)
    menu_Dps:setVisible(false)
    btn_seleDps:setVisible(true)
    menu_Heat:setVisible(true)
    btn_seleHeat:setVisible(false)
    for k,v in pairs(progress.heal) do
      v.pro:setVisible(false)
      v.lal:setVisible(false)
    end
    for k,v in pairs(progress.dps) do
      v.pro:setVisible(true)
      v.lal:setVisible(true)
    end
   end)
  btn_Heat:registerScriptTapHandler(function()
    audio.play(audio.button)
    menu_Dps:setVisible(true)
    btn_seleDps:setVisible(false)
    menu_Heat:setVisible(false)
    btn_seleHeat:setVisible(true)
    for k,v in pairs(progress.heal) do
      v.pro:setVisible(true)
      v.lal:setVisible(true)
    end
    for k,v in pairs(progress.dps) do
      v.pro:setVisible(false)
      v.lal:setVisible(false)
    end
   end)
  local atkDps = ui.getHurtInfos("atk", l_1_0, l_1_2, atkPet)
  local atkHeal = ui.getHurtInfos("atk", l_1_0, l_1_2, atkPet, true)
  local defDps = ui.getHurtInfos("def", l_1_1, l_1_2, defPet)
  local defHeal = ui.getHurtInfos("def", l_1_1, l_1_2, defPet, true)
  local maxDps = ui.getMaxData(atkDps, defDps)
  local maxHeal = ui.getMaxData(atkHeal, defHeal)
  ui.drawHurtInfos("atk", bg, atkDps, atkHeal, maxDps, maxHeal)
  ui.drawHurtInfos("def", bg, defDps, defHeal, maxDps, maxHeal)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParent()
   end
  layer:registerScriptHandler(function(l_5_0)
    if l_5_0 == "enter" then
      layer.notifyParentLock()
    elseif l_5_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

ui.createBg = function()
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setPreferredSize(CCSize(BG_W, BG_H))
  for i = 1, 2 do
    for j = 1, 7 do
      local banner = img.createUISprite(img.ui.fight_hurts_bg_1)
      if j % 2 == 0 then
        banner:setOpacity(178.5)
      end
      banner:setFlipX(i == 2)
      banner:setAnchorPoint(ccp(op3(i == 1, 1, 0), 1))
      banner:setPosition(op3(i == 1, BG_W / 2, BG_W / 2), 66 + (j - 1) * 62)
      bg:addChild(banner)
    end
  end
  local line = img.createUISprite(img.ui.fight_hurts_new_line)
  line:setScaleY(71.666666666667)
  line:setPosition(BG_W / 2, 437)
  line:setAnchorPoint(ccp(0.5, 1))
  bg:addChild(line)
  local Hline = img.createUISprite(img.ui.hero_tips_fgline)
  Hline:setScaleX(212.66666666667)
  Hline:setPosition(BG_W / 2, 487)
  Hline:setAnchorPoint(ccp(0.5, 0.5))
  bg:addChild(Hline)
  local vs = img.createUISprite(img.ui.fight_pay_vs)
  vs:setScale(0.4)
  vs:setPosition(BG_W / 2, 513)
  bg:addChild(vs)
  local atkTitleStr = i18n.global.fight_hurt_atk_title.string
  local atkTitle = lbl.createMixFont1(22, atkTitleStr, ccc3(104, 175, 255))
  atkTitle:setPosition(bg:getContentSize().width / 2 - 172, 510)
  bg:addChild(atkTitle)
  local defTitleStr = i18n.global.fight_hurt_def_title.string
  local defTitle = lbl.createMixFont1(22, defTitleStr, ccc3(255, 89, 89))
  defTitle:setPosition(bg:getContentSize().width / 2 + 172, 510)
  bg:addChild(defTitle)
  return bg
end

ui.getMaxData = function(l_3_0, l_3_1)
  local maxHurt = 0
  for _,info in ipairs(l_3_0) do
    if maxHurt == nil or maxHurt < info.hurt then
      maxHurt = info.hurt
    end
  end
  for _,info in ipairs(l_3_1) do
    if maxHurt == nil or maxHurt < info.hurt then
      maxHurt = info.hurt
    end
  end
  if maxHurt == 0 then
    maxHurt = 1
  end
  return maxHurt
end

ui.drawPro = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5)
  local x, y = op3(l_4_0 == "atk", BG_W / 2 - 266, BG_W / 2 + 266), 382 - (l_4_2 - 1) * 62
  local progressBg = img.createUISprite(img.ui.fight_hurts_bar_bg)
  local progressFg = progressbar.create(img.createUISprite(l_4_5))
  if l_4_0 == "atk" then
    progressFg:setScaleX(-1)
    progressBg:setAnchorPoint(ccp(0, 0.5))
    progressBg:setPosition(x + 15, y + 18)
    progressFg:setMidpoint(ccp(1, 0.5))
    progressFg:setBarChangeRate(ccp(1, 0))
  else
    progressBg:setAnchorPoint(ccp(1, 0.5))
    progressBg:setPosition(x - 15, y + 18)
    progressFg:setMidpoint(ccp(1, 0))
  end
  local progressBgRect = progressBg:boundingBox()
  progressFg:setPosition(progressBgRect:getMidX(), progressBgRect:getMidY() + 1)
  progressFg.setPercentageOnly(0)
  progressFg.scalePercentageOnly(l_4_3.hurt / l_4_4 * 100)
  local progressNum = lbl.createFont2(14, "0", ccc3(248, 242, 226))
  progressNum:setPosition(progressBgRect:getMidX(), progressBgRect:getMidY() + 20)
  l_4_1:addChild(progressBg, 10)
  l_4_1:addChild(progressFg, 20)
  l_4_1:addChild(progressNum, 21)
  progressFg.setPercentageHandler(function(l_1_0)
    progressNum:setString(math.floor(maxHurt * l_1_0 / 100))
   end)
  return progressFg, progressNum
end

ui.drawHurtInfos = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5)
  for i,info in ipairs(l_5_2) do
    local x, y = op3(l_5_0 == "atk", BG_W / 2 - 266, BG_W / 2 + 266), 382 - (i - 1) * 62
    local head = nil
    if info.pos < 13 then
      local param = {id = info.id, lv = info.lv, showGroup = true, showStar = true, wake = info.wake, orangeFx = nil, petID = nil}
      if l_5_0 == "atk" and info.hid and info.skin == nil then
        param.hid = info.hid
      end
      if info.skin then
        param.skin = info.skin
      end
      head = img.createHeroHeadByParam(param)
    else
      head = img.createUISprite(img.ui.herolist_head_bg)
      local bgSize = head:getContentSize()
      local playerHead = img.createPlayerHeadById(info.id)
      playerHead:setPosition(bgSize.width / 2, bgSize.height / 2)
      head:addChild(playerHead)
      local petJson = json.create(json.ui.petHint)
      petJson:playAnimation("animation", -1)
      petJson:setPosition(bgSize.width / 2, bgSize.height / 2)
      head:addChild(petJson, 10)
    end
    head:setScale(0.55)
    head:setAnchorPoint(op3(l_5_0 == "atk", ccp(1, 0), ccp(0, 0)))
    head:setPosition(x, y)
    l_5_1:addChild(head)
  end
  for k,v in pairs(l_5_2) do
    local myDps, myDpslal = ui.drawPro(l_5_0, l_5_1, k, v, l_5_4, img.ui.fight_hurts_bar_fg_2)
    progress.dps[v.pos] = {}
    progress.dps[v.pos].pro = myDps
    progress.dps[v.pos].lal = myDpslal
  end
  for k,v in pairs(l_5_3) do
    local myDps, myDpslal = ui.drawPro(l_5_0, l_5_1, k, v, l_5_5, img.ui.fight_hurts_bar_fg_1)
    progress.heal[v.pos] = {}
    progress.heal[v.pos].pro = myDps
    progress.heal[v.pos].lal = myDpslal
    progress.heal[v.pos].pro:setVisible(false)
    progress.heal[v.pos].lal:setVisible(false)
  end
end

ui.getHurtInfos = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  do
    local infos = {}
    for _,h in ipairs(l_6_1) do
      local info = nil
      if h.kind == "mons" then
        if h.lv or not h.star then
          info = {id = cfgmons[h.id].heroLink, lv = cfgmons[h.id].lvShow, star = cfgmons[h.id].star}
        elseif h.hid then
          local hdata = herosdata.find(h.hid)
          if (((((not h.id and hdata and h.lv) or not hdata or not h.star and hdata and not h.wake and hdata and not h.hid and hdata and not h.skin and hdata)))) then
            info = {id = hdata.id, lv = hdata.lv, star = hdata.star, wake = hdata.wake, hid = hdata.hid, skin = hdata.skin}
          else
            info = {id = h.id, lv = h.lv, star = h.star, wake = h.wake, skin = h.skin}
          end
          info.pos = op3(l_6_0 == "atk", h.pos, h.pos + 6)
          info.hurt = ui.getHurtValue(info.pos, l_6_2, l_6_4)
          info.name = i18n.hero[info.id].heroName
          infos[ infos + 1] = info
        end
        if l_6_3 ~= nil then
          local info = {}
          info.pos = 13
          if l_6_0 ~= "atk" then
            info.pos = 14
          end
          info.name = ""
          info.id = cfgPet[l_6_3.id].petIcon[l_6_3.star + 1]
          print("\230\136\152\229\174\160ID = ", info.id)
          info.lv = 1
          info.star = l_6_3.star
          info.hurt = ui.getHurtValue(info.pos, l_6_2, l_6_4)
          infos[ infos + 1] = info
        end
        table.sort(infos, function(l_1_0, l_1_1)
        return l_1_0.pos < l_1_1.pos
         end)
        return infos
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.getHurtValue = function(l_7_0, l_7_1, l_7_2)
  for _,s in ipairs(l_7_1) do
    if l_7_2 == nil then
      if not s.value then
        return s.pos ~= l_7_0 or 0
        for _,s in (for generator) do
        end
      end
      return s.heal or 0
    end
    return 0
     -- Warning: missing end command somewhere! Added here
  end
end

return ui

