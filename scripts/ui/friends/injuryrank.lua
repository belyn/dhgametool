-- Command line was: E:\github\dhgametool\scripts\ui\friends\injuryrank.lua 

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
local space_height = 0
local BG_WIDTH = 604
local BG_HEIGHT = 514
local perall = 0
local icon_rank = {1 = img.ui.arena_rank_1, 2 = img.ui.arena_rank_2, 3 = img.ui.arena_rank_3}
local createItem = function(l_1_0, l_1_1, l_1_2)
  local item = img.createUI9Sprite(img.ui.fight_hurts_bg_1)
  item:setPreferredSize(CCSizeMake(288, 76))
  local item_w = item:getContentSize().width
  local item_h = item:getContentSize().height
  local item1 = CCSprite:create()
  local item2 = img.createUISprite(img.ui.fight_hurts_bg_1)
  item2:setScaleX(0.81818181818182)
  item2:setScaleY(1.2258064516129)
  item2:setAnchorPoint(0, 0.5)
  item2:setPosition(item_w, item_h / 2)
  item2:setFlipX(true)
  item:addChild(item2)
  if l_1_1 % 2 == 0 then
    item:setOpacity(70)
    item2:setOpacity(70)
  end
  local rank = nil
  if l_1_1 < 4 then
    rank = img.createUISprite(icon_rank[l_1_1])
  else
    rank = lbl.createFont2(18, "" .. l_1_1, lbl.whiteColor)
  end
  rank:setPosition(CCPoint(75, item_h / 2))
  item:addChild(rank)
  local flag = img.createPlayerHead(l_1_0.logo)
  flag:setScale(0.7)
  flag:setPosition(CCPoint(200, item_h / 2))
  item:addChild(flag)
  local lbl_name = lbl.createFontTTF(20, l_1_0.name, ccc3(255, 246, 223))
  lbl_name:setAnchorPoint(CCPoint(0, 0))
  lbl_name:setPosition(CCPoint(280, 40))
  item:addChild(lbl_name)
  local bloodBar = img.createUISprite(img.ui.fight_hurts_bar_bg)
  bloodBar:setAnchorPoint(0, 0.5)
  bloodBar:setPosition(280, 23)
  item:addChild(bloodBar)
  if l_1_1 == 1 then
    upvalue_1536 = l_1_0.injury
  end
  local progress0 = img.createUISprite(img.ui.fight_hurts_bar_fg_1)
  local bloodProgress = createProgressBar(progress0)
  bloodProgress:setPosition(bloodBar:getContentSize().width / 2, bloodBar:getContentSize().height / 2)
  bloodProgress:setPercentage(l_1_0.injury / perall * 100)
  bloodBar:addChild(bloodProgress)
  local progressStr = string.format("%d", l_1_0.injury)
  local progressLabel = lbl.createFont2(16, progressStr, ccc3(255, 246, 223))
  progressLabel:setPosition(CCPoint(108, bloodBar:getContentSize().height / 2 + 5))
  bloodBar:addChild(progressLabel)
  return item
end

ui.create = function()
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
  local titleLabel = lbl.createFont1(24, i18n.global.friendboss_injury_statistics.string, ccc3(255, 227, 134))
  titleLabel:setPosition(BG_WIDTH / 2, BG_HEIGHT - 36)
  bg:addChild(titleLabel)
  local createScroll = function()
    local scroll_params = {width = 600, height = 430}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local showList = function(l_2_0)
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(1, 15))
    bg:addChild(scroll)
    bg.scroll = scroll
    scroll.addSpace(4)
    for ii = 1, #l_2_0 do
      local tmp_item = createItem(l_2_0[ii], ii, layer)
      tmp_item.guildObj = l_2_0[ii]
      tmp_item.ax = 1
      tmp_item.px = 302
      scroll.addItem(tmp_item)
      if ii ~= #l_2_0 then
        scroll.addSpace(space_height)
      end
    end
    scroll.setOffsetBegin()
   end
  local compareassits = function(l_3_0, l_3_1)
    local injury1, injury2 = l_3_0.injury, l_3_1.injury
    if injury2 < injury1 then
      return true
    end
   end
  local init = function()
    local gParams = {sid = player.sid}
    addWaitNet()
    net:frd_boss_static(gParams, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.assits then
        local assistsdata = l_1_0.assits
        table.sort(assistsdata, compareassits)
        showList(assistsdata)
      else
        local empty = require("ui.empty")
        local emptyBox = empty.create({text = i18n.global.empty_injury.string})
        emptyBox:setPosition(bg:getContentSize().width / 2, bg:getContentSize().height / 2)
        bg:addChild(emptyBox)
      end
      end)
   end
  init()
  local closeBtn0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(BG_WIDTH - 23, BG_HEIGHT - 26)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  bg:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer.onAndroidBack()
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParent()
   end
  layer:registerScriptHandler(function(l_7_0)
    if l_7_0 == "enter" then
      layer.notifyParentLock()
    elseif l_7_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

