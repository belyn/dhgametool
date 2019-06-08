-- Command line was: E:\github\dhgametool\scripts\fight\helper\buff.lua 

local helper = {}
require("common.func")
require("common.const")
local cfgbuff = require("config.buff")
local dots = {BUFF_DOT, BUFF_DOT_FIRE, BUFF_DOT_POISON, BUFF_DOT_BLOOD, BUFF_DOT_THU, BUFF_DOT_SHADOWF, BUFF_DOT_BLAST}
local dmgs = {BUFF_HURT, BUFF_TRUE_HURT, BUFF_ADD_HURT}
local heals = {BUFF_HEAL}
local controls = {BUFF_STUN, BUFF_STONE, BUFF_ICE, BUFF_FORBID, BUFF_WEAK, BUFF_FEAR, BUFF_HPBELOW_FEAR}
local roots = {BUFF_STUN, BUFF_STONE, BUFF_ICE}
local impresses = {BUFF_RIMPRESS, BUFF_CIMPRESS, BUFF_FIMPRESS, BUFF_OIMPRESS, BUFF_KIMPRESS, BUFF_SIMPRESS}
local impressesB = {"cImpressB", "rImpressB"}
helper.id = function(l_1_0)
  if l_1_0 then
    return buffname2id(l_1_0)
  end
  return nil
end

helper.name = function(l_2_0)
  if l_2_0 and cfgbuff[l_2_0] then
    return cfgbuff[l_2_0].name
  end
  return nil
end

helper.isAttrib = function(l_3_0)
  return require("fight.helper.attr").isAttrib(l_3_0)
end

helper.isAttribId = function(l_4_0)
  if cfgbuff[l_4_0] then
    return helper.isAttrib(cfgbuff[l_4_0].name)
  end
end

helper.isDot = function(l_5_0)
  return arraycontains(dots, l_5_0)
end

helper.isDotId = function(l_6_0)
  if cfgbuff[l_6_0] then
    return arraycontains(dots, cfgbuff[l_6_0].name)
  end
end

helper.isDmg = function(l_7_0)
  return arraycontains(dmgs, l_7_0)
end

helper.isDmgId = function(l_8_0)
  if cfgbuff[l_8_0] then
    return arraycontains(dmgs, cfgbuff[l_8_0].name)
  end
end

helper.isHeal = function(l_9_0)
  return arraycontains(heals, l_9_0)
end

helper.isHealId = function(l_10_0)
  if cfgbuff[l_10_0] then
    return arraycontains(heals, cfgbuff[l_10_0].name)
  end
end

helper.isControl = function(l_11_0)
  return arraycontains(controls, l_11_0)
end

helper.isControlId = function(l_12_0)
  if cfgbuff[l_12_0] then
    return arraycontains(controls, cfgbuff[l_12_0].name)
  end
end

helper.isImpress = function(l_13_0)
  return arraycontains(impresses, l_13_0)
end

helper.isImpressB = function(l_14_0)
  return arraycontains(impressesB, l_14_0)
end

helper.isImpressId = function(l_15_0)
  if cfgbuff[l_15_0] then
    return arraycontains(impresses, cfgbuff[l_15_0].name)
  end
end

helper.isRoot = function(l_16_0)
  return arraycontains(roots, l_16_0)
end

helper.isRootId = function(l_17_0)
  if cfgbuff[l_17_0] then
    return arraycontains(roots, cfgbuff[l_17_0].name)
  end
end

helper.add = function(l_18_0, l_18_1, l_18_2)
  if helper.isImpressId(l_18_1) then
    for ii = 1,  l_18_0.buffs do
      local _b = l_18_0.buffs[ii]
      if not _b.count then
        _b.count = (_b.id ~= l_18_1 or 1) + 1
        return 
      end
      l_18_0.buffs[ l_18_0.buffs + 1] = {id = l_18_1, name = cfgbuff[l_18_1].name, value = l_18_2 or 0, count = 1}
    else
      if not l_18_2 then
        l_18_0.buffs[ l_18_0.buffs + 1] = {id = l_18_1, name = cfgbuff[l_18_1].name, value = arraycontains(helper.states(l_18_0), cfgbuff[l_18_1].name) or 0}
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

helper.removeAllDot = function(l_19_0)
  arrayfilter(l_19_0.buffs, function(l_1_0)
    if helper.isDot(l_1_0.name) then
      return false
    else
      return true
    end
   end)
end

helper.del = function(l_20_0, l_20_1, l_20_2)
  for i,b in ipairs(l_20_0.buffs) do
    if b.id == l_20_1 and (not helper.isAttrib(b.name) or b.value * l_20_2 > 0) then
      if b.count and b.count > 0 then
        b.count = b.count - 1
        if b.name == BUFF_CIMPRESS then
          b.count = 0
        end
        if b.count <= 0 then
          table.remove(l_20_0.buffs, i)
          return 
        else
          table.remove(l_20_0.buffs, i)
        end
        return 
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

helper.clear = function(l_21_0)
  l_21_0.buffs = {}
end

helper.controls = function()
  return controls
end

helper.impresses = function()
  return impresses
end

helper.states = function(l_24_0)
  do
    local states = {}
    if l_24_0.buffs then
      for _,b in ipairs(l_24_0.buffs) do
        if arraycontains(controls, b.name) and not arraycontains(states, b.name) then
          states[ states + 1] = b.name
          for _,b in (for generator) do
          end
          if arraycontains(impresses, b.name) and not arraycontains(states, b.name) then
            states[ states + 1] = b.name
          end
        end
      end
      return states
    end
     -- Warning: missing end command somewhere! Added here
  end
end

helper.isRooted = function(l_25_0)
  if l_25_0.buffs then
    for _,b in ipairs(l_25_0.buffs) do
      if arraycontains(roots, b.name) then
        return true
      end
    end
  end
  return false
end

return helper

