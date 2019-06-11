-- Command line was: E:\github\dhgametool\scripts\ui\guild\gname.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local player = require("data.player")
local bagdata = require("data.bag")
local gdata = require("data.guild")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local dialog = require("ui.dialog")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local bg = img.createUI9Sprite(img.ui.dialog_1)
  bg:setPreferredSize(CCSizeMake(516, 347))
  bg:setScale(view.minScale)
  bg:setPosition(CCPoint(view.midX, view.midY - 0 * view.minScale))
  layer:addChild(bg)
  local bg_w = bg:getContentSize().width
  local bg_h = bg:getContentSize().height
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(bg_w - 25, bg_h - 28))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_close_menu, 100)
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local lbl_title = lbl.createFont1(24, i18n.global.guild_modify_name.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(bg_w / 2, bg_h - 29))
  bg:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.guild_modify_name.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(bg_w / 2, bg_h - 31))
  bg:addChild(lbl_title_shadowD)
  local lbl_des = lbl.createFont1(18, i18n.global.guild_modify_name_des.string, ccc3(113, 63, 22))
  lbl_des:setPosition(CCPoint(bg_w / 2, 245))
  bg:addChild(lbl_des)
  local edit_name0 = img.createLogin9Sprite(img.login.input_border)
  local edit_name = CCEditBox:create(CCSizeMake(440 * view.minScale, 42 * view.minScale), edit_name0)
  edit_name:setInputFlag(kEditBoxInputFlagInitialCapsSentence)
  edit_name:setReturnType(kKeyboardReturnTypeDone)
  edit_name:setMaxLength(16)
  edit_name:setFont("", 16 * view.minScale)
  edit_name:setFontColor(ccc3(53, 87, 4))
  edit_name:setPosition(scalep(480, 302))
  layer:addChild(edit_name)
  local btn_create0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_create0:setPreferredSize(CCSizeMake(194, 80))
  local lbl_create = lbl.createFont1(16, i18n.global.guild_btn_confirm.string, ccc3(113, 63, 22))
  lbl_create:setPosition(CCPoint(btn_create0:getContentSize().width / 2, 59))
  btn_create0:addChild(lbl_create)
  local icon_gem = img.createItemIcon2(ITEM_ID_GEM)
  icon_gem:setScale(0.8)
  icon_gem:setPosition(CCPoint(64, 30))
  btn_create0:addChild(icon_gem)
  local lbl_gem = lbl.createFont3(20, "" .. gdata.NAME_COST, ccc3(255, 246, 223))
  if bagdata.gem() < gdata.NAME_COST then
    lbl_gem:setColor(ccc3(255, 44, 44))
  end
  lbl_gem:setPosition(CCPoint(111, 30))
  btn_create0:addChild(lbl_gem)
  local btn_create = SpineMenuItem:create(json.ui.button, btn_create0)
  btn_create:setPosition(CCPoint(bg_w / 2, 88))
  local btn_create_menu = CCMenu:createWithItem(btn_create)
  btn_create_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_create_menu)
  btn_create:registerScriptTapHandler(function()
    audio.play(audio.button)
    if bagdata.gem() < gdata.NAME_COST then
      showToast(string.format(i18n.global.guild_modify_name_cost.string, gdata.NAME_COST))
      return 
    end
    local name_str = edit_name:getText()
    name_str = string.trim(name_str)
    if containsInvalidChar(name_str) then
      showToast(i18n.global.input_invalid_char.string)
      return 
    end
    if #name_str > 16 then
      showToast(string.format(i18n.global.guild_name_length.string, 16))
      return 
    end
    backEvent()
    if callback then
      callback(edit_name:getText())
    end
   end)
  bg:setScale(0.5 * view.minScale)
  edit_name:setVisible(false)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  anim_arr:addObject(CCDelayTime:create(0.15))
  anim_arr:addObject(CCCallFunc:create(function()
    edit_name:setVisible(true)
   end))
  bg:runAction(CCSequence:create(anim_arr))
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
  layer:registerScriptHandler(function(l_8_0)
    if l_8_0 == "enter" then
      onEnter()
    elseif l_8_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

