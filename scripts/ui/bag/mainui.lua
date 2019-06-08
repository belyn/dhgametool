-- Command line was: E:\github\dhgametool\scripts\ui\bag\mainui.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local lbl = require("res.lbl")
local audio = require("res.audio")
local i18n = require("res.i18n")
local baglayer = require("ui.bag.bag")
local bagdata = require("data.bag")
local herosdata = require("data.heros")
local player = require("data.player")
local cfgvip = require("config.vip")
local cfgequip = require("config.equip")
local cfgitem = require("config.item")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local tipssummon = require("ui.tips.summon")
local tipssell = require("ui.tips.sell")
local tipsgift = require("ui.tips.gift")
local net = require("net.netClient")
local cfgactivity = require("config.activity")
local treasureshow = require("ui.bag.treasureshow")
local createPopupPieceBatchSummonResult = function(l_1_0, l_1_1, l_1_2)
  local params = {}
  params.title = i18n.global.reward_will_get.string
  params.btn_count = 0
  local dialog = require("ui.dialog").create(params)
  local back = img.createLogin9Sprite(img.login.button_9_small_gold)
  back:setPreferredSize(CCSize(153, 50))
  local comfirlab = lbl.createFont1(18, i18n.global.summon_comfirm.string, lbl.buttonColor)
  comfirlab:setPosition(CCPoint(back:getContentSize().width / 2, back:getContentSize().height / 2))
  back:addChild(comfirlab)
  local backBtn = SpineMenuItem:create(json.ui.button, back)
  backBtn:setPosition(CCPoint(dialog.board:getContentSize().width / 2, 80))
  local menu = CCMenu:createWithItem(backBtn)
  menu:setPosition(0, 0)
  dialog.board:addChild(menu)
  autoLayoutShift(backBtn)
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
  elseif l_1_0 == "equip" then
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
  else
    local hero = img.createHeroHead(l_1_1, 1, true, true)
    heroBtn = SpineMenuItem:create(json.ui.button, hero)
    heroBtn:setScale(0.7)
    heroBtn:setPosition(dialog.board:getContentSize().width / 2, 185)
    local countLbl = lbl.createFont2(20, string.format("X%d", l_1_2), ccc3(255, 246, 223))
    countLbl:setAnchorPoint(ccp(0, 0.5))
    countLbl:setPosition(heroBtn:boundingBox():getMaxX() + 10, 185)
    dialog.board:addChild(countLbl)
    local iconMenu = CCMenu:createWithItem(heroBtn)
    iconMenu:setPosition(0, 0)
    dialog.board:addChild(iconMenu)
    heroBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      local herotips = require("ui.tips.hero")
      local tips = herotips.create(id)
      dialog:addChild(tips, 1001)
      end)
  end
  backBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    dialog:removeFromParentAndCleanup()
   end)
  return dialog
end

ui.create = function(l_2_0, l_2_1)
  local currentbag = "equip"
  if l_2_1 then
    currentbag = l_2_1
  end
  local layer = baglayer.create()
  local currentBatch = ""
  local moneybar = require("ui.moneybar")
  layer:addChild(moneybar.create(), 100)
  local equipTab0 = img.createUISprite(img.ui.bag_tab_equip0)
  local equipTab1 = img.createUISprite(img.ui.bag_tab_equip1)
  local equipTab = CCMenuItemSprite:create(equipTab0, nil, equipTab1)
  equipTab:setScale(view.minScale)
  equipTab:setAnchorPoint(0, 0.5)
  equipTab:setPosition(scalep(866, 437))
  equipTab:setEnabled(currentbag ~= "equip")
  local equipMenu = CCMenu:createWithItem(equipTab)
  equipMenu:setPosition(0, 0)
  layer:addChild(equipMenu, 3)
  local tabWidth, tabHeight = 78, 94
  local itemTab0 = img.createUI9Sprite(img.ui.bag_tab_item0)
  itemTab1 = img.createUI9Sprite(img.ui.bag_tab_item0)
  itemTab2 = img.createUI9Sprite(img.ui.bag_tab_item1)
  local itemTab = CCMenuItemSprite:create(itemTab0, itemTab1, itemTab2)
  itemTab:setScale(view.minScale)
  itemTab:setAnchorPoint(0, 0.5)
  itemTab:setPosition(scalep(866, 346))
  itemTab:setEnabled(currentbag ~= "item")
  local itemMenu = CCMenu:createWithItem(itemTab)
  itemMenu:setPosition(0, 0)
  layer:addChild(itemMenu, 3)
  local pieceTab0 = img.createUISprite(img.ui.bag_tab_piece0)
  pieceTab1 = img.createUISprite(img.ui.bag_tab_piece1)
  local pieceTab = CCMenuItemSprite:create(pieceTab0, nil, pieceTab1)
  pieceTab:setScale(view.minScale)
  pieceTab:setAnchorPoint(0, 0.5)
  pieceTab:setPosition(scalep(866, 255))
  pieceTab:setEnabled(currentbag ~= "piece")
  addRedDot(pieceTab, {px = pieceTab:getContentSize().width - 10, py = pieceTab:getContentSize().height - 10})
  delRedDot(pieceTab)
  local pieceMenu = CCMenu:createWithItem(pieceTab)
  pieceMenu:setPosition(0, 0)
  layer:addChild(pieceMenu, 3)
  local onUpdate = function(l_1_0)
    if bagdata.showRedDot() then
      addRedDot(pieceTab, {px = pieceTab:getContentSize().width - 10, py = pieceTab:getContentSize().height - 10})
    else
      delRedDot(pieceTab)
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  local treasureTab0 = img.createUISprite(img.ui.bag_tab_treasure_0)
  local treasureTab1 = img.createUISprite(img.ui.bag_tab_treasure_1)
  local treasureTab = CCMenuItemSprite:create(treasureTab0, nil, treasureTab1)
  treasureTab:setScale(view.minScale)
  treasureTab:setAnchorPoint(0, 0.5)
  treasureTab:setPosition(scalep(866, 164))
  treasureTab:setEnabled(currentbag ~= "equippiece")
  local treasureMenu = CCMenu:createWithItem(treasureTab)
  treasureMenu:setPosition(0, 0)
  layer:addChild(treasureMenu, 4)
  local orangeBatchbtn0 = img.createUISprite(img.ui.bag_btn_orange)
  local orangeBatchBtn = HHMenuItem:create(orangeBatchbtn0)
  orangeBatchBtn:setScale(view.minScale)
  orangeBatchBtn:setPosition(scalep(326, 62))
  local orangeBatchMenu = CCMenu:createWithItem(orangeBatchBtn)
  orangeBatchMenu:setPosition(0, 0)
  layer:addChild(orangeBatchMenu)
  local redBatchbtn0 = img.createUISprite(img.ui.bag_btn_red)
  local redBatchBtn = HHMenuItem:create(redBatchbtn0)
  redBatchBtn:setScale(view.minScale)
  redBatchBtn:setPosition(scalep(385, 62))
  local redBatchMenu = CCMenu:createWithItem(redBatchBtn)
  redBatchMenu:setPosition(0, 0)
  layer:addChild(redBatchMenu)
  local greenBatchbtn0 = img.createUISprite(img.ui.bag_btn_green)
  local greenBatchBtn = HHMenuItem:create(greenBatchbtn0)
  greenBatchBtn:setScale(view.minScale)
  greenBatchBtn:setPosition(scalep(448, 62))
  local greenBatchMenu = CCMenu:createWithItem(greenBatchBtn)
  greenBatchMenu:setPosition(0, 0)
  layer:addChild(greenBatchMenu)
  local purpleBatchbtn0 = img.createUISprite(img.ui.bag_btn_purple)
  local purpleBatchBtn = HHMenuItem:create(purpleBatchbtn0)
  purpleBatchBtn:setScale(view.minScale)
  purpleBatchBtn:setPosition(scalep(510, 62))
  local purpleBatchMenu = CCMenu:createWithItem(purpleBatchBtn)
  purpleBatchMenu:setPosition(0, 0)
  layer:addChild(purpleBatchMenu)
  local yellowBatchbtn0 = img.createUISprite(img.ui.bag_btn_yellow)
  local yellowBatchBtn = HHMenuItem:create(yellowBatchbtn0)
  yellowBatchBtn:setScale(view.minScale)
  yellowBatchBtn:setPosition(scalep(572, 62))
  local yellowBatchMenu = CCMenu:createWithItem(yellowBatchBtn)
  yellowBatchMenu:setPosition(0, 0)
  layer:addChild(yellowBatchMenu)
  local blueBatchbtn0 = img.createUISprite(img.ui.bag_btn_blue)
  local blueBatchBtn = HHMenuItem:create(blueBatchbtn0)
  blueBatchBtn:setScale(view.minScale)
  blueBatchBtn:setPosition(scalep(634, 62))
  local blueBatchMenu = CCMenu:createWithItem(blueBatchBtn)
  blueBatchMenu:setPosition(0, 0)
  layer:addChild(blueBatchMenu)
  local selectBatch = img.createUISprite(img.ui.bag_dianji)
  selectBatch:setScale(view.minScale)
  selectBatch:setPosition(-1000, -1000)
  layer:addChild(selectBatch)
  local treasurebtn0 = img.createUISprite(img.ui.bag_btn_shenqi)
  local treasureBtn = HHMenuItem:create(treasurebtn0)
  treasureBtn:setAnchorPoint(0.5, 1)
  treasureBtn:setScale(view.minScale)
  treasureBtn:setPosition(scalep(780, 97))
  local treasureMenu = CCMenu:createWithItem(treasureBtn)
  treasureMenu:setPosition(0, 0)
  layer:addChild(treasureMenu)
  local currentfilter = 0
  local showEquips = function(l_2_0)
    local eqs = {}
    for i,eq in ipairs(bagdata.equips) do
      if (l_2_0 == 0 or l_2_0 == cfgequip[eq.id].qlt) and cfgequip[eq.id].pos ~= EQUIP_POS_TREASURE and cfgequip[eq.id].pos ~= EQUIP_POS_SKIN then
        eqs[ eqs + 1] = eq
      end
    end
    layer.showEquips(eqs)
   end
  local showItems = function()
    local items = {}
    for i,t in ipairs(bagdata.items) do
      if cfgitem[t.id] and cfgitem[t.id].type == ITEM_KIND_ITEM and t.num > 0 then
        items[ items + 1] = t
      end
    end
    layer.showItems(items)
   end
  local showPieces = function()
    local pieces = {}
    for i,t in ipairs(bagdata.items) do
      if cfgitem[t.id] and (cfgitem[t.id].type == ITEM_KIND_HERO_PIECE or cfgitem[t.id].type == ITEM_KIND_TREASURE_PIECE) and t.num > 0 then
        pieces[ pieces + 1] = t
      end
    end
    layer.showPieces(pieces)
   end
  local showTreasure = function(l_5_0)
    local treasureAry = {}
    for i,eq in ipairs(bagdata.equips) do
      if cfgequip[eq.id].pos == EQUIP_POS_TREASURE and (l_5_0 == 0 or l_5_0 == cfgequip[eq.id].qlt) then
        treasureAry[ treasureAry + 1] = eq
      end
    end
    layer.showTreasure(treasureAry)
   end
  local setBagBtnsStatus = function()
    equipTab:setEnabled(currentbag ~= "equip")
    itemTab:setEnabled(currentbag ~= "item")
    pieceTab:setEnabled(currentbag ~= "piece")
    treasureTab:setEnabled(currentbag ~= "treasure")
    selectBatch:setVisible(currentbag == "equip" or currentbag == "treasure")
    orangeBatchBtn:setVisible(currentbag == "equip" or currentbag == "treasure")
    redBatchBtn:setVisible(currentbag == "equip" or currentbag == "treasure")
    greenBatchBtn:setVisible(currentbag == "equip" or currentbag == "treasure")
    purpleBatchBtn:setVisible(currentbag == "equip" or currentbag == "treasure")
    yellowBatchBtn:setVisible(currentbag == "equip" or currentbag == "treasure")
    blueBatchBtn:setVisible(currentbag == "equip" or currentbag == "treasure")
    treasureBtn:setVisible(currentbag == "treasure")
   end
  local showBag = function()
    setBagBtnsStatus()
    if currentbag == "equip" then
      showEquips(currentfilter)
    elseif currentbag == "item" then
      showItems()
    elseif currentbag == "piece" then
      showPieces()
    elseif currentbag == "treasure" then
      showTreasure(currentfilter)
    end
   end
  equipTab:registerScriptTapHandler(function()
    currentbag = "equip"
    showBag()
    audio.play(audio.button)
   end)
  itemTab:registerScriptTapHandler(function()
    currentbag = "item"
    showBag()
    audio.play(audio.button)
   end)
  pieceTab:registerScriptTapHandler(function()
    currentbag = "piece"
    showBag()
    audio.play(audio.button)
   end)
  treasureTab:registerScriptTapHandler(function()
    currentbag = "treasure"
    showBag()
    audio.play(audio.button)
   end)
  orangeBatchBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if currentfilter == 6 then
      upvalue_512 = 0
      selectBatch:setVisible(false)
      if currentbag == "equip" then
        showEquips(currentfilter)
      elseif currentbag == "treasure" then
        showTreasure(currentfilter)
      end
      return 
    end
    selectBatch:setVisible(true)
    selectBatch:setPosition(scalep(326, 65))
    upvalue_512 = 6
    if currentbag == "equip" then
      showEquips(currentfilter)
    elseif currentbag == "treasure" then
      showTreasure(currentfilter)
    end
   end)
  redBatchBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if currentfilter == 5 then
      upvalue_512 = 0
      selectBatch:setVisible(false)
      if currentbag == "equip" then
        showEquips(currentfilter)
      elseif currentbag == "treasure" then
        showTreasure(currentfilter)
      end
      return 
    end
    selectBatch:setVisible(true)
    selectBatch:setPosition(scalep(385, 65))
    upvalue_512 = 5
    if currentbag == "equip" then
      showEquips(currentfilter)
    elseif currentbag == "treasure" then
      showTreasure(currentfilter)
    end
   end)
  greenBatchBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if currentfilter == 4 then
      upvalue_512 = 0
      selectBatch:setVisible(false)
      if currentbag == "equip" then
        showEquips(currentfilter)
      elseif currentbag == "treasure" then
        showTreasure(currentfilter)
      end
      return 
    end
    selectBatch:setVisible(true)
    selectBatch:setPosition(scalep(448, 65))
    upvalue_512 = 4
    if currentbag == "equip" then
      showEquips(currentfilter)
    elseif currentbag == "treasure" then
      showTreasure(currentfilter)
    end
   end)
  purpleBatchBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if currentfilter == 3 then
      upvalue_512 = 0
      selectBatch:setVisible(false)
      if currentbag == "equip" then
        showEquips(currentfilter)
      elseif currentbag == "treasure" then
        showTreasure(currentfilter)
      end
      return 
    end
    selectBatch:setVisible(true)
    selectBatch:setPosition(scalep(510, 65))
    upvalue_512 = 3
    if currentbag == "equip" then
      showEquips(currentfilter)
    elseif currentbag == "treasure" then
      showTreasure(currentfilter)
    end
   end)
  yellowBatchBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if currentfilter == 2 then
      upvalue_512 = 0
      selectBatch:setVisible(false)
      if currentbag == "equip" then
        showEquips(currentfilter)
      elseif currentbag == "treasure" then
        showTreasure(currentfilter)
      end
      return 
    end
    selectBatch:setVisible(true)
    selectBatch:setPosition(scalep(572, 65))
    upvalue_512 = 2
    if currentbag == "equip" then
      showEquips(currentfilter)
    elseif currentbag == "treasure" then
      showTreasure(currentfilter)
    end
   end)
  blueBatchBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if currentfilter == 1 then
      upvalue_512 = 0
      selectBatch:setVisible(false)
      if currentbag == "equip" then
        showEquips(currentfilter)
      elseif currentbag == "treasure" then
        showTreasure(currentfilter)
      end
      return 
    end
    selectBatch:setVisible(true)
    selectBatch:setPosition(scalep(634, 65))
    upvalue_512 = 1
    if currentbag == "equip" then
      showEquips(currentfilter)
    elseif currentbag == "treasure" then
      showTreasure(currentfilter)
    end
   end)
  treasureBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(treasureshow.create(), 2000)
   end)
  local onSellItem = function(l_19_0)
    if layer.sellPopul then
      layer.sellPopul:removeFromParent()
      layer.sellPopul = nil
    end
    if layer.tipsTag then
      layer.tipsTag = false
      layer.tips:removeFromParent()
      layer.sellPopul = nil
    end
    local paramItems = {}
    paramItems[ paramItems + 1] = l_19_0
    local param = {}
    param.sid = player.sid
    param.items = paramItems
    addWaitNet()
    net:sell(param, function(l_1_0)
      tbl2string(l_1_0)
      delWaitNet()
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      bagdata.items.sub(item)
      bagdata.addCoin(l_1_0.item.num)
      showBag()
      local pop = createPopupPieceBatchSummonResult("item", ITEM_ID_COIN, l_1_0.item.num)
      layer:addChild(pop, 100)
      end)
   end
  local onOpenGift = function(l_20_0)
    if layer.giftPopul then
      layer.giftPopul:removeFromParent()
      layer.giftPopul = nil
    end
    if layer.tipsTag then
      layer.tipsTag = false
      layer.tips:removeFromParent()
      layer.giftPopul = nil
    end
    local paramItems = {}
    paramItems[ paramItems + 1] = l_20_0
    local param = {}
    param.sid = player.sid
    param.item = l_20_0.id
    param.num = l_20_0.num
    addWaitNet()
    net:open_gift(param, function(l_1_0)
      tbl2string(l_1_0)
      delWaitNet()
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      bagdata.items.sub(item)
      bagdata.addRewards(l_1_0.reward)
      showBag()
      local rw = tablecp(l_1_0.reward)
      layer:addChild(require("ui.reward").showReward(rw), 1000)
      end)
   end
  local onSellEquip = function(l_21_0)
    if layer.sellPopul then
      layer.sellPopul:removeFromParent()
      layer.sellPopul = nil
    end
    if layer.tipsTag then
      layer.tipsTag = false
      layer.tips:removeFromParent()
      layer.tips = nil
    end
    local paramItems = {}
    paramItems[ paramItems + 1] = l_21_0
    local param = {}
    param.sid = player.sid
    param.equips = paramItems
    addWaitNet()
    net:sell(param, function(l_1_0)
      tbl2string(l_1_0)
      delWaitNet()
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      bagdata.equips.sub(item)
      bagdata.addCoin(l_1_0.item.num)
      showBag()
      local pop = createPopupPieceBatchSummonResult("item", ITEM_ID_COIN, l_1_0.item.num)
      layer:addChild(pop, 100)
      end)
   end
  local onPopupSell = function(l_22_0)
    onSellItem(l_22_0)
   end
  local onPopupGift = function(l_23_0)
    onOpenGift(l_23_0)
   end
  local onEquipPopupSell = function(l_24_0)
    onSellEquip(l_24_0)
   end
  local back0 = img.createUISprite(img.ui.back)
  local backBtn = HHMenuItem:create(back0)
  backBtn:setScale(view.minScale)
  backBtn:setPosition(scalep(35, 546))
  local backMenu = CCMenu:createWithItem(backBtn)
  backMenu:setPosition(0, 0)
  layer:addChild(backMenu)
  local backEvent = function()
    audio.play(audio.button)
    if backlayer == "hook" then
      replaceScene(require("ui.hook.main").create())
    else
      replaceScene(require("ui.town.main").create())
    end
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
    showBag()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_30_0)
    if l_30_0 == "enter" then
      onEnter()
    elseif l_30_0 == "exit" then
      onExit()
    end
   end)
  layer.tipsTag = false
  layer.tipssTag = false
  local onClickPieceInfo = function(l_31_0)
    if layer.tipsTag then
      layer.tips:removeFromParent()
      layer.tipsTag = false
    end
   end
  local onClickPieceSummon = function(l_32_0)
    if layer.tipsTag then
      layer.tips:removeFromParent()
      layer.tipsTag = false
    end
    if layer.tipssTag then
      if layer.tipss and not tolua.isnull(layer.tipss) then
        layer.tipss:removeFromParent()
        layer.tipss = nil
      end
      layer.tipssTag = false
    end
    local costCount = cfgitem[l_32_0.id].heroCost.count
    local capacityNum = cfgvip[player.vipLv()].heroes + player.buy_hlimit * 5 -  herosdata
    local availableNum = math.floor(l_32_0.num / costCount)
    local num = math.min(capacityNum, availableNum)
    if num <= 0 then
      local gotoHeroDlg = require("ui.summon.tipsdialog")
      gotoHeroDlg.show(layer)
      return 
    end
    local param = {}
    param.sid = player.sid
    param.item = {id = l_32_0.id, num = costCount * num}
    addWaitNet()
    net:hero_merge(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. l_1_0.status)
        return 
      end
      local activityData = require("data.activity")
      local IDS = activityData.IDS
      local cfghero = require("config.hero")
      for i = 1,  l_1_0.heroes do
        if cfghero[l_1_0.heroes[i].id].maxStar ~= 5 then
          do return end
        end
        local tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_1.ID)
        if cfghero[l_1_0.heroes[i].id].group == 2 then
          tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_2.ID)
        end
        if cfghero[l_1_0.heroes[i].id].group == 3 then
          tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_3.ID)
        end
        if cfghero[l_1_0.heroes[i].id].group == 4 then
          tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_4.ID)
        end
        if cfghero[l_1_0.heroes[i].id].group == 5 then
          tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_5.ID)
        end
        if cfghero[l_1_0.heroes[i].id].group == 6 then
          tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_6.ID)
        end
        if tmp_status and tmp_status.limits and tmp_status.limits < cfgactivity[tmp_status.id].parameter[1].num then
          tmp_status.limits = tmp_status.limits + 1
          local tmp_status7 = activityData.getStatusById(IDS.HERO_SUMMON_7.ID)
          if tmp_status.limits == cfgactivity[tmp_status.id].parameter[1].num and tmp_status7.limits <  cfgactivity[tmp_status7.id].parameter then
            tmp_status7.limits = tmp_status7.limits + 1
          end
        end
      end
      herosdata.addAll(l_1_0.heroes)
      bagdata.items.sub({id = piece.id, num = costCount *  l_1_0.heroes})
      showBag()
      if isUniversalPiece(piece.id) then
        if  l_1_0.heroes == 1 then
          local pop = createPopupPieceBatchSummonResult("hero", l_1_0.heroes[1].id,  l_1_0.heroes)
          layer:addChild(pop, 100)
        else
          layer:addChild(require("ui.bag.summonshow").create(l_1_0.heroes, i18n.global.tips_summon.string), 1000)
        end
      else
        local pop = createPopupPieceBatchSummonResult("hero", l_1_0.heroes[1].id,  l_1_0.heroes)
        layer:addChild(pop, 100)
      end
      require("data.christmas").onGetHeroes(l_1_0.heroes)
      require("data.tutorial").goNext("piece", 1, true)
      end)
   end
  local onClickPieceSummonShow = function(l_33_0)
    if layer.tipsTag then
      layer.tips:removeFromParent()
      layer.tipsTag = false
    end
    layer.tipssTag = true
    layer.tipss = tipssummon.create("items", l_33_0, onClickPieceSummon)
    layer:addChild(layer.tipss, 100)
   end
  local onClickPieceSummonForTreasure = function(l_34_0)
    if layer.tipsTag then
      layer.tips:removeFromParent()
      layer.tipsTag = false
    end
    local costCount = cfgitem[l_34_0.id].treasureCost.count
    local param = {}
    param.sid = player.sid
    param.item = {id = l_34_0.id, num = costCount}
    addWaitNet()
    net:merge_treasure(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. l_1_0.status)
        return 
      end
      bagdata.equips.add({id = l_1_0.id, num = 1})
      bagdata.items.sub({id = piece.id, num = costCount})
      showBag()
      local pop = createPopupPieceBatchSummonResult("equip", l_1_0.id, 1)
      layer:addChild(pop, 100)
      end)
   end
  local onClickScrollPieceMerge = function(l_35_0)
    if layer.tipsTag then
      layer.tips:removeFromParent()
      layer.tipsTag = false
    end
    local param = {}
    param.sid = player.sid
    local num = math.floor(l_35_0.num / cfgitem[l_35_0.id].itemCost.count)
    param.item = {id = l_35_0.id, num = num * cfgitem[l_35_0.id].itemCost.count}
    addWaitNet()
    net:item_merge(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      bagdata.items.sub(param.item)
      bagdata.items.add({id = cfgitem[piece.id].itemCost.id, num = num})
      showBag()
      local pop = createPopupPieceBatchSummonResult("item", cfgitem[piece.id].itemCost.id, num)
      layer:addChild(pop, 100)
      end)
   end
  layer.setClickHandler(function(l_36_0)
    if layer.tipsTag then
      return 
    end
    if currentbag == "equip" or currentbag == "treasure" then
      layer.tipsTag = true
      layer.tips = tipsequip.createForBag(l_36_0.data, function()
        layer.sellPopul = tipssell.create("equip", icon.data, onEquipPopupSell)
        layer:addChild(layer.sellPopul, 200)
         end)
      layer:addChild(layer.tips, 100)
      layer.tips.setClickBlankHandler(function()
        layer.tips:removeFromParent()
        layer.tipsTag = false
         end)
    elseif currentbag == "item" then
      layer.tipsTag = true
      local iconHandler = nil
      tbl2string(l_36_0.data)
      local itemObj = cfgitem[l_36_0.data.id]
      if itemObj.giftId and itemObj.isAutoOpen == 2 then
        iconHandler = function()
        layer.giftPopul = tipsgift.create("items", icon.data, onPopupGift)
        layer:addChild(layer.giftPopul, 200)
         end
      else
        iconHandler = function()
        layer.sellPopul = tipssell.create("items", icon.data, onPopupSell)
        layer:addChild(layer.sellPopul, 200)
         end
      end
      layer.tips = tipsitem.createForBag(l_36_0.data, iconHandler)
      layer:addChild(layer.tips, 100)
      layer.tips.setClickBlankHandler(function()
        showBag()
        layer.tips:removeFromParent()
        layer.tipsTag = false
         end)
    elseif currentbag == "piece" then
      layer.tipsTag = true
      if cfgitem[l_36_0.data.id].type == ITEM_KIND_HERO_PIECE then
        if isUniversalPiece(l_36_0.data.id) then
          local costCount = math.floor(l_36_0.data.num / cfgitem[l_36_0.data.id].heroCost.count)
          if costCount <= 1 then
            layer.tips = tipsitem.createForBag(l_36_0.data, onClickPieceSummon)
          else
            layer.tips = tipsitem.createForBag(l_36_0.data, onClickPieceSummonShow)
          end
        else
          if cfgitem[l_36_0.data.id].heroCost.count <= l_36_0.data.num then
            local costCount = math.floor(l_36_0.data.num / cfgitem[l_36_0.data.id].heroCost.count)
            if costCount <= 1 then
              layer.tips = tipsitem.createForBag(l_36_0.data, onClickPieceSummon)
            else
              layer.tips = tipsitem.createForBag(l_36_0.data, onClickPieceSummonShow)
            end
          else
            layer.tips = tipsitem.createForBag(l_36_0.data, function()
            layer.sellPopul = tipssell.create("items", icon.data, onPopupSell)
            layer:addChild(layer.sellPopul, 200)
               end)
          end
        else
          layer.tips = tipsitem.createForBag(l_36_0.data, onClickPieceSummonForTreasure)
        end
      end
      layer:addChild(layer.tips, 100)
      layer.tips.setClickBlankHandler(function()
        layer.tips:removeFromParent()
        layer.tipsTag = false
         end)
    end
    audio.play(audio.button)
   end)
  return layer
end

return ui

