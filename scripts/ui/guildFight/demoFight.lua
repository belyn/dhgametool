-- Command line was: E:\github\dhgametool\scripts\ui\guildFight\demoFight.lua 

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
local hookdata = require("data.hook")
local _x_f = 20
local _y_f = 15
local xy = {{attacker = {{x = 645 + _x_f, y = 260 + _y_f}}, defender = {{x = 765 + _x_f, y = 260 + _y_f}}}, {attacker = {{x = 630 + _x_f, y = 240 + _y_f}, {x = 660 + _x_f, y = 280 + _y_f}}, defender = {{x = 785 + _x_f, y = 240 + _y_f}, {x = 755 + _x_f, y = 280 + _y_f}}}; y = 260}
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  fHelper.addBox(layer)
  local loadedIds = {}
  local units = {}
  units.atk_units = {}
  units.def_units = {}
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
    units.atk_units = {}
    units.def_units = {}
    atkIds, defIds = ui.refreshIds(params), params
    if atkIds and defIds then
      local newIds = ui.mergeIds(atkIds, defIds)
      local diffIds = ui.diffIds(loadedIds, newIds)
      upvalue_2048 = newIds
      upvalue_2560 = true
      schedule(layer, function()
        layer.loadAllResources(diffIds, function()
          if needRefresh then
            layer.refreshNow()
          else
            layer:setVisible(true)
            layer.addUnits(atkIds, defIds)
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
    for i,id in ipairs(l_3_1) do
      layer.addUnit(id, "defender", i)
    end
    local t = 0.8
    for _,u in ipairs(units) do
      u.card:runAction(CCFadeIn:create(t))
    end
    schedule(layer, t, layer.nextAction)
   end
  layer.addUnit = function(l_4_0, l_4_1, l_4_2)
    local box = (CCSprite:create())
    local _pos = nil
    if l_4_1 == "attacker" then
      _pos = xy[ atkIds][l_4_1][l_4_2]
    else
      _pos = xy[ defIds][l_4_1][l_4_2]
    end
    box:setPosition(_pos.x, _pos.y)
    layer.box:addChild(box, 4 - l_4_2)
    local card = json.createSpineHero(l_4_0)
    card:setScale(op3(l_4_1 == "attacker", 0.3, 0.3))
    card:setFlipX(l_4_1 ~= "attacker")
    box:addChild(card)
    units[ units + 1] = {heroId = l_4_0, box = box, card = card, size = "small", pos = op3(l_4_1 == "attacker", l_4_2, l_4_2 + 6), side = l_4_1, hp = op3(l_4_1 == "attacker", 100, math.random(5, 10)), atkId = cfghero[l_4_0].atkId}
    print("add unit --------------------", l_4_1)
    if l_4_1 == "attacker" then
      units.atk_units[ units.atk_units + 1] = units[ units]
    else
      print("add def_units-------------------------")
      units.def_units[ units.def_units + 1] = units[ units]
    end
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
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if actee.side ~= "defender" or actee.hp == 0 then
        schedule(layer, tNext, layer.nextAction)
      else
        schedule(layer, tNext, layer.nextAction)
      end
      end)
   end
  layer.nextDefender = function()
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
  local onExit = function()
    layer.unloadAllResources()
   end
  layer:registerScriptHandler(function(l_10_0)
    if l_10_0 == "enter" then
      do return end
    end
    if l_10_0 == "exit" then
      onExit()
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(false)
  return layer
end

ui.refreshIds = function(l_2_0)
  if not l_2_0 or not l_2_0.atkIds or not l_2_0.defIds then
    return 
  end
  local ids = l_2_0.atkIds
  if ids == nil or  ids == 0 then
    return 
  end
  local atkValid = atkIds ~= nil
  if atkIds then
    for _,id in ipairs(atkIds) do
      if not arraycontains(ids, id) then
        atkValid = false
    else
      end
    end
    if atkValid and  atkIds <  ids then
      atkValid = false
    end
  end
  if not atkValid then
    if  ids < 2 then
      atkIds = arraycp(ids)
    else
      local i = math.random(1,  ids)
    end
    ui.jobSort(atkIds)
  end
  local ids = l_2_0.defIds
  if ids == nil or  ids == 0 then
    return 
  end
  do
    local defValid = defIds ~= nil
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

    if ids[i] then
      for _,id in ipairs(op3( ids < i + 1, ids[i + 1 -  ids], ids[i + 1])) do
        atkIds = {}
        if not arraycontains(ids, id) then
          defValid = false
      else
        end
      end
      if defValid and  defIds <  ids then
        defValid = false
      end
    end
    if not defValid then
      if  ids < 2 then
        defIds = arraycp(ids)
      else
        local i = math.random(1,  ids)
      end
      ui.jobSort(defIds)
    end
    return atkIds, defIds
  end
   -- Warning: undefined locals caused missing assignments!
end

ui.jobSort = function(l_3_0)
  table.sort(l_3_0, function(l_1_0, l_1_1)
    local job1, job2 = cfghero[l_1_0].job, cfghero[l_1_1].job
    if job1 == 1 and job2 ~= 1 then
      return true
    elseif job1 ~= 1 and job2 == 1 then
      return false
    end
    if job1 == 4 and job2 ~= 4 then
      return true
    elseif job1 ~= 4 and job2 == 4 then
      return false
    end
    return job1 < job2
   end)
end

ui.mergeIds = function(l_4_0, l_4_1)
  local ids = arraycp(l_4_0)
  for _,id in ipairs(l_4_1) do
    if not arraycontains(ids, id) then
      ids[ ids + 1] = id
    end
  end
  return ids
end

ui.diffIds = function(l_5_0, l_5_1)
  local ids = {}
  for _,id in ipairs(l_5_1) do
    if not arraycontains(l_5_0, id) then
      ids[ ids + 1] = id
    end
  end
  return ids
end

ui.nextActorAndActee = function(l_6_0)
  local actor, actee = nil, nil
  for _,u in ipairs(l_6_0) do
    if not u.hasActed then
      actor = u
  else
    end
  end
  if not actor then
    for _,u in ipairs(l_6_0) do
      u.hasActed = false
    end
    actor = l_6_0[1]
  end
  actor.hasActed = true
  local atk_units = l_6_0.atk_units
  local def_units = l_6_0.def_units
  if actor.side == "attacker" then
    actee = def_units[math.random(1,  def_units)]
  else
    actee = atk_units[math.random(1,  atk_units)]
  end
  return actor, actee
end

return ui

