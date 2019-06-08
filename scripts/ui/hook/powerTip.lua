-- Command line was: E:\github\dhgametool\scripts\ui\hook\powerTip.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local player = require("data.player")
local bagdata = require("data.bag")
local hookdata = require("data.hook")
local i18n = require("res.i18n")
local Type = {Power = 1, Pve = 2, Lv = 3}
ui.create = function(l_1_0, l_1_1)
  local layer = CCLayer:create()
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local board_bg = img.createUI9Sprite(img.ui.tips_bg)
  board_bg:setPreferredSize(CCSizeMake(297, 255))
  board_bg:setScale(view.minScale)
  board_bg:setPosition(view.midX - 25 * view.minScale, view.midY)
  layer:addChild(board_bg)
  local board_bg_w = board_bg:getContentSize().width
  local board_bg_h = board_bg:getContentSize().height
  local titles = {Type.Power = i18n.global.hook_require_power.string, Type.Pve = i18n.global.hook_require_pve.string}
  local contents = {Type.Power = string.format(i18n.global.hook_power_tip.string, hookdata.stage_power(l_1_1)), Type.Pve = i18n.global.hook_pve_tip.string}
  local lbl_title = lbl.createFont1(20, titles[l_1_0], ccc3(255, 228, 156))
  lbl_title:setAnchorPoint(CCPoint(0, 0.5))
  lbl_title:setPosition(CCPoint(17, board_bg_h - 34))
  board_bg:addChild(lbl_title)
  local tips_line = img.createUI9Sprite(img.ui.hero_tips_fgline)
  tips_line:setPreferredSize(CCSizeMake(263, 1))
  tips_line:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 59))
  board_bg:addChild(tips_line)
  local cont_str = string.format(i18n.global.func_need_lv.string, hookdata.getStageLv(l_1_1))
  local lbl_content3 = lbl.create({font = 1, size = 16, text = cont_str, color = ccc3(255, 251, 236), width = 263, align = kCCTextAlignmentLeft, jp = {kind = "ttf"}})
  lbl_content3:setAnchorPoint(CCPoint(0, 1))
  lbl_content3:setPosition(CCPoint(17, board_bg_h - 70))
  board_bg:addChild(lbl_content3)
  local lbl_content = lbl.create({font = 1, size = 16, text = contents[Type.Power], color = ccc3(255, 251, 236), width = 263, align = kCCTextAlignmentLeft, jp = {kind = "ttf"}})
  lbl_content:setAnchorPoint(CCPoint(0, 1))
  lbl_content:setPosition(CCPoint(17, board_bg_h - 70 - lbl_content3:boundingBox().size.height - 10))
  board_bg:addChild(lbl_content)
  local lbl_content2 = lbl.create({font = 1, size = 16, text = contents[Type.Pve], color = ccc3(255, 251, 236), width = 263, align = kCCTextAlignmentLeft, jp = {kind = "ttf"}})
  lbl_content2:setAnchorPoint(CCPoint(0, 1))
  lbl_content2:setPosition(CCPoint(17, board_bg_h - 70 - lbl_content3:boundingBox().size.height - 10 - lbl_content:boundingBox().size.height - 10))
  board_bg:addChild(lbl_content2)
  if player.lv() < hookdata.getStageLv(l_1_1) then
    lbl_content3:setColor(ccc3(250, 53, 53))
  end
  if hookdata.getAllPower() < hookdata.stage_power(l_1_1) then
    lbl_content:setColor(ccc3(250, 53, 53))
  end
  if hookdata.getPveStageId() < l_1_1 then
    lbl_content2:setColor(ccc3(250, 53, 53))
  end
  layer.setTipPos = function(l_2_0, l_2_1, l_2_2, l_2_3)
    board_bg:setAnchorPoint(CCPoint(l_2_0, l_2_1))
    board_bg:setPosition(CCPoint(l_2_2, l_2_3))
   end
  layer.adaptPos = function(l_3_0)
    print("p0.x:" .. l_3_0.x)
    if l_3_0.x < view.logical.w / 2 then
      layer.setTipPos(0, 0, view.minX + (l_3_0.x + 30) * view.minScale, view.minY + (l_3_0.y + 30) * view.minScale)
    else
      layer.setTipPos(1, 0, view.minX + (l_3_0.x - 10) * view.minScale, view.minY + (l_3_0.y + 30) * view.minScale)
    end
   end
  local touchbeginx, touchbeginy, isclick = nil, nil, nil
  local onTouchBegan = function(l_4_0, l_4_1)
    touchbeginx, upvalue_512 = l_4_0, l_4_1
    upvalue_1024 = true
    return true
   end
  local onTouchMoved = function(l_5_0, l_5_1)
   end
  local onTouchEnded = function(l_6_0, l_6_1)
    local p0 = layer:convertToNodeSpace(ccp(l_6_0, l_6_1))
    if not board_bg:boundingBox():containsPoint(p0) then
      backEvent()
    end
   end
  local onTouch = function(l_7_0, l_7_1, l_7_2)
    if l_7_0 == "began" then
      return onTouchBegan(l_7_1, l_7_2)
    elseif l_7_0 == "moved" then
      return onTouchMoved(l_7_1, l_7_2)
    else
      return onTouchEnded(l_7_1, l_7_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
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

