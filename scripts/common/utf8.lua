-- Command line was: E:\github\dhgametool\scripts\common\utf8.lua 

local utf8 = {}
local FIRST_BYTE_MARK = {0, 192, 224, 240, 248, 252}
utf8.char = function(l_1_0, l_1_1)
  if not l_1_1 then
    l_1_1 = 1
  end
  local byte = string.byte(l_1_0, l_1_1)
  for i =  FIRST_BYTE_MARK, 1, -1 do
    if FIRST_BYTE_MARK[i] <= byte then
      return string.sub(l_1_0, l_1_1, l_1_1 + i - 1)
    end
  end
  return nil
end

utf8.chars = function(l_2_0)
  local chars = {}
  do
    local i = 1
    repeat
      if i <=  l_2_0 then
        local char = utf8.char(l_2_0, i)
        if char == nil then
          return nil
        end
        table.insert(chars, char)
        if i +  char - 1 ==  l_2_0 then
          return chars
        end
        i = i +  char
      else
        return nil
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

utf8.len = function(l_3_0)
  local chars = utf8.chars(l_3_0)
  if chars ~= nil then
    return  chars
  end
  return nil
end

utf8.char2codepoint = function(l_4_0)
  local b1 = string.byte(l_4_0, 1)
  if b1 <= 127 then
    return msB
  elseif b1 >= 192 and b1 <= 223 then
    local b2 = string.byte(l_4_0, 2)
    assert(b2 >= 128)
    return (b1 - 192) * 64 + b2
  elseif b1 >= 224 and b1 <= 239 then
    local b2, b3 = string.byte(l_4_0, 2, 3)
    assert(b2 >= 128 and b3 >= 128)
    return (b1 - 224) * 4096 + b2 % 64 * 64 + b3 % 64
  elseif b1 >= 240 and b1 <= 247 then
    local b2, b3, b4 = string.byte(l_4_0, 2, 4)
    assert(b2 >= 128 and b3 >= 128 and b4 >= 128)
    return (b1 - 240) * 262144 + b2 % 64 * 4096 + b3 % 64 * 64 + b4 % 64
  end
  return nil
end

utf8.codepoint2char = function(l_5_0)
  if l_5_0 <= 127 then
    return string.char(l_5_0)
  elseif l_5_0 <= 2047 then
    return string.char(192 + math.floor(l_5_0 / 64), 128 + l_5_0 % 64)
  elseif l_5_0 <= 65535 then
    return string.char(224 + math.floor(l_5_0 / 4096), 128 + math.floor(l_5_0 / 64) % 64, 128 + l_5_0 % 64)
  elseif l_5_0 <= 2097151 then
    return string.char(240 + math.floor(l_5_0 / 262144), 128 + math.floor(l_5_0 / 4096) % 64, 128 + math.floor(l_5_0 / 64) % 64, 128 + l_5_0 % 64)
  end
  return nil
end

utf8.isEmoji = function(l_6_0)
  local code = utf8.char2codepoint(l_6_0)
  if (code >= 128640 and code <= 128767) or code >= 127456 and code <= 127487 then
    return true
  end
  return false
end

return utf8

