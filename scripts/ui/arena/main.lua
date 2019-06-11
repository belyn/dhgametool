-- Command line was: E:\github\dhgametool\scripts\ui\arena\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local cfghero = require("config.hero")
local cfgequip = require("config.equip")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local arenaData = require("data.arena")
local databag = require("data.bag")
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  json.load(json.ui.jjc)
  local board = DHSkeletonAnimation:createWithKey(json.ui.jjc)
  board:scheduleUpdateLua()
  board:setPosition(view.midX, view.midY)
  board:setScale(view.minScale)
  board:playAnimation("start")
  board:appendNextAnimation("loop", -1)
  layer:addChild(board)
  local bg1 = CCLayer:create()
  board:addChildFollowSlot("code_bg1", bg1)
  local bg2 = CCLayer:create()
  board:addChildFollowSlot("code_bg2", bg2)
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = SpineMenuItem:create(json.ui.button, btnBackSprite)
  btnBack:setPosition(-5, 528)
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  bg1:addChild(menuBack)
  btnBack:registerScriptTapHandler(function()
    audio.play(audio.button)
    if uiParams and uiParams.from_layer == "task" then
      replaceScene(require("ui.town.main").create({from_layer = "task"}))
    else
      replaceScene(require("ui.town.main").create())
    end
   end)
  local btnInfoSprite = img.createUISprite(img.ui.btn_help)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  btnInfo:setPosition(568, 528)
  local menuInfo = CCMenu:createWithItem(btnInfo)
  menuInfo:setPosition(0, 0)
  bg1:addChild(menuInfo)
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    local str = i18n.arena[1].infoTitle1 .. ":::" .. string.gsub(i18n.arena[1].info1, ";", "|||")
    str = str .. "###" .. i18n.arena[1].infoTitle2 .. ":::" .. string.gsub(i18n.arena[1].info2, ";", "|||")
    layer:addChild(require("ui.help").create(str, i18n.global.help_title.string), 1000)
   end)
  autoLayoutShift(btnBack, true, false, true, false)
  autoLayoutShift(btnInfo, true, false, false, false)
  local showTitle = lbl.createFont3(22, i18n.arena[1].name)
  showTitle:setPosition(270, 458)
  bg1:addChild(showTitle)
  local showLeftTitle = lbl.createFont3(18, i18n.global.arena_remain_title.string, ccc3(255, 205, 51))
  showLeftTitle:setPosition(270, 431)
  bg1:addChild(showLeftTitle)
  local showTime = lbl.createFont2(16, "")
  showTime:setPosition(270, 410)
  bg1:addChild(showTime)
  local btnRewardSprite = img.createUISprite(img.ui.arena_reward_icon)
  local btnReward = SpineMenuItem:create(json.ui.button, btnRewardSprite)
  local menuReward = CCMenu:createWithItem(btnReward)
  btnReward:setPosition(687, 42)
  menuReward:setPosition(0, 0)
  bg2:addChild(menuReward)
  btnReward:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.arena.rewards").create())
   end)
  local showRewardTab = lbl.createFont2(14, i18n.global.arena_main_reward.string)
  showRewardTab:setPosition(btnReward:boundingBox():getMidX(), btnReward:boundingBox():getMinY() + 8)
  bg2:addChild(showRewardTab)
  local btnRecordSprite = img.createUISprite(img.ui.arena_record_icon)
  local btnRecord = SpineMenuItem:create(json.ui.button, btnRecordSprite)
  local menuRecord = CCMenu:createWithItem(btnRecord)
  btnRecord:setPosition(786, 40)
  menuRecord:setPosition(0, 0)
  bg2:addChild(menuRecord)
  btnRecord:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.arena.records").create())
   end)
  local showRecordTab = lbl.createFont2(14, i18n.global.arena_main_record.string)
  showRecordTab:setPosition(btnRecord:boundingBox():getMidX() - 3, btnRecord:boundingBox():getMinY() + 8)
  bg2:addChild(showRecordTab)
  local btnDefenSprite = img.createUISprite(img.ui.arena_defen_icon)
  local btnDefen = SpineMenuItem:create(json.ui.button, btnDefenSprite)
  local menuDefen = CCMenu:createWithItem(btnDefen)
  btnDefen:setPosition(884, 40)
  menuDefen:setPosition(0, 0)
  bg2:addChild(menuDefen)
  btnDefen:registerScriptTapHandler(function()
    disableObjAWhile(btnDefen)
    audio.play(audio.button)
    layer:addChild(require("ui.selecthero.main").create({type = "ArenaDef"}))
   end)
  local showDefenTab = lbl.createFont2(14, i18n.global.arena_main_defen.string)
  showDefenTab:setPosition(btnDefen:boundingBox():getMidX(), btnDefen:boundingBox():getMinY() + 8)
  bg2:addChild(showDefenTab)
  local showHead = img.createPlayerHeadForArena(player.logo, player.lv())
  showHead:setPosition(740, 485)
  bg2:addChild(showHead)
  local powerIcon = img.createUISprite(img.ui.power_icon)
  powerIcon:setScale(0.48)
  powerIcon:setPosition(807, 500)
  bg2:addChild(powerIcon)
  local showPower = lbl.createFont3(22, arenaData.power)
  showPower:setPosition(792, 450)
  showPower:setAnchorPoint(ccp(0, 0))
  bg2:addChild(showPower)
  local titleRank = lbl.createFont2(20, i18n.global.arena_main_rank.string, ccc3(248, 225, 191))
  titleRank:setAnchorPoint(ccp(0, 0))
  titleRank:setPosition(695, 395)
  bg2:addChild(titleRank)
  local titleScore = lbl.createFont2(20, i18n.global.arena_main_score_Big.string, ccc3(248, 225, 191))
  titleScore:setAnchorPoint(ccp(0, 0))
  titleScore:setPosition(695, 360)
  bg2:addChild(titleScore)
  local showRank = lbl.createFont2(20, arenaData.rank)
  showRank:setAnchorPoint(ccp(0, 0))
  showRank:setPosition(titleRank:boundingBox():getMaxX() + 10, 395)
  bg2:addChild(showRank)
  local showScore = lbl.createFont2(20, arenaData.score)
  showScore:setAnchorPoint(ccp(0, 0))
  showScore:setPosition(titleScore:boundingBox():getMaxX() + 10, 360)
  bg2:addChild(showScore)
  local showTicketBg = img.createUI9Sprite(img.ui.arena_ticket_bg)
  showTicketBg:setPreferredSize(CCSize(150, 25))
  showTicketBg:setPosition(788, 315)
  bg2:addChild(showTicketBg)
  local showTicketIcon = img.createItemIcon(ITEM_ID_ARENA)
  showTicketIcon:setScale(0.6)
  showTicketIcon:setPosition(710, 313)
  bg2:addChild(showTicketIcon)
  local showTicket = lbl.createFont2(18, "0")
  showTicket:setPosition(showTicketBg:getContentSize().width / 2, showTicketBg:getContentSize().height / 2)
  showTicketBg:addChild(showTicket)
  local btnAddSprite = img.createUISprite(img.ui.main_icon_plus)
  local btnAdd = SpineMenuItem:create(json.ui.button, btnAddSprite)
  local menuAdd = CCMenu:createWithItem(btnAdd)
  btnAdd:setPosition(858, 315)
  menuAdd:setPosition(0, 0)
  bg2:addChild(menuAdd)
  btnAdd:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.arena.buy").create())
   end)
  local btnBattleSprite = img.createLogin9Sprite(img.login.button_9_gold)
  btnBattleSprite:setPreferredSize(CCSize(190, 72))
  local labBattle = lbl.createFont1(22, i18n.global.arena_main_battle.string, ccc3(115, 59, 5))
  labBattle:setPosition(btnBattleSprite:getContentSize().width / 2, btnBattleSprite:getContentSize().height / 2)
  btnBattleSprite:addChild(labBattle)
  local btnBattle = SpineMenuItem:create(json.ui.button, btnBattleSprite)
  local menuBattle = CCMenu:createWithItem(btnBattle)
  btnBattle:setPosition(787, 230)
  menuBattle:setPosition(0, 0)
  bg2:addChild(menuBattle)
  btnBattle:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.arena.pickRival").create())
   end)
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(0, 2)
  scroll:setViewSize(CCSize(539, 382))
  scroll:setContentSize(CCSize(539, 0))
  bg1:addChild(scroll)
  local loadRank = function(l_8_0)
    local height = 86 * #l_8_0 + 3
    scroll:getContainer():removeAllChildrenWithCleanup(true)
    scroll:setContentSize(CCSize(539, height))
    scroll:setContentOffset(ccp(0, 382 - height))
    local IMG = {img.ui.arena_frame1, img.ui.arena_frame3, img.ui.arena_frame5}
    for i,v in ipairs(l_8_0) do
      do
        local playerBg, showRank, showPowerBg = nil, nil, nil
        if i < 4 then
          playerBg = img.createUI9Sprite(IMG[i])
          showRank = img.createUISprite(img.ui.arena_rank_" .. )
          showPowerBg = img.createUI9Sprite(img.ui.arena_frame" .. i * )
        else
          playerBg = img.createUI9Sprite(img.ui.botton_fram_2)
          showRank = lbl.createFont1(20, i, ccc3(130, 90, 61))
          showPowerBg = img.createUI9Sprite(img.ui.arena_frame7)
        end
        playerBg:setPreferredSize(CCSize(539, 84))
        playerBg:setAnchorPoint(ccp(0, 0))
        playerBg:setPosition(0, height - 86 * i - 3)
        scroll:getContainer():addChild(playerBg)
        showRank:setPosition(44, 43)
        playerBg:addChild(showRank)
        local showHead = img.createPlayerHeadForArena(v.logo, v.lv)
        showHead:setScale(0.7)
        local btnHead = CCMenuItemSprite:create(showHead, nil)
        local menuHead = CCMenu:createWithItem(btnHead)
        menuHead:setPosition(0, 0)
        playerBg:addChild(menuHead)
        btnHead:setPosition(122, 55)
        btnHead:registerScriptTapHandler(function()
          layer:addChild(require("ui.tips.player").create(v), 1000)
            end)
        local showName = lbl.createFontTTF(20, v.name, ccc3(81, 39, 18))
        showName:setAnchorPoint(ccp(0, 0))
        showName:setPosition(160, 48)
        playerBg:addChild(showName)
        showPowerBg:setPreferredSize(CCSize(197, 28))
        showPowerBg:setAnchorPoint(ccp(0, 0))
        showPowerBg:setPosition(160, 15)
        playerBg:addChild(showPowerBg)
        local showPowerIcon = img.createUISprite(img.ui.power_icon)
        showPowerIcon:setScale(0.5)
        showPowerIcon:setPosition(175, 30)
        playerBg:addChild(showPowerIcon)
        local showPower = lbl.createFont2(16, v.power)
        showPower:setAnchorPoint(ccp(0, 0))
        showPower:setPosition(202, 18)
        playerBg:addChild(showPower)
        local titleScore = lbl.createFont1(14, i18n.global.arena_main_score.string, ccc3(154, 106, 82))
        titleScore:setPosition(476, 53)
        playerBg:addChild(titleScore)
        local showScore = lbl.createFont1(22, v.score, ccc3(164, 47, 40))
        showScore:setPosition(476, 34)
        playerBg:addChild(showScore)
      end
    end
   end
  local pullRank = function()
    if not arenaData.members or arenaData.rank <= 50 then
      local params = {sid = player.sid, id = 1}
      addWaitNet()
      net:pvp_rank(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status == -1 then
          if not arenaData.members then
            loadRank({})
        else
          end
          arenaData.members = l_1_0.members
          loadRank(l_1_0.members)
        end
        for i = 1, #arenaData.members do
          if arenaData.members[i].uid == player.uid then
            arenaData.rank = i
            if arenaData.trank and arenaData.rank < arenaData.trank then
              arenaData.trank = arenaData.rank
            end
            arenaData.score = arenaData.members[i].score
          end
        end
        if showRank then
          showRank:setString(arenaData.rank)
        end
        if showScore then
          showScore:setString(arenaData.score)
        end
         end)
    else
      if arenaData.members then
        loadRank(arenaData.members)
      end
    end
   end
  addBackEvent(layer)
  layer.onAndroidBack = function()
    if uiParams and uiParams.from_layer == "task" then
      replaceScene(require("ui.town.main").create({from_layer = "task"}))
    else
      replaceScene(require("ui.town.main").create())
    end
   end
  local onEnter = function()
    pullRank()
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
  layer:scheduleUpdateWithPriorityLua(function()
    local item = databag.items.find(ITEM_ID_ARENA)
    local count = 0
    if item then
      count = item.num
    end
    showTicket:setString(count)
    if arenaData.season_cd - os.time() > 259200 then
      showTime:setString(math.floor((arenaData.season_cd - os.time()) / 86400) .. " " .. i18n.global.arena_time_day.string)
    else
      if arenaData.season_cd - os.time() >= 0 then
        showTime:setString(time2string(arenaData.season_cd - os.time()))
      else
        showTime:setString(time2string(0))
      end
    end
   end)
  return layer
end

return ui

