-- Command line was: E:\github\dhgametool\scripts\ui\brave\select.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local heros = require("data.heros")
local userdata = require("data.userdata")
local cfghero = require("config.hero")
local bag = require("data.bag")
local player = require("data.player")
local databrave = require("data.brave")
local cfgbrave = require("config.brave")
local petBattle = require("ui.pet.petBattle")
local initHerolistData = function(l_1_0)
  local herolist = {}
  for i,v in ipairs(heros) do
    if v.lv >= 40 then
      herolist[#herolist + 1] = clone(v)
    end
  end
  for i,v in ipairs(herolist) do
    v.isUsed = false
    v.hpp = 100
    for j,k in ipairs(databrave.heros) do
      if v.hid == k.hid then
        v.hpp = k.hpp
      end
    end
  end
  table.sort(herolist, compareHero)
  local whitelist = userdata.getSquadBrave()
  local tlist = herolistless(herolist, whitelist)
  return tlist
end

local onHadleBattle = function(l_2_0)
  if #l_2_0.hids <= 0 then
    showToast(i18n.global.toast_selhero_needhero.string)
    return 
  end
  local params = {sid = player.sid, camp = l_2_0.hids}
  print("\232\191\156\229\190\129\231\154\132\229\174\160\231\137\169\233\152\178\229\174\136\230\149\180\229\174\185\230\149\176\230\141\174-------begin")
  petBattle.addPetData(l_2_0.hids)
  print("\232\191\156\229\190\129\231\154\132\229\174\160\231\137\169\233\152\178\229\174\136\230\149\180\229\174\185\230\149\176\230\141\174-------end")
  tbl2string(params)
  addWaitNet()
  net:brave_fight(params, function(l_1_0)
    delWaitNet()
    if l_1_0.status < 0 then
      if l_1_0.status == -1 then
        showToast(i18n.global.toast_brave_close.string)
      else
        showToast("status:" .. l_1_0.status)
        return 
      end
      local video = clone(l_1_0)
      video.map = cfgbrave[databrave.id].mapId[databrave.stage]
      video.reward = content.reward
      video.atk = {}
      video.atk.camp = content.hids
      video.atk.name = player.name
      video.atk.lv = player.lv()
      video.atk.logo = player.logo
      video.def = clone(databrave.enemys[databrave.stage])
      local camp = {}
      for i,v in ipairs(video.def.camp) do
        if v.pos ~= 7 then
          v.hp = v.hpp
          if v.hp > 0 then
            camp[#camp + 1] = clone(v)
            for i,v in (for generator) do
            end
            camp[#camp + 1] = clone(v)
          end
        end
        video.def.camp = camp
        if video.rewards and video.select then
          bag.addRewards(video.rewards[video.select])
        end
        for i,v in ipairs(video.mhpp) do
          for j,k in ipairs(content.hids) do
            if v.pos == k.pos then
              v.hid = k.hid
            end
          end
        end
        for i,v in ipairs(video.mhpp) do
          local isFind = false
          for j,k in ipairs(databrave.heros) do
            if k.hid == v.hid then
              k.hpp = v.hpp
              isFind = true
            end
          end
          if not isFind then
            databrave.heros[#databrave.heros + 1] = {hid = v.hid, hpp = v.hpp}
          end
        end
        for i,v in ipairs(databrave.enemys[databrave.stage].camp) do
          for j,k in ipairs(video.ehpp) do
            if v.pos == k.pos then
              v.hpp = k.hpp
            end
          end
        end
        if video.win == true then
          databrave.stage = databrave.stage + 1
          local achieveData = require("data.achieve")
          if achieveData.achieveInfos[ACHIEVE_TYPE_BRAVE].num + 1 < databrave.stage then
            achieveData.add(ACHIEVE_TYPE_BRAVE, 1)
          end
          databrave.enemys[databrave.stage] = video.enemy
          for i,v in ipairs(video.reward) do
            if v.type == 1 then
              bag.items.add({id = v.id, num = v.num})
              for i,v in (for generator) do
              end
              bag.equips.add({id = v.id, num = v.num})
            end
          end
          processPetPosAtk1(video)
          processPetPosDef2(video)
          if arenaSkip() == "enable" then
            if video.win then
              CCDirector:sharedDirector():getRunningScene():addChild(require("fight.brave.win").create(video), 1000)
            else
              CCDirector:sharedDirector():getRunningScene():addChild(require("fight.brave.lose").create(video), 1000)
            end
          else
            replaceScene(require("fight.brave.loading").create(video))
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end)
end

ui.create = function(l_3_0)
  if not l_3_0 then
    local params = {}
  end
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, 0))
  layer:addChild(darkbg)
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(825, 410))
  board:setAnchorPoint(ccp(0.5, 0))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY + 34 * view.minScale)
  layer:addChild(board)
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(800, 385)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local title = lbl.createFont1(26, i18n.global.select_hero_title.string, ccc3(230, 208, 174))
  title:setPosition(413, 382)
  board:addChild(title, 1)
  local titleShade = lbl.createFont1(26, i18n.global.select_hero_title.string, ccc3(89, 48, 27))
  titleShade:setPosition(413, 380)
  board:addChild(titleShade)
  local heroCampBg = img.createUI9Sprite(img.ui.select_hero_camp_bg)
  heroCampBg:setPreferredSize(CCSize(770, 205))
  heroCampBg:setPosition(414, 240)
  board:addChild(heroCampBg, 1)
  local heroSkillBg = img.createUI9Sprite(img.ui.select_hero_buff_bg)
  heroSkillBg:setPreferredSize(CCSize(769, 76))
  heroSkillBg:setPosition(414, 85)
  board:addChild(heroSkillBg)
  local campWidget = require("ui.selecthero.campLayer").create()
  board:addChild(campWidget.layer, 20)
  campWidget.layer:setPosition(CCPoint(11, 35))
  local btnBattleSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnBattleSprite:setPreferredSize(CCSize(110, 78))
  local btnBattleIcon = img.createUISprite(img.ui.select_hero_btn_icon)
  btnBattleIcon:setPosition(btnBattleSprite:getContentSize().width / 2, btnBattleSprite:getContentSize().height / 2)
  btnBattleSprite:addChild(btnBattleIcon)
  local btnBattle = SpineMenuItem:create(json.ui.button, btnBattleSprite)
  btnBattle:setPosition(708, 211)
  local menuBattle = CCMenu:createWithItem(btnBattle)
  menuBattle:setPosition(0, 0)
  board:addChild(menuBattle, 1)
  local selectTeamBg = img.createUI9Sprite(img.ui.select_tab_tab_bg)
  selectTeamBg:setPreferredSize(CCSize(759, 37))
  selectTeamBg:setPosition(385, 179)
  heroCampBg:addChild(selectTeamBg)
  local showPowerBg = img.createUISprite(img.ui.select_hero_power_bg)
  showPowerBg:setAnchorPoint(ccp(0, 0.5))
  showPowerBg:setPosition(0, 19)
  selectTeamBg:addChild(showPowerBg)
  local powerIcon = img.createUISprite(img.ui.power_icon)
  powerIcon:setScale(0.46)
  powerIcon:setPosition(27, 21)
  showPowerBg:addChild(powerIcon)
  local showPower = lbl.createFont2(20, "0")
  showPower:setAnchorPoint(ccp(0, 0.5))
  showPower:setPosition(powerIcon:boundingBox():getMaxX() + 15, powerIcon:boundingBox():getMidY())
  showPowerBg:addChild(showPower)
  local labFront = lbl.createFont1(18, i18n.global.select_hero_front.string, ccc3(78, 48, 24))
  labFront:setAnchorPoint(ccp(0.5, 0.5))
  labFront:setPosition(122, 135)
  heroCampBg:addChild(labFront)
  local labBehind = lbl.createFont1(18, i18n.global.select_hero_behind.string, ccc3(78, 48, 24))
  labBehind:setAnchorPoint(ccp(0.5, 0.5))
  labBehind:setPosition(415, 135)
  heroCampBg:addChild(labBehind)
  local POSX = {78, 168, 281, 371, 461, 551}
  local baseHeroBg = {}
  local baseHeroHp = {}
  local showHeros = {}
  local hids = {}
  local headIcons = {}
  local herolist = initHerolistData()
  for i = 1, 6 do
    baseHeroBg[i] = img.createUI9Sprite(img.ui.herolist_withouthero_bg)
    baseHeroBg[i]:setPreferredSize(CCSize(84, 84))
    baseHeroBg[i]:setPosition(POSX[i], 74)
    heroCampBg:addChild(baseHeroBg[i])
    local showHpBg = img.createUISprite(img.ui.fight_hp_bg.small)
    showHpBg:setPosition(baseHeroBg[i]:boundingBox():getMidX(), baseHeroBg[i]:boundingBox():getMinY() - 13)
    heroCampBg:addChild(showHpBg)
    local showHpFgSp = img.createUISprite(img.ui.fight_hp_fg.small)
    baseHeroHp[i] = createProgressBar(showHpFgSp)
    baseHeroHp[i]:setPosition(showHpBg:getContentSize().width / 2, showHpBg:getContentSize().height / 2)
    baseHeroHp[i]:setPercentage(0)
    showHpBg:addChild(baseHeroHp[i])
  end
  local loadHeroCamps = function(l_2_0)
    for i = 1, 6 do
      if hids[i] and hids[i] > 0 then
        local heroInfo = heros.find(hids[i])
        if heroInfo then
          local param = {id = heroInfo.id, lv = heroInfo.lv, showGroup = true, showStar = 3, wake = heroInfo.wake, orangeFx = nil, petID = petBattle.getNowSele(), hid = heroInfo.hid}
          showHeros[i] = img.createHeroHeadByParam(param)
          showHeros[i]:setScale(0.8936170212766)
          showHeros[i]:setPosition(POSX[i], 74)
          heroCampBg:addChild(showHeros[i])
        else
          hids[i] = 0
        end
      end
    end
   end
  local btn_skip0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_skip0:setPreferredSize(CCSizeMake(180, 46))
  local skip_bg = img.createUISprite(img.ui.option_bg)
  skip_bg:setPosition(CCPoint(23, 24))
  btn_skip0:addChild(skip_bg)
  local skip_tick = img.createUISprite(img.ui.option_tick)
  skip_tick:setPosition(CCPoint(23, 24))
  btn_skip0:addChild(skip_tick)
  local lbl_skip = lbl.create({font = 1, size = 18, text = i18n.global.btn_skip_fight.string, color = ccc3(115, 59, 5), fr = {size = 14}, ru = {size = 14}})
  lbl_skip:setPosition(CCPoint(100, 23))
  btn_skip0:addChild(lbl_skip)
  local btn_skip = SpineMenuItem:create(json.ui.button, btn_skip0)
  btn_skip:setPosition(CCPoint(515, 17))
  local btn_skip_menu = CCMenu:createWithItem(btn_skip)
  btn_skip_menu:setPosition(CCPoint(0, 0))
  selectTeamBg:addChild(btn_skip_menu)
  local updateSkip = function()
    if arenaSkip() == "enable" then
      skip_tick:setVisible(true)
    else
      skip_tick:setVisible(false)
    end
   end
  updateSkip()
  btn_skip:registerScriptTapHandler(function()
    audio.play(audio.button)
    if arenaSkip() == "enable" then
      arenaSkip("disable")
    else
      arenaSkip("enable")
    end
    updateSkip()
   end)
  local petCallBack = function()
    for k,v in pairs(showHeros) do
      v:removeFromParent()
    end
    showHeros = {}
    loadHeroCamps(hids)
   end
  local spPet = img.createLogin9Sprite(img.login.button_9_small_purple)
  spPet:setPreferredSize(CCSizeMake(150, 45))
  local spIcon = img.createUISprite(img.ui.pet_leg)
  spPet:addChild(spIcon)
  local btnLal = lbl.createFont1(16, i18n.global.pet_battle_btn_lal.string, ccc3(92, 25, 142))
  spPet:addChild(btnLal)
  local btnPet = SpineMenuItem:create(json.ui.button, spPet)
  require("dhcomponents.DroidhangComponents"):mandateNode(btnPet, "yw_petBattle_btnPet")
  require("dhcomponents.DroidhangComponents"):mandateNode(spIcon, "yw_petBattle_spIcon")
  require("dhcomponents.DroidhangComponents"):mandateNode(btnLal, "yw_petBattle_btnLal")
  local menuPet = CCMenu:createWithItem(btnPet)
  menuPet:setPosition(0, 0)
  selectTeamBg:addChild(menuPet, 1)
  btnPet:registerScriptTapHandler(function()
    btnPet:setEnabled(false)
    disableObjAWhile(btnPet)
    audio.play(audio.button)
    require("ui.pet.petBattle").create(layer, petCallBack)
   end)
  local herolistBg = img.createUI9Sprite(img.ui.tips_bg)
  herolistBg:setPreferredSize(CCSize(957, 118))
  herolistBg:setScale(view.minScale)
  herolistBg:setAnchorPoint(ccp(0.5, 1))
  herolistBg:setPosition(view.midX, view.minY + 0 * view.minScale)
  layer:addChild(herolistBg)
  SCROLLVIEW_WIDTH = 943
  SCROLLVIEW_HEIGHT = 118
  SCROLLCONTENT_WIDTH = #herolist * 90 + 8
  scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionHorizontal)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(7, 0)
  scroll:setViewSize(CCSize(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT))
  scroll:setContentSize(CCSizeMake(SCROLLCONTENT_WIDTH, SCROLLVIEW_HEIGHT))
  herolistBg:addChild(scroll)
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
  blackBatch = CCNode:create()
  scroll:getContainer():addChild(blackBatch, 4)
  selectBatch = img.createBatchNodeForUI(img.ui.hook_btn_sel)
  scroll:getContainer():addChild(selectBatch, 5)
  for i = 1, #herolist do
    local x, y = 45 + (i - 1) * 90 + 8, 64
    local qlt = cfghero[herolist[i].id].maxStar
    local heroBg = nil
    if qlt == 10 then
      headBg = img.createUISprite(img.ui.hero_star_ten_bg)
      headBg:setPosition(x, y)
      headBg:setScale(0.92)
      iconBgBatch1:addChild(headBg)
      json.load(json.ui.lv10_framefx)
      local aniten = DHSkeletonAnimation:createWithKey(json.ui.lv10_framefx)
      aniten:playAnimation("animation", -1)
      aniten:scheduleUpdateLua()
      aniten:setScale(0.92)
      aniten:setPosition(x, y)
      scroll:getContainer():addChild(aniten, 3)
    else
      heroBg = img.createUISprite(img.ui.herolist_head_bg)
      heroBg:setScale(0.92)
      heroBg:setPosition(x, y)
      iconBgBatch:addChild(heroBg)
    end
    headIcons[i] = img.createHeroHeadByHid(herolist[i].hid)
    headIcons[i]:setScale(0.92)
    headIcons[i]:setPosition(x, y)
    scroll:getContainer():addChild(headIcons[i], 2)
    local showHpBg = img.createUISprite(img.ui.fight_hp_bg.small)
    showHpBg:setPosition(headIcons[i]:boundingBox():getMidX(), headIcons[i]:boundingBox():getMinY() - 8)
    scroll:getContainer():addChild(showHpBg)
    local showHpFgSp = img.createUISprite(img.ui.fight_hp_fg.small)
    local showHpFg = createProgressBar(showHpFgSp)
    showHpFg:setPosition(showHpBg:getContentSize().width / 2, showHpBg:getContentSize().height / 2)
    showHpFg:setPercentage(herolist[i].hpp)
    showHpBg:addChild(showHpFg)
    if herolist[i].hpp <= 0 then
      setShader(headIcons[i], SHADER_GRAY, true)
    end
  end
  local updateHp = function()
    for i = 1, 6 do
      baseHeroHp[i]:setPercentage(0)
      for j,k in ipairs(herolist) do
        if k.hid == hids[i] then
          baseHeroHp[i]:setPercentage(k.hpp)
        end
      end
    end
   end
  local checkUpdate = function()
    local power = 0
    local sk = 0
    for i = 1, 6 do
      if hids[i] and hids[i] > 0 and heros.find(hids[i]) then
        power = power + heros.power(hids[i])
        local heroData = heros.find(hids[i])
        if bit.band(sk, bit.blshift(1, cfghero[heroData.id].group - 1)) == 0 then
          sk = sk + bit.blshift(1, cfghero[heroData.id].group - 1)
        end
      end
    end
    showPower:setString(power)
    if heroSkillBg:getChildByTag(1) then
      heroSkillBg:removeChildByTag(1)
    end
    for i = 1, #require("ui.selecthero.campLayer").BuffTable do
      campWidget.icon[i]:setVisible(false)
    end
    local heroids = {}
    for i = 1, 6 do
      heroids[i] = nil
      if heros.find(hids[i]) ~= nil then
        heroids[i] = heros.find(hids[i]).id
      end
    end
    local showIcon = require("ui.selecthero.campLayer").checkUpdateForHeroids(heroids, true)
    if showIcon ~= -1 then
      campWidget.icon[showIcon]:setVisible(true)
    end
   end
  local onMoveUp = function(l_9_0, l_9_1, l_9_2)
    checkUpdate()
    if not l_9_2 then
      local heroInfo = heros.find(hids[l_9_1])
      local param = {id = heroInfo.id, lv = heroInfo.lv, showGroup = true, showStar = 3, wake = heroInfo.wake, orangeFx = nil, petID = petBattle.getNowSele(), hid = heroInfo.hid}
      showHeros[l_9_1] = img.createHeroHeadByParam(param)
      showHeros[l_9_1]:setScale(0.8936170212766)
      showHeros[l_9_1]:setPosition(POSX[l_9_1], 74)
      heroCampBg:addChild(showHeros[l_9_1])
      baseHeroHp[l_9_1]:setPercentage(herolist[l_9_0].hpp)
    end
    local blackBoard = CCLayerColor:create(ccc4(0, 0, 0, 120))
    blackBoard:setContentSize(CCSize(84, 84))
    blackBoard:setPosition(headIcons[l_9_0]:getPositionX() - 42, headIcons[l_9_0]:getPositionY() - 42)
    blackBatch:addChild(blackBoard, 0, l_9_0)
    local selectIcon = img.createUISprite(img.ui.hook_btn_sel)
    selectIcon:setPosition(headIcons[l_9_0]:getPositionX(), headIcons[l_9_0]:getPositionY())
    selectBatch:addChild(selectIcon, 0, l_9_0)
   end
  local moveUp = function(l_10_0)
    if herolist[l_10_0].hpp <= 0 then
      return 
    end
    local tpos = nil
    do
      for i = 1, 6 do
        if not hids[i] or hids[i] == 0 then
          tpos = i
      else
        end
      end
    end
    if tpos and not herolist[l_10_0].isUsed then
      herolist[l_10_0].isUsed = true
      hids[tpos] = herolist[l_10_0].hid
      local worldbpos = scroll:getContainer():convertToWorldSpace(ccp(headIcons[l_10_0]:getPositionX(), headIcons[l_10_0]:getPositionY()))
      local realbpos = board:convertToNodeSpace(worldbpos)
      local worldepos = heroCampBg:convertToWorldSpace(ccp(baseHeroBg[tpos]:getPositionX(), baseHeroBg[tpos]:getPositionY()))
      local realepos = board:convertToNodeSpace(worldepos)
      local param = {id = herolist[l_10_0].id}
      local tempHero = img.createHeroHeadByParam(param)
      tempHero:setScale(0.92)
      tempHero:setPosition(realbpos)
      board:addChild(tempHero, 100)
      local arr = CCArray:create()
      arr:addObject(CCMoveTo:create(0.1, realepos))
      local act1 = CCSpawn:create(arr)
      tempHero:runAction(CCSequence:createWithTwoActions(act1, CCCallFunc:create(function()
        tempHero:removeFromParentAndCleanup(true)
        onMoveUp(pos, tpos)
         end)))
    elseif tpos then
      showToast(i18n.global.toast_selhero_selected.string)
    else
      showToast(i18n.global.toast_selhero_already.string)
    end
   end
  local onMoveDown = function(l_11_0, l_11_1)
    checkUpdate()
    baseHeroHp[l_11_0]:setPercentage(0)
    blackBatch:removeChildByTag(l_11_1)
    selectBatch:removeChildByTag(l_11_1)
   end
  local moveDown = function(l_12_0)
    local tpos = nil
    do
      for i,v in ipairs(herolist) do
        if hids[l_12_0] == v.hid then
          tpos = i
      else
        end
      end
    end
    if tpos then
      showHeros[l_12_0]:removeFromParentAndCleanup(true)
      showHeros[l_12_0] = nil
      herolist[tpos].isUsed = false
      hids[l_12_0] = nil
      local worldbpos = heroCampBg:convertToWorldSpace(ccp(baseHeroBg[l_12_0]:getPositionX(), baseHeroBg[l_12_0]:getPositionY()))
      local realbpos = board:convertToNodeSpace(worldbpos)
      local worldepos = scroll:getContainer():convertToWorldSpace(ccp(headIcons[tpos]:getPositionX(), headIcons[tpos]:getPositionY()))
      local realepos = board:convertToNodeSpace(worldepos)
      local param = {id = herolist[tpos].id}
      local tempHero = img.createHeroHeadByParam(param)
      tempHero:setPosition(realbpos)
      tempHero:setScale(0.92)
      board:addChild(tempHero, 100)
      local arr = CCArray:create()
      arr:addObject(CCMoveTo:create(0.1, realepos))
      local act1 = CCSpawn:create(arr)
      tempHero:runAction(CCSequence:createWithTwoActions(act1, CCCallFunc:create(function()
        tempHero:removeFromParentAndCleanup(true)
        onMoveDown(pos, tpos)
         end)))
    end
   end
  local lastx, preSelect = nil, nil
  local onTouchBegin = function(l_13_0, l_13_1)
    local point = (heroCampBg:convertToNodeSpace(ccp(l_13_0, l_13_1)))
    upvalue_512 = nil
    upvalue_1024 = l_13_0
    for i = 1, 6 do
      if hids[i] and showHeros[i] and showHeros[i]:boundingBox():containsPoint(point) then
        upvalue_512 = i
      end
    end
    return true
   end
  local onTouchMoved = function(l_14_0, l_14_1)
    local point = heroCampBg:convertToNodeSpace(ccp(l_14_0, l_14_1))
    if preSelect and math.abs(l_14_0 - lastx) >= 10 then
      showHeros[preSelect]:setPosition(point)
      showHeros[preSelect]:setZOrder(1)
    end
    return true
   end
  local onTouchEnd = function(l_15_0, l_15_1)
    local point = heroCampBg:convertToNodeSpace(ccp(l_15_0, l_15_1))
    local pointOnScroll = scroll:getContainer():convertToNodeSpace(ccp(l_15_0, l_15_1))
    if math.abs(l_15_0 - lastx) < 10 then
      for i,v in ipairs(headIcons) do
        if v:boundingBox():containsPoint(pointOnScroll) then
          audio.play(audio.button)
          moveUp(i)
        end
      end
      for i = 1, 6 do
        if hids[i] and showHeros[i] and showHeros[i]:boundingBox():containsPoint(point) then
          audio.play(audio.button)
          moveDown(i)
        end
      end
    end
    if not preSelect or math.abs(l_15_0 - lastx) < 10 then
      return true
    end
    local ifset = false
    for i = 1, 6 do
      if baseHeroBg[i]:boundingBox():containsPoint(point) and math.abs(showHeros[preSelect]:getPositionX() - baseHeroBg[i]:getPositionX()) < 25 and math.abs(showHeros[preSelect]:getPositionY() - baseHeroBg[i]:getPositionY()) < 25 then
        ifset = true
        showHeros[preSelect]:setZOrder(0)
        showHeros[preSelect]:setPosition(baseHeroBg[i]:getPosition())
        if hids[i] and showHeros[i] then
          showHeros[i]:setPosition(baseHeroBg[preSelect]:getPosition())
        end
        showHeros[preSelect], showHeros[i] = showHeros[i], showHeros[preSelect]
        hids[preSelect], hids[i] = hids[i], hids[preSelect]
        updateHp()
      end
    end
    if ifset == false then
      showHeros[preSelect]:setPosition(baseHeroBg[preSelect]:getPosition())
      showHeros[preSelect]:setZOrder(0)
    end
    return true
   end
  local onTouch = function(l_16_0, l_16_1, l_16_2)
    if l_16_0 == "began" then
      return onTouchBegin(l_16_1, l_16_2)
    elseif l_16_0 == "moved" then
      return onTouchMoved(l_16_1, l_16_2)
    else
      return onTouchEnd(l_16_1, l_16_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  btnBattle:registerScriptTapHandler(function()
    audio.play(audio.fight_start_button)
    local cloneHids = clone(hids)
    cloneHids[7] = petBattle.getNowSele()
    userdata.setSquadBrave(cloneHids)
    local unit = {}
    for i = 1, 6 do
      if hids[i] and hids[i] > 0 then
        unit[#unit + 1] = {hid = hids[i], pos = i}
        local hh = heros.find(unit[#unit].hid)
        if hh and hh.wake then
          unit[#unit].wake = hh.wake
        end
      end
    end
    for i,v in ipairs(unit) do
      for j,k in ipairs(herolist) do
        if v.hid == k.hid then
          v.hp = k.hpp
        end
      end
    end
    params.hids = unit
    onHadleBattle(params)
   end)
  local initLoad = function()
    hids = userdata.getSquadBrave()
    petBattle.initData(hids)
    for i,v in ipairs(hids) do
      for j,k in ipairs(herolist) do
        if v == k.hid then
          if k.hpp == 0 then
            hids[i] = 0
            for i,v in (for generator) do
            end
            if baseHeroHp[i] then
              baseHeroHp[i]:setPercentage(k.hpp)
              for i,v in (for generator) do
              end
            end
          end
        end
        for i,v in ipairs(herolist) do
          for j = 1, 6 do
            if v.hid == hids[j] and hids[j] ~= 0 then
              onMoveUp(i, j, true)
              herolist[i].isUsed = true
            end
          end
        end
        loadHeroCamps(hids)
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  initLoad()
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_22_0)
    if l_22_0 == "enter" then
      onEnter()
    elseif l_22_0 == "exit" then
      onExit()
    end
   end)
  local anim_duration = 0.2
  board:setPosition(CCPoint(view.midX, view.minY + 576 * view.minScale))
  board:runAction(CCMoveTo:create(anim_duration, CCPoint(view.midX, view.minY + 135 * view.minScale)))
  herolistBg:runAction(CCMoveTo:create(anim_duration, CCPoint(view.midX, view.minY + 130 * view.minScale)))
  darkbg:runAction(CCFadeTo:create(anim_duration, POPUP_DARK_OPACITY))
  return layer
end

return ui

