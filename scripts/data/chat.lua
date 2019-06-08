-- Command line was: E:\github\dhgametool\scripts\data\chat.lua 

local chat = {}
local player = require("data.player")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local MSG_TYPE = {WORLD = 1, GUILD = 2, RECRUIT = 3}
chat.MSG_TYPE = MSG_TYPE
local is_inited = false
local is_synced = false
local initMsg = function()
  if is_inited then
    return 
  end
  chat.world = {new_msgs = {}, old_msgs = {}}
  chat.guild = {new_msgs = {}, old_msgs = {}}
  chat.recruit = {new_msgs = {}, old_msgs = {}}
  is_inited = true
end

initMsg()
chat.isSynced = function()
  return is_synced
end

chat.synced = function()
  is_synced = true
end

chat.deSync = function()
  is_synced = false
  upvalue_512 = false
end

chat.sync = function(l_5_0)
  initMsg()
  local params = {sid = player.sid}
  netClient:sync_chat(params, l_5_0)
end

chat.send = function(l_6_0, l_6_1)
  netClient:chat(l_6_0, l_6_1)
end

chat.showRedDot = function()
  if  chat.world.new_msgs > 0 then
    return true
  end
  if  chat.guild.new_msgs > 0 then
    return true
  end
  if  chat.recruit.new_msgs > 0 then
    return true
  end
  return false
end

chat.showRedDotForWorld = function()
  if  chat.world.new_msgs > 0 then
    return true
  end
  return false
end

chat.showRedDotForGuild = function()
  if  chat.guild.new_msgs > 0 then
    return true
  end
  return false
end

chat.showRedDotForRecruit = function()
  if  chat.recruit.new_msgs > 0 then
    return true
  end
  return false
end

local msgSort = function(l_11_0, l_11_1)
  if l_11_0.time < l_11_1.time then
    return true
  else
    return false
  end
end

chat.world.add = function(l_12_0)
  if not chat.world then
    chat.world = {}
  end
  chat.world[ chat.world + 1] = l_12_0
  table.sort(chat.world, msgSort)
end

chat.guild.add = function(l_13_0)
  if not chat.guild then
    chat.guild = {}
  end
  chat.guild[ chat.guild + 1] = l_13_0
  table.sort(chat.guild, msgSort)
end

chat.recruit.add = function(l_14_0)
  if not chat.recruit then
    chat.recruit = {}
  end
  chat.recruit[ chat.recruit + 1] = l_14_0
  table.sort(chat.recruit, msgSort)
end

chat.delOld = function(l_15_0)
  if  l_15_0 >= 60 then
    for ii = 1, 30 do
      table.remove(l_15_0, 1)
    end
  end
end

chat.addMsg = function(l_16_0, l_16_1)
  if not l_16_0 then
    l_16_0 = {}
  end
  l_16_0[ l_16_0 + 1] = l_16_1
  chat.delOld(l_16_0)
  table.sort(l_16_0, msgSort)
end

chat.getWorldMsg = function()
  return chat.world.old_msgs
end

chat.getGuildMsg = function()
  return chat.guild.old_msgs
end

chat.getRecruitMsg = function()
  return chat.recruit.old_msgs
end

chat.fetchWorldMsg = function()
  if  chat.world.new_msgs <= 0 then
    return nil
  end
  local tmp_obj = chat.world.new_msgs[1]
  chat.addMsg(chat.world.old_msgs, tmp_obj)
  table.remove(chat.world.new_msgs, 1)
  return tmp_obj
end

chat.fetchGuildMsg = function()
  if  chat.guild.new_msgs <= 0 then
    return nil
  end
  local tmp_obj = chat.guild.new_msgs[1]
  chat.addMsg(chat.guild.old_msgs, tmp_obj)
  table.remove(chat.guild.new_msgs, 1)
  return tmp_obj
end

chat.fetchRecruitMsg = function()
  if  chat.recruit.new_msgs <= 0 then
    return nil
  end
  local tmp_obj = chat.recruit.new_msgs[1]
  chat.addMsg(chat.recruit.old_msgs, tmp_obj)
  table.remove(chat.recruit.new_msgs, 1)
  return tmp_obj
end

local onMsg = function(l_23_0)
  print("new chat msg:")
  tbl2string(l_23_0)
  if l_23_0.type == chat.MSG_TYPE.WORLD then
    chat.addMsg(chat.world.new_msgs, l_23_0)
  else
    if l_23_0.type == chat.MSG_TYPE.GUILD then
      chat.addMsg(chat.guild.new_msgs, l_23_0)
    else
      if l_23_0.type == chat.MSG_TYPE.RECRUIT then
        chat.addMsg(chat.recruit.new_msgs, l_23_0)
      end
    end
  end
end

chat.addMsgs = function(l_24_0)
  if not l_24_0 or  l_24_0 == 0 then
    return 
  end
  for ii = 1,  l_24_0 do
    onMsg(l_24_0[ii])
  end
end

chat.registEvent = function()
  netClient:registChatEvent(onMsg)
end

return chat

