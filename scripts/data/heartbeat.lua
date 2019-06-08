-- Command line was: E:\github\dhgametool\scripts\data\heartbeat.lua 

local heart = {}
local NetClient = require("net.netClient")
netClient = NetClient:getInstance()
local scheduler = require("framework.scheduler")
heart.is_running = false
local HEARTBEAT_INTERVAL = 60
heart.run = function(l_1_0)
  heart.sid = l_1_0
  if heart.is_running then
    return 
  end
  heart.is_running = true
  heart.schedule()
end

heart.stop = function()
  if heart.schedule_handler then
    scheduler.unscheduleGlobal(heart.schedule_handler)
  end
  heart.schedule_handler = nil
  heart.is_running = false
end

heart.heart = function()
  netClient:heart_beat({sid = heart.sid, echo = 12344321})
  print("heart beat ----------- I'm alive.")
end

heart.schedule = function()
  if not heart.schedule_handler then
    heart.schedule_handler = scheduler.scheduleGlobal(heart.heart, HEARTBEAT_INTERVAL)
  end
end

return heart

