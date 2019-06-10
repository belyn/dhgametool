-- Command line was: E:\github\dhgametool\scripts\ui\frdarena\mbrinfo.lua 

local tips = {}
require("common.func")
require("common.const")
local view = require("common.view")
local player = require("data.player")
local net = require("net.netClient")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local friend = require("data.friend")
local frdarena = require("data.frdarena")
local TIPS_WIDTH = 516
local TIPS_HEIGHT = 342
local BUTTON_POSX = {1 = {258}, 2 = {414, 258, 102}, 3 = {100, 262, 424}}
local COLOR2TYPE = {1 = img.login.button_9_small_orange, 2 = img.login.button_9_small_gold}
tips.create = function(l_1_0, l_1_1, l_1_2)
  local layer = CCLayer:create()
  local guildName = l_1_0.gname or ""
  local board = img.createUI9Sprite(img.ui.tips_bg)
  board:setPreferredSize(CCSize(TIPS_WIDTH, TIPS_HEIGHT))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  layer.board = board
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(492, TIPS_HEIGHT - 28)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local showHead = img.createPlayerHead(l_1_0.logo, l_1_0.lv)
  showHead:setPosition(68, TIPS_HEIGHT - 68)
  board:addChild(showHead)
  local showName = lbl.createFontTTF(20, l_1_0.name)
  showName:setAnchorPoint(ccp(0, 0))
  showName:setPosition(118, TIPS_HEIGHT - 54)
  board:addChild(showName)
  local showID = lbl.createFont1(16, "ID " .. l_1_0.uid, ccc3(255, 246, 223))
  showID:setAnchorPoint(ccp(0, 0))
  showID:setPosition(118, TIPS_HEIGHT - 85)
  board:addChild(showID)
  local titleGuild = lbl.createFont2(18, i18n.global.tips_player_guild.string .. ":", ccc3(237, 203, 31))
  titleGuild:setAnchorPoint(ccp(0, 0))
  titleGuild:setPosition(118, TIPS_HEIGHT - 110)
  board:addChild(titleGuild)
  local createdelete = function()
    local deletparams = {}
    deletparams.btn_count = 0
    deletparams.body = string.format(i18n.global.frdpvp_team_isquit.string, 20)
    local dialoglayer = require("ui.dialog").create(deletparams)
    local btnYesSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnYesSprite:setPreferredSize(CCSize(115, 43))
    local btnYes = SpineMenuItem:create(json.ui.button, btnYesSprite)
    btnYes:setPosition(340, 100)
    local labYes = lbl.createFont1(18, i18n.global.board_confirm_yes.string, ccc3(115, 59, 5))
    labYes:setPosition(btnYes:getContentSize().width / 2, btnYes:getContentSize().height / 2)
    btnYesSprite:addChild(labYes)
    local menuYes = CCMenu:create()
    menuYes:setPosition(0, 0)
    menuYes:addChild(btnYes)
    dialoglayer.board:addChild(menuYes)
    local btnNoSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnNoSprite:setPreferredSize(CCSize(115, 43))
    local btnNo = SpineMenuItem:create(json.ui.button, btnNoSprite)
    btnNo:setPosition(150, 100)
    local labNo = lbl.createFont1(18, i18n.global.board_confirm_no.string, ccc3(115, 59, 5))
    labNo:setPosition(btnNo:getContentSize().width / 2, btnNo:getContentSize().height / 2)
    btnNoSprite:addChild(labNo)
    local menuNo = CCMenu:create()
    menuNo:setPosition(0, 0)
    menuNo:addChild(btnNo)
    dialoglayer.board:addChild(menuNo)
    btnYes:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      local param = {}
      param.sid = player.sid
      param.type = 3
      param.teamid = params.teamid
      addWaitNet()
      net:gpvp_mbrop(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        frdarena.setdissmiss()
        layer:removeFromParentAndCleanup(true)
         end)
      audio.play(audio.button)
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
  local createTransfer = function()
    local deletparams = {}
    deletparams.btn_count = 0
    deletparams.body = string.format(i18n.global.frdpvp_team_istransfer.string, 20)
    local dialoglayer = require("ui.dialog").create(deletparams)
    local btnYesSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnYesSprite:setPreferredSize(CCSize(115, 43))
    local btnYes = SpineMenuItem:create(json.ui.button, btnYesSprite)
    btnYes:setPosition(340, 100)
    local labYes = lbl.createFont1(18, i18n.global.board_confirm_yes.string, ccc3(115, 59, 5))
    labYes:setPosition(btnYes:getContentSize().width / 2, btnYes:getContentSize().height / 2)
    btnYesSprite:addChild(labYes)
    local menuYes = CCMenu:create()
    menuYes:setPosition(0, 0)
    menuYes:addChild(btnYes)
    dialoglayer.board:addChild(menuYes)
    local btnNoSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnNoSprite:setPreferredSize(CCSize(115, 43))
    local btnNo = SpineMenuItem:create(json.ui.button, btnNoSprite)
    btnNo:setPosition(150, 100)
    local labNo = lbl.createFont1(18, i18n.global.board_confirm_no.string, ccc3(115, 59, 5))
    labNo:setPosition(btnNo:getContentSize().width / 2, btnNo:getContentSize().height / 2)
    btnNoSprite:addChild(labNo)
    local menuNo = CCMenu:create()
    menuNo:setPosition(0, 0)
    menuNo:addChild(btnNo)
    dialoglayer.board:addChild(menuNo)
    btnYes:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      local param = {}
      param.sid = player.sid
      param.type = 5
      param.uid = params.uid
      addWaitNet()
      net:gpvp_leaderop(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status == -2 then
          showToast(i18n.global.frdpvp_team_playerleave.string)
          return 
        end
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        frdarena.setLeader(params.uid)
        if callBack then
          callBack()
        end
        layer:removeFromParentAndCleanup(true)
         end)
      audio.play(audio.button)
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
  if l_1_1 == "clear" then
    wayText = i18n.global.frdpvp_team_kick.string
  elseif l_1_1 == "quit" then
    wayText = i18n.global.frdpvp_team_quick.string
  elseif l_1_1 == "owner" then
    wayText = i18n.global.frdpvp_team_transfer.string
  else
    wayText = "none"
  end
  local btnConfig = {1 = {text = wayText, Color = 1}, 2 = {text = i18n.global.frdpvp_team_transfer.string, Color = 2}}
  btnConfig[1].handler = function()
    audio.play(audio.button)
    if way == "quit" then
      local dialog = createdelete()
      layer:addChild(dialog, 300)
    elseif way == "owner" then
      local dialog = createTransfer()
      layer:addChild(dialog, 300)
    else
      local param = {}
      param.sid = player.sid
      param.type = 3
      param.uid = params.uid
      addWaitNet()
      net:gpvp_leaderop(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status == -2 then
          showToast(i18n.global.frdpvp_team_playerleave.string)
          return 
        end
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        frdarena.delTeammate(params)
        layer:removeFromParentAndCleanup(true)
         end)
    end
   end
  btnConfig[2].handler = function()
    audio.play(audio.button)
    local dialog = createTransfer()
    layer:addChild(dialog, 300)
   end
  for i,v in ipairs(btnConfig) do
    do
      local btnSp = img.createLogin9Sprite(COLOR2TYPE[v.Color])
      btnSp:setPreferredSize(CCSize(148, 46))
      local btn = SpineMenuItem:create(json.ui.button, btnSp)
      btn:setPosition(BUTTON_POSX[2][i], TIPS_HEIGHT - 296)
      local menu = CCMenu:createWithItem(btn)
      menu:setPosition(0, 0)
      board:addChild(menu)
      local label = nil
      label = lbl.createFont1(18, v.text or "", ccc3(115, 59, 5))
      label:setPosition(btnSp:getContentSize().width / 2, btnSp:getContentSize().height / 2)
      btnSp:addChild(label)
      if v.handler then
        btn:registerScriptTapHandler(function()
        audio.play(audio.button)
        v.handler()
         end)
      end
      if wayText == "none" then
        btn:setVisible(false)
      end
      if i == 2 and l_1_1 ~= "clear" then
        btn:setVisible(false)
      end
    end
  end
  local onCreate = function(l_7_0)
    local showGuild = lbl.createFontTTF(18, l_7_0.mbr.gname or guildName)
    showGuild:setAnchorPoint(ccp(0, 0))
    showGuild:setPosition(titleGuild:boundingBox():getMaxX() + 10, titleGuild:getPositionY())
    board:addChild(showGuild)
    local titleDefen = lbl.createMixFont3(18, i18n.global.tips_player_defen.string, ccc3(255, 242, 152))
    titleDefen:setAnchorPoint(ccp(0, 0))
    titleDefen:setPosition(25, TIPS_HEIGHT - 161)
    board:addChild(titleDefen)
    local fgLine = img.createUI9Sprite(img.ui.hero_panel_fgline)
    fgLine:setOpacity(76.5)
    fgLine:setPreferredSize(CCSize(468, 2))
    fgLine:setPosition(TIPS_WIDTH / 2, TIPS_HEIGHT - 168)
    board:addChild(fgLine)
    local showPower = lbl.createFont2(22, l_7_0.mbr.power or 0)
    showPower:setAnchorPoint(ccp(1, 0.5))
    showPower:setPosition(fgLine:boundingBox():getMaxX(), TIPS_HEIGHT - 146)
    board:addChild(showPower)
    local powerIcon = img.createUISprite(img.ui.power_icon)
    powerIcon:setScale(0.48)
    powerIcon:setAnchorPoint(ccp(1, 0.5))
    powerIcon:setPosition(showPower:boundingBox():getMinX() - 10, TIPS_HEIGHT - 148)
    board:addChild(powerIcon)
    local POSX = {1 = 23, 2 = 98, 3 = 198, 4 = 273, 5 = 348, 6 = 423}
    local hids = {}
    if not l_7_0.mbr.camp then
      local pheroes = {}
    end
    if pheroes then
      for i,v in ipairs(pheroes) do
        hids[v.pos] = v
      end
    end
    for i = 1, 6 do
      local showHero = nil
      if hids[i] then
        local param = {id = hids[i].id, lv = hids[i].lv, showGroup = true, showStar = true, wake = hids[i].wake, orangeFx = nil, petID = require("data.pet").getPetID(hids), hid = nil, skin = hids[i].skin}
        showHero = img.createHeroHeadByParam(param)
      else
        showHero = img.createUISprite(img.ui.herolist_head_bg)
      end
      showHero:setAnchorPoint(ccp(0, 0))
      showHero:setScale(0.75)
      showHero:setPosition(POSX[i], TIPS_HEIGHT - 252)
      board:addChild(showHero)
    end
   end
  layer:registerScriptTouchHandler(function()
    return true
   end)
  layer:setTouchEnabled(true)
  local onEnter = function()
    local params = {sid = player.sid, uid = params.uid}
    addWaitNet()
    net:gpvp_mbr(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      onCreate(l_1_0)
      end)
   end
  local onExit = function()
   end
  layer:registerScriptHandler(function(l_11_0)
    if l_11_0 == "enter" then
      onEnter()
    elseif l_11_0 == "exit" then
       -- Warning: missing end command somewhere! Added here
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

return tips

