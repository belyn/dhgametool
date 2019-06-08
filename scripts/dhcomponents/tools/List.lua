-- Command line was: E:\github\dhgametool\scripts\dhcomponents\tools\List.lua 

local ListNode = class("ListNode")
ListNode.ctor = function(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0.value = l_1_1
  l_1_0.next = l_1_2
  l_1_0.prev = l_1_3
end

ListNode.getNext = function(l_2_0)
  return l_2_0.next
end

ListNode.getPrev = function(l_3_0)
  return l_3_0.prev
end

ListNode.getValue = function(l_4_0)
  return l_4_0.value
end

ListNode.insert = function(l_5_0, l_5_1)
  local newNode = ListNode.new(l_5_1, l_5_0, l_5_0.prev)
  l_5_0.prev.next = newNode
  l_5_0.prev = newNode
  return newNode
end

local List = class("List")
List.ctor = function(l_6_0)
  l_6_0.node = ListNode.new()
  l_6_0.node.next = l_6_0.node
  l_6_0.node.prev = l_6_0.node
  l_6_0.length = 0
end

List.getBegin = function(l_7_0)
  return l_7_0.node.next
end

List.getEnd = function(l_8_0)
  return l_8_0.node
end

List.insert = function(l_9_0, l_9_1, l_9_2)
  ListNode.insert(l_9_1, l_9_2)
  l_9_0.length = l_9_0.length + 1
end

List.pushFront = function(l_10_0, l_10_1)
  l_10_0:insert(l_10_0.node.next, l_10_1)
end

List.pushBack = function(l_11_0, l_11_1)
  l_11_0:insert(l_11_0.node, l_11_1)
end

List.popFront = function(l_12_0)
  l_12_0:erase(l_12_0.node.next)
end

List.popBack = function(l_13_0)
  l_13_0:erase(l_13_0.node.prev)
end

List.erase = function(l_14_0, l_14_1)
  l_14_1.prev.next = l_14_1.next
  l_14_1.next.prev = l_14_1.prev
  local nextNode = l_14_1.next
  l_14_1.value = nil
  l_14_1 = nil
  l_14_0.length = math.max(l_14_0.length - 1, 0)
  return nextNode
end

List.empty = function(l_15_0)
  return l_15_0.node.next == l_15_0.node
end

List.front = function(l_16_0)
  return l_16_0.node.next.value
end

List.back = function(l_17_0)
  return l_17_0.node.prev.value
end

List.copy = function(l_18_0)
  local newList = List.new()
  do
    local iter = l_18_0:getBegin()
    repeat
      if iter ~= l_18_0:getEnd() then
        newList:pushBack(iter:getValue())
        iter = iter:getNext()
      else
        return newList
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

List.clear = function(l_19_0)
  l_19_0.node.next = l_19_0.node
  l_19_0.node.prev = l_19_0.node
  l_19_0.length = 0
end

List.size = function(l_20_0)
  return l_20_0.length
end

return List

