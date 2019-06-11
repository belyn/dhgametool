-- Command line was: E:\github\dhgametool\scripts\ui\braveshop\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local player = require("data.player")
local bag = require("data.bag")
local databraveshop = require("data.braveshop")
local cfgbraveshop = require("config.bravemarket")
local cfgequip = require("config.equip")
local cfgitem = require("config.item")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
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
    local equip = img.createEquip(l_1_1, l_1_2)
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

ui.create = function()
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  img.load(img.packedOthers.ui_brave)
  local isBuy = {}
  local itemBg = {}
  local setAlreadyBuy, createItemWithPos = nil, nil
  local currentPage = 1
  local maxPage = math.floor((#cfgbraveshop - 1) / 8) + 1
  local board = img.createUISprite(img.ui.shop_board)
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY - 30 * view.minScale)
  layer:addChild(board)
  local boardtop = img.createUISprite(img.ui.brave_shop_top)
  boardtop:setPosition(415, 462)
  board:addChild(boardtop)
  board:setScale(0.1 * view.minScale)
  board:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  local lCoinBg = img.createUI9Sprite(img.ui.main_coin_bg)
  lCoinBg:setPreferredSize(CCSizeMake(174, 40))
  lCoinBg:setPosition(412, 505)
  board:addChild(lCoinBg, 5)
  local lcoinIcon = img.createItemIcon(ITEM_ID_BRAVE)
  lcoinIcon:setScale(0.517)
  lcoinIcon:setPosition(CCPoint(5, lCoinBg:getContentSize().height / 2 + 2))
  lCoinBg:addChild(lcoinIcon)
  local lCoin = bag.items.find(ITEM_ID_BRAVE)
  local lCoinLab = lbl.createFont2(16, lCoin.num, ccc3(255, 246, 223))
  lCoinLab:setPosition(CCPoint(lCoinBg:getContentSize().width / 2, lCoinBg:getContentSize().height / 2 + 2))
  lCoinBg:addChild(lCoinLab)
  local showItemLayer = CCLayer:create()
  board:addChild(showItemLayer)
  local createlist = function(l_1_0)
    if showItemLayer and not tolua.isnull(showItemLayer) then
      showItemLayer:removeAllChildrenWithCleanup(true)
    end
    for i = (l_1_0 - 1) * 8 + 1, l_1_0 * 8 do
      if #databraveshop.goods < i then
        return 
      end
      if cfgbraveshop[databraveshop.goods[i].id].limitNumb and cfgbraveshop[databraveshop.goods[i].id].limitNumb <= databraveshop.goods[i].num then
        isBuy[i] = true
      else
        isBuy[i] = false
      end
      itemBg[i] = createItemWithPos(databraveshop.goods[i], i)
      if cfgbraveshop[databraveshop.goods[i].id].limitNumb and cfgbraveshop[databraveshop.goods[i].id].limitNumb <= databraveshop.goods[i].num then
        setAlreadyBuy(i)
      end
    end
   end
  setAlreadyBuy = function(l_2_0)
    setShader(itemBg[l_2_0], SHADER_GRAY, true)
    itemBg[l_2_0]:setEnabled(false)
    local soldout = img.createUISprite(img.ui.blackmarket_soldout)
    soldout:setPosition(CCPoint(itemBg[l_2_0]:getContentSize().width / 2, itemBg[l_2_0]:getContentSize().height / 2))
    itemBg[l_2_0]:addChild(soldout)
   end
  local ITEM_POS = {1 = {175, 340}, 2 = {335, 340}, 3 = {495, 340}, 4 = {655, 340}, 5 = {175, 175}, 6 = {335, 175}, 7 = {495, 175}, 8 = {655, 175}}
  createItemWithPos = function(l_3_0, l_3_1)
    local item, icon, cost = nil, nil, nil
    local showpos = (l_3_1 - 1) % 8 + 1
    local itemFrame = img.createUISprite(img.ui.casino_shop_frame)
    itemFrame:setPosition(ITEM_POS[showpos][1], ITEM_POS[showpos][2])
    showItemLayer:addChild(itemFrame)
    local menuBg = CCMenu:create()
    menuBg:setPosition(0, 0)
    showItemLayer:addChild(menuBg)
    if cfgbraveshop[l_3_0.id].goods[1].type == 1 then
      item = img.createItem(cfgbraveshop[l_3_0.id].goods[1].id, cfgbraveshop[l_3_0.id].goods[1].num)
    else
      item = img.createEquip(cfgbraveshop[l_3_0.id].goods[1].id, cfgbraveshop[l_3_0.id].goods[1].num)
    end
    local itemBg = SpineMenuItem:create(json.ui.button, item)
    itemBg:setPosition(ITEM_POS[showpos][1], ITEM_POS[showpos][2] + 8)
    menuBg:addChild(itemBg)
    icon = img.createItemIcon(ITEM_ID_BRAVE)
    icon:setScale(0.379)
    cost = cfgbraveshop[l_3_0.id].cost
    local menuBuy = CCMenu:create()
    menuBuy:setPosition(0, 0)
    showItemLayer:addChild(menuBuy)
    local buyBtnSprite = img.createUISprite(img.ui.casino_shop_btn)
    local buyBtn = SpineMenuItem:create(json.ui.button, buyBtnSprite)
    buyBtn:setPosition(ITEM_POS[showpos][1], ITEM_POS[showpos][2] - 58)
    buyBtn:setEnabled(isBuy[l_3_1] == false)
    menuBuy:addChild(buyBtn)
    if isBuy[l_3_1] then
      setShader(buyBtn, SHADER_GRAY, true)
    end
    icon:setAnchorPoint(ccp(0, 0.5))
    icon:setPosition(15, buyBtnSprite:getContentSize().height / 2)
    buyBtnSprite:addChild(icon)
    local costLabel = lbl.createFont2(16, string.format("%d", cost), ccc3(255, 246, 223))
    local x = (buyBtn:getContentSize().width - icon:boundingBox():getMaxX()) / 2
    costLabel:setAnchorPoint(0, 0.5)
    costLabel:setPosition(icon:boundingBox():getMaxX() + 3, buyBtnSprite:getContentSize().height / 2)
    buyBtnSprite:addChild(costLabel)
    layer.tipsTag = false
    itemBg:registerScriptTapHandler(function()
      audio.play(audio.button)
      local tips = nil
      local pbdata = {}
      if layer.tipsTag == false then
        layer.tipsTag = true
        if cfgbraveshop[iteminfo.id].goods[1].type == 1 then
          pbdata.id = cfgbraveshop[iteminfo.id].goods[1].id
          tips = tipsitem.createForShow(pbdata)
        else
          if cfgbraveshop[iteminfo.id].goods[1].type == 2 then
            pbdata.id = cfgbraveshop[iteminfo.id].goods[1].id
            tips = tipsequip.createForShow(pbdata)
          end
        end
        layer:addChild(tips, 200)
        tips.setClickBlankHandler(function()
          tips:removeFromParent()
          layer.tipsTag = false
            end)
      end
      end)
    buyBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if lCoin.num < cost then
        showToast(i18n.global.brave_shop_coin_lack.string)
        return 
      end
      local param = {}
      param.sid = player.sid
      param.id = pos
      addWaitNet()
      net:brave_market_buy(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        if cfgbraveshop[iteminfo.id].goods[1].type == 1 then
          bag.items.add({id = cfgbraveshop[iteminfo.id].goods[1].id, num = cfgbraveshop[iteminfo.id].goods[1].num})
          local pop = createPopupPieceBatchSummonResult("item", cfgbraveshop[iteminfo.id].goods[1].id, cfgbraveshop[iteminfo.id].goods[1].num)
          layer:addChild(pop, 100)
        else
          bag.equips.add({id = cfgbraveshop[iteminfo.id].goods[1].id, num = cfgbraveshop[iteminfo.id].goods[1].num})
          local pop = createPopupPieceBatchSummonResult("equip", cfgbraveshop[iteminfo.id].goods[1].id, cfgbraveshop[iteminfo.id].goods[1].num)
          layer:addChild(pop, 100)
        end
        iteminfo.num = iteminfo.num + 1
        if cfgbraveshop[iteminfo.id].limitNumb and cfgbraveshop[iteminfo.id].limitNumb <= iteminfo.num then
          setAlreadyBuy(pos)
          setShader(buyBtn, SHADER_GRAY, true)
          buyBtn:setEnabled(false)
        end
        lCoinLab:setString(lCoin.num - cost)
        bag.items.sub({id = ITEM_ID_BRAVE, num = cost})
         end)
      end)
    return itemBg
   end
  local init = function()
    local param = {}
    param.sid = player.sid
    addWaitNet()
    net:brave_market_sync(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      databraveshop.init(l_1_0, true)
      createlist(currentPage)
      end)
   end
  layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.02), CCCallFunc:create(init)))
  local circlePos = {1 = {400, 60}, 2 = {430, 60}}
  local circlelight = img.createUISprite(img.ui.shop_circle_light)
  circlelight:setPosition(circlePos[1][1], circlePos[1][2])
  board:addChild(circlelight, 1)
  local circledark1 = img.createUISprite(img.ui.shop_circle_dark)
  circledark1:setPosition(circlePos[1][1], circlePos[1][2])
  board:addChild(circledark1)
  local circledark2 = img.createUISprite(img.ui.shop_circle_dark)
  circledark2:setPosition(circlePos[2][1], circlePos[2][2])
  board:addChild(circledark2)
  local showdot = function(l_5_0)
    circlelight:setPosition(circlePos[l_5_0][1], circlePos[l_5_0][2])
   end
  local lefMenu = CCMenu:create()
  lefMenu:setPosition(0, 0)
  board:addChild(lefMenu)
  local lefBtnSprite = img.createUISprite(img.ui.gemstore_next_icon1)
  local lefBtn = HHMenuItem:create(lefBtnSprite)
  lefBtn:setScale(-1)
  lefBtn:setPosition(70, 250)
  if currentPage <= 1 then
    lefBtn:setVisible(false)
  end
  lefMenu:addChild(lefBtn)
  local rigMenu = CCMenu:create()
  rigMenu:setPosition(0, 0)
  board:addChild(rigMenu)
  local rigBtnSprite = img.createUISprite(img.ui.gemstore_next_icon1)
  local rigBtn = HHMenuItem:create(rigBtnSprite)
  rigBtn:setPosition(760, 250)
  if maxPage <= currentPage then
    rigBtn:setVisible(false)
  end
  rigMenu:addChild(rigBtn)
  lefBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if currentPage <= 1 then
      return 
    end
    upvalue_512 = currentPage - 1
    if currentPage <= 1 then
      lefBtn:setVisible(false)
    end
    if currentPage <= maxPage - 1 then
      rigBtn:setVisible(true)
    end
    createlist(currentPage)
    showdot(currentPage)
   end)
  rigBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if maxPage <= currentPage then
      return 
    end
    upvalue_512 = currentPage + 1
    if maxPage <= currentPage then
      rigBtn:setVisible(false)
    end
    if currentPage >= 2 then
      lefBtn:setVisible(true)
    end
    createlist(currentPage)
    showdot(currentPage)
   end)
  local back0 = img.createUISprite(img.ui.close)
  local backBtn = SpineMenuItem:create(json.ui.button, back0)
  backBtn:setPosition(798, 474)
  local backMenu = CCMenu:createWithItem(backBtn)
  backMenu:setPosition(0, 0)
  board:addChild(backMenu)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup()
   end
  backBtn:registerScriptTapHandler(function()
    backEvent()
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
  layer:registerScriptHandler(function(l_13_0)
    if l_13_0 == "enter" then
      onEnter()
    elseif l_13_0 == "exit" then
      onExit()
    end
   end)
  layer:setTouchEnabled(true)
  return layer
end

return ui

