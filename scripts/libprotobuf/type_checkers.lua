-- Command line was: E:\github\dhgametool\scripts\libprotobuf\type_checkers.lua 

local type = type
local error = error
local string = string
module("type_checkers")
TypeChecker = function(l_1_0)
  local acceptable_types = l_1_0
  return function(l_1_0)
    local t = type(l_1_0)
    if acceptable_types[type(l_1_0)] == nil then
      error(string.format("%s has type %s, but expected one of: %s", l_1_0, type(l_1_0), acceptable_types))
    end
   end
end

Int32ValueChecker = function()
  local _MIN = -2147483648
  local _MAX = 2147483647
  return function(l_1_0)
    if type(l_1_0) ~= "number" then
      error(string.format("%s has type %s, but expected one of: number", l_1_0, type(l_1_0)))
    end
    if l_1_0 < _MIN or _MAX < l_1_0 then
      error("Value out of range: " .. l_1_0)
    end
   end
end

Uint32ValueChecker = function(l_3_0)
  local _MIN = 0
  local _MAX = 4294967295
  return function(l_1_0)
    if type(l_1_0) ~= "number" then
      error(string.format("%s has type %s, but expected one of: number", l_1_0, type(l_1_0)))
    end
    if l_1_0 < _MIN or _MAX < l_1_0 then
      error("Value out of range: " .. l_1_0)
    end
   end
end

UnicodeValueChecker = function()
  return function(l_1_0)
    if type(l_1_0) ~= "string" then
      error(string.format("%s has type %s, but expected one of: string", l_1_0, type(l_1_0)))
    end
   end
end


