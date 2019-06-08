-- Command line was: E:\github\dhgametool\scripts\data\head.lua 

local head = {}
require("common.const")
require("common.func")
local cfghead = require("config.head")
local cfghero = require("config.hero")
local cfgEquip = require("config.equip")
local herobook = require("data.herobook")
local skinbook = require("data.skinbook")
local ITEM_HEAD = {ITEM_ID_SP_FIGHT = 51, ITEM_ID_SP_FIGHT2 = 53, ITEM_ID_SP_WINNER_HEAD = 52, ITEM_ID_SP_LOVER_HEAD = 54, ITEM_ID_SP_F3V3_HEAD_1 = 59, ITEM_ID_SP_F3V3_HEAD_2 = 58, ITEM_ID_SP_F3V3_HEAD_3 = 57, ITEM_ID_SP_F3V3_HEAD_4 = 56, ITEM_ID_SP_F3V3_HEAD_5 = 55, ITEM_ID_SP_WARM = 60, ITEM_ID_SP_FIGHT3 = 61, ITEM_ID_SP_WARM2 = 62, ITEM_ID_SP_FIGHT4 = 63, ITEM_ID_SP_WARM3 = 64, ITEM_ID_SP_WARM4 = 65, ITEM_ID_SP_FIRSTYEAR = 66, ITEM_ID_SP_FIGHT5 = 67, ITEM_ID_SP_WARM5 = 68, ITEM_ID_SP_FIGHT6 = 74, ITEM_ID_SP_LOVE = 75, ITEM_ID_SP_FIGHT7 = 76, ITEM_ID_SP_RABBIT = 92, ITEM_ID_SP_BEAR = 93, ITEM_ID_SP_FIGHT8 = 94, ITEM_ID_SP_SUB = 95, ITEM_ID_SP_HW = 96, ITEM_ID_SP_FIGHT9 = 97, ITEM_ID_SP_VPLI1 = 98, ITEM_ID_SP_MASK = 99, ITEM_ID_SP_FIGHT10 = 100, ITEM_ID_SP_CHRISTMAS = 101, ITEM_ID_SP_FIGHT11 = 110, ITEM_ID_SP_NEWYEAR1 = 111, ITEM_ID_SP_FIGHT12 = 112, ITEM_ID_SP_FIGHT13 = 113, ITEM_ID_SP_FIGHT14 = 119, ITEM_ID_SP_FIGHT15 = 120, ITEM_ID_SP_DEMON = 121, ITEM_ID_SP_FIGHT16 = 122, ITEM_ID_SP_FIGHT17 = 123, ITEM_ID_SP_FIGHT18 = 124, ITEM_ID_SP_MOONCAKE = 125, ITEM_ID_SP_AFRICA1 = 126, ITEM_ID_SP_AFRICA2 = 127, ITEM_ID_SP_AFRICA3 = 128, ITEM_ID_SP_HALLOMAS = 129, ITEM_ID_SP_THANK = 177, ITEM_ID_SP_CHRISTMAS2 = 180}
head.getHeadIdByItemId = function(l_1_0)
  return ITEM_HEAD[l_1_0]
end

head.getItemhead = function()
  return ITEM_HEAD
end

head.init = function()
  arrayclear(head)
  for _,cfg in ipairs(cfghead) do
    if cfg.type == 2 then
      if skinbook.contain(cfg.iconId) then
        head[ head + 1] = {iconId = cfg.iconId, type = cfg.type}
        for _,cfg in (for generator) do
        end
        head[ head + 1] = {iconId = cfg.iconId, type = cfg.type, hide = true}
        for _,cfg in (for generator) do
        end
        head[ head + 1] = {iconId = cfg.iconId, type = cfg.type}
      end
      for _,id in ipairs(herobook) do
        local iconId = cfghero[id].heroCard
        if cfghero[id] and QUALITY_4 <= cfghero[id].qlt and not head.containsForid(iconId) then
          head[ head + 1] = {iconId = id, cardId = iconId, type = 1}
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

head.add = function(l_4_0)
  local iconId = cfghero[l_4_0].heroCard
  if not head.contains(iconId) then
    head[ head + 1] = {iconId = l_4_0, cardId = iconId, type = 1, isNew = true}
  end
end

head.addSkinHead = function(l_5_0)
  local iconId = cfgEquip[l_5_0].icon
  for _,info in ipairs(head) do
    if info.iconId == iconId then
      if info.hide == true then
        info.isNew = true
      end
      info.hide = false
    end
  end
end

head.containsForid = function(l_6_0)
  for _,info in ipairs(head) do
    if info.cardId == l_6_0 then
      return true
    end
  end
  return false
end

head.contains = function(l_7_0)
  for _,info in ipairs(head) do
    if info.iconId == l_7_0 then
      return true
    end
  end
  return false
end

head.showRedDot = function()
  for i = 1,  head do
    if head[i].isNew then
      return true
    end
  end
  return false
end

return head

