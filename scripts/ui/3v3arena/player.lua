-- Command line was: E:\github\dhgametool\scripts\ui\3v3arena\player.lua 

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
local TIPS_WIDTH = 524
local TIPS_HEIGHT = 462
local BUTTON_POSX = {1 = {258}, 2 = {163, 351}, 3 = {100, 262, 424}}
local COLOR2TYPE = {1 = img.login.button_9_small_gold, 2 = img.login.button_9_small_orange}
tips.create = function(l_1_0)
  local layer = CCLayer:create()
  local guildName = l_1_0.guild or ""
  if l_1_0.buttons then
    TIPS_HEIGHT = 342
  end
  local board = img.createUI9Sprite(img.ui.tips_bg)
  board:setPreferredSize(CCSize(TIPS_WIDTH, TIPS_HEIGHT))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  layer.board = board
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = HHMenuItem:create(btnCloseSprite)
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
  showName:setPosition(118, TIPS_HEIGHT - 52)
  board:addChild(showName)
  local showID = lbl.createFont1(16, "ID " .. l_1_0.uid, ccc3(255, 246, 223))
  showID:setAnchorPoint(ccp(0, 0))
  showID:setPosition(118, TIPS_HEIGHT - 85)
  board:addChild(showID)
  local titleGuild = lbl.createFont2(18, i18n.global.tips_player_guild.string .. ":", ccc3(237, 203, 31))
  titleGuild:setAnchorPoint(ccp(0, 0))
  titleGuild:setPosition(118, TIPS_HEIGHT - 110)
  board:addChild(titleGuild)
  local serverBg = img.createUISprite(img.ui.anrea_server_bg)
  serverBg:setPosition(270, showName:getPositionY() + showName:getContentSize().height * showName:getScaleX() * 0.5)
  board:addChild(serverBg)
  local serverLabel = lbl.createFont1(16, getSidname(l_1_0.sid), ccc3(255, 251, 215))
  serverLabel:setPosition(serverBg:getContentSize().width * 0.5, serverBg:getContentSize().height * 0.5)
  serverBg:addChild(serverLabel)
  if l_1_0.buttons then
    for i,v in ipairs(l_1_0.buttons) do
      do
        local btnSp = img.createLogin9Sprite(COLOR2TYPE[v.Color])
        if #l_1_0.buttons == 3 then
          btnSp:setPreferredSize(CCSize(150, 50))
        else
          btnSp:setPreferredSize(CCSize(118, 50))
        end
        local btn = HHMenuItem:create(btnSp)
        btn:setPosition(BUTTON_POSX[#l_1_0.buttons][i], TIPS_HEIGHT - 296)
        local menu = CCMenu:createWithItem(btn)
        menu:setPosition(0, 0)
        board:addChild(menu)
        local label = lbl.createFont1(18, v.text or "", ccc3(115, 59, 5))
        label:setPosition(btn:getContentSize().width / 2, btn:getContentSize().height / 2)
        btn:addChild(label)
        if v.handler then
          btn:registerScriptTapHandler(function()
          audio.play(audio.button)
          v.handler()
            end)
        end
      end
    end
  end
  local onCreate = function(l_3_0)
    local showGuild = lbl.createFontTTF(18, l_3_0.gname or guildName)
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
    local showPower = lbl.createFont2(22, l_3_0.power or 0)
    showPower:setAnchorPoint(ccp(1, 0.5))
    showPower:setPosition(fgLine:boundingBox():getMaxX(), TIPS_HEIGHT - 148)
    board:addChild(showPower)
    local powerIcon = img.createUISprite(img.ui.power_icon)
    powerIcon:setScale(0.48)
    powerIcon:setAnchorPoint(ccp(1, 0.5))
    powerIcon:setPosition(showPower:boundingBox():getMinX() - 10, TIPS_HEIGHT - 148)
    board:addChild(powerIcon)
    local hids = {}
    if not l_3_0.heroes then
      local pheroes = {}
    end
    for i,v in ipairs(pheroes) do
      hids[v.pos] = v
    end
    print("\229\134\160\229\134\155\232\175\149\231\130\188\230\159\165\231\156\139\229\175\185\230\137\139\229\138\160\229\133\165\229\174\160\231\137\169\233\152\181\229\174\185")
    local petID = {}
    petID[19] = 501
    petID[20] = 401
    petID[21] = 301
    for i = 19, 21 do
      print("i = " .. i)
      if hids[i] ~= nil then
        petID[i - 18] = hids[i].id
      end
    end
    print("\229\134\160\229\134\155\232\175\149\231\130\188\230\159\165\231\156\139\229\175\185\230\137\139\229\138\160\229\133\165\229\174\160\231\137\169\233\152\181\229\174\185")
    local addHero = function(l_1_0)
      local POSX = {1 = 23, 2 = 98, 3 = 198, 4 = 273, 5 = 348, 6 = 423}
      local offset = (l_1_0 - 1) * 6
      local y = TIPS_HEIGHT - 252 - (l_1_0 - 1) * 80
      for i = 1 + offset, 6 + offset do
        local showHero = nil
        if l_1_0 == 3 then
          showHero = img.createUISprite(img.ui.herolist_head_bg)
          local icon = img.createUISprite(img.ui.arena_new_question)
          icon:setPosition(showHero:getContentSize().width * 0.5, showHero:getContentSize().height * 0.5)
          showHero:addChild(icon)
        else
          if hids[i] then
            local param = {id = hids[i].id, lv = hids[i].lv, showGroup = true, showStar = true, wake = hids[i].wake, orangeFx = nil, petID = petID[l_1_0], skin = hids[i].skin}
            showHero = img.createHeroHeadByParam(param)
          else
            showHero = img.createUISprite(img.ui.herolist_head_bg)
          end
        end
        showHero:setAnchorPoint(ccp(0, 0))
        showHero:setScale(0.75)
        showHero:setPosition(POSX[i - offset], y)
        board:addChild(showHero)
      end
      end
    addHero(1)
    addHero(2)
    addHero(3)
   end
  layer:registerScriptTouchHandler(function()
    return true
   end)
  layer:setTouchEnabled(true)
  local onEnter = function()
    local netParams = {sid = player.sid, uid = params.uid, svr_id = params.sid}
    addWaitNet()
    net:player(netParams, function(l_1_0)
      delWaitNet()
      onCreate(l_1_0)
      end)
   end
  local onExit = function()
   end
  layer:registerScriptHandler(function(l_7_0)
    if l_7_0 == "enter" then
      onEnter()
    elseif l_7_0 == "exit" then
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

