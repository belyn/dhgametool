-- Command line was: E:\github\dhgametool\scripts\data\midas.lua 

local midas = {}
require("common.const")
require("common.func")
midas.init = function(l_1_0, l_1_1)
  local now = os.time()
  midas.cd = l_1_0 + now
  midas.flag = l_1_1
  midas.kind = {}
  for i = 1, 3 do
    midas.kind[i] = bit.band(1, midas.flag)
    midas.flag = bit.brshift(midas.flag, 1)
  end
  midas.flag = l_1_1
end

midas.showRedDot = function()
  midas._cd = math.max(0, midas.cd - os.time())
  if midas._cd <= 0 then
    return true
  else
    return false
  end
end

midas.print = function()
  print("--------- midas --------- {")
  print("cd:", midas.cd, midas.flag)
  print("--------- midas --------- }")
end

return midas

