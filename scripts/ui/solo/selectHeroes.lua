-- Command line was: E:\github\dhgametool\scripts\ui\solo\selectHeroes.lua 

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
local hookdata = require("data.hook")
local trialdata = require("data.trial")
local arenaData = require("data.arena")
local achieveData = require("data.achieve")
local petBattle = require("ui.pet.petBattle")
local bagdata = require("data.bag")
local cfgDrug = require("config.spkdrug")
local initHerolistData = function(l_1_0)
  if not l_1_0 then
    local params = {}
  end
  local tmpheros = clone(heros)
  local herolist = {}
  for i,v in ipairs(tmpheros) do
    if params.group then
      if cfghero[v.id].group == params.group then
        herolist[ herolist + 1] = v
        for i,v in (for generator) do
        end
        for j = 1, 5 do
          if params.hids[j] == v.hid then
            herolist[ herolist + 1] = v
          end
        end
        for i,v in (for generator) do
        end
        herolist[ herolist + 1] = v
      end
      for i,v in ipairs(herolist) do
        v.isUsed = false
      end
      table.sort(herolist, compareHero)
      do
        local tlist = herolistless(herolist)
        return tlist
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.create = function(l_2_0)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, 0))
  layer:addChild(darkbg)
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(825, 370))
  board:setAnchorPoint(ccp(0.5, 0))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY + 34 * view.minScale)
  layer:addChild(board)
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(800, 340)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    replaceScene(require("ui.town.main").create())
   end)
  layer.onAndroidBack = function()
    replaceScene(require("ui.town.main").create())
   end
  addBackEvent(layer)
  local title = lbl.createFont1(26, i18n.global.solo_selectHero.string, ccc3(230, 208, 174))
  title:setPosition(413, 342)
  board:addChild(title, 1)
  local titleShade = lbl.createFont1(26, i18n.global.solo_selectHero.string, ccc3(89, 48, 27))
  titleShade:setPosition(413, 340)
  board:addChild(titleShade)
  local heroCampBg = img.createUI9Sprite(img.ui.select_hero_camp_bg)
  heroCampBg:setPreferredSize(CCSize(770, 205))
  heroCampBg:setPosition(414, 190)
  board:addChild(heroCampBg, 1)
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
  local posY = heroCampBg:getContentSize().height / 2 - 21
  local centerX = heroCampBg:getContentSize().width / 2
  local offsetX = 96
  local baseHeroBg = {}
  local showHeros = {}
  local hids = {}
  local headIcons = {}
  local herolist = initHerolistData()
  for i = 1, 5 do
    baseHeroBg[i] = img.createUI9Sprite(img.ui.herolist_withouthero_bg)
    baseHeroBg[i]:setPreferredSize(CCSize(84, 84))
    baseHeroBg[i]:setPositionX((i - math.ceil(2.5)) * offsetX + centerX)
    baseHeroBg[i]:setPositionY(posY)
    heroCampBg:addChild(baseHeroBg[i])
  end
  ui.mainUI.modifyBufShow()
  local saveImg = img.createLogin9Sprite(img.login.button_9_small_gold)
  saveImg:setPreferredSize(CCSize(216, 54))
  local saveLabel = lbl.createFont1(20, i18n.global.solo_save.string, ccc3(115, 59, 5))
  saveLabel:setPosition(saveImg:getContentSize().width / 2, saveImg:getContentSize().height / 2)
  saveImg:addChild(saveLabel)
  local saveBtn = SpineMenuItem:create(json.ui.button, saveImg)
  saveBtn:setPosition(board:getContentSize().width / 2, 50)
  local saveMenu = CCMenu:createWithItem(saveBtn)
  saveMenu:setPosition(0, 0)
  board:addChild(saveMenu, 1)
  saveBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local heroHids = {}
    do
      for i = 1, 5 do
        if hids[i] ~= nil then
          for j = 1, 5 do
            if hids[j] ~= nil then
              table.insert(heroHids, 1, hids[j])
            end
          end
      else
        end
      end
    end
    if  heroHids > 0 then
      local soloData = require("data.solo")
      addWaitNet()
      local params = {sid = player.sid, hids = heroHids}
      print("\233\128\137\228\186\186\231\148\179\232\175\183\230\149\176\230\141\174")
      tablePrint(params)
      net:spk_camp(params, function(l_1_0)
        delWaitNet()
        print("\233\128\137\228\186\186\232\191\148\229\155\158\230\149\176\230\141\174")
        tablePrint(l_1_0)
        if l_1_0.status == 0 then
          soloData.reddot = 0
          local cfgSpkWave = require("config.spkwave")
          do
            local bossArr = cfgSpkWave[1].trial
            local ehpp = {}
            for i = 1,  bossArr do
              ehpp[i] = 100
            end
            if not l_1_0.bufs then
              l_1_0.bufs = {}
            end
            if not l_1_0.reward then
              l_1_0.reward = {}
            end
            soloData.setStage(l_1_0.nstage)
            soloData.setWave(l_1_0.wave or 1)
            soloData.heroList = ui.getHeroList(hids)
            soloData.bossList = soloData.convertBossInfo(ehpp)
            if not l_1_0.sellers then
              soloData.traderList = {}
            end
            soloData.power = soloData.getDrugNum(l_1_0.bufs, "power")
            soloData.crit = soloData.getDrugNum(l_1_0.bufs, "crit")
            soloData.speed = soloData.getDrugNum(l_1_0.bufs, "speed")
            soloData.milk = soloData.getDrugList(l_1_0.bufs, "milk")
            soloData.angel = soloData.getDrugList(l_1_0.bufs, "angel")
            soloData.evil = soloData.getDrugList(l_1_0.bufs, "evil")
            soloData.level = soloData.getStageLevel()
            print("aaa " .. soloData.power .. "," .. soloData.crit .. "," .. soloData.speed)
            for i,v in ipairs(soloData.heroList) do
              do
                v.power = soloData.power
                v.speed = soloData.speed
                v.crit = soloData.crit
              end
            end
            bagdata.items.addAll(l_1_0.reward.items)
            bagdata.equips.addAll(l_1_0.reward.equips)
            local rewards = {}
            if l_1_0.reward == nil or not l_1_0.reward.items then
              local items = {}
            end
            if l_1_0.reward == nil or not l_1_0.reward.equips then
              local equips = {}
            end
            if not l_1_0.bufs then
              local bufs = {}
            end
            for i,v in ipairs(items) do
              local item = {}
              item.type = 1
              item.id = v.id
              item.num = v.num
              table.insert(rewards, item)
            end
            for i,v in ipairs(equips) do
              local item = {}
              item.type = 2
              item.id = v.id
              item.num = v.num
              table.insert(rewards, item)
            end
            print("------- ")
            tablePrint(bufs)
            local bufList = {}
            for i,v in ipairs(bufs) do
              if bufList[cfgDrug[v.id].iconId] then
                bufList[cfgDrug[v.id].iconId].num = bufList[cfgDrug[v.id].iconId].num + v.num
                for i,v in (for generator) do
                end
                bufList[cfgDrug[v.id].iconId] = {}
                bufList[cfgDrug[v.id].iconId].id = v.id
                bufList[cfgDrug[v.id].iconId].num = v.num
              end
              for k,v in pairs(bufList) do
                local item = {}
                item.type = 3
                item.id = v.id
                item.num = v.num
                table.insert(rewards, item)
              end
              local parentLayer = layer:getParent().mainUI
              local callfunc = function()
                parentLayer.initHandle()
                parentLayer.modifyBufShow()
                parentLayer.playSweepAnimation()
                     end
              if  rewards > 0 then
                local darkLayer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
                parentLayer.widget.layer:addChild(darkLayer, 99999)
                local spineNode = json.create(json.ui.solo_sweep)
                spineNode:setScale(view.minScale)
                spineNode:setPosition(view.midX, view.midY)
                spineNode:playAnimation("animation")
                parentLayer.widget.layer:addChild(spineNode, 99999)
                local sweepLabel = lbl.createFont2(22, i18n.global.solo_sweep_finish.string, ccc3(255, 225, 107))
                sweepLabel:setAnchorPoint(0.5, 1)
                spineNode:addChildFollowSlot("code_text", sweepLabel)
                sweepLabel:setPositionY(sweepLabel:getPositionY() + 3)
                parentLayer.createSwallowLayer(1.6, 99999)
                local delay = CCDelayTime:create(1.6)
                local callfunc = CCCallFunc:create(function()
                  darkLayer:removeFromParent()
                  spineNode:removeFromParent()
                  local sweepUI = require("ui.solo.sweepUI").create(rewards, parentLayer, callfunc)
                  parentLayer.widget.layer:addChild(sweepUI, 99999)
                        end)
                parentLayer.widget.layer:runAction(CCSequence:createWithTwoActions(delay, callfunc))
              else
                layer:getParent().mainUI.initHandle()
              end
              layer:removeFromParent()
              return 
            end
          end
           -- Warning: missing end command somewhere! Added here
        end
         end)
    else
      showToast(i18n.global.toast_selhero_needhero.string)
    end
   end)
  local herolistBg = img.createUI9Sprite(img.ui.tips_bg)
  herolistBg:setPreferredSize(CCSize(957, 112))
  herolistBg:setScale(view.minScale)
  herolistBg:setAnchorPoint(ccp(0.5, 1))
  herolistBg:setPosition(view.midX, view.minY + 0 * view.minScale)
  layer:addChild(herolistBg)
  SCROLLVIEW_WIDTH = 793
  SCROLLVIEW_HEIGHT = 112
  SCROLLCONTENT_WIDTH =  herolist * 90 + 8
  scroll = CCScrollView:create()
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
  filterBg:setPreferredSize(CCSize(122, 458))
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
    local iconBgBatch1 = img.createBatchNodeForUI(img.ui.hero_star_ten_bg)
    showHeroLayer:addChild(iconBgBatch1, 1)
    local groupBgBatch = img.createBatchNodeForUI(img.ui.herolist_group_bg)
    showHeroLayer:addChild(groupBgBatch, 3)
    local starBatch = img.createBatchNodeForUI(img.ui.star_s)
    showHeroLayer:addChild(starBatch, 3)
    local star1Batch = img.createBatchNodeForUI(img.ui.hero_star_orange)
    showHeroLayer:addChild(star1Batch, 3)
    local star10Batch = img.createBatchNodeForUI(img.ui.hero_star_ten)
    showHeroLayer:addChild(star10Batch, 3)
    upvalue_2048 = CCNode:create()
    showHeroLayer:addChild(blackBatch, 4)
    upvalue_2560 = img.createBatchNodeForUI(img.ui.hook_btn_sel)
    showHeroLayer:addChild(selectBatch, 5)
    for i = 1,  herolist do
      local x, y = 45 + (i - 1) * 90 + 8, 56
      local qlt = cfghero[herolist[i].id].maxStar
      local heroBg = nil
      if qlt == 10 then
        heroBg = img.createUISprite(img.ui.hero_star_ten_bg)
        heroBg:setPosition(x, y)
        heroBg:setScale(0.92)
        iconBgBatch1:addChild(heroBg)
        json.load(json.ui.lv10_framefx)
        local aniten = DHSkeletonAnimation:createWithKey(json.ui.lv10_framefx)
        aniten:playAnimation("animation", -1)
        aniten:scheduleUpdateLua()
        aniten:setScale(0.92)
        aniten:setPosition(x, y)
        showHeroLayer:addChild(aniten, 3)
      else
        heroBg = img.createUISprite(img.ui.herolist_head_bg)
        heroBg:setScale(0.92)
        heroBg:setPosition(x, y)
        iconBgBatch:addChild(heroBg)
      end
      headIcons[i] = img.createHeroHeadByHid(herolist[i].hid)
      headIcons[i]:setScale(0.92)
      headIcons[i]:setPosition(x, y)
      showHeroLayer:addChild(headIcons[i], 2)
    end
   end
  local checkUpdate = function()
    local power = 0
    local sk = 0
    for i = 1, 5 do
      if hids[i] and hids[i] > 0 and heros.find(hids[i]) then
        power = power + heros.power(hids[i])
        local heroData = heros.find(hids[i])
        if bit.band(sk, bit.blshift(1, cfghero[heroData.id].group - 1)) == 0 then
          sk = sk + bit.blshift(1, cfghero[heroData.id].group - 1)
        end
      end
    end
    showPower:setString(power)
    local heroids = {}
    for i = 1, 5 do
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
  local onMoveUp = function(l_6_0, l_6_1, l_6_2)
    checkUpdate()
    if not l_6_2 then
      local heroInfo = heros.find(hids[l_6_1])
      local param = {id = heroInfo.id, lv = heroInfo.lv, showGroup = true, showStar = 3, wake = heroInfo.wake, orangeFx = nil, petID = nil, hid = heroInfo.hid}
      showHeros[l_6_1] = img.createHeroHeadByParam(param)
      showHeros[l_6_1]:setScale(0.91489361702128)
      showHeros[l_6_1]:setPositionX((l_6_1 - math.ceil(2.5)) * offsetX + centerX)
      showHeros[l_6_1]:setPositionY(posY)
      heroCampBg:addChild(showHeros[l_6_1])
    end
    local blackBoard = CCLayerColor:create(ccc4(0, 0, 0, 120))
    blackBoard:setContentSize(CCSize(84, 84))
    blackBoard:setPosition(headIcons[l_6_0]:getPositionX() - 42, headIcons[l_6_0]:getPositionY() - 42)
    blackBatch:addChild(blackBoard, 0, l_6_0)
    local selectIcon = img.createUISprite(img.ui.hook_btn_sel)
    selectIcon:setPosition(headIcons[l_6_0]:getPositionX(), headIcons[l_6_0]:getPositionY())
    selectBatch:addChild(selectIcon, 0, l_6_0)
   end
  local moveUp = function(l_7_0)
    if ui.mianUI ~= nil then
      print("\231\156\159\231\154\132\228\184\141\228\184\186\231\169\186")
    end
    local tpos = nil
    do
      for i = 1, 5 do
        if not hids[i] or hids[i] == 0 then
          tpos = i
      else
        end
      end
    end
    if tpos and not herolist[l_7_0].isUsed then
      herolist[l_7_0].isUsed = true
      hids[tpos] = herolist[l_7_0].hid
      local worldbpos = scroll:getContainer():convertToWorldSpace(ccp(headIcons[l_7_0]:getPositionX(), headIcons[l_7_0]:getPositionY()))
      local realbpos = board:convertToNodeSpace(worldbpos)
      local worldepos = heroCampBg:convertToWorldSpace(ccp(baseHeroBg[tpos]:getPositionX(), baseHeroBg[tpos]:getPositionY()))
      local realepos = board:convertToNodeSpace(worldepos)
      local param = {id = herolist[l_7_0].id, lv = herolist[l_7_0].lv, showGroup = true, showStar = nil, wake = nil, orangeFx = nil, petID = nil, hid = herolist[l_7_0].hid}
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
  local onMoveDown = function(l_8_0, l_8_1)
    checkUpdate()
    blackBatch:removeChildByTag(l_8_1)
    selectBatch:removeChildByTag(l_8_1)
   end
  local moveDown = function(l_9_0)
    local tpos = nil
    do
      for i,v in ipairs(herolist) do
        if hids[l_9_0] == v.hid then
          tpos = i
      else
        end
      end
    end
    if tpos then
      showHeros[l_9_0]:removeFromParentAndCleanup(true)
      showHeros[l_9_0] = nil
      herolist[tpos].isUsed = false
      hids[l_9_0] = nil
      local worldbpos = heroCampBg:convertToWorldSpace(ccp(baseHeroBg[l_9_0]:getPositionX(), baseHeroBg[l_9_0]:getPositionY()))
      local realbpos = board:convertToNodeSpace(worldbpos)
      local worldepos = scroll:getContainer():convertToWorldSpace(ccp(headIcons[tpos]:getPositionX(), headIcons[tpos]:getPositionY()))
      local realepos = board:convertToNodeSpace(worldepos)
      local param = {id = herolist[tpos].id, lv = herolist[tpos].lv, showGroup = true, showStar = nil, wake = nil, orangeFx = nil, petID = nil, hid = herolist[tpos].hid}
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
  local onTouchBegin = function(l_10_0, l_10_1)
    local point = (heroCampBg:convertToNodeSpace(ccp(l_10_0, l_10_1)))
    upvalue_512 = nil
    upvalue_1024 = l_10_0
    for i = 1, 5 do
      if hids[i] and showHeros[i] and showHeros[i]:boundingBox():containsPoint(point) then
        upvalue_512 = i
      end
    end
    return true
   end
  local onTouchMoved = function(l_11_0, l_11_1)
    local point = heroCampBg:convertToNodeSpace(ccp(l_11_0, l_11_1))
    if preSelect and math.abs(l_11_0 - lastx) >= 10 then
      showHeros[preSelect]:setPosition(point)
      showHeros[preSelect]:setZOrder(1)
    end
    return true
   end
  local onTouchEnd = function(l_12_0, l_12_1)
    if not scroll or tolua.isnull(scroll) then
      return 
    end
    local point = heroCampBg:convertToNodeSpace(ccp(l_12_0, l_12_1))
    local pointOnScroll = scroll:getContainer():convertToNodeSpace(ccp(l_12_0, l_12_1))
    if math.abs(l_12_0 - lastx) < 10 then
      for i,v in ipairs(headIcons) do
        if v:boundingBox():containsPoint(pointOnScroll) then
          audio.play(audio.button)
          moveUp(i)
        end
      end
      for i = 1, 5 do
        if hids[i] and showHeros[i] and showHeros[i]:boundingBox():containsPoint(point) then
          audio.play(audio.button)
          moveDown(i)
        end
      end
    end
    if not preSelect or math.abs(l_12_0 - lastx) < 10 then
      return true
    end
    local ifset = false
    for i = 1, 5 do
      if baseHeroBg[i]:boundingBox():containsPoint(point) and math.abs(showHeros[preSelect]:getPositionX() - baseHeroBg[i]:getPositionX()) < 33 and math.abs(showHeros[preSelect]:getPositionY() - baseHeroBg[i]:getPositionY()) < 33 then
        ifset = true
        showHeros[preSelect]:setZOrder(0)
        showHeros[preSelect]:setPosition(baseHeroBg[i]:getPosition())
        if hids[i] and showHeros[i] then
          showHeros[i]:setPosition(baseHeroBg[preSelect]:getPosition())
        end
        showHeros[preSelect], showHeros[i] = showHeros[i], showHeros[preSelect]
        hids[preSelect], hids[i] = hids[i], hids[preSelect]
      end
    end
    if ifset == false then
      showHeros[preSelect]:setPosition(baseHeroBg[preSelect]:getPosition())
      showHeros[preSelect]:setZOrder(0)
    end
    return true
   end
  local onTouch = function(l_13_0, l_13_1, l_13_2)
    if l_13_0 == "began" then
      return onTouchBegin(l_13_1, l_13_2)
    elseif l_13_0 == "moved" then
      return onTouchMoved(l_13_1, l_13_2)
    else
      return onTouchEnd(l_13_1, l_13_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  layer.showHint = function()
    local bubble = img.createUI9Sprite(img.ui.tutorial_bubble)
    local bubbleMinWidth, bubbleMinHeight = 208, 82
    bubble:setScale(view.minScale)
    bubble:setAnchorPoint(ccp(0.5, 0))
    bubble:setPosition(scalep(215, 430))
    layer:addChild(bubble)
    local label = lbl.createMix({font = 1, size = 16, text = i18n.global.tutorial_text_new_hit_1.string, color = ccc3(114, 72, 53), width = 350})
    local labelSize = label:boundingBox().size
    label:setAnchorPoint(ccp(0.5, 0.5))
    bubble:addChild(label)
    local bubbleWidth = labelSize.width + 20
    if bubbleWidth < bubbleMinWidth then
      bubbleWidth = bubbleMinWidth
    end
    local bubbleHeight = labelSize.height + 5
    if bubbleHeight < bubbleMinHeight then
      bubbleHeight = bubbleMinHeight
    end
    bubble:setPreferredSize(CCSize(bubbleWidth, bubbleHeight))
    label:setPosition(bubbleWidth / 2, bubbleHeight / 2)
    do
      local bubbleArrow = img.createUISprite(img.ui.tutorial_bubble_arrow)
      bubbleArrow:setRotation(-90)
      bubbleArrow:setPosition(bubbleWidth / 2, -6)
      bubble:addChild(bubbleArrow)
      bubble:setVisible(false)
      bubble:runAction(createSequence({}))
    end
    local bubble = img.createUI9Sprite(img.ui.tutorial_bubble)
    local bubbleMinWidth, bubbleMinHeight = 208, 82
    bubble:setScale(view.minScale)
    bubble:setAnchorPoint(ccp(0.5, 1))
    bubble:setPosition(scalep(514, 280))
    layer:addChild(bubble)
    local label = lbl.createMix({font = 1, size = 16, text = i18n.global.tutorial_text_new_hit_2.string, color = ccc3(114, 72, 53), width = 450})
    local labelSize = label:boundingBox().size
    label:setAnchorPoint(ccp(0.5, 0.5))
    bubble:addChild(label)
    local bubbleWidth = labelSize.width + 20
    if bubbleWidth < bubbleMinWidth then
      local bubbleHeight = labelSize.height + 5
       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    bubble:setPreferredSize(CCSize(bubbleWidth, bubbleHeight))
    label:setPosition(bubbleWidth / 2, bubbleHeight / 2)
    do
      local bubbleArrow = img.createUISprite(img.ui.tutorial_bubble_arrow)
      bubbleArrow:setRotation(90)
      bubbleArrow:setPosition(bubbleWidth / 2, bubbleHeight + 6)
      bubble:addChild(bubbleArrow)
      bubble:setVisible(false)
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

      bubble:runAction(createSequence({}))
    end
     -- Warning: undefined locals caused missing assignments!
   end
  createHerolist()
  local onEnter = function()
   end
  local onExit = function()
   end
  layer:registerScriptHandler(function(l_17_0)
    if l_17_0 == "enter" then
      onEnter()
    elseif l_17_0 == "exit" then
       -- Warning: missing end command somewhere! Added here
    end
   end)
  local anim_duration = 0.2
  board:setPosition(CCPoint(view.midX, view.minY + 576 * view.minScale))
  board:runAction(CCMoveTo:create(anim_duration, CCPoint(view.midX, view.minY + 150 * view.minScale)))
  herolistBg:runAction(CCMoveTo:create(anim_duration, CCPoint(view.midX, view.minY + 123 * view.minScale)))
  darkbg:runAction(CCFadeTo:create(anim_duration, POPUP_DARK_OPACITY))
  local group = nil
  local btnGroupList = {}
  do
    for i = 1, 6 do
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
        upvalue_2048 = initHerolistData({group = group, hids = hids})
        createHerolist()
        for i,v in ipairs(herolist) do
          for j = 1, 5 do
            if v.hid == hids[j] then
              onMoveUp(i, j, true)
              herolist[i].isUsed = true
            end
          end
        end
         end)
    end
    filterBg:setVisible(false)
    btnFilter:registerScriptTapHandler(function()
      if filterBg:isVisible() == true then
        filterBg:setVisible(false)
      else
        filterBg:setVisible(true)
      end
      end)
    require("ui.tutorial").show("ui.selected.pve", layer)
    return layer
  end
end

ui.getHeroList = function(l_3_0)
  local list = {}
  for i = 1, 5 do
    if l_3_0[i] ~= nil then
      local heroInfo = heros.find(l_3_0[i])
      heroInfo.group = cfghero[heroInfo.id].group
      heroInfo.qlt = cfghero[heroInfo.id].qlt
      heroInfo.hp = 100
      heroInfo.mp = heroInfo.energy or 50
      heroInfo.power = 0
      heroInfo.speed = 0
      heroInfo.crit = 0
      heroInfo.pos = 1
      heroInfo.skin = getHeroSkin(l_3_0[i])
      table.insert(list, heroInfo)
    end
  end
  return list
end

ui.setHeroList = function(l_4_0, l_4_1)
  local list = {}
  for i = 1, 5 do
    if l_4_0[i] ~= nil then
      local heroInfo = heros.find(l_4_0[i])
      heroInfo.group = cfghero[heroInfo.id].group
      heroInfo.qlt = cfghero[heroInfo.id].qlt
      heroInfo.hp = 100
      heroInfo.mp = 100
      heroInfo.power = 0
      heroInfo.speed = 0
      heroInfo.crit = 0
      table.insert(list, heroInfo)
    end
  end
  print("\229\188\128\229\167\139\230\137\147\229\141\176\232\161\168")
  tablePrint(list)
  l_4_1.setHeroList(list)
  return list
end

ui.setStage = function(l_5_0, l_5_1)
  l_5_1.setStage(l_5_0)
end

return ui

