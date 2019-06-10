-- Command line was: E:\github\dhgametool\scripts\ui\frdarena\teaminfo.lua 

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
ui.create = function(l_1_0)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local teaminfo = clone(frdarena.team)
  local board_w = 840
  local board_h = 540
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(board_w, board_h))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local innerBg = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  innerBg:setPreferredSize(CCSizeMake(784, 352))
  innerBg:setAnchorPoint(0, 0)
  innerBg:setPosition(29, 90)
  board:addChild(innerBg)
  local showTitle = lbl.createFont1(26, i18n.global.frdpvp_team_myteam.string, ccc3(230, 208, 174))
  showTitle:setPosition(board:getContentSize().width / 2, 511)
  board:addChild(showTitle, 1)
  local showTitleShade = lbl.createFont1(26, i18n.global.frdpvp_team_myteam.string, ccc3(89, 48, 27))
  showTitleShade:setPosition(board:getContentSize().width / 2, 509)
  board:addChild(showTitleShade)
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(815, 513)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local selectTeamBg = img.createUI9Sprite(img.ui.select_tab_tab_bg)
  selectTeamBg:setPreferredSize(CCSize(745, 37))
  selectTeamBg:setAnchorPoint(0.5, 0)
  selectTeamBg:setPosition(board_w / 2, 382)
  board:addChild(selectTeamBg)
  local showPowerBg = img.createUISprite(img.ui.select_hero_power_bg)
  showPowerBg:setAnchorPoint(ccp(0, 0.5))
  showPowerBg:setPosition(0, 19)
  selectTeamBg:addChild(showPowerBg)
  local powerIcon = img.createUISprite(img.ui.power_icon)
  powerIcon:setScale(0.46)
  powerIcon:setPosition(27, 21)
  showPowerBg:addChild(powerIcon)
  local showallPower = lbl.createFont2(20, teaminfo.power)
  showallPower:setAnchorPoint(ccp(0, 0.5))
  showallPower:setPosition(powerIcon:boundingBox():getMaxX() + 15, powerIcon:boundingBox():getMidY())
  showPowerBg:addChild(showallPower)
  local playerBg = {}
  for i = #teaminfo.mbrs + 1, 3 do
    playerBg[i] = img.createUI9Sprite(img.ui.botton_fram_2)
    playerBg[i]:setPreferredSize(CCSize(228, 246))
    playerBg[i]:setAnchorPoint(ccp(0.5, 0))
    playerBg[i]:setPosition(board_w / 2 + 248 * (i - 2), 116)
    board:addChild(playerBg[i])
  end
  local teamName = lbl.createFontTTF(20, teaminfo.name, ccc3(81, 52, 28))
  teamName:setAnchorPoint(1, 0.5)
  teamName:setPosition(board_w / 2 - 5, 462)
  board:addChild(teamName)
  local teamId = lbl.createFont2(16, string.format("ID %d", teaminfo.id), ccc3(255, 246, 243))
  teamId:setAnchorPoint(0, 0.5)
  teamId:setPosition(board_w / 2 + 5, 462)
  board:addChild(teamId)
  local createteamInfo = function()
    local teaminfolayer = CCLayer:create()
    local sx = 174
    local dx = 246
    for i = 1, 3 do
      do
        if i <= #teaminfo.mbrs then
          if teaminfo.mbrs[i].uid == player.uid then
            playerBg[i] = img.createUI9Sprite(img.ui.botton_fram_3)
          else
            playerBg[i] = img.createUI9Sprite(img.ui.botton_fram_2)
          end
          playerBg[i]:setPreferredSize(CCSize(228, 246))
          playerBg[i]:setAnchorPoint(ccp(0.5, 0))
          playerBg[i]:setPosition(board_w / 2 + 248 * (i - 2), 116)
          teaminfolayer:addChild(playerBg[i])
          local mname = lbl.createMixFont1(16, teaminfo.mbrs[i].name, ccc3(81, 52, 28))
          mname:setPosition(board_w / 2 + 248 * (i - 2), 326)
          teaminfolayer:addChild(mname, 10)
          local infoCutLine = img.createUI9Sprite(img.ui.split_line)
          infoCutLine:setPreferredSize(CCSize(176, 1))
          infoCutLine:setPosition(board_w / 2 + 248 * (i - 2), 306)
          teaminfolayer:addChild(infoCutLine)
          local head = img.createPlayerHeadForArena(teaminfo.mbrs[i].logo, teaminfo.mbrs[i].lv)
          headBtn = SpineMenuItem:create(json.ui.button, head)
          headBtn:setPosition(board_w / 2 + 248 * (i - 2), 240)
          local headMenu = CCMenu:createWithItem(headBtn)
          headMenu:setPosition(0, 0)
          teaminfolayer:addChild(headMenu)
          headBtn:registerScriptTapHandler(function()
            audio.play(audio.button)
            if player.uid == teaminfo.leader then
              if player.uid ~= teaminfo.mbrs[i].uid then
                layer:addChild(require("ui.frdarena.mbrinfo").create(teaminfo.mbrs[i], "clear"), 100)
              else
                layer:addChild(require("ui.frdarena.mbrinfo").create(teaminfo.mbrs[i], "none"), 100)
              end
            else
              teaminfo.mbrs[i].teamid = teaminfo.id
              if player.uid ~= teaminfo.mbrs[i].uid then
                layer:addChild(require("ui.frdarena.mbrinfo").create(teaminfo.mbrs[i], "none"), 100)
              else
                layer:addChild(require("ui.frdarena.mbrinfo").create(teaminfo.mbrs[i], "quit"), 100)
              end
            end
               end)
          if teaminfo.mbrs[i].uid == teaminfo.leader then
            local teamIcon = img.createUISprite(img.ui.friend_pvp_captain)
            teamIcon:setAnchorPoint(0, 1)
            teamIcon:setPosition(0, head:getContentSize().height)
            head:addChild(teamIcon)
          end
          local powerBg = nil
          if teaminfo.mbrs[i].uid == player.uid then
            powerBg = img.createUI9Sprite(img.ui.arena_frame" .. )
          else
            powerBg = img.createUI9Sprite(img.ui.arena_frame7)
          end
          powerBg:setPreferredSize(CCSize(127, 28))
          powerBg:setAnchorPoint(ccp(0.5, 0))
          powerBg:setPosition(board_w / 2 + 248 * (i - 2), 148)
          teaminfolayer:addChild(powerBg)
          local showPowerIcon = img.createUISprite(img.ui.power_icon)
          showPowerIcon:setScale(0.5)
          showPowerIcon:setPosition(board_w / 2 + 248 * (i - 2) - 54, 162)
          teaminfolayer:addChild(showPowerIcon)
          local showPower = lbl.createFont2(16, teaminfo.mbrs[i].power)
          showPower:setPosition(board_w / 2 + 248 * (i - 2), 162)
          teaminfolayer:addChild(showPower)
        else
          local mname = lbl.createMixFont1(16, i18n.global.frdpvp_team_wait.string, ccc3(81, 52, 28))
          mname:setPosition(board_w / 2 + 248 * (i - 2), 326)
          teaminfolayer:addChild(mname, 10)
          local infoCutLine = img.createUI9Sprite(img.ui.split_line)
          infoCutLine:setPreferredSize(CCSize(176, 1))
          infoCutLine:setPosition(board_w / 2 + 248 * (i - 2), 306)
          teaminfolayer:addChild(infoCutLine)
          local addicon = img.createUISprite(img.ui.herotask_add_icon)
          local addBtn = SpineMenuItem:create(json.ui.button, addicon)
          addBtn:setPosition(board_w / 2 + 248 * (i - 2), 225)
          local addMenu = CCMenu:createWithItem(addBtn)
          addMenu:setPosition(0, 0)
          teaminfolayer:addChild(addMenu)
          if player.uid ~= teaminfo.leader then
            addBtn:setVisible(false)
          end
          addBtn:registerScriptTapHandler(function()
            audio.play(audio.button)
            local params = {sid = player.sid}
            addWaitNet()
            net:gpvp_friendslist(params, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              layer:addChild(require("ui.frdarena.invidefrd").create(l_1_0.friends))
                  end)
               end)
        end
      end
    end
    return teaminfolayer
   end
  local teammateLayer = createteamInfo()
  board:addChild(teammateLayer)
  local dissolution = img.createLogin9Sprite(img.login.button_9_small_orange)
  dissolution:setPreferredSize(CCSizeMake(162, 52))
  local dissolutionlab = lbl.createFont1(16, i18n.global.frdpvp_team_dissolution.string, ccc3(115, 59, 5))
  dissolutionlab:setPosition(CCPoint(dissolution:getContentSize().width / 2, dissolution:getContentSize().height / 2 + 1))
  dissolution:addChild(dissolutionlab)
  local dissolutionBtn = SpineMenuItem:create(json.ui.button, dissolution)
  dissolutionBtn:setAnchorPoint(0, 0)
  dissolutionBtn:setPosition(CCPoint(board_w / 2 - 168, 27))
  local dissolutionMenu = CCMenu:createWithItem(dissolutionBtn)
  dissolutionMenu:setPosition(CCPoint(0, 0))
  board:addChild(dissolutionMenu)
  local createSure = function()
    local paramsc = {}
    paramsc.btn_count = 0
    paramsc.body = string.format(i18n.global.frdpvp_team_isdissolution.string)
    local board_w = 474
    local dialoglayer = require("ui.dialog").create(paramsc)
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
      audio.play(audio.button)
      local params = {sid = player.sid}
      addWaitNet()
      net:dismiss_gpvpteam(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status < 0 then
          showToast("status:" .. l_1_0.status)
          return 
        end
        frdarena.setdissmiss()
        showToast(i18n.global.frdpvp_dissmiss_scc.string)
        layer:removeFromParentAndCleanup(true)
         end)
      end)
    btnNo:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      audio.play(audio.button)
      end)
    local backEvent = function()
      dialoglayer:removeFromParentAndCleanup(true)
      end
    dialoglayer.onAndroidBack = function()
      backEvent()
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
  local createSureForsubmit = function()
    local paramsc = {}
    paramsc.btn_count = 0
    paramsc.body = string.format(i18n.global.frdpvp_team_issubmit.string)
    local board_w = 474
    local dialoglayer = require("ui.dialog").create(paramsc)
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
      audio.play(audio.button)
      local params = {sid = player.sid}
      addWaitNet()
      net:submit_gpvpteam(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status == -2 then
          showToast(i18n.global.frdpvp_team_noteammate.string)
          return 
        end
        if l_1_0.status < 0 then
          showToast("status:" .. l_1_0.status)
          return 
        end
        local paramss = {sid = player.sid}
        addWaitNet()
        net:gpvp_sync(paramss, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          frdarena.init(l_1_0)
          layer:removeFromParentAndCleanup(true)
          replaceScene(require("ui.frdarena.main").create())
            end)
         end)
      end)
    btnNo:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      audio.play(audio.button)
      end)
    local backEvent = function()
      dialoglayer:removeFromParentAndCleanup(true)
      end
    dialoglayer.onAndroidBack = function()
      backEvent()
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
  dissolutionBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(createSure())
   end)
  local createShare = function()
    local layer = CCLayer:create()
    local board = img.createUI9Sprite(img.ui.tips_bg)
    board:setPreferredSize(CCSize(358, 272))
    board:setScale(view.minScale)
    board:setPosition(scalep(480, 288))
    layer:addChild(board)
    local showText = lbl.createMix({font = 1, size = 16, text = i18n.global.hero_share_text.string, color = ccc3(255, 246, 223), width = 312, align = kCCTextAlignmentLeft})
    showText:setAnchorPoint(ccp(0, 1))
    showText:setPosition(24, 255)
    board:addChild(showText)
    local btnBg = img.createUI9Sprite(img.ui.smith_drop_bg)
    btnBg:setPreferredSize(CCSize(314, 168))
    btnBg:setPosition(179, 108)
    board:addChild(btnBg)
    local btnWorldChatSp = img.createLogin9Sprite(img.login.button_9_small_mwhite)
    btnWorldChatSp:setPreferredSize(CCSize(290, 68))
    local labWorldChat = lbl.createFont1(20, i18n.global.hero_btn_share_world.string, ccc3(118, 37, 5))
    labWorldChat:setPosition(btnWorldChatSp:getContentSize().width / 2, btnWorldChatSp:getContentSize().height / 2)
    btnWorldChatSp:addChild(labWorldChat)
    local btnWorldChat = SpineMenuItem:create(json.ui.button, btnWorldChatSp)
    btnWorldChat:setPosition(btnBg:getContentSize().width / 2, 122)
    local menuWorldChat = CCMenu:createWithItem(btnWorldChat)
    menuWorldChat:setPosition(0, 0)
    btnBg:addChild(menuWorldChat)
    local btnGuildChatSp = img.createLogin9Sprite(img.login.button_9_small_mwhite)
    btnGuildChatSp:setPreferredSize(CCSize(290, 68))
    local labGuildChat = lbl.createFont1(20, i18n.global.hero_btn_share_guild.string, ccc3(118, 37, 5))
    labGuildChat:setPosition(btnGuildChatSp:getContentSize().width / 2, btnGuildChatSp:getContentSize().height / 2)
    btnGuildChatSp:addChild(labGuildChat)
    local btnGuildChat = SpineMenuItem:create(json.ui.button, btnGuildChatSp)
    btnGuildChat:setPosition(btnBg:getContentSize().width / 2, 45)
    local menuGuildChat = CCMenu:createWithItem(btnGuildChat)
    menuGuildChat:setPosition(0, 0)
    btnBg:addChild(menuGuildChat)
    local onTouch = function(l_1_0, l_1_1, l_1_2)
      local point = layer:convertToNodeSpace(ccp(l_1_1, l_1_2))
      if not board:boundingBox():containsPoint(point) then
        layer:removeFromParentAndCleanup(true)
        return 
      end
      end
    layer:registerScriptTouchHandler(onTouch)
    layer:setTouchEnabled(true)
    local onShare = function(l_2_0)
      layer:removeFromParentAndCleanup(true)
      end
    btnWorldChat:registerScriptTapHandler(function()
      onShare(1)
      end)
    btnGuildChat:registerScriptTapHandler(function()
      onShare(2)
      end)
    return layer
   end
  local sendhelp = img.createLogin9Sprite(img.login.button_9_small_gold)
  sendhelp:setPreferredSize(CCSizeMake(162, 52))
  local sendhelplab = lbl.createFont1(16, i18n.global.frdpvp_team_sendhelp.string, ccc3(115, 59, 5))
  sendhelplab:setPosition(CCPoint(sendhelp:getContentSize().width / 2, sendhelp:getContentSize().height / 2 + 1))
  sendhelp:addChild(sendhelplab)
  local sendhelpBtn = SpineMenuItem:create(json.ui.button, sendhelp)
  sendhelpBtn:setAnchorPoint(0, 0)
  sendhelpBtn:setPosition(CCPoint(board_w / 2 - 168, 27))
  local sendhelpMenu = CCMenu:createWithItem(sendhelpBtn)
  sendhelpMenu:setPosition(CCPoint(0, 0))
  board:addChild(sendhelpMenu)
  sendhelpBtn:setVisible(false)
  sendhelpBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(createShare(), 1000)
   end)
  local invited = img.createLogin9Sprite(img.login.button_9_small_gold)
  invited:setPreferredSize(CCSizeMake(162, 52))
  local invitedlab = lbl.createFont1(16, i18n.global.friend_apply.string, ccc3(115, 59, 5))
  invitedlab:setPosition(CCPoint(invited:getContentSize().width / 2, invited:getContentSize().height / 2 + 1))
  invited:addChild(invitedlab)
  local invitedBtn = SpineMenuItem:create(json.ui.button, invited)
  invitedBtn:setAnchorPoint(0, 0)
  invitedBtn:setPosition(CCPoint(board_w / 2 + 6, 27))
  addRedDot(invited, {px = invited:getContentSize().width - 7, py = invited:getContentSize().height - 7})
  delRedDot(invited)
  local invitedMenu = CCMenu:createWithItem(invitedBtn)
  invitedMenu:setPosition(CCPoint(0, 0))
  board:addChild(invitedMenu)
  invitedBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local params = {sid = player.sid}
    tbl2string(params)
    addWaitNet()
    net:gpvp_applylist(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      layer:addChild(require("ui.frdarena.invided").create(l_1_0.mbrs))
      frdarena.showapplyRed = false
      end)
   end)
  local submit = img.createLogin9Sprite(img.login.button_9_small_gold)
  submit:setPreferredSize(CCSizeMake(162, 52))
  local submitlab = lbl.createFont1(16, i18n.global.frdpvp_team_submit.string, ccc3(115, 59, 5))
  submitlab:setPosition(CCPoint(submit:getContentSize().width / 2, submit:getContentSize().height / 2 + 1))
  submit:addChild(submitlab)
  local submitBtn = SpineMenuItem:create(json.ui.button, submit)
  submitBtn:setAnchorPoint(0, 0)
  submitBtn:setPosition(CCPoint(board_w / 2 + 178, 27))
  if #frdarena.team.mbrs < 3 then
    submitBtn:setVisible(false)
  end
  local submitMenu = CCMenu:createWithItem(submitBtn)
  submitMenu:setPosition(CCPoint(0, 0))
  board:addChild(submitMenu)
  submitBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(createSureForsubmit())
   end)
  if player.uid ~= teaminfo.leader then
    dissolutionBtn:setVisible(false)
    invitedBtn:setVisible(false)
    sendhelpBtn:setVisible(false)
    submitBtn:setVisible(false)
  end
  layer:scheduleUpdateWithPriorityLua(function()
    if frdarena.showapplyRed == true then
      addRedDot(invited, {px = invited:getContentSize().width - 7, py = invited:getContentSize().height - 7})
    else
      delRedDot(invited)
    end
    if frdarena.team == nil then
      layer:removeFromParentAndCleanup(true)
      return 
    end
    if (frdarena.team and #teaminfo.mbrs ~= #frdarena.team.mbrs) or frdarena.refreshOwner == true then
      frdarena.refreshOwner = false
      upvalue_1536 = clone(frdarena.team)
      teammateLayer:removeFromParentAndCleanup(true)
      upvalue_2048 = nil
      upvalue_2048 = createteamInfo()
      board:addChild(teammateLayer)
      if #frdarena.team.mbrs < 3 or player.uid ~= teaminfo.leader then
        submitBtn:setVisible(false)
      else
        submitBtn:setVisible(true)
      end
      if player.uid ~= teaminfo.leader then
        invitedBtn:setVisible(false)
        dissolutionBtn:setVisible(false)
      else
        invitedBtn:setVisible(true)
        dissolutionBtn:setVisible(true)
      end
    end
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_14_0)
    if l_14_0 == "enter" then
      onEnter()
    elseif l_14_0 == "exit" then
      onExit()
    end
   end)
  layer:registerScriptTouchHandler(function()
    return true
   end)
  layer:setTouchEnabled(true)
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

