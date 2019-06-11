-- Command line was: E:\github\dhgametool\scripts\ui\sealland\sweep.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local sealLandData = require("data.sealland")
local net = require("net.netClient")
local bagdata = require("data.bag")
local player = require("data.player")
local sealLandConfig = require("config.sealland")
ui.create = function(l_1_0, l_1_1, l_1_2)
  local layer = CCLayer:create()
  local buyCount = 1
  local sweepdarkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(sweepdarkbg)
  local sweepboard_bg = img.createUI9Sprite(img.ui.dialog_1)
  sweepboard_bg:setPreferredSize(CCSizeMake(470, 380))
  sweepboard_bg:setScale(view.minScale)
  sweepboard_bg:setPosition(scalep(480, 288))
  layer:addChild(sweepboard_bg)
  local sweepboard_bg_w = sweepboard_bg:getContentSize().width
  local sweepboard_bg_h = sweepboard_bg:getContentSize().height
  local edit0 = img.createLogin9Sprite(img.login.input_border)
  local edit = CCEditBox:create(CCSizeMake(156 * view.minScale, 40 * view.minScale), edit0)
  edit:setInputMode(kEditBoxInputModeNumeric)
  edit:setReturnType(kKeyboardReturnTypeDone)
  edit:setMaxLength(5)
  edit:setFont("", 16 * view.minScale)
  edit:setText("1")
  edit:setFontColor(ccc3(148, 98, 66))
  edit:setPosition(scalep(480, 308))
  layer:addChild(edit, 1000)
  layer.edit = edit
  local sweeplbl = lbl.createMixFont1(18, i18n.global.seal_land_sweep_times.string, ccc3(115, 59, 5))
  sweeplbl:setPosition(CCPoint(sweepboard_bg_w / 2, 275))
  sweepboard_bg:addChild(sweeplbl)
  local btn_sub0 = img.createUISprite(img.ui.btn_sub)
  local btn_sub = SpineMenuItem:create(json.ui.button, btn_sub0)
  btn_sub:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 - 111, 210))
  local btn_sub_menu = CCMenu:createWithItem(btn_sub)
  btn_sub_menu:setPosition(CCPoint(0, 0))
  sweepboard_bg:addChild(btn_sub_menu)
  local minSubImage = img.createUISprite(img.ui.btn_max)
  minSubImage:setFlipY(true)
  local minSub = SpineMenuItem:create(json.ui.button, minSubImage)
  minSub:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 - 111 - 50, 210))
  minSub:setRotation(180)
  local minSubMenu = CCMenu:createWithItem(minSub)
  minSubMenu:setPosition(CCPoint(0, 0))
  sweepboard_bg:addChild(minSubMenu)
  local btn_add0 = img.createUISprite(img.ui.btn_add)
  local btn_add = SpineMenuItem:create(json.ui.button, btn_add0)
  btn_add:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 + 111, 210))
  local btn_add_menu = CCMenu:createWithItem(btn_add)
  btn_add_menu:setPosition(CCPoint(0, 0))
  sweepboard_bg:addChild(btn_add_menu)
  local maxAddImage = img.createUISprite(img.ui.btn_max)
  local maxAdd = SpineMenuItem:create(json.ui.button, maxAddImage)
  maxAdd:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 + 111 + 50, 210))
  local maxAddMenu = CCMenu:createWithItem(maxAdd)
  maxAddMenu:setPosition(CCPoint(0, 0))
  sweepboard_bg:addChild(maxAddMenu)
  local broken_bg = img.createUI9Sprite(img.ui.casino_gem_bg)
  broken_bg:setPreferredSize(CCSizeMake(165, 34))
  broken_bg:setPosition(CCPoint(sweepboard_bg_w / 2, 144))
  sweepboard_bg:addChild(broken_bg)
  local icon_broken = img.createUISprite(img.ui.seal_land_sweep)
  icon_broken:setScale(0.8)
  icon_broken:setPosition(CCPoint(30, broken_bg:getContentSize().height / 2))
  broken_bg:addChild(icon_broken)
  local tGem = 0
  if bagdata.items.find(ITEM_ID_GEM) then
    tGem = bagdata.items.find(ITEM_ID_GEM).num
  end
  local lbl_pay = lbl.createFont2(16, tGem)
  lbl_pay:setPosition(CCPoint(100, broken_bg:getContentSize().height / 2))
  broken_bg:addChild(lbl_pay)
  local updatePay = function(l_1_0)
    local tmp_str = num2KM(num2KM(l_1_0))
    lbl_pay:setString(tmp_str)
   end
  updatePay(1)
  local edit_tickets = layer.edit
  edit_tickets:registerScriptEditBoxHandler(function(l_2_0)
    if l_2_0 == "returnSend" then
      do return end
    end
    if l_2_0 == "return" then
      do return end
    end
    if l_2_0 == "ended" then
      local tmp_ticket_count = edit_tickets:getText()
      tmp_ticket_count = string.trim(tmp_ticket_count)
      tmp_ticket_count = checkint(tmp_ticket_count)
      if tmp_ticket_count <= 0 then
        tmp_ticket_count = 0
      end
      edit_tickets:setText(tmp_ticket_count)
      updatePay(tmp_ticket_count)
      upvalue_1024 = tmp_ticket_count
    elseif l_2_0 == "began" then
      do return end
    end
    if l_2_0 == "changed" then
       -- Warning: missing end command somewhere! Added here
    end
   end)
  btn_sub:registerScriptTapHandler(function()
    audio.play(audio.button)
    local edt_txt = edit_tickets:getText()
    edt_txt = string.trim(edt_txt)
    if edt_txt == "" then
      edt_txt = 0
      edit_tickets:setText(0)
      updatePay(0)
      upvalue_1536 = 0
      return 
    end
    local ticket_count = checkint(edt_txt)
    if ticket_count <= 0 then
      edit_tickets:setText(0)
      updatePay(0)
      upvalue_1536 = 0
      return 
    else
      ticket_count = ticket_count - 1
      edit_tickets:setText(ticket_count)
      updatePay(ticket_count)
      upvalue_1536 = ticket_count
    end
   end)
  minSub:registerScriptTapHandler(function()
    audio.play(audio.button)
    local edt_txt = edit_tickets:getText()
    edt_txt = string.trim(edt_txt)
    if edt_txt == "" then
      edt_txt = 0
      edit_tickets:setText(0)
      updatePay(0)
      upvalue_1536 = 0
      return 
    end
    local ticket_count = sealLandData:availableSweepTimes()
    if ticket_count <= 0 then
      ticket_count = 0
    else
      ticket_count = 1
    end
    edit_tickets:setText(ticket_count)
    updatePay(ticket_count)
    upvalue_1536 = ticket_count
   end)
  btn_add:registerScriptTapHandler(function()
    audio.play(audio.button)
    local edt_txt = edit_tickets:getText()
    edt_txt = string.trim(edt_txt)
    if edt_txt == "" then
      edt_txt = 0
      edit_tickets:setText(0)
      updatePay(0)
      upvalue_1536 = 0
      return 
    end
    local ticket_count = checkint(edt_txt)
    if ticket_count < 0 then
      edit_tickets:setText(0)
      updatePay(0)
      upvalue_1536 = 0
      return 
    else
      if not ui.checkSweep(ticket_count + 1) then
        return 
      end
      ticket_count = ticket_count + 1
      edit_tickets:setText(ticket_count)
      updatePay(ticket_count)
      upvalue_1536 = ticket_count
    end
   end)
  maxAdd:registerScriptTapHandler(function()
    audio.play(audio.button)
    local edt_txt = edit_tickets:getText()
    edt_txt = string.trim(edt_txt)
    if edt_txt == "" then
      edt_txt = 0
      edit_tickets:setText(0)
      updatePay(0)
      upvalue_1536 = 0
      return 
    end
    local ticket_count = sealLandData:availableSweepTimes()
    if ticket_count <= 0 then
      ticket_count = 0
    end
    edit_tickets:setText(ticket_count)
    updatePay(ticket_count)
    upvalue_1536 = ticket_count
   end)
  local sweepbackEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local okSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
  okSprite:setPreferredSize(CCSize(155, 45))
  local oklab = lbl.createFont1(18, i18n.global.dialog_button_confirm.string, ccc3(126, 39, 0))
  oklab:setPosition(CCPoint(okSprite:getContentSize().width / 2, okSprite:getContentSize().height / 2))
  okSprite:addChild(oklab)
  local okBtn = SpineMenuItem:create(json.ui.button, okSprite)
  okBtn:setPosition(CCPoint(sweepboard_bg_w / 2, 80))
  local okMenu = CCMenu:createWithItem(okBtn)
  okMenu:setPosition(0, 0)
  sweepboard_bg:addChild(okMenu)
  okBtn:registerScriptTapHandler(function()
    disableObjAWhile(okBtn)
    local edt_txt = edit_tickets:getText()
    edt_txt = string.trim(edt_txt)
    if edt_txt == "" then
      sweepbackEvent()
      return 
    end
    local ticket_count = checkint(edt_txt)
    if ticket_count <= 0 then
      sweepbackEvent()
      return 
    end
    if not ui.checkSweep(ticket_count) then
      return 
    end
    addWaitNet()
    ui.sweep(levelId, ticket_count, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        if l_1_0.status == -1 then
          showToast(i18n.global.seal_land_sweep_times0.string)
        else
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        sealLandData:sweep(ticket_count)
        do
          local rewards = {equips = {}, items = {}}
          for k,v in pairs(sealLandConfig) do
            if v and v.reward and k == levelId then
              for index = 1, #v.reward do
                local reward = v.reward[index]
                if reward.type == 1 then
                  rewards.items[#rewards.items + 1] = {id = reward.id, num = reward.num * ticket_count}
                elseif reward.type == 2 then
                  rewards.equips[#rewards.equips + 1] = {id = reward.id, num = reward.num * ticket_count}
                end
              end
            end
          end
          bagdata.addRewards(rewards)
          if callback then
            callback()
          end
          sweepbackEvent()
          parent:addChild(require("ui.hook.drops").create(rewards))
        end
         -- Warning: missing end command somewhere! Added here
      end
      end)
   end)
  local sweepbtn_close0 = img.createUISprite(img.ui.close)
  local sweepbtn_close = SpineMenuItem:create(json.ui.button, sweepbtn_close0)
  sweepbtn_close:setPosition(CCPoint(sweepboard_bg_w - 25, sweepboard_bg_h - 28))
  local sweepbtn_close_menu = CCMenu:createWithItem(sweepbtn_close)
  sweepbtn_close_menu:setPosition(CCPoint(0, 0))
  sweepboard_bg:addChild(sweepbtn_close_menu, 100)
  sweepbtn_close:registerScriptTapHandler(function()
    sweepbackEvent()
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    sweepbackEvent()
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_13_0)
    if l_13_0 == "enter" then
      onEnter()
    elseif l_13_0 == "exit" then
      onExit()
    end
   end)
  l_1_0:addChild(layer, 1000)
end

ui.sweep = function(l_2_0, l_2_1, l_2_2)
  local nParams = {sid = player.sid, id = l_2_0, num = l_2_1}
  tbl2string(nParams)
  net:sealland_reward(nParams, function(l_1_0)
    callback(l_1_0)
   end)
end

ui.checkSweep = function(l_3_0)
  local availableFightTimes = sealLandData:availableSweepTimes()
  if availableFightTimes < l_3_0 then
    showToast(string.format(i18n.global.seal_land_sweep_available_times.string, availableFightTimes))
    return false
  end
  return true
end

return ui

