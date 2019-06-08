-- Command line was: E:\github\dhgametool\scripts\ui\tutorial.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local tutorial = require("data.tutorial")
local cfgtutorial = tutorial.getConfig()
local GIRL_BIG = 1
local GIRL_SMALL = 2
local GIRL_LEFT = 1
local GIRL_RIGHT = 2
local DIRECTION_UP = 1
local DIRECTION_DOWN = 2
local DIRECTION_LEFT = 3
local DIRECTION_RIGHT = 4
local fixPosition = function(l_1_0, l_1_1)
  if l_1_0.fixType then
    if string.sub(l_1_0.fixType, 1, 1) == "1" then
      l_1_1.y = l_1_1.y + view.minY
    end
    if string.sub(l_1_0.fixType, 2, 2) == "1" then
      l_1_1.y = l_1_1.y - view.minY
    end
    if string.sub(l_1_0.fixType, 3, 3) == "1" then
      l_1_1.x = l_1_1.x - view.minX + view.safeOffset
    end
    if string.sub(l_1_0.fixType, 4, 4) == "1" then
      l_1_1.x = l_1_1.x + view.minX - view.safeOffset
    end
  end
  return l_1_1
end

ui.show = function(l_2_0, l_2_1)
  if not TUTORIAL_ENABLE then
    return 
  end
  cfgtutorial = tutorial.getConfig()
  local id = tutorial.getExecuteId(l_2_0)
  if id then
    if tolua.isnull(l_2_1) then
      return 
    end
    if l_2_1.tutocallBack then
      l_2_1.tutocallBack()
    end
    print("tutorial execute id:", id)
    if isChannel() and cfgtutorial[id].name == "register" then
      return 
    end
    if l_2_0 == "ui.town.main" and cfgtutorial[id].townOffsetX then
      l_2_1.setOffsetX(cfgtutorial[id].townOffsetX)
    elseif l_2_0 == "ui.hook.map" and cfgtutorial[id].worldOffsetX then
      l_2_1.setOffsetX(cfgtutorial[id].worldOffsetX)
    end
    local dlgName = cfgtutorial[id].showDlg
    do
      if dlgName then
        if dlgName == "renameDlg" then
          l_2_1:addChild(require("ui.player.changename").create(true), 10000)
        end
        if dlgName == "showHint" then
          l_2_1.showHint()
        end
      end
      local tlayer = ui.create(id, function()
        tutorial.goNext(cfgtutorial[id].name, cfgtutorial[id].step)
         end)
      tutorial.setNextCallback(function()
        if not tolua.isnull(tlayer) then
          tlayer:removeFromParent()
        end
        ui.show(layername, layer)
         end)
      l_2_1:addChild(tlayer, 100000)
    end
  end
end

local fightLayer = nil
ui.setFightLayer = function(l_3_0)
  fightLayer = l_3_0
end

local townMainUILayer = nil
ui.setTownMainUILayer = function(l_4_0)
  townMainUILayer = l_4_0
end

ui.create = function(l_5_0, l_5_1)
  local layer = CCLayer:create()
  img.load(img.packedOthers.spine_ui_yindao_girl)
  img.load(img.packedUI.ui_tutorial)
  if tutorial.getVersion() ~= 1 then
    img.load(img.packedOthers.spine_ui_yindao_girl)
  end
  local cfg = cfgtutorial[l_5_0]
  local girl = nil
  local container = CCLayer:create()
  layer:addChild(container)
  local initGirl = function()
    if cfg.girl then
      if tutorial.getVersion() == 1 then
        upvalue_1024 = json.create(json.ui.yindao)
      else
        upvalue_1024 = json.create(json.ui.yindao_new)
      end
      if cfg.girlEnter then
        girl:playAnimation("enter")
        girl:appendNextAnimation("stand01")
      else
        girl:playAnimation("stand01")
      end
      if not cfg.girlFace or cfg.girlFace == 1 then
        girl:appendNextAnimation("stand02", -1)
      else
        if cfg.girlFace == 2 then
          girl:appendNextAnimation("stand03", -1)
        else
          if cfg.girlFace == 3 then
            girl:appendNextAnimation("stand04", -1)
          else
            if cfg.girlFace == 4 then
              girl:appendNextAnimation("stand05", -1)
            end
          end
        end
      end
      girl:setScale(view.minScale)
      if cfg.girlSide == GIRL_LEFT then
        girl:setPosition(scalep(95, -58))
      else
        girl:setFlipX(true)
        girl:setPosition(scalep(865, -58))
      end
      container:addChild(girl, 1)
    end
   end
  local delay = cfg.delay or 0.01
  if delay > 0 then
    container:setVisible(false)
    container:runAction(createSequence({}))
  else
    initGirl()
  end
  if cfg.blackSize then
    local render = cc.RenderTexture:create(view.physical.w, view.physical.h)
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

    render:setPosition(ccp(CCDelayTime:create(delay).physical.w / 2, CCShow:create().physical.h / 2))
    local center = nil
    if cfg.touchArea and cfg.touchArea[3] then
      do return end
    end
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

    center = ccp(cfg.touchArea[3], cfg.touchArea[4])
    local renderSprite = render:getSprite()
    renderSprite:setOpacityModifyRGB(true)
    renderSprite:setOpacity(0)
    renderSprite:runAction(cc.FadeIn:create(0.3))
    local renderSprite = render:getSprite()
    do
      local renderTexture = renderSprite:getTexture()
      renderTexture:setAntiAliasTexParameters()
      render:beginWithClear(0, 0, 0, 0)
      local sizeBlack = cfg.blackSize
      local mask = cc.Sprite:create("images/tutorial/tutorial_mask.png")
      local maskSize = mask:getContentSize()
      mask:setScale(math.min(sizeBlack / maskSize.width, sizeBlack / maskSize.height) * view.minScale)
      mask:setPosition(center)
      mask:visit()
      local blackLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 120))
      local blend = ccBlendFunc:new()
      blend.src = GL_ONE_MINUS_DST_ALPHA
      blend.dst = GL_ZERO
      blackLayer:setBlendFunc(blend)
      blackLayer:visit()
      render:endToLua()
      container:addChild(render)
    end
  end
  local isAutoRemove = cfg.duration ~= nil
  do
    if not cfg.delay then
      local delay = not isAutoRemove or 0.01
    end
    layer:runAction(createSequence({}))
  end
  if cfg.girl == GIRL_BIG then
    local banner = img.createUI9Sprite(img.ui.tutorial_text_bg)
     -- DECOMPILER ERROR: Overwrote pending register.

    banner:setPreferredSize(CCSize(950, CCDelayTime:create(delay + cfg.duration)))
    banner:setScale(view.minScale)
    banner:setAnchorPoint(ccp(0.5, 0))
    banner:setPosition(scalep(480, 2))
    container:addChild(banner)
    autoLayoutShift(banner, false, true, false, false)
    local label = lbl.createMix({font = 1, size = 18, text = i18n.global[cfg.text].string, color = ccc3(114, 72, 53), width = 640, align = kCCTextAlignmentLeft})
    label:setAnchorPoint(ccp(0, 0.5))
    if cfg.girlSide == GIRL_LEFT then
      label:setPosition(230, 70)
    else
      label:setPosition(92, 70)
    end
    banner:addChild(label)
    if not isAutoRemove and not cfg.arrowXY then
      local posX = nil
      if cfg.girlSide == GIRL_LEFT then
        do return end
      end
       -- DECOMPILER ERROR: Overwrote pending register.

      local hintIcon = cc.Sprite:create("images/tutorial/tutorial_hint.png")
       -- DECOMPILER ERROR: Overwrote pending register.

      hintIcon:setPosition(posX, CCCallFunc:create(l_5_1))
      posX = 920
      local action = createSequence({})
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

      hintIcon:runAction(CCMoveTo:create(0.4, ccp(posX, 32)):create(action))
      banner:addChild(hintIcon)
    end
  end
  if cfg.bubbleBlack then
    local blackLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 80))
    container:addChild(blackLayer, -1)
  end
  if cfg.bubbleXY then
    local bubble = img.createUI9Sprite(img.ui.tutorial_bubble)
    local bubbleMinWidth, bubbleMinHeight = 208, 82
    bubble:setScale(view.minScale)
    if cfg.girlSide == GIRL_LEFT then
      bubble:setAnchorPoint(ccp(0, 0.5))
    else
      bubble:setAnchorPoint(ccp(1, 0.5))
    end
    bubble:setPosition(scalep(cfg.bubbleXY[1], cfg.bubbleXY[2]))
    container:addChild(bubble, 1000)
    local label = lbl.createMix({font = 1, size = 18, text = i18n.global[cfg.text].string, color = ccc3(114, 72, 53), width = 250, align = kCCTextAlignmentLeft})
    local labelSize = label:boundingBox().size
    label:setAnchorPoint(ccp(0, 1))
    bubble:addChild(label)
    local bubbleWidth = labelSize.width + 36
    if bubbleWidth < bubbleMinWidth then
      bubbleWidth = bubbleMinWidth
    end
    local bubbleHeight = labelSize.height + 36
    if bubbleHeight < bubbleMinHeight then
      bubbleHeight = bubbleMinHeight
    end
    bubble:setPreferredSize(CCSize(bubbleWidth, bubbleHeight))
    label:setPosition(18, bubbleHeight - 18)
    local bubbleArrow = img.createUISprite(img.ui.tutorial_bubble_arrow)
    if cfg.girlSide == GIRL_LEFT then
      bubbleArrow:setAnchorPoint(ccp(1, 0.5))
      bubbleArrow:setPosition(3, bubbleHeight / 2)
    else
      bubbleArrow:setFlipX(true)
      bubbleArrow:setAnchorPoint(ccp(0, 0.5))
      bubbleArrow:setPosition(bubbleWidth - 3, bubbleHeight / 2)
    end
    bubble:addChild(bubbleArrow)
    if not isAutoRemove and not cfg.arrowXY then
      local hintIcon = cc.Sprite:create("images/tutorial/tutorial_hint.png")
      hintIcon:setScale(0.5)
      hintIcon:setPosition(bubbleWidth - 16, 22)
      local action = createSequence({})
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

      hintIcon:runAction(CCMoveTo:create(0.4, ccp(bubbleWidth - 16, 22)):create(action))
      bubble:addChild(hintIcon)
    end
  end
  local clickArea = nil
  if cfg.arrowXY then
    clickArea = CCLayerColor:create(ccc4(0, 0, 0, 150))
    clickArea:setScale(view.maxScale)
    clickArea:ignoreAnchorPointForPosition(false)
    clickArea:setAnchorPoint(ccp(0.5, 0.5))
    if cfg.touchArea then
      clickArea:setContentSize(CCSize(cfg.touchArea[1], cfg.touchArea[2]))
      if cfg.touchArea[3] then
        clickArea:setPosition(scalep(cfg.touchArea[3], cfg.touchArea[4]))
      else
        clickArea:setPosition(scalep(cfg.arrowXY[1], cfg.arrowXY[2]))
      end
    else
      clickArea:setPosition(scalep(cfg.arrowXY[1], cfg.arrowXY[2]))
      clickArea:setContentSize(CCSize(80, 80))
    end
    local center = fixPosition(cfg, ccp(clickArea:getPosition()))
    clickArea:setPosition(center)
    clickArea:setVisible(false)
    container:addChild(clickArea)
  end
  local moveArea = nil
  if cfg.clickMove then
    moveArea = CCLayerColor:create(ccc4(255, 0, 0, 150))
    moveArea:setScale(view.maxScale)
    moveArea:ignoreAnchorPointForPosition(false)
    moveArea:setAnchorPoint(ccp(0.5, 0.5))
    moveArea:setPosition(scalep(cfg.clickMove[1], cfg.clickMove[2]))
    moveArea:setContentSize(CCSize(cfg.clickMove[3], cfg.clickMove[4]))
    moveArea:setVisible(false)
    container:addChild(moveArea)
  end
  if cfg.arrowDirection then
    local arrow = json.create(json.ui.yd_hand)
    arrow:setScale(view.minScale)
    arrow:setPosition(scalep(cfg.arrowXY[1], cfg.arrowXY[2]))
    arrow:playAnimation("animation", -1)
    container:addChild(arrow)
    local center = fixPosition(cfg, ccp(arrow:getPosition()))
    arrow:setPosition(center)
    if moveArea then
      arrow:stopAnimation()
      arrow:setPosition(scalep(cfg.arrowXY[1] - 15, cfg.arrowXY[2] + 6))
      local center = fixPosition(cfg, ccp(arrow:getPosition()))
      arrow:setPosition(center)
      local action = createSequence({})
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

      arrow:runAction(cc.MoveTo:create(0.6, fixPosition(cfg, scalep(cfg.clickMove[1] - 30, cfg.clickMove[2] + 6))).RepeatForever:create(cc.Hide:create()))
    end
  end
  if cfg.pause and fightLayer and not tolua.isnull(fightLayer) then
    if cfg.pause[1] <= 0.01 then
      resumeSchedulerAndActions(fightLayer)
    else
      if cfg.pause[2] then
        layer:runAction(createSequence({}))
      else
        pauseSchedulerAndActions(fightLayer)
      end
    end
  end
  if cfg.sayGodby then
    if girl then
      girl:clearNextAnimation()
       -- DECOMPILER ERROR: Overwrote pending register.

      girl:playAnimation("stand02", 1, CCDelayTime:create(cfg.pause[2]))
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

      girl:runAction(createSequence({}))
    end
    if townMainUILayer and not tolua.isnull(townMainUILayer) then
      townMainUILayer.initHelperUI(false)
    end
  end
  local touchbeginx, touchbeginy = nil, nil
  local onTouchBegan = function(l_6_0, l_6_1)
    touchbeginx, upvalue_512 = l_6_0, l_6_1
    if clickArea and clickArea:boundingBox():containsPoint(ccp(l_6_0, l_6_1)) then
      layer:setVisible(false)
      HHUtils:sendTouchBegan(clickArea:getPositionX(), clickArea:getPositionY())
    end
    return true
   end
   -- DECOMPILER ERROR: Overwrote pending register.

  local moveX, moveY = -1000, cc.MoveTo:create(0.2, scalep(53, cc.DelayTime:create(0.8)))
   -- DECOMPILER ERROR: Overwrote pending register.

  local onTouchMoved = CCCallFunc:create(function(...)
        girl:playAnimation("exit", 1)
         -- DECOMPILER ERROR: Confused about usage of registers for local variables.

         end)
  local onTouchEnded = function(l_8_0, l_8_1)
    if moveArea then
      upvalue_512, upvalue_1024 = -1000, -1000
      local removeSelf, sendTouch = false, false
      if clickArea:boundingBox():containsPoint(ccp(touchbeginx, touchbeginy)) and moveArea:boundingBox():containsPoint(ccp(l_8_0, l_8_1)) then
        removeSelf = true
        sendTouch = true
      else
        local scene = CCDirector:sharedDirector():getRunningScene()
        scene:runAction(CCCallFunc:create(function()
          HHUtils:sendTouchEnded(clickArea:getPositionX() + 11, clickArea:getPositionY())
          layer:setVisible(true)
            end))
      end
      if removeSelf then
        layer:removeFromParent()
        if sendTouch then
          local scene = CCDirector:sharedDirector():getRunningScene()
          scene:runAction(CCCallFunc:create(function()
            HHUtils:sendTouchEnded(moveArea:getPositionX(), moveArea:getPositionY())
               end))
        end
        handler()
      end
      return 
    end
    local removeSelf, sendTouch = false, false
    if clickArea and clickArea:boundingBox():containsPoint(ccp(touchbeginx, touchbeginy)) then
      removeSelf = true
      sendTouch = true
      do return end
      if not isAutoRemove and cfg.girl then
        removeSelf = true
      end
    end
    if removeSelf then
      layer:removeFromParent()
      if sendTouch then
        local scene = CCDirector:sharedDirector():getRunningScene()
        scene:runAction(CCCallFunc:create(function()
          HHUtils:sendTouchEnded(clickArea:getPositionX(), clickArea:getPositionY())
            end))
      end
      handler()
    end
   end
  local onTouch = function(l_9_0, l_9_1, l_9_2)
    if l_9_0 == "began" then
      return onTouchBegan(l_9_1, l_9_2)
    elseif l_9_0 == "moved" then
      return onTouchMoved(l_9_1, l_9_2)
    else
      return onTouchEnded(l_9_1, l_9_2)
    end
   end
   -- DECOMPILER ERROR: Overwrote pending register.

  layer:registerScriptTouchHandler(cc.CallFunc:create(function()
        arrow:setVisible(true)
        arrow:setPosition(fixPosition(cfg, scalep(cfg.arrowXY[1] - 15, cfg.arrowXY[2] + 6)))
         end), false, -128, true)
  fightLayer.isPaused, fightLayer.isPaused = true, false
  layer:setTouchEnabled(true)
  if cfg.girl or cfg.arrowXY or isAutoRemove then
    layer:setTouchSwallowEnabled(true)
  else
    layer:setTouchSwallowEnabled(false)
  end
  layer:setKeypadEnabled(true)
  layer:addNodeEventListener(cc.KEYPAD_EVENT, function(l_10_0)
    if l_10_0.key == "back" then
      if layer._exit_flag then
        layer._exit_flag = nil
        layer:removeChildByTag(require("ui.dialog").TAG)
      else
        layer._exit_flag = true
        exitGame(layer)
      end
    end
   end)
  return layer
end

return ui

