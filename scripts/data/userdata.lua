-- Command line was: E:\github\dhgametool\scripts\data\userdata.lua 

local userdata = {}
userdata.keys = {account = "aaAccount", accountFormal = "aaAccountFormal", password = "aaToken", version = "aaVersion", language = "aaLanguage", musicBG = "aaMusicBG", musicFX = "aaMusicFX", gateServer = "aaGateServer", fightSpeed = "aaFightSpeed", notice = "aaNotice", txwhich = "txwhich", userid = "userid", arena_skip = "arena_skip", agree_user_protocol = "agree_user_protocol", fix_bar_offset = "fix_bar_offset"}
userdata.squadkeys = {normal_team = "normal_team", trial_team = "trial_team", arenaatk_team = "arenaatk_team", arenadef_team = "arenadef_team", frdarena_team = "frdarena_team", guildboss_team = "guildboss_team", guildgray_team = "guildgray_team", dailyfight_team = "dailyfight_team", airisland_team = "airisland_team", friend_team = "friend_team", arena3v3_team = "arena3v3_team", arena3v3atk_team = "arena3v3atk_team", guildmill_team = "guildmill_team", guildmillatk_team = "guildmillatk_team", guild_fight_team = "guild_fight_team", frd_pk_team = "frd_pk_team", brave_team = "brave_team", broken_boss_team = "broken_boss_team", sweepb_boss_team = "sweepb_boss_team", sweepair_boss_team = "sweepair_boss_team", sweepair_common_team = "sweepair_common_team", sweepf_boss_team = "sweepf_boss_team", sealland1 = "sealland1", sealland2 = "sealland2", sealland3 = "sealland3", sealland4 = "sealland4", sealland5 = "sealland5", sealland6 = "sealland6"}
local CRYPTO_KEY = "da3o29lanxd"
local u = CCUserDefault:sharedUserDefault()
userdata.getString = function(l_1_0, l_1_1)
  if not l_1_1 then
    l_1_1 = ""
  end
  return u:getStringForKey(l_1_0, l_1_1)
end

userdata.setString = function(l_2_0, l_2_1)
  u:setStringForKey(l_2_0, l_2_1)
  u:flush()
end

userdata.getEncryptString = function(l_3_0)
  return crypto.decryptXXTEA(crypto.decodeBase64(userdata.getString(l_3_0)), CRYPTO_KEY) or ""
end

userdata.setEncryptString = function(l_4_0, l_4_1)
  userdata.setString(l_4_0, crypto.encodeBase64(crypto.encryptXXTEA(l_4_1, CRYPTO_KEY)))
end

userdata.getBool = function(l_5_0, l_5_1)
  local s = userdata.getString(l_5_0)
  if s == "1" then
    return true
  elseif s == "0" then
    return false
  elseif not l_5_1 then
     -- DECOMPILER ERROR: Attempted to build a boolean expression without a pending context

  end
  return false
end

userdata.setBool = function(l_6_0, l_6_1)
  if l_6_1 then
    userdata.setString(l_6_0, "1")
  else
    userdata.setString(l_6_0, "0")
  end
end

userdata.getInt = function(l_7_0, l_7_1)
  return tonumber(userdata.getString(l_7_0), 10) or l_7_1 or 0
end

userdata.setInt = function(l_8_0, l_8_1)
  userdata.setString(l_8_0, tostring(l_8_1))
end

userdata.setSquad = function(l_9_0, l_9_1, l_9_2)
  local num = l_9_2 or 6
  if num == 6 and not l_9_1[7] then
    l_9_1[7] = -1
  end
  if num == 18 then
    for i = 19, 21 do
      if not l_9_1[i] then
        l_9_1[i] = -1
      end
    end
  end
  for i = 1, num do
    if not l_9_1[i] then
      l_9_1[i] = 0
    end
  end
  local str = table.concat(l_9_1, ",")
  userdata.setString(l_9_0, str)
end

userdata.getSquad = function(l_10_0)
  local hids = {}
  local str = userdata.getString(l_10_0)
  local h = string.split(str, ",")
  for i,v in ipairs(h) do
    hids[#hids + 1] = tonumber(v) or 0
  end
  for k,v in pairs(hids) do
    if hids[k] == -1 then
      hids[k] = 0
    end
  end
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if #hids <= 7 and hids[7] == 0 then
    hids[7] = -1
    do return end
    for i = 19, 21 do
      if hids[i] == 0 then
        hids[i] = -1
      end
    end
  end
  return hids
end

userdata.setSquadNormal = function(l_11_0)
  userdata.setSquad(userdata.squadkeys.normal_team, l_11_0)
end

userdata.getSquadNormal = function()
  local hids = userdata.getSquad(userdata.squadkeys.normal_team)
  return hids
end

userdata.setSquadGuildBoss = function(l_13_0)
  userdata.setSquad(userdata.squadkeys.guildboss_team, l_13_0)
end

userdata.getSquadGuildBoss = function()
  local hids = userdata.getSquad(userdata.squadkeys.guildboss_team)
  return hids
end

userdata.setSquadGuildGray = function(l_15_0)
  userdata.setSquad(userdata.squadkeys.guildgray_team, l_15_0)
end

userdata.getSquadGuildGray = function()
  local hids = userdata.getSquad(userdata.squadkeys.guildgray_team)
  return hids
end

userdata.setSquadTrial = function(l_17_0)
  userdata.setSquad(userdata.squadkeys.trial_team, l_17_0)
end

userdata.getSquadTrial = function()
  local hids = userdata.getSquad(userdata.squadkeys.trial_team)
  return hids
end

userdata.setSquadArenaatk = function(l_19_0)
  userdata.setSquad(userdata.squadkeys.arenaatk_team, l_19_0)
end

userdata.getSquadArenaatk = function()
  local hids = userdata.getSquad(userdata.squadkeys.arenaatk_team)
  return hids
end

userdata.setSquadFrdpk = function(l_21_0)
  userdata.setSquad(userdata.squadkeys.frd_pk_team, l_21_0)
end

userdata.getSquadFrdpk = function()
  local hids = userdata.getSquad(userdata.squadkeys.frd_pk_team)
  return hids
end

userdata.setSquadSealland1 = function(l_23_0)
  userdata.setSquad(userdata.squadkeys.sealland1, l_23_0)
end

userdata.getSquadSealland1 = function()
  local hids = userdata.getSquad(userdata.squadkeys.sealland1)
  return hids
end

userdata.setSquadSealland2 = function(l_25_0)
  userdata.setSquad(userdata.squadkeys.sealland2, l_25_0)
end

userdata.getSquadSealland2 = function()
  local hids = userdata.getSquad(userdata.squadkeys.sealland2)
  return hids
end

userdata.setSquadSealland3 = function(l_27_0)
  userdata.setSquad(userdata.squadkeys.sealland3, l_27_0)
end

userdata.getSquadSealland3 = function()
  local hids = userdata.getSquad(userdata.squadkeys.sealland3)
  return hids
end

userdata.setSquadSealland4 = function(l_29_0)
  userdata.setSquad(userdata.squadkeys.sealland4, l_29_0)
end

userdata.getSquadSealland4 = function()
  local hids = userdata.getSquad(userdata.squadkeys.sealland4)
  return hids
end

userdata.setSquadSealland5 = function(l_31_0)
  userdata.setSquad(userdata.squadkeys.sealland5, l_31_0)
end

userdata.getSquadSealland5 = function()
  local hids = userdata.getSquad(userdata.squadkeys.sealland5)
  return hids
end

userdata.setSquadSealland6 = function(l_33_0)
  userdata.setSquad(userdata.squadkeys.sealland6, l_33_0)
end

userdata.getSquadSealland6 = function()
  local hids = userdata.getSquad(userdata.squadkeys.sealland6)
  return hids
end

userdata.setSquadBrave = function(l_35_0)
  userdata.setSquad(userdata.squadkeys.brave_team, l_35_0)
end

userdata.getSquadBrave = function()
  local hids = userdata.getSquad(userdata.squadkeys.brave_team)
  return hids
end

userdata.setSquadArenadef = function(l_37_0)
  userdata.setSquad(userdata.squadkeys.arenadef_team, l_37_0)
end

userdata.getSquadArenadef = function()
  local hids = userdata.getSquad(userdata.squadkeys.arenadef_team)
  return hids
end

userdata.setSquadFrdArena = function(l_39_0)
  userdata.setSquad(userdata.squadkeys.frdarena_team, l_39_0)
end

userdata.getSquadFrdArena = function()
  local hids = userdata.getSquad(userdata.squadkeys.frdarena_team)
  return hids
end

userdata.setSquadDailyFight = function(l_41_0)
  userdata.setSquad(userdata.squadkeys.dailyfight_team, l_41_0)
end

userdata.getSquadDailyFight = function()
  local hids = userdata.getSquad(userdata.squadkeys.dailyfight_team)
  return hids
end

userdata.setSquadAirisland = function(l_43_0)
  userdata.setSquad(userdata.squadkeys.airisland_team, l_43_0)
end

userdata.getSquadAirisland = function()
  local hids = userdata.getSquad(userdata.squadkeys.airisland_team)
  return hids
end

userdata.setSquadFriend = function(l_45_0)
  userdata.setSquad(userdata.squadkeys.friend_team, l_45_0)
end

userdata.getSquadFriend = function()
  local hids = userdata.getSquad(userdata.squadkeys.friend_team)
  return hids
end

userdata.setSquadArena3v3Def = function(l_47_0)
  userdata.setSquad(userdata.squadkeys.arena3v3_team, l_47_0, 18)
end

userdata.getSquadArena3v3Def = function()
  local hids = userdata.getSquad(userdata.squadkeys.arena3v3_team)
  return hids
end

userdata.setSquadArena3v3Atk = function(l_49_0)
  userdata.setSquad(userdata.squadkeys.arena3v3atk_team, l_49_0, 18)
end

userdata.getSquadArena3v3Atk = function()
  local hids = userdata.getSquad(userdata.squadkeys.arena3v3atk_team)
  return hids
end

userdata.setSquadguildmill = function(l_51_0)
  userdata.setSquad(userdata.squadkeys.guildmillatk_team, l_51_0)
end

userdata.getSquadguildmill = function()
  local hids = userdata.getSquad(userdata.squadkeys.guildmillatk_team)
  return hids
end

userdata.setSquadguildmilldef = function(l_53_0)
  userdata.setSquad(userdata.squadkeys.guildmill_team, l_53_0)
end

userdata.getSquadguildmilldef = function()
  local hids = userdata.getSquad(userdata.squadkeys.guildmill_team)
  return hids
end

userdata.setGuildFight = function(l_55_0)
  userdata.setSquad(userdata.squadkeys.guild_fight_team, l_55_0)
end

userdata.getGuildFight = function()
  local hids = userdata.getSquad(userdata.squadkeys.guild_fight_team)
  return hids
end

userdata.setSquadBrokenboss = function(l_57_0)
  userdata.setSquad(userdata.squadkeys.broken_boss_team, l_57_0)
end

userdata.getSquadBrokenboss = function()
  local hids = userdata.getSquad(userdata.squadkeys.broken_boss_team)
  return hids
end

userdata.setSquadSweepforbrokenboss = function(l_59_0)
  userdata.setSquad(userdata.squadkeys.sweepb_boss_team, l_59_0)
end

userdata.getSquadSweepforbrokenboss = function()
  local hids = userdata.getSquad(userdata.squadkeys.sweepb_boss_team)
  return hids
end

userdata.setSquadSweepforairisland = function(l_61_0)
  userdata.setSquad(userdata.squadkeys.sweepair_boss_team, l_61_0)
end

userdata.getSquadSweepforairisland = function()
  local hids = userdata.getSquad(userdata.squadkeys.sweepair_boss_team)
  return hids
end

userdata.setSquadSweepforcomisland = function(l_63_0)
  userdata.setSquad(userdata.squadkeys.sweepair_common_team, l_63_0)
end

userdata.getSquadSweepforcomisland = function()
  local hids = userdata.getSquad(userdata.squadkeys.sweepair_common_team)
  return hids
end

userdata.setSquadSweepforfboss = function(l_65_0)
  userdata.setSquad(userdata.squadkeys.sweepf_boss_team, l_65_0)
end

userdata.getSquadSweepforfboss = function()
  local hids = userdata.getSquad(userdata.squadkeys.sweepf_boss_team)
  return hids
end

userdata.clearWhenSwitchAccount = function()
  print("\230\136\145\232\166\129\230\184\133\231\144\134\239\188\140\230\136\145\232\166\129\229\136\135\230\156\141\229\138\161\229\153\168")
  local hids = {0, 0, 0, 0, 0, 0, -1}
  userdata.setSquadNormal(hids)
  userdata.setSquadTrial(hids)
  userdata.setSquadArenaatk(hids)
  userdata.setSquadArenadef(hids)
  userdata.setSquadGuildBoss(hids)
  userdata.setSquadGuildGray(hids)
  userdata.setSquadDailyFight(hids)
  userdata.setSquadAirisland(hids)
  userdata.setSquadFriend(hids)
  userdata.setSquadguildmill(hids)
  userdata.setSquadguildmilldef(hids)
  userdata.setSquadFrdArena(hids)
  userdata.setGuildFight(hids)
  userdata.setSquadFrdpk(hids)
  userdata.setSquadBrave(hids)
  userdata.setSquadBrokenboss(hids)
  userdata.setSquadSweepforbrokenboss(hids)
  userdata.setSquadSweepforairisland(hids)
  userdata.setSquadSweepforcomisland(hids)
  userdata.setSquadSweepforfboss(hids)
  userdata.setSquadSealland1(hids)
  userdata.setSquadSealland2(hids)
  userdata.setSquadSealland3(hids)
  userdata.setSquadSealland4(hids)
  userdata.setSquadSealland5(hids)
  userdata.setSquadSealland6(hids)
  userdata.setInt(userdata.keys.fightSpeed, 1)
  for i = 1, 18 do
    hids[i] = 0
  end
  for i = 19, 21 do
    hids[i] = -1
  end
  print("\230\184\133\231\169\186\233\152\178\229\190\161\230\149\180\229\174\185")
  userdata.setSquadArena3v3Def(hids)
  userdata.setSquadArena3v3Atk(hids)
  local petData = require("data.pet")
  petData.sele = nil
end

return userdata

