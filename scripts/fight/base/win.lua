-- Command line was: E:\github\dhgametool\scripts\fight\base\win.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local particle = require("res.particle")
ui.create = function()
  local layer = CCLayer:create()
  audio.play(audio.fight_win)
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local bg = json.create(json.ui.zhandou_win)
  bg:playAnimation("animation")
  bg:appendNextAnimation("loop", -1)
  bg:setScale(view.minScale)
  bg:setPosition(scalep(480, 288))
  layer:addChild(bg)
  layer.bg = bg
  local title, title2 = nil, nil
  if i18n.getCurrentLanguage() == kLanguageChinese then
    title = img.createUISprite(img.ui.language_victory_cn)
    title2 = img.createUISprite(img.ui.language_victory_cn)
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      title = img.createUISprite(img.ui.language_victory_jp)
      title2 = img.createUISprite(img.ui.language_victory_jp)
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        title = img.createUISprite(img.ui.language_victory_jp)
        title2 = img.createUISprite(img.ui.language_victory_jp)
      else
        if i18n.getCurrentLanguage() == kLanguageKorean then
          title = img.createUISprite(img.ui.language_victory_kr)
          title2 = img.createUISprite(img.ui.language_victory_kr)
        else
          if i18n.getCurrentLanguage() == kLanguageRussian then
            title = img.createUISprite(img.ui.language_victory_ru)
            title2 = img.createUISprite(img.ui.language_victory_ru)
          else
            if i18n.getCurrentLanguage() == kLanguageTurkish then
              title = img.createUISprite(img.ui.language_victory_tr)
              title2 = img.createUISprite(img.ui.language_victory_tr)
            else
              title = img.createUISprite(img.ui.language_victory_us)
              title2 = img.createUISprite(img.ui.language_victory_us)
            end
          end
        end
      end
    end
  end
  bg:addChildFollowSlot("code_victory", title)
  bg:addChildFollowSlot("code_victory2", title2)
  schedule(layer, bg:getEventTime("animation", "lihua"), function()
    local p1 = particle.create("lihua_left")
    p1:setScale(view.minScale)
    p1:setPosition(bg:getBonePositionRelativeToWorld("code_lihua"))
    layer:addChild(p1, 10)
    local p2 = particle.create("lihua_left")
    p2:setScale(view.minScale)
    p2:setScaleX(not view.minScale)
    p2:setPosition(bg:getBonePositionRelativeToWorld("code_lihua2"))
    layer:addChild(p2, 10)
   end)
  schedule(layer, bg:getEventTime("animation", "lihua2"), function()
    local p = particle.create("lihua_top")
    p:setScale(view.minScale)
    p:setPosition(ccp(view.midX, view.maxY))
    layer:addChild(p, 10)
   end)
  ui.addContent(layer)
  layer.addOkNextButton = function(l_3_0, l_3_1)
    ui.addOkNextButton(layer, l_3_0, l_3_1)
   end
  layer.addOkButton = function(l_4_0, l_4_1)
    ui.addOkButton(layer, l_4_0, l_4_1)
   end
  layer.addRewardIcons = function(l_5_0)
    ui.addRewardIcons(layer, l_5_0)
   end
  layer.addVsScores = function(l_6_0)
    ui.addVsScores(layer, l_6_0)
   end
  layer.addHurtsButton = function(l_7_0, l_7_1, l_7_2, l_7_3)
    require("fight.base.win").addHurtsButton(layer, l_7_0, l_7_1, l_7_2, l_7_3)
   end
  layer.addHurtsSum = function(l_8_0)
    ui.addHurtsSum(layer, l_8_0)
   end
  layer.addEnhanceGuide = function(l_9_0)
    ui.addEnhanceGuide(layer, l_9_0)
   end
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

ui.addContent = function(l_2_0)
  do
    local content = CCLayer:create()
    content:setCascadeOpacityEnabled(true)
    content:setVisible(false)
    l_2_0:addChild(content, 5)
    l_2_0.content = content
    content:runAction(createSequence({}))
  end
   -- Warning: undefined locals caused missing assignments!
end

ui.addOkNextButton = function(l_3_0, l_3_1, l_3_2)
  local newNode = CCSprite:create()
  newNode:ignoreAnchorPointForPosition(false)
  newNode:setCascadeOpacityEnabled(true)
  local okBtn0 = img.createLogin9Sprite(img.login.button_9_gold)
  okBtn0:setPreferredSize(CCSize(208, 75))
  local okBtn = SpineMenuItem:create(json.ui.button, okBtn0)
  local okSize = okBtn:getContentSize()
  local okText = i18n.global.dialog_button_confirm.string
  local okLabel = lbl.createFont1(22, okText, lbl.buttonColor)
  okLabel:setPosition(okSize.width / 2, okSize.height / 2)
  okBtn0:addChild(okLabel)
  okBtn:setPosition(-150, 0)
  local okMenu = CCMenu:createWithItem(okBtn)
  okMenu:ignoreAnchorPointForPosition(false)
  newNode:addChild(okMenu)
  okBtn:registerScriptTapHandler(function()
    okBtn:setEnabled(false)
    audio.play(audio.button)
    handler1()
   end)
  addBackEvent(l_3_0)
  l_3_0.onAndroidBack = function()
    handler1()
   end
  local nextBtn0 = img.createLogin9Sprite(img.login.button_9_gold)
  nextBtn0:setPreferredSize(CCSize(208, 75))
  local nextBtn = SpineMenuItem:create(json.ui.button, nextBtn0)
  local nextSize = okBtn:getContentSize()
  local nextText = i18n.global.arena_video_next.string
  local nextLabel = lbl.createFont1(22, nextText, lbl.buttonColor)
  nextLabel:setPosition(nextSize.width / 2, nextSize.height / 2)
  nextBtn0:addChild(nextLabel)
  nextBtn:setPosition(150, 0)
  local nextMenu = CCMenu:createWithItem(nextBtn)
  nextMenu:ignoreAnchorPointForPosition(false)
  newNode:addChild(nextMenu)
  l_3_0.bg:addChildFollowSlot("code_button", newNode)
  nextBtn:registerScriptTapHandler(function()
    nextBtn:setEnabled(false)
    audio.play(audio.button)
    handler2()
   end)
end

ui.addOkButton = function(l_4_0, l_4_1, l_4_2)
  local okBtn0 = img.createLogin9Sprite(img.login.button_9_gold)
  okBtn0:setPreferredSize(CCSize(208, 75))
  okBtn0:setCascadeOpacityEnabled(true)
  local okBtn = SpineMenuItem:create(json.ui.button, okBtn0)
  local okSize = okBtn:getContentSize()
  if not l_4_2 then
    local okText = i18n.global.dialog_button_confirm.string
  end
  local okLabel = lbl.createFont1(22, okText, lbl.buttonColor)
  okLabel:setPosition(okSize.width / 2, okSize.height / 2)
  okBtn0:addChild(okLabel)
  okBtn:setCascadeOpacityEnabled(true)
  local okMenu = CCMenu:createWithItem(okBtn)
  okMenu:ignoreAnchorPointForPosition(false)
  okMenu:setCascadeOpacityEnabled(true)
  l_4_0.bg:addChildFollowSlot("code_button", okMenu)
  okBtn:registerScriptTapHandler(function()
    okBtn:setEnabled(false)
    audio.play(audio.button)
    handler()
   end)
  addBackEvent(l_4_0)
  l_4_0.onAndroidBack = function()
    handler()
   end
end

ui.addRewardIcons = function(l_5_0, l_5_1, l_5_2)
  if not l_5_1 then
    l_5_1 = tablecp({})
    if not l_5_1.equips then
      l_5_1.equips = {}
    end
    if not l_5_1.items then
      l_5_1.items = {}
    end
    table.sort(l_5_1.items, function(l_1_0, l_1_1)
      return l_1_0.id < l_1_1.id
      end)
    local w, h, gap = 84, 84, 12
    local count = #l_5_1.equips + #l_5_1.items
    do
      local container = CCSprite:create()
      container:setContentSize(CCSize(count * w + (count - 1) * gap, h))
      container:setCascadeOpacityEnabled(true)
      if l_5_2 then
        container:setScale(view.minScale)
        container:setPosition(scalep(480, 300))
        l_5_0.content:addChild(container)
      else
        l_5_0.bg:addChildFollowSlot("code_icon", container)
      end
      for i,t in ipairs(l_5_1.items) do
        do
          local icon = img.createItem(t.id, t.num)
          icon:setCascadeOpacityEnabled(true)
          local btn = SpineMenuItem:create(json.ui.button, icon)
          btn:setCascadeOpacityEnabled(true)
          btn:setPosition((i - 0.5) * w + (i - 1) * gap, h / 2)
          local menu = CCMenu:createWithItem(btn)
          menu:setPosition(0, 0)
          menu:setCascadeOpacityEnabled(true)
          container:addChild(menu)
          btn:registerScriptTapHandler(function()
          layer:addChild(require("ui.tips.item").createForShow(t), 1000)
          audio.play(audio.button)
            end)
        end
      end
      for i,e in ipairs(l_5_1.equips) do
        local icon = img.createEquip(e.id, e.num)
        icon:setCascadeOpacityEnabled(true)
        local btn = SpineMenuItem:create(json.ui.button, icon)
        btn:setCascadeOpacityEnabled(true)
        btn:setPosition((#l_5_1.items + i - 0.5) * w + (#l_5_1.items + i - 1) * gap, h / 2)
        local menu = CCMenu:createWithItem(btn)
        menu:setPosition(0, 0)
        menu:setCascadeOpacityEnabled(true)
        container:addChild(menu)
        btn:registerScriptTapHandler(function()
        layer:addChild(require("ui.tips.equip").createForShow(e), 1000)
        audio.play(audio.button)
         end)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.addVsScores = function(l_6_0, l_6_1)
  local vs = img.createUISprite(img.ui.fight_pay_vs)
  vs:setScale(view.minScale)
  vs:setPosition(scalep(480, 300))
  l_6_0.content:addChild(vs)
  local addScoreInfo = function(l_1_0, l_1_1, l_1_2, l_1_3)
    local y = 303
    local head = img.createPlayerHead(l_1_0.logo, l_1_0.lv)
    head:setScale(view.minScale)
    head:setPosition(scalep(l_1_3, y))
    head:setCascadeOpacityEnabled(true)
    layer.content:addChild(head, 1)
    local name = lbl.createFontTTF(18, l_1_0.name, lbl.whiteColor, true)
    name:setPosition(scalep(l_1_3, y + 59))
    layer.content:addChild(name, 1)
    if not video.noscore then
      local title = lbl.createFont2(18, i18n.global.fight_pvp_score.string, lbl.whiteColor, true)
      title:setPosition(scalep(l_1_3, y - 72))
      layer.content:addChild(title, 1)
      local num1 = lbl.createFont3(28, l_1_1, ccc3(255, 214, 103), true)
      num1:setAnchorPoint(ccp(1, 0))
      num1:setPosition(scalep(l_1_3 - 2, y - 119))
      layer.content:addChild(num1, 1)
      local text = string.format("(%+d)", l_1_2)
      local num2 = lbl.createFont2(20, text, ccc3(255, 214, 103), true)
      num2:setAnchorPoint(ccp(0, 0))
      num2:setPosition(scalep(l_1_3 + 3, y - 112))
      layer.content:addChild(num2, 1)
    end
   end
  addScoreInfo(l_6_1.atk, l_6_1.ascore, l_6_1.adelta, 330)
  addScoreInfo(l_6_1.def, l_6_1.dscore, l_6_1.ddelta, 630)
end

ui.addHurtsButton = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4)
  print("\232\191\155\229\133\165\229\159\186\231\161\128addHurtsButton")
  local btn0 = img.createUISprite(img.ui.fight_hurts)
  btn0:setCascadeOpacityEnabled(true)
  local btn = SpineMenuItem:create(json.ui.button, btn0)
  btn:setCascadeOpacityEnabled(true)
  btn:setScale(view.minScale)
  btn:setPosition(scalep(920, 400))
  local btnMenu = CCMenu:createWithItem(btn)
  btnMenu:setCascadeOpacityEnabled(true)
  btnMenu:setPosition(0, 0)
  l_7_0.content:addChild(btnMenu, 1)
  btn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("fight.hurts").create(atks, defs, hurts, video), 10)
   end)
end

ui.addHurtsSum = function(l_8_0, l_8_1)
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  container:setScale(view.minScale)
  container:setPosition(scalep(480, 215))
  l_8_0.content:addChild(container)
  local text = lbl.createFont2(18, i18n.global.fight_hurts_sum.string .. ":", ccc3(252, 215, 117))
  text:setAnchorPoint(ccp(0, 0.5))
  text:setPosition(0, 5)
  container:addChild(text)
  local value = 0
  for _,h in ipairs(l_8_1) do
    if h.pos <= 6 then
      value = value + h.value
    end
  end
  local num = lbl.createFont2(18, value, lbl.whiteColor)
  num:setAnchorPoint(ccp(0, 0.5))
  num:setPosition(text:boundingBox():getMaxX() + 10, 5)
  container:addChild(num)
  container:setContentSize(CCSize(num:boundingBox():getMaxX(), 10))
end

ui.addEnhanceGuide = function(l_9_0, l_9_1)
  local label = lbl.createMixFont2(18, i18n.global.fight_guide.string, lbl.whiteColor, true)
  label:setPosition(scalep(480, 368))
  l_9_0.content:addChild(label)
  local infos = {{icon = img.ui.fight_pay_go_smith, x = 310, y = 280, text = i18n.global.fight_pay_go_smith.string, handler = l_9_1.backToSmith}, {icon = img.ui.fight_pay_go_hero, x = 480, y = 280, text = i18n.global.fight_pay_go_hero.string, handler = l_9_1.backToHero}, {icon = img.ui.fight_pay_go_summon, x = 650, y = 280, text = i18n.global.fight_pay_go_summon.string, handler = l_9_1.backToSummon}}
  for _,info in ipairs(infos) do
    do
      local btn0 = img.createUISprite(info.icon)
      btn0:setCascadeOpacityEnabled(true)
      local btn = SpineMenuItem:create(json.ui.button, btn0)
      btn:setScale(view.minScale)
      btn:setPosition(scalep(info.x, info.y))
      btn:setCascadeOpacityEnabled(true)
      btn:registerScriptTapHandler(function()
        audio.play(audio.button)
        info.handler()
         end)
      local menu = CCMenu:createWithItem(btn)
      menu:setPosition(0, 0)
      menu:setCascadeOpacityEnabled(true)
      l_9_0.content:addChild(menu)
      local label = lbl.createMixFont1(14, info.text, ccc3(161, 204, 242), true)
      label:setPosition(scalep(info.x, info.y - 70))
      l_9_0.content:addChild(label)
    end
  end
end

return ui

