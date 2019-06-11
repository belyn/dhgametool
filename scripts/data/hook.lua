-- Command line was: E:\github\dhgametool\scripts\data\hook.lua 

local hook = {}
local scheduler = require("framework.scheduler")
local i18n = require("res.i18n")
local cfgstage = require("config.stage")
local cfgfort = require("config.fort")
local cfghooklock = require("config.hooklock")
local cfgvip = require("config.vip")
local player = require("data.player")
local herodata = require("data.heros")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
hook.OUTPUT_INTERVAL = 5
hook.getHookStage = function()
  return hook.hook_stage or 0
end

hook.getFortIdByStageId = function(l_2_0)
  if l_2_0 <= 0 then
    l_2_0 = 1
  end
  return cfgstage[l_2_0].fortId
end

hook.lastStage = function()
  return #cfgstage
end

hook.getStageLv = function(l_4_0)
  return cfgstage[l_4_0].lv
end

hook.getFortName = function(l_5_0)
  if not l_5_0 then
    l_5_0 = hook.getHookStage()
  end
  return i18n.fort[hook.getFortIdByStageId(l_5_0)].fortName
end

hook.getStageBossCD = function()
  return cfgstage[hook.hook_stage].battleTime
end

hook.getFortByStageId = function(l_7_0)
  if not l_7_0 or l_7_0 <= 0 then
    l_7_0 = 1
  end
  return cfgfort[cfgstage[l_7_0].fortId]
end

hook.getPveStageId = function()
  return hook.pve_stage or 1
end

hook.getBossCD = function()
  return hook.boss_cd
end

hook.getIDS = function()
  if not hook.ids then
    return {}
  end
end

hook.getSubRate = function()
  local shop = require("data.shop")
  if not shop or not shop.pay or not shop.pay[33] then
    return 0
  end
  if shop.pay[33] > 0 then
    return 1
  end
  return 0
end

hook.output = function()
  local subRate = hook.getSubRate()
  hook.coins = (hook.coins or 0) + math.floor(cfgstage[hook.hook_stage].gold * (1 + cfgvip[player.vipLv()].hook + subRate))
  hook.pxps = (hook.pxps or 0) + math.floor(cfgstage[hook.hook_stage].expP * (1 + cfgvip[player.vipLv()].hook))
  hook.hxps = (hook.hxps or 0) + math.floor(cfgstage[hook.hook_stage].expH * (1 + cfgvip[player.vipLv()].hook))
end

hook.startOutput = function()
  hook.tickScheduler = scheduler.scheduleGlobal(hook.output, hook.OUTPUT_INTERVAL)
end

hook.resetOutput = function()
  hook.coins = 0
  hook.pxps = 0
  hook.hxps = 0
end

hook.init = function(l_15_0)
  if hook.tickScheduler then
    scheduler.unscheduleGlobal(hook.tickScheduler)
    hook.tickScheduler = nil
  end
  if not l_15_0 or l_15_0.status ~= 0 then
    hook.status = -1
    hook.hook_stage = 0
    hook.pve_stage = 1
    hook.hids = {}
    hook.ids = {}
    hook.resetOutput()
    print("hook not init")
    return 
  end
  hook.init_time = os.time()
  hook.status = l_15_0.status
  hook.hook_stage = l_15_0.hook_stage
  hook.pve_stage = l_15_0.pve_stage
  hook.boss_cd = l_15_0.boss_cd
  hook.poker_cd = l_15_0.poker_cd
  if l_15_0.extra then
    hook.extra = l_15_0.extra
  end
  if not hook.status or hook.status ~= 0 then
    return 
  end
  hook.hids = {}
  if l_15_0.hids and #l_15_0.hids > 0 then
    for ii = 1, #l_15_0.hids do
      hook.hids[ii] = l_15_0.hids[ii]
    end
  end
  hook.ids = {}
  if l_15_0.ids and #l_15_0.ids > 0 then
    for ii = 1, #l_15_0.ids do
      hook.ids[ii] = l_15_0.ids[ii]
    end
  end
  hook.reward = clone(l_15_0.reward)
  hook.coins, hook.pxps, hook.hxps = coinAndExp(hook.reward, true), hook.reward, true
  hook.startOutput()
end

hook.pveWin = function()
  local tmp_stage = nil
  local tmp_pve_stage_id = hook.getPveStageId()
  if hook.lastStage() < tmp_pve_stage_id then
    tmp_stage = cfgstage[#cfgstage].next
  else
    tmp_stage = cfgstage[tmp_pve_stage_id].next
  end
  local achieveData = require("data.achieve")
  local fort = 0
  if #cfgstage < tmp_stage then
    fort = cfgstage[#cfgstage].fortId
  else
    fort = cfgstage[tmp_stage].fortId - 1
  end
  achieveData.set(ACHIEVE_TYPE_PASS_FORT, fort)
  local limitData = require("data.activitylimit")
  limitData.LevelNotice(tmp_pve_stage_id)
  hook.pve_stage = tmp_stage
  hook.fort_hint_flag = true
end

hook.set_reward = function(l_17_0)
  hook.reward = clone(l_17_0)
end

hook.stage_power = function(l_18_0)
  return cfgstage[l_18_0].power
end

hook.getAllPower = function(l_19_0)
  if not l_19_0 then
    local tmp_hids = hook.hids
  end
  if not tmp_hids or #tmp_hids == 0 then
    return 0
  end
  local power = 0
  for ii = 1, #tmp_hids do
    local h = herodata.find(tmp_hids[ii])
    if h then
      power = power + herodata.power(tmp_hids[ii])
    end
  end
  return power
end

hook.getMaxHookStage = function()
  local _pve = hook.getPveStageId()
  if hook.lastStage() < _pve then
    return hook.lastStage()
  end
  if hook.stage_power(_pve) < hook.getAllPower() and cfgstage[_pve] and cfgstage[_pve].lv <= player.lv() then
    return _pve
  else
    return _pve - 1
  end
  return 1
end

hook.getFortStageByStageId = function(l_21_0)
  local tmp_fort = hook.getFortIdByStageId(l_21_0)
  local fortInfo = hook.getFortByStageId(l_21_0)
  local tmp_stage = l_21_0 - fortInfo.stageId[1] + 1
  return tmp_fort, tmp_stage
end

hook.hook_init = function(l_22_0, l_22_1)
  netClient:hook_init(l_22_0, l_22_1)
end

hook.hook_heroes = function(l_23_0, l_23_1)
  netClient:hook_heroes(l_23_0, l_23_1)
end

hook.hook_reward = function(l_24_0, l_24_1)
  netClient:hook_reward(l_24_0, l_24_1)
end

hook.hook_ask = function(l_25_0, l_25_1)
  netClient:hook_ask(l_25_0, l_25_1)
end

hook.change = function(l_26_0, l_26_1)
  netClient:hook_change(l_26_0, l_26_1)
end

hook.getMaxHeroes = function()
  return cfghooklock[player.lv()].unlock
end

hook.checkTeamChange = function()
  if not hook.hids then
    return false
  end
  for ii = 1, #hook.hids do
    if not herodata.find(hook.hids[ii]) then
      return true
    end
  end
  return false
end

return hook

