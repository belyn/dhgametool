-- Command line was: E:\github\dhgametool\scripts\ui\smith\main.lua 

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
local MAX_DECOMPOSE = 4
local equipformulas = {}
local equipSuitFormulas = {}
ui.equipformulas = equipformulas
ui.equipSuitFormulas = equipSuitFormulas
local kind = "forge"
local currentForge = 1
local createPopupPieceBatchSummonResult = function(l_1_0, l_1_1, l_1_2)
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
  if l_1_0 == "item" then
    local item = img.createItem(l_1_1, l_1_2)
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
    local equip = img.createEquip(l_1_1)
    equipBtn = SpineMenuItem:create(json.ui.button, equip)
    equipBtn:setScale(0.85)
    equipBtn:setPosition(dialog.board:getContentSize().width / 2, 185)
    local iconMenu = CCMenu:createWithItem(equipBtn)
    iconMenu:setPosition(0, 0)
    dialog.board:addChild(iconMenu)
    local countLbl = lbl.createFont2(20, string.format("X%d", l_1_2), ccc3(255, 246, 223))
    countLbl:setAnchorPoint(ccp(0, 0.5))
    countLbl:setPosition(equipBtn:boundingBox():getMaxX() + 10, 185)
    dialog.board:addChild(countLbl)
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

equipformulas.init = function()
  equipformulas = {}
  for i = 1, 65000 do
    if cfgequip[i] and cfgequip[i].needFormula then
      equipformulas[ equipformulas + 1] = {id = i}
    end
  end
end

local createScrolls = function(l_3_0)
  local scrolls = {}
  for i,t in ipairs(equipformulas) do
    if l_3_0 == 0 or l_3_0 == cfgequip[t.id].pos then
      scrolls[ scrolls + 1] = {id = t.id}
    end
  end
  return scrolls
end

local createBag = function()
  local layer = CCLayer:create()
  layer.data = equipformulas[1]
  local outerBg = img.createUI9Sprite(img.ui.bag_outer)
  outerBg:setPreferredSize(CCSizeMake(432, 480))
  outerBg:setAnchorPoint(0, 0)
  outerBg:setScale(view.minScale)
  outerBg:setPosition(scalep(477, 16))
  layer:addChild(outerBg)
  local boardSize = outerBg:getContentSize()
  local innerBg = img.createUI9Sprite(img.ui.bag_inner)
  innerBg:setPreferredSize(CCSizeMake(382, 410))
  innerBg:setScale(view.minScale)
  innerBg:setAnchorPoint(0, 1)
  innerBg:setPosition(scalep(500, 456))
  layer:addChild(innerBg)
  local GRID_SCREEN = 12
  local GRID_COLUMN = 4
  local GRID_WIDTH = 76
  local GRID_HEIGHT = 76
  local GAP_HORIZONTAL = 10
  local GAP_VERTICAL = 10
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
  local grids = {}
  local icons = {}
  local borders = {}
  layer.grids = grids
  layer.icons = icons
  layer.borders = borders
  local getPosition = function(l_1_0, l_1_1)
    local x0 = MARGIN_LEFT - 3
    local y0 = scroll:getContentSize().height - MARGIN_TOP - GRID_HEIGHT + 3
    local x = x0 + math.floor((l_1_0 - 1) % GRID_COLUMN) * (GRID_WIDTH + GAP_HORIZONTAL)
    local y = y0
    y = y0 - math.floor((l_1_0 - 1) / GRID_COLUMN) * (GRID_HEIGHT + GAP_VERTICAL)
    return x, y
   end
  local getForgePosition = function(l_2_0)
    local x0 = MARGIN_LEFT + 2
    local y0 = scroll:getContentSize().height + 5
    local x, y = nil, nil
    if l_2_0 <= 3 then
      x = x0 + (GRID_WIDTH + GAP_HORIZONTAL) * 1.5
      y = y0 - l_2_0 * (GRID_HEIGHT + GAP_VERTICAL + 10)
      return x, y
    end
    l_2_0 = l_2_0 - 3
    y0 = y0 - 4 * (GRID_HEIGHT + GAP_VERTICAL + 10) - 25
    x = x0 + math.floor((l_2_0 - 1) % GRID_COLUMN) * (GRID_WIDTH + GAP_HORIZONTAL)
    y = y0 - math.floor((l_2_0 - 1) / GRID_COLUMN) * (GRID_HEIGHT + GAP_VERTICAL + 10)
    return x, y
   end
  local getborderPosition = function(l_3_0, l_3_1)
    local x0 = MARGIN_LEFT - 10
    local y0 = scroll:getContentSize().height - MARGIN_TOP - 135
    local x = x0
    local y = y0 - (l_3_0 - 1) * 145
    return x, y
   end
  local initScroll = function(l_4_0, l_4_1, l_4_2)
    if l_4_1 < GRID_SCREEN then
      l_4_1 = GRID_SCREEN
    end
    for i,_ in pairs(icons) do
      if icons[i].gridSelected then
        icons[i].gridSelected:removeFromParent()
        icons[i].gridSelected = nil
      end
      if icons[i].redIcon then
        icons[i].redIcon:removeFromParent()
        icons[i].redIcon = nil
      end
      icons[i]:removeFromParent()
      icons[i] = nil
    end
    local rownum = math.ceil(l_4_1 / GRID_COLUMN)
    local height = rownum * 86
    local contentOffsetY = scroll:getContentOffset().y
    local viewHeight = nil
    viewHeight = VIEW_HEIGHT_SMALL
    scroll:setPosition(0, 14)
    if not l_4_2 then
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
  local initGrids = function(l_5_0, l_5_1)
    for i = 1,  borders do
      borders[i]:removeFromParent()
      borders[i] = nil
    end
   end
  local addFunctionsForIcon = function(l_6_0, l_6_1, l_6_2)
    l_6_0.isGridSelected = function()
      return (icon.gridSelected ~= nil and icon.gridSelected:isVisible())
      end
    l_6_0.setGridSelected = function(l_2_0)
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
  layer.showEquips = function(l_7_0, l_7_1, l_7_2)
    initScroll(l_7_0,  l_7_1, l_7_2)
    initGrids( l_7_1, l_7_0)
    for i,eq in ipairs(l_7_1) do
      local x, y = getPosition(i, l_7_0)
      icons[i] = img.createEquip(eq.id)
      icons[i]:setScale(0.9)
      icons[i]:setAnchorPoint(ccp(0, 0))
      icons[i]:setPosition(x, y)
      icons[i].data = eq
      icons[i].tipTag = false
      scroll:getContainer():addChild(icons[i], 3)
      addFunctionsForIcon(icons[i], i, l_7_0)
      if  l_7_1 - 4 < i then
        y = y + 412 + 56
      end
      if  l_7_1 - 4 < i then
        y = y - 412 - 56
      end
      local redIcon = img.createUISprite(img.ui.main_red_dot)
      redIcon:setPosition(x + 70, y + 70)
      scroll:getContainer():addChild(redIcon, 100)
      icons[i].redIcon = redIcon
      icons[i].redIcon:setVisible(false)
      if cfgequip[eq.id].needFormula[1].count <= bagdata.equips.count(cfgequip[eq.id].needFormula[1].id) then
        icons[i].redIcon:setVisible(true)
      end
    end
   end
  layer.showItems = function(l_8_0, l_8_1, l_8_2)
    table.sort(l_8_1, compareItem)
    initScroll(l_8_0,  l_8_1, l_8_2)
    initGrids( l_8_1, l_8_0)
    for i,item in ipairs(l_8_1) do
      local x, y = getPosition(i, l_8_0)
      icons[i] = img.createItem(item.id, item.num)
      icons[i]:setAnchorPoint(ccp(0, 0))
      icons[i]:setPosition(x, y)
      icons[i].data = item
      scroll:getContainer():addChild(icons[i])
      addFunctionsForIcon(icons[i], i, l_8_0)
    end
   end
  local clickHandler = nil
  layer.setClickHandler = function(l_9_0)
    clickHandler = l_9_0
   end
  local touchbeginx, touchbeginy, isclick, touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil, nil, nil, nil
  local onTouchBegan = function(l_10_0, l_10_1)
    touchbeginx, upvalue_512 = l_10_0, l_10_1
    upvalue_1024 = true
    local p0 = scroll:getContainer():convertToNodeSpace(ccp(l_10_0, l_10_1))
    for _,icon in ipairs(icons) do
      if p0 and icon:boundingBox():containsPoint(p0) then
        return true
      end
    end
    return true
   end
  local onTouchMoved = function(l_11_0, l_11_1)
    if isclick and (math.abs(touchbeginx - l_11_0) > 10 or math.abs(touchbeginy - l_11_1) > 10) then
      isclick = false
    end
   end
  local onTouchEnded = function(l_12_0, l_12_1)
    if isclick then
      local p0 = (scroll:getContainer():convertToNodeSpace(ccp(l_12_0, l_12_1)))
      local p1 = nil
      if  icons > 0 then
        p1 = icons[1]:getParent():convertToNodeSpace(ccp(l_12_0, l_12_1))
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
  local onTouch = function(l_13_0, l_13_1, l_13_2)
    if l_13_0 == "began" then
      return onTouchBegan(l_13_1, l_13_2)
    elseif l_13_0 == "moved" then
      return onTouchMoved(l_13_1, l_13_2)
    else
      return onTouchEnded(l_13_1, l_13_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  layer:setTouchEnabled(true)
  return layer
end

local createForgeLayer = function(l_5_0, l_5_1)
  local layer = CCLayer:create()
  json.load(json.ui.blacksmith)
  local aniSmith = DHSkeletonAnimation:createWithKey(json.ui.blacksmith)
  aniSmith:setScale(view.minScale)
  aniSmith:scheduleUpdateLua()
  aniSmith:playAnimation("begin")
  aniSmith:setPosition(scalep(480, 288))
  layer.aniSmith = aniSmith
  layer:addChild(aniSmith)
  local leftFrame = img.createUISprite(img.ui.smith_bottom)
  aniSmith:addChildFollowSlot("backplane", leftFrame)
  local forgeBoard = img.createUISprite(img.ui.smith_forge_board)
  forgeBoard:setPosition(225, 323)
  leftFrame:addChild(forgeBoard)
  local costCoinBg = img.createUISprite(img.ui.smith_resourse_trough)
  costCoinBg:setPosition(CCPoint(292, 141))
  leftFrame:addChild(costCoinBg)
  local iconCostCoin = img.createItemIcon2(ITEM_ID_COIN)
  iconCostCoin:setPosition(CCPoint(8, costCoinBg:getContentSize().height / 2))
  costCoinBg:addChild(iconCostCoin)
  local costCoinnum = 0
  local costCoinLab = lbl.createFont2(16, num2KM(costCoinnum), ccc3(255, 246, 223))
  costCoinLab:setPosition(CCPoint(costCoinBg:getContentSize().width / 2, costCoinBg:getContentSize().height / 2))
  costCoinBg:addChild(costCoinLab)
  local coin_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  coin_bg:setPreferredSize(CCSizeMake(174, 40))
  coin_bg:setScale(view.minScale)
  coin_bg:setAnchorPoint(CCPoint(0, 0.5))
  coin_bg:setPosition(scalep(156, 480))
  layer:addChild(coin_bg)
  local icon_coin = img.createItemIcon2(ITEM_ID_COIN)
  icon_coin:setPosition(CCPoint(5, coin_bg:getContentSize().height / 2 + 2))
  coin_bg:addChild(icon_coin)
  local coin_num = bagdata.coin()
  local lbl_coin = lbl.createFont2(16, num2KM(coin_num), ccc3(255, 246, 223))
  lbl_coin:setPosition(CCPoint(coin_bg:getContentSize().width / 2, coin_bg:getContentSize().height / 2 + 2))
  coin_bg:addChild(lbl_coin)
  local updatePay = nil
  local firstForge = false
  local batchForge = function()
    local mergeMaxequip = math.floor(bagdata.equips.count(layer.icon.data.id) / layer.icon.data.num)
    local edit0 = img.createLogin9Sprite(img.login.input_border)
    layer.icon.edit = CCEditBox:create(CCSizeMake(118 * view.minScale, 40 * view.minScale), edit0)
    layer.icon.edit:setInputMode(kEditBoxInputModeNumeric)
    layer.icon.edit:setReturnType(kKeyboardReturnTypeDone)
    layer.icon.edit:setMaxLength(5)
    layer.icon.edit:setFont("", 20 * view.minScale)
    layer.icon.edit:setText(string.format("%d", mergeMaxequip))
    layer.icon.edit:setFontColor(ccc3(148, 98, 66))
    layer.icon.edit:setPosition(scalep(241, 222))
    layer:addChild(layer.icon.edit)
    local editlbl = createEditLbl(118, 40)
    editlbl.lbl:setColor(ccc3(148, 98, 66))
    editlbl.lbl:setString(string.format("%d", mergeMaxequip))
    editlbl:setScale(view.minScale)
    editlbl:setPosition(scalep(241, 222))
    layer:addChild(editlbl, 100)
    local btn_sub0 = img.createUISprite(img.ui.btn_sub)
    local btn_sub = SpineMenuItem:create(json.ui.button, btn_sub0)
    btn_sub:setScale(view.minScale)
    btn_sub:setPosition(scalep(155, 222))
    layer.icon.btn_sub_menu = CCMenu:createWithItem(btn_sub)
    layer.icon.btn_sub_menu:setPosition(CCPoint(0, 0))
    layer:addChild(layer.icon.btn_sub_menu)
    local btn_add0 = img.createUISprite(img.ui.btn_add)
    local btn_add = SpineMenuItem:create(json.ui.button, btn_add0)
    btn_add:setScale(view.minScale)
    btn_add:setPosition(scalep(329, 222))
    layer.icon.btn_add_menu = CCMenu:createWithItem(btn_add)
    layer.icon.btn_add_menu:setPosition(CCPoint(0, 0))
    layer:addChild(layer.icon.btn_add_menu)
    if firstForge == false then
      layer.icon.edit:setVisible(false)
      layer.icon.btn_add_menu:setVisible(false)
      layer.icon.btn_sub_menu:setVisible(false)
      editlbl:setVisible(false)
      upvalue_2560 = true
      schedule(layer, 0.6, function()
        layer.icon.edit:setVisible(true)
        layer.icon.btn_add_menu:setVisible(true)
        layer.icon.btn_sub_menu:setVisible(true)
        editlbl:setVisible(true)
         end)
    end
    upvalue_3072 = function(l_2_0)
      layer.icon.progressFg:setPercentage((l_2_0 * layer.icon.data.num + bagdata.equips.count(layer.icon.data.id) % layer.icon.data.num) / layer.icon.data.num * 100)
      local iconnum = layer.icon.data.num * l_2_0
      iconnum = iconnum + bagdata.equips.count(layer.icon.data.id) % layer.icon.data.num
      layer.icon.label:setString(string.format("%d/%d", iconnum, layer.icon.data.num))
      costCoinLab.num = layer.icon.goldMat * l_2_0
      costCoinLab:setString(num2KM(costCoinLab.num))
      editlbl.lbl:setString(l_2_0 .. "")
      editlbl:setVisible(true)
      end
    local edit_chips = layer.icon.edit
    edit_chips:registerScriptEditBoxHandler(function(l_3_0)
      if l_3_0 == "returnSend" then
        do return end
      end
      if l_3_0 == "return" then
        do return end
      end
      if l_3_0 == "ended" then
        local tmp_chip_count = edit_chips:getText()
        tmp_chip_count = string.trim(tmp_chip_count)
        tmp_chip_count = checkint(tmp_chip_count)
        if tmp_chip_count <= 0 then
          tmp_chip_count = 0
        else
          if math.floor(bagdata.equips.count(layer.icon.data.id) / layer.icon.data.num) < tmp_chip_count then
            tmp_chip_count = math.floor(bagdata.equips.count(layer.icon.data.id) / layer.icon.data.num)
          end
        end
        edit_chips:setText(tmp_chip_count)
        updatePay(tmp_chip_count)
      elseif l_3_0 == "began" then
        editlbl.lbl:setString("")
        editlbl:setVisible(false)
      elseif l_3_0 == "changed" then
         -- Warning: missing end command somewhere! Added here
      end
      end)
    btn_sub:registerScriptTapHandler(function()
      audio.play(audio.button)
      local edt_txt = edit_chips:getText()
      edt_txt = string.trim(edt_txt)
      if edt_txt == "" then
        edt_txt = 0
        edit_chips:setText(0)
        updatePay(0)
        return 
      end
      local chip_count = checkint(edt_txt)
      if chip_count <= 0 then
        edit_chips:setText(0)
        updatePay(0)
        return 
      else
        chip_count = chip_count - 1
        edit_chips:setText(chip_count)
        updatePay(chip_count)
      end
      end)
    btn_add:registerScriptTapHandler(function()
      audio.play(audio.button)
      local edt_txt = edit_chips:getText()
      edt_txt = string.trim(edt_txt)
      if edt_txt == "" then
        edt_txt = 0
        edit_chips:setText(0)
        updatePay(0)
        return 
      end
      local chip_count = checkint(edt_txt)
      if chip_count < 0 then
        edit_chips:setText(0)
        updatePay(0)
        return 
      else
        if math.floor(bagdata.equips.count(layer.icon.data.id) / layer.icon.data.num) <= chip_count then
          return 
        else
          chip_count = chip_count + 1
          edit_chips:setText(chip_count)
          updatePay(chip_count)
        end
      end
      end)
   end
  local compoydBtn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  compoydBtn0:setPreferredSize(CCSizeMake(153, 60))
  local compoydBtnLab = lbl.createFont1(18, i18n.global.smith_breakdown.string, ccc3(115, 59, 5))
  compoydBtnLab:setPosition(CCPoint(compoydBtn0:getContentSize().width / 2, compoydBtn0:getContentSize().height / 2))
  compoydBtn0:addChild(compoydBtnLab)
  local compoydBtn = SpineMenuItem:create(json.ui.button, compoydBtn0)
  compoydBtn:setPosition(CCPoint(292, 80))
  local compoydMenu = CCMenu:createWithItem(compoydBtn)
  compoydMenu:ignoreAnchorPointForPosition(false)
  leftFrame:addChild(compoydMenu)
  compoydBtn:registerScriptTapHandler(function()
    audio.play(audio.smith_forge)
    if layer.icon == nil then
      showToast(i18n.global.smith_scroll_put_in.string)
      return 
    end
    if bagdata.coin() < costCoinLab.num then
      showToast(i18n.global.blackmarket_coin_lack.string)
      return 
    end
    if bagdata.equips.count(layer.icon.data.id) < layer.icon.data.num then
      showToast(i18n.global.smith_no_enough.string)
      return 
    end
    if checkint(layer.icon.edit:getText()) == 0 then
      showToast(i18n.global.smith_forge_notzero.string)
      return 
    end
    local param = {}
    param.sid = player.sid
    param.id = bag.data.id
    param.num = checkint(layer.icon.edit:getText())
    addWaitNet()
    net:equip_merge(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      bagdata.subCoin(costCoinLab.num)
      lbl_coin:setString(num2KM(bagdata.coin()))
      local needFormulanum = param.num * cfgequip[bag.data.id].needFormula[1].count
      bagdata.equips.sub({id = layer.icon.data.id, num = needFormulanum})
      bagdata.equips.add({id = bag.data.id, num = param.num})
      local task = require("data.task")
      task.increment(task.TaskType.FORGE, param.num)
      local chipnum = math.floor(bagdata.equips.count(layer.icon.data.id) / layer.icon.data.num)
      layer.icon.edit:setText(chipnum)
      updatePay(chipnum)
      json.load(json.ui.tiejiangpu_shengji_fx)
      local aniSmithShengji = DHSkeletonAnimation:createWithKey(json.ui.tiejiangpu_shengji_fx)
      aniSmithShengji:scheduleUpdateLua()
      aniSmithShengji:playAnimation("animation")
      aniSmithShengji:setPosition(CCPoint(110, 117))
      leftFrame:addChild(aniSmithShengji)
      json.load(json.ui.blacksmith_hecheng)
      local aniSmithHecheng = DHSkeletonAnimation:createWithKey(json.ui.blacksmith_hecheng)
      aniSmithHecheng:scheduleUpdateLua()
      aniSmithHecheng:playAnimation("hecheng")
      aniSmithHecheng:setScale(view.minScale)
      aniSmithHecheng:setPosition(scalep(480, 288))
      layer:addChild(aniSmithHecheng)
      schedule(layer, 1.5, function()
        local pop = createPopupPieceBatchSummonResult("equip", bag.data.id, param.num)
        layer:addChild(pop, 100)
        if bagdata.equips.count(layer.icon.data.id) < layer.icon.data.num then
          bag.redIcon:setVisible(false)
        end
        if bag.icons[bag.ID + 1] then
          local needFormulaId = cfgequip[bag.icons[bag.ID + 1].data.id].needFormula[1].id
          local needFormulaNum = cfgequip[bag.icons[bag.ID + 1].data.id].needFormula[1].count
          if needFormulaNum <= bagdata.equips.count(needFormulaId) then
            bag.icons[bag.ID + 1].redIcon:setVisible(true)
          end
        end
        if player.lv() <= 40 then
          checkReddot()
        end
        aniSmithHecheng:removeFromParent()
         end)
      do
        local ban = CCLayer:create()
        ban:setTouchEnabled(true)
        ban:setTouchSwallowEnabled(true)
        layer:addChild(ban, 1000)
        layer:runAction(createSequence({}))
      end
       -- Warning: undefined locals caused missing assignments!
      end)
   end)
  layer.init = function()
    if layer.icon then
      layer.icon.edit:removeFromParent()
      layer.icon.edit = nil
      layer.icon.btn_sub_menu:removeFromParent()
      layer.icon.btn_sub_menu = nil
      layer.icon.btn_add_menu:removeFromParent()
      layer.icon.btn_add_menu = nil
      layer.icon.formulamenu:removeFromParent()
      layer.icon.formulamenu = nil
      layer.icon.formulaIcon = nil
      layer.icon.menu:removeFromParent()
      layer.icon.menu = nil
      layer.icon.data = nil
      layer.icon = nil
    end
    costCoinLab.num = 0
    costCoinLab:setString(num2KM(costCoinLab.num))
   end
  layer.putScroll = function(l_4_0, l_4_1)
    layer.init()
    local icon = img.createEquip(l_4_0.id)
    layer.icon = CCMenuItemSprite:create(icon, nil)
    layer.icon:setScale(0.85)
    layer.icon:setPosition(CCPoint(112, 122))
    layer.icon.data = l_4_0
    layer.icon.goldMat = l_4_1
    layer.icon.menu = CCMenu:createWithItem(layer.icon)
    layer.icon.menu:setPosition(0, 0)
    leftFrame:addChild(layer.icon.menu)
    local progressBg = img.createUISprite(img.ui.bag_heropiece_progr)
    progressBg:setPosition(43, -27)
    layer.icon:addChild(progressBg)
    local progressFgSprite = nil
    local equipmatNum = math.floor(bagdata.equips.count(l_4_0.id) / l_4_0.num) * l_4_0.num
    layer.equipmatNum = equipmatNum
    if bagdata.equips.count(l_4_0.id) < l_4_0.num then
      progressFgSprite = img.createUISprite(img.ui.bag_heropiece_progr_0)
    else
      progressFgSprite = img.createUISprite(img.ui.bag_heropiece_progr_1)
    end
    local progressFg = createProgressBar(progressFgSprite)
    progressFg:setPosition(43, -27)
    progressFg:setPercentage(bagdata.equips.count(l_4_0.id) / l_4_0.num * 100)
    layer.icon:addChild(progressFg)
    layer.icon.progressFg = progressFg
    local str = string.format("%d/%d", bagdata.equips.count(l_4_0.id), l_4_0.num)
    local label = lbl.createFont2(14, str, ccc3(255, 246, 223))
    label:setPosition(43, -28)
    layer.icon:addChild(label)
    layer.icon.label = label
    costCoinLab.num = l_4_1 * math.floor(bagdata.equips.count(l_4_0.id) / l_4_0.num)
    costCoinLab:setString(num2KM(costCoinLab.num))
    local formulaIcon = img.createEquip(bag.data.id)
    layer.icon.formulaIcon = CCMenuItemSprite:create(formulaIcon, nil)
    layer.icon.formulaIcon:setPosition(225, 323)
    layer.icon.formulamenu = CCMenu:createWithItem(layer.icon.formulaIcon)
    layer.icon.formulamenu:setPosition(0, 0)
    leftFrame:addChild(layer.icon.formulamenu)
    layer.icon:registerScriptTapHandler(function()
      if not layer.tipsTag then
        layer.tipsTag = true
        layer.tips = tipsequip.createForSmith({id = equip.id})
        layer:addChild(layer.tips, 100)
        layer.tips.setClickBlankHandler(function()
          layer.tips:removeFromParent()
          layer.tipsTag = false
            end)
      end
      audio.play(audio.button)
      end)
    layer.icon.formulaIcon:registerScriptTapHandler(function()
      if not layer.tipsTag then
        layer.tipsTag = true
        layer.tips = tipsequip.createForShow({id = bag.data.id})
        layer:addChild(layer.tips, 100)
        layer.tips.setClickBlankHandler(function()
          layer.tips:removeFromParent()
          layer.tipsTag = false
            end)
      end
      audio.play(audio.button)
      end)
    batchForge()
   end
  return layer
end

ui.create = function(l_6_0)
  local layer = CCLayer:create()
  img.load(img.packedOthers.spine_ui_blacksmith_1)
  img.load(img.packedOthers.spine_ui_blacksmith_2)
  img.load(img.packedOthers.ui_smith_bg)
  img.load(img.packedOthers.ui_smith)
  upvalue_512 = 1
  local bg = img.createUISprite(img.ui.smith_bg)
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
  json.load(json.ui.blacksmith)
  local aniSmith = DHSkeletonAnimation:createWithKey(json.ui.blacksmith)
  aniSmith:setScale(view.minScale)
  aniSmith:scheduleUpdateLua()
  aniSmith:playAnimation("background", -1)
  aniSmith:setPosition(scalep(480, 288))
  layer:addChild(aniSmith)
  local bag = createBag()
  bag:setPosition(0, 0)
  layer:addChild(bag)
  local roof = img.createUISprite(img.ui.smith_roof)
  roof:setScaleX(view.physical.w / roof:getContentSize().width)
  roof:setScaleY(view.minScale)
  roof:setAnchorPoint(CCPoint(0.5, 1))
  roof:setPosition(scalep(480, 576))
  layer:addChild(roof, 20)
  local titleLbl = lbl.createFont2(24, i18n.global.smith_title_upgrade.string, ccc3(255, 251, 188), view.minScale)
  titleLbl:setPosition(scalep(480, 556))
  layer:addChild(titleLbl, 20)
  autoLayoutShift(roof, true, false, false, false)
  autoLayoutShift(titleLbl)
  local weaponTab0 = img.createUISprite(img.ui.smith_weapon0)
  weaponTab1 = img.createUISprite(img.ui.smith_weapon0)
  weaponTab2 = img.createUISprite(img.ui.smith_weapon1)
  local weaponTab = CCMenuItemSprite:create(weaponTab0, weaponTab1, weaponTab2)
  weaponTab:setScale(view.minScale)
  weaponTab:setPosition(scalep(916, 390))
  weaponTab:setEnabled(false)
  addRedDot(weaponTab, {px = weaponTab:getContentSize().width - 10, py = weaponTab:getContentSize().height - 10})
  delRedDot(weaponTab)
  local weaponMenu = CCMenu:createWithItem(weaponTab)
  weaponMenu:setPosition(0, 0)
  layer:addChild(weaponMenu, 3)
  local armourTab0 = img.createUISprite(img.ui.smith_armour0)
  armourTab1 = img.createUISprite(img.ui.smith_armour0)
  armourTab2 = img.createUISprite(img.ui.smith_armour1)
  local armourTab = CCMenuItemSprite:create(armourTab0, armourTab1, armourTab2)
  armourTab:setScale(view.minScale)
  armourTab:setPosition(scalep(916, 300))
  addRedDot(armourTab, {px = armourTab:getContentSize().width - 10, py = armourTab:getContentSize().height - 10})
  delRedDot(armourTab)
  local armourMenu = CCMenu:createWithItem(armourTab)
  armourMenu:setPosition(0, 0)
  layer:addChild(armourMenu, 3)
  local shoeTab0 = img.createUISprite(img.ui.smith_shoe0)
  shoeTab1 = img.createUISprite(img.ui.smith_shoe0)
  shoeTab2 = img.createUISprite(img.ui.smith_shoe1)
  local shoeTab = CCMenuItemSprite:create(shoeTab0, shoeTab1, shoeTab2)
  shoeTab:setScale(view.minScale)
  shoeTab:setPosition(scalep(916, 210))
  addRedDot(shoeTab, {px = shoeTab:getContentSize().width - 10, py = shoeTab:getContentSize().height - 10})
  delRedDot(shoeTab)
  local shoeMenu = CCMenu:createWithItem(shoeTab)
  shoeMenu:setPosition(0, 0)
  layer:addChild(shoeMenu, 3)
  local jewelryTab0 = img.createUISprite(img.ui.smith_jewelry0)
  jewelryTab1 = img.createUISprite(img.ui.smith_jewelry0)
  jewelryTab2 = img.createUISprite(img.ui.smith_jewelry1)
  local jewelryTab = CCMenuItemSprite:create(jewelryTab0, jewelryTab1, jewelryTab2)
  jewelryTab:setScale(view.minScale)
  jewelryTab:setPosition(scalep(916, 120))
  addRedDot(jewelryTab, {px = jewelryTab:getContentSize().width - 10, py = jewelryTab:getContentSize().height - 10})
  delRedDot(jewelryTab)
  local jewelryMenu = CCMenu:createWithItem(jewelryTab)
  jewelryMenu:setPosition(0, 0)
  layer:addChild(jewelryMenu, 3)
  local checkReddot = function()
    for _ = 1, 4 do
      local equips = createScrolls(_)
      local redflag = false
      for i,eq in ipairs(equips) do
        if cfgequip[eq.id].needFormula[1].count <= bagdata.equips.count(cfgequip[eq.id].needFormula[1].id) then
          redflag = true
      else
        end
      end
      if redflag == true then
        if _ == 1 then
          addRedDot(weaponTab, {px = weaponTab:getContentSize().width - 10, py = weaponTab:getContentSize().height - 10})
        elseif _ == 2 then
          addRedDot(armourTab, {px = armourTab:getContentSize().width - 10, py = armourTab:getContentSize().height - 10})
        elseif _ == 3 then
          addRedDot(jewelryTab, {px = jewelryTab:getContentSize().width - 10, py = jewelryTab:getContentSize().height - 10})
        else
          addRedDot(shoeTab, {px = shoeTab:getContentSize().width - 10, py = shoeTab:getContentSize().height - 10})
        end
      elseif _ == 1 then
        delRedDot(weaponTab)
      elseif _ == 2 then
        delRedDot(armourTab)
      elseif _ == 3 then
        delRedDot(jewelryTab)
      else
        delRedDot(shoeTab)
      end
    end
   end
  local forgeLayer = createForgeLayer(bag, checkReddot)
  forgeLayer:setPosition(0, 0)
  layer:addChild(forgeLayer, 10)
  if player.lv() <= 40 then
    checkReddot()
  end
  local onForgeFilter = function()
    local equips = createScrolls(currentForge)
    bag.showEquips(kind, equips)
    local equipMat = {id = cfgequip[bag.icons[1].data.id].needFormula[1].id, num = cfgequip[bag.icons[1].data.id].needFormula[1].count}
    local goldMat = cfgequip[bag.icons[1].data.id].needFormula[1].gold
    bag.data = bag.icons[1].data
    bag.redIcon = bag.icons[1].redIcon
    forgeLayer.putScroll(equipMat, goldMat)
    bag.icons[1].setGridSelected(true)
    bag.ID = 1
   end
  weaponTab:registerScriptTapHandler(function()
    audio.play(audio.button)
    upvalue_512 = 1
    weaponTab:setEnabled(false)
    armourTab:setEnabled(true)
    shoeTab:setEnabled(true)
    jewelryTab:setEnabled(true)
    onForgeFilter()
   end)
  armourTab:registerScriptTapHandler(function()
    audio.play(audio.button)
    upvalue_512 = 2
    weaponTab:setEnabled(true)
    armourTab:setEnabled(false)
    shoeTab:setEnabled(true)
    jewelryTab:setEnabled(true)
    onForgeFilter()
   end)
  shoeTab:registerScriptTapHandler(function()
    audio.play(audio.button)
    upvalue_512 = 4
    weaponTab:setEnabled(true)
    armourTab:setEnabled(true)
    shoeTab:setEnabled(false)
    jewelryTab:setEnabled(true)
    onForgeFilter()
   end)
  jewelryTab:registerScriptTapHandler(function()
    audio.play(audio.button)
    upvalue_512 = 3
    weaponTab:setEnabled(true)
    armourTab:setEnabled(true)
    shoeTab:setEnabled(true)
    jewelryTab:setEnabled(false)
    onForgeFilter()
   end)
  local forgeLab = lbl.createMixFont1(14, i18n.global.smith_forge_prompt.string, ccc3(115, 59, 5), view.minScale)
  forgeLab:setPosition(scalep(688, 471))
  layer:addChild(forgeLab)
  local showSmith = function()
    bag.showEquips(kind, createScrolls(currentForge))
    local equipMat = {id = cfgequip[bag.icons[1].data.id].needFormula[1].id, num = cfgequip[bag.icons[1].data.id].needFormula[1].count}
    local goldMat = cfgequip[bag.icons[1].data.id].needFormula[1].gold
    bag.data = bag.icons[1].data
    bag.redIcon = bag.icons[1].redIcon
    forgeLayer.putScroll(equipMat, goldMat)
    bag.icons[1].setGridSelected(true)
    bag.ID = 1
   end
  local detailSprite = img.createUISprite(img.ui.btn_help)
  local detailBtn = SpineMenuItem:create(json.ui.button, detailSprite)
  detailBtn:setScale(view.minScale)
  detailBtn:setPosition(scalep(930, 549))
  local detailMenu = CCMenu:create()
  detailMenu:setPosition(0, 0)
  layer:addChild(detailMenu, 20)
  detailMenu:addChild(detailBtn)
  detailBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.help").create(i18n.global.help_smith.string), 1000)
   end)
  autoLayoutShift(detailBtn)
  local back0 = img.createUISprite(img.ui.back)
  local backBtn = HHMenuItem:create(back0)
  backBtn:setScale(view.minScale)
  backBtn:setPosition(scalep(35, 546))
  local backMenu = CCMenu:createWithItem(backBtn)
  backMenu:setPosition(0, 0)
  layer:addChild(backMenu, 20)
  local backEvent = function()
    audio.play(audio.button)
    if uiParams and uiParams.from_layer == "task" then
      replaceScene(require("ui.town.main").create({from_layer = "task"}))
    else
      replaceScene(require("ui.town.main").create())
    end
   end
  backBtn:registerScriptTapHandler(function()
    backEvent()
   end)
  autoLayoutShift(backBtn)
  bag.setClickHandler(function(l_11_0)
    if layer.tipsTag then
      return 
    end
    audio.play(audio.button)
    local datas = {}
    for i,_ in ipairs(bag.icons) do
      datas[i] = _.data
    end
    bag.data = l_11_0.data
    bag.redIcon = l_11_0.redIcon
    local equipMat = {id = cfgequip[l_11_0.data.id].needFormula[1].id, num = cfgequip[l_11_0.data.id].needFormula[1].count}
    local goldMat = cfgequip[l_11_0.data.id].needFormula[1].gold
    forgeLayer.putScroll(equipMat, goldMat)
   end)
  layer.onAndroidBack = function()
    backEvent()
   end
  addBackEvent(layer)
  local onEnter = function()
    layer.notifyParentLock()
    showSmith()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_15_0)
    if l_15_0 == "enter" then
      onEnter()
    elseif l_15_0 == "exit" then
      onExit()
    elseif l_15_0 == "cleanup" then
      img.unload(img.packedOthers.spine_ui_blacksmith_1)
      img.unload(img.packedOthers.spine_ui_blacksmith_2)
      img.unload(img.packedOthers.ui_smith_bg)
      img.unload(img.packedOthers.ui_smith)
    end
   end)
  return layer
end

return ui

