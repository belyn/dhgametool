-- Command line was: E:\github\dhgametool\scripts\ui\town\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local particle = require("res.particle")
local player = require("data.player")
local net = require("net.netClient")
local shortcut = require("common.shortcutmgr")
local lastAllTime = 0
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  layer.onAndroidBack = function()
   end
  local bg = CCNode:create()
  bg:setContentSize(CCSizeMake(view.logical.w, view.logical.h))
  bg:setScale(view.minScale)
  bg:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(bg)
  local main_ani = json.createWithoutSchedule(json.ui.main_zhuchangjing)
  main_ani:setScale(view.minScale)
  main_ani:setPosition(ccp(view.midX, view.midY))
  layer:addChild(main_ani)
  main_ani:playAnimation("animation", -1)
  main_ani:registerAnimation("slide", -1)
  local diaoqiao_ani = json.createWithoutSchedule(json.ui.main_diaoqiao)
  diaoqiao_ani:playAnimation("animation", -1)
  main_ani:addChildFollowSlot("code_diaoqiao", diaoqiao_ani)
  local yun_ani = json.create(json.ui.main_yun)
  yun_ani:playAnimation("animation", -1)
  main_ani:addChildFollowSlot("code_yun", yun_ani)
  local yun_ani2 = json.create(json.ui.main_yun2)
  yun_ani2:playAnimation("animation", -1)
  main_ani:addChildFollowSlot("code_yun2", yun_ani2)
  local snow_ani1 = json.create(json.ui.winter_main_snow1)
  snow_ani1:playAnimation("animation", -1)
  main_ani:addChildFollowSlot("code_winter_main_snow1", snow_ani1)
  local snow_ani2 = json.create(json.ui.winter_main_snow2)
  snow_ani2:playAnimation("animation", -1)
  main_ani:addChildFollowSlot("code_winter_main_snow2", snow_ani2)
  local dq_time = 0
  local playDq = function(l_2_0)
    if dq_time > 0 then
      diaoqiao_ani:update(l_2_0)
      dq_time = dq_time - l_2_0
    end
   end
  local timeUp = CCDelayTime:create(0.01)
  local callBack = CCCallFunc:create(function()
    main_ani:update(0.01, 0)
   end)
  local seq = CCSequence:createWithTwoActions(timeUp, callBack)
  layer:runAction(CCRepeat:create(seq, -1))
  main_ani:update(0, 0)
  local last_selected_sprite = 0
  local onTavernClicked = function(l_4_0)
    audio.play(audio.town_entry_tavern)
    upvalue_512 = 0
    if l_4_0 and not tolua.isnull(l_4_0) then
      clearShader(l_4_0, true)
    end
    if BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_TAVERN_LEVEL then
      showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_TAVERN_LEVEL))
      return 
    end
    replaceScene(require("ui.herotask.main").create())
   end
  local onMarketClicked = function(l_5_0)
    audio.play(audio.town_entry_blackmarket)
    upvalue_512 = 0
    if l_5_0 and not tolua.isnull(l_5_0) then
      clearShader(l_5_0, true)
    end
    if BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_BLACKMARKET_LEVEL then
      showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_BLACKMARKET_LEVEL))
      return 
    end
    replaceScene(require("ui.blackmarket.main").create())
   end
  local onAltarClicked = function(l_6_0)
    audio.play(audio.town_entry_devour)
    upvalue_512 = 0
    if l_6_0 and not tolua.isnull(l_6_0) then
      clearShader(l_6_0, true)
    end
    replaceScene(require("ui.devour.main").create())
   end
  local onHforgeClicked = function(l_7_0)
    audio.play(audio.town_entry_heroforge)
    upvalue_512 = 0
    if l_7_0 and not tolua.isnull(l_7_0) then
      clearShader(l_7_0, true)
    end
    replaceScene(require("ui.heroforge.main").create())
   end
  local onSummonClicked = function(l_8_0)
    audio.play(audio.town_entry_summon)
    upvalue_512 = 0
    if l_8_0 and not tolua.isnull(l_8_0) then
      clearShader(l_8_0, true)
    end
    replaceScene(require("ui.summon.main").create())
   end
  local onStageClicked = function(l_9_0)
    audio.play(audio.town_entry_worldmap)
    upvalue_512 = 0
    if l_9_0 and not tolua.isnull(l_9_0) then
      clearShader(l_9_0, true)
    end
    replaceScene(require("ui.hook.main").create())
   end
  local onBraveClicked = function(l_10_0)
    audio.play(audio.town_entry_airship)
    upvalue_512 = 0
    if l_10_0 and not tolua.isnull(l_10_0) then
      clearShader(l_10_0, true)
    end
    if BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_HERO_BRAVE then
      showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_HERO_BRAVE))
      return 
    end
    local databrave = require("data.brave")
    if not databrave.isPull or databrave.cd < os.time() then
      local params = {sid = player.sid}
      addWaitNet()
      netClient:sync_brave(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        databrave.init(l_1_0)
        if layer and not tolua.isnull(layer) then
          layer:addChild(require("ui.brave.main").create(), 1000)
        end
         end)
    else
      layer:addChild(require("ui.brave.main").create(), 1000)
    end
   end
  local onCasinoClicked = function(l_11_0)
    audio.play(audio.town_entry_casino)
    upvalue_512 = 0
    if l_11_0 and not tolua.isnull(l_11_0) then
      clearShader(l_11_0, true)
    end
    layer:addChild(require("ui.casino.selectcasino").create(), 1000)
   end
  local onSmithClicked = function(l_12_0)
    audio.play(audio.town_entry_smith)
    upvalue_512 = 0
    if l_12_0 and not tolua.isnull(l_12_0) then
      clearShader(l_12_0, true)
    end
    replaceScene(require("ui.smith.main").create())
   end
  local onArenaClicked = function(l_13_0)
    audio.play(audio.town_entry_arena)
    upvalue_512 = 0
    if l_13_0 and not tolua.isnull(l_13_0) then
      clearShader(l_13_0, true)
    end
    if BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_ARENA_LEVEL then
      showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_ARENA_LEVEL))
      return 
    end
    layer:addChild(require("ui.arena.entrance").create(), 1000)
   end
  local onOblivionClicked = function(l_14_0)
    audio.play(audio.town_entry_trial)
    upvalue_512 = 0
    if l_14_0 and not tolua.isnull(l_14_0) then
      clearShader(l_14_0, true)
    end
    if BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_TRIAL_LEVEL then
      showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_TRIAL_LEVEL))
      return 
    end
    addLoading(function()
      replaceScene(require("ui.trial.main").create())
      end, 1)
   end
  local onGodTreeClicked = function(l_15_0)
    audio.play(audio.town_entry_trial)
    upvalue_512 = 0
    if l_15_0 and not tolua.isnull(l_15_0) then
      clearShader(l_15_0, true)
    end
    if BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_GTREE_LEVEL then
      showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_GTREE_LEVEL))
      return 
    end
    layer.mainuiLayer:addChild(require("ui.summonspe.main").create(), 1000)
   end
  local onDilaoClicked = function(l_16_0)
    audio.play(audio.town_entry_trial)
    upvalue_512 = 0
    if l_16_0 and not tolua.isnull(l_16_0) then
      clearShader(l_16_0, true)
    end
    if BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_SOLO_LEVEL then
      showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_SOLO_LEVEL))
      return 
    end
    addWaitNet()
    local params = {sid = player.sid}
    net:spk_sync(params, function(l_1_0)
      delWaitNet()
      print("\230\151\182\233\151\180\228\184\186" .. l_1_0.cd)
      print("\232\191\148\229\155\158\230\149\176\230\141\174")
      tablePrint(l_1_0)
      tbl2string(l_1_0)
      local soloData = require("data.solo")
      soloData.init()
      if l_1_0.status == 1 or l_1_0.status == 2 then
        if soloData.getStatus() == 0 then
          soloData.setSelectOrder(nil)
        end
        soloData.setMainData(l_1_0)
        replaceScene(require("ui.solo.main").create())
      elseif l_1_0.status == 0 then
        soloData.setSelectOrder(nil)
        soloData.setMainData(l_1_0)
        replaceScene(require("ui.solo.noStartUI").create())
      end
      end)
   end
  local onKongdaoClicked = function(l_17_0)
    last_selected_sprite = 0
    if l_17_0 and not tolua.isnull(l_17_0) then
      clearShader(l_17_0, true)
    end
    if BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_AIRISLAND_LEVEL then
      showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_AIRISLAND_LEVEL))
      return 
    end
    local params = {sid = player.sid}
    addWaitNet()
    net:island_sync(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      local airData = require("data.airisland")
      airData.setData(l_1_0)
      addLoading(function()
        replaceScene(require("ui.airisland.main1").create(__data))
         end, 1)
      end)
   end
  local onSealLandClick = function(l_18_0)
    last_selected_sprite = 0
    if l_18_0 and not tolua.isnull(l_18_0) then
      clearShader(l_18_0, true)
    end
    if BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_SEAL_LAND_LEVEL then
      showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_SEAL_LAND_LEVEL))
      return 
    end
    local params = {sid = player.sid}
    addWaitNet()
    net:sealland_sync(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      local sealLandData = require("data.sealland")
      sealLandData:init(l_1_0)
      addLoading(function()
        replaceScene(require("ui.sealland.main").create())
         end, 1)
      end)
   end
  local buildings = {1 = {name = "tarven", jsonName = json.ui.main_jiuguan, code_name = "code_jiuguan", lbl = i18n.global.town_building_tavern.string, lbl_lv = UNLOCK_TAVERN_LEVEL, size = CCSizeMake(100, 200), tapFunc = onTavernClicked}, 2 = {name = "blackmarket", jsonName = json.ui.main_heishi, lbl = i18n.global.town_building_bm.string, lbl_lv = UNLOCK_BLACKMARKET_LEVEL, code_name = "code_heishi", size = CCSizeMake(100, 200), tapFunc = onMarketClicked}, 3 = {name = "altar", jsonName = json.ui.main_tunshi, lbl = i18n.global.town_building_altar.string, lbl_lv = 0, code_name = "code_tunshi", size = CCSizeMake(100, 200), tapFunc = onAltarClicked}, 4 = {name = "summon", jsonName = json.ui.main_zhaohuan, lbl = i18n.global.town_building_summon.string, lbl_lv = 0, code_name = "code_zhaohuan", size = CCSizeMake(100, 200), tapFunc = onSummonClicked}, 5 = {name = "stage", jsonName = json.ui.main_zhanzhengzm, lbl = i18n.global.town_building_stage.string, lbl_lv = 0, lbl_min_w = 160, code_name = "code_zhanyi", size = CCSizeMake(100, 200), tapFunc = onStageClicked}, 6 = {name = "casino", jsonName = json.ui.main_duchang, lbl = i18n.global.town_building_casino.string, lbl_lv = UNLOCK_CASINO_LEVEL, code_name = "code_duchang", size = CCSizeMake(100, 200), tapFunc = onCasinoClicked}, 7 = {name = "smith", jsonName = json.ui.main_tiejiangpu, lbl = i18n.global.town_building_smith.string, lbl_lv = 0, code_name = "code_tiejiangpu", size = CCSizeMake(100, 200), tapFunc = onSmithClicked}, 8 = {name = "trial", jsonName = json.ui.main_huanjing, lbl = i18n.global.town_building_oblivion.string, lbl_lv = UNLOCK_TRIAL_LEVEL, code_name = "code_chengbao", size = CCSizeMake(100, 200), tapFunc = onOblivionClicked}, 9 = {name = "arena", jsonName = json.ui.main_jjc, lbl = i18n.global.town_building_arena.string, lbl_lv = UNLOCK_ARENA_LEVEL, code_name = "code_jjc", size = CCSizeMake(100, 200), tapFunc = onArenaClicked}, 10 = {name = "hforge", jsonName = json.ui.main_summoning, lbl = i18n.global.town_building_hforge.string, lbl_lv = 0, code_name = "code_hecheng", size = CCSizeMake(100, 200), tapFunc = onHforgeClicked}, 11 = {name = "yuanzheng", jsonName = json.ui.main_yuanzheng, lbl = i18n.global.town_building_brave.string, lbl_lv = UNLOCK_HERO_BRAVE, code_name = "code_yuanzheng", size = CCSizeMake(100, 200), tapFunc = onBraveClicked}, 12 = {name = "gtree", jsonName = json.ui.main_tree, lbl = i18n.global.town_building_gtree.string, lbl_lv = UNLOCK_GTREE_LEVEL, code_name = "code_zhongjing", size = CCSizeMake(100, 200), tapFunc = onGodTreeClicked}, 13 = {name = "dilao", jsonName = json.ui.main_dilao, lbl = i18n.global.town_building_dungeon.string, lbl_lv = UNLOCK_SOLO_LEVEL, lbl_hide = false, code_name = "code_dilao", size = CCSizeMake(100, 200), tapFunc = onDilaoClicked}, 14 = {name = "redtree", jsonName = json.ui.main_hongshu, lbl = i18n.global.town_building_gtree.string, lbl_lv = 0, lbl_hide = true, code_name = "code_hongshu", size = CCSizeMake(100, 200)}, 15 = {name = "kongzhan", jsonName = json.ui.kongzhan_rk1, lbl = i18n.global.town_building_airisland.string, lbl_lv = UNLOCK_AIRISLAND_LEVEL, lbl_hide = false, code_name = "code_kongzhan_rk1", size = CCSizeMake(100, 200), tapFunc = onKongdaoClicked}, 16 = {name = "rk2", jsonName = json.ui.kongzhan_rk2, lbl = i18n.global.town_building_gtree.string, lbl_lv = 0, lbl_hide = true, code_name = "code_kongzhan_rk2", size = CCSizeMake(100, 200)}, 17 = {name = "rk3", jsonName = json.ui.kongzhan_rk3, lbl = i18n.global.town_building_gtree.string, lbl_lv = 0, lbl_hide = true, code_name = "code_kongzhan_rk3", size = CCSizeMake(100, 200)}, 18 = {name = "seal_land", jsonName = json.ui.main_seal_land, lbl = i18n.global.town_building_seal_land.string, lbl_lv = UNLOCK_SEAL_LAND_LEVEL, lbl_hide = false, code_name = "code_shijianliefeng", size = CCSizeMake(100, 200), tapFunc = onSealLandClick}}
  local buildingObjs = {}
  local lbl_buildings = {}
  local lbl_spaces = 76
  local building_lbl_color = ccc3(251, 230, 126)
  local createBuildings = function()
    lbl_buildings = {}
    upvalue_512 = {}
    for ii = 1,  buildings do
      local to = buildings[ii]
      local bo = json.create(to.jsonName)
      bo.data = to
      buildingObjs[ii] = bo
      bo:playAnimation("animation", -1)
      main_ani:addChildFollowSlot(to.code_name, bo)
      local lbl_xxx = lbl.createFont2(18, to.lbl, building_lbl_color)
      local building_lbl_xxx = img.createUI9Sprite(img.ui.main_building_lbl)
      lbl_buildings[ii] = building_lbl_xxx
      local bd_size = lbl_xxx:boundingBox().size
      if to.lbl_min_w and bd_size.width < to.lbl_min_w then
        bd_size.width = to.lbl_min_w
      end
      building_lbl_xxx:setPreferredSize(CCSizeMake(bd_size.width + lbl_spaces, 40))
      lbl_xxx:setPosition(CCPoint(building_lbl_xxx:getContentSize().width / 2, building_lbl_xxx:getContentSize().height / 2))
      building_lbl_xxx:addChild(lbl_xxx)
      main_ani:addChildFollowSlot(to.code_name .. "_lbl", building_lbl_xxx)
      if to.lbl_hide then
        building_lbl_xxx:setVisible(false)
      end
      if to.lbl and to.lbl_lv and player.lv() < to.lbl_lv then
        building_lbl_xxx:setVisible(false)
      end
    end
   end
  createBuildings()
  if TEST_ENTRY_ENABLE then
    local testBtn = CCMenuItemFont:create("TEST")
    testBtn:setScale(view.minScale)
    testBtn:setColor(ccc3(255, 0, 0))
    testBtn:setPosition(scalep(600, 490))
    local testMenu = CCMenu:createWithItem(testBtn)
    testMenu:setPosition(0, 0)
    layer:addChild(testMenu)
    testBtn:registerScriptTapHandler(function()
      replaceScene(require("ui.test.main").create())
      end)
  end
  local mainui = require("ui.town.mainui")
  local mainuiLayer = mainui.create(l_1_0)
  layer:addChild(mainuiLayer, 100)
  layer.mainuiLayer = mainuiLayer
  local beginX = 0
  local beginY = 0
  local isClick = false
  local currenX = 0
  local allTime = lastAllTime or 0
  local slideUpdate = function(l_21_0, l_21_1)
    local real_uT = l_21_1
    if real_uT < 0 then
      real_uT = real_uT + 4
    end
    main_ani:update(0, real_uT)
    if not require("data.tutorial").exists() then
      upvalue_512 = allTime + l_21_1
      upvalue_1024 = allTime
      if allTime >= 1 then
        upvalue_512 = 1
      elseif allTime <= -1 then
        upvalue_512 = -1
    end
    upvalue_1536 = l_21_0
   end
  local onTouchBegan = function(l_22_0, l_22_1)
    local po = bg:convertToNodeSpace(CCPoint(l_22_0, l_22_1))
    upvalue_512 = 3
    upvalue_1024 = po.x
    upvalue_1536 = po.y
    upvalue_2048 = true
    upvalue_2560 = po.x
    for ii = 1,  buildingObjs do
      local tObj = buildingObjs[ii]
      if tObj.data.tapFunc and tObj:getAabbBoundingBox():containsPoint(CCPoint(l_22_0, l_22_1)) then
        setShader(tObj, SHADER_HIGHLIGHT, true)
        upvalue_3584 = tObj
    else
      end
    end
    return true
   end
  local onTouchMoved = function(l_23_0, l_23_1)
    local po = bg:convertToNodeSpace(CCPoint(l_23_0, l_23_1))
    if isClick and (math.abs(po.x - beginX) > 15 or math.abs(po.y - beginY) > 15) then
      upvalue_512 = false
      if last_selected_sprite ~= 0 then
        clearShader(last_selected_sprite, true)
        upvalue_2048 = 0
      end
    end
    local deltaX = po.x - currenX
    local uT = deltaX / 300
    if allTime + uT <= 1 and allTime + uT >= -1 then
      slideUpdate(po.x, uT)
    else
      upvalue_2560 = po.x
    end
   end
  local onTouchEnded = function(l_24_0, l_24_1)
    if not isClick then
      return 
    end
    for ii = 1,  buildingObjs do
      local tObj = buildingObjs[ii]
      if tObj:getAabbBoundingBox():containsPoint(CCPoint(l_24_0, l_24_1)) then
        print("you clicked " .. tObj.data.name)
        if tObj.data.tapFunc then
          tObj.data.tapFunc(tObj)
      else
        end
      end
    end
    if last_selected_sprite ~= 0 then
      upvalue_1024 = 0
    end
   end
  local onTouch = function(l_25_0, l_25_1, l_25_2)
    if l_25_0 == "began" then
      return onTouchBegan(l_25_1, l_25_2)
    elseif l_25_0 == "moved" then
      return onTouchMoved(l_25_1, l_25_2)
    else
      return onTouchEnded(l_25_1, l_25_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  addBackEvent(layer, function()
    print("townlayer back event")
   end)
  local registShortcutListener = function()
    shortcut.registShortcutListener(function(l_1_0, l_1_1)
      print("=====================activityType:" .. l_1_0)
      if require("data.tutorial").exists() then
        return 
      end
      if l_1_0 == shortcut.getShortcutFullId(shortcut.ActionEnum.SIGN) then
        layer:addChild(require("ui.loginreward.main").create(), 1000)
      else
        if l_1_0 == shortcut.getShortcutFullId(shortcut.ActionEnum.TASK) then
          if player.lv() < UNLOCK_TASK_LEVEL then
            return 
          end
          layer:addChild(require("ui.task.main").create(), 1000)
        else
          if l_1_0 == shortcut.getShortcutFullId(shortcut.ActionEnum.DARE) then
            local daredata = require("data.dare")
            do
              local nParams = {sid = player.sid}
              addWaitNet()
              netClient:dare_sync(nParams, function(l_1_0)
                delWaitNet()
                tbl2string(l_1_0)
                daredata.sync(l_1_0)
                if layer and not tolua.isnull(layer) then
                  layer:addChild(require("ui.dare.main").create(), 1000)
                end
                     end)
            end
          end
        end
      end
      end)
   end
  local onEnter = function()
    layer.name = "townlayer"
    if lastAllTime and lastAllTime ~= 0 and not require("data.tutorial").exists() then
      upvalue_1024 = 0
      layer.setOffsetTime(lastAllTime)
    else
      registShortcutListener()
    end
    if isIOSLowerModel() then
      json.unloadForTown()
      img.unloadForTown()
    end
   end
  layer:registerScriptHandler(function(l_29_0)
    if l_29_0 == "enter" then
      onEnter()
    elseif l_29_0 == "exit" then
      shortcut.unregistShortcutListener()
    end
   end)
  layer.setOffsetTime = function(l_30_0)
    main_ani:unregisterAnimation("slide")
    main_ani:registerAnimation("slide", -1)
    slideUpdate(0, l_30_0)
   end
  layer.setOffsetX = function(l_31_0)
    lastAllTime = 0
    upvalue_512 = 0
    local uT = l_31_0 / -480
    print("------------_xPos,uT:", l_31_0, uT)
    layer.setOffsetTime(uT)
   end
  local tutorialData = require("data.tutorial")
  local tutorialUI = require("ui.tutorial")
  if tutorialData.getVersion() == 1 and tutorialData.is("rename") then
    layer:addChild(require("ui.player.changename").create(true), 10000)
  end
  if tutorialData.getVersion() == 2 then
    tutorialUI.setTownMainUILayer(mainuiLayer)
  end
  tutorialUI.show("ui.town.main", layer)
  local last_update = os.time()
  local onUpdate = function(l_32_0)
    if main_ani and not tolua.isnull(main_ani) then
      main_ani:update(l_32_0, 0)
    end
    playDq(l_32_0)
    if os.time() - last_update < 2 then
      return 
    end
    upvalue_1024 = os.time()
    local gachaData = require("data.gacha")
    if gachaData.showRedDot() then
      addRedDot(lbl_buildings[4], {px = lbl_buildings[4]:getContentSize().width - 10, py = lbl_buildings[4]:getContentSize().height - 5})
    else
      delRedDot(lbl_buildings[4])
    end
    local herotaskData = require("data.herotask")
    if herotaskData.showRedDot() then
      addRedDot(lbl_buildings[1], {px = lbl_buildings[1]:getContentSize().width - 10, py = lbl_buildings[1]:getContentSize().height - 5})
    else
      delRedDot(lbl_buildings[1])
    end
    local braveData = require("data.brave")
    if braveData.showRedDot() then
      addRedDot(lbl_buildings[11], {px = lbl_buildings[11]:getContentSize().width - 10, py = lbl_buildings[11]:getContentSize().height - 5})
      local userdata = require("data.userdata")
      local hids = {0, 0, 0, 0, 0, 0, -1}
      userdata.setSquadBrave(hids)
    else
      delRedDot(lbl_buildings[11])
    end
    local soloData = require("data.solo")
    if soloData.showRedDot() then
      addRedDot(lbl_buildings[13], {px = lbl_buildings[13]:getContentSize().width - 10, py = lbl_buildings[13]:getContentSize().height - 5})
    else
      delRedDot(lbl_buildings[13])
    end
    local airData = require("data.airisland")
    if airData.showRedDot() then
      addRedDot(lbl_buildings[15], {px = lbl_buildings[15]:getContentSize().width - 10, py = lbl_buildings[15]:getContentSize().height - 5})
    else
      delRedDot(lbl_buildings[15])
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  if not tutorialData.isFinished("rename") then
    gSubmitRoleData({roleLevel = 1, stype = "enterServer"})
  else
    if isChannel() then
      local cfg = require("common.sdkcfg")
      if cfg[APP_CHANNEL] and cfg[APP_CHANNEL].need_submit then
        cfg[APP_CHANNEL].need_submit = nil
        gSubmitRoleData({roleLevel = player.lv(), stype = "enterServer"})
      end
      if cfg[APP_CHANNEL] and cfg[APP_CHANNEL].checkRts then
        cfg[APP_CHANNEL].checkRts()
      end
      if APP_CHANNEL == "WUFAN" then
        cfg[APP_CHANNEL].init()
      end
    end
  end
  if reportInstall then
    reportInstall()
  end
  require("data.gvar").checkAppStore()
  return layer
end

return ui

