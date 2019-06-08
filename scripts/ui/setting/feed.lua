-- Command line was: E:\github\dhgametool\scripts\ui\setting\feed.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local player = require("data.player")
local userdata = require("data.userdata")
local pubsdata = require("data.pubs")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
ui.create = function(l_1_0)
  local boardlayer = require("ui.setting.board")
  local layer = boardlayer.create(boardlayer.TAB.FEED, l_1_0)
  local board = layer.inner_board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  layer.setTitle(i18n.global.setting_feed_submit.string)
  local SCROLL_VIEW_W = 654
  local SCROLL_VIEW_H = 244
  local SCROLL_PADDING = 15
  local container0 = img.createLogin9Sprite(img.login.input_border)
  container0:setPreferredSize(CCSizeMake(SCROLL_VIEW_W, SCROLL_VIEW_H))
  local container = CCMenuItemSprite:create(container0, nil)
  container:setAnchorPoint(CCPoint(0.5, 0))
  container:setPosition(CCPoint(board_w / 2, 138))
  local container_menu = CCMenu:createWithItem(container)
  container_menu:setPosition(CCPoint(0, 0))
  board:addChild(container_menu)
  local lbl_feed = lbl.create({kind = "ttf", size = 18, text = "", color = ccc3(112, 74, 43)})
  lbl_feed:setHorizontalAlignment(kCCTextAlignmentLeft)
  lbl_feed:setDimensions(CCSizeMake(SCROLL_VIEW_W - SCROLL_PADDING * 2, 0))
  lbl_feed:setAnchorPoint(CCPoint(0, 1))
  lbl_feed:setPosition(CCPoint(SCROLL_PADDING, SCROLL_VIEW_H - SCROLL_PADDING))
  container:addChild(lbl_feed, 10)
  container:registerScriptTapHandler(function()
    audio.play(audio.button)
    local inputlayer = require("ui.inputlayer")
    local onNotice = function(l_1_0)
      local notice_str = l_1_0 or ""
      notice_str = string.trim(notice_str)
      if containsInvalidChar(notice_str) then
        showToast(i18n.global.input_invalid_char.string)
        return 
      end
      lbl_feed:setString(notice_str)
      end
    layer:addChild(inputlayer.create(onNotice, lbl_feed:getString(), {maxLen = 240}), 1000)
   end)
  local btn_send0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_send0:setPreferredSize(CCSizeMake(175, 52))
  local lbl_send = lbl.createFont1(18, i18n.global.setting_feed_submit.string, ccc3(115, 59, 5))
  lbl_send:setPosition(CCPoint(btn_send0:getContentSize().width / 2, btn_send0:getContentSize().height / 2))
  btn_send0:addChild(lbl_send)
  local btn_send = SpineMenuItem:create(json.ui.button, btn_send0)
  btn_send:setPosition(CCPoint(board_w / 2, 72))
  local btn_send_menu = CCMenu:createWithItem(btn_send)
  btn_send_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_send_menu)
  btn_send:registerScriptTapHandler(function()
    audio.play(audio.button)
    local tmp_str = lbl_feed:getString()
    tmp_str = string.trim(tmp_str)
    if not tmp_str or tmp_str == "" then
      showToast(i18n.global.input_empty.string)
      return 
    end
    if containsInvalidChar(tmp_str) then
      showToast(i18n.global.input_invalid_char.string)
      return 
    end
    local params = {sid = player.sid, content = tmp_str}
    addWaitNet()
    netClient:feedback(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      lbl_feed:setString("")
      showToast(i18n.global.setting_feed_ok.string)
      end)
    require("net.httpClient").userAction("innerFeed")
   end)
  return layer
end

return ui

