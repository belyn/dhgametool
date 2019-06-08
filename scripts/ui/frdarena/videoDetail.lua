-- Command line was: E:\github\dhgametool\scripts\ui\frdarena\videoDetail.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local playerData = require("data.player")
local net = require("net.netClient")
local BG_WIDTH = 880
local BG_HEIGHT = 520
local SCROLL_MARGIN_TOP = 10
local SCROLL_MARGIN_BOTTOM = 10
local SCROLL_VIEW_WIDTH = BG_WIDTH
local SCROLL_VIEW_HEIGHT = BG_HEIGHT - SCROLL_MARGIN_TOP - SCROLL_MARGIN_BOTTOM
local createItemDetail = function(l_1_0, l_1_1, l_1_2, l_1_3)
  local bg = nil
  local bkgWidth = 342
  if l_1_1 == true then
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
  local playerLogo = img.createPlayerHeadForArena(l_1_3.logo)
  playerLogo:setScale(0.65)
  bg:addChild(playerLogo)
  local showName = lbl.createFontTTF(16, l_1_3.name)
  bg:addChild(showName)
  local player_lv_bg = img.createUISprite(img.ui.main_lv_bg)
  local lbl_player_lv = lbl.createFont2(14, "" .. l_1_3.lv)
  lbl_player_lv:setPosition(CCPoint(player_lv_bg:getContentSize().width / 2, player_lv_bg:getContentSize().height / 2))
  player_lv_bg:addChild(lbl_player_lv)
  bg:addChild(player_lv_bg)
  local hids = {}
  if not l_1_3.camp then
    local pheroes = {}
  end
  for i,v in ipairs(pheroes) do
    hids[v.pos] = v
  end
  tbl2string(hids)
  local sx, dx = 38, 53
  for i = 1, 6 do
    local showHero = nil
    if hids[i] then
      local param = {id = hids[i].id, lv = hids[i].lv, showGroup = true, showStar = true, wake = hids[i].wake, orangeFx = nil, petID = require("data.pet").getPetID(hids), hid = nil, skin = hids[i].skin}
      showHero = img.createHeroHeadByParam(param)
    else
      showHero = img.createUISprite(img.ui.herolist_head_bg)
    end
    showHero:setAnchorPoint(ccp(0.5, 0.5))
    showHero:setScale(0.55)
    showHero:setPosition(sx + (i - 1) * dx, 42)
    bg:addChild(showHero)
  end
  if l_1_2 then
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

local createItem = function(l_2_0, l_2_1, l_2_2, l_2_3)
  if l_2_0.wins[l_2_1] == nil then
    return 
  end
  local frames = nil
  if l_2_1 == 1 then
    frames = l_2_0.frames
  elseif l_2_1 == 2 then
    frames = l_2_0.frames1
  elseif l_2_1 == 3 then
    frames = l_2_0.frames2
  end
  local width = 806
  local height = 200
  local container = cc.Node:create()
  container:setAnchorPoint(CCPoint(0.5, 0.5))
  container:setContentSize(CCSize(width, height))
  local leftBg = createItemDetail(l_2_1, l_2_0.wins[l_2_1] == true, true, l_2_0.atk.mbrs[l_2_1])
  leftBg:setAnchorPoint(0, 0.5)
  leftBg:setPosition(0, height * 0.5)
  container:addChild(leftBg)
  local rightBg = createItemDetail(l_2_1, l_2_0.wins[l_2_1] == false, false, l_2_0.def.mbrs[l_2_1])
  rightBg:setAnchorPoint(0, 0.5)
  rightBg:setPosition(leftBg:getContentSize().width + 56, height * 0.5)
  container:addChild(rightBg)
  local titleKeyAry = {i18n.global.round1_3v3.string, i18n.global.round2_3v3.string, i18n.global.round3_3v3.string}
  local titleKey = titleKeyAry[l_2_1]
  local titleLabel = lbl.createFont1(24, titleKey, ccc3(255, 227, 134))
  titleLabel:setAnchorPoint(0.5, 1)
  titleLabel:setPosition(leftBg:getContentSize().width + 28, height + 6)
  container:addChild(titleLabel)
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
    local params = {sid = playerData.sid, vid = __data.vids[round]}
    tbl2string(params)
    addWaitNet()
    net:gpvp_video(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status < 0 then
        showToast("status:" .. l_1_0.status)
        return 
      end
      local video1 = {}
      video1.atk = __data.atk.mbrs[round]
      video1.def = __data.def.mbrs[round]
      video1.win = __data.wins[round]
      video1.frames = l_1_0.frames
      video1.hurts = l_1_0.hurts
      processPetPosAtk2(video1)
      processPetPosDef2(video1)
      video1.from_layer = {video = {id = videoId, __data = orgData}}
      replaceScene(require("fight.pvpf3rep.loading").create(video1))
      end)
   end)
  return container
end

ui.create = function(l_3_0, l_3_1, l_3_2)
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
  for i = 1, 3 do
    local item = createItem(l_3_0.log, i, l_3_1, l_3_2)
    if not item then
      do return end
    end
    height = height + item:getContentSize().height + 4
    table.insert(itemAry, item)
    scroll:addChild(item)
  end
  local sy = height - 4 - 10 - 5
  for _,item in ipairs(itemAry) do
    item:setAnchorPoint(0.5, 0.5)
    item:setPosition(SCROLL_VIEW_WIDTH * 0.5, sy - item:getContentSize().height * 0.5)
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

