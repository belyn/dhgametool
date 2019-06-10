-- Command line was: E:\github\dhgametool\scripts\ui\selecthero\herolist.lua 

local herolist = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local cfghero = require("config.hero")
local Dataheros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local condition = {}
local hids = {}
herolist.hids = hids
local initConditon = function(l_1_0)
  condition.heroNum = l_1_0.heroNum or 6
  condition.groups = l_1_0.groups
end

local getHeroListData = function(l_2_0)
  local heros = clone(Dataheros)
  local herolist = {}
  for _,v in ipairs(heros) do
    herolist[#herolist + 1] = {hid = v.hid, id = v.id, lv = v.lv, star = 3, isUsed = false}
    for j,hid in ipairs(hids) do
      if hid == herolist[#herolist].hid then
        herolist[#herolist].isUsed = true
      end
    end
  end
  if condition.groups then
    groups = condition.groups
    local h = {}
    for _,v in ipairs(herolist) do
      if v.isUsed == false then
        for j,group in ipairs(groups) do
          if cfghero[v.id].group == group then
            h[#h + 1] = v
          end
        end
        for _,v in (for generator) do
        end
        h[#h + 1] = v
      end
      herolist = h
    end
    do
      local tlist = herolistless(herolist)
      return tlist
    end
     -- Warning: missing end command somewhere! Added here
  end
end

local createDownList = function()
  local layer = CCLayer:create()
  local btnLevelSprite = img.createUISprite(img.ui.herolist_pulldown)
  btnLevelSprite:setFlipY(true)
  local btnLevel = HHMenuItem:createWithScale(btnLevelSprite, 1)
  local btnLevelLab = lbl.createFont1(18, "Level", ccc3(112, 54, 25))
  btnLevelLab:setPosition(btnLevel:getContentSize().width / 2, btnLevel:getContentSize().height / 2)
  btnLevel:addChild(btnLevelLab)
  local btnLevelMenu = CCMenu:createWithItem(btnLevel)
  btnLevel:setAnchorPoint(ccp(0, 0))
  btnLevel:setPosition(637, 377)
  btnLevelMenu:setPosition(0, 0)
  layer:addChild(btnLevelMenu)
  btnLevel:registerScriptTapHandler(function()
    sortType = "Level"
    getDataAndCreateList()
    layer:removeFromParentAndCleanup(true)
   end)
  local btnBattleSprite = img.createUISprite(img.ui.herolist_pulldown)
  local btnBattle = HHMenuItem:createWithScale(btnBattleSprite, 1)
  local btnBattleLab = lbl.createFont1(18, "Battle", ccc3(112, 54, 25))
  btnBattleLab:setPosition(btnBattle:getContentSize().width / 2, btnBattle:getContentSize().height / 2)
  btnBattle:addChild(btnBattleLab)
  local btnBattleMenu = CCMenu:createWithItem(btnBattle)
  btnBattle:setAnchorPoint(ccp(0, 1))
  btnBattle:setPosition(637, 378)
  btnBattleMenu:setPosition(0, 0)
  layer:addChild(btnBattleMenu)
  btnBattle:registerScriptTapHandler(function()
    sortType = "Battle"
    layer:removeFromParentAndCleanup(true)
   end)
  layer:registerScriptTouchHandler(function()
    layer:removeFromParentAndCleanup(true)
    return true
   end)
  layer:setTouchEnabled(true)
  return layer
end

local createHeroList = function(l_4_0)
  local layer = CCLayer:create()
  local SCROLLVIEW_WIDTH = 710
  local SCROLLVIEW_HEIGHT = 331
  local SCROLLCONTENT_HEIGHT = 23 + 101 * math.ceil(#l_4_0 / 7)
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(66, 109)
  scroll:setViewSize(CCSize(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT))
  scroll:setContentSize(CCSize(SCROLLVIEW_WIDTH, SCROLLCONTENT_HEIGHT))
  scroll:setContentOffset(ccp(0, SCROLLVIEW_HEIGHT - SCROLLCONTENT_HEIGHT))
  layer:addChild(scroll)
  local iconBgBatch = img.createBatchNodeForUI(img.ui.herolist_head_bg)
  scroll:getContainer():addChild(iconBgBatch, 1)
  local groupBgBatch = img.createBatchNodeForUI(img.ui.herolist_group_bg)
  scroll:getContainer():addChild(groupBgBatch, 3)
  local starBatch = img.createBatchNodeForUI(img.ui.herolist_star)
  scroll:getContainer():addChild(starBatch, 3)
  local blackBatch = CCNode:create()
  scroll:getContainer():addChild(blackBatch, 4)
  local selectBatch = img.createBatchNodeForUI(img.ui.hook_btn_sel)
  scroll:getContainer():addChild(selectBatch, 5)
  local headIcons = {}
  local selected = function(l_1_0)
    local isFind = nil
    for i,v in ipairs(hids) do
      if v == herolist[l_1_0].hid then
        isFind = true
      end
    end
    if condition.heroNum <= #hids then
      return 
    end
    if not isFind then
      herolist[l_1_0].isUsed = true
      hids[#hids + 1] = herolist[l_1_0].hid
    end
    local blackBoard = CCLayerColor:create(ccc4(0, 0, 0, 120))
    blackBoard:setContentSize(CCSize(92, 92))
    blackBoard:setPosition(headIcons[l_1_0]:getPositionX() - 46, headIcons[l_1_0]:getPositionY() - 46)
    blackBatch:addChild(blackBoard, 0, l_1_0)
    local selectIcon = img.createUISprite(img.ui.hook_btn_sel)
    selectIcon:setPosition(headIcons[l_1_0]:getPositionX(), headIcons[l_1_0]:getPositionY())
    selectBatch:addChild(selectIcon, 0, l_1_0)
   end
  local unselected = function(l_2_0)
    herolist[l_2_0].isUsed = false
    blackBatch:removeChildByTag(l_2_0)
    selectBatch:removeChildByTag(l_2_0)
    local h = {}
    for i,v in ipairs(hids) do
      if v ~= herolist[l_2_0].hid then
        h[#h + 1] = v
      end
    end
    upvalue_1536 = h
   end
  for i,v in ipairs(l_4_0) do
    local y, x = SCROLLCONTENT_HEIGHT - math.ceil(i / 7) * 101 + 40, (i - math.ceil(i / 7) * 7 + 7) * 101 - 51
    local headBg = img.createUISprite(img.ui.herolist_head_bg)
    headBg:setPosition(x, y)
    iconBgBatch:addChild(headBg)
    headIcons[i] = img.createHeroHeadIcon(l_4_0[i].id)
    headIcons[i]:setPosition(x, y)
    scroll:getContainer():addChild(headIcons[i], 2)
    local groupBg = img.createUISprite(img.ui.herolist_group_bg)
    groupBg:setScale(0.42)
    groupBg:setPosition(x - 30, y + 30)
    groupBgBatch:addChild(groupBg)
    local groupIcon = img.createUISprite(img.ui.herolist_group_" .. cfghero[l_4_0[i].id].grou)
    groupIcon:setScale(0.42)
    groupIcon:setPosition(x - 30, y + 30)
    scroll:getContainer():addChild(groupIcon, 3)
    local showLv = lbl.createFont2(16, l_4_0[i].lv)
    showLv:setPosition(x + 26, y + 30)
    scroll:getContainer():addChild(showLv, 3)
    local quality = l_4_0[i].star
    local offset = x + 10 * quality / 2
    for j = 1, quality do
      local star = img.createUISprite(img.ui.herolist_star)
      star:setScale(0.35)
      star:setPosition(offset - j * 10 + 5, y - 34)
      starBatch:addChild(star)
    end
    if v.isUsed == true then
      selected(i)
    end
  end
  local lasty = nil
  local onTouchBegin = function(l_3_0, l_3_1)
    lasty = l_3_1
    return true
   end
  local onTouchMoved = function(l_4_0, l_4_1)
    return true
   end
  local onTouchEnd = function(l_5_0, l_5_1)
    local pointOnBoard = layer:convertToNodeSpace(ccp(l_5_0, l_5_1))
    if math.abs(l_5_1 - lasty) > 10 or not scroll:boundingBox():containsPoint(pointOnBoard) then
      return true
    end
    do
      local point = scroll:getContainer():convertToNodeSpace(ccp(l_5_0, l_5_1))
      for i,v in ipairs(headIcons) do
        if v:boundingBox():containsPoint(point) then
          if herolist[i].isUsed == false then
            selected(i)
            for i,v in (for generator) do
            end
            unselected(i)
          end
        end
        return true
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local onTouch = function(l_6_0, l_6_1, l_6_2)
    if l_6_0 == "began" then
      return onTouchBegin(l_6_1, l_6_2)
    elseif l_6_0 == "moved" then
      return onTouchMoved(l_6_1, l_6_2)
    else
      return onTouchEnd(l_6_1, l_6_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  return layer
end

herolist.create = function(l_5_0)
  local layer = CCLayer:create()
  if not l_5_0 then
    local params = {}
  end
  initConditon(params)
  if not params.hids then
    upvalue_512 = {}
  end
  local bg = img.createUISprite(img.ui.bag_bg)
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = HHMenuItem:create(btnBackSprite)
  btnBack:setScale(view.minScale)
  btnBack:setPosition(scalep(35, 546))
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  layer:addChild(menuBack, 1000)
  layer.back = btnBack
  btnBack:registerScriptTapHandler(function()
    layer:removeFromParentAndCleanup(true)
   end)
  local title = lbl.createFont3(30, "HERO ENCYCLOPEDIA", ccc3(250, 216, 105))
  title:setScale(view.minScale)
  title:setPosition(scalep(480, 545))
  layer:addChild(title, 100)
  local board = img.createUISprite(img.ui.herolist_bg)
  board:setScale(view.minScale)
  board:setPosition(view.midX - 15, view.midY - 20)
  layer:addChild(board)
  local heroNumLab = lbl.createFont1(20, "41/100", ccc3(112, 54, 25))
  heroNumLab:setPosition(110, 472)
  board:addChild(heroNumLab)
  local herolist = getHeroListData()
  local showHeroLayer = CCLayer:create()
  board:addChild(showHeroLayer)
  showHeroLayer:addChild(createHeroList(herolist), 1000)
  local group = nil
  local btnGroupList = {}
  for i = 1, 6 do
    do
      local btnGroupSpriteFg = img.createUISprite(img.ui.herolist_group_" .. )
      local btnGroupSpriteBg = img.createUISprite(img.ui.herolist_group_bg)
      btnGroupSpriteFg:setPosition(btnGroupSpriteBg:getContentSize().width / 2, btnGroupSpriteBg:getContentSize().height / 2 + 2)
      btnGroupSpriteBg:addChild(btnGroupSpriteFg)
      btnGroupList[i] = HHMenuItem:createWithScale(btnGroupSpriteBg, 1)
      local btnGroupMenu = CCMenu:createWithItem(btnGroupList[i])
      btnGroupMenu:setPosition(0, 0)
      board:addChild(btnGroupMenu, 10)
      btnGroupList[i]:setPosition(183 + 66 * i, 460)
      btnGroupList[i]:registerScriptTapHandler(function()
        for j = 1, 6 do
          btnGroupList[j]:unselected()
        end
        showHeroLayer:removeAllChildrenWithCleanup(true)
        if not group or group ~= i then
          upvalue_1024 = i
          btnGroupList[i]:selected()
          local tempParams = clone(params)
          tempParams.groups = {1 = i}
          initConditon(tempParams)
          showHeroLayer:addChild(createHeroList(getHeroListData()))
        else
          upvalue_1024 = nil
          initConditon(params)
          showHeroLayer:addChild(createHeroList(getHeroListData()))
        end
         end)
    end
  end
  local btnSortSprite = img.createUISprite(img.ui.herolist_button_pulldown)
  local btnSortIcon = img.createUISprite(img.ui.herolist_triangle)
  btnSortIcon:setPosition(78, 18)
  btnSortSprite:addChild(btnSortIcon)
  local btnSort = HHMenuItem:createWithScale(btnSortSprite, 1)
  local btnSortLab = lbl.createFont1(20, "Sort", ccc3(112, 54, 25))
  btnSortLab:setPosition(btnSort:getContentSize().width / 2 - 12, btnSort:getContentSize().height / 2)
  btnSort:addChild(btnSortLab)
  local btnSortMenu = CCMenu:createWithItem(btnSort)
  btnSortMenu:setPosition(0, 0)
  board:addChild(btnSortMenu, 10)
  btnSort:setPosition(715, 472)
  btnSort:registerScriptTapHandler(function()
   end)
  local btnBattleSprite = img.createLogin9Sprite(img.login.button_9_gold)
  btnBattleSprite:setPreferredSize(CCSize(173, 66))
  local btnBattle = HHMenuItem:createWithScale(btnBattleSprite, 1)
  local btnBattleLab = lbl.createFont1(20, "Battle", ccc3(112, 54, 25))
  btnBattleLab:setPosition(btnBattle:getContentSize().width / 2, btnBattle:getContentSize().height / 2)
  btnBattle:addChild(btnBattleLab)
  local btnBattleMenu = CCMenu:createWithItem(btnBattle)
  btnBattleMenu:setPosition(0, 0)
  board:addChild(btnBattleMenu, 10)
  btnBattle:setPosition(410, 75)
  btnBattle:registerScriptTapHandler(function()
    if params.handler then
      params.handler(clone(hids))
    end
    layer:removeFromParentAndCleanup(true)
   end)
  return layer
end

return herolist

