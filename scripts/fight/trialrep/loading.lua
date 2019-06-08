-- Command line was: E:\github\dhgametool\scripts\fight\trialrep\loading.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local i18n = require("res.i18n")
local json = require("res.json")
local audio = require("res.audio")
local cfgwavetrial = require("config.wavetrial")
local cfgmons = require("config.monster")
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
    replaceScene(require("fight.trialrep.video").create(video))
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
      replaceScene(require("ui.trial.main").create())
      end)
  else
    replaceScene(require("ui.trial.main").create())
  end
end

ui.backToSmith = function(l_3_0)
  local mapId, heroIds, pets, skins = ui.getMapAndHeroIds(l_3_0)
  local params = {mapId = mapId, heroIds = heroIds, pets = pets, skins = skins}
  require("fight.base.loading").unloadFightWithParams(params)
  if memflag == true then
    local layer = require("fight.base.uiloading").create()
    replaceScene(layer)
    layer.startLoading(mapId, heroIds, function()
      replaceScene(require("ui.smith.main").create())
      end)
  else
    replaceScene(require("ui.smith.main").create())
  end
end

ui.backToHero = function(l_4_0)
  local mapId, heroIds, pets, skins = ui.getMapAndHeroIds(l_4_0)
  local params = {mapId = mapId, heroIds = heroIds, pets = pets, skins = skins}
  require("fight.base.loading").unloadFightWithParams(params)
  if memflag == true then
    local layer = require("fight.base.uiloading").create()
    replaceScene(layer)
    layer.startLoading(mapId, heroIds, function()
      replaceScene(require("ui.herolist.main").create())
      end)
  else
    replaceScene(require("ui.herolist.main").create())
  end
end

ui.backToSummon = function(l_5_0)
  local mapId, heroIds, pets, skins = ui.getMapAndHeroIds(l_5_0)
  local params = {mapId = mapId, heroIds = heroIds, pets = pets, skins = skins}
  require("fight.base.loading").unloadFightWithParams(params)
  if memflag == true then
    local layer = require("fight.base.uiloading").create()
    replaceScene(layer)
    layer.startLoading(mapId, heroIds, function()
      replaceScene(require("ui.summon.main").create())
      end)
  else
    replaceScene(require("ui.summon.main").create())
  end
end

ui.getMapAndHeroIds = function(l_6_0)
  local mapId, heroIds, pets = cfgwavetrial[l_6_0.stage].map, {}, {}
  local skins = {}
  for _,h in ipairs(l_6_0.camp) do
    if h and h.pos ~= 7 then
      if h.skin then
        skins[ skins + 1] = h.skin
      end
      heroIds[ heroIds + 1] = h.id
    end
  end
  if l_6_0.atk and l_6_0.atk.pet then
    pets[ pets + 1] = l_6_0.atk.pet
  end
  for _,m in ipairs(cfgwavetrial[l_6_0.stage].trial) do
    heroIds[ heroIds + 1] = cfgmons[m].heroLink
  end
  if l_6_0.def and l_6_0.def.pet then
    pets[ pets + 1] = l_6_0.def.pet
  end
  return mapId, heroIds, pets, skins
end

ui.getMapAndHeroIds2 = function(l_7_0)
  local cfghero = require("config.hero")
  local mapId, heroIds, pets = cfgwavetrial[l_7_0.stage].map, {}, {}
  local skins = {}
  local heroList = {}
  for _,h in ipairs(l_7_0.camp) do
    if h and h.pos ~= 7 then
      if h.skin then
        skins[ skins + 1] = h.skin
      end
      if h.hid then
        h.hid = nil
      end
      heroIds[ heroIds + 1] = h.id
      heroList[ heroList + 1] = h
    end
  end
  if l_7_0.atk and l_7_0.atk.pet then
    pets[ pets + 1] = l_7_0.atk.pet
  end
  for _,m in ipairs(cfgwavetrial[l_7_0.stage].trial) do
    heroIds[ heroIds + 1] = cfgmons[m].heroLink
    local tInfo = clone(cfghero[cfgmons[m].heroLink])
    tInfo.id = cfgmons[m].heroLink
    heroList[ heroList + 1] = tInfo
  end
  if l_7_0.def and l_7_0.def.pet then
    pets[ pets + 1] = l_7_0.def.pet
  end
  return {mapId = mapId, heroIds = heroIds, pets = pets, skins = skins, heroList = heroList}
end

return ui

