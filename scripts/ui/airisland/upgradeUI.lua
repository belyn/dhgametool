-- Command line was: E:\github\dhgametool\scripts\ui\airisland\upgradeUI.lua 

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
local dialog = require("ui.dialog")
local airData = require("data.airisland")
local airConf = require("config.homeworld")
local IMG_BUILD_ID = {1 = "airisland_maintower_", 2 = "airisland_gold_", 3 = "airisland_diamond_", 4 = "airisland_magic_", 5 = "airisland_bumper_", 6 = "airisland_energy_", 7 = "airisland_gale_", 8 = "airisland_tyrant_", 9 = "airisland_moon_"}
ui.create = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  ui.buildID = l_1_0
  ui.buildType = l_1_1
  ui.buildPos = l_1_2
  ui.mainUI = l_1_3
  ui.resultType = math.floor(ui.buildID / 1000)
  local layer = CCLayer:create()
  layer:setTouchEnabled(true)
  local darkLayer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkLayer)
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSizeMake(754, 510))
  board:setScale(view.minScale)
  board:setPosition(view.midX - 0 * view.minScale, view.midY - 10)
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local box = img.createUI9Sprite(img.ui.inner_bg)
  box:setPreferredSize(CCSize(658, 228))
  box:setAnchorPoint(ccp(0.5, 0.5))
  box:setPosition(board:getContentSize().width / 2, 284)
  board:addChild(box)
  local box_w = box:getContentSize().width
  local box_h = box:getContentSize().height
  local nameList = {0 = "airisland_buildName_1", 1 = "airisland_mine", 2 = "airisland_holy"}
  local titleStr = i18n.global[nameList[l_1_1]].string
  local title = lbl.createFont1(24, titleStr, ccc3(230, 208, 174))
  title:setPosition(CCPoint(board_w / 2, board_h - 29))
  board:addChild(title, 2)
  local shadow = lbl.createFont1(24, titleStr, ccc3(89, 48, 27))
  shadow:setPosition(CCPoint(board_w / 2, board_h - 31))
  board:addChild(shadow, 1)
  local outLabel = lbl.createFont1(18, i18n.global.airisland_output.string, ccc3(115, 59, 5))
  outLabel:setPosition(46, 424)
  outLabel:setAnchorPoint(0, 0.5)
  board:addChild(outLabel)
  local progressBg = img.createUI9Sprite(img.ui.guild_mill_coinprobg)
  progressBg:setPosition(board_w / 2 - 5, 424)
  progressBg:setPreferredSize(CCSizeMake(468, 22))
  board:addChild(progressBg)
  local progressBg_w = progressBg:getContentSize().width
  local progressBg_h = progressBg:getContentSize().height
  local progressImg = img.createUISprite(img.ui.airisland_stockbar)
  local progressTimer = createProgressBar(progressImg)
  progressTimer:setPosition(progressBg_w / 2, progressBg_h / 2 + 1)
  progressBg:addChild(progressTimer)
  progressTimer.now = l_1_4 or 0
  progressTimer.max = airConf[l_1_0].max or 1
  progressTimer:setPercentage(progressTimer.now / progressTimer.max * 100)
  if l_1_1 ~= 0 then
    if progressTimer.max <= progressTimer.now then
      ui.mainUI.refreshOutPut(ui.buildType, ui.buildPos, true)
    else
      ui.mainUI.refreshOutPut(ui.buildType, ui.buildPos, false)
    end
  end
  local progressLabel = lbl.createFont2(16, num2KM(progressTimer.now) .. "/" .. num2KM(progressTimer.max), lbl.whiteColor)
  progressLabel:setPosition(progressBg_w / 2, progressBg_h)
  progressBg:addChild(progressLabel)
  local outID = {2 = 1, 3 = 2, 4 = 15, 6 = 4302}
  if outID[ui.resultType] then
    if ui.resultType ~= 6 or not img.createItemIconForId(outID[ui.resultType]) then
      local outIcon = img.createItemIcon2(outID[ui.resultType])
    end
    outIcon:setPosition(0, progressBg:getContentSize().height / 2)
    progressBg:addChild(outIcon)
  end
  local getImg = img.createLogin9Sprite(img.login.button_9_small_green)
  getImg:setPreferredSize(CCSizeMake(88, 38))
  local getLabel = lbl.createFont1(16, i18n.global.hook_btn_get.string, ccc3(31, 96, 6))
  getLabel:setPosition(44, 19)
  getImg:addChild(getLabel)
  getBtn = SpineMenuItem:create(json.ui.button, getImg)
  getBtn:setPosition(CCPoint(664, 426))
  local getMenu = CCMenu:createWithItem(getBtn)
  getMenu:setPosition(CCPoint(0, 0))
  board:addChild(getMenu, 11)
  getBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local createType = ui.buildType == 1 and 1 or 0
    local params = {sid = player.sid, type = createType, act = 2, id = ui.buildID, pos = ui.buildPos}
    addWaitNet()
    print("-------output info--------")
    print("type" .. createType .. "," .. "act:" .. 2 .. "," .. "id:" .. ui.buildID .. "," .. "pos:" .. ui.buildPos)
    net:island_op(params, function(l_1_0)
      print("--------get output--------")
      delWaitNet()
      tablePrint(l_1_0)
      if l_1_0.status == 0 then
        if l_1_0.item then
          if l_1_0.item.items[1].num == 0 then
            showToast(i18n.global.airisland_no_putout.string)
            return 
          end
          bagdata.items.add(l_1_0.item.items[1])
          ui.progressTimer.now = 0
          ui.progressTimer:setPercentage(ui.progressTimer.now / ui.progressTimer.max * 100)
          ui.progressLabel:setString(num2KM(ui.progressTimer.now) .. "/" .. num2KM(ui.progressTimer.max))
          local pbBag = {}
          pbBag.items = {}
          pbBag.items[1] = l_1_0.item.items[1]
          CCDirector:sharedDirector():getRunningScene():addChild(reward.createFloating(pbBag), 99999)
          local limit = airConf[params.id].max
          if limit <= l_1_0.item.items[1].num then
            airData.getOutPut()
          elseif l_1_0.vit then
            if l_1_0.vit == 0 then
              showToast(i18n.global.airisland_no_putout.string)
              return 
            end
            airData.changeVit(l_1_0.vit)
            ui.progressTimer.now = 0
            ui.progressTimer:setPercentage(ui.progressTimer.now / ui.progressTimer.max * 100)
            ui.progressLabel:setString(num2KM(ui.progressTimer.now) .. "/" .. num2KM(ui.progressTimer.max))
            local pbBag = {}
            pbBag.items = {}
            pbBag.items[1] = {}
            pbBag.items[1].id = 4302
            pbBag.items[1].num = l_1_0.vit
            CCDirector:sharedDirector():getRunningScene():addChild(reward.createFloating(pbBag), 99999)
          end
        end
        local canUpgrade = true
        if not airConf[ui.buildID + 1] or not airConf[ui.buildID + 1].need then
          local need = {}
        end
        for i,v in ipairs(need) do
          local item = bagdata.items.find(v.id)
          if item.num < v.num then
            canUpgrade = false
            if v.id == 1 then
              ui.goldLabel:setColor(cc.c3b(255, 44, 44))
              for i,v in (for generator) do
              end
              if v.id == 2 then
                ui.gemLabel:setColor(cc.c3b(255, 44, 44))
                for i,v in (for generator) do
                end
                ui.stoneLabel:setColor(cc.c3b(255, 44, 44))
              end
            end
            if canUpgrade then
              ui.goldLabel:setColor(lbl.whiteColor)
              ui.gemLabel:setColor(lbl.whiteColor)
              ui.stoneLabel:setColor(lbl.whiteColor)
            end
            local limit = airConf[ui.buildID + 1] and airConf[ui.buildID + 1].limit or 0
            local lv = airConf[airData.data.id].lv
            if limit then
              ui.tipLabel:setVisible(false)
              ui.tipLabel:setString(i18n.global.airisland_require_lv.string .. "Lv " .. limit)
              if lv < limit then
                canUpgrade = false
              end
            end
            if canUpgrade then
              clearShader(ui.upgradeBtn, true)
            else
              setShader(ui.upgradeBtn, SHADER_GRAY, true)
            end
            ui.upgradeBtn:setEnabled(canUpgrade)
            ui.mainUI.getOutPut(ui.buildType, ui.buildPos)
          else
            showToast(i18n.global.airisland_no_putout.string)
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
      end)
   end)
  local arrow = img.createUISprite(img.ui.arrow)
  arrow:setPosition(box_w / 2, box_h / 2 - 2)
  box:addChild(arrow)
  local goldBoard = img.createUI9Sprite(img.ui.guild_mill_coinbg)
  goldBoard:setPreferredSize(CCSize(196, 30))
  goldBoard:setPosition(board_w / 2 - 110, 124)
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
  gemBoard:setPosition(board_w / 2 + 110, 124)
  board:addChild(gemBoard)
  local gemIcon = img.createItemIcon2(ITEM_ID_GEM)
  gemIcon:setPosition(0, gold_h / 2)
  gemBoard:addChild(gemIcon)
  local gemLabel = lbl.createFont2(16, num2KM(1000), lbl.whiteColor)
  gemLabel:setPosition(gold_w / 2, gold_h / 2)
  gemBoard:addChild(gemLabel)
  local stoneBoard = img.createUI9Sprite(img.ui.guild_mill_coinbg)
  stoneBoard:setPreferredSize(CCSize(196, 30))
  stoneBoard:setPosition(board_w / 2 + 110, 124)
  board:addChild(stoneBoard)
  local stoneIcon = img.createItemIcon2(ITEM_ID_BUILD_STONE)
  stoneIcon:setPosition(gemIcon:getPosition())
  stoneBoard:addChild(stoneIcon)
  local stoneLabel = lbl.createFont2(16, num2KM(1000), lbl.whiteColor)
  stoneLabel:setPosition(gold_w / 2, gold_h / 2)
  stoneBoard:setVisible(false)
  stoneBoard:addChild(stoneLabel)
  local tipLabel = lbl.createFont1(16, "0", ccc3(115, 70, 44))
  tipLabel:setPosition(board_w / 2, 102)
  tipLabel:setVisible(false)
  board:addChild(tipLabel)
  local removeImg = img.createLogin9Sprite(img.login.button_9_small_orange)
  removeImg:setPreferredSize(CCSize(164, 48))
  removeBtn = SpineMenuItem:create(json.ui.button, removeImg)
  removeBtn:setPosition(CCPoint(board_w / 2 - 90, 60))
  local removeLabel = lbl.createFont1(16, i18n.global.airisland_remove.string, ccc3(142, 56, 23))
  removeLabel:setPosition(82, 24)
  removeImg:addChild(removeLabel)
  local removeMenu = CCMenu:createWithItem(removeBtn)
  removeMenu:setPosition(CCPoint(0, 0))
  board:addChild(removeMenu)
  removeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local dialog_params = {title = "", body = i18n.global.airisland_isRemove.string, btn_count = 2, btn_color = {1 = dialog.COLOR_GOLD, 2 = dialog.COLOR_GOLD}, btn_text = {1 = i18n.global.dialog_button_cancel.string, 2 = i18n.global.dialog_button_confirm.string}, selected_btn = 0, callback = function(l_1_0)
      layer:removeChildByTag(dialog.TAG)
      if ui.buildType ~= 1 or not 1 then
        local createType = l_1_0.selected_btn ~= 2 or 0
      end
      do
        local params = {sid = player.sid, type = createType, act = 3, id = ui.buildID, pos = ui.buildPos}
        addWaitNet()
        print("--------remove build----------")
        print("type" .. createType .. "," .. "act:" .. 3 .. "," .. "id:" .. ui.buildID .. "," .. "pos:" .. ui.buildPos)
        net:island_op(params, function(l_1_0)
        print("--------remove Build result--------")
        delWaitNet()
        tablePrint(l_1_0)
        if l_1_0.status == 0 then
          local pbBag = {}
          pbBag.items = {}
          if l_1_0.item then
            for i,v in ipairs(l_1_0.item.items) do
              table.insert(pbBag.items, v)
              bagdata.items.add(v)
            end
          elseif l_1_0.vit then
            airData.changeVit(l_1_0.vit)
            local item = {}
            item.id = 4302
            item.num = l_1_0.vit
            table.insert(pbBag.items, item)
          end
          for i,v in ipairs(airConf[ui.buildID].back) do
            table.insert(pbBag.items, v)
            bagdata.items.add(v)
          end
          CCDirector:sharedDirector():getRunningScene():addChild(reward.createFloating(pbBag), 99999)
          print("--------a---------")
          print(ui.buildPos .. "," .. ui.buildType)
          ui.mainUI.removeItem(ui.buildPos, ui.buildType)
          layer:removeFromParent()
        end
         end)
      end
      do return end
      if l_1_0.selected_btn == 1 then
         -- Warning: missing end command somewhere! Added here
      end
      end}
    local tip = dialog.create(dialog_params)
    layer:addChild(tip, 1000, dialog.TAG)
   end)
  local upgradeImg = img.createLogin9Sprite(img.login.button_9_small_gold)
  upgradeImg:setPreferredSize(CCSize(164, 48))
  upgradeBtn = SpineMenuItem:create(json.ui.button, upgradeImg)
  upgradeBtn:setPosition(CCPoint(board_w / 2 + 90, 60))
  local upgradeLabel = lbl.createFont1(16, i18n.global.airisland_upgrade.string, ccc3(115, 59, 5))
  upgradeLabel:setPosition(82, 24)
  upgradeImg:addChild(upgradeLabel)
  local upgradeMenu = CCMenu:createWithItem(upgradeBtn)
  upgradeMenu:setPosition(CCPoint(0, 0))
  board:addChild(upgradeMenu)
  upgradeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if ui.buildType == 0 then
      if not airConf[ui.buildID + 1] then
        showToast(i18n.global.airisland_max_lv.string)
        return 
      end
      local params = {sid = player.sid}
      addWaitNet()
      print("-------upgrade tower--------")
      net:island_tower(params, function(l_1_0)
        print("--------upgrade Build result--------")
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status == 0 then
          airData.data.id = airData.data.id + 1
          for i,v in ipairs(airConf[ui.buildID + 1].need) do
            bagdata.items.sub(v)
          end
          ui.refreshUpgrade()
          local oldPit = airConf[ui.buildID - 1].pit
          local newPit = airConf[ui.buildID].pit
          local oldPlat = airConf[ui.buildID - 1].plat
          local newPlat = airConf[ui.buildID].plat
          local subPit = newPit - oldPit
          local subPlat = newPlat - oldPlat
          if subPit > 0 then
            ui.mainUI.addHole(1, newPit)
          end
          if subPlat > 0 then
            ui.mainUI.addHole(2, newPlat)
          end
          ui.mainUI.upgradeItem(ui.buildPos, ui.buildType)
        end
         end)
    else
      local createType = ui.buildType == 1 and 1 or 0
      local params = {sid = player.sid, type = createType, act = 1, id = ui.buildID, pos = ui.buildPos}
      addWaitNet()
      print("--------upgrade build--------")
      net:island_op(params, function(l_2_0)
        print("--------upgrade Build--------")
        delWaitNet()
        tbl2string(l_2_0)
        if l_2_0.status == 0 then
          for i,v in ipairs(airConf[ui.buildID + 1].need) do
            bagdata.items.sub(v)
          end
          ui.refreshUpgrade()
          ui.mainUI.upgradeItem(ui.buildPos, ui.buildType)
          ui.mainUI.refreshOutPut(ui.buildType, ui.buildPos, false)
        end
         end)
    end
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
  local leftItem = ui.createItem(true)
  leftItem:setPosition(box_w / 2 - 164, box_h / 2 - 2)
  box:addChild(leftItem)
  do
    local rightItem = nil
    if airConf[ui.buildID + 1] then
      rightItem = ui.createItem(false)
      rightItem:setPosition(box_w / 2 + 164, box_h / 2 - 2)
      box:addChild(rightItem)
    end
    ui.leftItem = leftItem
    ui.rightItem = rightItem or nil
    ui.arrow = arrow
    ui.box = box
    ui.board = board
    ui.layer = layer
    ui.tipLabel = tipLabel
    ui.goldBoard = goldBoard
    ui.gemBoard = gemBoard
    ui.stoneBoard = stoneBoard
    ui.goldLabel = goldLabel
    ui.gemLabel = gemLabel
    ui.stoneLabel = stoneLabel
    ui.removeBtn = removeBtn
    ui.upgradeBtn = upgradeBtn
    ui.progressTimer = progressTimer
    ui.progressLabel = progressLabel
    if ui.resultType < 2 or ui.resultType > 6 or ui.resultType == 5 then
      outLabel:setVisible(false)
      progressBg:setVisible(false)
      progressTimer:setVisible(false)
      getBtn:setVisible(false)
      ui.box:setPositionY(ui.box:getPositionY() + 20)
      ui.goldBoard:setPositionY(ui.goldBoard:getPositionY() + 14)
      ui.gemBoard:setPositionY(ui.gemBoard:getPositionY() + 14)
      ui.stoneBoard:setPositionY(ui.stoneBoard:getPositionY() + 14)
      ui.tipLabel:setPositionY(ui.tipLabel:getPositionY() + 14)
      ui.removeBtn:setPositionY(ui.removeBtn:getPositionY() + 14)
      ui.upgradeBtn:setPositionY(ui.upgradeBtn:getPositionY() + 14)
    else
      if ui.resultType ~= 6 then
        ui.getHolyAdd()
        ui.startProgressTimer()
      end
    end
    if l_1_1 == 0 then
      tipLabel:setVisible(false)
      getBtn:setVisible(false)
      removeBtn:setVisible(false)
      upgradeBtn:setPositionX(board_w / 2)
      ui.goldBoard:setPositionY(ui.goldBoard:getPositionY())
      ui.gemBoard:setPositionY(ui.gemBoard:getPositionY())
      ui.stoneBoard:setPositionY(ui.stoneBoard:getPositionY())
      ui.upgradeBtn:setPositionY(ui.upgradeBtn:getPositionY() - 4)
    end
    if not airConf[ui.buildID + 1] then
      leftItem:setPreferredSize(CCSizeMake(box_w, box_h))
      leftItem:setPositionX(box_w / 2)
      leftItem:setPositionY(box_h / 2)
      leftItem.top:setVisible(true)
      leftItem.top:setPreferredSize(CCSizeMake(box_w, box_h + 4))
      leftItem.top:setPositionX(box_w / 2)
      leftItem.top:setPositionY(box_h / 2)
      leftItem.icon:setPositionX(box_w / 2)
      leftItem.icon:setPositionY(leftItem.icon:getPositionY() + 20)
      leftItem.line:setPositionX(box_w / 2)
      leftItem.line:setPositionY(leftItem.line:getPositionY() + 10)
      leftItem.lvBg:setPositionX(box_w / 2)
      leftItem.lvBg:setPositionY(leftItem.lvBg:getPositionY() + 10)
      leftItem.nameLabel:setPositionX(box_w / 2)
      leftItem.nameLabel:setPositionY(leftItem.nameLabel:getPositionY() + 9)
      leftItem.helpBtn:setPositionX(box_w - 28)
      leftItem.helpBtn:setPositionY(leftItem.helpBtn:getPositionY() + 46)
      leftItem.upgradeSpine:setPosition(leftItem.top:getPosition())
      leftItem.line:setPreferredSize(CCSizeMake(572, 1))
      leftItem.lWing:setPositionX(leftItem.icon:getPositionX() - 137)
      leftItem.rWing:setPositionX(leftItem.icon:getPositionX() + 137)
      leftItem.lWing:setPositionY(leftItem.icon:getPositionY() + 52)
      leftItem.rWing:setPositionY(leftItem.icon:getPositionY() + 52)
      leftItem.lWing:setVisible(true)
      leftItem.rWing:setVisible(true)
      arrow:setVisible(false)
      upgradeBtn:setVisible(false)
      goldBoard:setVisible(false)
      gemBoard:setVisible(false)
      stoneBoard:setVisible(false)
      if l_1_1 == 0 then
        upgradeBtn:setVisible(true)
        setShader(upgradeBtn, SHADER_GRAY, true)
      else
        removeBtn:setPositionX(board_w / 2)
      end
      leftItem.icon:setPositionY(leftItem.icon:getPositionY() + 6)
      leftItem.lWing:setPositionY(leftItem.lWing:getPositionY() + 6)
      leftItem.rWing:setPositionY(leftItem.rWing:getPositionY() + 6)
      leftItem.lvBg:setPositionY(leftItem.lvBg:getPositionY() + 6)
      leftItem.nameLabel:setPositionY(leftItem.nameLabel:getPositionY() - 6)
      removeBtn:setPositionY(removeBtn:getPositionY() + 34)
      upgradeBtn:setPositionY(upgradeBtn:getPositionY() + 34)
      tipLabel:setVisible(false)
      tipLabel:setString(i18n.global.airisland_max_lv.string)
      tipLabel:setPositionY(tipLabel:getPositionY() + 20)
    else
      local canUpgrade = true
      local gold, gem, stone = nil, nil, nil
      for i,v in ipairs(airConf[ui.buildID + 1].need) do
        if v.id == 1 then
          gold = v.num
          goldLabel:setString(num2KM(v.num))
          goldBoard:setVisible(true)
          for i,v in (for generator) do
          end
          if v.id == 2 then
            gem = v.num
            gemLabel:setString(num2KM(v.num))
            gemBoard:setVisible(true)
            stoneBoard:setVisible(false)
            for i,v in (for generator) do
            end
            stone = v.num
            stoneLabel:setString(num2KM(v.num))
            gemBoard:setVisible(false)
            stoneBoard:setVisible(true)
          end
          for i,v in ipairs(airConf[ui.buildID + 1].need) do
            local item = bagdata.items.find(v.id)
            if item.num < v.num then
              canUpgrade = false
              if v.id == 1 then
                ui.goldLabel:setColor(cc.c3b(255, 44, 44))
                for i,v in (for generator) do
                end
                if v.id == 2 then
                  ui.gemLabel:setColor(cc.c3b(255, 44, 44))
                  for i,v in (for generator) do
                  end
                  ui.stoneLabel:setColor(cc.c3b(255, 44, 44))
                end
              end
              if canUpgrade then
                ui.goldLabel:setColor(lbl.whiteColor)
                ui.gemLabel:setColor(lbl.whiteColor)
                ui.stoneLabel:setColor(lbl.whiteColor)
              end
              local limit = airConf[ui.buildID + 1].limit
              local lv = airConf[airData.data.id].lv
              if limit then
                tipLabel:setVisible(false)
                tipLabel:setString(i18n.global.airisland_require_lv.string .. "Lv " .. limit)
                if lv < limit then
                  canUpgrade = false
                end
              end
              if canUpgrade then
                clearShader(ui.upgradeBtn, true)
              else
                setShader(ui.upgradeBtn, SHADER_GRAY, true)
              end
              ui.upgradeBtn:setEnabled(canUpgrade)
            end
            board:setScale(0.5 * view.minScale)
            board:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
            return layer
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.createItem = function(l_2_0)
  if not l_2_0 or not img.ui.botton_fram_4 then
    local path = img.ui.botton_fram_2
  end
  if not l_2_0 or not ui.buildID then
    local buildID = ui.buildID + 1
  end
  local show = airConf[buildID].show
  local level = airConf[buildID].lv
  local board = img.createUI9Sprite(path)
  board:setPreferredSize(CCSizeMake(280, 184))
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local top = img.createUI9Sprite(img.ui.botton_fram_2)
  top:setPreferredSize(CCSizeMake(658, 228))
  top:setPosition(board_w / 2, board_h / 2)
  top:setVisible(false)
  board:addChild(top)
  local icon = img.createUISprite(img.ui[IMG_BUILD_ID[ui.resultType] .. show])
  icon:setAnchorPoint(0.5, 0)
  icon:setPosition(board_w / 2, 51)
  icon:setScale(0.8)
  board:addChild(icon, 1)
  local lWing = img.createUISprite(img.ui.guild_mill_branch)
  lWing:setRotation(15)
  lWing:setPosition(icon:getPosition())
  lWing:setVisible(false)
  board:addChild(lWing)
  local rWing = img.createUISprite(img.ui.guild_mill_branch)
  rWing:setScaleX(-1)
  rWing:setRotation(-15)
  rWing:setPosition(icon:getPosition())
  rWing:setVisible(false)
  board:addChild(rWing)
  local lvBg = img.createUISprite(img.ui.airisland_lvbg)
  lvBg:setPosition(board_w / 2, 56)
  lvBg:setVisible(false)
  board:addChild(lvBg, 2)
  local lvLabel = lbl.createFont1(14, "Lv." .. level, lbl.whiteColor)
  lvLabel:setPosition(lvBg:getContentSize().width / 2, lvBg:getContentSize().height / 2 + 1)
  lvBg:addChild(lvLabel)
  local line = img.createUI9Sprite(img.ui.split_line)
  line:setPreferredSize(CCSizeMake(238, 1))
  line:setPosition(board_w / 2, 40)
  board:addChild(line)
  local resultName = "Lv." .. level .. "  " .. i18n.global.airisland_buildName_" .. ui.resultTyp.string
  local nameLabel = lbl.createFont1(14, resultName, ccc3(111, 76, 56))
  nameLabel:setPosition(board_w / 2, 25)
  board:addChild(nameLabel)
  local helpImg = img.createUISprite(img.ui.btn_detail)
  local helpBtn = SpineMenuItem:create(json.ui.button, helpImg)
  helpBtn:setScale(0.8)
  helpBtn:setPosition(board_w - 26, 157)
  local helpMenu = CCMenu:createWithItem(helpBtn)
  helpMenu:setPosition(CCPoint(0, 0))
  board:addChild(helpMenu)
  helpBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local propertyUI = require("ui.airisland.propertyUI").create(buildID)
    ui.layer:addChild(propertyUI, 10)
   end)
  local tipLabel, LockIcon = nil, nil
  if ui.buildType ~= 0 and not l_2_0 then
    local limit = airConf[buildID].limit
    local lv = airConf[airData.data.id].lv
    if limit and lv < limit then
      nameLabel:setVisible(false)
      icon:setVisible(false)
      tipLabel = lbl.create({font = 1, size = 14, text = i18n.global.airisland_require_lv.string .. "Lv " .. limit, color = ccc3(111, 76, 56), width = 207})
      tipLabel:setPosition(nameLabel:getPosition())
      tipLabel:setPositionY(tipLabel:getPositionY() + 22)
      lockIcon = img.createUISprite(img.ui.locked)
      lockIcon:setPosition(board_w / 2, board_h / 2 + 14)
      board:addChild(tipLabel)
      board:addChild(lockIcon)
      helpBtn:setVisible(false)
      line:setVisible(false)
    end
  end
  local upgradeSpine = json.create(json.ui.kongzhan_zhudao_shengji)
  upgradeSpine:setPosition(board_w / 2, board_h / 2 + 14)
  board:addChild(upgradeSpine, 2)
  board.icon = icon
  board.lvBg = lvBg
  board.line = line
  board.top = top
  board.lWing = lWing
  board.rWing = rWing
  board.nameLabel = nameLabel
  board.helpBtn = helpBtn
  board.upgradeSpine = upgradeSpine
  return board
end

ui.refreshUpgrade = function()
  local box_w = ui.box:getContentSize().width
  local box_h = ui.box:getContentSize().height
  ui.buildID = ui.buildID + 1
  ui.leftItem:removeFromParent()
  ui.leftItem = ui.createItem(true)
  ui.leftItem:setPosition(box_w / 2 - 164, box_h / 2 - 2)
  ui.box:addChild(ui.leftItem)
  ui.leftItem.upgradeSpine:playAnimation("animation")
  if not airConf[ui.buildID + 1] then
    local box_w = ui.box:getContentSize().width
    local box_h = ui.box:getContentSize().height
    local width = 608
    ui.leftItem.upgradeSpine:stopAnimation()
    ui.leftItem.upgradeSpine:setVisible(false)
    ui.leftItem:setPreferredSize(CCSizeMake(width, 184))
    ui.leftItem:setPosition(box_w / 2, box_h / 2)
    ui.leftItem.line:setPreferredSize(CCSizeMake(564, 1))
    ui.leftItem.line:setPositionX(width / 2)
    ui.leftItem.icon:setPositionX(width / 2)
    ui.leftItem.icon:setPositionY(ui.leftItem.icon:getPositionY() - 1)
    ui.leftItem.lvBg:setPositionX(width / 2)
    ui.leftItem.nameLabel:setPositionX(width / 2)
    ui.leftItem.helpBtn:setPositionX(width - 25)
    ui.leftItem.upgradeSpine:setPositionX(width / 2)
    ui.leftItem.lWing:setPositionX(ui.leftItem.icon:getPositionX() - 137)
    ui.leftItem.rWing:setPositionX(ui.leftItem.icon:getPositionX() + 137)
    ui.leftItem.lWing:setPositionY(ui.leftItem.icon:getPositionY() + 48)
    ui.leftItem.rWing:setPositionY(ui.leftItem.icon:getPositionY() + 48)
    ui.removeBtn:setPositionX(ui.board:getContentSize().width / 2)
    ui.removeBtn:setPositionY(ui.removeBtn:getPositionY() + 34)
    ui.upgradeBtn:setPositionY(ui.upgradeBtn:getPositionY() + 34)
    ui.leftItem.lWing:setVisible(true)
    ui.leftItem.rWing:setVisible(true)
    ui.arrow:setVisible(false)
    ui.rightItem:setVisible(false)
    ui.upgradeBtn:setVisible(false)
    ui.goldBoard:setVisible(false)
    ui.gemBoard:setVisible(false)
    ui.stoneBoard:setVisible(false)
    ui.tipLabel:setVisible(false)
    ui.tipLabel:setString(i18n.global.airisland_max_lv.string)
    if ui.buildType == 0 then
      ui.upgradeBtn:setVisible(true)
      setShader(ui.upgradeBtn, SHADER_GRAY, true)
    else
      ui.rightItem:removeFromParent()
      ui.rightItem = ui.createItem(false)
      ui.rightItem:setPosition(box_w / 2 + 164, box_h / 2 - 2)
      ui.box:addChild(ui.rightItem)
      local canUpgrade = true
      local gold, gem, stone = nil, nil, nil
      for i,v in ipairs(airConf[ui.buildID + 1].need) do
        if v.id == 1 then
          gold = v.num
          ui.goldLabel:setString(num2KM(v.num))
          ui.goldBoard:setVisible(true)
          for i,v in (for generator) do
          end
          if v.id == 2 then
            gem = v.num
            ui.gemLabel:setString(num2KM(v.num))
            ui.gemBoard:setVisible(true)
            ui.stoneBoard:setVisible(false)
            for i,v in (for generator) do
            end
            stone = v.num
            ui.stoneLabel:setString(num2KM(v.num))
            ui.gemBoard:setVisible(false)
            ui.stoneBoard:setVisible(true)
          end
          for i,v in ipairs(airConf[ui.buildID + 1].need) do
            local item = bagdata.items.find(v.id)
            if item.num < v.num then
              canUpgrade = false
              if v.id == 1 then
                ui.goldLabel:setColor(cc.c3b(255, 44, 44))
                for i,v in (for generator) do
                end
                if v.id == 2 then
                  ui.gemLabel:setColor(cc.c3b(255, 44, 44))
                  for i,v in (for generator) do
                  end
                  ui.stoneLabel:setColor(cc.c3b(255, 44, 44))
                end
              end
              if canUpgrade then
                ui.goldLabel:setColor(lbl.whiteColor)
                ui.gemLabel:setColor(lbl.whiteColor)
                ui.stoneLabel:setColor(lbl.whiteColor)
              end
              local limit = airConf[ui.buildID + 1].limit
              local lv = airConf[airData.data.id].lv
              if limit then
                ui.tipLabel:setVisible(false)
                ui.tipLabel:setString(i18n.global.airisland_require_lv.string .. "Lv " .. limit)
                if lv < limit then
                  print("----\230\156\170\232\190\190\229\136\176\231\173\137\231\186\167-----")
                  canUpgrade = false
                end
              end
              if canUpgrade then
                clearShader(ui.upgradeBtn, true)
              else
                setShader(ui.upgradeBtn, SHADER_GRAY, true)
              end
              ui.upgradeBtn:setEnabled(canUpgrade)
            end
          end
          if ui.progressTimer:isVisible() then
            ui.progressTimer.max = airConf[ui.buildID].max
            ui.progressTimer:setPercentage(ui.progressTimer.now / ui.progressTimer.max * 100)
            ui.progressLabel:setString(num2KM(ui.progressTimer.now) .. "/" .. num2KM(ui.progressTimer.max))
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.getHolyAdd = function()
  ui.addPercent = nil
  for i,v in ipairs(airData.data.holy) do
    if math.floor(v.id / 1000) ~= 5 then
      ui.addPercent = airConf[v.id].add
  else
    end
  end
end

ui.startProgressTimer = function()
  local delay = CCDelayTime:create(10)
  local callfunc = CCCallFunc:create(function()
    local speed = math.floor(airConf[ui.buildID].give / 24 / 60 / 60 * 10)
    local new = ui.progressTimer.now
    if not ui.addPercent or not math.floor(speed * (1 + ui.addPercent / 100)) then
      new = new + speed
    end
    if ui.progressTimer.max <= new then
      ui.progressTimer.now = ui.progressTimer.max
      ui.progressTimer:setPercentage(ui.progressTimer.now / ui.progressTimer.max * 100)
      ui.progressLabel:setString(num2KM(ui.progressTimer.now) .. "/" .. num2KM(ui.progressTimer.max))
      ui.progressTimer:stopAllActions()
    else
      ui.progressTimer.now = new
      ui.progressTimer:setPercentage(ui.progressTimer.now / ui.progressTimer.max * 100)
      ui.progressLabel:setString(num2KM(ui.progressTimer.now) .. "/" .. num2KM(ui.progressTimer.max))
    end
   end)
  local sequence = createSequence({delay, callfunc})
  ui.progressTimer:runAction(CCRepeatForever:create(sequence))
end

return ui

