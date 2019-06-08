-- Command line was: E:\github\dhgametool\scripts\ui\activity\ban.lua 

local ui = {}
require("common.const")
require("common.func")
ui.addBan = function(l_1_0, l_1_1, l_1_2)
  local ban = CCLayer:create()
  l_1_0:addChild(ban, 1000, 101)
  ban:setTouchEnabled(true)
  ban:registerScriptTouchHandler(function(l_1_0, l_1_1, l_1_2)
    if l_1_0 == "began" then
      local pscroll = layer:getParent():getParent().scroll
      local p0 = pscroll:getParent():convertToNodeSpace(ccp(l_1_1, l_1_2))
      local p1 = (scroll:getParent():convertToNodeSpace(ccp(l_1_1, l_1_2)))
      local p2 = nil
      if board then
        p2 = board:getParent():convertToNodeSpace(ccp(l_1_1, l_1_2))
      end
      if pscroll:boundingBox():containsPoint(p0) or scroll:boundingBox():containsPoint(p1) or board and board:boundingBox():containsPoint(p2) then
        ban:setTouchSwallowEnabled(false)
      else
        ban:setTouchSwallowEnabled(true)
      end
      return true
    end
   end)
end

return ui

