-- Command line was: E:\github\dhgametool\scripts\fight\frdboss\lose.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local cfgfrdstage = require("config.friendstage")
local net = require("net.netClient")
local bag = require("data.bag")
local petBattle = require("ui.pet.petBattle")
local player = require("data.player")
ui.create = function(l_1_0)
  local layer = require("fight.base.lose").create()
  local cfg = cfgfrdstage[l_1_0.stage]
  local friendboss = require("data.friendboss")
  local nexthandler = function()
    local params = friendboss.video.curparams
    petBattle.addPetData(params.camp)
    addWaitNet()
    net:frd_boss_fight(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      local friend = require("data.friend")
      if l_1_0.status == -1 then
        showToast(i18n.global.friendboss_no_enegy.string)
        return 
      elseif l_1_0.status == -5 then
        showToast(i18n.global.event_processing.string)
        return 
      end
      if l_1_0.status == -3 then
        showToast(i18n.global.friendboss_boss_die.string)
        if pUid == player.uid then
          friendboss.upscd()
        else
          friend.changebossst(pUid, false)
          return 
        end
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        do
          local curvideo = clone(l_1_0)
          if curvideo.rewards and video.select then
            bag.addRewards(curvideo.rewards[curvideo.select])
          end
          curvideo.uid = params.uid
          curvideo.camp = params.camp
          curvideo.stage = friendboss.video.stage
          curvideo.curparams = params
          friendboss.delEnegy()
          if l_1_0.win then
            if pUid == player.uid then
              friendboss.upscd()
            else
              friend.changebossst(pUid, false)
            end
          end
          if not curvideo.atk then
            curvideo.atk = {}
          end
          curvideo.atk.camp = params.camp
          processPetPosAtk1(curvideo)
          processPetPosDef2(curvideo)
          friendboss.video = clone(curvideo)
          replaceScene(require("fight.frdboss.loading").create(curvideo))
        end
         -- Warning: missing end command somewhere! Added here
      end
      end)
   end
  if friendboss.enegy > 0 then
    layer.addOkNextButton(function()
    require("fight.frdboss.loading").backToUI(video)
   end, function()
    require("fight.frdboss.loading").backToNext(video, nexthandler)
   end)
  else
    layer.addOkButton(function()
    require("fight.frdboss.loading").backToUI(video)
   end)
  end
  if l_1_0.hurts and #l_1_0.hurts > 0 then
    local camp = {}
    for i,m in ipairs(cfg.monster) do
      camp[#camp + 1] = {kind = "mons", id = m, pos = cfg.stand[i]}
    end
    layer.addHurtsButton(l_1_0.camp, camp, l_1_0.hurts, l_1_0)
    require("fight.frdboss.win").addScoreAndHurtsSum(layer, l_1_0.hurts, cfg)
  end
  if l_1_0.rewards and l_1_0.select then
    layer:addChild(require("fight.pvp.lucky").create(l_1_0.rewards, l_1_0.select), 10)
  end
  return layer
end

return ui

