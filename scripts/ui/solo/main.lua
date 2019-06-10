-- Command line was: E:\github\dhgametool\scripts\ui\solo\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local heros = require("data.heros")
local cfghero = require("config.hero")
local cfgSpkWave = require("config.spkwave")
local cfgMonster = require("config.monster")
local cfgDrug = require("config.spkdrug")
local cfgTrader = require("config.spktrader")
local cfgSpk = require("config.spk")
local cfgequip = require("config.equip")
local bag = require("data.bag")
local player = require("data.player")
local soloData = require("data.solo")
local spkConf = require("config.spk")
math.randomseed(os.time())
ui.create = function()
  ui.widget = {}
  ui.data = {}
  ui.isAllDie = false
  ui.isFirst = true
  ui.data.maxClearNum = 100
  ui.data.overNum = 500
  ui.data.lastSelected = 0
  ui.widget.heroIcons = {}
  ui.widget.layer = CCLayer:create()
  ui.widget.layer.mainUI = ui
  ui.widget.touchLayer = CCLayer:create()
  ui.widget.touchLayer:setTouchEnabled(true)
  ui.widget.layer:addChild(ui.widget.touchLayer)
  ui.widget.spineNode = json.create(json.ui.solo)
  ui.widget.spineNode:setScale(view.minScale)
  ui.widget.spineNode:setPosition(view.midX, view.midY)
  ui.widget.layer:addChild(ui.widget.spineNode)
  ui.widget.spineNode:registerAnimation("start")
  ui.widget.upSpine = json.create(json.ui.solo_up)
  ui.widget.upSpine:setScale(view.minScale)
  ui.widget.upSpine:setPosition(view.midX, view.midY)
  ui.widget.layer:addChild(ui.widget.upSpine)
  ui.widget.upSpine:playAnimation("start")
  autoLayoutShift(ui.widget.upSpine, true)
  ui.widget.downSpine = json.create(json.ui.solo_down)
  ui.widget.downSpine:setScale(view.minScale)
  ui.widget.downSpine:setPosition(view.midX, view.midY)
  ui.widget.layer:addChild(ui.widget.downSpine)
  ui.widget.downSpine:playAnimation("start")
  autoLayoutShift(ui.widget.downSpine, false, true)
  ui.widget.sideSpine = json.create(json.ui.solo_side)
  ui.widget.sideSpine:setScale(view.minScale)
  ui.widget.sideSpine:setPosition(view.midX, view.midY)
  ui.widget.layer:addChild(ui.widget.sideSpine)
  ui.widget.sideSpine:playAnimation("start")
  autoLayoutShift(ui.widget.sideSpine, false, false, true, false)
  ui.widget.objLayer = CCLayerColor:create(ccc4(0, 0, 0, 0))
  ui.widget.objLayer:setContentSize(120, 170)
  ui.widget.objLayer:setPosition(ccp(220, -150))
  ui.widget.spineNode:addChild(ui.widget.objLayer)
  local sprite = CCSprite:create()
  sprite:setContentSize(CCSize(120, 170))
  ui.widget.objTouchBtn = SpineMenuItem:create(json.ui.button, sprite)
  ui.widget.objTouchBtn:setPosition(ccp(60, 85))
  local touchMenu = CCMenu:createWithItem(ui.widget.objTouchBtn)
  touchMenu:setPosition(0, 0)
  ui.widget.objLayer:addChild(touchMenu)
  ui.widget.countDownLabel = lbl.createFont2(14, ui.getTimeString(math.max(0, soloData.cd - os.time())), ccc3(195, 255, 66))
  print("\230\151\182\233\151\180\228\184\186" .. ui.getTimeString(math.max(0, soloData.cd)))
  ui.widget.countDownLabel:setAnchorPoint(ccp(1, 0.5))
  ui.widget.countDownLabel:setPosition(ccp(50, 225))
  ui.widget.spineNode:addChild(ui.widget.countDownLabel)
  autoLayoutShift(ui.widget.countDownLabel, true)
  ui.widget.countDownLabel:scheduleUpdateWithPriorityLua(ui.refreshTime, 0)
  ui.widget.endLabel = lbl.createFont2(14, i18n.global.solo_end.string, ccc3(255, 255, 255))
  ui.widget.endLabel:setAnchorPoint(ccp(0, 0.5))
  ui.widget.endLabel:setPosition(ccp(-35, 225))
  ui.widget.spineNode:addChild(ui.widget.endLabel)
  autoLayoutShift(ui.widget.endLabel, true)
  ui.beCenter(ui.widget.endLabel, ui.widget.countDownLabel)
  ui.widget.heroNameLabel = lbl.createFont2(18, "", ccc3(255, 255, 255))
  ui.widget.heroNameLabel:setVisible(false)
  ui.widget.spineNode:addChildFollowSlot("code_name", ui.widget.heroNameLabel)
  ui.widget.heroGroupImg = img.createGroupIcon(1)
  ui.widget.heroGroupImg:setVisible(false)
  ui.widget.heroGroupImg:setScale(0.3864)
  ui.widget.spineNode:addChildFollowSlot("code_circle", ui.widget.heroGroupImg)
  ui.widget.heroHpBar = ui.createStateBar("hp", "large")
  ui.widget.heroHpBar:setVisible(false)
  ui.widget.spineNode:addChildFollowSlot("code_upperline", ui.widget.heroHpBar)
  ui.widget.heroMpBar = ui.createStateBar("mp", "large")
  ui.widget.heroMpBar:setVisible(false)
  ui.widget.spineNode:addChildFollowSlot("code_underline", ui.widget.heroMpBar)
  ui.widget.waveLabel = lbl.createFont2(24, "--", ccc3(250, 216, 105))
  ui.widget.upSpine:addChildFollowSlot("code_text", ui.widget.waveLabel)
  local speedLayer = CCLayer:create()
  ui.widget.speedBuffBar = ui.createBuff({name = "speed", nowNum = 0, maxNum = 20})
  speedLayer:addChild(ui.widget.speedBuffBar)
  speedLayer:setPositionY(-5)
  ui.widget.spineNode:addChildFollowSlot("code_drug1", speedLayer)
  autoLayoutShift(ui.widget.speedBuffBar, false, true, true, false)
  local powerLayer = CCLayer:create()
  ui.widget.powerBuffBar = ui.createBuff({name = "power", nowNum = 0, maxNum = 20})
  powerLayer:addChild(ui.widget.powerBuffBar)
  powerLayer:setPositionY(-5)
  ui.widget.spineNode:addChildFollowSlot("code_drug2", powerLayer)
  autoLayoutShift(ui.widget.powerBuffBar, false, true, true, false)
  local critLayer = CCLayer:create()
  ui.widget.critBuffBar = ui.createBuff({name = "crit", nowNum = 0, maxNum = 20})
  critLayer:addChild(ui.widget.critBuffBar)
  critLayer:setPositionY(-5)
  ui.widget.spineNode:addChildFollowSlot("code_drug3", critLayer)
  autoLayoutShift(ui.widget.critBuffBar, false, true, true, false)
  ui.widget.angelBtn = ui.createDrugBtn("angel")
  ui.widget.sideSpine:addChildFollowSlot("1code_leftdrag1", ui.widget.angelBtn.menu)
  ui.widget.evilBtn = ui.createDrugBtn("evil")
  ui.widget.sideSpine:addChildFollowSlot("1code_leftdrag2", ui.widget.evilBtn.menu)
  ui.widget.milkBtn = ui.createDrugBtn("milk")
  ui.widget.sideSpine:addChildFollowSlot("1code_leftdrag3", ui.widget.milkBtn.menu)
  ui.widget.angelLabel = lbl.createFont2(14, #soloData.angel)
  ui.widget.angelLabel:setPosition(ccp(65, 19))
  ui.widget.angelLabel:setScale(1 / ui.widget.angelBtn:getScale())
  ui.widget.angelBtn.img:addChild(ui.widget.angelLabel)
  ui.widget.evilLabel = lbl.createFont2(14, #soloData.evil)
  ui.widget.evilLabel:setPosition(ccp(65, 19))
  ui.widget.evilLabel:setScale(1 / ui.widget.evilBtn:getScale())
  ui.widget.evilBtn.img:addChild(ui.widget.evilLabel)
  ui.widget.milkLabel = lbl.createFont2(14, #soloData.milk)
  ui.widget.milkLabel:setPosition(ccp(65, 19))
  ui.widget.milkLabel:setScale(1 / ui.widget.milkBtn:getScale())
  ui.widget.milkBtn.img:addChild(ui.widget.milkLabel)
  ui.widget.autoBtn = ui.createAutoBtn()
  local autoMenu = CCMenu:createWithItem(ui.widget.autoBtn)
  autoMenu:setCascadeOpacityEnabled(true)
  autoMenu:ignoreAnchorPointForPosition(false)
  ui.widget.spineNode:addChildFollowSlot("code_autofight", autoMenu)
  ui.widget.autoBtn:setPositionX(42)
  autoLayoutShift(ui.widget.autoBtn, false, true, false, true)
  ui.widget.battleBtn = ui.createBattleBtn()
  local battleMenu = CCMenu:createWithItem(ui.widget.battleBtn)
  battleMenu:setCascadeOpacityEnabled(true)
  battleMenu:ignoreAnchorPointForPosition(false)
  ui.widget.spineNode:addChildFollowSlot("code_button", battleMenu)
  ui.widget.backBtn = HHMenuItem:create(img.createUISprite(img.ui.back))
  ui.widget.backBtn:setScale(view.minScale)
  ui.widget.backBtn:setPosition(scalep(35, 540))
  local backMenu = CCMenu:createWithItem(ui.widget.backBtn)
  backMenu:setPosition(ccp(0, 0))
  ui.widget.layer:addChild(backMenu, 1000)
  autoLayoutShift(ui.widget.backBtn, true, false, true, false)
  local traderBtnImg = img.createUISprite(img.ui.solo_trader_btn)
  ui.widget.traderBtn = SpineMenuItem:create(json.ui.button, traderBtnImg)
  ui.widget.traderBtn:setScale(view.minScale)
  ui.widget.traderBtn:setPosition(scalep(810, 540))
  local traderMenu = CCMenu:createWithItem(ui.widget.traderBtn)
  traderMenu:setPosition(ccp(0, 0))
  ui.widget.layer:addChild(traderMenu, 1000)
  local btnSpine = json.create(json.ui.solo_btn)
  btnSpine:playAnimation("animation", -1)
  btnSpine:setPosition(ui.widget.traderBtn:getContentSize().width / 2, ui.widget.traderBtn:getContentSize().height / 2)
  traderBtnImg:addChild(btnSpine)
  autoLayoutShift(ui.widget.traderBtn, true, false, false, true)
  local rankImg = img.createUISprite(img.ui.btn_rank)
  ui.widget.rankBtn = SpineMenuItem:create(json.ui.button, rankImg)
  ui.widget.rankBtn:setScale(view.minScale)
  ui.widget.rankBtn:setPosition(scalep(865, 540))
  local rankMenu = CCMenu:createWithItem(ui.widget.rankBtn)
  rankMenu:setPosition(ccp(0, 0))
  ui.widget.layer:addChild(rankMenu, 1000)
  autoLayoutShift(ui.widget.rankBtn, true, false, false, true)
  local helpImg = img.createUISprite(img.ui.btn_help)
  ui.widget.helpBtn = SpineMenuItem:create(json.ui.button, helpImg)
  ui.widget.helpBtn:setScale(view.minScale)
  ui.widget.helpBtn:setPosition(scalep(920, 540))
  local helpMenu = CCMenu:createWithItem(ui.widget.helpBtn)
  helpMenu:setPosition(ccp(0, 0))
  ui.widget.layer:addChild(helpMenu, 1000)
  autoLayoutShift(ui.widget.helpBtn, true, false, false, true)
  ui.initHandle()
  ui.btnCallback()
  return ui.widget.layer
end

ui.beCenter = function(l_2_0, l_2_1)
  local interval = 8
  local width1 = l_2_0:boundingBox():getMaxX() - l_2_0:boundingBox():getMinX()
  local width2 = l_2_1:boundingBox():getMaxX() - l_2_1:boundingBox():getMinX()
  local totalW = width1 + width2 + interval
  print("\233\149\191\229\186\166\228\184\186" .. totalW .. " " .. width1 .. " " .. width2)
  l_2_0:setPositionX(not totalW / 2)
  l_2_1:setPositionX(totalW / 2)
end

ui.initData = function(l_3_0)
end

ui.initHandle = function()
  if soloData.heroList == nil or #soloData.heroList == 0 then
    local selectUI = require("ui.solo.selectHeroes")
    selectUI.mainUI = ui
    ui.widget.selectLayer = selectUI.create()
    ui.widget.layer:addChild(ui.widget.selectLayer, 99999)
    return 
  end
  ui.createSwallowLayer(0.5)
  ui.addHeroIcon()
  if ui.isFirst and soloData.getTrader() then
    soloData.setWave(soloData.getWave() - 1)
  end
  ui.isFirst = false
  local stageLevel = soloData.getStageLevel()
  if stageLevel >= 5 or not stageLevel then
    stageLevel = 4
  end
  ui.widget.waveLabel:setString(i18n.global.solo_stage" .. stageLeve.string .. ":" .. (soloData.getWave() - 1) % ui.data.maxClearNum + 1)
  local isClear = ui.clearStage()
  if isClear then
    return 
  end
  if soloData.getReward() then
    print("\229\174\157\231\174\177\228\184\141\228\184\186\231\169\186")
    ui.showRewardSpine()
  else
    if soloData.getBuf() then
      local bufID = soloData.getBufType()
      ui.setBattleBtnState(ui.widget.battleBtn, "disable")
      ui.showPotionSpine(bufID)
    else
      if soloData.getTrader() then
        local traderID = cfgTrader[soloData.getTrader()].Body
        ui.setBattleBtnState(ui.widget.battleBtn, "skip")
        ui.showTraderSpine(traderID)
      else
        if soloData.getStage() then
          local bossID = cfgSpkWave[soloData.getStage()].show
          ui.showBossSpine(bossID)
        end
      end
    end
  end
  local isAuto = soloData.getAutoState()
  if isAuto and ui.widget.autoBtn.state == "normal" then
    ui.changeAutoBtnState(ui.widget.autoBtn)
    if ui.widget.battleBtn.state == "fight" then
      ui.setBattleBtnState(ui.widget.battleBtn, "auto")
    end
  end
  if soloData.getSelectOrder() and soloData.heroList[soloData.getSelectOrder()] and soloData.heroList[soloData.getSelectOrder()].hp > 0 then
    ui.selectHero(soloData.getSelectOrder())
    return 
  end
  for i,v in ipairs(soloData.heroList) do
    if v.hp > 0 then
      ui.selectHero(i)
      return 
    end
  end
  ui.heroAllDie()
end

ui.refreshBoss = function()
  if ui.data.overNum <= soloData.getWave() then
    soloData.setWave(soloData.getWave() + 1)
    ui.clearStage()
    return 
  end
  soloData.setReward(nil)
  soloData.setTrader(nil)
  soloData.setBuf(nil)
  soloData.setWave(soloData.getWave() + 1)
  if ui.data.overNum <= soloData.getWave() then
    local stageLevel = soloData.getStageLevel()
    ui.widget.waveLabel:setString(i18n.global.solo_stage" .. stageLeve.string .. ":" .. ui.data.maxClearNum)
  else
    local stageLevel = soloData.getStageLevel()
    ui.widget.waveLabel:setString(i18n.global.solo_stage" .. stageLeve.string .. ":" .. (soloData.getWave() - 1) % ui.data.maxClearNum + 1)
  end
  ui.widget.spineNode:removeChildFollowSlot("code_trader")
  ui.widget.spineNode:removeChildFollowSlot("code_drug")
  ui.setBattleBtnState(ui.widget.battleBtn, "fight")
  if ui.widget.autoBtn.state == "auto" then
    ui.setBattleBtnState(ui.widget.battleBtn, "auto")
    ui.widget.spineNode:registerAnimation("auto_fight", -1)
    ui.widget.autoSpine:registerAnimation("auto_fight", -1)
    ui.widget.autoSpine:setVisible(true)
  end
  local bossList = soloData.convertBossInfo({})
  soloData.bossList = bossList
  local id = cfgSpkWave[soloData.getStage()].show
  ui.showBossSpine(id)
end

ui.refreshUI = function(l_6_0)
  print("---------\232\191\155\229\133\165\229\136\183\230\150\176\229\135\189\230\149\176 refreshUI")
  if not l_6_0.win then
    if l_6_0.mhpp then
      soloData.heroList[soloData.getSelectOrder()].hp = l_6_0.mhpp
    else
      soloData.heroList[soloData.getSelectOrder()].hp = 0
    end
    if l_6_0.menergy then
      soloData.heroList[soloData.getSelectOrder()].mp = l_6_0.menergy
    else
      soloData.heroList[soloData.getSelectOrder()].mp = 0
    end
    ui.setStateBar(ui.widget.heroIcons[soloData.getSelectOrder()].hpBar, soloData.heroList[soloData.getSelectOrder()].hp / 100)
    ui.setStateBar(ui.widget.heroIcons[soloData.getSelectOrder()].mpBar, soloData.heroList[soloData.getSelectOrder()].mp / 100)
    if soloData.heroList[soloData.getSelectOrder()].hp == 0 then
      ui.beGray(ui.widget.heroIcons[soloData.getSelectOrder()])
      clearShader(ui.widget.heroIcons[soloData.getSelectOrder()].hpBar, true)
      clearShader(ui.widget.heroIcons[soloData.getSelectOrder()].mpBar, true)
      soloData.setSelectOrder(nil)
    end
    for i,v in ipairs(l_6_0.ehpp) do
      soloData.bossList[i].hp = v
    end
    for i,v in ipairs(soloData.heroList) do
      if v.hp >= 0 then
        ui.initHandle()
        return 
      end
    end
    ui.heroAllDie()
  else
    ui.widget.spineNode:unregisterAnimation("auto_fight")
    ui.widget.autoSpine:unregisterAnimation("auto_fight")
    ui.widget.autoSpine:setVisible(false)
    if l_6_0.mhpp then
      soloData.heroList[soloData.getSelectOrder()].hp = l_6_0.mhpp
    end
    if l_6_0.menergy then
      soloData.heroList[soloData.getSelectOrder()].mp = l_6_0.menergy
    end
    ui.setStateBar(ui.widget.heroIcons[soloData.getSelectOrder()].hpBar, soloData.heroList[soloData.getSelectOrder()].hp / 100)
    ui.setStateBar(ui.widget.heroIcons[soloData.getSelectOrder()].mpBar, soloData.heroList[soloData.getSelectOrder()].mp / 100)
    ui.selectHero(soloData.getSelectOrder())
    if l_6_0.buf then
      print("\232\142\183\229\190\151\231\154\132\232\141\175\230\176\180id\228\184\186" .. l_6_0.buf)
      soloData.setStage(l_6_0.nstage)
      soloData.setBuf(l_6_0.buf)
      soloData.setReward(nil)
      soloData.setTrader(nil)
      ui.showPotionSpine(soloData.getBufType())
      if ui.widget.autoBtn.state == "auto" then
        ui.widget.spineNode:unregisterAnimation("auto_fight")
        ui.widget.autoSpine:unregisterAnimation("auto_fight")
        ui.widget.autoSpine:setVisible(false)
      end
      ui.setBattleBtnState(ui.widget.battleBtn, "fight")
    elseif l_6_0.seller then
      soloData.setTrader(l_6_0.seller)
      soloData.setReward(nil)
      soloData.setBuf(nil)
      local traderName = cfgTrader[l_6_0.seller].Body
      if ui.widget.autoBtn.state == "auto" then
        ui.widget.spineNode:unregisterAnimation("auto_fight")
        ui.widget.autoSpine:unregisterAnimation("auto_fight")
        ui.widget.autoSpine:setVisible(false)
      end
      ui.setBattleBtnState(ui.widget.battleBtn, "skip")
      ui.showTraderSpine(traderName)
    elseif l_6_0.reward then
      soloData.setReward(l_6_0.reward)
      soloData.setBuf(nil)
      soloData.setTrader(nil)
      soloData.setStage(l_6_0.nstage)
      ui.showRewardSpine()
    end
    local bossList = soloData.convertBossInfo({})
    soloData.bossList = bossList
    ui.initHandle()
  end
end

ui.btnCallback = function()
  addBackEvent(ui.widget.layer)
  local onEnter = function()
    ui.widget.layer.notifyParentLock()
   end
  local onExit = function()
    ui.widget.layer.notifyParentUnlock()
   end
  ui.widget.layer.onAndroidBack = function()
    audio.play(audio.button)
    replaceScene(require("ui.town.main").create())
   end
  ui.widget.layer:registerScriptHandler(function(l_4_0)
    if l_4_0 == "enter" then
      onEnter()
    elseif l_4_0 == "exit" then
      onExit()
    elseif l_4_0 == "cleanup" then
       -- Warning: missing end command somewhere! Added here
    end
   end)
  ui.widget.backBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    replaceScene(require("ui.town.main").create())
   end)
  ui.widget.traderBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    ui.widget.traderBtn:setEnabled(false)
    local delay = CCDelayTime:create(0.8)
    local callfunc = CCCallFunc:create(function()
      ui.widget.traderBtn:setEnabled(true)
      end)
    local sequence = CCSequence:createWithTwoActions(delay, callfunc)
    ui.widget.traderBtn:runAction(sequence)
    local traderClassifyUI = require("ui.solo.traderClassifyUI").create()
    ui.widget.layer:addChild(traderClassifyUI, 99999)
   end)
  ui.widget.rankBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    addWaitNet()
    local params = {sid = player.sid}
    print("\230\142\146\232\161\140\230\166\156\229\143\145\233\128\129\230\149\176\230\141\174")
    tablePrint(params)
    net:spk_rank(params, function(l_1_0)
      delWaitNet()
      print("\230\136\145\231\154\132uid:" .. require("data.player").uid)
      print("\230\142\146\232\161\140\230\166\156\232\191\148\229\155\158\230\149\176\230\141\174")
      tablePrint(l_1_0)
      local rankUI = require("ui.solo.rankUI").create(l_1_0)
      ui.widget.layer:addChild(rankUI, 99999)
      end)
   end)
  ui.widget.helpBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    ui.widget.helpBtn:setEnabled(false)
    local delay = CCDelayTime:create(0.8)
    local callfunc = CCCallFunc:create(function()
      ui.widget.helpBtn:setEnabled(true)
      end)
    local sequence = CCSequence:createWithTwoActions(delay, callfunc)
    ui.widget.helpBtn:runAction(sequence)
    local helpUI = require("ui.help").create(i18n.global.solo_help.string)
    ui.widget.layer:addChild(helpUI, 99999)
   end)
  local callBack = nil
  local size = ui.widget.angelBtn:getContentSize()
  callBack = function()
    ui.addDrugTipUI("angel")
   end
  ui.widget.angelNode = ui.createTipBtn(275, 288, ui.widget.angelBtn, "angel", callBack)
  ui.widget.angelNode:setContentSize(size)
  ui.widget.angelNode:setPosition(size.width / 2, size.height / 2)
  ui.widget.angelBtn:addChild(ui.widget.angelNode)
  callBack = function()
    ui.addDrugTipUI("evil")
   end
  ui.widget.evilNode = ui.createTipBtn(275, 288, ui.widget.evilBtn, "evil", callBack)
  ui.widget.evilNode:setContentSize(size)
  ui.widget.evilNode:setPosition(size.width / 2, size.height / 2)
  ui.widget.evilBtn:addChild(ui.widget.evilNode)
  callBack = function()
    ui.addDrugTipUI("milk")
   end
  ui.widget.milkNode = ui.createTipBtn(275, 288, ui.widget.milkBtn, "milk", callBack)
  ui.widget.milkNode:setContentSize(size)
  ui.widget.milkNode:setPosition(size.width / 2, size.height / 2)
  ui.widget.milkBtn:addChild(ui.widget.milkNode)
  ui.widget.touchLayer:registerScriptTouchHandler(ui.onTouch)
  ui.widget.battleBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if ui.widget.battleBtn.state == "fight" then
      addWaitNet()
      local params = {sid = player.sid, hid = soloData.heroList[soloData.getSelectOrder()].hid}
      print("\230\137\139\229\138\168\230\136\152\230\150\151\231\154\132\230\149\176\230\141\174")
      tablePrint(params)
      net:spk_fight(params, function(l_1_0)
        delWaitNet()
        print("\232\191\148\229\155\158\230\137\139\229\138\168\230\136\152\230\150\151\228\191\161\230\129\175")
        tbl2string(l_1_0)
        if l_1_0.status == 0 then
          if soloData.getWave() % 100 == 0 and l_1_0.win then
            local achieveData = require("data.achieve")
            achieveData.add(ACHIEVE_TYPE_SOLOPASS, 1)
          end
          ui.storageReward(l_1_0.reward)
          local video = clone(l_1_0)
          video.data = l_1_0
          video.stage = soloData.getStage()
          video.atk = {}
          video.atk.camp = {1 = soloData.heroList[soloData.getSelectOrder()]}
          video.def = {}
          video.def.camp = soloData.getAliveBoss()
          replaceScene(require("fight.solo.loading").create(video))
        end
         end)
    else
      if ui.widget.battleBtn.state == "auto" then
        addWaitNet()
        local params = {sid = player.sid, hid = soloData.heroList[soloData.getSelectOrder()].hid}
        print("\232\135\170\229\138\168\230\136\152\230\150\151\230\149\176\230\141\174")
        tablePrint(params)
        net:spk_fight(params, function(l_2_0)
          delWaitNet()
          print("\232\191\148\229\155\158\231\154\132\232\135\170\229\138\168\230\136\152\230\150\151\228\191\161\230\129\175")
          tablePrint(l_2_0)
          if l_2_0.status == 0 then
            if soloData.getWave() % 100 == 0 and l_2_0.win then
              local achieveData = require("data.achieve")
              achieveData.add(ACHIEVE_TYPE_SOLOPASS, 1)
            end
            ui.storageReward(l_2_0.reward)
            local video = clone(l_2_0)
            video.data = l_2_0
            video.stage = soloData.getStage()
            video.atk = {}
            video.atk.camp = {1 = soloData.heroList[soloData.getSelectOrder()]}
            video.def = {}
            video.def.camp = soloData.getAliveBoss()
            video.auto = true
            video.callback = function()
              ui.endBossSpine(data)
                  end
            if video.win then
              ui.widget.layer:addChild(require("fight.solo.win").create(video), 1000)
            else
              ui.widget.layer:addChild(require("fight.solo.lose").create(video), 1000)
            end
          end
            end)
      else
        if ui.widget.battleBtn.state == "skip" then
          addWaitNet()
          local params = {sid = player.sid, skip = 1}
          print("\229\143\145\233\128\129\231\154\132\232\183\179\232\191\135\228\191\161\230\129\175")
          tablePrint(params)
          net:spk_buy(params, function(l_3_0)
            delWaitNet()
            print("\232\191\148\229\155\158\231\154\132\232\183\179\232\191\135\228\191\161\230\129\175")
            tablePrint(l_3_0)
            if l_3_0.status == 0 then
              soloData.setStage(l_3_0.nstage)
              ui.setBattleBtnState(ui.widget.battleBtn, "fight")
              ui.endTraderSpine()
            end
               end)
        end
      end
    end
   end)
  ui.widget.autoBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if ui.widget.autoBtn.state == "normal" and ui.widget.battleBtn.state == "fight" then
      ui.changeAutoBtnState(ui.widget.autoBtn)
      ui.setBattleBtnState(ui.widget.battleBtn, "auto")
    else
      if ui.widget.autoBtn.state == "auto" and ui.widget.battleBtn.state == "auto" then
        ui.widget.spineNode:registerAnimation("animation")
        ui.changeAutoBtnState(ui.widget.autoBtn)
        ui.setBattleBtnState(ui.widget.battleBtn, "fight")
      else
        ui.changeAutoBtnState(ui.widget.autoBtn)
      end
    end
   end)
  ui.widget.objTouchBtn:registerScriptTapHandler(function()
    if soloData.getBuf() then
      do return end
    end
    if soloData.getTrader() then
      ui.showBuyUI()
    else
      if soloData.getStage() then
        ui.showBossList()
      end
    end
   end)
end

ui.addHeroIcon = function()
  for i = 1, #soloData.heroList do
    if ui.widget.heroIcons[i] then
      return 
    end
    ui.widget.heroIcons[i] = ui.createHeroIcon(soloData.heroList[i])
    ui.widget.downSpine:addChildFollowSlot("code_hero" .. i, ui.widget.heroIcons[i])
  end
end

ui.createDrugBtn = function(l_9_0)
  local btnImg = img.createUISprite(img.ui.grid)
  local size = (btnImg:getContentSize())
  local drugPath = nil
  if l_9_0 == "milk" then
    drugPath = img.ui.solo_milk
  elseif l_9_0 == "angel" then
    drugPath = img.ui.solo_angel_potion
  elseif l_9_0 == "evil" then
    drugPath = img.ui.solo_evil_potion
  end
  local icon = img.createUISprite(drugPath)
  icon:setScale(0.6)
  icon:setPosition(btnImg:getContentSize().width / 2, btnImg:getContentSize().height / 2)
  btnImg:addChild(icon)
  local btn = SpineMenuItem:create(json.ui.button, btnImg)
  btn:setScale(1.5)
  local drugMenu = CCMenu:createWithItem(btn)
  drugMenu:setPosition(ccp(0, 0))
  btn:setPosition(ccp(0, 0))
  btn.menu = drugMenu
  btn.img = btnImg
  btn:setPositionY(1)
  return btn
end

ui.createStateBar = function(l_10_0, l_10_1, l_10_2)
  if not l_10_2 then
    l_10_2 = 100
  end
  local bgStr = {hp = img.ui.fight_hp_bg[l_10_1], mp = img.ui.fight_ep_bg[l_10_1]}
  local fgStr = {hp = img.ui.fight_hp_fg[l_10_1], mp = img.ui.fight_ep_fg[l_10_1]}
  local box = img.createUISprite(bgStr[l_10_0])
  box:setCascadeOpacityEnabled(true)
  local bar = createProgressBar(img.createUISprite(fgStr[l_10_0]))
  bar:setAnchorPoint(ccp(0, 0.5))
  bar:setPositionX(box:getContentSize().width / 2 - bar:getContentSize().width / 2)
  bar:setPositionY(box:getContentSize().height / 2)
  box:addChild(bar)
  bar:setPercentage(l_10_2)
  box.bar = bar
  box.type = l_10_0
  box.percent = l_10_2
  return box
end

ui.setStateBar = function(l_11_0, l_11_1)
  l_11_0.bar:stopAllActions()
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_11_0.bar:setPercentage(l_11_1 * 100)
end

ui.changeStateBar = function(l_12_0, l_12_1, l_12_2)
  if (l_12_1 > 1 and 1) or not l_12_2 then
    l_12_2 = 0.5
  end
  local percent = l_12_0.bar:getPercentage()
  local actionTimes = l_12_2 / 0.01
  local deltaPercent = (l_12_1 * 100 - percent) / actionTimes
  local delay = CCDelayTime:create(0.01)
  local callfunc = CCCallFunc:create(function()
    percent = percent + deltaPercent
    stateBar.bar:setPercentage(percent)
   end)
  local sequence = CCSequence:createWithTwoActions(callfunc, delay)
  l_12_0.bar:stopAllActions()
  l_12_0.bar:runAction(CCRepeat:create(sequence, actionTimes))
end

ui.createBuff = function(l_13_0)
  l_13_0.maxNum = l_13_0.maxNum or 20
  local name = l_13_0.name
  local iconList = {speed = img.ui.solo_speed_potion_small, power = img.ui.solo_power_potion_small, crit = img.ui.solo_crit_potion_small}
  local barList = {speed = img.ui.solo_speed_bar, power = img.ui.solo_power_bar, crit = img.ui.solo_crit_bar}
  local board = img.createUI9Sprite(img.ui.main_coin_bg)
  board:setPreferredSize(CCSize(182, 39))
  board:setAnchorPoint(ccp(0.5, 1))
  local progressBar = createProgressBar(img.createUISprite(barList[name]))
  progressBar:setAnchorPoint(ccp(0, 0.5))
  progressBar:setPosition(ccp(8, board:getContentSize().height / 2 + 3))
  progressBar:setPercentage(l_13_0.nowNum / l_13_0.maxNum < 1 and l_13_0.nowNum / l_13_0.maxNum * 100 or 100)
  board:addChild(progressBar)
  local progressLabel = lbl.createFont2(14, l_13_0.nowNum .. "/" .. l_13_0.maxNum)
  progressLabel:setPosition(ccp(board:getContentSize().width / 2, board:getContentSize().height / 2 + 3))
  board:addChild(progressLabel)
  local spineList = {speed = json.ui.solo_speed, power = json.ui.solo_power, crit = json.ui.solo_crit}
  local drugSpine = json.create(spineList[name])
  drugSpine:setPosition(8, board:getContentSize().height / 2 + 2)
  board:addChild(drugSpine)
  local iconList = {speed = img.ui.solo_speed_potion_small, power = img.ui.solo_power_potion_small, crit = img.ui.solo_crit_potion_small}
  local codeList = {speed = "code_3702", power = "code_3802", crit = "code_3902"}
  local icon = img.createUISprite(iconList[name])
  drugSpine:addChildFollowSlot(codeList[name], icon)
  icon:setPositionY(1)
  local act = {speed = "1speed_click", power = "2power_click", crit = "3cc_click"}
  drugSpine:playAnimation(act[name])
  drugSpine:stopAnimation()
  local btn = ui.createTipBtn(174, 233, board, name)
  btn:setContentSize(board:getContentSize())
  btn:setPosition(ccp(board:getContentSize().width / 2, board:getContentSize().height / 2))
  board:addChild(btn)
  board.name = name
  board.progressBar = progressBar
  board.progressLabel = progressLabel
  board.nowNum = l_13_0.nowNum
  board.maxNum = l_13_0.maxNum
  board.drugSpine = drugSpine
  return board
end

ui.createTipBtn = function(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4)
  local tipUI = nil
  local btn = CCNode:create()
  btn:setTouchEnabled(true)
  btn:setContentSize(l_14_2:getContentSize())
  btn:setAnchorPoint(ccp(0.5, 0.5))
  btn:setPosition(ccp(l_14_2:getContentSize().width / 2, l_14_2:getContentSize().height / 2))
  btn:registerScriptTouchHandler(function(l_1_0, l_1_1, l_1_2)
    if l_1_0 == "began" then
      print("aaaaaa")
      local point = btn:getParent():convertToNodeSpace(ccp(l_1_1, l_1_2))
      local rect = btn:boundingBox()
      if rect:containsPoint(point) then
        local delay = CCDelayTime:create(0.3)
        local callfunc = CCCallFunc:create(function()
          tipUI = ui.showBuffIntro(name)
          tipUI.bg:setPosition(scalep(posX, posY))
          local size = tipUI.bg:getBoundingBox()
          local posX1 = tipUI.bg:getPositionX()
          tipUI.bg:setPositionX(math.max(size.width / 2, posX1))
          if name == "angel" or name == "evil" or name == "milk" then
            autoLayoutShift(tipUI.bg, false, false, true, false)
          else
            autoLayoutShift(tipUI.bg, false, true, false, false)
          end
            end)
        local sequence = CCSequence:createWithTwoActions(delay, callfunc)
        btn:stopAllActions()
        btn:runAction(sequence)
        return true
      else
        return false
      end
    elseif l_1_0 == "ended" then
      print("ended")
      btn:stopAllActions()
      if tipUI then
        tipUI:removeFromParent()
        upvalue_512 = nil
      elseif callback then
        print("bbbbb")
        callback()
      end
    end
   end)
  return btn
end

ui.showBuffIntro = function(l_15_0)
  local layer = CCLayer:create()
  layer:setTouchEnabled(true)
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setPreferredSize(CCSizeMake(430, 166))
  bg:setScale(view.minScale)
  bg:setPosition(scalep(174, 223))
  layer.bg = bg
  layer:addChild(bg)
  local bg_w = bg:getContentSize().width
  local bg_h = bg:getContentSize().height
  local lineImg = img.createUI9Sprite(img.ui.hero_tips_fgline)
  lineImg:setPreferredSize(CCSize(378, 1))
  lineImg:setPosition(ccp(bg:getContentSize().width / 2, 86))
  bg:addChild(lineImg)
  local box = img.createUISprite(img.ui.grid)
  box:setScale(52 / box:getContentSize().width)
  box:setAnchorPoint(ccp(0, 1))
  box:setPositionX(24)
  box:setPositionY(bg:getContentSize().height - box:getPositionX())
  bg:addChild(box)
  local drugStr = {power = "solo_power_potion_small", speed = "solo_speed_potion_small", crit = "solo_crit_potion_small", milk = "solo_milk", angel = "solo_angel_potion", evil = "solo_evil_potion"}
  local icon = img.createUISprite(img.ui[drugStr[l_15_0]])
  icon:setScale(1 / box:getScale())
  if l_15_0 == "milk" or l_15_0 == "angel" or l_15_0 == "evil" then
    icon:setScale(1 / box:getScale() * 0.4)
  end
  icon:setPosition(box:getContentSize().width / 2, box:getContentSize().height / 2)
  box:addChild(icon)
  local nameLabel = lbl.createFont1(22, i18n.global.solo_drugName_" .. l_15_.string, ccc3(255, 228, 156))
  nameLabel:setAnchorPoint(ccp(0, 0))
  nameLabel:setPosition(ccp(80, 106))
  bg:addChild(nameLabel)
  local introLabel = nil
  if l_15_0 == "milk" or l_15_0 == "evil" or l_15_0 == "angel" then
    local addStr = i18n.global.solo_drugIntro_" .. l_15_.string
    introLabel = lbl.createMix({font = 1, size = 16, width = 380, text = addStr, color = ccc3(251, 251, 251), align = kCCTextAlignmentLeft})
  else
    local addNum = {power = 1.5, speed = 2, crit = 2}
    local drugNum = soloData.heroList[soloData.getSelectOrder()][l_15_0]
    local addStr = string.format(i18n.global.solo_drugIntro_" .. l_15_.string, addNum[l_15_0] * drugNum)
    introLabel = lbl.createMix({font = 1, size = 16, width = 380, text = addStr, color = ccc3(251, 251, 251), align = kCCTextAlignmentLeft})
  end
  introLabel:setAnchorPoint(ccp(0, 1))
  introLabel:setPosition(ccp((bg:getContentSize().width - 380) / 2, 70))
  bg:addChild(introLabel)
  local sprite = CCSprite:create()
  sprite:setContentSize(bg:getContentSize())
  local btn = SpineMenuItem:create(json.ui.button, sprite)
  btn:setPosition(ccp(bg:getContentSize().width / 2, bg:getContentSize().height / 2))
  local touchMenu = CCMenu:createWithItem(btn)
  touchMenu:setPosition(0, 0)
  bg:addChild(touchMenu)
  layer:registerScriptTouchHandler(function(l_1_0, l_1_1, l_1_2)
    if l_1_0 == "began" then
      return true
    elseif l_1_0 == "ended" then
      layer:removeFromParent()
    end
   end)
  ui.widget.layer:addChild(layer, 99999)
  return layer
end

ui.changeBuffBarState = function(l_16_0, l_16_1)
  print("buff\229\144\141\231\167\176" .. l_16_0.name)
  print("\230\156\128\229\164\167\229\128\188:" .. l_16_0.maxNum)
  print("\229\189\147\229\137\141\229\128\188" .. l_16_1[l_16_0.name])
  if l_16_1[l_16_0.name] >= l_16_0.maxNum or not l_16_1[l_16_0.name] then
    l_16_0.nowNum = l_16_0.maxNum
  end
  l_16_0.progressLabel:setString(l_16_0.nowNum .. "/" .. l_16_0.maxNum)
  l_16_0.progressBar:setPercentage(l_16_0.nowNum / l_16_0.maxNum * 100)
end

ui.createAutoBtn = function()
  local btnImg = img.createUI9Sprite(img.ui.btn_1)
  btnImg:setPreferredSize(CCSizeMake(88, 80))
  local autoBtn = SpineMenuItem:create(json.ui.button, btnImg)
  local autoImg = img.createUI9Sprite(img.ui.btn_7)
  autoImg:setPreferredSize(CCSizeMake(88, 80))
  autoImg:setPosition(ccp(btnImg:getContentSize().width / 2, btnImg:getContentSize().height / 2))
  btnImg:addChild(autoImg)
  local autoIcon = img.createUISprite(img.ui.solo_auto_battle_change)
  autoIcon:setPosition(ccp(autoImg:getContentSize().width / 2, autoImg:getContentSize().height / 2 + 5))
  autoImg:addChild(autoIcon)
  local autoLabel = lbl.createFont1(12, i18n.global.solo_battle_manual.string, ccc3(29, 103, 0))
  autoLabel:setPosition(ccp(autoImg:getContentSize().width / 2, autoImg:getContentSize().height / 2 - 20))
  autoImg:addChild(autoLabel)
  local normalImg = img.createUI9Sprite(img.ui.btn_1)
  normalImg:setPreferredSize(CCSizeMake(88, 80))
  normalImg:setPosition(ccp(btnImg:getContentSize().width / 2, btnImg:getContentSize().height / 2))
  btnImg:addChild(normalImg)
  local normalIcon = img.createUISprite(img.ui.solo_auto_battle_normal)
  normalIcon:setPosition(ccp(normalImg:getContentSize().width / 2, normalImg:getContentSize().height / 2 + 5))
  normalImg:addChild(normalIcon)
  local normalLabel = lbl.createFont1(12, i18n.global.solo_battle_auto.string, ccc3(134, 59, 33))
  normalLabel:setPosition(ccp(normalImg:getContentSize().width / 2, normalImg:getContentSize().height / 2 - 20))
  normalImg:addChild(normalLabel)
  ui.widget.autoSpine = json.create(json.ui.solo_auto)
  ui.widget.autoSpine:setPosition(ccp(btnImg:getContentSize().width / 2, btnImg:getContentSize().height / 2))
  btnImg:addChild(ui.widget.autoSpine)
  autoBtn.state = "normal"
  autoBtn.normalImg = normalImg
  autoBtn.label = label
  return autoBtn
end

ui.changeAutoBtnState = function(l_18_0)
  if l_18_0.state == "normal" then
    l_18_0.state = "auto"
    l_18_0.normalImg:setVisible(false)
    soloData.setAutoState(true)
    if not soloData.getTrader() and not soloData.getReward() and not soloData.getBuf() then
      ui.widget.spineNode:registerAnimation("auto_fight", -1)
      ui.widget.autoSpine:registerAnimation("auto_fight", -1)
      ui.widget.autoSpine:setVisible(true)
    else
      l_18_0.state = "normal"
      l_18_0.normalImg:setVisible(true)
      soloData.setAutoState(false)
      ui.widget.spineNode:unregisterAnimation("auto_fight")
      ui.widget.autoSpine:unregisterAnimation("auto_fight")
      ui.widget.autoSpine:setVisible(false)
    end
  end
end

ui.createBattleBtn = function()
  local battleImg = img.createUISprite(img.ui.solo_battle_btn)
  local battleBtn = SpineMenuItem:create(json.ui.button, battleImg)
  battleImg:setCascadeOpacityEnabled(true)
  battleBtn:setCascadeOpacityEnabled(true)
  local redSword = img.createUISprite(img.ui.solo_sword_red)
  redSword:setPositionX(battleBtn:getContentSize().width / 2)
  redSword:setPositionY(battleBtn:getContentSize().height / 2)
  battleImg:addChild(redSword)
  local blueSword = img.createUISprite(img.ui.solo_sword_blue)
  blueSword:setPositionX(battleBtn:getContentSize().width / 2)
  blueSword:setPositionY(battleBtn:getContentSize().height / 2)
  battleImg:addChild(blueSword)
  local skipImg = img.createUISprite(img.ui.solo_skip)
  skipImg:setPositionX(battleBtn:getContentSize().width / 2)
  skipImg:setPositionY(battleBtn:getContentSize().height / 2)
  skipImg:setVisible(false)
  battleImg:addChild(skipImg)
  local grayImg = img.createUISprite(img.ui.solo_battle_btn_gray)
  grayImg:setPositionX(battleBtn:getContentSize().width / 2)
  grayImg:setPositionY(battleBtn:getContentSize().height / 2)
  grayImg:setVisible(false)
  battleImg:addChild(grayImg)
  battleBtn.state = "fight"
  battleBtn.battleImg = battleImg
  battleBtn.redSword = redSword
  battleBtn.blueSword = blueSword
  battleBtn.skipImg = skipImg
  battleBtn.grayImg = grayImg
  return battleBtn
end

ui.setBattleBtnState = function(l_20_0, l_20_1)
  l_20_0.state = l_20_1
  if l_20_1 == "fight" then
    clearShader(l_20_0.battleImg, true)
    l_20_0.redSword:setVisible(true)
    l_20_0.blueSword:setVisible(true)
    l_20_0.skipImg:setVisible(false)
    l_20_0.grayImg:setVisible(false)
  elseif l_20_1 == "auto" then
    clearShader(l_20_0.battleImg, true)
    l_20_0.redSword:setVisible(true)
    l_20_0.blueSword:setVisible(true)
    l_20_0.skipImg:setVisible(false)
    l_20_0.grayImg:setVisible(false)
  elseif l_20_1 == "disable" then
    clearShader(l_20_0.battleImg, SHADER_GRAY, true)
    l_20_0.redSword:setVisible(false)
    l_20_0.blueSword:setVisible(false)
    l_20_0.skipImg:setVisible(false)
    l_20_0.grayImg:setVisible(true)
  elseif l_20_1 == "skip" then
    clearShader(l_20_0.battleImg, true)
    l_20_0.redSword:setVisible(false)
    l_20_0.blueSword:setVisible(false)
    l_20_0.skipImg:setVisible(true)
    l_20_0.grayImg:setVisible(false)
  end
end

ui.createHeroIcon = function(l_21_0)
  local icon = nil
  if l_21_0.wake == 4 then
    icon = img.createUISprite(img.ui.hero_star_ten_bg)
    json.load(json.ui.lv10_framefx)
    local aniten = DHSkeletonAnimation:createWithKey(json.ui.lv10_framefx)
    aniten:playAnimation("animation", -1)
    aniten:scheduleUpdateLua()
    aniten:setPosition(icon:getContentSize().width / 2, icon:getContentSize().height / 2)
    icon:addChild(aniten, 3)
  else
    icon = img.createUISprite(img.ui.herolist_head_bg)
  end
  icon:setCascadeOpacityEnabled(true)
  icon:setScale(0.9)
  local headIcon = nil
  if l_21_0.skin then
    headIcon = CCSprite:createWithSpriteFrameName(string.format("head/%04d.png", cfgequip[l_21_0.skin].heroBody))
  else
    headIcon = img.createHeroHeadIcon(l_21_0.id)
  end
  headIcon:setPosition(CCPoint(icon:getContentSize().width / 2, icon:getContentSize().height / 2))
  icon:addChild(headIcon)
  local groupBg = img.createUISprite(img.ui.herolist_group_bg)
  groupBg:setScale(0.42)
  groupBg:setPosition(CCPoint(18, icon:getContentSize().height - 18))
  icon:addChild(groupBg)
  print("\232\191\155\229\133\165\228\184\128\230\172\161" .. l_21_0.id)
  local groupIcon = img.createUISprite(img.ui.herolist_group_" .. l_21_0.grou)
  print("\233\152\181\229\174\185\228\184\186" .. l_21_0.group)
  groupIcon:setPosition(groupBg:getPosition())
  groupIcon:setScale(0.42)
  icon:addChild(groupIcon)
  local showLv = lbl.createFont2(13.8, l_21_0.lv)
  showLv:setPosition(CCPoint(67, icon:getContentSize().height - 18))
  icon:addChild(showLv)
  local startX = 10
  local offsetX = 10
  local isRed = false
  local totalStarNum = 1
  if l_21_0.qlt <= 5 then
    totalStarNum = l_21_0.qlt
    for i = totalStarNum, 1, -1 do
      local star = img.createUISprite(img.ui.star_s)
      star:setPositionX((i - (totalStarNum + 1) / 2) * 12 * 0.8 + icon:getContentSize().width / 2)
      star:setPositionY(12)
      icon:addChild(star)
    end
  else
    isRed = true
    if l_21_0.wake then
      totalStarNum = l_21_0.wake + 1
      if totalStarNum >= 6 then
        json.load(json.ui.lv10plus_hero)
        local star = DHSkeletonAnimation:createWithKey(json.ui.lv10plus_hero)
        star:scheduleUpdateLua()
        star:playAnimation("animation", -1)
        star:setPosition(icon:getContentSize().width / 2, 14)
        icon:addChild(star)
        local energizeStarLab = lbl.createFont2(26, totalStarNum - 5)
        energizeStarLab:setPosition(star:getContentSize().width / 2, 0)
        star:addChild(energizeStarLab)
        star:setScale(0.53)
      elseif totalStarNum >= 5 then
        local starIcon2 = img.createUISprite(img.ui.hero_star_ten)
        starIcon2:setPosition(icon:getContentSize().width / 2, 12)
        icon:addChild(starIcon2)
      else
        for i = totalStarNum, 1, -1 do
          local star = img.createUISprite(img.ui.hero_star_orange)
          star:setScale(0.75)
          star:setPositionX((i - (totalStarNum + 1) / 2) * 12 * 0.8 + icon:getContentSize().width / 2)
          star:setPositionY(12)
          icon:addChild(star)
        end
      end
    else
      local star = img.createUISprite(img.ui.hero_star_orange)
      star:setScale(0.75)
      star:setPositionX(icon:getContentSize().width / 2)
      star:setPositionY(12)
      icon:addChild(star)
    end
  end
end
local hpBar = ui.createStateBar("hp", "small", l_21_0.hp)
hpBar:setPosition(icon:getContentSize().width / 2, -4)
hpBar:setScale(1.1111111111111)
icon:addChild(hpBar)
local mpBar = ui.createStateBar("mp", "small", l_21_0.mp)
mpBar:setPosition(icon:getContentSize().width / 2, hpBar:getPositionY() - 10)
mpBar:setScale(1.1111111111111)
icon:addChild(mpBar)
local maskLayer = CCLayer:create()
maskLayer:setCascadeOpacityEnabled(true)
maskLayer:setContentSize(icon:getContentSize())
maskLayer:setPosition(ccp(0, 0))
maskLayer:setVisible(false)
icon:addChild(maskLayer)
local headMask = img.createUISprite(img.ui.hero_head_shade)
headMask:setOpacity(125)
headMask:setPosition(ccp(maskLayer:getContentSize().width / 2, maskLayer:getContentSize().height / 2))
maskLayer:addChild(headMask)
local hpMask = img.createUISprite(img.ui.solo_hp_mask)
hpMask:setOpacity(125)
hpMask:setScale(1.1111111111111)
hpMask:setPosition(ccp(maskLayer:getContentSize().width / 2, -8))
maskLayer:addChild(hpMask)
local tickImg = img.createUISprite(img.ui.hook_btn_sel)
tickImg:setPosition(headIcon:getPosition())
tickImg:setVisible(false)
icon:addChild(tickImg)
icon.state = l_21_0.hp > 0 and "normal" or "disable"
icon.hpBar = hpBar
icon.mpBar = mpBar
icon.maskLayer = maskLayer
icon.tickImg = tickImg
if l_21_0.hp <= 0 then
  ui.beGray(icon)
  clearShader(icon.hpBar)
  clearShader(icon.mpBar)
end
return icon
end

ui.beGray = function(l_22_0)
  setShader(l_22_0, SHADER_GRAY, true)
end

ui.beDark = function(l_23_0)
  l_23_0.maskLayer:setVisible(true)
  l_23_0.tickImg:setVisible(true)
end

ui.beNormal = function(l_24_0)
  clearShader(l_24_0, true)
  l_24_0.maskLayer:setVisible(false)
  l_24_0.tickImg:setVisible(false)
end

ui.playBuffBarAnimation = function(l_25_0, l_25_1, l_25_2)
  if (l_25_1 > 1 and 1) or not l_25_2 then
    l_25_2 = 0.5
  end
  local percent = l_25_0:getPercentage()
  local actionTimes = l_25_2 / 0.01
  local deltaPercent = (l_25_1 * 100 - percent) / actionTimes
  local delay = CCDelayTime:create(0.01)
  local callfunc = CCCallFunc:create(function()
    percent = percent + deltaPercent
    buffBar:setPercentage(percent)
   end)
  local sequence = CCSequence:createWithTwoActions(callfunc, delay)
  l_25_0:stopAllActions()
  l_25_0:runAction(CCRepeat:create(sequence, actionTimes))
end

ui.playBuffLabelAnimation = function(l_26_0, l_26_1, l_26_2, l_26_3, l_26_4)
  if l_26_1 < l_26_3 or l_26_2 == l_26_3 then
    return 
  end
  if not l_26_4 then
    l_26_4 = 0.5
  end
  local oldData = l_26_2
  local delta = l_26_3 - l_26_2 > 0 and l_26_3 - l_26_2 or 1
  local deltaTime = l_26_4 / delta
  local delay = CCDelayTime:create(deltaTime)
  local callfunc = CCCallFunc:create(function()
    oldData = oldData + 1
    buffLabel:setString(oldData .. "/" .. maxNum)
    print("\230\160\135\231\173\190\229\173\151\231\172\166:" .. oldData .. "/" .. maxNum)
   end)
  local arr = CCArray:create()
  arr:addObject(callfunc)
  arr:addObject(delay)
  local sequence = CCSequence:create(arr)
  l_26_0:stopAllActions()
  l_26_0:runAction(CCRepeat:create(sequence, delta))
  print("\229\190\170\231\142\175\230\172\161\230\149\176\228\184\186\239\188\154" .. delta)
end

ui.selectHero = function(l_27_0)
  if soloData.heroList[l_27_0].hp <= 0 then
    if ui.isAllDie then
      do return end
    end
    return 
  end
  if ui.isAllDie then
    soloData.setSelectOrder(l_27_0)
    for i,v in ipairs(ui.widget.heroIcons) do
      v.maskLayer:setVisible(false)
      v.tickImg:setVisible(false)
    end
    ui.widget.heroIcons[l_27_0].tickImg:setVisible(true)
    ui.changeBuffBarState(ui.widget.speedBuffBar, soloData.heroList[soloData.getSelectOrder()])
    ui.changeBuffBarState(ui.widget.powerBuffBar, soloData.heroList[soloData.getSelectOrder()])
    ui.changeBuffBarState(ui.widget.critBuffBar, soloData.heroList[soloData.getSelectOrder()])
  else
    if soloData.heroList[l_27_0].hp <= 0 then
      return 
    end
    soloData.setSelectOrder(l_27_0)
    for i,v in ipairs(ui.widget.heroIcons) do
      v.maskLayer:setVisible(false)
      v.tickImg:setVisible(false)
    end
    ui.widget.heroIcons[l_27_0].maskLayer:setVisible(true)
    ui.widget.heroIcons[l_27_0].tickImg:setVisible(true)
    ui.changeBuffBarState(ui.widget.speedBuffBar, soloData.heroList[soloData.getSelectOrder()])
    ui.changeBuffBarState(ui.widget.powerBuffBar, soloData.heroList[soloData.getSelectOrder()])
    ui.changeBuffBarState(ui.widget.critBuffBar, soloData.heroList[soloData.getSelectOrder()])
    ui.showHeroSpine(l_27_0)
  end
end

ui.onTouch = function(l_28_0, l_28_1, l_28_2)
  if l_28_0 == "began" then
    return ui.onTouchBegan(l_28_1, l_28_2)
  elseif l_28_0 == "moved" then
    do return end
  end
  return ui.onTouchEnded(l_28_1, l_28_2)
end

ui.onTouchBegan = function(l_29_0, l_29_1)
  print("\231\130\185\229\135\187\229\157\144\230\160\135" .. l_29_0 .. "," .. l_29_1)
  for i,v in ipairs(ui.widget.heroIcons) do
    local point = v:getParent():convertToNodeSpace(ccp(l_29_0, l_29_1))
    local rect = v:boundingBox()
    if (ui.isAllDie or v.state ~= "disable") and rect:containsPoint(point) then
      print("\230\136\145\231\130\185\228\184\173\228\186\134\231\172\172" .. i .. "\228\184\170")
      ui.data.lastSelected = i
      return true
    end
  end
  return false
end

ui.onTouchEnded = function(l_30_0, l_30_1)
  if ui.data.lastSelected == 0 then
    return 
  end
  local icon = ui.widget.heroIcons[ui.data.lastSelected]
  local point = icon:getParent():convertToNodeSpace(ccp(l_30_0, l_30_1))
  local rect = icon:boundingBox()
  if rect:containsPoint(point) then
    print("\230\136\145\229\143\150\230\182\136\228\186\134\231\172\172" .. ui.data.lastSelected .. "\228\184\170")
    if soloData.getSelectOrder() ~= ui.data.lastSelected then
      ui.selectHero(ui.data.lastSelected)
    end
  end
end

ui.showHeroSpine = function(l_31_0)
  ui.widget.spineNode:removeChildFollowSlot("code_hero")
  local heroInfo = soloData.heroList[l_31_0]
  if heroInfo.skin then
    ui.widget.heroSpine = json.createSpineHeroSkin(heroInfo.skin)
  else
    ui.widget.heroSpine = json.createSpineHero(heroInfo.id)
  end
  ui.widget.heroSpine:setScale(0.65)
  ui.widget.spineNode:addChildFollowSlot("code_hero", ui.widget.heroSpine)
  ui.widget.heroNameLabel:setString(i18n.hero[heroInfo.id].heroName)
  ui.widget.heroNameLabel:setVisible(true)
  print("\232\191\153\228\184\170\231\167\141\230\151\143\231\154\132\233\152\181\232\144\165\230\152\175" .. heroInfo.group)
  local oldImg = ui.widget.heroGroupImg
  ui.widget.heroGroupImg = img.createGroupIcon(heroInfo.group)
  ui.widget.heroGroupImg:setPosition(oldImg:getPosition())
  ui.widget.heroGroupImg:setScale(oldImg:getScale())
  ui.widget.heroGroupImg:setVisible(true)
  ui.widget.spineNode:removeChildFollowSlot("code_circle")
  ui.widget.spineNode:addChildFollowSlot("code_circle", ui.widget.heroGroupImg)
  ui.setStateBar(ui.widget.heroHpBar, heroInfo.hp / 100)
  ui.widget.heroHpBar:setVisible(true)
  ui.setStateBar(ui.widget.heroMpBar, heroInfo.mp / 100)
  ui.widget.heroMpBar:setVisible(true)
end

ui.showBossSpine = function(l_32_0)
  ui.widget.spineNode:removeChildFollowSlot("code_boss")
  ui.widget.bossSpine = json.createSpineMons(l_32_0)
  ui.widget.bossSpine:setScale(0.65)
  ui.widget.spineNode:addChildFollowSlot("code_boss", ui.widget.bossSpine)
  ui.widget.spineNode:playAnimation("boss_birth")
  ui.createSwallowLayer(1)
end

ui.showTraderSpine = function(l_33_0)
  ui.widget.spineNode:removeChildFollowSlot("code_trader")
  ui.widget.traderSpine = json.create(json.ui.trader" .. l_33_)
  ui.widget.spineNode:addChildFollowSlot("code_trader", ui.widget.traderSpine)
  ui.widget.spineNode:playAnimation("trader_birth")
  ui.widget.spineNode:registerLuaHandler(function(l_1_0)
    if l_1_0 == "trader_birth" then
      print("\229\149\134\228\186\186\232\191\155\229\133\165\231\187\147\230\157\159")
      ui.widget.traderSpine:playAnimation("stand", -1)
    end
   end)
  ui.createSwallowLayer(0.83333333333333)
end

ui.showPotionSpine = function(l_34_0)
  print("---------\232\191\155\229\133\165\229\135\189\230\149\176 showPotionSpine")
  ui.widget.spineNode:removeChildFollowSlot("code_drug")
  local drugStr = {power = "solo_power_potion", speed = "solo_speed_potion", crit = "solo_crit_potion", milk = "solo_milk", angel = "solo_angel_potion", evil = "solo_evil_potion"}
  ui.widget.drugImg = img.createUISprite(img.ui[drugStr[l_34_0]])
  ui.widget.drugImg.id = l_34_0
  ui.widget.spineNode:addChildFollowSlot("code_drug", ui.widget.drugImg)
  ui.widget.spineNode:playAnimation("drug_birth")
  ui.widget.spineNode:registerLuaHandler(function(l_1_0)
    if l_1_0 == "drug_birth" then
      if id == "power" or id == "speed" or id == "crit" then
        local delay = CCDelayTime:create(0.1)
        local callfunc = CCCallFunc:create(function()
          ui.usePotion()
            end)
        ui.widget.spineNode:runAction(CCSequence:createWithTwoActions(delay, callfunc))
      else
        local delay = CCDelayTime:create(0.1)
        local callfunc = CCCallFunc:create(function()
          ui.savePotion()
            end)
        ui.widget.spineNode:runAction(CCSequence:createWithTwoActions(delay, callfunc))
      end
    end
   end)
  ui.createSwallowLayer(1.5)
end

ui.showRewardSpine = function()
  print("\232\176\131\231\148\168\228\184\128\230\172\161\229\165\150\229\138\177\233\170\168\233\170\188")
  ui.widget.spineNode:removeChildFollowSlot("code_treasure")
  ui.widget.spineNode:registerAnimation("treasure_birth")
  ui.widget.spineNode:registerLuaHandler(function(l_1_0)
    if l_1_0 == "treasure_birth" then
      ui.showRewardUI()
    end
   end)
  ui.createSwallowLayer(2)
end

ui.endBossSpine = function(l_36_0)
  if ui.widget.bossSpine ~= nil then
    ui.widget.spineNode:playAnimation("boss_die")
    ui.widget.spineNode:registerLuaHandler(function(l_1_0)
      if l_1_0 == "boss_die" then
        ui.refreshUI(data)
      end
      end)
    ui.createSwallowLayer(0.66666666666667)
  end
end

ui.endTraderSpine = function()
  if ui.widget.traderSpine ~= nil then
    ui.widget.traderSpine:playAnimation("jump")
    ui.widget.spineNode:registerAnimation("trader_die")
    ui.widget.spineNode:registerLuaHandler(function(l_1_0)
      if l_1_0 == "trader_die" then
        ui.refreshBoss()
      end
      end)
    ui.createSwallowLayer(1.3333333333333)
  end
end

ui.endPotionSpine = function()
  print("------\232\191\155\229\133\165\229\135\189\230\149\176 endPotionSpine")
  print(soloData.getBufType())
  if soloData.getBuf() then
    local drugStr = {speed = "1speed_click", power = "2power_click", crit = "3cc_click", milk = "4milk_click2", evil = "5demon_click2", angel = "6angel_click2"}
    do
      local drugSpine = {speed = ui.widget.speedBuffBar.drugSpine, power = ui.widget.powerBuffBar.drugSpine, crit = ui.widget.critBuffBar.drugSpine}
      if soloData.getBufType() == "milk" or soloData.getBufType() == "evil" or soloData.getBufType() == "angel" then
        ui.widget.spineNode:registerAnimation(drugStr[soloData.getBufType()])
      else
        ui.widget.spineNode:playAnimation(drugStr[soloData.getBufType()])
        drugSpine[soloData.getBufType()]:playAnimation(drugStr[soloData.getBufType()])
        ui.widget.spineNode:registerLuaHandler(function(l_1_0)
          if l_1_0 == drugStr[soloData.getBufType()] then
            print("\231\187\147\230\157\159\232\141\175\230\176\180\229\138\168\231\148\187")
            ui.refreshBoss()
          end
            end)
      end
      ui.createSwallowLayer(1.6666666666667)
    end
  end
end

ui.savePotionSpine = function()
  print("---------\232\191\155\229\133\165\229\135\189\230\149\176 savePotionSpine")
  print(soloData.getBufType())
  if soloData.getBuf() then
    local drugStr = {milk = "4milk_click", evil = "5demon_click", angel = "6angel_click"}
    do
      ui.widget.spineNode:stopAnimation()
      ui.widget.spineNode:playAnimation(drugStr[soloData.getBufType()])
      ui.widget.sideSpine:registerAnimation(drugStr[soloData.getBufType()])
      ui.widget.spineNode:registerLuaHandler(function(l_1_0)
        if l_1_0 == drugStr[soloData.getBufType()] then
          print("\228\191\157\229\173\152\232\141\175\230\176\180\229\138\168\231\148\187")
          ui.refreshBoss()
        end
         end)
      ui.createSwallowLayer(1.6666666666667)
    end
  end
end

ui.createSwallowLayer = function(l_40_0, l_40_1)
  if not l_40_0 then
    l_40_0 = 0.5
  end
  if not l_40_1 then
    l_40_1 = 999
  end
  local swallowLayer = CCLayer:create()
  swallowLayer:setTouchEnabled(true)
  ui.widget.layer:addChild(swallowLayer, l_40_1)
  local delayTime = CCDelayTime:create(l_40_0)
  local callfunc = CCCallFunc:create(function()
    if swallowLayer ~= nil then
      swallowLayer:removeFromParent()
      swallowLayer = nil
    end
   end)
  local arr = CCArray:create()
  arr:addObject(delayTime)
  arr:addObject(callfunc)
  swallowLayer:runAction(CCSequence:create(arr))
end

ui.usePotion = function()
  print("------\232\191\155\229\133\165\229\135\189\230\149\176 usePotion")
  local potionStr = {milk = {hp = 25, mp = 0}, angel = {hp = 100, mp = 0}, evil = {hp = 50, mp = 100}}
  do
    local bufStr = {speed = ui.widget.speedBuffBar, power = ui.widget.powerBuffBar, crit = ui.widget.critBuffBar}
    if potionStr[soloData.getBufType()] then
      local addHp, addMp = 0, 0
      do
        for i,v in ipairs(cfgDrug[soloData.getBuf()].effect) do
          if v.type == "healP" then
            addHp = v.num * 100
            for i,v in (for generator) do
            end
            if v.type == "energy" then
              addMp = v.num * 100
            end
          end
          local hp, mp = soloData.heroList[soloData.getSelectOrder()].hp, soloData.heroList[soloData.getSelectOrder()].mp
          if hp + addHp <= 100 or not 100 then
            soloData.heroList[soloData.getSelectOrder()].hp = hp + addHp
          end
          if mp + addMp <= 100 or not 100 then
            soloData.heroList[soloData.getSelectOrder()].mp = mp + addMp
          end
          local delay = CCDelayTime:create(0.4)
          local callfunc = CCCallFunc:create(function()
          ui.changeStateBar(ui.widget.heroHpBar, soloData.heroList[soloData.getSelectOrder()].hp / 100)
          ui.changeStateBar(ui.widget.heroMpBar, soloData.heroList[soloData.getSelectOrder()].mp / 100)
          ui.changeStateBar(ui.widget.heroIcons[soloData.getSelectOrder()].hpBar, soloData.heroList[soloData.getSelectOrder()].hp / 100)
          ui.changeStateBar(ui.widget.heroIcons[soloData.getSelectOrder()].mpBar, soloData.heroList[soloData.getSelectOrder()].mp / 100)
            end)
          ui.widget.layer:runAction(CCSequence:createWithTwoActions(delay, callfunc))
        end
      else
        if bufStr[soloData.getBufType()] then
          local oldBufData = soloData.heroList[soloData.getSelectOrder()][soloData.getBufType()]
          if oldBufData + 1 <= 20 or not 20 then
            local newBufData = oldBufData + 1
          end
          soloData.addPotion(soloData.getBuf())
          local delay = CCDelayTime:create(0.4)
          local callfunc = CCCallFunc:create(function()
          ui.playBuffBarAnimation(bufStr[soloData.getBufType()].progressBar, newBufData / 20)
          ui.playBuffLabelAnimation(bufStr[soloData.getBufType()].progressLabel, 20, oldBufData, newBufData)
            end)
          ui.widget.layer:runAction(CCSequence:createWithTwoActions(delay, callfunc))
        end
      end
      ui.endPotionSpine()
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.savePotion = function()
  print("------\232\191\155\229\133\165\229\135\189\230\149\176 savePotion")
  local potionStr = {milk = {hp = 20, mp = 0}, angel = {hp = 100, mp = 0}, evil = {hp = 50, mp = 300}}
  local label = {milk = ui.widget.milkLabel, angel = ui.widget.angelLabel, evil = ui.widget.evilLabel}
  if soloData.getBufType() == "milk" or soloData.getBufType() == "angel" or soloData.getBufType() == "evil" then
    table.insert(soloData[soloData.getBufType()], soloData.getBuf())
    label[soloData.getBufType()]:setString(#soloData[soloData.getBufType()])
    ui.savePotionSpine()
  end
end

ui.showBossList = function()
  local listView = require("ui.solo.monsListUI").create(soloData.bossList)
  ui.widget.layer:addChild(listView, 99999)
end

ui.showBuyUI = function()
  if ui == nil then
    print("ui\229\128\188\230\152\175\231\169\186\231\154\132")
  end
  local itemType = cfgTrader[soloData.getTrader()].yes[1].type
  local itemID = cfgTrader[soloData.getTrader()].yes[1].id
  local itemNum = cfgTrader[soloData.getTrader()].yes[1].num
  local cost = cfgTrader[soloData.getTrader()].cost
  local gold = cfgTrader[soloData.getTrader()].gold
  local params = {goodsType = itemType, id = itemID, num = itemNum, gem = cost}
  local shopUI = require("ui.solo.shopUI").create({goodsType = itemType, id = itemID, num = itemNum, gem = cost, coin = gold}, ui)
  ui.widget.layer:addChild(shopUI, 99999)
end

ui.showDrugUI = function()
  local hid = soloData.heroList[soloData.getSelectOrder()].hid
  local drugUI = require("ui.solo.useDrugUI").create(soloData.getBufType(), soloData.getBuf(), ui, hid)
  ui.widget.layer:addChild(drugUI, 99999)
end

ui.showRewardUI = function()
  local reward = (soloData.getReward())
  local rewardID, rewardNum, rewardType = nil, nil, nil
  if reward.items then
    print("HAVE ITEM")
    rewardType = 1
    rewardID = reward.items[1].id
    rewardNum = reward.items[1].num
  else
    rewardType = 2
    rewardID = reward.equips[1].id
    rewardNum = reward.equips[1].num
  end
  print("\229\165\150\229\138\177\228\184\186\239\188\154")
  tablePrint(reward)
  local rewardUI = require("ui.solo.rewardUI").create({id = rewardID, num = rewardNum, goodsType = rewardType}, ui)
  ui.widget.layer:addChild(rewardUI, 99999)
end

ui.refreshFightData = function(l_47_0)
  print("\229\136\183\230\150\176\230\136\152\230\150\151\229\144\142\231\154\132\230\149\176\230\141\174")
  tablePrint(l_47_0)
  if l_47_0.win then
    print("\232\131\156\229\136\169")
    if l_47_0.mhpp then
      soloData.heroList[soloData.getSelectOrder()].hp = l_47_0.mhpp
    end
    if l_47_0.menergy then
      soloData.heroList[soloData.getSelectOrder()].mp = l_47_0.menergy
    end
    if l_47_0.reward then
      print("\230\156\137\229\165\150\229\138\177")
      soloData.setReward(l_47_0.reward)
      soloData.setStage(l_47_0.nstage)
      print("\230\150\176\231\154\132\230\179\162\230\172\161" .. soloData.getStage())
      soloData.setTrader(nil)
      soloData.setBuf(nil)
    elseif l_47_0.buf then
      print("\230\156\137\232\141\175\230\176\180" .. l_47_0.buf)
      soloData.setStage(l_47_0.nstage)
      soloData.setBuf(l_47_0.buf)
      soloData.setReward(nil)
      soloData.setTrader(nil)
    elseif l_47_0.seller then
      print("\230\156\137\229\149\134\228\186\186" .. l_47_0.seller)
      soloData.setWave(soloData.getWave() + 1)
      soloData.setTrader(l_47_0.seller)
      soloData.setReward(nil)
      soloData.setBuf(nil)
    elseif l_47_0.menergy then
      soloData.heroList[soloData.getSelectOrder()].mp = l_47_0.menergy
    else
      soloData.heroList[soloData.getSelectOrder()].mp = 0
    end
    if l_47_0.mhpp then
      soloData.heroList[soloData.getSelectOrder()].hp = l_47_0.mhpp
    else
      soloData.heroList[soloData.getSelectOrder()].hp = 0
      soloData.setSelectOrder(nil)
    end
    if l_47_0.ehpp == nil then
      l_47_0.ehpp = {}
      for i,v in ipairs(soloData.bossList) do
        table.insert(l_47_0.ehpp, 0)
      end
    end
    for i,v in ipairs(l_47_0.ehpp) do
      if i > 4 then
        return 
      end
      print("bossHP" .. v)
      soloData.bossList[i].hp = v
    end
  end
end

ui.getTimeString = function(l_48_0)
  local h = math.floor(l_48_0 / 60 / 60)
  local m = math.floor(l_48_0 / 60 % 60)
  local s = l_48_0 - m * 60 - h * 60 * 60
  h = string.format("%02d", h)
  m = string.format("%02d", m)
  s = string.format("%02d", s)
  local timeStr = h .. ":" .. m .. ":" .. s
  return timeStr
end

ui.refreshTime = function()
  if soloData.cd then
    local time = math.max(0, soloData.cd - os.time())
    ui.widget.countDownLabel:setString(ui.getTimeString(time))
    if time == 0 then
      soloData.setStatus(0)
      replaceScene(require("ui.town.main").create())
    end
  end
end

ui.heroAllDie = function()
  ui.isAllDie = true
  local maskLayer = CCLayer:create()
  maskLayer:setTouchEnabled(true)
  ui.widget.layer:addChild(maskLayer, 50)
  ui.setBattleBtnState(ui.widget.battleBtn, "fight")
  if ui.widget.autoBtn.state == "auto" then
    ui.changeAutoBtnState(ui.widget.autoBtn)
  end
  for i,v in ipairs(ui.widget.heroIcons) do
    ui.beGray(v)
    ui.setStateBar(v.hpBar, 0)
    ui.setStateBar(v.mpBar, 0)
    clearShader(v.hpBar, true)
    clearShader(v.mpBar, true)
  end
  ui.beGray(ui.widget.battleBtn)
  ui.beGray(ui.widget.autoBtn)
  ui.widget.spineNode:removeChildFollowSlot("code_hero")
  ui.widget.spineNode:removeChildFollowSlot("code_boss")
  ui.widget.spineNode:removeChildFollowSlot("code_trader")
  ui.widget.spineNode:removeChildFollowSlot("code_drug")
  ui.widget.spineNode:unregisterAllAnimation()
  ui.widget.spineNode:playAnimation("start")
  ui.widget.sideSpine:playAnimation("start")
  ui.widget.upSpine:playAnimation("start")
  ui.widget.downSpine:playAnimation("start")
  ui.widget.heroNameLabel:setVisible(false)
  ui.widget.heroGroupImg:setVisible(false)
  ui.widget.heroHpBar:setVisible(false)
  ui.widget.heroMpBar:setVisible(false)
  ui.widget.touchLayer:setLocalZOrder(60)
  soloData.setSelectOrder(nil)
end

ui.clearStage = function()
  local maxWave = ui.data.maxClearNum
  if (soloData.getWave() == nil or soloData.getWave() <= ui.data.overNum) and (soloData.status ~= 2 or soloData.trader) then
    return false
  end
  local maskLayer = CCLayer:create()
  maskLayer:setTouchEnabled(true)
  ui.widget.layer:addChild(maskLayer, 50)
  ui.widget.spineNode:removeChildFollowSlot("code_boss")
  ui.widget.spineNode:removeChildFollowSlot("code_trader")
  ui.widget.spineNode:removeChildFollowSlot("code_drug")
  ui.widget.spineNode:removeChildFollowSlot("code_treasure")
  ui.widget.battleBtn:setVisible(false)
  ui.widget.victoryImg = img.createUISprite(img.ui.solo_victory)
  ui.widget.spineNode:addChild(ui.widget.victoryImg)
  ui.widget.victoryImg:setPositionY(70)
  ui.widget.waveLabel:setString(i18n.global.solo_stage" .. math.floor((ui.data.overNum - 1) / 100.string .. ":" .. maxWave)
  ui.widget.victoryLabel = lbl.createFont2(16, i18n.global.solo_victory.string, lbl.whiteColor)
  ui.widget.victoryLabel:setPositionY(15)
  ui.widget.spineNode:addChild(ui.widget.victoryLabel)
  return true
end

ui.storageReward = function(l_52_0)
  if l_52_0 == nil then
    return 
  end
  local pb = {}
  if l_52_0.items then
    pb.id = l_52_0.items[1].id
    pb.num = l_52_0.items[1].num
    bag.items.add(pb)
  elseif l_52_0.equips then
    pb.id = l_52_0.equips[1].id
    pb.num = l_52_0.equips[1].num
    bag.equips.add(pb)
  end
end

ui.addDrugTipUI = function(l_53_0)
  if #soloData[l_53_0] > 0 then
    print("\228\189\191\231\148\168\228\191\157\229\173\152\231\154\132\232\141\175\229\137\130")
    local drugText = {milk = i18n.global.solo_useMilk.string, angel = i18n.global.solo_useAngel.string, evil = i18n.global.solo_useEvil.string}
    do
      local drugLabel = {milk = ui.widget.milkLabel, angel = ui.widget.angelLabel, evil = ui.widget.evilLabel}
      local dialog = require("ui.dialog")
      local tag = 1000
      local body_text = drugText[l_53_0]
      local process_dialog = function(l_1_0)
        if l_1_0.selected_btn == 1 then
          do return end
        end
        if l_1_0.selected_btn == 2 then
          local label = {milk = ui.widget.milkLabel, angel = ui.widget.angelLabel, evil = ui.widget.evilLabel}
          do
            local heroHid = soloData.heroList[soloData.getSelectOrder()].hid
            local drugId = soloData[drugType][1]
            local params = {sid = player.sid, buf = drugId, hid = heroHid}
            print("\228\189\191\231\148\168\231\154\132\229\142\134\229\143\178\232\141\175\230\176\180")
            tablePrint(params)
            net:spk_buf(params, function(l_1_0)
              delWaitNet()
              print("\232\141\175\230\176\180\232\191\148\229\155\158\230\149\176\230\141\174")
              tablePrint(l_1_0)
              if l_1_0.status == 0 then
                local drug = soloData.getBuf()
                soloData.setBuf(drugId)
                ui.usePotion()
                soloData.setBuf(nil)
                if drug ~= nil then
                  soloData.setBuf(drug)
                end
                table.remove(soloData[drugType], 1)
                drugLabel[drugType]:setString(#soloData[drugType])
              end
                  end)
          end
        end
        ui.widget.layer:removeChildByTag(tag)
         end
      local params = {title = "", body = body_text, btn_count = 2, btn_color = {1 = dialog.COLOR_GOLD, 2 = dialog.COLOR_GOLD}, btn_text = {1 = i18n.global.board_confirm_no.string, 2 = i18n.global.board_confirm_yes.string}, callback = process_dialog}
      local tipDialog = dialog.create(params, true)
      tipDialog:setAnchorPoint(CCPoint(0, 0))
      tipDialog:setPosition(CCPoint(0, 0))
      ui.widget.layer:addChild(tipDialog, 999, tag)
    end
  end
end

ui.modifyBufShow = function()
  local property = {}
  property.power = 0
  property.speed = 0
  property.crit = 0
  ui.widget.milkLabel:setString(0)
  ui.widget.angelLabel:setString(0)
  ui.widget.evilLabel:setString(0)
  ui.changeBuffBarState(ui.widget.speedBuffBar, property)
  ui.changeBuffBarState(ui.widget.powerBuffBar, property)
  ui.changeBuffBarState(ui.widget.critBuffBar, property)
end

ui.playSweepAnimation = function()
  ui.widget.milkLabel:setString(#soloData.milk)
  ui.widget.angelLabel:setString(#soloData.angel)
  ui.widget.evilLabel:setString(#soloData.evil)
  bufStr = {speed = ui.widget.speedBuffBar, power = ui.widget.powerBuffBar, crit = ui.widget.critBuffBar}
  local delay = CCDelayTime:create(0.4)
  local callfunc = CCCallFunc:create(function()
    print("-------speed" .. soloData.speed)
    print("-------power" .. soloData.power)
    print("-------crit" .. soloData.crit)
    ui.playBuffBarAnimation(bufStr.speed.progressBar, soloData.speed / 20)
    ui.playBuffLabelAnimation(bufStr.speed.progressLabel, 20, 0, soloData.speed)
    ui.playBuffBarAnimation(bufStr.power.progressBar, soloData.power / 20)
    ui.playBuffLabelAnimation(bufStr.power.progressLabel, 20, 0, soloData.power)
    ui.playBuffBarAnimation(bufStr.crit.progressBar, soloData.crit / 20)
    ui.playBuffLabelAnimation(bufStr.crit.progressLabel, 20, 0, soloData.crit)
   end)
  ui.widget.layer:runAction(CCSequence:createWithTwoActions(delay, callfunc))
  local angelLight = json.create(json.ui.solo_lightA)
  local evilLight = json.create(json.ui.solo_lightA)
  local milkLight = json.create(json.ui.solo_lightA)
  local speedLight = json.create(json.ui.solo_lightB)
  local powerLight = json.create(json.ui.solo_lightB)
  local critLight = json.create(json.ui.solo_lightB)
  angelLight:setPosition(ccp(-438, 107))
  evilLight:setPosition(ccp(-438, 35))
  milkLight:setPosition(ccp(-438, -37))
  speedLight:setPosition(ccp(-450, -180))
  powerLight:setPosition(ccp(-450, -220))
  critLight:setPosition(ccp(-450, -260))
  ui.widget.spineNode:addChild(angelLight, 99999999)
  ui.widget.spineNode:addChild(evilLight, 99999999)
  ui.widget.spineNode:addChild(milkLight, 99999999)
  ui.widget.spineNode:addChild(speedLight, 99999999)
  ui.widget.spineNode:addChild(powerLight, 99999999)
  ui.widget.spineNode:addChild(critLight, 99999999)
  if soloData.angel and #soloData.angel > 0 then
    angelLight:playAnimation("animation")
  end
  if soloData.evil and #soloData.evil > 0 then
    evilLight:playAnimation("animation")
  end
  if soloData.milk and #soloData.milk > 0 then
    milkLight:playAnimation("animation")
  end
  if soloData.speed and soloData.speed > 0 then
    speedLight:playAnimation("animation")
  end
  if soloData.power and soloData.power > 0 then
    powerLight:playAnimation("animation")
  end
  if soloData.crit and soloData.crit > 0 then
    critLight:playAnimation("animation")
  end
  ui.createSwallowLayer(1.6666666666667)
end

ui.setStage = function(l_56_0)
  soloData.setStage(l_56_0)
end

return ui

