-- Command line was: E:\github\dhgametool\scripts\data\christmas.lua 

local christmas = {}
christmas.act = {}
christmas.reward = {}
christmas.wishes = {}
christmas.init = function(l_1_0)
  if not l_1_0.acts then
    christmas.act = {}
  end
  if not l_1_0.reward then
    christmas.reward = {}
  end
  if not l_1_0.wishes then
    christmas.wishes = {}
  end
end

christmas.setValue = function(l_2_0, l_2_1)
  christmas[l_2_0] = l_2_1
end

christmas.shouldPop = function()
  if christmas.reward then
    if christmas.reward.items and #christmas.reward.items > 0 then
      return true
    end
    if christmas.reward.equips and #christmas.reward.equips > 0 then
      return true
    end
  end
  return false
end

christmas.emptyReward = function()
  christmas.reward = {}
end

christmas.onGetHeroes = function(l_5_0)
  if l_5_0 == nil or #l_5_0 == 0 then
    return 
  end
  christmas.addSnowflake(l_5_0)
end

christmas.addSnowflake = function(l_6_0)
  local activityData = require("data.activity")
  local IDS = activityData.IDS
  local snowflake_status = activityData.getStatusById(IDS.CHRISTMAS_SNOWFLAKE.ID)
  if snowflake_status and snowflake_status.limits then
    local cfgspecial = require("config.specialactivity")
    if not cfgspecial[IDS.CHRISTMAS_SNOWFLAKE.ID].instruct then
      local max_limit = not cfgspecial[IDS.CHRISTMAS_SNOWFLAKE.ID] or 0
    end
    if snowflake_status.limits < max_limit then
      local cfghero = require("config.hero")
      local five_star_hero_count = 0
      for _,hero in ipairs(l_6_0) do
        if hero.id and cfghero[hero.id] and cfghero[hero.id].maxStar == 5 then
          five_star_hero_count = five_star_hero_count + 1
        end
      end
      local remainder_count = max_limit - snowflake_status.limits
      if remainder_count < five_star_hero_count then
        five_star_hero_count = remainder_count
      end
      if five_star_hero_count > 0 then
        activityData.addScore(IDS.CHRISTMAS_SNOWFLAKE.ID, five_star_hero_count)
        if cfgspecial[IDS.CHRISTMAS_SNOWFLAKE.ID].rewards and cfgspecial[IDS.CHRISTMAS_SNOWFLAKE.ID].rewards[1] then
          local snowflake_num = cfgspecial[IDS.CHRISTMAS_SNOWFLAKE.ID].rewards[1].num * five_star_hero_count
          local snowflake_reward = {}
          snowflake_reward.items = {{id = ITEM_ID_SNOWFLAKE, num = snowflake_num}}
          local rewards_ui = require("ui.reward")
          local bagdata = require("data.bag")
          CCDirector:sharedDirector():getRunningScene():addChild(rewards_ui.createFloating(snowflake_reward), 100000)
          bagdata.items.add({id = ITEM_ID_SNOWFLAKE, num = snowflake_num})
        end
      end
    end
  end
end

return christmas

