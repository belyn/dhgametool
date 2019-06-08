-- Command line was: E:\github\dhgametool\scripts\fight\frdpk\lose.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local petBattle = require("ui.pet.petBattle")
local player = require("data.player")
ui.create = function(l_1_0)
  local layer = require("fight.base.lose").create()
  l_1_0.noscore = true
  layer.addVsScores(l_1_0)
  local nexthandler = function()
    local params = video.curparams
    petBattle.addPetData(params.camp)
    addWaitNet()
    net:frd_pk(params, function(l_1_0)
      tbl2string(l_1_0)
      delWaitNet()
      if l_1_0.status == -1 then
        showToast(i18n.global.toast_arena_nocamp.string)
        return 
      end
      if l_1_0.status < 0 then
        showToast("status:" .. l_1_0.status)
        return 
      end
      local curvideo = l_1_0.video
      curvideo.atk.camp = params.camp
      curvideo.atk.name = player.name
      curvideo.atk.lv = player.lv()
      curvideo.atk.logo = player.logo
      local tmp = curvideo.def.camp
      curvideo.def = {}
      curvideo.def = clone(video.info)
      curvideo.def.camp = tmp
      processPetPosAtk1(curvideo)
      processPetPosDef2(curvideo)
      video.from_layer = {from_layer = "frdpk"}
      curvideo.curparams = params
      curvideo.info = video.info
      replaceScene(require("fight.frdpk.loading").create(curvideo))
      end)
   end
  layer.addOkNextButton(function()
    require("fight.frdpk.loading").backToUI(video)
   end, function()
    require("fight.frdpk.loading").backToNext(video, nexthandler)
   end, "frdpk")
  if l_1_0.hurts and  l_1_0.hurts > 0 then
    layer.addHurtsButton(l_1_0.atk.camp, l_1_0.def.camp, l_1_0.hurts, l_1_0)
  end
  return layer
end

return ui

