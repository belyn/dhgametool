-- Command line was: E:\github\dhgametool\scripts\fight\pvp\lucky.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
ui.create = function(l_1_0, l_1_1, l_1_2)
  local layer = CCLayer:create()
  local duration = l_1_2 or 2
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  darkbg:setVisible(false)
  layer:addChild(darkbg)
  local boxes = {}
   -- DECOMPILER ERROR: Unhandled construct in list

   -- DECOMPILER ERROR: Unhandled construct in table

  local xy = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Unhandled construct in table

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

  for i = {280, 288}, 280, 480 do
    boxes[i] = json.create(json.ui.pvp_choujiang)
    boxes[i]:setScale(view.minScale)
     -- DECOMPILER ERROR: Unhandled construct in table

    boxes[i]:setPosition(scalep(xy[i][1], xy[i][2]))
    xy, xy = {}, {}
    boxes[i]:setVisible(false)
    layer:addChild(boxes[i])
  end
   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

  schedule(layer, duration, function()
    darkbg:setVisible(true)
    for _,box in ipairs(boxes) do
      box:setVisible(true)
      box:playAnimation("birth")
      box:appendNextAnimation("loop", -1)
    end
   end)
   -- DECOMPILER ERROR: unhandled table 

  local onSelect = function(l_2_0)
    local things = {}
    for i,r in ipairs(rewards) do
      do
        things[i] = rewards[i]
      end
    end
    if index ~= l_2_0 then
      local tmp = things[index]
      do
        things[index] = things[l_2_0]
        things[l_2_0] = tmp
      end
    end
    for i,thing in ipairs(things) do
      local icon, kind, t = nil, nil, nil
      if thing.equips and #thing.equips > 0 then
        kind = "equip"
        t = thing.equips[1]
        icon = img.createEquip(t.id, t.num)
      else
        kind = "item"
        t = thing.items[1]
        icon = img.createItem(t.id, t.num)
      end
      icon:setCascadeOpacityEnabled(true)
      local btn = SpineMenuItem:create(json.ui.button, icon)
      btn:setCascadeOpacityEnabled(true)
      local menu = CCMenu:createWithItem(btn)
      menu:setCascadeOpacityEnabled(true)
      menu:ignoreAnchorPointForPosition(false)
      boxes[i]:addChildFollowSlot("code_gear", menu)
      schedule(boxes[i], op3(i == l_2_0, 0, 1), function()
        boxes[i]:clearNextAnimation()
        boxes[i]:playAnimation(op3(i == s, "click", "notclick"))
        boxes[i]:registerAnimation(op3(i == s, "end_loop2", "end_loop"), -1)
         end)
      btn:registerScriptTapHandler(function()
        audio.play(audio.button)
        if kind == "equip" then
          layer:addChild(require("ui.tips.equip").createForShow(t), 1000)
        else
          layer:addChild(require("ui.tips.item").createForShow(t), 1000)
        end
         end)
    end
    audio.play(audio.battle_card_reward)
   end
   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

  addBackEvent(layer)
   -- DECOMPILER ERROR: unhandled table 

  layer.onAndroidBack = function()
   end
   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

  layer:registerScriptHandler(function(l_4_0)
    if l_4_0 == "enter" then
      layer.notifyParentLock()
    elseif l_4_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
   -- DECOMPILER ERROR: unhandled table 

  local state = "unselected"
   -- DECOMPILER ERROR: unhandled table 

  local onTouch = function(l_5_0, l_5_1, l_5_2)
    if l_5_0 == "began" then
      return true
    elseif l_5_0 == "moved" then
      return 
    elseif state == "unselected" then
      for i,box in ipairs(boxes) do
        if box:getAabbBoundingBox():containsPoint(ccp(l_5_1, l_5_2)) then
          state = "selected"
          onSelect(i)
      else
        end
      end
    elseif state == "selected" then
      state = "removed"
      layer:removeFromParent()
    end
  end
   end
   -- DECOMPILER ERROR: unhandled table 

  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

