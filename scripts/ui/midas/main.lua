-- Command line was: E:\github\dhgametool\scripts\ui\midas\main.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local lbl = require("res.lbl")
local audio = require("res.audio")
local i18n = require("res.i18n")
local player = require("data.player")
local midas = require("data.midas")
local bag = require("data.bag")
local cfgmidas = require("config.midas")
local cfgvip = require("config.vip")
local net = require("net.netClient")
local tipsitem = require("ui.tips.item")
local MIDASTIME = 28800
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

ui.create = function(l_2_0)
  local layer = CCLayer:create()
  local currentMidas = true
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board_w = 704
  local board_h = 370
  local board = img.createUI9Sprite(img.ui.midas_titlebg)
  board:setPreferredSize(CCSizeMake(board_w, board_h))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  json.load(json.ui.dianjin)
  local animMidas = DHSkeletonAnimation:createWithKey(json.ui.dianjin)
  animMidas:scheduleUpdateLua()
  animMidas:playAnimation("animation")
  animMidas:setPosition(board_w / 2, board_h / 2)
  board:addChild(animMidas, 1000)
  board:setScale(0.1 * view.minScale)
  board:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  json.load(json.ui.dianjin2)
  local personAni = json.create(json.ui.dianjin2)
  personAni:setPosition(0, 0)
  personAni:playAnimation("animation", -1)
  board:addChild(personAni)
  local titleLab = lbl.createFont1(28, i18n.global.midas_golden_hand.string, ccc3(255, 220, 135))
  titleLab:setAnchorPoint(0, 0.5)
  titleLab:setPosition(180, 328)
  board:addChild(titleLab)
  local border1 = img.createUI9Sprite(img.ui.midas_icon_bottom1)
  border1:setPreferredSize(CCSizeMake(154, 186))
  border1:setAnchorPoint(0, 0)
  border1:setPosition(CCPoint(182, 80))
  board:addChild(border1)
  local border2 = img.createUI9Sprite(img.ui.midas_icon_bottom1)
  border2:setPreferredSize(CCSizeMake(154, 186))
  border2:setAnchorPoint(0, 0)
  border2:setPosition(CCPoint(347, 80))
  board:addChild(border2)
  local border3 = img.createUI9Sprite(img.ui.midas_icon_bottom1)
  border3:setPreferredSize(CCSizeMake(154, 186))
  border3:setAnchorPoint(0, 0)
  border3:setPosition(CCPoint(512, 80))
  board:addChild(border3)
  local coinFram1 = img.createUISprite(img.ui.midas_icon_bottom2)
  coinFram1:setPosition(border1:getContentSize().width / 2, 105)
  border1:addChild(coinFram1)
  local coinFram2 = img.createUISprite(img.ui.midas_icon_bottom2)
  coinFram2:setPosition(border2:getContentSize().width / 2, 105)
  border2:addChild(coinFram2)
  local coinFram3 = img.createUISprite(img.ui.midas_icon_bottom2)
  coinFram3:setPosition(border3:getContentSize().width / 2, 105)
  border3:addChild(coinFram3)
  local getBtn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  local coinIcon1 = img.createUISprite(img.ui.midas_icon_1)
  coinIcon1:setPosition(coinFram1:getContentSize().width / 2, 70)
  coinFram1:addChild(coinIcon1)
  local coinIcon2 = img.createUISprite(img.ui.midas_icon_2)
  coinIcon2:setPosition(coinFram2:getContentSize().width / 2, 70)
  coinFram2:addChild(coinIcon2)
  local coinIcon3 = img.createUISprite(img.ui.midas_icon_3)
  coinIcon3:setPosition(coinFram3:getContentSize().width / 2, 70)
  coinFram3:addChild(coinIcon3)
  local getBtn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  local getBtn1 = img.createLogin9Sprite(img.login.button_9_small_grey)
  getBtn0:setPreferredSize(CCSizeMake(122, 48))
  getBtn1:setPreferredSize(CCSizeMake(122, 48))
  local btnLevel1 = CCMenuItemSprite:create(getBtn0, nil, getBtn1)
  btnLevel1:setPosition(border1:getContentSize().width / 2, 0)
  if midas.kind[1] == 1 then
    btnLevel1:setEnabled(false)
  end
  local btnMenuLevel1 = CCMenu:createWithItem(btnLevel1)
  btnMenuLevel1:setPosition(0, 0)
  border1:addChild(btnMenuLevel1)
  local level2getBtn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  local level2getBtn1 = img.createLogin9Sprite(img.login.button_9_small_grey)
  level2getBtn0:setPreferredSize(CCSizeMake(122, 48))
  level2getBtn1:setPreferredSize(CCSizeMake(122, 48))
  local btnLevel2 = CCMenuItemSprite:create(level2getBtn0, nil, level2getBtn1)
  btnLevel2:setPosition(border2:getContentSize().width / 2, 0)
  if midas.kind[2] == 1 then
    btnLevel2:setEnabled(false)
  end
  local btnMenuLevel2 = CCMenu:createWithItem(btnLevel2)
  btnMenuLevel2:setPosition(0, 0)
  border2:addChild(btnMenuLevel2)
  local level3getBtn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  local level3getBtn1 = img.createLogin9Sprite(img.login.button_9_small_grey)
  level3getBtn0:setPreferredSize(CCSizeMake(122, 48))
  level3getBtn1:setPreferredSize(CCSizeMake(122, 48))
  local btnLevel3 = CCMenuItemSprite:create(level3getBtn0, nil, level3getBtn1)
  btnLevel3:setPosition(border3:getContentSize().width / 2, 0)
  if midas.kind[3] == 1 then
    btnLevel3:setEnabled(false)
  end
  local btnMenuLevel3 = CCMenu:createWithItem(btnLevel3)
  btnMenuLevel3:setPosition(0, 0)
  border3:addChild(btnMenuLevel3)
  local lightGem2 = img.createItemIcon2(ITEM_ID_GEM)
  lightGem2:setScale(0.68)
  lightGem2:setPosition(btnLevel2:getContentSize().width / 3 - 10, btnLevel2:getContentSize().height / 2 + 2)
  lightGem2:setVisible(midas.kind[2] == 0)
  btnLevel2:addChild(lightGem2)
  local lightGem3 = img.createItemIcon2(ITEM_ID_GEM)
  lightGem3:setScale(0.68)
  lightGem3:setPosition(btnLevel3:getContentSize().width / 3 - 10, btnLevel3:getContentSize().height / 2 + 2)
  lightGem3:setVisible(midas.kind[3] == 0)
  btnLevel3:addChild(lightGem3)
  local greyGem2 = img.createUISprite(img.ui.midas_diamond_gray)
  greyGem2:setPosition(btnLevel2:getContentSize().width / 3 - 15, btnLevel2:getContentSize().height / 2 + 4)
  greyGem2:setVisible(midas.kind[2] == 1)
  btnLevel2:addChild(greyGem2)
  local greyGem3 = img.createUISprite(img.ui.midas_diamond_gray)
  greyGem3:setPosition(btnLevel3:getContentSize().width / 3 - 15, btnLevel3:getContentSize().height / 2 + 4)
  greyGem3:setVisible(midas.kind[3] == 1)
  btnLevel3:addChild(greyGem3)
  local level = player.lv()
  local goldStr1 = string.format("%d", cfgmidas[level].gold * (1 + cfgvip[player.vipLv()].midas))
  local goldLabel1 = lbl.createFont2(18, goldStr1, ccc3(255, 246, 223))
  goldLabel1:setPosition(coinFram1:getContentSize().width / 2, 28)
  coinFram1:addChild(goldLabel1)
  local goldStr2 = string.format("%d", 2 * cfgmidas[level].gold * (1 + cfgvip[player.vipLv()].midas))
  local goldLabel2 = lbl.createFont2(18, goldStr2, ccc3(255, 246, 223))
  goldLabel2:setPosition(coinFram2:getContentSize().width / 2, 28)
  coinFram2:addChild(goldLabel2)
  local goldStr3 = string.format("%d", 5 * cfgmidas[level].gold * (1 + cfgvip[player.vipLv()].midas))
  local goldLabel3 = lbl.createFont2(18, goldStr3, ccc3(255, 246, 223))
  goldLabel3:setPosition(coinFram3:getContentSize().width / 2, 28)
  coinFram3:addChild(goldLabel3)
  local gemLabel1 = lbl.createFont1(16, i18n.global.midas_free_get.string, ccc3(126, 47, 28))
  gemLabel1:setPosition(btnLevel1:getContentSize().width / 2, btnLevel1:getContentSize().height / 2)
  if midas.kind[1] == 1 then
    gemLabel1:setColor(ccc3(60, 60, 60))
  end
  btnLevel1:addChild(gemLabel1)
  local gemLabel2 = lbl.createFont1(16, i18n.global.midas_get.string, ccc3(126, 47, 28))
  gemLabel2:setPosition(greyGem2:getBoundingBox():getMaxX() + 43, btnLevel2:getContentSize().height / 2)
  if midas.kind[2] == 1 then
    gemLabel2:setColor(ccc3(60, 60, 60))
  end
  btnLevel2:addChild(gemLabel2)
  local gemLabel3 = lbl.createFont1(16, i18n.global.midas_get.string, ccc3(126, 47, 28))
  gemLabel3:setPosition(greyGem3:getBoundingBox():getMaxX() + 43, btnLevel3:getContentSize().height / 2)
  if midas.kind[3] == 1 then
    gemLabel3:setColor(ccc3(60, 60, 60))
  end
  btnLevel3:addChild(gemLabel3)
  local gemnumLabel2 = lbl.createFont2(14, "20", ccc3(255, 246, 225))
  gemnumLabel2:setPosition(btnLevel2:getContentSize().width / 3 - 15, btnLevel2:getContentSize().height / 2 - 6)
  btnLevel2:addChild(gemnumLabel2)
  local gemnumLabel3 = lbl.createFont2(14, "50", ccc3(255, 246, 225))
  gemnumLabel3:setPosition(btnLevel3:getContentSize().width / 3 - 15, btnLevel3:getContentSize().height / 2 - 6)
  btnLevel3:addChild(gemnumLabel3)
  local midasInfo = lbl.createFont2(16, i18n.global.midas_info.string, ccc3(255, 246, 225))
  midasInfo:setAnchorPoint(0, 0.5)
  midasInfo:setPosition(CCPoint(182, 295))
  midasInfo:setVisible(false)
  board:addChild(midasInfo)
  json.load(json.ui.clock)
  local clockIcon = DHSkeletonAnimation:createWithKey(json.ui.clock)
  clockIcon:scheduleUpdateLua()
  clockIcon:playAnimation("animation", -1)
  clockIcon:setPosition(195, 290)
  board:addChild(clockIcon)
  local toFreeLab = lbl.createMixFont2(16, i18n.global.blackmarket_refresh.string, ccc3(255, 246, 225))
  toFreeLab:setAnchorPoint(0, 0.5)
  toFreeLab:setPosition(clockIcon:getBoundingBox():getMaxX() + 30, 290)
  toFreeLab:setVisible(currentMidas == false)
  board:addChild(toFreeLab)
  local midasCd = math.max(0, midas.cd - os.time())
  local countTimeInfoStr = string.format("%02d:%02d:%02d", math.floor(midasCd / 3600), math.floor(midasCd % 3600 / 60), math.floor(midasCd % 60))
  local countTimeInfo = lbl.createFont2(16, countTimeInfoStr, ccc3(196, 255, 36))
  countTimeInfo:setAnchorPoint(0, 0.5)
  countTimeInfo:setPosition(toFreeLab:getBoundingBox():getMaxX() + 10, 290)
  countTimeInfo:setVisible(currentMidas == false)
  board:addChild(countTimeInfo)
  local showMidas = function()
    lightGem2:setVisible(currentMidas)
    lightGem3:setVisible(currentMidas)
    greyGem2:setVisible(currentMidas == false)
    greyGem3:setVisible(currentMidas == false)
    btnLevel1:setEnabled(currentMidas)
    btnLevel2:setEnabled(currentMidas)
    btnLevel3:setEnabled(currentMidas)
    clockIcon:setVisible(currentMidas == false)
    countTimeInfo:setVisible(currentMidas == false)
    toFreeLab:setVisible(currentMidas == false)
    if currentMidas then
      gemLabel1:setColor(ccc3(126, 47, 28))
      gemLabel2:setColor(ccc3(126, 47, 28))
      gemLabel3:setColor(ccc3(126, 47, 28))
    else
      gemLabel1:setColor(ccc3(60, 60, 60))
      gemLabel2:setColor(ccc3(60, 60, 60))
      gemLabel3:setColor(ccc3(60, 60, 60))
    end
   end
  local onUpdate = function()
    midasCd = math.max(0, midas.cd - os.time())
    if midasCd > 0 then
      upvalue_1024 = false
      local countTimeInfoStr = string.format("%02d:%02d:%02d", math.floor(midasCd / 3600), math.floor(midasCd % 3600 / 60), math.floor(midasCd % 60))
      countTimeInfo:setString(countTimeInfoStr)
      midasInfo:setVisible(false)
      clockIcon:setVisible(currentMidas == false)
      countTimeInfo:setVisible(currentMidas == false)
      toFreeLab:setVisible(currentMidas == false)
    else
      upvalue_1024 = true
      showMidas()
      midasInfo:setVisible(true)
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  btnLevel1:registerScriptTapHandler(function()
    audio.play(audio.button)
    midas.eimit = os.time() + MIDASTIME
    upvalue_1536 = false
    local param = {}
    param.sid = player.sid
    param.type = 1
    addWaitNet()
    net:midas(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      local coinNum = cfgmidas[level].gold * (1 + cfgvip[player.vipLv()].midas)
      local midascd = math.max(0, midas.cd - os.time())
      if midascd <= 0 then
        midas.cd = os.time() + MIDASTIME
      end
      bag.addCoin(coinNum)
      local pop = createPopupPieceBatchSummonResult("item", ITEM_ID_COIN, coinNum)
      layer:addChild(pop, 100)
      midas.kind[1] = 1
      btnLevel1:setEnabled(false)
      gemLabel1:setColor(ccc3(60, 60, 60))
      local task = require("data.task")
      task.increment(task.TaskType.MIDAS)
      end)
   end)
  btnLevel2:registerScriptTapHandler(function()
    audio.play(audio.button)
    if bag.gem() < 20 then
      showToast(i18n.global.summon_gem_lack.string)
      return 
    end
    upvalue_1536 = false
    local param = {}
    param.sid = player.sid
    param.type = 2
    addWaitNet()
    net:midas(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      local midascd = math.max(0, midas.cd - os.time())
      if midascd <= 0 then
        midas.cd = os.time() + MIDASTIME
      end
      local coinNum = cfgmidas[level].gold * 2 * (1 + cfgvip[player.vipLv()].midas)
      bag.addCoin(coinNum)
      bag.subGem(20)
      local pop = createPopupPieceBatchSummonResult("item", ITEM_ID_COIN, coinNum)
      layer:addChild(pop, 100)
      midas.kind[2] = 1
      btnLevel2:setEnabled(false)
      gemLabel2:setColor(ccc3(60, 60, 60))
      lightGem2:setVisible(false)
      greyGem2:setVisible(true)
      local task = require("data.task")
      task.increment(task.TaskType.MIDAS)
      end)
   end)
  btnLevel3:registerScriptTapHandler(function()
    audio.play(audio.button)
    if bag.gem() < 50 then
      showToast(i18n.global.summon_gem_lack.string)
      return 
    end
    upvalue_1536 = false
    local param = {}
    param.sid = player.sid
    param.type = 3
    addWaitNet()
    net:midas(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      local midascd = math.max(0, midas.cd - os.time())
      if midascd <= 0 then
        midas.cd = os.time() + MIDASTIME
      end
      local coinNum = cfgmidas[level].gold * 5 * (1 + cfgvip[player.vipLv()].midas)
      bag.addCoin(coinNum)
      bag.subGem(50)
      local pop = createPopupPieceBatchSummonResult("item", ITEM_ID_COIN, coinNum)
      layer:addChild(pop, 100)
      midas.kind[3] = 1
      btnLevel3:setEnabled(false)
      gemLabel3:setColor(ccc3(60, 60, 60))
      lightGem3:setVisible(false)
      greyGem3:setVisible(true)
      local task = require("data.task")
      task.increment(task.TaskType.MIDAS)
      end)
   end)
  local backEvent = function()
    audio.play(audio.button)
    if uiParams and uiParams.from_layer == "task" then
      replaceScene(require("ui.town.main").create({from_layer = "task"}))
    else
      layer:removeFromParentAndCleanup()
    end
   end
  local close0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, close0)
  closeBtn:setPosition(CCPoint(683, 346))
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  board:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
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
  layer:registerScriptHandler(function(l_11_0)
    if l_11_0 == "enter" then
      onEnter()
    elseif l_11_0 == "exit" then
      onExit()
    end
   end)
  layer:setTouchEnabled(true)
  return layer
end

return ui

