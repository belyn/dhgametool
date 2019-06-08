-- Command line was: E:\github\dhgametool\scripts\ui\guildFight\settingLineup.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local heros = require("data.heros")
local userdata = require("data.userdata")
local cfghero = require("config.hero")
local bag = require("data.bag")
local player = require("data.player")
local net = require("net.netClient")
local space_height = 1
local MAXSHADOW = 3
local MIXLIMIXTEAME = 10
local MAXLIMIXTEAME = 15
createChangePos = function(l_1_0, l_1_1, l_1_2)
  local layer = CCLayer:create()
  local BG_WIDTH = 448
  local BG_HEIGHT = 322
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setPreferredSize(CCSize(BG_WIDTH, BG_HEIGHT))
  bg:setScale(view.minScale * 0.1)
  bg:setAnchorPoint(ccp(0.5, 0.5))
  bg:setPosition(scalep(480, 338))
  bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  layer:addChild(bg)
  local titlelab = lbl.createFont1(20, i18n.global.guiidFight_number_sel.string, ccc3(255, 227, 134))
  titlelab:setPosition(BG_WIDTH / 2, 286)
  bg:addChild(titlelab)
  local line = img.createUISprite(img.ui.help_line)
  line:setScaleX(405 / line:getContentSize().width)
  line:setPosition(BG_WIDTH / 2, 260)
  bg:addChild(line)
  local sx = 80
  local sy = 200
  local dx = 74
  local dy = 68
  for i = 1, l_1_1 do
    do
      local numbg = img.createLogin9Sprite(img.login.button_9_small_gold)
      numbg:setPreferredSize(CCSize(64, 56))
      local numlab = lbl.createFont1(16, i, ccc3(115, 59, 5))
      numlab:setPosition(numbg:getContentSize().width / 2, numbg:getContentSize().height / 2)
      numbg:addChild(numlab)
      local numBtn = SpineMenuItem:create(json.ui.button, numbg)
      numBtn:setPosition(sx + (i - 1) % 5 * dx, sy - math.floor((i - 1) / 5) * dy)
      local nummenu = CCMenu:createWithItem(numBtn)
      nummenu:setPosition(0, 0)
      bg:addChild(nummenu)
      numBtn:registerScriptTapHandler(function()
        audio.play(audio.button)
        callback(curpos, i, true)
        layer:removeFromParentAndCleanup()
         end)
    end
  end
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

ui.create = function(l_2_0, l_2_1)
  local layer = CCLayer:create()
  if not l_2_0 then
    local param = {}
  end
  local params = clone(param)
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  tbl2string(params)
  local BG_WIDTH = 930
  local BG_HEIGHT = 544
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(BG_WIDTH, BG_HEIGHT))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local teamsUid = params.uids
  local shadowUid = params.mask
  local judgeSet = function()
    if  teamsUid ~=  param.uids then
      return true
    end
    for i = 1,  teamsUid do
      if teamsUid[i] ~= param.uids[i] then
        return true
      end
    end
    if  shadowUid ~=  param.mask then
      return true
    end
    for i = 1,  shadowUid do
      if shadowUid[i] ~= param.mask[i] then
        return true
      end
    end
    return false
   end
  local createCostDiamond = function(l_2_0)
    local paramsc = {}
    paramsc.btn_count = 0
    paramsc.body = string.format(i18n.global.guildFight_save_tips.string)
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
      curlayer:removeFromParentAndCleanup(true)
      audio.play(audio.button)
      local paramss = {sid = player.sid, uids = teamsUid, mask = shadowUid}
      addWaitNet()
      net:guild_fight_lineup(paramss, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          if l_1_0.status == -1 then
            showToast(i18n.global.guildFight_mix_teams.string)
          elseif l_1_0.status == -2 then
            showToast(i18n.global.guildFight_shadow_limit.string)
          elseif l_1_0.status == -3 then
            showToast(i18n.global.guildFight_cant_subteam.string)
          elseif l_1_0.status == -4 then
            showToast(i18n.global.guiidFight_toast_reg_end.string)
          else
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
            return 
          end
          upvalue_512 = clone(params)
          callBack(params)
          showToast(i18n.global.guildFight_setting_ac.string)
           -- Warning: missing end command somewhere! Added here
        end
         end)
      end)
    btnNo:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      curlayer:removeFromParentAndCleanup(true)
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
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(BG_WIDTH - 25, BG_HEIGHT - 25)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    if judgeSet() == false or  params.uids < MIXLIMIXTEAME then
      layer:removeFromParentAndCleanup()
      return 
    end
    layer:addChild(createCostDiamond(layer))
   end)
  local title = lbl.createFont1(26, i18n.global.arena3v3_btn_setting.string, ccc3(230, 208, 174))
  title:setPosition(BG_WIDTH / 2, BG_HEIGHT - 27)
  board:addChild(title, 1)
  local titleShade = lbl.createFont1(26, i18n.global.arena3v3_btn_setting.string, ccc3(89, 48, 27))
  titleShade:setPosition(BG_WIDTH / 2, BG_HEIGHT - 29)
  board:addChild(titleShade)
  local heroCampBg = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  heroCampBg:setPreferredSize(CCSize(884, 452))
  heroCampBg:setPosition(BG_WIDTH / 2, 265)
  board:addChild(heroCampBg)
  local selectTeamBg = img.createUI9Sprite(img.ui.select_tab_tab_bg)
  selectTeamBg:setPreferredSize(CCSize(840, 37))
  selectTeamBg:setPosition(442, 412)
  heroCampBg:addChild(selectTeamBg)
  local showPowerBg = img.createUISprite(img.ui.select_hero_power_bg)
  showPowerBg:setAnchorPoint(ccp(0, 0.5))
  showPowerBg:setPosition(0, 19)
  selectTeamBg:addChild(showPowerBg)
  local powerIcon = img.createUISprite(img.ui.team_icon)
  powerIcon:setPosition(27, 21)
  showPowerBg:addChild(powerIcon)
  local showteams = lbl.createFont2(20, string.format("%d/15",  params.uids), ccc3(255, 246, 223))
  showteams:setAnchorPoint(ccp(0, 0.5))
  showteams:setPosition(powerIcon:boundingBox():getMaxX() + 15, powerIcon:boundingBox():getMidY())
  showPowerBg:addChild(showteams)
  local btnSettingSprite = img.createLogin9Sprite(img.login.button_9_small_green)
  btnSettingSprite:setPreferredSize(CCSize(172, 44))
  local btnSettingLab = lbl.createFont1(16, i18n.global.guildFight_save_camp.string, ccc3(27, 89, 2))
  btnSettingLab:setPosition(btnSettingSprite:getContentSize().width / 2, btnSettingSprite:getContentSize().height / 2)
  btnSettingSprite:addChild(btnSettingLab)
  local btnSetting = SpineMenuItem:create(json.ui.button, btnSettingSprite)
  btnSetting:setPosition(754, 19)
  local menuSetting = CCMenu:createWithItem(btnSetting)
  menuSetting:setPosition(0, 0)
  selectTeamBg:addChild(menuSetting, 1)
  local scrolloffsety = 0
  local teamslayer, createteamlayer = nil, nil
  btnSetting:registerScriptTapHandler(function()
    audio.play(audio.button)
    if  teamsUid < MIXLIMIXTEAME then
      showToast(i18n.global.guildFight_mix_teams.string)
      return 
    end
    local paramss = {sid = player.sid, uids = teamsUid, mask = shadowUid}
    addWaitNet()
    net:guild_fight_lineup(paramss, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        if l_1_0.status == -1 then
          showToast(i18n.global.guildFight_mix_teams.string)
        elseif l_1_0.status == -2 then
          showToast(i18n.global.guildFight_shadow_limit.string)
        elseif l_1_0.status == -3 then
          showToast(i18n.global.guildFight_cant_subteam.string)
        elseif l_1_0.status == -4 then
          showToast(i18n.global.guiidFight_toast_reg_end.string)
        else
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        upvalue_512 = clone(params)
        callBack(params)
        showToast(i18n.global.guildFight_setting_ac.string)
         -- Warning: missing end command somewhere! Added here
      end
      end)
   end)
  local changepos = function(l_5_0, l_5_1, l_5_2)
    if l_5_1 ~= l_5_0 then
      if l_5_0 == 0 then
        table.insert(params.mbrs, params.mbrs[l_5_1])
        table.remove(params.mbrs, l_5_1)
      else
        params.mbrs[l_5_0], params.mbrs[l_5_1] = params.mbrs[l_5_1], params.mbrs[l_5_0]
      end
      if l_5_2 then
        local aUidpos, bUidpos = nil, nil
        for j = 1,  teamsUid do
          if params.mbrs[l_5_0].uid == teamsUid[j] then
            aUidpos = j
          end
          if params.mbrs[l_5_1].uid == teamsUid[j] then
            bUidpos = j
          end
        end
        teamsUid[aUidpos], teamsUid[bUidpos] = teamsUid[bUidpos], teamsUid[aUidpos]
      end
    end
    if teamslayer then
      upvalue_1536 = board.scroll:getContentOffset().y
      teamslayer:removeFromParentAndCleanup()
      upvalue_1024 = nil
      upvalue_1024 = createteamlayer()
      board:addChild(teamslayer)
    end
   end
  local createItem = function(l_6_0, l_6_1)
    local item = img.createUI9Sprite(img.ui.botton_fram_2)
    item:setPreferredSize(CCSizeMake(836, 100))
    local item_w = item:getContentSize().width
    local item_h = item:getContentSize().height
    if l_6_1 <=  teamsUid then
      local numlab = lbl.createFont1(16, l_6_1, ccc3(81, 39, 18))
      numlab:setPosition(37, item_h / 2)
      item:addChild(numlab)
    end
    local namelab = lbl.createFontTTF(16, l_6_0.name, ccc3(81, 39, 18))
    namelab:setAnchorPoint(0, 0.5)
    namelab:setPosition(67, 68)
    item:addChild(namelab)
    local showPowerBg = img.createUI9Sprite(img.ui.arena_frame7)
    showPowerBg:setPreferredSize(CCSize(140, 28))
    showPowerBg:setAnchorPoint(ccp(0, 0.5))
    showPowerBg:setPosition(72, 38)
    item:addChild(showPowerBg)
    local showPowerIcon = img.createUISprite(img.ui.power_icon)
    showPowerIcon:setScale(0.5)
    showPowerIcon:setPosition(10, showPowerBg:getContentSize().height / 2)
    showPowerBg:addChild(showPowerIcon)
    local showPower = lbl.createFont2(16, l_6_0.power)
    showPower:setPosition(showPowerBg:getContentSize().width / 2, showPower:getContentSize().height / 2 - 4)
    showPowerBg:addChild(showPower)
    local POSX = {1 = 265, 2 = 326, 3 = 400, 4 = 462, 5 = 524, 6 = 586}
    for i = 1, 6 do
      local showHero = nil
      if l_6_0.camp[i] and l_6_0.camp[i].pos ~= 7 then
        local param = {id = l_6_0.camp[i].id, lv = l_6_0.camp[i].lv, showGroup = true, showStar = true, wake = l_6_0.camp[i].wake, orangeFx = nil, petID = require("data.pet").getPetID(l_6_0.camp), skin = l_6_0.camp[i].skin}
        showHero = img.createHeroHeadByParam(param)
        showHero:setScale(0.6)
      else
        showHero = img.createUI9Sprite(img.ui.herolist_withouthero_bg)
        showHero:setPreferredSize(CCSize(59, 59))
      end
      showHero:setPosition(POSX[i] - 3, item:getContentSize().height / 2)
      item:addChild(showHero)
    end
    local open = true
    for ii = 1,  shadowUid do
      if shadowUid[ii] == l_6_0.uid then
        open = false
    else
      end
    end
    local shadowbg = img.createLogin9Sprite(img.login.button_9_small_gold)
    shadowbg:setPreferredSize(CCSize(54, 52))
    local openshadow = img.createUISprite(img.ui.guildFight_eye_open)
    openshadow:setPosition(shadowbg:getContentSize().width / 2, shadowbg:getContentSize().height / 2)
    openshadow:setVisible(open == true)
    shadowbg:addChild(openshadow)
    local closeshadow = img.createUISprite(img.ui.guildFight_eye_close)
    closeshadow:setPosition(shadowbg:getContentSize().width / 2, shadowbg:getContentSize().height / 2)
    closeshadow:setVisible(open ~= true)
    shadowbg:addChild(closeshadow)
    local shadowBtn = SpineMenuItem:create(json.ui.button, shadowbg)
    shadowBtn:setPosition(659, item:getContentSize().height / 2 + 2)
    if  teamsUid < l_6_1 then
      shadowBtn:setVisible(false)
    end
    local shadowmenu = CCMenu:createWithItem(shadowBtn)
    shadowmenu:setPosition(0, 0)
    item:addChild(shadowmenu)
    local exchangebg = img.createLogin9Sprite(img.login.button_9_small_gold)
    exchangebg:setPreferredSize(CCSize(54, 52))
    local exchange = img.createUISprite(img.ui.arena_new_switch)
    exchange:setScale(0.95)
    exchange:setPosition(exchangebg:getContentSize().width / 2, exchangebg:getContentSize().height / 2)
    exchangebg:addChild(exchange)
    local exchangeBtn = SpineMenuItem:create(json.ui.button, exchangebg)
    exchangeBtn:setPosition(723, item:getContentSize().height / 2 + 2)
    if  teamsUid < l_6_1 then
      exchangeBtn:setVisible(false)
    end
    local exchangemenu = CCMenu:createWithItem(exchangeBtn)
    exchangemenu:setPosition(0, 0)
    item:addChild(exchangemenu)
    local selectteam = false
    for ii = 1,  teamsUid do
      if teamsUid[ii] == l_6_0.uid then
        selectteam = true
    else
      end
    end
    local tickbg = img.createUISprite(img.ui.guildFight_tick_bg)
    local tick = img.createUISprite(img.ui.hook_btn_sel)
    tick:setScale(0.75)
    tick:setPosition(tickbg:getContentSize().width / 2 + 5, tickbg:getContentSize().height / 2 + 3)
    tickbg:addChild(tick)
    tick:setVisible(selectteam)
    local tickBtn = SpineMenuItem:create(json.ui.button, tickbg)
    tickBtn:setPosition(789, item:getContentSize().height / 2 + 3)
    local tickmenu = CCMenu:createWithItem(tickBtn)
    tickmenu:setPosition(0, 0)
    item:addChild(tickmenu)
    shadowBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if open == true then
        if MAXSHADOW <=  shadowUid then
          showToast(i18n.global.guildFight_shadow_limit.string)
          return 
        end
        openshadow:setVisible(false)
        closeshadow:setVisible(true)
        upvalue_512 = false
        showToast(i18n.global.guildFight_shadow_camp.string)
        shadowUid[ shadowUid + 1] = teamObj.uid
      else
        openshadow:setVisible(true)
        closeshadow:setVisible(false)
        upvalue_512 = true
        for i = 1,  shadowUid do
          if shadowUid[i] == teamObj.uid then
            table.remove(shadowUid, i)
        else
          end
        end
        showToast(i18n.global.guildFight_show_camp.string)
      end
      end)
    exchangeBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer:addChild(createChangePos(_idx,  teamsUid, changepos))
      end)
    tickBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if selectteam == false then
        if MAXLIMIXTEAME <=  teamsUid then
          showToast(i18n.global.guildFight_max_teams.string)
          return 
        end
        tick:setVisible(true)
        upvalue_512 = true
        teamsUid[ teamsUid + 1] = teamObj.uid
        showteams:setString(string.format("%d/15",  teamsUid))
        changepos( teamsUid, _idx)
      else
        tick:setVisible(false)
        upvalue_512 = false
        for i = 1,  teamsUid do
          if teamsUid[i] == teamObj.uid then
            table.remove(teamsUid, i)
        else
          end
        end
        for i = 1,  shadowUid do
          if shadowUid[i] == teamObj.uid then
            table.remove(shadowUid, i)
        else
          end
        end
        changepos(0, _idx)
        showteams:setString(string.format("%d/15",  teamsUid))
      end
      end)
    return item
   end
  local createScroll = function()
    local scroll_params = {width = 836, height = 365}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  createteamlayer = function(l_8_0)
    local tlayer = CCLayer:create()
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(48, 55))
    tlayer:addChild(scroll)
    board.scroll = scroll
    scroll.addSpace(4)
    for ii = 1,  params.mbrs do
      local tmp_item = createItem(params.mbrs[ii], ii)
      tmp_item.guildObj = params.mbrs[ii]
      tmp_item.ax = 0.5
      tmp_item.px = 418
      scroll.addItem(tmp_item)
      if ii ~=  params.mbrs then
        scroll.addSpace(space_height)
      end
    end
    if l_8_0 then
      scroll:setOffsetBegin()
    else
      scroll:setContentOffset(CCPoint(0, scrolloffsety))
    end
    return tlayer
   end
  teamslayer = createteamlayer(true)
  board:addChild(teamslayer)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

