-- Command line was: E:\github\dhgametool\scripts\data\task.lua 

local task = {}
local dailytask = require("config.dailytask")
local player = require("data.player")
local i18n = require("res.i18n")
local bagdata = require("data.bag")
local NetClient = require("net.netClient")
netClient = NetClient:getInstance()
local TaskType = {MIDAS = 1, FRIEND_HEART = 2, CASINO = 3, HERO_TASK = 4, FORGE = 5, BASIC_SUMMON = 6, SENIOR_SUMMON = 7, ARENA = 8, HOOK_GET = 9, CHALLENGE = 11, ALL = 99}
task.TaskType = TaskType
task.tasks = {}
task.expire = 0
task.is_pulled = false
task.pull_time = os.time()
local OK = 0
local ERROR = -1
local TIMEOUT = -100
local total_taskId = TaskType.ALL
task.initFromCfg = function()
  task.tasks = {}
  for idx,o_task in pairs(dailytask) do
    local _task = clone(o_task)
    _task.id = idx
    _task.count = 0
    _task.is_claim = 0
    _task.total = _task.completeValue
    task.tasks[idx] = _task
  end
end

task.findFromCfgById = function(l_2_0)
  for idx,_task in pairs(dailytask) do
    if idx == l_2_0 then
      return clone(_task)
    end
  end
end

task.findFromDataById = function(l_3_0)
  for idx,_task in pairs(task.tasks) do
    if _task.id == l_3_0 then
      return _task
    end
  end
end

task.unlockTask = function(l_4_0)
  if not task.tasks[l_4_0] then
    local tmp_task = task.findFromCfgById(l_4_0)
    if tmp_task then
      tmp_task.id = l_4_0
      tmp_task.count = 0
      tmp_task.is_claim = 0
      tmp_task.total = tmp_task.completeValue
      task.tasks[l_4_0] = tmp_task
    end
  end
end

task.getTotalTaskId = function()
  return total_taskId
end

local delTaskByTaskId = function(l_6_0)
  for idx,__ in pairs(task.tasks) do
    if idx == l_6_0 then
      task.tasks[idx] = nil
  else
    end
  end
end

task.setCD = function(l_7_0)
  task.cd = l_7_0 or 0
end

task.getCD = function()
  return task.cd or 0
end

task.refresh = function()
  task.syncInit()
  task.cd = 86400
  task.pull_time = os.time()
end

task.syncInit = function(l_10_0)
  task.pull_time = os.time()
  task.initFromCfg()
  local any_unlock = false
  if player.lv() < UNLOCK_SMITH_LEVEL then
    delTaskByTaskId(TaskType.FORGE)
    any_unlock = true
  end
  if player.lv() < UNLOCK_MIDAS_LEVEL then
    delTaskByTaskId(TaskType.MIDAS)
    any_unlock = true
  end
  if player.lv() < UNLOCK_CASINO_LEVEL then
    delTaskByTaskId(TaskType.CASINO)
    any_unlock = true
  end
  if player.lv() < UNLOCK_ARENA_LEVEL then
    delTaskByTaskId(TaskType.ARENA)
    any_unlock = true
  end
  if player.lv() < UNLOCK_CHALLENGE_LEVEL then
    delTaskByTaskId(TaskType.CHALLENGE)
    any_unlock = true
  end
  if player.lv() < UNLOCK_TAVERN_LEVEL then
    delTaskByTaskId(TaskType.HERO_TASK)
    any_unlock = true
  end
  if not any_unlock then
    print("=================unlockTask all==================")
    task.unlockTask(TaskType.ALL)
  else
    print("=================lockTask all==================")
    delTaskByTaskId(TaskType.ALL)
  end
  if not l_10_0 or not l_10_0.tasks then
    return 
  end
  local completed = 0
  for ii = 1, #l_10_0.tasks do
    local tid = l_10_0.tasks[ii].id
    local d_task = task.findFromDataById(tid)
    if d_task then
      d_task.is_claim = l_10_0.tasks[ii].is_claim
      d_task.count = l_10_0.tasks[ii].count
      if d_task.completeValue <= d_task.count then
        d_task.count = d_task.completeValue
        d_task.isCompleted = true
        completed = completed + 1
      else
        d_task.isCompleted = false
      end
    end
  end
  task.checkAll()
end

task.checkLv = function()
  if UNLOCK_SMITH_LEVEL <= player.lv() then
    task.unlockTask(TaskType.FORGE)
  end
  if UNLOCK_MIDAS_LEVEL <= player.lv() then
    task.unlockTask(TaskType.MIDAS)
  end
  if UNLOCK_CASINO_LEVEL <= player.lv() then
    task.unlockTask(TaskType.CASINO)
  end
  if UNLOCK_ARENA_LEVEL <= player.lv() then
    task.unlockTask(TaskType.ARENA)
  end
  if UNLOCK_CHALLENGE_LEVEL <= player.lv() then
    task.unlockTask(TaskType.CHALLENGE)
  end
  if UNLOCK_TAVERN_LEVEL <= player.lv() then
    task.unlockTask(TaskType.HERO_TASK)
    task.unlockTask(TaskType.ALL)
  else
    return 
  end
end

task.checkAll = function()
  task.checkLv()
  local a_task = task.findFromDataById(TaskType.ALL)
  if not a_task then
    return 
  end
  local completed = 0
  local task_count = 0
  for k,v in pairs(TaskType) do
    if v ~= TaskType.ALL then
      task_count = task_count + 1
      if not task.tasks[v] then
        return 
        for k,v in (for generator) do
        end
        if task.tasks[v].count < task.tasks[v].total then
          for k,v in (for generator) do
          end
          completed = completed + 1
        end
      end
      a_task.count = completed
      a_task.total = task_count
      if a_task.total <= a_task.count then
        a_task.count = a_task.total
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

local sortValue = function(l_13_0)
  if l_13_0.id == total_taskId then
    return 20000
  elseif l_13_0.is_claim == 1 then
    return 10000 + l_13_0.id
  else
    if l_13_0.count < l_13_0.total then
      return 5000 + l_13_0.id
    else
      return l_13_0.id
    end
  end
end

task.sort = function(l_14_0, l_14_1)
  return sortValue(l_14_0) < sortValue(l_14_1)
end

task.getTask = function()
  return task.tasks
end

task.increment = function(l_16_0, l_16_1)
  task.checkLv()
  if not l_16_1 then
    l_16_1 = 1
  end
  local is_it_completed = false
  local d_task = task.findFromDataById(l_16_0)
  if not d_task then
    return 
  end
  d_task.count = d_task.count + l_16_1
  if d_task.total <= d_task.count then
    d_task.count = d_task.total
    d_task.isCompleted = true
  end
  task.checkAll()
  return is_it_completed
end

task.showRedDot = function()
  if player.lv() < UNLOCK_TASK_LEVEL then
    return false
  end
  for idx,__ in pairs(task.tasks) do
    if task.tasks[idx].isCompleted ~= true and task.tasks[idx].is_claim ~= 0 then
      return true
    end
  end
  return false
end

task.claim = function(l_18_0, l_18_1)
  netClient:task_claim(l_18_0, l_18_1)
end

task.claim_del = function(l_19_0, l_19_1)
  tbl2string(l_19_0)
  local params = {sid = player.sid, id = l_19_0.id}
  addWaitNet()
  netClient:task_claim(params, function(l_1_0)
    tbl2string(l_1_0)
    delWaitNet()
    if l_1_0.status ~= 0 then
      showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
      if callback then
        callback(ERROR)
      end
      return 
    end
    local tmp_bag = reward2Pbbag(obj.reward)
    bagdata.addRewards(tmp_bag)
    obj.is_claim = 1
    if callback then
      callback(OK, tmp_bag)
    end
   end)
end

return task

