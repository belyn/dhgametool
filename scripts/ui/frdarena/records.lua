-- Command line was: E:\github\dhgametool\scripts\ui\frdarena\records.lua 

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
local cfgarena = require("config.arena")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local frdarena = require("data.frdarena")
ui.create = function(l_1_0)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(840, 533))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local innerBg = img.createUI9Sprite(img.ui.inner_bg)
  innerBg:setPreferredSize(CCSize(790, 438))
  innerBg:setAnchorPoint(ccp(0.5, 0))
  innerBg:setPosition(board:getContentSize().width / 2, 27)
  board:addChild(innerBg)
  local showTitle = lbl.createFont1(26, i18n.global.arena_records_title.string, ccc3(230, 208, 174))
  showTitle:setPosition(board:getContentSize().width / 2, 504)
  board:addChild(showTitle, 1)
  local showTitleShade = lbl.createFont1(26, i18n.global.arena_records_title.string, ccc3(89, 48, 27))
  showTitleShade:setPosition(board:getContentSize().width / 2, 502)
  board:addChild(showTitleShade)
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(810, 507)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local createRecords = function(l_2_0, l_2_1)
    if not l_2_0 then
      local logs = clone({})
    end
    for i = 1,  logs / 2 do
      logs[i], logs[ logs - i + 1] = logs[ logs - i + 1], logs[i]
    end
    local height = 105 *  logs
    if  logs >= 10 then
      height = 1050
    end
    local scroll = CCScrollView:create()
    do
      scroll:setDirection(kCCScrollViewDirectionVertical)
      scroll:setAnchorPoint(ccp(0, 0))
      scroll:setPosition(10, 1)
      scroll:setViewSize(CCSize(778, 435))
      scroll:setContentSize(CCSize(778, height))
      scroll:setContentOffset(ccp(0, 435 - height))
      innerBg:addChild(scroll)
      if  logs == 0 then
        local empty = require("ui.empty").create({text = i18n.global.empty_battlerec.string})
        empty:setPosition(innerBg:getContentSize().width / 2, innerBg:getContentSize().height / 2)
        innerBg:addChild(empty, 0, 101)
      end
      do
        for i,v in ipairs(logs) do
          if i > 10 then
            do return end
          end
          local recordBg = img.createUI9Sprite(img.ui.botton_fram_2)
          recordBg:setPreferredSize(CCSize(770, 95))
          recordBg:setAnchorPoint(ccp(0.5, 0))
          recordBg:setPosition(385, height - 105 * i)
          scroll:getContainer():addChild(recordBg)
          if v.log_id then
            local btnVideoSprite = img.createUISprite(img.ui.arena_button_video)
            local btnVideo = SpineMenuItem:create(json.ui.button, btnVideoSprite)
            btnVideo:setPosition(52, 49)
            local menuVideo = CCMenu:createWithItem(btnVideo)
            menuVideo:setPosition(0, 0)
            recordBg:addChild(menuVideo)
            local onVideo = function()
              local params = {sid = player.sid, log_id = v.log_id}
              tbl2string(params)
              addWaitNet()
              net:gpvp_wlog(params, function(l_1_0)
                delWaitNet()
                tbl2string(l_1_0)
                if l_1_0.status < 0 then
                  showToast("status:" .. l_1_0.status)
                  return 
                end
                layer:addChild(require("ui.frdarena.videoDetail").create(l_1_0, i, orgData), 10000)
                     end)
                  end
            btnVideo:registerScriptTapHandler(function()
              audio.play(audio.button)
              onVideo()
                  end)
            if uiParams and i == uiParams.id then
              onVideo()
            end
          end
          for i = 1, 3 do
            local showHead = img.createPlayerHeadForArena(v.enemy.mbrs[i].logo, v.enemy.mbrs[i].lv)
            showHead:setScale(0.7)
            showHead:setPosition(142 + (i - 1) * 65, 48)
            recordBg:addChild(showHead)
          end
          local showName = lbl.createFontTTF(18, v.enemy.name, ccc3(114, 72, 53))
          showName:setAnchorPoint(ccp(0, 0))
          showName:setPosition(336, 49)
          recordBg:addChild(showName)
          local str = nil
          print(os.time() - v.time)
          if os.time() - v.time >= 86400 then
            str = math.floor((os.time() - v.time) / 3600 / 24) .. " " .. i18n.global.arena_records_days.string
          else
            if os.time() - v.time >= 3600 then
              str = math.floor((os.time() - v.time) / 3600) .. " " .. i18n.global.arena_records_hours.string
            else
              if os.time() - v.time >= 60 then
                str = math.floor((os.time() - v.time) / 60) .. " " .. i18n.global.arena_records_minutes.string
              else
                str = i18n.global.arena_records_times.string
              end
            end
          end
          local showTime = lbl.createFont1(16, str, ccc3(160, 124, 96))
          showTime:setAnchorPoint(ccp(0, 0))
          showTime:setPosition(336, 24)
          recordBg:addChild(showTime)
          local titleScore = lbl.createFont1(14, i18n.global.arena_records_score.string, ccc3(160, 124, 96))
          titleScore:setPosition(700, 60)
          recordBg:addChild(titleScore)
          local showScore = lbl.createFont1(20, v.score, ccc3(225, 89, 82))
          showScore:setPosition(700, 36)
          recordBg:addChild(showScore)
          if v.score > 0 then
            showScore:setString("+" .. v.score)
          end
          local showResult = nil
          if v.win == false then
            showResult = img.createUISprite(img.ui.arena_icon_lost)
            showScore:setColor(ccc3(91, 147, 2))
          else
            showResult = img.createUISprite(img.ui.arena_icon_win)
          end
          showResult:setPosition(546, 47)
          recordBg:addChild(showResult)
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  layer:registerScriptTouchHandler(function()
    return true
   end)
  layer:setTouchEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  local onEnter = function()
    if uiParams and uiParams.__data then
      createRecords(uiParams.__data.logs, uiParams.__data)
    else
      local params = {sid = player.sid, log_id = frdarena.team.id}
      addWaitNet()
      net:gpvp_logs(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        createRecords(l_1_0.logs, l_1_0)
         end)
    end
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_7_0)
    if l_7_0 == "enter" then
      onEnter()
    elseif l_7_0 == "exit" then
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

