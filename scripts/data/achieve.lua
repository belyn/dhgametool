-- Command line was: E:\github\dhgametool\scripts\data\achieve.lua 

local achieve = {}
local cfgachieve = require("config.achievement")
achieve.clear = function()
  achieve.achieveInfos = nil
end

achieve.init = function(l_2_0)
  tbl2string(l_2_0)
  local achieveInfos = {}
  if not l_2_0.id then
    local ids = {}
  end
  for _,v in pairs(cfgachieve) do
    if v.isBornAchieve > 0 then
      achieveInfos[v.completeType] = {id = _, num = l_2_0.num[v.completeType], isComplete = false}
      if l_2_0.curnum and v.completeType == ACHIEVE_TYPE_AFRICA then
        achieveInfos[ACHIEVE_TYPE_AFRICA].curnum = l_2_0.curnum[1]
      end
    end
  end
  local hash = {}
  for i,v in ipairs(ids) do
    hash[v] = true
  end
  for i,v in ipairs(achieveInfos) do
    for j = 1, 200 do
      if (cfgachieve[v.id].nextAchieveId == 0 or not hash[v.id]) and hash[v.id] then
        v.isComplete = true
        for i,v in (for generator) do
          do return end
          v = {id = cfgachieve[v.id].nextAchieveId, num = l_2_0.num[i], isComplete = false}
          if l_2_0.curnum and i == ACHIEVE_TYPE_AFRICA then
            v.curnum = l_2_0.curnum[1]
          end
          achieveInfos[i] = v
        end
         -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end
    end
    achieve.achieveInfos = achieveInfos
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

     -- Warning: missing end command somewhere! Added here
  end
end

achieve.claim = function(l_3_0)
  local achieveInfos = achieve.achieveInfos
  if cfgachieve[l_3_0].nextAchieveId == 0 then
    achieveInfos[cfgachieve[l_3_0].completeType].isComplete = true
  else
    if cfgachieve[l_3_0].completeType == ACHIEVE_TYPE_AFRICA and achieveInfos[cfgachieve[l_3_0].completeType].curnum then
      achieveInfos[cfgachieve[l_3_0].completeType] = {num = achieveInfos[cfgachieve[l_3_0].completeType].num, isComplete = false, id = cfgachieve[l_3_0].nextAchieveId, curnum = achieveInfos[cfgachieve[l_3_0].completeType].curnum}
    else
      achieveInfos[cfgachieve[l_3_0].completeType] = {num = achieveInfos[cfgachieve[l_3_0].completeType].num, isComplete = false, id = cfgachieve[l_3_0].nextAchieveId}
    end
  end
end

achieve.add = function(l_4_0, l_4_1)
  if achieve and achieve.achieveInfos and achieve.achieveInfos[l_4_0] and achieve.achieveInfos[l_4_0].num then
    achieve.achieveInfos[l_4_0].num = achieve.achieveInfos[l_4_0].num + l_4_1
  end
  require("data.appsflyer").addAchieve(l_4_0, l_4_1)
end

achieve.addCasino = function(l_5_0)
  if not l_5_0 then
    return 
  end
  if not l_5_0.items or  l_5_0.items <= 0 then
    return 
  end
  local cfgitem = require("config.item")
  local count = 0
  for ii = 1,  l_5_0.items do
    local tmp_id = l_5_0.items[ii].id
    local tmp_item = cfgitem[tmp_id]
    if not tmp_item then
      return 
    end
    if tmp_item.type == ITEM_KIND_HERO_PIECE and tmp_item.qlt == QUALITY_5 then
      count = count + 1
    end
  end
  achieve.add(ACHIEVE_TYPE_CASINO, count)
end

achieve.set = function(l_6_0, l_6_1)
  if achieve and achieve.achieveInfos then
    achieve.achieveInfos[l_6_0].num = l_6_1
  end
  require("data.appsflyer").setAchieve(l_6_0, l_6_1)
end

achieve.addSummonForAf = function(l_7_0)
  if l_7_0 == 0 then
    achieve.achieveInfos[ACHIEVE_TYPE_AFRICA].curnum = 0
  else
    achieve.achieveInfos[ACHIEVE_TYPE_AFRICA].curnum = achieve.achieveInfos[ACHIEVE_TYPE_AFRICA].curnum + l_7_0
    if achieve.achieveInfos[ACHIEVE_TYPE_AFRICA].num <= achieve.achieveInfos[ACHIEVE_TYPE_AFRICA].curnum then
      achieve.set(ACHIEVE_TYPE_AFRICA, achieve.achieveInfos[ACHIEVE_TYPE_AFRICA].curnum)
    end
  end
end

achieve.showRedDot = function()
  if achieve and achieve.achieveInfos then
    for i,v in ipairs(achieve.achieveInfos) do
      if cfgachieve[v.id].completeValue <= v.num and not v.isComplete then
        return true
      end
    end
  end
  return false
end

return achieve

