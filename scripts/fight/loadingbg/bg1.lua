-- Command line was: E:\github\dhgametool\scripts\fight\loadingbg\bg1.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local lbl = require("res.lbl")
local audio = require("res.audio")
local i18n = require("res.i18n")
ui.create = function()
  local layer = CCLayer:create()
  local bg = img.createLoadingPng("loading3")
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
  local progressBg = img.createUISprite(img.ui.fight_load_bar_bg)
  progressBg:setScale(view.minScale)
  progressBg:setPosition(scalep(480, 129))
  layer:addChild(progressBg)
  local progress0 = img.createUISprite(img.ui.fight_load_bar_fg)
  local progress = createProgressBar(progress0)
  progress:setScale(view.minScale)
  progress:setPosition(progressBg:getPosition())
  layer:addChild(progress)
  local light = img.createUISprite(img.ui.fight_load_bar_light)
  light:setScale(view.minScale)
  light:setAnchorPoint(ccp(1, 0.5))
  light:setPositionY(progress:getPositionY())
  light:setVisible(false)
  layer:addChild(light)
  local label = lbl.createFont2(17, "", lbl.whiteColor, true)
  label:setPosition(progress:getPositionX(), progress:getPositionY() + 7 * view.minScale)
  layer:addChild(label)
  layer.setPercentageForProgress = function(l_1_0)
    progress:setPercentage(l_1_0)
    label:setString(math.floor(l_1_0) .. "%")
    local rect = progress:boundingBox()
    light:setVisible(l_1_0 > 10 and l_1_0 < 95)
    light:setPositionX(rect:getMinX() + rect.size.width * l_1_0 / 100)
   end
  local hint = lbl.createMix({font = 2, size = 17, text = "", color = lbl.whiteColor, minScale = true, width = 800, align = kCCTextAlignmentCenter})
  hint:setPosition(view.midX, scaley(43))
  layer:addChild(hint)
  layer.setHint = function(l_2_0)
    if not tolua.isnull(hint) then
      hint:setString(l_2_0)
    end
   end
  img.unloadLoadingPng("loading3")
  return layer
end

return ui

