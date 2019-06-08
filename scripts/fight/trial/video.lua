-- Command line was: E:\github\dhgametool\scripts\fight\trial\video.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local audio = require("res.audio")
local hHelper = require("fight.helper.hero")
local fHelper = require("fight.helper.fx")
local cfgwavetrial = require("config.wavetrial")
local cfgmons = require("config.monster")
ui.create = function(l_1_0)
  local layer = require("fight.base.video").create("trial")
  local stage = l_1_0.stage
  fHelper.addMap(layer, cfgwavetrial[stage].map)
  fHelper.addHelpButton(layer)
  fHelper.addSpeedButton(layer, true)
  fHelper.addRoundLabel(layer)
  if l_1_0.atk and l_1_0.atk.pet then
    fHelper.addPetEp(layer)
  end
  layer.playBGM(audio.fight_bg[math.random( audio.fight_bg)])
  layer.getVideoAndUnits = function()
    local attackers = {}
    for i,h in ipairs(video.camp) do
      attackers[i] = hHelper.createHero({hid = h.hid, pos = h.pos, side = "attacker", wake = h.wake})
    end
    local defenders = {}
    for i,m in ipairs(cfgwavetrial[stage].trial) do
      defenders[i] = hHelper.createMons({id = m, pos = 6 + cfgwavetrial[stage].stand[i], side = "defender"})
    end
    hHelper.processTreasureEp(attackers)
    return video, attackers, defenders
   end
  layer.onVideoFrame = function(l_2_0)
    fHelper.setRoundLabel(layer, l_2_0.tid)
   end
  layer.startFight()
  return layer
end

return ui

