-- Command line was: E:\github\dhgametool\scripts\ui\solo\noStartUI.lua 

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
local bag = require("data.bag")
local player = require("data.player")
local soloData = require("data.solo")
ui.create = function()
  ui.widget = {}
  ui.data = {}
  ui.widget.layer = CCLayer:create()
  ui.widget.spineNode = json.create(json.ui.solo)
  ui.widget.spineNode:setScale(view.minScale)
  ui.widget.spineNode:setPosition(view.midX, view.midY)
  ui.widget.layer:addChild(ui.widget.spineNode)
  ui.widget.spineNode:playAnimation("b_start")
  ui.widget.spineNode:registerLuaHandler(function(l_1_0)
    if l_1_0 == "b_start" then
      ui.widget.spineNode:playAnimation("b_loop", -1)
    end
   end)
  ui.widget.upSpine = json.create(json.ui.solo_up)
  ui.widget.upSpine:setScale(view.minScale)
  ui.widget.upSpine:setPosition(view.midX, view.midY)
  ui.widget.layer:addChild(ui.widget.upSpine)
  ui.widget.upSpine:playAnimation("b_start")
  ui.widget.upSpine:appendNextAnimation("b_loop", -1)
  autoLayoutShift(ui.widget.upSpine, true)
  ui.widget.downSpine = json.create(json.ui.solo_down)
  ui.widget.downSpine:setScale(view.minScale)
  ui.widget.downSpine:setPosition(view.midX, view.midY)
  ui.widget.layer:addChild(ui.widget.downSpine)
  ui.widget.downSpine:playAnimation("b_start")
  ui.widget.downSpine:appendNextAnimation("b_loop", -1)
  autoLayoutShift(ui.widget.downSpine, false, true)
  ui.widget.title = lbl.createFont2(24, i18n.global.solo_close.string, ccc3(250, 216, 105))
  ui.widget.upSpine:addChildFollowSlot("code_text", ui.widget.title)
  ui.widget.boardNode = CCNode:create()
  ui.widget.downSpine:addChildFollowSlot("code_x", ui.widget.boardNode)
  ui.widget.clockSpine = json.create(json.ui.clock)
  ui.widget.clockSpine:playAnimation("animation", -1)
  ui.widget.boardNode:addChild(ui.widget.clockSpine)
  ui.widget.countDownLabel = lbl.createFont2(14, ui.getTimeString(math.max(0, soloData.cd)), ccc3(195, 255, 66))
  ui.widget.countDownLabel:setAnchorPoint(ccp(0, 0.5))
  ui.widget.boardNode:addChild(ui.widget.countDownLabel)
  ui.widget.countDownLabel:scheduleUpdateWithPriorityLua(ui.refreshTime, 0)
  ui.widget.startLabel = lbl.createFont2(18, i18n.global.arena3v3_open_cd.string, ccc3(255, 246, 223))
  ui.widget.startLabel:setAnchorPoint(ccp(1, 0.5))
  ui.widget.boardNode:addChild(ui.widget.startLabel)
  local intervalX = 2
  local clockWidth = 29
  local timeWidth = ui.widget.countDownLabel:boundingBox():getMaxX() - ui.widget.countDownLabel:boundingBox():getMinX()
  local startWidth = ui.widget.startLabel:boundingBox():getMaxX() - ui.widget.startLabel:boundingBox():getMinX()
  local totalWidth = clockWidth + timeWidth + startWidth + intervalX * 2
  ui.widget.countDownLabel:setPosition(ccp(totalWidth / 2 - timeWidth, 5))
  ui.widget.startLabel:setPosition(ccp(ui.widget.countDownLabel:getPositionX() - intervalX, 6))
  ui.widget.clockSpine:setPosition(ccp(ui.widget.startLabel:getPositionX() - startWidth - 16, 6))
  print("\230\151\182\233\146\159\233\149\191\229\186\166" .. ui.widget.clockSpine:getContentSize().width)
  print("\230\151\182\233\151\180\230\160\135\231\173\190\233\149\191\229\186\166" .. timeWidth)
  print("\229\188\128\229\167\139\230\160\135\231\173\190\233\149\191\229\186\166" .. startWidth)
  print("\230\128\187\233\149\191\229\186\166" .. totalWidth)
  ui.widget.backBtn = HHMenuItem:create(img.createUISprite(img.ui.back))
  ui.widget.backBtn:setScale(view.minScale)
  ui.widget.backBtn:setPosition(scalep(35, 540))
  local backMenu = CCMenu:createWithItem(ui.widget.backBtn)
  backMenu:setPosition(ccp(0, 0))
  ui.widget.layer:addChild(backMenu, 1000)
  autoLayoutShift(ui.widget.backBtn, true, false, true, false)
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
  ui.btnCallBack()
  return ui.widget.layer
end

ui.btnCallBack = function()
  ui.widget.backBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    replaceScene(require("ui.town.main").create())
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
    local helpUI = require("ui.help").create(i18n.global.solo_help.string)
    ui.widget.layer:addChild(helpUI, 99999)
   end)
  ui.widget.layer.onAndroidBack = function()
    audio.play(audio.button)
    replaceScene(require("ui.town.main").create())
   end
  addBackEvent(ui.widget.layer)
end

ui.getTimeString = function(l_3_0)
  local h = math.floor(l_3_0 / 60 / 60)
  local m = math.floor(l_3_0 / 60 % 60)
  local s = l_3_0 - m * 60 - h * 60 * 60
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
      replaceScene(require("ui.town.main").create())
    end
  end
end

ui.createCountDownLabel = function()
  if ui.data.countTime then
    local label = lbl.createFont2(18, ui.getTimeString(ui.data.countTime), ccc3(195, 255, 66))
    do
      local delay = CCDelayTime:create(1)
      local callfunc = CCCallFunc:create(function()
        if ui.data.countTime <= 0 then
          label:stopAllActions()
          replaceScene(require("ui.town.main").create())
        else
          ui.data.countTime = ui.data.countTime - 1
          label:setString(ui.getTimeString(ui.data.countTime))
        end
         end)
      local arr = CCArray:create()
      arr:addObject(delay)
      arr:addObject(callfunc)
      local sequence = CCSequence:create(arr)
      label:runAction(CCRepeatForever:create(sequence))
      return label
    end
  end
end

return ui

