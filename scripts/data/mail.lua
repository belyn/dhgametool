-- Command line was: E:\github\dhgametool\scripts\data\mail.lua 

local mail = {}
local cfgmail = require("config.mail")
local player = require("data.player")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
mail.TYPE = {AFFIX = 1, ACTIVITY = 2, GUILD = 3, SYS = 4, PLAYER = 5, LINK = 6, ALLPLAYER = 7, LINK2 = 8}
mail.is_running = false
local player_mails = {}
local sys_mails = {}
mail.mails = {player_mails = player_mails, sys_mails = sys_mails}
mail.not_reads = 0
mail.showRedDot = function()
  if mail.mails and mail.mails.player_mails then
    local tmp_mails = mail.mails.player_mails
    for ii = 1, #tmp_mails do
      if tmp_mails[ii].flag ~= 0 then
        return true
      end
    end
  end
  if mail.mails and mail.mails.sys_mails then
    local tmp_mails = mail.mails.sys_mails
    for ii = 1, #tmp_mails do
      if tmp_mails[ii].flag ~= 0 then
        return true
      end
    end
  end
  return false
end

mail.getTypeById = function(l_2_0)
  if cfgmail[l_2_0] then
    return cfgmail[l_2_0].type
  else
    return nil
  end
end

local FLAGS = {0 = 0, 1 = 1, 2 = 2}
local mail_sort = function(l_3_0, l_3_1)
  if not l_3_0 and l_3_1 then
    return false
  elseif l_3_0 and not l_3_1 then
    return true
  elseif not l_3_0 and not l_3_1 then
    return true
  else
    if FLAGS[l_3_0.flag] < FLAGS[l_3_1.flag] then
      return true
    else
      if FLAGS[l_3_1.flag] < FLAGS[l_3_0.flag] then
        return false
      else
        if FLAGS[l_3_0.flag] == FLAGS[l_3_1.flag] then
          if cfgmail[l_3_0.id].type < cfgmail[l_3_1.id].type then
            return true
          else
            if cfgmail[l_3_1.id].type < cfgmail[l_3_0.id].type then
              return false
            else
              if l_3_1.send_time >= l_3_0.send_time then
                return cfgmail[l_3_0.id].type ~= cfgmail[l_3_1.id].type
              end
            end
          end
        end
      end
    end
  end
end

local addPlayerMail = function(l_4_0)
  if not player_mails then
    player_mails = {}
  end
  player_mails[#player_mails + 1] = l_4_0
  table.sort(player_mails, mail_sort)
end

local addSysMail = function(l_5_0)
  if not sys_mails then
    sys_mails = {}
  end
  sys_mails[#sys_mails + 1] = l_5_0
  table.sort(sys_mails, mail_sort)
end

local addMail = function(l_6_0)
  if not l_6_0 then
    return 
  end
  if not cfgmail[l_6_0.id] then
    return 
  end
  if cfgmail[l_6_0.id].type == mail.TYPE.PLAYER then
    addPlayerMail(l_6_0)
  else
    if cfgmail[l_6_0.id].type == mail.TYPE.ALLPLAYER then
      addPlayerMail(l_6_0)
    else
      addSysMail(l_6_0)
    end
  end
end

mail.addMails = function(l_7_0)
  if not l_7_0 then
    return 
  end
  for ii = 1, #l_7_0 do
    addMail(l_7_0[ii])
  end
end

mail.delPlayer = function(l_8_0)
  for ii = 1, #player_mails do
    if player_mails[ii] == l_8_0 then
      table.remove(player_mails, ii)
  else
    end
  end
end

mail.delSys = function(l_9_0)
  for ii = 1, #sys_mails do
    if sys_mails[ii] == l_9_0 then
      table.remove(sys_mails, ii)
  else
    end
  end
end

mail.netDel = function(l_10_0, l_10_1)
  local params = {sid = player.sid, deletes = {1 = l_10_0.mid}}
  netClient:op_mail(params, l_10_1)
end

mail.del = function(l_11_0)
  if not l_11_0 then
    return 
  end
  if cfgmail[l_11_0.id].type == mail.TYPE.PLAYER then
    mail.delPlayer(l_11_0)
  else
    if cfgmail[l_11_0.id].type == mail.TYPE.ALLPLAYER then
      mail.delPlayer(l_11_0)
    else
      mail.delSys(l_11_0)
    end
  end
end

mail.read = function(l_12_0, l_12_1)
  local params = {sid = player.sid, reads = {1 = l_12_0}}
  netClient:op_mail(params, l_12_1)
end

mail.block = function(l_13_0, l_13_1)
  local params = {sid = player.sid, blocks = {1 = l_13_0}}
  netClient:op_mail(params, l_13_1)
end

mail.affix = function(l_14_0, l_14_1)
  local params = {sid = player.sid, affixs = l_14_0}
  netClient:op_mail(params, l_14_1)
end

mail.flagByMids = function(l_15_0)
  for ii = 1, #l_15_0 do
    for jj = 1, #sys_mails do
      if sys_mails[jj].mid == l_15_0[ii] then
        sys_mails[jj].flag = 2
    else
      end
    end
  end
end

mail.send = function(l_16_0, l_16_1)
  netClient:send_mail(l_16_0, l_16_1)
end

mail.init = function(l_17_0)
  player_mails = {}
  upvalue_512 = {}
  mail.mails = {player_mails = player_mails, sys_mails = sys_mails}
  mail.addMails(l_17_0)
end

mail.getPlayerMails = function()
  table.sort(player_mails, mail_sort)
  return player_mails
end

mail.getSysMails = function()
  table.sort(sys_mails, mail_sort)
  return sys_mails
end

local onMail = function(l_20_0)
  cclog("onMail data")
  tbl2string(l_20_0)
  addMail(l_20_0)
end

local onOpMail = function(l_21_0)
  cclog("onOpMail data")
  tbl2string(l_21_0)
end

mail.registEvent = function()
  netClient:registMailEvent(onMail)
end

mail.print = function()
  if mail.mails then
    tbl2string(mail.mails)
  end
end

return mail

