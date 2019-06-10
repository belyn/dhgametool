-- Command line was: E:\github\dhgametool\scripts\fight\helper\attr.lua 

local helper = {}
require("common.func")
require("common.const")
local cfghero = require("config.hero")
local cfgbuff = require("config.buff")
local cfgequip = require("config.equip")
local cfgtalen = require("config.talen")
local cfgskill = require("config.skill")
local bagdata = require("data.bag")
local gskillData = require("data.gskill")
local names = {BUFF_ATK, BUFF_ATK_P, BUFF_ARM, BUFF_ARM_P, BUFF_HP, BUFF_HP_P, BUFF_SPD, BUFF_HIT, BUFF_MISS, BUFF_CRIT, BUFF_CRIT_TIME, BUFF_SKL_P, BUFF_DEC_DMG, BUFF_FREE, BUFF_TRUE_ATK, BUFF_BRK}
local isPercent = {}
local jobBuff = {zsHpPO = BUFF_HP_P, zsAtkPO = BUFF_ATK_P, zsCritO = BUFF_CRIT, zsMissO = BUFF_MISS, zsSklPO = BUFF_SKL_P, zsSpdO = BUFF_SPD, fsHpPO = BUFF_HP_P, fsAtkPO = BUFF_ATK_P, fsCritO = BUFF_CRIT, fsHitO = BUFF_HIT, fsSklPO = BUFF_SKL_P, fsSpdO = BUFF_SPD, ckHpPO = BUFF_HP_P, ckCritTimeO = BUFF_CRIT_TIME, ckCritO = BUFF_CRIT, ckBrkO = BUFF_BRK, ckSklPO = BUFF_SKL_P, ckSpdO = BUFF_SPD, ckAtkPO = BUFF_ATK_P, yxHpPO = BUFF_HP_P, yxAtkPO = BUFF_ATK_P, yxMissO = BUFF_MISS, yxHitO = BUFF_HIT, yxSklPO = BUFF_SKL_P, yxSpdO = BUFF_SPD, msHpPO = BUFF_HP_P, msMissO = BUFF_MISS, msCritO = BUFF_CRIT, msSpdO = BUFF_SPD, msSklPO = BUFF_SKL_P, msAtkPO = BUFF_ATK_P}
helper.jobBuff = function(l_1_0)
  return jobBuff[l_1_0]
end

helper.init = function()
  if #isPercent == 0 then
    for _,name in ipairs(names) do
      local id = buffname2id(name)
      if cfgbuff[id].isPercent == 2 then
        isPercent[name] = true
      end
    end
  end
end

helper.attr = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4)
  if not l_3_1 then
    l_3_1 = l_3_0.star
  end
  if not l_3_2 then
    l_3_2 = l_3_0.lv
  end
  if not l_3_3 then
    l_3_3 = l_3_0.wake
  end
  helper.init()
  local cfg = clone(cfghero[l_3_0.id])
  local cfggrowhp = cfg.growHp
  local cfggrowatk = cfg.growAtk
  local cfggrowarm = cfg.growArm
  local cfggrowspd = cfg.growSpd
  if l_3_3 and l_3_3 ~= 0 and l_3_3 < 4 then
    cfggrowhp = cfg.disillusGrow[l_3_3].disiG[2]
    cfggrowatk = cfg.disillusGrow[l_3_3].disiG[1]
    cfggrowarm = cfg.disillusGrow[l_3_3].disiG[3]
    cfggrowspd = cfg.disillusGrow[l_3_3].disiG[4]
    cfg.pasSkill = cfg.disillusSkill[l_3_3].disi[1]
    cfg.pasSkill1Id = cfg.disillusSkill[l_3_3].disi[2]
    cfg.pasSkill2Id = cfg.disillusSkill[l_3_3].disi[3]
    cfg.pasSkill3Id = cfg.disillusSkill[l_3_3].disi[4]
  end
  local base = {hp = (cfg.baseHp + (l_3_2 - 1) * cfggrowhp) * (1 + l_3_1 * 0.2), atk = (cfg.baseAtk + (l_3_2 - 1) * cfggrowatk) * (1 + l_3_1 * 0.2), arm = cfg.baseArm + (l_3_2 - 1) * cfggrowarm, spd = (cfg.baseSpd + (l_3_2 - 1) * cfggrowspd) * (1 + l_3_1 * 0.1)}
  local extra = {}
  local addAttr = function(l_1_0, l_1_1)
    if isPercent[l_1_0] then
      if extra[l_1_0] then
        extra[l_1_0][#extra[l_1_0] + 1] = l_1_1
      else
        extra[l_1_0] = {l_1_1}
      end
    else
      extra[l_1_0] = (extra[l_1_0] or 0) + l_1_1
    end
   end
  if l_3_3 and l_3_3 > 4 then
    local talenAttr = cfgtalen[l_3_3 - 4].base
    if talenAttr then
      for i = 1, #talenAttr do
        addAttr(talenAttr[i].type, talenAttr[i].num)
      end
    end
    for i = 1, #cfgtalen[l_3_3 - 4].talenSkills do
      local pasSkill = cfgtalen[l_3_3 - 4].talenSkills[i]
      if cfgskill[pasSkill].trigger == 23 then
        for _,b in ipairs(cfgskill[pasSkill].effect) do
          addAttr(b.type, b.num)
        end
      end
    end
  end
  local otherPower = 0
  if l_3_0.equips then
    local suits = {}
    for _,id in ipairs(l_3_0.equips) do
      local cfg = cfgequip[id]
      if cfg.power then
        otherPower = otherPower + cfg.power
        for _,id in (for generator) do
        end
        for i = 1, 3 do
          local attr = cfg.base" .. 
          if attr then
            addAttr(attr.type, attr.num)
          end
        end
        if (cfg.job and arraycontains(cfg.job, cfghero[l_3_0.id].job)) or cfg.group and cfg.group == cfghero[l_3_0.id].group then
          for i = 1, 3 do
            local attr = cfg.act" .. 
            if attr then
              addAttr(attr.type, attr.num)
            end
          end
        end
        if cfg.form then
          local suit = nil
          for _,s in ipairs(suits) do
            if arrayequal(s.form, cfg.form) then
              suit = s
          else
            end
          end
          if suit then
            suit.num = suit.num + 1
            for _,id in (for generator) do
            end
            suits[#suits + 1] = {form = cfg.form, id = id, num = 1}
          end
        end
        for _,suit in ipairs(suits) do
          if suit.num > 1 then
            for i = 1, suit.num - 1 do
              local attr = cfgequip[suit.id].suit" .. 
              if attr then
                addAttr(attr.type, attr.num)
              end
            end
          end
        end
      end
      local v = function(l_2_0, l_2_1)
        local n = math.floor(base[l_2_0] or 0) + math.floor(extra[l_2_0] or 0)
        if l_2_1 and extra[l_2_1] then
          for _,p in ipairs(extra[l_2_1]) do
            n = n + math.floor(n * p)
          end
        end
        return n
         end
      local calGskill = function()
        for ii = 1, #gskillData.jobs[cfg.job] do
          local effects = gskillData.getBuffsEffects(gskillData.jobs[cfg.job][ii])
          if effects then
            for jj = 1, #effects do
              addAttr(jobBuff[effects[jj].type], effects[jj].num)
            end
          end
        end
         end
      if not l_3_4 then
        calGskill()
      end
      local calculate = function(l_4_0)
        local attribs = {hp = v(BUFF_HP, BUFF_HP_P), atk = v(BUFF_ATK, BUFF_ATK_P), arm = v(BUFF_ARM, BUFF_ARM_P), spd = v(BUFF_SPD), hit = v(BUFF_HIT), miss = v(BUFF_MISS), crit = v(BUFF_CRIT), critTime = v(BUFF_CRIT_TIME), sklP = v(BUFF_SKL_P), decDmg = v(BUFF_DEC_DMG), free = v(BUFF_FREE), trueAtk = v(BUFF_TRUE_ATK), brk = v(BUFF_BRK), power = l_4_0}
        if not l_4_0 then
          attribs.power = attribs.atk + attribs.arm + math.floor(attribs.hp / 6) + attribs.hit + attribs.miss + attribs.crit + attribs.critTime + attribs.sklP + attribs.decDmg * 2 + attribs.trueAtk * 2 + otherPower
        end
        return attribs
         end
      local attribs = (calculate())
      do
        local refresh = nil
        for i = 1, 3 do
          local pasTier = cfg.pasTier" .. 
          if pasTier then
            if l_3_1 < pasTier then
              do return end
            end
            local pasSkill = cfg.pasSkill" .. i .. "Id
            if pasSkill and cfgskill[pasSkill].attrPas then
              for _,b in ipairs(cfgskill[pasSkill].effect) do
                addAttr(b.type, b.num)
              end
              if not refresh then
                refresh = true
              end
            end
          end
        end
        if l_3_0.equips then
          for _,id in ipairs(l_3_0.equips) do
            local cfg = cfgequip[id]
            if cfg.power then
              for i = 1, 3 do
                local attr = cfg.base" .. 
                if attr then
                  addAttr(attr.type, attr.num)
                  if not refresh then
                    refresh = true
                  end
                end
              end
              if (cfg.job and arraycontains(cfg.job, cfghero[l_3_0.id].job)) or cfg.group and cfg.group == cfghero[l_3_0.id].group then
                for i = 1, 3 do
                  local attr = cfg.act" .. 
                  if attr then
                    addAttr(attr.type, attr.num)
                    if not refresh then
                      refresh = true
                    end
                  end
                end
              end
            end
          end
        end
        if refresh then
          return calculate(attribs.power)
        end
        return attribs
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

helper.equipPower = function(l_4_0)
  local cfg = cfgequip[l_4_0]
  if cfg.power then
    return cfg.power
  end
  local v = {BUFF_ATK = 0, BUFF_ARM = 0, BUFF_HP = 0}
  for i = 1, 3 do
    local attr = cfg.base" .. 
    if attr then
      v[attr.type] = v[attr.type] + attr.num
    end
  end
  return math.floor(v[BUFF_ATK] + v[BUFF_ARM] + math.floor(v[BUFF_HP] / 6))
end

helper.isAttrib = function(l_5_0)
  return arraycontains(names, l_5_0)
end

return helper

