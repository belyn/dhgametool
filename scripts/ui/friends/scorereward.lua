-- Command line was: E:\github\dhgametool\scripts\ui\friends\scorereward.lua 

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
local cfgassist = require("config.assistrank")
local player = require("data.player")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local friendboss = require("data.friendboss")
local space_height = 1
local icon_rank = {1 = img.ui.arena_rank_1, 2 = img.ui.arena_rank_2, 3 = img.ui.arena_rank_3}
local createItem = function(l_1_0, l_1_1, l_1_2, l_1_3)
  local item = img.createUI9Sprite(img.ui.botton_fram_2)
  item:setPreferredSize(CCSizeMake(575, 82))
  local item_w = item:getContentSize().width
  local item_h = item:getContentSize().height
  local rank = nil
  if l_1_1 < 4 then
    rank = img.createUISprite(icon_rank[l_1_1])
  else
    rank = lbl.createFont1(18, l_1_3 + 1 .. "-" .. l_1_0.rank, ccc3(81, 39, 18))
  end
  rank:setPosition(CCPoint(60, item_h / 2))
  item:addChild(rank)
  local offset_x = 155
  for i = 1,  l_1_0.rewards do
    local tmp_item = nil
    do
      local itemObj = l_1_0.rewards[i]
      if itemObj.type == 1 then
        local tmp_item0 = img.createItem(itemObj.id, itemObj.num)
        tmp_item = SpineMenuItem:create(json.ui.button, tmp_item0)
      elseif itemObj.type == 2 then
        local tmp_item0 = img.createEquip(itemObj.id, itemObj.num)
        tmp_item = SpineMenuItem:create(json.ui.button, tmp_item0)
      end
      tmp_item:setScale(0.7)
      tmp_item:setPosition(CCPoint(offset_x + (i - 1) * 70, item_h / 2))
      local tmp_item_menu = CCMenu:createWithItem(tmp_item)
      tmp_item_menu:setPosition(CCPoint(0, 0))
      item:addChild(tmp_item_menu)
      tmp_item:registerScriptTapHandler(function()
        audio.play(audio.button)
        local tmp_tip = nil
        if itemObj.type == 1 then
          tmp_tip = tipsitem.createForShow({id = itemObj.id})
          layer:addChild(tmp_tip, 100)
        else
          if itemObj.type == 2 then
            tmp_tip = tipsequip.createById(itemObj.id)
            layer:addChild(tmp_tip, 100)
          end
        end
        tmp_tip.setClickBlankHandler(function()
          tmp_tip:removeFromParentAndCleanup(true)
            end)
         end)
    end
  end
  return item
end

ui.create = function()
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board_bg = img.createUI9Sprite(img.ui.dialog_1)
  board_bg:setPreferredSize(CCSizeMake(662, 514))
  board_bg:setScale(view.minScale)
  board_bg:setPosition(view.midX, view.midY)
  layer:addChild(board_bg)
  local board_bg_w = board_bg:getContentSize().width
  local board_bg_h = board_bg:getContentSize().height
  board_bg:setScale(0.5 * view.minScale)
  board_bg:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  local lbl_title = lbl.createFont1(24, i18n.global.friendboss_integral_reward.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 29))
  board_bg:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.friendboss_integral_reward.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 31))
  board_bg:addChild(lbl_title_shadowD)
  json.load(json.ui.clock)
  local clockIcon = DHSkeletonAnimation:createWithKey(json.ui.clock)
  clockIcon:scheduleUpdateLua()
  clockIcon:playAnimation("animation", -1)
  clockIcon:setPosition(42, 430)
  board_bg:addChild(clockIcon, 100)
  local timeLab = string.format("%02d:%02d:%02d", math.floor(0), math.floor(0), math.floor(0))
  local showTimeLab = lbl.createFont2(16, "", ccc3(165, 253, 71))
  showTimeLab:setAnchorPoint(0, 0.5)
  showTimeLab:setPosition(67, 430)
  board_bg:addChild(showTimeLab)
  local rewardLab = lbl.createMixFont1(16, i18n.global.friendboss_score_text.string, ccc3(115, 59, 5))
  rewardLab:setAnchorPoint(0, 0.5)
  rewardLab:setPosition(150, 430)
  board_bg:addChild(rewardLab)
  rewardLab:setVisible(false)
  local onUpdate = function(l_1_0)
    if friendboss.rcd then
      cd = math.max(0, friendboss.rcd + friendboss.pull_time - os.time())
      if cd > 0 then
        upvalue_512 = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
        showTimeLab:setString(timeLab)
      else
        friendboss.rcd = friendboss.rcd + 604800
        upvalue_512 = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
        showTimeLab:setString(timeLab)
      end
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
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
  board:setPreferredSize(CCSizeMake(604, 360))
  board:setAnchorPoint(CCPoint(0.5, 0))
  board:setPosition(CCPoint(board_bg_w / 2, 38))
  board_bg:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local createScroll = function()
    local scroll_params = {width = 604, height = 350}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local showList = function(l_5_0)
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(0, 2))
    board:addChild(scroll)
    board.scroll = scroll
    scroll.addSpace(4)
    for ii = 1,  l_5_0 do
      local tmp_item = nil
      if ii > 2 then
        tmp_item = createItem(l_5_0[ii], ii, layer, l_5_0[ii - 1].rank)
      else
        tmp_item = createItem(l_5_0[ii], ii, layer)
      end
      tmp_item.guildObj = l_5_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = 302
      scroll.addItem(tmp_item)
      if ii ~=  l_5_0 then
        scroll.addSpace(space_height)
      end
    end
    scroll.setOffsetBegin()
   end
  if not cfgassist then
    showList({})
  end
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
  layer:registerScriptHandler(function(l_9_0)
    if l_9_0 == "enter" then
      onEnter()
    elseif l_9_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

