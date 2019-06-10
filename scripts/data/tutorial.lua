-- Command line was: E:\github\dhgametool\scripts\data\tutorial.lua 

local tutorial = {}
require("common.const")
require("common.func")
local cfgtutorial = require("config.tutorial")
local REQUIRED = 1
local OPTIONAL = 2
local names, stepNums, stepFlags, idMap, bitMap, forced, serverBits, curIds, curOffset, recordFlag = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
tutorial.init = function(l_1_0, l_1_1)
  recordFlag = l_1_0
  upvalue_512 = require("config.tutorial")
  UNLOCK_BLACKMARKET_LEVEL = 10
  if tutorial.getVersion() == 2 then
    l_1_0 = l_1_1
    upvalue_512 = require("config.tutorial_2")
    UNLOCK_BLACKMARKET_LEVEL = 1
  end
  upvalue_1536 = {}
  upvalue_2048 = {}
  upvalue_2560 = {}
  upvalue_3072 = {}
  upvalue_3584 = {}
  upvalue_4096 = {}
  upvalue_4608 = tutorial.decodeServerBits(l_1_0)
  upvalue_5120, upvalue_5632 = nil
  for id,t in ipairs(cfgtutorial) do
    if not arraycontains(names, t.name) then
      names[#names + 1] = t.name
    end
    if idMap[t.name] == nil then
      idMap[t.name] = {}
    end
    if idMap[t.name][t.step] == nil then
      idMap[t.name][t.step] = {}
    end
    table.insert(idMap[t.name][t.step], id)
    if t.bit then
      if bitMap[t.name] == nil then
        bitMap[t.name] = {}
      end
      if bitMap[t.name][t.step] == nil then
        bitMap[t.name][t.step] = t.bit
      end
    end
    if stepNums[t.name] == nil or stepNums[t.name] < t.step then
      stepNums[t.name] = t.step
    end
    if not forced[t.name] and t.forced == 1 then
      forced[t.name] = true
    end
  end
  for _,name in ipairs(names) do
    local stepNum = stepNums[name]
    if not forced[name] and tutorial.validate(name) then
      stepFlags[name] = stepNum
      for _,name in (for generator) do
      end
      local stepFlag = 0
      for n = stepNum, 1, -1 do
        if bitMap[name] and bitMap[name][n] and serverBits[bitMap[name][n]] == 1 then
          stepFlag = n
      else
        end
      end
      stepFlags[name] = stepFlag
    end
     -- Warning: missing end command somewhere! Added here
  end
end

tutorial.getConfig = function()
  return cfgtutorial
end

tutorial.getVersion = function()
  if recordFlag == 0 then
    return 2
  else
    return 1
  end
end

tutorial.validate = function(l_4_0)
  local lv = require("data.player").lv()
  local hookdata = require("data.hook")
  local pveStage = hookdata.getPveStageId()
  local hookStage = hookdata.getHookStage()
  for step,ids in ipairs(idMap[l_4_0]) do
    for _,id in ipairs(ids) do
      if (((cfgtutorial[id].lv and cfgtutorial[id].lv ~= lv) or not cfgtutorial[id].pveStage or cfgtutorial[id].pveStage ~= pveStage or cfgtutorial[id].hookStage and cfgtutorial[id].hookStage ~= hookStage)) then
        return false
      end
    end
  end
  return true
end

tutorial.decodeServerBits = function(l_5_0)
  do
    local bits = {}
    if l_5_0 and l_5_0 ~= 0 then
      bits[#bits + 1] = bit.band(1, l_5_0)
      l_5_0 = bit.brshift(l_5_0, 1)
    else
      return bits
    end
     -- Warning: missing end command somewhere! Added here
  end
end

tutorial.isFinished = function(l_6_0, l_6_1)
  if not l_6_1 then
    l_6_1 = 1
  end
  return l_6_1 <= stepFlags[l_6_0]
end

tutorial.finish = function(l_7_0, l_7_1)
  if not l_7_1 then
    l_7_1 = 1
  end
  if tutorial.is(l_7_0, l_7_1) and not tutorial.isFinished(l_7_0, l_7_1) then
    stepFlags[l_7_0] = l_7_1
    cclog("tutorial.finish [%s]=%d", l_7_0, l_7_1)
  end
end

tutorial.getExecuteId = function(l_8_0)
  if curIds == nil then
    for _,name in ipairs(names) do
      if not tutorial.isFinished(name, stepNums[name]) and tutorial.validate(name) then
        local ids = {}
        for step = 1, stepNums[name] do
          for _,id in ipairs(idMap[name][step]) do
            if cfgtutorial[id].condition == REQUIRED or not tutorial.isFinished(name, step) then
              table.insert(ids, id)
            end
          end
        end
        local offset = nil
        if #ids > 0 and cfgtutorial[ids[1]].layer == l_8_0 then
          offset = 1
        else
          for i,id in ipairs(ids) do
             -- DECOMPILER ERROR: unhandled construct in 'if'

            if cfgtutorial[id].condition ~= OPTIONAL and cfgtutorial[id].layer == l_8_0 then
              offset = i
              do return end
            end
          end
        end
        if offset then
          curIds = ids
          upvalue_4096 = offset
          tutorial.printCurIds()
          return curIds[curOffset]
        end
      end
    end
  end
  if curIds ~= nil and cfgtutorial[curIds[curOffset]].layer == l_8_0 then
    return curIds[curOffset]
  end
  return nil
end

tutorial.is = function(l_9_0, l_9_1)
  if not l_9_1 then
    l_9_1 = 1
  end
  if curIds and curOffset and curIds[curOffset] then
    local id = curIds[curOffset]
    return cfgtutorial[id].name == l_9_0 and cfgtutorial[id].step == l_9_1
  end
  return false
end

tutorial.exists = function()
  if curIds and curOffset and curIds[curOffset] then
    return true
  end
  return false
end

local nextCallback = nil
tutorial.setNextCallback = function(l_11_0)
  nextCallback = l_11_0
end

tutorial.goNext = function(l_12_0, l_12_1, l_12_2)
  if not l_12_1 then
    l_12_1 = 1
  end
  if tutorial.is(l_12_0, l_12_1) then
    local id = curIds[curOffset]
    local ids = idMap[l_12_0][l_12_1]
    if l_12_2 or ids[#ids] == id then
      tutorial.finish(l_12_0, l_12_1)
    end
    if curOffset == #curIds then
      upvalue_512, upvalue_1024 = nil
    else
      upvalue_1024 = curOffset + 1
    end
    nextCallback()
    return true
  end
  return false
end

tutorial.print = function()
  print("--------- tutorial --------- {")
  print("names: ", table.concat(names, ","))
  local serverBitStr = {}
  for i,bit in ipairs(serverBits) do
    table.insert(serverBitStr, string.format("[%d]=%d", i, bit))
  end
  print("serverBits:", table.concat(serverBitStr, " "))
  local bitMapStr = {}
  for _,name in ipairs(names) do
    local bits = bitMap[name]
    if bits then
      for step,bit in ipairs(bits) do
        table.insert(bitMapStr, string.format("%s[%d]=%d", name, step, bit))
      end
    end
  end
  print("bitMap:", table.concat(bitMapStr, " "))
  local stepNumStr = {}
  for _,name in ipairs(names) do
    table.insert(stepNumStr, string.format("%s=%d", name, stepNums[name]))
  end
  print("stepNums:", table.concat(stepNumStr, " "))
  local stepFlagStr = {}
  for _,name in ipairs(names) do
    table.insert(stepFlagStr, string.format("%s=%d", name, stepFlags[name]))
  end
  print("stepFlags:", table.concat(stepFlagStr, " "))
  local forcedStr = {}
  for _,name in ipairs(names) do
    if forced[name] then
      table.insert(forcedStr, name)
    end
  end
  print("forced:", table.concat(forcedStr, ","))
  print("idMap:")
  for _,name in ipairs(names) do
    local stepIds = idMap[name]
    for step,ids in ipairs(stepIds) do
      cclog("    %s[%d] = {%s}", name, step, table.concat(ids, ","))
    end
  end
  print("--------- tutorial --------- }")
end

tutorial.printCurIds = function()
  if curIds ~= nil then
    cclog("tutorial curIds = {%s}", table.concat(curIds, ","))
    cclog("tutorial curOffset = %d", curOffset)
  else
    print("tutorial curIds is nil!")
  end
end

tutorial.isComplete = function()
  if not TUTORIAL_ENABLE then
    return true
  end
  for _,name in ipairs(names) do
    if forced[name] and not tutorial.isFinished(name, stepNums[name]) then
      return false
    end
  end
  return true
end

return tutorial

