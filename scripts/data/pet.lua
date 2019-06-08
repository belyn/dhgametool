-- Command line was: E:\github\dhgametool\scripts\data\pet.lua 

local pet = {}
require("common.const")
require("common.func")
local petMain = require("ui.pet.main")
local petConf = require("config.pet")
pet.data = {}
pet.sele = nil
pet.showRedDot = function()
  return false
end

pet.initData = function()
  print("\229\174\160\231\137\169\230\149\176\230\141\174\231\154\132\229\136\157\229\167\139\229\140\150")
end

pet.ruleData = function(l_3_0)
  for key,val in pairs(l_3_0) do
    val.buffLv = {}
    for k,v in pairs(val.skl) do
      do
        if val.id < 700 then
          local lv = v - (math.floor(val.id / 100) * 10000 + 1000 * k)
          val.buffLv[k] = lv
        end
        for k,v in (for generator) do
        end
        local lv = v - (math.floor(val.id / 100) * 1000 + 30 * (k - 1))
        val.buffLv[k] = lv
      end
    end
    return l_3_0
     -- Warning: missing end command somewhere! Added here
  end
end

pet.setData = function(l_4_0)
  pet.data = l_4_0
  for k,v in pairs(pet.data) do
    v.advanced = v.star + 1
  end
  pet.data = pet.ruleData(pet.data)
end

pet.addData = function(l_5_0)
  local data = {}
  data.id = l_5_0
  data.lv = 1
  data.advanced = 1
  data.star = 0
  data.buffLv = {}
  data.buffLv[1] = 1
  data.skl = {}
  data.skl[1] = petConf[l_5_0].pasSkillId[1]
  print("data.skl[1] == " .. data.skl[1])
  table.insert(pet.data, data)
end

pet.getData = function(l_6_0)
  for k,v in pairs(pet.data) do
    if tonumber(v.id) == tonumber(l_6_0) then
      return pet.data[k]
    end
  end
  return nil
end

pet.refreshData = function()
  for k,v in pairs(pet.data) do
    v.advanced = v.star + 1
    for i = 1, v.advanced do
      if v.skl[i] == nil then
        v.skl[i] = petConf[v.id].pasSkillId[i]
      end
    end
  end
  pet.data = pet.ruleData(pet.data)
end

pet.Reset = function(l_8_0)
  for k,v in pairs(pet.data) do
    if v.id == l_8_0 then
      v.advanced = 1
      v.star = 0
      v.skl = {}
      v.buffLv = {}
      v.skl[1] = petConf[v.id].pasSkillId[1]
      v.buffLv[1] = 1
    end
  end
end

pet.coutRsult = function(l_9_0, l_9_1)
  if l_9_1 == 0 then
    return 
  end
  if l_9_0 == 3 and l_9_1 == -3 then
    showToast(string.format(i18n.global.pet_smaterial_not_enough.string))
    return 
  end
  showToast("id = " .. l_9_0 .. " status = " .. l_9_1)
end

pet.getPetID = function(l_10_0)
  if not l_10_0 then
    return nil
  end
  for k,v in pairs(l_10_0) do
    if v.pos == 7 then
      return v.id
    end
  end
  return nil
end

pet.getPetIDFromCamp = function(l_11_0)
  for _,v in ipairs(l_11_0) do
    if v and v.pos == 7 then
      return v.id
    end
  end
  return nil
end

return pet

