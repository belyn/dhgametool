-- Command line was: E:\github\dhgametool\scripts\ui\devour\filtertips.lua 

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
local cfghero = require("config.hero")
local TIPS_WIDTH = 360
local TIPS_HEIGHT = 146
tips.createFilterBoard = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local filterLayer = CCLayer:create()
  local filterBoard = img.createUI9Sprite(img.ui.tips_bg)
  filterBoard:setPreferredSize(CCSize(TIPS_WIDTH, TIPS_HEIGHT))
  filterBoard:setScale(view.minScale)
  filterBoard:setPosition(scalep(696.5, 166))
  filterLayer:addChild(filterBoard)
  filterLayer.board = filterBoard
  local btnStar = {}
  for i = 1, 5 do
    do
      local btnStarSp = img.createUISprite(img.ui.devour_circle_bg)
      do
        local starIcon = img.createUISprite(img.ui.star)
        starIcon:setPosition(btnStarSp:getContentSize().width / 2, btnStarSp:getContentSize().height / 2 + 2)
        starIcon:setScale(0.7)
        btnStarSp:addChild(starIcon)
        local showStar = lbl.createFont2(16, i)
        showStar:setPosition(btnStarSp:getContentSize().width / 2, btnStarSp:getContentSize().height / 2 + 2)
        btnStarSp:addChild(showStar)
        btnStar[i] = CCMenuItemSprite:create(btnStarSp, nil)
        local menuStar = CCMenu:createWithItem(btnStar[i])
        menuStar:setPosition(0, 0)
        filterBoard:addChild(menuStar)
        btnStar[i]:setPosition(76 + 54 * (i - 1), 44)
        btnStar[i].sel = img.createUISprite(img.ui.bag_dianji)
        btnStar[i].sel:setPosition(btnStar[i]:getContentSize().width / 2, btnStar[i]:getContentSize().height / 2 + 2)
        btnStar[i]:addChild(btnStar[i].sel)
        if l_1_0 ~= i then
          btnStar[i].sel:setVisible(false)
        end
        btnStar[i]:registerScriptTapHandler(function()
          if starType == i then
            starType = 0
            starfunc(0)
            btnStar[i].sel:setVisible(false)
          else
            starType = i
            starfunc(i)
            for j = 1, 5 do
              btnStar[j].sel:setVisible(false)
            end
            btnStar[i].sel:setVisible(true)
          end
          callfunc()
            end)
      end
    end
    local btnGroup = {}
    for i = 1, 6 do
      local btnGroupSp = img.createUISprite(img.ui.devour_circle_bg)
      local groupIcon = img.createUISprite(img.ui.herolist_group_" .. )
      groupIcon:setPosition(btnGroupSp:getContentSize().width / 2, btnGroupSp:getContentSize().height / 2 + 2)
      groupIcon:setScale(0.7)
      btnGroupSp:addChild(groupIcon)
      btnGroup[i] = CCMenuItemSprite:create(btnGroupSp, nil)
      local menuGroup = CCMenu:createWithItem(btnGroup[i])
      menuGroup:setPosition(0, 0)
      filterBoard:addChild(menuGroup)
      btnGroup[i]:setPosition(46 + 54 * (i - 1), 98)
      btnGroup[i].sel = img.createUISprite(img.ui.bag_dianji)
      btnGroup[i].sel:setPosition(btnGroup[i]:getContentSize().width / 2, btnGroup[i]:getContentSize().height / 2 + 2)
      btnGroup[i]:addChild(btnGroup[i].sel)
      if l_1_1 ~= i then
        btnGroup[i].sel:setVisible(false)
      end
      btnGroup[i]:registerScriptTapHandler(function()
        if groupType == i then
          groupType = 0
          groupfunc(0)
          btnGroup[i].sel:setVisible(false)
        else
          groupType = i
          groupfunc(i)
          for j = 1, 6 do
            btnGroup[j].sel:setVisible(false)
          end
          btnGroup[i].sel:setVisible(true)
        end
        callfunc()
         end)
    end
    local touchbeginx, touchbeginy, isclick = nil, nil, nil
    local onTouchBegan = function(l_3_0, l_3_1)
      touchbeginx, upvalue_512 = l_3_0, l_3_1
      upvalue_1024 = true
      return true
      end
    local onTouchMoved = function(l_4_0, l_4_1)
      if isclick and (math.abs(touchbeginx - l_4_0) > 10 or math.abs(touchbeginy - l_4_1) > 10) then
        isclick = false
      end
      end
    local onTouchEnded = function(l_5_0, l_5_1)
      print("toucheend")
      if isclick and not filterBoard:boundingBox():containsPoint(ccp(l_5_0, l_5_1)) then
        filterLayer:removeFromParentAndCleanup(true)
      end
      end
    local onTouch = function(l_6_0, l_6_1, l_6_2)
      if l_6_0 == "began" then
        return onTouchBegan(l_6_1, l_6_2)
      elseif l_6_0 == "moved" then
        return onTouchMoved(l_6_1, l_6_2)
      else
        return onTouchEnded(l_6_1, l_6_2)
      end
      end
    filterLayer:registerScriptTouchHandler(onTouch, false, -128, false)
    filterLayer:setTouchEnabled(true)
    addBackEvent(filterLayer)
    filterLayer.onAndroidBack = function()
      filterLayer:removeFromParentAndCleanup(true)
      end
    local onEnter = function()
      filterLayer.notifyParentLock()
      end
    do
      local onExit = function()
      filterLayer.notifyParentUnlock()
      end
      filterLayer:registerScriptHandler(function(l_10_0)
      if l_10_0 == "enter" then
        onEnter()
      elseif l_10_0 == "exit" then
        onExit()
      end
      end)
      return filterLayer
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return tips

