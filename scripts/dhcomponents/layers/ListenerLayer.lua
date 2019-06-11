-- Command line was: E:\github\dhgametool\scripts\dhcomponents\layers\ListenerLayer.lua 

local nativeUpdateComponent = require("dhcomponents.NativeUpdateComponent")
local editorComponent = require("dhcomponents.EditorComponent")
local ListenerLayer = class("ListenerLayer", function()
  return cc.Layer:create()
end
)
ListenerLayer.ctor = function(l_2_0)
  l_2_0:setKeypadEnabled(true)
  l_2_0:addNodeEventListener(cc.KEYPAD_EVENT, function(l_1_0)
    local keyCode = l_1_0.key
    local isPressed = l_1_0.isPressed
    if not isPressed then
      local director = cc.Director:sharedDirector()
      if keyCode == "KEY_P" then
        if director:isPaused() then
          director:resume()
        else
          director:pause()
        end
      elseif keyCode == "KEY_F" then
        nativeUpdateComponent:restart(false)
      elseif keyCode == "KEY_R" then
        nativeUpdateComponent:restart(true)
      elseif keyCode == "KEY_M" then
        print(string.format("\231\186\185\231\144\134\228\189\191\231\148\168\230\131\133\229\134\181 "))
        CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
        print(string.format("lua\229\134\133\229\173\152\228\189\191\231\148\168\230\131\133\229\134\181: %.2f MB", collectgarbage("count") / 1024))
      elseif keyCode == "KEY_Q" or keyCode == "KEY_W" or keyCode == "KEY_E" or keyCode == "KEY_A" or keyCode == "KEY_S" or keyCode == "KEY_D" then
        editorComponent:startEditor(keyCode)
      end
      if keyCode ~= "KEY_P" and director:isPaused() then
        director:resume()
      elseif keyCode == "KEY_B" then
        editorComponent:generateNewKey(keyCode)
      end
    end
   end)
end

return ListenerLayer

