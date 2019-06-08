-- Command line was: E:\github\dhgametool\scripts\data\guild.lua 

local guild = {}
local guildexp = require("config.guildexp")
local cfgguildFlag = require("config.guildflag")
local i18n = require("res.i18n")
local player = require("data.player")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local TITLE = {RESIDENT = 0, OFFICER = 1, PRESIDENT = 2}
guild.TITLE = TITLE
guild.CREATE_COST = 500
guild.NAME_COST = 1000
guild.is_init = false
guild.SIGN_EXP = 30
guild.SIGN_COIN = 50
local flags = {}
local initFlag = function()
  for ii = 1,  cfgguildFlag do
    flags[ii] = ii
  end
end

initFlag()
guild.flags = flags
guild.init = function(l_2_0)
  guild.last_pull = os.time()
  guild.guildObj = clone(l_2_0.guild)
  guild.members = clone(l_2_0.members)
  player.gid = guild.guildObj.id
  if not l_2_0.sign_cd then
    guild.sign_cd = os.time()
  end
  guild.appliers_count = l_2_0.appliers_count or 0
  guild.is_init = true
end

guild.deInit = function()
  guild.is_init = false
end

guild.IsInit = function()
  return guild.is_init
end

guild.self = function()
  if not guild.members then
    return nil
  end
  for ii = 1,  guild.members do
    if guild.members[ii].uid == player.uid then
      return guild.members[ii]
    end
  end
  return nil
end

guild.selfTitle = function()
  local selfObj = guild.self()
  if selfObj then
    return selfObj.title
  end
  return TITLE.RESIDENT
end

guild.removeMemByUid = function(l_7_0)
  if not guild.members or  guild.members == 0 then
    return 
  end
  for ii = 1,  guild.members do
    if guild.members[ii].uid == l_7_0 then
      table.remove(guild.members, ii)
      return 
    end
  end
end

guild.Lv = function(l_8_0)
  if not l_8_0 then
    l_8_0 = guild.guildObj.exp
  end
  for ii = 1,  guildexp do
    if l_8_0 < guildexp[ii].allExp then
      return ii - 1
    end
  end
  return  guildexp
end

guild.maxMember = function(l_9_0)
  local lv = guild.Lv(l_9_0)
  return guildexp[lv].member
end

guild.maxOffical = function(l_10_0)
  return 4
end

guild.lvReward = function(l_11_0)
  local lv = guild.Lv(l_11_0)
  return guildexp[lv].registerReward
end

guild.upLvExp = function(l_12_0)
  local lv = guild.Lv(l_12_0)
  if  guildexp <= lv then
    lv =  guildexp - 1
  end
  return guildexp[lv + 1].allExp - guildexp[lv].allExp
end

guild.curLvExp = function(l_13_0)
  if not l_13_0 then
    l_13_0 = guild.guildObj.exp
  end
  local lv = guild.Lv(l_13_0)
  if lv <= 1 then
    return l_13_0
  end
  local curLvExp = l_13_0 - guildexp[lv].allExp
  if guild.upLvExp(l_13_0) < curLvExp then
    curLvExp = guild.upLvExp(l_13_0)
  end
  return curLvExp
end

guild.addExp = function(l_14_0)
  if not guild.guildObj then
    return 
  end
  guild.guildObj.exp = guild.guildObj.exp or 0
  guild.guildObj.exp = guild.guildObj.exp + l_14_0
end

guild.getTitleStr = function(l_15_0)
  if l_15_0 == TITLE.RESIDENT then
    return i18n.global.guild_title_resident.string
  else
    if l_15_0 == TITLE.OFFICER then
      return i18n.global.guild_title_officer.string
    else
      if l_15_0 == TITLE.PRESIDENT then
        return i18n.global.guild_title_president.string
      end
    end
  end
end

guild.mem_sort = function(l_16_0, l_16_1)
  return l_16_1.title < l_16_0.title
end

guild.showRedDot = function()
  if not player.gid or player.gid <= 0 then
    return false
  end
  local gmill = require("data.guildmill")
  if gmill.showRedDot() then
    return true
  end
  if not guild.guildObj then
    return false
  end
  if guild.showRedDotApply() then
    return true
  end
  return false
end

guild.showRedDotApply = function()
  if TITLE.RESIDENT < guild.selfTitle() and guild.appliers_count and guild.appliers_count > 0 then
    return true
  end
  return false
end

guild.deApplyCount = function()
  if guild.appliers_count and guild.appliers_count > 0 then
    guild.appliers_count = guild.appliers_count - 1
  end
end

guild.setApplyCount = function(l_20_0)
  guild.appliers_count = l_20_0
end

guild.Listen = function()
  netClient:registGuildEvent(function(l_1_0)
    print("guild notify --------------------")
    tbl2string(l_1_0)
    if not guild.appliers_count then
      guild.appliers_count = 0
    end
    guild.deInit()
    local gtype = l_1_0.type
    if gtype == 1 then
      guild.appliers_count = guild.appliers_count + 1
    elseif gtype == 2 then
      guild.appliers_count = guild.appliers_count - 1
      if l_1_0.uid and l_1_0.uid == player.uid then
        player.gid = 2
      elseif gtype == 3 then
        guild.appliers_count = guild.appliers_count - 1
      elseif gtype == 4 then
        if l_1_0.uid and l_1_0.uid == player.uid then
          guild.self().title = TITLE.OFFICER
        end
        guild.deInit()
      elseif gtype == 5 then
        if l_1_0.uid and l_1_0.uid == player.uid then
          guild.self().title = TITLE.RESIDENT
        end
        guild.deInit()
      elseif gtype == 6 then
        if l_1_0.uid and l_1_0.uid == player.uid then
          guild.self().title = TITLE.PRESIDENT
        end
        guild.deInit()
      elseif gtype == 7 then
        guild.addExp(guild.SIGN_EXP)
      elseif gtype == 8 then
        guild.deInit()
        if l_1_0.uid and l_1_0.uid == player.uid then
          player.gid = 0
        end
      end
    end
   end)
end

guild.onlineStatus = function(l_22_0)
  if l_22_0 <= 0 then
    return i18n.global.guild_mem_status_online.string
  elseif l_22_0 < 60 then
    return i18n.global.arena_records_times.string
  elseif l_22_0 < 3600 then
    local mm = math.floor(l_22_0 % 3600 / 60)
    if i18n.getCurrentLanguage() == kLanguageGerman then
      return string.format(i18n.global.arena_records_minutes.string, mm)
    end
    return mm .. i18n.global.arena_records_minutes.string
  elseif l_22_0 < 86400 then
    local hh = math.floor(l_22_0 / 3600)
    if i18n.getCurrentLanguage() == kLanguageGerman then
      return string.format(i18n.global.arena_records_hours.string, hh)
    end
    return hh .. i18n.global.arena_records_hours.string
  elseif l_22_0 < 864000 then
    return string.format(i18n.global.guild_mem_status_nd.string, math.floor(l_22_0 / 86400))
  else
    return i18n.global.guild_mem_status_10d.string
  end
end

return guild

