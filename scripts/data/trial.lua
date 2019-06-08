-- Command line was: E:\github\dhgametool\scripts\data\trial.lua 

local trial = {}
trial.init = function(l_1_0)
  trial.stage = l_1_0.id
  trial.tl = l_1_0.tl
  if l_1_0.cd then
    trial.cd = l_1_0.cd + os.time()
  else
    trial.cd = os.time() + 1800
  end
end

trial.win = function()
  trial.stage = trial.stage + 1
end

trial.lose = function()
  trial.tl = trial.tl - 1
  if trial.tl == 9 then
    trial.cd = os.time() + 1800
  end
end

trial.initVideo = function(l_4_0)
  trial.videos = l_4_0
  trial.video_stage = trial.stage
end

return trial

