-- Command line was: E:\github\dhgametool\scripts\data\herobook.lua 

local herobook = {}
require("common.const")
require("common.func")
local cfghero = require("config.hero")
herobook.init = function(l_1_0)
  arrayclear(herobook)
  if not l_1_0 then
    local heroIds = {}
  end
  for _,id in ipairs(heroIds) do
    herobook[ herobook + 1] = id
  end
  local headdata = require("data.head")
  headdata.init()
end

herobook.add = function(l_2_0)
  if not arraycontains(herobook, l_2_0) then
    herobook[ herobook + 1] = l_2_0
    if QUALITY_4 <= cfghero[l_2_0].qlt then
      local headdata = require("data.head")
      headdata.add(l_2_0)
    end
  end
end

herobook.print = function()
  print("---------------- herobook ---------------- {")
  print("[", table.concat(herobook, " "), "]")
  print("---------------- herobook ---------------- }")
end

return herobook

