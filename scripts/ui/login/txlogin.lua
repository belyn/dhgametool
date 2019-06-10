-- Command line was: E:\github\dhgametool\scripts\ui\login\txlogin.lua 

local ui = {}
require("config")
require("framework.init")
require("common.const")
require("common.func")
local view = require("common.view")
local json = require("res.json")
local audio = require("res.audio")
local img = require("res.img")
local userdata = require("data.userdata")
ui.which = "qq"
ui.create = function()
  local layer = CCNode:create()
  layer:setContentSize(CCSizeMake(960, 200))
  local btn_qq0 = img.createLoginSprite(img.login.login_btn_qq)
  local btn_qq = SpineMenuItem:create(json.ui.button, btn_qq0)
  btn_qq:setPosition(ccp(300, 130))
  local btn_qq_menu = CCMenu:createWithItem(btn_qq)
  btn_qq_menu:setPosition(ccp(0, 0))
  layer:addChild(btn_qq_menu)
  local btn_wx0 = img.createLoginSprite(img.login.login_btn_wx)
  local btn_wx = SpineMenuItem:create(json.ui.button, btn_wx0)
  btn_wx:setPosition(ccp(660, 130))
  local btn_wx_menu = CCMenu:createWithItem(btn_wx)
  btn_wx_menu:setPosition(ccp(0, 0))
  layer:addChild(btn_wx_menu)
  autoLayoutShift(btn_qq, nil, true, nil, nil)
  autoLayoutShift(btn_wx, nil, true, nil, nil)
  btn_qq:registerScriptTapHandler(function()
    audio.play(audio.button)
    ui.which = "qq"
    userdata.setString(userdata.keys.txwhich, "qq")
    require("ui.login.home").goUpdate(layer:getParent(), getVersion())
   end)
  btn_wx:registerScriptTapHandler(function()
    audio.play(audio.button)
    ui.which = "wx"
    userdata.setString(userdata.keys.txwhich, "wx")
    require("ui.login.home").goUpdate(layer:getParent(), getVersion())
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

