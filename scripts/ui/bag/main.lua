-- Command line was: E:\github\dhgametool\scripts\ui\bag\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
ui.create = function(l_1_0, l_1_1)
  local layer = CCLayer:create()
  local bg = img.createUISprite(img.ui.bag_bg)
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
  local mainui = require("ui.bag.mainui")
  layer:addChild(mainui.create(l_1_0, l_1_1), 100)
  require("ui.tutorial").show("ui.bag.main", layer)
  return layer
end

return ui

