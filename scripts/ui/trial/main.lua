-- Command line was: E:\github\dhgametool\scripts\ui\trial\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local player = require("data.player")
local net = require("net.netClient")
local cfgwave = require("config.wavetrial")
local cfgmonster = require("config.monster")
local cfghero = require("config.hero")
local trial = require("data.trial")
ui.create = function()
  local layer = CCLayer:create()
  img.load(img.packedOthers.ui_dreamland)
  img.load(img.packedOthers.spine_ui_hanjingta_1)
  local model = "normal"
  local stageId = trial.stage or 1
  local st = math.max(1, stageId - 7)
  local ed = math.min(stageId + 8,  cfgwave)
  if ed - st < 15 then
    st = math.max(1, ed - 15)
  end
  local stageNum = ed - st + 1
  local Height = stageNum * 200
  local bg = CCSprite:create()
  bg:setContentSize(960, 576)
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
  json.load(json.ui.huanjingta)
  local board = DHSkeletonAnimation:createWithKey(json.ui.huanjingta)
  board:scheduleUpdateLua()
  board:setPosition(480, 288)
  bg:addChild(board)
  autoLayoutShift(board, false, true, false, false)
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = SpineMenuItem:create(json.ui.button, btnBackSprite)
  btnBack:setScale(view.minScale)
  btnBack:setPosition(scalep(35, 546))
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  layer:addChild(menuBack, 10)
  layer.back = btnBack
  autoLayoutShift(btnBack)
  local btnInfoSprite = img.createUISprite(img.ui.btn_help)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  btnInfo:setScale(view.minScale)
  btnInfo:setPosition(scalep(924, 546))
  local menuInfo = CCMenu:createWithItem(btnInfo)
  menuInfo:setPosition(0, 0)
  layer:addChild(menuInfo, 1000)
  layer.back = btnInfo
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.help").create(i18n.global.help_trial.string, i18n.global.help_title.string), 1000)
   end)
  autoLayoutShift(btnInfo)
  local btnRankSprite = img.createUISprite(img.ui.btn_rank)
  local btnRank = SpineMenuItem:create(json.ui.button, btnRankSprite)
  btnRank:setScale(view.minScale)
  btnRank:setPosition(scalep(924, 487))
  local menuRank = CCMenu:createWithItem(btnRank)
  menuRank:setPosition(0, 0)
  layer:addChild(menuRank, 1000)
  layer.back = btnRank
  btnRank:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.trial.rank").create(), 1000)
   end)
  autoLayoutShift(btnRank, true)
  local showUpdateLayer = CCLayer:create()
  board:addChildFollowSlot("code_floor", showUpdateLayer)
  local floor = {}
  for i = 1, stageNum + 3 do
    local idx = (i + st) % 2 + 1
    local realStage = st + i - 1
    json.load(json.ui.huanjingta_floor" .. id)
    floor[i] = DHSkeletonAnimation:createWithKey(json.ui.huanjingta_floor" .. id)
    floor[i]:scheduleUpdateLua()
    floor[i]:setAnchorPoint(ccp(0.5, 0))
    floor[i]:setPosition(480, 200 * i - 200)
    showUpdateLayer:addChild(floor[i])
    if i <= stageNum and stageId <= realStage then
      local showMonster = json.createSpineMons(cfgwave[realStage].trial[1])
      showMonster:setFlipX(true)
      showMonster:setScale(0.45)
      showMonster:setPosition(750, 200 * i - 164)
      showUpdateLayer:addChild(showMonster)
    end
    local showFloorBg = img.createUISprite(img.ui.dreamland_stage_bg)
    showFloorBg:setAnchorPoint(ccp(0.5, 0))
    if realStage % 2 == 1 then
      showFloorBg:setPosition(85, -2)
    else
      showFloorBg:setPosition(-15, -2)
    end
    floor[i]:addChild(showFloorBg, 1000)
    local showFloor = lbl.createFont2(24, realStage)
    showFloor:setPosition(showFloorBg:getContentSize().width / 2, showFloor:getContentSize().height / 2 + 5)
    showFloorBg:addChild(showFloor)
  end
  local showMogu = CCLayer:create()
  board:addChildFollowSlot("code_mogu", showMogu)
  for i = 1, math.ceil(Height / 768) + 2 do
    json.load(json.ui.huanjingta_mogu)
    local mogu = DHSkeletonAnimation:createWithKey(json.ui.huanjingta_mogu)
    mogu:scheduleUpdateLua()
    mogu:setPosition(0, (i - 1) * 768)
    mogu:playAnimation("start")
    mogu:appendNextAnimation("animation", -1)
    showMogu:addChild(mogu)
  end
  local showStageLayer = nil
  if stageId <=  cfgwave then
    showStageLayer = require("ui.trial.stage").create(stageId, layer)
    board:addChildFollowSlot("code_font", showStageLayer)
    showStageLayer:setVisible(false)
  end
  showUpdateLayer:setPositionY((st - math.min(stageId,  cfgwave)) * 200)
  showMogu:setPositionY((st - math.min(stageId,  cfgwave)) * 200)
  for i = 1,  floor do
    local idx = i + st - 1
    if ed < idx then
      floor[i]:playAnimation("forg", -1)
    elseif idx < stageId then
      floor[i]:playAnimation("normal", -1)
    elseif stageId == idx then
      floor[i]:playAnimation("open", -1)
    elseif stageId < idx then
      floor[i]:playAnimation("lock", -1)
    end
  end
  local tlBg = img.createUI9Sprite(img.ui.main_coin_bg)
  tlBg:setPreferredSize(CCSizeMake(174, 40))
  tlBg:setPosition(480, 544)
  bg:addChild(tlBg)
  autoLayoutShift(tlBg)
  local tlAll = img.createItemIcon(ITEM_ID_TRIAL_TL)
  tlAll:setScale(0.55)
  tlAll:setPosition(16, 24)
  tlBg:addChild(tlAll)
  local showTlAll = lbl.createFont2(16, "", ccc3(255, 247, 229))
  showTlAll:setPosition(tlBg:getContentSize().width / 2 + 5, tlBg:getContentSize().height / 2 + 2)
  tlBg:addChild(showTlAll)
  local btnAddSp = img.createUISprite(img.ui.main_icon_plus)
  local btnAdd = HHMenuItem:create(btnAddSp)
  btnAdd:setPosition(CCPoint(tlBg:getContentSize().width - 18, tlBg:getContentSize().height / 2 + 2))
  local btnAddMenu = CCMenu:createWithItem(btnAdd)
  btnAddMenu:setPosition(CCPoint(0, 0))
  tlBg:addChild(btnAddMenu)
  btnAdd:registerScriptTapHandler(function()
    layer:addChild(require("ui.trial.buy").create(), 100)
   end)
  local tipsTlBg = img.createUI9Sprite(img.ui.dreamland_lasttime_bg)
  tipsTlBg:setPreferredSize(CCSize(120, 32))
  tipsTlBg:setPosition(tlBg:getContentSize().width / 2, -11)
  tlBg:addChild(tipsTlBg)
  local showLab1 = lbl.createMixFont2(16, time2string(trial.cd - os.time()), ccc3(188, 192, 193))
  showLab1:setPosition(tipsTlBg:getContentSize().width / 2, tipsTlBg:getContentSize().height / 2)
  tipsTlBg:addChild(showLab1)
  local isTouchEnd, lasty, lastPos = nil, nil, nil
  local delta_y = 0
  local deltaMove = function(l_4_0)
    if model ~= "stage" then
      tlBg:setVisible(true)
      if trial.cd - os.time() <= 0 then
        trial.cd = trial.cd + 1800
        if trial.tl < 10 then
          trial.tl = trial.tl + 1
        end
      end
      showTlAll:setString(trial.tl)
      if trial.tl < 10 then
        showLab1:setString(time2string(trial.cd - os.time()))
        tipsTlBg:setVisible(true)
      else
        showLab1:setString("")
        tipsTlBg:setVisible(false)
      end
    else
      tlBg:setVisible(false)
    end
  end
  if not isTouchEnd then
    return 
  end
  if not ATTENUATION_COEFFCIENT + 1 < delta_y and delta_y < ATTENUATION_COEFFCIENT - 1 then
    return 
  end
  local posy = showUpdateLayer:getPositionY() + delta_y
  if posy < view.logical.h - Height - 400 then
    posy = view.logical.h - Height - 400
  end
  if posy > 0 then
    posy = 0
  end
  showUpdateLayer:setPositionY(posy)
  showMogu:setPositionY(posy)
  if delta_y <= 0 or not delta_y - ATTENUATION_COEFFCIENT then
    upvalue_3584 = delta_y + ATTENUATION_COEFFCIENT
  end
   end
  layer:scheduleUpdateWithPriorityLua(deltaMove, 0)
  local onTouchBegin = function(l_5_0, l_5_1)
    lastPos = CCPoint(l_5_0, l_5_1)
    upvalue_512 = l_5_1
    upvalue_1024 = false
    return true
   end
  local onTouchMoved = function(l_6_0, l_6_1)
    if lastPos then
      local posy = showUpdateLayer:getPositionY() + l_6_1 - lastPos.y
      if posy < view.logical.h - Height - 400 then
        posy = view.logical.h - Height - 400
      end
      if posy > 0 then
        posy = 0
      end
      showUpdateLayer:setPositionY(posy)
      showMogu:setPositionY(posy)
      upvalue_2560 = l_6_1 - lastPos.y
      lastPos = CCPoint(l_6_0, l_6_1)
    end
    return true
   end
  local onTouchEnd = function(l_7_0, l_7_1)
    isTouchEnd = true
    if math.abs(l_7_1 - lasty) > 10 then
      return 
    end
    for i,v in ipairs(floor) do
      if v:getAabbBoundingBox():containsPoint(ccp(l_7_0, l_7_1)) and i + st - 1 == stageId and stageId <=  cfgwave then
        audio.play(audio.trial_chain)
        layer:setTouchEnabled(false)
        upvalue_4096 = "stage"
        showStageLayer:setVisible(true)
        board:setPlayBackwardsEnabled(false)
        board:playAnimation("animation")
      end
    end
    return true
   end
  local onTouch = function(l_8_0, l_8_1, l_8_2)
    if l_8_0 == "began" then
      return onTouchBegin(l_8_1, l_8_2)
    elseif l_8_0 == "moved" then
      return onTouchMoved(l_8_1, l_8_2)
    else
      return onTouchEnd(l_8_1, l_8_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  local backEvent = function()
    if model == "stage" then
      audio.play(audio.trial_chain)
      board:setPlayBackwardsEnabled(true)
      board:playAnimation("animation")
      layer:setTouchEnabled(true)
      showStageLayer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(function()
        showStageLayer:setVisible(false)
         end)))
      model = "normal"
    else
      audio.play(audio.button)
      replaceScene(require("ui.town.main").create())
    end
   end
  btnBack:registerScriptTapHandler(backEvent)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    backEvent()
   end
  local onEnter = function()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_13_0)
    if l_13_0 == "enter" then
      onEnter()
    elseif l_13_0 == "exit" then
      onExit()
    elseif l_13_0 == "cleanup" and isIOSLowerModel() then
      img.unload(img.packedOthers.ui_dreamland)
      img.unload(img.packedOthers.spine_ui_hanjingta_1)
      json.unload(json.ui.huanjingta)
      json.unload(json.ui.huanjingta_mogu)
      json.unload(json.ui.huanjingta_floor1)
      json.unload(json.ui.huanjingta_floor2)
      for i = 1, stageNum + 3 do
        local idx = (i + st) % 2 + 1
        local realStage = st + i - 1
        if i <= stageNum and stageId <= realStage then
          json.unloadUnit(cfghero[cfgmonster[cfgwave[realStage].trial[1]].heroLink].heroBody)
        end
      end
    end
   end)
  return layer
end

return ui

