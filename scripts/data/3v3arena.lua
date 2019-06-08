-- Command line was: E:\github\dhgametool\scripts\data\3v3arena.lua 

local arena = {}
local net = require("net.netClient")
local player = require("data.player")
arena.rivals = {}
local net = require("net.netClient")
arena.init = function(l_1_0)
  arena.status = l_1_0.status
  arena.score = l_1_0.self.score
  arena.power = l_1_0.self.power
  arena.rank = l_1_0.self.rank
  arena.trank = l_1_0.self.trank
  arena.tscore = l_1_0.self.tscore
  arena.members = nil
  arena.rivals = {}
  arena.fight = l_1_0.self.fight or 0
  arena.camp = l_1_0.self.camp
  if arena.camp then
    local hids = {}
    for i = 1, 18 do
      hids[i] = 0
    end
    for i,v in ipairs(arena.camp) do
      if v.pos <= 18 then
        hids[v.pos] = v.hid
        for i,v in (for generator) do
        end
        hids[v.pos] = v.id
      end
      local userdata = require("data.userdata")
      userdata.setSquadArena3v3Def(hids)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

arena.initTime = function(l_2_0)
  arena.season_cd = os.time() + l_2_0.season_cd
end

arena.refresh = function()
  local riv = {}
  if not arena.rivals then
    arena.rivals = {}
  end
  for i = 1,  arena.rivals do
    for j = i + 1,  arena.rivals do
      if arena.rivals[j].score < arena.rivals[i].score then
        arena.rivals[i], arena.rivals[j] = arena.rivals[j], arena.rivals[i]
      end
    end
  end
  for i = 1,  arena.rivals do
    local idx =  arena.rivals - i + 1
    if not arena.rivals[idx].isUsed then
      riv[ riv + 1] = arena.rivals[idx]
      arena.rivals[idx].isUsed = true
    end
    if  riv >= 2 then
      do return end
    end
  end
  for i = 1,  arena.rivals do
    if not arena.rivals[i].isUsed then
      riv[ riv + 1] = arena.rivals[i]
      arena.rivals[i].isUsed = true
    end
    if  riv >= 3 then
      return riv
    end
  end
  for i = 1,  arena.rivals do
    local idx =  arena.rivals - i + 1
    if not arena.rivals[idx].isUsed then
      riv[ riv + 1] = arena.rivals[idx]
      arena.rivals[idx].isUsed = true
    end
    if  riv >= 3 then
      return riv
    end
  end
  if  riv ==  arena.rivals and  riv > 0 then
    return riv
  elseif  riv < 2 then
    return {}
  end
  return riv
end

arena.update = function(l_4_0)
  arena.score = l_4_0
  if arena.tscore < arena.score then
    arena.tscore = arena.score
  end
end

return arena

