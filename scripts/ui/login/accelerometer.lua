-- Command line was: E:\github\dhgametool\scripts\ui\login\accelerometer.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local i18n = require("res.i18n")
ui.create = function(l_1_0)
  local enableAcc = false
  if l_1_0 and l_1_0.enableAcc then
    enableAcc = l_1_0.enableAcc
  end
  local layer = CCLayer:create()
  local json_prefix = "spinejson/ui/gyro"
  local sprites = {}
  for ii = 1, 5 do
    local anim = json.create(json_prefix .. ii .. ".json")
    anim:setPosition(CCPoint(view.midX, view.midY))
    anim:setScale(view.minScale)
    anim:playAnimation("animation", -1)
    layer:addChild(anim)
    sprites[ii] = anim
  end
  local json_snow_prefix = "spinejson/ui/winter_main_snow"
  for ii = 1, 3 do
    local anim = json.create(json_snow_prefix .. ii .. ".json")
    anim:playAnimation("animation", -1)
    sprites[1]:addChildFollowSlot("code_winter_main_snow" .. ii, anim)
  end
  local suffix = "_us"
  if isAmazon() then
    suffix = "_us"
  else
    if isOnestore() then
      suffix = "_us"
    elseif APP_CHANNEL and APP_CHANNEL ~= "" then
      suffix = "_cn"
    else
      if i18n.getCurrentLanguage() == kLanguageChinese then
        suffix = "_cn"
      else
        if i18n.getCurrentLanguage() == kLanguageChineseTW then
          suffix = "_cn"
        end
      end
    end
  end
  local slogo = CCSprite:create(string.format("LOADING/Logo%s.png", suffix))
  slogo:setPosition(scalep(250, 500))
  slogo:setScale(view.minScale)
  layer:addChild(slogo)
  autoLayoutShift(slogo, true, false, true, false)
  local spriteInitPos = {x = view.midX, y = view.midY}
  local fixPos = function(l_1_0, l_1_1, l_1_2)
    if l_1_0 < l_1_1 then
      l_1_0 = l_1_1
    elseif l_1_2 < l_1_0 then
      l_1_0 = l_1_2
    end
    return l_1_0
   end
  local posOffset = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
    l_2_4 = l_2_4 + 0.6
    if l_2_4 > 1 then
      l_2_4 = 1
    end
    local scale = view.minScale
    local pi = 3.1416
    local dx = l_2_3 * 15 * 9.81 * scale * l_2_2
    local dy = l_2_4 * 15 * 9.81 * scale * l_2_2 * 0.7
    ptNowX = l_2_1.x + dx
    ptNowY = l_2_1.y + dy
    l_2_0:setPosition(CCPoint(ptNowX, ptNowY))
   end
  local samplesx = {}
  local samplesy = {}
  local samples_count = 0
  local samples_max_count = 30
  local initSamples = function(l_3_0)
    for ii = 1, samples_max_count do
      l_3_0[ii] = 0
    end
   end
  local avgSamples = function(l_4_0)
    local sum = 0
    for ii = 1, samples_max_count do
      sum = sum + l_4_0[ii]
    end
    return (sum) / samples_max_count
   end
  initSamples(samplesx)
  initSamples(samplesy)
  local last_time = 0
  local accelerometerListener = function(l_5_0, l_5_1, l_5_2, l_5_3)
    samplesx[samples_count + 1] = l_5_0
    samplesy[samples_count + 1] = l_5_1
    upvalue_512 = samples_count + 1
    if samples_max_count <= samples_count then
      upvalue_512 = 0
    end
    l_5_0 = avgSamples(samplesx)
    l_5_1 = avgSamples(samplesy)
    posOffset(sprites[1], spriteInitPos, 0.8, l_5_0, l_5_1)
    posOffset(sprites[2], spriteInitPos, 0.6, l_5_0, l_5_1)
    posOffset(sprites[3], spriteInitPos, 0.4, l_5_0, l_5_1)
    posOffset(sprites[4], spriteInitPos, 0.3, l_5_0, l_5_1)
    posOffset(sprites[5], spriteInitPos, 0.2, l_5_0, l_5_1)
   end
  if enableAcc then
    layer:addNodeEventListener(cc.ACCELERATE_EVENT, function(l_6_0)
    if l_6_0.name == "changed" then
      accelerometerListener(l_6_0.x, l_6_0.y, l_6_0.z, l_6_0.timestamp)
    end
   end)
  end
  layer:registerScriptHandler(function(l_7_0)
    if l_7_0 == "enter" and enableAcc then
      layer:setAccelerometerInterval(0.02)
      layer:setAccelerometerEnabled(true)
      do return end
      if l_7_0 == "exit" then
        if enableAcc then
          layer:setAccelerometerEnabled(false)
        end
        for ii = 1, 5 do
          json.unload(json_prefix .. ii .. ".json")
        end
      end
    end
   end)
  return layer
end

return ui

