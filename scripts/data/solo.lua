-- Command line was: E:\github\dhgametool\scripts\data\solo.lua 

local solo = {}
local cfghero = require("config.hero")
local cfgMonster = require("config.monster")
local cfgSpk = require("config.spk")
local cfgSpkWave = require("config.spkwave")
local cfgMonster = require("config.monster")
local cfgDrug = require("config.spkdrug")
local cfgTrader = require("config.spktrader")
local heros = require("data.heros")
local userdata = require("data.userdata")
solo.initRedDot = function(l_1_0)
  solo.reddot = bit.band(2, l_1_0)
  print("\229\141\149\230\140\145\232\181\155\231\186\162\231\130\185" .. solo.reddot)
end

solo.showRedDot = function(l_2_0)
  if solo.reddot and solo.reddot ~= 0 then
    return true
  end
  return false
end

solo.init = function()
  solo.isPull = true
  solo.status = nil
  solo.cd = nil
  solo.estage = nil
  solo.wave = nil
  solo.buf = nil
  solo.trader = nil
  solo.reward = nil
  solo.select = nil
  solo.heroList = {}
  solo.bossList = {}
  solo.traderList = {}
  solo.milk = {}
  solo.angel = {}
  solo.evil = {}
  solo.power = 0
  solo.crit = 0
  solo.speed = 0
  solo.level = 0
  solo.levelStage = 100
  local state = userdata.getString("soloAuto", "0")
  if state == "0" then
    solo.setAutoState(false)
  elseif state == "1" then
    solo.setAutoState(true)
  end
end

solo.setBattleList = function(l_4_0)
  for i,v in ipairs(l_4_0) do
    local heroInfo = heros.find(v)
    heroInfo.hp = 100
    heroInfo.mp = heroInfo.energy or 0
    heroInfo.speed = 0
    heroInfo.power = 0
    heroInfo.crit = 0
    heroInfo.group = cfghero[heroInfo.id].group
    heroInfo.qlt = cfghero[heroInfo.id].qlt
    table.insert(solo.heroList, heroInfo)
  end
end

solo.setIsPull = function(l_5_0)
  solo.isPull = l_5_0
end

solo.getIsPull = function()
  return solo.isPull
end

solo.setMainData = function(l_7_0)
  solo.mainData = l_7_0
  solo.status = l_7_0.status
  solo.cd = l_7_0.cd + os.time()
  solo.estage = l_7_0.estage
  solo.wave = l_7_0.wave
  solo.buf = l_7_0.buf
  solo.trader = l_7_0.seller
  if not l_7_0.sellers then
    solo.traderList = {}
  end
  solo.heroList = solo.convertHeroInfo(l_7_0.camp)
  solo.bossList = solo.convertBossInfo(l_7_0.ehpp)
  if not l_7_0.bufs then
    l_7_0.bufs = {}
  end
  solo.milk = solo.getDrugList(l_7_0.bufs, "milk")
  solo.angel = solo.getDrugList(l_7_0.bufs, "angel")
  solo.evil = solo.getDrugList(l_7_0.bufs, "evil")
  solo.power = solo.getDrugNum(l_7_0.bufs, "power")
  solo.crit = solo.getDrugNum(l_7_0.bufs, "crit")
  solo.speed = solo.getDrugNum(l_7_0.bufs, "speed")
  solo.level = solo.wave and math.floor((solo.wave - 1) / solo.levelStage) or 0
  if solo.status ~= 2 or not solo.level - 1 then
    solo.level = solo.level
  end
  print("aaaaa" .. solo.level)
  for i,v in ipairs(solo.heroList) do
    v.power = solo.power
    v.speed = solo.speed
    v.crit = solo.crit
  end
  if solo.buf then
    solo.wave = solo.wave - 1
  end
  print("\232\174\190\231\189\174\229\144\142\231\154\132\230\151\182\233\151\180\228\184\186" .. solo.cd)
  print("\230\149\176\230\141\174\230\137\147\229\141\176")
end

solo.removeTrader = function(l_8_0)
  for i,v in ipairs(solo.traderList) do
    if v == l_8_0 then
      table.remove(solo.traderList, i)
  else
    end
  end
end

solo.addPotion = function(l_9_0)
  local iconID = cfgDrug[l_9_0].iconId
  if solo.power + 1 > 20 or not solo.power + 1 then
    solo.power = iconID ~= 3801 or 20
    do return end
  end
  if solo.speed + 1 > 20 or not solo.speed + 1 then
    solo.speed = iconID ~= 3701 or 20
    do return end
  end
  if solo.crit + 1 > 20 or not solo.crit + 1 then
    solo.crit = iconID ~= 3901 or 20
  end
  for i,v in ipairs(solo.heroList) do
    v.speed = solo.speed
    v.power = solo.power
    v.crit = solo.crit
    print("---power " .. solo.power)
    print("---speed " .. solo.speed)
    print("---crit " .. solo.crit)
  end
end

solo.getAliveBoss = function()
  local list = {}
  for i,v in ipairs(solo.bossList) do
    if v.hp > 0 then
      table.insert(list, v)
    end
  end
  return list
end

solo.getDrugList = function(l_11_0, l_11_1)
  local list = {}
  local drugType = nil
  if l_11_0 then
    for i,v in ipairs(l_11_0) do
      if v.num > 0 then
        if cfgDrug[v.id].iconId == 4001 then
          drugType = "milk"
        else
          if cfgDrug[v.id].iconId == 4101 then
            drugType = "evil"
          else
            if cfgDrug[v.id].iconId == 4201 then
              drugType = "angel"
            end
          end
        end
        if l_11_1 == drugType then
          for j = 1, v.num do
            table.insert(list, v.id)
          end
        end
      end
    end
  end
  return list
end

solo.getDrugNum = function(l_12_0, l_12_1)
  local num = 0
  for i,v in ipairs(l_12_0) do
    if cfgDrug[v.id].iconId == 3801 and l_12_1 == "power" then
      num = v.num + num
      for i,v in (for generator) do
      end
      if cfgDrug[v.id].iconId == 3901 and l_12_1 == "crit" then
        num = v.num + (num)
        for i,v in (for generator) do
        end
        if cfgDrug[v.id].iconId == 3701 and l_12_1 == "speed" then
          num = v.num + (num)
        end
      end
      if num <= 20 or not 20 then
        return num
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

solo.getStageLevel = function()
  local level = 0
  level = solo.wave ~= nil and math.floor((solo.wave - 1) / solo.levelStage) or 0
  return level
end

solo.getShowWave = function()
  local wave = 1
  wave = solo.wave ~= nil and (solo.getWave() - 1) % 100 + 1 or 1
  return wave
end

solo.convertHeroInfo = function(l_15_0)
  if l_15_0 == nil then
    return {}
  end
  do
    local infoTable = {}
    for i,v in ipairs(l_15_0) do
      infoTable[i] = {}
      infoTable[i].hid = v.base.hid
      infoTable[i].id = v.base.id
      infoTable[i].lv = v.base.lv
      infoTable[i].star = v.base.star
      infoTable[i].hp = v.base.hpp or 100
      infoTable[i].mp = v.base.energy
      infoTable[i].wake = v.base.wake
      infoTable[i].skin = v.base.skin
      infoTable[i].group = cfghero[infoTable[i].id].group
      infoTable[i].qlt = cfghero[infoTable[i].id].qlt
      infoTable[i].speed = solo.speed or 0
      infoTable[i].power = solo.power or 0
      infoTable[i].crit = solo.crit or 0
      infoTable[i].pos = 1
      if v.buf then
        for j,n in ipairs(v.buf) do
          if cfgDrug[n.id].type == 1 then
            infoTable[i].power = infoTable[i].power + n.num
            for j,n in (for generator) do
            end
            if cfgDrug[n.id].type == 2 then
              infoTable[i].speed = infoTable[i].speed + n.num
              for j,n in (for generator) do
              end
              if cfgDrug[n.id].type == 3 then
                infoTable[i].crit = infoTable[i].crit + n.num
              end
            end
          end
        end
        return infoTable
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

solo.convertBossInfo = function(l_16_0)
  if solo.estage == nil then
    return {}
  end
  local bossArr = cfgSpkWave[solo.estage].trial
  local infoTable = {}
  for i,v in ipairs(bossArr) do
    tablePrint(bossArr)
    infoTable[i] = {}
    infoTable[i].id = cfgMonster[v].heroLink
    infoTable[i].lv = cfgMonster[v].lv
    infoTable[i].star = cfgMonster[v].star
    infoTable[i].group = cfghero[cfgMonster[v].heroLink].group
    infoTable[i].qlt = cfghero[cfgMonster[v].heroLink].qlt
    infoTable[i].hp = l_16_0[i] or 100
    infoTable[i].pos = cfgSpkWave[solo.estage].stand[i]
  end
  return infoTable
end

solo.setAutoState = function(l_17_0)
  solo.isAuto = l_17_0
  if l_17_0 then
    userdata.setString("soloAuto", "1")
  else
    userdata.setString("soloAuto", "0")
  end
end

solo.getAutoState = function()
  local isAuto = solo.isAuto or false
  return isAuto
end

solo.setHeroProperty = function(l_19_0, l_19_1, l_19_2)
  solo.heroList[l_19_0][l_19_1] = l_19_2
end

solo.setBossProperty = function(l_20_0, l_20_1, l_20_2)
  solo.bossList[l_20_0][l_20_1] = l_20_2
end

solo.setStatus = function(l_21_0)
  solo.status = l_21_0
end

solo.getStatus = function()
  return solo.status
end

solo.setWave = function(l_23_0)
  solo.wave = l_23_0
end

solo.getWave = function()
  return solo.wave
end

solo.setStage = function(l_25_0)
  solo.estage = l_25_0
end

solo.getStage = function()
  return solo.estage
end

solo.setBuf = function(l_27_0)
  solo.buf = l_27_0
end

solo.getBuf = function()
  return solo.buf
end

solo.getBufType = function()
  if solo.getBuf() == nil then
    return 
  end
  local bufStr = {4001 = "milk", 4101 = "evil", 4201 = "angel", 3801 = "power", 3701 = "speed", 3901 = "crit"}
  local bufType = bufStr[cfgDrug[solo.getBuf()].iconId]
  return bufType
end

solo.setTrader = function(l_30_0)
  solo.trader = l_30_0
end

solo.getTrader = function()
  return solo.trader
end

solo.setReward = function(l_32_0)
  solo.reward = l_32_0
end

solo.getReward = function()
  return solo.reward
end

solo.setSelectOrder = function(l_34_0)
  solo.selectOrder = l_34_0
end

solo.getSelectOrder = function()
  return solo.selectOrder
end

solo.refreshData = function(l_36_0)
end

solo.clearData = function()
  for k,v in pairs(solo) do
    v = nil
  end
  solo = {}
end

return solo

