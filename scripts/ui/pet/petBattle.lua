-- Command line was: E:\github\dhgametool\scripts\ui\pet\petBattle.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local net = require("net.netClient")
local petdata = require("config.pet")
local DHComponents = require("dhcomponents.DroidhangComponents")
local petNetData = require("data.pet")
local userdata = require("data.userdata")
ui.create = function(l_1_0, l_1_1)
  ui.data = {}
  ui.widget = {}
  ui.widget.Card = {}
  local petKey = {}
  local petNum = 0
  for k,v in pairs(petdata) do
    petNum = petNum + 1
    table.insert(petKey, k)
  end
  table.sort(petKey)
  for i = 1, petNum do
    local myId = petKey[i]
    local name = string.gsub(petdata[myId].petBody, "pet_", "")
    name = string.gsub(name, "_", "")
    if petNetData.getData(myId) ~= nil or not 1 then
      local fixName = petNetData.getData(myId).advanced
    end
    print("spine_ui_" .. name .. fixName)
    img.load(img.packedOthers.spine_ui_" .. name .. fixNam)
  end
  ui.widget.layer = CCLayer:create()
  ui.widget.layer:setPosition(CCPoint(0, 0))
  l_1_0:addChild(ui.widget.layer, 999)
  local darkBg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  ui.widget.layer:addChild(darkBg)
  darkBg:setTouchEnabled(true)
  darkBg:registerScriptTouchHandler(function(l_1_0, l_1_1, l_1_2)
    return false
   end)
  ui.widget.bg = img.createLogin9Sprite(img.login.dialog)
  ui.widget.bg:setPreferredSize(CCSize(900, 500))
  ui.widget.bg:setAnchorPoint(CCPoint(0.5, 0.5))
  ui.widget.bg:setPosition(CCPoint(view.midX, view.midY))
  ui.widget.layer:addChild(ui.widget.bg)
  ui.widget.bg:setScale(0.7 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.12, 1.1 * view.minScale, 1.1 * view.minScale))
  anim_arr:addObject(CCScaleTo:create(0.09, 1 * view.minScale, 1 * view.minScale))
  ui.widget.bg:runAction(CCSequence:create(anim_arr))
  local title = lbl.createFont1(24, i18n.global.pet_battle_title.string, ccc3(230, 208, 174))
  ui.widget.bg:addChild(title, 2)
  local titleShade = lbl.createFont1(24, i18n.global.pet_battle_title.string, ccc3(89, 48, 27))
  ui.widget.bg:addChild(titleShade, 1)
  local doc = lbl.createFont1(18, i18n.global.pet_battle_doc.string, ccc3(96, 44, 15))
  ui.widget.bg:addChild(doc)
  ui.widget.backBtn = SpineMenuItem:create(json.ui.button, img.createUISprite(img.ui.close))
  local menuPet = CCMenu:createWithItem(ui.widget.backBtn)
  menuPet:setPosition(0, 0)
  ui.widget.bg:addChild(menuPet)
  local board = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  board:setPreferredSize(CCSizeMake(844, 360))
  ui.widget.bg:addChild(board)
  ui.widget.battle_Spine = json.create(json.ui.pet_play_json)
  ui.widget.battle_Spine:setVisible(false)
  ui.widget.Scroll = CCScrollView:create()
  ui.widget.Scroll:setAnchorPoint(CCPoint(0.5, 0.5))
  ui.widget.Scroll:setPosition(CCPoint(10, 0))
  ui.widget.Scroll:setDirection(kCCScrollViewDirectionHorizontal)
  ui.widget.Scroll:setViewSize(CCSize(822, 500))
  ui.widget.Scroll:setContentSize(CCSize(175 * (petNum), 500))
  ui.widget.Scroll:setTouchEnabled(true)
  ui.widget.Scroll:setCascadeOpacityEnabled(true)
  ui.widget.Scroll:getContainer():setCascadeOpacityEnabled(true)
  ui.widget.Scroll:addChild(ui.widget.battle_Spine, 50)
  board:addChild(ui.widget.Scroll)
  ui.widget.Card = {}
  for i = 1, petNum do
    ui.createCard(petKey[i], ui.widget.Scroll)
  end
  ui.refreshCard()
  ui.widget.backBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if ui.widget.layer ~= nil then
      petCallBack()
      ui.widget.layer:removeFromParent()
      ui.data = {}
      ui.widget = {}
      for i = 1, petNum do
        local myId = petKey[i]
        local name = string.gsub(petdata[myId].petBody, "pet_", "")
        name = string.gsub(name, "_", "")
        if petNetData.getData(myId) ~= nil or not 1 then
          local fixName = petNetData.getData(myId).advanced
        end
        img.unload(img.packedOthers.spine_ui_" .. name .. fixNam)
      end
    end
   end)
  local onUpdate = function()
    ui.checkCard()
   end
  ui.widget.bg:scheduleUpdateWithPriorityLua(onUpdate)
  DHComponents:mandateNode(ui.widget.backBtn, "yw_petBattle_backBtn")
  DHComponents:mandateNode(board, "yw_petBattle_board")
  DHComponents:mandateNode(title, "yw_petBattle_title")
  DHComponents:mandateNode(titleShade, "yw_petBattle_titleShade")
  DHComponents:mandateNode(doc, "yw_petBattle_doc")
  return ui.widget
end

ui.initData = function(l_2_0)
  if l_2_0[7] == nil then
    petNetData.sele = -1
  else
    petNetData.sele = l_2_0[7]
  end
end

ui.findNum = function(l_3_0)
  for k,v in pairs(petNetData) do
    if v.isSele ~= nil and l_3_0 == v.isSele then
      return k
    end
  end
  return nil
end

ui.getNowSele = function()
  if petNetData.sele ~= -1 then
    return petNetData.sele
  end
  return nil
end

ui.addPetData = function(l_5_0)
  for k,v in pairs(l_5_0) do
    if v.pos == 7 then
      l_5_0[k] = nil
    end
  end
  if petNetData.sele == nil or petNetData.sele <= 0 then
    return l_5_0
  end
  print("petNetData.sele = " .. petNetData.sele)
  if petdata[petNetData.sele] == nil then
    return l_5_0
  end
  local petTable = {}
  petTable.id = tonumber(petNetData.sele)
  petTable.pos = 7
  table.insert(l_5_0, petTable)
  return l_5_0
end

ui.createCard = function(l_6_0, l_6_1)
  if petdata[l_6_0] == nil then
    showToast(string.format("pet error id"))
    return 
  end
  ui.widget.Card[l_6_0] = {}
  ui.widget.Card[l_6_0].cardLayer = CCLayer:create()
  ui.widget.Card[l_6_0].cardLayer:setPosition(CCPoint(0, 0))
  l_6_1:addChild(ui.widget.Card[l_6_0].cardLayer)
  local path = img.ui.pet_card
  if petNetData.getData(l_6_0) ~= nil and (petNetData.getData(l_6_0).advanced == 2 or petNetData.getData(l_6_0).advanced == 3) then
    path = img.ui.pet_card2
  else
    if petNetData.getData(l_6_0) ~= nil and petNetData.getData(l_6_0).advanced == 4 then
      path = img.ui.pet_card3
    end
  end
  local cardBg = img.createUISprite(path)
  cardBg:setPosition(CCPoint(0, 0))
  cardBg:setScale(0.5)
  ui.widget.Card[l_6_0].cardBg = cardBg
  ui.widget.Card[l_6_0].cardLayer:addChild(cardBg)
  local battleSp = img.createLogin9Sprite(img.login.button_9_small_gold)
  battleSp:setPreferredSize(CCSize(150, 50))
  ui.widget.Card[l_6_0].battleSp = battleSp
  local battleLab = lbl.createFont1(18, i18n.global.pet_battle_out.string, ccc3(118, 37, 5))
  battleLab:setPosition(battleSp:getContentSize().width / 2, battleSp:getContentSize().height / 2 + 2)
  battleSp:addChild(battleLab)
  ui.widget.Card[l_6_0].battleLab = battleLab
  ui.widget.Card[l_6_0].battleItem = SpineMenuItem:create(json.ui.button, battleSp)
  local battleMenu = CCMenu:createWithItem(ui.widget.Card[l_6_0].battleItem)
  battleMenu:setPosition(CCPoint(0, 0))
  ui.widget.Card[l_6_0].cardLayer:addChild(battleMenu)
  ui.widget.Card[l_6_0].battleMenu = battleMenu
  local battleCancelSp = img.createLogin9Sprite(img.login.button_9_small_orange)
  battleCancelSp:setPreferredSize(CCSize(150, 50))
  ui.widget.Card[l_6_0].battleCancelSp = battleCancelSp
  local battleCancelLab = lbl.createFont1(18, i18n.global.pet_battle_cancel.string, ccc3(118, 37, 5))
  battleCancelLab:setPosition(battleCancelSp:getContentSize().width / 2, battleCancelSp:getContentSize().height / 2 + 2)
  battleCancelSp:addChild(battleCancelLab)
  ui.widget.Card[l_6_0].battleCancelLab = battleCancelLab
  ui.widget.Card[l_6_0].battleCancelItem = SpineMenuItem:create(json.ui.button, battleCancelSp)
  local battleCancelMenu = CCMenu:createWithItem(ui.widget.Card[l_6_0].battleCancelItem)
  battleCancelMenu:setPosition(CCPoint(0, 0))
  ui.widget.Card[l_6_0].cardLayer:addChild(battleCancelMenu)
  ui.widget.Card[l_6_0].battleCancelMenu = battleCancelMenu
  local imgStar = 1
  if petNetData.getData(l_6_0) then
    imgStar = petNetData.getData(l_6_0).star + 1
  end
  local cardMain = img.createUISprite(img.ui[petdata[l_6_0].petBody .. imgStar])
  ui.widget.Card[l_6_0].cardMain = cardMain
  cardMain:setPosition(CCPoint(cardMain:getContentSize().width / 2, cardMain:getContentSize().height / 2))
  cardBg:addChild(cardMain, -1)
  local name = string.gsub(petdata[l_6_0].petBody, "pet_", "spine_")
  if petNetData.getData(l_6_0) ~= nil or not 1 then
    local fixName = petNetData.getData(l_6_0).advanced
  end
  local petSpine = ui.createJsonCard(json.ui[name .. fixName], l_6_0)
  cardMain:addChild(petSpine)
  DHComponents:mandateNode(ui.widget.Card[l_6_0].cardLayer, "yw_petBattle_cardBg" .. l_6_0)
  DHComponents:mandateNode(ui.widget.Card[l_6_0].battleItem, "yw_petBattle_battleItem")
  DHComponents:mandateNode(ui.widget.Card[l_6_0].battleCancelItem, "yw_petBattle_battleItem")
  ui.widget.Card[l_6_0].battleItem:registerScriptTapHandler(function()
    audio.play(audio.button)
    ui.battleItemTouch(id)
   end)
  ui.widget.Card[l_6_0].battleCancelItem:registerScriptTapHandler(function()
    audio.play(audio.button)
    ui.widget.battle_Spine:setVisible(false)
    ui.battleItemTouch(id)
   end)
end

ui.createJsonCard = function(l_7_0)
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
  local rightAnimBg = json.create(l_7_0)
  rightAnimBg:setPosition(stencilSize.width / 2, 0)
  rightAnimBg:playAnimation("stand", -1)
  Scroll:addChild(rightAnimBg)
  return Scroll
end

ui.checkCard = function()
  if ui.widget.Scroll == nil then
    return 
  end
  local posX = ui.widget.Scroll:getContentOffset().x
  local view_w = ui.widget.Scroll:getViewSize().width
  do
    local nowOff = 70
    for k,v in pairs(ui.widget.Card) do
      if v.cardLayer:getPositionX() + nowOff + posX < 0 then
        v.cardLayer:setVisible(false)
        for k,v in (for generator) do
        end
        if v.cardLayer:getPositionX() - view_w - nowOff + posX > 0 then
          v.cardLayer:setVisible(false)
          for k,v in (for generator) do
          end
          v.cardLayer:setVisible(true)
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.battleItemTouch = function(l_9_0)
  if petNetData.getData(l_9_0) == nil then
    showToast(string.format(i18n.global.pet_need_act.string))
    return 
  end
  if petNetData.sele == l_9_0 then
    petNetData.sele = -1
  else
    petNetData.sele = l_9_0
  end
  ui.refreshCard()
end

ui.refreshCard = function()
  if ui.widget.Card == nil then
    return 
  end
  for id,val in pairs(ui.widget.Card) do
    if petNetData.getData(id) == nil then
      ui.widget.Card[id].battleCancelItem:setVisible(false)
      setShader(ui.widget.Card[id].battleMenu, SHADER_GRAY, true)
      setShader(ui.widget.Card[id].cardBg, SHADER_GRAY, true)
      setShader(ui.widget.Card[id].cardMain, SHADER_GRAY, true)
      for id,val in (for generator) do
      end
      if id ~= petNetData.sele then
        ui.widget.Card[id].battleItem:setVisible(true)
        ui.widget.Card[id].battleMenu:setTouchEnabled(true)
        ui.widget.Card[id].battleCancelItem:setVisible(false)
        ui.widget.Card[id].battleCancelItem:setTouchEnabled(false)
        clearShader(ui.widget.Card[id].cardBg, true)
        clearShader(ui.widget.Card[id].cardMain, true)
        if ui.widget.Card[id].color ~= nil then
          ui.widget.Card[id].color:removeFromParent()
          ui.widget.Card[id].color = nil
          for id,val in (for generator) do
          end
          ui.widget.Card[id].battleCancelItem:setVisible(true)
          ui.widget.Card[id].battleCancelMenu:setTouchEnabled(true)
          ui.widget.Card[id].battleItem:setVisible(false)
          ui.widget.Card[id].battleItem:setTouchEnabled(false)
          ui.widget.battle_Spine:setVisible(true)
          ui.widget.battle_Spine:setPosition(ui.widget.Card[id].cardLayer:getPosition())
          ui.widget.battle_Spine:playAnimation("battle")
          if ui.widget.Card[id].color == nil then
            ui.widget.Card[id].color = CCLayerColor:create(ccc4(0, 0, 0, 120))
            ui.widget.Card[id].color:setContentSize(CCSize(ui.widget.Card[id].cardMain:getContentSize().width - 20, ui.widget.Card[id].cardMain:getContentSize().height - 36))
            ui.widget.Card[id].cardMain:addChild(ui.widget.Card[id].color)
            ui.widget.Card[id].color:setPosition(CCPoint(9, 11))
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return ui

