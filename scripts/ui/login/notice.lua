-- Command line was: E:\github\dhgametool\scripts\ui\login\notice.lua 

local ui = {}
require("config")
require("framework.init")
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local pubsdata = require("data.pubs")
local net = require("net.netClient")
ui.create = function()
  local layer = CCLayer:create()
  local darkBg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkBg)
  local bg = img.createLogin9Sprite(img.login.login_home_notice_board)
  bg:setScale(view.minScale * 0.1)
  bg:setPosition(scalep(480, 288))
  bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  layer:addChild(bg)
  local bg_w = bg:getContentSize().width
  local bg_h = bg:getContentSize().height
  local lbl_title = lbl.createFont2(22, i18n.global.setting_title_notice.string)
  lbl_title:setPosition(CCPoint(bg_w / 2, bg_h - 63))
  bg:addChild(lbl_title)
  local closeBtn0 = img.createLoginSprite(img.login.button_close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(bg_w - 23, bg_h - 63)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  bg:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer.onAndroidBack()
   end)
  local pubs = pubsdata.getPub()
  local SCROLL_VIEW_W = 554
  local SCROLL_VIEW_H = 338
  local SCROLL_PADDING = 8
  local createScroll = function()
    local lineScroll = require("ui.lineScroll")
    local params = {width = SCROLL_VIEW_W, height = SCROLL_VIEW_H}
    return lineScroll.create(params)
   end
  local showPubs = function(l_3_0)
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(41, 48))
    bg:addChild(scroll)
    for ii = 1,  l_3_0 do
      local lbl_pub_title = lbl.createMix({font = 1, size = 18, text = l_3_0[ii].title, color = ccc3(148, 0, 0), width = SCROLL_VIEW_W - SCROLL_PADDING * 2, align = kCCTextAlignmentLeft})
      lbl_pub_title.ax = 0
      lbl_pub_title.px = SCROLL_PADDING
      scroll.addItem(lbl_pub_title)
      for jj = 1,  l_3_0[ii].sub do
        local lbl_sub_title = lbl.createMix({font = 1, size = 16, text = l_3_0[ii].sub[jj].title, color = ccc3(78, 35, 16), width = SCROLL_VIEW_W - 16, align = kCCTextAlignmentLeft})
        lbl_sub_title.ax = 0
        lbl_sub_title.px = SCROLL_PADDING
        scroll.addItem(lbl_sub_title)
        if not l_3_0[ii].sub[jj].content then
          local sub_contents = {}
        end
        for kk = 1,  sub_contents do
          local lbl_sub_content = lbl.createMix({font = 1, size = 16, text = sub_contents[kk], color = ccc3(78, 35, 16), width = SCROLL_VIEW_W - 16, align = kCCTextAlignmentLeft})
          lbl_sub_content.height = lbl_sub_content:getContentSize().height
          lbl_sub_content.ax = 0
          lbl_sub_content.px = SCROLL_PADDING
          scroll.addItem(lbl_sub_content)
        end
        scroll.addSpace(10)
      end
      scroll.addSpace(5)
    end
    scroll.setOffsetBegin()
   end
  showPubs(pubs)
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

