-- Command line was: E:\github\dhgametool\scripts\data\player.lua 

local player = {}
require("common.const")
require("common.func")
local cfgexpplayer = require("config.expplayer")
local cfgvip = require("config.vip")
local cfghero = require("config.hero")
local bagdata = require("data.bag")
local achievedata = require("data.achieve")
player.init = function(l_1_0, l_1_1, l_1_2)
  player.uid = l_1_0
  player.sid = l_1_1
  if l_1_2 then
    player.name = l_1_2.name
    player.logo = l_1_2.logo
    player.gid = l_1_2.gid or 0
    player.gname = l_1_2.gname
    player.final_rank = l_1_2.final_rank
  end
end

player.exp = function()
  return bagdata.items.find(ITEM_ID_PLAYER_EXP).num
end

player.maxLv = function()
  return #cfgexpplayer
end

player.maxExp = function()
  return cfgexpplayer[#cfgexpplayer].allExp
end

player.lv = function(l_5_0)
  if not l_5_0 then
    local item = bagdata.items.find(ITEM_ID_PLAYER_EXP)
    if item then
      l_5_0 = item.num
    else
      l_5_0 = 0
    end
  end
  if player.maxExp() < l_5_0 then
    return nil
  end
  for i = 1, player.maxLv() do
    if l_5_0 < cfgexpplayer[i].allExp then
      local curExp = l_5_0 - cfgexpplayer[i - 1].allExp
      return i - 1, curExp, cfgexpplayer[i].allExp - cfgexpplayer[i - 1].allExp
    end
  end
  return player.maxLv()
end

player.maxVipLv = function()
  return #cfgvip
end

player.maxVipExp = function()
  return cfgvip[#cfgvip].exp
end

player.vipLv = function(l_8_0)
  if not l_8_0 then
    local item = bagdata.items.find(ITEM_ID_VIP_EXP)
    if item then
      l_8_0 = item.num
    else
      l_8_0 = 0
    end
  end
  if player.maxVipExp() < l_8_0 then
    return nil
  end
  for i = 0, player.maxVipLv() do
    if l_8_0 < cfgvip[i].exp then
      local curExp = l_8_0 - cfgvip[i - 1].exp
      return i - 1, curExp, cfgvip[i].exp - cfgvip[i - 1].exp
    end
  end
  return player.maxVipLv()
end

player.setHideVip = function(l_9_0)
  player.hide_vip = l_9_0
end

player.print = function()
  print("--------------- player --------------- {")
  print("uid:", player.uid)
  print("sid:", player.sid)
  print("name:", player.name)
  print("logo:", player.logo)
  print("gid:", player.gid)
  print("gname:", player.gname)
  print("final_rank:", player.final_rank)
  print("hide_vip:", player.hide_vip)
  print("--------------- player --------------- }")
end

return player

