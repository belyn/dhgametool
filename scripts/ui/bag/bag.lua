-- Command line was: E:\github\dhgametool\scripts\ui\bag\bag.lua 

local bag = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local cfgequip = require("config.equip")
local cfgitem = require("config.item")
local i18n = require("res.i18n")
local empty = require("ui.empty")
bag.create = function()
  local layer = CCLayer:create()
  local outerBg = img.createUI9Sprite(img.ui.bag_outer)
  outerBg:setPreferredSize(CCSizeMake(838, 502))
  outerBg:setAnchorPoint(0.5, 1)
  outerBg:setScale(view.minScale)
  outerBg:setPosition(scalep(480, 520))
  layer:addChild(outerBg)
  local innerBg = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  innerBg:setPreferredSize(CCSizeMake(780, 404))
  innerBg:setScale(view.minScale)
  innerBg:setAnchorPoint(0.5, 1)
  innerBg:setPosition(scalep(480, 498))
  layer:addChild(innerBg)
  local GRID_SCREEN = 32
  local GRID_COLUMN = 8
  local GRID_WIDTH = 84
  local GRID_HEIGHT = 84
  local GAP_HORIZONTAL = 7
  local GAP_VERTICAL = 7
  local MARGIN_TOP = 14
  local MARGIN_BOTTOM = 14
  local MARGIN_LEFT = 28
  local VIEW_WIDTH = innerBg:getContentSize().width
  local VIEW_HEIGHT = 382
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(0, 0)
  scroll:setPosition(0, 12)
  scroll:setViewSize(CCSize(VIEW_WIDTH, VIEW_HEIGHT))
  innerBg:addChild(scroll)
  layer.scroll = scroll
  local grids = {}
  local icons = {}
  local qlts = {}
  layer.grids = grids
  layer.icons = icons
  layer.qlts = qlts
  layer.emptyBox = nil
  local getPosition = function(l_1_0, l_1_1)
    local x0 = MARGIN_LEFT
    local y0 = scroll:getContentSize().height - MARGIN_TOP - GRID_HEIGHT
    local x = x0 + math.floor((l_1_0 - 1) % GRID_COLUMN) * (GRID_WIDTH + GAP_HORIZONTAL)
    local y = y0
    if l_1_1 ~= 1 then
      y = y - math.floor((l_1_0 - 1) / GRID_COLUMN) * (GRID_HEIGHT + GAP_VERTICAL)
    else
      y = y - math.floor((l_1_0 - 1) / GRID_COLUMN) * (GRID_HEIGHT + GAP_VERTICAL + 34)
    end
    return x, y
   end
  local initScroll = function(l_2_0, l_2_1, l_2_2)
    local pieceheight = 0
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if l_2_1 ~= "piece" and l_2_0 < 32 then
      l_2_0 = 32
      do return end
      if l_2_0 < 24 then
        l_2_0 = 24
      end
      pieceheight = 36
    end
    for i,_ in pairs(icons) do
      if icons[i].gridSelected then
        icons[i].gridSelected:removeFromParent()
      end
      if icons[i].qlts then
        icons[i].qlts:removeFromParent()
      end
      icons[i].currentbag = nil
      icons[i]:removeFromParent()
      icons[i].gridSelected = nil
      icons[i].qlts = nil
      icons[i] = nil
    end
    if layer.emptyBox then
      layer.emptyBox:removeFromParent()
      layer.emptyBox = nil
    end
    local rownum = math.ceil(l_2_0 / GRID_COLUMN)
    local height = MARGIN_TOP + MARGIN_BOTTOM + rownum * GRID_HEIGHT + (rownum - 1) * (pieceheight + GAP_VERTICAL)
    local contentOffsetY = scroll:getContentOffset().y
    if not l_2_2 then
      contentOffsetY = VIEW_HEIGHT - height
    elseif contentOffsetY > 0 then
      contentOffsetY = 0
    else
      if contentOffsetY < VIEW_HEIGHT - height then
        contentOffsetY = VIEW_HEIGHT - height
      end
    end
    scroll:setContentSize(CCSize(VIEW_WIDTH, height))
    scroll:setContentOffset(ccp(0, contentOffsetY))
   end
  local initGrids = function(l_3_0, l_3_1)
   end
  local addFunctionsForIcon = function(l_4_0, l_4_1)
    l_4_0.isGridSelected = function()
      return (icon.gridSelected ~= nil and icon.gridSelected:isVisible())
      end
    l_4_0.setGridSelected = function(l_2_0)
      if icon.gridSelected == nil then
        icon.gridSelected = img.createUISprite(img.ui.bag_grid_selected)
        icon.gridSelected:setAnchorPoint(ccp(0, 0))
        if icons[i].currentbag == "equip" then
          local x, y = icons[i]:getPosition()
          icon.gridSelected:setPosition(x, y)
        else
          if icons[i].currentbag == "item" then
            icon.gridSelected:setPosition(icons[i]:getPosition())
          else
            icon.gridSelected:setPosition(icons[i]:getPosition())
          end
        end
        local gridSelectedBatch = img.createBatchNodeForUI(img.ui.bag_grid_selected)
        scroll:getContainer():addChild(gridSelectedBatch)
        gridSelectedBatch:addChild(icon.gridSelected)
      end
      icon.gridSelected:setVisible(l_2_0)
      end
   end
  layer.showEquips = function(l_5_0, l_5_1)
    table.sort(l_5_0, compareEquip)
    initScroll(#l_5_0, "equip", l_5_1)
    if #l_5_0 == 0 then
      layer.emptyBox = empty.create({text = i18n.global.empty_equips.string})
      layer.emptyBox:setPosition(innerBg:getContentSize().width / 2, innerBg:getContentSize().height / 2)
      innerBg:addChild(layer.emptyBox)
      return 
    end
    for i,eq in ipairs(l_5_0) do
      local x, y = getPosition(i, 0)
      icons[i] = img.createEquip(eq.id, eq.num)
      icons[i]:setAnchorPoint(ccp(0, 0))
      icons[i]:setPosition(x, y)
      icons[i].data = eq
      icons[i].tipTag = false
      scroll:getContainer():addChild(icons[i])
      icons[i].currentbag = "equip"
      addFunctionsForIcon(icons[i], i)
    end
   end
  layer.showItems = function(l_6_0, l_6_1)
    table.sort(l_6_0, compareItem)
    initScroll(#l_6_0, "item", l_6_1)
    if #l_6_0 == 0 then
      layer.emptyBox = empty.create({text = i18n.global.empty_items.string})
      layer.emptyBox:setPosition(innerBg:getContentSize().width / 2, innerBg:getContentSize().height / 2)
      innerBg:addChild(layer.emptyBox)
      return 
    end
    for i,item in ipairs(l_6_0) do
      local x, y = getPosition(i, 0)
      icons[i] = img.createItem(item.id, item.num)
      icons[i]:setAnchorPoint(ccp(0, 0))
      icons[i]:setPosition(x, y)
      icons[i].data = item
      scroll:getContainer():addChild(icons[i])
      icons[i].currentbag = "item"
      addFunctionsForIcon(icons[i], i)
    end
   end
  layer.showPieces = function(l_7_0)
    table.sort(l_7_0, compareHeroPiece)
    initScroll(#l_7_0, "piece")
    if #l_7_0 == 0 then
      layer.emptyBox = empty.create({text = i18n.global.empty_pieces.string})
      layer.emptyBox:setPosition(innerBg:getContentSize().width / 2, innerBg:getContentSize().height / 2)
      innerBg:addChild(layer.emptyBox)
      return 
    end
    for i,piece in ipairs(l_7_0) do
      local x, y = getPosition(i, 1)
      icons[i] = img.createItem(piece.id)
      icons[i]:setAnchorPoint(ccp(0, 0))
      icons[i]:setPosition(x, y)
      icons[i].data = piece
      scroll:getContainer():addChild(icons[i])
      icons[i].currentbag = "pieces"
      local progressBg = img.createUISprite(img.ui.bag_heropiece_progr)
      progressBg:setPosition(41, -10)
      icons[i]:addChild(progressBg)
      local costCount = 1
      if cfgitem[piece.id].type == ITEM_KIND_TREASURE_PIECE then
        costCount = cfgitem[piece.id].treasureCost.count
      else
        costCount = cfgitem[piece.id].heroCost.count
      end
      local progressFgSprite = nil
      if piece.num < costCount then
        progressFgSprite = img.createUISprite(img.ui.bag_heropiece_progr_0)
      else
        progressFgSprite = img.createUISprite(img.ui.bag_heropiece_progr_1)
      end
      local progressFg = createProgressBar(progressFgSprite)
      progressFg:setPosition(41, -10)
      progressFg:setPercentage(piece.num / costCount * 100)
      icons[i]:addChild(progressFg)
      local str = string.format("%d/%d", piece.num, costCount)
      local label = lbl.createFont2(14, str, ccc3(255, 246, 223))
      label:setPosition(41, -11)
      icons[i]:addChild(label)
      addFunctionsForIcon(icons[i], i)
    end
   end
  layer.showTreasure = function(l_8_0)
    table.sort(l_8_0, function(l_1_0, l_1_1)
      local quality1, quality2 = cfgequip[l_1_0.id].qlt, cfgequip[l_1_1.id].qlt
      if quality2 < quality1 then
        return true
      elseif quality1 < quality2 then
        return false
      end
      return l_1_0.id < l_1_1.id
      end)
    initScroll(#l_8_0, "treasure")
    if #l_8_0 == 0 then
      layer.emptyBox = empty.create({text = i18n.global.empty_treasure.string})
      layer.emptyBox:setPosition(innerBg:getContentSize().width / 2, innerBg:getContentSize().height / 2)
      innerBg:addChild(layer.emptyBox)
      return 
    end
    for i,treasure in ipairs(l_8_0) do
      local x, y = getPosition(i, 0)
      icons[i] = img.createEquip(treasure.id, treasure.num)
      icons[i]:setAnchorPoint(ccp(0, 0))
      icons[i]:setPosition(x, y)
      icons[i].data = treasure
      scroll:getContainer():addChild(icons[i])
      icons[i].currentbag = "treasure"
      if cfgitem[treasure.id] then
        local progressBg = img.createUISprite(img.ui.bag_heropiece_progr)
        progressBg:setPosition(41, -10)
        icons[i]:addChild(progressBg)
        local costCount = cfgitem[treasure.id].treasureCost.count
        local progressFgSprite = nil
        if treasure.num < costCount then
          progressFgSprite = img.createUISprite(img.ui.bag_heropiece_progr_0)
        else
          progressFgSprite = img.createUISprite(img.ui.bag_heropiece_progr_1)
        end
        local progressFg = createProgressBar(progressFgSprite)
        progressFg:setPosition(41, -10)
        progressFg:setPercentage(treasure.num / costCount * 100)
        icons[i]:addChild(progressFg)
        local str = string.format("%d/%d", treasure.num, costCount)
        local label = lbl.createFont2(14, str, ccc3(255, 246, 223))
        label:setPosition(41, -11)
        icons[i]:addChild(label)
      end
      addFunctionsForIcon(icons[i], i)
    end
   end
  local clickHandler = nil
  layer.setClickHandler = function(l_9_0)
    clickHandler = l_9_0
   end
  local touchbeginx, touchbeginy, isclick = nil, nil, nil
  local onTouchBegan = function(l_10_0, l_10_1)
    touchbeginx, upvalue_512 = l_10_0, l_10_1
    upvalue_1024 = true
    return true
   end
  local onTouchMoved = function(l_11_0, l_11_1)
    if isclick and (math.abs(touchbeginx - l_11_0) > 10 or math.abs(touchbeginy - l_11_1) > 10) then
      isclick = false
    end
   end
  local onTouchEnded = function(l_12_0, l_12_1)
    if isclick then
      local p0 = scroll:getParent():convertToNodeSpace(ccp(l_12_0, l_12_1))
      if scroll:getBoundingBox():containsPoint(p0) then
        local p1 = nil
        if #icons > 0 then
          p1 = icons[1]:getParent():convertToNodeSpace(ccp(l_12_0, l_12_1))
        end
        for _,icon in ipairs(icons) do
          if p1 and icon:boundingBox():containsPoint(p1) then
            for _,ic in ipairs(icons) do
              if ic.isGridSelected() then
                ic.setGridSelected(false)
              end
            end
            icon.setGridSelected(true)
            if clickHandler then
              clickHandler(icon)
            end
            return 
          end
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
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  addBackEvent(layer)
  local onEnter = function()
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  layer:registerScriptHandler(function(l_17_0)
    if l_17_0 == "enter" then
      onEnter()
    elseif l_17_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return bag

