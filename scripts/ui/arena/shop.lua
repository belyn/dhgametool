-- Command line was: E:\github\dhgametool\scripts\ui\arena\shop.lua 

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
local dataarenashop = require("data.arenashop")
local cfgarenashop = require("config.arenamarket")
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
  local maxPage = math.floor((#cfgarenashop - 1) / 8) + 1
  local board = img.createUISprite(img.ui.shop_board)
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY - 30 * view.minScale)
  layer:addChild(board)
  local boardicon = img.createUISprite(img.ui.arena_new_shop_icon)
  boardicon:setPosition(415, 425)
  board:addChild(boardicon)
  local boardtop = img.createUISprite(img.ui.arena_new_shop_up_bar)
  boardtop:setPosition(415, 462)
  board:addChild(boardtop)
  board:setScale(0.1 * view.minScale)
  board:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  local lCoinBg = img.createUI9Sprite(img.ui.main_coin_bg)
  lCoinBg:setPreferredSize(CCSizeMake(174, 40))
  lCoinBg:setPosition(412, 505)
  board:addChild(lCoinBg, 5)
  local lcoinIcon = img.createItemIcon(ITEM_ID_ARENA_SHOP)
  lcoinIcon:setScale(0.517)
  lcoinIcon:setPosition(CCPoint(5, lCoinBg:getContentSize().height / 2 + 2))
  lCoinBg:addChild(lcoinIcon)
  local lCoin = bag.items.find(ITEM_ID_ARENA_SHOP)
  local lCoinLab = lbl.createFont2(16, lCoin.num, ccc3(255, 246, 223))
  lCoinLab:setPosition(CCPoint(lCoinBg:getContentSize().width / 2, lCoinBg:getContentSize().height / 2 + 2))
  lCoinBg:addChild(lCoinLab)
  local showItemLayer = CCLayer:create()
  board:addChild(showItemLayer)
  local createlist = function(l_1_0)
    showItemLayer:removeAllChildrenWithCleanup(true)
    for i = (l_1_0 - 1) * 8 + 1, l_1_0 * 8 do
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
    if cfgarenashop[l_3_0.id].goods[1].type == 1 then
      item = img.createItem(cfgarenashop[l_3_0.id].goods[1].id, cfgarenashop[l_3_0.id].goods[1].num)
    else
      item = img.createEquip(cfgarenashop[l_3_0.id].goods[1].id, cfgarenashop[l_3_0.id].goods[1].num)
    end
    local itemBg = SpineMenuItem:create(json.ui.button, item)
    itemBg:setPosition(ITEM_POS[showpos][1], ITEM_POS[showpos][2] + 8)
    menuBg:addChild(itemBg)
    icon = img.createItemIcon(ITEM_ID_ARENA_SHOP)
    icon:setScale(0.379)
    cost = cfgarenashop[l_3_0.id].cost
    local menuBuy = CCMenu:create()
    menuBuy:setPosition(0, 0)
    showItemLayer:addChild(menuBuy)
    local bagheadnum = 0
    if bag.items.find(cfgarenashop[l_3_0.id].goods[1].id) then
      bagheadnum = bag.items.find(cfgarenashop[l_3_0.id].goods[1].id).num
    end
    local buyBtnSprite = img.createUISprite(img.ui.casino_shop_btn)
    local buyBtn = SpineMenuItem:create(json.ui.button, buyBtnSprite)
    buyBtn:setPosition(ITEM_POS[showpos][1], ITEM_POS[showpos][2] - 58)
    menuBuy:addChild(buyBtn)
    if isBuy[l_3_1] or cfgarenashop[l_3_0.id].limitNumb and bagheadnum > 0 then
      setShader(buyBtn, SHADER_GRAY, true)
      setShader(itemBg, SHADER_GRAY, true)
      buyBtn:setEnabled(false)
      itemBg:setEnabled(false)
      local soldout = img.createUISprite(img.ui.blackmarket_soldout)
      soldout:setPosition(CCPoint(itemBg:getContentSize().width / 2, itemBg:getContentSize().height / 2))
      itemBg:addChild(soldout)
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
        if cfgarenashop[iteminfo.id].goods[1].type == 1 then
          pbdata.id = cfgarenashop[iteminfo.id].goods[1].id
          tips = tipsitem.createForShow(pbdata)
        else
          if cfgarenashop[iteminfo.id].goods[1].type == 2 then
            pbdata.id = cfgarenashop[iteminfo.id].goods[1].id
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
        if lCoin.num < cost then
          showToast(i18n.global.arena_shop_coin_lack.string)
          return 
        end
        local param = {}
        param.sid = player.sid
        param.id = pos
        param.num = 1
        addWaitNet()
        net:pmarket_buy(param, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          if l_1_0.status == -3 then
            showToast(i18n.global.toast_arenashop_notbuy.string)
            return 
          end
          if l_1_0.status ~= 0 then
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
            return 
          end
          if cfgarenashop[iteminfo.id].goods[1].type == 1 then
            bag.items.add({id = cfgarenashop[iteminfo.id].goods[1].id, num = cfgarenashop[iteminfo.id].goods[1].num})
            local pop = createPopupPieceBatchSummonResult("item", cfgarenashop[iteminfo.id].goods[1].id, cfgarenashop[iteminfo.id].goods[1].num)
            layer:addChild(pop, 100)
            processSpecialHead(cfgarenashop[iteminfo.id].goods)
          else
            bag.equips.add({id = cfgarenashop[iteminfo.id].goods[1].id, num = cfgarenashop[iteminfo.id].goods[1].num})
            local pop = createPopupPieceBatchSummonResult("equip", cfgarenashop[iteminfo.id].goods[1].id, cfgarenashop[iteminfo.id].goods[1].num)
            layer:addChild(pop, 100)
          end
          iteminfo.num = iteminfo.num + 1
          if cfgarenashop[iteminfo.id].limitNumb and cfgarenashop[iteminfo.id].limitNumb <= iteminfo.num then
            setAlreadyBuy(pos)
            setShader(buyBtn, SHADER_GRAY, true)
            buyBtn:setEnabled(false)
          end
          lCoinLab:setString(lCoin.num - cost)
          bag.items.sub({id = ITEM_ID_ARENA_SHOP, num = cost})
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
    callbackFunc = function(l_3_0)
      lCoinLab:setString(lCoin.num - l_3_0)
      end
    buyBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if cfgarenashop[iteminfo.id].limitNumb == 1 then
        local surebuy = createSurebuy(iteminfo, buyBtn, cost, pos)
        layer:addChild(surebuy, 300)
      else
        if cost * 2 <= lCoin.num then
          ui.showBuy(layer, pos, cost, iteminfo, callbackFunc)
        else
          local surebuy = createSurebuy(iteminfo, buyBtn, cost, pos)
          layer:addChild(surebuy, 300)
        end
      end
      end)
    return itemBg
   end
  local init = function()
    local param = {}
    param.sid = player.sid
    addWaitNet()
    net:pmarket(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      dataarenashop.init(l_1_0, true)
      createlist(currentPage)
      end)
   end
  layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.02), CCCallFunc:create(init)))
  local circlePos = {1 = {400, 60}, 2 = {430, 60}, 3 = {460, 60}, 4 = {490, 60}}
  local circlelight = img.createUISprite(img.ui.shop_circle_light)
  circlelight:setPosition(circlePos[1][1] - 30 * (maxPage / 2 - 1), circlePos[1][2])
  board:addChild(circlelight, 1)
  for i = 1, maxPage do
    local circledark = img.createUISprite(img.ui.shop_circle_dark)
    circledark:setPosition(circlePos[i][1] - 30 * (maxPage / 2 - 1), circlePos[i][2])
    board:addChild(circledark)
  end
  local showdot = function(l_5_0)
    circlelight:setPosition(circlePos[l_5_0][1] - 30 * (maxPage / 2 - 1), circlePos[l_5_0][2])
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

ui.showBuy = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4)
  local layer = CCLayer:create()
  local buyCount = 1
  local sweepdarkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(sweepdarkbg)
  local sweepboard_bg = img.createUI9Sprite(img.ui.dialog_1)
  sweepboard_bg:setPreferredSize(CCSizeMake(470, 380))
  sweepboard_bg:setScale(view.minScale)
  sweepboard_bg:setPosition(scalep(480, 288))
  layer:addChild(sweepboard_bg)
  local sweepboard_bg_w = sweepboard_bg:getContentSize().width
  local sweepboard_bg_h = sweepboard_bg:getContentSize().height
  local edit0 = img.createLogin9Sprite(img.login.input_border)
  local edit = CCEditBox:create(CCSizeMake(136 * view.minScale, 40 * view.minScale), edit0)
  edit:setInputMode(kEditBoxInputModeNumeric)
  edit:setReturnType(kKeyboardReturnTypeDone)
  edit:setMaxLength(5)
  edit:setFont("", 16 * view.minScale)
  edit:setText("1")
  edit:setFontColor(ccc3(148, 98, 66))
  edit:setPosition(scalep(480, 308))
  layer:addChild(edit, 1000)
  layer.edit = edit
  local sweeplbl = lbl.createMixFont1(18, i18n.global.dare_buy_times.string, ccc3(115, 59, 5))
  sweeplbl:setPosition(CCPoint(sweepboard_bg_w / 2, 275))
  sweepboard_bg:addChild(sweeplbl)
  local btn_sub0 = img.createUISprite(img.ui.btn_sub)
  local btn_sub = SpineMenuItem:create(json.ui.button, btn_sub0)
  btn_sub:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 - 100, 210))
  local btn_sub_menu = CCMenu:createWithItem(btn_sub)
  btn_sub_menu:setPosition(CCPoint(0, 0))
  sweepboard_bg:addChild(btn_sub_menu)
  local btn_add0 = img.createUISprite(img.ui.btn_add)
  local btn_add = SpineMenuItem:create(json.ui.button, btn_add0)
  btn_add:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 + 100, 210))
  local btn_add_menu = CCMenu:createWithItem(btn_add)
  btn_add_menu:setPosition(CCPoint(0, 0))
  sweepboard_bg:addChild(btn_add_menu)
  local btn_min0 = img.createUISprite(img.ui.btn_max)
  btn_min0:setFlipX(true)
  local btn_min = SpineMenuItem:create(json.ui.button, btn_min0)
  btn_min:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 - 150, 210))
  local btn_min_menu = CCMenu:createWithItem(btn_min)
  btn_min_menu:setPosition(CCPoint(0, 0))
  sweepboard_bg:addChild(btn_min_menu)
  local btn_max0 = img.createUISprite(img.ui.btn_max)
  local btn_max = SpineMenuItem:create(json.ui.button, btn_max0)
  btn_max:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 + 150, 210))
  local btn_max_menu = CCMenu:createWithItem(btn_max)
  btn_max_menu:setPosition(CCPoint(0, 0))
  sweepboard_bg:addChild(btn_max_menu)
  local broken_bg = img.createUI9Sprite(img.ui.casino_gem_bg)
  broken_bg:setPreferredSize(CCSizeMake(165, 34))
  broken_bg:setPosition(CCPoint(sweepboard_bg_w / 2, 144))
  sweepboard_bg:addChild(broken_bg)
  local icon_broken = img.createItemIcon2(ITEM_ID_ARENA_SHOP)
  icon_broken:setScale(0.8)
  icon_broken:setPosition(CCPoint(30, broken_bg:getContentSize().height / 2))
  broken_bg:addChild(icon_broken)
  local tGem = 0
  if bag.items.find(ITEM_ID_ARENA_SHOP) then
    tGem = bag.items.find(ITEM_ID_ARENA_SHOP).num
  end
  local lbl_pay = lbl.createFont2(16, tGem)
  lbl_pay:setPosition(CCPoint(100, broken_bg:getContentSize().height / 2))
  broken_bg:addChild(lbl_pay)
  local updatePay = function(l_1_0)
    local tmp_str = tGem .. "/" .. l_1_0 * cost
    lbl_pay:setString(tmp_str)
   end
  updatePay(1)
  local edit_tickets = layer.edit
  edit_tickets:registerScriptEditBoxHandler(function(l_2_0)
    if l_2_0 == "returnSend" then
      do return end
    end
    if l_2_0 == "return" then
      do return end
    end
    if l_2_0 == "ended" then
      local tmp_ticket_count = edit_tickets:getText()
      tmp_ticket_count = string.trim(tmp_ticket_count)
      tmp_ticket_count = checkint(tmp_ticket_count)
      if tmp_ticket_count <= 0 then
        tmp_ticket_count = 0
      end
      edit_tickets:setText(tmp_ticket_count)
      updatePay(tmp_ticket_count)
      upvalue_1024 = tmp_ticket_count
    elseif l_2_0 == "began" then
      do return end
    end
    if l_2_0 == "changed" then
       -- Warning: missing end command somewhere! Added here
    end
   end)
  btn_sub:registerScriptTapHandler(function()
    audio.play(audio.button)
    local edt_txt = edit_tickets:getText()
    edt_txt = string.trim(edt_txt)
    if edt_txt == "" then
      edt_txt = 1
      edit_tickets:setText(1)
      updatePay(1)
      upvalue_1536 = 1
      return 
    end
    local ticket_count = checkint(edt_txt)
    if ticket_count <= 1 then
      edit_tickets:setText(1)
      updatePay(1)
      upvalue_1536 = 1
      return 
    else
      ticket_count = ticket_count - 1
      edit_tickets:setText(ticket_count)
      updatePay(ticket_count)
      upvalue_1536 = ticket_count
    end
   end)
  btn_add:registerScriptTapHandler(function()
    audio.play(audio.button)
    local edt_txt = edit_tickets:getText()
    edt_txt = string.trim(edt_txt)
    if edt_txt == "" then
      edt_txt = 0
      edit_tickets:setText(0)
      updatePay(0)
      upvalue_1536 = 0
      return 
    end
    local ticket_count = checkint(edt_txt)
    if ticket_count < 0 then
      edit_tickets:setText(0)
      updatePay(0)
      upvalue_1536 = 0
      return 
    else
      if tGem <= cost * (ticket_count + 1) then
        return 
      end
      local tmp_gem_cost = ticket_count + 1
      ticket_count = ticket_count + 1
      edit_tickets:setText(ticket_count)
      updatePay(ticket_count)
      upvalue_1536 = ticket_count
    end
   end)
  btn_min:registerScriptTapHandler(function()
    audio.play(audio.button)
    edit_tickets:setText(1)
    updatePay(1)
    upvalue_1536 = 1
   end)
  btn_max:registerScriptTapHandler(function()
    audio.play(audio.button)
    local tNumber = math.floor(tGem / cost)
    edit_tickets:setText(tNumber)
    updatePay(tNumber)
    upvalue_2560 = tNumber
   end)
  local sweepbackEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local okSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
  okSprite:setPreferredSize(CCSize(155, 45))
  local oklab = lbl.createFont1(18, i18n.global.dialog_button_confirm.string, ccc3(126, 39, 0))
  oklab:setPosition(CCPoint(okSprite:getContentSize().width / 2, okSprite:getContentSize().height / 2))
  okSprite:addChild(oklab)
  local okBtn = SpineMenuItem:create(json.ui.button, okSprite)
  okBtn:setPosition(CCPoint(sweepboard_bg_w / 2, 80))
  local okMenu = CCMenu:createWithItem(okBtn)
  okMenu:setPosition(0, 0)
  sweepboard_bg:addChild(okMenu)
  okBtn:registerScriptTapHandler(function()
    disableObjAWhile(okBtn)
    audio.play(audio.button)
    local edt_txt = edit_tickets:getText()
    edt_txt = string.trim(edt_txt)
    if edt_txt == "" then
      sweepbackEvent()
      return 
    end
    local ticket_count = checkint(edt_txt)
    if ticket_count <= 0 then
      sweepbackEvent()
      return 
    end
    if tGem < cost * ticket_count then
      showToast(i18n.global.arena_shop_coin_lack.string)
      return 
    end
    local nParams = {sid = player.sid, id = pos, num = ticket_count}
    addWaitNet()
    net:pmarket_buy(nParams, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status == -3 then
        showToast(i18n.global.toast_arenashop_notbuy.string)
        return 
      end
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      if callbackFunc then
        callbackFunc(cost * ticket_count)
      end
      if cfgarenashop[iteminfo.id].goods[1].type == 1 then
        bag.items.add({id = cfgarenashop[iteminfo.id].goods[1].id, num = cfgarenashop[iteminfo.id].goods[1].num * ticket_count})
        local pop = createPopupPieceBatchSummonResult("item", cfgarenashop[iteminfo.id].goods[1].id, cfgarenashop[iteminfo.id].goods[1].num * cost * ticket_count)
        layer:addChild(pop, 100)
        processSpecialHead(cfgarenashop[iteminfo.id].goods)
      else
        bag.equips.add({id = cfgarenashop[iteminfo.id].goods[1].id, num = cfgarenashop[iteminfo.id].goods[1].num * ticket_count})
        local pop = createPopupPieceBatchSummonResult("equip", cfgarenashop[iteminfo.id].goods[1].id, cfgarenashop[iteminfo.id].goods[1].num * cost * ticket_count)
        layer:addChild(pop, 100)
      end
      bag.items.sub({id = ITEM_ID_ARENA_SHOP, num = cost * ticket_count})
      showToast(i18n.global.toast_buy_okay.string)
      sweepbackEvent()
      end)
   end)
  local sweepbtn_close0 = img.createUISprite(img.ui.close)
  local sweepbtn_close = SpineMenuItem:create(json.ui.button, sweepbtn_close0)
  sweepbtn_close:setPosition(CCPoint(sweepboard_bg_w - 25, sweepboard_bg_h - 28))
  local sweepbtn_close_menu = CCMenu:createWithItem(sweepbtn_close)
  sweepbtn_close_menu:setPosition(CCPoint(0, 0))
  sweepboard_bg:addChild(sweepbtn_close_menu, 100)
  sweepbtn_close:registerScriptTapHandler(function()
    sweepbackEvent()
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    sweepbackEvent()
   end
  local onEnter = function()
    print("onEnter")
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
  l_3_0:addChild(layer, 1000)
end

return ui

