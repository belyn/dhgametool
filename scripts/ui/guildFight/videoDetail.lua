-- Command line was: E:\github\dhgametool\scripts\ui\guildFight\videoDetail.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local player = require("data.player")
local net = require("net.netClient")
local droidhangComponents = require("dhcomponents.DroidhangComponents")
local BG_WIDTH = 880
local BG_HEIGHT = 520
local SCROLL_MARGIN_TOP = 100
local SCROLL_MARGIN_BOTTOM = 10
local SCROLL_VIEW_WIDTH = BG_WIDTH
local SCROLL_VIEW_HEIGHT = BG_HEIGHT - SCROLL_MARGIN_TOP - SCROLL_MARGIN_BOTTOM
local createItemDetail = function(l_1_0, l_1_1, l_1_2)
  local bg = nil
  local bkgWidth = 342
  local resultIcon = nil
  if l_1_0 == true then
    bg = img.createUI9Sprite(img.ui.arena_new_video_bg_win)
    bg:setPreferredSize(CCSize(bkgWidth, bg:getContentSize().height))
    bg:setAnchorPoint(ccp(0.5, 0.5))
    resultIcon = img.createUISprite(img.ui.arena_icon_win)
  else
    bg = img.createUI9Sprite(img.ui.arena_new_video_bg_lose)
    bg:setPreferredSize(CCSize(bkgWidth, bg:getContentSize().height))
    bg:setAnchorPoint(ccp(0.5, 0.5))
    resultIcon = img.createUISprite(img.ui.arena_icon_lost)
  end
  bg:addChild(resultIcon)
  local playerLogo = img.createPlayerHeadForArena(l_1_2.logo)
  playerLogo:setScale(0.65)
  bg:addChild(playerLogo)
  local showName = lbl.createFontTTF(16, l_1_2.name)
  bg:addChild(showName)
  local player_lv_bg = img.createUISprite(img.ui.main_lv_bg)
  local lbl_player_lv = lbl.createFont2(14, "" .. l_1_2.lv)
  lbl_player_lv:setPosition(CCPoint(player_lv_bg:getContentSize().width / 2, player_lv_bg:getContentSize().height / 2))
  player_lv_bg:addChild(lbl_player_lv)
  bg:addChild(player_lv_bg)
  local hids = {}
  if not l_1_2.camp then
    local pheroes = {}
  end
  for i,v in ipairs(pheroes) do
    hids[v.pos] = v
  end
  local sx, dx = 38, 53
  for i = 1, 6 do
    local showHero = nil
    if hids[i] then
      showHero = img.createHeroHead(hids[i].id, hids[i].lv, true, true, hids[i].wake, nil, require("data.pet").getPetID(hids))
      if hids[i].hp and hids[i].hp <= 0 then
        setShader(showHero, SHADER_GRAY, true)
      else
        showHero = img.createUISprite(img.ui.herolist_head_bg)
      end
    end
    showHero:setAnchorPoint(ccp(0.5, 0.5))
    showHero:setScale(0.55)
    showHero:setPosition(sx + (i - 1) * dx, 42)
    bg:addChild(showHero)
  end
  if l_1_1 then
    resultIcon:setPosition(bkgWidth - 45, 114)
    showName:setAnchorPoint(ccp(0, 0))
    player_lv_bg:setAnchorPoint(CCPoint(0, 1))
    playerLogo:setPosition(44, 114)
    showName:setPosition(81, 117)
    player_lv_bg:setPosition(81, 114)
  else
    resultIcon:setPosition(45, 114)
    showName:setAnchorPoint(ccp(1, 0))
    player_lv_bg:setAnchorPoint(CCPoint(1, 1))
    playerLogo:setPosition(bkgWidth - 44, 114)
    showName:setPosition(bkgWidth - 81, 117)
    player_lv_bg:setPosition(bkgWidth - 81, 114)
  end
  return bg
end

local findTeam = function(l_2_0, l_2_1, l_2_2, l_2_3)
  local member = nil
  for _,mbr in ipairs(l_2_0.mbrs) do
    if mbr.uid == l_2_2 then
      member = clone(mbr)
  else
    end
  end
  do
    local res = {}
    for _,v2 in ipairs(member.camp) do
      local findFlag = false
      for _,v1 in ipairs(l_2_1) do
        if v1.pos == v2.pos then
          if v1.hpp and v1.hpp > 0 then
            local newValue = clone(v2)
            newValue.hp = v1.hpp
            newValue.hpp = nil
            table.insert(res, newValue)
          elseif l_2_3 then
            local newValue = clone(v2)
            newValue.hp = 0
            table.insert(res, newValue)
          end
          findFlag = true
      else
        end
      end
      do
        if not findFlag and l_2_3 then
          local newValue = clone(v2)
          newValue.hp = 0
          table.insert(res, newValue)
        end
        for _,v2 in (for generator) do
        end
        if v2.pos == 7 then
          local newValue = clone(v2)
          table.insert(res, newValue)
        end
      end
      member.camp = res
      return member
    end
     -- Warning: missing end command somewhere! Added here
  end
end

local createItem = function(l_3_0, l_3_1)
  local width = 806
  local height = 165
  local container = cc.Node:create()
  container:setAnchorPoint(CCPoint(0.5, 0.5))
  container:setContentSize(CCSize(width, height))
  local atk = findTeam(l_3_0.atk, l_3_1.atk_camp, l_3_1.atk, true)
  local leftBg = createItemDetail(l_3_1.win == true, true, atk)
  leftBg:setAnchorPoint(0, 0.5)
  leftBg:setPosition(0, height * 0.5)
  container:addChild(leftBg)
  local def = findTeam(l_3_0.def, l_3_1.def_camp, l_3_1.def, true)
  local rightBg = createItemDetail(l_3_1.win == false, false, def)
  rightBg:setAnchorPoint(0, 0.5)
  rightBg:setPosition(leftBg:getContentSize().width + 56, height * 0.5)
  container:addChild(rightBg)
  local vsIcon = img.createUISprite(img.ui.arena_new_vs)
  vsIcon:setPosition(leftBg:getContentSize().width + 28, height * 0.5)
  container:addChild(vsIcon)
  local btn_vide0 = img.createUISprite(img.ui.arena_new_video_btn)
  local btn_vide = SpineMenuItem:create(json.ui.button, btn_vide0)
  local btn_video_menu = CCMenu:createWithItem(btn_vide)
  btn_video_menu:setPosition(CCPoint(0, 0))
  container:addChild(btn_video_menu)
  btn_vide:setPosition(rightBg:getPositionX() + rightBg:getContentSize().width + 40, height * 0.5)
  btn_vide:registerScriptTapHandler(function()
    audio.play(audio.button)
    local params = {sid = player.sid, vid = bat.vid}
    addWaitNet()
    net:guild_fight_video(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status < 0 then
        if l_1_0.status == -1 then
          showToast(i18n.global.guiidFight_toast_reg_end.string)
        else
          showToast("status:" .. l_1_0.status)
          return 
        end
        local getNewCamp = function(l_1_0)
          local res = {}
          if not l_1_0 then
            for _,v in ipairs({}) do
            end
            if v.hpp and v.hpp > 0 then
              local newValue = clone(v)
              newValue.hp = newValue.hpp
              newValue.hpp = nil
              table.insert(res, newValue)
            end
          end
          return res
            end
        local battleData = {}
        local atk = findTeam(data.atk, bat.atk_camp, bat.atk)
        do
          local def = findTeam(data.def, bat.def_camp, bat.def)
          battleData.atk = atk
          battleData.def = def
          battleData.frames = l_1_0.frames
          battleData.win = bat.win
          battleData.hurts = l_1_0.hurts
          processPetPosAtk2(battleData)
          processPetPosDef2(battleData)
          pushScene(require("fight.gwarrep.loading").create(battleData))
        end
         -- Warning: missing end command somewhere! Added here
      end
      end)
   end)
  return container
end

ui.create = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if l_4_3.status == -1 then
    showToast(i18n.global.guiidFight_toast_reg_end.string)
    return CCNode:create()
  end
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setPreferredSize(CCSize(BG_WIDTH, BG_HEIGHT))
  bg:setScale(view.minScale * 0.1)
  bg:setAnchorPoint(ccp(0.5, 0.5))
  bg:setPosition(view.midX, view.midY)
  bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  layer:addChild(bg)
  local infoCutLine = img.createUISprite(img.ui.split_line)
  bg:addChild(infoCutLine)
  infoCutLine:setScaleX((BG_WIDTH - 60) / infoCutLine:getContentSize().width)
  droidhangComponents:mandateNode(infoCutLine, "LSjL_agPjyl")
  local vsIcon = img.createUISprite(img.ui.arena_new_vs)
  droidhangComponents:mandateNode(vsIcon, "44SF_agPjyl", cc.p(0, 0))
  bg:addChild(vsIcon)
  if not l_4_1.logo then
    local guildFlag = img.createGFlag(not l_4_1 or 1)
  end
  guildFlag:setScale(0.7)
  bg:addChild(guildFlag)
  droidhangComponents:mandateNode(guildFlag, "fT8z_HNd3ou")
  local nameLabel = lbl.createFontTTF(16, l_4_1.name or "unknow", ccc3(255, 255, 255))
  bg:addChild(nameLabel)
  droidhangComponents:mandateNode(nameLabel, "fT8z_WUpnzb")
  local serverBg = img.createUISprite(img.ui.anrea_server_bg)
  bg:addChild(serverBg)
  serverBg:setScale(0.8)
  droidhangComponents:mandateNode(serverBg, "fT8z_BPGxQ0")
  local serverLabel = lbl.createFont1(16, getSidname(l_4_1.sid or 1), ccc3(255, 251, 215))
  serverLabel:setPosition(serverBg:getContentSize().width * 0.5, serverBg:getContentSize().height * 0.5)
  serverBg:addChild(serverLabel)
  do
    local resultIcon = nil
    if l_4_0 == true then
      resultIcon = img.createUISprite(img.ui.arena_icon_win)
    else
      resultIcon = img.createUISprite(img.ui.arena_icon_lost)
    end
    bg:addChild(resultIcon)
    droidhangComponents:mandateNode(resultIcon, "fT8z_58GxZ0")
  end
  if not l_4_2.logo then
    local guildFlag = img.createGFlag(not l_4_2 or 1)
  end
  guildFlag:setScale(0.7)
  bg:addChild(guildFlag)
  droidhangComponents:mandateNode(guildFlag, "wg71_RXppmJ")
  local nameLabel = lbl.createFontTTF(16, l_4_2.name or "unknow", ccc3(255, 255, 255))
  bg:addChild(nameLabel)
  droidhangComponents:mandateNode(nameLabel, "wg71_0FRQxq")
  local serverBg = img.createUISprite(img.ui.anrea_server_bg)
  bg:addChild(serverBg)
  serverBg:setScale(0.8)
  droidhangComponents:mandateNode(serverBg, "wg71_qYQOgU")
  local serverLabel = lbl.createFont1(16, getSidname(l_4_2.sid or 1), ccc3(255, 251, 215))
  serverLabel:setPosition(serverBg:getContentSize().width * 0.5, serverBg:getContentSize().height * 0.5)
  serverBg:addChild(serverLabel)
  do
    local resultIcon = nil
    if l_4_0 == false then
      resultIcon = img.createUISprite(img.ui.arena_icon_win)
    else
      resultIcon = img.createUISprite(img.ui.arena_icon_lost)
    end
    bg:addChild(resultIcon)
    droidhangComponents:mandateNode(resultIcon, "wg71_9Fhsro")
  end
  local closeBtn0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(BG_WIDTH - 23, BG_HEIGHT - 26)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  bg:addChild(closeMenu, 1)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer.onAndroidBack()
   end)
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setViewSize(CCSize(SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT))
  scroll:setPosition(0, SCROLL_MARGIN_BOTTOM)
  bg:addChild(scroll)
  local height = 0
  local itemAry = {}
  for _,bat in ipairs(l_4_3.bats) do
    local item = createItem(l_4_3, bat)
    height = height + item:getContentSize().height + 4
    table.insert(itemAry, item)
    scroll:addChild(item)
  end
  local sy = height - 4 - 10 - 5
  for _,item in ipairs(itemAry) do
    item:setAnchorPoint(0.5, 0.5)
    item:setPosition(SCROLL_VIEW_WIDTH * 0.5, sy - item:getContentSize().height * 0.5 + 6)
    sy = sy - item:getContentSize().height - 4
  end
  scroll:setContentSize(CCSize(SCROLL_VIEW_WIDTH, height))
  scroll:setContentOffset(ccp(0, SCROLL_VIEW_HEIGHT - (height)))
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParent()
   end
  layer:registerScriptHandler(function(l_3_0)
    if l_3_0 == "enter" then
      layer.notifyParentLock()
    elseif l_3_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

