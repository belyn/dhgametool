-- Command line was: E:\github\dhgametool\scripts\ui\login\warning.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
ui.create = function()
  local layer = CCLayer:create()
  if not APP_CHANNEL or APP_CHANNEL == "" then
    return layer
  end
  local sdkcfg = require("common.sdkcfg")
  if not sdkcfg[APP_CHANNEL] or not sdkcfg[APP_CHANNEL].fpage then
    return layer
  end
  local bg = img.createLogin9Sprite(img.login.login_warning_bg)
  bg:setPreferredSize(CCSize(1440, 864))
  bg:setScale(view.minScale)
  bg:setPosition(scalep(480, 288))
  layer:addChild(bg)
  local pagefile = "images/fpage/" .. sdkcfg[APP_CHANNEL].fpage
  local warning = img.createSpriteUnpacked(pagefile)
  warning:setScale(view.minScale)
  warning:setOpacity(0)
  warning:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(warning, 100)
  local arr = CCArray:create()
  arr:addObject(CCDelayTime:create(0.5))
  arr:addObject(CCCallFunc:create(function()
    warning:runAction(CCFadeIn:create(1))
   end))
  layer:runAction(CCSequence:create(arr))
  local textureCache = CCTextureCache:sharedTextureCache()
  local tex = textureCache:textureForKey(pagefile)
  if tex then
    textureCache:removeTextureForKey(pagefile)
  end
  return layer
end

return ui

