-- Command line was: E:\github\dhgametool\scripts\fight\hairisland\loading.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local i18n = require("res.i18n")
local json = require("res.json")
local audio = require("res.audio")
local cfgmons = require("config.monster")
local cfgfloatland = require("config.floatland")
local herosdata = require("data.heros")
local player = require("data.player")
local memflag = false
ui.create = function(l_1_0)
  local layer = require("fight.base.loading").create()
  memflag = false
  local fx = require("common.helper")
  if fx.isLowMem() then
    memflag = true
    require("fight.base.loading").unloadUIBeforFight()
  end
  local resInfo = ui.getMapAndHeroIds2(l_1_0)
  local params = {mapId = resInfo.mapId, heroIds = resInfo.heroIds, pets = resInfo.pets, skins = resInfo.skins, heroList = resInfo.heroList}
  layer.startLoadingWithParams(params, function()
    replaceScene(require("fight.hairisland.video").create(video))
   end)
  return layer
end

ui.backToUI = function(l_2_0)
  local mapId, heroIds, pets, skins = ui.getMapAndHeroIds(l_2_0)
  local params = {mapId = mapId, heroIds = heroIds, pets = pets, skins = skins}
  require("fight.base.loading").unloadFightWithParams(params)
  if memflag == true then
    local layer = require("fight.base.uiloading").create()
    replaceScene(layer)
    layer.startLoading(mapId, heroIds, function()
      local params = {sid = player.sid, pos = 0}
      addWaitNet()
      netClient:island_land(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        local airData = require("data.airisland")
        airData.setLandData(l_1_0)
        replaceScene(require("ui.airisland.fightmain").create())
         end)
      end)
  else
    local params = {sid = player.sid, pos = 0}
    addWaitNet()
    netClient:island_land(params, function(l_2_0)
      delWaitNet()
      tbl2string(l_2_0)
      local airData = require("data.airisland")
      airData.setLandData(l_2_0)
      replaceScene(require("ui.airisland.fightmain").create())
      end)
  end
end

ui.backToNext = function(l_3_0, l_3_1)
  local mapId, heroIds, pets, skins = ui.getMapAndHeroIds(l_3_0)
  local params = {mapId = mapId, heroIds = heroIds, pets = pets, skins = skins}
  require("fight.base.loading").unloadFightWithParams(params)
  if memflag == true then
    local layer = require("fight.base.uiloading").create()
    replaceScene(layer)
    layer.startLoading(mapId, heroIds, function()
      nexthandler()
      end)
  else
    l_3_1()
  end
end

ui.getMapAndHeroIds = function(l_4_0)
  local mapId, heroIds, pets = cfgfloatland[l_4_0.stage].map, {}, {}
  local skins = {}
  for _,h in ipairs(l_4_0.camp) do
    if h.skin then
      skins[ skins + 1] = h.skin
    end
    heroIds[ heroIds + 1] = h.id
  end
  if l_4_0.atk and l_4_0.atk.pet then
    pets[ pets + 1] = l_4_0.atk.pet
  end
  for _,m in ipairs(cfgfloatland[l_4_0.stage].monster) do
    heroIds[ heroIds + 1] = cfgmons[m].heroLink
  end
  return mapId, heroIds, pets, skins
end

ui.getMapAndHeroIds2 = function(l_5_0)
  local cfghero = require("config.hero")
  local mapId, heroIds, pets = cfgfloatland[l_5_0.stage].map, {}, {}
  local skins = {}
  local heroList = {}
  for _,h in ipairs(l_5_0.camp) do
    if h.skin then
      skins[ skins + 1] = h.skin
    end
    if h.hid then
      h.hid = nil
    end
    heroIds[ heroIds + 1] = h.id
    heroList[ heroList + 1] = h
  end
  if l_5_0.atk and l_5_0.atk.pet then
    pets[ pets + 1] = l_5_0.atk.pet
  end
  for _,m in ipairs(cfgfloatland[l_5_0.stage].monster) do
    heroIds[ heroIds + 1] = cfgmons[m].heroLink
    local tInfo = clone(cfghero[cfgmons[m].heroLink])
    tInfo.id = cfgmons[m].heroLink
    heroList[ heroList + 1] = tInfo
  end
  return {mapId = mapId, heroIds = heroIds, pets = pets, skins = skins, heroList = heroList}
end

return ui

