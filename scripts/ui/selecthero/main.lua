-- Command line was: E:\github\dhgametool\scripts\ui\selecthero\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local heros = require("data.heros")
local userdata = require("data.userdata")
local cfghero = require("config.hero")
local bag = require("data.bag")
local player = require("data.player")
local hookdata = require("data.hook")
local trialdata = require("data.trial")
local arenaData = require("data.arena")
local achieveData = require("data.achieve")
local petBattle = require("ui.pet.petBattle")
local seallandData = require("data.sealland")
local getCampHids = function(l_1_0)
  tbl2string(l_1_0)
  local hids = {}
  if l_1_0.type == "pve" then
    hids = userdata.getSquadNormal()
  elseif l_1_0.type == "trial" then
    hids = userdata.getSquadTrial()
  elseif l_1_0.type == "ArenaAtk" then
    hids = userdata.getSquadArenaatk()
  elseif l_1_0.type == "ArenaDef" then
    hids = userdata.getSquadArenadef()
  elseif l_1_0.type == "FrdArena" then
    hids = userdata.getSquadFrdArena()
  elseif l_1_0.type == "guildVice" then
    hids = userdata.getSquadGuildBoss()
  elseif l_1_0.type == "guildGray" then
    hids = userdata.getSquadGuildGray()
  elseif l_1_0.type == "challenge" then
    hids = userdata.getSquadDailyFight()
  elseif l_1_0.type == "airisland" then
    hids = userdata.getSquadAirisland()
  elseif l_1_0.type == "friend" then
    hids = userdata.getSquadFriend()
  elseif l_1_0.type == "guildmill" then
    hids = userdata.getSquadguildmilldef()
  elseif l_1_0.type == "guildmillharry" then
    hids = userdata.getSquadguildmill()
  elseif l_1_0.type == "guildFight" then
    hids = userdata.getGuildFight()
  elseif l_1_0.type == "frdpk" then
    hids = userdata.getSquadFrdpk()
  elseif l_1_0.type == "brokenboss" then
    hids = userdata.getSquadBrokenboss()
  elseif l_1_0.type == "sweepforbrokenboss" then
    hids = userdata.getSquadSweepforbrokenboss()
  elseif l_1_0.type == "sweepforairisland" then
    hids = userdata.getSquadSweepforairisland()
  elseif l_1_0.type == "sweepforcomisland" then
    hids = userdata.getSquadSweepforcomisland()
  elseif l_1_0.type == "sweepforfboss" then
    hids = userdata.getSquadSweepforfboss()
  elseif l_1_0.type == "sealland" then
    if l_1_0.data.group == 1 then
      hids = userdata.getSquadSealland1()
    else
      if l_1_0.data.group == 2 then
        hids = userdata.getSquadSealland2()
      else
        if l_1_0.data.group == 3 then
          hids = userdata.getSquadSealland3()
        else
          if l_1_0.data.group == 4 then
            hids = userdata.getSquadSealland4()
          else
            if l_1_0.data.group == 5 then
              hids = userdata.getSquadSealland5()
            else
              if l_1_0.data.group == 6 then
                hids = userdata.getSquadSealland6()
              end
            end
          end
        end
      end
    end
  end
  return hids
end

local initHerolistData = function(l_2_0)
  if not l_2_0 then
    local params = {}
  end
  local tmpheros = clone(heros)
  local herolist = {}
  for i,v in ipairs(tmpheros) do
    if params.group then
      if cfghero[v.id].group == params.group then
        herolist[#herolist + 1] = v
        for i,v in (for generator) do
        end
        for j = 1, 6 do
          if params.hids[j] == v.hid then
            herolist[#herolist + 1] = v
          end
        end
        for i,v in (for generator) do
        end
        herolist[#herolist + 1] = v
      end
      for i,v in ipairs(herolist) do
        v.isUsed = false
      end
      table.sort(herolist, compareHero)
      local whitelist = getCampHids(params)
      whitelist = arraymerge(whitelist, params.hids)
      do
        local tlist = herolistless(herolist, whitelist)
        return tlist
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

local onHadleBattle = function(l_3_0)
  print(l_3_0.type)
  if #l_3_0.hids <= 0 then
    showToast(i18n.global.toast_selhero_needhero.string)
    return 
  end
  print("\231\187\159\228\184\128\229\138\160\229\133\165\229\174\160\231\137\169\230\149\176\230\141\174")
  petBattle.addPetData(l_3_0.hids)
  print("\231\187\159\228\184\128\229\138\160\229\133\165\229\174\160\231\137\169\230\149\176\230\141\174")
  if l_3_0.type == "trial" then
    local params = {sid = player.sid, camp = l_3_0.hids}
    do
      if trialdata.tl <= 0 then
        showToast(i18n.global.trial_need_tl.string)
        return 
      end
      addWaitNet()
      net:trial_fight(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status < 0 then
          showToast("status:" .. l_1_0.status)
          return 
        end
        local video = l_1_0.video
        video.camp = content.hids
        video.stage = trialdata.stage
        if video.win == true then
          trialdata.win()
          bag.addRewards(video.reward)
          require("data.appsflyer").setAchieve(6001, video.stage)
        else
          trialdata.lose()
        end
        if not video.atk then
          video.atk = {}
        end
        video.atk.camp = content.hids
        processPetPosAtk1(video)
        processPetPosDef2(video)
        replaceScene(require("fight.trial.loading").create(video))
         end)
    end
  elseif l_3_0.type == "ArenaDef" then
    local params = {sid = player.sid, id = 1, camp = l_3_0.hids}
    addWaitNet()
    net:pvp_camp(params, function(l_2_0)
      delWaitNet()
      if l_2_0.status >= 0 then
        addWaitNet()
        net:joinpvp_sync(params, function(l_1_0)
          delWaitNet()
          if l_1_0.status == -1 then
            layer:addChild(require("ui.selecthero.main").create({type = "ArenaDef"}), 10000)
          elseif l_1_0.status == -2 then
            showToast(i18n.global.event_processing.string)
          else
            local arenaData = require("data.arena")
            arenaData.init(l_1_0)
            local hids = {}
            for i,v in ipairs(heros) do
              if v.flag and bit.band(v.flag, 1) ~= 0 then
                v.flag = v.flag - 1
              end
            end
            for i,v in ipairs(params.camp) do
              hids[#hids + 1] = v.hid
            end
            heros.setFlag(hids, 1)
            replaceScene(require("ui.arena.main").create())
          end
            end)
      end
      end)
  elseif l_3_0.type == "pve" then
    local params = {sid = player.sid, camp = l_3_0.hids}
    tbl2string(params)
    addWaitNet()
    net:pve(params, function(l_3_0)
      delWaitNet()
      tbl2string(l_3_0)
      if l_3_0.status < 0 then
        showToast("status:" .. l_3_0.status)
        return 
      end
      local preLv = player.lv()
      bag.addRewards(l_3_0.video.reward)
      local curLv = player.lv()
      require("data.tutorial").goNext("hook", 2, true)
      local video = l_3_0.video
      video.camp = content.hids
      for ii = 1, #video.camp do
        if video.camp[ii].pos == 7 then
          local petid = video.camp[ii].id
          local petData = require("data.pet")
          local petInfo = petData.getData(petid)
          if not video.atk then
            video.atk = {}
          end
          video.atk.pet = petInfo
          video.camp[ii] = nil
        end
      end
      video.stage = hookdata.getPveStageId()
      video.preLv = preLv
      video.curLv = curLv
      if video.win then
        hookdata.pveWin()
      end
      replaceScene(require("fight.pve.loading").create(video))
      end)
  elseif l_3_0.type == "airisland" then
    local airData = require("data.airisland")
    if airData.data.vit.vit <= 0 then
      showToast(i18n.global.airisland_toast_noflr.string)
      return 
    end
    local params = {sid = player.sid, camp = l_3_0.hids, pos = l_3_0.pos}
    if l_3_0.cdk then
      params.cdk = l_3_0.cdk
    end
    tbl2string(params)
    addWaitNet()
    net:island_fight(params, function(l_4_0)
      delWaitNet()
      tbl2string(l_4_0)
      if l_4_0.status == -5 then
        showToast(i18n.global.floatland_toast_overtime.string)
        return 
      end
      if l_4_0.status == -3 then
        showToast(i18n.global.airisland_toast_noflr.string)
        return 
      end
      if l_4_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_4_0.status))
        return 
      end
      local video = clone(l_4_0)
      bag.addRewards(video.reward)
      video.uid = content.uid
      video.camp = content.hids
      video.stage = content.stage
      video.curparams = params
      airData.changeVit(-1)
      if not l_4_0.win or not video.atk then
        video.atk = {}
      end
      video.atk.camp = content.hids
      processPetPosAtk1(video)
      processPetPosDef2(video)
      replaceScene(require("fight.airisland.loading").create(video))
      end)
  elseif l_3_0.type == "friend" then
    local friendboss = require("data.friendboss")
    if friendboss.enegy <= 0 then
      showToast(i18n.global.friendboss_no_enegy.string)
      return 
    end
    local params = {sid = player.sid, camp = l_3_0.hids, uid = l_3_0.uid}
    tbl2string(params)
    addWaitNet()
    net:frd_boss_fight(params, function(l_5_0)
      delWaitNet()
      tbl2string(l_5_0)
      local friend = require("data.friend")
      if l_5_0.status == -1 then
        showToast(i18n.global.friendboss_no_enegy.string)
        return 
      elseif l_5_0.status == -5 then
        showToast(i18n.global.event_processing.string)
        return 
      elseif l_5_0.status == -4 then
        showToast(i18n.global.frdboss_fight_notlv.string)
        return 
      end
      if l_5_0.status == -3 then
        showToast(i18n.global.friendboss_boss_die.string)
        if pUid == player.uid then
          friendboss.upscd()
        else
          friend.changebossst(pUid, false)
          return 
        end
        if l_5_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_5_0.status))
          return 
        end
        do
          local video = clone(l_5_0)
          if video.rewards and video.select then
            bag.addRewards(video.rewards[video.select])
          end
          video.uid = content.uid
          video.camp = content.hids
          video.stage = content.stage
          video.curparams = params
          friendboss.delEnegy(1)
          if l_5_0.win then
            if pUid == player.uid then
              friendboss.upscd()
            else
              friend.changebossst(pUid, false)
            end
          end
          if not video.atk then
            video.atk = {}
          end
          video.atk.camp = content.hids
          processPetPosAtk1(video)
          processPetPosDef2(video)
          friendboss.video = clone(video)
          replaceScene(require("fight.frdboss.loading").create(video))
        end
         -- Warning: missing end command somewhere! Added here
      end
      end)
  elseif l_3_0.type == "guildmill" then
    local params = {sid = player.sid, camp = l_3_0.hids}
    addWaitNet()
    net:gmill_start(params, function(l_6_0)
      delWaitNet()
      tbl2string(l_6_0)
      if l_6_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_6_0.status))
        return 
      end
      content.callBack()
      end)
  elseif l_3_0.type == "guildmillharry" then
    local params = {sid = player.sid, camp = l_3_0.hids}
    addWaitNet()
    net:gmill_fight(params, function(l_7_0)
      delWaitNet()
      tbl2string(l_7_0)
      if l_7_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_7_0.status))
        return 
      end
      local video = clone(l_7_0)
      local video = l_7_0.video
      video.atk = {}
      video.atk.camp = content.hids
      video.atk.name = player.name
      video.atk.lv = player.lv()
      video.atk.logo = player.logo
      processPetPosAtk1(video)
      processPetPosDef2(video)
      if video.rewards then
        bag.addRewards(video.rewards[1])
      end
      if video.win then
        local activityData = require("data.activity")
        activityData.addScore(activityData.IDS.SCORE_FIGHT.ID, 1)
      end
      video.from_layer = {from_layer = "gmill"}
      replaceScene(require("fight.pvpgmill.loading").create(video))
      end)
  elseif l_3_0.type == "guildGray" then
    local params = {sid = player.sid, camp = l_3_0.hids}
    tbl2string(params)
    addWaitNet()
    net:gfire_fight(params, function(l_8_0)
      delWaitNet()
      if l_8_0.status < 0 then
        if l_8_0.status == -2 then
          showToast(i18n.global.gboss_fight_st5.string)
        elseif l_8_0.status == -3 then
          showToast(i18n.global.gboss_fight_st3.string)
        elseif l_8_0.status == -4 then
          showToast(i18n.global.gboss_fight_st4.string)
        else
          showToast("status:" .. l_8_0.status)
          return 
        end
        local video = l_8_0
        video.boss = content.id
        video.camp = params.camp
        tbl2string(l_8_0)
        if not video.atk then
          video.atk = {}
        end
        video.atk.camp = content.hids
        processPetPosAtk1(video)
        processPetPosDef2(video)
        do
          local cfgguildfire = require("config.guildfire")
          bag.addRewards(reward2Pbbag(cfgguildfire[content.id].reward))
          replaceScene(require("fight.grayboss.loading").create(video))
        end
         -- Warning: missing end command somewhere! Added here
      end
      end)
  elseif l_3_0.type == "guildVice" then
    local params = {sid = player.sid, camp = l_3_0.hids, uid = player.uid, id = l_3_0.id}
    tbl2string(params)
    addWaitNet()
    net:gboss_fight(params, function(l_9_0)
      delWaitNet()
      if l_9_0.status < 0 then
        if l_9_0.status == -1 then
          showToast(i18n.global.gboss_fight_st1.string)
        elseif l_9_0.status == -2 then
          showToast(i18n.global.gboss_fight_st2.string)
        elseif l_9_0.status == -3 then
          showToast(i18n.global.gboss_fight_st3.string)
        elseif l_9_0.status == -5 then
          showToast(i18n.global.gboss_fight_st5.string)
        elseif l_9_0.status == -6 then
          showToast(i18n.global.gboss_fight_st6.string)
        else
          showToast("status:" .. l_9_0.status)
          return 
        end
        do
          local video = l_9_0
          video.boss = params.id
          video.camp = params.camp
          tbl2string(l_9_0)
          if not video.atk then
            video.atk = {}
          end
          video.atk.camp = content.hids
          processPetPosAtk1(video)
          processPetPosDef2(video)
          require("data.guild").addExp(l_9_0.exp or 0)
          require("data.bag").subGem(content.gems)
          require("data.gboss").addPlainReward(params.id)
          replaceScene(require("fight.gboss.loading").create(video))
        end
         -- Warning: missing end command somewhere! Added here
      end
      end)
  elseif l_3_0.type == "challenge" then
    local params = {sid = player.sid, camp = l_3_0.hids, id = l_3_0.data.id, type = l_3_0.data.type}
    tbl2string(params)
    addWaitNet()
    net:dare_fight(params, function(l_10_0)
      delWaitNet()
      tbl2string(l_10_0)
      if l_10_0.status < 0 then
        showToast("status:" .. l_10_0.status)
        return 
      end
      local video = clone(l_10_0)
      video.camp = content.hids
      video.type = params.type
      video.curparams = params
      if not video.atk then
        video.atk = {}
      end
      video.atk.camp = content.hids
      processPetPosAtk1(video)
      processPetPosDef2(video)
      if l_10_0.win == true then
        require("data.dare").win(params.type)
        local dailytask = require("data.task")
        dailytask.increment(dailytask.TaskType.CHALLENGE, 1)
        local darestage = require("config.darestage")
        local rewards = darestage[l_10_0.stage].reward
        for i,v in ipairs(rewards) do
          if v.type == 1 then
            bag.items.add(v)
            for i,v in (for generator) do
            end
            bag.equips.add(v)
          end
        end
        local dareData = require("data.dare")
        dareData.video = clone(video)
        if arenaSkip() == "enable" then
          if video.win then
            CCDirector:sharedDirector():getRunningScene():addChild(require("fight.dare.win").create(video), 1000)
          else
            CCDirector:sharedDirector():getRunningScene():addChild(require("fight.dare.lose").create(video), 1000)
          end
        else
          replaceScene(require("fight.dare.loading").create(video))
        end
         -- Warning: missing end command somewhere! Added here
      end
      end)
  elseif l_3_0.type == "ArenaAtk" then
    local params = {sid = player.sid, camp = l_3_0.hids, uid = l_3_0.info.uid, id = 1}
    addWaitNet()
    net:pvp_fight(params, function(l_11_0)
      delWaitNet()
      if l_11_0.status == -3 then
        showToast(i18n.global.event_processing.string)
        return 
      elseif l_11_0.status < 0 then
        showToast("status:" .. l_11_0.status)
        return 
      end
      local arenaData = require("data.arena")
      local video = l_11_0.video
      video.atk.camp = content.hids
      video.atk.name = player.name
      video.atk.lv = player.lv()
      video.atk.logo = player.logo
      video.atk.score = arenaData.score
      arenaData.update(video.ascore)
      local tmp = video.def.camp
      video.def = {}
      video.def = clone(content.info)
      video.def.camp = tmp
      processPetPosAtk1(video)
      processPetPosDef2(video)
      if video.rewards and video.select then
        bag.addRewards(video.rewards[video.select])
      end
      arenaData.fight = arenaData.fight + 1
      bag.items.sub({id = ITEM_ID_ARENA, num = content.cost})
      tbl2string(video)
      local achieveData = require("data.achieve")
      local mactivityData = require("data.monthlyactivity")
      if video.win then
        achieveData.add(ACHIEVE_TYPE_ARENA_ATTACK, 1)
        mactivityData.addScore(mactivityData.IDS.SCORE_FIGHT.ID, 2)
      else
        mactivityData.addScore(mactivityData.IDS.SCORE_FIGHT.ID, 1)
      end
      local dailytask = require("data.task")
      dailytask.increment(dailytask.TaskType.ARENA, 1)
      video.from_layer = "task"
      if arenaSkip() == "enable" then
        if video.win then
          CCDirector:sharedDirector():getRunningScene():addChild(require("fight.pvp.win").create(l_11_0.video), 1000)
        else
          CCDirector:sharedDirector():getRunningScene():addChild(require("fight.pvp.lose").create(l_11_0.video), 1000)
        end
      else
        replaceScene(require("fight.pvp.loading").create(l_11_0.video))
      end
      end)
  elseif l_3_0.type == "guildFight" then
    local params = {sid = player.sid, camp = l_3_0.hids}
    addWaitNet()
    net:guild_fight_camp(params, function(l_12_0)
      delWaitNet()
      tbl2string(l_12_0)
      if l_12_0.status ~= 0 then
        if l_12_0.status == -4 then
          showToast(i18n.global.guiidFight_toast_reg_end.string)
        elseif l_12_0.status == -3 then
          showToast(i18n.global.guiidFight_toast_is_out.string)
        elseif l_12_0.status == -5 then
          showToast(i18n.global.guildFight_settingteam_st5.string)
        elseif l_12_0.status == -6 then
          showToast(i18n.global.gfight_limitsetcamp.string)
        else
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_12_0.status))
          return 
        end
        if not tolua.isnull(content.layer) then
          content.layer:removeFromParent()
        end
        content.callBack(content.hids)
         -- Warning: missing end command somewhere! Added here
      end
      end)
  elseif l_3_0.type == "frdpk" then
    local params = {sid = player.sid, camp = l_3_0.hids, uid = l_3_0.info.uid}
    addWaitNet()
    net:frd_pk(params, function(l_13_0)
      tbl2string(l_13_0)
      delWaitNet()
      if l_13_0.status == -1 then
        showToast(i18n.global.toast_arena_nocamp.string)
        return 
      end
      if l_13_0.status < 0 then
        showToast("status:" .. l_13_0.status)
        return 
      end
      local video = l_13_0.video
      video.atk.camp = content.hids
      video.atk.name = player.name
      video.atk.lv = player.lv()
      video.atk.logo = player.logo
      local tmp = video.def.camp
      video.def = {}
      video.def = clone(content.info)
      video.def.camp = tmp
      processPetPosAtk1(video)
      processPetPosDef2(video)
      video.from_layer = {from_layer = "frdpk"}
      video.curparams = params
      video.info = content.info
      replaceScene(require("fight.frdpk.loading").create(video))
      end)
  elseif l_3_0.type == "brokenboss" then
    local tick_num = 0
    if bag.items.find(ITEM_ID_BROKEN) then
      tick_num = bag.items.find(ITEM_ID_BROKEN).num
    end
    if tick_num <= 0 then
      showToast(i18n.global.tips_act_ticket_lack.string)
      return 
    end
    local params = {sid = player.sid, camp = l_3_0.hids, id = l_3_0.stage}
    tbl2string(params)
    addWaitNet()
    net:bboss_fight(params, function(l_14_0)
      delWaitNet()
      tbl2string(l_14_0)
      if l_14_0.status == -2 then
        showToast(i18n.global.friendboss_boss_die.string)
      end
      if l_14_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_14_0.status))
        return 
      end
      local video = clone(l_14_0)
      if video.rewards and video.select then
        bag.addRewards(video.rewards[video.select])
      end
      video.uid = content.uid
      video.camp = content.hids
      video.stage = content.stage
      bag.items.sub({id = ITEM_ID_BROKEN, num = 1})
      if not video.atk then
        video.atk = {}
      end
      video.atk.camp = content.hids
      processPetPosAtk1(video)
      processPetPosDef2(video)
      replaceScene(require("fight.broken.loading").create(video))
      end)
  elseif l_3_0.type == "sweepforbrokenboss" then
    local params = {sid = player.sid, camp = l_3_0.hids, id = l_3_0.stage, num = l_3_0.num}
    tbl2string(params)
    addWaitNet()
    net:bboss_batch(params, function(l_15_0)
      delWaitNet()
      tbl2string(l_15_0)
      if l_15_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_15_0.status))
        return 
      end
      bag.items.sub({id = ITEM_ID_BROKEN, num = l_15_0.num})
      bag.addRewards(l_15_0.reward)
      content.callback(l_15_0.reward, l_15_0.num)
      end)
  elseif l_3_0.type == "sweepforfboss" then
    local params = {sid = player.sid, camp = l_3_0.hids, uid = l_3_0.uid, num = l_3_0.num}
    addWaitNet()
    net:fboss_batch(params, function(l_16_0)
      delWaitNet()
      tbl2string(l_16_0)
      if l_16_0.status == -4 then
        showToast(i18n.global.frdboss_fight_notlv.string)
        return 
      end
      if l_16_0.status == -3 then
        showToast(i18n.global.friendboss_boss_die.string)
        return 
      end
      if l_16_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_16_0.status))
        return 
      end
      bag.addRewards(l_16_0.reward)
      content.callback(l_16_0)
      if player.uid == content.uid then
        content.callback2(l_16_0.hpps[1])
      end
      local friendboss = require("data.friendboss")
      friendboss.delEnegy(l_16_0.num)
      end)
  elseif l_3_0.type == "sweepforcomisland" then
    local params = {sid = player.sid, camp = l_3_0.hids}
    tbl2string(params)
    addWaitNet()
    net:island_sweep(params, function(l_17_0)
      delWaitNet()
      tbl2string(l_17_0)
      if l_17_0.status == -3 then
        showToast(i18n.global.island_nosweepisland.string)
        return 
      end
      if l_17_0.status == -1 then
        showToast(i18n.global.airisland_toast_noflr.string)
        return 
      end
      if l_17_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_17_0.status))
        return 
      end
      local airData = require("data.airisland")
      airData.calVit(l_17_0.num)
      bag.addRewards(l_17_0.reward)
      content.callback(l_17_0.reward, l_17_0.num)
      if l_17_0.poss and #l_17_0.poss > 0 then
        content.callback2(l_17_0.poss)
      end
      end)
  elseif l_3_0.type == "sweepforairisland" then
    local params = {sid = player.sid, camp = l_3_0.hids, pos = l_3_0.pos, num = l_3_0.num}
    tbl2string(params)
    addWaitNet()
    net:island_batch(params, function(l_18_0)
      delWaitNet()
      tbl2string(l_18_0)
      if l_18_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_18_0.status))
        return 
      end
      local airData = require("data.airisland")
      airData.changeVit(not l_18_0.num)
      bag.addRewards(l_18_0.reward)
      content.callback(l_18_0.reward, l_18_0.num)
      if content.pos == 0 and l_18_0.hpps[1] == 0 then
        content.callback2(0)
      end
      if content.pos ~= 0 then
        local flaghp = false
        for i = 1, #l_18_0.hpps do
          if l_18_0.hpps[i] ~= 0 then
            flaghp = true
        else
          end
        end
        if flaghp == false then
          content.callback2(content.pos)
        end
      end
      end)
  elseif l_3_0.type == "FrdArena" then
    local params = {sid = player.sid, camp = l_3_0.hids}
    addWaitNet()
    net:gpvp_set_camp(params, function(l_19_0)
      delWaitNet()
      tbl2string(l_19_0)
      if l_19_0.status >= 0 then
        addWaitNet()
        net:gpvp_sync(params, function(l_1_0)
          delWaitNet()
          local frdarena = require("data.frdarena")
          frdarena.init(l_1_0)
          local hids = {}
          for i,v in ipairs(heros) do
            if v.flag and bit.band(v.flag, 8) ~= 0 then
              v.flag = v.flag - 8
            end
          end
          for i,v in ipairs(params.camp) do
            hids[#hids + 1] = v.hid
          end
          heros.setFlag(hids, 8)
          replaceScene(require("ui.frdarena.main").create())
            end)
      end
      end)
  elseif l_3_0.type == "sealland" then
    local params = {sid = player.sid, id = l_3_0.data.id, camp = l_3_0.hids}
    addWaitNet()
    net:sealland_fight(params, function(l_20_0)
      delWaitNet()
      tbl2string(l_20_0)
      if l_20_0.status == -2 then
        showToast(i18n.global.sealland_nomaxlevel.string)
        return 
      end
      if l_20_0.status == -3 then
        showToast(i18n.global.sealland_overmaxwin.string)
        return 
      end
      if l_20_0.status == -4 then
        showToast(i18n.global.sealland_overmaxfight.string)
        return 
      end
      if l_20_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_20_0.status))
        return 
      end
      local video = clone(l_20_0)
      video.camp = content.hids
      video.stage = content.data.id
      video.group = content.data.group
      local cfgsealland = require("config.sealland")
      local reward = {}
      local equips = {}
      local items = {}
      for i = 1, #cfgsealland[video.stage].firstReward do
        local cfginfo = cfgsealland[video.stage].firstReward[i]
        if cfginfo.type == 1 then
          items[#items + 1] = {id = cfginfo.id, num = cfginfo.num}
        else
          equips[#equips + 1] = {id = cfginfo.id, num = cfginfo.num}
        end
      end
      reward.equips = equips
      reward.items = items
      if video.win then
        video.reward = reward
        bag.addRewards(video.reward)
        seallandData:win(content.data.group)
      else
        seallandData:lose(content.data.group)
      end
      if not video.atk then
        video.atk = {}
      end
      video.atk.camp = content.hids
      processPetPosAtk1(video)
      processPetPosDef2(video)
      if arenaSkip() == "enable" then
        local callbackRemove = function()
        if content.layer and not tolua.isnull(content.layer) then
          content.layer:removeFromParentAndCleanup(true)
        end
        content.callback()
         end
        if video.win then
          content.layer:addChild(require("fight.sealland.win").create(video), 1000)
        else
          content.layer:addChild(require("fight.sealland.lose").create(video), 1000)
        end
      else
        replaceScene(require("fight.sealland.loading").create(video))
      end
      end)
  end
end

ui.create = function(l_4_0)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, 0))
  layer:addChild(darkbg)
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(825, 410))
  board:setAnchorPoint(ccp(0.5, 0))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY + 34 * view.minScale)
  layer:addChild(board)
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(800, 385)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local title = lbl.createFont1(26, i18n.global.select_hero_title.string, ccc3(230, 208, 174))
  title:setPosition(413, 382)
  board:addChild(title, 1)
  local titleShade = lbl.createFont1(26, i18n.global.select_hero_title.string, ccc3(89, 48, 27))
  titleShade:setPosition(413, 380)
  board:addChild(titleShade)
  local heroCampBg = img.createUI9Sprite(img.ui.select_hero_camp_bg)
  heroCampBg:setPreferredSize(CCSize(770, 205))
  heroCampBg:setPosition(414, 240)
  board:addChild(heroCampBg, 1)
  local heroSkillBg = img.createUI9Sprite(img.ui.select_hero_buff_bg)
  heroSkillBg:setPreferredSize(CCSize(769, 76))
  heroSkillBg:setPosition(414, 85)
  board:addChild(heroSkillBg)
  local campWidget = require("ui.selecthero.campLayer").create()
  board:addChild(campWidget.layer, 20)
  campWidget.layer:setPosition(CCPoint(11, 35))
  local btnBattleSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnBattleSprite:setPreferredSize(CCSize(110, 78))
  local btnBattleIcon = img.createUISprite(img.ui.select_hero_btn_icon)
  btnBattleIcon:setPosition(btnBattleSprite:getContentSize().width / 2, btnBattleSprite:getContentSize().height / 2)
  btnBattleSprite:addChild(btnBattleIcon)
  local btnBattle = SpineMenuItem:create(json.ui.button, btnBattleSprite)
  btnBattle:setPosition(708, 211)
  local menuBattle = CCMenu:createWithItem(btnBattle)
  menuBattle:setPosition(0, 0)
  board:addChild(menuBattle, 1)
  local selectTeamBg = img.createUI9Sprite(img.ui.select_tab_tab_bg)
  selectTeamBg:setPreferredSize(CCSize(759, 37))
  selectTeamBg:setPosition(385, 179)
  heroCampBg:addChild(selectTeamBg)
  local showPowerBg = img.createUISprite(img.ui.select_hero_power_bg)
  showPowerBg:setAnchorPoint(ccp(0, 0.5))
  showPowerBg:setPosition(0, 19)
  selectTeamBg:addChild(showPowerBg)
  local powerIcon = img.createUISprite(img.ui.power_icon)
  powerIcon:setScale(0.46)
  powerIcon:setPosition(27, 21)
  showPowerBg:addChild(powerIcon)
  local showPower = lbl.createFont2(20, "0")
  showPower:setAnchorPoint(ccp(0, 0.5))
  showPower:setPosition(powerIcon:boundingBox():getMaxX() + 15, powerIcon:boundingBox():getMidY())
  showPowerBg:addChild(showPower)
  local labFront = lbl.createFont1(18, i18n.global.select_hero_front.string, ccc3(78, 48, 24))
  labFront:setAnchorPoint(ccp(0.5, 0.5))
  labFront:setPosition(122, 135)
  heroCampBg:addChild(labFront)
  local labBehind = lbl.createFont1(18, i18n.global.select_hero_behind.string, ccc3(78, 48, 24))
  labBehind:setAnchorPoint(ccp(0.5, 0.5))
  labBehind:setPosition(415, 135)
  heroCampBg:addChild(labBehind)
  local POSX = {78, 168, 281, 371, 461, 551}
  local baseHeroBg = {}
  local showHeros = {}
  local hids = {}
  local headIcons = {}
  local herolist = initHerolistData(l_4_0)
  for i = 1, 6 do
    baseHeroBg[i] = img.createUI9Sprite(img.ui.herolist_withouthero_bg)
    baseHeroBg[i]:setPreferredSize(CCSize(84, 84))
    baseHeroBg[i]:setPosition(POSX[i], 74)
    heroCampBg:addChild(baseHeroBg[i])
  end
  local loadHeroCamps = function(l_2_0)
    print("\230\137\147\229\141\176\229\189\147\229\137\141\233\152\181\229\174\185")
    tablePrint(l_2_0)
    for i = 1, 6 do
      if l_2_0[i] and l_2_0[i] > 0 then
        local heroInfo = heros.find(l_2_0[i])
        if heroInfo then
          local param = {id = heroInfo.id, lv = heroInfo.lv, showGroup = true, showStar = 3, wake = heroInfo.wake, orangeFx = nil, petID = petBattle.getNowSele(), hid = heroInfo.hid}
          showHeros[i] = img.createHeroHeadByParam(param)
          showHeros[i]:setScale(0.8936170212766)
          showHeros[i]:setPosition(POSX[i], 74)
          heroCampBg:addChild(showHeros[i])
        else
          l_2_0[i] = 0
        end
      end
    end
   end
  local btn_skip0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_skip0:setPreferredSize(CCSizeMake(180, 46))
  local skip_bg = img.createUISprite(img.ui.option_bg)
  skip_bg:setPosition(CCPoint(23, 24))
  btn_skip0:addChild(skip_bg)
  local skip_tick = img.createUISprite(img.ui.option_tick)
  skip_tick:setPosition(CCPoint(23, 24))
  btn_skip0:addChild(skip_tick)
  local lbl_skip = lbl.create({font = 1, size = 18, text = i18n.global.btn_skip_fight.string, color = ccc3(115, 59, 5), fr = {size = 14}, ru = {size = 14}})
  lbl_skip:setPosition(CCPoint(100, 23))
  btn_skip0:addChild(lbl_skip)
  local btn_skip = SpineMenuItem:create(json.ui.button, btn_skip0)
  btn_skip:setPosition(CCPoint(515, 17))
  local btn_skip_menu = CCMenu:createWithItem(btn_skip)
  btn_skip_menu:setPosition(CCPoint(0, 0))
  selectTeamBg:addChild(btn_skip_menu)
  if not l_4_0 then
    btn_skip:setVisible(false)
  elseif l_4_0.type == "ArenaAtk" then
    btn_skip:setVisible(true)
  elseif l_4_0.type == "challenge" then
    btn_skip:setVisible(true)
  elseif l_4_0.type == "sealland" then
    btn_skip:setVisible(true)
  else
    btn_skip:setVisible(false)
  end
  local updateSkip = function()
    if arenaSkip() == "enable" then
      skip_tick:setVisible(true)
    else
      skip_tick:setVisible(false)
    end
   end
  updateSkip()
  btn_skip:registerScriptTapHandler(function()
    audio.play(audio.button)
    if arenaSkip() == "enable" then
      arenaSkip("disable")
    else
      arenaSkip("enable")
    end
    updateSkip()
   end)
  local petCallBack = function()
    for k,v in pairs(showHeros) do
      v:removeFromParent()
    end
    showHeros = {}
    loadHeroCamps(hids)
   end
  local spPet = img.createLogin9Sprite(img.login.button_9_small_purple)
  spPet:setPreferredSize(CCSizeMake(150, 46))
  local spIcon = img.createUISprite(img.ui.pet_leg)
  spPet:addChild(spIcon)
  local btnLal = lbl.createFont1(16, i18n.global.pet_battle_btn_lal.string, ccc3(92, 25, 142))
  spPet:addChild(btnLal)
  local btnPet = SpineMenuItem:create(json.ui.button, spPet)
  require("dhcomponents.DroidhangComponents"):mandateNode(btnPet, "yw_petBattle_btnPet")
  require("dhcomponents.DroidhangComponents"):mandateNode(spIcon, "yw_petBattle_spIcon")
  require("dhcomponents.DroidhangComponents"):mandateNode(btnLal, "yw_petBattle_btnLal")
  local menuPet = CCMenu:createWithItem(btnPet)
  menuPet:setPosition(0, 0)
  selectTeamBg:addChild(menuPet, 1)
  btnPet:registerScriptTapHandler(function()
    btnPet:setEnabled(false)
    disableObjAWhile(btnPet)
    audio.play(audio.button)
    petBattle.create(layer, petCallBack)
   end)
  local herolistBg = img.createUI9Sprite(img.ui.tips_bg)
  herolistBg:setPreferredSize(CCSize(957, 112))
  herolistBg:setScale(view.minScale)
  herolistBg:setAnchorPoint(ccp(0.5, 1))
  herolistBg:setPosition(view.midX, view.minY + 0 * view.minScale)
  layer:addChild(herolistBg)
  SCROLLVIEW_WIDTH = 793
  SCROLLVIEW_HEIGHT = 112
  SCROLLCONTENT_WIDTH = #herolist * 90 + 8
  scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionHorizontal)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(7, 0)
  scroll:setViewSize(CCSize(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT))
  scroll:setContentSize(CCSizeMake(SCROLLCONTENT_WIDTH, SCROLLVIEW_HEIGHT))
  herolistBg:addChild(scroll)
  local btnFilterSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnFilterSprite:setPreferredSize(CCSize(130, 70))
  local btnFilterIcon = lbl.createFont1(20, i18n.global.selecthero_btn_hero.string, ccc3(115, 59, 5))
  btnFilterIcon:setPosition(btnFilterSprite:getContentSize().width / 2, btnFilterSprite:getContentSize().height / 2)
  btnFilterSprite:addChild(btnFilterIcon)
  local btnFilter = SpineMenuItem:create(json.ui.button, btnFilterSprite)
  btnFilter:setPosition(873, 56)
  local menuFilter = CCMenu:createWithItem(btnFilter)
  menuFilter:setPosition(0, 0)
  herolistBg:addChild(menuFilter, 1)
  local filterBg = img.createUI9Sprite(img.ui.tips_bg)
  filterBg:setPreferredSize(CCSize(122, 458))
  filterBg:setScale(view.minScale)
  filterBg:setAnchorPoint(ccp(1, 0))
  filterBg:setPosition(scalep(938, 110))
  layer:addChild(filterBg)
  local showHeroLayer = CCLayer:create()
  scroll:getContainer():addChild(showHeroLayer)
  local selectBatch, blackBatch = nil, nil
  local createHerolist = function()
    showHeroLayer:removeAllChildrenWithCleanup(true)
    arrayclear(headIcons)
    scroll:setContentSize(CCSizeMake(#herolist * 90 + 8, SCROLLVIEW_HEIGHT))
    scroll:setContentOffset(ccp(0, 0))
    local iconBgBatch = img.createBatchNodeForUI(img.ui.herolist_head_bg)
    showHeroLayer:addChild(iconBgBatch, 1)
    local iconBgBatch1 = img.createBatchNodeForUI(img.ui.hero_star_ten_bg)
    showHeroLayer:addChild(iconBgBatch1, 1)
    local groupBgBatch = img.createBatchNodeForUI(img.ui.herolist_group_bg)
    showHeroLayer:addChild(groupBgBatch, 3)
    local starBatch = img.createBatchNodeForUI(img.ui.star_s)
    showHeroLayer:addChild(starBatch, 3)
    local star10Batch = img.createBatchNodeForUI(img.ui.hero_star_ten)
    showHeroLayer:addChild(star10Batch, 3)
    local star1Batch = img.createBatchNodeForUI(img.ui.hero_star_orange)
    showHeroLayer:addChild(star1Batch, 3)
    upvalue_2048 = CCNode:create()
    showHeroLayer:addChild(blackBatch, 5)
    upvalue_2560 = img.createBatchNodeForUI(img.ui.hook_btn_sel)
    showHeroLayer:addChild(selectBatch, 5)
    for i = 1, #herolist do
      local x, y = 45 + (i - 1) * 90 + 8, 56
      local qlt = cfghero[herolist[i].id].maxStar
      local heroBg = nil
      if qlt == 10 then
        heroBg = img.createUISprite(img.ui.hero_star_ten_bg)
        heroBg:setPosition(x, y)
        heroBg:setScale(0.92)
        iconBgBatch1:addChild(heroBg)
        json.load(json.ui.lv10_framefx)
      else
        heroBg = img.createUISprite(img.ui.herolist_head_bg)
        heroBg:setScale(0.92)
        heroBg:setPosition(x, y)
        iconBgBatch:addChild(heroBg)
      end
      headIcons[i] = img.createHeroHeadByHid(herolist[i].hid)
      headIcons[i]:setScale(0.92)
      headIcons[i]:setPosition(x, y)
      showHeroLayer:addChild(headIcons[i], 2)
    end
   end
  local checkUpdate = function()
    local power = 0
    local sk = 0
    for i = 1, 6 do
      if hids[i] and hids[i] > 0 and heros.find(hids[i]) then
        power = power + heros.power(hids[i])
        local heroData = heros.find(hids[i])
        if bit.band(sk, bit.blshift(1, cfghero[heroData.id].group - 1)) == 0 then
          sk = sk + bit.blshift(1, cfghero[heroData.id].group - 1)
        end
      end
    end
    showPower:setString(power)
    if heroSkillBg:getChildByTag(1) then
      heroSkillBg:removeChildByTag(1)
    end
    for i = 1, #require("ui.selecthero.campLayer").BuffTable do
      campWidget.icon[i]:setVisible(false)
    end
    local heroids = {}
    for i = 1, 6 do
      heroids[i] = nil
      if heros.find(hids[i]) ~= nil then
        heroids[i] = heros.find(hids[i]).id
      end
    end
    local showIcon = require("ui.selecthero.campLayer").checkUpdateForHeroids(heroids, true)
    if showIcon ~= -1 then
      campWidget.icon[showIcon]:setVisible(true)
    end
   end
  local onMoveUp = function(l_9_0, l_9_1, l_9_2)
    checkUpdate()
    if not l_9_2 then
      local heroInfo = heros.find(hids[l_9_1])
      local param = {id = heroInfo.id, lv = heroInfo.lv, showGroup = true, showStar = 3, wake = heroInfo.wake, orangeFx = nil, petID = petBattle.getNowSele(), hid = heroInfo.hid}
      showHeros[l_9_1] = img.createHeroHeadByParam(param)
      showHeros[l_9_1]:setScale(0.91489361702128)
      showHeros[l_9_1]:setPosition(POSX[l_9_1], 74)
      heroCampBg:addChild(showHeros[l_9_1])
    end
    local blackBoard = CCLayerColor:create(ccc4(0, 0, 0, 120))
    blackBoard:setContentSize(CCSize(84, 84))
    blackBoard:setPosition(headIcons[l_9_0]:getPositionX() - 42, headIcons[l_9_0]:getPositionY() - 42)
    blackBatch:addChild(blackBoard, 0, l_9_0)
    local selectIcon = img.createUISprite(img.ui.hook_btn_sel)
    selectIcon:setPosition(headIcons[l_9_0]:getPositionX(), headIcons[l_9_0]:getPositionY())
    selectBatch:addChild(selectIcon, 0, l_9_0)
   end
  local moveUp = function(l_10_0)
    local tpos = nil
    do
      for i = 1, 6 do
        if not hids[i] or hids[i] == 0 then
          tpos = i
      else
        end
      end
    end
    if tpos and not herolist[l_10_0].isUsed then
      herolist[l_10_0].isUsed = true
      hids[tpos] = herolist[l_10_0].hid
      local worldbpos = scroll:getContainer():convertToWorldSpace(ccp(headIcons[l_10_0]:getPositionX(), headIcons[l_10_0]:getPositionY()))
      local realbpos = board:convertToNodeSpace(worldbpos)
      local worldepos = heroCampBg:convertToWorldSpace(ccp(baseHeroBg[tpos]:getPositionX(), baseHeroBg[tpos]:getPositionY()))
      local realepos = board:convertToNodeSpace(worldepos)
      local param = {id = herolist[l_10_0].id}
      local tempHero = img.createHeroHeadByParam(param)
      tempHero:setScale(0.92)
      tempHero:setPosition(realbpos)
      board:addChild(tempHero, 100)
      local arr = CCArray:create()
      arr:addObject(CCMoveTo:create(0.1, realepos))
      local act1 = CCSpawn:create(arr)
      tempHero:runAction(CCSequence:createWithTwoActions(act1, CCCallFunc:create(function()
        tempHero:removeFromParentAndCleanup(true)
        onMoveUp(pos, tpos)
         end)))
    elseif tpos then
      showToast(i18n.global.toast_selhero_selected.string)
    else
      showToast(i18n.global.toast_selhero_already.string)
    end
   end
  local onMoveDown = function(l_11_0, l_11_1)
    checkUpdate()
    blackBatch:removeChildByTag(l_11_1)
    selectBatch:removeChildByTag(l_11_1)
   end
  local moveDown = function(l_12_0)
    local tpos = nil
    do
      for i,v in ipairs(herolist) do
        if hids[l_12_0] == v.hid then
          tpos = i
      else
        end
      end
    end
    if tpos then
      showHeros[l_12_0]:removeFromParentAndCleanup(true)
      showHeros[l_12_0] = nil
      herolist[tpos].isUsed = false
      hids[l_12_0] = nil
      local worldbpos = heroCampBg:convertToWorldSpace(ccp(baseHeroBg[l_12_0]:getPositionX(), baseHeroBg[l_12_0]:getPositionY()))
      local realbpos = board:convertToNodeSpace(worldbpos)
      local worldepos = scroll:getContainer():convertToWorldSpace(ccp(headIcons[tpos]:getPositionX(), headIcons[tpos]:getPositionY()))
      local realepos = board:convertToNodeSpace(worldepos)
      local param = {id = herolist[tpos].id}
      local tempHero = img.createHeroHeadByParam(param)
      tempHero:setPosition(realbpos)
      tempHero:setScale(0.92)
      board:addChild(tempHero, 100)
      local arr = CCArray:create()
      arr:addObject(CCMoveTo:create(0.1, realepos))
      local act1 = CCSpawn:create(arr)
      tempHero:runAction(CCSequence:createWithTwoActions(act1, CCCallFunc:create(function()
        tempHero:removeFromParentAndCleanup(true)
        onMoveDown(pos, tpos)
         end)))
    end
   end
  local lastx, preSelect = nil, nil
  local onTouchBegin = function(l_13_0, l_13_1)
    local point = (heroCampBg:convertToNodeSpace(ccp(l_13_0, l_13_1)))
    upvalue_512 = nil
    upvalue_1024 = l_13_0
    for i = 1, 6 do
      if hids[i] and showHeros[i] and showHeros[i]:boundingBox():containsPoint(point) then
        upvalue_512 = i
      end
    end
    return true
   end
  local onTouchMoved = function(l_14_0, l_14_1)
    local point = heroCampBg:convertToNodeSpace(ccp(l_14_0, l_14_1))
    if preSelect and math.abs(l_14_0 - lastx) >= 10 then
      showHeros[preSelect]:setPosition(point)
      showHeros[preSelect]:setZOrder(1)
    end
    return true
   end
  local onTouchEnd = function(l_15_0, l_15_1)
    if not scroll or tolua.isnull(scroll) then
      return 
    end
    local point = heroCampBg:convertToNodeSpace(ccp(l_15_0, l_15_1))
    local pointOnScroll = scroll:getContainer():convertToNodeSpace(ccp(l_15_0, l_15_1))
    if math.abs(l_15_0 - lastx) < 10 then
      for i,v in ipairs(headIcons) do
        if v:boundingBox():containsPoint(pointOnScroll) then
          audio.play(audio.button)
          moveUp(i)
        end
      end
      for i = 1, 6 do
        if hids[i] and showHeros[i] and showHeros[i]:boundingBox():containsPoint(point) then
          audio.play(audio.button)
          moveDown(i)
        end
      end
    end
    if not preSelect or math.abs(l_15_0 - lastx) < 10 then
      return true
    end
    local ifset = false
    for i = 1, 6 do
      if baseHeroBg[i]:boundingBox():containsPoint(point) and math.abs(showHeros[preSelect]:getPositionX() - baseHeroBg[i]:getPositionX()) < 33 and math.abs(showHeros[preSelect]:getPositionY() - baseHeroBg[i]:getPositionY()) < 33 then
        ifset = true
        showHeros[preSelect]:setZOrder(0)
        showHeros[preSelect]:setPosition(baseHeroBg[i]:getPosition())
        if hids[i] and showHeros[i] then
          showHeros[i]:setPosition(baseHeroBg[preSelect]:getPosition())
        end
        showHeros[preSelect], showHeros[i] = showHeros[i], showHeros[preSelect]
        hids[preSelect], hids[i] = hids[i], hids[preSelect]
      end
    end
    if ifset == false then
      showHeros[preSelect]:setPosition(baseHeroBg[preSelect]:getPosition())
      showHeros[preSelect]:setZOrder(0)
    end
    return true
   end
  local onTouch = function(l_16_0, l_16_1, l_16_2)
    if l_16_0 == "began" then
      return onTouchBegin(l_16_1, l_16_2)
    elseif l_16_0 == "moved" then
      return onTouchMoved(l_16_1, l_16_2)
    else
      return onTouchEnd(l_16_1, l_16_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  layer.showHint = function()
    local bubble = img.createUI9Sprite(img.ui.tutorial_bubble)
    local bubbleMinWidth, bubbleMinHeight = 208, 82
    bubble:setScale(view.minScale)
    bubble:setAnchorPoint(ccp(0.5, 0))
    bubble:setPosition(scalep(215, 430))
    layer:addChild(bubble)
    local label = lbl.createMix({font = 1, size = 16, text = i18n.global.tutorial_text_new_hit_1.string, color = ccc3(114, 72, 53), width = 350})
    local labelSize = label:boundingBox().size
    label:setAnchorPoint(ccp(0.5, 0.5))
    bubble:addChild(label)
    local bubbleWidth = labelSize.width + 20
    if bubbleWidth < bubbleMinWidth then
      bubbleWidth = bubbleMinWidth
    end
    local bubbleHeight = labelSize.height + 5
    if bubbleHeight < bubbleMinHeight then
      bubbleHeight = bubbleMinHeight
    end
    bubble:setPreferredSize(CCSize(bubbleWidth, bubbleHeight))
    label:setPosition(bubbleWidth / 2, bubbleHeight / 2)
    do
      local bubbleArrow = img.createUISprite(img.ui.tutorial_bubble_arrow)
      bubbleArrow:setRotation(-90)
      bubbleArrow:setPosition(bubbleWidth / 2, -6)
      bubble:addChild(bubbleArrow)
      bubble:setVisible(false)
      bubble:runAction(createSequence({}))
    end
    local bubble = img.createUI9Sprite(img.ui.tutorial_bubble)
    local bubbleMinWidth, bubbleMinHeight = 208, 82
    bubble:setScale(view.minScale)
    bubble:setAnchorPoint(ccp(0.5, 1))
    bubble:setPosition(scalep(514, 280))
    layer:addChild(bubble)
    local label = lbl.createMix({font = 1, size = 16, text = i18n.global.tutorial_text_new_hit_2.string, color = ccc3(114, 72, 53), width = 450})
    local labelSize = label:boundingBox().size
    label:setAnchorPoint(ccp(0.5, 0.5))
    bubble:addChild(label)
    local bubbleWidth = labelSize.width + 20
    if bubbleWidth < bubbleMinWidth then
      local bubbleHeight = labelSize.height + 5
       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    bubble:setPreferredSize(CCSize(bubbleWidth, bubbleHeight))
    label:setPosition(bubbleWidth / 2, bubbleHeight / 2)
    do
      local bubbleArrow = img.createUISprite(img.ui.tutorial_bubble_arrow)
      bubbleArrow:setRotation(90)
      bubbleArrow:setPosition(bubbleWidth / 2, bubbleHeight + 6)
      bubble:addChild(bubbleArrow)
      bubble:setVisible(false)
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

      bubble:runAction(createSequence({}))
    end
     -- Warning: undefined locals caused missing assignments!
   end
  if l_4_0.type == "pve" then
    local hookdata = require("data.hook")
    local pveStage = hookdata.getPveStageId()
    local stageId = 10
    if pveStage >= 3 and pveStage <= stageId then
      layer.showHint()
    end
  end
  btnBattle:registerScriptTapHandler(function()
    audio.play(audio.fight_start_button)
    local cloneHids = clone(hids)
    cloneHids[7] = petBattle.getNowSele()
    if params.type == "pve" then
      userdata.setSquadNormal(cloneHids)
    else
      if params.type == "trial" then
        userdata.setSquadTrial(cloneHids)
      else
        if params.type == "ArenaAtk" then
          userdata.setSquadArenaatk(cloneHids)
        else
          if params.type == "ArenaDef" then
            userdata.setSquadArenadef(cloneHids)
          else
            if params.type == "FrdArena" then
              userdata.setSquadFrdArena(cloneHids)
            else
              if params.type == "guildVice" then
                userdata.setSquadGuildBoss(cloneHids)
              else
                if params.type == "guildGray" then
                  userdata.setSquadGuildGray(cloneHids)
                else
                  if params.type == "challenge" then
                    userdata.setSquadDailyFight(cloneHids)
                  else
                    if params.type == "airisland" then
                      userdata.setSquadAirisland(cloneHids)
                    else
                      if params.type == "friend" then
                        userdata.setSquadFriend(cloneHids)
                      else
                        if params.type == "guildmill" then
                          userdata.setSquadguildmilldef(cloneHids)
                        else
                          if params.type == "guildmillharry" then
                            userdata.setSquadguildmill(cloneHids)
                          else
                            if params.type == "guildFight" then
                              userdata.setGuildFight(cloneHids)
                            else
                              if params.type == "frdpk" then
                                userdata.setSquadFrdpk(cloneHids)
                              else
                                if params.type == "brokenboss" then
                                  userdata.setSquadBrokenboss(cloneHids)
                                else
                                  if params.type == "sweepforbrokenboss" then
                                    userdata.setSquadSweepforbrokenboss(cloneHids)
                                  else
                                    if params.type == "sweepforairisland" then
                                      userdata.setSquadSweepforairisland(cloneHids)
                                    else
                                      if params.type == "sweepforcomisland" then
                                        userdata.setSquadSweepforcomisland(cloneHids)
                                      else
                                        if params.type == "sweepforfboss" then
                                          userdata.setSquadSweepforfboss(cloneHids)
                                        else
                                          if params.type == "sealland" then
                                            if params.data.group == 1 then
                                              userdata.setSquadSealland1(cloneHids)
                                            else
                                              if params.data.group == 2 then
                                                userdata.setSquadSealland2(cloneHids)
                                              else
                                                if params.data.group == 3 then
                                                  userdata.setSquadSealland3(cloneHids)
                                                else
                                                  if params.data.group == 4 then
                                                    userdata.setSquadSealland4(cloneHids)
                                                  else
                                                    if params.data.group == 5 then
                                                      userdata.setSquadSealland5(cloneHids)
                                                    else
                                                      if params.data.group == 6 then
                                                        userdata.setSquadSealland6(cloneHids)
                                                      end
                                                    end
                                                  end
                                                end
                                              end
                                            end
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    local unit = {}
    for i = 1, 6 do
      if hids[i] and hids[i] > 0 then
        unit[#unit + 1] = {hid = hids[i], pos = i}
        local hh = heros.find(hids[i])
        if hh and hh.wake then
          unit[#unit].wake = hh.wake
        end
      end
    end
    params.hids = unit
    params.layer = layer
    onHadleBattle(params)
   end)
  local initLoad = function()
    hids = getCampHids(params)
    petBattle.initData(hids)
    print("\230\156\172\230\172\161\233\152\181\229\174\185 ---  = " .. params.type)
    loadHeroCamps(hids)
    for i,v in ipairs(herolist) do
      for j = 1, 6 do
        if v.hid == hids[j] then
          onMoveUp(i, j, true)
          herolist[i].isUsed = true
        end
      end
    end
   end
  createHerolist()
  initLoad()
  local onEnter = function()
   end
  local onExit = function()
   end
  do
    layer:registerScriptHandler(function(l_22_0)
      if l_22_0 == "enter" then
        onEnter()
      elseif l_22_0 == "exit" then
         -- Warning: missing end command somewhere! Added here
      end
      end)
    local anim_duration = 0.2
    board:setPosition(CCPoint(view.midX, view.minY + 576 * view.minScale))
    board:runAction(CCMoveTo:create(anim_duration, CCPoint(view.midX, view.minY + 130 * view.minScale)))
    herolistBg:runAction(CCMoveTo:create(anim_duration, CCPoint(view.midX, view.minY + 123 * view.minScale)))
    darkbg:runAction(CCFadeTo:create(anim_duration, POPUP_DARK_OPACITY))
    local group = nil
    local btnGroupList = {}
    for i = 1, 6 do
      local btnGroupSpriteFg = img.createUISprite(img.ui.herolist_group_" .. )
      local btnGroupSpriteBg = img.createUISprite(img.ui.herolist_group_bg)
      btnGroupSpriteFg:setPosition(btnGroupSpriteBg:getContentSize().width / 2, btnGroupSpriteBg:getContentSize().height / 2 + 2)
      btnGroupSpriteBg:addChild(btnGroupSpriteFg)
      btnGroupList[i] = HHMenuItem:createWithScale(btnGroupSpriteBg, 1)
      local btnGroupMenu = CCMenu:createWithItem(btnGroupList[i])
      btnGroupMenu:setPosition(0, 0)
      filterBg:addChild(btnGroupMenu, 10)
      btnGroupList[i]:setPosition(61, 52 + 70 * (i - 1))
      local showSelect = img.createUISprite(img.ui.herolist_select_icon)
      showSelect:setPosition(btnGroupList[i]:getContentSize().width / 2, btnGroupList[i]:getContentSize().height / 2 + 2)
      btnGroupList[i]:addChild(showSelect)
      btnGroupList[i].showSelect = showSelect
      showSelect:setVisible(false)
      btnGroupList[i]:registerScriptTapHandler(function()
        audio.play(audio.button)
        for j = 1, 6 do
          btnGroupList[j]:unselected()
          btnGroupList[j].showSelect:setVisible(false)
        end
        if not group or i ~= group then
          upvalue_1024 = i
          btnGroupList[i]:selected()
          btnGroupList[i].showSelect:setVisible(true)
        else
          upvalue_1024 = nil
        end
        upvalue_2048 = initHerolistData({group = group, hids = hids})
        createHerolist()
        for i,v in ipairs(herolist) do
          for j = 1, 6 do
            if v.hid == hids[j] then
              onMoveUp(i, j, true)
              herolist[i].isUsed = true
            end
          end
        end
         end)
    end
    filterBg:setVisible(false)
    if l_4_0.type == "sealland" then
      btnFilter:setVisible(false)
      group = l_4_0.data.group
      herolist = initHerolistData({group = group, hids = hids})
      createHerolist()
      for i,v in ipairs(herolist) do
        for j = 1, 6 do
          if v.hid == hids[j] then
            onMoveUp(i, j, true)
            herolist[i].isUsed = true
          end
        end
      end
      scroll:setViewSize(CCSize(SCROLLVIEW_WIDTH + 150, SCROLLVIEW_HEIGHT))
    end
    btnFilter:registerScriptTapHandler(function()
      if filterBg:isVisible() == true then
        filterBg:setVisible(false)
      else
        filterBg:setVisible(true)
      end
      end)
    local tutocallBack = function()
      local count = 0
      for i,v in ipairs(herolist) do
        for j = 1, 6 do
          if v.hid == hids[j] then
            count = count + 1
          end
        end
      end
      if count == 0 or count == 1 then
        upvalue_512 = (for generator)
        userdata.setSquadNormal(hids)
        upvalue_512 = userdata.getSquadNormal()
        petBattle.initData(hids)
        loadHeroCamps(hids)
        for i,v in ipairs(herolist) do
          for j = 1, 6 do
            if v.hid == hids[j] then
              onMoveUp(i, j, true)
              herolist[i].isUsed = true
            end
          end
        end
      end
      end
    if #herolist > 2 then
      layer.tutocallBack = tutocallBack
    end
    require("ui.tutorial").show("ui.selected.pve", layer)
    return layer
  end
end

return ui

