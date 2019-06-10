-- Command line was: E:\github\dhgametool\scripts\ui\casino\shop.lua 

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
local dataluckymarket = require("data.luckymarket")
local cfgluckymarket = require("config.luckymarket")
local cfgequip = require("config.equip")
local cfgitem = require("config.item")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local MARKETTIME = 10800
local REFRESHLUCKY = 50
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
  local refresh, createItemWithPos, setAlreadyBuy = nil, nil, nil
  local board = img.createUISprite(img.ui.casino_shop_bottom)
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  board:setScale(0.1 * view.minScale)
  board:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  local boss = json.createSpineHero(3303)
  boss:setPosition(88, 30)
  board:addChild(boss)
  local chat = img.createLogin9Sprite(img.login.toast_bg)
  chat:setPreferredSize(CCSize(752, 74))
  chat:setAnchorPoint(CCPoint(0.5, 0))
  chat:setPosition(412, 29)
  board:addChild(chat)
  local lCoinBg = img.createUI9Sprite(img.ui.main_coin_bg)
  lCoinBg:setPreferredSize(CCSizeMake(174, 40))
  lCoinBg:setPosition(412, 505)
  board:addChild(lCoinBg, 5)
  local lcoinIcon = img.createItemIcon(ITEM_ID_LUCKY_COIN)
  lcoinIcon:setScale(0.517)
  lcoinIcon:setPosition(CCPoint(5, lCoinBg:getContentSize().height / 2 + 2))
  lCoinBg:addChild(lcoinIcon)
  local lCoin = bag.items.find(6)
  local lCoinLab = lbl.createFont2(16, lCoin.num, ccc3(255, 246, 223))
  lCoinLab:setPosition(CCPoint(lCoinBg:getContentSize().width / 2, lCoinBg:getContentSize().height / 2 + 2))
  lCoinBg:addChild(lCoinLab)
  local showItemLayer = CCLayer:create()
  board:addChild(showItemLayer)
  local createlist = function(l_1_0)
    showItemLayer:removeAllChildrenWithCleanup(true)
    for i = 1, 8 do
      if dataluckymarket.goods[i].bought == 1 then
        isBuy[i] = true
      else
        isBuy[i] = false
      end
      itemBg[i] = createItemWithPos(dataluckymarket.goods[i], i)
      if l_1_0 then
        json.load(json.ui.ic_refresh)
        local aniRef = DHSkeletonAnimation:createWithKey(json.ui.ic_refresh)
        aniRef:scheduleUpdateLua()
        aniRef:playAnimation("animation")
        aniRef:setPosition(itemBg[i]:getContentSize().width / 2, itemBg[i]:getContentSize().height / 2)
        itemBg[i]:addChild(aniRef, 100)
      end
      if dataluckymarket.goods[i].bought == 1 then
        setAlreadyBuy(i)
      end
    end
   end
  local createCostDiamond = function()
    local params = {}
    params.btn_count = 0
    params.body = string.format(i18n.global.casino_sure.string, REFRESHLUCKY)
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
      if bag.items.find(ITEM_ID_LUCKY_COIN).num < REFRESHLUCKY then
        showToast(i18n.global.casino_shop_coin_lack.string)
        return 
      end
      local param = {}
      param.sid = player.sid
      param.type = 3
      addWaitNet()
      net:lmarket_pull(param, function(l_1_0)
        tbl2string(l_1_0)
        delWaitNet()
        if l_1_0.status == -2 then
          showToast(i18n.global.casino_shop_coin_lack.string)
          return 
        end
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        bag.items.sub({id = ITEM_ID_LUCKY_COIN, num = REFRESHLUCKY})
        lCoinLab:setString(bag.items.find(ITEM_ID_LUCKY_COIN).num)
        dataluckymarket.init(l_1_0)
        createlist(true)
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
  local refreshSprite = img.createLogin9Sprite(img.login.button_9_small_green)
  refreshSprite:setPreferredSize(CCSize(146, 50))
  local refreshBtn = SpineMenuItem:create(json.ui.button, refreshSprite)
  refreshBtn:setVisible(false)
  local refreshlab = lbl.createFont1(18, i18n.global.blackmarket_refresh.string, ccc3(29, 103, 0))
  refreshlab:setPosition(CCPoint(refreshSprite:getContentSize().width * 3 / 5, refreshSprite:getContentSize().height / 2))
  refreshlab:setVisible(false)
  refreshSprite:addChild(refreshlab)
  refreshBtn:setAnchorPoint(CCPoint(0, 0.5))
  refreshBtn:setPosition(615, 65)
  local refreshMenu = CCMenu:createWithItem(refreshBtn)
  refreshMenu:setPosition(0, 0)
  board:addChild(refreshMenu)
  refreshBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local param = {}
    param.sid = player.sid
    if refresh <= 0 then
      param.type = 2
    else
      if bag.items.find(ITEM_ID_LUCKY_COIN).num < REFRESHLUCKY then
        showToast(i18n.global.casino_shop_coin_lack.string)
        return 
      else
        local dialog = createCostDiamond()
        layer:addChild(dialog, 300)
        return 
      end
    end
    addWaitNet()
    net:lmarket_pull(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      dataluckymarket.init(l_1_0, true)
      createlist(true)
      end)
   end)
  setAlreadyBuy = function(l_4_0)
    setShader(itemBg[l_4_0], SHADER_GRAY, true)
    itemBg[l_4_0]:setEnabled(false)
    local soldout = img.createUISprite(img.ui.blackmarket_soldout)
    soldout:setPosition(CCPoint(itemBg[l_4_0]:getContentSize().width / 2, itemBg[l_4_0]:getContentSize().height / 2))
    itemBg[l_4_0]:addChild(soldout)
   end
  local ITEM_POS = {1 = {232, 350}, 2 = {390, 350}, 3 = {548, 350}, 4 = {706, 350}, 5 = {232, 198}, 6 = {390, 198}, 7 = {548, 200}, 8 = {706, 198}}
  createItemWithPos = function(l_5_0, l_5_1)
    local item, icon, cost = nil, nil, nil
    local itemFrame = img.createUISprite(img.ui.casino_shop_frame)
    itemFrame:setPosition(ITEM_POS[l_5_1][1], ITEM_POS[l_5_1][2])
    showItemLayer:addChild(itemFrame)
    local menuBg = CCMenu:create()
    menuBg:setPosition(0, 0)
    showItemLayer:addChild(menuBg)
    if l_5_0.type == 1 then
      item = img.createItem(l_5_0.id, cfgluckymarket[l_5_0.excel_id].count)
    elseif l_5_0.type == 2 then
      item = img.createEquip(l_5_0.id, cfgluckymarket[l_5_0.excel_id].count)
    end
    local itemBg = SpineMenuItem:create(json.ui.button, item)
    itemBg:setPosition(ITEM_POS[l_5_1][1], ITEM_POS[l_5_1][2])
    menuBg:addChild(itemBg)
    icon = img.createItemIcon(ITEM_ID_LUCKY_COIN)
    icon:setScale(0.379)
    cost = cfgluckymarket[l_5_0.excel_id].cost
    local menuBuy = CCMenu:create()
    menuBuy:setPosition(0, 0)
    showItemLayer:addChild(menuBuy)
    local buyBtnSprite = img.createUISprite(img.ui.casino_shop_btn)
    local buyBtn = SpineMenuItem:create(json.ui.button, buyBtnSprite)
    buyBtn:setPosition(ITEM_POS[l_5_1][1], ITEM_POS[l_5_1][2] - 65)
    buyBtn:setEnabled(isBuy[l_5_1] == false)
    menuBuy:addChild(buyBtn)
    if isBuy[l_5_1] then
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
        if iteminfo.type == 1 then
          pbdata.id = iteminfo.id
          tips = tipsitem.createForShow(pbdata)
        else
          if iteminfo.type == 2 then
            pbdata.id = iteminfo.id
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
      local param = {}
      param.sid = player.sid
      param.id = pos
      if lCoin.num < cost then
        showToast(i18n.global.casino_shop_coin_lack.string)
        return 
      end
      addWaitNet()
      net:lmarket_buy(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        if l_1_0.bag.equips then
          bag.equips.addAll(l_1_0.bag.equips)
          local pop = createPopupPieceBatchSummonResult("equip", iteminfo.id, cfgluckymarket[iteminfo.excel_id].count)
          layer:addChild(pop, 100)
        end
        if l_1_0.bag.items then
          bag.items.addAll(l_1_0.bag.items)
          local pop = createPopupPieceBatchSummonResult("item", iteminfo.id, cfgluckymarket[iteminfo.excel_id].count)
          layer:addChild(pop, 100)
        end
        lCoinLab:setString(lCoin.num - cost)
        setShader(buyBtn, SHADER_GRAY, true)
        buyBtn:setEnabled(false)
        bag.items.sub({id = ITEM_ID_LUCKY_COIN, num = cost})
        setAlreadyBuy(pos)
         end)
      end)
    return itemBg
   end
  local refreshGem = img.createItemIcon(ITEM_ID_LUCKY_COIN)
  refreshGem:setScale(0.379)
  refreshGem:setPosition(CCPoint(25, refreshSprite:getContentSize().height / 2 + 5))
  refreshGem:setVisible(false)
  refreshSprite:addChild(refreshGem)
  local refreshGemlab = lbl.createFont2(42.21635883905, string.format("%d", REFRESHLUCKY), ccc3(255, 246, 223))
  refreshGemlab:setPosition(CCPoint(refreshGem:getContentSize().width / 2, 5))
  refreshGem:addChild(refreshGemlab)
  local showTimeLab = lbl.createFont2(16, "", ccc3(165, 253, 71))
  showTimeLab:setAnchorPoint(1, 0.5)
  showTimeLab:setPosition(refreshBtn:boundingBox():getMinX() - 30, refreshBtn:getPositionY())
  showTimeLab:setVisible(false)
  board:addChild(showTimeLab, 10)
  local toFreelab = lbl.createFont2(16, i18n.global.casino_shop_to_free.string, ccc3(255, 246, 223))
  toFreelab:setAnchorPoint(1, 0.5)
  toFreelab:setVisible(false)
  toFreelab:setPosition(showTimeLab:getPositionX() - showTimeLab:getContentSize().width - 10, refreshBtn:getPositionY())
  board:addChild(toFreelab)
  local initFlag = false
  local initRefresh = false
  local onUpdate = function()
    if initRefresh == true then
      refreshBtn:setVisible(true)
      initRefresh = false
    end
    if initFlag == true then
      upvalue_1536 = math.max(0, dataluckymarket.refresh - os.time())
      if refresh > 0 then
        toFreelab:setVisible(true)
        refreshlab:setVisible(true)
        showTimeLab:setVisible(true)
        refreshGem:setVisible(true)
        local timeLab = string.format("%02d:%02d:%02d", math.floor(refresh / 3600), math.floor(refresh % 3600 / 60), math.floor(refresh % 60))
        showTimeLab:setString(timeLab)
        showTimeLab:setColor(ccc3(165, 253, 71))
        refreshlab:setPosition(CCPoint(refreshSprite:getContentSize().width * 3 / 5, refreshSprite:getContentSize().height / 2))
        toFreelab:setPosition(showTimeLab:boundingBox():getMinX() - 10, refreshBtn:getPositionY())
      else
        toFreelab:setVisible(false)
        refreshGem:setVisible(false)
        refreshlab:setVisible(true)
        showTimeLab:setVisible(true)
        showTimeLab:setString(i18n.global.blackmarket_free_refresh.string)
        showTimeLab:setColor(ccc3(255, 246, 223))
        refreshlab:setPosition(CCPoint(refreshSprite:getContentSize().width / 2, refreshSprite:getContentSize().height / 2))
      end
    end
   end
  local init = function()
    local param = {}
    param.sid = player.sid
    param.type = 1
    addWaitNet()
    net:lmarket_pull(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      tbl2string(l_1_0)
      dataluckymarket.init(l_1_0, true)
      createlist()
      upvalue_1536 = math.max(0, dataluckymarket.refresh - os.time())
      upvalue_2048 = true
      upvalue_2560 = true
      end)
   end
  layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.02), CCCallFunc:create(init)))
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
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

