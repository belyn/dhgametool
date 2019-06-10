-- Command line was: E:\github\dhgametool\scripts\ui\frdarena\main.lua 

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
local frdarena = require("data.frdarena")
local databag = require("data.bag")
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  json.load(json.ui.frd_jjc)
  local board = DHSkeletonAnimation:createWithKey(json.ui.frd_jjc)
  board:scheduleUpdateLua()
  board:setPosition(view.midX, view.midY)
  board:setScale(view.minScale)
  layer:addChild(board)
  local bg1 = CCLayer:create()
  board:addChildFollowSlot("code_bg1", bg1)
  local bg2 = CCLayer:create()
  board:addChildFollowSlot("code_bg2", bg2)
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = SpineMenuItem:create(json.ui.button, btnBackSprite)
  btnBack:setPosition(-136, 546)
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  bg1:addChild(menuBack)
  btnBack:registerScriptTapHandler(function()
    audio.play(audio.button)
    replaceScene(require("ui.town.main").create())
   end)
  local btnInfoSprite = img.createUISprite(img.ui.btn_help)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  btnInfo:setPosition(441, 546)
  local menuInfo = CCMenu:createWithItem(btnInfo)
  menuInfo:setPosition(0, 0)
  bg1:addChild(menuInfo, 1)
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    local str = i18n.arena[4].infoTitle1 .. ":::" .. string.gsub(i18n.arena[4].info1, ";", "|||")
    str = str .. "###" .. i18n.arena[4].infoTitle2 .. ":::" .. string.gsub(i18n.arena[4].info2, ";", "|||")
    layer:addChild(require("ui.help").create(str, i18n.global.help_title.string), 1000)
   end)
  autoLayoutShift(btnBack, true, false, true, false)
  autoLayoutShift(btnInfo, true, false, false, false)
  local showTitle = lbl.createFont3(22, i18n.arena[4].name)
  showTitle:setPosition(138, 478)
  bg1:addChild(showTitle)
  local showLeftTitle = lbl.createFont3(18, i18n.global.arena_remain_title.string, ccc3(255, 205, 51))
  showLeftTitle:setPosition(138, 451)
  bg1:addChild(showLeftTitle)
  local showTime = lbl.createFont2(16, "")
  showTime:setPosition(138, 430)
  bg1:addChild(showTime)
  local createFrdpvp1 = function()
    local bg2layer = CCLayer:create()
    board:playAnimation("start1")
    board:appendNextAnimation("loop1", -1)
    local btnBattleSprite = img.createLogin9Sprite(img.login.button_9_gold)
    btnBattleSprite:setPreferredSize(CCSize(196, 62))
    local labBattle = lbl.createFont1(18, i18n.global.frdpvp_team_lobby.string, ccc3(115, 59, 5))
    labBattle:setPosition(btnBattleSprite:getContentSize().width / 2, btnBattleSprite:getContentSize().height / 2 - 1)
    btnBattleSprite:addChild(labBattle)
    local btnBattle = SpineMenuItem:create(json.ui.button, btnBattleSprite)
    local menuBattle = CCMenu:createWithItem(btnBattle)
    btnBattle:setPosition(787, 198)
    menuBattle:setPosition(0, 0)
    bg2layer:addChild(menuBattle)
    btnBattle:registerScriptTapHandler(function()
      audio.play(audio.button)
      board:playAnimation("click")
      local ban = CCLayer:create()
      ban:setTouchEnabled(true)
      ban:setTouchSwallowEnabled(true)
      layer:addChild(ban, 1000)
      schedule(layer, 1, function()
        if frdarena.team == nil then
          layer:addChild(require("ui.frdarena.teammain").create())
        else
          layer:addChild(require("ui.frdarena.teaminfo").create())
        end
        board:appendNextAnimation("loop1", -1)
        ban:removeFromParent()
         end)
      end)
    bg2layer:scheduleUpdateWithPriorityLua(function()
      if frdarena.team and frdarena.team.reg and frdarena.team.reg == true then
        replaceScene(require("ui.frdarena.main").create())
      end
      end)
    return bg2layer
   end
  local createFrdpvp2 = function()
    local bg2layer = CCLayer:create()
    board:playAnimation("start2")
    board:appendNextAnimation("loop2", -1)
    local teamtitleBg = img.createUISprite(img.ui.friend_pvp_biaotidiban)
    teamtitleBg:setPosition(787, 520)
    bg2layer:addChild(teamtitleBg)
    local showTeamTitle = lbl.createMixFont1(18, frdarena.team.name, ccc3(255, 244, 147))
    showTeamTitle:setPosition(teamtitleBg:getContentSize().width / 2, teamtitleBg:getContentSize().height / 2)
    teamtitleBg:addChild(showTeamTitle, 1)
    local lidIcon = img.createUISprite(img.ui.friend_pvp_maoding)
    lidIcon:setPosition(695, 478)
    bg2layer:addChild(lidIcon)
    local ridIcon = img.createUISprite(img.ui.friend_pvp_maoding)
    ridIcon:setPosition(879, 478)
    bg2layer:addChild(ridIcon)
    local showTeamId = lbl.createFont2(16, string.format("ID %d", frdarena.team.id))
    showTeamId:setPosition(787, 478)
    bg2layer:addChild(showTeamId, 1)
    local teaminfoBg = img.createUI9Sprite(img.ui.friend_pvp_teaminfo)
    teaminfoBg:setPreferredSize(CCSize(252, 200))
    teaminfoBg:setAnchorPoint(0.5, 0)
    teaminfoBg:setPosition(787, 255)
    bg2layer:addChild(teaminfoBg)
    local powerIcon = img.createUISprite(img.ui.power_icon)
    powerIcon:setScale(0.48)
    powerIcon:setAnchorPoint(ccp(0, 0.5))
    powerIcon:setPosition(682, 424)
    bg2layer:addChild(powerIcon)
    local showPower = lbl.createFont2(18, frdarena.team.power)
    showPower:setAnchorPoint(ccp(0, 0.5))
    showPower:setPosition(717, 424)
    bg2layer:addChild(showPower)
    local btn_setting0 = img.createUISprite(img.ui.guild_icon_admin)
    local btn_setting = SpineMenuItem:create(json.ui.button, btn_setting0)
    btn_setting:setPosition(CCPoint(876, 415))
    local btn_setting_menu = CCMenu:createWithItem(btn_setting)
    btn_setting_menu:setPosition(CCPoint(0, 0))
    bg2layer:addChild(btn_setting_menu)
    btn_setting:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer:addChild(require("ui.frdarena.setteamline").create(), 1000)
      end)
    local rankLbl = lbl.createFont1(16, i18n.global.arena_main_rank.string, ccc3(255, 244, 147))
    rankLbl:setAnchorPoint(ccp(0, 0.5))
    rankLbl:setPosition(682, 390)
    bg2layer:addChild(rankLbl)
    local ranknum = lbl.createFont2(16, frdarena.team.rank)
    ranknum:setAnchorPoint(ccp(0, 0.5))
    ranknum:setPosition(rankLbl:boundingBox():getMaxX() + 15, 390)
    bg2layer:addChild(ranknum)
    local scoreLbl = lbl.createFont1(16, i18n.global.arena_main_score_Big.string, ccc3(255, 244, 147))
    scoreLbl:setAnchorPoint(ccp(0, 0.5))
    scoreLbl:setPosition(682, 364)
    bg2layer:addChild(scoreLbl)
    local scorenum = lbl.createFont2(16, frdarena.team.score)
    scorenum:setAnchorPoint(ccp(0, 0.5))
    scorenum:setPosition(scoreLbl:boundingBox():getMaxX() + 15, 364)
    bg2layer:addChild(scorenum)
    local teamIcon = {}
    local showHead = {}
    local callfuncOwner = function()
      for i = 1, 3 do
        if frdarena.team.mbrs[i].uid ~= frdarena.team.leader then
          teamIcon[i]:setVisible(false)
        else
          teamIcon[i]:setVisible(true)
        end
      end
      end
    local dx = nil
    for i = 1, 3 do
      do
        showHead[i] = img.createPlayerHeadForArena(frdarena.team.mbrs[i].logo, frdarena.team.mbrs[i].lv)
        teamIcon[i] = img.createUISprite(img.ui.friend_pvp_captain)
        teamIcon[i]:setAnchorPoint(0, 1)
        teamIcon[i]:setPosition(0, showHead[i]:getContentSize().height)
        showHead[i]:addChild(teamIcon[i])
        if frdarena.team.mbrs[i].uid ~= frdarena.team.leader then
          teamIcon[i]:setVisible(false)
        end
        local headBtn = SpineMenuItem:create(json.ui.button, showHead[i])
        headBtn:setScale(0.8)
        headBtn:setPosition(787 + 74 * (i - 2), 306)
        local headMenu = CCMenu:createWithItem(headBtn)
        headMenu:setPosition(0, 0)
        bg2layer:addChild(headMenu)
        headBtn:registerScriptTapHandler(function()
          audio.play(audio.button)
          if player.uid == frdarena.team.leader then
            if player.uid == frdarena.team.mbrs[i].uid then
              layer:addChild(require("ui.frdarena.mbrinfo").create(frdarena.team.mbrs[i], "none"), 100)
            else
              layer:addChild(require("ui.frdarena.mbrinfo").create(frdarena.team.mbrs[i], "owner", callfuncOwner), 100)
            end
          else
            layer:addChild(require("ui.frdarena.mbrinfo").create(frdarena.team.mbrs[i], "none"), 100)
          end
            end)
      end
    end
    local btnBattleSprite = img.createLogin9Sprite(img.login.button_9_gold)
    btnBattleSprite:setPreferredSize(CCSize(172, 70))
    local labBattle = lbl.createFont1(18, i18n.global.arena_main_battle.string, ccc3(115, 59, 5))
    labBattle:setPosition(btnBattleSprite:getContentSize().width / 2, btnBattleSprite:getContentSize().height / 2 - 1)
    btnBattleSprite:addChild(labBattle)
    local btnBattle = SpineMenuItem:create(json.ui.button, btnBattleSprite)
    local menuBattle = CCMenu:createWithItem(btnBattle)
    btnBattle:setPosition(787, 202)
    menuBattle:setPosition(0, 0)
    bg2layer:addChild(menuBattle)
    btnBattle:registerScriptTapHandler(function()
      audio.play(audio.button)
      if frdarena.team.leader ~= player.uid then
        showToast(i18n.global.frdpvp_permission_denied.string)
        return 
      end
      layer:addChild(require("ui.frdarena.selecfight").create())
      end)
    return bg2layer
   end
  local rightLayer = nil
  if frdarena.team and frdarena.team.reg and frdarena.team.reg == true then
    rightLayer = createFrdpvp2()
  else
    rightLayer = createFrdpvp1()
  end
  bg2:addChild(rightLayer)
  local btnRewardSprite = img.createUISprite(img.ui.arena_reward_icon)
  local btnReward = SpineMenuItem:create(json.ui.button, btnRewardSprite)
  local menuReward = CCMenu:createWithItem(btnReward)
  btnReward:setPosition(687, 42)
  menuReward:setPosition(0, 0)
  bg2:addChild(menuReward)
  btnReward:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.frdarena.rewards").create())
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
    if frdarena.team == nil then
      showToast(i18n.global.frdpvp_team_nosubmit.string)
      return 
    end
    layer:addChild(require("ui.frdarena.records").create())
   end)
  if l_1_0 and l_1_0.video then
    layer:addChild(require("ui.frdarena.records").create(l_1_0.video))
  end
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
    audio.play(audio.button)
    layer:addChild(require("ui.selecthero.main").create({type = "FrdArena"}))
   end)
  local showDefenTab = lbl.createFont2(14, i18n.global.arena_main_defen.string)
  showDefenTab:setPosition(btnDefen:boundingBox():getMidX(), btnDefen:boundingBox():getMinY() + 8)
  bg2:addChild(showDefenTab)
  layer:scheduleUpdateWithPriorityLua(function()
    if frdarena.season_cd - os.time() > 259200 then
      showTime:setString(math.floor((frdarena.season_cd - os.time()) / 86400) .. " " .. i18n.global.arena_time_day.string)
    else
      showTime:setString(time2string(frdarena.season_cd - os.time()))
    end
    if frdarena.season_cd <= os.time() then
      replaceScene(require("ui.town.main").create())
    end
   end)
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(-131, 22)
  scroll:setViewSize(CCSize(539, 382))
  scroll:setContentSize(CCSize(539, 0))
  bg1:addChild(scroll)
  local playerBg = {}
  local loadRank = function(l_9_0)
    local height = 89 * #l_9_0 + 3
    scroll:getContainer():removeAllChildrenWithCleanup(true)
    scroll:setContentSize(CCSize(539, height))
    scroll:setContentOffset(ccp(0, 382 - height))
    upvalue_512 = {}
    local IMG = {img.ui.arena_frame1, img.ui.arena_frame3, img.ui.arena_frame5}
    for i,v in ipairs(l_9_0) do
      local showRank, showPowerBg = nil, nil
      if i < 4 then
        playerBg[i] = img.createUI9Sprite(IMG[i])
        showRank = img.createUISprite(img.ui.arena_rank_" .. )
        showPowerBg = img.createUI9Sprite(img.ui.arena_frame" .. i * )
      else
        playerBg[i] = img.createUI9Sprite(img.ui.botton_fram_2)
        showRank = lbl.createFont1(20, i, ccc3(130, 90, 61))
        showPowerBg = img.createUI9Sprite(img.ui.arena_frame7)
      end
      playerBg[i]:setPreferredSize(CCSize(541, 88))
      playerBg[i]:setAnchorPoint(ccp(0, 0))
      playerBg[i]:setPosition(0, height - 87 * i - 3)
      scroll:getContainer():addChild(playerBg[i])
      showRank:setPosition(40, playerBg[i]:getContentSize().height / 2 + 1)
      playerBg[i]:addChild(showRank)
      for j = 1, #v.mbrs do
        local playerHead = img.createPlayerHead(v.mbrs[j].logo, v.mbrs[j].lv)
        playerHead:setScale(0.66)
        playerHead:setPosition(98 + (j - 1) * 60, playerBg[i]:getContentSize().height / 2 + 1)
        playerBg[i]:addChild(playerHead)
      end
      local showName = lbl.createFontTTF(16, v.name, ccc3(81, 39, 18))
      showName:setAnchorPoint(ccp(0, 0))
      showName:setPosition(257, 49)
      playerBg[i]:addChild(showName)
      showPowerBg:setPreferredSize(CCSize(130, 28))
      showPowerBg:setAnchorPoint(ccp(0, 0))
      showPowerBg:setPosition(259, 18)
      playerBg[i]:addChild(showPowerBg)
      local showPowerIcon = img.createUISprite(img.ui.power_icon)
      showPowerIcon:setScale(0.45)
      showPowerIcon:setPosition(270, 33)
      playerBg[i]:addChild(showPowerIcon)
      local showPower = lbl.createFont2(16, v.power)
      showPower:setAnchorPoint(ccp(0, 0))
      showPower:setPosition(300, 22)
      playerBg[i]:addChild(showPower)
      local sevbg = img.createUISprite(img.ui.anrea_server_bg)
      sevbg:setScale(0.78)
      sevbg:setPosition(430, 47)
      playerBg[i]:addChild(sevbg)
      local sevlab = lbl.createFont1(18, getSidname(v.sid), ccc3(247, 234, 209))
      sevlab:setPosition(sevbg:getContentSize().width / 2, sevbg:getContentSize().height / 2)
      sevbg:addChild(sevlab)
      local titleScore = lbl.createFont1(14, i18n.global.arena_main_score.string, ccc3(154, 106, 82))
      titleScore:setPosition(490, 54)
      playerBg[i]:addChild(titleScore)
      local showScore = lbl.createFont1(22, v.score, ccc3(164, 47, 40))
      showScore:setPosition(490, 35)
      playerBg[i]:addChild(showScore)
    end
   end
  local pullRank = function()
    if not frdarena.teams then
      local params = {sid = player.sid}
      addWaitNet()
      net:gpvp_ranklist(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status < 0 then
          showToast("status:" .. l_1_0.status)
          return 
        end
        if l_1_0.team then
          frdarena.teams = l_1_0.team
          loadRank(l_1_0.team)
        end
         end)
      return 
    end
    if frdarena.team.reg == true and frdarena.team.rank <= 50 then
      local params = {sid = player.sid}
      addWaitNet()
      net:gpvp_ranklist(params, function(l_2_0)
        delWaitNet()
        tbl2string(l_2_0)
        if l_2_0.status < 0 then
          showToast("status:" .. l_2_0.status)
          return 
        end
        if l_2_0.team then
          frdarena.teams = l_2_0.team
          loadRank(l_2_0.team)
          for i = 1, #frdarena.teams do
            if frdarena.teams[i].uid == player.uid then
              frdarena.team.rank = i
              if frdarena.trank and frdarena.team.rank < frdarena.trank then
                frdarena.trank = frdarena.team.rank
              end
              frdarena.team.score = frdarena.teams[i].score
            end
          end
          if showRank then
            showRank:setString(frdarena.team.rank)
          end
          if showScore then
            showScore:setString(frdarena.team.score)
          end
        end
         end)
      return 
    end
    if frdarena.teams then
      loadRank(frdarena.teams)
    end
   end
  local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
  local onTouchBegan = function(l_11_0, l_11_1)
    touchbeginx, upvalue_512 = l_11_0, l_11_1
    upvalue_1024 = true
    if scroll and not tolua.isnull(scroll) then
      local obj = scroll:getContainer()
      local p0 = obj:convertToNodeSpace(ccp(l_11_0, l_11_1))
      for ii = 1, #playerBg do
        if playerBg[ii]:boundingBox():containsPoint(p0) then
          upvalue_2560 = playerBg[ii]
        end
      end
    end
    return true
   end
  local onTouchMoved = function(l_12_0, l_12_1)
    if isclick and (math.abs(touchbeginx - l_12_0) > 10 or math.abs(touchbeginy - l_12_1) > 10) then
      isclick = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_13_0, l_13_1)
    if isclick then
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        upvalue_512 = nil
      end
      if scroll and not tolua.isnull(scroll) then
        local obj = scroll:getContainer()
        local p0 = obj:convertToNodeSpace(ccp(l_13_0, l_13_1))
        for ii = 1, #playerBg do
          if playerBg[ii]:boundingBox():containsPoint(p0) and last_selet_item ~= playerBg[ii] then
            audio.play(audio.button)
            local params = {sid = player.sid, grp_id = frdarena.teams[ii].id}
            tbl2string(params)
            addWaitNet()
            net:gpvp_grp(params, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              if l_1_0.status ~= 0 then
                showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
                return 
              end
              layer:addChild(require("ui.frdarena.teaminfotips").create(l_1_0.grp))
                  end)
            last_selet_item = nil
          end
        end
      end
    end
   end
  local onTouch = function(l_14_0, l_14_1, l_14_2)
    if l_14_0 == "began" then
      return onTouchBegan(l_14_1, l_14_2)
    elseif l_14_0 == "moved" then
      return onTouchMoved(l_14_1, l_14_2)
    else
      return onTouchEnded(l_14_1, l_14_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    replaceScene(require("ui.town.main").create())
   end
  local onEnter = function()
    pullRank()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_18_0)
    if l_18_0 == "enter" then
      onEnter()
    elseif l_18_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

