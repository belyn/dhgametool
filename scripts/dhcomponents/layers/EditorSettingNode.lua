-- Command line was: scripts\dhcomponents\layers\EditorSettingNode.lua 

local UIButton = require("dhcomponents.ui.UIButton")
local EditorAttributeNode = require("dhcomponents.layers.EditorAttributeNode")
local EditorSettingNode = class("EditorSettingNode", EditorAttributeNode)
EditorSettingNode.ctor = function(l_1_0, l_1_1, l_1_2)
  EditorSettingNode.super.ctor(l_1_0, l_1_1, l_1_2)
end

EditorSettingNode.initUI = function(l_2_0)
  local width = 290
  local height = 200
  local container = l_2_0
  container:setContentSize(cc.size(width, height))
  local nodeInfoAry = l_2_0.selectedInfo.nodeInfoAry
  local specifyNode = nil
  if  l_2_0.selectedInfo.nodeInfoAry == 1 then
    specifyNode = nodeInfoAry[1].node
  end
  l_2_0:fixBaseAttributeNodePos(true)
  local drawNodeBg = cc.DrawNode:create()
  drawNodeBg:drawSolidRect(cc.p(not width * 0.5, not height * 0.5), cc.p(width * 0.5, height * 0.5), cc.c4f(0.7, 0.7, 0.7, 0.99))
  drawNodeBg:setPosition(width * 0.5, height * 0.5)
  container:addChild(drawNodeBg)
  local posXNameLabel = cc.Label:createWithSystemFont("positionX", "", 14)
  posXNameLabel:setAnchorPoint(cc.p(0, 0.5))
  posXNameLabel:setPosition(10, height - 20)
  posXNameLabel:setTextColor(cc.c4b(0, 0, 0, 255))
  container:addChild(posXNameLabel)
  local posXJustifyLeftBtnDrawNode = cc.DrawNode:create()
  posXJustifyLeftBtnDrawNode:drawSolidRect(cc.p(0, 0), cc.p(20, 20), cc.c4f(0.3, 0.7, 0.8, 1))
  posXJustifyLeftBtnDrawNode:setContentSize(cc.size(20, 20))
  local posXJustifyLeftBtn = UIButton.new({normal = posXJustifyLeftBtnDrawNode}, function(...)
    for _,info in ipairs(nodeInfoAry) do
       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused at declaration of local variable

      .node:setPositionX(0)
       -- DECOMPILER ERROR: Confused about usage of registers!

      self:syncNodeState(.node)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
    self:syncTextState()
    self:fixBaseAttributeNodePos()
   end)
  posXJustifyLeftBtn:setPosition(100, height - 20)
  container:addChild(posXJustifyLeftBtn)
  local posXJustifyMidBtnDrawNode = cc.DrawNode:create()
  posXJustifyMidBtnDrawNode:drawSolidRect(cc.p(0, 0), cc.p(20, 20), cc.c4f(0.3, 0.7, 0.8, 1))
  posXJustifyMidBtnDrawNode:setContentSize(cc.size(20, 20))
  local posXJustifyMidBtn = UIButton.new({normal = posXJustifyMidBtnDrawNode}, function(...)
    for _,info in ipairs(nodeInfoAry) do
       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused about usage of registers!

      .node:setPositionX(.node:getParent():getContentSize().width * 0.5)
       -- DECOMPILER ERROR: Confused about usage of registers!

      self:syncNodeState(.node)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
    self:syncTextState()
    self:fixBaseAttributeNodePos()
   end)
  posXJustifyMidBtn:setPosition(150, height - 20)
  container:addChild(posXJustifyMidBtn)
  local posXJustifyRightBtnDrawNode = cc.DrawNode:create()
  posXJustifyRightBtnDrawNode:drawSolidRect(cc.p(0, 0), cc.p(20, 20), cc.c4f(0.3, 0.7, 0.8, 1))
  posXJustifyRightBtnDrawNode:setContentSize(cc.size(20, 20))
  local posXJustifyRightBtn = UIButton.new({normal = posXJustifyRightBtnDrawNode}, function(...)
    for _,info in ipairs(nodeInfoAry) do
       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused about usage of registers!

      .node:setPositionX(.node:getParent():getContentSize().width)
       -- DECOMPILER ERROR: Confused about usage of registers!

      self:syncNodeState(.node)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
    self:syncTextState()
    self:fixBaseAttributeNodePos()
   end)
  posXJustifyRightBtn:setPosition(200, height - 20)
  container:addChild(posXJustifyRightBtn)
  local posYNameLabel = cc.Label:createWithSystemFont("positionY", "", 14)
  posYNameLabel:setAnchorPoint(cc.p(0, 0.5))
  posYNameLabel:setPosition(10, height - 60)
  posYNameLabel:setTextColor(cc.c4b(0, 0, 0, 255))
  container:addChild(posYNameLabel)
  local posYJustifyLeftBtnDrawNode = cc.DrawNode:create()
  posYJustifyLeftBtnDrawNode:drawSolidRect(cc.p(0, 0), cc.p(20, 20), cc.c4f(0.3, 0.7, 0.8, 1))
  posYJustifyLeftBtnDrawNode:setContentSize(cc.size(20, 20))
  local posYJustifyLeftBtn = UIButton.new({normal = posYJustifyLeftBtnDrawNode}, function(...)
    for _,info in ipairs(nodeInfoAry) do
       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused at declaration of local variable

      .node:setPositionY(0)
       -- DECOMPILER ERROR: Confused about usage of registers!

      self:syncNodeState(.node)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
    self:syncTextState()
    self:fixBaseAttributeNodePos()
   end)
  posYJustifyLeftBtn:setPosition(100, height - 60)
  container:addChild(posYJustifyLeftBtn)
  local posYJustifyMidBtnDrawNode = cc.DrawNode:create()
  posYJustifyMidBtnDrawNode:drawSolidRect(cc.p(0, 0), cc.p(20, 20), cc.c4f(0.3, 0.7, 0.8, 1))
  posYJustifyMidBtnDrawNode:setContentSize(cc.size(20, 20))
  local posYJustifyMidBtn = UIButton.new({normal = posYJustifyMidBtnDrawNode}, function(...)
    for _,info in ipairs(nodeInfoAry) do
       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused about usage of registers!

      .node:setPositionY(.node:getParent():getContentSize().height * 0.5)
       -- DECOMPILER ERROR: Confused about usage of registers!

      self:syncNodeState(.node)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
    self:syncTextState()
    self:fixBaseAttributeNodePos()
   end)
  posYJustifyMidBtn:setPosition(150, height - 60)
  container:addChild(posYJustifyMidBtn)
  local posYJustifyRightBtnDrawNode = cc.DrawNode:create()
  posYJustifyRightBtnDrawNode:drawSolidRect(cc.p(0, 0), cc.p(20, 20), cc.c4f(0.3, 0.7, 0.8, 1))
  posYJustifyRightBtnDrawNode:setContentSize(cc.size(20, 20))
  local posYJustifyRightBtn = UIButton.new({normal = posYJustifyRightBtnDrawNode}, function(...)
    for _,info in ipairs(nodeInfoAry) do
       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused about usage of registers!

      .node:setPositionY(.node:getParent():getContentSize().height)
       -- DECOMPILER ERROR: Confused about usage of registers!

      self:syncNodeState(.node)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
    self:syncTextState()
    self:fixBaseAttributeNodePos()
   end)
  posYJustifyRightBtn:setPosition(200, height - 60)
  container:addChild(posYJustifyRightBtn)
end

return EditorSettingNode

