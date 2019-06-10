-- Command line was: E:\github\dhgametool\scripts\ui\tips\player1.lua 

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
local TIPS_WIDTH = 516
local TIPS_HEIGHT = 342
local BUTTON_POSX = {1 = {258}, 2 = {470, 258, 102, 102}, 3 = {100, 262, 424}}
local COLOR2TYPE = {1 = img.login.button_9_small_gold, 2 = img.login.button_9_small_orange}
tips.create = function(l_1_0, l_1_1, l_1_2)
  local layer = CCLayer:create()
  local guildName = l_1_0.guild or ""
  local board = img.createUI9Sprite(img.ui.tips_bg)
  board:setPreferredSize(CCSize(TIPS_WIDTH, TIPS_HEIGHT))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  layer.board = board
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
    deletparams.body = string.format(i18n.global.friend_sure_delete.string)
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
      param.rm = params.uid
      addWaitNet()
      net:frd_op(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        friend.delFriendsList(params.frd)
        layer:removeFromParentAndCleanup(true)
        callBack()
        showToast(i18n.global.friend_delete_success.string)
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
    return dialoglayer
   end
  if friend.friends.friendsList and l_1_1 ~= "del" then
    for i,obj in ipairs(friend.friends.friendsList) do
      if obj.name == l_1_0.name then
        l_1_1 = "none"
    else
      end
    end
    local btnConfig = {1 = {text = "", Color = 1}, 2 = {text = i18n.global.friend_mail.string, Color = 1}, 3 = {text = i18n.global.chat_shield.string, Color = 1}}
    local btn = {}
    do
      btnConfig[1].handler = function()
        audio.play(audio.button)
        if way == "del" then
          local dialog = createdelete()
          layer:addChild(dialog, 300)
        else
          if friend.friends.friendsList and #friend.friends.friendsList >= 30 then
            showToast(i18n.global.friend_friends_limit.string)
            return 
          end
          local param = {}
          param.sid = player.sid
          param.apply = params.uid
          addWaitNet()
          net:frd_op(param, function(l_1_0)
            delWaitNet()
            tbl2string(l_1_0)
            if l_1_0.status == -1 then
              showToast(i18n.global.friend_are_friend.string)
              return 
            end
            if l_1_0.status ~= 0 then
              showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
              return 
            end
            if params.frd then
              friend.delFriendsRecmd(params.frd)
              callBack()
            end
            if layer and not tolua.isnull(layer) then
              layer:removeFromParentAndCleanup(true)
            end
            showToast(i18n.global.friend_apply_succese.string)
               end)
        end
         end
      btnConfig[2].handler = function()
        audio.play(audio.button)
        local maillayer = require("ui.mail.main")
        local mParams = {tab = maillayer.TAB.NEW, sendto = params.uid, close = true}
        layer:addChild(maillayer.create(mParams), 100)
         end
      local createshield = function()
        local paramss = {}
        paramss.btn_count = 0
        paramss.body = i18n.global.chat_sure_shield.string
        local dialoglayer = require("ui.dialog").create(paramss)
        local btnYesSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
        btnYesSprite:setPreferredSize(CCSize(153, 50))
        local btnYes = SpineMenuItem:create(json.ui.button, btnYesSprite)
        btnYes:setPosition(340, 100)
        local labYes = lbl.createFont1(18, i18n.global.dialog_button_confirm.string, ccc3(115, 59, 5))
        labYes:setPosition(btnYes:getContentSize().width / 2, btnYes:getContentSize().height / 2)
        btnYesSprite:addChild(labYes)
        local menuYes = CCMenu:create()
        menuYes:setPosition(0, 0)
        menuYes:addChild(btnYes)
        dialoglayer.board:addChild(menuYes)
        local btnNoSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
        btnNoSprite:setPreferredSize(CCSize(153, 50))
        local btnNo = SpineMenuItem:create(json.ui.button, btnNoSprite)
        btnNo:setPosition(150, 100)
        local labNo = lbl.createFont1(18, i18n.global.dialog_button_cancel.string, ccc3(115, 59, 5))
        labNo:setPosition(btnNo:getContentSize().width / 2, btnNo:getContentSize().height / 2)
        btnNoSprite:addChild(labNo)
        local menuNo = CCMenu:create()
        menuNo:setPosition(0, 0)
        menuNo:addChild(btnNo)
        dialoglayer.board:addChild(menuNo)
        btnYes:registerScriptTapHandler(function()
          dialoglayer:removeFromParentAndCleanup(true)
          audio.play(audio.button)
          local param = {}
          param.sid = player.sid
          param.uid = params.uid
          addWaitNet()
          net:block_chat(param, function(l_1_0)
            delWaitNet()
            tbl2string(l_1_0)
            if l_1_0.status ~= 0 then
              showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
              return 
            end
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
        return dialoglayer
         end
      btnConfig[3].handler = function()
        local dialog = createshield()
        layer:addChild(dialog, 300)
         end
      for i,v in ipairs(btnConfig) do
        local btnSp, menu = nil, nil
        if i == 1 then
          if l_1_1 == "del" then
            btnSp = img.createUISprite(img.ui.player_deletefrd)
          else
            btnSp = img.createUISprite(img.ui.player_addfrd)
          end
          btn[i] = SpineMenuItem:create(json.ui.button, btnSp)
          btn[i]:setPosition(BUTTON_POSX[2][i], TIPS_HEIGHT - 48)
          menu = CCMenu:createWithItem(btn[i])
          menu:setPosition(0, 0)
          board:addChild(menu)
        else
          btnSp = img.createLogin9Sprite(COLOR2TYPE[v.Color])
          btnSp:setPreferredSize(CCSize(148, 46))
          btn[i] = SpineMenuItem:create(json.ui.button, btnSp)
          btn[i]:setPosition(BUTTON_POSX[2][i], TIPS_HEIGHT - 296)
          menu = CCMenu:createWithItem(btn[i])
          menu:setPosition(0, 0)
          board:addChild(menu)
          local label, icon = nil, nil
          if i == 2 then
            icon = img.createUISprite(img.ui.player_sendmail)
            icon:setPosition(btnSp:getContentSize().width / 5 - 2, btnSp:getContentSize().height / 2 + 1)
            label = lbl.createFont1(16, v.text or "", ccc3(118, 37, 5))
            label:setPosition(icon:boundingBox():getMaxX() + 50, btnSp:getContentSize().height / 2 + 1)
          end
          if i == 3 then
            icon = img.createUISprite(img.ui.player_block)
            icon:setPosition(btnSp:getContentSize().width / 5 - 2, btnSp:getContentSize().height / 2 + 1)
            label = lbl.createFont1(16, v.text or "", ccc3(118, 37, 5))
            label:setPosition(icon:boundingBox():getMaxX() + 50, btnSp:getContentSize().height / 2 + 1)
          end
          if i == 4 then
            icon = img.createUISprite(img.ui.player_report)
            icon:setPosition(btnSp:getContentSize().width / 5 - 2, btnSp:getContentSize().height / 2 + 1)
            label = lbl.createFont1(16, v.text or "", ccc3(122, 40, 19))
            label:setPosition(icon:boundingBox():getMaxX() + 50, btnSp:getContentSize().height / 2 + 1)
          end
          btnSp:addChild(icon)
          btnSp:addChild(label)
        end
        if v.handler then
          btn[i]:registerScriptTapHandler(function()
          audio.play(audio.button)
          v.handler()
            end)
        end
        if l_1_1 == "none" and i == 1 then
          btn[i]:setVisible(false)
        end
        if i == 4 and l_1_0.report == nil then
          btn[i]:setVisible(false)
        end
      end
      local onCreate = function(l_7_0)
        local showGuild = lbl.createFontTTF(18, l_7_0.gname or guildName)
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
        local showPower = lbl.createFont2(22, l_7_0.power or 0)
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
        if not l_7_0.heroes then
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
      local touchbeginx, touchbeginy, isclick = nil, nil, nil
      local onTouchBegan = function(l_8_0, l_8_1)
        touchbeginx, upvalue_512 = l_8_0, l_8_1
        upvalue_1024 = true
        return true
         end
      local onTouchMoved = function(l_9_0, l_9_1)
        if isclick and (math.abs(touchbeginx - l_9_0) > 10 or math.abs(touchbeginy - l_9_1) > 10) then
          isclick = false
        end
         end
      local onTouchEnded = function(l_10_0, l_10_1)
        if not outside_remove and params.btn_count ~= nil and params.btn_count > 0 then
          return 
        end
        print("toucheend")
        if isclick and not board:boundingBox():containsPoint(ccp(l_10_0, l_10_1)) then
          layer:removeFromParentAndCleanup(true)
        end
         end
      local onTouch = function(l_11_0, l_11_1, l_11_2)
        if l_11_0 == "began" then
          return onTouchBegan(l_11_1, l_11_2)
        elseif l_11_0 == "moved" then
          return onTouchMoved(l_11_1, l_11_2)
        else
          return onTouchEnded(l_11_1, l_11_2)
        end
         end
      layer:registerScriptTouchHandler(onTouch, false, -128, false)
      layer:setTouchEnabled(true)
      addBackEvent(layer)
      layer.onAndroidBack = function()
        layer:removeFromParentAndCleanup(true)
         end
      local onEnter = function()
        layer.notifyParentLock()
        local params = {sid = player.sid, uid = params.uid}
        addWaitNet()
        net:player(params, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          onCreate(l_1_0)
          if l_1_0.report == 1 then
            setShader(btn[4], SHADER_GRAY, true)
            btn[4]:setEnabled(false)
          end
            end)
         end
      local onExit = function()
        layer.notifyParentUnlock()
         end
      layer:registerScriptHandler(function(l_15_0)
        if l_15_0 == "enter" then
          onEnter()
        elseif l_15_0 == "exit" then
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
     -- Warning: missing end command somewhere! Added here
  end
end

return tips

