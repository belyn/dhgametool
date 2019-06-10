-- Command line was: E:\github\dhgametool\scripts\ui\herolist\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local cfghero = require("config.hero")
local heros = require("data.heros")
local cfgvip = require("config.vip")
local bag = require("data.bag")
local player = require("data.player")
local herotips = require("ui.tips.hero")
local cfgherBag = require("config.herobag")
local createBoardForRewards = function(l_1_0, l_1_1)
  local heroData = heros.find(l_1_0)
  local params = {}
  params.title = i18n.global.reward_will_get.string
  params.btn_count = 0
  local dialog = require("ui.dialog").create(params)
  local back = img.createLogin9Sprite(img.login.button_9_small_gold)
  back:setPreferredSize(CCSize(153, 50))
  local comfirlab = lbl.createFont1(18, i18n.global.summon_comfirm.string, lbl.buttonColor)
  comfirlab:setPosition(CCPoint(back:getContentSize().width / 2, back:getContentSize().height / 2))
  back:addChild(comfirlab)
  local backBtn = SpineMenuItem:create(json.ui.button, back)
  backBtn:setPosition(CCPoint(dialog.board:getContentSize().width / 2, 80))
  local menu = CCMenu:createWithItem(backBtn)
  menu:setPosition(0, 0)
  dialog.board:addChild(menu)
  dialog.board.tipsTag = false
  local hero = img.createHeroHeadByHid(l_1_0)
  heroBtn = SpineMenuItem:create(json.ui.button, hero)
  heroBtn:setScale(0.85)
  heroBtn:setPosition(dialog.board:getContentSize().width / 2, 185)
  local iconMenu = CCMenu:createWithItem(heroBtn)
  iconMenu:setPosition(0, 0)
  dialog.board:addChild(iconMenu)
  heroBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local heroInfo = clone(heroData.attr())
    heroInfo.lv = heroData.lv
    heroInfo.star = heroData.star
    heroInfo.id = heroData.id
    heroInfo.wake = heroData.wake
    local tips = herotips.create(heroInfo)
    dialog:addChild(tips, 1001)
   end)
  backBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    dialog:getParent():addChild(require("ui.hook.drops").create(reward, i18n.global.ui_decompose_preview.string), 1000)
    dialog:removeFromParentAndCleanup()
   end)
  dialog.setClickBlankHandler(function()
    dialog:getParent():addChild(require("ui.hook.drops").create(reward, i18n.global.ui_decompose_preview.string), 1000)
    dialog:removeFromParentAndCleanup()
   end)
  return dialog
end

ui.create = function(l_2_0)
  local layer = CCLayer:create()
  layer.needFresh = false
  if not l_2_0 then
    local params = {}
  end
  json.load(json.ui.lv10_framefx)
  local bg = img.createUISprite(img.ui.bag_bg)
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
  if params.reward then
    if params.hosthid then
      layer:addChild(createBoardForRewards(params.hosthid, params.reward), 1002)
    elseif params.heroes then
      layer:addChild(require("ui.bag.summonshow").create(params.heroes, i18n.global.transchange_gethero.string, params.reward), 1002)
    end
  end
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = HHMenuItem:create(btnBackSprite)
  btnBack:setScale(view.minScale)
  btnBack:setPosition(scalep(35, 546))
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  layer:addChild(menuBack, 1000)
  layer.back = btnBack
  btnBack:registerScriptTapHandler(function()
    audio.play(audio.button)
    if not params.back then
      replaceScene(require("ui.town.main").create())
    else
      if params.back == "hook" then
        replaceScene(require("ui.hook.map").create())
      end
    end
   end)
  autoLayoutShift(btnBack)
  local title = lbl.createFont3(30, i18n.global.herolist_title.string, ccc3(250, 216, 105))
  title:setScale(view.minScale)
  title:setPosition(scalep(480, 545))
  layer:addChild(title, 100)
  local showHeroLayer = nil
  local model = params.model or "Hero"
  local sortType = nil
  local group = params.group
  local board = img.createUISprite(img.ui.herolist_bg)
  board:setScale(view.minScale)
  board:setPosition(scalep(467, 272))
  layer:addChild(board)
  local vipLv = player.vipLv() or 0
  local heroNumLab = lbl.createFont1(16, #heros .. "/" .. cfgvip[vipLv].heroes + player.buy_hlimit * 5, ccc3(112, 54, 25))
  heroNumLab:setPosition(110, 472)
  board:addChild(heroNumLab)
  local btnAdd0 = img.createUISprite(img.ui.main_icon_plus)
  local btnAdd = SpineMenuItem:create(json.ui.button, btnAdd0)
  btnAdd:setScale(view.minScale)
  btnAdd:setPosition(scalep(215, 495))
  local btnAddMenu = CCMenu:createWithItem(btnAdd)
  btnAddMenu:setPosition(CCPoint(0, 0))
  layer:addChild(btnAddMenu)
  btnAdd:registerScriptTapHandler(function()
    local onAdd = function()
      if bag.gem() < cfgherBag[player.buy_hlimit + 1].cost then
        showToast(i18n.global.summon_gem_lack.string)
        return 
      else
        local params = {sid = player.sid}
        addWaitNet()
        net:buy_hlimit(params, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          bag.subGem(cfgherBag[player.buy_hlimit + 1].cost)
          player.buy_hlimit = player.buy_hlimit + 1
          heroNumLab:setString(#heros .. "/" .. cfgvip[vipLv].heroes + player.buy_hlimit * 5)
            end)
      end
      end
    if #cfgherBag <= player.buy_hlimit then
      showToast(i18n.global.toast_buy_herolist_full.string)
    else
      local pr = {title = "", text = string.format(i18n.global.herolist_buynum_text.string, cfgherBag[player.buy_hlimit + 1].cost, 5), handle = onAdd, scale = true}
      layer:addChild(require("ui.tips.confirm").create(pr), 100)
    end
   end)
  local btnHeroSprite0 = img.createUISprite(img.ui.herolist_tab_hero_nselect)
  local btnHeroSprite1 = img.createUISprite(img.ui.herolist_tab_hero_select)
  local btnHero = CCMenuItemSprite:create(btnHeroSprite0, btnHeroSprite1, btnHeroSprite0)
  local btnHeroMenu = CCMenu:createWithItem(btnHero)
  btnHero:setPosition(848, 318)
  btnHeroMenu:setPosition(0, 0)
  board:addChild(btnHeroMenu, 10)
  local btnBookSprite0 = img.createUISprite(img.ui.herolist_tab_book_nselect)
  local btnBookSprite1 = img.createUISprite(img.ui.herolist_tab_book_select)
  local btnBook = CCMenuItemSprite:create(btnBookSprite0, btnBookSprite1, btnBookSprite0)
  local btnBookMenu = CCMenu:createWithItem(btnBook)
  btnBook:setPosition(848, 195)
  btnBookMenu:setPosition(0, 0)
  board:addChild(btnBookMenu, 10)
  local btnGroupList = {}
  local getDataAndCreateList = nil
  if model == "Hero" then
    btnHero:selected()
    btnAdd:setVisible(true)
  else
    btnBook:selected()
    btnAdd:setVisible(false)
  end
  btnHero:registerScriptTapHandler(function()
    audio.play(audio.button)
    if model ~= "Hero" then
      btnHero:setEnabled(false)
      btnBook:setEnabled(true)
      title:setString(i18n.global.herolist_title.string)
      btnHero:selected()
      btnBook:unselected()
      upvalue_512 = "Hero"
      if group then
        btnGroupList[group]:unselected()
        upvalue_3072 = nil
      end
      btnAdd:setVisible(true)
      getDataAndCreateList()
    end
   end)
  btnBook:registerScriptTapHandler(function()
    audio.play(audio.button)
    if model ~= "Book" then
      btnHero:setEnabled(true)
      btnBook:setEnabled(false)
      title:setString(i18n.global.herolist_title_herobook.string)
      btnHero:unselected()
      btnBook:selected()
      upvalue_512 = "Book"
      btnAdd:setVisible(false)
      getDataAndCreateList()
    end
   end)
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
      local showSelect = img.createUISprite(img.ui.herolist_select_icon)
      showSelect:setPosition(btnGroupList[i]:getContentSize().width / 2, btnGroupList[i]:getContentSize().height / 2 + 2)
      btnGroupList[i]:addChild(showSelect)
      btnGroupList[i].showSelect = showSelect
      showSelect:setVisible(false)
      btnGroupList[i]:registerScriptTapHandler(function()
        audio.play(audio.button)
        for j = 1, 6 do
          btnGroupList[j]:unselected()
          btnGroupList[j].showSelect:setVisible(false)
        end
        if not group or i ~= group then
          upvalue_1024 = i
          btnGroupList[i]:selected()
          btnGroupList[i].showSelect:setVisible(true)
        else
          upvalue_1024 = nil
        end
        getDataAndCreateList()
         end)
    end
  end
  if group then
    btnGroupList[group]:selected()
    btnGroupList[group].showSelect:setVisible(true)
  end
  local createDownList = function()
    local layer = CCLayer:create()
    local bg = img.createUI9Sprite(img.ui.tips_bg)
    bg:setPreferredSize(CCSize(142, 116))
    bg:setPosition(707, 377)
    layer:addChild(bg)
    local btnLevelSprite = img.createUISprite(img.ui.herolist_pulldown)
    btnLevelSprite:setFlipY(true)
    local btnLevel = HHMenuItem:createWithScale(btnLevelSprite, 1)
    local btnLevelLab = lbl.createFont1(18, i18n.global.herolist_sort_lv.string)
    btnLevelLab:setPosition(btnLevel:getContentSize().width / 2, btnLevel:getContentSize().height / 2)
    btnLevel:addChild(btnLevelLab)
    if sortType == "Level" then
      btnLevelLab:setColor(ccc3(255, 219, 103))
    end
    local btnLevelMenu = CCMenu:createWithItem(btnLevel)
    btnLevel:setAnchorPoint(ccp(0.5, 0))
    btnLevel:setPosition(bg:getContentSize().width / 2, bg:getContentSize().height / 2)
    btnLevelMenu:setPosition(0, 0)
    bg:addChild(btnLevelMenu)
    btnLevel:registerScriptTapHandler(function()
      audio.play(audio.button)
      upvalue_512 = "Level"
      getDataAndCreateList()
      layer:removeFromParentAndCleanup(true)
      end)
    local btnStarSprite = img.createUISprite(img.ui.herolist_pulldown)
    local btnStar = HHMenuItem:createWithScale(btnStarSprite, 1)
    local btnStarLab = lbl.createFont1(18, i18n.global.herolist_sort_qlt.string)
    btnStarLab:setPosition(btnStar:getContentSize().width / 2, btnStar:getContentSize().height / 2)
    btnStar:addChild(btnStarLab)
    if sortType == "Star" then
      btnStarLab:setColor(ccc3(255, 219, 103))
    end
    local btnStarMenu = CCMenu:createWithItem(btnStar)
    btnStar:setAnchorPoint(ccp(0.5, 1))
    btnStar:setPosition(bg:getContentSize().width / 2, bg:getContentSize().height / 2 + 1)
    btnStarMenu:setPosition(0, 0)
    bg:addChild(btnStarMenu)
    btnStar:registerScriptTapHandler(function()
      audio.play(audio.button)
      upvalue_512 = "Star"
      getDataAndCreateList()
      layer:removeFromParentAndCleanup(true)
      end)
    layer:registerScriptTouchHandler(function()
      layer:removeFromParentAndCleanup(true)
      return true
      end)
    layer:setTouchEnabled(true)
    return layer
   end
  local btnSortSprite = img.createUISprite(img.ui.herolist_button_pulldown)
  local btnSortIcon = img.createUISprite(img.ui.herolist_triangle)
  btnSortIcon:setPosition(78, 18)
  btnSortSprite:addChild(btnSortIcon)
  local btnSort = HHMenuItem:createWithScale(btnSortSprite, 1)
  local btnSortLab = lbl.createFont1(12, i18n.global.herolist_sort_btn.string, ccc3(112, 54, 25))
  btnSortLab:setPosition(btnSort:getContentSize().width / 2 - 12, btnSort:getContentSize().height / 2)
  btnSort:addChild(btnSortLab)
  local btnSortMenu = CCMenu:createWithItem(btnSort)
  btnSortMenu:setPosition(0, 0)
  board:addChild(btnSortMenu, 10)
  btnSort:setPosition(715, 472)
  btnSort:registerScriptTapHandler(function()
    audio.play(audio.button)
    board:addChild(createDownList(), 1000)
   end)
  local createHeroList = function(l_8_0)
    local layer = CCLayer:create()
    local SCROLLVIEW_WIDTH = 710
    local SCROLLVIEW_HEIGHT = 411
    local SCROLLCONTENT_HEIGHT = 23 + 101 * math.ceil(#l_8_0 / 7)
    local scroll = CCScrollView:create()
    scroll:setDirection(kCCScrollViewDirectionVertical)
    scroll:setAnchorPoint(ccp(0, 0))
    scroll:setPosition(66, 29)
    scroll:setViewSize(CCSize(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT))
    scroll:setContentSize(CCSize(SCROLLVIEW_WIDTH, SCROLLCONTENT_HEIGHT))
    scroll:setContentOffset(ccp(0, SCROLLVIEW_HEIGHT - SCROLLCONTENT_HEIGHT))
    layer:addChild(scroll)
    local iconBgBatch = img.createBatchNodeForUI(img.ui.herolist_head_bg)
    scroll:getContainer():addChild(iconBgBatch, 1)
    local iconBgBatch1 = img.createBatchNodeForUI(img.ui.hero_star_ten_bg)
    scroll:getContainer():addChild(iconBgBatch1, 1)
    local groupBgBatch = img.createBatchNodeForUI(img.ui.herolist_group_bg)
    scroll:getContainer():addChild(groupBgBatch, 3)
    local starBatch = img.createBatchNodeForUI(img.ui.star_s)
    scroll:getContainer():addChild(starBatch, 3)
    local star1Batch = img.createBatchNodeForUI(img.ui.hero_star_orange)
    scroll:getContainer():addChild(star1Batch, 3)
    local star10Batch = img.createBatchNodeForUI(img.ui.hero_star_ten)
    scroll:getContainer():addChild(star10Batch, 3)
    local blackBatch = img.createBatchNodeForUI(img.ui.hero_head_shade)
    scroll:getContainer():addChild(blackBatch, 5)
    local headIcons = {}
    local createItem = function(l_1_0, l_1_1)
      local y, x = SCROLLCONTENT_HEIGHT - math.ceil(l_1_0 / 7) * 101 + 40, (l_1_0 - math.ceil(l_1_0 / 7) * 7 + 7) * 101 - 51
      local headBg = nil
      local qlt = cfghero[herolist[l_1_0].id].maxStar
      if qlt == 10 then
        headBg = img.createUISprite(img.ui.hero_star_ten_bg)
        headBg:setPosition(x, y)
        iconBgBatch1:addChild(headBg)
        local aniten = DHSkeletonAnimation:createWithKey(json.ui.lv10_framefx)
        aniten:playAnimation("animation", -1)
        aniten:scheduleUpdateLua()
        aniten:setPosition(x, y)
        scroll:getContainer():addChild(aniten, 4)
      else
        headBg = img.createUISprite(img.ui.herolist_head_bg)
        headBg:setPosition(x, y)
        iconBgBatch:addChild(headBg)
      end
      if herolist[l_1_0].hid then
        headIcons[l_1_0] = img.createHeroHeadByHid(herolist[l_1_0].hid)
      else
        headIcons[l_1_0] = img.createHeroHeadIcon(herolist[l_1_0].id)
        local groupBg = img.createUISprite(img.ui.herolist_group_bg)
        groupBg:setScale(0.42)
        groupBg:setPosition(x - 30, y + 29)
        groupBgBatch:addChild(groupBg)
        local groupIcon = img.createUISprite(img.ui.herolist_group_" .. cfghero[herolist[l_1_0].id].grou)
        groupIcon:setScale(0.42)
        groupIcon:setPosition(x - 30, y + 30)
        scroll:getContainer():addChild(groupIcon, 3)
        local showLv = lbl.createFont2(16, herolist[l_1_0].lv)
        showLv:setPosition(x + 26, y + 30)
        scroll:getContainer():addChild(showLv, 3)
        if qlt <= 5 then
          for i = qlt, 1, -1 do
            local star = img.createUISprite(img.ui.star_s)
            star:setPosition(x + (i - (qlt + 1) / 2) * 12, y - 32)
            starBatch:addChild(star)
          end
        elseif qlt == 6 then
          local redstar = 1
          if herolist[l_1_0].wake then
            redstar = herolist[l_1_0].wake + 1
          end
          for i = redstar, 1, -1 do
            local star = img.createUISprite(img.ui.hero_star_orange)
            star:setScale(0.75)
            star:setPosition(x + (i - (redstar + 1) / 2) * 12, y - 30)
            star1Batch:addChild(star)
          end
        elseif qlt == 10 then
          local star = img.createUISprite(img.ui.hero_star_ten)
          star:setPosition(x, y - 30)
          star10Batch:addChild(star)
        end
      end
      headIcons[l_1_0]:setPosition(x, y)
      scroll:getContainer():addChild(headIcons[l_1_0], 2)
      if model ~= "Hero" and not l_1_1.isHave then
        local blackBoard = img.createUISprite(img.ui.hero_head_shade)
        blackBoard:setScale(0.95744680851064)
        blackBoard:setOpacity(120)
        blackBoard:setPosition(headIcons[l_1_0]:getPositionX(), headIcons[l_1_0]:getPositionY())
        blackBatch:addChild(blackBoard, 0, l_1_0)
      end
      end
    local initShowCount = 60
    for i,v in ipairs(l_8_0) do
      if initShowCount < i then
        do return end
      end
      createItem(i, v)
    end
    local heroCount = #l_8_0
    local showAfter = function()
      if initShowCount < heroCount then
        initShowCount = initShowCount + 1
        createItem(initShowCount, herolist[initShowCount])
        return true
      end
      end
    if heroCount == 0 then
      local empty = require("ui.empty").create({text = i18n.global.empty_herolist.string, color = ccc3(217, 187, 157)})
      empty:setPosition(board:getContentSize().width / 2, board:getContentSize().height / 2)
      layer:addChild(empty)
    elseif initShowCount < heroCount then
      layer:scheduleUpdateWithPriorityLua(function(l_3_0)
      if showAfter() and showAfter() then
        showAfter()
      end
      end, 0)
    end
    local lasty = nil
    local onTouchBegin = function(l_4_0, l_4_1)
      lasty = l_4_1
      return true
      end
    local onTouchMoved = function(l_5_0, l_5_1)
      return true
      end
    local onTouchEnd = function(l_6_0, l_6_1)
      local pointOnBoard = layer:convertToNodeSpace(ccp(l_6_0, l_6_1))
      if math.abs(l_6_1 - lasty) > 10 or not scroll:boundingBox():containsPoint(pointOnBoard) then
        return true
      end
      do
        local point = scroll:getContainer():convertToNodeSpace(ccp(l_6_0, l_6_1))
        for i,v in ipairs(headIcons) do
          if v:boundingBox():containsPoint(point) then
            audio.play(audio.button)
            if model == "Hero" then
              bg:getParent():addChild(require("ui.hero.main").create(herolist[i].hid, group, herolist, i), 10000)
              for i,v in (for generator) do
              end
              bg:getParent():addChild(require("ui.herolist.herobook").create(herolist[i].id, nil, herolist, i), 10000)
            end
          end
          return true
        end
         -- Warning: missing end command somewhere! Added here
      end
      end
    local onTouch = function(l_7_0, l_7_1, l_7_2)
      if l_7_0 == "began" then
        return onTouchBegin(l_7_1, l_7_2)
      elseif l_7_0 == "moved" then
        return onTouchMoved(l_7_1, l_7_2)
      else
        return onTouchEnd(l_7_1, l_7_2)
      end
      end
    layer:registerScriptTouchHandler(onTouch)
    layer:setTouchEnabled(true)
    return layer
   end
  getDataAndCreateList = function()
    local herolist = {}
    if model == "Hero" then
      for _,v in ipairs(heros) do
        if not group or cfghero[v.id].group == group then
          herolist[#herolist + 1] = {hid = v.hid, id = v.id, lv = v.lv, star = v.star, wake = v.wake}
        end
      end
      btnSort:setVisible(true)
      heroNumLab:setVisible(true)
      if sortType == "Level" then
        for i = 1, #herolist do
          for j = i + 1, #herolist do
            if herolist[i].lv < herolist[j].lv then
              herolist[i], herolist[j] = herolist[j], herolist[i]
            end
          end
        end
      elseif sortType == "Star" then
        for i = 1, #herolist do
          for j = i + 1, #herolist do
            if cfghero[herolist[i].id].qlt < cfghero[herolist[j].id].qlt then
              herolist[i], herolist[j] = herolist[j], herolist[i]
            end
            if herolist[i].wake == nil and herolist[j].wake then
              herolist[i], herolist[j] = herolist[j], herolist[i]
            end
            if herolist[i].wake and herolist[j].wake and herolist[i].wake < herolist[j].wake then
              herolist[i], herolist[j] = herolist[j], herolist[i]
            end
          end
        end
      else
        table.sort(herolist, compareHero)
      end
    elseif not group then
      upvalue_1024 = 1
      btnGroupList[1]:selected()
      btnGroupList[1].showSelect:setVisible(true)
    end
    for _,v in pairs(cfghero) do
      if v.showInGuide > 0 and (not group or v.group == group) then
        herolist[#herolist + 1] = {id = _, lv = cfghero[_].maxLv}
      end
    end
    for i = 1, #herolist do
      for j = i + 1, #herolist do
        if herolist[j].id < herolist[i].id then
          herolist[i], herolist[j] = herolist[j], herolist[i]
        end
      end
    end
    do
      local herobook = require("data.herobook")
      for i = 1, #herolist do
        herolist[i].isHave = false
        for j = 1, #herobook do
          if herolist[i].id == herobook[j] then
            herolist[i].isHave = true
          end
        end
      end
      btnSort:setVisible(false)
      heroNumLab:setVisible(false)
    end
    if showHeroLayer then
      showHeroLayer:removeFromParentAndCleanup(true)
      upvalue_4096 = nil
    end
    upvalue_4096 = createHeroList(herolist)
    board:addChild(showHeroLayer)
   end
  getDataAndCreateList()
  layer:scheduleUpdateWithPriorityLua(function()
    if layer.needFresh == true then
      layer.needFresh = false
      getDataAndCreateList()
    end
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    if not params.back then
      replaceScene(require("ui.town.main").create())
    else
      if params.back == "hook" then
        replaceScene(require("ui.hook.map").create())
      end
    end
   end
  local onEnter = function()
    print("onEnter")
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
  require("ui.tutorial").show("ui.hero.main", layer)
  return layer
end

return ui

