-- Command line was: E:\github\dhgametool\scripts\data\frdarena.lua 

local frdarena = {}
local net = require("net.netClient")
local netClient = net:getInstance()
local player = require("data.player")
frdarena.rivals = {}
frdarena.init = function(l_1_0)
  frdarena.team = l_1_0.team
  frdarena.camp = l_1_0.camp
  frdarena.trank = nil
  if l_1_0.team and l_1_0.team.enggy_cd then
    frdarena.team.pull_ecd_time = os.time()
  end
  frdarena.teams = nil
  frdarena.rivals = {}
  frdarena.showapplyRed = false
  frdarena.showinvitRed = false
  frdarena.refreshOwner = false
end

frdarena.refTeam = function(l_2_0)
  frdarena.team = l_2_0.team
  frdarena.camp = l_2_0.camp
end

frdarena.initTime = function(l_3_0)
  frdarena.season_cd = os.time() + l_3_0.season_cd
end

frdarena.refresh = function()
  local riv = {}
  for i = 1,  frdarena.rivals do
    for j = i + 1,  frdarena.rivals do
      if frdarena.rivals[j].score < frdarena.rivals[i].score then
        frdarena.rivals[i], frdarena.rivals[j] = frdarena.rivals[j], frdarena.rivals[i]
      end
    end
  end
  for i = 1,  frdarena.rivals do
    local idx =  frdarena.rivals - i + 1
    if not frdarena.rivals[idx].isUsed then
      riv[ riv + 1] = frdarena.rivals[idx]
      frdarena.rivals[idx].isUsed = true
    end
    if  riv >= 2 then
      do return end
    end
  end
  for i = 1,  frdarena.rivals do
    if not frdarena.rivals[i].isUsed then
      riv[ riv + 1] = frdarena.rivals[i]
      frdarena.rivals[i].isUsed = true
    end
    if  riv >= 3 then
      return riv
    end
  end
  for i = 1,  frdarena.rivals do
    local idx =  frdarena.rivals - i + 1
    if not frdarena.rivals[idx].isUsed then
      riv[ riv + 1] = frdarena.rivals[idx]
      frdarena.rivals[idx].isUsed = true
    end
    if  riv >= 3 then
      return riv
    end
  end
  if  riv ==  frdarena.rivals and  riv > 0 then
    return riv
  elseif  riv < 2 then
    return {}
  end
  return riv
end

frdarena.setdissmiss = function()
  frdarena.team = nil
end

frdarena.setLeader = function(l_6_0)
  frdarena.refreshOwner = true
  frdarena.team.leader = l_6_0
end

frdarena.jointeam = function(l_7_0)
  frdarena.team = {}
  frdarena.team = l_7_0
end

frdarena.addTeammate = function(l_8_0)
  if not frdarena.team.mbrs then
    frdarena.team.mbrs = {}
  end
  for i = 1,  frdarena.team.mbrs do
    if frdarena.team.mbrs[i] == l_8_0 then
      return 
    end
  end
  frdarena.team.mbrs[ frdarena.team.mbrs + 1] = l_8_0
end

frdarena.delTeammate = function(l_9_0)
  if frdarena.team.mbrs == nil then
    return 
  end
  for i = 1,  frdarena.team.mbrs do
    if frdarena.team.mbrs[i].uid == l_9_0.uid then
      table.remove(frdarena.team.mbrs, i)
  else
    end
  end
end

frdarena.submit = function()
  frdarena.team.reg = true
end

frdarena.delOld = function(l_11_0)
  if  l_11_0 >= 60 then
    for ii = 1, 30 do
      table.remove(l_11_0, 1)
    end
  end
end

onFrdarena = function(l_12_0)
  tbl2string(l_12_0)
  if l_12_0.owner or l_12_0.dismiss or l_12_0.leave or l_12_0.agree_invite or l_12_0.submit or l_12_0.kicked or l_12_0.agreed then
    local params = {sid = player.sid}
    net:gpvp_sync(params, function(l_1_0)
      tbl2string(l_1_0)
      frdarena.refTeam(l_1_0)
      if data.owner then
        frdarena.refreshOwner = true
      end
      end)
  elseif l_12_0.invited then
    frdarena.showinvitRed = true
  elseif l_12_0.apply then
    frdarena.showapplyRed = true
  end
end

frdarena.registEvent = function()
  netClient:registFrdarenaEvent(onFrdarena)
end

return frdarena

