-- Command line was: E:\github\dhgametool\scripts\data\sealland.lua 

local sealLand = {}
local config = require("config.sealland")
local DAILY_FREE_CHALLENGE_TIMES = 10
local MAX_BUY_SWEEP_TIMES = 10
local hasChallengeTimes = 0
local buyChallengeTimes = 0
local buySweepTimes = 0
local baseSweepTimes = 0
local hasSweepTimes = 0
local cd = 0
local pullTime = 0
local levels = {1, 1, 1, 1, 1, 1}
local levelCount = {1, 1, 1, 1, 1, 1}
sealLand.init = function(l_1_0, l_1_1)
  hasChallengeTimes = l_1_1.lose or 0
  upvalue_512 = l_1_1.challenge_buy or 0
  upvalue_1024 = l_1_1.sweep_buy or 0
  upvalue_1536 = 2
  upvalue_2048 = l_1_1.sweep_times or 0
  upvalue_2560 = l_1_1.cd
  if l_1_1.stages then
    levels[1] = l_1_1.stages[1]
    levels[2] = l_1_1.stages[2]
    levels[3] = l_1_1.stages[3]
    levels[4] = l_1_1.stages[4]
    levels[5] = l_1_1.stages[5]
    levels[6] = l_1_1.stages[6]
  end
  for i = 1, #levels do
    local count = levels[i] % 1000 - 1
    if count >= 10 then
      upvalue_1536 = 5
     -- DECOMPILER ERROR: unhandled construct in 'if'

    elseif count >= 6 and baseSweepTimes < 4 then
      upvalue_1536 = 4
      do return end
      if count >= 3 and baseSweepTimes < 3 then
        upvalue_1536 = 3
      end
    end
  end
  for k,v in pairs(config) do
    levelCount[v.type] = math.max(levelCount[v.type], k)
  end
  upvalue_4608 = os.time()
end

sealLand.availableSweepTimes = function(l_2_0)
  return baseSweepTimes + buySweepTimes - hasSweepTimes
end

sealLand.availableChallengeTimes = function(l_3_0)
  return DAILY_FREE_CHALLENGE_TIMES + buyChallengeTimes - hasChallengeTimes
end

sealLand.sweep = function(l_4_0, l_4_1)
  hasSweepTimes = hasSweepTimes + l_4_1
end

sealLand.win = function(l_5_0, l_5_1)
  hasChallengeTimes = hasChallengeTimes + 1
  if l_5_0:checkCamp(l_5_1) then
    for k,v in pairs(config) do
      if k == levels[l_5_1] then
        levels[l_5_1] = v.next
      end
    end
  end
end

sealLand.lose = function(l_6_0, l_6_1)
  hasChallengeTimes = hasChallengeTimes + 1
end

sealLand.buySweep = function(l_7_0, l_7_1)
  if l_7_1 < 0 or MAX_BUY_SWEEP_TIMES < buySweepTimes + l_7_1 then
    return 
  end
  buySweepTimes = buySweepTimes + l_7_1
end

sealLand.buyChallenge = function(l_8_0, l_8_1)
  if l_8_1 < 0 then
    return 
  end
  buyChallengeTimes = buyChallengeTimes + l_8_1
end

sealLand.availableBuySweepTimes = function(l_9_0)
  local times = MAX_BUY_SWEEP_TIMES - buySweepTimes
  if times <= 0 then
    times = 0
  end
  return times
end

sealLand.getBuySweepTimes = function(l_10_0)
  return buySweepTimes
end

sealLand.cdTime = function(l_11_0)
  local currentCd = cd - (os.time() - pullTime)
  if currentCd <= 0 then
    cd = 86400
    upvalue_512 = os.time()
    upvalue_1024 = 0
    upvalue_1536 = 0
    upvalue_2048 = 0
    upvalue_2560 = 0
    return cd
  end
  return currentCd
end

sealLand.getCurrentLevel = function(l_12_0, l_12_1)
  if l_12_0:checkCamp(l_12_1) then
    return levels[l_12_1]
  end
  return 1
end

sealLand.getLevelCount = function(l_13_0, l_13_1)
  if l_13_0:checkCamp(l_13_1) then
    return levelCount[l_13_1] % 1000
  end
  return 1
end

sealLand.checkCamp = function(l_14_0, l_14_1)
  if l_14_1 > 0 and l_14_1 < 7 then
    return true
  end
  return false
end

return sealLand

