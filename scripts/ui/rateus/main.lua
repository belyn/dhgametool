-- Command line was: E:\github\dhgametool\scripts\ui\rateus\main.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local img = require("res.img")
local lbl = require("res.lbl")
local audio = require("res.audio")
local json = require("res.json")
local net = require("net.netClient")
local playerdata = require("data.player")
local rateusdata = require("data.rateus")
local NUM_OF_GEM = 200
local RATE_US_OK = 1
local RATE_US_CANCEL = 2
ui.create = function()
  local layer = require("ui.dialog").create({title = i18n.global.rate_us_title.string, body = i18n.global.rate_us_text.string, btn_count = 2, btn_text = {1 = i18n.global.dialog_button_cancel.string, 2 = i18n.global.dialog_button_confirm.string}, selected_btn = 0})
  local size = layer.board:getContentSize()
  layer.bodyLabel:setPosition(size.width / 2, size.height - 75)
  local icon = img.createItem(ITEM_ID_GEM, NUM_OF_GEM)
  local btn = SpineMenuItem:create(json.ui.button, icon)
  btn:setPosition(size.width / 2, layer.bodyLabel:boundingBox():getMinY() - 45)
  btn:setScale(0.8)
  local menu = CCMenu:createWithItem(btn)
  menu:setPosition(0, 0)
  layer.board:addChild(menu)
  btn:registerScriptTapHandler(function()
    layer:addChild(require("ui.tips.item").createForShow({id = ITEM_ID_GEM, num = NUM_OF_GEM}), 1000)
    audio.play(audio.button)
   end)
  local postRateUsResult = function(l_2_0)
    addWaitNet()
    net:rate_us({sid = playerdata.sid, action = l_2_0}, function(l_1_0)
      delWaitNet()
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. l_1_0.status)
        return 
      end
      rateusdata.close()
      if action == RATE_US_OK then
        if isOnestore() then
          local URL_ONESTORE = "http://onesto.re/0000721940"
          device.openURL(URL_ONESTORE)
        else
          if device.platform == "android" then
            device.openURL(URL_GOOGLE_PLAY_ANDROID)
          else
            if device.platform == "ios" then
              device.openURL(URL_APP_STORE_IOS)
            end
          end
        end
      end
      layer:removeFromParent()
      end)
   end
  layer.setCallback(function(l_3_0)
    if l_3_0.selected_btn == 1 then
      layer.onAndroidBack()
    else
      postRateUsResult(RATE_US_OK)
    end
   end)
  layer.onAndroidBack = function()
    postRateUsResult(RATE_US_CANCEL)
   end
  return layer
end

return ui

