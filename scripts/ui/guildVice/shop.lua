-- Command line was: E:\github\dhgametool\scripts\ui\guildVice\shop.lua 

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
local dataguildmarket = require("data.guildmarket")
local cfgguildmarket = require("config.guildstore")
local cfgequip = require("config.equip")
local cfgitem = require("config.item")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local REFRESHLUCKY = 20000
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
  local isBuy = {}
  local itemBg = {}
  local setAlreadyBuy, createItemWithPos = nil, nil
  local currentPage = 1
  local cfgCount = 0
  for v,k in pairs(cfgguildmarket) do
    cfgCount = cfgCount + 1
  end
  local maxPage = math.floor((cfgCount - 1) / 8) + 1
  local board = img.createUI9Sprite(img.ui.shop_board)
  board:setPreferredSize(CCSizeMake(838, 483))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY - 30 * view.minScale)
  layer:addChild(board)
  local sellicon = img.createUISprite(img.ui.guild_shop_sell)
  sellicon:setAnchorPoint(1, 1)
  sellicon:setPosition(67, 480)
  board:addChild(sellicon)
  local lighticon = img.createUISprite(img.ui.guild_shop_light)
  lighticon:setAnchorPoint(0, 1)
  lighticon:setPosition(740, 480)
  board:addChild(lighticon)
  local leftTowericon = img.createUISprite(img.ui.guild_shop_tower)
  leftTowericon:setAnchorPoint(0.5, 0)
  leftTowericon:setPosition(35, -5)
  board:addChild(leftTowericon)
  local rightTowericon = img.createUISprite(img.ui.guild_shop_tower)
  rightTowericon:setAnchorPoint(0.5, 0)
  rightTowericon:setFlipX(true)
  rightTowericon:setPosition(795, -5)
  board:addChild(rightTowericon)
  local boardtop = img.createUISprite(img.ui.guild_shop_top)
  boardtop:setPosition(415, 478)
  board:addChild(boardtop)
  board:setScale(0.1 * view.minScale)
  board:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  local lCoinBg = img.createUI9Sprite(img.ui.main_coin_bg)
  lCoinBg:setPreferredSize(CCSizeMake(174, 40))
  lCoinBg:setPosition(412, 520)
  board:addChild(lCoinBg, 5)
  local lcoinIcon = img.createItemIcon(ITEM_ID_GUILD_COIN)
  lcoinIcon:setScale(0.517)
  lcoinIcon:setPosition(CCPoint(5, lCoinBg:getContentSize().height / 2 + 2))
  lCoinBg:addChild(lcoinIcon)
  local lCoin = bag.items.find(ITEM_ID_GUILD_COIN)
  local lCoinLab = lbl.createFont2(16, lCoin.num, ccc3(255, 246, 223))
  lCoinLab:setPosition(CCPoint(lCoinBg:getContentSize().width / 2, lCoinBg:getContentSize().height / 2 + 2))
  lCoinBg:addChild(lCoinLab)
  local showItemLayer = CCLayer:create()
  board:addChild(showItemLayer)
  local createlist = function(l_1_0)
    showItemLayer:removeAllChildrenWithCleanup(true)
    for i = (l_1_0 - 1) * 8 + 1, l_1_0 * 8 do
      if  dataguildmarket.goods < i then
        return 
      end
      if cfgguildmarket[dataguildmarket.goods[i].id].limitNumb and cfgguildmarket[dataguildmarket.goods[i].id].limitNumb <= dataguildmarket.goods[i].num then
        isBuy[i] = true
      else
        isBuy[i] = false
      end
      itemBg[i] = createItemWithPos(dataguildmarket.goods[i], i)
      if cfgguildmarket[dataguildmarket.goods[i].id].limitNumb and cfgguildmarket[dataguildmarket.goods[i].id].limitNumb <= dataguildmarket.goods[i].num then
        setAlreadyBuy(i)
      end
    end
   end
  local createSurebuy = function(l_2_0, l_2_1, l_2_2, l_2_3)
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
      local param = {}
      param.sid = player.sid
      param.id = iteminfo.id
      addWaitNet()
      net:gmarket_buy(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        if cfgguildmarket[iteminfo.id].goods[1].type == 1 then
          bag.items.add({id = cfgguildmarket[iteminfo.id].goods[1].id, num = cfgguildmarket[iteminfo.id].goods[1].num})
          local pop = createPopupPieceBatchSummonResult("item", cfgguildmarket[iteminfo.id].goods[1].id, cfgguildmarket[iteminfo.id].goods[1].num)
          layer:addChild(pop, 100)
        else
          bag.equips.add({id = cfgguildmarket[iteminfo.id].goods[1].id, num = cfgguildmarket[iteminfo.id].goods[1].num})
          local pop = createPopupPieceBatchSummonResult("equip", cfgguildmarket[iteminfo.id].goods[1].id, cfgguildmarket[iteminfo.id].goods[1].num)
          layer:addChild(pop, 100)
        end
        iteminfo.num = iteminfo.num + 1
        if cfgguildmarket[iteminfo.id].limitNumb and cfgguildmarket[iteminfo.id].limitNumb <= iteminfo.num then
          setAlreadyBuy(pos)
          setShader(buyBtn, SHADER_GRAY, true)
          buyBtn:setEnabled(false)
        end
        lCoinLab:setString(lCoin.num - cost)
        bag.items.sub({id = ITEM_ID_GUILD_COIN, num = cost})
         end)
      audio.play(audio.button)
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
  setAlreadyBuy = function(l_3_0)
    setShader(itemBg[l_3_0], SHADER_GRAY, true)
    itemBg[l_3_0]:setEnabled(false)
    local soldout = img.createUISprite(img.ui.blackmarket_soldout)
    soldout:setPosition(CCPoint(itemBg[l_3_0]:getContentSize().width / 2, itemBg[l_3_0]:getContentSize().height / 2))
    itemBg[l_3_0]:addChild(soldout)
   end
  local ITEM_POS = {1 = {164, 369}, 2 = {336, 369}, 3 = {508, 369}, 4 = {680, 369}, 5 = {164, 218}, 6 = {336, 218}, 7 = {508, 218}, 8 = {680, 218}}
  createItemWithPos = function(l_4_0, l_4_1)
    local item, icon, cost = nil, nil, nil
    local showpos = (l_4_1 - 1) % 8 + 1
    local itemFrame = img.createUISprite(img.ui.casino_shop_frame)
    itemFrame:setPosition(ITEM_POS[showpos][1], ITEM_POS[showpos][2])
    showItemLayer:addChild(itemFrame)
    local menuBg = CCMenu:create()
    menuBg:setPosition(0, 0)
    showItemLayer:addChild(menuBg)
    if cfgguildmarket[l_4_0.id].goods[1].type == 1 then
      item = img.createItem(cfgguildmarket[l_4_0.id].goods[1].id, cfgguildmarket[l_4_0.id].goods[1].num)
    else
      item = img.createEquip(cfgguildmarket[l_4_0.id].goods[1].id, cfgguildmarket[l_4_0.id].goods[1].num)
    end
    local itemBg = SpineMenuItem:create(json.ui.button, item)
    itemBg:setPosition(ITEM_POS[showpos][1], ITEM_POS[showpos][2] + 8)
    menuBg:addChild(itemBg)
    icon = img.createItemIcon(ITEM_ID_GUILD_COIN)
    icon:setScale(0.379)
    cost = cfgguildmarket[l_4_0.id].cost
    local menuBuy = CCMenu:create()
    menuBuy:setPosition(0, 0)
    showItemLayer:addChild(menuBuy)
    local buyBtnSprite = img.createUISprite(img.ui.casino_shop_btn)
    local buyBtn = SpineMenuItem:create(json.ui.button, buyBtnSprite)
    buyBtn:setPosition(ITEM_POS[showpos][1], ITEM_POS[showpos][2] - 58)
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
        if cfgguildmarket[iteminfo.id].goods[1].type == 1 then
          pbdata.id = cfgguildmarket[iteminfo.id].goods[1].id
          tips = tipsitem.createForShow(pbdata)
        else
          if cfgguildmarket[iteminfo.id].goods[1].type == 2 then
            pbdata.id = cfgguildmarket[iteminfo.id].goods[1].id
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
        showToast(i18n.global.guild_shop_coin_lack.string)
        return 
      end
      local surebuy = createSurebuy(iteminfo, buyBtn, cost, pos)
      layer:addChild(surebuy, 1000)
      end)
    return itemBg
   end
  local createCostDiamond = function()
    local params = {}
    params.btn_count = 0
    params.body = string.format(i18n.global.guildshop_ref_sure.string, REFRESHLUCKY)
    local dialoglayer = require("ui.dialog").create(params)
    local btnYesSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnYesSprite:setPreferredSize(CCSize(153, 50))
    local btnYes = SpineMenuItem:create(json.ui.button, btnYesSprite)
    btnYes:setPosition(340, 100)
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
    btnNo:setPosition(150, 100)
    local labNo = lbl.createFont1(18, i18n.global.board_confirm_no.string, ccc3(115, 59, 5))
    labNo:setPosition(btnNo:getContentSize().width / 2, btnNo:getContentSize().height / 2)
    btnNoSprite:addChild(labNo)
    local menuNo = CCMenu:create()
    menuNo:setPosition(0, 0)
    menuNo:addChild(btnNo)
    dialoglayer.board:addChild(menuNo)
    btnYes:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      if bag.items.find(ITEM_ID_GUILD_COIN).num < REFRESHLUCKY then
        showToast(i18n.global.guild_shop_coin_lack.string)
        return 
      end
      local param = {}
      param.sid = player.sid
      addWaitNet()
      net:gmarket_refresh(param, function(l_1_0)
        tbl2string(l_1_0)
        delWaitNet()
        if l_1_0.status == -2 then
          showToast(i18n.global.guild_shop_coin_lack.string)
          return 
        end
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        bag.items.sub({id = ITEM_ID_GUILD_COIN, num = REFRESHLUCKY})
        lCoinLab:setString(bag.items.find(ITEM_ID_GUILD_COIN).num)
        dataguildmarket.init(l_1_0)
        createlist(currentPage)
         end)
      audio.play(audio.button)
      end)
    btnNo:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      audio.play(audio.button)
      end)
    local backEvent = function()
      dialoglayer:removeFromParentAndCleanup(true)
      end
    dialoglayer.onAndroidBack = function()
      backEvent()
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
  local chat = img.createLogin9Sprite(img.login.toast_bg)
  chat:setPreferredSize(CCSize(752, 70))
  chat:setAnchorPoint(CCPoint(0.5, 0))
  chat:setPosition(412, 30)
  board:addChild(chat)
  local refreshSprite = img.createLogin9Sprite(img.login.button_9_small_green)
  refreshSprite:setPreferredSize(CCSize(160, 50))
  local refreshBtn = SpineMenuItem:create(json.ui.button, refreshSprite)
  local refreshlab = lbl.createFont1(18, i18n.global.blackmarket_refresh.string, ccc3(29, 103, 0))
  refreshlab:setPosition(CCPoint(refreshSprite:getContentSize().width * 3 / 5, refreshSprite:getContentSize().height / 2))
  refreshSprite:addChild(refreshlab)
  refreshBtn:setAnchorPoint(CCPoint(0, 0.5))
  refreshBtn:setPosition(615, 64)
  local refreshMenu = CCMenu:createWithItem(refreshBtn)
  refreshMenu:setPosition(0, 0)
  board:addChild(refreshMenu)
  local refreshGem = img.createItemIcon(ITEM_ID_GUILD_COIN)
  refreshGem:setScale(0.379)
  refreshGem:setPosition(CCPoint(25, refreshSprite:getContentSize().height / 2 + 5))
  refreshSprite:addChild(refreshGem)
  local refreshGemlab = lbl.createFont2(42.21635883905, string.format("20k"), ccc3(255, 246, 223))
  refreshGemlab:setPosition(CCPoint(refreshGem:getContentSize().width / 2, 5))
  refreshGem:addChild(refreshGemlab)
  refreshBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local param = {}
    param.sid = player.sid
    local dialog = createCostDiamond()
    layer:addChild(dialog, 300)
    return 
   end)
  local init = function()
    local param = {}
    param.sid = player.sid
    addWaitNet()
    net:gmarket_sync(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      dataguildmarket.init(l_1_0, true)
      upvalue_1024 = dataguildmarket.getMaxPage()
      createlist(currentPage)
      end)
   end
  layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.02), CCCallFunc:create(init)))
  local circlePos = {1 = {400, 120}, 2 = {430, 120}, 3 = {460, 120}, 4 = {590, 120}}
  local sx = 421
  local dx = 30
  local circlelight = img.createUISprite(img.ui.shop_circle_light)
  circlelight:setPosition(sx + (1 - (maxPage + 1) / 2) * dx, circlePos[1][2])
  board:addChild(circlelight, 1)
  local circledark = {}
  for i = 1, maxPage do
    circlePos[i][1] = sx + (i - (maxPage + 1) / 2) * dx
    circlePos[i][2] = 120
    circledark[i] = img.createUISprite(img.ui.shop_circle_dark)
    circledark[i]:setPosition(circlePos[i][1], circlePos[i][2])
    board:addChild(circledark[i])
  end
  local showdot = function(l_8_0)
    circlelight:setPosition(circlePos[l_8_0][1], circlePos[l_8_0][2])
   end
  local lefMenu = CCMenu:create()
  lefMenu:setPosition(0, 0)
  board:addChild(lefMenu)
  local lefBtnSprite = img.createUISprite(img.ui.gemstore_next_icon1)
  local lefBtn = HHMenuItem:create(lefBtnSprite)
  lefBtn:setScale(-1)
  lefBtn:setPosition(60, 290)
  if currentPage <= 1 then
    lefBtn:setVisible(false)
  end
  lefMenu:addChild(lefBtn)
  local rigMenu = CCMenu:create()
  rigMenu:setPosition(0, 0)
  board:addChild(rigMenu)
  local rigBtnSprite = img.createUISprite(img.ui.gemstore_next_icon1)
  local rigBtn = HHMenuItem:create(rigBtnSprite)
  rigBtn:setPosition(780, 290)
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
  backBtn:setPosition(798, 489)
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
  layer:registerScriptHandler(function(l_16_0)
    if l_16_0 == "enter" then
      onEnter()
    elseif l_16_0 == "exit" then
      onExit()
    end
   end)
  layer:setTouchEnabled(true)
  return layer
end

return ui

