-- Command line was: E:\github\dhgametool\scripts\fight\hairisland\video.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local audio = require("res.audio")
local hHelper = require("fight.helper.hero")
local fHelper = require("fight.helper.fx")
local cfgfloatland = require("config.floatland")
local cfgmons = require("config.monster")
ui.create = function(l_1_0)
  local layer = require("fight.base.video").create("hairisland")
  local cfg = cfgfloatland[l_1_0.stage]
  fHelper.addMap(layer, cfg.map)
  fHelper.addHelpButton(layer)
  fHelper.addSkipButton(layer)
  fHelper.addSpeedButton(layer)
  fHelper.addRoundLabel(layer)
  if l_1_0.atk and l_1_0.atk.pet then
    fHelper.addPetEp(layer)
  end
  layer.playBGM(audio.fight_bg[math.random( audio.fight_bg)])
  layer.getVideoAndUnits = function()
    local attackers = {}
    for i,h in ipairs(video.camp) do
      attackers[i] = hHelper.createHero({id = h.id, lv = h.lv, pos = h.pos, star = h.star, side = "attacker", wake = h.wake, skin = h.skin})
    end
    local defenders = {}
    for i,m in ipairs(cfg.monster) do
      if video.hpps[i] and video.hpps[i] > 0 then
        defenders[ defenders + 1] = hHelper.createMons({id = m, pos = 6 + cfg.stand[i], side = "defender", hp = video.hpps[i]})
      end
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

