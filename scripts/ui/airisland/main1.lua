-- Command line was: E:\github\dhgametool\scripts\ui\airisland\main1.lua 

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
local IMG_BUILD_ID = {1 = json.ui.kongzhan_chengbao, 2 = json.ui.kongzhan_jinkuang, 3 = json.ui.kongzhan_shuijing, 4 = json.ui.kongzhan_mofachen, 5 = json.ui.kongzhan_fengshou, 6 = json.ui.kongzhan_huoli, 7 = json.ui.kongzhan_jifeng, 8 = json.ui.kongzhan_baojun, 9 = json.ui.kongzhan_xueyue}
ui.create = function(l_1_0)
  local data = {}
  data = airData.data
  ui.mines = {}
  ui.holys = {}
  ui.mainTower = nil
  ui.mineralPosX = {528, 457, 587, 639, 775, 706}
  ui.mineralPosY = {159.5, 92.5, 108.5, 252.5, 259.5, 304.5}
  ui.holyPosX = {374, 280, 468, 548, 374, 164, 137, 342}
  ui.holyPosY = {255, 274, 236, 359, 384, 364, 454, 474}
  local layer = CCLayer:create()
  img.load(img.packedOthers.ui_airisland_bg)
  img.load(img.packedOthers.ui_airisland)
  img.load(img.packedOthers.spine_ui_kongzhan_1)
  local bg = img.createUISprite(img.ui.airisland_bg)
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
  ui.bg = bg
  local animBg = json.create(json.ui.kongzhan_zhudao)
  animBg:setPosition(bg:getContentSize().width / 2, bg:getContentSize().height / 2)
  animBg:playAnimation("animation", -1)
  bg:addChild(animBg)
  local buildingObjs = {}
  local aniFeiting = json.create(json.ui.kongzhan_feiting)
  aniFeiting:playAnimation("animation", -1)
  buildingObjs[1] = aniFeiting
  animBg:addChildFollowSlot("code_feiting", aniFeiting)
  local feitingLabel = lbl.createFont2(18, i18n.global.airisland_fight.string, ccc3(251, 230, 126))
  local size = feitingLabel:boundingBox().size
  local feitingLabelBg = img.createUI9Sprite(img.ui.main_building_lbl)
  feitingLabelBg:setPreferredSize(CCSizeMake(size.width + 76, 40))
  feitingLabel:setPosition(feitingLabelBg:getContentSize().width / 2, feitingLabelBg:getContentSize().height / 2)
  feitingLabelBg:addChild(feitingLabel)
  aniFeiting:addChildFollowSlot("code_bd", feitingLabelBg)
  local onBack = function()
    replaceScene(require("ui.town.main").create())
    img.unload(img.packedOthers.ui_airisland_bg)
    img.unload(img.packedOthers.ui_airisland)
    json.unloadAll(IMG_BUILD_ID)
    if isIOSLowerModel() then
      json.unload(json.ui.kongzhan_zhudao)
      json.unload(json.ui.kongzhan_feiting)
      json.unload(json.ui.kongzhan_dizuo)
      json.unload(json.ui.kongzhan_zhudao_chaichu)
      json.unload(json.ui.kongzhan_zhudao_jianzao)
      json.unload(json.ui.kongzhan_zhudao_shengji)
      json.unload(json.ui.kongzhan_tish)
      img.unload(img.packedOthers.spine_ui_kongzhan_1)
    end
   end
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = SpineMenuItem:create(json.ui.button, btnBackSprite)
  btnBack:setScale(view.minScale)
  btnBack:setPosition(scalep(35, 546))
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  layer:addChild(menuBack, 10)
  btnBack:registerScriptTapHandler(function()
    audio.play(audio.button)
    onBack()
   end)
  local helpImg = img.createUISprite(img.ui.btn_help)
  local helpBtn = SpineMenuItem:create(json.ui.button, helpImg)
  helpBtn:setScale(view.minScale)
  helpBtn:setPosition(scalep(926, 546))
  local helpMenu = CCMenu:createWithItem(helpBtn)
  helpMenu:setPosition(ccp(0, 0))
  layer:addChild(helpMenu, 10)
  helpBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local helpUI = require("ui.help").create(i18n.global.airisland_help.string)
    layer:addChild(helpUI, 99999)
   end)
  autoLayoutShift(btnBack)
  autoLayoutShift(helpBtn)
  local itembar = require("ui.airisland.itembar")
  layer:addChild(itembar.create(), 1000)
  local buildLayer = nil
  if not airData.data.mine then
    airData.data.mine = {}
  end
  if not airData.data.holy then
    airData.data.holy = {}
  end
  ui.addMainTower()
  ui.addMines()
  ui.addHolys()
  addBackEvent(layer)
  layer.onAndroidBack = function()
    onBack()
   end
  local onEnter = function()
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  local last_selected_sprite = 0
  local beginX = 0
  local beginY = 0
  local isClick = false
  local onTouchBegan = function(l_7_0, l_7_1)
    local po = bg:convertToNodeSpace(CCPoint(l_7_0, l_7_1))
    upvalue_512 = po.x
    upvalue_1024 = po.y
    upvalue_1536 = true
    for ii = 1,  buildingObjs do
      local tObj = buildingObjs[ii]
      if tObj:getAabbBoundingBox():containsPoint(CCPoint(l_7_0, l_7_1)) then
        setShader(tObj, SHADER_HIGHLIGHT, true)
        upvalue_2560 = tObj
    else
      end
    end
    return true
   end
  local onTouchMoved = function(l_8_0, l_8_1)
    local po = bg:convertToNodeSpace(CCPoint(l_8_0, l_8_1))
    if isClick and (math.abs(po.x - beginX) > 15 or math.abs(po.y - beginY) > 15) then
      upvalue_512 = false
      if last_selected_sprite ~= 0 then
        clearShader(last_selected_sprite, true)
        upvalue_2048 = 0
      end
    end
   end
  local onTouchEnded = function(l_9_0, l_9_1)
    if not isClick then
      return 
    end
    for ii = 1,  buildingObjs do
      local tObj = buildingObjs[ii]
      if tObj:getAabbBoundingBox():containsPoint(CCPoint(l_9_0, l_9_1)) then
        local params = {sid = player.sid, pos = 0}
        addWaitNet()
        net:island_land(params, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          airData.setLandData(l_1_0)
          replaceScene(require("ui.airisland.fightmain").create())
            end)
        upvalue_2560 = 0
        clearShader(tObj, true)
    else
      end
    end
   end
  local onTouch = function(l_10_0, l_10_1, l_10_2)
    if l_10_0 == "began" then
      return onTouchBegan(l_10_1, l_10_2)
    elseif l_10_0 == "moved" then
      return onTouchMoved(l_10_1, l_10_2)
    else
      return onTouchEnded(l_10_1, l_10_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  layer:registerScriptHandler(function(l_11_0)
    if l_11_0 == "enter" then
      onEnter()
    elseif l_11_0 == "exit" then
      onExit()
    elseif l_11_0 == "cleanup" then
       -- Warning: missing end command somewhere! Added here
    end
   end)
  ui.layer = layer
  return layer
end

ui.createBuild = function(l_2_0, l_2_1, l_2_2)
  local pos = l_2_2
  local resultType = math.floor((l_2_1 or 1000) / 1000)
  local touch_w = l_2_0 == 0 and 160 or 100
  local touch_h = l_2_0 == 0 and 130 or 50
  local mainNode = CCNode:create()
  mainNode:setAnchorPoint(0.5, 0.5)
  mainNode:setContentSize(CCSizeMake(touch_w, touch_h))
  local colorLayer = CCLayerColor:create(ccc4(0, 0, 0, 0))
  colorLayer:setPosition(0, 0)
  colorLayer:setContentSize(CCSizeMake(touch_w, touch_h))
  mainNode:addChild(colorLayer)
  local sp = CCSprite:create()
  sp:setAnchorPoint(0.5, 0.5)
  sp:setContentSize(CCSizeMake(touch_w, touch_h))
  local sp_w = sp:getContentSize().width
  local sp_h = sp:getContentSize().height
  json.load(IMG_BUILD_ID[resultType])
  local bottomImg = json.create(json.ui.kongzhan_dizuo)
  bottomImg:setPosition(sp_w / 2, sp_h / 2)
  sp:addChild(bottomImg)
  if l_2_0 == 0 then
    bottomImg:playAnimation("animation_1", -1)
    bottomImg:setVisible(false)
  else
    bottomImg:playAnimation("animation_" .. l_2_0, -1)
  end
  local removeSpine = json.create(json.ui.kongzhan_zhudao_chaichu)
  removeSpine:setPosition(sp_w / 2, sp_h / 2)
  sp:addChild(removeSpine, 10)
  local buildSpine = json.create(json.ui.kongzhan_zhudao_jianzao)
  buildSpine:setPosition(sp_w / 2, sp_h / 2)
  sp:addChild(buildSpine, 10)
  local upgradeSpine = json.create(json.ui.kongzhan_zhudao_shengji)
  upgradeSpine:setPosition(sp_w / 2, sp_h / 2)
  sp:addChild(upgradeSpine, 10)
  local menuItem = HHMenuItem:createWithScale(sp, 1)
  menuItem:setAnchorPoint(0.5, 0.5)
  menuItem:setPosition(sp:getContentSize().width / 2, sp:getContentSize().height / 2)
  if l_2_0 == 0 then
    menuItem:setPositionY(menuItem:getPositionY() - 20)
  end
  local menu = CCMenu:createWithItem(menuItem)
  menu:setPosition(0, 0)
  mainNode:addChild(menu)
  menuItem:registerScriptTapHandler(function()
    audio.play(audio.button)
    if buildType == 0 then
      local upgradeUI = require("ui.airisland.upgradeUI").create(airData.data.id, 0, nil, ui, nil)
      ui.layer:addChild(upgradeUI, 99999)
      return 
    end
    local isSeed = nil
    if buildType == 2 then
      for i,v in ipairs(airData.data.holy) do
        if v.pos == mainNode.pos then
          isSeed = true
      else
        end
      end
    elseif buildType == 1 then
      for i,v in ipairs(airData.data.mine) do
        if v.pos == mainNode.pos then
          isSeed = true
      else
        end
      end
    end
    if not isSeed then
      local buildUI = require("ui.airisland.buildUI").create(mainNode.buildType, pos, ui)
      ui.layer:addChild(buildUI, 99999)
      return 
    end
    if airConf[mainNode.buildID].give or airConf[mainNode.buildID].time then
      local params = {sid = player.sid}
      addWaitNet()
      net:island_sync(params, function(l_1_0)
        delWaitNet()
        print("------result-------")
        tablePrint(l_1_0)
        airData.setData(l_1_0)
        if not airData.data.holy then
          airData.data.holy = {}
        end
        if not airData.data.mine then
          airData.data.mine = {}
        end
        local outPut = nil
        if buildType ~= 1 or not airData.data.mine then
          local list = airData.data.holy
        end
        for i,v in ipairs(list) do
          if not v.val then
            outPut = v.pos ~= mainNode.pos or 0
          end
          do return end
        end
        local upgradeUI = require("ui.airisland.upgradeUI").create(mainNode.buildID, mainNode.buildType, pos, ui, outPut)
        ui.layer:addChild(upgradeUI, 99999)
         end)
      return 
    end
    local upgradeUI = require("ui.airisland.upgradeUI").create(mainNode.buildID, mainNode.buildType, pos, ui, nil)
    ui.layer:addChild(upgradeUI, 99999)
   end)
  local result = DHSkeletonAnimation:createWithKey(IMG_BUILD_ID[resultType])
  result:scheduleUpdateLua()
  result:setAnchorPoint(CCPoint(0.5, 0.5))
  result:setPosition(CCPoint(sp_w / 2, sp_h / 2))
  sp:addChild(result)
  if l_2_1 then
    result:registerAnimation("animation_" .. airConf[l_2_1].show, -1)
  end
  if l_2_1 then
    result:setVisible(true)
    bottomImg:setVisible(false)
  else
    result:setVisible(false)
    bottomImg:setVisible(true)
  end
  do
    local tipBg = nil
    if (resultType >= 2 and resultType <= 4) or resultType == 6 then
      print("\232\191\155\230\157\165\232\191\153\233\135\140\228\186\134")
      tipBg = img.createUISprite(img.ui.airisland_tip)
      tipBg:setOpacity(0)
      local bg_w = tipBg:getContentSize().width
      do
        local bg_h = tipBg:getContentSize().height
        local own = nil
        local max = airConf[l_2_1].max
        for i,v in ipairs(airData.data.mine) do
          if not v.val then
            v.val = v.id ~= l_2_1 or v.pos ~= pos or 0
          end
          own = v.val
          do return end
        end
        for i,v in ipairs(airData.data.holy) do
          if not v.val then
            v.val = v.id ~= l_2_1 or v.pos ~= pos or 0
          end
          own = v.val
          do return end
        end
        local tipSpine = json.create(json.ui.kongzhan_tish)
        tipSpine:setPosition(bg_w / 2, bg_h / 2 - 28)
        tipBg:addChild(tipSpine)
        mainNode.tipSpine = tipSpine
        local outID = nil
        if resultType == 2 then
          outID = 1
        elseif resultType == 3 then
          outID = 2
        elseif resultType == 4 then
          outID = 15
        elseif resultType == 6 then
          outID = 4302
        end
        if resultType ~= 6 or not img.createItemIconForId(outID) then
          local outIcon1 = img.createItemIcon(outID)
        end
        if resultType ~= 6 or not img.createItemIconForId(outID) then
          local outIcon2 = img.createItemIcon(outID)
        end
        if resultType ~= 6 then
          outIcon1:setScale(0.4)
          outIcon2:setScale(0.4)
        end
        tipSpine:addChildFollowSlot("code_icon1", outIcon1)
        tipSpine:addChildFollowSlot("code_icon2", outIcon2)
        local outItem = HHMenuItem:createWithScale(tipBg, 1)
        outItem:setAnchorPoint(0.5, 0.5)
        outItem:setPosition(sp:getContentSize().width / 2, 75)
        local outMenu = CCMenu:createWithItem(outItem)
        outMenu:setPosition(0, 0)
        ui.bg:addChild(outMenu, 10)
        mainNode.outMenu = outMenu
        local buildType = l_2_0
        local buildID = l_2_1
        local buildPos = pos
        outItem:registerScriptTapHandler(function()
        local createType = buildType == 1 and 1 or 0
        local params = {sid = player.sid, type = createType, act = 2, id = mainNode.buildID, pos = mainNode.pos}
        addWaitNet()
        print("-------output info--------")
        print("type" .. createType .. "," .. "act:" .. 2 .. "," .. "id:" .. mainNode.buildID .. "," .. "pos:" .. mainNode.pos)
        net:island_op(params, function(l_1_0)
          print("--------get output--------")
          delWaitNet()
          tablePrint(l_1_0)
          if l_1_0.status == 0 then
            if l_1_0.vit then
              airData.changeVit(l_1_0.vit)
              if l_1_0.vit > 0 then
                local pbBag = {}
                pbBag.items = {}
                pbBag.items[1] = {}
                pbBag.items[1].id = 4302
                pbBag.items[1].num = l_1_0.vit
                CCDirector:sharedDirector():getRunningScene():addChild(reward.createFloating(pbBag), 99999)
                local max = airConf[mainNode.buildID].max
                if max <= l_1_0.vit then
                  mainNode.tipSpine:playAnimation("animation2", -1)
                else
                  showToast(i18n.global.airisland_no_putout.string)
                end
              else
                bagdata.items.add(l_1_0.item.items[1])
                if l_1_0.item.items[1].num > 0 then
                  local pbBag = {}
                  pbBag.items = {}
                  pbBag.items[1] = l_1_0.item.items[1]
                  CCDirector:sharedDirector():getRunningScene():addChild(reward.createFloating(pbBag), 99999)
                  local max = airConf[mainNode.buildID].max
                  if max <= l_1_0.item.items[1].num then
                    mainNode.tipSpine:playAnimation("animation2", -1)
                  end
                  local limit = airConf[params.id].max
                  if limit <= l_1_0.item.items[1].num then
                    airData.getOutPut()
                  else
                    showToast(i18n.global.airisland_no_putout.string)
                  end
                else
                  showToast(i18n.global.airisland_no_putout.string)
                end
              end
            end
          end
            end)
         end)
        if max <= own then
          tipSpine:playAnimation("animation", -1)
        else
          tipSpine:playAnimation("animation2", -1)
        end
      end
      mainNode.bottomImg = bottomImg
      mainNode.result = result
      mainNode.buildType = l_2_0
      mainNode.buildID = l_2_1
      mainNode.pos = pos
      mainNode.resultType = resultType
      mainNode.removeSpine = removeSpine
      mainNode.buildSpine = buildSpine
      mainNode.upgradeSpine = upgradeSpine
      mainNode.sp = sp
      return mainNode
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.addMainTower = function()
  ui.mainTower = ui.createBuild(0, airData.data.id)
  ui.mainTower:setPosition(500, 454)
  ui.bg:addChild(ui.mainTower)
end

ui.addMines = function()
  local touch_w = 100
  local touch_h = 50
  local pitMax = airConf[airData.data.id].pit
  for i,v in ipairs(airData.data.mine) do
    local mine = ui.createBuild(1, v.id, v.pos)
    ui.mines[v.pos] = mine
  end
  for i = 1, pitMax do
    if not ui.mines[i] then
      local mine = ui.createBuild(1, nil, i)
      ui.mines[i] = mine
    end
    ui.mines[i]:setPositionX(ui.mineralPosX[i])
    ui.mines[i]:setPositionY(ui.mineralPosY[i])
    ui.bg:addChild(ui.mines[i], 7 - i)
    if ui.mines[i].outMenu then
      ui.mines[i].outMenu:setPositionX(ui.mineralPosX[i] - touch_w / 2)
      ui.mines[i].outMenu:setPositionY(ui.mineralPosY[i] - 10)
    end
  end
end

ui.addHolys = function()
  local touch_w = 100
  local touch_h = 50
  local platMax = airConf[airData.data.id].plat
  for i,v in ipairs(airData.data.holy) do
    local holy = ui.createBuild(2, v.id, v.pos)
    ui.holys[v.pos] = holy
  end
  for i = 1, platMax do
    if not ui.holys[i] then
      local holy = ui.createBuild(2, nil, i)
      ui.holys[i] = holy
    end
    ui.holys[i]:setPositionX(ui.holyPosX[i])
    ui.holys[i]:setPositionY(ui.holyPosY[i])
    ui.bg:addChild(ui.holys[i], 8 - i)
    if ui.holys[i].outMenu then
      ui.holys[i].outMenu:setPositionX(ui.holyPosX[i] - touch_w / 2)
      ui.holys[i].outMenu:setPositionY(ui.holyPosY[i] - 10)
    end
  end
end

ui.buildItem = function(l_6_0, l_6_1, l_6_2)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if l_6_1 == 1 then
    do return end
  end
   -- DECOMPILER ERROR: Overwrote pending register.

  ui.mines[l_6_0].buildType = l_6_1
   -- DECOMPILER ERROR: Confused about usage of registers!

  ui.mines[l_6_0].buildID = l_6_2
   -- DECOMPILER ERROR: Confused about usage of registers!

  ui.mines[l_6_0].pos = l_6_0
   -- DECOMPILER ERROR: Confused about usage of registers!

  ui.mines[l_6_0].resultType = math.floor(l_6_2 / 1000)
   -- DECOMPILER ERROR: Confused about usage of registers!

  ui.mines[l_6_0].bottomImg:setVisible(false)
   -- DECOMPILER ERROR: Confused about usage of registers!

  print("----resultType-----" .. ui.mines[l_6_0].resultType)
  print("show:" .. airConf[l_6_2].show)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused at declaration of local variable

  json.create(IMG_BUILD_ID[ui.mines[l_6_0].resultType]):setAnchorPoint(CCPoint(0.5, 0.5))
  json.create(IMG_BUILD_ID[ui.mines[l_6_0].resultType]):setPosition(CCPoint(ui.mines[l_6_0].sp:getContentSize().width / 2, ui.mines[l_6_0].sp:getContentSize().height / 2))
   -- DECOMPILER ERROR: Confused about usage of registers!

  ui.mines[l_6_0].sp:addChild(json.create(IMG_BUILD_ID[ui.mines[l_6_0].resultType]))
  if l_6_2 then
    json.create(IMG_BUILD_ID[ui.mines[l_6_0].resultType]):unregisterAllAnimation()
    json.create(IMG_BUILD_ID[ui.mines[l_6_0].resultType]):registerAnimation("animation_" .. airConf[l_6_2].show, -1)
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

  ui.mines[l_6_0].result:removeFromParent()
   -- DECOMPILER ERROR: Confused about usage of registers!

  ui.mines[l_6_0].result = json.create(IMG_BUILD_ID[ui.mines[l_6_0].resultType])
   -- DECOMPILER ERROR: Confused about usage of registers!

  ui.mines[l_6_0].buildSpine:playAnimation("animation")
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  if (ui.mines[l_6_0].resultType >= 2 and ui.mines[l_6_0].resultType <= 4) or ui.mines[l_6_0].resultType == 6 then
    print("\232\191\155\230\157\165\232\191\153\233\135\140\228\186\134")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    if ui.mines[l_6_0].outMenu then
      ui.mines[l_6_0].outMenu:removeFromParent()
       -- DECOMPILER ERROR: Confused about usage of registers!

      ui.mines[l_6_0].outMenu = nil
    end
     -- DECOMPILER ERROR: Confused at declaration of local variable

    do
       -- DECOMPILER ERROR: Overwrote pending register.

      nil:setOpacity(0)
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused at declaration of local variable

      json.create(json.ui.kongzhan_tish):setPosition(nil:getContentSize().width / 2, nil:getContentSize().height / 2 - 28)
       -- DECOMPILER ERROR: Confused about usage of registers!

      nil:addChild(json.create(json.ui.kongzhan_tish))
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Overwrote pending register.

      if ui.mines[l_6_0].resultType == 2 then
        do return end
      end
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Overwrote pending register.

      if ui.mines[l_6_0].resultType == 3 then
        do return end
      end
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Overwrote pending register.

      if ui.mines[l_6_0].resultType == 4 then
        do return end
      end
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused about usage of registers!

      if ((((ui.mines[l_6_0].resultType == 6 and ui.mines[l_6_0].resultType ~= 6) or not img.createItemIconForId(nil) and ui.mines[l_6_0].resultType == 6 and not img.createItemIconForId(nil) and ui.mines[l_6_0].resultType ~= 6))) then
        img.createItemIcon(nil):setScale(0.4)
        img.createItemIcon(nil):setScale(0.4)
      end
      json.create(json.ui.kongzhan_tish):addChildFollowSlot("code_icon1", img.createItemIcon(nil))
      json.create(json.ui.kongzhan_tish):addChildFollowSlot("code_icon2", img.createItemIcon(nil))
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused at declaration of local variable

      HHMenuItem:createWithScale(nil, 1):setAnchorPoint(0.5, 0.5)
       -- DECOMPILER ERROR: Confused about usage of registers!

      HHMenuItem:createWithScale(nil, 1):setPosition(ui.mines[l_6_0].sp:getContentSize().width / 2, 75)
       -- DECOMPILER ERROR: Confused at declaration of local variable

      CCMenu:createWithItem(HHMenuItem:createWithScale(nil, 1)):setPosition(0, 0)
      ui.bg:addChild(CCMenu:createWithItem(HHMenuItem:createWithScale(nil, 1)), 10)
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused at declaration of local variable

      HHMenuItem:createWithScale(nil, 1):registerScriptTapHandler(function()
        local createType = buildType == 1 and 1 or 0
        local params = {sid = player.sid, type = createType, act = 2, id = item.buildID, pos = item.pos}
        addWaitNet()
        print("-------output info--------")
        print("type" .. createType .. "," .. "act:" .. 2 .. "," .. "id:" .. item.buildID .. "," .. "pos:" .. item.pos)
        net:island_op(params, function(l_1_0)
          print("--------get output--------")
          delWaitNet()
          tablePrint(l_1_0)
          if l_1_0.status == 0 then
            if l_1_0.vit then
              airData.changeVit(l_1_0.vit)
              if l_1_0.vit > 0 then
                local pbBag = {}
                pbBag.items = {}
                pbBag.items[1] = {}
                pbBag.items[1].id = 4302
                pbBag.items[1].num = l_1_0.vit
                CCDirector:sharedDirector():getRunningScene():addChild(reward.createFloating(pbBag), 99999)
                local max = airConf[item.buildID].max
                if max <= l_1_0.vit then
                  item.tipSpine:playAnimation("animation2", -1)
                else
                  showToast(i18n.global.airisland_no_putout.string)
                end
              else
                bagdata.items.add(l_1_0.item.items[1])
                if l_1_0.item.items[1].num > 0 then
                  local pbBag = {}
                  pbBag.items = {}
                  pbBag.items[1] = l_1_0.item.items[1]
                  CCDirector:sharedDirector():getRunningScene():addChild(reward.createFloating(pbBag), 99999)
                  local max = airConf[item.buildID].max
                  if max <= l_1_0.item.items[1].num then
                    item.tipSpine:playAnimation("animation2", -1)
                    airData.getOutPut()
                  else
                    showToast(i18n.global.airisland_no_putout.string)
                  end
                else
                  showToast(i18n.global.airisland_no_putout.string)
                end
              end
            end
          end
            end)
         end)
      if airConf[l_6_2].max <= 0 then
        json.create(json.ui.kongzhan_tish):playAnimation("animation", -1)
      else
        json.create(json.ui.kongzhan_tish):playAnimation("animation2", -1)
      end
      do
         -- DECOMPILER ERROR: Confused at declaration of local variable

         -- DECOMPILER ERROR: Confused about usage of registers!

        if l_6_1 == 1 then
          ui.mines[l_6_0].outMenu:setPositionX(ui.mineralPosX[l_6_0] - 100 / 2)
           -- DECOMPILER ERROR: Confused about usage of registers!

          ui.mines[l_6_0].outMenu:setPositionY(ui.mineralPosY[l_6_0] - 10)
         -- DECOMPILER ERROR: Confused about usage of registers!

         -- DECOMPILER ERROR: Confused about usage of registers!

        else
          ui.mines[l_6_0].outMenu:setPositionX(ui.holyPosX[l_6_0] - 100 / 2)
           -- DECOMPILER ERROR: Confused about usage of registers!

          ui.mines[l_6_0].outMenu:setPositionY(ui.holyPosY[l_6_0] - 10)
        end
         -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end
    end
  end
   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
table.insert(airData.data.holy, {})
 -- DECOMPILER ERROR: Confused about usage of registers for local variables.

 -- Warning: undefined locals caused missing assignments!
end

ui.removeItem = function(l_7_0, l_7_1)
  print("----removeItem------")
  print("pos:" .. l_7_0 .. "," .. "buildType" .. l_7_1)
  local item = nil
  if l_7_1 == 1 then
    item = ui.mines[l_7_0]
  else
    item = ui.holys[l_7_0]
  end
  if item.outMenu then
    item.outMenu:setVisible(false)
  end
  item.buildType = l_7_1
  item.buildID = nil
  item.resultType = 1
  item.bottomImg:setVisible(false)
  item.result:setVisible(false)
  item.removeSpine:registerAnimation("animation" .. l_7_1)
  item.removeSpine:registerLuaHandler(function(l_1_0)
    if l_1_0 == "fx" then
      item.bottomImg:setVisible(true)
    end
   end)
  if l_7_1 ~= 1 or not airData.data.mine then
    local list = airData.data.holy
  end
  for i,v in ipairs(list) do
    if v.pos == l_7_0 then
      table.remove(list, i)
  else
    end
  end
end

ui.upgradeItem = function(l_8_0, l_8_1)
  if l_8_1 == 0 then
    ui.mainTower.buildType = l_8_1
    ui.mainTower.buildID = ui.mainTower.buildID + 1
    ui.mainTower.result:unregisterAllAnimation()
    ui.mainTower.result:registerAnimation("animation_" .. airConf[ui.mainTower.buildID].show, -1)
    airData.data.id = ui.mainTower.buildID
    return 
  end
  local item = nil
  if l_8_1 == 1 then
    item = ui.mines[l_8_0]
  else
    item = ui.holys[l_8_0]
  end
  item.buildType = l_8_1
  item.buildID = item.buildID + 1
  item.result:unregisterAllAnimation()
  item.result:registerAnimation("animation_" .. airConf[item.buildID].show, -1)
  if l_8_1 ~= 1 or not airData.data.mine then
    local list = airData.data.holy
  end
  for i,v in ipairs(list) do
    if v.pos == l_8_0 then
      v.id = item.buildID
      return 
    end
  end
end

ui.createCurrencyBoard = function(l_9_0)
  local board = img.createUI9Sprite(img.ui.main_coin_bg)
  board:setPreferredSize(CCSizeMake(146, 32))
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local icon = nil
  if l_9_0 == 0 then
    icon = img.createItemIcon2(ITEM_ID_COIN)
  else
    icon = img.createItemIcon2(l_9_0)
  end
  icon:setPosition(5, board_h / 2 + 2)
  board:addChild(icon)
  local num = nil
  if l_9_0 == 1 then
    num = num2KM(bagdata.coin())
  elseif l_9_0 == 2 then
    num = num2KM(bagdata.gem())
  elseif l_9_0 == 72 then
    num = num2KM(bagdata.items.find(l_9_0).num)
  elseif l_9_0 == 0 then
    num = airData.data.vit.vit .. "/" .. airConf[airData.data.id].xMax
  end
  local numLabel = lbl.createFont2(16, num, ccc3(255, 246, 223))
  numLabel:setPosition(board_w / 2, board_h / 2 + 3)
  board:addChild(numLabel)
  local plusImg = img.createUISprite(img.ui.main_icon_plus)
  plusBtn = HHMenuItem:create(plusImg)
  plusBtn:setPosition(board_w - 18, board_h / 2)
  plusBtn:setVisible(false)
  local plusMenu = CCMenu:createWithItem(plusBtn)
  plusMenu:setPosition(ccp(0, 0))
  board:addChild(plusMenu)
  local id = l_9_0
  board:scheduleUpdateWithPriorityLua(function()
    if id == 1 then
      numLabel:setString(num2KM(bagdata.coin()))
    elseif id == 2 then
      numLabel:setString(num2KM(bagdata.gem()))
    elseif id == 72 then
      numLabel:setString(num2KM(bagdata.items.find(id).num))
    elseif id == 0 then
      numLabel:setString(airData.data.vit.vit .. "/" .. airConf[airData.data.id].xMax)
    end
   end, 0)
  board.label = numLabel
  return board
end

ui.addHole = function(l_10_0, l_10_1)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if l_10_0 == 1 then
    ui.mines[l_10_1] = ui.createBuild(l_10_0, nil, l_10_1)
     -- DECOMPILER ERROR: Confused about usage of registers!

    ui.createBuild(l_10_0, nil, l_10_1):setPositionX(ui.mineralPosX[ ui.mines])
     -- DECOMPILER ERROR: Confused about usage of registers!

    ui.createBuild(l_10_0, nil, l_10_1):setPositionY(ui.mineralPosY[ ui.mines])
  elseif l_10_0 == 2 then
    ui.holys[l_10_1] = ui.createBuild(l_10_0, nil, l_10_1)
     -- DECOMPILER ERROR: Confused about usage of registers!

    ui.createBuild(l_10_0, nil, l_10_1):setPositionX(ui.holyPosX[ ui.holys])
     -- DECOMPILER ERROR: Confused about usage of registers!

    ui.createBuild(l_10_0, nil, l_10_1):setPositionY(ui.holyPosY[ ui.holys])
  end
  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

    ui.bg:addChild(ui.createBuild(l_10_0, nil, l_10_1), (l_10_0 == 1 and 7 or 8) - l_10_1)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ui.refreshOutPut = function(l_11_0, l_11_1, l_11_2)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if l_11_0 == 1 then
    do return end
  end
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Confused about usage of registers!

  if l_11_0 ~= 2 or ui.mines[l_11_1].tipSpine then
    if l_11_2 then
      ui.mines[l_11_1].tipSpine:playAnimation("animation", -1)
     -- DECOMPILER ERROR: Confused about usage of registers!

    else
      ui.mines[l_11_1].tipSpine:playAnimation("animation2", -1)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
  end
end

ui.getOutPut = function(l_12_0, l_12_1)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if l_12_0 == 1 then
    do return end
  end
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Confused about usage of registers!

  if l_12_0 ~= 2 or ui.mines[l_12_1].tipSpine then
    ui.mines[l_12_1].tipSpine:playAnimation("animation2", -1)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

return ui

