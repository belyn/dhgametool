-- Command line was: E:\github\dhgametool\scripts\ui\guildFight\guildFightcamp.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local player = require("data.player")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local net = require("net.netClient")
local space_height = 1
local createItem = function(l_1_0, l_1_1, l_1_2)
  local item = img.createUI9Sprite(img.ui.botton_fram_2)
  item:setPreferredSize(CCSizeMake(574, 102))
  local item_w = item:getContentSize().width
  local item_h = item:getContentSize().height
  local rank = lbl.createFont1(18, "" .. l_1_1, ccc3(81, 39, 18))
  rank:setPosition(CCPoint(46, item_h / 2))
  item:addChild(rank)
  local hids = {}
  if not l_1_0.camp then
    local pheroes = {}
  end
  for i,v in ipairs(pheroes) do
    hids[v.pos] = v
  end
  local dx = 78
  local sx0 = 115
  local sx1 = sx0 + dx + 90
  do
    local sxAry = {sx0, sx0 + dx, sx1, sx1 + dx, sx1 + dx * 2, sx1 + dx * 3}
    for i = 1, 6 do
      local showHero = nil
      local hideFlag = false
      if l_1_2 then
        for _,uid in ipairs(l_1_2) do
          if uid == l_1_0.uid then
            hideFlag = true
        else
          end
        end
        if hideFlag then
          showHero = img.createUISprite(img.ui.herolist_head_bg)
          local icon = img.createUISprite(img.ui.arena_new_question)
          icon:setPosition(showHero:getContentSize().width * 0.5, showHero:getContentSize().height * 0.5)
          showHero:addChild(icon)
        elseif hids[i] then
          local param = {id = hids[i].id, lv = hids[i].lv, showGroup = true, showStar = true, wake = hids[i].wake, orangeFx = nil, petID = require("data.pet").getPetID(hids), skin = hids[i].skin}
          showHero = img.createHeroHeadByParam(param)
        else
          showHero = img.createUISprite(img.ui.herolist_head_bg)
        end
        showHero:setAnchorPoint(ccp(0.5, 0.5))
        showHero:setScale(0.75)
        showHero:setPosition(sxAry[i], item:getContentSize().height * 0.5 + 1)
        item:addChild(showHero)
      end
      return item
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.create = function(l_2_0, l_2_1)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board_bg = img.createUI9Sprite(img.ui.dialog_1)
  board_bg:setPreferredSize(CCSizeMake(664, 552))
  board_bg:setScale(view.minScale)
  board_bg:setPosition(view.midX, view.midY)
  layer:addChild(board_bg)
  local board_bg_w = board_bg:getContentSize().width
  local board_bg_h = board_bg:getContentSize().height
  board_bg:setScale(0.5 * view.minScale)
  board_bg:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  local lbl_title = lbl.createFont1(24, i18n.global.guildfight_camp.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 29))
  board_bg:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.guildfight_camp.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 31))
  board_bg:addChild(lbl_title_shadowD)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(board_bg_w - 25, board_bg_h - 28))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  board_bg:addChild(btn_close_menu, 100)
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local board = img.createUI9Sprite(img.ui.inner_bg)
  board:setPreferredSize(CCSizeMake(598, 450))
  board:setAnchorPoint(CCPoint(0.5, 0))
  board:setPosition(CCPoint(board_bg_w / 2, 38))
  board_bg:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local createScroll = function()
    local scroll_params = {width = 604, height = 436}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local showList = function(l_4_0)
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(-3, 5))
    board:addChild(scroll)
    board.scroll = scroll
    scroll.addSpace(4)
    for ii = 1, #l_4_0 do
      local tmp_item = createItem(l_4_0[ii], ii, mask)
      tmp_item.guildObj = l_4_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = 302
      scroll.addItem(tmp_item)
      if ii ~= #l_4_0 then
        scroll.addSpace(space_height)
      end
    end
    scroll.setOffsetBegin()
   end
  showList(l_2_0)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    backEvent()
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_8_0)
    if l_8_0 == "enter" then
      onEnter()
    elseif l_8_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

