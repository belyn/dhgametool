-- Command line was: E:\github\dhgametool\scripts\dhcomponents\tools\UICreate.lua 

local UICreate = {}
UICreater.createContainerNode = function(l_1_0, l_1_1)
  local node = cc.Node:create()
  for i,v in ipairs(l_1_0) do
    node:addChild(v.node)
  end
  node:setAnchorPoint(0.5, 0.5)
  node:setCascadeOpacityEnabled(true)
  node.updateInfo = function()
    local x = 0
    local maxHeight = 0
    for i,v in ipairs(subNodeList) do
      if v.disX then
        x = x + v.disX
      end
      v.node:setPosition(x + v.node:getContentSize().width / 2 * v.node:getScale(), 0)
      x = x + v.node:getContentSize().width * v.node:getScale()
      local height = v.node:getContentSize().height * v.node:getScale()
      if maxHeight < height then
        maxHeight = height
      end
    end
    upvalue_512 = alignType or 1
    local yList = {maxHeight / 2, 0, maxHeight}
    local anchorList = {}
     -- DECOMPILER ERROR: Overwrote pending register.

    local y = yList[cc.p(0.5, 0.5)]
     -- DECOMPILER ERROR: Overwrote pending register.

    local anchor = anchorList[cc.p(0.5, 0)]
     -- DECOMPILER ERROR: Overwrote pending register.

    for i,v in cc.p(0.5, 1)(subNodeList) do
      local disY = v.disY or 0
      v.node:setAnchorPoint(anchor)
      v.node:setPositionY(y + disY)
    end
    node:setContentSize(x, maxHeight)
   end
  node:updateInfo()
  return node
end

return UICreate

