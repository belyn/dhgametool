-- Command line was: E:\github\dhgametool\scripts\ui\guildVice\board.lua 

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
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board = img.createUI9Sprite(img.ui.dialog_1)
  board:setPreferredSize(CCSizeMake(796, 510))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0.5, 0))
  board:setPosition(view.midX - 0 * view.minScale, view.minY + 15 * view.minScale)
  layer:addChild(board)
  layer.board = board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  if l_1_0 and l_1_0._anim then
    board:setScale(0.5 * view.minScale)
    board:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  end
  local lbl_title = lbl.createFont1(24, "", ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_w / 2, board_h - 29))
  board:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, "", ccc3(89, 48, 27))
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
  inner_board:setPreferredSize(CCSizeMake(742, 406))
  inner_board:setAnchorPoint(CCPoint(0.5, 0))
  inner_board:setPosition(CCPoint(board_w / 2, 35))
  board:addChild(inner_board)
  layer.inner_board = inner_board
  local inner_board_w = inner_board:getContentSize().width
  local inner_board_h = inner_board:getContentSize().height
  return layer
end

return ui

