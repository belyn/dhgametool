-- Command line was: E:\github\dhgametool\scripts\ui\activityhome\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local createTab = function()
  local tabs = {}
  tabs[1] = {des = i18n.global.town_limit.string, event = function(l_1_0, l_1_1)
    l_1_0:addChild(require("ui.activityhome.limit").create(l_1_1), 100, 1000)
   end}
  tabs[2] = {des = i18n.global.town_mact.string, event = function(l_2_0, l_2_1)
    l_2_0:addChild(require("ui.activityhome.monthly").create(l_2_1), 100, 1000)
   end}
  tabs[3] = {des = i18n.global.main_btn_gift.string, event = function(l_3_0, l_3_1)
    l_3_0:addChild(require("ui.activityhome.activity").create(), 100, 1000)
   end}
  return tabs
end

ui.create = function(l_2_0, l_2_1)
  local currentTab = 1
  local tabs = createTab()
  if l_2_0 and l_2_0 > 0 and l_2_0 <= #tabs then
    currentTab = l_2_0
  end
  local layer = CCLayer:create()
  img.load(img.packedOthers.ui_activity_home)
  local bg = img.createUISprite(img.ui.activity_home_bg)
  bg:setPosition(view.midX, view.midY)
  bg:setScale(view.minScale)
  layer:addChild(bg)
  local top = img.createUISprite(img.ui.activity_home_top)
  top:setPosition(view.midX, view.physical.h)
  top:setAnchorPoint(0.5, 1)
  top:setScale(view.minScale)
  layer:addChild(top)
  local bar = require("ui.activityhome.topbar")
  layer:addChild(bar.create(), 101)
  local back0 = img.createUISprite(img.ui.back)
  local backBtn = HHMenuItem:create(back0)
  backBtn:setScale(view.minScale)
  backBtn:setPosition(scalep(35, 546))
  backBtn:registerScriptTapHandler(function()
    layer.onAndroidBack()
   end)
  local backMenu = CCMenu:createWithItem(backBtn)
  backMenu:setPosition(0, 0)
  layer:addChild(backMenu, 101)
  autoLayoutShift(backBtn)
  local shopBg = img.createUISprite(img.ui.activity_home_leaf_bg)
  shopBg:setPosition(scalep(850, 471))
  shopBg:setAnchorPoint(CCPointMake(0, 0))
  shopBg:setScale(view.minScale)
  layer:addChild(shopBg, 101)
  local shopImage = img.createUISprite(img.ui.activity_home_leaf)
  local shopBtn = HHMenuItem:create(shopImage)
  shopBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.monthlyactivity.market").create(), 1000)
   end)
  shopBtn:setPosition(0, 0)
  local shopMenu = CCMenu:createWithItem(shopBtn)
  shopMenu:setPosition(61, 61)
  shopBg:addChild(shopMenu)
  autoLayoutShift(shopBg)
  local flower = img.createUISprite(img.ui.activity_home_flower)
  flower:setPosition(shopBg:getContentSize().width + 10, shopBg:getContentSize().height + 14)
  flower:setAnchorPoint(1, 1)
  shopBg:addChild(flower)
  local particle = require("res.particle")
  local particle_shop = particle.create("ui_shop")
  particle_shop:setPosition(CCPoint(61, 61))
  shopBg:addChild(particle_shop)
  local board = img.createUISprite(img.ui.activity_home_board)
  board:setPosition(view.midX, view.midY - view.minScale * 68)
  board:setScale(view.minScale)
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local cloud = img.createUISprite(img.ui.activity_home_cloud)
  cloud:setAnchorPoint(1, 0.5)
  cloud:setPosition(view.physical.w - scalex(20), scaley(456))
  cloud:setScale(view.minScale)
  layer:addChild(cloud)
  local tabButtons = {}
  local tabSelectedFunc = function(l_3_0)
    layer:removeChildByTag(1000)
    layer:removeChildByTag(1234)
    tabs[l_3_0].event(layer, fromLayer)
    if fromLayer then
      upvalue_1024 = nil
    end
    for j = 1, #tabButtons do
      tabButtons[j]:setVisible(l_3_0 == j)
    end
   end
  local tabPoint = board:convertToWorldSpace(CCPointMake(board_w / 2, board_h - 2))
  for i = 1, #tabs do
    do
      local tabNormal = img.createUISprite(img.ui.activity_home_tab1)
      local tabSelected = img.createUISprite(img.ui.activity_home_tab2)
      tabSelected:setPosition(tabNormal:getContentSize().width / 2, tabNormal:getContentSize().height / 2 - 2)
      tabSelected:setVisible(i == currentTab)
      tabNormal:addChild(tabSelected)
      local tabTop = img.createUISprite(img.ui.activity_home_tab3)
      tabTop:setPosition(tabSelected:getContentSize().width / 2, tabSelected:getContentSize().height - 5)
      tabSelected:addChild(tabTop)
      local text = lbl.create({font = 1, size = 18, text = tabs[i].des, color = ccc3(97, 62, 43), de = {size = 16}, fr = {size = 16}})
      text:setPosition(tabNormal:getContentSize().width / 2, tabNormal:getContentSize().height / 2)
      tabNormal:addChild(text)
      local tab = CCMenuItemSprite:create(tabNormal, nil)
      tab:setPosition(CCPoint(tabPoint.x - (#tabs - 1) / 2 * view.minScale * 192 + (i - 1) * view.minScale * 192, tabPoint.y))
      tab:setAnchorPoint(0.5, 0)
      tab:setScale(view.minScale)
      tab:registerScriptTapHandler(function()
        audio.play(audio.button)
        tabSelectedFunc(i)
         end)
      local tabMenu = CCMenu:createWithItem(tab)
      tabMenu:setPosition(0, 0)
      layer:addChild(tabMenu, 102)
      tabButtons[#tabButtons + 1] = tabSelected
    end
  end
  tabSelectedFunc(currentTab)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  layer:registerScriptHandler(function(l_6_0)
    if l_6_0 == "enter" then
      layer.notifyParentLock()
    elseif l_6_0 == "exit" then
      layer.notifyParentUnlock()
    elseif l_6_0 == "cleanup" then
      img.unload(img.packedOthers.ui_activity_home)
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

