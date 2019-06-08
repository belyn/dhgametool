-- Command line was: E:\github\dhgametool\scripts\ui\sealland\shop.lua 

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
local shopConfig = require("config.seallandmarket")
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

local createBuyLayer = function(l_2_0, l_2_1, l_2_2)
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
  local edit = CCEditBox:create(CCSizeMake(156 * view.minScale, 40 * view.minScale), edit0)
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
  btn_sub:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 - 111, 210))
  local btn_sub_menu = CCMenu:createWithItem(btn_sub)
  btn_sub_menu:setPosition(CCPoint(0, 0))
  sweepboard_bg:addChild(btn_sub_menu)
  local subMinImage = img.createUISprite(img.ui.btn_max)
  subMinImage:setFlipY(true)
  local subMin = SpineMenuItem:create(json.ui.button, subMinImage)
  subMin:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 - 111 - 50, 210))
  subMin:setRotation(180)
  local subMinMenu = CCMenu:createWithItem(subMin)
  subMinMenu:setPosition(CCPoint(0, 0))
  sweepboard_bg:addChild(subMinMenu)
  local btn_add0 = img.createUISprite(img.ui.btn_add)
  local btn_add = SpineMenuItem:create(json.ui.button, btn_add0)
  btn_add:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 + 111, 210))
  local btn_add_menu = CCMenu:createWithItem(btn_add)
  btn_add_menu:setPosition(CCPoint(0, 0))
  sweepboard_bg:addChild(btn_add_menu)
  local addMaxImage = img.createUISprite(img.ui.btn_max)
  local addMax = SpineMenuItem:create(json.ui.button, addMaxImage)
  addMax:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 + 111 + 50, 210))
  local addMaxMenu = CCMenu:createWithItem(addMax)
  addMaxMenu:setPosition(CCPoint(0, 0))
  sweepboard_bg:addChild(addMaxMenu)
  local broken_bg = img.createUI9Sprite(img.ui.casino_gem_bg)
  broken_bg:setPreferredSize(CCSizeMake(165, 34))
  broken_bg:setPosition(CCPoint(sweepboard_bg_w / 2, 144))
  sweepboard_bg:addChild(broken_bg)
  local icon_broken = img.createItemIcon2(l_2_0)
  icon_broken:setScale(0.8)
  icon_broken:setPosition(CCPoint(30, broken_bg:getContentSize().height / 2))
  broken_bg:addChild(icon_broken)
  local getNum = function(l_1_0)
    local num = 0
    if bag.items.find(l_1_0) then
      num = bag.items.find(l_1_0).num
    end
    return num
   end
  local lbl_pay = lbl.createFont2(16, getNum(l_2_0))
  lbl_pay:setPosition(CCPoint(100, broken_bg:getContentSize().height / 2))
  broken_bg:addChild(lbl_pay)
  local updatePay = function(l_2_0)
    local tmp_str = num2KM(getNum(id)) .. "/" .. l_2_0 * cost
    lbl_pay:setString(tmp_str)
   end
  updatePay(1)
  local edit_tickets = layer.edit
  edit_tickets:registerScriptEditBoxHandler(function(l_3_0)
    if l_3_0 == "returnSend" then
      do return end
    end
    if l_3_0 == "return" then
      do return end
    end
    if l_3_0 == "ended" then
      local tmp_ticket_count = edit_tickets:getText()
      tmp_ticket_count = string.trim(tmp_ticket_count)
      tmp_ticket_count = checkint(tmp_ticket_count)
      if tmp_ticket_count <= 0 then
        tmp_ticket_count = 0
      end
      edit_tickets:setText(tmp_ticket_count)
      updatePay(tmp_ticket_count)
      upvalue_1024 = tmp_ticket_count
    elseif l_3_0 == "began" then
      do return end
    end
    if l_3_0 == "changed" then
       -- Warning: missing end command somewhere! Added here
    end
   end)
  btn_sub:registerScriptTapHandler(function()
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
    if ticket_count <= 0 then
      edit_tickets:setText(0)
      updatePay(0)
      upvalue_1536 = 0
      return 
    else
      ticket_count = ticket_count - 1
      edit_tickets:setText(ticket_count)
      updatePay(ticket_count)
      upvalue_1536 = ticket_count
    end
   end)
  subMin:registerScriptTapHandler(function()
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
    edit_tickets:setText(1)
    updatePay(1)
    upvalue_1536 = 1
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
      if getNum(id) < (ticket_count + 1) * cost then
        if id == ITEM_ID_COLOR_CRYSTAL then
          showToast(i18n.global.seal_land_color_crystal_lack.string)
          return 
        end
        if id == ITEM_ID_LIGHT_DARK_CRYSTAL then
          showToast(i18n.global.seal_land_light_dark_crystal_lack.string)
          return 
        end
      end
      ticket_count = ticket_count + 1
      edit_tickets:setText(ticket_count)
      updatePay(ticket_count)
      upvalue_1536 = ticket_count
    end
   end)
  addMax:registerScriptTapHandler(function()
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
    local buyTimes = math.floor(getNum(id) / cost)
    edit_tickets:setText(buyTimes)
    updatePay(buyTimes)
    upvalue_1536 = buyTimes
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
    if getNum(id) < ticket_count * cost then
      if id == ITEM_ID_COLOR_CRYSTAL then
        showToast(i18n.global.seal_land_color_crystal_lack.string)
        return 
      end
      if id == ITEM_ID_LIGHT_DARK_CRYSTAL then
        showToast(i18n.global.seal_land_light_dark_crystal_lack.string)
        return 
      end
      return 
    end
    if callback then
      callback(ticket_count)
    end
    sweepbackEvent()
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
  layer:registerScriptHandler(function(l_14_0)
    if l_14_0 == "enter" then
      onEnter()
    elseif l_14_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

local createSurebuy = function(l_3_0)
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
    audio.play(audio.button)
    callback()
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

ui.create = function()
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  img.load(img.packedOthers.ui_brave)
  local itemBg = {}
  local setAlreadyBuy, createItemWithPos = nil, nil
  local currentPage = 1
  local maxPage = math.floor(( shopConfig - 1) / 8) + 1
  local board = img.createUISprite(img.ui.shop_board)
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY - 30 * view.minScale)
  layer:addChild(board)
  local boardtop = img.createUISprite(img.ui.brave_shop_top)
  boardtop:setPosition(415, 462)
  board:addChild(boardtop)
  board:setScale(0.1 * view.minScale)
  board:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  local colorCoinBg = img.createUI9Sprite(img.ui.main_coin_bg)
  colorCoinBg:setPreferredSize(CCSizeMake(174, 40))
  colorCoinBg:setPosition(320, 505)
  board:addChild(colorCoinBg, 5)
  local colorCoinIcon = img.createItemIcon(ITEM_ID_COLOR_CRYSTAL)
  colorCoinIcon:setScale(0.517)
  colorCoinIcon:setPosition(CCPoint(5, colorCoinBg:getContentSize().height / 2 + 2))
  colorCoinBg:addChild(colorCoinIcon)
  local colorCoin = bag.items.find(ITEM_ID_COLOR_CRYSTAL)
  local colorCoinLab = lbl.createFont2(16, colorCoin.num, ccc3(255, 246, 223))
  colorCoinLab:setPosition(CCPoint(colorCoinBg:getContentSize().width / 2, colorCoinBg:getContentSize().height / 2 + 2))
  colorCoinBg:addChild(colorCoinLab)
  local lightDarkBg = img.createUI9Sprite(img.ui.main_coin_bg)
  lightDarkBg:setPreferredSize(CCSizeMake(174, 40))
  lightDarkBg:setPosition(514, 505)
  board:addChild(lightDarkBg, 5)
  local lightDarkIcon = img.createItemIcon(ITEM_ID_LIGHT_DARK_CRYSTAL)
  lightDarkIcon:setScale(0.517)
  lightDarkIcon:setPosition(CCPoint(5, lightDarkBg:getContentSize().height / 2 + 2))
  lightDarkBg:addChild(lightDarkIcon)
  local lightDarkCoin = bag.items.find(ITEM_ID_LIGHT_DARK_CRYSTAL)
  local lightDarkCoinLab = lbl.createFont2(16, lightDarkCoin.num, ccc3(255, 246, 223))
  lightDarkCoinLab:setPosition(CCPoint(lightDarkBg:getContentSize().width / 2, lightDarkBg:getContentSize().height / 2 + 2))
  lightDarkBg:addChild(lightDarkCoinLab)
  local showItemLayer = CCLayer:create()
  board:addChild(showItemLayer)
  local createlist = function(l_1_0)
    if showItemLayer and not tolua.isnull(showItemLayer) then
      showItemLayer:removeAllChildrenWithCleanup(true)
    end
    for i = (l_1_0 - 1) * 8 + 1, l_1_0 * 8 do
      if  shopConfig < i then
        return 
      end
      itemBg[i] = createItemWithPos(shopConfig[i], i)
    end
   end
  local ITEM_POS = {1 = {175, 340}, 2 = {335, 340}, 3 = {495, 340}, 4 = {655, 340}, 5 = {175, 175}, 6 = {335, 175}, 7 = {495, 175}, 8 = {655, 175}}
  createItemWithPos = function(l_2_0, l_2_1)
    local item, icon, cost = nil, nil, nil
    local showpos = (l_2_1 - 1) % 8 + 1
    local itemFrame = img.createUISprite(img.ui.casino_shop_frame)
    itemFrame:setPosition(ITEM_POS[showpos][1], ITEM_POS[showpos][2])
    showItemLayer:addChild(itemFrame)
    local menuBg = CCMenu:create()
    menuBg:setPosition(0, 0)
    showItemLayer:addChild(menuBg)
    local goods = l_2_0.getCommodity[1]
    if goods.type == 1 then
      item = img.createItem(goods.id, goods.num)
    else
      item = img.createEquip(goods.id, goods.num)
    end
    local itemBg = SpineMenuItem:create(json.ui.button, item)
    itemBg:setPosition(ITEM_POS[showpos][1], ITEM_POS[showpos][2] + 8)
    menuBg:addChild(itemBg)
    local currency = l_2_0.currencyCount[1]
    icon = img.createItemIcon(currency.id)
    icon:setScale(0.379)
    cost = currency.num
    local menuBuy = CCMenu:create()
    menuBuy:setPosition(0, 0)
    showItemLayer:addChild(menuBuy)
    local buyBtnSprite = img.createUISprite(img.ui.casino_shop_btn)
    local buyBtn = SpineMenuItem:create(json.ui.button, buyBtnSprite)
    buyBtn:setPosition(ITEM_POS[showpos][1], ITEM_POS[showpos][2] - 58)
    buyBtn:setEnabled(true)
    menuBuy:addChild(buyBtn)
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
        local goods = iteminfo.getCommodity[1]
        if goods.type == 1 then
          pbdata.id = goods.id
          tips = tipsitem.createForShow(pbdata)
        elseif goods.type == 2 then
          pbdata.id = goods
          tips = tipsequip.createForShow(pbdata)
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
      local commit = function(l_1_0)
        local param = {sid = player.sid, id = pos, num = l_1_0}
        addWaitNet()
        net:sealland_market_buy(param, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          if l_1_0.status ~= 0 then
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
            return 
          end
          local goods = iteminfo.getCommodity[1]
          if goods.type == 1 then
            bag.items.add({id = goods.id, num = goods.num * buyCount})
            local pop = createPopupPieceBatchSummonResult("item", goods.id, goods.num * buyCount)
            layer:addChild(pop, 100)
          else
            bag.equips.add({id = goods.id, num = goods.num * buyCount})
            local pop = createPopupPieceBatchSummonResult("equip", goods.id, goods.num * buyCount)
            layer:addChild(pop, 100)
          end
          local currency = iteminfo.currencyCount[1]
          if currency.id == ITEM_ID_COLOR_CRYSTAL then
            colorCoinLab:setString(colorCoin.num - cost * buyCount)
          else
            lightDarkCoinLab:setString(lightDarkCoin.num - cost * buyCount)
          end
          bag.items.sub({id = currency.id, num = cost * buyCount})
            end)
         end
      local currency = iteminfo.currencyCount[1]
      if currency.id == ITEM_ID_COLOR_CRYSTAL then
        if colorCoin.num < cost then
          showToast(i18n.global.seal_land_color_crystal_lack.string)
          return 
        end
        if cost * 2 <= colorCoin.num then
          layer:addChild(createBuyLayer(currency.id, cost, commit))
        else
          layer:addChild(createSurebuy(function()
          commit(1)
            end))
        end
      end
      if currency.id == ITEM_ID_LIGHT_DARK_CRYSTAL then
        if lightDarkCoin.num < cost then
          showToast(i18n.global.seal_land_light_dark_crystal_lack.string)
          return 
        end
        if cost * 2 <= lightDarkCoin.num then
          layer:addChild(createBuyLayer(currency.id, cost, commit))
        else
          layer:addChild(createSurebuy(function()
          commit(1)
            end))
        end
      end
      end)
    return itemBg
   end
  local init = function()
    createlist(currentPage)
   end
  layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.02), CCCallFunc:create(init)))
  local circlePos = {}
  if maxPage > 1 then
    for i = 1, maxPage do
      circlePos[ circlePos + 1] = {400 + (i - 1) * 30, 60}
      local circledark1 = img.createUISprite(img.ui.shop_circle_dark)
      circledark1:setPosition(circlePos[i][1], circlePos[i][2])
      board:addChild(circledark1)
    end
    local circlelight = img.createUISprite(img.ui.shop_circle_light)
    circlelight:setPosition(circlePos[1][1], circlePos[1][2])
    board:addChild(circlelight, 1)
  end
  local showdot = function(l_4_0)
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
  layer:registerScriptHandler(function(l_12_0)
    if l_12_0 == "enter" then
      onEnter()
    elseif l_12_0 == "exit" then
      onExit()
    end
   end)
  layer:setTouchEnabled(true)
  return layer
end

return ui

