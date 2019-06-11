-- Command line was: E:\github\dhgametool\scripts\ui\monthlyactivity\market.lua 

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
local dataarenashop = require("data.monthlymarket")
local cfgarenashop = require("config.monthlymarket")
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
  local maxPage = 0
  local circleLayer = nil
  local board = img.createUISprite(img.ui.mmarket_bg)
  board:setScale(view.minScale)
  board:setPosition(view.midX - 10 * view.minScale, view.midY + 45 * view.minScale)
  layer:addChild(board)
  board:setScale(0.1 * view.minScale)
  board:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  local lCoinBg = img.createUI9Sprite(img.ui.main_coin_bg)
  lCoinBg:setPreferredSize(CCSizeMake(174, 40))
  lCoinBg:setPosition(480, 475)
  board:addChild(lCoinBg, 5)
  local lcoinIcon = img.createItemIcon(ITEM_ID_GLORY)
  lcoinIcon:setScale(0.517)
  lcoinIcon:setPosition(CCPoint(5, lCoinBg:getContentSize().height / 2 + 2))
  lCoinBg:addChild(lcoinIcon)
  local lCoin = bag.items.find(ITEM_ID_GLORY)
  local lCoinLab = lbl.createFont2(16, lCoin.num, ccc3(255, 246, 223))
  lCoinLab:setPosition(CCPoint(lCoinBg:getContentSize().width / 2, lCoinBg:getContentSize().height / 2 + 2))
  lCoinBg:addChild(lCoinLab)
  local createSurebuy = function(l_1_0, l_1_1, l_1_2, l_1_3)
    local params = {}
    params.btn_count = 0
    params.body = string.format(i18n.global.blackmarket_buy_sure.string, 20)
    local board_w = 474
    local dialoglayer = require("ui.dialog").create(params)
    local btnYesSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnYesSprite:setPreferredSize(CCSize(153, 50))
    local btnYes = SpineMenuItem:create(json.ui.button, btnYesSprite)
    btnYes:setPosition(board_w / 2 + 95, 100)
    local labYes = lbl.createFont1(18, i18n.global.board_confirm_yes.string, ccc3(115, 59, 5))
    labYes:setPosition(btnYes:getContentSize().width / 2, btnYes:getContentSize().height / 2)
    btnYesSprite:addChild(labYes)
    local menuYes = CCMenu:create()
    menuYes:setPosition(0, 0)
    menuYes:addChild(btnYes)
    dialoglayer.board:addChild(menuYes)
    local btnNoSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnNoSprite:setPreferredSize(CCSize(153, 50))
    local btnNo = SpineMenuItem:create(json.ui.button, btnNoSprite)
    btnNo:setPosition(board_w / 2 - 95, 100)
    local labNo = lbl.createFont1(18, i18n.global.board_confirm_no.string, ccc3(115, 59, 5))
    labNo:setPosition(btnNo:getContentSize().width / 2, btnNo:getContentSize().height / 2)
    btnNoSprite:addChild(labNo)
    local menuNo = CCMenu:create()
    menuNo:setPosition(0, 0)
    menuNo:addChild(btnNo)
    dialoglayer.board:addChild(menuNo)
    btnYes:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      if lCoin.num < cost then
        showToast(i18n.global.mmarket_coin_lack.string)
        return 
      end
      local param = {}
      param.sid = player.sid
      param.id = iteminfo.id
      addWaitNet()
      net:monthmarket_buy(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        if cfgarenashop[iteminfo.id].getCommodity[1].type == 1 then
          bag.items.add({id = cfgarenashop[iteminfo.id].getCommodity[1].id, num = cfgarenashop[iteminfo.id].getCommodity[1].num})
          local pop = createPopupPieceBatchSummonResult("item", cfgarenashop[iteminfo.id].getCommodity[1].id, cfgarenashop[iteminfo.id].getCommodity[1].num)
          layer:addChild(pop, 100)
        else
          bag.equips.add({id = cfgarenashop[iteminfo.id].getCommodity[1].id, num = cfgarenashop[iteminfo.id].getCommodity[1].num})
          local pop = createPopupPieceBatchSummonResult("equip", cfgarenashop[iteminfo.id].getCommodity[1].id, cfgarenashop[iteminfo.id].getCommodity[1].num)
          layer:addChild(pop, 100)
        end
        lCoinLab:setString(lCoin.num - cost)
        bag.items.sub({id = ITEM_ID_GLORY, num = cost})
         end)
      end)
    btnNo:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      audio.play(audio.button)
      end)
    local diabackEvent = function()
      dialoglayer:removeFromParentAndCleanup(true)
      end
    dialoglayer.onAndroidBack = function()
      diabackEvent()
      end
    addBackEvent(dialoglayer)
    local onEnter = function()
      dialoglayer.notifyParentLock()
      end
    local onExit = function()
      dialoglayer.notifyParentUnlock()
      end
    dialoglayer:registerScriptHandler(function(l_7_0)
      if l_7_0 == "enter" then
        onEnter()
      elseif l_7_0 == "exit" then
        onExit()
      end
      end)
    return dialoglayer
   end
  local showItemLayer = CCLayer:create()
  board:addChild(showItemLayer)
  local createlist = function(l_2_0)
    showItemLayer:removeAllChildrenWithCleanup(true)
    for i = (l_2_0 - 1) * 8 + 1, l_2_0 * 8 do
      if #dataarenashop.goods < i then
        return 
      end
      if cfgarenashop[dataarenashop.goods[i].id].limitNumb and cfgarenashop[dataarenashop.goods[i].id].limitNumb <= dataarenashop.goods[i].num then
        isBuy[i] = true
      else
        isBuy[i] = false
      end
      itemBg[i] = createItemWithPos(dataarenashop.goods[i], i)
      if cfgarenashop[dataarenashop.goods[i].id].limitNumb and cfgarenashop[dataarenashop.goods[i].id].limitNumb <= dataarenashop.goods[i].num then
        setAlreadyBuy(i)
      end
    end
   end
  setAlreadyBuy = function(l_3_0)
    setShader(itemBg[l_3_0], SHADER_GRAY, true)
    itemBg[l_3_0]:setEnabled(false)
    local soldout = img.createUISprite(img.ui.blackmarket_soldout)
    soldout:setPosition(CCPoint(itemBg[l_3_0]:getContentSize().width / 2, itemBg[l_3_0]:getContentSize().height / 2))
    itemBg[l_3_0]:addChild(soldout)
   end
  local ITEM_POS = {1 = {175, 340}, 2 = {335, 340}, 3 = {495, 340}, 4 = {655, 340}, 5 = {175, 175}, 6 = {335, 175}, 7 = {495, 175}, 8 = {655, 175}}
  createItemWithPos = function(l_4_0, l_4_1)
    local item, icon, cost = nil, nil, nil
    local showpos = (l_4_1 - 1) % 8 + 1
    local itemFrame = img.createUISprite(img.ui.mmarket_shopback)
    itemFrame:setPosition(ITEM_POS[showpos][1] + 68, ITEM_POS[showpos][2] - 6)
    showItemLayer:addChild(itemFrame)
    local menuBg = CCMenu:create()
    menuBg:setPosition(0, 0)
    showItemLayer:addChild(menuBg)
    if cfgarenashop[l_4_0.id].getCommodity[1].type == 1 then
      item = img.createItem(cfgarenashop[l_4_0.id].getCommodity[1].id, cfgarenashop[l_4_0.id].getCommodity[1].num)
    else
      item = img.createEquip(cfgarenashop[l_4_0.id].getCommodity[1].id, cfgarenashop[l_4_0.id].getCommodity[1].num)
    end
    local itemBg = SpineMenuItem:create(json.ui.button, item)
    itemBg:setPosition(ITEM_POS[showpos][1] + 68, ITEM_POS[showpos][2] + 2)
    menuBg:addChild(itemBg)
    icon = img.createItemIcon(ITEM_ID_GLORY)
    icon:setScale(0.379)
    cost = cfgarenashop[l_4_0.id].currencyCount[1].num
    local menuBuy = CCMenu:create()
    menuBuy:setPosition(0, 0)
    showItemLayer:addChild(menuBuy)
    local buyBtnSprite = img.createUISprite(img.ui.casino_shop_btn)
    local buyBtn = SpineMenuItem:create(json.ui.button, buyBtnSprite)
    buyBtn:setPosition(ITEM_POS[showpos][1] + 68, ITEM_POS[showpos][2] - 64)
    buyBtn:setEnabled(isBuy[l_4_1] == false)
    menuBuy:addChild(buyBtn)
    if isBuy[l_4_1] then
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
        if cfgarenashop[iteminfo.id].getCommodity[1].type == 1 then
          pbdata.id = cfgarenashop[iteminfo.id].getCommodity[1].id
          tips = tipsitem.createForShow(pbdata)
        else
          if cfgarenashop[iteminfo.id].getCommodity[1].type == 2 then
            pbdata.id = cfgarenashop[iteminfo.id].getCommodity[1].id
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
      local surebuy = createSurebuy(iteminfo, buyBtn, cost, pos)
      layer:addChild(surebuy, 300)
      end)
    return itemBg
   end
  local init = function()
    local param = {}
    param.sid = player.sid
    addWaitNet()
    net:monthmarket_sync(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      dataarenashop.init(l_1_0, true)
      upvalue_1024 = math.floor((#dataarenashop.goods - 1) / 8) + 1
      upvalue_1536 = createCircleAndRaw()
      board:addChild(circleLayer)
      createTag()
      showdot(currentPage)
      createlist(currentPage)
      end)
   end
  layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.02), CCCallFunc:create(init)))
  local circlePos = {1 = {400, 60}, 2 = {430, 60}, 3 = {460, 60}, 4 = {490, 60}, 5 = {520, 60}, 6 = {550, 60}}
  local circlelight = img.createUISprite(img.ui.shop_circle_light)
  circlelight:setPosition(circlePos[1][1], circlePos[1][2])
  board:addChild(circlelight, 1)
  showdot = function(l_6_0)
    circlelight:setPosition(circlePos[l_6_0][1] - 30 * (maxPage / 2 - 1) + 68, circlePos[l_6_0][2])
   end
  createCircleAndRaw = function()
    if circleLayer and not tolua.isnull(layer) then
      circleLayer:removeFromParentAndCleanup(true)
      circleLayer = nil
    end
    local layer = CCLayer:create()
    for i = 1, maxPage do
      local circledark = img.createUISprite(img.ui.mmarket_point)
      circledark:setPosition(circlePos[i][1] - 30 * (maxPage / 2 - 1) + 68, circlePos[i][2])
      layer:addChild(circledark)
    end
    local lefMenu = CCMenu:create()
    lefMenu:setPosition(0, 0)
    layer:addChild(lefMenu)
    local lefBtnSprite = img.createUISprite(img.ui.gemstore_next_icon1)
    local lefBtn = HHMenuItem:create(lefBtnSprite)
    lefBtn:setScale(-1)
    lefBtn:setPosition(138, 250)
    if currentPage <= 1 then
      lefBtn:setVisible(false)
    end
    lefMenu:addChild(lefBtn)
    local rigMenu = CCMenu:create()
    rigMenu:setPosition(0, 0)
    layer:addChild(rigMenu)
    local rigBtnSprite = img.createUISprite(img.ui.gemstore_next_icon1)
    local rigBtn = HHMenuItem:create(rigBtnSprite)
    rigBtn:setPosition(828, 250)
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
    return layer
   end
  createTag = function()
    local btnPieceSprite0 = img.createUISprite(img.ui.activity_lightshop_piece0)
    local btnPieceSprite1 = img.createUISprite(img.ui.activity_lightshop_piece1)
    local btnPiece = CCMenuItemSprite:create(btnPieceSprite0, btnPieceSprite1, btnPieceSprite0)
    local btnPieceMenu = CCMenu:createWithItem(btnPiece)
    btnPiece:setPosition(920, 334)
    btnPieceMenu:setPosition(0, 0)
    btnPiece:selected()
    board:addChild(btnPieceMenu, 10)
    local btnEquipSprite0 = img.createUISprite(img.ui.activity_lightshop_artifact0)
    local btnEquipSprite1 = img.createUISprite(img.ui.activity_lightshop_artifact1)
    local btnEquip = CCMenuItemSprite:create(btnEquipSprite0, btnEquipSprite1, btnEquipSprite0)
    local btnEquipMenu = CCMenu:createWithItem(btnEquip)
    btnEquip:setPosition(920, 146)
    btnEquipMenu:setPosition(0, 0)
    board:addChild(btnEquipMenu, 10)
    local btnSkinpieceSprite0 = img.createUISprite(img.ui.activity_lightshop_skin0)
    local btnSkinpieceSprite1 = img.createUISprite(img.ui.activity_lightshop_skin1)
    local btnSkinpiece = CCMenuItemSprite:create(btnSkinpieceSprite0, btnSkinpieceSprite1, btnSkinpieceSprite0)
    local btnSkinpieceMenu = CCMenu:createWithItem(btnSkinpiece)
    btnSkinpiece:setPosition(920, 240)
    btnSkinpieceMenu:setPosition(0, 0)
    board:addChild(btnSkinpieceMenu, 10)
    btnPiece:registerScriptTapHandler(function()
      audio.play(audio.button)
      upvalue_512 = 1
      dataarenashop.goods = dataarenashop.mpiece
      upvalue_1536 = math.floor((#dataarenashop.goods - 1) / 8) + 1
      showdot(currentPage)
      createlist(currentPage)
      upvalue_2560 = createCircleAndRaw()
      board:addChild(circleLayer)
      btnPiece:selected()
      btnEquip:unselected()
      btnSkinpiece:unselected()
      end)
    btnEquip:registerScriptTapHandler(function()
      audio.play(audio.button)
      upvalue_512 = 1
      dataarenashop.goods = dataarenashop.mequip
      upvalue_1536 = math.floor((#dataarenashop.goods - 1) / 8) + 1
      showdot(currentPage)
      createlist(currentPage)
      upvalue_2560 = createCircleAndRaw()
      board:addChild(circleLayer)
      btnPiece:unselected()
      btnEquip:selected()
      btnSkinpiece:unselected()
      end)
    btnSkinpiece:registerScriptTapHandler(function()
      audio.play(audio.button)
      upvalue_512 = 1
      dataarenashop.goods = dataarenashop.mskin
      upvalue_1536 = math.floor((#dataarenashop.goods - 1) / 8) + 1
      showdot(currentPage)
      createlist(currentPage)
      upvalue_2560 = createCircleAndRaw()
      board:addChild(circleLayer)
      btnPiece:unselected()
      btnEquip:unselected()
      btnSkinpiece:selected()
      end)
   end
  local back0 = img.createUISprite(img.ui.close)
  local backBtn = SpineMenuItem:create(json.ui.button, back0)
  backBtn:setPosition(892, 473)
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
  layer:registerScriptHandler(function(l_14_0)
    if l_14_0 == "enter" then
      onEnter()
    elseif l_14_0 == "exit" then
      onExit()
    end
   end)
  layer:setTouchEnabled(true)
  return layer
end

return ui

