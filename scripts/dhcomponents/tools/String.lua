-- Command line was: E:\github\dhgametool\scripts\dhcomponents\tools\String.lua 

local String = {}
String.getGrowthString = function(l_1_0, l_1_1)
  local eps = 0.0001
  local count = 0
  if l_1_1 - math.floor(l_1_1) < eps then
    l_1_0, count = string.gsub(l_1_0, "%%d", string.format("%.0f", l_1_1))
  else
    if l_1_1 * 10 - math.floor(l_1_1 * 10) < eps then
      l_1_0, count = string.gsub(l_1_0, "%%d", string.format("%.1f", l_1_1))
    else
      l_1_0, count = string.gsub(l_1_0, "%%d", string.format("%.2f", l_1_1))
    end
  end
  if count <= 0 then
    local pValue = l_1_1 * 100
    if pValue - math.floor(pValue) < eps then
      l_1_0, count = string.gsub(l_1_0, "%%p", string.format("%.0f", pValue) .. "%%")
    else
      if pValue * 10 - math.floor(pValue * 10) < eps then
        l_1_0, count = string.gsub(l_1_0, "%%p", string.format("%.1f", pValue) .. "%%")
      else
        l_1_0, count = string.gsub(l_1_0, "%%p", string.format("%.2f", pValue) .. "%%")
      end
    end
  end
  return l_1_0
end

String.endWith = function(l_2_0, l_2_1)
  if not l_2_0 or not l_2_1 then
    return false
  end
  local len = string.len(l_2_0)
  local pLen = string.len(l_2_1)
  return string.find(l_2_0, l_2_1, len - pLen)
end

String.split = function(l_3_0, l_3_1)
  local nFindStartIndex = 1
  local nSplitIndex = 1
  do
    local nSplitArray = {}
    repeat
      local nFindLastIndex = string.find(l_3_0, l_3_1, nFindStartIndex)
      if not nFindLastIndex then
        nSplitArray[nSplitIndex] = string.sub(l_3_0, nFindStartIndex, string.len(l_3_0))
      else
        nSplitArray[nSplitIndex] = string.sub(l_3_0, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(l_3_1)
        nSplitIndex = nSplitIndex + 1
      end
    else
      return nSplitArray
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return String

