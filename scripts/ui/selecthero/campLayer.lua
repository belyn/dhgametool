-- Command line was: E:\github\dhgametool\scripts\ui\selecthero\campLayer.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local heros = require("data.heros")
local i18n = require("res.i18n")
local cfgcamp = require("config.camp")
local cfghero = require("config.hero")
local heros = require("data.heros")
local DHComponents = require("dhcomponents.DroidhangComponents")
local BG_WIDTH = 600
local BG_HEIGHT = 100
local Blend = 7
local JusticeAndEvil = 8
local Ruin = 9
local Redemption = 10
local Justice = 11
local Evil = 12
local Pollute = 13
local Shackles = 14
local LifeDeath = 15
local OldEnemy = 16
ui.BuffTable = {}
ui.BuffTable[1] = {1, 1, 1, 1, 1, 1}
ui.BuffTable[2] = {2, 2, 2, 2, 2, 2}
ui.BuffTable[3] = {3, 3, 3, 3, 3, 3}
ui.BuffTable[4] = {4, 4, 4, 4, 4, 4}
ui.BuffTable[5] = {5, 5, 5, 5, 5, 5}
ui.BuffTable[6] = {6, 6, 6, 6, 6, 6}
ui.BuffTable[Blend] = {6, 5, 4, 3, 2, 1}
ui.BuffTable[JusticeAndEvil] = {6, 6, 6, 5, 5, 5}
ui.BuffTable[Ruin] = {5, 5, 3, 3, 1, 1}
ui.BuffTable[Redemption] = {6, 6, 4, 4, 2, 2}
ui.BuffTable[Justice] = {4, 4, 4, 2, 2, 2}
ui.BuffTable[Evil] = {3, 3, 3, 1, 1, 1}
ui.BuffTable[Pollute] = {4, 4, 4, 3, 3, 3}
ui.BuffTable[Shackles] = {3, 3, 3, 2, 2, 2}
ui.BuffTable[LifeDeath] = {4, 4, 4, 1, 1, 1}
ui.BuffTable[OldEnemy] = {2, 2, 2, 1, 1, 1}
ui.create = function()
  ui.obj = {}
  ui.obj.widget = {}
  ui.obj.widget.layer = CCLayer:create()
  ui.obj.widget.layer:setContentSize(CCSize(BG_WIDTH, BG_HEIGHT))
  ui.obj.widget.layer:setAnchorPoint(0, 0.5)
  ui.obj.widget.scroll = CCScrollView:create()
  ui.obj.widget.scroll:setAnchorPoint(CCPoint(0, 0))
  ui.obj.widget.scroll:setDirection(kCCScrollViewDirectionHorizontal)
  ui.obj.widget.scroll:setViewSize(CCSize(745, 100))
  ui.obj.widget.scroll:setContentSize(CCSize(1030, 100))
  ui.obj.widget.scroll:setCascadeOpacityEnabled(true)
  ui.obj.widget.scroll:setPosition(30, 0)
  ui.obj.widget.scroll:getContainer():setCascadeOpacityEnabled(true)
  ui.obj.widget.layer:addChild(ui.obj.widget.scroll)
  ui.obj.widget.icon = {}
  for i = #cfgcamp, 1, -1 do
    do
      local cfg = cfgcamp[i]
      local iconBg = img.createUISprite("battlebuff_" .. i .. ".png")
      iconBg:setPosition(65 * (i - 1), 20)
      iconBg:setTouchEnabled(true)
      iconBg:setTouchSwallowEnabled(false)
      ui.obj.widget.scroll:addChild(iconBg)
      local size = iconBg:getContentSize()
      ui.obj.widget.icon[i] = json.create(json.ui.campbuff[i])
      ui.obj.widget.icon[i]:setScale(0.72)
      ui.obj.widget.icon[i]:setPosition(65 * (i - 1) + size.width / 2, 20 + size.height / 2)
      ui.obj.widget.icon[i]:setVisible(false)
      ui.obj.widget.icon[i]:playAnimation("animation", -1)
      ui.obj.widget.scroll:addChild(ui.obj.widget.icon[i])
      local onTouch = function(l_1_0, l_1_1, l_1_2)
        if l_1_0 == "began" then
          iconTips = require("ui.tips.campbuff").create(i)
          ui.obj.widget.layer:getParent():getParent():addChild(iconTips)
        elseif l_1_0 == "moved" then
          return true
           -- Warning: missing end command somewhere! Added here
        end
         end
      iconBg:registerScriptTouchHandler(onTouch)
    end
  end
  return ui.obj.widget
end

ui.autoJumpScroll = function(l_2_0, l_2_1)
  if l_2_0 == nil or l_2_0 == false then
    return 
  end
  if l_2_1 > 11 then
    ui.obj.widget.scroll:setContentOffset(CCPoint(-285, 0))
  else
    ui.obj.widget.scroll:setContentOffset(CCPoint(0, 0))
  end
end

ui.checkUpdateForHeroids = function(l_3_0, l_3_1)
  for i = 1, 6 do
    print(l_3_0[i])
    if l_3_0[i] == nil or l_3_0[i] <= 0 then
      return -1
    end
  end
  local sortHeroids = tablecp(l_3_0)
  table.sort(sortHeroids, function(l_1_0, l_1_1)
    return cfghero[l_1_1].group < cfghero[l_1_0].group
   end)
  for key,val in pairs(ui.BuffTable) do
    do
      local BuffTableItem = ui.BuffTable[key]
      for i = 1, 6 do
        if BuffTableItem[i] ~= tonumber(cfghero[sortHeroids[i]].group) then
          for key,val in (for generator) do
          end
          if i == 6 then
            ui.autoJumpScroll(l_3_1, key)
            return key
          end
        end
      end
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
    return -1
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

     -- Warning: missing end command somewhere! Added here
  end
end

return ui

