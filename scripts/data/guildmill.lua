-- Command line was: E:\github\dhgametool\scripts\data\guildmill.lua 

local guildmill = {}
local player = require("data.player")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
guildmill.initorder = function(l_1_0)
  guildmill.lv = l_1_0.mill_lv
  guildmill.reddot = 0
  if l_1_0.orders then
    guildmill.pull_ocd_time = {}
    guildmill.order = l_1_0.orders
    for i = 1, #guildmill.order do
      guildmill.pull_ocd_time[i] = os.time()
    end
  else
    guildmill.order = nil
  end
  if l_1_0.ecd then
    guildmill.pull_ecd_time = os.time()
    guildmill.ecd = l_1_0.ecd
  else
    guildmill.ecd = nil
  end
end

guildmill.initRedDot = function(l_2_0)
  if UNLOCK_GUILD_LEVEL <= player.lv() then
    guildmill.reddot = bit.band(4, l_2_0)
  end
end

guildmill.showRedDot = function()
  if guildmill.reddot and guildmill.reddot ~= 0 then
    return true
  end
  return false
end

guildmill.sortOrder = function()
  local orders = {}
  for i,v in ipairs(guildmill.order) do
    if v.cd and v.cd == 0 then
      orders[#orders + 1] = v
    end
  end
  for i,v in ipairs(guildmill.order) do
    if v.cd == nil then
      orders[#orders + 1] = v
    end
  end
  for i,v in ipairs(guildmill.order) do
    if v.cd and v.cd > 0 then
      orders[#orders + 1] = v
    end
  end
  guildmill.order = orders
end

guildmill.initupgrade = function(l_5_0)
  guildmill.coin = l_5_0.coin
  local cfgmilllv = require("config.milllv")
  for i = 1, guildmill.lv do
    guildmill.coin = guildmill.coin - cfgmilllv[i].gold
  end
end

guildmill.donatecoin = function(l_6_0)
  local coin = 100000
  if l_6_0 == 2 then
    coin = 1000000
  end
  guildmill.coin = guildmill.coin + coin
  local cfgmilllv = require("config.milllv")
  if cfgmilllv[guildmill.lv + 1].gold <= guildmill.coin then
    guildmill.lv = guildmill.lv + 1
    guildmill.coin = guildmill.coin - cfgmilllv[guildmill.lv].gold
  end
end

guildmill.addEnegy = function()
  local bag = require("data.bag")
  bag.items.add({id = ITEM_ID_BREAD, num = 1})
  if bag.items.find(ITEM_ID_BREAD).num == 10 then
    guildmill.ecd = nil
  end
end

return guildmill

