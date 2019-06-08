-- Command line was: E:\github\dhgametool\scripts\ui\frdarena\createteam.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local player = require("data.player")
local userdata = require("data.userdata")
local net = require("net.netClient")
local frdarena = require("data.frdarena")
ui.create = function()
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board = img.createUI9Sprite(img.ui.dialog_1)
  board:setPreferredSize(CCSizeMake(510, 376))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local lbl_title = lbl.createFont1(24, i18n.global.goto_guild_create.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_w / 2, board_h - 29))
  board:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.goto_guild_create.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_w / 2, board_h - 31))
  board:addChild(lbl_title_shadowD)
  local lbl_teamname = lbl.createFont1(18, i18n.global.frdpvp_team_teamname.string, ccc3(113, 63, 22))
  lbl_teamname:setAnchorPoint(CCPoint(0, 0))
  lbl_teamname:setPosition(CCPoint(79, 262))
  board:addChild(lbl_teamname)
  local lbl_power = lbl.createFont1(18, i18n.global.frdpvp_team_reqpower.string, ccc3(113, 63, 22))
  lbl_power:setAnchorPoint(CCPoint(0, 0))
  lbl_power:setPosition(CCPoint(79, 187))
  board:addChild(lbl_power)
  local edit_name0 = img.createLogin9Sprite(img.login.input_border)
  local edit_name = CCEditBox:create(CCSizeMake(350 * view.minScale, 40 * view.minScale), edit_name0)
  edit_name:setReturnType(kKeyboardReturnTypeDone)
  edit_name:setMaxLength(12)
  edit_name:setFont("", 16 * view.minScale)
  edit_name:setFontColor(ccc3(113, 63, 22))
  edit_name:setPlaceHolder("")
  edit_name:setVisible(false)
  edit_name:setPosition(scalep(480, 338))
  layer:addChild(edit_name, 100)
  local edit_power0 = img.createLogin9Sprite(img.login.input_border)
  local edit_power = CCEditBox:create(CCSizeMake(350 * view.minScale, 40 * view.minScale), edit_power0)
  edit_power:setInputMode(kEditBoxInputModeNumeric)
  edit_power:setReturnType(kKeyboardReturnTypeDone)
  edit_power:setMaxLength(9)
  edit_power:setFont("", 16 * view.minScale)
  edit_power:setText(string.format("%d", 1))
  edit_power:setVisible(false)
  edit_power:setFontColor(ccc3(148, 98, 66))
  edit_power:setPosition(scalep(480, 262))
  layer:addChild(edit_power, 100)
  local edit_chips = edit_power
  edit_chips:registerScriptEditBoxHandler(function(l_1_0)
    if l_1_0 == "returnSend" then
      do return end
    end
    if l_1_0 == "return" then
      do return end
    end
    if l_1_0 == "ended" then
      local tmp_chip_count = edit_chips:getText()
      tmp_chip_count = string.trim(tmp_chip_count)
      tmp_chip_count = checkint(tmp_chip_count)
      if tmp_chip_count < 1 then
        tmp_chip_count = 1
      elseif tmp_chip_count > 999999 then
        tmp_chip_count = 999999
      end
      edit_chips:setText(tmp_chip_count)
    elseif l_1_0 == "began" then
      do return end
    end
    if l_1_0 == "changed" then
       -- Warning: missing end command somewhere! Added here
    end
   end)
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
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local btn_create0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_create0:setPreferredSize(CCSizeMake(160, 55))
  local lbl_create = lbl.createFont1(18, i18n.global.goto_guild_create.string, ccc3(115, 59, 5))
  lbl_create:setPosition(CCPoint(btn_create0:getContentSize().width / 2, btn_create0:getContentSize().height / 2))
  btn_create0:addChild(lbl_create)
  local btn_create = SpineMenuItem:create(json.ui.button, btn_create0)
  btn_create:setPosition(CCPoint(board_w / 2, 75))
  local btn_create_menu = CCMenu:createWithItem(btn_create)
  btn_create_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_create_menu)
  btn_create:registerScriptTapHandler(function()
    audio.play(audio.button)
    local input_power = checkint(edit_power:getText())
    local input_name = edit_name:getText()
    input_name = string.trim(input_name)
    if not input_name or string.len(input_name) < 5 then
      showToast(i18n.global.frdpvp_team_name_limit.string)
      return 
    end
    if not input_name or string.len(input_name) > 12 then
      showToast(i18n.global.frdpvp_team_name_limit.string)
      return 
    end
    if not input_name or isBanWord(input_name) then
      showToast(i18n.global.input_invalid_char.string)
      return 
    end
    local params = {sid = player.sid, name = input_name, need_power = input_power}
    addWaitNet()
    net:create_gpvpteam(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status == -2 then
        showToast(i18n.global.frdpvp_team_iinteam.string)
        return 
      end
      if l_1_0.status == -1 then
        showToast(i18n.global.player_change_name_equal.string)
        return 
      end
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      addWaitNet()
      net:gpvp_sync(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        frdarena.team = l_1_0.team
        layer:getParent():getParent():addChild(require("ui.frdarena.teaminfo").create())
        layer:getParent():removeFromParentAndCleanup(true)
         end)
      end)
   end)
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
  board:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  anim_arr:addObject(CCDelayTime:create(0.15))
  anim_arr:addObject(CCCallFunc:create(function()
    edit_name:setVisible(true)
    edit_power:setVisible(true)
   end))
  board:runAction(CCSequence:create(anim_arr))
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

