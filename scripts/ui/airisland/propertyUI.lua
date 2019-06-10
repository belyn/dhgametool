-- Command line was: E:\github\dhgametool\scripts\ui\airisland\propertyUI.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local particle = require("res.particle")
local i18n = require("res.i18n")
local net = require("net.netClient")
local player = require("data.player")
local bagdata = require("data.bag")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local tipsitem = require("ui.tips.item")
local tipsequip = require("ui.tips.equip")
local reward = require("ui.reward")
local herosdata = require("data.heros")
local airData = require("data.airisland")
local airConf = require("config.homeworld")
local IMG_BUILD_ID = {1 = "airisland_maintower_", 2 = "airisland_gold_", 3 = "airisland_diamond_", 4 = "airisland_magic_", 5 = "airisland_bumper_", 6 = "airisland_energy_", 7 = "airisland_gale_", 8 = "airisland_tyrant_", 9 = "airisland_moon_"}
ui.create = function(l_1_0)
  ui.items = {}
  ui.buildID = l_1_0
  ui.resultType = math.floor(ui.buildID / 1000)
  local layer = CCLayer:create()
  layer:setTouchEnabled(true)
  local board = img.createUI9Sprite(img.ui.tips_bg)
  board:setPreferredSize(CCSizeMake(352, 280))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  board_w = board:getContentSize().width
  board_h = board:getContentSize().height
  local show = airConf[l_1_0].show
  local level = airConf[l_1_0].lv
  local icon = img.createUISprite(img.ui[IMG_BUILD_ID[ui.resultType] .. show])
  icon:setAnchorPoint(0.5, 0)
  icon:setPosition(board_w / 2, 140)
  icon:setScale(0.8)
  board:addChild(icon)
  local resultName = i18n.global.airisland_buildName_" .. ui.resultTyp.string
  local nameLabel = lbl.createFont1(18, resultName, ccc3(255, 228, 156))
  nameLabel:setPosition(board_w / 2, 127)
  board:addChild(nameLabel)
  local line = img.createUI9Sprite(img.ui.hero_tips_fgline)
  line:setPreferredSize(CCSizeMake(292, 1))
  line:setPosition(board_w / 2, 108)
  board:addChild(line)
  local closeImg = img.createUISprite(img.ui.close)
  closeBtn = SpineMenuItem:create(json.ui.button, closeImg)
  closeBtn:setPosition(CCPoint(board_w - 25, board_h - 28))
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  board:addChild(closeMenu, 11)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParent()
   end)
  closeBtn:setVisible(false)
  local btnImg = CCSprite:create()
  btnImg:setContentSize(board:getContentSize())
  local hideBtn = SpineMenuItem:create(json.ui.button, btnImg)
  hideBtn:setPosition(ccp(board:getContentSize().width / 2, board:getContentSize().height / 2))
  local btnMenu = CCMenu:createWithItem(hideBtn)
  btnMenu:setPosition(0, 0)
  board:addChild(btnMenu, 1000)
  layer:registerScriptTouchHandler(function(l_2_0, l_2_1, l_2_2)
    if l_2_0 == "began" then
      layer:removeFromParent()
      return true
    end
   end)
  ui.board = board
  ui.line = line
  ui.nameLabel = nameLabel
  ui.icon = icon
  ui.addItems()
  return layer
end

ui.createItem = function(l_2_0)
  local introStr = {goldOut = "airisland_gold", gemOut = "airisland_gem", magicOut = "airisland_magic", staminaOut = "airisland_stamina", capacity = "airisland_capacity", outAdd = "airisland_outadd", hpAdd = "airisland_hp", spdAdd = "airisland_spd", atkAdd = "airisland_atk", pit = "airisland_pit", plat = "airisland_plat", land = "airisland_island", xMax = "airisland_aplimit"}
  local node = CCNode:create()
  node:setAnchorPoint(0.5, 0.5)
  node:setContentSize(CCSizeMake(ui.board:getContentSize().width, 28))
  local node_w = node:getContentSize().width
  local node_h = node:getContentSize().height
  local introLabel = lbl.createFont1(16, i18n.global[introStr[l_2_0]].string .. ":", lbl.whiteColor)
  introLabel:setAnchorPoint(0, 0.5)
  introLabel:setPosition(30, node_h / 2)
  node:addChild(introLabel)
  local numLabel = lbl.createFont2(16, "0", lbl.whiteColor)
  numLabel:setAnchorPoint(1, 0.5)
  numLabel:setPosition(322, node_h / 2)
  node:addChild(numLabel)
  if l_2_0 == "goldOut" or l_2_0 == "gemOut" or l_2_0 == "magicOut" then
    numLabel:setString("+" .. num2KM(airConf[ui.buildID].give) .. "/" .. i18n.global.airisland_day.string)
  elseif l_2_0 == "staminaOut" then
    numLabel:setString("+1" .. "/" .. math.floor(airConf[ui.buildID].time / 60) .. "m")
  elseif l_2_0 == "capacity" then
    numLabel:setString(num2KM(airConf[ui.buildID].max))
  elseif l_2_0 == "outAdd" then
    numLabel:setString("+" .. airConf[ui.buildID].add .. "%")
  elseif l_2_0 == "hpAdd" or l_2_0 == "spdAdd" or l_2_0 == "atkAdd" then
    if l_2_0 == "spdAdd" then
      numLabel:setString("+" .. airConf[ui.buildID].effect[1].num)
    else
      numLabel:setString("+" .. airConf[ui.buildID].effect[1].num * 100 .. "%")
    end
  elseif l_2_0 == "pit" then
    numLabel:setString(airConf[ui.buildID].pit)
  elseif l_2_0 == "plat" then
    numLabel:setString(airConf[ui.buildID].plat)
  elseif l_2_0 == "land" then
    numLabel:setString(airConf[ui.buildID].land)
  elseif l_2_0 == "xMax" then
    numLabel:setString(airConf[ui.buildID].xMax)
  end
  node.introLabel = introLabel
  node.numLabel = numLabel
  node.intro_w = introLabel:boundingBox():getMaxX() - introLabel:boundingBox():getMinX()
  node.intro_H = introLabel:getContentSize().height
  node.num_w = numLabel:boundingBox():getMaxX() - numLabel:boundingBox():getMinX()
  node.num_h = numLabel:getContentSize().height
  node.node_w = node_w
  return node
end

ui.addItems = function()
  local centerX = ui.board:getContentSize().width / 2
  local centerY = 60
  local item_w = ui.board:getContentSize().width / 2
  local intervalY = 32
   -- DECOMPILER ERROR: Unhandled construct in list

   -- DECOMPILER ERROR: Unhandled construct in table

  local propertyList = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Unhandled construct in table

   -- DECOMPILER ERROR: Unhandled construct in table

   -- DECOMPILER ERROR: Unhandled construct in table

   -- DECOMPILER ERROR: Unhandled construct in table

   -- DECOMPILER ERROR: Unhandled construct in table

   -- DECOMPILER ERROR: Unhandled construct in table

   -- DECOMPILER ERROR: unhandled table 

  for i,v in {"pit", "plat", "land", "xMax"} do
    propertyList = {}
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    local item = "outAdd".createItem("staminaOut")
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    ui.board:addChild("atkAdd")
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    table.insert(ui.items, item)
  end
  local startY = {"pit", "plat", "land", "xMax"}
  local intervalY = 28
   -- DECOMPILER ERROR: unhandled table 

  local intervalY1 = 18
   -- DECOMPILER ERROR: unhandled table 

  local intervalY2 = 10
   -- DECOMPILER ERROR: unhandled table 

  local intervalY3 = 130
   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

  for i = #ui.items, 1, -1 do
     -- DECOMPILER ERROR: unhandled table 

    ui.items[i]:setPositionX(centerX)
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    ui.items[i]:setPositionY(startY + intervalY * (#ui.items - i))
  end
   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

  ui.line:setPositionY(ui.items[1]:getPositionY() + startY - 4)
   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

  ui.nameLabel:setPositionY(ui.line:getPositionY() + intervalY1)
   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

  ui.icon:setPositionY(ui.nameLabel:getPositionY() + intervalY2)
   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

  ui.board:setPreferredSize(CCSizeMake(352, ui.icon:getPositionY() + intervalY3))
end

return ui

