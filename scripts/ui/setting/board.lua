-- Command line was: E:\github\dhgametool\scripts\ui\setting\board.lua 

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
local TAB = {OPTION = 1, HELP = 2, SERVER = 3, FEED = 4}
ui.TAB = TAB
ui.create = function(l_1_0, l_1_1)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board = img.createUI9Sprite(img.ui.dialog_1)
  board:setPreferredSize(CCSizeMake(790, 526))
  board:setScale(view.minScale)
  board:setPosition(view.midX - 5 * view.minScale, view.midY)
  layer:addChild(board)
  layer.board = board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  if l_1_1 then
    board:setScale(0.5 * view.minScale)
    board:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  end
  local lbl_title = lbl.createFont1(24, i18n.global.setting_board_title.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_w / 2, board_h - 29))
  board:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.setting_board_title.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_w / 2, board_h - 31))
  board:addChild(lbl_title_shadowD)
  layer.setTitle = function(l_1_0)
    lbl_title:setString(l_1_0)
    lbl_title_shadowD:setString(l_1_0)
   end
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(board_w - 25, board_h - 28))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_close_menu, 100)
  layer.btn_close = btn_close
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local inner_board = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  inner_board:setPreferredSize(CCSizeMake(736, 422))
  inner_board:setAnchorPoint(CCPoint(0.5, 0))
  inner_board:setPosition(CCPoint(board_w / 2, 35))
  board:addChild(inner_board)
  layer.inner_board = inner_board
  local inner_board_w = inner_board:getContentSize().width
  local inner_board_h = inner_board:getContentSize().height
  local tab_offset_y = 20
  local tab_opt0 = img.createUISprite(img.ui.setting_tab_opt_norm)
  local tab_opt = HHMenuItem:createWithScale(tab_opt0, 1)
  tab_opt:setScale(0.5)
  tab_opt:setAnchorPoint(CCPoint(0, 0))
  tab_opt:setPosition(CCPoint(758, 322 + tab_offset_y))
  local tab_opt_menu = CCMenu:createWithItem(tab_opt)
  tab_opt_menu:setPosition(CCPoint(0, 0))
  board:addChild(tab_opt_menu)
  local tab_opt_sel = img.createUISprite(img.ui.setting_tab_opt_sel)
  tab_opt_sel:setAnchorPoint(CCPoint(0, 0))
  tab_opt_sel:setPosition(CCPoint(0, 0))
  tab_opt:addChild(tab_opt_sel)
  tab_opt_sel:setVisible(false)
  local tab_faq0 = img.createUISprite(img.ui.setting_tab_help_norm)
  local tab_faq = HHMenuItem:createWithScale(tab_faq0, 1)
  tab_faq:setScale(0.5)
  tab_faq:setAnchorPoint(CCPoint(0, 0))
  tab_faq:setPosition(CCPoint(758, 230 + tab_offset_y))
  local tab_faq_menu = CCMenu:createWithItem(tab_faq)
  tab_faq_menu:setPosition(CCPoint(0, 0))
  board:addChild(tab_faq_menu)
  local tab_faq_sel = img.createUISprite(img.ui.setting_tab_help_sel)
  tab_faq_sel:setAnchorPoint(CCPoint(0, 0))
  tab_faq_sel:setPosition(CCPoint(0, 0))
  tab_faq:addChild(tab_faq_sel)
  tab_faq_sel:setVisible(false)
  local tab_svr0 = img.createUISprite(img.ui.setting_tab_svr_norm)
  local tab_svr = HHMenuItem:createWithScale(tab_svr0, 1)
  tab_svr:setScale(0.5)
  tab_svr:setAnchorPoint(CCPoint(0, 0))
  tab_svr:setPosition(CCPoint(758, 138 + tab_offset_y))
  local tab_svr_menu = CCMenu:createWithItem(tab_svr)
  tab_svr_menu:setPosition(CCPoint(0, 0))
  board:addChild(tab_svr_menu)
  local tab_svr_sel = img.createUISprite(img.ui.setting_tab_svr_sel)
  tab_svr_sel:setAnchorPoint(CCPoint(0, 0))
  tab_svr_sel:setPosition(CCPoint(0, 0))
  tab_svr:addChild(tab_svr_sel)
  tab_svr_sel:setVisible(false)
  local tab_feed0 = img.createUISprite(img.ui.setting_tab_feed_norm)
  local tab_feed = HHMenuItem:createWithScale(tab_feed0, 1)
  tab_feed:setScale(0.5)
  tab_feed:setAnchorPoint(CCPoint(0, 0))
  tab_feed:setPosition(CCPoint(758, 46 + tab_offset_y))
  local tab_feed_menu = CCMenu:createWithItem(tab_feed)
  tab_feed_menu:setPosition(CCPoint(0, 0))
  board:addChild(tab_feed_menu)
  local tab_feed_sel = img.createUISprite(img.ui.setting_tab_feed_sel)
  tab_feed_sel:setAnchorPoint(CCPoint(0, 0))
  tab_feed_sel:setPosition(CCPoint(0, 0))
  tab_feed:addChild(tab_feed_sel)
  tab_feed_sel:setVisible(false)
  if l_1_0 == TAB.OPTION then
    tab_opt_sel:setVisible(true)
    tab_opt:setEnabled(false)
  else
    if l_1_0 == TAB.HELP then
      tab_faq_sel:setVisible(true)
      tab_faq:setEnabled(false)
    else
      if l_1_0 == TAB.SERVER then
        tab_svr_sel:setVisible(true)
        tab_svr:setEnabled(false)
      else
        if l_1_0 == TAB.FEED then
          tab_feed_sel:setVisible(true)
          tab_feed:setEnabled(false)
        end
      end
    end
  end
  if APP_CHANNEL and APP_CHANNEL == "MRGAME" then
    tab_feed:setVisible(false)
  end
  tab_opt:registerScriptTapHandler(function()
    audio.play(audio.button)
    local parentObj = layer:getParent()
    layer:removeFromParentAndCleanup(true)
    parentObj:addChild(require("ui.setting.option").create(), 1000)
   end)
  tab_faq:registerScriptTapHandler(function()
    audio.play(audio.button)
    local parentObj = layer:getParent()
    layer:removeFromParentAndCleanup(true)
    parentObj:addChild(require("ui.setting.help").create(), 1000)
   end)
  tab_svr:registerScriptTapHandler(function()
    audio.play(audio.button)
    local parentObj = layer:getParent()
    layer:removeFromParentAndCleanup(true)
    parentObj:addChild(require("ui.setting.server").create(), 1000)
   end)
  tab_feed:registerScriptTapHandler(function()
    audio.play(audio.button)
    local parentObj = layer:getParent()
    layer:removeFromParentAndCleanup(true)
    parentObj:addChild(require("ui.setting.feed").create(), 1000)
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    backEvent()
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_11_0)
    if l_11_0 == "enter" then
      onEnter()
    elseif l_11_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

