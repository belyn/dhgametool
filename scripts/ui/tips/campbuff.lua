-- Command line was: E:\github\dhgametool\scripts\ui\tips\campbuff.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local cfgcamp = require("config.camp")
local DHComponents = require("dhcomponents.DroidhangComponents")
local H = 168
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  layer:setAnchorPoint(0.5, 0.5)
  local cfg = cfgcamp[l_1_0]
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setAnchorPoint(0.5, 0.5)
  bg:setScale(view.minScale)
  bg:setPosition(scalep(480, 348))
  layer:addChild(bg)
  layer.bg = bg
  local grid = img.createUISprite(img.ui.campbuff_grid)
  bg:addChild(grid)
  local icon = json.create(json.ui.campbuff[l_1_0])
  icon:playAnimation("animation", -1)
  icon:setScale(0.6)
  bg:addChild(icon)
  local titleStr = i18n.global.hero_group_" .. l_1_.string
  local title = lbl.createMix({font = 2, size = 24, text = titleStr, color = ccc3(255, 228, 156), pt = {size = 22}})
  title:setAnchorPoint(ccp(0, 0.5))
  bg:addChild(title)
  local text = lbl.createMixFont1(16, i18n.global.fight_campbuff_text.string, lbl.whiteColor)
  text:setAnchorPoint(ccp(0, 0.5))
  bg:addChild(text)
  local line = img.createUISprite(img.ui.hero_tips_fgline)
  line:setScaleX(350 / line:getContentSize().width)
  line:setAnchorPoint(ccp(0, 0.5))
  bg:addChild(line)
  local desc = lbl.createMix({font = 1, size = 16, text = i18n.global.camp_require_" .. l_1_.string, color = lbl.whiteColor, width = 360, align = kCCTextAlignmentLeft})
  desc:setAnchorPoint(ccp(0, 0))
  bg:addChild(desc)
  local currentY = desc:boundingBox():getMaxY() - 20
  print("currentY = " .. currentY)
  bg:setPreferredSize(CCSize(410, H + currentY))
  DHComponents:mandateNode(grid, "yw_campbuff_grid")
  DHComponents:mandateNode(icon, "yw_campbuff_icon")
  DHComponents:mandateNode(title, "yw_campbuff_title")
  DHComponents:mandateNode(text, "yw_campbuff_text")
  DHComponents:mandateNode(line, "yw_campbuff_line")
  DHComponents:mandateNode(desc, "yw_campbuff_desc")
  text:setPosition(text:getPositionX(), text:getPositionY() + currentY)
  icon:setPosition(icon:getPositionX(), icon:getPositionY() + currentY)
  title:setPosition(title:getPositionX(), title:getPositionY() + currentY)
  grid:setPosition(grid:getPositionX(), grid:getPositionY() + currentY)
  line:setPosition(line:getPositionX(), line:getPositionY() + currentY)
   -- DECOMPILER ERROR: Unhandled construct in list

   -- DECOMPILER ERROR: Unhandled construct in table

  local xy = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

  for i,b in {22, 46}(22) do
    local n, v = buffString(b.type, b.num)
    local name = lbl.createMixFont1(16, n, ccc3(212, 179, 54))
    name:setAnchorPoint(ccp(0, 0.5))
    name:setPosition(xy[i][1], xy[i][2])
    xy = {}
    bg:addChild(name)
    local value = lbl.createMixFont1(16, "+" .. v, lbl.whiteColor)
    value:setAnchorPoint(ccp(0, 0.5))
    value:setPosition(name:boundingBox():getMaxX() + 20, xy[i][2])
    bg:addChild(value)
  end
   -- DECOMPILER ERROR: unhandled table 

  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParent()
   end
   -- DECOMPILER ERROR: unhandled table 

  layer:registerScriptHandler(function(l_2_0)
    if l_2_0 == "enter" then
      layer.notifyParentLock()
    elseif l_2_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
   -- DECOMPILER ERROR: unhandled table 

  layer:setTouchEnabled(true)
   -- DECOMPILER ERROR: unhandled table 

  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

