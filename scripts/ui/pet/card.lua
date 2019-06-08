-- Command line was: E:\github\dhgametool\scripts\ui\pet\card.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local lbl = require("res.lbl")
local i18n = require("res.i18n")
local pet = require("ui.pet.main")
local petConf = require("config.pet")
local netClient = require("net.netClient")
local player = require("data.player")
local bag = require("data.bag")
local petNetData = require("data.pet")
ui.create = function(l_1_0, l_1_1, l_1_2)
  local obj = {}
  obj.data = {}
  obj.widget = {}
  obj.data.id = l_1_1
  obj.data.info = l_1_2
  obj.widget.node = CCNode:create()
  obj.widget.node:setContentSize(CCSize(243.2, 364))
  obj.widget.node:setCascadeOpacityEnabled(true)
  local name = string.gsub(petConf[l_1_1].petBody, "pet_", "spine_")
  if l_1_2 ~= nil then
    obj.widget.petPic = img.createUISprite(img.ui[petConf[l_1_1].petBody .. l_1_2.star + 1])
    obj.widget.pet_spine = ui.createJsonCard(json.ui[name .. petNetData.getData(l_1_1).advanced], l_1_1)
    obj.widget.petPic:addChild(obj.widget.pet_spine)
  else
    print("----------" .. img.ui[petConf[l_1_1].petBody .. "1"] .. "-------")
    obj.widget.petPic = img.createUISprite(img.ui[petConf[l_1_1].petBody .. "1"])
    obj.widget.pet_spine = ui.createJsonCard(json.ui[name .. 1], l_1_1)
    obj.widget.petPic:addChild(obj.widget.pet_spine)
  end
  obj.widget.petPic:setScaleX(0.8)
  obj.widget.petPic:setScaleY(0.8)
  obj.widget.petPic:setCascadeOpacityEnabled(true)
  obj.widget.node:addChild(obj.widget.petPic, 10)
  local searchBtn = SpineMenuItem:create(json.ui.button, img.createUISprite(img.ui.pet_search))
  searchBtn:setScale(0.9)
  searchBtn:setAnchorPoint(ccp(1, 1))
  searchBtn:setPosition(CCPoint(obj.widget.node:getContentSize().width / 2 - 20, obj.widget.node:getContentSize().height / 2 - 20))
  local searchMenu = CCMenu:createWithItem(searchBtn)
  searchMenu:setPosition(0, 0)
  obj.widget.node:addChild(searchMenu, 11)
  searchBtn:registerScriptTapHandler(function()
    local petDetails = require("ui.pet.petDetails").create(id)
    local parentLayer = obj.widget.node:getParent():getParent():getParent():getParent():getParent():getParent():getParent()
    parentLayer:addChild(petDetails, 9999)
   end)
  local path = img.ui.pet_card
  if l_1_2 and (petNetData.getData(l_1_1).advanced == 2 or petNetData.getData(l_1_1).advanced == 3) then
    path = img.ui.pet_card2
  elseif l_1_2 and petNetData.getData(l_1_1).advanced == 4 then
    path = img.ui.pet_card3
  end
  obj.widget.qualityBox = img.createUISprite(path)
  obj.widget.qualityBox:setScaleX(0.8)
  obj.widget.qualityBox:setScaleY(0.8)
  obj.widget.qualityBox:setPosition(obj.widget.petPic:getPosition())
  obj.widget.node:addChild(obj.widget.qualityBox, 20)
  if l_1_2 == nil then
    setShader(obj.widget.petPic, SHADER_GRAY, true)
    obj.data.info = ui.setConfig(l_1_1)
    obj.widget.actBtn = ui.createActBtn(obj, l_1_1, obj.data.info, l_1_0)
    obj.widget.node:addChild(obj.widget.actBtn)
  else
    obj.widget.detBtn = ui.createDetBtn(obj, l_1_1, obj.data.info)
    obj.widget.node:addChild(obj.widget.detBtn)
  end
  return obj
end

ui.createJsonCard = function(l_2_0, l_2_1)
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

ui.createActBtn = function(l_3_0, l_3_1, l_3_2, l_3_3)
  local itemId = petConf[l_3_1].activaty[1]
  local itemNum = petConf[l_3_1].activaty[2]
  local itemActivaty = petConf[l_3_1].activaty
  tablePrint(itemActivaty)
  local activateImg = img.createUI9Sprite(img.ui.btn_7)
  activateImg:setPreferredSize(CCSizeMake(190, 65))
  local activateBtn = SpineMenuItem:create(json.ui.button, activateImg)
  local activateMenu = CCMenu:createWithItem(activateBtn)
  activateMenu:setPosition(0, 0)
  local netFun = function(l_1_0, l_1_1)
    local params = {sid = player.sid, id = petId, opcode = 1}
    addWaitNet()
    netClient:pet_op(params, function(l_1_0)
      if l_1_0.status == 0 then
        pet.subItem({{type = itemId, count = itemNum}})
        ui.playActiveJson(obj)
        obj.widget.detBtn = ui.createDetBtn(obj, petId, l_1_0)
        obj.widget.node:addChild(obj.widget.detBtn)
        clearShader(obj.widget.petPic, true)
        activateBtn:removeFromParent()
        obj.widget.actBtn = nil
      end
      petNetData.coutRsult(1, l_1_0.status)
      delWaitNet()
      end)
   end
  activateBtn:registerScriptTapHandler(function()
    if itemNum <= bag.items.find(itemId).num then
      petNetData.addData(petId)
      netFun(itemId, itemNum)
    else
      showToast(string.format(i18n.global.pet_smaterial_not_enough.string))
    end
   end)
  local goldIcon = img.createItemIcon2(itemId)
  goldIcon:setPosition(37, 32)
  activateImg:addChild(goldIcon)
  local activeLabel = lbl.createFont2(16, itemNum)
  activeLabel:setPosition(37, 20)
  activateImg:addChild(activeLabel)
  local strLabel = lbl.createFont1(18, i18n.global.pet_activate.string, ccc3(23, 83, 10))
  strLabel:setPosition(110, 33)
  activateImg:addChild(strLabel)
  local DHComponents = require("dhcomponents.DroidhangComponents")
  DHComponents:mandateNode(activateBtn, "DAui_aiLhPV")
  activateMenu.itemId = itemId
  activateMenu.itemNum = itemNum
  return activateMenu
end

ui.createDetBtn = function(l_4_0, l_4_1, l_4_2)
  local detailsImg = img.createUI9Sprite(img.ui.btn_1)
  detailsImg:setPreferredSize(CCSizeMake(190, 65))
  local detailsBtn = SpineMenuItem:create(json.ui.button, detailsImg)
  local detailsMenu = CCMenu:createWithItem(detailsBtn)
  detailsMenu:setPosition(0, 0)
  detailsBtn:registerScriptTapHandler(function()
    require("ui.pet.main").gotoPetInfo(petNetData.getData(id))
   end)
  if l_4_2.advanced == 4 then
    local lightJson = json.create(json.ui.pet_json)
    lightJson:setPositionX(l_4_0.widget.petPic:getPositionX())
    lightJson:setPositionY(l_4_0.widget.petPic:getPositionY())
    lightJson:setScaleY(0.98)
    lightJson:playAnimation(petConf[l_4_1].petEff, -1)
    l_4_0.widget.node:addChild(lightJson, 10)
  end
  local strLabel = lbl.createFont1(18, i18n.global.pet_details.string, ccc3(114, 59, 15))
  strLabel:setPosition(95, 33)
  detailsImg:addChild(strLabel)
  local DHComponents = require("dhcomponents.DroidhangComponents")
  DHComponents:mandateNode(detailsBtn, "DAui_aiLhPV")
  return detailsMenu
end

ui.setConfig = function(l_5_0)
  local data = {}
  data.id = l_5_0
  data.lv = 1
  data.advanced = 1
  return data
end

ui.playActiveJson = function(l_6_0)
  local activeJson = json.create(json.ui.pet_json)
  activeJson:setPositionX(l_6_0.widget.petPic:getPositionX())
  activeJson:setPositionY(l_6_0.widget.petPic:getPositionY())
  activeJson:playAnimation("unlock")
  l_6_0.widget.node:addChild(activeJson, 9999)
end

return ui

