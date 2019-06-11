-- Command line was: E:\github\dhgametool\scripts\ui\solo\rankUI.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local netClient = require("net.netClient")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local icon_rank = {1 = img.ui.arena_rank_1, 2 = img.ui.arena_rank_2, 3 = img.ui.arena_rank_3}
ui.create = function(l_1_0)
  ui.widget = {}
  ui.data = {}
  ui.data.myWave = l_1_0.wave
  ui.data.myTime = l_1_0.time
  ui.data.myRank = l_1_0.rank
  if not l_1_0.mbr then
    ui.data.rankList = {}
  end
  ui.widget.rankList = {}
  ui.widget.layer = CCLayer:create()
  ui.widget.layer:setTouchEnabled(true)
  ui.widget.darkLayer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  ui.widget.layer:addChild(ui.widget.darkLayer)
  ui.widget.bg = img.createUI9Sprite(img.ui.dialog_1)
  ui.widget.bg:setPreferredSize(CCSizeMake(662, 514))
  ui.widget.bg:setScale(view.minScale)
  ui.widget.bg:setPosition(view.midX, view.midY)
  ui.widget.layer:addChild(ui.widget.bg)
  local bg_w = ui.widget.bg:getContentSize().width
  local bg_h = ui.widget.bg:getContentSize().height
  ui.widget.title = lbl.createFont1(24, i18n.global.hook_pverank_title.string, ccc3(230, 208, 174))
  ui.widget.title:setPosition(CCPoint(bg_w / 2, bg_h - 29))
  ui.widget.bg:addChild(ui.widget.title, 2)
  ui.widget.shadow = lbl.createFont1(24, i18n.global.hook_pverank_title.string, ccc3(89, 48, 27))
  ui.widget.shadow:setPosition(CCPoint(bg_w / 2, bg_h - 31))
  ui.widget.bg:addChild(ui.widget.shadow)
  ui.widget.board = img.createUI9Sprite(img.ui.inner_bg)
  ui.widget.board:setPreferredSize(CCSizeMake(604, 413))
  ui.widget.board:setAnchorPoint(CCPoint(0.5, 0))
  ui.widget.board:setPosition(CCPoint(bg_w / 2, 38))
  ui.widget.bg:addChild(ui.widget.board)
  local board_w = ui.widget.board:getContentSize().width
  local board_h = ui.widget.board:getContentSize().height
  local closeImg = img.createUISprite(img.ui.close)
  ui.widget.closeBtn = SpineMenuItem:create(json.ui.button, closeImg)
  ui.widget.closeBtn:setPosition(CCPoint(bg_w - 25, bg_h - 28))
  local closeMenu = CCMenu:createWithItem(ui.widget.closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  ui.widget.bg:addChild(closeMenu, 100)
  local scroll_params = {width = 604, height = 380}
  ui.widget.scroll = require("ui.lineScroll").create(scroll_params)
  ui.widget.scroll:setAnchorPoint(CCPoint(0, 0))
  ui.widget.scroll:setPosition(CCPoint(0, 20))
  ui.widget.scroll.addSpace(4)
  ui.widget.board:addChild(ui.widget.scroll)
  ui.addItems()
  ui.widget.myItem = ui.createMyItem()
  if ui.widget.myItem ~= nil then
    ui.widget.myItem:setPosition(board_w / 2, 36)
    ui.widget.board:addChild(ui.widget.myItem, 3)
  end
  ui.widget.bg:setScale(0.5 * view.minScale)
  ui.widget.bg:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  ui.callBack()
  return ui.widget.layer
end

ui.callBack = function()
  ui.widget.closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    ui.widget.layer:removeFromParent()
   end)
  ui.widget.layer:registerScriptHandler(function(l_2_0)
    if l_2_0 == "enter" then
      ui.onEnter()
    elseif l_2_0 == "exit" then
      ui.onExit()
    end
   end)
  ui.widget.layer.onAndroidBack = function()
    audio.play(audio.button)
    ui.widget.layer:removeFromParent()
   end
  addBackEvent(ui.widget.layer)
end

ui.onEnter = function()
  print("onEnter")
  ui.widget.layer.notifyParentLock()
end

ui.onExit = function()
  print("onExit")
  ui.widget.layer.notifyParentUnlock()
end

ui.createItem = function(l_5_0, l_5_1)
  local item = img.createUI9Sprite(img.ui.botton_fram_2)
  item:setPreferredSize(CCSizeMake(577, 77))
  local item_w = item:getContentSize().width
  local item_h = item:getContentSize().height
  local rank = nil
  if l_5_1 <= 3 then
    rank = img.createUISprite(icon_rank[l_5_1])
  else
    rank = lbl.createFont1(18, "" .. l_5_1, ccc3(81, 39, 18))
  end
  rank:setPosition(ccp(43, 39))
  item:addChild(rank)
  local headIcon = img.createPlayerHead(l_5_0.logo)
  headIcon:setScale(48 / headIcon:getContentSize().width)
  headIcon:setPosition(CCPoint(103, 40))
  item:addChild(headIcon)
  local lvImg = img.createUI9Sprite(img.ui.main_lv_bg)
  lvImg:setPosition(ccp(155, 39))
  item:addChild(lvImg)
  local lvLabel = lbl.createFont2(16, l_5_0.lv, lbl.whiteColor)
  lvLabel:setPosition(ccp(lvImg:getContentSize().width / 2, lvImg:getContentSize().height / 2))
  lvImg:addChild(lvLabel)
  local nameLabel = lbl.createFontTTF(18, l_5_0.name, ccc3(81, 39, 18))
  nameLabel:setAnchorPoint(CCPoint(0, 0.5))
  nameLabel:setPosition(CCPoint(182, item_h / 2 + 12))
  item:addChild(nameLabel)
  local year = os.date("%Y", l_5_0.time)
  local month = os.date("%m", l_5_0.time)
  local day = os.date("%d", l_5_0.time)
  local timeLabel = lbl.createFont1(14, year .. "/" .. month .. "/" .. day, ccc3(81, 39, 18))
  timeLabel:setAnchorPoint(CCPoint(0, 0.5))
  timeLabel:setPosition(CCPoint(182, 28))
  item:addChild(timeLabel)
  local levelStage = math.floor((l_5_0.wave - 1) / 100)
  local waveLabel = lbl.createFont1(18, i18n.global.solo_stage" .. levelStag.string, ccc3(122, 83, 52))
  waveLabel:setPosition(CCPoint(521, 53))
  item:addChild(waveLabel)
  local waveNum = (l_5_0.wave - 1) % 100 + 1
  local waveNumLabel = lbl.createFont1(18, waveNum, ccc3(156, 69, 45))
  waveNumLabel:setPosition(CCPoint(521, 30))
  item:addChild(waveNumLabel)
  return item
end

ui.createMyItem = function()
  if ui.data.myRank == nil or ui.data.myRank == 0 then
    return nil
  end
  local data = {}
  data.logo = player.logo
  data.lv = player.lv()
  data.name = player.name
  data.wave = ui.data.myWave
  data.time = ui.data.myTime
  local idx = ui.data.myRank
  local item = img.createUI9Sprite(img.ui.item_yellow)
  item:setPreferredSize(CCSizeMake(606, 82))
  local item_w = item:getContentSize().width
  local item_h = item:getContentSize().height
  local rank = nil
  if idx <= 3 then
    rank = img.createUISprite(icon_rank[idx])
  else
    rank = lbl.createFont1(18, "" .. idx, ccc3(81, 39, 18))
  end
  rank:setPosition(ccp(57, item_h / 2))
  item:addChild(rank)
  local headIcon = img.createPlayerHead(data.logo)
  headIcon:setScale(48 / headIcon:getContentSize().width)
  headIcon:setPosition(CCPoint(117, item_h / 2))
  item:addChild(headIcon)
  local lvImg = img.createUI9Sprite(img.ui.main_lv_bg)
  lvImg:setPosition(ccp(170, item_h / 2))
  item:addChild(lvImg)
  local lvLabel = lbl.createFont1(16, data.lv, lbl.whiteColor)
  lvLabel:setPosition(ccp(lvImg:getContentSize().width / 2, lvImg:getContentSize().height / 2))
  lvImg:addChild(lvLabel)
  local nameLabel = lbl.createFontTTF(18, data.name, ccc3(81, 39, 18))
  nameLabel:setAnchorPoint(CCPoint(0, 0))
  nameLabel:setPosition(CCPoint(197, 43))
  item:addChild(nameLabel)
  local year = os.date("%Y", data.time)
  local month = os.date("%m", data.time)
  local day = os.date("%d", data.time)
  local timeLabel = lbl.createFont1(14, year .. "/" .. month .. "/" .. day, ccc3(122, 83, 52))
  timeLabel:setAnchorPoint(CCPoint(0, 0))
  timeLabel:setPosition(CCPoint(197, 20))
  item:addChild(timeLabel)
  local levelStage = math.floor((data.wave - 1) / 100)
  local waveLabel = lbl.createFont1(18, i18n.global.solo_stage" .. levelStag.string, ccc3(122, 83, 52))
  waveLabel:setPosition(CCPoint(537, 53))
  item:addChild(waveLabel)
  local waveNum = (data.wave - 1) % 100 + 1
  local waveNumLabel = lbl.createFont1(18, waveNum, ccc3(156, 69, 45))
  waveNumLabel:setPosition(CCPoint(537, 30))
  item:addChild(waveNumLabel)
  return item
end

ui.addItems = function()
  if #ui.data.rankList <= 0 then
    return 
  end
  print("\230\142\146\232\161\140\230\166\156\233\149\191\229\186\166" .. #ui.data.rankList)
  for i = 1, #ui.data.rankList do
    ui.widget.rankList[i] = ui.createItem(ui.data.rankList[i], i)
    ui.widget.rankList[i].ax = 0.5
    ui.widget.rankList[i].px = 302
    ui.widget.scroll.addItem(ui.widget.rankList[i])
  end
  local cur_height = ui.widget.scroll.cur_height
  if ui.widget.scroll.height >= cur_height + 160 or not cur_height + 160 then
    cur_height = ui.widget.scroll.height
  end
  ui.widget.scroll.cur_height = cur_height
  ui.widget.scroll:setContentSize(CCSizeMake(ui.widget.scroll.width, cur_height))
  ui.widget.scroll.content_layer:setPosition(CCPoint(0, cur_height))
  ui.widget.scroll.setOffsetBegin()
end

return ui

