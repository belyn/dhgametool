-- Command line was: E:\github\dhgametool\scripts\ui\airisland\buildUI.lua 

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
ui.create = function(l_1_0, l_1_1, l_1_2)
  ui.mainUI = l_1_2
  ui.buildPos = l_1_1
  ui.buildType = l_1_0
  ui.items = {}
  ui.selectType = nil
  local layer = CCLayer:create()
  layer:setTouchEnabled(true)
  local darkLayer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkLayer)
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSizeMake(750, 500))
  board:setScale(view.minScale)
  board:setPosition(view.midX - 0 * view.minScale, view.midY - 10)
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  if l_1_0 ~= 1 or not i18n.global.airisland_mine.string then
    local titleStr = i18n.global.airisland_holy.string
  end
  local title = lbl.createFont1(24, titleStr, ccc3(230, 208, 174))
  title:setPosition(CCPoint(board_w / 2, board_h - 29))
  board:addChild(title, 2)
  local shadow = lbl.createFont1(24, titleStr, ccc3(89, 48, 27))
  shadow:setPosition(CCPoint(board_w / 2, board_h - 31))
  board:addChild(shadow, 1)
  local box = img.createUI9Sprite(img.ui.inner_bg)
  box:setPreferredSize(CCSize(690, 256))
  box:setAnchorPoint(ccp(0.5, 0.5))
  box:setPosition(board:getContentSize().width / 2, 290)
  board:addChild(box)
  local box_w = box:getContentSize().width
  local box_h = box:getContentSize().height
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionHorizontal)
  scroll:setViewSize(CCSize(box_w - 8, box_h))
  scroll:setContentSize(CCSize(box_w - 8, box_h))
  scroll:setContentOffset(ccp(0, 0))
  scroll:setPosition(4, 0)
  scroll:setTouchEnabled(false)
  box:addChild(scroll)
  local scrollLayer = CCLayer:create()
  scrollLayer:setContentSize(scroll:getViewSize())
  scrollLayer:setPosition(0, 0)
  scrollLayer:setTouchEnabled(true)
  scrollLayer:setTouchSwallowEnabled(false)
  box:addChild(scrollLayer, 10)
  local lastX, lastY, moveX, moveY, isClicked = nil, nil, nil, nil, nil
  scrollLayer:registerScriptTouchHandler(function(l_1_0, l_1_1, l_1_2)
    local p = box:convertToNodeSpace(ccp(l_1_1, l_1_2))
    if l_1_0 == "began" then
      if not scrollLayer:boundingBox():containsPoint(p) then
        return false
      end
      upvalue_1024, upvalue_1536 = l_1_1, l_1_2
      upvalue_2048, upvalue_2560 = l_1_1, l_1_2
      upvalue_3072 = false
      return true
    elseif l_1_0 == "moved" then
      if math.abs(l_1_1 - lastX) > 10 or math.abs(l_1_2 - lastY) > 10 then
        upvalue_3072 = true
        for i,v in ipairs(ui.items) do
          v.btn:setEnabled(false)
        end
      end
      if isClicked then
        local posX = ui.scroll:getContentOffset().x
        ui.scroll:setContentOffset(ccp(posX + (l_1_1 - moveX), 0))
      end
      upvalue_2048, upvalue_2560 = l_1_1, l_1_2
    elseif l_1_0 == "ended" then
      local isEnabled = true
      for i,v in ipairs(ui.items) do
        if v.btn then
          if not v.btn:isEnabled() then
            isEnabled = false
          end
          v.btn:setEnabled(true)
        end
      end
      local content_w = ui.scroll:getContentSize().width
      local view_w = ui.scroll:getViewSize().width
      local offsetX = ui.scroll:getContentOffset().x
      if isEnabled then
        return 
      end
      if offsetX > 0 then
        ui.scroll:setContentOffsetInDuration(ccp(0, 0), 0.2)
      elseif offsetX + content_w < view_w then
        ui.scroll:setContentOffsetInDuration(ccp(view_w - content_w, 0), 0.2)
      end
    end
   end)
  local goldBoard = img.createUI9Sprite(img.ui.guild_mill_coinbg)
  goldBoard:setPreferredSize(CCSize(196, 30))
  goldBoard:setPosition(board_w / 2 - 110, 128)
  board:addChild(goldBoard)
  local gold_w = goldBoard:getContentSize().width
  local gold_h = goldBoard:getContentSize().height
  local goldIcon = img.createItemIcon2(ITEM_ID_COIN)
  goldIcon:setPosition(0, gold_h / 2)
  goldBoard:addChild(goldIcon)
  local goldLabel = lbl.createFont2(16, num2KM(1000), lbl.whiteColor)
  goldLabel:setPosition(gold_w / 2, gold_h / 2)
  goldBoard:addChild(goldLabel)
  local gemBoard = img.createUI9Sprite(img.ui.guild_mill_coinbg)
  gemBoard:setPreferredSize(CCSize(196, 30))
  gemBoard:setPosition(board_w / 2 + 110, 128)
  board:addChild(gemBoard)
  local gemIcon = img.createItemIcon2(ITEM_ID_GEM)
  gemIcon:setPosition(0, gold_h / 2)
  gemBoard:addChild(gemIcon)
  local stoneIcon = img.createItemIcon2(3)
  stoneIcon:setPosition(gemIcon:getPosition())
  stoneIcon:setVisible(false)
  gemBoard:addChild(stoneIcon)
  local gemLabel = lbl.createFont2(16, num2KM(1000), lbl.whiteColor)
  gemLabel:setPosition(gold_w / 2, gold_h / 2)
  gemBoard:addChild(gemLabel)
  local buildImg = img.createLogin9Sprite(img.login.button_9_small_gold)
  buildImg:setPreferredSize(CCSize(204, 60))
  buildBtn = SpineMenuItem:create(json.ui.button, buildImg)
  buildBtn:setPosition(board_w / 2, 66)
  local buildMenu = CCMenu:createWithItem(buildBtn)
  buildMenu:setPosition(0, 0)
  board:addChild(buildMenu)
  local buildLabel = lbl.createFont1(18, i18n.global.airisland_build.string, ccc3(115, 59, 5))
  buildLabel:setPosition(CCPoint(buildImg:getContentSize().width / 2, buildImg:getContentSize().height / 2))
  buildImg:addChild(buildLabel)
  buildBtn:registerScriptTapHandler(function()
    if not ui.selectType then
      return 
    end
    local createType = ui.buildType == 1 and 1 or 0
    local buildID = ui.selectType * 1000 + 1
    local params = {sid = player.sid, type = createType, act = 0, id = buildID, pos = ui.buildPos}
    addWaitNet()
    print("--------create build--------")
    print("type:" .. createType .. "," .. "id:" .. buildID .. "," .. "pos:" .. ui.buildPos)
    print("buildID:" .. buildID)
    net:island_op(params, function(l_1_0)
      print("--------create Build result--------")
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status == 0 then
        for i,v in ipairs(airConf[buildID].need) do
          bagdata.items.sub(v)
        end
        ui.mainUI.buildItem(ui.buildPos, ui.buildType, buildID)
        layer:removeFromParent()
      end
      end)
   end)
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
  ui.scroll = scroll
  ui.goldLabel = goldLabel
  ui.gemLabel = gemLabel
  ui.gemIcon = gemIcon
  ui.stoneIcon = stoneIcon
  ui.buildBtn = buildBtn
  ui.layer = layer
  ui.addItems()
  ui.resetScroll()
  for i,v in ipairs(ui.items) do
    if v.canBuild then
      ui.selectItem(ui.items[i])
  else
    end
  end
  board:setScale(0.5 * view.minScale)
  board:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  return layer
end

ui.createItem = function(l_2_0)
  local resultType = l_2_0
  local boardWidth = resultType >= 5 and 202 or 206
  local ownNum = 0
  local maxNum = 2
  local board = img.createUI9Sprite(img.ui.tutorial_text_bg)
  board:setPreferredSize(CCSizeMake(boardWidth, 216))
  local boardHeight = board:getContentSize().height
  local boardBtn = SpineMenuItem:create(json.ui.button, board)
  boardBtn:setAnchorPoint(0.5, 0.5)
  boardBtn:setPosition(0, 0)
  local boardMenu = CCMenu:createWithItem(boardBtn)
  local top = img.createUI9Sprite(img.ui.item_yellow)
  top:setPreferredSize(CCSizeMake(boardWidth + 2, boardHeight + 2))
  top:setPosition(boardWidth / 2, boardHeight / 2 - 1)
  top:setVisible(false)
  board:addChild(top)
  local resultName = i18n.global.airisland_buildName_" .. resultTyp.string
  local nameLabel = lbl.createFont1(14, resultName, ccc3(111, 76, 56))
  nameLabel:setPosition(boardWidth / 2, 27)
  board:addChild(nameLabel)
  local line_w = resultType >= 5 and 154 or 170
  local line = img.createLoginSprite(img.login.help_line)
  line:setScaleX(line_w / line:getContentSize().width)
  line:setPosition(boardWidth / 2, 45)
  board:addChild(line)
  local show = airConf[resultType * 1000 + 1].show
  print("----------------" .. resultType .. "," .. show)
  local icon = img.createUISprite(img.ui[IMG_BUILD_ID[resultType] .. show])
  icon:setAnchorPoint(0.5, 0)
  icon:setPosition(boardWidth / 2, 69)
  icon:setScale(0.6)
  board:addChild(icon)
  local timesLabel = lbl.createFont1(16, "0/2", ccc3(81, 39, 18))
  timesLabel:setAnchorPoint(0, 0.5)
  timesLabel:setPosition(14, 194)
  board:addChild(timesLabel)
  local tick = img.createUISprite(img.ui.hook_btn_sel)
  tick:setScale(0.5)
  tick:setPositionX(boardWidth - 27)
  tick:setPositionY(icon:getPositionY() - 5)
  tick:setVisible(false)
  board:addChild(tick)
  local helpImg = img.createUISprite(img.ui.btn_detail)
  local helpBtn = SpineMenuItem:create(json.ui.button, helpImg)
  helpBtn:setScale(0.8)
  helpBtn:setPosition(boardWidth - 26, 189)
  local helpMenu = CCMenu:createWithItem(helpBtn)
  helpMenu:setPosition(CCPoint(0, 0))
  board:addChild(helpMenu)
  helpBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local propertyUI = require("ui.airisland.propertyUI").create(resultType * 1000 + 1)
    ui.layer:addChild(propertyUI, 10)
   end)
  if resultType == 5 or resultType == 6 then
    maxNum = 1
  end
  for i,v in ipairs(airData.data.holy) do
    if math.floor(v.id / 1000) == resultType then
      ownNum = ownNum + 1
    end
  end
  for i,v in ipairs(airData.data.mine) do
    if math.floor(v.id / 1000) == resultType then
      ownNum = ownNum + 1
    end
  end
  timesLabel:setString(ownNum .. "/" .. maxNum)
  if maxNum <= ownNum then
    tick:setVisible(true)
  end
  boardMenu.ownNum = ownNum
  boardMenu.maxNum = maxNum
  boardMenu.btn = boardBtn
  boardMenu.top = top
  boardMenu.resultType = resultType
  boardMenu.canBuild = ownNum < maxNum and true or false
  boardBtn:registerScriptTapHandler(function()
    if boardMenu.canBuild then
      ui.selectItem(boardMenu)
    else
      showToast(i18n.global.airisland_limit_num.string)
    end
   end)
  return boardMenu
end

ui.addItems = function()
  local startX = 120
  local intervalX = 224
  local posY = 128
  if ui.buildType == 1 then
    for i = 2, 4 do
      local item = ui.createItem(i)
      item:setPositionX(startX + (i - 2) * intervalX)
      item:setPositionY(posY)
      ui.scroll:addChild(item)
      table.insert(ui.items, item)
    end
  else
    startX = 110
    intervalX = 210
    for i = 5, 9 do
      local item = ui.createItem(i)
      item:setPositionX(startX + (i - 5) * intervalX)
      item:setPositionY(posY)
      ui.scroll:addChild(item)
      table.insert(ui.items, item)
    end
  end
  local grayItems = {}
  for i = #ui.items, 1, -1 do
    if not ui.items[i].canBuild then
      table.insert(grayItems, ui.items[i])
      table.remove(ui.items, i)
    end
  end
  for i = #grayItems, 1, -1 do
    table.insert(ui.items, grayItems[i])
  end
  for i,v in ipairs(ui.items) do
    v:setPositionX(startX + (i - 1) * intervalX)
  end
end

ui.resetScroll = function()
  if ui.buildType == 1 then
    ui.scroll:setContentSize(CCSize(690, 256))
    ui.scroll:setContentOffset(ccp(0, 0))
  else
    ui.scroll:setContentSize(CCSize(16 + 202 * #ui.items + 8 * (#ui.items - 1), 256))
    ui.scroll:setContentOffset(ccp(0, 0))
  end
end

ui.selectItem = function(l_5_0)
  ui.selectType = l_5_0.resultType
  for i,v in ipairs(ui.items) do
    if v ~= l_5_0 then
      v.top:setVisible(false)
      for i,v in (for generator) do
      end
      v.top:setVisible(true)
    end
    local conf = airConf[l_5_0.resultType * 1000 + 1]
    local gold, gem, stone = nil, nil, nil
    for i,v in ipairs(conf.need) do
      if v.id == 1 then
        gold = v.num
        ui.goldLabel:setString(num2KM(v.num))
        for i,v in (for generator) do
        end
        if v.id == 2 then
          gem = v.num
          ui.gemIcon:setVisible(true)
          ui.stoneIcon:setVisible(false)
          ui.gemLabel:setString(num2KM(v.num))
          for i,v in (for generator) do
          end
          stone = v.num
          ui.gemIcon:setVisible(false)
          ui.stoneIcon:setVisible(true)
          ui.gemLabel:setString(num2KM(v.num))
        end
        do
          local canBuild = true
          if gold and bagdata.coin() < gold then
            canBuild = false
            ui.goldLabel:setColor(cc.c3b(255, 44, 44))
          end
          if gem and bagdata.gem() < gem then
            canBuild = false
            ui.gemLabel:setColor(cc.c3b(252, 44, 44))
          end
          if stone and bagdata.items.find(ITEM_ID_BUILD_STONE) < stone then
            canBuild = false
            ui.gemLabel:setColor(cc.c3b(255, 44, 44))
          end
          if canBuild then
            clearShader(ui.buildBtn, true)
            ui.goldLabel:setColor(lbl.whiteColor)
            ui.gemLabel:setColor(lbl.whiteColor)
          else
            setShader(ui.buildBtn, SHADER_GRAY, true)
          end
          ui.buildBtn:setEnabled(canBuild)
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return ui

