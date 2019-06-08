-- Command line was: E:\github\dhgametool\scripts\data\bag.lua 

local bag = {}
local equips = {}
local items = {}
bag.equips = equips
bag.items = items
require("common.const")
require("common.func")
local cfgequip = require("config.equip")
local cfghero = require("config.hero")
local head = require("data.head")
local CURRENCY_IDS = {ITEM_ID_COIN, ITEM_ID_GEM, ITEM_ID_PLAYER_EXP, ITEM_ID_VIP_EXP, ITEM_ID_HERO_EXP, ITEM_ID_GUILD_COIN, ITEM_ID_LUCKY_COIN, ITEM_ID_RUNE_COIN, ITEM_ID_SMITH_CRYSTAL, ITEM_ID_ENCHANT, ITEM_ID_LOVE, ITEM_ID_GACHA, ITEM_ID_SUPERGACHA, ITEM_ID_ENERGY, ITEM_ID_BRAVE, ITEM_ID_ARENA_SHOP, ITEM_ID_BREAD, ITEM_ID_PET_DEVIL, ITEM_ID_PET_CHAOS, ITEM_ID_BUILD_STONE, ITEM_ID_COLOR_CRYSTAL, ITEM_ID_LIGHT_DARK_CRYSTAL, ITEM_ID_GLORY}
bag.init = function(l_1_0)
  if not l_1_0 then
    return 
  end
  equips.init(l_1_0.equips)
  items.init(l_1_0.items)
end

equips.init = function(l_2_0)
  arrayclear(equips)
  if not l_2_0 then
    return 
  end
  for i,pb in ipairs(l_2_0) do
    local e = tablecp(pb)
    if not e.attr then
      e.attr = {}
    end
    equips[ equips + 1] = e
  end
end

equips.add = function(l_3_0)
  if l_3_0.id then
    assert(l_3_0.num, "id or num nil")
  end
  local e = equips.find(l_3_0.id)
  if e then
    e.num = e.num + l_3_0.num
    e.showRedDot = true
  else
    equips[ equips + 1] = {id = l_3_0.id, num = l_3_0.num, showRedDot = true}
  end
  if cfgequip[l_3_0.id].pos == EQUIP_POS_SKIN then
    head.addSkinHead(l_3_0.id)
    return 
  end
  local achieveData = require("data.achieve")
  if cfgequip[l_3_0.id].qlt == QUALITY_4 then
    achieveData.add(ACHIEVE_TYPE_GET_EQUIP_GREEN, l_3_0.num)
  end
  if cfgequip[l_3_0.id].qlt == QUALITY_5 then
    achieveData.add(ACHIEVE_TYPE_GET_EQUIP_RED, l_3_0.num)
  end
  if cfgequip[l_3_0.id].qlt == QUALITY_6 then
    achieveData.add(ACHIEVE_TYPE_GET_EQUIP_ORANGE, l_3_0.num)
  end
end

equips.returnbag = function(l_4_0)
  if l_4_0.id then
    assert(l_4_0.num, "id or num nil")
  end
  local e = equips.find(l_4_0.id)
  if cfgequip[l_4_0.id].pos ~= EQUIP_POS_JADE then
    if e then
      e.num = e.num + l_4_0.num
      e.showRedDot = true
    else
      equips[ equips + 1] = {id = l_4_0.id, num = l_4_0.num, showRedDot = true}
    end
  end
end

equips.addAll = function(l_5_0)
  if not l_5_0 then
    return 
  end
  for i,pb in ipairs(l_5_0) do
    equips.add(pb)
  end
end

equips.sub = function(l_6_0)
  if l_6_0.id then
    assert(l_6_0.num, "id or num nil")
  end
  local e, i = equips.find(l_6_0.id)
  if e and l_6_0.num <= e.num then
    e.num = e.num - l_6_0.num
    if e.num == 0 then
      table.remove(equips, i)
    end
    return e
  end
end

equips.find = function(l_7_0)
  for i,e in ipairs(equips) do
    if e.id == l_7_0 then
      return e, i
    end
  end
end

equips.del = function(l_8_0)
  for i,e in ipairs(equips) do
    if e.id == l_8_0 then
      table.remove(equips, i)
      return e
    end
  end
end

equips.count = function(l_9_0)
  local e = equips.find(l_9_0)
  if e then
    return e.num
  end
  return 0
end

equips.skin = function(l_10_0)
  local eqs = {}
  for i,eq in ipairs(equips) do
    if cfgequip[eq.id].pos == EQUIP_POS_SKIN and (not l_10_0 or cfghero[cfgequip[eq.id].heroId[1]].group == l_10_0) then
      for j = 1, eq.num do
        eqs[ eqs + 1] = clone(eq)
        eqs[ eqs].num = 1
        eqs[ eqs].flag = true
      end
    end
  end
  return eqs
end

equips.print = function()
  print("--------- equips --------- {")
  for _,e in ipairs(equips) do
    print("id:", e.id, "num:", e.num)
  end
  print("--------- equips --------- }")
end

items.init = function(l_12_0)
  arrayclear(items)
  for _,id in ipairs(CURRENCY_IDS) do
    items[ items + 1] = {id = id, num = 0}
  end
  items.addAll(l_12_0)
end

items.add = function(l_13_0)
  if l_13_0.id then
    assert(l_13_0.num, "id or num nil")
  end
  if l_13_0.num == 0 then
    return 
  end
  local t = items.find(l_13_0.id)
  if t then
    t.num = t.num + l_13_0.num
  else
    t = {id = l_13_0.id, num = l_13_0.num}
    items[ items + 1] = t
  end
  local player = require("data.player")
  if t.id == ITEM_ID_PLAYER_EXP and player.maxExp() < t.num then
    t.num = player.maxExp()
  else
    if t.id == ITEM_ID_VIP_EXP and player.maxVipExp() < t.num then
      t.num = player.maxVipExp()
    else
      if t.id == ITEM_ID_LOVE and t.num > 1000 then
        if l_13_0.num > 1000 then
          t.num = l_13_0.num
        else
          if t.num - l_13_0.num > 1000 then
            t.num = t.num - l_13_0.num
          else
            t.num = 1000
          end
        end
      end
    end
  end
  local achieveData = require("data.achieve")
  if t.id == ITEM_ID_PLAYER_EXP then
    achieveData.set(ACHIEVE_TYPE_PLAYER_LV, player.lv())
  end
  if t.id == ITEM_ID_VIP_EXP then
    achieveData.set(ACHIEVE_TYPE_VIP_LV, player.vipLv())
  end
end

items.sub = function(l_14_0)
  if l_14_0.id then
    assert(l_14_0.num, "id or num nil")
  end
  local t, i = items.find(l_14_0.id)
  if t and l_14_0.num <= t.num then
    t.num = t.num - l_14_0.num
    if t.num == 0 and not arraycontains(CURRENCY_IDS, l_14_0.id) then
      table.remove(items, i)
    end
    return t
  end
end

items.addAll = function(l_15_0)
  if not l_15_0 then
    return 
  end
  for i,pb in ipairs(l_15_0) do
    items.add(pb)
  end
end

items.del = function(l_16_0)
  for i,t in ipairs(items) do
    if t.id == l_16_0 then
      table.remove(items, i)
      return t
    end
  end
end

items.find = function(l_17_0)
  for i,t in ipairs(items) do
    if t.id == l_17_0 then
      return t, i
    end
  end
end

items.print = function()
  print("--------- items --------- {")
  for _,t in ipairs(items) do
    print("id:", t.id, "num:", t.num)
  end
  print("--------- items --------- }")
end

bag.coin = function()
  return items.find(ITEM_ID_COIN).num
end

bag.addCoin = function(l_20_0)
  items.add({id = ITEM_ID_COIN, num = l_20_0})
end

bag.subCoin = function(l_21_0)
  items.sub({id = ITEM_ID_COIN, num = l_21_0})
end

bag.devil = function()
  return items.find(ITEM_ID_PET_DEVIL).num
end

bag.addDevil = function(l_23_0)
  items.add({id = ITEM_ID_PET_DEVIL, num = l_23_0})
end

bag.subDevil = function(l_24_0)
  items.sub({id = ITEM_ID_PET_DEVIL, num = l_24_0})
end

bag.chaos = function()
  return items.find(ITEM_ID_PET_CHAOS).num
end

bag.addChaos = function(l_26_0)
  items.add({id = ITEM_ID_PET_CHAOS, num = l_26_0})
end

bag.subChaos = function(l_27_0)
  items.sub({id = ITEM_ID_PET_CHAOS, num = l_27_0})
end

bag.gem = function()
  return items.find(ITEM_ID_GEM).num
end

bag.addGem = function(l_29_0)
  items.add({id = ITEM_ID_GEM, num = l_29_0})
end

bag.subGem = function(l_30_0)
  items.sub({id = ITEM_ID_GEM, num = l_30_0})
end

bag.addRewards = function(l_31_0)
  if not l_31_0 then
    return 
  end
  if l_31_0.equips then
    bag.equips.addAll(l_31_0.equips)
  end
  if l_31_0.items then
    bag.items.addAll(l_31_0.items)
  end
  processSpecialHead(l_31_0.items)
end

bag.showRedDot = function()
  local cfgitem = require("config.item")
  for _,t in ipairs(bag.items) do
    if cfgitem[t.id] and cfgitem[t.id].heroCost and cfgitem[t.id].type == ITEM_KIND_HERO_PIECE and cfgitem[t.id].heroCost.count <= t.num then
      return true
    end
    if cfgitem[t.id] and cfgitem[t.id].treasureCost and cfgitem[t.id].type == ITEM_KIND_TREASURE_PIECE and cfgitem[t.id].treasureCost.count <= t.num then
      return true
    end
  end
  return false
end

bag.print = function()
  print("---------------- bag ---------------- {")
  equips.print()
  items.print()
  print("---------------- bag ---------------- }")
end

return bag

