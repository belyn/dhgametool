-- Command line was: E:\github\dhgametool\scripts\ui\player\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local player = require("data.player")
local audio = require("res.audio")
ui.create = function()
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(536, 408))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local showTitle = lbl.createFont1(26, i18n.global.player_title.string, ccc3(230, 208, 174))
  showTitle:setPosition(board:getContentSize().width / 2, 378)
  board:addChild(showTitle, 1)
  local showTitleShade = lbl.createFont1(26, i18n.global.player_title.string, ccc3(89, 48, 27))
  showTitleShade:setPosition(board:getContentSize().width / 2, 376)
  board:addChild(showTitleShade)
  local btnCloseSp = img.createLoginSprite(img.login.button_close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSp)
  btnClose:setPosition(511, 381)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local showNameBg = img.createUI9Sprite(img.ui.playerInfo_name_bg)
  showNameBg:setPreferredSize(CCSize(252, 35))
  showNameBg:setPosition(board:getContentSize().width / 2, 315)
  board:addChild(showNameBg)
  local showName = lbl.createFontTTF(20, player.name, ccc3(81, 39, 18))
  showName:setPosition(showNameBg:getContentSize().width / 2, showNameBg:getContentSize().height / 2)
  showNameBg:addChild(showName)
  layer.name = player.name
  local btnChangeSp = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnChangeSp:setPreferredSize(CCSize(60, 40))
  local btnChangeSpIcon = img.createUISprite(img.ui.playerInfo_button_change)
  btnChangeSpIcon:setPosition(btnChangeSp:getContentSize().width / 2, btnChangeSp:getContentSize().height / 2 + 1)
  btnChangeSp:addChild(btnChangeSpIcon)
  local btnChange = SpineMenuItem:create(json.ui.button, btnChangeSp)
  btnChange:setPosition(showNameBg:boundingBox():getMaxX() + 45, showNameBg:getPositionY())
  local menuChange = CCMenu:createWithItem(btnChange)
  menuChange:setPosition(0, 0)
  board:addChild(menuChange)
  btnChange:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.player.changename").create(), 100)
   end)
  local showID = lbl.createFont1(18, "ID " .. player.uid, ccc3(81, 39, 18))
  showID:setPosition(board:getContentSize().width / 2, 278)
  board:addChild(showID)
  local menuHead = nil
  local showHeadSprite = img.createPlayerHead(player.logo)
  local headData = require("data.head")
  if headData.showRedDot() then
    addRedDot(showHeadSprite, {px = showHeadSprite:getContentSize().width - 10, py = showHeadSprite:getContentSize().height - 10})
  end
  local showHead = HHMenuItem:createWithScale(showHeadSprite, 1)
  showHead:setPosition(board:getContentSize().width / 2, 216)
  menuHead = CCMenu:createWithItem(showHead)
  menuHead:setPosition(0, 0)
  board:addChild(menuHead)
  layer.logo = player.logo
  showHead:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.player.changehead").create(), 100)
   end)
  local showPlayerInfoBg = img.createUISprite(img.ui.playerInfo_info_bg)
  showPlayerInfoBg:setPosition(board:getContentSize().width / 2, 122)
  board:addChild(showPlayerInfoBg)
  local titleLv = lbl.createFont1(24, "Lv.", ccc3(225, 220, 96))
  titleLv:setAnchorPoint(ccp(1, 0))
  titleLv:setPosition(showPlayerInfoBg:getContentSize().width / 2, 46)
  showPlayerInfoBg:addChild(titleLv)
  local showLv = lbl.createFont1(24, player.lv(), ccc3(246, 252, 248))
  showLv:setAnchorPoint(ccp(0, 0))
  showLv:setPosition(showPlayerInfoBg:getContentSize().width / 2, 46)
  showPlayerInfoBg:addChild(showLv)
  local showGuild = lbl.createFontTTF(20, player.gname, ccc3(38, 24, 15))
  showGuild:setAnchorPoint(ccp(0.5, 0))
  showGuild:setPosition(showPlayerInfoBg:getContentSize().width / 2, 8)
  showPlayerInfoBg:addChild(showGuild)
  local showExpBg = img.createUISprite(img.ui.playerInfo_exp_bg)
  showExpBg:setPosition(board:getContentSize().width / 2, 52)
  board:addChild(showExpBg)
  local showExpBarBg = img.createUISprite(img.ui.playerInfo_process_bar_bg)
  showExpBarBg:setAnchorPoint(ccp(0, 0.5))
  showExpBarBg:setPosition(50, showExpBg:getContentSize().height / 2)
  showExpBg:addChild(showExpBarBg)
  local lv, curExp, nextExp = player.lv()
  if not curExp then
    curExp = 1
    nextExp = 1
  end
  local showExpBarSp = img.createUISprite(img.ui.playerInfo_process_bar_fg)
  local showExpBar = createProgressBar(showExpBarSp)
  showExpBar:setAnchorPoint(ccp(0, 0.5))
  showExpBar:setPosition(2, showExpBarBg:getContentSize().height / 2)
  showExpBar:setPercentage(curExp / nextExp * 100)
  showExpBarBg:addChild(showExpBar)
  local showExp = lbl.createFont2(18, i18n.global.player_exp_max.string, ccc3(255, 237, 248))
  if lv ~= player.maxLv() then
    showExp:setString(curExp .. "/" .. nextExp)
  end
  showExp:setPosition(219, showExpBg:getContentSize().height / 2 + 10)
  showExpBg:addChild(showExp, 1)
  local setInfo = function()
   end
  layer:scheduleUpdateWithPriorityLua(function()
    if layer.logo ~= player.logo then
      layer.logo = player.logo
      menuHead:removeFromParentAndCleanup(true)
      local showHeadSprite = img.createPlayerHead(player.logo, player.lv())
      local showHead = HHMenuItem:createWithScale(showHeadSprite, 1)
      showHead:setPosition(board:getContentSize().width / 2, 216)
      upvalue_1024 = CCMenu:createWithItem(showHead)
      menuHead:setPosition(0, 0)
      board:addChild(menuHead)
      showHead:registerScriptTapHandler(function()
        audio.play(audio.button)
        layer:addChild(require("ui.player.changehead").create(), 100)
         end)
    end
    if layer.name ~= player.name then
      layer.name = player.name
      showName:setString(player.name)
    end
    local headData = require("data.head")
    if headData.showRedDot() then
      addRedDot(showHeadSprite, {px = showHeadSprite:getContentSize().width - 10, py = showHeadSprite:getContentSize().height - 10})
    else
      delRedDot(showHeadSprite)
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
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_10_0)
    if l_10_0 == "enter" then
      onEnter()
    elseif l_10_0 == "exit" then
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

