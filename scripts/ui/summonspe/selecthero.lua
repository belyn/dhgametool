-- Command line was: E:\github\dhgametool\scripts\ui\summonspe\selecthero.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local heros = require("data.heros")
local cfghero = require("config.hero")
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local headIcons = {}
  local herolist = {}
  local group = 0
  local initHerolistData = function()
    herolist = {}
    local tmpheros = clone(heros)
    for i,v in ipairs(tmpheros) do
      if cfghero[v.id].qlt > 3 and cfghero[v.id].qlt < 6 and cfghero[v.id].group < 5 and (group == 0 or cfghero[v.id].group == group) then
        herolist[ herolist + 1] = {hid = v.hid, id = v.id, lv = v.lv, star = v.star, flag = v.flag}
      end
    end
    table.sort(herolist, compareHero)
   end
  initHerolistData()
  local herolistBg = img.createUI9Sprite(img.ui.tips_bg)
  herolistBg:setPreferredSize(CCSize(958, 112))
  herolistBg:setScale(view.minScale)
  herolistBg:setAnchorPoint(ccp(0.5, 1))
  herolistBg:setPosition(view.midX, view.minY - 0 * view.minScale)
  layer:addChild(herolistBg)
  local SCROLLVIEW_WIDTH = 793
  local SCROLLVIEW_HEIGHT = 112
  local SCROLLCONTENT_WIDTH =  herolist * 90 + 8
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionHorizontal)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(7, 0)
  scroll:setViewSize(CCSize(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT))
  scroll:setContentSize(CCSizeMake(SCROLLCONTENT_WIDTH, SCROLLVIEW_HEIGHT))
  herolistBg:addChild(scroll)
  local btnFilterSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnFilterSprite:setPreferredSize(CCSize(130, 70))
  local btnFilterIcon = lbl.createFont1(20, i18n.global.selecthero_btn_hero.string, ccc3(115, 59, 5))
  btnFilterIcon:setPosition(btnFilterSprite:getContentSize().width / 2, btnFilterSprite:getContentSize().height / 2)
  btnFilterSprite:addChild(btnFilterIcon)
  local btnFilter = SpineMenuItem:create(json.ui.button, btnFilterSprite)
  btnFilter:setPosition(873, 56)
  local menuFilter = CCMenu:createWithItem(btnFilter)
  menuFilter:setPosition(0, 0)
  herolistBg:addChild(menuFilter, 1)
  local filterBg = img.createUI9Sprite(img.ui.tips_bg)
  filterBg:setPreferredSize(CCSize(122, 325))
  filterBg:setScale(view.minScale)
  filterBg:setAnchorPoint(ccp(1, 0))
  filterBg:setPosition(scalep(938, 110))
  layer:addChild(filterBg)
  local showHeroLayer = CCLayer:create()
  scroll:getContainer():addChild(showHeroLayer)
  local selectBatch, blackBatch = nil, nil
  local createHerolist = function()
    showHeroLayer:removeAllChildrenWithCleanup(true)
    arrayclear(headIcons)
    scroll:setContentSize(CCSizeMake( herolist * 90 + 8, SCROLLVIEW_HEIGHT))
    scroll:setContentOffset(ccp(0, 0))
    local iconBgBatch = img.createBatchNodeForUI(img.ui.herolist_head_bg)
    showHeroLayer:addChild(iconBgBatch, 1)
    local groupBgBatch = img.createBatchNodeForUI(img.ui.herolist_group_bg)
    showHeroLayer:addChild(groupBgBatch, 3)
    local starBatch = img.createBatchNodeForUI(img.ui.star_s)
    showHeroLayer:addChild(starBatch, 3)
    local star1Batch = img.createBatchNodeForUI(img.ui.hero_star_orange)
    showHeroLayer:addChild(star1Batch, 3)
    upvalue_3072 = CCNode:create()
    showHeroLayer:addChild(blackBatch, 4)
    upvalue_3584 = img.createBatchNodeForUI(img.ui.hook_btn_sel)
    showHeroLayer:addChild(selectBatch, 5)
    local lockBatch = img.createBatchNodeForUI(img.ui.devour_icon_lock)
    showHeroLayer:addChild(lockBatch, 6)
    for i = 1,  herolist do
      local x, y = 45 + (i - 1) * 90 + 8, 56
      local heroBg = img.createUISprite(img.ui.herolist_head_bg)
      heroBg:setScale(0.92)
      heroBg:setPosition(x, y)
      iconBgBatch:addChild(heroBg)
      headIcons[i] = img.createHeroHeadByHid(herolist[i].hid)
      headIcons[i]:setScale(0.92)
      headIcons[i]:setPosition(x, y)
      showHeroLayer:addChild(headIcons[i], 2)
      if herolist[i].flag and herolist[i].flag > 0 then
        local count = 0
        local text = ""
        if herolist[i].flag % 2 == 1 then
          text = text .. i18n.global.toast_devour_arena.string
          count = count + 1
        end
        if math.floor(herolist[i].flag / 2) % 2 == 1 then
          if count >= 1 then
            text = text .. "\n"
          end
          text = text .. i18n.global.toast_devour_lock.string
          count = count + 1
        end
        if math.floor(herolist[i].flag / 4) % 2 == 1 then
          if count >= 1 then
            text = text .. "\n"
          end
          text = text .. i18n.global.toast_devour_3v3arena.string
          count = count + 1
        end
        if math.floor(herolist[i].flag / 8) % 2 == 1 then
          if count >= 1 then
            text = text .. "\n"
          end
          text = text .. i18n.global.toast_devour_frdarena.string
          count = count + 1
        end
        herolist[i].lock = text
        local blackBoard = img.createUISprite(img.ui.hero_head_shade)
        blackBoard:setScale(0.80851063829787)
        blackBoard:setOpacity(120)
        blackBoard:setPosition(headIcons[i]:getPositionX(), headIcons[i]:getPositionY())
        blackBatch:addChild(blackBoard, 0, i)
        local showLock = img.createUISprite(img.ui.devour_icon_lock)
        showLock:setPosition(headIcons[i]:getPositionX(), headIcons[i]:getPositionY())
        lockBatch:addChild(showLock, 0, i)
      end
    end
   end
  createHerolist()
  local anim_duration = 0.2
  herolistBg:runAction(CCMoveTo:create(anim_duration, CCPoint(view.midX, view.minY + 110 * view.minScale)))
  local btnGroupList = {}
  for i = 1, 4 do
    do
      local btnGroupSpriteFg = img.createUISprite(img.ui.herolist_group_" .. )
      local btnGroupSpriteBg = img.createUISprite(img.ui.herolist_group_bg)
      btnGroupSpriteFg:setPosition(btnGroupSpriteBg:getContentSize().width / 2, btnGroupSpriteBg:getContentSize().height / 2 + 2)
      btnGroupSpriteBg:addChild(btnGroupSpriteFg)
      btnGroupList[i] = HHMenuItem:createWithScale(btnGroupSpriteBg, 1)
      local btnGroupMenu = CCMenu:createWithItem(btnGroupList[i])
      btnGroupMenu:setPosition(0, 0)
      filterBg:addChild(btnGroupMenu, 10)
      btnGroupList[i]:setPosition(61, 52 + 70 * (i - 1))
      local showSelect = img.createUISprite(img.ui.herolist_select_icon)
      showSelect:setPosition(btnGroupList[i]:getContentSize().width / 2, btnGroupList[i]:getContentSize().height / 2 + 2)
      btnGroupList[i]:addChild(showSelect)
      btnGroupList[i].showSelect = showSelect
      showSelect:setVisible(false)
      btnGroupList[i]:registerScriptTapHandler(function()
        audio.play(audio.button)
        for j = 1, 4 do
          btnGroupList[j]:unselected()
          btnGroupList[j].showSelect:setVisible(false)
        end
        if group == 0 or i ~= group then
          upvalue_1024 = i
          btnGroupList[i]:selected()
          btnGroupList[i].showSelect:setVisible(true)
        else
          upvalue_1024 = 0
        end
        initHerolistData()
        createHerolist()
         end)
    end
  end
  filterBg:setVisible(false)
  btnFilter:registerScriptTapHandler(function()
    if filterBg:isVisible() == true then
      filterBg:setVisible(false)
    else
      filterBg:setVisible(true)
    end
   end)
  local lastx, preSelect = nil, nil
  local onTouchBegin = function(l_5_0, l_5_1)
    lastx = l_5_0
    return true
   end
  local onTouchMoved = function(l_6_0, l_6_1)
    return true
   end
  local onTouchEnd = function(l_7_0, l_7_1)
    local pointOnScroll = scroll:getContainer():convertToNodeSpace(ccp(l_7_0, l_7_1))
    if math.abs(l_7_0 - lastx) < 10 then
      for i,v in ipairs(headIcons) do
        if v:boundingBox():containsPoint(pointOnScroll) then
          audio.play(audio.button)
          if herolist[i].lock then
            showToast(herolist[i].lock)
            return 
          end
          tbl2string(herolist)
          callBack(herolist[i])
          layer:removeFromParentAndCleanup()
        end
      end
    end
    return true
   end
  local clickBlankHandler = nil
  layer.setClickBlankHandler = function(l_8_0)
    clickBlankHandler = l_8_0
   end
  local onTouch = function(l_9_0, l_9_1, l_9_2)
    if l_9_0 == "began" then
      return onTouchBegin(l_9_1, l_9_2)
    elseif l_9_0 == "moved" then
      return onTouchMoved(l_9_1, l_9_2)
    else
      if not herolistBg:boundingBox():containsPoint(ccp(l_9_1, l_9_2)) and not filterBg:boundingBox():containsPoint(ccp(l_9_1, l_9_2)) then
        layer.onAndroidBack()
      else
        return onTouchEnd(l_9_1, l_9_2)
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup()
   end
  layer.onAndroidBack = function()
    if clickBlankHandler then
      clickBlankHandler()
    else
      backEvent()
    end
   end
  addBackEvent(layer)
  local onEnter = function()
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_14_0)
    if l_14_0 == "enter" then
      onEnter()
    elseif l_14_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

