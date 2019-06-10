-- Command line was: E:\github\dhgametool\scripts\data\heros.lua 

local heros = {}
require("common.func")
local cfghero = require("config.hero")
local cfgexphero = require("config.exphero")
local achieveData = require("data.achieve")
local activitydata = require("data.activity")
local attrHelper = require("fight.helper.attr")
local bag = require("data.bag")
heros.init = function(l_1_0)
  arrayclear(heros)
  if not l_1_0 then
    return 
  end
  for i,pb in ipairs(l_1_0) do
    local h = tablecp(pb)
    heros.adapt(h)
    heros[#heros + 1] = h
  end
end

heros.adapt = function(l_2_0)
  local cfg = cfghero[l_2_0.id]
  if not l_2_0.equips then
    l_2_0.equips = {}
  end
  l_2_0.attr = function()
      return attrHelper.attr(h)
      end
  return l_2_0
end

heros.add = function(l_3_0)
  local h = tablecp(l_3_0)
  heros.adapt(h)
  heros[#heros + 1] = h
  if cfghero[h.id].qlt == GROUP_4 then
    achieveData.add(ACHIEVE_TYPE_GET_HERO_STAR4, 1)
  end
  if cfghero[h.id].qlt == GROUP_5 then
    achieveData.add(ACHIEVE_TYPE_GET_HERO_STAR5, 1)
  end
  if cfghero[h.id].qlt == GROUP_6 then
    achieveData.add(ACHIEVE_TYPE_GET_HERO_STAR6, 1)
  end
  local herobook = require("data.herobook")
  herobook.add(h.id)
end

heros.addAllForReturn = function(l_4_0)
  for i,pb in ipairs(l_4_0) do
    local h = tablecp(pb)
    heros.adapt(h)
    heros[#heros + 1] = h
  end
end

heros.addAll = function(l_5_0)
  for i,pb in ipairs(l_5_0) do
    heros.add(pb)
  end
end

heros.find = function(l_6_0)
  for i,h in ipairs(heros) do
    if h.hid == l_6_0 then
      return h, i
    end
  end
end

heros.changeID = function(l_7_0, l_7_1)
  for i,h in ipairs(heros) do
    if h.hid == l_7_0 then
      heros[i].id = l_7_1
      local herobook = require("data.herobook")
      herobook.add(l_7_1)
      return 
    end
  end
end

heros.wakeUp = function(l_8_0, l_8_1)
  for i,h in ipairs(heros) do
    if h.hid == l_8_0 then
      if heros[i].wake == nil then
        heros[i].wake = 1
      else
        heros[i].wake = heros[i].wake + 1
        if heros[i].wake == 4 then
          heros[i].id = cfghero[l_8_1].nId
          local herobook = require("data.herobook")
          herobook.add(heros[i].id)
        end
      end
      return 
    end
  end
end

heros.tenchange = function(l_9_0, l_9_1)
  local cfglifechange = require("config.lifechange")
  for i,h in ipairs(heros) do
    if h.hid == l_9_0.hid then
      heros[i].id = cfglifechange[l_9_1].nId
      local herobook = require("data.herobook")
      herobook.add(heros[i].id)
    end
  end
end

heros.findById = function(l_10_0)
  local rt = {}
  for i,h in ipairs(heros) do
    if h.id == l_10_0 then
      rt[#rt + 1] = h
    end
  end
  return rt
end

heros.del = function(l_11_0, l_11_1)
  for i,h in ipairs(heros) do
    if h.hid == l_11_0 then
      if not l_11_1 then
        for j,v in ipairs(h.equips) do
          bag.equips.returnbag({id = v, num = 1})
        end
      end
      table.remove(heros, i)
      return h
    end
  end
end

heros.power = function(l_12_0)
  return heros.find(l_12_0).attr().power
end

heros.maxAttr = function(l_13_0)
  return attrHelper.attr({id = l_13_0}, cfghero[l_13_0].qlt, cfghero[l_13_0].maxLv, nil, true)
end

heros.decompose = function(l_14_0)
  local exp, evolve, rune = 0, 0, 0
  for i,v in ipairs(l_14_0) do
    heroData = heros.find(v)
    if heroData then
      exp = exp + cfghero[heroData.id].xpBase + 0.65 * cfgexphero[heroData.lv].allExp
      evolve = evolve + cfghero[heroData.id].tierBase
      for i = 1, heroData.star do
        evolve = evolve + 0.7 * cfghero[heroData.id].starExp" .. [1]
      end
      rune = rune + cfghero[heroData.id].rune
    end
  end
  return exp, evolve, rune
end

heros.decomposeForwake = function(l_15_0)
  local exp = 0
  for i,v in ipairs(l_15_0) do
    heroData = heros.find(v)
    if heroData then
      exp = exp + cfghero[heroData.id].xpBase + cfgexphero[heroData.lv].allExp
    end
  end
  return exp
end

heros.decomposeFortenchange = function(l_16_0)
  local exp, evolve, rune = 0, 0, 0
  for i,v in ipairs(l_16_0) do
    heroData = heros.find(v)
    if heroData then
      exp = exp + cfghero[heroData.id].xpBase + cfgexphero[heroData.lv].allExp
      evolve = evolve + cfghero[heroData.id].tierBase
      for i = 1, heroData.star do
        evolve = evolve + cfghero[heroData.id].starExp" .. [1]
      end
      rune = rune + cfghero[heroData.id].rune
    end
  end
  return exp, evolve, rune
end

heros.setFlag = function(l_17_0, l_17_1)
  for i,v in ipairs(l_17_0) do
    local heroData = heros.find(l_17_0[i])
    if heroData then
      if not heroData.flag then
        heroData.flag = 0
      end
      if bit.band(heroData.flag, l_17_1) == 0 then
        heroData.flag = heroData.flag + l_17_1
      end
    end
  end
end

heros.setVisit = function(l_18_0, l_18_1)
  local heroData = heros.find(l_18_0)
  heroData.visit = l_18_1
end

heros.print = function()
  print("--------------- heros --------------- {")
  for i,h in ipairs(heros) do
    print("id:", h.id, "hid:", h.hid, "lv:", h.lv, "star:", h.star, "wake:", h.wake, "flag:", h.flag, "equips:", table.concat(h.equips, ","))
  end
  print("--------------- heros --------------- }")
end

return heros

