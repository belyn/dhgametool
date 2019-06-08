-- Command line was: E:\github\dhgametool\scripts\data\gboss.lua 

local gboss = {}
local cfgguildboss = require("config.guildboss")
gboss.pull_time = os.time()
local items_per_page = 8
gboss.sync = function(l_1_0)
  gboss.pull_time = os.time()
  gboss.id = l_1_0.id
  gboss.cd = l_1_0.cd
  gboss.hpp = l_1_0.hpp
  gboss.fights = l_1_0.fights
end

gboss.addBossExp = function(l_2_0)
  require("data.guild").addExp(cfgguildboss[l_2_0].guildExp)
end

gboss.getPages = function()
  return math.floor(( cfgguildboss + items_per_page - 1) / items_per_page)
end

gboss.getCurPage = function()
  local cur_page = math.floor((gboss.id + items_per_page - 1) / items_per_page)
  if gboss.getPages() < cur_page then
    return gboss.getPages()
  end
  return cur_page
end

gboss.addPlainReward = function(l_5_0)
  require("data.bag").addRewards(reward2Pbbag(cfgguildboss[l_5_0].reward))
end

return gboss

