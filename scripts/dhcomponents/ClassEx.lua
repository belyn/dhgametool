-- Command line was: E:\github\dhgametool\scripts\dhcomponents\ClassEx.lua 

local DrawNode = cc.DrawNode
DrawNode.drawSolidRect = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
   -- DECOMPILER ERROR: Unhandled construct in list

   -- DECOMPILER ERROR: Unhandled construct in table

  local points = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Unhandled construct in table

   -- DECOMPILER ERROR: Overwrote pending register.

  points = {}
   -- DECOMPILER ERROR: Unhandled construct in table

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

  {l_1_1.x, l_1_1.y}(l_1_1.x, l_1_1.x, {fillColor = l_1_3, borderColor = l_1_3, borderWidth = 1})
end

DrawNode.drawTriangle = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
  if not l_2_5 then
    l_2_5 = 1
  end
  l_2_0:drawSegment(l_2_1, l_2_2, l_2_5, l_2_4)
  l_2_0:drawSegment(l_2_2, l_2_3, l_2_5, l_2_4)
  l_2_0:drawSegment(l_2_3, l_2_1, l_2_5, l_2_4)
end

DrawNode.drawRect = function(l_3_0, l_3_1, l_3_2, l_3_3)
  radius = radius or 1
  l_3_0:drawSegment(cc.p(l_3_1.x, l_3_1.y), cc.p(l_3_1.x, l_3_2.y), radius, l_3_3)
  l_3_0:drawSegment(cc.p(l_3_1.x, l_3_2.y), cc.p(l_3_2.x, l_3_2.y), radius, l_3_3)
  l_3_0:drawSegment(cc.p(l_3_2.x, l_3_2.y), cc.p(l_3_2.x, l_3_1.y), radius, l_3_3)
  l_3_0:drawSegment(cc.p(l_3_2.x, l_3_1.y), cc.p(l_3_1.x, l_3_1.y), radius, l_3_3)
end

DrawNode.drawSolidCircle = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5)
  l_4_0:drawDot(l_4_1, l_4_2, l_4_5)
end

cc.pSub = function(l_5_0, l_5_1)
  return cc.p(l_5_0.x - l_5_1.x, l_5_0.y - l_5_1.y)
end

cc.pAdd = function(l_6_0, l_6_1)
  return cc.p(l_6_0.x + l_6_1.x, l_6_0.y + l_6_1.y)
end

cc.pToAngleSelf = function(l_7_0)
  return math.atan2(l_7_0.y, l_7_0.x)
end

cc.Label = CCLabelTTF
local Label = cc.Label
Label.createWithSystemFont = function(l_8_0, l_8_1, l_8_2, l_8_3)
  return Label:create(l_8_1, l_8_2, l_8_3)
end

Label.setTextColor = function(l_9_0, l_9_1)
  local color3b = cc.c3b(l_9_1.r, l_9_1.g, l_9_1.b)
  l_9_0:setColor(color3b)
  l_9_0:setOpacity(l_9_1.a)
end

ccui = cc
cc.EditBox = CCEditBox
local EditBox = cc.EditBox
EditBox.setFontColor4b = function(l_10_0, l_10_1)
  if l_10_1.a then
    local color3b = cc.c3b(l_10_1.r, l_10_1.g, l_10_1.b)
    l_10_0:setColor(color3b)
    l_10_0:setOpacity(l_10_1.a)
  else
    l_10_0:setFontColor(l_10_1)
  end
end

EditBox.setPlaceholderFontColor4b = function(l_11_0, l_11_1)
  if l_11_1.a then
    local color3b = cc.c3b(l_11_1.r, l_11_1.g, l_11_1.b)
    l_11_0:setColor(color3b)
    l_11_0:setOpacity(l_11_1.a)
  else
    l_11_0:setPlaceholderFontColor(l_11_1)
  end
end


