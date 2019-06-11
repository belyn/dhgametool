-- Command line was: E:\github\dhgametool\scripts\libprotobuf\listener.lua 

local setmetatable = setmetatable
module("listener")
local _null_listener = {Modified = function()
end
}
NullMessageListener = function()
  return _null_listener
end

local _listener_meta = {Modified = function(l_3_0)
  if l_3_0.dirty then
    return 
  end
  if l_3_0._parent_message then
    l_3_0._parent_message:_Modified()
  end
end
}
_listener_meta.__index = _listener_meta
Listener = function(l_4_0)
  local o = {}
  o.__mode = "v"
  o._parent_message = l_4_0
  o.dirty = false
  return setmetatable(o, _listener_meta)
end


