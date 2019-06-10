-- Command line was: E:\github\dhgametool\scripts\ui\blackmarket\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local net = require("net.netClient")
local player = require("data.player")
local bag = require("data.bag")
local datablackmarket = require("data.blackmarket")
local cfgblackmarket = require("config.blackmarket")
local cfgequip = require("config.equip")
local cfgitem = require("config.item")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local midas = require("ui.midas.main")
local gemshop = require("ui.shop.main")
local MARKETTIME = 10800
local REFRESHGEM = 20
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
    local itemBtn = SpineMenuItem:create(json.ui.button, item)
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
  local layer = CCLayer:create()
  local isBuy = {}
  local itemBg = {}
  local refresh = 0
  local setAlreadyBuy, createItemWithPos = nil, nil
  local circlePos = {}
  local circles = {}
  local circleLight = nil
  local currentPage = 1
  local maxPage = 1
  local pullFinish = false
  img.load(img.packedOthers.ui_blackmarket_bg)
  json.load(json.ui.heishi)
  local aniBlackmarket = DHSkeletonAnimation:createWithKey(json.ui.heishi)
  aniBlackmarket:setScale(view.minScale)
  aniBlackmarket:scheduleUpdateLua()
  aniBlackmarket:playAnimation("start")
  aniBlackmarket:registerAnimation("loop", -1)
  aniBlackmarket:setPosition(scalep(480, 288))
  layer:addChild(aniBlackmarket, 100)
  json.load(json.ui.heishishangren)
  local aniShangren = DHSkeletonAnimation:createWithKey(json.ui.heishishangren)
  aniShangren:scheduleUpdateLua()
  aniShangren:playAnimation("stand", -1)
  aniShangren:setPosition(scalep(480, 288))
  aniShangren:setScale(view.minScale)
  layer:addChild(aniShangren, 99)
  schedule(layer, 1, function()
    aniBlackmarket:registerAnimation("loop2", -1)
   end)
  local bg = img.createUISprite(img.ui.blackmarket_bg)
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
  local tableLayer = CCLayer:create()
  tableLayer:setPosition(-480, -288)
  aniBlackmarket:addChildFollowSlot("code_icons", tableLayer)
  local showItemLayer = CCLayer:create()
  tableLayer:addChild(showItemLayer)
  local createCircles = function()
    currentPage = 1
    upvalue_512 = math.floor((#datablackmarket.goods - 1) / 8) + 1
    for i = 1, #circles do
      if not tolua.isnull(circles[i]) then
        circles[i]:removeFromParentAndCleanup(true)
      end
    end
    upvalue_2048 = {}
    if maxPage > 1 then
      for i = 1, maxPage do
        circlePos[#circlePos + 1] = {444 + (i - 1) * 30, 10}
        local circleDark = img.createUISprite(img.ui.shop_circle_dark)
        circleDark:setPosition(circlePos[i][1], circlePos[i][2])
        tableLayer:addChild(circleDark, 10000)
        circles[#circles + 1] = circleDark
      end
      if circleLight and not tolua.isnull(circleLight) then
        circleLight:removeFromParentAndCleanup(true)
      end
      upvalue_3584 = img.createUISprite(img.ui.shop_circle_light)
      circleLight:setPosition(circlePos[1][1], circlePos[1][2])
      tableLayer:addChild(circleLight, 10000)
    end
   end
  local createlist = function(l_3_0)
    showItemLayer:removeAllChildrenWithCleanup(true)
    local start = (currentPage - 1) * 8 + 1
    local stop = start + 7
    if #datablackmarket.goods < stop then
      stop = #datablackmarket.goods
    end
    for i = start, stop do
      local itemConfig = datablackmarket.goods[i]
      if itemConfig.limitNumb <= datablackmarket.buy[itemConfig.id] then
        isBuy[i] = true
      else
        isBuy[i] = false
      end
      itemBg[i] = createItemWithPos(datablackmarket.goods[i], i)
      if l_3_0 then
        json.load(json.ui.ic_refresh)
        local aniRef = DHSkeletonAnimation:createWithKey(json.ui.ic_refresh)
        aniRef:scheduleUpdateLua()
        aniRef:playAnimation("animation")
        aniRef:setPosition(itemBg[i]:getContentSize().width / 2, itemBg[i]:getContentSize().height / 2)
        itemBg[i]:addChild(aniRef, 100)
      end
      if itemConfig.limitNumb <= datablackmarket.buy[itemConfig.id] then
        setAlreadyBuy(i)
      end
    end
   end
  local showPage = function()
    createlist()
    circleLight:setPosition(circlePos[currentPage][1], circlePos[currentPage][2])
   end
  local createSurebuy = function(l_5_0, l_5_1, l_5_2, l_5_3)
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
      param.index = iteminfo.id
      param.type = iteminfo.cost.type
      param.count = iteminfo.cost.count
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if param.type == 1 and bag.coin() < cost then
        showToast(i18n.global.blackmarket_coin_lack.string)
        return 
        do return end
         -- DECOMPILER ERROR: unhandled construct in 'if'

        if param.type == 2 and bag.gem() < cost then
          showToast(i18n.global.summon_gem_lack.string)
          return 
          do return end
          if bag.items.find(ITEM_ID_SMITH_CRYSTAL).num < cost then
            showToast(i18n.global.blackmarket_essence_lack.string)
            return 
          end
        end
      end
      tbl2string(param)
      addWaitNet()
      net:bmarket_buy(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        if l_1_0.bag.equips then
          bag.equips.addAll(l_1_0.bag.equips)
          local reward = l_1_0.bag.equips[1]
          local pop = createPopupPieceBatchSummonResult("equip", reward.id, reward.num)
          layer:addChild(pop, 100)
        end
        if l_1_0.bag.items then
          bag.items.addAll(l_1_0.bag.items)
          local reward = l_1_0.bag.items[1]
          local pop = createPopupPieceBatchSummonResult("item", reward.id, reward.num)
          layer:addChild(pop, 100)
        end
        if param.type == 1 then
          bag.subCoin(cost)
        else
          if param.type == 2 then
            bag.subGem(cost)
          else
            bag.items.sub({id = ITEM_ID_SMITH_CRYSTAL, num = cost})
          end
        end
        datablackmarket.buy[iteminfo.id] = datablackmarket.buy[iteminfo.id] + 1
        if iteminfo.limitNumb <= datablackmarket.buy[iteminfo.id] then
          setAlreadyBuy(pos)
          if buyBtn and not tolua.isnull(buyBtn) then
            setShader(buyBtn, SHADER_GRAY, true)
            buyBtn:setEnabled(false)
          end
        end
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
  local refreshlab = lbl.createFont2(14, i18n.global.blackmarket_refresh.string, ccc3(255, 246, 223))
  refreshlab:setPosition(CCPoint(473, 310))
  refreshlab:setAnchorPoint(1, 0.5)
  tableLayer:addChild(refreshlab)
  local showTimeLab = lbl.createFont2(14, "", ccc3(165, 253, 71))
  showTimeLab:setAnchorPoint(0, 0.5)
  showTimeLab:setPosition(490, 310)
  tableLayer:addChild(showTimeLab)
  local lefMenu = CCMenu:create()
  lefMenu:setPosition(0, 0)
  tableLayer:addChild(lefMenu)
  local lefBtnSprite = img.createUISprite(img.ui.right_next)
  lefBtnSprite:setFlipY(true)
  local lefBtn = HHMenuItem:create(lefBtnSprite)
  lefBtn:setRotation(180)
  lefBtn:setScale(0.75)
  lefBtn:setPosition(99, 192)
  if currentPage <= 1 then
    lefBtn:setVisible(false)
  end
  lefMenu:addChild(lefBtn)
  local rigMenu = CCMenu:create()
  rigMenu:setPosition(0, 0)
  tableLayer:addChild(rigMenu)
  local rigBtnSprite = img.createUISprite(img.ui.right_next)
  local rigBtn = HHMenuItem:create(rigBtnSprite)
  rigBtn:setScale(0.75)
  rigBtn:setPosition(864, 192)
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
    showPage()
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
    showPage()
   end)
  autoLayoutShift(lefBtn)
  setAlreadyBuy = function(l_8_0)
    if not itemBg[l_8_0] or tolua.isnull(itemBg[l_8_0]) then
      return 
    end
    setShader(itemBg[l_8_0], SHADER_GRAY, true)
    itemBg[l_8_0]:setEnabled(false)
    local soldout = img.createUISprite(img.ui.blackmarket_soldout)
    soldout:setPosition(CCPoint(itemBg[l_8_0]:getContentSize().width / 2, itemBg[l_8_0]:getContentSize().height / 2))
    itemBg[l_8_0]:addChild(soldout)
   end
  local ITEM_POS = {1 = {252, 250}, 2 = {402, 250}, 3 = {552, 250}, 4 = {702, 250}, 5 = {252, 114}, 6 = {402, 114}, 7 = {552, 114}, 8 = {702, 114}}
  createItemWithPos = function(l_9_0, l_9_1)
    local position = l_9_1 % 8
    if position == 0 then
      position = 8
    end
    local item, icon, cost = nil, nil, nil
    local menuBg = CCMenu:create()
    menuBg:setPosition(0, 0)
    showItemLayer:addChild(menuBg)
    if l_9_0.type == 1 then
      item = img.createItem(l_9_0.excelId, l_9_0.numb)
    elseif l_9_0.type == 2 then
      item = img.createEquip(l_9_0.excelId, l_9_0.numb)
    end
    local itemBg = SpineMenuItem:create(json.ui.button, item)
    itemBg:setScale(0.9)
    itemBg:setPosition(ITEM_POS[position][1], ITEM_POS[position][2])
    menuBg:addChild(itemBg)
    if l_9_0.cost.type == 1 then
      icon = img.createItemIcon2(ITEM_ID_COIN)
      cost = l_9_0.cost.count
    else
      if l_9_0.cost.type == 2 then
        icon = img.createItemIcon2(ITEM_ID_GEM)
        cost = l_9_0.cost.count
      else
        icon = img.createItemIcon2(ITEM_ID_SMITH_CRYSTAL)
        cost = l_9_0.cost.count
      end
    end
    local menuBuy = CCMenu:create()
    menuBuy:setPosition(0, 0)
    showItemLayer:addChild(menuBuy)
    local buyBtnSprite = img.createUISprite(img.ui.blackmarket_btn_buy)
    icon:setAnchorPoint(ccp(0, 0.5))
    icon:setScale(0.75)
    icon:setPosition(10, buyBtnSprite:getContentSize().height / 2)
    buyBtnSprite:addChild(icon)
    local buyBtn = SpineMenuItem:create(json.ui.button, buyBtnSprite)
    buyBtn:setPosition(ITEM_POS[position][1], ITEM_POS[position][2] - 65)
    buyBtn:setEnabled(isBuy[l_9_1] == false)
    menuBuy:addChild(buyBtn)
    if isBuy[l_9_1] then
      setShader(buyBtn, SHADER_GRAY, true)
    end
    local costLabel = lbl.createFont2(14, convertItemNum(cost), ccc3(255, 246, 223))
    local x = (buyBtn:getContentSize().width - icon:boundingBox():getMaxX()) / 2
    costLabel:setPosition(x + icon:boundingBox():getMaxX() - 5, buyBtnSprite:getContentSize().height / 2 - 1)
    buyBtnSprite:addChild(costLabel)
    layer.tipsTag = false
    itemBg:registerScriptTapHandler(function()
      audio.play(audio.button)
      local tips = nil
      local pbdata = {}
      if layer.tipsTag == false then
        layer.tipsTag = true
        if iteminfo.type == 1 then
          pbdata.id = iteminfo.excelId
          tips = tipsitem.createForShow(pbdata)
        else
          if iteminfo.type == 2 then
            pbdata.id = iteminfo.excelId
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
  local refreshUI = function()
    createCircles()
    createlist(true)
    upvalue_1024 = math.max(0, datablackmarket.refresh - os.time())
    if maxPage <= 1 then
      lefBtn:setVisible(false)
      rigBtn:setVisible(false)
    else
      lefBtn:setVisible(false)
      rigBtn:setVisible(true)
    end
   end
  local pullData = function(l_11_0)
    pullFinish = false
    addWaitNet()
    net:bmarket_pull(l_11_0, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      datablackmarket.init(l_1_0, true)
      refreshUI()
      upvalue_1536 = true
      end)
   end
  json.load(json.ui.clock)
  local init = function()
    local param = {}
    param.sid = player.sid
    param.type = 1
    pullData(param)
   end
  local onUpdate = function()
    if pullFinish then
      upvalue_512 = math.max(0, datablackmarket.refresh - os.time())
      local timeLab = string.format("%02d:%02d:%02d", math.floor(refresh / 3600), math.floor(refresh % 3600 / 60), math.floor(refresh % 60))
      showTimeLab:setString(timeLab)
      if refresh <= 0 then
        init()
      end
    end
   end
  layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.02), CCCallFunc:create(init)))
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  local moneybar = require("ui.moneybar")
  layer:addChild(moneybar.create(), 100)
  local back0 = img.createUISprite(img.ui.back)
  local backBtn = HHMenuItem:create(back0)
  backBtn:setScale(view.minScale)
  backBtn:setPosition(scalep(35, 546))
  local backMenu = CCMenu:createWithItem(backBtn)
  backMenu:setPosition(0, 0)
  layer:addChild(backMenu)
  local backEvent = function()
    audio.play(audio.button)
    replaceScene(require("ui.town.main").create())
   end
  backBtn:registerScriptTapHandler(function()
    backEvent()
   end)
  autoLayoutShift(backBtn)
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
  layer:registerScriptHandler(function(l_19_0)
    if l_19_0 == "enter" then
      onEnter()
    elseif l_19_0 == "exit" then
      onExit()
    elseif l_19_0 == "cleanup" then
      img.unload(img.packedOthers.ui_blackmarket_bg)
    end
   end)
  require("ui.tutorial").show("ui.bmarket.main", layer)
  return layer
end

return ui

