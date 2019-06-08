-- Command line was: E:\github\dhgametool\scripts\data\gskill.lua 

local gskill = {}
local cfgguildskill = require("config.guildskill")
local SkillType = {JOB1 = 1, JOB2 = 2, JOB3 = 3, JOB4 = 4, JOB5 = 5}
gskill.SkillType = SkillType
local jobs = {}
gskill.jobs = jobs
local ssort = function(l_1_0, l_1_1)
  return l_1_0.idx < l_1_1.idx
end

gskill.init = function()
  jobs = {}
  gskill.jobs = jobs
  for idx,skill in pairs(cfgguildskill) do
    cfgguildskill[idx].idx = idx
    cfgguildskill[idx].lv = 0
    local stype = cfgguildskill[idx].type
    if not jobs[stype] then
      jobs[stype] = {}
    end
    local _tbl = jobs[stype]
    _tbl[ _tbl + 1] = cfgguildskill[idx]
  end
  for ii = 1, 5 do
    table.sort(jobs[ii], ssort)
  end
end

gskill.initCode = function(l_3_0)
  if not l_3_0 then
    l_3_0 = 0
  end
  gskill.code = l_3_0
end

gskill.getCode = function(l_4_0)
  if not gskill.code then
    return 0
  end
  if l_4_0 == bit.band(l_4_0, gskill.code) then
    return 1
  end
  return 0
end

gskill.setCode = function(l_5_0)
  if not gskill.code then
    gskill.code = l_5_0
    return 
  end
  if l_5_0 == bit.band(l_5_0, gskill.code) then
    return 
  end
  gskill.code = gskill.code + l_5_0
end

gskill.resetJob = function(l_6_0)
  for k,v in ipairs(gskill.jobs[l_6_0]) do
    gskill.jobs[l_6_0][k].lv = 0
  end
  gskill.setCode(math.pow(2, l_6_0 - 1))
end

gskill.sync = function(l_7_0)
  gskill.init()
  if not l_7_0 or  l_7_0 <= 0 then
    return 
  end
  for ii = 1,  l_7_0 do
    cfgguildskill[l_7_0[ii].id].lv = l_7_0[ii].lv
  end
end

gskill.isLearned = function(l_8_0)
  if not l_8_0 then
    return false
  end
  local t_id = l_8_0 * 1000 + 101
  if not cfgguildskill[t_id] then
    return false
  end
  if cfgguildskill[t_id].lv > 0 then
    return true
  end
  return false
end

gskill.isLighten = function(l_9_0)
  if not cfgguildskill[l_9_0].preSkl then
    return true
  end
  local _pre_id = cfgguildskill[l_9_0].preSkl
  if cfgguildskill[_pre_id].lv and cfgguildskill[l_9_0].lvReq <= cfgguildskill[_pre_id].lv then
    return true
  end
  return false
end

gskill.testLock = function(l_10_0)
  if not cfgguildskill[l_10_0].preSkl then
    return false
  end
  local _pre_id = cfgguildskill[l_10_0].preSkl
  if cfgguildskill[_pre_id].lv and cfgguildskill[_pre_id].lv == cfgguildskill[l_10_0].lvReq then
    return true
  end
  return false
end

gskill.isFull = function(l_11_0)
  return l_11_0.lvMax <= l_11_0.lv
end

gskill.getBuffs = function(l_12_0)
  local buffs = {}
  local base_buffs = {}
  local base_effects = l_12_0.baseEffect
  for ii = 1,  base_effects do
    local _n, _v = buffString(base_effects[ii].type, base_effects[ii].num)
    base_buffs[ii] = {}
    base_buffs[ii].name = _n
    base_buffs[ii].value = _v
  end
  if l_12_0.lv <= 0 then
    buffs = base_buffs
    for ii = 1,  buffs do
      buffs[ii].gvalue = buffs[ii].value
      buffs[ii].value = 0
    end
  else
    local effects = l_12_0.growEffect
    for ii = 1,  effects do
      local _n, _v = buffString(effects[ii].type, base_effects[ii].num + effects[ii].num * (l_12_0.lv - 1))
      buffs[ii] = {}
      buffs[ii].name = _n
      buffs[ii].value = _v
      if gskill.isFull(l_12_0) then
        buffs[ii].gvalue = nil
      else
        local g_n, g_v = buffString(effects[ii].type, base_effects[ii].num + effects[ii].num * (l_12_0.lv - 0))
        buffs[ii].gvalue = g_v
      end
    end
  end
  return buffs
end

gskill.getBuffsEffects = function(l_13_0)
  local buffs = {}
  local base_buffs = {}
  local base_effects = l_13_0.baseEffect
  for ii = 1,  base_effects do
    base_buffs[ii] = {}
    base_buffs[ii].type = base_effects[ii].type
    base_buffs[ii].num = base_effects[ii].num
  end
  if l_13_0.lv <= 0 then
    buffs = base_buffs
    for ii = 1,  buffs do
      buffs[ii].num = 0
    end
  else
    local effects = l_13_0.growEffect
    for ii = 1,  effects do
      buffs[ii] = {}
      buffs[ii].type = effects[ii].type
      buffs[ii].num = base_effects[ii].num + effects[ii].num * (l_13_0.lv - 1)
    end
  end
  return buffs
end

gskill.getCost = function(l_14_0)
  local coin_cost, gcoin_cost = 0, 0
  if l_14_0.lv <= 0 then
    coin_cost = l_14_0.baseGold
    gcoin_cost = l_14_0.baseGuildCoin
  else
    coin_cost = l_14_0.baseGold + (l_14_0.lv - 0) * l_14_0.growGold
    gcoin_cost = l_14_0.baseGuildCoin + (l_14_0.lv - 0) * l_14_0.growGuildCoin
  end
  return coin_cost, gcoin_cost
end

return gskill

