-- Command line was: E:\github\dhgametool\scripts\libprotobuf\containers.lua 

local setmetatable = setmetatable
local table = table
local rawset = rawset
local error = error
module("containers")
local _RCFC_meta = {add = function(l_1_0)
  local value = l_1_0._message_descriptor._concrete_class()
  local listener = l_1_0._listener
  rawset(l_1_0, #l_1_0 + 1, value)
  value:_SetListener(listener)
  if listener.dirty == false then
    listener:Modified()
  end
  return value
end
, remove = function(l_2_0, l_2_1)
  local listener = l_2_0._listener
  table.remove(l_2_0, l_2_1)
  listener:Modified()
end
, __newindex = function(l_3_0, l_3_1, l_3_2)
  error("RepeatedCompositeFieldContainer Can't set value directly")
end
}
_RCFC_meta.__index = _RCFC_meta
RepeatedCompositeFieldContainer = function(l_4_0, l_4_1)
  local o = {_listener = l_4_0, _message_descriptor = l_4_1}
  return setmetatable(o, _RCFC_meta)
end

local _RSFC_meta = {append = function(l_5_0, l_5_1)
  l_5_0._type_checker(l_5_1)
  rawset(l_5_0, #l_5_0 + 1, l_5_1)
  l_5_0._listener:Modified()
end
, remove = function(l_6_0, l_6_1)
  table.remove(l_6_0, l_6_1)
  l_6_0._listener:Modified()
end
, __newindex = function(l_7_0, l_7_1, l_7_2)
  error("RepeatedCompositeFieldContainer Can't set value directly")
end
}
_RSFC_meta.__index = _RSFC_meta
RepeatedScalarFieldContainer = function(l_8_0, l_8_1)
  local o = {}
  o._listener = l_8_0
  o._type_checker = l_8_1
  return setmetatable(o, _RSFC_meta)
end


