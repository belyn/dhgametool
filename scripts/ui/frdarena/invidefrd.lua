-- Command line was: E:\github\dhgametool\scripts\ui\frdarena\invidefrd.lua 

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
local friend = require("data.friend")
ui.create = function(l_1_0)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local board = img.createUI9Sprite(img.ui.dialog_1)
  board:setPreferredSize(CCSizeMake(646, 514))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local innerBg = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  innerBg:setPreferredSize(CCSizeMake(596, 416))
  innerBg:setAnchorPoint(0, 0)
  innerBg:setPosition(25, 30)
  board:addChild(innerBg)
  local showTitle = lbl.createFont1(26, i18n.global.frdpvp_invitable_list.string, ccc3(230, 208, 174))
  showTitle:setPosition(board:getContentSize().width / 2, 486)
  board:addChild(showTitle, 1)
  local showTitleShade = lbl.createFont1(26, i18n.global.frdpvp_invitable_list.string, ccc3(89, 48, 27))
  showTitleShade:setPosition(board:getContentSize().width / 2, 484)
  board:addChild(showTitleShade)
  local teamnum = 0
  if l_1_0 then
    teamnum = #l_1_0
  end
  local createinfoScroll, scroll = nil, nil
  local createItem = function(l_1_0)
    local item = img.createUI9Sprite(img.ui.botton_fram_2)
    item:setPreferredSize(CCSizeMake(554, 78))
    local item_w = item:getContentSize().width
    local item_h = item:getContentSize().height
    local head = img.createPlayerHead(mbrs[l_1_0].logo)
    frdBtn = SpineMenuItem:create(json.ui.button, head)
    frdBtn:setScale(0.6)
    frdBtn:setPosition(CCPoint(40, item_h / 2 + 1))
    local frdMenu = CCMenu:createWithItem(frdBtn)
    frdMenu:setPosition(0, 0)
    item:addChild(frdMenu)
    frdBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      local params = {}
      layer:addChild(require("ui.frdarena.mbrinfo").create(mbrs[_idx], "none"), 100)
      end)
    local lv_bg = img.createUISprite(img.ui.main_lv_bg)
    lv_bg:setPosition(CCPoint(92, item_h / 2))
    item:addChild(lv_bg)
    local lbl_mem_lv = lbl.createFont1(14, mbrs[l_1_0].lv)
    lbl_mem_lv:setPosition(CCPoint(lv_bg:getContentSize().width / 2, lv_bg:getContentSize().height / 2))
    lv_bg:addChild(lbl_mem_lv)
    local lbl_mem_name = lbl.createFontTTF(16, mbrs[l_1_0].name, ccc3(81, 39, 18))
    lbl_mem_name:setAnchorPoint(CCPoint(0, 0.5))
    lbl_mem_name:setPosition(CCPoint(123, 48))
    item:addChild(lbl_mem_name)
    if mbrs[l_1_0].last then
      local last = mbrs[l_1_0].last
      if mbrs[l_1_0].last ~= 0 then
        last = os.time() - mbrs[l_1_0].last
      end
      local lbl_mem_status = lbl.createFont1(14, friend.onlineStatus(last), ccc3(138, 96, 76))
      lbl_mem_status:setAnchorPoint(CCPoint(0, 0.5))
      lbl_mem_status:setPosition(CCPoint(123, 28))
      item:addChild(lbl_mem_status)
    end
    local invitebtn = img.createLogin9Sprite(img.login.button_9_small_gold)
    invitebtn:setPreferredSize(CCSizeMake(115, 38))
    local lblInvite = lbl.createFont1(16, i18n.global.frdpvp_team_invite.string, ccc3(115, 59, 5))
    lblInvite:setPosition(CCPoint(invitebtn:getContentSize().width / 2, invitebtn:getContentSize().height / 2))
    invitebtn:addChild(lblInvite)
    local applyAgreBtn = SpineMenuItem:create(json.ui.button, invitebtn)
    applyAgreBtn:setPosition(CCPoint(480, item_h / 2 + 1))
    local applyAgreMenu = CCMenu:createWithItem(applyAgreBtn)
    applyAgreMenu:setPosition(CCPoint(0, 0))
    item:addChild(applyAgreMenu)
    applyAgreBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      local param = {}
      param.sid = player.sid
      param.type = 1
      param.uid = mbrs[_idx].uid
      addWaitNet()
      net:gpvp_leaderop(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        applyAgreBtn:setEnabled(false)
        setShader(applyAgreBtn, SHADER_GRAY, true)
         end)
      end)
    return item
   end
  local space_height = 2
  local createScroll = function()
    local scroll_params = {width = 562, height = 375}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  createinfoScroll = function()
    if mbrs then
      upvalue_512 = createScroll()
      scroll:setAnchorPoint(CCPoint(0, 0))
      scroll:setPosition(CCPoint(42, 50))
      board:addChild(scroll)
      for ii = 1, #mbrs do
        local tmp_item = createItem(ii)
        tmp_item.ax = 0.5
        tmp_item.px = 281
        scroll.addItem(tmp_item)
        if ii ~= #mbrs then
          scroll.addSpace(space_height)
        end
      end
      scroll:setOffsetBegin()
    end
   end
  createinfoScroll()
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(615, 485)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
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
  layer:registerScriptTouchHandler(function()
    return true
   end)
  layer:setTouchEnabled(true)
  board:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  anim_arr:addObject(CCDelayTime:create(0.15))
  anim_arr:addObject(CCCallFunc:create(function()
   end))
  board:runAction(CCSequence:create(anim_arr))
  return layer
end

return ui

