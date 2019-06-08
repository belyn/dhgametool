-- Command line was: E:\github\dhgametool\scripts\ui\hook\map.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local player = require("data.player")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local audio = require("res.audio")
local cfgfort = require("config.fort")
local cfgstage = require("config.stage")
local hookdata = require("data.hook")
local fortxy = {0, 0, 0, -600, -600, -960, -960, -960, -1160, -1160, -1420, -1600}
local MODEL_NORMAL = 1
local MODEL_DIFFCULT = 2
local MODEL_HELL = 3
local MODEL_NIGHTMARE = 4
local MODEL_DREAM = 5
local model = {1 = {mapSize = 2, basefort = 0, maxfort = 8, mapName_b = "hookmap_bg_b", mapName = "hookmap_bg", mapName_e = "hookmap_bg_e", allBg = json.ui.bt_all, cloud = json.ui.bt_cloud, weizhi = json.ui.bt_lock_weizhi, dot = json.ui.bt_dot_easy}, 2 = {mapSize = 3, basefort = 8, maxfort = 18, mapName_b = "hook_dmap_b", mapName = "hook_dmap_", mapName_e = "hook_dmap_e", allBg = json.ui.bt_all_kunnan, cloud = json.ui.bt_cloud_kunnan, weizhi = json.ui.bt_lock_weizhi_kunnan, dot = json.ui.bt_dot_hard}, 3 = {mapSize = 3, basefort = 18, maxfort = 30, mapName_b = "hook_hmap_b", mapName = "hook_hmap_", mapName_e = "hook_hmap_e", allBg = json.ui.bt_diyu, cloud = json.ui.bt_cloud_diyu, weizhi = json.ui.bt_lock_weizhi_diyu, dot = json.ui.bt_dot_hell}, 4 = {mapSize = 3, basefort = 30, maxfort = 42, mapName_b = "hook_hmap_b", mapName = "hook_hmap_", mapName_e = "hook_hmap_e", allBg = json.ui.bt_diyu, cloud = json.ui.bt_cloud_diyu, weizhi = json.ui.bt_lock_weizhi_diyu, dot = json.ui.bt_dot_hell}, 5 = {mapSize = 3, basefort = 42, maxfort = 54, mapName_b = "hook_drmap_b", mapName = "hook_drmap_", mapName_e = "hook_drmap_e", allBg = json.ui.bt_diyu, cloud = json.ui.bt_cloud_diyu, weizhi = json.ui.bt_lock_weizhi_diyu, dot = json.ui.bt_dot_hell}}
ui.create = function(l_1_0, l_1_1, l_1_2)
  local layer = CCLayer:create()
  img.load(img.packedOthers.spine_ui_building_10)
  img.load(img.packedOthers.spine_ui_bt_changjing_1)
  img.load(img.packedOthers.ui_hookmap_bg1)
  img.load(img.packedOthers.ui_hookmap_bg2)
  img.load(img.packedOthers.ui_hook_dmap_1)
  img.load(img.packedOthers.ui_hook_dmap_2)
  img.load(img.packedOthers.ui_hook_dmap_3)
  img.load(img.packedOthers.ui_hook_hmap_1)
  img.load(img.packedOthers.ui_hook_hmap_2)
  img.load(img.packedOthers.ui_hook_hmap_3)
  img.load(img.packedOthers.ui_hook_drmap_1)
  img.load(img.packedOthers.ui_hook_drmap_2)
  img.load(img.packedOthers.ui_hook_drmap_3)
  if not l_1_1 then
    layer:addChild(require("ui.hook.main").create(l_1_0), 100)
  end
  local mapModel = l_1_2
  local fort = 1
  if hookdata.getPveStageId() > 1 then
    if cfgstage[hookdata.getPveStageId()] then
      fort = cfgstage[hookdata.getPveStageId()].fortId
    else
      fort =  cfgfort
    end
  end
  local nowstage = (hookdata.getHookStage())
  local nowfort = nil
  if nowstage ~= 0 then
    if cfgstage[nowstage] then
      nowfort = cfgstage[nowstage].fortId
    else
      nowfort =  cfgfort
    end
  else
    nowfort = -1
  end
  if not mapModel then
    if model[MODEL_NIGHTMARE].maxfort < nowfort then
      mapModel = MODEL_DREAM
    else
      if model[MODEL_HELL].maxfort < nowfort then
        mapModel = MODEL_NIGHTMARE
      else
        if model[MODEL_DIFFCULT].maxfort < nowfort then
          mapModel = MODEL_HELL
        else
          if model[MODEL_NORMAL].maxfort < nowfort then
            mapModel = MODEL_DIFFCULT
          else
            mapModel = MODEL_NORMAL
          end
        end
      end
    end
  end
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = SpineMenuItem:create(json.ui.button, btnBackSprite)
  btnBack:setScale(view.minScale)
  btnBack:setPosition(scalep(35, 546))
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  layer:addChild(menuBack, 10)
  btnBack:registerScriptTapHandler(function()
    replaceScene(require("ui.hook.map").create())
   end)
  autoLayoutShift(btnBack)
  local maplayer = CCLayer:create()
  layer:addChild(maplayer)
  local showFort = {}
  local lockAnim = {}
  local mapWidth = 0
  local map_b = img.createUISprite(img.ui[model[mapModel].mapName_b])
  map_b:setScale(view.minScale)
  map_b:setAnchorPoint(ccp(1, 0.5))
  map_b:setPosition(scalep(1, 288))
  maplayer:addChild(map_b)
  for i = 1, model[mapModel].mapSize do
    local map = img.createUISprite(img.ui[model[mapModel].mapName .. i])
    mapWidth = mapWidth + map:getContentSize().width
    map:setScale(view.minScale)
    map:setAnchorPoint(ccp(0, 0.5))
    map:setPosition(scalep(959 * i - 960, 288))
    maplayer:addChild(map)
  end
  local map_e = img.createUISprite(img.ui[model[mapModel].mapName_e])
  map_e:setScale(view.minScale)
  map_e:setAnchorPoint(ccp(0, 0.5))
  map_e:setPosition(scalep(mapWidth - 1 * model[mapModel].mapSize, 288))
  maplayer:addChild(map_e)
  local allbg = json.create(model[mapModel].allBg)
  allbg:playAnimation("animation", -1)
  allbg:setPosition(scalep((mapWidth) / 2, 288))
  allbg:setScale(view.minScale)
  maplayer:addChild(allbg)
  local posbg = json.create(model[mapModel].weizhi)
  posbg:setPosition(scalep((mapWidth) / 2, 288))
  posbg:setScale(view.minScale)
  maplayer:addChild(posbg)
  local dotani = json.create(model[mapModel].dot)
  dotani:setScale(view.minScale)
  dotani:setPosition(scalep((mapWidth) / 2, 288))
  maplayer:addChild(dotani, 100)
  local anim = json.create(model[mapModel].cloud)
  anim:setScale(view.minScale)
  anim:setPosition(scalep((mapWidth) / 2, 288))
  maplayer:addChild(anim, 100)
  local showFort = {}
  local lockAnim = {}
  if model[mapModel].maxfort - model[mapModel].basefort <= fort - model[mapModel].basefort then
    dotani:playAnimation(model[mapModel].maxfort - model[mapModel].basefort)
    dotani:update(100)
  end
  for i = 1, model[mapModel].maxfort - model[mapModel].basefort do
    showFort[i] = json.create(json.ui.bt_" .. )
    showFort[i]:playAnimation("animation", -1)
    allbg:addChildFollowSlot("code_bt_" .. i, showFort[i])
    if mapModel == MODEL_NORMAL and i ~= model[mapModel].maxfort - model[mapModel].basefort then
      setShader(showFort[i], SHADER_SOFT_LIGHT_NORMAL + i - 1, true)
    end
    if mapModel == MODEL_DIFFCULT and i ~= model[mapModel].maxfort - model[mapModel].basefort then
      setShader(showFort[i], SHADER_SOFT_LIGHT_DIFFICULT + i - 1, true)
    end
    if mapModel == MODEL_HELL and i ~= model[mapModel].maxfort - model[mapModel].basefort then
      setShader(showFort[i], SHADER_SOFT_LIGHT_DUNGEON + i - 1, true)
    end
    if mapModel == MODEL_NIGHTMARE and i ~= model[mapModel].maxfort - model[mapModel].basefort then
      setShader(showFort[i], SHADER_SOFT_LIGHT_NIGHTMARE + i - 1, true)
    end
    if mapModel == MODEL_DREAM and i ~= model[mapModel].maxfort - model[mapModel].basefort then
      setShader(showFort[i], SHADER_SOFT_LIGHT_DREAM + i - 1, true)
    end
    local showLayer = CCLayer:create()
    posbg:addChildFollowBone("code_bt_" .. i, showLayer)
    local showName = lbl.createFont2(18, i18n.fort[model[mapModel].basefort + i].fortName, ccc3(255, 246, 223))
    showName:setPosition(0, -70)
    showLayer:addChild(showName)
    if fort - model[mapModel].basefort < i then
      lockAnim[i] = json.create(json.ui.bt_lock)
      lockAnim[i]:setPosition(0, 0)
      showLayer:addChild(lockAnim[i])
    else
      if i == fort - model[mapModel].basefort and i > 1 then
        dotani:playAnimation(i)
        dotani:update(100)
      end
    end
    if i == nowfort - model[mapModel].basefort then
      local animBattle = json.create(json.ui.bt_sword)
      animBattle:setPosition(0, -30)
      animBattle:playAnimation("animation", -1)
      showLayer:addChild(animBattle)
    end
    if i == fort - model[mapModel].basefort and nowfort ~= fort then
      if i > 1 then
        dotani:playAnimation(i)
      end
      lockAnim[i] = json.create(json.ui.bt_lock)
      lockAnim[i]:setPosition(0, 0)
      lockAnim[i]:playAnimation("animation")
      showLayer:addChild(lockAnim[i])
      schedule(layer, 0.6, function()
        if isPlay then
          audio.play(audio.map_unlock)
        end
         end)
    end
  end
  for i = 1, 5 do
    local anim = json.create(json.ui.bt_pubu)
    anim:playAnimation("animation", -1)
    if i == 1 then
      showFort[5]:addChildFollowSlot("code_pubu", anim)
    else
      showFort[5]:addChildFollowSlot("code_pubu" .. i, anim)
    end
  end
  local onHook = function(l_3_0)
    local params = {sid = player.sid, stage = cfgfort[l_3_0].stageId[1]}
    addWaitNet()
    hookdata.change(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status == -1 then
        showToast(i18n.global.hook_grade_lack.string)
        return 
      end
      if l_1_0.status ~= 0 then
        showToast("server status:" .. l_1_0.status)
        return 
      end
      hookdata.hook_stage = params.stage
      if l_1_0.reward then
        hookdata.set_reward(l_1_0.reward)
      end
      if l_1_0.boss_cd then
        hookdata.boss_cd = l_1_0.boss_cd + os.time() - hookdata.init_time
      end
      replaceScene(require("ui.hook.map").create())
      end)
   end
  local lastx = 0
  local lastPos = nil
  local isTouchEnd = true
  local delta_x = 0
  local updateTime = 0
  local deltaMove = function(l_4_0)
    if updateTime >= 480 then
      if updateTime >= 480 then
        updateTime = 0
      end
      showFort[7]:registerAnimation("fire", 1, false)
    end
    updateTime = updateTime + 1
    if not isTouchEnd then
      return 
    end
    if not ATTENUATION_COEFFCIENT + 1 < delta_x and delta_x < ATTENUATION_COEFFCIENT - 1 then
      return 
    end
    local posx = maplayer:getPositionX() + delta_x
    if posx < (view.logical.w - mapWidth) * view.minScale then
      posx = (view.logical.w - mapWidth) * view.minScale
    end
    if posx > 0 then
      posx = 0
    end
    maplayer:setPositionX(posx)
    if delta_x <= 0 or not delta_x - ATTENUATION_COEFFCIENT then
      upvalue_1536 = delta_x + ATTENUATION_COEFFCIENT
    end
   end
  layer:scheduleUpdateWithPriorityLua(deltaMove, 0)
  local onTouchBegin = function(l_5_0, l_5_1)
    lastPos = CCPoint(l_5_0, l_5_1)
    upvalue_512 = l_5_0
    upvalue_1024 = false
    return true
   end
  local onTouchMoved = function(l_6_0, l_6_1)
    if lastPos then
      local posx = maplayer:getPositionX() + l_6_0 - lastPos.x
      if posx < (view.logical.w - mapWidth) * view.minScale then
        posx = (view.logical.w - mapWidth) * view.minScale
      end
      if posx > 0 then
        posx = 0
      end
      maplayer:setPositionX(posx)
      upvalue_2048 = l_6_0 - lastPos.x
      lastPos = CCPoint(l_6_0, l_6_1)
    end
   end
  local onTouchEnd = function(l_7_0, l_7_1)
    isTouchEnd = true
    if math.abs(l_7_0 - lastx) > 10 then
      return 
    end
    do
      for i,v in ipairs(showFort) do
        do
          if v:getAabbBoundingBox():containsPoint(ccp(l_7_0, l_7_1)) then
            if i <= fort - model[mapModel].basefort and i ~= nowfort - model[mapModel].basefort then
              local params = {title = "", text = i18n.global.hookmap_goto_hook.string, handle = function()
            onHook(i + model[mapModel].basefort)
               end}
              layer:addChild(require("ui.tips.confirm").create(params))
            else
              if fort - model[mapModel].basefort < i then
                showToast(i18n.global.toast_hookmap_pass.string)
              end
            end
        else
          end
        end
      end
    end
   end
  local onTouch = function(l_8_0, l_8_1, l_8_2)
    if l_8_0 == "began" then
      return onTouchBegin(l_8_1, l_8_2)
    elseif l_8_0 == "moved" then
      return onTouchMoved(l_8_1, l_8_2)
    else
      return onTouchEnd(l_8_1, l_8_2)
    end
   end
  layer.setOffsetX = function(l_9_0)
    maplayer:setPositionX(l_9_0 * view.minScale)
   end
  maplayer:registerScriptTouchHandler(onTouch)
  maplayer:setTouchEnabled(true)
  local off = nowfort - model[mapModel].basefort
  if off <= 0 then
    off = 1
  end
  if off >= 9 and mapModel == MODEL_NORMAL then
    off = 8
  end
  if off >= 11 and mapModel == MODEL_DIFFCULT then
    off = 10
  end
  if off >= 11 and mapModel == MODEL_HELL then
    off = 10
  end
  if off >= 11 and mapModel == MODEL_NIGHTMARE then
    off = 10
  end
  maplayer:setPositionX(fortxy[off] * view.minScale)
  if l_1_1 then
    if fort - model[mapModel].basefort <= model[mapModel].maxfort - model[mapModel].basefort then
      anim:playAnimation(fort - model[mapModel].basefort, -1)
    else
      anim:playAnimation(model[mapModel].maxfort - model[mapModel].basefort, -1)
    end
  end
  addBackEvent(layer)
  layer.onAndroidBack = function()
    replaceScene(require("ui.hook.map").create())
   end
  local onEnter = function()
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_13_0)
    if l_13_0 == "enter" then
      onEnter()
    elseif l_13_0 == "exit" then
      onExit()
    elseif l_13_0 == "cleanup" and isIOSLowerModel() then
      img.unload(img.packedOthers.spine_ui_bt_changjing_1)
      img.unload(img.packedOthers.spine_ui_building_10)
      img.unload(img.packedOthers.ui_hookmap_bg2)
      img.unload(img.packedOthers.ui_hook_dmap_1)
      img.unload(img.packedOthers.ui_hook_dmap_2)
      img.unload(img.packedOthers.ui_hook_dmap_3)
      img.unload(img.packedOthers.ui_hook_hmap_1)
      img.unload(img.packedOthers.ui_hook_hmap_2)
      img.unload(img.packedOthers.ui_hook_hmap_3)
      img.unload(img.packedOthers.ui_hook_drmap_1)
      img.unload(img.packedOthers.ui_hook_drmap_2)
      img.unload(img.packedOthers.ui_hook_drmap_3)
    end
   end)
  local ltitleTag = img.createUISprite(img.ui.hook_map_titlebg)
  ltitleTag:setScale(view.minScale)
  ltitleTag:setAnchorPoint(1, 1)
  ltitleTag:setPosition(scalep(480, 576))
  layer:addChild(ltitleTag, 10)
  local rtitleTag = img.createUISprite(img.ui.hook_map_titlebg)
  rtitleTag:setScale(view.minScale)
  rtitleTag:setAnchorPoint(0, 1)
  rtitleTag:setPosition(scalep(480, 576))
  rtitleTag:setFlipX(true)
  layer:addChild(rtitleTag, 10)
  autoLayoutShift(ltitleTag)
  autoLayoutShift(rtitleTag)
  local btnNormalSp0 = img.createUISprite(img.ui.hook_normol_0)
  local btnNormalSp1 = img.createUISprite(img.ui.hook_normol_1)
  local btnNormal = CCMenuItemSprite:create(btnNormalSp0, btnNormalSp1)
  btnNormal:setScale(view.minScale)
  btnNormal:setPosition(scalep(248, 536))
  local menuNormal = CCMenu:createWithItem(btnNormal)
  menuNormal:setPosition(0, 0)
  layer:addChild(menuNormal, 10)
  btnNormal:registerScriptTapHandler(function()
    replaceScene(require("ui.hook.map").create(info, isPlay, MODEL_NORMAL))
   end)
  autoLayoutShift(btnNormal)
  local labNormal = lbl.createFont2(16, i18n.global.hook_map_btn_normal.string, ccc3(255, 246, 223))
  labNormal:setPosition(btnNormal:getContentSize().width / 2, 10)
  btnNormal:addChild(labNormal)
  local btnDiffcultSp0 = img.createUISprite(img.ui.hook_diffic_0)
  local btnDiffcultSp1 = img.createUISprite(img.ui.hook_diffic_1)
  local btnDiffcult = CCMenuItemSprite:create(btnDiffcultSp0, btnDiffcultSp1)
  btnDiffcult:setScale(view.minScale)
  btnDiffcult:setPosition(scalep(364, 536))
  local menuDiffcult = CCMenu:createWithItem(btnDiffcult)
  menuDiffcult:setPosition(0, 0)
  layer:addChild(menuDiffcult, 10)
  btnDiffcult:registerScriptTapHandler(function()
    replaceScene(require("ui.hook.map").create(info, isPlay, MODEL_DIFFCULT))
   end)
  autoLayoutShift(btnDiffcult)
  local labDiffcult = lbl.createFont2(16, i18n.global.hook_map_btn_diffcult.string, ccc3(255, 246, 223))
  labDiffcult:setPosition(btnDiffcult:getContentSize().width / 2, 10)
  btnDiffcult:addChild(labDiffcult)
  local btnHellSp0 = img.createUISprite(img.ui.hook_hell_0)
  local btnHellSp1 = img.createUISprite(img.ui.hook_hell_1)
  local btnHell = CCMenuItemSprite:create(btnHellSp0, btnHellSp1)
  btnHell:setScale(view.minScale)
  btnHell:setPosition(scalep(480, 536))
  local menuHell = CCMenu:createWithItem(btnHell)
  menuHell:setPosition(0, 0)
  layer:addChild(menuHell, 10)
  btnHell:registerScriptTapHandler(function()
    replaceScene(require("ui.hook.map").create(info, isPlay, MODEL_HELL))
   end)
  autoLayoutShift(btnHell)
  local labHell = lbl.createFont2(16, i18n.global.hook_map_btn_hell.string, ccc3(255, 246, 223))
  labHell:setPosition(btnHell:getContentSize().width / 2, 10)
  btnHell:addChild(labHell)
  local btnNightmareSp0 = img.createUISprite(img.ui.hook_nmare_0)
  local btnNightmareSp1 = img.createUISprite(img.ui.hook_nmare_1)
  local btnNightmare = CCMenuItemSprite:create(btnNightmareSp0, btnNightmareSp1)
  btnNightmare:setScale(view.minScale)
  btnNightmare:setPosition(scalep(596, 536))
  local menuNightmare = CCMenu:createWithItem(btnNightmare)
  menuNightmare:setPosition(0, 0)
  layer:addChild(menuNightmare, 10)
  btnNightmare:registerScriptTapHandler(function()
    replaceScene(require("ui.hook.map").create(info, isPlay, MODEL_NIGHTMARE))
   end)
  autoLayoutShift(btnNightmare)
  local labNightmare = lbl.createFont2(16, i18n.global.hook_map_btn_nmare.string, ccc3(255, 246, 223))
  labNightmare:setPosition(btnNightmare:getContentSize().width / 2, 10)
  btnNightmare:addChild(labNightmare)
  local btnDreamSp0 = img.createUISprite(img.ui.hook_dream_0)
  local btnDreamSp1 = img.createUISprite(img.ui.hook_dream_1)
  local btnDream = CCMenuItemSprite:create(btnDreamSp0, btnDreamSp1)
  btnDream:setScale(view.minScale)
  btnDream:setPosition(scalep(712, 536))
  local menuDream = CCMenu:createWithItem(btnDream)
  menuDream:setPosition(0, 0)
  layer:addChild(menuDream, 10)
  btnDream:registerScriptTapHandler(function()
    replaceScene(require("ui.hook.map").create(info, isPlay, MODEL_DREAM))
   end)
  autoLayoutShift(btnDream)
  local labDream = lbl.createFont2(16, i18n.global.hook_map_btn_dream.string, ccc3(255, 246, 223))
  labDream:setPosition(btnDream:getContentSize().width / 2, 10)
  btnDream:addChild(labDream)
  if mapModel == MODEL_NORMAL then
    btnNormal:setEnabled(false)
    btnNormal:selected()
    labNormal:setColor(ccc3(251, 230, 126))
    labHell:setColor(ccc3(255, 246, 223))
    labDiffcult:setColor(ccc3(255, 246, 223))
    labNightmare:setColor(ccc3(255, 246, 223))
    labDream:setColor(ccc3(255, 246, 223))
  elseif mapModel == MODEL_DIFFCULT then
    btnDiffcult:setEnabled(false)
    btnDiffcult:selected()
    labDiffcult:setColor(ccc3(251, 230, 126))
    labNormal:setColor(ccc3(255, 246, 223))
    labHell:setColor(ccc3(255, 246, 223))
    labNightmare:setColor(ccc3(255, 246, 223))
    labDream:setColor(ccc3(255, 246, 223))
  elseif mapModel == MODEL_HELL then
    btnHell:setEnabled(false)
    btnHell:selected()
    labHell:setColor(ccc3(251, 230, 126))
    labDiffcult:setColor(ccc3(255, 246, 223))
    labNormal:setColor(ccc3(255, 246, 223))
    labNightmare:setColor(ccc3(255, 246, 223))
    labDream:setColor(ccc3(255, 246, 223))
  elseif mapModel == MODEL_DREAM then
    btnDream:setEnabled(false)
    btnDream:selected()
    labDream:setColor(ccc3(251, 230, 126))
    labDiffcult:setColor(ccc3(255, 246, 223))
    labNormal:setColor(ccc3(255, 246, 223))
    labNightmare:setColor(ccc3(255, 246, 223))
    labHell:setColor(ccc3(255, 246, 223))
  else
    btnNightmare:setEnabled(false)
    btnNightmare:selected()
    labNightmare:setColor(ccc3(251, 230, 126))
    labHell:setColor(ccc3(255, 246, 223))
    labDiffcult:setColor(ccc3(255, 246, 223))
    labNormal:setColor(ccc3(255, 246, 223))
    labDream:setColor(ccc3(255, 246, 223))
  end
  for i = 1, 5 do
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if model[6 - i].basefort < fort and nowfort <= model[6 - i].basefort then
      json.load(json.ui.unlock)
      tagAnim = DHSkeletonAnimation:createWithKey(json.ui.unlock)
      tagAnim:playAnimation("animation", -1)
      tagAnim:scheduleUpdateLua()
      tagAnim:setPosition(btnHell:getContentSize().width / 2, btnHell:getContentSize().height / 2)
      if 6 - i == MODEL_NORMAL then
        btnNormal:addChild(tagAnim)
      else
        if 6 - i == MODEL_DIFFCULT then
          btnDiffcult:addChild(tagAnim)
        else
          if 6 - i == MODEL_HELL then
            btnHell:addChild(tagAnim)
          else
            if 6 - i == MODEL_NIGHTMARE then
              btnNightmare:addChild(tagAnim)
            else
              btnDream:addChild(tagAnim)
              do return end
            end
          end
        end
      end
    end
  end
  return layer
end

return ui

