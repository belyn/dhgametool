-- Command line was: E:\github\dhgametool\scripts\ui\pet\scrollUI.lua 

local ui = {}
local readData = function()
end

ui.initData = function()
  ui.data = {}
  ui.widget = {}
  ui.widget.cardNodeVec = {}
  ui.widget.Scroll = nil
  ui.data.totalNum = 0
  ui.data.spacing = 0
  ui.data.canScroll = true
end

ui.create = function()
  ui.initData()
  local Scroll = CCScrollView:create()
  Scroll:setAnchorPoint(CCPoint(0.5, 0.5))
  Scroll:setDirection(kCCScrollViewDirectionHorizontal)
  Scroll:setViewSize(CCSize(800, 500))
  Scroll:setContentSize(CCSize(1640, 500))
  Scroll:setTouchEnabled(false)
  Scroll:setCascadeOpacityEnabled(true)
  Scroll:getContainer():setCascadeOpacityEnabled(true)
  local itemLayer = CCLayer:create()
  itemLayer:setContentSize(800, 400)
  itemLayer:setCascadeOpacityEnabled(true)
  Scroll:addChild(itemLayer)
  ui.widget.Scroll = Scroll
  ui.widget.itemLayer = itemLayer
  return Scroll
end

ui.addCard = function(l_4_0, l_4_1)
  local size = l_4_0.widget.qualityBox:getContentSize()
  local width = size.width * 0.8
  local height = size.height * 0.8
  ui.data.spacing = width + 25
  ui.widget.itemLayer:addChild(l_4_0.widget.node, l_4_1)
  l_4_0.widget.node:setPositionX(ui.data.totalNum * ui.data.spacing + width / 2 + 10)
  l_4_0.widget.node:setPositionY(270)
  ui.data.totalNum = ui.data.totalNum + 1
  table.insert(ui.widget.cardNodeVec, l_4_0.widget.node)
end

ui.checkCard = function()
  do
    local posX = math.abs(ui.widget.itemLayer:getPositionX())
    for k,v in pairs(ui.widget.cardNodeVec) do
      if v:getPositionX() <= posX then
        v:setVisible(false)
        for k,v in (for generator) do
        end
        v:setVisible(true)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.moveDir = function(l_6_0, l_6_1, l_6_2)
  if not l_6_2 then
    l_6_2 = 0.2
  end
  if not ui.data.canScroll then
    return 
  end
  l_6_1:setEnabled(false)
  ui.data.canScroll = false
  local posX = ui.widget.itemLayer:getPositionX()
  local posY = ui.widget.itemLayer:getPositionY()
  local move = CCMoveTo:create(l_6_2, CCPoint(posX + l_6_0 * ui.data.spacing, 0))
  local callfunc = CCCallFunc:create(function()
    btn:setEnabled(true)
    ui.data.canScroll = true
   end)
  local actArray = CCArray:create()
  actArray:addObject(move)
  actArray:addObject(callfunc)
  local sequence = CCSequence:create(actArray)
  ui.widget.itemLayer:runAction(sequence)
end

return ui

