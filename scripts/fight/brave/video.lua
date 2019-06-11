-- Command line was: E:\github\dhgametool\scripts\fight\brave\video.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local audio = require("res.audio")
local hHelper = require("fight.helper.hero")
local fHelper = require("fight.helper.fx")
ui.create = function(l_1_0)
  local layer = require("fight.base.video").create("brave")
  fHelper.addMap(layer, l_1_0.map)
  fHelper.addHelpButton(layer)
  fHelper.addSkipButton(layer)
  fHelper.addSpeedButton(layer)
  fHelper.addRoundLabel(layer)
  if l_1_0.atk and l_1_0.atk.pet then
    fHelper.addPetEp(layer)
  end
  layer.playBGM(audio.fight_bg[math.random(#audio.fight_bg)])
  layer.getVideoAndUnits = function()
    local attackers = {}
    for i,h in pairs(video.atk.camp) do
      attackers[i] = hHelper.createHero({hid = h.hid, pos = h.pos, side = "attacker", hp = h.hp, wake = h.wake, skin = h.skin})
    end
    local defenders = {}
    for i,h in pairs(video.def.camp) do
      defenders[i] = hHelper.createHero({id = h.id, lv = h.lv, pos = 6 + h.pos, star = h.star, side = "defender", hp = h.hp, wake = h.wake, skin = h.skin})
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

