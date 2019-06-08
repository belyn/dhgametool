-- Command line was: E:\github\dhgametool\scripts\ui\frdarena\teaminfotips.lua 

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
local TIPS_WIDTH = 538
local TIPS_HEIGHT = 465
local COLOR2TYPE = {1 = img.login.button_9_small_orange}
tips.create = function(l_1_0)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local guildName = ""
  local board = img.createUI9Sprite(img.ui.tips_bg)
  board:setPreferredSize(CCSize(TIPS_WIDTH, TIPS_HEIGHT))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  layer.board = board
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(TIPS_WIDTH - 26, TIPS_HEIGHT - 26)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local showName = lbl.createFontTTF(20, l_1_0.name, ccc3(255, 255, 255))
  showName:setPosition(TIPS_WIDTH / 2, TIPS_HEIGHT - 35)
  board:addChild(showName)
  local sevbg = img.createUISprite(img.ui.anrea_server_bg)
  sevbg:setScale(0.78)
  sevbg:setAnchorPoint(0, 0.5)
  sevbg:setPosition(showName:boundingBox():getMaxX() + 5, TIPS_HEIGHT - 35)
  board:addChild(sevbg)
  local sevlab = lbl.createFont1(18, getSidname(l_1_0.sid), ccc3(247, 234, 209))
  sevlab:setPosition(sevbg:getContentSize().width / 2, sevbg:getContentSize().height / 2 + 1)
  sevbg:addChild(sevlab)
  local titledefen = lbl.createMixFont3(18, i18n.global.tips_player_defen.string, ccc3(255, 242, 152))
  titledefen:setAnchorPoint(ccp(0, 0.5))
  titledefen:setPosition(25, TIPS_HEIGHT - 80)
  board:addChild(titledefen)
  local fgline = img.createUI9Sprite(img.ui.hero_panel_fgline)
  fgline:setOpacity(76.5)
  fgline:setPreferredSize(CCSize(482, 2))
  fgline:setPosition(TIPS_WIDTH / 2, TIPS_HEIGHT - 102)
  board:addChild(fgline)
  local showPower = lbl.createFont2(22, l_1_0.power or 0)
  showPower:setAnchorPoint(ccp(1, 0.5))
  showPower:setPosition(fgline:boundingBox():getMaxX(), TIPS_HEIGHT - 80)
  board:addChild(showPower)
  local powerIcon = img.createUISprite(img.ui.power_icon)
  powerIcon:setScale(0.48)
  powerIcon:setAnchorPoint(ccp(1, 0.5))
  powerIcon:setPosition(showPower:boundingBox():getMinX() - 10, TIPS_HEIGHT - 80)
  board:addChild(powerIcon)
  local dy = 110
  local sy = 248
  local item_w = 484
  local item_h = 102
  for i = 1, 3 do
    local bitemBg = img.createUI9Sprite(img.ui.friend_pvp_emptypos)
    bitemBg:setPreferredSize(CCSize(item_w, item_h))
    bitemBg:setAnchorPoint(0.5, 0)
    bitemBg:setPosition(TIPS_WIDTH / 2, sy - dy * (i - 1))
    board:addChild(bitemBg)
    if i <=  l_1_0.mbrs then
      local itemBg = img.createUI9Sprite(img.ui.botton_fram_2)
      itemBg:setPreferredSize(CCSize(item_w, item_h))
      itemBg:setAnchorPoint(0.5, 0)
      itemBg:setPosition(TIPS_WIDTH / 2, sy - dy * (i - 1))
      board:addChild(itemBg)
      local showpos = lbl.createFont1(18, i, ccc3(115, 59, 5))
      showpos:setPosition(32, item_h / 2)
      itemBg:addChild(showpos)
      local head = img.createPlayerHeadForArena(l_1_0.mbrs[i].logo, l_1_0.mbrs[i].lv)
      head:setScale(0.9)
      head:setPosition(94, item_h / 2)
      itemBg:addChild(head)
      if l_1_0.leader == l_1_0.mbrs[i].uid then
        local teamIcon = img.createUISprite(img.ui.friend_pvp_captain)
        teamIcon:setAnchorPoint(0, 1)
        teamIcon:setPosition(0, head:getContentSize().height)
        head:addChild(teamIcon)
      end
      local namelab = lbl.createFontTTF(16, l_1_0.mbrs[i].name, ccc3(81, 39, 18))
      namelab:setAnchorPoint(0, 0.5)
      namelab:setPosition(142, 76)
      itemBg:addChild(namelab)
      local POSX = {1 = 165, 2 = 218, 3 = 285, 4 = 337, 5 = 389, 6 = 441}
      local hids = {}
      if not l_1_0.mbrs[i].camp then
        local pheroes = {}
      end
      if pheroes then
        for i,v in ipairs(pheroes) do
          hids[v.pos] = v
        end
      end
      for ii = 1, 6 do
        local showHero = nil
        local idx = (i - 1) * 6 + ii
        if hids[ii] then
          if i == 3 then
            showHero = img.createUISprite(img.ui.herolist_head_bg)
            local icon = img.createUISprite(img.ui.arena_new_question)
            icon:setPosition(showHero:getContentSize().width * 0.5, showHero:getContentSize().height * 0.5)
            showHero:addChild(icon)
          else
            local param = {id = hids[ii].id, lv = hids[ii].lv, showGroup = true, showStar = true, wake = hids[ii].wake, orangeFx = nil, petID = require("data.pet").getPetID(hids), hid = nil, skin = hids[ii].skin}
            showHero = img.createHeroHeadByParam(param)
          end
          showHero:setScale(0.5)
        elseif i == 3 then
          showHero = img.createUISprite(img.ui.herolist_head_bg)
          local icon = img.createUISprite(img.ui.arena_new_question)
          icon:setPosition(showHero:getContentSize().width * 0.5, showHero:getContentSize().height * 0.5)
          showHero:addChild(icon)
          showHero:setScale(0.5)
        else
          showHero = img.createUI9Sprite(img.ui.herolist_withouthero_bg)
          showHero:setScale(0.83333333333333)
          showHero:setPreferredSize(CCSize(59, 59))
        end
        showHero:setPosition(POSX[ii] - 3, 38)
        itemBg:addChild(showHero)
      end
    end
  end
  local onCreate = function(l_2_0)
    local POSX = {1 = 23, 2 = 98, 3 = 198, 4 = 273, 5 = 348, 6 = 423}
    local hids = {}
    if not l_2_0.heroes then
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
   end
  local onExit = function()
   end
  layer:registerScriptHandler(function(l_6_0)
    if l_6_0 == "enter" then
      onEnter()
    elseif l_6_0 == "exit" then
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

