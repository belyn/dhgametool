-- Command line was: E:\github\dhgametool\scripts\ui\lineScroll.lua 

local lineScroll = {}
lineScroll.TAG_CONTENT_LAYER = 1117
lineScroll.create = function(l_1_0)
  local scroll_w = l_1_0.width or 0
  local scroll_h = l_1_0.height or 0
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setViewSize(CCSize(scroll_w, scroll_h))
  scroll:setContentSize(CCSize(scroll_w, scroll_h))
  scroll.height = scroll_h
  scroll.width = scroll_w
  scroll.cur_height = 0
  local content_layer = CCLayer:create()
  content_layer:setAnchorPoint(CCPoint(0, 1))
  content_layer:setPosition(CCPoint(0, scroll_h))
  scroll:getContainer():addChild(content_layer, 1, lineScroll.TAG_CONTENT_LAYER)
  scroll.content_layer = content_layer
  local allItems = {}
  scroll.addItem = function(l_1_0)
    l_1_0.ax = l_1_0.ax or 0
    l_1_0.ay = l_1_0.ay or 0
    l_1_0.px = l_1_0.px or 0
    local cur_height = scroll.cur_height or 0
    local obj_height = l_1_0.height
    if not obj_height then
      obj_height = l_1_0:getContentSize().height
    end
    local cur_height = cur_height + obj_height
    l_1_0:setAnchorPoint(CCPoint(l_1_0.ax, l_1_0.ay))
    if l_1_0.ay == 0.5 then
      l_1_0:setPosition(CCPoint(l_1_0.px, 0 - cur_height + obj_height / 2))
    else
      l_1_0:setPosition(CCPoint(l_1_0.px, 0 - cur_height))
    end
    scroll.content_layer:addChild(l_1_0)
    allItems[ allItems + 1] = l_1_0
    scroll.cur_height = cur_height
    if scroll.height < cur_height then
      scroll:setContentSize(CCSizeMake(scroll.width, cur_height))
      scroll.content_layer:setPosition(CCPoint(0, cur_height))
    else
      scroll:setContentSize(CCSizeMake(scroll.width, scroll.height))
      scroll.content_layer:setPosition(CCPoint(0, scroll.height))
    end
   end
  scroll.validUI = function(l_2_0, l_2_1)
    local findItem = nil
    for ii = 1,  allItems do
      if findItem then
        allItems[ii]:setPositionY(allItems[ii]:getPositionY() - l_2_1)
      end
      if allItems[ii] == l_2_0 then
        findItem = true
      end
    end
    scroll.cur_height = scroll.cur_height + l_2_1
    scroll.addSpace(0)
   end
  scroll.addSpace = function(l_3_0)
    local cur_height = scroll.cur_height or 0
    cur_height = cur_height + l_3_0
    if scroll.height < cur_height then
      scroll:setContentSize(CCSizeMake(scroll.width, cur_height))
      scroll.content_layer:setPosition(CCPoint(0, cur_height))
    else
      scroll:setContentSize(CCSizeMake(scroll.width, scroll.height))
      scroll.content_layer:setPosition(CCPoint(0, scroll.height))
    end
    scroll.cur_height = cur_height
   end
  scroll.setOffset = function(l_4_0)
    local cur_height = scroll.cur_height or 0
    if l_4_0 == "begin" then
      if scroll.height < cur_height then
        scroll:setContentOffset(CCPoint(0, scroll.height - cur_height))
      else
        scroll:setContentOffset(CCPoint(0, 0))
      end
    elseif l_4_0 == "end" then
      scroll:setContentOffset(CCPoint(0, 0))
    end
   end
  scroll.setOffsetBegin = function()
    scroll.setOffset("begin")
   end
  scroll.setOffsetEnd = function()
    scroll.setOffset("end")
   end
  scroll.updateOffsetEnd = function(l_7_0)
    local offset_y = scroll:getContentOffset().y
    if offset_y > 0 then
      scroll.setOffsetBegin()
    elseif offset_y > -10 then
      scroll.setOffsetEnd()
    end
   end
  return scroll
end

return lineScroll

