-- Command line was: E:\github\dhgametool\scripts\dhcomponents\tools\SchedulerUtil.lua 

local SchedulerUtil = {}
local director = cc.Director:sharedDirector()
local scheduler = director:getScheduler()
SchedulerUtil.init = function(l_1_0)
  l_1_0.scheduleIdMap = {}
end

SchedulerUtil.unscheduleAll = function(l_2_0)
  for scheduleId,_ in pairs(l_2_0.scheduleIdMap) do
    scheduler:unscheduleScriptEntry(scheduleId)
  end
  l_2_0.scheduleIdMap = {}
end

SchedulerUtil.unscheduleGlobal = function(l_3_0, l_3_1)
  if not l_3_0.scheduleIdMap[l_3_1] then
    return 
  end
  scheduler:unscheduleScriptEntry(l_3_1)
end

SchedulerUtil.scheduleUpdateGlobal = function(l_4_0, l_4_1)
  return l_4_0:scheduleGlobal(l_4_1, 0)
end

SchedulerUtil.scheduleGlobal = function(l_5_0, l_5_1, l_5_2)
  local scheduleId = scheduler:scheduleScriptFunc(l_5_1, l_5_2, false)
  l_5_0.scheduleIdMap[scheduleId] = true
  return scheduleId
end

SchedulerUtil.performWithDelayGlobal = function(l_6_0, l_6_1, l_6_2)
  local timer = 0
  local scheduleId = nil
  local update = function(l_1_0)
    timer = timer + l_1_0
    if time <= timer then
      scheduler:unscheduleScriptEntry(scheduleId)
      listener()
    end
   end
  scheduleId = l_6_0:scheduleUpdateGlobal(update)
  return scheduleId
end

SchedulerUtil:init()
return SchedulerUtil

