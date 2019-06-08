-- Command line was: E:\github\dhgametool\scripts\ui\airisland\main.lua 

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
ui.create = function()
  local data = {}
  data.id = 1001
  data.vit = {vit = 10, buy = 0}
  data.holy = {{id = 5001, pos = 1}, {id = 6001, pos = 2}, {id = 7001, pos = 3}, {id = 8001, pos = 4}}
  data.mine = {{id = 2001, pos = 1}, {id = 3001, pos = 2}, {id = 4001, pos = 3}, {id = 4003, pos = 4}}
  airData.setData(data)
  local layer = CCLayer:create()
  img.load(img.packedOthers.ui_airisland_bg)
  img.load(img.packedOthers.ui_airisland)
  local bg = img.createUISprite(img.ui.airisland_bg)
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
  local airislandBtn = CCMenuItemFont:create("Feiting")
  airislandBtn:setScale(view.minScale)
  airislandBtn:setColor(ccc3(255, 0, 0))
  airislandBtn:setPosition(scalep(400, 490))
  local airislandMenu = CCMenu:createWithItem(airislandBtn)
  airislandMenu:setPosition(0, 0)
  layer:addChild(airislandMenu)
  airislandBtn:registerScriptTapHandler(function()
    replaceScene(require("ui.airisland.fightmain").create())
   end)
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = SpineMenuItem:create(json.ui.button, btnBackSprite)
  btnBack:setScale(view.minScale)
  btnBack:setPosition(scalep(35, 546))
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  layer:addChild(menuBack, 10)
  btnBack:registerScriptTapHandler(function()
    replaceScene(require("ui.town.main").create())
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    replaceScene(require("ui.town.main").create())
   end
  local onEnter = function()
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_6_0)
    if l_6_0 == "enter" then
      onEnter()
    elseif l_6_0 == "exit" then
      onExit()
    elseif l_6_0 == "cleanup" and isIOSLowerModel() then
      img.unload(img.packedOthers.ui_airisland_bg)
      img.unload(img.packedOthers.ui_airisland)
    end
   end)
  ui.mineral = {}
   -- DECOMPILER ERROR: Unhandled construct in list

   -- DECOMPILER ERROR: Unhandled construct in table

  local mineralPos = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Unhandled construct in table

   -- DECOMPILER ERROR: Unhandled construct in table

   -- DECOMPILER ERROR: Unhandled construct in table

  for i = {534, 154.5}, {485, 89.5}, {599, 105.5} do
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    local holeLayer = 639:create(ccc4(0, 0, 0, 0))
    do
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      holeLayer:setContentSize(CCSizeMake(200, 80))
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: Unhandled construct in table

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: Unhandled construct in table

       -- DECOMPILER ERROR: unhandled table 

      holeLayer:setPosition(scalep(mineralPos[i][1], mineralPos[i][2]))
      mineralPos, mineralPos = {}, {}
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      holeLayer:setScale(view.minScale * 0.515)
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      holeLayer:setTouchEnabled(true)
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      holeLayer:setTouchSwallowEnabled(false)
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      holeLayer:ignoreAnchorPointForPosition(false)
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      layer:addChild(holeLayer, 7 - i)
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      table.insert(ui.mineral, holeLayer)
       -- DECOMPILER ERROR: unhandled table 

      local onTouch = function(l_7_0, l_7_1, l_7_2)
        local isOut = nil
        local box = holeLayer:getBoundingBox()
        local point = layer:convertToNodeSpace(CCPoint(l_7_1, l_7_2))
        if l_7_0 == "began" then
          if box:containsPoint(point) then
            setShader(holeLayer, SHADER_HIGHLIGHT, true)
            return true
          end
          return false
        elseif l_7_0 == "moved" and not box:containsPoint(point) then
          clearShader(holeLayer, true)
          isOut = true
          do return end
          if l_7_0 == "ended" then
            clearShader(holeLayer, true)
            if box:containsPoint(point) and not isOut then
              print("end")
            end
          end
        end
         end
      do
         -- DECOMPILER ERROR: unhandled table 

         -- DECOMPILER ERROR: unhandled table 

        holeLayer:registerScriptTouchHandler(onTouch)
        local holeImg = img.createUISprite(img.ui.airisland_bottom2)
        local holeFlag = img.createUISprite(img.ui.airisland_flag)
        holeFlag:setScale(1.9417475728155)
        holeFlag:setPosition(ccp(100.97087378641, 75.728155339806))
        holeImg:setPosition(ccp(100, 40))
        holeImg:addChild(holeFlag)
         -- DECOMPILER ERROR: unhandled table 

        holeLayer:addChild(holeImg)
        local build = nil
        for _,v in ipairs(airData.data.mine) do
           -- DECOMPILER ERROR: unhandled table 

          if v.pos == i then
            build = ui.createBuild(1, clone(v))
            build:setAnchorPoint(ccp(0.5, 0))
            build:setPosition(89, 0)
             -- DECOMPILER ERROR: unhandled table 

            holeLayer:addChild(build)
        else
          end
        end
        holeLayer.hole = holeImg
        holeLayer.build = build or nil
        if build ~= nil then
          holeImg:setVisible(false)
        end
      end
    end
    ui.relic = {}
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Unhandled construct in table

    local relicPos = {}
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in table

     -- DECOMPILER ERROR: Unhandled construct in table

     -- DECOMPILER ERROR: Unhandled construct in table

    for i = {384, 254}, {280, 273}, {498, 226} do
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      local holeLayer = 548:create(162(133, 0, 0, 0))
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      holeLayer:setContentSize(CCSizeMake(200, 80))
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: Unhandled construct in table

       -- DECOMPILER ERROR: Unhandled construct in table

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      holeLayer:setPosition(scalep(relicPos[i][1], relicPos[i][2]))
      relicPos, relicPos, i = {}, {}, {548, 365}
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      holeLayer:setScale(view.minScale * 0.515)
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      holeLayer:setTouchEnabled(true)
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      holeLayer:setTouchSwallowEnabled(false)
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      holeLayer:ignoreAnchorPointForPosition(false)
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      layer:addChild(holeLayer)
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      table.insert(ui.relic, holeLayer)
       -- DECOMPILER ERROR: unhandled table 

      local onTouch = function(l_8_0, l_8_1, l_8_2)
        local isOut = nil
        local box = holeLayer:getBoundingBox()
        local point = layer:convertToNodeSpace(CCPoint(l_8_1, l_8_2))
        if l_8_0 == "began" then
          if box:containsPoint(point) then
            setShader(holeLayer, SHADER_HIGHLIGHT, true)
            return true
          end
          return false
        elseif l_8_0 == "moved" and not box:containsPoint(point) then
          clearShader(holeLayer, true)
          isOut = true
          do return end
          if l_8_0 == "ended" then
            clearShader(holeLayer, true)
            if box:containsPoint(point) and not isOut then
              print("end")
            end
          end
        end
         end
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      holeLayer:registerScriptTouchHandler(onTouch)
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      local holeImg = img.createUISprite(img.ui.airisland_bottom1)
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      local holeFlag = img.createUISprite(img.ui.airisland_flag)
       -- DECOMPILER ERROR: unhandled table 

      holeFlag:setScale(1.9417475728155)
       -- DECOMPILER ERROR: unhandled table 

      holeFlag:setPosition(ccp(95.145631067961, 83.495145631068))
       -- DECOMPILER ERROR: unhandled table 

      holeImg:setPosition(ccp(100, 40))
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      holeImg:addChild(holeFlag)
       -- DECOMPILER ERROR: unhandled table 

       -- DECOMPILER ERROR: unhandled table 

      holeLayer:addChild(holeImg)
      local build = nil
      for _,v in ipairs(airData.data.holy) do
        if v.pos == i then
          build = ui.createBuild(2, clone(v))
          build:setAnchorPoint(ccp(0.5, 0))
          build:setPosition(89, 0)
           -- DECOMPILER ERROR: unhandled table 

          holeLayer:addChild(build)
      else
        end
      end
       -- DECOMPILER ERROR: unhandled table 

      holeLayer.hole = holeImg
      holeLayer.build = build or nil
       -- DECOMPILER ERROR: unhandled table 

      if build ~= nil then
        holeImg:setVisible(false)
      end
    end
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    local towerLayer = {384, 254}:create(ccc4(0, 0, 0, 0))
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    towerLayer:setContentSize(CCSizeMake(195, 163))
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    towerLayer:setPosition(scalep(524, 479))
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    towerLayer:setScale(view.minScale)
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    towerLayer:setTouchEnabled(true)
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    towerLayer:setTouchSwallowEnabled(false)
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    towerLayer:ignoreAnchorPointForPosition(false)
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    layer:addChild(towerLayer)
     -- DECOMPILER ERROR: unhandled table 

    local onTouch = function(l_9_0, l_9_1, l_9_2)
      local isOut = nil
      local box = towerLayer:getBoundingBox()
      local point = layer:convertToNodeSpace(CCPoint(l_9_1, l_9_2))
      if l_9_0 == "began" then
        if box:containsPoint(point) then
          setShader(towerLayer, SHADER_HIGHLIGHT, true)
          return true
        end
        return false
      elseif l_9_0 == "moved" and not box:containsPoint(point) then
        clearShader(towerLayer, true)
        isOut = true
        do return end
        if l_9_0 == "ended" then
          clearShader(towerLayer, true)
          if box:containsPoint(point) and not isOut then
            print("end")
            ui.createMainTowerTip()
          end
        end
      end
      end
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    towerLayer:registerScriptTouchHandler(onTouch)
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    local towerConf = airConf[airData.data.id]
     -- DECOMPILER ERROR: unhandled table 

    local towerShow = towerConf.show
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    local towerImg = img.createUISprite(img.ui.airisland_maintower_" .. towerSho)
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    towerImg:setPosition(97.5, 81.5)
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    towerLayer:addChild(towerImg)
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    local pit = towerConf.pit
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    local plat = towerConf.plat
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    for i,v in ipairs(ui.mineral) do
       -- DECOMPILER ERROR: unhandled table 

      if pit < i then
        v:setVisible(false)
      end
    end
     -- DECOMPILER ERROR: unhandled table 

     -- DECOMPILER ERROR: unhandled table 

    for i,v in ipairs(ui.relic) do
       -- DECOMPILER ERROR: unhandled table 

      if plat < i then
        v:setVisible(false)
      end
    end
    local data = {}
    data = airConf[5001]
    data.id = 5001
    do
      local box = ui.createBuildBox(2, data, false)
      box:setScale(view.minScale)
      box:setPosition(view.midX, view.midY)
      layer:addChild(box, 100)
      ui.mainLayer = layer
      return layer
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.createBuild = function(l_2_0, l_2_1)
  local buildImg = nil
  print("\232\191\153\228\184\170id" .. l_2_1.id)
  print("type" .. l_2_0)
  local buildShow = airConf[l_2_1.id].show
  print("\232\191\153\228\184\170show" .. buildShow)
  if l_2_0 == 1 then
    if l_2_1.id > 2000 and l_2_1.id < 3000 then
      buildImg = img.createUISprite(img.ui.airisland_gold_" .. buildSho)
    elseif l_2_1.id > 3000 and l_2_1.id < 4000 then
      buildImg = img.createUISprite(img.ui.airisland_diamond_" .. buildSho)
    elseif l_2_1.id > 4000 and l_2_1.id < 5000 then
      buildImg = img.createUISprite(img.ui.airisland_magic_" .. buildSho)
    elseif l_2_1.id > 5000 and l_2_1.id < 6000 then
      buildImg = img.createUISprite(img.ui.airisland_bumper_" .. buildSho)
    elseif l_2_1.id > 6000 and l_2_1.id < 7000 then
      buildImg = img.createUISprite(img.ui.airisland_energy_" .. buildSho)
    elseif l_2_1.id > 7000 and l_2_1.id < 8000 then
      buildImg = img.createUISprite(img.ui.airisland_fast_" .. buildSho)
    elseif l_2_1.id > 8000 and l_2_1.id < 9000 then
      buildImg = img.createUISprite(img.ui.airisland_tyrant_" .. buildSho)
    elseif l_2_1.id > 9000 and l_2_1.id < 10000 then
      buildImg = img.createUISprite(img.ui.airisland_moon_" .. buildSho)
    end
  end
  buildImg.type = l_2_0
  buildImg.data = clone(l_2_1)
  return buildImg
end

ui.createBuildTip = function(l_3_0, l_3_1)
  local bg = img.createLogin9Sprite(img.login.dialog)
  bg:setPreferredSize(CCSizeMake(752, 488))
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
  local title = lbl.createFont1(24, i18n.global.chip_btn_buy.string, ccc3(230, 208, 174))
  title:setPosition(CCPoint(376, 459))
  bg:addChild(title, 2)
  local titleShadow = lbl.createFont1(24, i18n.global.chip_btn_buy.string, ccc3(89, 48, 27))
  titleShadow:setPosition(CCPoint(376, 457))
  bg:addChild(titleShadow)
  local closeImg = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeImg)
  closeBtn:setPosition(CCPoint(727, 460))
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  bg:addChild(closeMenu, 100)
  local upgradeImg = img.createUI9Sprite(img.ui.btn_2)
  upgradeImg:setPreferredSize(CCSizeMake(204, 54))
  local upgradeLabel = lbl.createFont1(24, i18n.global.chip_btn_buy.string, ccc3(89, 48, 27))
  upgradeLabel:setPosition(102, 27)
  upgradeImg:addChild(upgradeLabel)
  local upgradeBtn = SpineMenuItem:create(json.ui.button, upgradeImg)
  upgradeBtn:setPosition(376, 72)
  local upgradeMenu = CCMenu:createWithItem(upgradeBtn)
  upgradeMenu:setPosition(0, 0)
  bg:addChild(upgradeMenu)
  local innerBox = img.createUI9Sprite(img.ui.bottom_border_3)
  innerBox:setPreferredSize(CCSizeMake(656, 250))
  innerBox:setPosition(374, 280)
  bg:addChild(innerBox)
  local arrow = img.createUI9Sprite(img.ui.arrow)
  arrow:setPosition(330, 120)
  innerBox:addChild(arrow)
  local maxUI, leftBuild, rightBuild, expend1, expend2, curConf, nextConf, id = nil, nil, nil, nil, nil, nil, nil, nil
  local maxLv = 40
  local data = {}
  if l_3_0 == 0 then
    maxLv = 20
    data = clone(airConf[1000 + maxLv])
    data.id = 1000 + maxLv
    maxUI = ui.createBuildBox(l_3_0, data)
    maxUI:setPosition(324, 260)
    bg:addChild(maxUI)
    if airData.data.id < 1000 + maxLv then
      curConf = airConf[airData.data.id]
      nextConf = airConf[airData.data.id + 1]
      leftBuild = ui.createBuildBox(l_3_0, curConf, true)
      rightBuild = ui.createBuildBox(l_3_0, nextConf)
      leftBuild:setPosition(170, 133)
      rightBuild:setPosition(490, 133)
      bg:addChild(leftBuild)
      bg:addChild(rightBuild)
    elseif l_3_0 == 1 then
      for k,v in pairs(airData.mine) do
        if v.pos == l_3_1 then
          id = math.floor(id / 1000) * 1000
      else
        end
      end
      data = clone(airConf[id + maxLv])
      data.id = id + maxLv
      maxUI = ui.createBuildBox(l_3_0, data)
      maxUI:setPosition(324, 260)
      bg:addChild(maxUI)
    elseif l_3_0 == 2 then
      for k,v in pairs(airData.holy) do
        if v.pos == l_3_1 then
          id = math.floor(id / 1000) * 1000
      else
        end
      end
      data = clone(airConf[id + maxLv])
      data.id = id + maxLv
      maxUI = ui.createBuildBox(l_3_0, data)
      maxUI:setPosition(324, 260)
      bg:addChild(maxUI)
    end
  end
  closeBtn:registerScriptTapHandler(function()
    print("\229\133\179\233\151\173")
    audio.play(audio.button)
    layer:removeFromParent()
   end)
end

ui.createExpendBar = function(l_4_0, l_4_1)
  local bar = img.createUI9Sprite(img.ui.hero_evolve_cost_bg)
  bar:setPreferredSize(CCSizeMake(200, 32))
  local label = lbl.createFont1(24, l_4_1, ccc3(230, 208, 174))
  label:setPosition(106, 15)
  bar:addChild(label)
  local icon = img.createItemIcon(l_4_0)
  icon:setPosition(2, 15)
  bar:addChild(icon)
  return bar
end

ui.createBuildBox = function(l_5_0, l_5_1, l_5_2)
  print("---------")
  tablePrint(l_5_1)
  local bg = nil
  if l_5_2 then
    bg = img.createUI9Sprite(img.ui.botton_fram_3)
  else
    bg = img.createUI9Sprite(img.ui.botton_fram_2)
  end
  bg:setPreferredSize(CCSizeMake(280, 210))
  local line = img.createUI9Sprite(img.ui.split_line)
  line:setPreferredSize(CCSizeMake(234, 1))
  line:setPosition(140, 90)
  bg:addChild(line)
  local label = {}
  for i = 1, 4 do
    local text = lbl.createFont1(24, "--", ccc3(89, 48, 27))
    text:setAnchorPoint(ccp(0, 0.5))
    text:setPosition(20, 25 + (i - 1) * 20)
    bg:addChild(text)
    table.insert(label, text)
  end
  do
    local buildImg = nil
    if l_5_0 == 0 then
      local numStr = {l_5_1.pit, l_5_1.plat, l_5_1.land, l_5_1.xMax}
      buildImg = img.createUISprite(img.ui.airisland_maintower_" .. l_5_1.sho)
      buildImg:setScale(0.65)
      buildImg:setPosition(160, 150)
      bg:addChild(buildImg)
      for i,v in ipairs(label) do
        v:setString("----" .. numStr[i])
      end
    elseif l_5_0 == 1 then
      local numStr = {l_5_1.max, l_5_1.give.num}
      if l_5_1.id > 2000 and l_5_1.id < 3000 then
        buildImg = img.createUISprite(img.ui.airisland_gold_" .. l_5_1.sho)
      elseif l_5_1.id > 3000 and l_5_1.id < 4000 then
        buildImg = img.createUISprite(img.ui.airisland_diamond_" .. l_5_1.sho)
      elseif l_5_1.id > 4000 and l_5_1.id < 5000 then
        buildImg = img.createUISprite(img.ui.airisland_magic_" .. l_5_1.sho)
      end
      bg:setPreferredSize(CCSizeMake(280, 180))
      buildImg:setPosition(140, 145)
      buildImg:setScale(0.72)
      bg:addChild(buildImg)
      line:setPositionY(66)
      lvBg:setPositionY(86)
      for i,v in ipairs(label) do
        if i > 2 then
          v:setVisible(false)
          for i,v in (for generator) do
          end
          v:setString("------" .. numStr[i])
        end
      elseif l_5_0 == 2 then
        if l_5_1.id > 5000 and l_5_1.id < 6000 then
          buildImg = img.createUISprite(img.ui.airisland_bumper_" .. l_5_1.sho)
        elseif l_5_1.id > 6000 and l_5_1.id < 7000 then
          buildImg = img.createUISprite(img.ui.airisland_energy_" .. l_5_1.sho)
        elseif l_5_1.id > 7000 and l_5_1.id < 8000 then
          buildImg = img.createUISprite(img.ui.airisland_fast_" .. l_5_1.sho)
        elseif l_5_1.id > 8000 and l_5_1.id < 9000 then
          buildImg = img.createUISprite(img.ui.airisland_tyrant_" .. l_5_1.sho)
        elseif l_5_1.id > 9000 and l_5_1.id < 10000 then
          buildImg = img.createUISprite(img.ui.airisland_moon_" .. l_5_1.sho)
        end
        bg:setPreferredSize(CCSizeMake(280, 180))
        buildImg:setPosition(140, 145)
        buildImg:setScale(0.72)
        bg:addChild(buildImg)
        line:setPositionY(66)
        for i,v in ipairs(label) do
          if i > 1 then
            v:setVisible(false)
            for i,v in (for generator) do
            end
            if not l_5_1.add and not l_5_1.effect[1].num then
              local num = l_5_1.give.num
            end
            v:setString("------" .. num)
          end
        end
        return bg
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return ui

