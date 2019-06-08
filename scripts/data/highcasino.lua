-- Command line was: E:\github\dhgametool\scripts\data\highcasino.lua 

local casino = {}
local bagdata = require("data.bag")
local player = require("data.player")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
casino.COST_PER_CHIP = 50
casino.pull = function(l_1_0, l_1_1)
  netClient:pull_casino(l_1_0, l_1_1)
end

casino.msg = function(l_2_0, l_2_1)
  netClient:casino_msg(l_2_0, l_2_1)
end

casino.draw = function(l_3_0, l_3_1)
  netClient:casino_draw(l_3_0, l_3_1)
end

casino.ids2Pbbag = function(l_4_0)
  local _pbbag = {items = {}, equips = {}}
  if not l_4_0 or  l_4_0 <= 0 then
    return _pbbag
  end
  for ii = 1,  l_4_0 do
    local _idx = l_4_0[ii]
    local p_tbl = nil
    if casino.items[_idx].type == 1 then
      p_tbl = _pbbag.items
    else
      if casino.items[_idx].type == 2 then
        p_tbl = _pbbag.equips
      end
    end
    if p_tbl then
      local tmp_item = clone(casino.items[_idx])
      tmp_item.num = tmp_item.count
      p_tbl[ p_tbl + 1] = tmp_item
    end
  end
  return _pbbag
end

casino.buy = function(l_5_0, l_5_1)
  netClient:casino_buy(l_5_0, l_5_1)
end

casino.getChips = function()
  local _chips = bagdata.items.find(ITEM_ID_ADVANCED_CHIP)
  if _chips then
    return _chips.num
  end
  return 0
end

casino.addChips = function(l_7_0)
  local _chips = bagdata.items.find(ITEM_ID_ADVANCED_CHIP)
  if _chips then
    _chips.num = _chips.num + l_7_0
    if _chips.num < 0 then
      _chips.num = 0
    else
      bagdata.items.add({id = ITEM_ID_ADVANCED_CHIP, num = l_7_0})
    end
  end
end

casino.subChips = function(l_8_0)
  casino.addChips(0 - l_8_0)
end

casino.getRateById = function(l_9_0, l_9_1)
  if not casino.items or  casino.items <= 0 then
    return 0
  end
  local self_weight = 0
  local total_weight = 0
  for ii = 1,  casino.items do
    total_weight = total_weight + (casino.items[ii].weight or 2000)
    self_weight = casino.items[ii].id ~= l_9_0 or casino.items[ii].type ~= l_9_1 or casino.items[ii].weight or 0
  end
  return 100 * (self_weight) / (total_weight)
end

casino.init = function(l_10_0)
  casino.last_pull = os.time()
  casino.last_force_pull = os.time()
  casino.items = l_10_0.items
  casino.cd = l_10_0.cd
  casino.force_cd = l_10_0.force_cd
  casino.msgs = l_10_0.msgs
end

return casino

