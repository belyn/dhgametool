-- Command line was: E:\github\dhgametool\scripts\ui\hero\talenskill.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local cfgtalen = require("config.talen")
local BG_WIDTH = 684
local BG_HEIGHT = 445
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setPreferredSize(CCSize(BG_WIDTH, BG_HEIGHT))
  bg:setScale(view.minScale * 0.1)
  bg:setAnchorPoint(ccp(0.5, 0.5))
  bg:setPosition(view.midX, view.midY)
  bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  layer:addChild(bg)
  local closeBtn0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(BG_WIDTH - 23, BG_HEIGHT - 26)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  bg:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer.onAndroidBack()
   end)
  local title = i18n.global.hero_title_talenskill.string
  local titleLabel = lbl.createMixFont1(24, title, ccc3(255, 227, 134))
  titleLabel:setPosition(BG_WIDTH / 2, BG_HEIGHT - 36)
  bg:addChild(titleLabel)
  local line = img.createUISprite(img.ui.help_line)
  line:setScaleX(627 / line:getContentSize().width)
  line:setPosition(BG_WIDTH / 2, BG_HEIGHT - 64)
  bg:addChild(line)
  local createScroll = function()
    local scroll_params = {width = 680, height = 368}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local createItem = function(l_3_0)
    local item = img.createUI9Sprite(img.ui.botton_fram_2)
    item:setPreferredSize(CCSizeMake(627, 157))
    local item_w = item:getContentSize().width
    local item_h = item:getContentSize().height
    local skillId = cfgtalen[ cfgtalen].talenSkills[l_3_0]
    local skillIconBg = img.createUISprite(img.ui.hero_skill_bg)
    skillIconBg:setPosition(70, item:getContentSize().height / 2)
    item:addChild(skillIconBg)
    local skillIcon = img.createSkill(skillId)
    skillIcon:setPosition(skillIconBg:getContentSize().width / 2, skillIconBg:getContentSize().height / 2)
    skillIconBg:addChild(skillIcon)
    local showText = lbl.createMix({font = 1, size = 16, text = i18n.skill[skillId].desc, width = 474, color = ccc3(114, 72, 53), align = kCCTextAlignmentLeft})
    showText:setAnchorPoint(ccp(0, 1))
    showText:setPosition(125, 92)
    item:addChild(showText)
    local fgLine = img.createUI9Sprite(img.ui.gemstore_fgline)
    fgLine:setPreferredSize(CCSize(473, 2))
    fgLine:setAnchorPoint(0, 0.5)
    fgLine:setPosition(125, showText:boundingBox():getMaxY() + 8)
    item:addChild(fgLine)
    local showTitle = lbl.createMixFont1(20, i18n.skill[skillId].skillName, ccc3(148, 98, 66))
    showTitle:setAnchorPoint(ccp(0, 1))
    showTitle:setPosition(125, fgLine:boundingBox():getMaxY() + 12 + 21)
    item:addChild(showTitle)
    if talenLv < l_3_0 then
      setShader(skillIcon, SHADER_GRAY, true)
      local talenUnlockLab = lbl.createMixFont1(16, string.format(i18n.global.talen_lv_unlock.string, l_3_0), ccc3(212, 0, 0))
      talenUnlockLab:setAnchorPoint(ccp(0, 1))
      talenUnlockLab:setPosition(125, showText:boundingBox():getMinY() - 12)
      item:addChild(talenUnlockLab)
    end
    return item
   end
  local scroll = createScroll()
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(2, 7))
  bg:addChild(scroll)
  scroll.addSpace(4)
  for ii = 1, 3 do
    local tmp_item = createItem(ii)
    tmp_item.ax = 0.5
    tmp_item.px = 340
    scroll.addItem(tmp_item)
    if ii ~= 3 then
      scroll.addSpace(1)
    end
  end
  scroll.setOffsetBegin()
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParent()
   end
  layer:registerScriptHandler(function(l_5_0)
    if l_5_0 == "enter" then
      layer.notifyParentLock()
    elseif l_5_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

