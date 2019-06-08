-- Command line was: E:\github\dhgametool\scripts\fight\pvpf3\lose.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
ui.create = function(l_1_0)
  local layer = require("fight.base.lose").create()
  l_1_0.noscore = true
  layer.addVsScores(l_1_0)
  local ok_str = nil
  if l_1_0.wins and  l_1_0.wins <= l_1_0.idx then
    ok_str = nil
  else
    ok_str = i18n.global.arena_video_next.string
  end
  layer.addOkButton(function()
    require("fight.pvpf3.loading").backToUI(video, layer)
   end, ok_str)
  if l_1_0.hurts and  l_1_0.hurts > 0 then
    layer.addHurtsButton(l_1_0.atk.camp, l_1_0.def.camp, l_1_0.hurts, l_1_0)
  end
  return layer
end

return ui

