-- Command line was: E:\github\dhgametool\scripts\ui\hook\fight.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local audio = require("res.audio")
local cfghero = require("config.hero")
local cfgbuff = require("config.buff")
local cfgskill = require("config.skill")
local cfgstage = require("config.stage")
local cfgmons = require("config.monster")
local fHelper = require("fight.helper.fx")
local hHelper = require("fight.helper.hero")
local hookdata = (require("data.hook"))
local atkIds, defId, defIdx = nil, nil, nil
local xy = {{attacker = {328}, defender = {606}}, {attacker = {390, 260}, defender = {687}}, {attacker = {457, 323, 190}, defender = {713}}; y = 280}
ui.create = function()
  local layer = CCLayer:create()
  fHelper.addBox(layer)
  local loadedIds = {}
  local units = nil
  local needRefresh = false
  local hasBegan = false
  layer.refresh = function()
    layer:setVisible(false)
    if hasBegan then
      upvalue_1024 = true
    else
      layer.refreshNow()
    end
   end
  layer.refreshNow = function()
    needRefresh = false
    if units then
      do
        for _,u in ipairs(units) do
          u.card:removeFromParent()
          u.card = nil
        end
      end
    end
    upvalue_512 = {}
    upvalue_1024, upvalue_1536, upvalue_2048 = ui.refreshIds(atkIds, defId, defIdx), atkIds, defId
    if atkIds and defId and defIdx then
      local newIds = ui.mergeIds(atkIds, {defId})
      local diffIds = ui.diffIds(loadedIds, newIds)
      upvalue_3072 = newIds
      upvalue_3584 = true
      schedule(layer, function()
        layer.loadAllResources(diffIds, function()
          if needRefresh then
            layer.refreshNow()
          else
            layer:setVisible(true)
            layer.addUnits(atkIds, defId)
          end
            end)
         end)
    end
   end
  layer.refreshNow()
  layer.addUnits = function(l_3_0, l_3_1)
    for i,id in ipairs(l_3_0) do
      layer.addUnit(id, "attacker", i)
    end
    layer.addUnit(l_3_1, "defender", 1)
    local t = 0.8
    for _,u in ipairs(units) do
      u.card:runAction(CCFadeIn:create(t))
    end
    schedule(layer, t, layer.nextAction)
   end
  layer.addUnit = function(l_4_0, l_4_1, l_4_2)
    local box = CCSprite:create()
    box:setPosition(xy[ atkIds][l_4_1][l_4_2], xy.y)
    layer.box:addChild(box, 4 - l_4_2)
    local card = json.createSpineHero(l_4_0)
    card:setScale(op3(l_4_1 == "attacker", 0.4, 0.5))
    card:setFlipX(l_4_1 ~= "attacker")
    box:addChild(card)
    units[ units + 1] = {heroId = l_4_0, box = box, card = card, size = "small", pos = op3(l_4_1 == "attacker", l_4_2, l_4_2 + 6), side = l_4_1, hp = op3(l_4_1 == "attacker", 100, math.random(5, 10)), atkId = cfghero[l_4_0].atkId}
   end
  layer.nextAction = function()
    if needRefresh then
      layer.refreshNow()
      return 
    end
    local actor, actee = ui.nextActorAndActee(units)
    local action = cfghero[actor.heroId].atkId
    local tActor, tNext = fHelper.playActor(layer, actor, action, {actee})
    schedule(layer, tActor, function()
      fHelper.playActee(layer, actor, actee, action, buffname2id(BUFF_HURT))
      if actee.side == "defender" then
        actee.hp = actee.hp - 1
      end
      if actee.hp == 0 then
        actee.card:runAction(createSequence({}))
        schedule(layer, 3, layer.nextDefender)
      else
        schedule(layer, tNext, layer.nextAction)
      end
       -- Warning: undefined locals caused missing assignments!
      end)
   end
  layer.nextDefender = function()
    table.remove(units,  units)
    local stage = hookdata.getHookStage()
    local mons = cfgstage[stage].monsterShow
    upvalue_1536 = op3( mons < defIdx + 1, 1, defIdx + 1)
    upvalue_2048 = mons[defIdx]
    local newIds = ui.mergeIds(atkIds, {defId})
    local diffIds = ui.diffIds(loadedIds, newIds)
    upvalue_3584 = newIds
    schedule(layer, function()
      layer.loadAllResources(diffIds, function()
        layer.addUnit(defId, "defender", 1)
        for _,u in ipairs(units) do
          u.hasActed = false
        end
        local t = 0.8
        local def = units[ units]
        def.card:runAction(CCFadeIn:create(t))
        schedule(layer, t, layer.nextAction)
         end)
      end)
   end
  local imgList, jsonList = {}, {}
  layer.loadAllResources = function(l_7_0, l_7_1)
    if  l_7_0 == 0 then
      l_7_1()
      return 
    end
    imgList = arraymerge(imgList, img.getLoadListForFight(nil, l_7_0, true))
    upvalue_1024 = arraymerge(jsonList, json.getLoadListForFight(l_7_0, true))
    local sum, num =  imgList, 0
    img.loadAsync(imgList, function()
      num = num + 1
      if num == sum and not tolua.isnull(layer) then
        json.loadAll(jsonList)
        schedule(layer, onFinish)
      end
      end)
   end
  layer.unloadAllResources = function()
    json.unloadAll(jsonList)
    img.unloadList(imgList)
   end
  layer:registerScriptHandler(function(l_9_0)
    if l_9_0 == "enter" then
      do return end
    end
    if l_9_0 == "exit" then
      print("----------------fightlayer exit")
      layer.unloadAllResources()
    end
   end)
  return layer
end

ui.refreshIds = function(l_2_0, l_2_1, l_2_2)
  local ids = hookdata.getIDS()
  local stage = hookdata.getHookStage()
  local cfg = cfgstage[stage]
  if stage == 0 or ids == nil or  ids == 0 then
    return 
  end
  local atkValid = l_2_0 ~= nil
  if l_2_0 then
    for _,id in ipairs(l_2_0) do
      if not arraycontains(ids, id) then
        atkValid = false
    else
      end
    end
    if atkValid and  l_2_0 <  ids then
      atkValid = false
    end
  end
  if not atkValid then
    if  ids < 3 then
      l_2_0 = arraycp(ids)
    else
      local i = math.random(1,  ids)
    end
     -- DECOMPILER ERROR: Overwrote pending register.

    table.sort(l_2_0, ids[i])
  end
  do
    local defValid = false
    do
      if l_2_1 and l_2_2 then
        local m = cfg.monsterShow[l_2_2]
    end
    if m and m == l_2_1 then
      end
    end
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  return l_2_0, l_2_1, l_2_2
end
 -- Warning: undefined locals caused missing assignments!
end

ui.mergeIds = function(l_3_0, l_3_1)
  local ids = arraycp(l_3_0)
  for _,id in ipairs(l_3_1) do
    if not arraycontains(ids, id) then
      ids[ ids + 1] = id
    end
  end
  return ids
end

ui.diffIds = function(l_4_0, l_4_1)
  local ids = {}
  for _,id in ipairs(l_4_1) do
    if not arraycontains(l_4_0, id) then
      ids[ ids + 1] = id
    end
  end
  return ids
end

ui.nextActorAndActee = function(l_5_0)
  local actor, actee = nil, nil
  for _,u in ipairs(l_5_0) do
    if not u.hasActed then
      actor = u
  else
    end
  end
  if not actor then
    for _,u in ipairs(l_5_0) do
      u.hasActed = false
    end
    actor = l_5_0[1]
  end
  actor.hasActed = true
  if actor.side == "attacker" then
    actee = l_5_0[ l_5_0]
  else
    actee = l_5_0[math.random(1,  l_5_0 - 1)]
  end
  return actor, actee
end

return ui

