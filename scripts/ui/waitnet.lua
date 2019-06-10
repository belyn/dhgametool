-- Command line was: E:\github\dhgametool\scripts\ui\waitnet.lua 

local waitnet = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local particle = require("res.particle")
waitnet.create = function(l_1_0, l_1_1)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  darkbg:setVisible(false)
  layer:addChild(darkbg)
  local startTime = os.time()
  local timeout = l_1_1 or NET_TIMEOUT
  layer.setTimeout = function(l_1_0)
    timeout = l_1_0
   end
  json.load(json.ui.lag_loading)
  local icon = DHSkeletonAnimation:createWithKey(json.ui.lag_loading)
  icon:setScale(view.minScale)
  icon:scheduleUpdateLua()
  icon:playAnimation("animation", -1)
  icon:setPosition(view.physical.w / 2, view.physical.h / 2)
  icon:setVisible(false)
  layer:addChild(icon)
  local picon = particle.create("lag_loading")
  picon:setScale(view.minScale)
  picon:setPosition(view.physical.w / 2, view.physical.h / 2)
  picon:setVisible(false)
  layer:addChild(picon)
  local arr = CCArray:create()
  arr:addObject(CCDelayTime:create(1))
  arr:addObject(CCCallFunc:create(function()
    darkbg:setVisible(true)
    icon:setVisible(true)
    picon:setVisible(true)
   end))
  layer:runAction(CCSequence:create(arr))
  layer:scheduleUpdateWithPriorityLua(function()
    local now = os.time()
    if timeout < now - startTime then
      layer:removeFromParent()
      if onTimeout then
        onTimeout()
      else
        popReconnectDialog()
      end
    end
   end, 0)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return waitnet

