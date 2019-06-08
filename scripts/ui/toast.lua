-- Command line was: E:\github\dhgametool\scripts\ui\toast.lua 

local toast = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
toast.create = function(l_1_0)
  local layer = CCLayer:create()
  local label = lbl.createFontTTF(16, l_1_0, ccc3(255, 251, 217))
  local size = label:boundingBox().size
  local bg = img.createLogin9Sprite(img.login.toast_bg)
  do
    local bgsize = CCSize(op3(size.width > 360, size.width + 120, 480), size.height + 45)
    bg:setCascadeOpacityEnabled(true)
    bg:setPreferredSize(bgsize)
    bg:setPosition(view.midX, view.midY)
    bg:setScale(0.1 * view.minScale)
    bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
    layer:addChild(bg)
    label:setPosition(bgsize.width / 2, bgsize.height / 2)
    bg:addChild(label)
    layer:runAction(createSequence({}))
    return layer
  end
   -- Warning: undefined locals caused missing assignments!
end

return toast

