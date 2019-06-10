-- Command line was: E:\github\dhgametool\scripts\ui\solo\sweepUI.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local net = require("net.netClient")
local audio = require("res.audio")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local player = require("data.player")
local bagdata = require("data.bag")
local casinodata = require("data.casino")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local soloData = require("data.solo")
local cfgDrug = require("config.spkdrug")
local particle = require("res.particle")
ui.create = function(l_1_0, l_1_1, l_1_2)
  ui.widget = {}
  ui.data = {}
  ui.widget.items = {}
  ui.data.bag = l_1_0
  ui.data.mainUI = l_1_1
  ui.data.callfunc = l_1_2
  ui.widget.layer = CCLayer:create()
  ui.widget.layer:setTouchEnabled(true)
  ui.widget.darkBg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  ui.widget.layer:addChild(ui.widget.darkBg)
  ui.widget.bg = img.createUI9Sprite(img.ui.dialog_1)
  ui.widget.bg:setPreferredSize(CCSizeMake(645, 496))
  ui.widget.bg:setScale(view.minScale)
  ui.widget.bg:setPosition(view.midX, view.midY)
  ui.widget.layer:addChild(ui.widget.bg)
  local width = ui.widget.bg:getContentSize().width
  local height = ui.widget.bg:getContentSize().height
  local title = i18n.global.solo_sweep.string
  ui.widget.title = lbl.createFont1(24, title, ccc3(230, 208, 174))
  ui.widget.title:setPosition(CCPoint(width / 2, height - 29))
  ui.widget.bg:addChild(ui.widget.title, 2)
  ui.widget.shadow = lbl.createFont1(24, title, ccc3(89, 48, 27))
  ui.widget.shadow:setPosition(CCPoint(width / 2, height - 31))
  ui.widget.bg:addChild(ui.widget.shadow)
  ui.widget.board = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  ui.widget.board:setPreferredSize(CCSizeMake(594, 334))
  ui.widget.board:setAnchorPoint(CCPoint(0.5, 0))
  ui.widget.board:setPosition(CCPoint(width / 2, 92))
  ui.widget.bg:addChild(ui.widget.board)
  local ITEM_H = 80
  local SCROLL_INTERVAL = 10
  local SCROLL_VIEW_W = 545
  local SCROLL_VIEW_H = 306
  local SCROLL_CONTENT_W = 545
  local SCROLL_CONTENT_H = math.ceil(#l_1_0 / 6) > 3 and math.ceil(#l_1_0 / 6) * (ITEM_H + SCROLL_INTERVAL) or 306
  ui.widget.scroll = CCScrollView:create()
  ui.widget.scroll:setDirection(kCCScrollViewDirectionVertical)
  ui.widget.scroll:setViewSize(CCSize(SCROLL_VIEW_W, SCROLL_VIEW_H))
  ui.widget.scroll:setContentSize(CCSize(SCROLL_CONTENT_W, SCROLL_CONTENT_H))
  ui.widget.scroll:setAnchorPoint(CCPoint(0, 0))
  ui.widget.scroll:setPosition(CCPoint(25, 15))
  ui.widget.scroll:setContentOffset(ccp(0, SCROLL_VIEW_H - SCROLL_CONTENT_H))
  ui.widget.board:addChild(ui.widget.scroll)
  local closeImg = img.createUISprite(img.ui.close)
  ui.widget.closeBtn = SpineMenuItem:create(json.ui.button, closeImg)
  ui.widget.closeBtn:setPosition(CCPoint(width - 25, height - 28))
  local closeMenu = CCMenu:createWithItem(ui.widget.closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  ui.widget.bg:addChild(closeMenu, 10)
  local confirmImg = img.createLogin9Sprite(img.login.button_9_small_gold)
  confirmImg:setPreferredSize(CCSizeMake(158, 54))
  local confirmLabel = lbl.createFont1(18, i18n.global.hook_drop_btn_get.string, ccc3(115, 59, 5))
  confirmLabel:setPosition(CCPoint(confirmImg:getContentSize().width / 2, confirmImg:getContentSize().height / 2))
  confirmImg:addChild(confirmLabel)
  ui.widget.confirmBtn = SpineMenuItem:create(json.ui.button, confirmImg)
  ui.widget.confirmBtn:setPosition(CCPoint(width / 2, 58))
  local confirmMenu = CCMenu:createWithItem(ui.widget.confirmBtn)
  confirmMenu:setPosition(CCPoint(0, 0))
  ui.widget.bg:addChild(confirmMenu)
  local particle1 = particle.create("firework1")
  particle1:setPosition(ccp(56, 40))
  ui.widget.board:addChild(particle1)
  local particle2 = particle.create("firework1")
  particle2:setPosition(ccp(560, 40))
  ui.widget.board:addChild(particle2)
  local particle3 = particle.create("firework1")
  particle3:setPosition(ccp(300, 330))
  ui.widget.board:addChild(particle3)
  ui.btnCallback()
  ui.addItems()
  ui.widget.bg:setScale(0.5 * view.minScale)
  ui.widget.bg:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  return ui.widget.layer
end

ui.addItems = function()
  local ITEM_H = 80
  local SCROLL_INTERVAL = 10
  local SCROLL_CONTENT_H = math.ceil(#ui.data.bag / 6) > 3 and math.ceil(#ui.data.bag / 6) * (ITEM_H + SCROLL_INTERVAL) or 306
  for i,v in ipairs(ui.data.bag) do
    local item = nil
    if v.type == 1 then
      item = img.createItem(v.id, v.num)
    elseif v.type == 2 then
      item = img.createEquip(v.id, v.num)
    elseif v.type == 3 then
      item = ui.createBufIcon(v.id, v.num)
    end
    item:setAnchorPoint(CCPoint(0.5, 0.5))
    table.insert(ui.widget.items, item)
    local posX = ((i - 1) % 6 + 0.5) * (ITEM_H + SCROLL_INTERVAL) + 2
    local posY = SCROLL_CONTENT_H - (math.floor((i - 1) / 6 + 1) - 0.5) * (ITEM_H + SCROLL_INTERVAL) - 14
    item:setPosition(CCPoint(posX, posY))
    item:setVisible(true)
    item:setScale(1)
    ui.widget.scroll:addChild(item)
    item:setAnchorPoint(ccp(0.5, 0.5))
  end
end

ui.createBufIcon = function(l_3_0, l_3_1)
  local grid = img.createUISprite(img.ui.grid)
  local size = grid:getContentSize()
  grid:setCascadeOpacityEnabled(true)
  local iconID = cfgDrug[l_3_0].iconId
  local icon = nil
  if iconID == 4001 then
    icon = img.createUISprite(img.ui.solo_milk)
  elseif iconID == 4101 then
    icon = img.createUISprite(img.ui.solo_evil_potion)
  elseif iconID == 4201 then
    icon = img.createUISprite(img.ui.solo_angel_potion)
  elseif iconID == 3801 then
    icon = img.createUISprite(img.ui.solo_power_potion)
  elseif iconID == 3701 then
    icon = img.createUISprite(img.ui.solo_speed_potion)
  elseif iconID == 3901 then
    icon = img.createUISprite(img.ui.solo_crit_potion)
  end
  icon:setScale(0.7)
  icon:setPosition(size.width / 2, size.height / 2)
  grid:addChild(icon)
  local label = lbl.createFont2(14, convertItemNum(l_3_1))
  label:setAnchorPoint(ccp(1, 0))
  label:setPosition(74, 6)
  grid:addChild(label)
  return grid
end

ui.playSweepAnimation = function()
  local ITEM_H = 80
  local SCROLL_INTERVAL = 10
  local scaleTime = 0.35
  local moveTime = 0.2
  local stopTime = 0.2
  local lines = math.ceil(#ui.data.bag / 6)
  local showLine = 1
  if lines > 3 then
    local delay1 = CCDelayTime:create(0.15 + (scaleTime + stopTime) * 3 + moveTime * 2)
    local delay2 = CCDelayTime:create(scaleTime + moveTime + stopTime)
    local call = CCCallFunc:create(function()
      local offsetY = ui.widget.scroll:getContentOffset().y
      ui.widget.scroll:setContentOffsetInDuration(ccp(0, offsetY + ITEM_H + SCROLL_INTERVAL), moveTime)
      end)
    local seq1 = createSequence({call, delay2})
    local rep = CCRepeat:create(seq1, lines - 3)
    local seq2 = createSequence({delay1, rep})
    ui.widget.board:runAction(seq2)
  end
  local maskLayer = CCLayer:create()
  maskLayer:setTouchEnabled(true)
  maskLayer:setContentSize(ui.widget.scroll:getViewSize())
  maskLayer:setPosition(ui.widget.scroll:getPosition())
  ui.widget.layer:addChild(maskLayer, 999999)
  local delayTime = CCDelayTime:create(scaleTime + moveTime + stopTime)
  local callfunc = CCCallFunc:create(function()
    local endNum = showLine == lines and #ui.data.bag - (lines - 1) * 6 or 6
    for i = 1, endNum do
      ui.widget.items[(showLine - 1) * 6 + i]:setVisible(true)
      local itemDelay = CCDelayTime:create(i * 0.05)
      local scale = CCScaleTo:create(0.1, 1, 1)
      ui.widget.items[(showLine - 1) * 6 + i]:runAction(createSequence({itemDelay, scale}))
    end
    if lines <= showLine then
      ui.widget.closeBtn:setVisible(true)
      ui.widget.confirmBtn:setVisible(true)
      if maskLayer ~= nil then
        maskLayer:removeFromParent()
      end
      upvalue_1536 = nil
      return 
    end
    showLine = showLine + 1
   end)
  local startDelay = CCDelayTime:create(0.15)
  do
    local sequence = createSequence({callfunc, delayTime})
    ui.widget.board:runAction(createSequence({}))
  end
   -- Warning: undefined locals caused missing assignments!
end

ui.btnCallback = function()
  local closeTip = function()
    audio.play(audio.button)
    if ui.data.callfunc then
      ui.data.callfunc()
    end
    ui.widget.layer:removeFromParent()
   end
  ui.widget.closeBtn:registerScriptTapHandler(function()
    closeTip()
   end)
  ui.widget.confirmBtn:registerScriptTapHandler(function()
    closeTip()
   end)
  ui.widget.layer.onAndroidBack = function()
    closeTip()
   end
  addBackEvent(ui.widget.layer)
  ui.widget.layer:registerScriptHandler(function(l_5_0)
    if l_5_0 == "enter" then
      ui.widget.layer.notifyParentLock()
    elseif l_5_0 == "exit" then
      ui.widget.layer.notifyParentUnlock()
    end
   end)
end

return ui

