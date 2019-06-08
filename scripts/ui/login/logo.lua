-- Command line was: E:\github\dhgametool\scripts\ui\login\logo.lua 

local ui = {}
require("common.const")
local view = require("common.view")
local logo_json_key = "spinejson/ui/DH_Logo.json"
local getVideoImgs = function()
  local imgs = {}
  for ii = 1, 52 do
    imgs[ii] = string.format("DHImages/DH_logo_%02d.png", ii)
  end
  imgs[ imgs + 1] = "DHImages/glow.png"
  return imgs
end

local loadImgs = function(l_2_0)
  local textureCache = CCTextureCache:sharedTextureCache()
  local spriteframeCache = CCSpriteFrameCache:sharedSpriteFrameCache()
  for ii = 1,  l_2_0 do
    local key = l_2_0[ii]
    if not spriteframeCache:spriteFrameByName(key) then
      local tex = textureCache:addImage(key)
      local size = tex:getContentSize()
      local rect = CCRect(0, 0, size.width, size.height)
      local frame = CCSpriteFrame:createWithTexture(tex, rect)
      spriteframeCache:addSpriteFrame(frame, key)
    end
  end
end

local unLoadImgs = function(l_3_0)
  local textureCache = CCTextureCache:sharedTextureCache()
  local spriteframeCache = CCSpriteFrameCache:sharedSpriteFrameCache()
  for ii = 1,  l_3_0 do
    local key = l_3_0[ii]
    local tex = textureCache:textureForKey(key)
    if tex then
      spriteframeCache:removeSpriteFramesFromTexture(tex)
      textureCache:removeTextureForKey(key)
    end
  end
end

local createSpine = function(l_4_0)
  local cache = DHSkeletonDataCache:getInstance()
  if not cache:getSkeletonData(l_4_0) then
    cache:loadSkeletonData(l_4_0, l_4_0)
  end
  local anim = DHSkeletonAnimation:createWithKey(l_4_0)
  anim:scheduleUpdateLua()
  return anim
end

local unloadSpine = function(l_5_0)
  local cache = DHSkeletonDataCache:getInstance()
  cache:removeSkeletonData(l_5_0)
end

ui.createVideo = function()
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, 255))
  layer:addChild(darkbg)
  local logo_audio = "music/logo.mp3"
  local engine = SimpleAudioEngine:sharedEngine()
  engine:preloadEffect(logo_audio)
  local imgs = getVideoImgs()
  loadImgs(imgs)
  local svideo = createSpine(logo_json_key)
  svideo:setScale(view.yScale * 576 / 1080)
  svideo:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(svideo)
  svideo:playAnimation("animation")
  local effectEnabled = CCUserDefault:sharedUserDefault():getStringForKey("aaMusicFX", "1")
  if effectEnabled and effectEnabled == "1" then
    engine:playEffect(logo_audio)
  end
  svideo:setCascadeOpacityEnabled(true)
  layer.animal = svideo
  return layer
end

ui.create = function()
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(255, 255, 255, 255))
  layer:addChild(darkbg)
  local video = ui.createVideo()
  layer:addChild(video)
  local textureCache = CCTextureCache:sharedTextureCache()
  local spriteframeCache = CCSpriteFrameCache:sharedSpriteFrameCache()
  local prename = "images/login_logo"
  spriteframeCache:addSpriteFramesWithFile(prename .. ".plist")
  local arr = CCArray:create()
  if APP_CHANNEL and APP_CHANNEL == "ONESTORE" then
    do return end
  end
  if APP_CHANNEL and APP_CHANNEL == "AMAZON" then
    do return end
  end
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    arr:addObject(CCCallFunc:create(function()
    local warning = CCSprite:createWithSpriteFrameName("login/login_warning_sentence.png")
    warning:setOpacity(0)
    warning:setScale(view.minScale)
    warning:setPosition(view.physical.w * 0.5, 65 * view.minScale)
    layer:addChild(warning, 2001)
    warning:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1), CCFadeIn:create(1)))
   end))
  else
    if CCApplication:sharedApplication():getCurrentLanguage() == kLanguageChinese then
      arr:addObject(CCCallFunc:create(function()
    local warning = CCSprite:createWithSpriteFrameName("login/login_warning_sentence.png")
    warning:setOpacity(0)
    warning:setScale(view.minScale)
    warning:setPosition(view.physical.w * 0.5, 65 * view.minScale)
    layer:addChild(warning, 2001)
    warning:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1), CCFadeIn:create(1)))
   end))
    end
  end
  arr:addObject(CCDelayTime:create(2))
  arr:addObject(CCCallFunc:create(function()
    require("common.func")
    require("config")
    require("framework.init")
    local img = require("res.img")
    local arr2 = CCArray:create()
    arr2:addObject(CCCallFunc:create(function(...)
      unloadSpine(logo_json_key)
      unLoadImgs(getVideoImgs())
       -- DECOMPILER ERROR: Confused at declaration of local variable

      if APP_CHANNEL and APP_CHANNEL ~= "" then
        local sdkcfg = require("common.sdkcfg")
        if sdkcfg[APP_CHANNEL] and sdkcfg[APP_CHANNEL].fpage then
          layer:addChild(require("ui.login.warning").create(), 3000)
           -- DECOMPILER ERROR: Overwrote pending register.

          video:runAction(createSequence({}))
        end
      end
      schedule(layer, 0, function()
        local tex = textureCache:textureForKey(prename .. ".png")
        if tex then
          spriteframeCache:removeSpriteFramesFromFile(prename .. ".plist")
          textureCache:removeTextureForKey(prename .. ".png")
        end
        replaceScene(require("ui.login.home").create())
         end)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

       -- Warning: undefined locals caused missing assignments!
      end))
    layer:runAction(CCSequence:create(arr2))
   end))
  layer:runAction(CCSequence:create(arr))
  return layer
end

return ui

