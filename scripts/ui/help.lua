-- Command line was: E:\github\dhgametool\scripts\ui\help.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local DELIMITER_1 = "###"
local DELIMITER_2 = ":::"
local DELIMITER_3 = "|||"
local BG_WIDTH = 666
local BG_HEIGHT = 415
local SCROLL_MARGIN_TOP = 70
local SCROLL_MARGIN_BOTTOM = 10
local SCROLL_VIEW_WIDTH = BG_WIDTH
local SCROLL_VIEW_HEIGHT = BG_HEIGHT - SCROLL_MARGIN_TOP - SCROLL_MARGIN_BOTTOM
ui.create = function(l_1_0, l_1_1)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  img.loadAll(img.packedLogin.common)
  local bg = img.createLogin9Sprite(img.login.tips_bg)
  bg:setPreferredSize(CCSize(BG_WIDTH, BG_HEIGHT))
  bg:setScale(view.minScale * 0.1)
  bg:setAnchorPoint(ccp(0.5, 0.5))
  bg:setPosition(view.midX, view.midY)
  bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  layer:addChild(bg)
  local closeBtn0 = img.createLoginSprite(img.login.button_close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(BG_WIDTH - 23, BG_HEIGHT - 26)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  bg:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer.onAndroidBack()
   end)
  if not l_1_1 then
    l_1_1 = i18n.global.help_title.string
  end
  local titleLabel = lbl.createMixFont1(24, l_1_1, ccc3(255, 227, 134))
  titleLabel:setPosition(BG_WIDTH / 2, BG_HEIGHT - 36)
  bg:addChild(titleLabel)
  local line = img.createLoginSprite(img.login.help_line)
  line:setScaleX(610 / line:getContentSize().width)
  line:setPosition(BG_WIDTH / 2, BG_HEIGHT - 64)
  bg:addChild(line)
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setViewSize(CCSize(SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT))
  scroll:setPosition(0, SCROLL_MARGIN_BOTTOM)
  bg:addChild(scroll)
  local contentDetail = nil
  if l_1_0 then
    contentDetail = {}
    local blocks = string.split(l_1_0, DELIMITER_1)
    for _,block in ipairs(blocks) do
      local blockParts = string.split(block, DELIMITER_2)
      if #blockParts > 1 then
        table.insert(contentDetail, {title = blockParts[1], lines = string.split(blockParts[2], DELIMITER_3)})
        for _,block in (for generator) do
        end
        table.insert(contentDetail, {title = nil, lines = string.split(blockParts[1], DELIMITER_3)})
      end
    end
    local labels = {}
    if contentDetail then
      for i,detail in ipairs(contentDetail) do
         -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

      end
      labels[#labels + 1] = {label = lbl.createMix({font = 1, size = 19, text = detail.title, color = ccc3(254, 235, 202), width = 610, align = kCCTextAlignmentLeft}), x = 30, offsetY = op3(not detail.title, 15, 25)}
      for j,line in ipairs(detail.lines) do
        labels[#labels + 1] = {label = lbl.createMix({font = 1, size = 16, text = line, color = ccc3(254, 235, 202), width = 610, align = kCCTextAlignmentLeft}), x = 30, offsetY = op3(j == 1, 16, 12)}
      end
    end
  end
  local container, currentY = alignLabels(labels)
  local height = not currentY + 12
  if height < SCROLL_VIEW_HEIGHT then
    height = SCROLL_VIEW_HEIGHT
  end
  container:setPosition(0, height)
  scroll:setContentSize(CCSize(SCROLL_VIEW_WIDTH, height))
  scroll:addChild(container)
  scroll:setContentOffset(ccp(0, SCROLL_VIEW_HEIGHT - height))
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParent()
   end
  layer:registerScriptHandler(function(l_3_0)
    if l_3_0 == "enter" then
      layer.notifyParentLock()
    elseif l_3_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

