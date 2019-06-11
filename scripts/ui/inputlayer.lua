-- Command line was: E:\github\dhgametool\scripts\ui\inputlayer.lua 

local inputlayer = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local edit_txt_color = ccc3(66, 36, 6)
local edit_txt_placeholder_color = ccc3(97, 97, 97)
inputlayer.create = function(l_1_0, l_1_1, l_1_2)
  local maxLen = l_1_2 and l_1_2.maxLen or 140
  local layer = CCLayer:create()
  local is_end = false
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local backBtn0 = img.createUISprite(img.ui.back)
  local backBtn = HHMenuItem:create(backBtn0)
  backBtn:setScale(view.minScale)
  backBtn:setPosition(scalep(44, 540))
  local backMenu = CCMenu:createWithItem(backBtn)
  backMenu:setPosition(0, 0)
  layer:addChild(backMenu)
  layer.back = backBtn
  local backEvent = function()
    layer.edit_box:unregisterScriptEditBoxHandler()
    layer:removeFromParentAndCleanup(true)
   end
  backBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    backEvent()
   end)
  layer.onAndroidBack = function()
    backEvent()
   end
  local edit_box_0 = img.createLogin9Sprite(img.login.input_border)
  local edit_box = CCEditBox:create(CCSizeMake(view.physical.w - 160 * view.minScale - view.minX, 40 * view.minScale), edit_box_0)
  edit_box:setMaxLength(maxLen)
  edit_box:setFont("", 16 * view.minScale)
  edit_box:setInputFlag(kEditBoxInputFlagInitialCapsSentence)
  edit_box:setReturnType(kKeyboardReturnTypeDone)
  edit_box:setAnchorPoint(CCPoint(0, 0))
  edit_box:setPosition(CCPoint(view.minX + 10 * view.minScale, view.midY + 150 * view.minScale))
  edit_box:setFontColor(edit_txt_color)
  edit_box:setPlaceholderFontColor(edit_txt_placeholder_color)
  layer:addChild(edit_box, 10000)
  layer.edit_box = edit_box
  if l_1_1 then
    edit_box:setText(l_1_1)
  end
  local onConfirm = function()
    local _str = edit_box:getText()
    if callback then
      callback(_str)
    end
    upvalue_1024 = true
   end
  local btn_confirm0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_confirm0:setPreferredSize(CCSizeMake(115, 45))
  local lbl_confirm = lbl.createFont1(18, i18n.global.dialog_button_confirm.string, ccc3(115, 59, 5))
  lbl_confirm:setPosition(CCPoint(btn_confirm0:getContentSize().width / 2, btn_confirm0:getContentSize().height / 2))
  btn_confirm0:addChild(lbl_confirm)
  local btn_confirm = SpineMenuItem:create(json.ui.button, btn_confirm0)
  btn_confirm:setScale(view.minScale)
  btn_confirm:setAnchorPoint(CCPoint(0.5, 0.5))
  btn_confirm:setPosition(CCPoint(edit_box:boundingBox():getMaxX() + 65 * view.minScale, edit_box:boundingBox():getMinY() + 18 * view.minScale))
  local btn_confirm_menu = CCMenu:createWithItem(btn_confirm)
  btn_confirm_menu:setPosition(CCPoint(0, 0))
  layer:addChild(btn_confirm_menu)
  btn_confirm:registerScriptTapHandler(function()
    audio.play(audio.button)
    onConfirm()
   end)
  edit_box:registerScriptEditBoxHandler(function(l_6_0)
    print("eventType:", l_6_0)
    if l_6_0 == "returnSend" then
      do return end
    end
    if l_6_0 == "return" then
      do return end
    end
    if l_6_0 == "returnDone" then
      onConfirm()
    elseif l_6_0 == "began" then
      do return end
    end
    if l_6_0 == "changed" then
      do return end
    end
    if l_6_0 == "ended" then
       -- Warning: missing end command somewhere! Added here
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  local onUpdate = function(l_7_0)
    if is_end ~= true then
      layer:removeFromParentAndCleanup(true)
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  addBackEvent(layer)
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_10_0)
    if l_10_0 == "enter" then
      onEnter()
    elseif l_10_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return inputlayer

