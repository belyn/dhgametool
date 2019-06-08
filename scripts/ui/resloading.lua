-- Command line was: E:\github\dhgametool\scripts\ui\resloading.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local lbl = require("res.lbl")
ui.create = function(l_1_0, l_1_1)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, 127.5))
  layer:addChild(darkbg)
  local loading = img.createUISprite(img.ui.loading_s)
  loading:setScale(view.minScale)
  loading:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(loading)
  local lbl_loading = lbl.createFont1(22, "loading.", ccc3(115, 59, 5))
  lbl_loading:setAnchorPoint(CCPoint(0, 0.5))
  lbl_loading:setPosition(CCPoint(155, 55))
  loading:addChild(lbl_loading)
  local dtime = 0.5
  for i = 1, l_1_1 / dtime do
    do
      schedule(layer, i * dtime, function()
        if i % 3 == 1 then
          lbl_loading:setString("loading..")
        else
          if i % 3 == 2 then
            lbl_loading:setString("loading...")
          else
            lbl_loading:setString("loading.")
          end
        end
         end)
    end
  end
  local arr = CCArray:create()
  arr:addObject(CCCallFunc:create(function()
    layer:removeFromParent()
    if callBack then
      callBack()
    end
   end))
  layer:runAction(CCSequence:create(arr))
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

