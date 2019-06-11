-- Command line was: E:\github\dhgametool\scripts\ui\login\home.lua 

local ui = {}
local cjson = json
require("config")
require("framework.init")
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local userdata = require("data.userdata")
local TAG_POPUP_SWITCH = 100
local TAG_POPUP_NOTICE = 101
local TAG_POPUP_REPAIR = 102
ui.create = function()
  local layer = CCLayer:create()
  img.loadAll(img.packedLogin.common)
  img.loadAll(img.packedLogin.home)
  local suffix = "_us"
  if isAmazon() then
    suffix = "_us"
  else
    if isOnestore() then
      suffix = "_us"
    elseif APP_CHANNEL and APP_CHANNEL ~= "" then
      suffix = "_cn"
    else
      if i18n.getCurrentLanguage() == kLanguageChinese then
        suffix = "_cn"
      else
        if i18n.getCurrentLanguage() == kLanguageChineseTW then
          suffix = "_cn"
        end
      end
    end
  end
  layer:addChild(require("ui.login.accelerometer").create({enableAcc = true}))
  local hintBg = img.createLogin9Sprite(img.login.text_border_2)
  local hintWidth = view.physical.w
  hintBg:setPreferredSize(CCSize(hintWidth, 38 * view.minScale))
  hintBg:setAnchorPoint(ccp(0, 0))
  hintBg:setPosition(0, 0)
  layer:addChild(hintBg)
  local hint = lbl.createMixFont2(18, "", ccc3(255, 247, 229), true)
  hint:setPosition(view.midX, scaley(17))
  layer:addChild(hint)
  autoLayoutShift(hint)
  layer.setHint = function(l_1_0)
    if not tolua.isnull(hint) then
      hint:setString(l_1_0)
    end
   end
  layer.fadeHint = function()
    if not tolua.isnull(hint) and not tolua.isnull(hintBg) then
      local t = 1
      hint:runAction(CCRepeatForever:create(createSequence({})))
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

      hintBg:runAction(CCRepeatForever:create(createSequence({})))
    end
     -- Warning: undefined locals caused missing assignments!
   end
  local vlabel = lbl.createFont2(16, getVersion(), ccc3(255, 251, 217), true)
  vlabel:setAnchorPoint(ccp(1, 0))
  vlabel:setPosition(view.maxX, scaley(2))
  layer:addChild(vlabel, 1)
  autoLayoutShift(vlabel)
  local sp_tap_bg = img.createLoginSprite("loading_board.png")
  sp_tap_bg:setScale(view.minScale)
  sp_tap_bg:setPosition(scalep(480, 30))
  layer:addChild(sp_tap_bg)
  sp_tap_bg:setVisible(false)
  local lgg_short = i18n.getLanguageShortName()
  local sp_tap = img.createLoginSprite("loading_" .. lgg_short .. ".png")
  sp_tap:setPosition(CCPoint(sp_tap_bg:getContentSize().width / 2, sp_tap_bg:getContentSize().height / 2))
  sp_tap_bg:addChild(sp_tap)
  sp_tap:runAction(CCRepeatForever:create(createSequence({})))
  local ban = CCLayer:create()
  ban:setTouchEnabled(true)
  ban:setTouchSwallowEnabled(true)
  layer:addChild(ban, 100)
  local inited, started = nil, nil
  local pullGateAndNotice = function()
    schedule(layer, function()
      if not isNetAvailable() then
        ui.popErrorDialog(i18n.global.error_network_unavailable.string)
        return 
      end
      layer.setHint(i18n.global.get_best_gate_server.string)
      require("ui.login.gate").init(function(l_1_0, l_1_1)
        if l_1_0 ~= "ok" then
          ui.popErrorDialog(i18n.global.get_best_gate_server_fail.string)
          if reportRIpException then
            reportRIpException()
          end
          return 
        end
        schedule(layer, 2, function()
          ui.pullNotice(layer, gate, function(l_1_0)
            inited = true
            layer.setHint("")
            schedule(layer, 0.5, function()
              ui.popWelcome(layer)
                  end)
            schedule(layer, 2, function()
              ui.popNotice(layer)
              if ban and not tolua.isnull(ban) then
                ban:removeFromParent()
              end
              if APP_CHANNEL and APP_CHANNEL == "TX" then
                do return end
              end
              sp_tap_bg:setVisible(true)
              hintBg:setVisible(false)
                  end)
               end)
            end)
         end)
      end)
   end
  local isShowUserProtocol = function()
    if i18n.getLanguageShortName() == "cn" then
      return false
    end
    if APP_CHANNEL and APP_CHANNEL == "MRGAME" then
      return false
    end
    if APP_CHANNEL and APP_CHANNEL == "6KW" then
      return false
    end
    if APP_CHANNEL and APP_CHANNEL == "6KWYYB" then
      return false
    end
    return true
   end
   -- DECOMPILER ERROR: Overwrote pending register.

  if isShowUserProtocol() then
    local agreeBg = img.createLoginSprite(CCFadeTo:create(1.5, 25.5).login.guildFight_tick_bg)
    do
       -- DECOMPILER ERROR: Overwrote pending register.

      agreeBg:setScale(0.85)
      local icon_sel = img.createLoginSprite(img.login.hook_btn_sel)
      icon_sel:setScale(0.78)
      icon_sel:setAnchorPoint(CCPoint(0, 0))
      icon_sel:setPosition(CCPoint(2, 0))
      agreeBg:addChild(icon_sel)
      local empty = CCNode:create()
      empty:setContentSize(CCSizeMake(100, 100))
      empty:setScale(view.minScale)
      empty:addChild(agreeBg)
      local btn_check = SpineMenuItem:create(json.ui.button, empty)
      btn_check:setPosition(scalep(324, 75))
      btn_check:registerScriptTapHandler(function()
        audio.play(audio.button)
        local isAgree = userdata.getBool(userdata.keys.agree_user_protocol)
        icon_sel:setVisible( isAgree)
        userdata.setBool(userdata.keys.agree_user_protocol,  isAgree)
         end)
      local btn_check_menu = CCMenu:createWithItem(btn_check)
      btn_check_menu:setPosition(CCPoint(0, 0))
      layer:addChild(btn_check_menu)
      autoLayoutShift(btn_check)
      local des = img.createLoginSprite(img.login.login_home_protocol_des)
      des:setAnchorPoint(CCPoint(0, 0.5))
      des:setPosition(scalep(350, 75))
      des:setScale(view.minScale)
      layer:addChild(des)
      autoLayoutShift(des)
      local openSprite = img.createLoginSprite(img.login.login_home_protocol_open)
      local openMenuItem = CCMenuItemSprite:create(openSprite, nil)
      openMenuItem:setAnchorPoint(CCPoint(0, 0.5))
      openMenuItem:setPosition(scalep(482, 75))
      openMenuItem:setScale(view.minScale)
      openMenuItem:registerScriptTapHandler(function()
        audio.play(audio.button)
        device.openURL("https://www.dhgames.cn/other/ad/agreement.html")
         end)
      local openMenu = CCMenu:createWithItem(openMenuItem)
      openMenu:setPosition(CCPoint(0, 0))
      layer:addChild(openMenu)
      autoLayoutShift(openMenuItem)
      local updateProtocolStatus = function()
        local agree = userdata.getBool(userdata.keys.agree_user_protocol)
        icon_sel:setVisible(agree)
         end
      local setDefaultAgreeProtocol = function()
        local isAgreeString = userdata.getString(userdata.keys.agree_user_protocol)
        if not isAgreeString or isAgreeString == "" then
          userdata.setBool(userdata.keys.agree_user_protocol, true)
          updateProtocolStatus()
        end
         end
      do
        updateProtocolStatus()
        if isChannel() then
          setDefaultAgreeProtocol()
          pullGateAndNotice()
        else
          if userdata.getString("dhInstall", "") == "" then
            ui.popUserProtocol(layer, function()
          updateProtocolStatus()
          schedule(layer, 0.2, function()
            pullGateAndNotice()
               end)
            end, function()
          updateProtocolStatus()
          schedule(layer, 0.2, function()
            pullGateAndNotice()
               end)
            end)
          else
            setDefaultAgreeProtocol()
            pullGateAndNotice()
          end
        end
      end
    else
      pullGateAndNotice()
    end
    local accountBtn0 = img.createLoginSprite(img.login.login_btn_switch)
    local accountBtn = SpineMenuItem:create(json.ui.button, accountBtn0)
    accountBtn:setScale(view.minScale)
    accountBtn:setPosition(scalep(919, 540))
    local accountMenu = CCMenu:createWithItem(accountBtn)
    accountMenu:setPosition(0, 0)
    layer:addChild(accountMenu)
    accountBtn:registerScriptTapHandler(function()
      if inited and not started then
        audio.play(audio.button)
        ui.popSwitchDialog(layer, function(l_1_0)
          schedule(layer, 0.3, function()
            ui.popWelcome(layer, account)
               end)
            end)
      end
      end)
    local noticeBtn0 = img.createLoginSprite(img.login.login_btn_notice)
    local noticeBtn = SpineMenuItem:create(json.ui.button, noticeBtn0)
    noticeBtn:setScale(view.minScale)
    noticeBtn:setPosition(scalep(858, 540))
    local noticeMenu = CCMenu:createWithItem(noticeBtn)
    noticeMenu:setPosition(0, 0)
    layer:addChild(noticeMenu)
    noticeBtn:registerScriptTapHandler(function()
      if inited and not started then
        audio.play(audio.button)
        ui.popNotice(layer)
      end
      end)
    local repairBtn0 = img.createLoginSprite(img.login.login_btn_repair)
    local repairBtn = SpineMenuItem:create(json.ui.button, repairBtn0)
    repairBtn:setScale(view.minScale)
    repairBtn:setPosition(scalep(39, 540))
    local repairMenu = CCMenu:createWithItem(repairBtn)
    repairMenu:setPosition(0, 0)
    layer:addChild(repairMenu)
    repairBtn:registerScriptTapHandler(function()
      if inited and not started then
        audio.play(audio.button)
        ui.popRepairDialog(layer, function()
          if inited and not started then
            upvalue_512 = true
            ui.goUpdate(layer)
          end
            end)
      end
      end)
    autoLayoutShift(accountBtn)
    autoLayoutShift(noticeBtn, nil, nil, nil, true)
    autoLayoutShift(repairBtn)
    autoLayoutShift(sp_tap_bg, nil, true, nil, nil)
    addBackEvent(layer)
    layer.onAndroidBack = function()
      exitGame(layer)
      end
    layer:registerScriptHandler(function(l_15_0)
      if l_15_0 == "enter" then
        layer.notifyParentLock()
      elseif l_15_0 == "exit" then
        layer.notifyParentUnlock()
      end
      end)
    do
      local onTouch = function(l_16_0, l_16_1, l_16_2)
      if l_16_0 == "began" then
        return true
      elseif l_16_0 == "moved" then
        return 
      elseif inited and not started and l_16_2 < scaley(500) then
        local isAgree = userdata.getBool(userdata.keys.agree_user_protocol)
        if isShowUserProtocol() and not isAgree then
          showToast("\232\175\183\229\139\190\233\128\137\228\184\139\230\150\185\231\154\132\231\148\168\230\136\183\229\141\143\232\174\174\239\188\140\229\141\179\229\143\175\232\191\155\229\133\165\230\184\184\230\136\143")
          return 
        end
        upvalue_512 = true
        ui.goUpdate(layer, getVersion())
      end
      end
      if APP_CHANNEL and APP_CHANNEL == "TX" then
        accountBtn:setVisible(false)
        repairBtn:setVisible(false)
        noticeBtn:setVisible(false)
        hint:setVisible(false)
        sp_tap_bg:setVisible(false)
        local txlogin = require("ui.login.txlogin").create()
        txlogin:setScale(view.minScale)
        txlogin:setAnchorPoint(ccp(0, 0))
        txlogin:setPosition(scalep(0, 0))
        layer:addChild(txlogin, 200)
      elseif APP_CHANNEL and APP_CHANNEL == "MSDK" then
        local player = require("data.player")
        player.uid = nil
        player.sid = nil
        accountBtn:setVisible(false)
        repairBtn:setVisible(false)
        noticeBtn:setVisible(false)
        hint:setVisible(false)
        local btn_logout0 = img.createLogin9Sprite(img.login.button_9_gold)
        btn_logout0:setPreferredSize(CCSizeMake(80, 48))
        local lbl_logout = lbl.createMixFont1(18, "\230\179\168\233\148\128", ccc3(131, 65, 29))
        lbl_logout:setPosition(CCPoint(40, 24))
        btn_logout0:addChild(lbl_logout)
        local btn_logout = SpineMenuItem:create(json.ui.button, btn_logout0)
        btn_logout:setScale(view.minScale)
        btn_logout:setPosition(scalep(919, 540))
        local btn_logout_menu = CCMenu:createWithItem(btn_logout)
        btn_logout_menu:setPosition(CCPoint(0, 0))
        layer:addChild(btn_logout_menu)
        autoLayoutShift(btn_logout)
        btn_logout:setVisible(false)
        btn_logout:registerScriptTapHandler(function()
        audio.play(audio.button)
        local lparams = {which = "logout"}
        local lparamStr = cjson.encode(lparams)
        SDKHelper:getInstance():login(lparamStr, function(l_1_0)
          print("msdk logout data:", l_1_0)
          btn_logout:setVisible(false)
          hint:setVisible(false)
          local txlogin = require("ui.login.txlogin").create()
          txlogin:setScale(view.minScale)
          txlogin:setAnchorPoint(ccp(0, 0))
          txlogin:setPosition(scalep(0, 0))
          layer:addChild(txlogin, 200)
            end)
         end)
        SDKHelper:getInstance():initGame("", function(l_18_0)
        print("msdk initGame data:", l_18_0)
        if l_18_0 and l_18_0 == "wxcall2" then
          userdata.setString(userdata.keys.txwhich, "wx")
          require("ui.login.home").goUpdate(layer, getVersion())
        elseif l_18_0 and l_18_0 == "qqcall2" then
          userdata.setString(userdata.keys.txwhich, "qq")
          require("ui.login.home").goUpdate(layer, getVersion())
        end
        local player = require("data.player")
        if player.uid and player.sid then
          return 
        end
        if l_18_0 and l_18_0 == "wxcall" then
          userdata.setString(userdata.keys.txwhich, "wx")
          require("ui.login.home").goUpdate(layer, getVersion())
        elseif l_18_0 and l_18_0 == "qqcall" then
          userdata.setString(userdata.keys.txwhich, "qq")
          require("ui.login.home").goUpdate(layer, getVersion())
        end
         end)
        schedule(layer, 0.5, function()
        local params = {which = ""}
        print("start to check login")
        local paramStr = cjson.encode(params)
        SDKHelper:getInstance():login(paramStr, function(l_1_0)
          print("msdk prelogin data:", l_1_0)
          local data = cjson.decode(l_1_0)
          if data and data.platform == "none" then
            btn_logout:setVisible(false)
            local txlogin = require("ui.login.txlogin").create()
            txlogin:setScale(view.minScale)
            txlogin:setAnchorPoint(ccp(0, 0))
            txlogin:setPosition(scalep(0, 0))
            layer:addChild(txlogin, 200)
          elseif data and data.platform == "qq" then
            userdata.setString(userdata.keys.txwhich, "qq")
            btn_logout:setVisible(true)
            hint:setVisible(true)
            layer.setHint(i18n.global.start_game.string)
            layer:setTouchEnabled(true)
          elseif data and data.platform == "wx" then
            userdata.setString(userdata.keys.txwhich, "wx")
            btn_logout:setVisible(true)
            hint:setVisible(true)
            layer.setHint(i18n.global.start_game.string)
            layer:setTouchEnabled(true)
          elseif data and data.platform == "wxcall" then
            userdata.setString(userdata.keys.txwhich, "wx")
            require("ui.login.home").goUpdate(layer, getVersion())
          elseif data and data.platform == "qqcall" then
            userdata.setString(userdata.keys.txwhich, "qq")
            require("ui.login.home").goUpdate(layer, getVersion())
          end
          upvalue_3584 = true
          if ban and not tolua.isnull(ban) then
            ban:removeFromParent()
          end
            end)
         end)
      else
        if isChannel() then
          accountBtn:setVisible(false)
          repairBtn:setVisible(false)
          noticeBtn:setVisible(false)
        end
      end
      layer:registerScriptTouchHandler(onTouch)
      layer:setTouchEnabled(true)
      return layer
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.goUpdate = function(l_2_0, l_2_1)
  local time = 0
  if l_2_0 and l_2_0.bg and not tolua.isnull(l_2_0.bg) then
    time = l_2_0.bg:getFrameTime()
    l_2_0.bg:unscheduleUpdate()
  end
  if l_2_1 then
    replaceScene(require("ui.login.update").create(false, nil, time))
  else
    replaceScene(require("ui.login.update").create(true, nil, time))
  end
end

ui.popErrorDialog = function(l_3_0)
  if isChannel() then
    replaceScene(require("ui.login.home").create())
    return 
  end
  popReconnectDialog(l_3_0, function()
    replaceScene(require("ui.login.home").create())
   end)
end

ui.popSwitchDialog = function(l_4_0, l_4_1)
  if not l_4_0:getChildByTag(TAG_POPUP_SWITCH) then
    l_4_0:addChild(require("ui.login.input").create(l_4_1), 1000)
  end
end

ui.pullNotice = function(l_5_0, l_5_1, l_5_2)
  l_5_0.setHint(i18n.global.pull_notice.string)
  local pubs = (require("data.pubs"))
  local param = nil
  if pubs.init() then
    param = {sid = 0, language = pubs.language, vsn = pubs.vsn}
  else
    param = {sid = 0, language = i18n.getCurrentLanguage(), vsn = 0}
  end
  local isDone = false
  local net = require("net.netClient")
  net:connect({host = l_5_1.host, port = l_5_1.port}, function()
    if isDone then
      return 
    end
    net:pub(param, function(l_1_0)
      if not isDone then
        isDone = true
        if l_1_0.status < 0 then
          layer.setHint(i18n.global.pull_notice_fail.string .. l_1_0.status)
          return 
        end
        if l_1_0.status ~= 1 then
          pubs.save(l_1_0.language, l_1_0.vsn, l_1_0.pub)
        end
        pubs.print()
        net:close(function()
          if data.status == 1 then
            handler("cache")
          else
            handler("ok")
          end
            end)
      end
      end)
   end)
  schedule(l_5_0, NET_TIMEOUT, function()
    if not isDone then
      isDone = true
      net:close(function()
        ui.popErrorDialog(i18n.global.pull_notice_fail.string .. ": timeout")
         end)
    end
   end)
end

ui.popUserProtocol = function(l_6_0, l_6_1, l_6_2)
  l_6_0:addChild(require("ui.login.protocol").create(l_6_1, l_6_2), 400)
end

ui.popNotice = function(l_7_0)
  if APP_CHANNEL and APP_CHANNEL == "MSDK" then
    if ui.popped_notice then
      return 
    end
    ui.popped_notice = true
  end
  if not l_7_0:getChildByTag(TAG_POPUP_NOTICE) then
    l_7_0:addChild(require("ui.login.notice").create(), 300)
  end
end

ui.popRepairDialog = function(l_8_0, l_8_1)
  if not l_8_0:getChildByTag(TAG_POPUP_REPAIR) then
    local pop = require("ui.dialog").create({body = i18n.global.repair_mode.string, btn_count = 2, btn_text = {1 = i18n.global.dialog_button_cancel.string, 2 = i18n.global.dialog_button_confirm.string}, selected_btn = 0})
    do
      pop.setCallback(function(l_1_0)
        l_1_0.button:setEnabled(false)
        pop:removeFromParent()
        if l_1_0.selected_btn == 2 then
          onConfirm()
        end
         end)
      l_8_0:addChild(pop, 100)
    end
  end
end

ui.popWelcome = function(l_9_0, l_9_1)
  if not l_9_1 then
    l_9_1 = userdata.getString(userdata.keys.account)
  end
  if l_9_1 ~= "" then
    local str = string.format(i18n.global.welcome_player.string, l_9_1)
    local label = lbl.createFontTTF(20, str, ccc3(0, 0, 0))
    local w, h = label:boundingBox().size.width + 150, 70
    local bg = img.createLogin9Sprite(img.login.login_welcome_bg)
    bg:setPreferredSize(CCSize(w, h))
    bg:setScale(view.minScale)
    bg:setAnchorPoint(ccp(0.5, 0))
    bg:setPosition(view.midX, view.physical.h)
    l_9_0:addChild(bg, 500)
    local logo = img.createLoginSprite(img.login.login_welcome_logo)
    logo:setPosition(50, h / 2)
    bg:addChild(logo)
    label:setAnchorPoint(ccp(0, 0.5))
    label:setPosition(100, h / 2 - 1)
    bg:addChild(label)
    bg:runAction(createSequence({}))
  end
   -- Warning: undefined locals caused missing assignments!
end

return ui

