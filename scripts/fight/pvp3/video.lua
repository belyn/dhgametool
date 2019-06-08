-- Command line was: E:\github\dhgametool\scripts\fight\pvp3\video.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local audio = require("res.audio")
local hHelper = require("fight.helper.hero")
local fHelper = require("fight.helper.fx")
ui.create = function(l_1_0, l_1_1)
  l_1_0[l_1_1].idx = l_1_1
  local layer = require("fight.base.video").create("pvp3")
  fHelper.addMap(layer, MAP_ID_ARENA)
  fHelper.addHelpButton(layer)
  fHelper.addSkipButton(layer)
  fHelper.addSpeedButton(layer)
  fHelper.addRoundLabel(layer)
  if l_1_0[l_1_1].atk and l_1_0[l_1_1].atk.pet then
    fHelper.addPetEp(layer)
  end
  layer.playBGM(audio.arena_bg)
  layer.getVideoAndUnits = function()
    local attackers = {}
    for i,h in pairs(videos[idx].atk.camp) do
      attackers[i] = hHelper.createHero({hid = h.hid, pos = h.pos, side = "attacker", wake = h.wake, skin = h.skin})
    end
    local defenders = {}
    for i,h in pairs(videos[idx].def.camp) do
      defenders[i] = hHelper.createHero({id = h.id, lv = h.lv, pos = 6 + h.pos, star = h.star, side = "defender", wake = h.wake, skin = h.skin})
    end
    hHelper.processTreasureEp(attackers)
    return videos[idx], attackers, defenders
   end
  layer.onVideoFrame = function(l_2_0)
    fHelper.setRoundLabel(layer, l_2_0.tid)
   end
  layer.startFight()
  return layer
end

return ui

