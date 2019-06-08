-- Command line was: E:\github\dhgametool\scripts\ui\empty.lua 

local empty = {}
require("common.func")
require("common.const")
local view = require("common.view")
local player = require("data.player")
local net = require("net.netClient")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
empty.create = function(l_1_0)
  local spriteBox = CCSprite:create()
  spriteBox:setContentSize(CCSize(400, 200))
  local lblsize = l_1_0.size or 18
  local lbltext = l_1_0.text or ""
  if not l_1_0.color then
    local lblcolor = ccc3(115, 59, 5)
  end
  local lblwidth = l_1_0.width or 400
  local dragonScale = l_1_0.scale or 1
  local dragonicon = img.createUISprite(img.ui.mail_icon_nomail)
  dragonicon:setPosition(200, 120)
  dragonicon:setScale(dragonScale)
  spriteBox:addChild(dragonicon)
  local label = lbl.createMix({font = 1, size = lblsize, text = lbltext, color = lblcolor, width = lblwidth, align = kCCTextAlignmentLeftt})
  label:setPosition(200, 40)
  spriteBox:addChild(label)
  return spriteBox
end

return empty

