-- Command line was: E:\github\dhgametool\scripts\data\rateus.lua 

local rateus = {}
rateus.init = function(l_1_0)
  rateus.status = l_1_0
end

rateus.isAvailable = function()
  if isOnestore() then
    do return end
  end
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    return false
  end
  return rateus.status == 1 and require("data.player").lv() >= 30
end

rateus.close = function()
  rateus.status = nil
end

rateus.print = function()
  print("--------- rate us -------- {")
  print("status:", rateus.status)
  print("--------- rate us -------- }")
end

return rateus

