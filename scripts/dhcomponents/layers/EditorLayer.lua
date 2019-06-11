-- Command line was: E:\github\dhgametool\scripts\dhcomponents\layers\EditorLayer.lua 

local editorComponent = require("dhcomponents.EditorComponent")
local UIHelper = require("dhcomponents.tools.UIHelper")
local EditorLayer = class("EditorLayer", function()
  return cc.Layer:create()
end
)
EditorLayer.TouchNodeWidth = 65
EditorLayer.TouchNodeHeight = 65
EditorLayer.TouchNodeMaxRadius = 45
EditorLayer.TouchNodeMinRadius = 10
EditorLayer.OptMode = {POSITION = 1, ROTATE = 2, SCALE = 3, ATTRIBUTE = 4, SETTING = 5}
EditorLayer.SelectedMode = {BOTH = 1, VERTOCAL = 2, HORIZONTAL = 3}
EditorLayer.ctor = function(l_2_0, l_2_1)
  if l_2_1 == "KEY_Q" then
    l_2_0.mode = EditorLayer.OptMode.POSITION
  elseif l_2_1 == "KEY_W" then
    l_2_0.mode = EditorLayer.OptMode.ROTATE
  elseif l_2_1 == "KEY_E" then
    l_2_0.mode = EditorLayer.OptMode.SCALE
  elseif l_2_1 == "KEY_S" then
    l_2_0.mode = EditorLayer.OptMode.ATTRIBUTE
  elseif l_2_1 == "KEY_D" then
    l_2_0.mode = EditorLayer.OptMode.SETTING
  end
  l_2_0:updateModeState()
  l_2_0.nodeInfoMap = {}
  local nodeMap = editorComponent:getAllActiveNode()
  for node,info in pairs(nodeMap) do
    l_2_0.nodeInfoMap[node] = {info = clone(info)}
  end
  l_2_0:analyzeNodeOrder(cc.Director:sharedDirector():getRunningScene(), 0)
  l_2_0:initTouch()
  l_2_0:setKeypadEnabled(true)
  l_2_0:addNodeEventListener(cc.KEYPAD_EVENT, handler(l_2_0, l_2_0.onKeypadCallback))
  l_2_0:setKeypadEnabled(true)
  l_2_0:addNodeEventListener(cc.KEYPAD_EVENT, function(l_1_0)
    if l_1_0.key == "KEY_ESC" then
      editorComponent:endEditor()
    end
   end)
  if l_2_1 == "KEY_A" then
    l_2_0:showAllNodeBoundingBox()
  end
  l_2_0:registerScriptHandler(function(l_2_0)
    if l_2_0 == "cleanup" then
      self:onCleanup()
    end
   end)
  l_2_0.keyPressedFlagMap = {}
end

EditorLayer.updateModeState = function(l_3_0)
  if l_3_0.titleLabel then
    l_3_0.titleLabel:removeFromParent()
    l_3_0.titleLabel = nil
  end
  local text = ""
  if l_3_0.mode == EditorLayer.OptMode.POSITION then
    text = "\231\167\187\229\138\168\230\168\161\229\188\143"
  else
    if l_3_0.mode == EditorLayer.OptMode.ROTATE then
      text = "\230\151\139\232\189\172\230\168\161\229\188\143"
    else
      if l_3_0.mode == EditorLayer.OptMode.SCALE then
        text = "\231\188\169\230\148\190\230\168\161\229\188\143"
      else
        if l_3_0.mode == EditorLayer.OptMode.ATTRIBUTE then
          text = "\229\177\158\230\128\167\230\168\161\229\188\143"
        else
          if l_3_0.mode == EditorLayer.OptMode.SETTING then
            text = "\232\174\190\231\189\174\230\168\161\229\188\143"
          end
        end
      end
    end
  end
  local label = CCLabelTTF:create(text, "", 32)
  label:setColor(cc.c3b(255, 20, 20))
  label:setOpacity(200)
  l_3_0:addChild(label)
  local winSize = cc.Director:sharedDirector():getWinSize()
  label:setPosition(winSize.width * 0.5, winSize.height - 60)
  l_3_0.titleLabel = label
  l_3_0:recalculationSelectedNodeCenter()
  l_3_0:showSelectedNode()
end

EditorLayer.onKeypadCallback = function(l_4_0, l_4_1)
  local keyCode = l_4_1.key
  local isPressed = l_4_1.isPressed
  if l_4_0.inTouchFlag then
    return 
  end
  if isPressed then
    l_4_0.keyPressedFlagMap[keyCode] = true
    if keyCode == "KEY_LEFT_ARROW" then
      l_4_0:onKeyboardMoved(-1, 0)
    elseif keyCode == "KEY_RIGHT_ARROW" then
      l_4_0:onKeyboardMoved(1, 0)
    elseif keyCode == "KEY_UP_ARROW" then
      l_4_0:onKeyboardMoved(0, 1)
    elseif keyCode == "KEY_DOWN_ARROW" then
      l_4_0:onKeyboardMoved(0, -1)
    else
      l_4_0.keyPressedFlagMap[keyCode] = nil
      if keyCode == "KEY_Q" then
        l_4_0.mode = EditorLayer.OptMode.POSITION
      elseif keyCode == "KEY_W" then
        l_4_0.mode = EditorLayer.OptMode.ROTATE
      elseif keyCode == "KEY_E" then
        l_4_0.mode = EditorLayer.OptMode.SCALE
      elseif keyCode == "KEY_A" then
        l_4_0:showAllNodeBoundingBox()
      elseif keyCode == "KEY_S" then
        l_4_0.mode = EditorLayer.OptMode.ATTRIBUTE
      elseif keyCode == "KEY_D" then
        l_4_0.mode = EditorLayer.OptMode.SETTING
      elseif keyCode == "KEY_Z" and l_4_0.keyPressedFlagMap.KEY_ALT then
        if l_4_0.keyPressedFlagMap.KEY_SHIFT then
          editorComponent:redoOperation()
        else
          editorComponent:undoOperation()
        end
      end
      l_4_0:updateModeState()
      if keyCode == "KEY_LEFT_ARROW" or keyCode == "KEY_RIGHT_ARROW" or keyCode == "KEY_UP_ARROW" or keyCode == "KEY_DOWN_ARROW" then
        l_4_0:syncTextState()
      end
    end
  end
end

EditorLayer.showAllNodeBoundingBox = function(l_5_0)
  if l_5_0.showAllNodeFlag then
    l_5_0.showAllNodeFlag = nil
    for node,_ in pairs(l_5_0.nodeInfoMap) do
      if node.boundingBoxdrawNode then
        node.boundingBoxdrawNode:removeFromParent()
        node.boundingBoxdrawNode = nil
      end
    end
  else
    l_5_0.showAllNodeFlag = true
    for node,_ in pairs(l_5_0.nodeInfoMap) do
      local info = l_5_0.nodeInfoMap[node]
      if info and tolua.type(node) ~= "CCLabelBMFont" then
        local contentSize = node:getContentSize()
        l_5_0:fixContentSize(contentSize)
        local width = contentSize.width
        local height = contentSize.height
        local boundingBoxdrawNode = cc.DrawNode:create()
        boundingBoxdrawNode:drawSolidRect(cc.p(0, 0), cc.p(width, height), cc.c4f(0, 1, 0, 0.4))
        node:addChild(boundingBoxdrawNode)
        node.boundingBoxdrawNode = boundingBoxdrawNode
      end
    end
  end
end

EditorLayer.analyzeNodeOrder = function(l_6_0, l_6_1, l_6_2)
  if l_6_1 then
    l_6_1:sortAllChildren()
    local children = l_6_1:getChildren()
    if not children then
      if l_6_0.nodeInfoMap[l_6_1] then
        l_6_0.nodeInfoMap[l_6_1].zorder = l_6_2
      end
      return l_6_2 + 1
    end
    local childCount = children:count()
    local i = 0
    repeat
      if i < childCount then
        local child = tolua.cast(children:objectAtIndex(i), "CCNode")
        if child:getZOrder() >= 0 then
          do return end
        end
        i = i + 1
        l_6_2 = l_6_0:analyzeNodeOrder(child, l_6_2)
      else
        if l_6_0.nodeInfoMap[l_6_1] then
          l_6_0.nodeInfoMap[l_6_1].zorder = l_6_2
        end
        l_6_2 = l_6_2 + 1
        repeat
          if i < childCount then
            local child = tolua.cast(children:objectAtIndex(i), "CCNode")
            i = i + 1
            l_6_2 = l_6_0:analyzeNodeOrder(child, l_6_2)
        end
        return l_6_2
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

EditorLayer.onCleanup = function(l_7_0)
  l_7_0:hideSelectedNode()
  if l_7_0.showAllNodeFlag then
    l_7_0:showAllNodeBoundingBox()
  end
end

EditorLayer.initTouch = function(l_8_0)
  local onTouch = function(l_1_0, l_1_1, l_1_2)
    local touch = {}
    touch.getLocation = function()
      return cc.p(x, y)
      end
    touch.getStartLocation = function()
      return self.touchStartLocation
      end
    if l_1_0 == "began" then
      self.touchStartLocation = cc.p(l_1_1, l_1_2)
      return self:onTouchBegan(touch)
    elseif l_1_0 == "moved" then
      return self:onTouchMoved(touch)
    else
      return self:onTouchEnded(touch)
    end
   end
  l_8_0:registerScriptTouchHandler(onTouch)
  l_8_0:setTouchEnabled(true)
end

EditorLayer.onTouchBegan = function(l_9_0, l_9_1, l_9_2)
  l_9_0.inTouchFlag = true
  do
    local location = l_9_1:getLocation()
    if l_9_0.selectedInfo and not l_9_0.keyPressedFlagMap.KEY_ALT then
      if l_9_0.mode == EditorLayer.OptMode.POSITION or l_9_0.mode == EditorLayer.OptMode.SCALE then
        if l_9_0.selectedInfo.touchRectVertical:containsPoint(location) then
          l_9_0.selectedMode = EditorLayer.SelectedMode.VERTOCAL
        else
          if l_9_0.selectedInfo.touchRectHorizontal:containsPoint(location) then
            l_9_0.selectedMode = EditorLayer.SelectedMode.HORIZONTAL
          else
            if l_9_0.selectedInfo.touchRect:containsPoint(location) then
              l_9_0.selectedMode = EditorLayer.SelectedMode.BOTH
            else
              if l_9_0.mode == EditorLayer.OptMode.ROTATE then
                local dist = location:getDistance(l_9_0.selectedInfo.pos)
                if dist <= EditorLayer.TouchNodeMaxRadius and EditorLayer.TouchNodeMinRadius <= dist then
                  l_9_0.selectedMode = EditorLayer.SelectedMode.BOTH
                end
              end
            end
          end
        end
      end
      return true
    end
     -- Warning: missing end command somewhere! Added here
  end
end

EditorLayer.onTouchMoved = function(l_10_0, l_10_1, l_10_2)
  local location = l_10_1:getLocation()
  local startLocation = l_10_1:getStartLocation()
  local createDrawNode = function()
    local drawNode = cc.DrawNode:create()
    drawNode:drawSolidRect(startLocation, location, cc.c4f(1, 1, 0, 0.7), 4)
    self:addChild(drawNode)
    return drawNode
   end
  if l_10_0.selectedMode then
    l_10_0:onSelectedMoved(l_10_1)
  elseif l_10_0.checkBoxInfo then
    l_10_0.checkBoxInfo.drawNode:removeFromParent()
    l_10_0.checkBoxInfo.drawNode = createDrawNode()
    l_10_0:onCheckBoxOpt(l_10_1)
  else
    if location:getDistance(startLocation) > 10 then
      l_10_0.checkBoxInfo = {drawNode = createDrawNode()}
      l_10_0:clearSelectedInfo()
    end
  end
end

EditorLayer.onTouchEnded = function(l_11_0, l_11_1, l_11_2)
  l_11_0.inTouchFlag = nil
  if l_11_0.checkBoxInfo then
    l_11_0.checkBoxInfo.drawNode:removeFromParent()
    l_11_0.checkBoxInfo = nil
    l_11_0:onCheckBoxOpt(l_11_1)
  elseif not l_11_0.selectedMode then
    local resNodeAry = {}
    if l_11_0.keyPressedFlagMap.KEY_ALT and l_11_0.selectedInfo then
      for _,info in ipairs(l_11_0.selectedInfo.nodeInfoAry) do
        table.insert(resNodeAry, info.node)
      end
    end
    l_11_0:clearSelectedInfo()
    local resNode = nil
    for node,_ in pairs(l_11_0.nodeInfoMap) do
      local info = l_11_0.nodeInfoMap[node]
      if info then
        local contentSize = node:getContentSize()
        l_11_0:fixContentSize(contentSize)
        local rect = cc.rect(0, 0, contentSize.width, contentSize.height)
        local point = node:convertToNodeSpace(l_11_1:getLocation())
        if rect:containsPoint(point) and UIHelper.hasVisibleParents(node) and (not resNode or l_11_0.nodeInfoMap[resNode].zorder < info.zorder) then
          resNode = node
        end
      end
    end
    local same = false
    for i,node in ipairs(resNodeAry) do
      if node == resNode then
        same = true
        table.remove(resNodeAry, i)
    else
      end
    end
    if not same then
      table.insert(resNodeAry, resNode)
    end
    l_11_0:onSelectedNode(resNodeAry)
    l_11_0:showSelectedNode()
  else
    l_11_0.selectedMode = nil
    l_11_0.selectedInfo.center = clone(l_11_0.selectedInfo.pos)
    for _,info in ipairs(l_11_0.selectedInfo.nodeInfoAry) do
      local node = info.node
      print("@@@ ", node, tolua.isnull(node))
      local anchorPoint = node:getAnchorPoint()
      local contentSize = node:getContentSize()
      info.pos = node:convertToWorldSpace(cc.p(contentSize.width * anchorPoint.x, contentSize.height * anchorPoint.y))
      info.angleX = node:getRotationX()
      info.angleY = node:getRotationY()
      info.scaleX = node:getScaleX()
      info.scaleY = node:getScaleY()
      l_11_0:syncNodeState(node)
    end
    local center = l_11_0.selectedInfo.center
    local width = EditorLayer.TouchNodeWidth
    local height = EditorLayer.TouchNodeHeight
    l_11_0.selectedInfo.touchRect = cc.rect(center.x - width * 0.5, center.y - height * 0.5, width, height)
    l_11_0:syncTextState()
  end
end

EditorLayer.clearSelectedInfo = function(l_12_0)
  if l_12_0.selectedInfo then
    l_12_0:hideSelectedNode()
    l_12_0.selectedInfo = nil
  end
end

EditorLayer.onCheckBoxOpt = function(l_13_0, l_13_1)
  local location = l_13_1:getLocation()
  local startLocation = l_13_1:getStartLocation()
  local minX = math.min(location.x, startLocation.x)
  local minY = math.min(location.y, startLocation.y)
  local maxX = math.max(location.x, startLocation.x)
  local maxY = math.max(location.y, startLocation.y)
  local touchRect = cc.rect(minX, minY, maxX - minX, maxY - minY)
  local resNodeAry = {}
  for node,_ in pairs(l_13_0.nodeInfoMap) do
    local info = l_13_0.nodeInfoMap[node]
    if info then
      local contentSize = node:getContentSize()
      l_13_0:fixContentSize(contentSize)
      local insideFlag = true
      local posAry = {}
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

      for _,pos in cc.p(0, 0)(cc.p(0, contentSize.height)) do
        local worldPos = node:convertToWorldSpace(pos)
        if not touchRect:containsPoint(worldPos) or not UIHelper.hasVisibleParents(node) then
          do return end
        end
      end
      if insideFlag then
        table.insert(resNodeAry, node)
      end
    end
  end
  local same = true
  if l_13_0.selectedInfo then
    if #resNodeAry == #l_13_0.selectedInfo.nodeInfoAry then
      for i,node in ipairs(resNodeAry) do
        if node ~= l_13_0.selectedInfo.nodeInfoAry[i].node then
          do return end
        end
      end
     -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  elseif not same then
    l_13_0:clearSelectedInfo()
    l_13_0:onSelectedNode(resNodeAry)
    l_13_0:showSelectedNode()
  end
   -- Warning: undefined locals caused missing assignments!
end

EditorLayer.syncNodeState = function(l_14_0, l_14_1)
  local info = l_14_0.nodeInfoMap[l_14_1].info
  local orgInfo = info.orgInfo
  info.pos = cc.p(l_14_1:getPosition())
  local angleX = l_14_1:getRotationX()
  if angleX ~= orgInfo.angleX then
    info.angleX = angleX
  end
  local angleY = l_14_1:getRotationY()
  if angleY ~= orgInfo.angleY then
    info.angleY = angleY
  end
  local scaleX = l_14_1:getScaleX()
  if scaleX ~= orgInfo.scaleX then
    info.scaleX = scaleX
  end
  local scaleY = l_14_1:getScaleY()
  if scaleY ~= orgInfo.scaleY then
    info.scaleY = scaleY
  end
  local anchor = l_14_1:getAnchorPoint()
  if anchor.x ~= orgInfo.anchor.x or anchor.y ~= orgInfo.anchor.y then
    info.anchor = anchor
    info.orgAnchor = clone(anchor)
  end
  local color = l_14_1:getColor()
  if color.r ~= orgInfo.color.r or color.g ~= orgInfo.color.g or color.b ~= orgInfo.color.b then
    info.color = color
    orgInfo.color = clone(color)
  end
  local opacity = l_14_1:getOpacity()
  if opacity ~= orgInfo.opacity then
    info.opacity = opacity
    orgInfo.opacity = opacity
  end
end

EditorLayer.syncTextState = function(l_15_0)
  for _,info in ipairs(l_15_0.selectedInfo.nodeInfoAry) do
    l_15_0:syncNodeState(info.node)
  end
  editorComponent:pushOperation(l_15_0.nodeInfoMap)
end

EditorLayer.onSelectedMoved = function(l_16_0, l_16_1)
  local location = l_16_1:getLocation()
  local startOffset = cc.pSub(l_16_1:getStartLocation(), l_16_0.selectedInfo.center)
  if l_16_0.mode == EditorLayer.OptMode.POSITION then
    location = cc.pSub(location, startOffset)
    if l_16_0.selectedMode == EditorLayer.SelectedMode.VERTOCAL then
      location.x = l_16_0.selectedInfo.center.x
    else
      if l_16_0.selectedMode == EditorLayer.SelectedMode.HORIZONTAL then
        location.y = l_16_0.selectedInfo.center.y
      end
    end
    l_16_0.selectedInfo.pos = location
    l_16_0.selectedInfo.drawNode:setPosition(location)
    local diffPos = cc.pSub(location, l_16_0.selectedInfo.center)
    for _,info in ipairs(l_16_0.selectedInfo.nodeInfoAry) do
      local node = info.node
      local pos = info.pos
      pos = cc.pAdd(pos, diffPos)
      local finalPos = node:getParent():convertToNodeSpace(pos)
      node:setPosition(finalPos)
    end
  else
    if l_16_0.mode == EditorLayer.OptMode.ROTATE then
      local diffPos = cc.pSub(location, l_16_0.selectedInfo.center)
      if diffPos.x ~= 0 or diffPos.y ~= 0 then
        local orgAngle = not cc.pToAngleSelf(startOffset) / math.pi * 180
        local curAngle = not cc.pToAngleSelf(diffPos) / math.pi * 180
        local diffAngle = curAngle - orgAngle
        for _,info in ipairs(l_16_0.selectedInfo.nodeInfoAry) do
          local node = info.node
          local angle = info.angleX
          local finalAngle = angle + diffAngle
          node:setRotation(finalAngle)
        end
      else
        location = cc.pSub(location, startOffset)
        if l_16_0.selectedMode == EditorLayer.SelectedMode.VERTOCAL then
          location.x = l_16_0.selectedInfo.center.x
        else
          if l_16_0.selectedMode == EditorLayer.SelectedMode.HORIZONTAL then
            location.y = l_16_0.selectedInfo.center.y
          end
        end
        local diffPos = cc.pSub(location, l_16_0.selectedInfo.center)
        for _,info in ipairs(l_16_0.selectedInfo.nodeInfoAry) do
          local node = info.node
          do
            if l_16_0.selectedMode == EditorLayer.SelectedMode.BOTH then
              local scale = (diffPos.x + diffPos.y) / 100
              node:setScaleX(info.scaleX + scale)
              node:setScaleY(info.scaleY + scale)
            end
            for _,info in (for generator) do
            end
            local scaleX = diffPos.x / 50
            local scaleY = diffPos.y / 50
            node:setScaleX(info.scaleX + scaleX)
            node:setScaleY(info.scaleY + scaleY)
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

EditorLayer.onKeyboardMoved = function(l_17_0, l_17_1, l_17_2)
  if not l_17_0.selectedInfo then
    return 
  end
  if l_17_0.mode == EditorLayer.OptMode.POSITION then
    for _,info in ipairs(l_17_0.selectedInfo.nodeInfoAry) do
      local node = info.node
      node:setPositionX(node:getPositionX() + l_17_1)
      node:setPositionY(node:getPositionY() + l_17_2)
      info.pos = cc.p(node:getPosition())
    end
    l_17_0.selectedInfo.pos.x = l_17_0.selectedInfo.pos.x + l_17_1
    l_17_0.selectedInfo.pos.y = l_17_0.selectedInfo.pos.y + l_17_2
    l_17_0.selectedInfo.center = clone(l_17_0.selectedInfo.pos)
  else
    if l_17_0.mode == EditorLayer.OptMode.ROTATE then
      for _,info in ipairs(l_17_0.selectedInfo.nodeInfoAry) do
        local node = info.node
        local angle = info.angleX + l_17_1 + l_17_2 * 0.1
        node:setRotation(angle)
        info.angleX = node:getRotation()
        info.angleY = node:getRotation()
      end
    else
      if l_17_0.mode == EditorLayer.OptMode.SCALE then
        for _,info in ipairs(l_17_0.selectedInfo.nodeInfoAry) do
          local node = info.node
          node:setScaleX(node:getScaleX() + l_17_1 * 0.1)
          node:setScaleY(node:getScaleY() + l_17_2 * 0.1)
          info.scaleX = node:getScaleX()
          info.scaleY = node:getScaleY()
        end
      end
    end
  end
  l_17_0:showSelectedNode()
end

EditorLayer.hideSelectedNode = function(l_18_0)
  if l_18_0.selectedInfo then
    if l_18_0.selectedInfo.drawNode then
      l_18_0.selectedInfo.drawNode:removeFromParent()
      l_18_0.selectedInfo.drawNode = nil
    end
    local nodeInfoAry = l_18_0.selectedInfo.nodeInfoAry
    for _,info in ipairs(nodeInfoAry) do
      if info.drawNode then
        info.drawNode:removeFromParent()
        info.drawNode = nil
      end
    end
  end
end

EditorLayer.fixContentSize = function(l_19_0, l_19_1)
  if l_19_1.width == 0 then
    l_19_1.width = 60
  end
  if l_19_1.height == 0 then
    l_19_1.height = 60
  end
  if l_19_1.width <= 8 and l_19_1.height <= 8 then
    l_19_1.width = 12
    l_19_1.height = 12
  end
end

EditorLayer.showSelectedNode = function(l_20_0)
  l_20_0:hideSelectedNode()
  if l_20_0.selectedInfo then
    local curPos = l_20_0.selectedInfo.pos
    l_20_0.selectedInfo.drawNodeAry = {}
    local drawNode = cc.Node:create()
    l_20_0.selectedInfo.drawNode = drawNode
    l_20_0:addChild(drawNode)
    drawNode:setPosition(curPos)
    local width = EditorLayer.TouchNodeWidth
    local height = EditorLayer.TouchNodeHeight
    l_20_0.selectedInfo.touchRect = cc.rect(curPos.x - width * 0.5, curPos.y - height * 0.5, width, height)
    if l_20_0.mode == EditorLayer.OptMode.POSITION then
      local drawNodeCenter = cc.DrawNode:create()
      drawNodeCenter:drawSolidRect(cc.p(not width * 0.5, not height * 0.5), cc.p(width * 0.5, height * 0.5), cc.c4f(1, 0, 0, 0.2))
      drawNode:addChild(drawNodeCenter)
      table.insert(l_20_0.selectedInfo.drawNodeAry, drawNodeCenter)
      local length = height + 10
      local upDrawNode = cc.DrawNode:create()
      upDrawNode:drawSolidRect(cc.p(-3, 0), cc.p(3, length), cc.c4f(1, 0, 0, 0.4))
      drawNode:addChild(upDrawNode)
      table.insert(l_20_0.selectedInfo.drawNodeAry, upDrawNode)
      local upTopDrawNode = cc.DrawNode:create()
      upTopDrawNode:drawTriangle(cc.p(-10, length), cc.p(10, length), cc.p(0, length + 10), cc.c4f(1, 0, 0, 0.4))
      drawNode:addChild(upTopDrawNode)
      table.insert(l_20_0.selectedInfo.drawNodeAry, upTopDrawNode)
      local rightDrawNode = cc.DrawNode:create()
      rightDrawNode:drawSolidRect(cc.p(0, -3), cc.p(length, 3), cc.c4f(1, 0, 0, 0.4))
      drawNode:addChild(rightDrawNode)
      table.insert(l_20_0.selectedInfo.drawNodeAry, rightDrawNode)
      local rightTopDrawNode = cc.DrawNode:create()
      rightTopDrawNode:drawTriangle(cc.p(length, -10), cc.p(length, 10), cc.p(length + 10, 0), cc.c4f(1, 0, 0, 0.4))
      drawNode:addChild(rightTopDrawNode)
      table.insert(l_20_0.selectedInfo.drawNodeAry, rightTopDrawNode)
      local basePos = l_20_0.selectedInfo.pos
      l_20_0.selectedInfo.touchRectVertical = cc.rect(basePos.x - 3, basePos.y, 6, length + 10)
      l_20_0.selectedInfo.touchRectHorizontal = cc.rect(basePos.x, basePos.y - 3, length + 10, 6)
    else
      if l_20_0.mode == EditorLayer.OptMode.ROTATE then
        local drawNodeMax = cc.DrawNode:create()
        drawNodeMax:drawSolidCircle(cc.p(0, 0), EditorLayer.TouchNodeMaxRadius, 0, 100, cc.c4f(1, 0, 0, 0.2))
        drawNode:addChild(drawNodeMax)
        table.insert(l_20_0.selectedInfo.drawNodeAry, drawNodeMax)
        local drawNodeMin = cc.DrawNode:create()
        drawNodeMin:drawSolidCircle(cc.p(0, 0), EditorLayer.TouchNodeMinRadius, 0, 100, cc.c4f(0, 0, 1, 0.2))
        drawNode:addChild(drawNodeMin)
        table.insert(l_20_0.selectedInfo.drawNodeAry, drawNodeMin)
      else
        if l_20_0.mode == EditorLayer.OptMode.SCALE then
          local drawNodeCenter = cc.DrawNode:create()
          drawNodeCenter:drawSolidRect(cc.p(not width * 0.5, not height * 0.5), cc.p(width * 0.5, height * 0.5), cc.c4f(1, 0, 1, 0.2))
          drawNode:addChild(drawNodeCenter)
          table.insert(l_20_0.selectedInfo.drawNodeAry, drawNodeCenter)
          local length = height + 10
          local upDrawNode = cc.DrawNode:create()
          upDrawNode:drawSolidRect(cc.p(-3, 0), cc.p(3, length), cc.c4f(1, 0, 1, 0.4))
          drawNode:addChild(upDrawNode)
          table.insert(l_20_0.selectedInfo.drawNodeAry, upDrawNode)
          local upTopDrawNode = cc.DrawNode:create()
          upTopDrawNode:drawTriangle(cc.p(-10, length), cc.p(10, length), cc.p(0, length + 10), cc.c4f(1, 0, 1, 0.4))
          drawNode:addChild(upTopDrawNode)
          table.insert(l_20_0.selectedInfo.drawNodeAry, upTopDrawNode)
          local rightDrawNode = cc.DrawNode:create()
          rightDrawNode:drawSolidRect(cc.p(0, -3), cc.p(length, 3), cc.c4f(1, 0, 1, 0.4))
          drawNode:addChild(rightDrawNode)
          table.insert(l_20_0.selectedInfo.drawNodeAry, rightDrawNode)
          local rightTopDrawNode = cc.DrawNode:create()
          rightTopDrawNode:drawTriangle(cc.p(length, -10), cc.p(length, 10), cc.p(length + 10, 0), cc.c4f(1, 0, 1, 0.4))
          drawNode:addChild(rightTopDrawNode)
          table.insert(l_20_0.selectedInfo.drawNodeAry, rightTopDrawNode)
          local basePos = l_20_0.selectedInfo.pos
          l_20_0.selectedInfo.touchRectVertical = cc.rect(basePos.x - 3, basePos.y, 6, length + 10)
          l_20_0.selectedInfo.touchRectHorizontal = cc.rect(basePos.x, basePos.y - 3, length + 10, 6)
        else
          if l_20_0.mode == EditorLayer.OptMode.ATTRIBUTE then
            l_20_0:showBaseAttributeNode()
          else
            if l_20_0.mode == EditorLayer.OptMode.SETTING then
              l_20_0:showSettingNode()
            end
          end
        end
      end
    end
    local nodeInfoAry = l_20_0.selectedInfo.nodeInfoAry
    for _,info in ipairs(nodeInfoAry) do
      local node = info.node
      local contentSize = node:getContentSize()
      l_20_0:fixContentSize(contentSize)
      if tolua.type(node) ~= "CCLabelBMFont" then
        local drawNode = cc.DrawNode:create()
        drawNode:drawRect(cc.p(0, 0), cc.p(contentSize.width, contentSize.height), cc.c4f(1, 0, 1, 0.3))
        node:addChild(drawNode)
        info.drawNode = drawNode
      end
    end
  end
end

EditorLayer.recalculationSelectedNodeCenter = function(l_21_0)
  if l_21_0.selectedInfo then
    local count = 0
    local center = cc.p(0, 0)
    for _,info in ipairs(l_21_0.selectedInfo.nodeInfoAry) do
      local node = info.node
      local contentSize = node:getContentSize()
      local anchorPoint = node:getAnchorPoint()
      local pos = node:convertToWorldSpace(cc.p(contentSize.width * anchorPoint.x, contentSize.height * anchorPoint.y))
      center.x = center.x + pos.x
      center.y = center.y + pos.y
      count = count + 1
      info.pos = pos
      info.angleX = node:getRotationX()
      info.angleY = node:getRotationY()
      info.scaleX = node:getScaleX()
      info.scaleY = node:getScaleY()
    end
    center.x = center.x / (count)
    center.y = center.y / (count)
    l_21_0.selectedInfo.pos = center
    l_21_0.selectedInfo.center = center
  end
end

EditorLayer.onSelectedNode = function(l_22_0, l_22_1)
  local count = #l_22_1
  if count <= 0 then
    return 
  end
  local newNodeAry = {}
  for _,selNode in ipairs(l_22_1) do
    table.insert(newNodeAry, selNode)
    local selInfo = l_22_0.nodeInfoMap[selNode]
    local selKey = selInfo.info.key
    if selInfo and selKey then
      for node,info in pairs(l_22_0.nodeInfoMap) do
        if info.info.key == selKey and node ~= selNode then
          table.insert(newNodeAry, node)
        end
      end
    end
  end
  l_22_1 = newNodeAry
  count = #l_22_1
  l_22_0.selectedInfo = {nodeInfoAry = {}}
  local center = cc.p(0, 0)
  for _,node in ipairs(l_22_1) do
    local contentSize = node:getContentSize()
    local anchorPoint = node:getAnchorPoint()
    local pos = node:convertToWorldSpace(cc.p(contentSize.width * anchorPoint.x, contentSize.height * anchorPoint.y))
    center.x = center.x + pos.x
    center.y = center.y + pos.y
    local info = {node = node, pos = pos, angleX = node:getRotationX(), angleY = node:getRotationY(), scaleX = node:getScaleX(), scaleY = node:getScaleY()}
    table.insert(l_22_0.selectedInfo.nodeInfoAry, info)
  end
  center.x = center.x / count
  center.y = center.y / count
  l_22_0.selectedInfo.pos = center
  l_22_0.selectedInfo.center = center
end

EditorLayer.showBaseAttributeNode = function(l_23_0)
  if not l_23_0.selectedInfo then
    return 
  end
  if #l_23_0.selectedInfo.nodeInfoAry <= 0 then
    return 
  end
  local EditorAttributeNode = require("dhcomponents.layers.EditorAttributeNode")
  local node = EditorAttributeNode.new(l_23_0, l_23_0.selectedInfo)
  l_23_0:addChild(node)
  l_23_0.selectedInfo.drawNode = node
end

EditorLayer.showSettingNode = function(l_24_0)
  if not l_24_0.selectedInfo then
    return 
  end
  if #l_24_0.selectedInfo.nodeInfoAry <= 0 then
    return 
  end
  local EditorAttributeNode = require("dhcomponents.layers.EditorSettingNode")
  local node = EditorAttributeNode.new(l_24_0, l_24_0.selectedInfo)
  l_24_0:addChild(node)
  l_24_0.selectedInfo.drawNode = node
end

return EditorLayer

