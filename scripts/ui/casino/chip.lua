-- Command line was: E:\github\dhgametool\scripts\ui\casino\chip.lua 

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
local casinodata = require("data.casino")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local COST_PER_CHIP = casinodata.COST_PER_CHIP
local buy_chip_count = 0
ui.create = function()
  buy_chip_count = 0
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board_bg = img.createUI9Sprite(img.ui.dialog_1)
  board_bg:setPreferredSize(CCSizeMake(370, 448))
  board_bg:setScale(view.minScale)
  board_bg:setPosition(view.midX - 0 * view.minScale, view.midY)
  layer:addChild(board_bg)
  local board_bg_w = board_bg:getContentSize().width
  local board_bg_h = board_bg:getContentSize().height
  local edit0 = img.createLogin9Sprite(img.login.input_border)
  local edit = CCEditBox:create(CCSizeMake(160 * view.minScale, 40 * view.minScale), edit0)
  edit:setInputMode(kEditBoxInputModeNumeric)
  edit:setReturnType(kKeyboardReturnTypeDone)
  edit:setMaxLength(5)
  edit:setFont("", 20 * view.minScale)
  edit:setText("0")
  edit:setFontColor(ccc3(148, 98, 66))
  edit:setPosition(scalep(480, 272))
  edit:setVisible(false)
  layer:addChild(edit, 1000)
  layer.edit = edit
  board_bg:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  anim_arr:addObject(CCDelayTime:create(0.15))
  anim_arr:addObject(CCCallFunc:create(function()
    edit:setVisible(true)
   end))
  board_bg:runAction(CCSequence:create(anim_arr))
  local lbl_title = lbl.createFont1(24, i18n.global.chip_board_title.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 29))
  board_bg:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.chip_board_title.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 31))
  board_bg:addChild(lbl_title_shadowD)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(board_bg_w - 25, board_bg_h - 28))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  board_bg:addChild(btn_close_menu, 100)
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local icon_chip = img.createItem(ITEM_ID_CHIP)
  icon_chip:setPosition(CCPoint(board_bg_w / 2, 309))
  board_bg:addChild(icon_chip)
  local btn_sub0 = img.createUISprite(img.ui.btn_sub)
  local btn_sub = SpineMenuItem:create(json.ui.button, btn_sub0)
  btn_sub:setPosition(CCPoint(73, 208))
  local btn_sub_menu = CCMenu:createWithItem(btn_sub)
  btn_sub_menu:setPosition(CCPoint(0, 0))
  board_bg:addChild(btn_sub_menu)
  local btn_add0 = img.createUISprite(img.ui.btn_add)
  local btn_add = SpineMenuItem:create(json.ui.button, btn_add0)
  btn_add:setPosition(CCPoint(295, 208))
  local btn_add_menu = CCMenu:createWithItem(btn_add)
  btn_add_menu:setPosition(CCPoint(0, 0))
  board_bg:addChild(btn_add_menu)
  local gem_bg = img.createUI9Sprite(img.ui.casino_gem_bg)
  gem_bg:setPreferredSize(CCSizeMake(220, 36))
  gem_bg:setPosition(CCPoint(board_bg_w / 2, 141))
  board_bg:addChild(gem_bg)
  local icon_gem = img.createItemIcon2(ITEM_ID_GEM)
  icon_gem:setScale(0.8)
  icon_gem:setPosition(CCPoint(44, gem_bg:getContentSize().height / 2))
  gem_bg:addChild(icon_gem)
  local lbl_pay = lbl.createFont3(16, bagdata.gem() .. "/0")
  lbl_pay:setPosition(CCPoint(130, gem_bg:getContentSize().height / 2 - 1))
  gem_bg:addChild(lbl_pay)
  lbl_pay.gems = bagdata.gem()
  local updatePay = function(l_4_0)
    local tmp_str = bagdata.gem() .. "/" .. l_4_0 * COST_PER_CHIP
    lbl_pay:setString(tmp_str)
    lbl_pay.gems = bagdata.gem()
   end
  local edit_chips = layer.edit
  edit_chips:registerScriptEditBoxHandler(function(l_5_0)
    if l_5_0 == "returnSend" then
      do return end
    end
    if l_5_0 == "return" then
      do return end
    end
    if l_5_0 == "ended" then
      local tmp_chip_count = edit_chips:getText()
      tmp_chip_count = string.trim(tmp_chip_count)
      tmp_chip_count = checkint(tmp_chip_count)
      if tmp_chip_count <= 0 then
        tmp_chip_count = 0
      end
      edit_chips:setText(tmp_chip_count)
      updatePay(tmp_chip_count)
      upvalue_1024 = tmp_chip_count
    elseif l_5_0 == "began" then
      do return end
    end
    if l_5_0 == "changed" then
       -- Warning: missing end command somewhere! Added here
    end
   end)
  btn_sub:registerScriptTapHandler(function()
    audio.play(audio.button)
    local edt_txt = edit_chips:getText()
    edt_txt = string.trim(edt_txt)
    if edt_txt == "" then
      edt_txt = 0
      edit_chips:setText(0)
      updatePay(0)
      upvalue_1536 = 0
      return 
    end
    local chip_count = checkint(edt_txt)
    if chip_count <= 0 then
      edit_chips:setText(0)
      updatePay(0)
      upvalue_1536 = 0
      return 
    else
      chip_count = chip_count - 1
      edit_chips:setText(chip_count)
      updatePay(chip_count)
      upvalue_1536 = chip_count
    end
   end)
  btn_add:registerScriptTapHandler(function()
    audio.play(audio.button)
    local edt_txt = edit_chips:getText()
    edt_txt = string.trim(edt_txt)
    if edt_txt == "" then
      edt_txt = 0
      edit_chips:setText(0)
      updatePay(0)
      upvalue_1536 = 0
      return 
    end
    local chip_count = checkint(edt_txt)
    if chip_count < 0 then
      edit_chips:setText(0)
      updatePay(0)
      upvalue_1536 = 0
      return 
    else
      local tmp_gem_cost = COST_PER_CHIP * (chip_count + 1)
      if bagdata.gem() < tmp_gem_cost then
        local gotoShopDlg = require("ui.gotoShopDlg")
        gotoShopDlg.show(layer, "casino")
        return 
      end
      chip_count = chip_count + 1
      edit_chips:setText(chip_count)
      updatePay(chip_count)
      upvalue_1536 = chip_count
    end
   end)
  local btn_buy0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_buy0:setPreferredSize(CCSizeMake(155, 55))
  local lbl_buy = lbl.createFont1(18, i18n.global.chip_btn_buy.string, ccc3(115, 59, 5))
  lbl_buy:setPosition(CCPoint(btn_buy0:getContentSize().width / 2, btn_buy0:getContentSize().height / 2))
  btn_buy0:addChild(lbl_buy)
  local btn_buy = SpineMenuItem:create(json.ui.button, btn_buy0)
  btn_buy:setPosition(CCPoint(board_bg_w / 2, 70))
  local btn_buy_menu = CCMenu:createWithItem(btn_buy)
  btn_buy_menu:setPosition(CCPoint(0, 0))
  board_bg:addChild(btn_buy_menu)
  btn_buy:registerScriptTapHandler(function()
    audio.play(audio.button)
    btn_buy:setEnabled(false)
    local tmp_edt_txt = edit_chips:getText()
    tmp_edt_txt = string.trim(tmp_edt_txt)
    if tmp_edt_txt == "" then
      tmp_edt_txt = 0
      edit_chips:setText(0)
      updatePay(0)
      upvalue_2048 = 0
      btn_buy:setEnabled(true)
      return 
    else
      local chip_count = checkint(tmp_edt_txt)
      if chip_count <= 0 then
        btn_buy:setEnabled(true)
        return 
      else
        upvalue_2048 = chip_count
      end
    end
    local tmp_gem = buy_chip_count * COST_PER_CHIP
    if bagdata.gem() < tmp_gem then
      local gotoShopDlg = require("ui.gotoShopDlg")
      gotoShopDlg.show(layer, "casino")
      btn_buy:setEnabled(true)
      return 
    end
    if tmp_gem == 0 then
      btn_buy:setEnabled(true)
      return 
    end
    local params = {sid = player.sid, count = buy_chip_count}
    addWaitNet()
    netClient:casino_buy(params, function(l_1_0)
      cclog("buy_chip callback.")
      tbl2string(l_1_0)
      delWaitNet()
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        mainBtn:setEnabled(true)
        return 
      end
      casinodata.addChips(buy_chip_count)
      bagdata.subGem(tmp_gem)
      btn_buy:setEnabled(true)
      layer:removeFromParentAndCleanup(true)
      showToast(i18n.global.toast_buy_okay.string)
      end)
   end)
  local last_update = os.time()
  local onUpdate = function(l_9_0)
    if os.time() - last_update < 0.5 then
      return 
    end
    if not buy_chip_count then
      updatePay(lbl_pay.gems == bagdata.gem() or 0)
    end
    last_update = os.time()
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
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
  layer:registerScriptHandler(function(l_13_0)
    if l_13_0 == "enter" then
      onEnter()
    elseif l_13_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

