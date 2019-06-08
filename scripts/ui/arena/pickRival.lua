-- Command line was: E:\github\dhgametool\scripts\ui\arena\pickRival.lua 

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
ui.create = function()
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(746, 520))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local showTitle = lbl.createFont1(26, i18n.global.arena_rivals_title.string, ccc3(230, 208, 174))
  showTitle:setPosition(board:getContentSize().width / 2, 490)
  board:addChild(showTitle, 1)
  local showTitleShade = lbl.createFont1(26, i18n.global.arena_rivals_title.string, ccc3(89, 48, 27))
  showTitleShade:setPosition(board:getContentSize().width / 2, 488)
  board:addChild(showTitleShade)
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(721, 492)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local titlePower = lbl.createMixFont1(15, i18n.global.arena_rivals_info.string, ccc3(96, 60, 38))
  titlePower:setAnchorPoint(ccp(0, 0))
  titlePower:setPosition(35, 436)
  board:addChild(titlePower)
  local refreshBg = img.createUI9Sprite(img.ui.select_tab_tab_bg)
  refreshBg:setAnchorPoint(ccp(0, 0))
  refreshBg:setPreferredSize(CCSize(679, 37))
  refreshBg:setPosition(35, 384)
  board:addChild(refreshBg)
  local showPowerBg = img.createUISprite(img.ui.select_hero_power_bg)
  showPowerBg:setAnchorPoint(ccp(0, 0.5))
  showPowerBg:setPosition(0, 19)
  refreshBg:addChild(showPowerBg)
  local powerIcon = img.createUISprite(img.ui.power_icon)
  powerIcon:setScale(0.46)
  powerIcon:setPosition(27, 21)
  showPowerBg:addChild(powerIcon)
  local showPower = lbl.createFont2(20, arenaData.power)
  showPower:setAnchorPoint(ccp(0, 0.5))
  showPower:setPosition(powerIcon:boundingBox():getMaxX() + 15, powerIcon:boundingBox():getMidY())
  showPowerBg:addChild(showPower)
  local btnRefreshSp = img.createLogin9Sprite(img.login.button_9_small_green)
  btnRefreshSp:setPreferredSize(CCSize(115, 46))
  local labRefresh = lbl.createFont1(16, i18n.global.arena_rivals_refresh.string, ccc3(35, 98, 5))
  labRefresh:setPosition(btnRefreshSp:getContentSize().width / 2, btnRefreshSp:getContentSize().height / 2)
  btnRefreshSp:addChild(labRefresh)
  local btnRefresh = SpineMenuItem:create(json.ui.button, btnRefreshSp)
  local menuRefresh = CCMenu:createWithItem(btnRefresh)
  menuRefresh:setPosition(0, 0)
  refreshBg:addChild(menuRefresh)
  btnRefresh:setPosition(622, 19)
  local innerBg = img.createUI9Sprite(img.ui.inner_bg)
  innerBg:setPreferredSize(CCSize(681, 334))
  innerBg:setAnchorPoint(ccp(0, 0))
  innerBg:setPosition(33, 32)
  board:addChild(innerBg)
  local oppoLayer = CCLayer:create()
  innerBg:addChild(oppoLayer)
  local loadRivals = function(l_2_0)
    oppoLayer:removeAllChildrenWithCleanup(true)
    for i,v in ipairs(l_2_0) do
      do
        if i > 3 then
          do return end
        end
        local oppoBg = img.createUI9Sprite(img.ui.botton_fram_2)
        do
          oppoBg:setPreferredSize(CCSize(655, 95))
          oppoBg:setAnchorPoint(ccp(0, 0))
          oppoBg:setPosition(13, innerBg:getContentSize().height - 105 * i - 5)
          oppoLayer:addChild(oppoBg)
          local showName = lbl.createFontTTF(18, v.name, ccc3(81, 39, 18))
          showName:setAnchorPoint(ccp(0, 0))
          showName:setPosition(98, 57)
          oppoBg:addChild(showName)
          local playerHeadSprite = img.createPlayerHead(v.logo, v.lv)
          playerHeadSprite:setScale(0.8)
          local playerHead = CCMenuItemSprite:create(playerHeadSprite, nil)
          local menuPlayerHead = CCMenu:createWithItem(playerHead)
          menuPlayerHead:setPosition(0, 0)
          playerHead:setPosition(56, 57)
          oppoBg:addChild(menuPlayerHead)
          playerHead:registerScriptTapHandler(function()
            audio.play(audio.button)
            layer:addChild(require("ui.tips.player").create(v), 100)
               end)
          local powerBg = img.createUI9Sprite(img.ui.arena_frame7)
          powerBg:setPreferredSize(CCSize(196, 28))
          powerBg:setAnchorPoint(ccp(0, 0))
          powerBg:setPosition(98, 19)
          oppoBg:addChild(powerBg)
          local powerIcon = img.createUISprite(img.ui.power_icon)
          powerIcon:setScale(0.5)
          powerIcon:setPosition(15, 14)
          powerBg:addChild(powerIcon)
          local showPower = lbl.createFont2(16, v.power)
          showPower:setAnchorPoint(ccp(0, 0.5))
          showPower:setPosition(43, 14)
          powerBg:addChild(showPower)
          local titleScore = lbl.createFont1(14, i18n.global.arena_rivals_score.string, ccc3(154, 106, 82))
          titleScore:setPosition(394, 57)
          oppoBg:addChild(titleScore)
          local showScore = lbl.createFont1(22, v.score, ccc3(164, 47, 40))
          showScore:setPosition(394, 38)
          oppoBg:addChild(showScore)
          local btnBattleSp = img.createLogin9Sprite(img.login.button_9_small_gold)
          btnBattleSp:setPreferredSize(CCSize(136, 52))
          local ticketIcon = img.createItemIcon(ITEM_ID_ARENA)
          ticketIcon:setScale(0.5)
          ticketIcon:setPosition(34, 26)
          btnBattleSp:addChild(ticketIcon)
          local ticketCost = 0
          if arenaData.fight <  cfgarena[1].cost then
            ticketCost = cfgarena[1].cost[arenaData.fight + 1]
          else
            ticketCost = cfgarena[1].cost[ cfgarena[1].cost]
          end
          local showCost = lbl.createFont2(14, ticketCost)
          showCost:setPosition(34, 16)
          btnBattleSp:addChild(showCost)
          local labFight = lbl.createFont1(16, i18n.global.arena_rivals_fight.string, ccc3(115, 59, 5))
          labFight:setPosition(90, 26)
          btnBattleSp:addChild(labFight)
          local btnBattle = SpineMenuItem:create(json.ui.button, btnBattleSp)
          local menuBattle = CCMenu:createWithItem(btnBattle)
          menuBattle:setPosition(0, 0)
          oppoBg:addChild(menuBattle)
          btnBattle:setPosition(574, 47)
          btnBattle:registerScriptTapHandler(function()
            disableObjAWhile(btnBattle)
            audio.play(audio.button)
            local havTicket = 0
            local item = bag.items.find(ITEM_ID_ARENA)
            if item then
              havTicket = item.num
            end
            if ticketCost <= havTicket then
              layer:addChild(require("ui.selecthero.main").create({type = "ArenaAtk", info = v, cost = ticketCost}))
            else
              layer:addChild(require("ui.arena.buy").create())
            end
               end)
        end
      end
    end
   end
  local onRefresh = function()
    local Rivals = arenaData.refresh()
    if  Rivals <= 0 then
      local params = {sid = player.sid, id = 1}
      addWaitNet()
      net:pvp_refresh(params, function(l_1_0)
        delWaitNet()
        if l_1_0.status and l_1_0.status == -1 then
          showToast(i18n.global.event_processing.string)
          return 
        end
        arenaData.rivals = l_1_0.rivals
        upvalue_1024 = arenaData.refresh()
        loadRivals(Rivals)
         end)
    end
    loadRivals(Rivals)
   end
  btnRefresh:registerScriptTapHandler(function()
    audio.play(audio.button)
    onRefresh()
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
  layer:registerScriptHandler(function(l_9_0)
    if l_9_0 == "enter" then
      onEnter()
    elseif l_9_0 == "exit" then
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

