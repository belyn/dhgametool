-- Command line was: E:\github\dhgametool\scripts\data\friend.lua 

local friend = {}
local i18n = require("res.i18n")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local friendsList = {}
local friendsApply = {}
local friendsRecmd = {}
local is_inited = false
local initMsg = function()
  if is_inited then
    return 
  end
  friend.list = {new_msgs = {}, old_msgs = {}}
  friend.apply = {new_msgs = {}, old_msgs = {}}
  friend.loved = {new_msgs = {}, old_msgs = {}}
  is_inited = true
end

initMsg()
friend.compareFrd = function(l_2_0, l_2_1)
  if l_2_0.boss and not l_2_1.boss then
    return true
  elseif not l_2_0.boss and l_2_1.boss then
    return false
  end
end

friend.init = function(l_3_0)
  friend.love = l_3_0.love
  friend.cd = l_3_0.cd + os.time()
  upvalue_512 = l_3_0.friends
  upvalue_1024 = l_3_0.apply
  upvalue_1536 = l_3_0.recmd
  if friendsList then
    table.sort(friendsList, friend.compareFrd)
  end
  friend.friends = {friendsList = friendsList, friendsApply = friendsApply, friendsRecmd = friendsRecmd}
end

friend.onlineStatus = function(l_4_0)
  if l_4_0 <= 0 then
    return i18n.global.guild_mem_status_online.string
  elseif l_4_0 < 60 then
    return i18n.global.arena_records_times.string
  elseif l_4_0 < 3600 then
    local mm = math.floor(l_4_0 % 3600 / 60)
    if i18n.getCurrentLanguage() == kLanguageGerman then
      return string.format(i18n.global.arena_records_minutes.string, mm)
    end
    return mm .. i18n.global.arena_records_minutes.string
  elseif l_4_0 < 86400 then
    local hh = math.floor(l_4_0 / 3600)
    if i18n.getCurrentLanguage() == kLanguageGerman then
      return string.format(i18n.global.arena_records_hours.string, hh)
    end
    return hh .. i18n.global.arena_records_hours.string
  elseif l_4_0 < 864000 then
    return string.format(i18n.global.guild_mem_status_nd.string, math.floor(l_4_0 / 86400))
  else
    return i18n.global.guild_mem_status_10d.string
  end
end

friend.showRedDot = function()
  if  friend.list.new_msgs > 0 then
    return true
  end
  if  friend.apply.new_msgs > 0 then
    return true
  end
  if  friend.loved.new_msgs > 0 then
    return true
  end
  return false
end

friend.showListRedDot = function()
  if friendsList == nil then
    return false
  end
  for i = 1,  friendsList do
    if friendsList[i].flag == 2 or friendsList[i].flag == 3 then
      return true
    end
  end
  return false
end

friend.showApplyRedDot = function()
  if friendsApply == nil then
    return false
  end
  if  friendsApply > 0 then
    return true
  end
  return false
end

friend.delOld = function(l_8_0)
  if  l_8_0 >= 60 then
    for ii = 1, 30 do
      table.remove(l_8_0, 1)
    end
  end
end

friend.addMsg = function(l_9_0, l_9_1)
  if not l_9_0 then
    l_9_0 = {}
  end
  l_9_0[ l_9_0 + 1] = l_9_1
  friend.delOld(l_9_0)
end

friend.addLove = function(l_10_0)
  friend.love = friend.love + l_10_0
end

friend.changebossst = function(l_11_0, l_11_1)
  if not friendsList then
    friendsList = {}
    friend.friends.friendsList = friendsList
  end
  for i = 1,  friendsList do
    if friendsList[i].uid == l_11_0 then
      friendsList[i].boss = l_11_1
      table.sort(friendsList, friend.compareFrd)
      return 
    end
  end
end

friend.addFriendsList = function(l_12_0)
  if not friendsList then
    friendsList = {}
    friend.friends.friendsList = friendsList
  end
  for i = 1,  friendsList do
    if friendsList[i] == l_12_0 then
      return 
    end
  end
  friendsList[ friendsList + 1] = l_12_0
end

friend.addFriendsRecmd = function(l_13_0)
  if not friendsRecmd then
    friendsRecmd = {}
    friend.friends.friendsRecmd = friendsRecmd
  end
  friendsRecmd[ friendsRecmd + 1] = l_13_0
end

friend.addFriendsApply = function(l_14_0)
  if not friendsApply then
    friendsApply = {}
    friend.friends.friendsApply = friendsApply
  end
  friendsApply[ friendsApply + 1] = l_14_0
  if  friendsApply > 10 then
    table.remove(friendsApply, 1)
  end
end

friend.delFriendsList = function(l_15_0)
  if friendsList == nil then
    return 
  end
  for i = 1,  friendsList do
    if friendsList[i] == l_15_0 then
      table.remove(friendsList, i)
  else
    end
  end
end

friend.addfriends = function(l_16_0)
  if l_16_0.friends then
    for i = 1,  l_16_0.friends do
      addFriendsList(l_16_0.friends[i])
    end
  end
  if l_16_0.apply then
    for i = 1,  l_16_0.apply do
      addFriendsApply(l_16_0.apply[i])
    end
  end
  if l_16_0.recmd then
    for i = 1,  l_16_0.recmd do
      addFriendsRecmd(l_16_0.recmd[i])
    end
  end
end

friend.delFriendsApply = function(l_17_0)
  for i = 1,  friendsApply do
    if friendsApply[i] == l_17_0 then
      table.remove(friendsApply, i)
  else
    end
  end
end

friend.delFriendsRecmd = function(l_18_0)
  for i = 1,  friendsRecmd do
    if friendsRecmd[i] == l_18_0 then
      table.remove(friendsRecmd, i)
  else
    end
  end
end

friend.getFriendsList = function()
  return friendsList
end

friend.getFriendsApply = function()
  return friendsApply
end

friend.getFriendsRecmd = function()
  return friendsRecmd
end

friend.fetchListMsg = function()
  if  friend.list.new_msgs <= 0 then
    return nil
  end
  local tmp_obj = friend.list.new_msgs[1]
  friend.addMsg(friend.list.old_msgs, tmp_obj)
  table.remove(friend.list.new_msgs, 1)
  return tmp_obj
end

friend.fetchLovedMsg = function()
  if  friend.loved.new_msgs <= 0 then
    return nil
  end
  local tmp_obj = friend.loved.new_msgs[1]
  friend.addMsg(friend.loved.old_msgs, tmp_obj)
  table.remove(friend.loved.new_msgs, 1)
  return tmp_obj
end

friend.fetchApplyMsg = function()
  if  friend.apply.new_msgs <= 0 then
    return nil
  end
  local tmp_obj = friend.apply.new_msgs[1]
  friend.addMsg(friend.apply.old_msgs, tmp_obj)
  table.remove(friend.apply.new_msgs, 1)
  return tmp_obj
end

local onFriends = function(l_25_0)
  cclog("onFriends data")
  tbl2string(l_25_0)
  if l_25_0.add then
    friend.addMsg(friend.list.new_msgs, l_25_0)
    friend.addFriendsList(l_25_0.add)
  end
  if l_25_0.love then
    friend.addMsg(friend.loved.new_msgs, l_25_0)
    for i = 1,  friendsList do
      if friendsList[i].uid == l_25_0.love then
        friendsList[i].flag = friendsList[i].flag + 2
    else
      end
    end
  end
  if l_25_0.apply then
    friend.addMsg(friend.apply.new_msgs, l_25_0)
    friend.addFriendsApply(l_25_0.apply)
  end
  if l_25_0.del then
    for i = 1,  friendsList do
      if friendsList[i].uid == l_25_0.del then
        friend.delFriendsList(friendsList[i])
    else
      end
    end
  end
end

friend.registEvent = function()
  netClient:registFriendsEvent(onFriends)
end

return friend

