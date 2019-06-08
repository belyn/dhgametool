-- Command line was: E:\github\dhgametool\scripts\data\skinbook.lua 

local skinbook = {}
skinbook.data = {}
skinbook.init = function(l_1_0)
  if not l_1_0 then
    skinbook.data = {}
  end
end

skinbook.contain = function(l_2_0)
  for k,v in ipairs(skinbook.data) do
    if v == l_2_0 then
      return true
    end
  end
  return false
end

skinbook.print = function()
  print("---------------- skinbook ---------------- {")
  print("[", table.concat(skinbook.data, " "), "]")
  print("---------------- skinbook ---------------- }")
end

return skinbook

