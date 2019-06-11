-- Command line was: E:\github\dhgametool\scripts\data\arena.lua 

local arena = {}
local net = require("net.netClient")
local player = require("data.player")
arena.rivals = {}
local net = require("net.netClient")
arena.init = function(l_1_0)
  arena.members = nil
  arena.rivals = {}
  arena.fight = 0
  arena.tscore = 0
  arena.rank = 0
  arena.trank = 0
  if not l_1_0.self.fight then
    arena.fight = not l_1_0.self or 0
  end
  arena.score = l_1_0.self.score
  arena.power = l_1_0.self.power
  arena.rank = l_1_0.self.rank
  arena.trank = l_1_0.self.trank
  arena.tscore = l_1_0.self.tscore
  arena.win = l_1_0.self.win
  arena.camp = l_1_0.self.camp
  if arena.camp then
    local hids = {0, 0, 0, 0, 0, 0}
    for i,v in ipairs(arena.camp) do
      if v.pos ~= 7 then
        hids[v.pos] = v.hid
        for i,v in (for generator) do
        end
        hids[v.pos] = v.id
      end
      local userdata = require("data.userdata")
      userdata.setSquadArenadef(hids, 1)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

arena.initTime = function(l_2_0)
  arena.season_cd = os.time() + (l_2_0.season_cd or 0)
  arena.daily_cd = os.time() + (l_2_0.daily_cd or 0)
end

arena.refresh = function()
  local riv = {}
  for i = 1, #arena.rivals do
    for j = i + 1, #arena.rivals do
      if arena.rivals[j].score < arena.rivals[i].score then
        arena.rivals[i], arena.rivals[j] = arena.rivals[j], arena.rivals[i]
      end
    end
  end
  for i = 1, #arena.rivals do
    local idx = #arena.rivals - i + 1
    if not arena.rivals[idx].isUsed then
      riv[#riv + 1] = arena.rivals[idx]
      arena.rivals[idx].isUsed = true
    end
    if #riv >= 2 then
      do return end
    end
  end
  for i = 1, #arena.rivals do
    if not arena.rivals[i].isUsed then
      riv[#riv + 1] = arena.rivals[i]
      arena.rivals[i].isUsed = true
    end
    if #riv >= 3 then
      return riv
    end
  end
  for i = 1, #arena.rivals do
    local idx = #arena.rivals - i + 1
    if not arena.rivals[idx].isUsed then
      riv[#riv + 1] = arena.rivals[idx]
      arena.rivals[idx].isUsed = true
    end
    if #riv >= 3 then
      return riv
    end
  end
  if #riv == #arena.rivals and #riv > 0 then
    return riv
  elseif #riv < 2 then
    return {}
  end
  return riv
end

arena.update = function(l_4_0)
  arena.score = l_4_0
  if arena.tscore < arena.score then
    arena.tscore = arena.score
  end
  local achieveData = require("data.achieve")
  achieveData.set(ACHIEVE_TYPE_ARENA_SCORE, arena.tscore)
end

return arena

