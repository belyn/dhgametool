-- Command line was: E:\github\dhgametool\scripts\ui\devour\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local particle = require("res.particle")
local player = require("data.player")
local net = require("net.netClient")
local heros = require("data.heros")
local cfghero = require("config.hero")
local audio = require("res.audio")
local bag = require("data.bag")
local particle = require("res.particle")
local cfgequip = require("config.equip")
local MAX_NUM = 12
ui.create = function()
  local layer = CCLayer:create()
  img.load(img.packedOthers.ui_devour_bg)
  sortType = nil
  local bgg = img.createUISprite(img.ui.devour_bg)
  bgg:setScale(view.minScale)
  bgg:setPosition(view.midX, view.midY)
  layer:addChild(bgg)
  local bg = CCSprite:create()
  bg:setContentSize(CCSizeMake(960, 576))
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
  local shopBg = img.createUISprite(img.ui.main_btn_shop_bg)
  shopBg:setScale(view.minScale)
  shopBg:setAnchorPoint(CCPoint(1, 1))
  shopBg:setPosition(scalep(993, 576))
  layer:addChild(shopBg)
  autoLayoutShift(shopBg)
  local btnInfoSprite = img.createUISprite(img.ui.btn_help)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  btnInfo:setScale(view.minScale)
  btnInfo:setPosition(scalep(820, 542))
  local menuInfo = CCMenu:createWithItem(btnInfo)
  menuInfo:setPosition(0, 0)
  layer:addChild(menuInfo, 100)
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.help").create(i18n.global.help_devour.string, i18n.global.help_title.string), 1000)
   end)
  autoLayoutShift(btnInfo, true, false, false, true)
  local particle_scale = view.minScale
  local particle_shop = particle.create("ui_shop")
  particle_shop:setScale(particle_scale)
  particle_shop:setPosition(scalep(910, 511))
  layer:addChild(particle_shop, 100)
  autoLayoutShift(particle_shop)
  local btnShop0 = img.createUISprite(img.ui.rune_store)
  local btnShop = HHMenuItem:createWithScale(btnShop0, 1)
  btnShop:setPosition(CCPoint(shopBg:getContentSize().width - 49 - 31, shopBg:getContentSize().height - 43))
  local btnShopMenu = CCMenu:createWithItem(btnShop)
  btnShopMenu:setPosition(CCPoint(0, 0))
  shopBg:addChild(btnShopMenu)
  btnShop:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.heromarket.main").create(), 1000)
   end)
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
    replaceScene(require("ui.town.main").create())
   end)
  autoLayoutShift(btnBack)
  json.load(json.ui.devour_in_animation)
  local bgAnim = DHSkeletonAnimation:createWithKey(json.ui.devour_in_animation)
  bgAnim:scheduleUpdateLua()
  bgAnim:setPosition(480, 288)
  bgAnim:playAnimation("animation")
  bg:addChild(bgAnim)
  local rigBg = img.createUI9Sprite(img.ui.bag_outer)
  rigBg:setPreferredSize(CCSize(424, 472))
  rigBg:setPosition(0, -10)
  bgAnim:addChildFollowSlot("code_right_plate", rigBg)
  local lefBg = img.createUI9Sprite(img.ui.bag_outer)
  lefBg:setPreferredSize(CCSize(430, 472))
  lefBg:setPosition(0, -34)
  bgAnim:addChildFollowSlot("code_left_plate", lefBg)
  local lefBoard = img.createUI9Sprite(img.ui.devour_lef_bg)
  lefBoard:setPreferredSize(CCSize(393, 307))
  lefBoard:setAnchorPoint(ccp(0.5, 0))
  lefBoard:setPosition(lefBg:getContentSize().width / 2, 142)
  lefBg:addChild(lefBoard, 1)
  local lefTitle = img.createUISprite(img.ui.devour_lef_title)
  lefTitle:setAnchorPoint(ccp(0.5, 0))
  lefTitle:setPosition(188, 446)
  lefBg:addChild(lefTitle, 1)
  local showTitle = lbl.createFont2(22, i18n.global.devour_lef_title.string, ccc3(246, 215, 113))
  showTitle:setPosition(lefTitle:getContentSize().width / 2, 20)
  lefTitle:addChild(showTitle)
  local btnSmartSp = img.createLogin9Sprite(img.login.button_9_small_green)
  btnSmartSp:setPreferredSize(CCSize(175, 58))
  local labSmart = lbl.createFont1(18, i18n.global.devour_btn_smart.string, ccc3(6, 104, 12))
  labSmart:setPosition(btnSmartSp:getContentSize().width / 2, btnSmartSp:getContentSize().height / 2)
  btnSmartSp:addChild(labSmart)
  local btnSmart = HHMenuItem:createWithScale(btnSmartSp, 1)
  local menuSmart = CCMenu:createWithItem(btnSmart)
  menuSmart:setPosition(0, 0)
  lefBg:addChild(menuSmart)
  btnSmart:setPosition(lefBg:getContentSize().width / 2 - 92, 85)
  local btnPreviewSp = img.createUISprite(img.ui.devour_find)
  local btnPreview = HHMenuItem:createWithScale(btnPreviewSp, 1)
  local menuPreview = CCMenu:createWithItem(btnPreview)
  menuPreview:setPosition(0, 0)
  lefBg:addChild(menuPreview, 1)
  menuPreview:setPosition(360, 465)
  local expBg = img.createUI9Sprite(img.ui.main_coin_bg)
  expBg:setPreferredSize(CCSizeMake(174, 40))
  expBg:setAnchorPoint(CCPoint(1, 0.5))
  expBg:setPosition(472, 544)
  bg:addChild(expBg)
  autoLayoutShift(expBg)
  local expAll = img.createItemIcon(ITEM_ID_HERO_EXP)
  expAll:setScale(0.55)
  expAll:setPosition(16, 24)
  expBg:addChild(expAll)
  local showExpAll = lbl.createFont2(16, "", ccc3(255, 247, 229))
  showExpAll:setPosition(expBg:getContentSize().width / 2 + 5, expBg:getContentSize().height / 2 + 2)
  expBg:addChild(showExpAll)
  local evolveBg = img.createUI9Sprite(img.ui.main_coin_bg)
  evolveBg:setPreferredSize(CCSizeMake(174, 40))
  evolveBg:setAnchorPoint(CCPoint(0, 0.5))
  evolveBg:setPosition(488, 544)
  bg:addChild(evolveBg, 1000)
  autoLayoutShift(evolveBg)
  local evolveAll = img.createItemIcon(ITEM_ID_EVOLVE_EXP)
  evolveAll:setScale(0.55)
  evolveAll:setPosition(16, 23)
  evolveBg:addChild(evolveAll)
  local showEvolveAll = lbl.createFont2(16, "", ccc3(255, 247, 229))
  showEvolveAll:setPosition(evolveBg:getContentSize().width / 2 + 5, evolveBg:getContentSize().height / 2 + 2)
  evolveBg:addChild(showEvolveAll)
  local showExpBg = img.createUI9Sprite(img.ui.select_hero_camp_bg)
  showExpBg:setAnchorPoint(ccp(0, 0.5))
  showExpBg:setPreferredSize(CCSize(115, 29))
  showExpBg:setPosition(33, 120)
  lefBg:addChild(showExpBg)
  local showEvolveBg = img.createUI9Sprite(img.ui.select_hero_camp_bg)
  showEvolveBg:setAnchorPoint(ccp(0, 0.5))
  showEvolveBg:setPreferredSize(CCSize(115, 29))
  showEvolveBg:setPosition(158, 120)
  lefBg:addChild(showEvolveBg)
  local showRuneBg = img.createUI9Sprite(img.ui.select_hero_camp_bg)
  showRuneBg:setPreferredSize(CCSize(115, 29))
  showRuneBg:setAnchorPoint(ccp(0, 0.5))
  showRuneBg:setPosition(283, 120)
  lefBg:addChild(showRuneBg)
  local showExpIcon = img.createItemIcon(ITEM_ID_HERO_EXP)
  showExpIcon:setScale(0.5)
  showExpIcon:setPosition(15, 15)
  showExpBg:addChild(showExpIcon)
  local showEvolveIcon = img.createItemIcon(ITEM_ID_EVOLVE_EXP)
  showEvolveIcon:setScale(0.5)
  showEvolveIcon:setPosition(15, 15)
  showEvolveBg:addChild(showEvolveIcon)
  local showRuneIcon = img.createItemIcon(ITEM_ID_RUNE_COIN)
  showRuneIcon:setScale(0.5)
  showRuneIcon:setPosition(15, 15)
  showRuneBg:addChild(showRuneIcon)
  local showExp = lbl.createFont2(16, "0")
  showExp:setPosition(67, 15)
  showExpBg:addChild(showExp)
  local showEvolve = lbl.createFont2(16, "0")
  showEvolve:setPosition(67, 15)
  showEvolveBg:addChild(showEvolve)
  local showRune = lbl.createFont2(16, "0")
  showRune:setPosition(67, 15)
  showRuneBg:addChild(showRune)
  showExpBg:setVisible(false)
  showEvolveBg:setVisible(false)
  showRuneBg:setVisible(false)
  local btnDevourSp = img.createLogin9Sprite(img.login.button_9_small_orange)
  btnDevourSp:setPreferredSize(CCSize(175, 58))
  local labDevour = lbl.createFont1(18, i18n.global.devour_btn.string, ccc3(118, 37, 5))
  labDevour:setPosition(btnDevourSp:getContentSize().width / 2, btnDevourSp:getContentSize().height / 2)
  btnDevourSp:addChild(labDevour)
  local btnDevour = SpineMenuItem:create(json.ui.button, btnDevourSp)
  btnDevour:setPosition(lefBg:getContentSize().width / 2 + 92, 85)
  local menuDevour = CCMenu:createWithItem(btnDevour)
  menuDevour:setPosition(0, 0)
  lefBg:addChild(menuDevour)
  local innerBg = img.createUI9Sprite(img.ui.bag_inner)
  innerBg:setPreferredSize(CCSize(375, 356))
  innerBg:setPosition(rigBg:getContentSize().width / 2, 257)
  rigBg:addChild(innerBg)
  local heroBase = {}
  local baseAnim = {}
  for i = 1, MAX_NUM do
    heroBase[i] = img.createUI9Sprite(img.ui.herolist_withouthero_bg)
    heroBase[i]:setPreferredSize(CCSize(76, 76))
    heroBase[i]:setPosition(68 + (i - 1) % 4 * 86, 328 - math.ceil(i / 4) * 87)
    lefBoard:addChild(heroBase[i])
    local showIcon = img.createUISprite(img.ui.devour_add_icon)
    showIcon:setPosition(heroBase[i]:getContentSize().width / 2, heroBase[i]:getContentSize().height / 2)
    heroBase[i]:addChild(showIcon)
    json.load(json.ui.devour_fx_v2)
    baseAnim[i] = DHSkeletonAnimation:createWithKey(json.ui.devour_fx_v2)
    baseAnim[i]:scheduleUpdateLua()
    baseAnim[i]:setPosition(heroBase[i]:getPositionX(), heroBase[i]:getPositionY())
    lefBoard:addChild(baseAnim[i], 1)
  end
  local showHeroNum = lbl.createFont1(18, string.format(i18n.global.devour_rig_title.string, 0, 0), ccc3(111, 76, 56))
  showHeroNum:setPosition(rigBg:getContentSize().width / 2, 450)
  rigBg:addChild(showHeroNum)
  local SCROLLVIEW_WIDTH = 357
  local SCROLLVIEW_HEIGHT = 330
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(10, 15)
  scroll:setViewSize(CCSize(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT))
  innerBg:addChild(scroll)
  local blackBatch, selectBatch = nil, nil
  local starType = 0
  local groupType = 0
  local headIcons = {}
  local hids = {}
  local showHeros = {}
  local herolist = {}
  local createHerolist = function()
    arrayclear(headIcons)
    arrayclear(herolist)
    scroll:getContainer():removeAllChildrenWithCleanup(true)
    if innerBg:getChildByTag(101) then
      innerBg:removeChildByTag(101)
    end
    local tmp = clone(heros)
    for i = 1, #tmp do
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if groupType == 0 and (cfghero[tmp[i].id].qlt == starType or starType == 0) then
        herolist[#herolist + 1] = tmp[i]
        do return end
        if (cfghero[tmp[i].id].qlt == starType or starType == 0) and cfghero[tmp[i].id].group == groupType then
          herolist[#herolist + 1] = tmp[i]
        end
      end
    end
    table.sort(herolist, compareHero)
    for i = 1, #herolist / 2 do
      herolist[i], herolist[#herolist - i + 1] = herolist[#herolist - i + 1], herolist[i]
    end
    if #herolist == 0 then
      local empty = require("ui.empty").create({text = i18n.global.empty_herodevour.string, scale = 0.9, size = 14, color = ccc3(255, 246, 223)})
      empty:setPosition(innerBg:getContentSize().width / 2, innerBg:getContentSize().height / 2)
      innerBg:addChild(empty, 0, 101)
    end
    showHeroNum:setString(string.format(i18n.global.devour_rig_title.string, #herolist, #heros))
    local SCROLLCONTENT_HEIGHT = math.ceil(#herolist / 4) * 84 + 10
    scroll:setContentSize(CCSizeMake(SCROLLVIEW_WIDTH, SCROLLCONTENT_HEIGHT))
    scroll:setContentOffset(ccp(0, SCROLLVIEW_HEIGHT - SCROLLCONTENT_HEIGHT))
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
    upvalue_6656 = img.createBatchNodeForUI(img.ui.hero_head_shade)
    scroll:getContainer():addChild(blackBatch, 4)
    upvalue_7168 = img.createBatchNodeForUI(img.ui.hook_btn_sel)
    scroll:getContainer():addChild(selectBatch, 5)
    local lockBatch = img.createBatchNodeForUI(img.ui.devour_icon_lock)
    scroll:getContainer():addChild(lockBatch, 6)
    for i = 1, #herolist do
      local x, y = 53 + (i - 1) % 4 * 84, SCROLLCONTENT_HEIGHT - math.ceil(i / 4) * 84 + 30
      local qlt = cfghero[herolist[i].id].maxStar
      local heroBg = nil
      if qlt == 10 then
        headBg = img.createUISprite(img.ui.hero_star_ten_bg)
        headBg:setPosition(x, y)
        headBg:setScale(0.8)
        iconBgBatch1:addChild(headBg)
        json.load(json.ui.lv10_framefx)
        local aniten = DHSkeletonAnimation:createWithKey(json.ui.lv10_framefx)
        aniten:playAnimation("animation", -1)
        aniten:scheduleUpdateLua()
        aniten:setScale(0.8)
        aniten:setPosition(x, y)
        scroll:getContainer():addChild(aniten, 3)
      else
        heroBg = img.createUISprite(img.ui.herolist_head_bg)
        heroBg:setScale(0.8)
        heroBg:setPosition(x, y)
        iconBgBatch:addChild(heroBg)
      end
      headIcons[i] = img.createHeroHeadIcon(herolist[i].id)
      headIcons[i]:setScale(0.8)
      headIcons[i]:setPosition(x, y)
      scroll:getContainer():addChild(headIcons[i], 2)
      local groupBg = img.createUISprite(img.ui.herolist_group_bg)
      groupBg:setScale(0.336)
      groupBg:setPosition(x - 24, y + 24)
      groupBgBatch:addChild(groupBg)
      local groupIcon = img.createUISprite(img.ui.herolist_group_" .. cfghero[herolist[i].id].grou)
      groupIcon:setScale(0.336)
      groupIcon:setPosition(x - 24, y + 25)
      scroll:getContainer():addChild(groupIcon, 3)
      local showLv = lbl.createFont2(12, herolist[i].lv)
      showLv:setPosition(x + 23, y + 24)
      scroll:getContainer():addChild(showLv, 3)
      if qlt <= 5 then
        for i = qlt, 1, -1 do
          local star = img.createUISprite(img.ui.star_s)
          star:setScale(0.8)
          star:setPosition(x + (i - (qlt + 1) / 2) * 12 * 0.8, y - 26)
          starBatch:addChild(star)
        end
      elseif qlt == 6 then
        local redstar = 1
        if herolist[i].wake then
          redstar = herolist[i].wake + 1
        end
        for i = redstar, 1, -1 do
          local star = img.createUISprite(img.ui.hero_star_orange)
          star:setScale(0.6)
          star:setPosition(x + (i - (redstar + 1) / 2) * 12 * 0.8, y - 24)
          star1Batch:addChild(star)
        end
      elseif qlt == 10 then
        local redstar = 1
        if herolist[i].wake then
          redstar = herolist[i].wake + 1
        end
        if redstar and redstar > 5 then
          json.load(json.ui.lv10plus_hero)
          local energizeStar = DHSkeletonAnimation:createWithKey(json.ui.lv10plus_hero)
          energizeStar:scheduleUpdateLua()
          energizeStar:playAnimation("animation", -1)
          energizeStar:setPosition(x, y - 24)
          scroll:getContainer():addChild(energizeStar, 3)
          local energizeStarLab = lbl.createFont2(26, redstar - 4 - 1)
          energizeStarLab:setPosition(energizeStar:getContentSize().width / 2, 0)
          energizeStar:addChild(energizeStarLab)
          energizeStar:setScale(0.53)
        else
          local starIcon2 = img.createUISprite(img.ui.hero_star_ten)
          starIcon2:setScale(0.8)
          starIcon2:setPosition(x, y - 24)
          star10Batch:addChild(starIcon2)
        end
      end
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
        if math.floor(herolist[i].flag / 4) % 2 % 2 == 1 then
          if count >= 1 then
            text = text .. "\n"
          end
          text = text .. i18n.global.toast_devour_3v3arena.string
          count = count + 1
        end
        if math.floor(herolist[i].flag / 8) % 2 % 2 % 2 == 1 then
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
      for j = 1, MAX_NUM do
        if hids[j] and hids[j] == herolist[i].hid then
          herolist[i].isUsed = true
          local blackBoard = img.createUISprite(img.ui.hero_head_shade)
          blackBoard:setScale(0.85106382978723)
          blackBoard:setOpacity(120)
          blackBoard:setPosition(headIcons[i]:getPositionX(), headIcons[i]:getPositionY())
          blackBatch:addChild(blackBoard, 0, i)
          local selectIcon = img.createUISprite(img.ui.hook_btn_sel)
          selectIcon:setPosition(headIcons[i]:getPositionX(), headIcons[i]:getPositionY())
          selectBatch:addChild(selectIcon, 0, i)
        end
      end
    end
   end
  createHerolist()
  local setStarType = function(l_5_0)
    starType = l_5_0
   end
  local setGroupType = function(l_6_0)
    groupType = l_6_0
   end
  local btnFilterSp = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnFilterSp:setPreferredSize(CCSize(135, 50))
  local labFilter = lbl.createFont1(18, i18n.global.selecthero_btn_hero.string, ccc3(115, 59, 5))
  labFilter:setPosition(btnFilterSp:getContentSize().width / 2, btnFilterSp:getContentSize().height / 2)
  btnFilterSp:addChild(labFilter)
  local btnFilter = HHMenuItem:createWithScale(btnFilterSp, 1)
  local menuFilter = CCMenu:createWithItem(btnFilter)
  menuFilter:setPosition(0, 0)
  rigBg:addChild(menuFilter)
  btnFilter:setPosition(rigBg:getContentSize().width / 2, 48)
  btnFilter:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.devour.filtertips").createFilterBoard(starType, groupType, createHerolist, setStarType, setGroupType), 100)
   end)
  local checkIfBlank = function()
    for i = 1, MAX_NUM do
      if not hids[i] then
        return true
      end
    end
    return false
   end
  local checkNum = function()
    local teams = {}
    for i = 1, MAX_NUM do
      if hids[i] then
        teams[#teams + 1] = hids[i]
      end
    end
    local exp, evolve, rune = heros.decompose(teams)
    showRune:setString(num2KM(math.floor(rune)))
    showExp:setString(num2KM(math.floor(exp)))
    showEvolve:setString(num2KM(math.floor(evolve)))
   end
  local onSelect = function(l_10_0)
    for i = 1, MAX_NUM do
      if not hids[i] or hids[i] == 0 then
        hids[i] = herolist[l_10_0].hid
        herolist[l_10_0].isUsed = true
        showHeros[i] = img.createHeroHead(herolist[l_10_0].id, herolist[l_10_0].lv, true, true, herolist[l_10_0].wake)
        showHeros[i]:setScale(0.8)
        showHeros[i]:setPosition(heroBase[i]:getPositionX(), heroBase[i]:getPositionY())
        lefBoard:addChild(showHeros[i])
        local blackBoard = img.createUISprite(img.ui.hero_head_shade)
        blackBoard:setScale(0.85106382978723)
        blackBoard:setOpacity(120)
        blackBoard:setPosition(headIcons[l_10_0]:getPositionX(), headIcons[l_10_0]:getPositionY())
        blackBatch:addChild(blackBoard, 0, l_10_0)
        local selectIcon = img.createUISprite(img.ui.hook_btn_sel)
        selectIcon:setPosition(headIcons[l_10_0]:getPositionX(), headIcons[l_10_0]:getPositionY())
        selectBatch:addChild(selectIcon, 0, l_10_0)
        checkNum()
        return 
      end
    end
   end
  local unSelect = function(l_11_0)
    for i = 1, #herolist do
      if herolist[i].hid == hids[l_11_0] then
        blackBatch:removeChildByTag(i)
        selectBatch:removeChildByTag(i)
        herolist[i].isUsed = false
      end
    end
    hids[l_11_0] = nil
    showHeros[l_11_0]:removeFromParentAndCleanup(true)
    showHeros[l_11_0] = nil
    checkNum()
   end
  local lasty = nil
  local onTouchBegin = function(l_12_0, l_12_1)
    lasty = l_12_1
    return true
   end
  local onTouchMoved = function(l_13_0, l_13_1)
    return true
   end
  local onTouchEnd = function(l_14_0, l_14_1)
    if math.abs(l_14_1 - lasty) > 10 then
      return 
    end
    local pointOnScroll = scroll:getContainer():convertToNodeSpace(ccp(l_14_0, l_14_1))
    for i,v in ipairs(headIcons) do
      if v:boundingBox():containsPoint(pointOnScroll) then
        if herolist[i].lock then
          showToast(herolist[i].lock)
          return 
        end
        if not herolist[i].isUsed then
          onSelect(i)
          for i,v in (for generator) do
          end
          for j = 1, MAX_NUM do
            if hids[j] and hids[j] == herolist[i].hid then
              unSelect(j)
            end
          end
        end
      end
      do
        local pointOnBoard = lefBoard:convertToNodeSpace(ccp(l_14_0, l_14_1))
        for i = 1, MAX_NUM do
          if hids[i] and showHeros[i] and showHeros[i]:boundingBox():containsPoint(pointOnBoard) then
            unSelect(i)
          end
        end
        return true
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local onTouch = function(l_15_0, l_15_1, l_15_2)
    if l_15_0 == "began" then
      return onTouchBegin(l_15_1, l_15_2)
    elseif l_15_0 == "moved" then
      return onTouchMoved(l_15_1, l_15_2)
    else
      return onTouchEnd(l_15_1, l_15_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  local playParticle = function()
    local animlayer = CCLayer:create()
    layer:addChild(animlayer, 10000)
    local part1 = particle.create("devour_particle_01")
    part1:setStartSize(part1:getStartSize() * view.minScale)
    part1:setStartSizeVar(part1:getStartSizeVar() * view.minScale)
    part1:setEndSize(part1:getEndSize() * view.minScale)
    part1:setEndSizeVar(part1:getEndSizeVar() * view.minScale)
    animlayer:addChild(part1)
    local part2 = particle.create("devour_particle_02")
    part2:setStartSize(part2:getStartSize() * view.minScale)
    part2:setStartSizeVar(part2:getStartSizeVar() * view.minScale)
    part2:setEndSize(part2:getEndSize() * view.minScale)
    part2:setEndSizeVar(part2:getEndSizeVar() * view.minScale)
    animlayer:addChild(part2)
    local part3 = particle.create("devour_particle_03")
    part3:setStartSize(part3:getStartSize() * view.minScale)
    part3:setStartSizeVar(part3:getStartSizeVar() * view.minScale)
    part3:setEndSize(part3:getEndSize() * view.minScale)
    part3:setEndSizeVar(part3:getEndSizeVar() * view.minScale)
    animlayer:addChild(part3)
    json.load(json.ui.devour_particle_animation)
    local partAnim = DHSkeletonAnimation:createWithKey(json.ui.devour_particle_animation)
    partAnim:scheduleUpdateLua()
    partAnim:setPosition(scalep(480, 288))
    partAnim:setScale(view.minScale)
    partAnim:playAnimation("animation")
    animlayer:addChild(partAnim)
    local tick = 0
    animlayer:scheduleUpdateWithPriorityLua(function()
      tick = tick + 1
      part1:setPosition(partAnim:getBonePositionRelativeToLayer("code_particle_01"))
      part2:setPosition(partAnim:getBonePositionRelativeToLayer("code_particle_02"))
      part3:setPosition(partAnim:getBonePositionRelativeToLayer("code_particle_03"))
      if tick > 360 then
        animlayer:removeFromParentAndCleanup(true)
      end
      end)
   end
  local onhandle = function()
    local params = {sid = player.sid, hid = {}}
    for i = 1, MAX_NUM do
      if hids[i] then
        params.hid[#params.hid + 1] = hids[i]
      end
    end
    if #params.hid <= 0 then
      return 
    end
    if #heros == #params.hid then
      showToast(i18n.global.devour_tips_all.string)
      return 
    end
    addWaitNet()
    net:hero_decompose(params, function(l_1_0)
      delWaitNet()
      audio.play(audio.devour)
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast("server status:" .. l_1_0.status)
        return 
      end
      require("data.tutorial").goNext("devour", 1, true)
      local reward = {items = {}, equips = {}}
      for _,v in ipairs(l_1_0.items) do
        if v.num > 0 then
          table.insert(reward.items, v)
        end
        print("@@@@@ ", v.id, v.num)
      end
      for i = 1, MAX_NUM do
        if hids[i] then
          baseAnim[i]:playAnimation("fangru")
          local heroData = heros.find(hids[i])
          local info = heros.del(hids[i])
          for j,v in ipairs(info.equips) do
            local config = cfgequip[v]
            if config and config.pos ~= 5 then
              table.insert(reward.equips, {id = v, num = 1})
            end
          end
        end
      end
      btnDevour:setEnabled(false)
      layer:setTouchEnabled(false)
      layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.35), CCCallFunc:create(function()
        for i = 1, MAX_NUM do
          if hids[i] then
            hids[i] = nil
          end
          if showHeros[i] then
            showHeros[i]:removeFromParentAndCleanup(true)
            showHeros[i] = nil
          end
        end
        createHerolist()
        layer:setTouchEnabled(true)
        btnDevour:setEnabled(true)
        showRune:setString(0)
        showExp:setString(0)
        showEvolve:setString(0)
         end)))
      bag.items.addAll(l_1_0.items)
      local achieveData = require("data.achieve")
      achieveData.add(ACHIEVE_TYPE_DECOMPOSE_HERO, #hids)
      layer:addChild(require("ui.hook.drops").create(reward, i18n.global.ui_decompose_award.string), 1000)
      end)
   end
  btnDevour:registerScriptTapHandler(function()
    local isHigh = false
    for i = 1, MAX_NUM do
      if hids[i] then
        local heroData = heros.find(hids[i])
        if cfghero[heroData.id].qlt >= 4 then
          isHigh = true
        end
      end
    end
    if isHigh then
      local params = {title = "", text = i18n.global.devour_tips_high.string, handle = onhandle}
      layer:addChild(require("ui.tips.confirm").create(params), 1000)
    else
      onhandle()
    end
   end)
  btnSmart:registerScriptTapHandler(function()
    for i,v in ipairs(herolist) do
      if not v.lock and not v.isUsed and checkIfBlank() then
        onSelect(i)
      end
    end
   end)
  btnPreview:registerScriptTapHandler(function()
    local reward = {items = {}, equips = {}}
    local teams = {}
    for i = 1, MAX_NUM do
      if hids[i] then
        teams[#teams + 1] = hids[i]
      end
    end
    do
      local exp, evolve, rune = heros.decompose(teams)
      if exp > 0 then
        table.insert(reward.items, {id = 10, num = math.floor(exp)})
      end
      if evolve > 0 then
        table.insert(reward.items, {id = 11, num = math.floor(evolve)})
      end
      if rune > 0 then
        table.insert(reward.items, {id = 7, num = math.floor(rune)})
      end
      for i = 1, MAX_NUM do
        if hids[i] then
          local heroData = heros.find(hids[i])
          for j,v in ipairs(heroData.equips) do
            local config = cfgequip[v]
            if config then
              if config.pos ~= EQUIP_POS_JADE then
                table.insert(reward.equips, {id = v, num = 1})
                for j,v in (for generator) do
                end
                if config.jadeUpgAll then
                  for _,item in ipairs(config.jadeUpgAll) do
                    table.insert(reward.items, item)
                  end
                end
              end
            end
          end
        end
        layer:addChild(require("ui.hook.drops").create(reward, i18n.global.ui_decompose_preview.string, true), 1000)
      end
       -- Warning: missing end command somewhere! Added here
    end
   end)
  layer:scheduleUpdateWithPriorityLua(function()
    local exp, evolve = 0, 0
    local itemExp = bag.items.find(ITEM_ID_HERO_EXP)
    local itemEvolve = bag.items.find(ITEM_ID_EVOLVE_EXP)
    if itemExp then
      exp = itemExp.num
    end
    if itemEvolve then
      evolve = itemEvolve.num
    end
    showExpAll:setString(num2KM(exp))
    showEvolveAll:setString(num2KM(evolve))
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    replaceScene(require("ui.town.main").create())
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_25_0)
    if l_25_0 == "enter" then
      onEnter()
    elseif l_25_0 == "exit" then
      onExit()
    elseif l_25_0 == "cleanup" then
      img.unload(img.packedOthers.ui_devour_bg)
      json.unload(json.ui.devour_in_animation)
    end
   end)
  require("ui.tutorial").show("ui.devour.main", layer)
  return layer
end

return ui

