-- Command line was: E:\github\dhgametool\scripts\fight\base\loading.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local i18n = require("res.i18n")
local json = require("res.json")
local audio = require("res.audio")
ui.create = function()
  local bgIndex = math.random(3)
  if bgIndex == 2 then
    img.load(img.packedOthers.fightLoading[bgIndex])
  end
  local layer = require("fight.loadingbg.bg" .. bgIndex).create()
  local tipsIndex = math.random( i18n.loadingtips)
  layer.setHint(i18n.loadingtips[tipsIndex].tips)
  layer.startLoading = function(l_1_0, l_1_1, l_1_2)
    audio.stopBackgroundMusic()
    schedule(layer, function()
      local imgList = img.getLoadListForFight(mapId, heroIds)
      local jsonList = json.getLoadListForFight(heroIds)
      layer.loadFight(imgList, jsonList, onFinish)
      end)
   end
  layer.startLoadingWithParams = function(l_2_0, l_2_1)
    local mapId = l_2_0.mapId
    local heroIds = l_2_0.heroIds
    local pets = l_2_0.pets
    local skins = l_2_0.skins
    local heroList = l_2_0.heroList
    audio.stopBackgroundMusic()
    schedule(layer, function()
      local imgList = img.getLoadListForFight2(mapId, heroList)
      local petImgList = img.getLoadListForPet(pets)
      local skinImgList = img.getLoadListForSkin(skins)
      imgList = arraymerge(imgList, petImgList)
      imgList = arraymerge(imgList, skinImgList)
      local jsonList = json.getLoadListForFight2(heroList)
      local petJsonList = json.getLoadListForPet(pets)
      local skinJsonList = json.getLoadListForSkin(skins)
      jsonList = arraymerge(jsonList, petJsonList)
      jsonList = arraymerge(jsonList, skinJsonList)
      layer.loadFight(imgList, jsonList, onFinish)
      end)
   end
  local beginTime = os.time()
  layer.loadFight = function(l_3_0, l_3_1, l_3_2)
    local pixel_format = CCTexture2D:defaultAlphaPixelFormat()
    if device.platform == "ios" and require("common.helper").isLowMem() then
      CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA4444)
    end
    local sum, num =  l_3_0, 0
    img.loadAsync(l_3_0, function()
      num = num + 1
      if layer.setPercentageForProgress then
        layer.setPercentageForProgress(num / sum * 100)
      end
      if num == sum and not tolua.isnull(layer) then
        local delay = 0.01
        local endTime = os.time()
        if endTime - beginTime < 1 then
          delay = 1 - (endTime - beginTime)
        end
        schedule(layer, delay, function()
          json.loadAll(jsonList)
          if pixel_format then
            CCTexture2D:setDefaultAlphaPixelFormat(pixel_format)
          end
          onFinish()
            end)
      end
      end)
   end
  return layer
end

ui.unloadFight = function(l_2_0, l_2_1)
  local imgList = img.getLoadListForFight(l_2_0, l_2_1)
  local jsonList = json.getLoadListForFight(l_2_1)
  json.unloadAll(jsonList)
  img.unloadList(imgList)
  img.unloadAll(img.packedOthers.fightLoading)
  audio.playBackgroundMusic(audio.ui_bg)
  CCDirector:sharedDirector():getScheduler():setTimeScale(1)
end

ui.unloadFightWithParams = function(l_3_0)
  local mapId = l_3_0.mapId
  local heroIds = l_3_0.heroIds
  if not l_3_0.pets then
    local pets = {}
  end
  if not l_3_0.skins then
    local skins = {}
  end
  local imgList = img.getLoadListForFight(mapId, heroIds)
  local petImgList = img.getLoadListForPet(pets)
  local skinImgList = img.getLoadListForSkin(skins)
  local buffImgList = img.getAllBuff()
  imgList = arraymerge(imgList, petImgList)
  imgList = arraymerge(imgList, skinImgList)
  imgList = arraymerge(imgList, buffImgList)
  local jsonList = json.getLoadListForFight(heroIds)
  local petJsonList = json.getLoadListForPet(pets)
  local skinJsonList = json.getLoadListForSkin(skins)
  local buffJsonList = json.getAllBuff()
  jsonList = arraymerge(jsonList, petJsonList)
  jsonList = arraymerge(jsonList, skinJsonList)
  jsonList = arraymerge(jsonList, buffJsonList)
  json.unloadAll(jsonList)
  img.unloadList(imgList)
  img.unloadAll(img.packedOthers.fightLoading)
  audio.playBackgroundMusic(audio.ui_bg)
  CCDirector:sharedDirector():getScheduler():setTimeScale(1)
end

ui.unloadUIBeforFight = function()
  local imgList, jsonList = img.getLoadListForUI(), json.getLoadListForUI()
  json.unloadAll(jsonList)
  print("unloadList")
  img.unloadList(imgList)
end

return ui

