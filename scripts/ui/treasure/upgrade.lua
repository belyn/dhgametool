-- Command line was: E:\github\dhgametool\scripts\ui\treasure\upgrade.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local net = require("net.netClient")
local bag = require("data.bag")
local cfgequip = require("config.equip")
local tipsitem = require("ui.tips.item")
local tipsequip = require("ui.tips.equip")
local player = require("data.player")
local heroData = require("data.heros")
local equiptr = {}
ui.equiptr = equiptr
local showtr = function()
  local treasures = {}
  for i,eq in ipairs(bag.equips) do
    if cfgequip[eq.id].pos == 6 and eq.num ~= 0 then
      local tmp = {}
      treasures[#treasures + 1] = tmp
      treasures[#treasures].id = eq.id
      treasures[#treasures].num = eq.num
    end
  end
  return treasures
end

local createPopupPieceBatchSummonResult = function(l_2_0, l_2_1, l_2_2)
  local params = {}
  params.title = i18n.global.reward_will_get.string
  params.btn_count = 0
  local dialog = require("ui.dialog").create(params)
  local back = img.createLogin9Sprite(img.login.button_9_small_gold)
  back:setPreferredSize(CCSize(153, 50))
  local comfirlab = lbl.createFont1(22, i18n.global.summon_comfirm.string, lbl.buttonColor)
  comfirlab:setPosition(CCPoint(back:getContentSize().width / 2, back:getContentSize().height / 2))
  back:addChild(comfirlab)
  local backBtn = SpineMenuItem:create(json.ui.button, back)
  backBtn:setPosition(CCPoint(dialog.board:getContentSize().width / 2, 80))
  local menu = CCMenu:createWithItem(backBtn)
  menu:setPosition(0, 0)
  dialog.board:addChild(menu)
  dialog.board.tipsTag = false
  if l_2_0 == "item" then
    local item = img.createItem(l_2_1, l_2_2)
    itemBtn = SpineMenuItem:create(json.ui.button, item)
    itemBtn:setScale(0.85)
    itemBtn:setPosition(dialog.board:getContentSize().width / 2, 185)
    local iconMenu = CCMenu:createWithItem(itemBtn)
    iconMenu:setPosition(0, 0)
    dialog.board:addChild(iconMenu)
    itemBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if dialog.board.tipsTag == false then
        dialog.board.tipsTag = true
        tips = tipsitem.createForShow({id = id, num = count})
        dialog:addChild(tips, 200)
        tips.setClickBlankHandler(function()
          tips:removeFromParent()
          dialog.board.tipsTag = false
            end)
      end
      end)
  else
    local equip = img.createEquip(l_2_1, l_2_2)
    equipBtn = SpineMenuItem:create(json.ui.button, equip)
    equipBtn:setScale(0.85)
    equipBtn:setPosition(dialog.board:getContentSize().width / 2, 185)
    local iconMenu = CCMenu:createWithItem(equipBtn)
    iconMenu:setPosition(0, 0)
    dialog.board:addChild(iconMenu)
    equipBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if dialog.board.tipsTag == false then
        dialog.board.tipsTag = true
        tips = tipsequip.createForShow({id = id})
        dialog:addChild(tips, 200)
        tips.setClickBlankHandler(function()
          tips:removeFromParent()
          dialog.board.tipsTag = false
            end)
      end
      end)
  end
  backBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    dialog:removeFromParentAndCleanup()
   end)
  return dialog
end

local createBag = function()
  local layer = CCLayer:create()
  ui.equiptr = showtr()
  local outerBg = img.createUI9Sprite(img.ui.bag_outer)
  outerBg:setPreferredSize(CCSizeMake(426, 474))
  outerBg:setAnchorPoint(0, 0)
  outerBg:setScale(view.minScale)
  outerBg:setPosition(scalep(482, 39))
  layer:addChild(outerBg)
  local boardSize = outerBg:getContentSize()
  local innerBg = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  innerBg:setPreferredSize(CCSizeMake(375, 416))
  innerBg:setScale(view.minScale)
  innerBg:setAnchorPoint(0, 1)
  innerBg:setPosition(scalep(510, 486))
  layer:addChild(innerBg)
  local GRID_SCREEN = 12
  local GRID_COLUMN = 4
  local GRID_WIDTH = 76
  local GRID_HEIGHT = 76
  local GAP_HORIZONTAL = 8
  local GAP_VERTICAL = 8
  local MARGIN_TOP = 14
  local MARGIN_BOTTOM = 14
  local MARGIN_LEFT = 28
  local VIEW_WIDTH = innerBg:getContentSize().width
  local VIEW_HEIGHT = 314
  local VIEW_HEIGHT_NORMAL = 352
  local VIEW_HEIGHT_SMALL = 382
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(0, 0)
  innerBg:addChild(scroll)
  layer.scroll = scroll
  local icons = {}
  layer.icons = icons
  local getPosition = function(l_1_0, l_1_1)
    local x0 = MARGIN_LEFT - 5
    local y0 = scroll:getContentSize().height - MARGIN_TOP - GRID_HEIGHT + 8
    local x = x0 + math.floor((l_1_0 - 1) % GRID_COLUMN) * (GRID_WIDTH + GAP_HORIZONTAL)
    local y = y0
    y = y0 - math.floor((l_1_0 - 1) / GRID_COLUMN) * (GRID_HEIGHT + GAP_VERTICAL)
    return x, y
   end
  local initScroll = function(l_2_0, l_2_1)
    if l_2_0 < GRID_SCREEN then
      l_2_0 = GRID_SCREEN
    end
    for i,_ in pairs(icons) do
      if icons[i].gridSelected then
        icons[i].gridSelected:removeFromParent()
        icons[i].gridSelected = nil
      end
      icons[i]:removeFromParent()
      icons[i] = nil
    end
    local rownum = math.ceil(l_2_0 / GRID_COLUMN)
    local height = rownum * 86
    local contentOffsetY = scroll:getContentOffset().y
    local viewHeight = nil
    viewHeight = VIEW_HEIGHT_SMALL
    scroll:setPosition(0, 14)
    if not l_2_1 then
      contentOffsetY = viewHeight - height
    elseif contentOffsetY > 0 then
      contentOffsetY = 0
    elseif contentOffsetY < viewHeight - height then
      contentOffsetY = viewHeight - height
    end
    scroll:setViewSize(CCSize(VIEW_WIDTH, viewHeight))
    scroll:setContentSize(CCSize(VIEW_WIDTH, height))
    scroll:setContentOffset(ccp(0, contentOffsetY))
   end
  local addFunctionsForIcon = function(l_3_0, l_3_1, l_3_2)
    l_3_0.isGridSelected = function()
      return (icon.gridSelected ~= nil and icon.gridSelected:isVisible())
      end
    l_3_0.setGridSelected = function(l_2_0)
      if icon.gridSelected == nil then
        icon.gridSelected = img.createUISprite(img.ui.bag_grid_selected)
        icon.gridSelected:setAnchorPoint(ccp(0, 0))
        icon.gridSelected:setScale(0.9)
        local x, y = icons[i]:getPosition()
        icon.gridSelected:setPosition(x, y)
        local gridSelectedBatch = img.createBatchNodeForUI(img.ui.bag_grid_selected)
        scroll:getContainer():addChild(gridSelectedBatch, 4)
        gridSelectedBatch:addChild(icon.gridSelected)
      end
      icon.gridSelected:setVisible(l_2_0)
      end
   end
  layer.showEquips = function(l_4_0, l_4_1)
    table.sort(l_4_0, compareEquip)
    initScroll(#l_4_0, l_4_1)
    for i,eq in ipairs(l_4_0) do
      local x, y = getPosition(i, kind)
      icons[i] = img.createEquip(eq.id, eq.num)
      icons[i]:setScale(0.9)
      icons[i]:setAnchorPoint(ccp(0, 0))
      icons[i]:setPosition(x, y)
      icons[i].data = eq
      icons[i].tipTag = false
      scroll:getContainer():addChild(icons[i], 3)
      addFunctionsForIcon(icons[i], i, kind)
      if #l_4_0 - 4 < i then
        y = y + 412 + 56
      end
      if #l_4_0 - 4 < i then
        y = y - 412 - 56
      end
    end
   end
  layer.showEquips(ui.equiptr)
  local clickHandler = nil
  layer.setClickHandler = function(l_5_0)
    clickHandler = l_5_0
   end
  local touchbeginx, touchbeginy, isclick, touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil, nil, nil, nil
  local onTouchBegan = function(l_6_0, l_6_1)
    touchbeginx, upvalue_512 = l_6_0, l_6_1
    upvalue_1024 = true
    local p0 = scroll:getContainer():convertToNodeSpace(ccp(l_6_0, l_6_1))
    for _,icon in ipairs(icons) do
      if p0 and icon:boundingBox():containsPoint(p0) then
        return true
      end
    end
    return true
   end
  local onTouchMoved = function(l_7_0, l_7_1)
    if isclick and (math.abs(touchbeginx - l_7_0) > 10 or math.abs(touchbeginy - l_7_1) > 10) then
      isclick = false
    end
   end
  local onTouchEnded = function(l_8_0, l_8_1)
    if isclick then
      local p0 = (scroll:getContainer():convertToNodeSpace(ccp(l_8_0, l_8_1)))
      local p1 = nil
      if #icons > 0 then
        p1 = icons[1]:getParent():convertToNodeSpace(ccp(l_8_0, l_8_1))
      end
      for _,icon in ipairs(icons) do
        if p1 and icon:boundingBox():containsPoint(p1) then
          for __,ic in ipairs(icons) do
            if ic.isGridSelected() then
              ic.setGridSelected(false)
            end
          end
          icon.setGridSelected(true)
          layer.ID = _
          if clickHandler then
            clickHandler(icon)
          end
          return 
        end
      end
    end
   end
  local onTouch = function(l_9_0, l_9_1, l_9_2)
    if l_9_0 == "began" then
      return onTouchBegan(l_9_1, l_9_2)
    elseif l_9_0 == "moved" then
      return onTouchMoved(l_9_1, l_9_2)
    else
      return onTouchEnded(l_9_1, l_9_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  layer:setTouchEnabled(true)
  return layer
end

ui.create = function(l_4_0, l_4_1)
  local id = l_4_0.id
  local hid = nil
  if l_4_0.owner then
    hid = l_4_0.owner.hid
  end
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local exp = 0
  local clickID, clickNUM = nil, nil
  local hidsid = {}
  local hidscount = {}
  local hidsbagid = {}
  local showTre = {}
  local outerBg = img.createUI9Sprite(img.ui.bag_outer)
  outerBg:setPreferredSize(CCSizeMake(432, 338))
  outerBg:setAnchorPoint(0, 0)
  outerBg:setScale(view.minScale)
  outerBg:setPosition(scalep(50, 39))
  layer:addChild(outerBg, 1)
  local boardSize = outerBg:getContentSize()
  local lefBoard = img.createUI9Sprite(img.ui.hero_treasure_board)
  lefBoard:setPreferredSize(CCSizeMake(464, 319))
  lefBoard:setAnchorPoint(ccp(0.5, 0))
  lefBoard:setPosition(outerBg:getContentSize().width / 2, 170)
  outerBg:addChild(lefBoard, 1)
  local showTitle = lbl.createFont2(22, i18n.global.treasure_levelUp_title.string, ccc3(246, 215, 113))
  showTitle:setPosition(lefBoard:getContentSize().width / 2, 294)
  lefBoard:addChild(showTitle)
  local powerBar = img.createUISprite(img.ui.treasure_bar_0)
  powerBar:setPosition(lefBoard:getContentSize().width / 2, 114)
  lefBoard:addChild(powerBar)
  local progress0 = img.createUISprite(img.ui.treasure_bar_1)
  local powerProgress = createProgressBar(progress0)
  powerProgress:setPosition(powerBar:getContentSize().width / 2, powerBar:getContentSize().height / 2 + 1)
  powerProgress:setPercentage(exp / cfgequip[id].treasureUpg * 100)
  powerBar:addChild(powerProgress)
  local progressStr = string.format("%d/%d", exp, cfgequip[id].treasureUpg)
  local progressLabel = lbl.createFont2(16, progressStr, ccc3(255, 246, 223))
  progressLabel:setPosition(CCPoint(powerBar:getContentSize().width / 2, powerBar:getContentSize().height / 2 + 5))
  powerBar:addChild(progressLabel)
  local tipsTag = false
  local texiaoFlag = false
  json.load(json.ui.baowu_line)
  local lineani = nil
  local uplef = function()
    local leflayer = CCLayer:create()
    local icon1 = img.createEquip(id)
    local itemBtn1 = SpineMenuItem:create(json.ui.button, icon1)
    itemBtn1:setPosition(135, 180)
    local iconMenu = CCMenu:createWithItem(itemBtn1)
    iconMenu:setPosition(0, 0)
    leflayer:addChild(iconMenu)
    itemBtn1:registerScriptTapHandler(function()
      audio.play(audio.button)
      if tipsTag == false then
        upvalue_512 = true
        local tips = tipsequip.createForShow({id = id})
        do
          layer:addChild(tips, 10001)
          tips.setClickBlankHandler(function()
            tips:removeFromParent()
            upvalue_512 = false
               end)
        end
      end
      end)
    local raw = img.createUISprite(img.ui.arrow)
    raw:setPosition(lefBoard:getContentSize().width / 2, 180)
    lefBoard:addChild(raw)
    if cfgequip[id].treasureNext then
      local icon2 = img.createEquip(cfgequip[id].treasureNext)
      local itemBtn2 = SpineMenuItem:create(json.ui.button, icon2)
      itemBtn2:setPosition(325, 180)
      local iconMenu2 = CCMenu:createWithItem(itemBtn2)
      iconMenu2:setPosition(0, 0)
      leflayer:addChild(iconMenu2)
      itemBtn2:registerScriptTapHandler(function()
        audio.play(audio.button)
        if tipsTag == false then
          upvalue_512 = true
          local tips = tipsequip.createForShow({id = cfgequip[id].treasureNext})
          do
            layer:addChild(tips, 10001)
            tips.setClickBlankHandler(function()
              tips:removeFromParent()
              upvalue_512 = false
                  end)
          end
        end
         end)
    end
    for i = 1, 4 do
      if showTre[i] then
        showTre[i]:removeFromParent()
        showTre[i] = nil
        if hidscount[i] then
          hidsid[i] = nil
          hidscount[i] = nil
          hidsbagid[i] = nil
        end
      end
    end
    return leflayer
   end
  local leflayer = uplef()
  lefBoard:addChild(leflayer)
  local baglayer, onSelect = nil, nil
  local upgradesprit = img.createLogin9Sprite(img.login.button_9_small_green)
  upgradesprit:setPreferredSize(CCSize(174, 50))
  local upgradeInfo = SpineMenuItem:create(json.ui.button, upgradesprit)
  upgradeInfo:setPosition(lefBoard:getContentSize().width / 2, 64)
  local declab1 = lbl.createFont1(16, i18n.global.hero_title_exp.string, ccc3(27, 89, 2))
  declab1:setPosition(CCPoint(upgradesprit:getContentSize().width / 2, upgradesprit:getContentSize().height / 2))
  upgradesprit:addChild(declab1)
  local menuInfo = CCMenu:createWithItem(upgradeInfo)
  menuInfo:setPosition(0, 0)
  lefBoard:addChild(menuInfo, 100)
  upgradeInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    if exp < cfgequip[id].treasureUpg then
      showToast(i18n.global.treasure_no_enough_exp.string)
      return 
    end
    local tritems = {}
    for i = 1, #hidsid do
      local pitem = {}
      if hidscount[i] ~= nil then
        pitem.id = hidsid[i]
        pitem.num = hidscount[i]
        tritems[#tritems + 1] = pitem
      end
    end
    local param = {}
    param.sid = player.sid
    param.id = id
    param.source = tritems
    if hid then
      param.hid = hid
    end
    tbl2string(param)
    addWaitNet()
    net:up_treasure(param, function(l_1_0)
      tbl2string(l_1_0)
      delWaitNet()
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      if hid == nil then
        bag.equips.sub({id = id, num = 1})
      end
      do
        for i = 1, #param.source do
          bag.equips.sub(param.source[i])
        end
      end
      if l_1_0.over ~= 0 then
        bag.equips.add({id = 5000, num = l_1_0.over})
        local ban = CCLayer:create()
        ban:setTouchEnabled(true)
        ban:setTouchSwallowEnabled(true)
        layer:addChild(ban, 1000)
        schedule(layer, 1, function()
          ban:removeFromParent()
          local pop = createPopupPieceBatchSummonResult("equip", 5000, __data.over)
          layer:addChild(pop, 100)
            end)
      end
      json.load(json.ui.baowu_upgrade)
      local lefupgrade = DHSkeletonAnimation:createWithKey(json.ui.baowu_upgrade)
      lefupgrade:playAnimation("animation")
      lefupgrade:scheduleUpdateLua()
      lefupgrade:setPosition(135, 138)
      lefBoard:addChild(lefupgrade, 1000)
      json.load(json.ui.baowu_upgrade2)
      local rigupgrade = DHSkeletonAnimation:createWithKey(json.ui.baowu_upgrade2)
      rigupgrade:playAnimation("animation")
      rigupgrade:scheduleUpdateLua()
      rigupgrade:setPosition(325, 138)
      lefBoard:addChild(rigupgrade, 1000)
      lineani:removeFromParent()
      upvalue_5120 = false
      local pid = id
      upvalue_1536 = cfgequip[id].treasureNext
      bag.equips.add({id = id, num = 1})
      if hid then
        onWear(id, EQUIP_POS_TREASURE, false, function()
        bag.equips.sub({id = pid, num = 1})
        if cfgequip[id].treasureNext then
          leflayer:removeFromParentAndCleanup(true)
          upvalue_2048 = nil
          upvalue_2048 = uplef()
          lefBoard:addChild(leflayer)
          upvalue_3584 = 0
          progressLabel:setString(string.format("%d/%d", exp, cfgequip[id].treasureUpg))
          powerProgress:setPercentage(exp / cfgequip[id].treasureUpg * 100)
          baglayer:removeFromParentAndCleanup(true)
          upvalue_5120 = nil
          upvalue_5120 = createBag()
          baglayer:setPosition(0, 0)
          layer:addChild(baglayer)
          baglayer.setClickHandler(function(l_1_0)
            clickID = l_1_0.data.id
            upvalue_512 = l_1_0.data.num
            local onPutOne = function(...)
              if clickNUM >= 1 then
                clickNUM = clickNUM - 1
                onSelect(clickID, 1)
                 -- DECOMPILER ERROR: Confused about usage of registers for local variables.

              end
                  end
            local onPutTen = function(...)
              if clickNUM >= 1 then
                if clickNUM >= 10 then
                  onSelect(clickID, 10)
                  clickNUM = clickNUM - 10
                else
                  onSelect(clickID, clickNUM)
                  clickNUM = 0
                   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

                end
              end
                  end
            local tipsTreasureLevelUp = require("ui.tips.equip").createForTreasureLevelUp(l_1_0.data, onPutOne, onPutTen)
            layer:addChild(tipsTreasureLevelUp, 10000)
               end)
        else
          local reward = require("ui.reward")
          layer:getParent():addChild(reward.showRewardFortreasure({id = id, num = 1}), 10001)
          schedule(layer, 0.5, function()
            layer:removeFromParentAndCleanup()
               end)
        end
         end)
      end
      end)
   end)
  local declab = lbl.createMixFont1(16, i18n.global.treasure_levelUp_material_hint.string, ccc3(93, 43, 15))
  declab:setPosition(CCPoint(outerBg:getContentSize().width / 2, 144))
  outerBg:addChild(declab)
  local treasureGrid = {}
  local treasures = {}
  for i = 1, 4 do
    treasureGrid[i] = img.createUISprite(img.ui.grid)
    treasureGrid[i]:setPosition(75 + (i - 1) * 94, 84)
    outerBg:addChild(treasureGrid[i])
    treasureGrid[i].flag = false
  end
  baglayer = createBag(false)
  baglayer:setPosition(0, 0)
  layer:addChild(baglayer)
  local backEvent = function()
    layer:removeFromParentAndCleanup()
   end
  local close0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, close0)
  closeBtn:setScale(view.minScale)
  closeBtn:setPosition(scalep(884, 490))
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  layer:addChild(closeMenu, 1)
  closeBtn:registerScriptTapHandler(function()
    backEvent()
   end)
  local upbag = function()
    baglayer.showEquips(ui.equiptr)
   end
  onSelect = function(l_6_0, l_6_1, l_6_2)
    do
      for i = 1, 4 do
        do
          if not hidscount[i] or hidscount[i] == 0 then
            hidscount[i] = l_6_1
            hidsid[i] = l_6_0
            hidsbagid[i] = baglayer.ID
            local showitem = img.createEquip(l_6_0, hidscount[i])
            showTre[i] = SpineMenuItem:create(json.ui.button, showitem)
            showTre[i]:setPosition(treasureGrid[i]:getPositionX(), treasureGrid[i]:getPositionY())
            local itemMenu = CCMenu:createWithItem(showTre[i])
            itemMenu:setPosition(0, 0)
            outerBg:addChild(itemMenu)
            showTre[i].bagid = baglayer.ID
            showTre[i]:registerScriptTapHandler(function()
              audio.play(audio.button)
              showTre[i]:removeFromParent()
              showTre[i] = nil
              upvalue_1536 = exp - hidscount[i] * cfgequip[treaid].treasureExp
              progressLabel:setString(string.format("%d/%d", exp, cfgequip[id].treasureUpg))
              powerProgress:setPercentage(exp / cfgequip[id].treasureUpg * 100)
              if exp < cfgequip[id].treasureUpg and texiaoFlag == true then
                lineani:removeFromParent()
                upvalue_5120 = false
              end
              ui.equiptr[hidsbagid[i]].num = ui.equiptr[hidsbagid[i]].num + hidscount[i]
              upbag()
              hidsid[i] = nil
              hidscount[i] = nil
              hidsbagid[i] = nil
                  end)
            upvalue_5120 = exp + l_6_1 * cfgequip[l_6_0].treasureExp
            progressLabel:setString(string.format("%d/%d", exp, cfgequip[id].treasureUpg))
            powerProgress:setPercentage(exp / cfgequip[id].treasureUpg * 100)
            if cfgequip[id].treasureUpg <= exp and texiaoFlag == false then
              upvalue_8192 = DHSkeletonAnimation:createWithKey(json.ui.baowu_line)
              lineani:playAnimation("animation", -1)
              lineani:scheduleUpdateLua()
              lineani:setPosition(powerBar:getContentSize().width / 2, powerBar:getContentSize().height / 2 + 1)
              powerBar:addChild(lineani)
              upvalue_7680 = true
            end
            ui.equiptr[hidsbagid[i]].num = ui.equiptr[hidsbagid[i]].num - l_6_1
            upbag()
            do return end
          else
            if hidsid[i] == l_6_0 then
              hidscount[i] = hidscount[i] + l_6_1
              hidsbagid[i] = baglayer.ID
              showTre[i]:removeFromParent()
              showTre[i] = nil
              local showitem = img.createEquip(l_6_0, hidscount[i])
              showTre[i] = SpineMenuItem:create(json.ui.button, showitem)
              showTre[i]:setPosition(treasureGrid[i]:getPositionX(), treasureGrid[i]:getPositionY())
              local itemMenu = CCMenu:createWithItem(showTre[i])
              itemMenu:setPosition(0, 0)
              outerBg:addChild(itemMenu)
              showTre[i].bagid = baglayer.ID
              showTre[i]:registerScriptTapHandler(function()
                audio.play(audio.button)
                showTre[i]:removeFromParent()
                showTre[i] = nil
                upvalue_1536 = exp - hidscount[i] * cfgequip[treaid].treasureExp
                progressLabel:setString(string.format("%d/%d", exp, cfgequip[id].treasureUpg))
                powerProgress:setPercentage(exp / cfgequip[id].treasureUpg * 100)
                if exp < cfgequip[id].treasureUpg and texiaoFlag == true then
                  lineani:removeFromParent()
                  upvalue_5120 = false
                end
                ui.equiptr[hidsbagid[i]].num = ui.equiptr[hidsbagid[i]].num + hidscount[i]
                upbag()
                hidsid[i] = nil
                hidscount[i] = nil
                hidsbagid[i] = nil
                     end)
              upvalue_5120 = exp + l_6_1 * cfgequip[l_6_0].treasureExp
              progressLabel:setString(string.format("%d/%d", exp, cfgequip[id].treasureUpg))
              powerProgress:setPercentage(exp / cfgequip[id].treasureUpg * 100)
              if cfgequip[id].treasureUpg <= exp and texiaoFlag == false then
                upvalue_8192 = DHSkeletonAnimation:createWithKey(json.ui.baowu_line)
                lineani:playAnimation("animation", -1)
                lineani:scheduleUpdateLua()
                lineani:setPosition(powerBar:getContentSize().width / 2, powerBar:getContentSize().height / 2 + 1)
                powerBar:addChild(lineani)
                upvalue_7680 = true
              end
              ui.equiptr[hidsbagid[i]].num = ui.equiptr[hidsbagid[i]].num - l_6_1
              upbag()
          else
            end
          end
        end
      end
    end
   end
  baglayer.setClickHandler(function(l_7_0)
    clickID = l_7_0.data.id
    upvalue_512 = l_7_0.data.num
    local onPutOne = function(...)
      if clickNUM >= 1 then
        clickNUM = clickNUM - 1
        onSelect(clickID, 1)
         -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end
      end
    local onPutTen = function(...)
      if clickNUM >= 1 then
        if clickNUM >= 10 then
          onSelect(clickID, 10)
          clickNUM = clickNUM - 10
        else
          onSelect(clickID, clickNUM)
          clickNUM = 0
           -- DECOMPILER ERROR: Confused about usage of registers for local variables.

        end
      end
      end
    local tipsTreasureLevelUp = require("ui.tips.equip").createForTreasureLevelUp(l_7_0.data, onPutOne, onPutTen)
    layer:addChild(tipsTreasureLevelUp, 10000)
   end)
  layer.onAndroidBack = function()
    backEvent()
   end
  addBackEvent(layer)
  local onEnter = function()
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_11_0)
    if l_11_0 == "enter" then
      onEnter()
    elseif l_11_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

