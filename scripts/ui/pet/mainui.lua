-- Command line was: E:\github\dhgametool\scripts\ui\pet\mainui.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local lbl = require("res.lbl")
local audio = require("res.audio")
local i18n = require("res.i18n")
local net = require("net.netClient")
local petdata = require("config.pet")
local scrollUI = require("ui.pet.scrollUI")
local cardClass = require("ui.pet.card")
local petNetData = require("data.pet")
ui.create = function(l_1_0)
  ui.data = {}
  ui.widget = {}
  ui.data.leftOrder = 1
  ui.data.totalCards = 0
  ui.data.touchX = -100
  ui.data.isMove = false
  ui.widget.scrollView = scrollUI.create()
  ui.widget.scrollView:setPosition(CCPoint(-400, -270))
  l_1_0:addChildFollowSlot("code_card_position", ui.widget.scrollView)
  ui.widget.touchLayer = CCLayer:create()
  ui.widget.touchLayer:setContentSize(800, 400)
  ui.widget.touchLayer:setPosition(CCPoint(0, 80))
  ui.widget.touchLayer:setTouchEnabled(true)
  ui.widget.scrollView:addChild(ui.widget.touchLayer, -1)
  local petKey = {}
  local petNum = 0
  for k,v in pairs(petdata) do
    petNum = petNum + 1
    table.insert(petKey, k)
  end
  table.sort(petKey)
  ui.data.totalCards = petNum
  for i = 1, ui.data.totalCards do
    local haveCard = false
    for k,v in pairs(petNetData.data) do
      if v.id == petKey[i] then
        local card = cardClass.create(l_1_0, petKey[i], v)
        scrollUI.addCard(card, 20 - i)
        haveCard = true
    else
      end
    end
    if not haveCard then
      local card = cardClass.create(l_1_0, petKey[i])
      scrollUI.addCard(card, 20 - i)
    end
  end
  ui.widget.leftArrow = img.createUISprite(img.ui.hero_raw)
  ui.widget.leftArrow:setScaleX(-1)
  ui.widget.leftArrowBtn = SpineMenuItem:create(json.ui.button, ui.widget.leftArrow)
  local leftMenu = CCMenu:createWithItem(ui.widget.leftArrowBtn)
  leftMenu:setPosition(0, 0)
  l_1_0:addChildFollowSlot("code_arrow_position2", leftMenu)
  setShader(ui.widget.leftArrowBtn, SHADER_GRAY, true)
  ui.widget.rightArrow = img.createUISprite(img.ui.hero_raw)
  ui.widget.rightArrow:setScaleX(-1)
  ui.widget.rightArrowBtn = SpineMenuItem:create(json.ui.button, ui.widget.rightArrow)
  local rightMenu = CCMenu:createWithItem(ui.widget.rightArrowBtn)
  rightMenu:setPosition(0, 0)
  l_1_0:addChildFollowSlot("code_arrow_position", rightMenu)
  local DHComponents = require("dhcomponents.DroidhangComponents")
  ui.CallFun()
  local onUpdate = function()
    scrollUI.checkCard()
   end
  ui.widget.touchLayer:scheduleUpdateWithPriorityLua(onUpdate)
  return ui.widget
end

ui.forceMove = function()
  if ui.dirNum == nil then
    return 
  else
    if ui.dirNum == 2 then
      scrollUI.moveDir(-2, ui.widget.leftArrowBtn, 0.01)
      ui.dirNum = 0
      ui.changeArrowState(2)
    else
      if ui.dirNum == 4 then
        scrollUI.moveDir(-4, ui.widget.leftArrowBtn, 0.01)
        ui.dirNum = 0
        ui.changeArrowState(4)
      else
        if ui.dirNum == 6 then
          scrollUI.moveDir(-6, ui.widget.leftArrowBtn, 0.01)
          ui.dirNum = 0
          ui.changeArrowState(6)
        end
      end
    end
  end
end

ui.clear = function(l_3_0)
  l_3_0:removeChildFollowSlot("code_card_position")
  l_3_0:removeChildFollowSlot("code_arrow_position")
  l_3_0:removeChildFollowSlot("code_arrow_position2")
  ui.data = nil
  ui.widget = nil
end

ui.CallFun = function()
  ui.widget.leftArrowBtn:registerScriptTapHandler(function()
    if ui.data.leftOrder <= 1 then
      return 
    end
    if ui.data.isMove == true then
      return 
    end
    ui.data.isMove = true
    ui.widget.scrollView:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(function()
      ui.data.isMove = false
      end)))
    audio.play(audio.button)
    scrollUI.moveDir(2, ui.widget.leftArrowBtn)
    ui.changeArrowState(-2)
   end)
  ui.widget.rightArrowBtn:registerScriptTapHandler(function()
    if ui.data.totalCards - 2 <= ui.data.leftOrder then
      return 
    end
    if ui.data.isMove == true then
      return 
    end
    ui.data.isMove = true
    ui.widget.scrollView:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(function()
      ui.data.isMove = false
      end)))
    audio.play(audio.button)
    scrollUI.moveDir(-2, ui.widget.rightArrowBtn)
    ui.changeArrowState(2)
   end)
  ui.widget.touchLayer:registerScriptTouchHandler(function(l_3_0, l_3_1, l_3_2)
    if l_3_0 == "began" then
      if not ui.widget.touchLayer:getBoundingBox():containsPoint(CCPoint(l_3_1, l_3_2)) then
        return false
      end
      ui.data.touchX = l_3_1
      return true
    elseif l_3_0 == "ended" then
      local difX = l_3_1 - ui.data.touchX
      if difX > 5 and ui.data.leftOrder > 1 then
        scrollUI.moveDir(2, ui.widget.leftArrowBtn)
        ui.changeArrowState(-2)
        scrollUI.checkCard()
      elseif difX < -5 and ui.data.leftOrder < ui.data.totalCards - 2 then
        scrollUI.moveDir(-2, ui.widget.rightArrowBtn)
        ui.changeArrowState(2)
      end
    end
   end)
end

ui.changeArrowState = function(l_5_0)
  ui.widget.leftArrowBtn:setVisible(true)
  ui.widget.rightArrowBtn:setVisible(true)
  clearShader(ui.widget.leftArrowBtn, true)
  clearShader(ui.widget.rightArrowBtn, true)
  ui.data.leftOrder = ui.data.leftOrder + l_5_0
  ui.dirNum = (ui.dirNum or 0) + l_5_0
  if ui.data.leftOrder <= 1 then
    setShader(ui.widget.leftArrowBtn, SHADER_GRAY, true)
  else
    if ui.data.totalCards - 2 <= ui.data.leftOrder then
      setShader(ui.widget.rightArrowBtn, SHADER_GRAY, true)
    end
  end
end

return ui

