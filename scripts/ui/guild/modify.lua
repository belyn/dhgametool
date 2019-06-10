-- Command line was: E:\github\dhgametool\scripts\ui\guild\modify.lua 

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
local gdata = require("data.guild")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local dialog = require("ui.dialog")
local board1 = require("ui.guild.board1")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
ui.create = function()
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local bg = img.createUI9Sprite(img.ui.dialog_1)
  bg:setPreferredSize(CCSizeMake(706, 496))
  bg:setScale(view.minScale)
  bg:setPosition(CCPoint(view.midX, view.midY - 0 * view.minScale))
  layer:addChild(bg)
  local bg_w = bg:getContentSize().width
  local bg_h = bg:getContentSize().height
  bg:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  bg:runAction(CCSequence:create(anim_arr))
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
  local lbl_title = lbl.createFont1(24, i18n.global.guild_modify_board_title.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(bg_w / 2, bg_h - 29))
  bg:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.guild_modify_board_title.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(bg_w / 2, bg_h - 31))
  bg:addChild(lbl_title_shadowD)
  local board = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  board:setPreferredSize(CCSizeMake(640, 388))
  board:setAnchorPoint(CCPoint(0.5, 0))
  board:setPosition(CCPoint(bg_w / 2, 36))
  bg:addChild(board)
  layer.board = board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local x_offset = -70
  local name_bg = img.createLogin9Sprite(img.login.input_border)
  name_bg:setPreferredSize(CCSizeMake(455, 40))
  name_bg:setAnchorPoint(CCPoint(0, 0.5))
  name_bg:setPosition(CCPoint(x_offset + 132, 334))
  board:addChild(name_bg)
  local lbl_name = lbl.createFontTTF(18, gdata.guildObj.name or "", ccc3(73, 38, 4))
  lbl_name:setAnchorPoint(CCPoint(0, 0.5))
  lbl_name:setPosition(CCPoint(15, name_bg:getContentSize().height / 2))
  name_bg:addChild(lbl_name)
  local btn_name0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_name0:setPreferredSize(CCSizeMake(60, 42))
  local icon_name = img.createUISprite(img.ui.guild_icon_edit)
  icon_name:setPosition(CCPoint(btn_name0:getContentSize().width / 2, btn_name0:getContentSize().height / 2 + 1))
  btn_name0:addChild(icon_name)
  local btn_name = SpineMenuItem:create(json.ui.button, btn_name0)
  btn_name:setPosition(CCPoint(x_offset + 622, 334))
  local btn_name_menu = CCMenu:createWithItem(btn_name)
  btn_name_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_name_menu)
  btn_name:registerScriptTapHandler(function()
    audio.play(audio.button)
    local gname = require("ui.guild.gname")
    local onName = function(l_1_0)
      local name_str = l_1_0 or ""
      name_str = string.trim(name_str)
      if isBanWord(name_str) then
        showToast(i18n.global.input_invalid_char.string)
        return 
      end
      if containsInvalidChar(name_str) then
        showToast(i18n.global.input_invalid_char.string)
        return 
      end
      if name_str == lbl_name:getString() then
        return 
      end
      if not name_str or name_str == "" then
        showToast(i18n.global.guild_create_name_empty.string)
        return 
      end
      if #name_str > 16 then
        showToast(string.format(i18n.global.guild_name_length.string, 16))
        return 
      end
      local gParams = {sid = player.sid, name = name_str}
      addWaitNet()
      netClient:guild_name(gParams, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          if l_1_0.status == -1 then
            showToast(i18n.global.guild_name_24h.string)
            return 
          elseif l_1_0.status == -2 then
            showToast(string.format(i18n.global.guild_modify_name_cost.string, gdata.NAME_COST))
            return 
          elseif l_1_0.status == -3 then
            showToast(i18n.global.guild_name_exist.string)
            return 
          end
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        bagdata.subGem(gdata.NAME_COST)
        gdata.guildObj.name = name_str
        lbl_name:setString(name_str)
        showToast(i18n.global.guild_modify_ok.string)
         end)
      end
    layer:addChild(gname.create(onName), 1000)
   end)
  local sel_flag = 1
  if gdata.guildObj and gdata.guildObj.logo then
    sel_flag = gdata.guildObj.logo
  end
  local flag_container = CCSprite:create()
  flag_container:setContentSize(CCSizeMake(70, 73))
  flag_container:setPosition(CCPoint(x_offset + 168, 264))
  board:addChild(flag_container)
  local updateFlag = function(l_4_0)
    flag_container:removeAllChildrenWithCleanup(true)
    local guild_flag = img.createGFlag(l_4_0)
    guild_flag:setAnchorPoint(CCPoint(0, 0))
    guild_flag:setPosition(CCPoint(0, 0))
    flag_container:addChild(guild_flag)
    flag_container.flag = guild_flag
    upvalue_1024 = l_4_0
   end
  local netUpdateFlag = function(l_5_0)
    if l_5_0 == sel_flag then
      return 
    end
    local gParams = {sid = player.sid, id = l_5_0}
    addWaitNet()
    netClient:guild_flag(gParams, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      updateFlag(_flag)
      gdata.guildObj.logo = _flag
      showToast(i18n.global.guild_modify_ok.string)
      end)
   end
  updateFlag(sel_flag)
  local btn_flag0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_flag0:setPreferredSize(CCSizeMake(146, 50))
  local lbl_flag = lbl.createFont1(18, i18n.global.guild_create_flag_sel.string, ccc3(115, 59, 5))
  lbl_flag:setPosition(CCPoint(btn_flag0:getContentSize().width / 2, btn_flag0:getContentSize().height / 2))
  btn_flag0:addChild(lbl_flag)
  local btn_flag = SpineMenuItem:create(json.ui.button, btn_flag0)
  btn_flag:setPosition(CCPoint(x_offset + 313, 270))
  local btn_flag_menu = CCMenu:createWithItem(btn_flag)
  btn_flag_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_flag_menu)
  btn_flag:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.guild.flag").create(function(l_1_0)
      netUpdateFlag(l_1_0)
      end, sel_flag), 1000)
   end)
  local btn_notice0 = img.createLogin9Sprite(img.login.input_border)
  btn_notice0:setPreferredSize(CCSizeMake(518, 110))
  local btn_notice = CCMenuItemSprite:create(btn_notice0, nil)
  btn_notice:setAnchorPoint(CCPoint(0, 0))
  btn_notice:setPosition(CCPoint(x_offset + 132, 108))
  local btn_notice_menu = CCMenu:createWithItem(btn_notice)
  btn_notice_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_notice_menu)
  local lbl_notice = lbl.create({kind = "ttf", size = 18, text = gdata.guildObj.notice or "", color = ccc3(112, 74, 43)})
  lbl_notice:setHorizontalAlignment(kCCTextAlignmentLeft)
  lbl_notice:setDimensions(CCSizeMake(488, 0))
  lbl_notice:setAnchorPoint(CCPoint(0, 1))
  lbl_notice:setPosition(CCPoint(15, btn_notice:getContentSize().height - 15))
  btn_notice:addChild(lbl_notice)
  btn_notice:registerScriptTapHandler(function()
    audio.play(audio.button)
    local inputlayer = require("ui.inputlayer")
    local onNotice = function(l_1_0)
      local notice_str = l_1_0 or ""
      notice_str = string.trim(notice_str)
      if isBanWord(notice_str) then
        showToast(i18n.global.input_invalid_char.string)
        return 
      end
      if containsInvalidChar(notice_str) then
        showToast(i18n.global.input_invalid_char.string)
        return 
      end
      if notice_str == lbl_notice:getString() then
        return 
      end
      local gParams = {sid = player.sid, notice = notice_str}
      addWaitNet()
      netClient:guild_notice(gParams, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        gdata.guildObj.notice = gParams.notice
        lbl_notice:setString(notice_str)
        showToast(i18n.global.guild_modify_ok.string)
         end)
      end
    layer:addChild(inputlayer.create(onNotice, lbl_notice:getString()), 1000)
   end)
  local btn_dissmiss0 = img.createLogin9Sprite(img.login.button_9_small_orange)
  btn_dissmiss0:setPreferredSize(CCSizeMake(196, 50))
  local lbl_dissmiss = lbl.createFont1(16, i18n.global.guild_admin_dismiss.string, ccc3(131, 52, 21))
  lbl_dissmiss:setPosition(CCPoint(btn_dissmiss0:getContentSize().width / 2, btn_dissmiss0:getContentSize().height / 2))
  btn_dissmiss0:addChild(lbl_dissmiss)
  local btn_dissmiss = SpineMenuItem:create(json.ui.button, btn_dissmiss0)
  btn_dissmiss:setPosition(CCPoint(board_w / 2, 56))
  local btn_dissmiss_menu = CCMenu:createWithItem(btn_dissmiss)
  btn_dissmiss_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_dissmiss_menu)
  local btn_cancel0 = img.createLogin9Sprite(img.login.button_9_small_green)
  btn_cancel0:setPreferredSize(CCSizeMake(196, 50))
  local lbl_cancel = lbl.createFont1(18, i18n.global.guild_admin_undismiss.string, ccc3(29, 103, 0))
  lbl_cancel:setPosition(CCPoint(btn_cancel0:getContentSize().width / 2, btn_cancel0:getContentSize().height / 2))
  btn_cancel0:addChild(lbl_cancel)
  local btn_cancel = SpineMenuItem:create(json.ui.button, btn_cancel0)
  btn_cancel:setPosition(CCPoint(board_w / 2, 56))
  local btn_cancel_menu = CCMenu:createWithItem(btn_cancel)
  btn_cancel_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_cancel_menu)
  local lbl_cancel_cd = lbl.createFont2(16, "", ccc3(181, 255, 94))
  lbl_cancel_cd:setPosition(CCPoint(board_w / 2, 93))
  lbl_cancel_cd:setVisible(false)
  board:addChild(lbl_cancel_cd)
  local self_title = gdata.selfTitle()
  if self_title == gdata.TITLE.PRESIDENT then
    if gdata.guildObj.dismiss_cd and os.time() - gdata.last_pull < gdata.guildObj.dismiss_cd then
      btn_dissmiss:setVisible(false)
      btn_cancel:setVisible(true)
      lbl_cancel_cd:setVisible(true)
    else
      btn_dissmiss:setVisible(true)
      btn_cancel:setVisible(false)
      lbl_cancel_cd:setVisible(false)
    end
  else
    if self_title == gdata.TITLE.OFFICER then
      btn_dissmiss:setVisible(false)
      btn_cancel:setVisible(false)
      lbl_cancel_cd:setVisible(false)
    end
  end
end
btn_dissmiss:registerScriptTapHandler(function()
  audio.play(audio.button)
  local doDismiss = function()
    local gParams = {sid = player.sid, dismiss = 1}
    addWaitNet()
    netClient:guild_dismiss(gParams, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status == -1 then
        showToast(i18n.global.guild_dissmiss_toast.string)
        return 
      end
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      gdata.guildObj.dismiss_cd = 7200 + os.time() - gdata.last_pull
      btn_dissmiss:setVisible(false)
      btn_cancel:setVisible(true)
      lbl_cancel_cd:setVisible(true)
      end)
   end
  local process_dialog = function(l_2_0)
    layer:removeChildByTag(dialog.TAG)
    if l_2_0.selected_btn == 2 then
      doDismiss()
    elseif l_2_0.selected_btn == 1 then
       -- Warning: missing end command somewhere! Added here
    end
   end
  local dialog_params = {title = "", body = string.format(i18n.global.guild_admin_dlg_body.string, 2), btn_count = 2, btn_color = {1 = dialog.COLOR_BLUE, 2 = dialog.COLOR_GOLD}, btn_text = {1 = i18n.global.dialog_button_cancel.string, 2 = i18n.global.dialog_button_confirm.string}, selected_btn = 0, callback = process_dialog}
  local dialog_ins = dialog.create(dialog_params)
  layer:addChild(dialog_ins, 1000, dialog.TAG)
end
)
btn_cancel:registerScriptTapHandler(function()
  audio.play(audio.button)
  local gParams = {sid = player.sid, nodismiss = 1}
  addWaitNet()
  netClient:guild_dismiss(gParams, function(l_1_0)
    delWaitNet()
    tbl2string(l_1_0)
    if l_1_0.status ~= 0 then
      showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
      return 
    end
    gdata.guildObj.dismiss_cd = nil
    btn_dissmiss:setVisible(true)
    btn_cancel:setVisible(false)
    lbl_cancel_cd:setVisible(false)
   end)
end
)
local last_update = os.time()
local onUpdate = function(l_10_0)
  if os.time() - last_update < 1 then
    return 
  end
  last_update = os.time()
  local self_title = gdata.selfTitle()
  if self_title < gdata.TITLE.PRESIDENT then
    return 
  end
  if gdata.guildObj.dismiss_cd then
    local remain_time = gdata.guildObj.dismiss_cd - (os.time() - gdata.last_pull)
    if remain_time < 0 then
      gdata.deInit()
      player.gid = 0
      replaceScene(require("ui.town.main").create())
      return 
    end
    local time_str = time2string(remain_time)
    lbl_cancel_cd:setString(time_str)
    btn_dissmiss:setVisible(false)
    btn_cancel:setVisible(true)
    lbl_cancel_cd:setVisible(true)
  else
    btn_dissmiss:setVisible(true)
    btn_cancel:setVisible(false)
    lbl_cancel_cd:setVisible(false)
  end
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

layer:registerScriptHandler(function(l_14_0)
  if l_14_0 == "enter" then
    onEnter()
  elseif l_14_0 == "exit" then
    onExit()
  end
end
)
return layer
end

return ui

