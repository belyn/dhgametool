-- Command line was: E:\github\dhgametool\scripts\fight\dare\win.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local cfgdarestage = require("config.darestage")
local daredata = require("data.dare")
local net = require("net.netClient")
local bag = require("data.bag")
local petBattle = require("ui.pet.petBattle")
ui.create = function(l_1_0)
  local layer = require("fight.base.win").create()
  local cfg = cfgdarestage[l_1_0.stage]
  local dares = daredata.getDare(l_1_0.type)
  local nexthandler = function()
    local params = daredata.video.curparams
    petBattle.addPetData(params.camp)
    addWaitNet()
    net:dare_fight(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status < 0 then
        showToast("status:" .. l_1_0.status)
        return 
      end
      local curvideo = clone(l_1_0)
      curvideo.camp = params.camp
      curvideo.type = params.type
      curvideo.curparams = params
      if not curvideo.atk then
        curvideo.atk = {}
      end
      curvideo.atk.camp = params.camp
      processPetPosAtk1(curvideo)
      processPetPosDef2(curvideo)
      if l_1_0.win == true then
        require("data.dare").win(params.type)
        local dailytask = require("data.task")
        dailytask.increment(dailytask.TaskType.CHALLENGE, 1)
        local darestage = require("config.darestage")
        local rewards = darestage[l_1_0.stage].reward
        for i,v in ipairs(rewards) do
          if v.type == 1 then
            bag.items.add(v)
            for i,v in (for generator) do
            end
            bag.equips.add(v)
          end
        end
        local dareData = require("data.dare")
        dareData.video = clone(curvideo)
        if arenaSkip() == "enable" then
          if layer and not tolua.isnull(layer) then
            layer:removeFromParent(true)
          end
          if curvideo.win then
            CCDirector:sharedDirector():getRunningScene():addChild(require("fight.dare.win").create(curvideo), 1000)
          else
            CCDirector:sharedDirector():getRunningScene():addChild(require("fight.dare.lose").create(curvideo), 1000)
          end
        else
          replaceScene(require("fight.dare.loading").create(curvideo))
        end
         -- Warning: missing end command somewhere! Added here
      end
      end)
   end
  if dares.fight < dares.buy + 2 then
    layer.addOkNextButton(function()
    require("fight.dare.loading").backToUI(video)
   end, function()
    require("fight.dare.loading").backToNext(video, nexthandler)
   end)
  else
    layer.addOkButton(function()
    require("fight.dare.loading").backToUI(video)
   end)
  end
  if l_1_0.hurts and  l_1_0.hurts > 0 then
    local camp = {}
    for i,m in ipairs(cfg.monster) do
      camp[ camp + 1] = {kind = "mons", id = m, pos = cfg.stand[i]}
    end
    layer.addHurtsButton(l_1_0.camp, camp, l_1_0.hurts, l_1_0)
  end
  do
    local equips, items = {}, {}
    for _,r in ipairs(cfg.reward) do
      if r.type == 1 then
        items[ items + 1] = {id = r.id, num = r.num}
        for _,r in (for generator) do
        end
        equips[ equips + 1] = {id = r.id, num = r.num}
      end
      layer.addRewardIcons({equips = equips, items = items})
      return layer
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return ui

