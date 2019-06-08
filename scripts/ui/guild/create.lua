-- Command line was: E:\github\dhgametool\scripts\ui\guild\create.lua 

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
ui.create = function(l_1_0)
  local layer = board1.create(board1.TAB.CREATE, l_1_0)
  local board = layer.board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local x_offset = -72
  local edit_name0 = img.createLogin9Sprite(img.login.input_border)
  local edit_name = CCEditBox:create(CCSizeMake(538 * view.minScale, 40 * view.minScale), edit_name0)
  edit_name:setInputFlag(kEditBoxInputFlagInitialCapsSentence)
  edit_name:setReturnType(kKeyboardReturnTypeDone)
  edit_name:setMaxLength(16)
  edit_name:setFont("", 16 * view.minScale)
  edit_name:setFontColor(ccc3(73, 38, 4))
  edit_name:setPlaceHolder(i18n.global.guild_create_edit_guild_name.string)
  edit_name:setAnchorPoint(CCPoint(0, 0.5))
  edit_name:setPosition(scalep(211, 412))
  layer:addChild(edit_name)
  local sel_flag = 1
  local flag_container = CCSprite:create()
  flag_container:setContentSize(CCSizeMake(70, 73))
  flag_container:setPosition(CCPoint(x_offset + 158, 262))
  board:addChild(flag_container)
  local updateFlag = function(l_1_0)
    flag_container:removeAllChildrenWithCleanup(true)
    local guild_flag = img.createGFlag(l_1_0)
    guild_flag:setAnchorPoint(CCPoint(0, 0))
    guild_flag:setPosition(CCPoint(0, 0))
    flag_container:addChild(guild_flag)
    flag_container.flag = guild_flag
    upvalue_1024 = l_1_0
   end
  updateFlag(sel_flag)
  local btn_flag0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_flag0:setPreferredSize(CCSizeMake(146, 50))
  local lbl_flag = lbl.createFont1(18, i18n.global.guild_create_flag_sel.string, ccc3(115, 59, 5))
  lbl_flag:setPosition(CCPoint(btn_flag0:getContentSize().width / 2, btn_flag0:getContentSize().height / 2))
  btn_flag0:addChild(lbl_flag)
  local btn_flag = SpineMenuItem:create(json.ui.button, btn_flag0)
  btn_flag:setPosition(CCPoint(x_offset + 303, 268))
  local btn_flag_menu = CCMenu:createWithItem(btn_flag)
  btn_flag_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_flag_menu)
  btn_flag:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.guild.flag").create(function(l_1_0)
      updateFlag(l_1_0)
      end, sel_flag), 1000)
   end)
  local btn_notice0 = img.createLogin9Sprite(img.login.input_border)
  btn_notice0:setPreferredSize(CCSizeMake(538, 110))
  local btn_notice = CCMenuItemSprite:create(btn_notice0, nil)
  btn_notice:setAnchorPoint(CCPoint(0, 0))
  btn_notice:setPosition(CCPoint(x_offset + 122, 108))
  local btn_notice_menu = CCMenu:createWithItem(btn_notice)
  btn_notice_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_notice_menu)
  local lbl_notice = lbl.create({kind = "ttf", size = 18, text = i18n.global.guild_create_notice_des.string, color = ccc3(112, 74, 43)})
  lbl_notice:setHorizontalAlignment(kCCTextAlignmentLeft)
  lbl_notice:setDimensions(CCSizeMake(508, 0))
  lbl_notice:setAnchorPoint(CCPoint(0, 1))
  lbl_notice:setPosition(CCPoint(15, btn_notice:getContentSize().height - 15))
  btn_notice:addChild(lbl_notice)
  local btn_create0 = img.createLogin9Sprite(img.login.button_9_small_green)
  btn_create0:setPreferredSize(CCSizeMake(177, 75))
  local lbl_create = lbl.createFont1(16, i18n.global.guild_create_btn_create.string, ccc3(53, 87, 4))
  lbl_create:setPosition(CCPoint(btn_create0:getContentSize().width / 2, 54))
  btn_create0:addChild(lbl_create)
  local icon_gem = img.createItemIcon2(ITEM_ID_GEM)
  icon_gem:setScale(0.8)
  icon_gem:setPosition(CCPoint(64, 26))
  btn_create0:addChild(icon_gem)
  local lbl_gem = lbl.createFont2(20, "" .. gdata.CREATE_COST)
  lbl_gem:setPosition(CCPoint(107, 26))
  btn_create0:addChild(lbl_gem)
  local btn_create = SpineMenuItem:create(json.ui.button, btn_create0)
  btn_create:setPosition(CCPoint(board_w / 2, 63))
  local btn_create_menu = CCMenu:createWithItem(btn_create)
  btn_create_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_create_menu)
  btn_notice:registerScriptTapHandler(function()
    audio.play(audio.button)
    local inputlayer = require("ui.inputlayer")
    local onNotice = function(l_1_0)
      local notice_str = l_1_0 or ""
      notice_str = string.trim(notice_str)
      if containsInvalidChar(notice_str) then
        showToast(i18n.global.input_invalid_char.string)
        return 
      end
      lbl_notice:setString(notice_str)
      end
    layer:addChild(inputlayer.create(onNotice, lbl_notice:getString()), 1000)
   end)
  btn_create:registerScriptTapHandler(function()
    audio.play(audio.button)
    if bagdata.gem() < gdata.CREATE_COST then
      showToast(string.format(i18n.global.guild_create_need_coin.string, gdata.CREATE_COST))
      return 
    end
    local gname = edit_name:getText()
    gname = string.trim(gname)
    local notice = lbl_notice:getString()
    notice = string.trim(notice or "")
    if isBanWord(gname) or isBanWord(notice) then
      showToast(i18n.global.input_invalid_char.string)
      return 
    end
    if not gname or gname == "" then
      showToast(i18n.global.guild_create_name_empty.string)
      return 
    end
    if  gname > 16 then
      showToast(string.format(i18n.global.guild_name_length.string, 16))
      return 
    end
    if containsInvalidChar(gname) then
      showToast(i18n.global.input_invalid_char.string)
      return 
    end
    local params = {sid = player.sid, name = gname, logo = sel_flag, notice = lbl_notice:getString()}
    addWaitNet()
    netClient:guild_create(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        if l_1_0.status == -1 then
          showToast(string.format(i18n.global.guild_create_lv.string, UNLOCK_GUILD_LEVEL))
          return 
        elseif l_1_0.status == -2 then
          showToast(string.format(i18n.global.guild_create_cost.string, gdata.CREATE_COST))
          return 
        elseif l_1_0.status == -3 then
          showToast(i18n.global.guild_name_exist.string)
          return 
        elseif l_1_0.status == -4 then
          showToast(i18n.global.guild_accepted_u.string)
          return 
        end
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      bagdata.subGem(gdata.CREATE_COST)
      local gparams = {sid = player.sid}
      addWaitNet()
      netClient:guild_sync(gparams, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        gdata.init(l_1_0)
        replaceScene(require("ui.guild.main").create())
         end)
      end)
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

