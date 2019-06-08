-- Command line was: E:\github\dhgametool\scripts\data\activitylimit.lua 

local activitylimit = {}
local player = require("data.player")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local cfglimitgift = require("config.limitgift")
local cfgactivity = require("config.activity")
activitylimit.pull_time = os.time()
local IDS = {GRADE_24 = {ID = 21, pull = true}, GRADE_32 = {ID = 22, pull = true}, GRADE_48 = {ID = 23, pull = true}, GRADE_58 = {ID = 24, pull = true}, GRADE_78 = {ID = 25, pull = true}, LEVEL_3_15 = {ID = 31, pull = true}, SUMMON_4 = {ID = 41, pull = true}, SUMMON_5 = {ID = 42, pull = true}}
activitylimit.IDS = IDS
local activitylimit_data = nil
activitylimit.init = function(l_1_0)
  activitylimit_data = l_1_0.status
  activitylimit.pull_time = os.time()
  if activitylimit_data then
    for ii = 1,  activitylimit_data do
      if activitylimit_data[ii].id <= 3 then
        do return end
      end
      if activitylimit_data[ii].cd and activitylimit_data[ii].cd > 0 then
        activitylimit_data[ii].read = 0
      end
    end
  end
end

activitylimit.showLimit = function()
  local activity = require("data.activity")
  if activitylimit_data and  activitylimit_data > 0 then
    for i = 1,  activitylimit_data do
      if activitylimit_data[i].status == 0 then
        return true
      end
    end
  end
  local fpay_status = activity.getStatusById(activity.IDS.FIRST_PAY.ID)
  if fpay_status and fpay_status.status ~= 2 and fpay_status.cd ~= 0 then
    return true
  end
  local sccasino_status = activity.getStatusById(activity.IDS.SCORE_CASINO.ID)
  if sccasino_status and sccasino_status.cd ~= 0 then
    return true
  end
  local scfight_status = activity.getStatusById(activity.IDS.SCORE_FIGHT.ID)
  if scfight_status and scfight_status.cd ~= 0 then
    return true
  end
  local valuepack_status = activity.getStatusById(activity.IDS.VP_1.ID)
  if valuepack_status and valuepack_status.cd ~= 0 then
    return true
  end
  local tarven_status = activity.getStatusById(activity.IDS.SCORE_TARVEN_4.ID)
  if tarven_status and tarven_status.cd ~= 0 then
    return true
  end
  local summon_status = activity.getStatusById(activity.IDS.SCORE_SUMMON.ID)
  if summo_status and summo_status.cd ~= 0 then
    return true
  end
  local crushing1_status = activity.getStatusById(activity.IDS.CRUSHING_SPACE_1.ID)
  if crushing1_status and crushing1_status.cd ~= 0 then
    return true
  end
  local crushing2_status = activity.getStatusById(activity.IDS.CRUSHING_SPACE_2.ID)
  if crushing2_status and crushing2_status.cd ~= 0 then
    return true
  end
  local crushing3_status = activity.getStatusById(activity.IDS.CRUSHING_SPACE_3.ID)
  if crushing3_status and crushing3_status.cd ~= 0 then
    return true
  end
  local fish_status = activity.getStatusById(activity.IDS.FISHBABY_1.ID)
  if fish_status and fish_status.cd ~= 0 then
    return true
  end
  local follow_status = activity.getStatusById(activity.IDS.FOLLOW.ID)
  if follow_status and follow_status.cd ~= 0 then
    return true
  end
  local spesummon_status = activity.getStatusById(activity.IDS.SCORE_SPESUMMON.ID)
  if spesummo_status and spesummo_status.cd ~= 0 then
    return true
  end
  local tenchange_status = activity.getStatusById(activity.IDS.TENCHANGE.ID)
  if tenchange_status and tenchange_status.cd ~= 0 then
    return true
  end
  local christmas_status = activity.getStatusById(activity.IDS.CHRISTMAS_1.ID)
  if christmas_status and christmas_status.cd ~= 0 then
    return true
  end
  local asylum_status = activity.getStatusById(activity.IDS.ASYLUM_1.ID)
  if asylum_status and asylum_status.cd ~= 0 then
    return true
  end
  local newyear_status = activity.getStatusById(activity.IDS.NEWYEAR.ID)
  if ewyear_status and ewyear_status.cd ~= 0 then
    return true
  end
  return false
end

activitylimit.addlimitAct = function(l_3_0)
  if not activitylimit_data then
    activitylimit_data = {}
  end
  for i = 1,  activitylimit_data do
    if activitylimit_data[i] == l_3_0 then
      return 
    end
    if activitylimit_data[i].id == l_3_0.id then
      activitylimit_data[i] = l_3_0
      return 
    end
  end
  activitylimit_data[ activitylimit_data + 1] = l_3_0
end

activitylimit.GradeNotice = function(l_4_0)
  if l_4_0 == cfglimitgift[activitylimit.IDS.GRADE_24.ID].parameter then
    local actdata = {}
    actdata.id = activitylimit.IDS.GRADE_24.ID
    actdata.limits = cfglimitgift[activitylimit.IDS.GRADE_24.ID].buyTimes
    actdata.cd = cfglimitgift[activitylimit.IDS.GRADE_24.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    activitylimit.addlimitAct(actdata)
  end
  if l_4_0 == cfglimitgift[activitylimit.IDS.GRADE_32.ID].parameter then
    local actdata = {}
    actdata.id = activitylimit.IDS.GRADE_32.ID
    actdata.limits = cfglimitgift[activitylimit.IDS.GRADE_32.ID].buyTimes
    actdata.cd = cfglimitgift[activitylimit.IDS.GRADE_32.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    activitylimit.addlimitAct(actdata)
  end
  if l_4_0 == cfglimitgift[activitylimit.IDS.GRADE_48.ID].parameter then
    local actdata = {}
    actdata.id = activitylimit.IDS.GRADE_48.ID
    actdata.limits = cfglimitgift[activitylimit.IDS.GRADE_48.ID].buyTimes
    actdata.cd = cfglimitgift[activitylimit.IDS.GRADE_48.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    activitylimit.addlimitAct(actdata)
  end
  if l_4_0 == cfglimitgift[activitylimit.IDS.GRADE_58.ID].parameter then
    local actdata = {}
    actdata.id = activitylimit.IDS.GRADE_58.ID
    actdata.limits = cfglimitgift[activitylimit.IDS.GRADE_58.ID].buyTimes
    actdata.cd = cfglimitgift[activitylimit.IDS.GRADE_58.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    activitylimit.addlimitAct(actdata)
  end
  if l_4_0 == cfglimitgift[activitylimit.IDS.GRADE_78.ID].parameter then
    local actdata = {}
    actdata.id = activitylimit.IDS.GRADE_78.ID
    actdata.limits = cfglimitgift[activitylimit.IDS.GRADE_78.ID].buyTimes
    actdata.cd = cfglimitgift[activitylimit.IDS.GRADE_78.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    activitylimit.addlimitAct(actdata)
  end
end

activitylimit.LevelNotice = function(l_5_0)
  local actdata = {}
  if l_5_0 == cfglimitgift[activitylimit.IDS.LEVEL_3_15.ID].parameter then
    actdata.id = activitylimit.IDS.LEVEL_3_15.ID
    actdata.limits = cfglimitgift[activitylimit.IDS.LEVEL_3_15.ID].buyTimes
    actdata.cd = cfglimitgift[activitylimit.IDS.LEVEL_3_15.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    activitylimit.addlimitAct(actdata)
  end
end

activitylimit.summonNotice = function(l_6_0)
  local actdata = {}
  if l_6_0 == 4 then
    actdata.id = activitylimit.IDS.SUMMON_4.ID
    actdata.limits = cfglimitgift[activitylimit.IDS.SUMMON_4.ID].buyTimes
    actdata.cd = cfglimitgift[activitylimit.IDS.SUMMON_4.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    actdata.next = cfglimitgift[activitylimit.IDS.SUMMON_4.ID].cd * 3600
    activitylimit.addlimitAct(actdata)
  else
    actdata.id = activitylimit.IDS.SUMMON_5.ID
    actdata.limits = cfglimitgift[activitylimit.IDS.SUMMON_5.ID].buyTimes
    actdata.cd = cfglimitgift[activitylimit.IDS.SUMMON_5.ID].lastHours * 60 * 60
    actdata.status = 0
    actdata.read = 0
    actdata.next = cfglimitgift[activitylimit.IDS.SUMMON_5.ID].cd * 3600
    activitylimit.addlimitAct(actdata)
  end
end

activitylimit.getStatusById = function(l_7_0)
  if not activitylimit_data then
    return nil
  end
  for ii = 1,  activitylimit_data do
    if activitylimit_data[ii].id == l_7_0 then
      return activitylimit_data[ii]
    end
  end
  return nil
end

activitylimit.showRedDot = function()
  if activitylimit_data and  activitylimit_data > 0 then
    for i = 1,  activitylimit_data do
      if activitylimit_data[i].read == 0 then
        return true
      end
    end
  end
  local activity = require("data.activity")
  if activity.showRedDotLimit() then
    return true
  end
  return false
end

activitylimit.getPullIds = function()
  local ids = {}
  for _,info in pairs(activitylimit.IDS) do
    if info.pull then
      ids[ ids + 1] = info.ID
    end
  end
  return ids
end

activitylimit.pay = function()
  if not activitylimit_data then
    return 
  end
  local tmp_status = activitylimit.getStatusById(IDS.FIRST_PAY.ID)
  if not tmp_status then
    return 
  end
  if tmp_status.status == 0 then
    tmp_status.status = 1
  end
end

activitylimit.anyNew = function()
  local monthloginData = require("data.monthlogin")
  if monthloginData.showRedDot() then
    return true
  end
  local shopData = require("data.shop")
  if shopData.showRedDot() then
    return true
  end
  if not activitylimit_data or  activitylimit_data == 0 then
    return false
  end
  for ii = 1,  activitylimit_data do
    if activitylimit_data[ii].read and activitylimit_data[ii].read == 0 then
      return true
    end
  end
  return false
end

activitylimit.setReadById = function(l_12_0)
  if not activitylimit_data then
    return nil
  end
  local tmp_status = activitylimit.getStatusById(l_12_0)
  if not tmp_status then
    print("can't find the activitylimit id:", l_12_0)
    return 
  end
  if tmp_status.read and tmp_status.read == 0 then
    tmp_status.read = 1
  end
end

activitylimit.print = function()
  print("--------- activitylimit --------- {")
  print("pull_time = ", activitylimit.pull_time)
  print("--- all status --- {")
  for _,info in pairs(activitylimit_data) do
    local str = {}
    table.insert(str, string.format("id:%d", info.id))
    if info.status then
      table.insert(str, string.format("status:%d", info.status))
    end
    if info.cd then
      table.insert(str, string.format("cd:%d", info.cd))
    end
    if info.limits then
      table.insert(str, string.format("limits:%d", info.limits))
    end
    if info.read then
      table.insert(str, string.format("read:%d", info.read))
    end
    print(table.concat(str, " "))
  end
  print("--- all status --- }")
  print("--------- activitylimit --------- }")
end

return activitylimit

