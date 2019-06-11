-- Command line was: E:\github\dhgametool\scripts\common\view.lua 

local userdata = require("data.userdata")
local view = {}
view.logical = {w = 960, h = 576}
local winSize = CCDirector:sharedDirector():getWinSize()
view.physical = {w = winSize.width, h = winSize.height}
view.xScale = view.physical.w / view.logical.w
view.yScale = view.physical.h / view.logical.h
if view.xScale < view.yScale then
  view.minScale = view.xScale
  view.maxScale = view.yScale
else
  view.minScale = view.yScale
  view.maxScale = view.xScale
end
view.minX = (view.physical.w - view.logical.w * view.minScale) / 2
view.minY = (view.physical.h - view.logical.h * view.minScale) / 2
view.maxX = view.physical.w - view.minX
view.maxY = view.physical.h - view.minY
view.midX = (view.minX + view.maxX) / 2
view.midY = (view.minY + view.maxY) / 2
local userOffset = userdata.getInt(userdata.keys.fix_bar_offset, 0)
if view.physical.w == 2436 and view.physical.h == 1125 then
  if userOffset > 0 then
    view.safeOffset = userOffset
  else
    view.safeOffset = 92
  end
else
  if view.physical.w == 1624 and view.physical.h == 750 then
    if userOffset > 0 then
      view.safeOffset = userOffset
    else
      view.safeOffset = 92
    end
  else
    view.safeOffset = userOffset
  end
end
return view

