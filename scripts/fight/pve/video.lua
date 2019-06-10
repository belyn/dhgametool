-- Command line was: E:\github\dhgametool\scripts\fight\pve\video.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local audio = require("res.audio")
local hHelper = require("fight.helper.hero")
local fHelper = require("fight.helper.fx")
local cfgstage = require("config.stage")
local cfgmons = require("config.monster")
ui.create = function(l_1_0)
  local layer = require("fight.base.video").create("pve")
  local stage = l_1_0.stage
  fHelper.addMap(layer, cfgstage[stage].map)
  fHelper.addRoundLabel(layer)
  if l_1_0.atk and l_1_0.atk.pet then
    fHelper.addPetEp(layer)
  end
  layer.playBGM(audio.fight_bg[math.random(#audio.fight_bg)])
  layer.getVideoAndUnits = function()
    local attackers = {}
    for i,h in ipairs(video.camp) do
      attackers[i] = hHelper.createHero({hid = h.hid, pos = h.pos, side = "attacker", wake = h.wake})
    end
    local defenders = {}
    for i,m in ipairs(cfgstage[stage].monster) do
      defenders[i] = hHelper.createMons({id = m, pos = 6 + cfgstage[stage].stand[i], side = "defender"})
    end
    hHelper.processTreasureEp(attackers)
    return video, attackers, defenders
   end
  layer.onVideoFrame = function(l_2_0)
    fHelper.setRoundLabel(layer, l_2_0.tid)
   end
  local tutorialData = require("data.tutorial")
  local tutorialUI = require("ui.tutorial")
  if tutorialData.getVersion() == 1 then
    tutorialUI.show("fight.pve.video", layer)
    if require("data.tutorial").is("hook", 2) then
      schedule(layer, 1, function()
      fHelper.popHelp(layer)
      require("data.tutorial").goNext("hook", 2)
      end)
    else
      fHelper.addHelpButton(layer)
      fHelper.addSpeedButton(layer, true)
    end
  else
    tutorialUI.setFightLayer(layer)
    schedule(layer, 0.1, function()
      tutorialUI.show("fight.pve.video", layer:getParent())
      end)
    if tutorialData.is("hook", 2) then
      schedule(layer, 0.7, function()
      pauseSchedulerAndActions(layer)
      end)
    end
    fHelper.addHelpButton(layer)
    fHelper.addSpeedButton(layer, true)
  end
end
layer.startFight()
return layer
end

return ui

