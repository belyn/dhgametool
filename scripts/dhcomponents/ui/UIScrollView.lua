-- Command line was: E:\github\dhgametool\scripts\dhcomponents\ui\UIScrollView.lua 

local UIScrollView = class("UIScrollView", function()
  local scroll = cc.ScrollView:create()
  scroll._onTouchBegan = scroll.onTouchBegan
  scroll._onTouchMoved = scroll.onTouchMoved
  scroll._onTouchEnded = scroll.onTouchEnded
  scroll._onTouchCancelled = scroll.onTouchCancelled
  return scroll
end
)
cc.SCROLLVIEW_DIRECTION_NONE = -1
cc.SCROLLVIEW_DIRECTION_HORIZONTAL = 0
cc.SCROLLVIEW_DIRECTION_VERTICAL = 1
cc.SCROLLVIEW_DIRECTION_BOTH = 2
UIScrollView.create = function(l_2_0)
  local scroll = UIScrollView.new(l_2_0)
  return scroll
end

UIScrollView.ctor = function(l_3_0, l_3_1)
  if not l_3_1 then
    l_3_1 = {}
  end
  if l_3_1.container then
    l_3_0:setContainer(l_3_1.container)
  end
  if not l_3_1.viewSize then
    l_3_0:setViewSize(cc.size(0, 0))
  end
  if not l_3_1.contentSize and not l_3_1.viewSize then
    l_3_0:setContentSize(cc.size(0, 0))
  end
  l_3_0:setContentOffset(cc.p(0, 0))
  if not l_3_1.direction then
    l_3_0:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
  end
  l_3_0:setClippingToBounds(l_3_1.clipping == nil and true or false)
  l_3_0:setBounceable(l_3_1.bounceable == nil and true or false)
  l_3_0:setDelegate()
  l_3_0:setTouchEnabled(false)
  l_3_0.moveCallback = l_3_1.moveCallback
  local listener = cc.EventListenerTouchOneByOne:create()
  listener:setSwallowTouches(true)
  listener:registerScriptHandler(handler(l_3_0, l_3_0.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
  listener:registerScriptHandler(handler(l_3_0, l_3_0.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
  listener:registerScriptHandler(handler(l_3_0, l_3_0.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
  listener:registerScriptHandler(handler(l_3_0, l_3_0.onTouchCancelled), cc.Handler.EVENT_TOUCH_CANCELLED)
  local eventDispatcher = l_3_0:getEventDispatcher()
  eventDispatcher:addEventListenerWithSceneGraphPriority(listener, l_3_0)
  l_3_0.touchEnable = true
  local lockListener = cc.EventListenerCustom:create("dh_lock_ui", function(l_1_0)
    self:setEnabled(false)
   end)
  eventDispatcher:addEventListenerWithSceneGraphPriority(lockListener, l_3_0)
end

UIScrollView.setEnabled = function(l_4_0, l_4_1)
  if l_4_1 ~= l_4_0.touchEnable then
    l_4_0.touchEnable = l_4_1
  end
end

UIScrollView.isEnabled = function(l_5_0)
  return l_5_0.touchEnable
end

UIScrollView.interceptTouchEventCheck = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  local touchPoint = l_6_3:getLocation()
  if not l_6_0:isVisible() or not l_6_0:hasVisibleParents() then
    return false
  end
  if l_6_1 == "began" then
    local touchIn = l_6_0:_onTouchBegan(l_6_3, l_6_4)
    if touchIn then
      l_6_0.isGetIntercept = true
    end
    return touchIn
  elseif l_6_1 == "moved" and l_6_0:isEnabled() then
    local startPoint = l_6_3:getStartLocation()
    do
      local offset = cc.pGetDistance(startPoint, touchPoint)
      if l_6_0.moveCallback and UIScrollView.getChildFocusCancelOffset() < offset then
        l_6_0.moveCallback()
      end
      if UIScrollView.getChildFocusCancelOffset() < offset then
        l_6_0:_onTouchMoved(l_6_3, l_6_4)
        l_6_2:unselected()
      end
      do return end
      if l_6_1 == "ended" then
        l_6_0:_onTouchEnded(l_6_3, l_6_4)
        if l_6_2:isSwallowTouches() then
          l_6_0.isGetIntercept = false
        end
      end
    end
  end
end

UIScrollView.onTouchBegan = function(l_7_0, l_7_1, l_7_2)
  if not l_7_0.isGetIntercept and l_7_0:isEnabled() then
    local ret = l_7_0:_onTouchBegan(l_7_1, l_7_2)
    return ret
  end
  return false
end

UIScrollView.onTouchMoved = function(l_8_0, l_8_1, l_8_2)
  if not l_8_0.isGetIntercept and l_8_0:isEnabled() then
    l_8_0:_onTouchMoved(l_8_1, l_8_2)
  end
end

UIScrollView.onTouchEnded = function(l_9_0, l_9_1, l_9_2)
  if not l_9_0.isGetIntercept and l_9_0:isEnabled() then
    l_9_0:_onTouchEnded(l_9_1, l_9_2)
  end
  l_9_0.isGetIntercept = false
end

UIScrollView.onTouchCancelled = function(l_10_0, l_10_1, l_10_2)
  if not l_10_0.isGetIntercept and l_10_0:isEnabled() then
    l_10_0:_onTouchCancelled(l_10_1, l_10_2)
  end
  l_10_0.isGetIntercept = false
end

UIScrollView.hasVisibleParents = function(l_11_0)
  do
    local parent = l_11_0:getParent()
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

UIScrollView.getChildFocusCancelOffset = function()
  return 15
end

return UIScrollView

