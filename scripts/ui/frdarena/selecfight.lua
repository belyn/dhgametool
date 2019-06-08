-- Command line was: E:\github\dhgametool\scripts\ui\frdarena\selecfight.lua 

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
local cfgarena = require("config.arena")
local cfgequip = require("config.equip")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local arenaData = require("data.arena")
local frdarena = require("data.frdarena")
ui.create = function()
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local teaminfo = frdarena.team
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(746, 546))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local board_w = 746
  local board_h = 546
  local showTitle = lbl.createFont1(26, i18n.global.arena_rivals_title.string, ccc3(230, 208, 174))
  showTitle:setPosition(board:getContentSize().width / 2, board_h - 30)
  board:addChild(showTitle, 1)
  local showTitleShade = lbl.createFont1(26, i18n.global.arena_rivals_title.string, ccc3(89, 48, 27))
  showTitleShade:setPosition(board:getContentSize().width / 2, board_h - 32)
  board:addChild(showTitleShade)
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(721, board_h - 28)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local refreshBg = img.createUI9Sprite(img.ui.select_tab_tab_bg)
  refreshBg:setAnchorPoint(ccp(0, 0.5))
  refreshBg:setPreferredSize(CCSize(679, 37))
  refreshBg:setPosition(35, board_h - 96)
  board:addChild(refreshBg)
  local showPowerBg = img.createUISprite(img.ui.select_hero_power_bg)
  showPowerBg:setAnchorPoint(ccp(0, 0.5))
  showPowerBg:setPosition(0, 19)
  refreshBg:addChild(showPowerBg)
  local powerIcon = img.createUISprite(img.ui.power_icon)
  powerIcon:setScale(0.46)
  powerIcon:setPosition(27, 21)
  showPowerBg:addChild(powerIcon)
  local showPower = lbl.createFont2(20, teaminfo.power)
  showPower:setAnchorPoint(ccp(0, 0.5))
  showPower:setPosition(powerIcon:boundingBox():getMaxX() + 15, powerIcon:boundingBox():getMidY())
  showPowerBg:addChild(showPower)
  local btn_skip0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_skip0:setPreferredSize(CCSizeMake(180, 46))
  local skip_bg = img.createUISprite(img.ui.option_bg)
  skip_bg:setPosition(CCPoint(23, 24))
  btn_skip0:addChild(skip_bg)
  local skip_tick = img.createUISprite(img.ui.option_tick)
  skip_tick:setPosition(CCPoint(23, 24))
  btn_skip0:addChild(skip_tick)
  local lbl_skip = lbl.create({font = 1, size = 18, text = i18n.global.btn_skip_fight.string, color = ccc3(115, 59, 5), fr = {size = 14}, ru = {size = 14}})
  lbl_skip:setPosition(CCPoint(100, 23))
  btn_skip0:addChild(lbl_skip)
  local btn_skip = SpineMenuItem:create(json.ui.button, btn_skip0)
  btn_skip:setPosition(CCPoint(465, 18))
  local btn_skip_menu = CCMenu:createWithItem(btn_skip)
  btn_skip_menu:setPosition(CCPoint(0, 0))
  refreshBg:addChild(btn_skip_menu)
  local updateSkip = function()
    if arenaSkip() == "enable" then
      skip_tick:setVisible(true)
    else
      skip_tick:setVisible(false)
    end
   end
  updateSkip()
  btn_skip:registerScriptTapHandler(function()
    audio.play(audio.button)
    if arenaSkip() == "enable" then
      arenaSkip("disable")
    else
      arenaSkip("enable")
    end
    updateSkip()
   end)
  local btnRefreshSp = img.createLogin9Sprite(img.login.button_9_small_green)
  btnRefreshSp:setPreferredSize(CCSize(115, 46))
  local labRefresh = lbl.createFont1(16, i18n.global.arena_rivals_refresh.string, ccc3(35, 98, 5))
  labRefresh:setPosition(btnRefreshSp:getContentSize().width / 2, btnRefreshSp:getContentSize().height / 2)
  btnRefreshSp:addChild(labRefresh)
  local btnRefresh = SpineMenuItem:create(json.ui.button, btnRefreshSp)
  local menuRefresh = CCMenu:createWithItem(btnRefresh)
  menuRefresh:setPosition(0, 0)
  refreshBg:addChild(menuRefresh)
  btnRefresh:setPosition(622, 18)
  local innerBg = img.createUI9Sprite(img.ui.inner_bg)
  innerBg:setPreferredSize(CCSize(681, 378))
  innerBg:setAnchorPoint(ccp(0, 0))
  innerBg:setPosition(33, 32)
  board:addChild(innerBg)
  local valueBottom = img.createUI9Sprite(img.ui.main_coin_bg)
  valueBottom:setPreferredSize(CCSizeMake(138, 36))
  valueBottom:setPosition(CCPoint(122, board_h - 164))
  board:addChild(valueBottom)
  local enegy = frdarena.team.enegy
  local breadlab = lbl.createFont2(16, string.format("%d/12", enegy), ccc3(248, 242, 226))
  breadlab:setPosition(CCPoint(valueBottom:getContentSize().width / 2, valueBottom:getContentSize().height / 2 + 3))
  valueBottom:addChild(breadlab)
  local breadIcon = img.createItemIcon2(ITEM_ID_BREAD)
  breadIcon:setPosition(5, valueBottom:getContentSize().height / 2 + 2)
  valueBottom:addChild(breadIcon)
  local oppoLayer = CCLayer:create()
  innerBg:addChild(oppoLayer)
  local loadRivals = function(l_4_0)
    oppoLayer:removeAllChildrenWithCleanup(true)
    for i,v in ipairs(l_4_0) do
      do
        if i > 3 then
          do return end
        end
        local oppoBg = img.createUI9Sprite(img.ui.botton_fram_2)
        do
          oppoBg:setPreferredSize(CCSize(655, 100))
          local playerOppo = CCMenuItemSprite:create(oppoBg, nil)
          local menuPlayerOppo = CCMenu:createWithItem(playerOppo)
          menuPlayerOppo:setPosition(0, 0)
          playerOppo:setAnchorPoint(ccp(0, 0.5))
          playerOppo:setPosition(13, innerBg:getContentSize().height - 105 * i)
          oppoLayer:addChild(menuPlayerOppo)
          playerOppo:registerScriptTapHandler(function()
            audio.play(audio.button)
            local params = {sid = player.sid, grp_id = v.id}
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
               end)
          local showName = lbl.createFontTTF(16, v.name, ccc3(81, 39, 18))
          showName:setAnchorPoint(ccp(0, 0))
          showName:setPosition(216, 55)
          oppoBg:addChild(showName)
          for j = 1,  v.mbrs do
            local playerHead = img.createPlayerHead(v.mbrs[j].logo, v.mbrs[j].lv)
            playerHead:setScale(0.7)
            playerHead:setPosition(48 + (j - 1) * 63, oppoBg:getContentSize().height / 2)
            oppoBg:addChild(playerHead)
          end
          local powerBg = img.createUI9Sprite(img.ui.arena_frame7)
          powerBg:setPreferredSize(CCSize(130, 28))
          powerBg:setAnchorPoint(ccp(0, 0))
          powerBg:setPosition(216, 22)
          oppoBg:addChild(powerBg)
          local powerIcon = img.createUISprite(img.ui.power_icon)
          powerIcon:setScale(0.45)
          powerIcon:setPosition(14, 14)
          powerBg:addChild(powerIcon)
          local showPower = lbl.createFont2(16, v.power)
          showPower:setAnchorPoint(ccp(0, 0.5))
          showPower:setPosition(43, 14)
          powerBg:addChild(showPower)
          local sevbg = img.createUISprite(img.ui.anrea_server_bg)
          sevbg:setScale(0.78)
          sevbg:setPosition(382, 47)
          oppoBg:addChild(sevbg)
          local sevlab = lbl.createFont1(16, getSidname(v.sid), ccc3(247, 234, 209))
          sevlab:setPosition(sevbg:getContentSize().width / 2, sevbg:getContentSize().height / 2)
          sevbg:addChild(sevlab)
          local titleScore = lbl.createFont1(14, i18n.global.arena_main_score.string, ccc3(154, 106, 82))
          titleScore:setPosition(450, 59)
          oppoBg:addChild(titleScore)
          local showScore = lbl.createFont1(22, v.score, ccc3(164, 47, 40))
          showScore:setPosition(450, 40)
          oppoBg:addChild(showScore)
          local btnBattleSp = img.createLogin9Sprite(img.login.button_9_small_gold)
          btnBattleSp:setPreferredSize(CCSize(136, 52))
          local labFight = lbl.createFont1(16, i18n.global.arena_rivals_fight.string, ccc3(115, 59, 5))
          labFight:setPosition(btnBattleSp:getContentSize().width / 2, btnBattleSp:getContentSize().height / 2)
          btnBattleSp:addChild(labFight)
          local btnBattle = SpineMenuItem:create(json.ui.button, btnBattleSp)
          local menuBattle = CCMenu:createWithItem(btnBattle)
          menuBattle:setPosition(0, 0)
          oppoBg:addChild(menuBattle)
          btnBattle:setPosition(571, 50)
          btnBattle:registerScriptTapHandler(function()
            disableObjAWhile(btnBattle)
            audio.play(audio.button)
            if frdarena.team.enegy <= 0 then
              showToast(i18n.global.friendboss_no_enegy.string)
              return 
            end
            local params = {sid = player.sid, grp_id = v.id}
            addWaitNet()
            net:gpvp_fight(params, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              if l_1_0.status == -1 then
                showToast(i18n.global.friendboss_no_enegy.string)
                return 
              end
              if l_1_0.status < 0 then
                showToast("status:" .. l_1_0.status)
                return 
              end
              if frdarena.team.enegy == 12 then
                frdarena.team.enggy_cd = 3600
                frdarena.team.pull_ecd_time = os.time()
              end
              frdarena.team.enegy = frdarena.team.enegy - 1
              upvalue_1024 = frdarena.team.enegy
              breadlab:setString(string.format("%d/12", enegy))
              frdarena.team.score = l_1_0.atk.score
              local video = {}
              for i = 1,  l_1_0.wins do
                video[i] = {}
                video[i].atk = l_1_0.atk.mbrs[i]
                video[i].def = l_1_0.def.mbrs[i]
                video[i].wins = l_1_0.wins
                video[i].ascore = l_1_0.atk.score
                video[i].dscore = l_1_0.def.score
                video[i].adelta = l_1_0.adelta
                video[i].ddelta = l_1_0.ddelta
                video[i].ref = l_1_0
                processPetPosAtk2(video[i])
                processPetPosDef2(video[i])
                if i == 1 then
                  video[i].frames = l_1_0.frames1
                  video[i].hurts = l_1_0.hurts1
                elseif i == 2 then
                  video[i].frames = l_1_0.frames2
                  video[i].hurts = l_1_0.hurts2
                elseif i == 3 then
                  video[i].frames = l_1_0.frames3
                  video[i].hurts = l_1_0.hurts3
                end
              end
              tbl2string(video)
              do
                if video and video.wins then
                  local win_count = 0
                  if video.wins[ii] == true then
                    win_count = win_count + 1
                  end
              end
              if win_count >= 2 then
                end
              end
              if arenaSkip() == "enable" then
                local tmp_videos = video[ video]
                tmp_videos.idx =  video
                tmp_videos.videos = video
                tmp_videos.skip = true
                CCDirector:sharedDirector():getRunningScene():addChild(require("fight.pvpf3.final").create(tmp_videos), 1000)
              else
                replaceScene(require("fight.pvpf3.loading").create(video))
              end
                  end)
               end)
        end
      end
    end
   end
  local onRefresh = function()
    local Rivals = frdarena.refresh()
    if  Rivals <= 0 then
      local params = {sid = player.sid, id = 1}
      addWaitNet()
      net:gpvp_match(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.teams then
          frdarena.rivals = l_1_0.teams
          upvalue_512 = frdarena.refresh()
          loadRivals(Rivals)
        end
         end)
    end
    loadRivals(Rivals)
   end
  btnRefresh:registerScriptTapHandler(function()
    audio.play(audio.button)
    onRefresh()
   end)
  json.load(json.ui.clock)
  local clockIcon = DHSkeletonAnimation:createWithKey(json.ui.clock)
  clockIcon:scheduleUpdateLua()
  clockIcon:playAnimation("animation", -1)
  clockIcon:setPosition(215, board_h - 163)
  if enegy == 12 then
    clockIcon:setVisible(false)
  end
  board:addChild(clockIcon, 100)
  local timeLab = string.format("%02d:%02d:%02d", math.floor(0), math.floor(0), math.floor(0))
  local showTimeLab = lbl.createFont2(16, "", ccc3(165, 253, 71))
  showTimeLab:setAnchorPoint(0, 0.5)
  showTimeLab:setPosition(235, board_h - 163)
  board:addChild(showTimeLab)
  local recoverlab = lbl.createFont1(16, i18n.global.friendboss_enegy_recovery.string, ccc3(81, 39, 18))
  recoverlab:setAnchorPoint(0, 0.5)
  recoverlab:setPosition(CCPoint(311, board_h - 165))
  board:addChild(recoverlab)
  layer:scheduleUpdateWithPriorityLua(function()
    if frdarena.team.enggy_cd and frdarena.team.pull_ecd_time and showTimeLab and not tolua.isnull(showTimeLab) then
      cd = math.max(0, frdarena.team.enggy_cd + frdarena.team.pull_ecd_time - os.time())
      if cd > 0 then
        local timeLab = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
        showTimeLab:setString(timeLab)
        if enegy > 11 then
          recoverlab:setVisible(false)
          showTimeLab:setVisible(false)
          clockIcon:setVisible(false)
        elseif enegy <= 11 then
          frdarena.team.enggy_cd = frdarena.team.enggy_cd + 3600
          frdarena.team.enegy = frdarena.team.enegy + 1
          upvalue_1024 = frdarena.team.enegy
          breadlab:setString(string.format("%d/12", enegy))
          if frdarena.team.enegy_cd == nil then
            recoverlab:setVisible(false)
            showTimeLab:setVisible(false)
            clockIcon:setVisible(false)
          else
            recoverlab:setVisible(false)
            showTimeLab:setVisible(false)
            clockIcon:setVisible(false)
          end
        end
      end
    end
   end)
  layer:registerScriptTouchHandler(function()
    return true
   end)
  layer:setTouchEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  local onEnter = function()
    print("onEnter")
    onRefresh()
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
  board:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  anim_arr:addObject(CCDelayTime:create(0.15))
  anim_arr:addObject(CCCallFunc:create(function()
   end))
  board:runAction(CCSequence:create(anim_arr))
  return layer
end

return ui

