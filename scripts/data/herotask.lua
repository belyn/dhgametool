-- Command line was: E:\github\dhgametool\scripts\data\herotask.lua 

local herotask = {}
herotask.init = function(l_1_0)
  tbl2string(l_1_0)
  if not l_1_0.tasks then
    herotask.tasks = {}
  end
  if l_1_0.cd then
    herotask.cd = l_1_0.cd + os.time()
  end
  for i,v in ipairs(herotask.tasks) do
    v.cd = v.cd + os.time()
  end
  herotask.sortTask()
end

herotask.checkPull = function()
  if not herotask.cd or herotask.cd <= os.time() then
    return true
  end
  return false
end

herotask.changeLock = function(l_3_0)
  for i,v in ipairs(herotask.tasks) do
    if v.tid == l_3_0 then
      if v.lock and v.lock == 1 then
        herotask.tasks[i].lock = 0
      else
        herotask.tasks[i].lock = 1
      end
  else
    end
  end
end

herotask.sortTask = function()
  local tasks = {}
  for i,v in ipairs(herotask.tasks) do
    if not v.heroes then
      tasks[ tasks + 1] = v
    end
  end
  for i,v in ipairs(herotask.tasks) do
    if v.heroes and v.cd and v.cd <= os.time() then
      tasks[ tasks + 1] = v
    end
  end
  for i,v in ipairs(herotask.tasks) do
    if v.cd and os.time() < v.cd then
      tasks[ tasks + 1] = v
    end
  end
  herotask.tasks = tasks
end

herotask.del = function(l_5_0)
  local tasks = {}
  for i,v in ipairs(herotask.tasks) do
    if v.tid ~= l_5_0 then
      tasks[ tasks + 1] = v
    end
  end
  herotask.tasks = tasks
end

herotask.add = function(l_6_0)
  local tasks = {}
  tasks[ tasks + 1] = l_6_0
  for i,v in ipairs(herotask.tasks) do
    tasks[ tasks + 1] = v
  end
  herotask.tasks = tasks
end

herotask.showRedDot = function()
  if herotask.tasks then
    for i,v in ipairs(herotask.tasks) do
      if v.heroes and v.cd <= os.time() then
        return true
      end
    end
  end
  return false
end

return herotask

