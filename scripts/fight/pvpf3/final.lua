-- Command line was: E:\github\dhgametool\scripts\fight\pvpf3\final.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local herosdata = require("data.heros")
ui.create = function(l_1_0)
  local anim_name = json.ui.p3v3jiesuan_d
  local code_name = "code_defeat"
  local winlose = "defeat"
  local anim_birth = "start"
  local anim_loop = "loop"
  local win_count = 0
  for ii = 1, #l_1_0.wins do
    if l_1_0.wins[ii] == true then
      win_count = win_count + 1
    end
  end
  if win_count >= 2 then
    anim_name = json.ui.p3v3jiesuan_v
    code_name = "code_victory"
    winlose = "victory"
  end
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY * 0.8))
  layer:addChild(darkbg)
  json.load(anim_name)
  local anim = DHSkeletonAnimation:createWithKey(anim_name)
  anim:setScale(view.minScale)
  anim:scheduleUpdateLua()
  anim:setPosition(scalep(480, 288))
  layer:addChild(anim, 1)
  local atitle = nil
  if i18n.getCurrentLanguage() == kLanguageChinese then
    atitle = img.createUISprite(img.ui.language_" .. winlose .. "_cn)
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      atitle = img.createUISprite(img.ui.language_" .. winlose .. "_jp)
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        atitle = img.createUISprite(img.ui.language_" .. winlose .. "_jp)
      else
        if i18n.getCurrentLanguage() == kLanguageKorean then
          atitle = img.createUISprite(img.ui.language_" .. winlose .. "_kr)
        else
          if i18n.getCurrentLanguage() == kLanguageRussian then
            atitle = img.createUISprite(img.ui.language_" .. winlose .. "_ru)
          else
            atitle = img.createUISprite(img.ui.language_" .. winlose .. "_us)
          end
        end
      end
    end
  end
  anim:addChildFollowSlot(code_name, atitle)
  local base_win = require("fight.base.win")
  local okHandler = function()
    require("fight.pvpf3.loading").backToUI(video)
   end
  local arr = CCArray:create()
  arr:addObject(CCCallFunc:create(function()
    anim:playAnimation(anim_birth)
   end))
  arr:addObject(CCCallFunc:create(function()
    ui.addContent(layer)
    ui.addOkButton(layer, okHandler)
    ui.addVsScores(layer, video)
   end))
  local remain_cd = anim:getAnimationTime(anim_birth)
  if remain_cd > 0 then
    arr:addObject(CCDelayTime:create(remain_cd))
  end
  arr:addObject(CCCallFunc:create(function()
    anim:playAnimation(anim_loop, -1)
   end))
  layer:runAction(CCSequence:create(arr))
  addBackEvent(layer)
  layer.onAndroidBack = function()
    okHandler()
   end
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

ui.addContent = function(l_2_0)
  local content = CCLayer:create()
  content:setCascadeOpacityEnabled(true)
  l_2_0:addChild(content, 5)
  l_2_0.content = content
end

ui.addOkButton = function(l_3_0, l_3_1)
  local okBtn0 = img.createLogin9Sprite(img.login.button_9_gold)
  okBtn0:setPreferredSize(CCSize(208, 75))
  okBtn0:setCascadeOpacityEnabled(true)
  local okBtn = SpineMenuItem:create(json.ui.button, okBtn0)
  local okSize = okBtn:getContentSize()
  if not text then
    local okText = i18n.global.dialog_button_confirm.string
  end
  local okLabel = lbl.createFont1(22, okText, lbl.buttonColor)
  okLabel:setPosition(okSize.width / 2, okSize.height / 2)
  okBtn0:addChild(okLabel)
  okBtn:setCascadeOpacityEnabled(true)
  okBtn:setScale(view.minScale)
  okBtn:setPosition(scalep(480, 101))
  local okMenu = CCMenu:createWithItem(okBtn)
  okMenu:setPosition(CCPoint(0, 0))
  l_3_0:addChild(okMenu)
  okBtn:registerScriptTapHandler(function()
    okBtn:setEnabled(false)
    audio.play(audio.button)
    handler()
   end)
end

ui.addVsScores = function(l_4_0, l_4_1)
  local win_count = 0
  for ii = 1, #l_4_1.wins do
    if l_4_1.wins[ii] == true then
      win_count = win_count + 1
    end
  end
  local vs = img.createUISprite(img.ui.fight_pay_vs)
  vs:setScale(view.minScale)
  vs:setPosition(scalep(480, 287))
  l_4_0.content:addChild(vs)
  local lbl_rate = lbl.createFont3(28, win_count .. " : " .. #l_4_1.wins - (win_count), ccc3(255, 214, 103), true)
  lbl_rate:setPosition(scalep(480, 352))
  l_4_0.content:addChild(lbl_rate)
  local addHeadFlag = function(l_1_0)
    local flag = img.createUISprite(img.ui.friend_pvp_captain)
    flag:setAnchorPoint(CCPoint(0, 1))
    flag:setPosition(CCPoint(0, l_1_0:getContentSize().height))
    l_1_0:addChild(flag, 10000)
   end
  local addScoreInfo = function(l_2_0, l_2_1, l_2_2, l_2_3)
    local y = 321
    local head_scale = 0.7
    local head_step = 75
    local head = img.createPlayerHead(l_2_0.mbrs[1].logo, l_2_0.mbrs[1].lv)
    head:setScale(head_scale * view.minScale)
    head:setPosition(scalep(l_2_3 - head_step, y))
    head:setCascadeOpacityEnabled(true)
    layer.content:addChild(head, 1)
    if l_2_0.mbrs[1].uid == l_2_0.leader then
      addHeadFlag(head)
    end
    local head2 = img.createPlayerHead(l_2_0.mbrs[2].logo, l_2_0.mbrs[2].lv)
    head2:setScale(head_scale * view.minScale)
    head2:setPosition(scalep(l_2_3 - 0, y))
    head2:setCascadeOpacityEnabled(true)
    layer.content:addChild(head2, 1)
    if l_2_0.mbrs[2].uid == l_2_0.leader then
      addHeadFlag(head2)
    end
    local head3 = img.createPlayerHead(l_2_0.mbrs[3].logo, l_2_0.mbrs[3].lv)
    head3:setScale(head_scale * view.minScale)
    head3:setPosition(scalep(l_2_3 + head_step, y))
    head3:setCascadeOpacityEnabled(true)
    layer.content:addChild(head3, 1)
    if l_2_0.mbrs[3].uid == l_2_0.leader then
      addHeadFlag(head3)
    end
    local name = lbl.createFontTTF(18, l_2_0.name, lbl.whiteColor, true)
    name:setPosition(scalep(l_2_3, y + 59))
    layer.content:addChild(name, 1)
    local title = lbl.createFont2(18, i18n.global.fight_pvp_score.string, lbl.whiteColor, true)
    title:setPosition(scalep(l_2_3, y - 72))
    layer.content:addChild(title, 1)
    local num1 = lbl.createFont3(28, l_2_1, ccc3(255, 214, 103), true)
    num1:setAnchorPoint(ccp(1, 0.5))
    num1:setPosition(scalep(l_2_3 + 10, y - 99))
    layer.content:addChild(num1, 1)
    local text = string.format("(%+d)", l_2_2)
    local num2 = lbl.createFont2(20, text, ccc3(255, 214, 103), true)
    num2:setAnchorPoint(ccp(0, 0.5))
    num2:setPosition(scalep(l_2_3 + 15, y - 99))
    layer.content:addChild(num2, 1)
   end
  addScoreInfo(l_4_1.ref.atk, l_4_1.ascore, l_4_1.adelta, 315)
  addScoreInfo(l_4_1.ref.def, l_4_1.dscore, l_4_1.ddelta, 645)
end

return ui

