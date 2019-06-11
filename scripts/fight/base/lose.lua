-- Command line was: E:\github\dhgametool\scripts\fight\base\lose.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
ui.create = function()
  local layer = CCLayer:create()
  audio.play(audio.fight_lose)
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local bg = json.create(json.ui.zhandou_lose)
  bg:playAnimation("animation")
  bg:appendNextAnimation("loop", -1)
  bg:setScale(view.minScale)
  bg:setPosition(scalep(480, 288))
  layer:addChild(bg)
  layer.bg = bg
  local title = nil
  local posX = 0
  local posY = 0
  if i18n.getCurrentLanguage() == kLanguageChinese then
    posX = 8
    posY = -10
    title = img.createUISprite(img.ui.language_defeat_cn)
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      title = img.createUISprite(img.ui.language_defeat_jp)
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        title = img.createUISprite(img.ui.language_defeat_jp)
      else
        if i18n.getCurrentLanguage() == kLanguageKorean then
          title = img.createUISprite(img.ui.language_defeat_kr)
        else
          if i18n.getCurrentLanguage() == kLanguageRussian then
            title = img.createUISprite(img.ui.language_defeat_ru)
          else
            title = img.createUISprite(img.ui.language_defeat_us)
          end
        end
      end
    end
  end
  bg:addChildFollowSlot("code_defeat", title)
  title:setPositionX(posX)
  title:setPositionY(posY)
  require("fight.base.win").addContent(layer)
  layer.addOkNextButton = function(l_1_0, l_1_1, l_1_2)
    ui.addOkNextButton(layer, l_1_0, l_1_1, l_1_2)
   end
  layer.addOkButton = function(l_2_0, l_2_1)
    require("fight.base.win").addOkButton(layer, l_2_0, l_2_1)
   end
  layer.addRewardIcons = function(l_3_0, l_3_1)
    require("fight.base.win").addRewardIcons(layer, l_3_0, l_3_1)
   end
  layer.addVsScores = function(l_4_0)
    require("fight.base.win").addVsScores(layer, l_4_0)
   end
  layer.addHurtsButton = function(l_5_0, l_5_1, l_5_2, l_5_3)
    require("fight.base.win").addHurtsButton(layer, l_5_0, l_5_1, l_5_2, l_5_3)
   end
  layer.addHurtsSum = function(l_6_0)
    require("fight.base.win").addHurtsSum(layer, l_6_0)
   end
  layer.addEnhanceGuide = function(l_7_0)
    require("fight.base.win").addEnhanceGuide(layer, l_7_0)
   end
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

ui.addOkNextButton = function(l_2_0, l_2_1, l_2_2, l_2_3)
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
  addBackEvent(l_2_0)
  l_2_0.onAndroidBack = function()
    handler1()
   end
  local nextBtn0 = img.createLogin9Sprite(img.login.button_9_gold)
  nextBtn0:setPreferredSize(CCSize(208, 75))
  local nextBtn = SpineMenuItem:create(json.ui.button, nextBtn0)
  local nextSize = okBtn:getContentSize()
  local nextText = i18n.global.arena_video_next.string
  if l_2_3 then
    nextText = i18n.global.frdpk_video_next.string
  end
  local nextLabel = lbl.createFont1(22, nextText, lbl.buttonColor)
  nextLabel:setPosition(nextSize.width / 2, nextSize.height / 2)
  nextBtn0:addChild(nextLabel)
  nextBtn:setPosition(150, 0)
  local nextMenu = CCMenu:createWithItem(nextBtn)
  nextMenu:ignoreAnchorPointForPosition(false)
  newNode:addChild(nextMenu)
  l_2_0.bg:addChildFollowSlot("code_button", newNode)
  nextBtn:registerScriptTapHandler(function()
    nextBtn:setEnabled(false)
    audio.play(audio.button)
    handler2()
   end)
end

return ui

