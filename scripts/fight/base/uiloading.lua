-- Command line was: E:\github\dhgametool\scripts\fight\base\uiloading.lua 

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
  local tipsIndex = math.random(#i18n.loadingtips)
  layer.setHint(i18n.loadingtips[tipsIndex].tips)
  layer.startLoading = function(l_1_0, l_1_1, l_1_2)
    schedule(layer, function()
      local imgList, jsonList = img.getLoadListForUI(), json.getLoadListForUI()
      layer.loadFight(imgList, jsonList, onFinish)
      end)
   end
  local beginTime = os.time()
  layer.loadFight = function(l_2_0, l_2_1, l_2_2)
    local sum, num = #l_2_0, 0
    img.loadAsync(l_2_0, function()
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

ui.unloadUIBeforFight = function()
  local imgList, jsonList = img.getLoadListForUI(), json.getLoadListForUI()
  json.unloadAll(jsonList)
  img.unloadList(imgList)
end

return ui

