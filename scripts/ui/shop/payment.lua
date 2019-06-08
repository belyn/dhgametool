-- Command line was: E:\github\dhgametool\scripts\ui\shop\payment.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.activity")
local player = require("data.player")
local activityData = require("data.activity")
local shop = require("data.shop")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local ltext = "Payment Terms##\n------------------------##\n1. All payment operations via iTunes will be monitored and managed by Apple##\n2. Payment will be charged to iTunes Account at confirmation of purchase##\n3. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period##\n4. Account will be charged for renewal within 24-hours prior to the end of the current period,and identify the cost of the renewal##\n5. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase##\n6. Any unused portion of a free trial period,if offered,will be forfeited when the user purchases a subscription to that publication,where applicable"
ui.create = function()
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(255, 255, 255, 255))
  layer:addChild(darkbg)
  local bg = CCSprite:create()
  bg:setContentSize(CCSizeMake(960, 576))
  bg:setScale(view.minScale)
  bg:setPosition(scalep(480, 288))
  layer:addChild(bg)
  local bg_w = bg:getContentSize().width
  local bg_h = bg:getContentSize().height
  local backEvent = function()
    layer:removeFromParent()
   end
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = SpineMenuItem:create(json.ui.button, btnBackSprite)
  btnBack:setScale(view.minScale)
  btnBack:setPosition(scalep(35, 546))
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  layer:addChild(menuBack, 10)
  btnBack:registerScriptTapHandler(function()
    backEvent()
   end)
  local scroll_params = {width = 900, height = 500}
  local lineScroll = require("ui.lineScroll")
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(30, 10))
  bg:addChild(scroll)
  local createItem = function(l_3_0)
    l_3_0 = string.trim(l_3_0)
    local msg = lbl.create({kind = "ttf", size = 18, text = l_3_0, color = ccc3(0, 0, 0), width = 880, align = kCCTextAlignmentLeft})
    local item = CCSprite:create()
    local msg_h = msg:getContentSize().height
    item:setContentSize(CCSizeMake(880, msg_h + 5))
    msg:setAnchorPoint(CCPoint(0, 0))
    msg:setPosition(CCPoint(0, 0))
    item:addChild(msg)
    item.height = msg_h + 5
    return item
   end
  local blocks = string.split(ltext, "##")
  for ii = 1,  blocks do
    local tmp_item = createItem(blocks[ii])
    scroll.addItem(tmp_item)
  end
  scroll.setOffsetBegin()
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

