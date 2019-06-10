-- Command line was: E:\github\dhgametool\scripts\ui\midas\crystal.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local lbl = require("res.lbl")
local audio = require("res.audio")
local player = require("data.player")
local midas = require("data.midas")
local bag = require("data.bag")
local cfgmidas = require("config.midas")
local net = require("net.netClient")
local MIDASTIME = 28800
ui.create = function()
  local layer = CCLayer:create()
  local currentMidas = true
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board_w = 686
  local board_h = 528
  local board = img.createUI9Sprite(img.ui.bag_outer_bg)
  board:setPreferredSize(CCSizeMake(board_w, board_h))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY - 20 * view.minScale)
  layer:addChild(board)
  board:setScale(0.1 * view.minScale)
  board:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  local titleBg = img.createUISprite(img.ui.midas_titlebg_crst)
  titleBg:setAnchorPoint(0, 0)
  titleBg:setPosition(CCPoint(10, 318))
  board:addChild(titleBg)
  local border1 = img.createUI9Sprite(img.ui.bottom_border_2)
  border1:setPreferredSize(CCSizeMake(620, 82))
  border1:setAnchorPoint(0, 0)
  border1:setPosition(CCPoint(32, 218))
  board:addChild(border1)
  local border2 = img.createUI9Sprite(img.ui.bottom_border_2)
  border2:setPreferredSize(CCSizeMake(620, 82))
  border2:setAnchorPoint(0, 0)
  border2:setPosition(CCPoint(32, 126))
  board:addChild(border2)
  local border3 = img.createUI9Sprite(img.ui.bottom_border_2)
  border3:setPreferredSize(CCSizeMake(620, 82))
  border3:setAnchorPoint(0, 0)
  border3:setPosition(CCPoint(32, 34))
  board:addChild(border3)
  local coinIcon1 = img.createUISprite(img.ui.midas_icon_4)
  coinIcon1:setPosition(CCPoint(78, 260))
  board:addChild(coinIcon1)
  local coinIcon2 = img.createUISprite(img.ui.midas_icon_5)
  coinIcon2:setPosition(CCPoint(78, 168))
  board:addChild(coinIcon2)
  local coinIcon3 = img.createUISprite(img.ui.midas_icon_6)
  coinIcon3:setPosition(CCPoint(78, 76))
  board:addChild(coinIcon3)
  local getBtn0 = img.createUI9Sprite(img.ui.btn_2)
  local getBtn1 = img.createUI9Sprite(img.ui.btn_4)
  getBtn0:setPreferredSize(CCSizeMake(192, 48))
  getBtn1:setPreferredSize(CCSizeMake(192, 48))
  local btnLevel1 = CCMenuItemSprite:create(getBtn0, nil, getBtn1)
  btnLevel1:setPosition(CCPoint(532, 258))
  btnLevel1:setEnabled(currentMidas)
  local btnMenuLevel1 = CCMenu:createWithItem(btnLevel1)
  btnMenuLevel1:setPosition(0, 0)
  board:addChild(btnMenuLevel1)
  local level2getBtn0 = img.createUI9Sprite(img.ui.btn_2)
  local level2getBtn1 = img.createUI9Sprite(img.ui.btn_4)
  level2getBtn0:setPreferredSize(CCSizeMake(192, 48))
  level2getBtn1:setPreferredSize(CCSizeMake(192, 48))
  local btnLevel2 = CCMenuItemSprite:create(level2getBtn0, nil, level2getBtn1)
  btnLevel2:setPosition(CCPoint(532, 168))
  btnLevel2:setEnabled(currentMidas)
  local btnMenuLevel2 = CCMenu:createWithItem(btnLevel2)
  btnMenuLevel2:setPosition(0, 0)
  board:addChild(btnMenuLevel2)
  local level3getBtn0 = img.createUI9Sprite(img.ui.btn_2)
  local level3getBtn1 = img.createUI9Sprite(img.ui.btn_4)
  level3getBtn0:setPreferredSize(CCSizeMake(192, 48))
  level3getBtn1:setPreferredSize(CCSizeMake(192, 48))
  local btnLevel3 = CCMenuItemSprite:create(level3getBtn0, nil, level3getBtn1)
  btnLevel3:setPosition(CCPoint(532, 76))
  btnLevel3:setEnabled(currentMidas)
  local btnMenuLevel3 = CCMenu:createWithItem(btnLevel3)
  btnMenuLevel3:setPosition(0, 0)
  board:addChild(btnMenuLevel3)
  local lightGem2 = img.createUISprite(img.ui.gem)
  lightGem2:setPosition(btnLevel2:getContentSize().width / 3, btnLevel2:getContentSize().height / 2)
  btnLevel2:addChild(lightGem2)
  local lightGem3 = img.createUISprite(img.ui.gem)
  lightGem3:setPosition(btnLevel3:getContentSize().width / 3, btnLevel3:getContentSize().height / 2)
  btnLevel3:addChild(lightGem3)
  local greyGem2 = img.createUISprite(img.ui.midas_diamond_gray)
  greyGem2:setPosition(btnLevel2:getContentSize().width / 3, btnLevel2:getContentSize().height / 2)
  btnLevel2:addChild(greyGem2)
  local greyGem3 = img.createUISprite(img.ui.midas_diamond_gray)
  greyGem3:setPosition(btnLevel3:getContentSize().width / 3, btnLevel3:getContentSize().height / 2)
  btnLevel3:addChild(greyGem3)
  local level = player.lv()
  local goldStr1 = string.format("x%d", cfgmidas[level].crystal)
  local goldLabel1 = lbl.createFont1(24, goldStr1, ccc3(126, 47, 28))
  goldLabel1:setAnchorPoint(0, 0.5)
  goldLabel1:setPosition(CCPoint(117, 256))
  board:addChild(goldLabel1)
  local goldStr2 = string.format("x%d", 2 * cfgmidas[level].crystal)
  local goldLabel2 = lbl.createFont1(24, goldStr2, ccc3(126, 47, 28))
  goldLabel2:setAnchorPoint(0, 0.5)
  goldLabel2:setPosition(CCPoint(117, 166))
  board:addChild(goldLabel2)
  local goldStr3 = string.format("x%d", 5 * cfgmidas[level].crystal)
  local goldLabel3 = lbl.createFont1(24, goldStr3, ccc3(126, 47, 28))
  goldLabel3:setAnchorPoint(0, 0.5)
  goldLabel3:setPosition(CCPoint(117, 74))
  board:addChild(goldLabel3)
  local gemLabel1 = lbl.createFont1(24, "FREE GET", ccc3(126, 47, 28))
  gemLabel1:setAnchorPoint(0, 0.5)
  gemLabel1:setPosition(CCPoint(492, 256))
  board:addChild(gemLabel1)
  local gemLabel2 = lbl.createFont1(24, "GET", ccc3(126, 47, 28))
  gemLabel2:setAnchorPoint(0, 0.5)
  gemLabel2:setPosition(CCPoint(540, 166))
  board:addChild(gemLabel2)
  local gemLabel3 = lbl.createFont1(24, "GET", ccc3(126, 47, 28))
  gemLabel3:setAnchorPoint(0, 0.5)
  gemLabel3:setPosition(CCPoint(540, 74))
  board:addChild(gemLabel3)
  local gemnumLabel2 = lbl.createFont1(16, "20", ccc3(255, 254, 245))
  gemnumLabel2:setPosition(CCPoint(510, 160))
  board:addChild(gemnumLabel2)
  local gemnumLabel3 = lbl.createFont1(16, "50", ccc3(255, 254, 245))
  gemnumLabel3:setPosition(CCPoint(510, 66))
  board:addChild(gemnumLabel3)
  local clock = img.createUISprite(img.ui.midas_clock)
  clock:setPosition(CCPoint(439, 466))
  clock:setVisible(currentMidas == false)
  board:addChild(clock)
  local midasCd = math.max(0, midas.crstcd - os.time())
  local countTimeInfoStr = string.format("%02d:%02d:%02d", math.floor(midasCd / 3600), math.floor(midasCd % 3600 / 60), math.floor(midasCd % 60))
  local countTimeInfo = lbl.createFont2(18, countTimeInfoStr, ccc3(196, 255, 36))
  countTimeInfo:setPosition(499, 465)
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
    clock:setVisible(currentMidas == false)
    countTimeInfo:setVisible(currentMidas == false)
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
    midasCd = math.max(0, midas.crstcd - os.time())
    if midasCd > 0 then
      upvalue_1024 = false
      showMidas()
      local countTimeInfoStr = string.format("%02d:%02d:%02d", math.floor(midasCd / 3600), math.floor(midasCd % 3600 / 60), math.floor(midasCd % 60))
      countTimeInfo:setString(countTimeInfoStr)
    else
      upvalue_1024 = true
      showMidas()
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  btnLevel1:registerScriptTapHandler(function()
    midas.eimit = os.time() + MIDASTIME
    upvalue_1024 = false
    local param = {}
    param.sid = player.sid
    param.type = 4
    addWaitNet(function()
      delWaitNet()
      showToast("sever timeout")
      end)
    net:midas(param, function(l_2_0)
      delWaitNet()
      if l_2_0.status ~= 0 then
        showToast("server status:" .. l_2_0.status)
        return 
      end
      midas.crstcd = os.time() + MIDASTIME
      bag.items.add({id = ITEM_ID_ENCHANT, num = cfgmidas[level].crystal})
      end)
    showMidas()
   end)
  btnLevel2:registerScriptTapHandler(function()
    if bag.gem() < 20 then
      showToast("no enough gem!")
      return 
    end
    midas.crstcd = os.time() + MIDASTIME
    upvalue_1536 = false
    local param = {}
    param.sid = player.sid
    param.type = 5
    addWaitNet(function()
      delWaitNet()
      showToast("sever timeout")
      end)
    net:midas(param, function(l_2_0)
      delWaitNet()
      if l_2_0.status ~= 0 then
        showToast("server status:" .. l_2_0.status)
        return 
      end
      midas.crstcd = os.time() + MIDASTIME
      bag.items.add({id = ITEM_ID_ENCHANT, num = cfgmidas[level].crystal * 2})
      bag.subGem(20)
      end)
    showMidas()
   end)
  btnLevel3:registerScriptTapHandler(function()
    if bag.gem() < 50 then
      showToast("no enough gem!")
      return 
    end
    midas.limit = os.time() + MIDASTIME
    upvalue_1536 = false
    local param = {}
    param.sid = player.sid
    param.type = 6
    addWaitNet(function()
      delWaitNet()
      showToast("sever timeout")
      end)
    net:midas(param, function(l_2_0)
      delWaitNet()
      if l_2_0.status ~= 0 then
        showToast("server status:" .. l_2_0.status)
        return 
      end
      midas.crstcd = os.time() + MIDASTIME
      bag.items.add({id = ITEM_ID_ENCHANT, num = cfgmidas[level].crystal * 5})
      bag.subGem(50)
      end)
    showMidas()
   end)
  local close0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, close0)
  closeBtn:setPosition(CCPoint(672, 500))
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  board:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup()
   end)
  layer.onAndroidBack = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  addBackEvent(layer)
  local onEnter = function()
    layer.notifyParentLock()
    showMidas()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_10_0)
    if l_10_0 == "enter" then
      onEnter()
    elseif l_10_0 == "exit" then
      onExit()
    end
   end)
  layer:setTouchEnabled(true)
  return layer
end

return ui

