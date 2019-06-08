-- Command line was: E:\github\dhgametool\scripts\ui\solo\monsListUI.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local netClient = require("net.netClient")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
ui.create = function(l_1_0)
  ui.widget = {}
  ui.data = {}
  ui.data.monsList = l_1_0
  ui.widget.monsIcons = {}
  ui.widget.layer = CCLayer:create()
  ui.widget.layer:setTouchEnabled(true)
  ui.widget.bg = img.createUI9Sprite(img.ui.tips_bg)
  ui.widget.bg:setPreferredSize(CCSizeMake(460, 204))
  ui.widget.bg:setScale(view.minScale)
  ui.widget.bg:setPosition(ccp(view.midX, view.midY))
  ui.widget.layer:addChild(ui.widget.bg)
  ui.widget.line = img.createUI9Sprite(img.ui.hero_tips_fgline)
  ui.widget.line:setPreferredSize(CCSize(400, 1))
  ui.widget.line:setPosition(ui.widget.bg:getContentSize().width / 2, ui.widget.bg:getContentSize().height - 58)
  ui.widget.bg:addChild(ui.widget.line)
  ui.widget.title = lbl.createFont1(18, i18n.global.solo_preview.string, ccc3(255, 228, 156))
  ui.widget.title:setPosition(ccp(ui.widget.bg:getContentSize().width / 2, 170))
  ui.widget.bg:addChild(ui.widget.title)
  local btnImg = CCSprite:create()
  btnImg:setContentSize(ui.widget.bg:getContentSize())
  ui.widget.hideBtn = SpineMenuItem:create(json.ui.button, btnImg)
  ui.widget.hideBtn:setPosition(ccp(ui.widget.bg:getContentSize().width / 2, ui.widget.bg:getContentSize().height / 2))
  local btnMenu = CCMenu:createWithItem(ui.widget.hideBtn)
  btnMenu:setPosition(0, 0)
  ui.widget.bg:addChild(btnMenu, 1000)
  ui.addMonsIcon()
  ui.widget.layer:registerScriptTouchHandler(function(l_1_0, l_1_1, l_1_2)
    if l_1_0 == "began" then
      if ui.widget.layer then
        ui.widget.layer:removeFromParent()
        ui.widget.layer = nil
      end
      return true
    end
   end)
  ui.widget.layer.onAndroidBack = function()
    audio.play(audio.button)
    if ui.widget.layer then
      ui.widget.layer:removeFromParent()
      ui.widget.layer = nil
    end
   end
  addBackEvent(ui.widget.layer)
  ui.widget.layer:registerScriptHandler(function(l_3_0)
    if l_3_0 == "enter" then
      ui.widget.layer.notifyParentLock()
    elseif l_3_0 == "exit" then
      ui.widget.layer.notifyParentUnlock()
    end
   end)
  return ui.widget.layer
end

ui.createMonsIcon = function(l_2_0)
  local icon = img.createUISprite(img.ui.herolist_head_bg)
  icon:setCascadeOpacityEnabled(true)
  print("\232\175\165\230\128\170\231\137\169\229\164\180\229\131\143ID" .. l_2_0.id)
  local headIcon = img.createHeroHeadIcon(l_2_0.id)
  headIcon:setPosition(CCPoint(icon:getContentSize().width / 2, icon:getContentSize().height / 2))
  icon:addChild(headIcon)
  local groupBg = img.createUISprite(img.ui.herolist_group_bg)
  groupBg:setScale(0.42)
  groupBg:setPosition(CCPoint(18, icon:getContentSize().height - 18))
  icon:addChild(groupBg)
  local groupIcon = img.createUISprite(img.ui.herolist_group_" .. l_2_0.grou)
  groupIcon:setPosition(groupBg:getPosition())
  groupIcon:setScale(0.42)
  icon:addChild(groupIcon)
  local showLv = lbl.createFont2(13.8, l_2_0.lv)
  showLv:setPosition(CCPoint(67, icon:getContentSize().height - 18))
  icon:addChild(showLv)
  local startX = 10
  local offsetX = 10
  local isRed = false
  local totalStarNum = 1
  if l_2_0.qlt <= 5 then
    totalStarNum = l_2_0.qlt
  elseif l_2_0.qlt == 6 then
    isRed = true
    if l_2_0.wake then
      totalStarNum = l_2_0.wake + 1
    end
  end
  for i = totalStarNum, 1, -1 do
    local star = nil
    if isRed then
      star = img.createUISprite(img.ui.hero_star_orange)
      star:setScale(0.75)
    else
      star = img.createUISprite(img.ui.star_s)
    end
    star:setPositionX((i - (totalStarNum + 1) / 2) * 12 * 0.8 + icon:getContentSize().width / 2)
    star:setPositionY(12)
    icon:addChild(star)
  end
  local box = img.createUISprite(img.ui.fight_hp_bg.small)
  box:setCascadeOpacityEnabled(true)
  box:setPosition(icon:getContentSize().width / 2, -4)
  icon:addChild(box)
  local bar = img.createUISprite(img.ui.fight_hp_fg.small)
  bar:setAnchorPoint(ccp(0, 0.5))
  bar:setPositionX(box:getContentSize().width / 2 - bar:getContentSize().width / 2)
  bar:setPositionY(box:getContentSize().height / 2)
  box:addChild(bar)
  bar:setScaleX(l_2_0.hp / 100)
  if l_2_0.hp <= 0 then
    setShader(icon, SHADER_GRAY, true)
  end
  return icon
end

ui.addMonsIcon = function()
  local totalNum =  ui.data.monsList
  local midX = ui.widget.bg:getContentSize().width / 2
  print("\228\184\173\233\151\180\229\128\188\228\184\186\239\188\154" .. midX .. "\230\128\187\230\149\176\233\135\143\228\184\186\239\188\154" .. totalNum)
  local offsetX = 102
  local posY = 84
  for i,v in ipairs(ui.data.monsList) do
    if i > 4 then
      return 
    end
    ui.widget.monsIcons[i] = ui.createMonsIcon(v)
    ui.widget.monsIcons[i]:setPositionX(midX + offsetX * (i - (totalNum + 1) / 2))
    ui.widget.monsIcons[i]:setPositionY(posY)
    ui.widget.bg:addChild(ui.widget.monsIcons[i])
  end
end

return ui

