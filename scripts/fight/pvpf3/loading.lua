-- Command line was: E:\github\dhgametool\scripts\fight\pvpf3\loading.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local i18n = require("res.i18n")
local json = require("res.json")
local audio = require("res.audio")
local herosdata = (require("data.heros"))
local tmp_videos = nil
local memflag = false
ui.create = function(l_1_0, l_1_1)
  if not l_1_0 then
    l_1_0 = tmp_videos
  else
    tmp_videos = l_1_0
  end
  local idx = l_1_1 or 1
  if l_1_0[idx].wins and l_1_0[idx].wins[idx] then
    l_1_0[idx].win = l_1_0[idx].wins[idx]
  end
  local layer = require("fight.base.loading").create()
  l_1_0[idx].noscore = true
  if idx == 1 then
    upvalue_512 = false
    local fx = require("common.helper")
    if fx.isLowMem() then
      upvalue_512 = true
      require("fight.base.loading").unloadUIBeforFight()
    end
  end
  local resInfo = ui.getMapAndHeroIds2(l_1_0, idx)
  local params = {mapId = resInfo.mapId, heroIds = resInfo.heroIds, pets = resInfo.pets, skins = resInfo.skins, heroList = resInfo.heroList}
  layer.startLoadingWithParams(params, function()
    replaceScene(require("fight.pvpf3.video").create(videos, idx))
   end)
  return layer
end

ui.backToUI = function(l_2_0, l_2_1)
  local videos = tmp_videos
  if l_2_0 and l_2_0.skip then
    videos = l_2_0.videos
  end
  local idx = l_2_0.idx
  local mapId, heroIds, pets, skins = ui.getMapAndHeroIds(videos, idx)
  local params = {mapId = mapId, heroIds = heroIds, pets = pets, skins = skins}
  require("fight.base.loading").unloadFightWithParams(params)
  if idx < #videos then
    replaceScene(require("fight.pvpf3.loading").create(videos, idx + 1))
  elseif l_2_1 and not tolua.isnull(l_2_1) then
    l_2_1:addChild(require("fight.pvpf3.final").create(l_2_0), 1000)
  elseif memflag == true then
    local uilayer = require("fight.base.uiloading").create()
    replaceScene(uilayer)
    uilayer.startLoading(mapId, heroIds, function()
      replaceScene(require("ui.frdarena.main").create(video.from_layer))
      end)
  else
    replaceScene(require("ui.frdarena.main").create(l_2_0.from_layer))
  end
end

ui.getMapAndHeroIds = function(l_3_0, l_3_1)
  local mapId, heroIds, pets = MAP_ID_ARENA, {}, {}
  local skins = {}
  for _,h in pairs(l_3_0[l_3_1].atk.camp) do
    h.hid = nil
    if h.skin then
      skins[#skins + 1] = h.skin
    end
    heroIds[#heroIds + 1] = h.id
  end
  if l_3_0[l_3_1].atk and l_3_0[l_3_1].atk.pet then
    pets[#pets + 1] = l_3_0[l_3_1].atk.pet
  end
  for _,h in pairs(l_3_0[l_3_1].def.camp) do
    if h.skin then
      skins[#skins + 1] = h.skin
    end
    heroIds[#heroIds + 1] = h.id
  end
  if l_3_0[l_3_1].def and l_3_0[l_3_1].def.pet then
    pets[#pets + 1] = l_3_0[l_3_1].def.pet
  end
  return mapId, heroIds, pets, skins
end

ui.getMapAndHeroIds2 = function(l_4_0, l_4_1)
  local mapId, heroIds, pets = MAP_ID_ARENA, {}, {}
  local skins = {}
  local heroList = {}
  for _,h in pairs(l_4_0[l_4_1].atk.camp) do
    h.hid = nil
    if h.skin then
      skins[#skins + 1] = h.skin
    end
    heroIds[#heroIds + 1] = h.id
    heroList[#heroList + 1] = h
  end
  if l_4_0[l_4_1].atk and l_4_0[l_4_1].atk.pet then
    pets[#pets + 1] = l_4_0[l_4_1].atk.pet
  end
  for _,h in pairs(l_4_0[l_4_1].def.camp) do
    if h.skin then
      skins[#skins + 1] = h.skin
    end
    if h.hid then
      h.hid = nil
    end
    heroIds[#heroIds + 1] = h.id
    heroList[#heroList + 1] = h
  end
  if l_4_0[l_4_1].def and l_4_0[l_4_1].def.pet then
    pets[#pets + 1] = l_4_0[l_4_1].def.pet
  end
  return {mapId = mapId, heroIds = heroIds, pets = pets, skins = skins, heroList = heroList}
end

return ui

