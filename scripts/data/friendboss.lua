-- Command line was: E:\github\dhgametool\scripts\data\friendboss.lua 

local friendboss = {}
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local player = require("data.player")
friendboss.init = function(l_1_0)
  print("**** frdboss ****")
  tbl2string(l_1_0)
  friendboss.pull_time = os.time()
  friendboss.enegy = l_1_0.tl
  friendboss.video = {}
  if l_1_0.tcd then
    friendboss.pull_tcd_time = os.time()
    friendboss.tcd = l_1_0.tcd
  else
    friendboss.tcd = nil
  end
  if l_1_0.scd then
    friendboss.pull_scd_time = os.time()
    friendboss.scd = l_1_0.scd
  else
    friendboss.scd = nil
  end
  friendboss.rcd = l_1_0.rcd
end

friendboss.delEnegy = function(l_2_0)
  if friendboss.enegy == 10 then
    friendboss.tcd = 7200
    friendboss.pull_tcd_time = os.time()
  end
  if l_2_0 then
    friendboss.enegy = friendboss.enegy - l_2_0
  else
    friendboss.enegy = friendboss.enegy - 1
  end
end

friendboss.addEnegy = function()
  friendboss.enegy = friendboss.enegy + 1
  if friendboss.enegy == 10 then
    friendboss.tcd = nil
  end
end

friendboss.upscd = function()
  friendboss.scd = 0
  friendboss.pull_scd_time = os.time()
end

friendboss.addscd = function()
  friendboss.scd = friendboss.scd + 28800
  friendboss.pull_scd_time = os.time()
end

local onFriendsboss = function(l_6_0)
  print("onFriendsboss data")
  tbl2string(l_6_0)
  local friend = require("data.friend")
  friend.changebossst(l_6_0.uid, true)
end

friendboss.registEvent = function()
  netClient:registFriendsbossEvent(onFriendsboss)
end

friendboss.showBossRedDot = function()
  if friendboss.scd and friendboss.scd == 0 and player.lv() >= 36 then
    return true
  end
  return false
end

return friendboss

