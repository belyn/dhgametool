-- Command line was: E:\github\dhgametool\scripts\fight\helper\hero.lua 

local helper = {}
require("common.func")
require("common.const")
local cfghero = require("config.hero")
local cfgmons = require("config.monster")
local cfgskill = require("config.skill")
local cfgequip = require("config.equip")
local herosdata = require("data.heros")
helper.createHero = function(l_1_0)
  local p = tablecp(l_1_0)
  if p.hid then
    local h = herosdata.find(p.hid)
    if not p.id then
      p.id = h.id
    end
    if not p.lv then
      p.lv = h.lv
    end
    if not p.star then
      p.star = h.star
    end
    p.skin = getHeroSkin(p.hid)
  end
  return {kind = p.kind or "hero", hid = p.hid, id = p.id, heroId = p.id, lv = p.lv, hp = not p.heroId and p.hp or 100, ep = p.ep or cfghero[p.id].energyBase or 0, group = cfghero[p.id].group, pos = p.pos, side = not p.group and p.side or "attacker", size = p.size or "small", star = p.star or 0, buffs = {}, stateFx = {}, atkId = helper.atkId(p.id, (p.buffs or not p.stateFx) and p.atkId or 0, p.wake), addHurtId = helper.addHurtId(p.id, ((p.heroId or not p.star) and p.heroId or p.star) or 0), skin = p.skin}
end

helper.createMons = function(l_2_0)
  do
    local cfg = cfgmons[l_2_0.id]
    if ((not l_2_0.heroId and l_2_0.star) or not l_2_0.heroId and not l_2_0.star) then
      return {kind = l_2_0.kind or "mons", id = l_2_0.id, heroId = cfg.heroLink, lv = cfg.lv, hp = ((l_2_0.heroId or not l_2_0.lv) and not cfg.lvShow and l_2_0.hp) or 100, ep = l_2_0.ep or cfghero[cfg.heroLink].energyBase or 0, group = cfghero[cfg.heroLink].group, pos = l_2_0.pos, side = not l_2_0.group and l_2_0.side or "defender", size = op3(cfg.isBoss, "large", "small"), star = cfg.star, buffs = {}, stateFx = {}, atkId = helper.atkId(cfg.heroLink, cfg.star, l_2_0.wake), addHurtId = helper.addHurtId(cfg.heroLink, cfg.star)}
    end
     -- Warning: missing end command somewhere! Added here
  end
end

helper.groupRestraint = function(l_3_0, l_3_1)
  if l_3_0 and l_3_1 then
    local group1, group2 = l_3_0.group, l_3_1.group
    if (group1 == 5 and group2 == 6) or group1 == 6 and group2 == 5 then
      return true
    end
  end
  return false
end

helper.isEnemy = function(l_4_0, l_4_1)
  return (l_4_0.pos <= 6 and l_4_1.pos > 6) or (l_4_0.pos > 6 and l_4_1.pos <= 6)
end

helper.atkId = function(l_5_0, l_5_1, l_5_2)
  local cfg = clone(cfghero[l_5_0])
  if l_5_2 and l_5_2 < 4 and cfg.disillusSkill and cfg.disillusSkill[l_5_2] then
    cfg.pasSkill1Id = cfg.disillusSkill[l_5_2].disi[2]
    cfg.pasSkill2Id = cfg.disillusSkill[l_5_2].disi[3]
    cfg.pasSkill3Id = cfg.disillusSkill[l_5_2].disi[4]
  end
  for i,n in ipairs({"pasSkill1Id", "pasSkill2Id", "pasSkill3Id"}) do
    local skId = cfg[n]
    local tier = cfg.pasTier" .. 
    if skId and tier and tier <= l_5_1 then
      for _,e in ipairs(cfgskill[skId].effect) do
        if e.type == BUFF_CHANGE_COMBAT then
          return e.num
        end
      end
    end
  end
  return cfghero[l_5_0].atkId
end

helper.addHurtId = function(l_6_0, l_6_1)
  for i,n in ipairs({"pasSkill1Id", "pasSkill2Id", "pasSkill3Id"}) do
    local skId = cfghero[l_6_0][n]
    local tier = cfghero[l_6_0].pasTier" .. 
    if skId and tier and tier <= l_6_1 then
      for _,e in ipairs(cfgskill[skId].effect) do
        if e.type == BUFF_ADD_HURT then
          return skId
        end
      end
    end
  end
end

helper.processTreasureEpOne = function(l_7_0)
  if not l_7_0 or not l_7_0.hid then
    return 
  end
  l_7_0.ep = l_7_0.ep or 0
  local h = herosdata.find(l_7_0.hid)
  if h and h.equips then
    for ii = 1,  h.equips do
      local eid = h.equips[ii]
      local cfg = cfgequip[eid]
      if cfg and cfg.pos == EQUIP_POS_TREASURE then
        if cfg.base1 and cfg.base1.type and cfg.base1.type == "energy" then
          l_7_0.ep = l_7_0.ep + cfg.base1.num
        end
        if cfg.base2 and cfg.base2.type and cfg.base2.type == "energy" then
          l_7_0.ep = l_7_0.ep + cfg.base2.num
        end
        if cfg.base3 and cfg.base3.type and cfg.base3.type == "energy" then
          l_7_0.ep = l_7_0.ep + cfg.base3.num
        end
      end
    end
  end
  if l_7_0.ep and l_7_0.ep > 100 then
    l_7_0.ep = 100
  end
end

helper.processTreasureEp = function(l_8_0)
  if not l_8_0 or  l_8_0 <= 0 then
    return 
  end
  for ii = 1,  l_8_0 do
    helper.processTreasureEpOne(l_8_0[ii])
  end
end

return helper

