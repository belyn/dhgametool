-- Command line was: E:\github\dhgametool\scripts\dhcomponents\DroidhangComponents.lua 

local nativeUpdateComponent = require("dhcomponents.NativeUpdateComponent")
require("dhcomponents.ClassEx")
local DroidhangComponents = {}
DroidhangComponents.onSceneInit = function(l_1_0, l_1_1)
  if not nativeUpdateComponent:isModify() then
    return 
  end
  local listenerLayerLayer = require("dhcomponents.layers.ListenerLayer")
  local layer = listenerLayerLayer.new()
  l_1_1:addChild(layer, 10086)
end

DroidhangComponents.mandateNode = function(l_2_0, l_2_1, l_2_2, l_2_3)
  local editorComponent = require("dhcomponents.EditorComponent")
  editorComponent:mandateNode(l_2_1, l_2_2, l_2_3)
end

return DroidhangComponents

