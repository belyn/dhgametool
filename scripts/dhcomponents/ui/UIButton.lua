-- Command line was: E:\github\dhgametool\scripts\dhcomponents\ui\UIButton.lua 

local schedulerUtil = require("dhcomponents.tools.SchedulerUtil")
local TAG_BUTTON_SCALE = 1032808
local UIButton = class("UIButton", function()
  return display.newNode()
end
)
UIButton.noShaderTag = 96421
UIButton.selectedBtnMap = {}
UIButton.ctor = function(l_2_0, l_2_1, l_2_2, l_2_3)
  l_2_0.images = l_2_1
  l_2_0.onClick = l_2_2
  if l_2_3 then
    l_2_0.selectedHandler = l_2_3.selectedHandler
    l_2_0.unselectedHandler = l_2_3.unselectedHandler
    l_2_0.cancelledHandler = l_2_3.cancelledHandler
    l_2_0.selectedProgram = l_2_3.selectedProgram
    l_2_0.disabledProgram = l_2_3.disabledProgram
    l_2_0.selectedScale = l_2_3.selectedScale
    l_2_0.lockDuration = l_2_3.lockDuration
  end
  if not l_2_0.selectedProgram and not l_2_0.selectedScale then
    l_2_0.selectedScale = 0.85
  end
  l_2_0.touchEnable = true
  l_2_0.pressed = false
  l_2_0.glProgramMap = {}
  l_2_0:setAnchorPoint(cc.p(0.5, 0.5))
  if l_2_0.images.normal then
    l_2_0:setContentSize(l_2_0.images.normal:getContentSize())
    l_2_0:addChild(l_2_0.images.normal)
    l_2_0.images.normal:setAnchorPoint(cc.p(0, 0))
  end
  if l_2_0.images.selected then
    l_2_0.images.selected:setVisible(false)
    l_2_0:addChild(l_2_0.images.selected)
    l_2_0.images.selected:setAnchorPoint(cc.p(0, 0))
  end
  if l_2_0.images.disabled then
    l_2_0.images.disabled:setVisible(false)
    l_2_0:addChild(l_2_0.images.disabled)
    l_2_0.images.disabled:setAnchorPoint(cc.p(0, 0))
  end
  if l_2_0.onClick then
    l_2_0:onTouch()
  end
  l_2_0:registerScriptHandler(function(l_1_0)
    if l_1_0 == "cleanup" then
      self:onCleanup()
    end
   end)
end

UIButton.onCleanup = function(l_3_0)
  UIButton.selectedBtnMap[l_3_0] = nil
end

UIButton.drawTouchRect = function(l_4_0)
  if l_4_0.drawNode then
    l_4_0.drawNode:removeFromParent()
  end
  local contentSize = l_4_0:getContentSize()
  l_4_0.drawNode = cc.DrawNode:create()
  l_4_0.drawNode:drawRect(cc.p(0, 0), cc.p(contentSize.width, 0), cc.p(contentSize.width, contentSize.height), cc.p(0, contentSize.height), cc.c4f(1, 0, 0, 1))
  l_4_0:addChild(l_4_0.drawNode)
end

UIButton.setContentSize = function(l_5_0, l_5_1)
  cc.Node.setContentSize(l_5_0, l_5_1)
end

UIButton.setInterceptEnabled = function(l_6_0, l_6_1)
  l_6_0.interceptEnabled = l_6_1
end

UIButton.setTouchHandler = function(l_7_0, l_7_1)
  l_7_0.onClick = l_7_1
  if l_7_0.onClick then
    l_7_0:onTouch()
  end
end

UIButton.onTouch = function(l_8_0)
  l_8_0.touchEnable = true
  l_8_0.pressed = false
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

UIButton.onTouchBegan = function(l_9_0, l_9_1, l_9_2)
  local point = l_9_1:getLocation()
  if not l_9_0:contains(point) or not l_9_0.touchEnable or not l_9_0:isVisible() or not l_9_0:hasVisibleParents() then
    return false
  end
  if not l_9_0:propagateTouchEvent("began", l_9_0, l_9_1, l_9_2) then
    return false
  end
  if l_9_0.onClick then
    l_9_0:selected()
    return true
  else
    return false
  end
end

UIButton.onCancelled = function(l_10_0)
  if l_10_0.cancelledHandler then
    l_10_0.cancelledHandler(l_10_0)
  end
end

UIButton.onTouchMoved = function(l_11_0, l_11_1, l_11_2)
  local point = l_11_1:getLocation()
  l_11_0:propagateTouchEvent("moved", l_11_0, l_11_1, l_11_2)
  if not l_11_0.pressed or not l_11_0.touchEnable then
    return 
  end
  if not l_11_0:contains(point) then
    l_11_0:unselected()
    l_11_0:onCancelled()
  end
end

UIButton.setLockDuration = function(l_12_0, l_12_1)
  l_12_0.lockDuration = l_12_1
end

UIButton.getLockDuration = function(l_13_0)
  return l_13_0.lockDuration or 0.1
end

UIButton.lockDelay = function(l_14_0)
  if UIButton.lockId == nil then
    UIButton.lockId = schedulerUtil:performWithDelayGlobal(function()
    schedulerUtil:unscheduleGlobal(UIButton.lockId)
    UIButton.lockId = nil
   end, l_14_0:getLockDuration())
  end
end

UIButton.isLock = function()
  return UIButton.lockId ~= nil
end

UIButton.setSoundEffect = function(l_16_0, l_16_1)
  l_16_0.soundEffectName = l_16_1
end

UIButton.setSoundWorking = function(l_17_0, l_17_1)
  l_17_0.soundWorking = l_17_1
end

UIButton.handleOperation = function(l_18_0)
end

UIButton.unselectedAll = function()
  for btn,_ in pairs(UIButton.selectedBtnMap) do
    btn:unselected()
  end
end

UIButton.handleClick = function(l_20_0)
  if UIButton.isLock() then
    return 
  end
  l_20_0:lockDelay()
  l_20_0:handleOperation()
  l_20_0.onClick(l_20_0)
  UIButton.unselectedAll()
end

UIButton.onTouchEnded = function(l_21_0, l_21_1, l_21_2)
  local point = l_21_1:getLocation()
  l_21_0:propagateTouchEvent("ended", l_21_0, l_21_1, l_21_2)
  if not l_21_0.pressed or not l_21_0.touchEnable then
    return 
  end
  l_21_0:unselected()
  if l_21_0:contains(point) and l_21_0.onClick and l_21_0:hasVisibleParents() then
    l_21_0:handleClick()
  end
end

UIButton.onTouchCancelled = function(l_22_0, l_22_1, l_22_2)
  l_22_0:unselected()
  l_22_0:onCancelled()
end

UIButton.setEnabled = function(l_23_0, l_23_1)
  if l_23_0.touchEnable ~= l_23_1 then
    l_23_0.touchEnable = l_23_1
    l_23_0:updateImagesVisibility()
    if not l_23_1 then
      l_23_0:unselected()
    end
  end
end

UIButton.isEnabled = function(l_24_0)
  return l_24_0.touchEnable
end

UIButton.setOriginGLProgram = function(l_25_0, l_25_1)
  local program = l_25_0.glProgramMap[l_25_1]
  if program then
    l_25_1:setGLProgram(program)
  end
  local childArray = l_25_1:getChildren()
  for _,child in ipairs(childArray) do
    l_25_0:setOriginGLProgram(child)
  end
end

UIButton.resetOriginGLProgram = function(l_26_0)
  l_26_0:setOriginGLProgram(l_26_0)
end

UIButton.setDisplayGLProgram = function(l_27_0, l_27_1, l_27_2)
  if l_27_0.glCascadeEnabled == nil or l_27_0.glCascadeEnabled == true then
    l_27_0:setCascadeGLProgram(l_27_0, l_27_1, l_27_2)
  else
    if l_27_0.images.normal then
      l_27_0:setCascadeGLProgram(l_27_0.images.normal, l_27_1, l_27_2)
    end
  end
end

UIButton.setCascadeGLProgram = function(l_28_0, l_28_1, l_28_2, l_28_3)
  if l_28_1 then
    if l_28_1:getTag() ~= UIButton.noShaderTag then
      if l_28_3 then
        l_28_0.glProgramMap[l_28_1] = l_28_1:getGLProgram()
      end
      l_28_1:setGLProgram(l_28_2)
    end
    local childArray = l_28_1:getChildren()
    for _,child in ipairs(childArray) do
      l_28_0:setCascadeGLProgram(child, l_28_2, l_28_3)
    end
  end
end

UIButton.setGLCascadeEnabled = function(l_29_0, l_29_1)
  l_29_0.glCascadeEnabled = l_29_1
end

UIButton.updateImagesVisibility = function(l_30_0)
  if l_30_0.touchEnable then
    if l_30_0.images.disabled then
      if l_30_0.images.normal then
        l_30_0.images.normal:setVisible(true)
      end
      if l_30_0.images.selected then
        l_30_0.images.disabled:setVisible(false)
      end
      l_30_0.images.disabled:setVisible(false)
    else
      if l_30_0.images.normal then
        l_30_0.images.normal:setVisible(true)
        l_30_0:resetOriginGLProgram()
      end
      if l_30_0.images.selected then
        l_30_0.images.disabled:setVisible(false)
      else
        if l_30_0.images.disabled then
          if l_30_0.images.normal then
            l_30_0.images.normal:setVisible(false)
          end
          if l_30_0.images.selected then
            l_30_0.images.disabled:setVisible(false)
          end
          l_30_0.images.disabled:setVisible(true)
        else
          if l_30_0.images.normal then
            l_30_0.images.normal:setVisible(true)
            if l_30_0.disabledProgram then
              l_30_0:setDisplayGLProgram(l_30_0.disabledProgram, true)
            end
          end
          if l_30_0.images.selected then
            l_30_0.images.disabled:setVisible(false)
          end
        end
      end
    end
  end
end

UIButton.setNormalImage = function(l_31_0, l_31_1)
  if l_31_1 ~= l_31_0.images.normal then
    if l_31_0.images.normal then
      l_31_0.images.normal:removeFromParent()
      l_31_0.images.normal = nil
    end
    l_31_0.images.normal = l_31_1
    if l_31_0.images.normal then
      l_31_0:setContentSize(l_31_0.images.normal:getContentSize())
      l_31_0:addChild(l_31_0.images.normal)
      l_31_0.images.normal:setAnchorPoint(cc.p(0, 0))
      l_31_0:updateImagesVisibility()
      if l_31_0.pressed then
        if l_31_0.images.selected then
          l_31_0.images.normal:setVisible(false)
        elseif l_31_0.selectedProgram then
          l_31_0:setDisplayGLProgram(l_31_0.selectedProgram, true)
        end
      end
    end
  end
end

UIButton.contains = function(l_32_0, l_32_1)
  local location = nil
  if l_32_0.backupScaleX then
    local backupScaleX = l_32_0:getScaleX()
    local backupScaleY = l_32_0:getScaleY()
    l_32_0:setScaleX(l_32_0.backupScaleX)
    l_32_0:setScaleY(l_32_0.backupScaleY)
    location = l_32_0:convertToNodeSpace(l_32_1)
    l_32_0:setScaleX(backupScaleX)
    l_32_0:setScaleY(backupScaleY)
  else
    location = l_32_0:convertToNodeSpace(l_32_1)
  end
  local contentSize = l_32_0:getContentSize()
  local rect = cc.rect(0, 0, contentSize.width, contentSize.height)
  return cc.rectContainsPoint(rect, location)
end

UIButton.isSwallowTouches = function(l_33_0)
  return true
end

UIButton.propagateTouchEvent = function(l_34_0, l_34_1, l_34_2, l_34_3, l_34_4)
  if l_34_0.interceptEnabled == false then
    return true
  end
  return l_34_0:interceptTouchEventCheck(l_34_1, l_34_2, l_34_3, l_34_4)
end

UIButton.interceptTouchEventCheck = function(l_35_0, l_35_1, l_35_2, l_35_3, l_35_4)
  do
    local parent = l_35_0:getParent()
    repeat
      if parent ~= nil then
        if parent.interceptTouchEventCheck then
          return parent:interceptTouchEventCheck(l_35_1, l_35_2, l_35_3, l_35_4)
        end
        parent = parent:getParent()
      else
        return true
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

UIButton.hasVisibleParents = function(l_36_0)
  do
    local parent = l_36_0:getParent()
    repeat
      if parent ~= nil then
        if not parent:isVisible() then
          return false
        end
        parent = parent:getParent()
      else
        return true
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

UIButton.selected = function(l_37_0)
  if l_37_0.pressed then
    return 
  end
  UIButton.selectedBtnMap[l_37_0] = true
  if l_37_0.selectedHandler then
    l_37_0.selectedHandler(l_37_0)
  end
  l_37_0.pressed = true
  if l_37_0.images.selected then
    l_37_0.images.selected:setVisible(true)
    if l_37_0.images.normal then
      l_37_0.images.normal:setVisible(false)
    elseif l_37_0.selectedProgram and l_37_0.images.normal then
      l_37_0:setDisplayGLProgram(l_37_0.selectedProgram, true)
    end
    if l_37_0.selectedScale then
      if l_37_0.backupScaleX == nil then
        l_37_0.backupScaleX = l_37_0:getScaleX()
        l_37_0.backupScaleY = l_37_0:getScaleY()
      end
      l_37_0:stopActionByTag(TAG_BUTTON_SCALE)
      local action = cc.ScaleTo:create(0.03, l_37_0.backupScaleX * l_37_0.selectedScale, l_37_0.backupScaleY * l_37_0.selectedScale)
      action:setTag(TAG_BUTTON_SCALE)
      l_37_0:runAction(action)
    end
  end
  if not l_37_0.longPressInfo.interval then
    l_37_0.longPressInfo.timeCount = not l_37_0.longPressInfo.delayTime + (not l_37_0.longPressInfo or 0)
    l_37_0:scheduleUpdate(function(l_1_0)
      local interval = self.longPressInfo.interval
      self.longPressInfo.timeCount = self.longPressInfo.timeCount + l_1_0
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if interval and interval <= self.longPressInfo.timeCount then
        self.longPressInfo.timeCount = self.longPressInfo.timeCount - interval
        self.longPressInfo.callBack(self)
        do return end
        if self.longPressInfo.timeCount >= 0 then
          self.longPressInfo.timeCount = 0
          self:unscheduleUpdate()
          self.longPressInfo.callBack(self)
        end
      end
      end)
     -- Warning: missing end command somewhere! Added here
  end
end

UIButton.unselected = function(l_38_0)
  if not l_38_0.pressed then
    return 
  end
  UIButton.selectedBtnMap[l_38_0] = nil
  if l_38_0.unselectedHandler then
    l_38_0.unselectedHandler(l_38_0)
  end
  l_38_0.pressed = false
  if l_38_0.images.selected then
    l_38_0.images.selected:setVisible(false)
    if l_38_0.images.normal then
      l_38_0.images.normal:setVisible(true)
    elseif l_38_0.selectedProgram and l_38_0.images.normal then
      l_38_0:resetOriginGLProgram()
    end
    if l_38_0.selectedScale then
      l_38_0:stopActionByTag(TAG_BUTTON_SCALE)
      local action1 = cc.ScaleTo:create(0.04, l_38_0.backupScaleX * 1.05, l_38_0.backupScaleY * 1.05)
      local action2 = cc.ScaleTo:create(0.04, 0.5 * l_38_0.backupScaleX * (l_38_0.selectedScale + 1), 0.5 * l_38_0.backupScaleY * (l_38_0.selectedScale + 1))
      local action3 = cc.ScaleTo:create(0.06, l_38_0.backupScaleX, l_38_0.backupScaleY)
      local array = CCArray:create()
      array:addObject(action1)
      array:addObject(action2)
      array:addObject(action3)
      local actionAll = cc.Sequence:create(array)
      actionAll:setTag(TAG_BUTTON_SCALE)
      l_38_0:runAction(actionAll)
    end
  end
  if l_38_0.longPressInfo and l_38_0.longPressInfo.timeCount then
    l_38_0.longPressInfo.timeCount = nil
    l_38_0:unscheduleUpdate()
  end
end

UIButton.setLongPressCallback = function(l_39_0, l_39_1, l_39_2, l_39_3)
  l_39_0.longPressInfo = {callBack = l_39_1, delayTime = l_39_2, interval = l_39_3}
end

UIButton.removeAllChildren = function(l_40_0)
  local childArray = l_40_0:getChildren()
  for _,child in ipairs(childArray) do
    if child ~= l_40_0.images.normal and child ~= l_40_0.images.selected and child ~= l_40_0.images.disabled then
      l_40_0:removeChild(child)
    end
  end
end

return UIButton

