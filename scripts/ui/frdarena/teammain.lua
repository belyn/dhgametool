-- Command line was: E:\github\dhgametool\scripts\ui\frdarena\teammain.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local cfghero = require("config.hero")
local cfgequip = require("config.equip")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local frdarena = require("data.frdarena")
ui.create = function()
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local board_w = 840
  local board_h = 540
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(board_w, board_h))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local innerBg = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  innerBg:setPreferredSize(CCSizeMake(780, 375))
  innerBg:setAnchorPoint(0, 0)
  innerBg:setPosition(29, 90)
  board:addChild(innerBg)
  local showTitle = lbl.createFont1(26, i18n.global.frdpvp_team_lobby.string, ccc3(230, 208, 174))
  showTitle:setPosition(board:getContentSize().width / 2, 511)
  board:addChild(showTitle, 1)
  local showTitleShade = lbl.createFont1(26, i18n.global.frdpvp_team_lobby.string, ccc3(89, 48, 27))
  showTitleShade:setPosition(board:getContentSize().width / 2, 509)
  board:addChild(showTitleShade)
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(815, 513)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local teams = {}
  local items = {}
  local createItem = function(l_2_0, l_2_1)
    local item = img.createUI9Sprite(img.ui.botton_fram_2)
    item:setPreferredSize(CCSizeMake(735, 88))
    items[l_2_1] = item
    local item_w = item:getContentSize().width
    local item_h = item:getContentSize().height
    local headdx = 65
    local head = nil
    for i = 1, 3 do
      if l_2_0.mbrs[i] then
        head = img.createPlayerHeadForArena(l_2_0.mbrs[i].logo, l_2_0.mbrs[i].lv)
        if l_2_0.leader == l_2_0.mbrs[i].uid then
          local teamIcon = img.createUISprite(img.ui.friend_pvp_captain)
          teamIcon:setAnchorPoint(0, 1)
          teamIcon:setPosition(0, head:getContentSize().height)
          head:addChild(teamIcon)
        else
          head = img.createUI9Sprite(img.ui.friend_pvp_blackpl)
          head:setOpacity(178.5)
        end
      end
      head:setScale(0.65)
      head:setPosition(CCPoint(48 + (i - 1) * headdx, item_h / 2 + 1))
      item:addChild(head)
    end
    local lbl_mem_name = lbl.createFontTTF(16, l_2_0.name, ccc3(81, 39, 18))
    lbl_mem_name:setAnchorPoint(CCPoint(0, 0))
    lbl_mem_name:setPosition(CCPoint(220, 51))
    item:addChild(lbl_mem_name)
    powerBg = img.createUI9Sprite(img.ui.arena_frame7)
    powerBg:setPreferredSize(CCSize(146, 28))
    powerBg:setAnchorPoint(ccp(0.5, 0))
    powerBg:setPosition(293, 20)
    item:addChild(powerBg)
    local showPowerIcon = img.createUISprite(img.ui.power_icon)
    showPowerIcon:setScale(0.5)
    showPowerIcon:setPosition(234, 34)
    item:addChild(showPowerIcon)
    local showPower = lbl.createFont2(16, l_2_0.power)
    showPower:setPosition(293, 34)
    item:addChild(showPower)
    local lblNeedPower = lbl.createFont1(14, "need power", ccc3(154, 106, 82))
    lblNeedPower:setAnchorPoint(0.5, 0)
    lblNeedPower:setPosition(455, 50)
    item:addChild(lblNeedPower)
    local needPower = lbl.createFont1(20, l_2_0.need_power, ccc3(81, 39, 18))
    needPower:setAnchorPoint(0.5, 0)
    needPower:setPosition(455, 24)
    item:addChild(needPower)
    local applySp = img.createLogin9Sprite(img.login.button_9_small_gold)
    applySp:setPreferredSize(CCSizeMake(116, 42))
    local applylbl = lbl.createFont1(16, i18n.global.guild_btn_apply.string, ccc3(115, 59, 5))
    applylbl:setPosition(CCPoint(applySp:getContentSize().width / 2, applySp:getContentSize().height / 2 + 1))
    applySp:addChild(applylbl)
    local applyAgreBtn = SpineMenuItem:create(json.ui.button, applySp)
    applyAgreBtn:setPosition(CCPoint(650, item_h / 2 + 1))
    local applyAgreMenu = CCMenu:createWithItem(applyAgreBtn)
    applyAgreMenu:setPosition(CCPoint(0, 0))
    item:addChild(applyAgreMenu)
    applyAgreBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      local param = {}
      param.sid = player.sid
      param.type = 1
      param.teamid = teamObj.id
      tbl2string(param)
      addWaitNet()
      net:gpvp_mbrop(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        setShader(applyAgreBtn, SHADER_GRAY, true)
        applyAgreBtn:setEnabled(false)
         end)
      end)
    return item
   end
  local createScroll = function()
    local scroll_params = {width = 738, height = 275}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local scroll = nil
  local space_height = 2
  local initData = function(l_4_0)
    items = {}
    if scroll then
      scroll:removeFromParentAndCleanup(true)
      upvalue_512 = nil
    end
    if l_4_0.team then
      upvalue_512 = createScroll()
      scroll:setAnchorPoint(CCPoint(0, 0))
      scroll:setPosition(CCPoint(50, 105))
      board:addChild(scroll)
      for ii = 1,  l_4_0.team do
        local tmp_item = createItem(l_4_0.team[ii], ii)
        tmp_item.ax = 0.5
        tmp_item.px = 369
        scroll.addItem(tmp_item)
        if ii ~=  l_4_0.team then
          scroll.addSpace(space_height)
        end
      end
      scroll:setOffsetBegin()
    end
   end
  local editId0 = img.createLogin9Sprite(img.login.input_border)
  local editId = CCEditBox:create(CCSizeMake(324 * view.minScale, 38 * view.minScale), editId0)
  editId:setInputMode(kEditBoxInputModeNumeric)
  editId:setReturnType(kKeyboardReturnTypeDone)
  editId:setMaxLength(9)
  editId:setFont("", 16 * view.minScale)
  editId:setPlaceHolder(i18n.global.friend_find_id.string)
  editId:setFontColor(ccc3(148, 98, 66))
  editId:setPosition(scalep(274, 438))
  layer:addChild(editId)
  editId:setVisible(false)
  local apply = img.createLogin9Sprite(img.login.button_9_small_gold)
  apply:setPreferredSize(CCSizeMake(160, 40))
  local applylab = lbl.createFont1(16, i18n.global.guild_btn_apply.string, ccc3(115, 59, 5))
  applylab:setPosition(CCPoint(apply:getContentSize().width / 2, apply:getContentSize().height / 2 + 1))
  apply:addChild(applylab)
  local applyBtn = SpineMenuItem:create(json.ui.button, apply)
  applyBtn:setAnchorPoint(0.5, 0)
  applyBtn:setPosition(CCPoint(707, 398))
  local applyMenu = CCMenu:createWithItem(applyBtn)
  applyMenu:setPosition(CCPoint(0, 0))
  board:addChild(applyMenu)
  applyBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if editId:getText() == "" then
      showToast(i18n.global.input_empty.string)
      return 
    end
    local inputTeamid = tonumber(editId:getText())
    local params = {sid = player.sid, type = 1, teamid = inputTeamid}
    tbl2string(params)
    addWaitNet()
    net:gpvp_mbrop(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status == -1 then
        showToast(i18n.global.frdpvp_team_fighting.string)
        return 
      end
      if l_1_0.status < 0 then
        showToast("status:" .. l_1_0.status)
        return 
      end
      showToast(i18n.global.friend_apply_succese.string)
      end)
   end)
  local create = img.createLogin9Sprite(img.login.button_9_small_gold)
  create:setPreferredSize(CCSizeMake(162, 52))
  local createlab = lbl.createFont1(16, i18n.global.goto_guild_create.string, ccc3(115, 59, 5))
  createlab:setPosition(CCPoint(create:getContentSize().width / 2, create:getContentSize().height / 2 + 1))
  create:addChild(createlab)
  local createBtn = SpineMenuItem:create(json.ui.button, create)
  createBtn:setAnchorPoint(0.5, 0)
  createBtn:setPosition(CCPoint(board_w / 2 - 174, 27))
  local createMenu = CCMenu:createWithItem(createBtn)
  createMenu:setPosition(CCPoint(0, 0))
  board:addChild(createMenu)
  createBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.frdarena.createteam").create())
   end)
  local invited = img.createLogin9Sprite(img.login.button_9_small_gold)
  invited:setPreferredSize(CCSizeMake(162, 52))
  addRedDot(invited, {px = invited:getContentSize().width - 7, py = invited:getContentSize().height - 7})
  delRedDot(invited)
  local invitedlab = lbl.createFont1(16, i18n.global.frdpvp_team_invite.string, ccc3(115, 59, 5))
  invitedlab:setPosition(CCPoint(invited:getContentSize().width / 2, invited:getContentSize().height / 2 + 1))
  invited:addChild(invitedlab)
  local invitedBtn = SpineMenuItem:create(json.ui.button, invited)
  invitedBtn:setAnchorPoint(0.5, 0)
  invitedBtn:setPosition(CCPoint(board_w / 2, 27))
  local invitedMenu = CCMenu:createWithItem(invitedBtn)
  invitedMenu:setPosition(CCPoint(0, 0))
  board:addChild(invitedMenu)
  layer:scheduleUpdateWithPriorityLua(function()
    if frdarena.showinvitRed == true then
      addRedDot(invited, {px = invited:getContentSize().width - 7, py = invited:getContentSize().height - 7})
    else
      delRedDot(invited)
    end
   end)
  invitedBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local param = {}
    param.sid = player.sid
    addWaitNet()
    net:gpvp_invitelist(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      layer:addChild(require("ui.frdarena.teaminvited").create(l_1_0))
      frdarena.showinvitRed = false
      end)
   end)
  local refresh = img.createLogin9Sprite(img.login.button_9_small_green)
  refresh:setPreferredSize(CCSizeMake(162, 52))
  local refreshlab = lbl.createFont1(16, i18n.global.casino_btn_refresh.string, ccc3(29, 103, 0))
  refreshlab:setPosition(CCPoint(refresh:getContentSize().width / 2, refresh:getContentSize().height / 2 + 1))
  refresh:addChild(refreshlab)
  local refreshBtn = SpineMenuItem:create(json.ui.button, refresh)
  refreshBtn:setAnchorPoint(0.5, 0)
  refreshBtn:setPosition(CCPoint(board_w / 2 + 174, 27))
  local refreshMenu = CCMenu:createWithItem(refreshBtn)
  refreshMenu:setPosition(CCPoint(0, 0))
  board:addChild(refreshMenu)
  refreshBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local params = {sid = player.sid}
    addWaitNet()
    net:gpvp_refresh(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      initData(l_1_0)
      end)
   end)
  local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
  local onTouchBegan = function(l_10_0, l_10_1)
    touchbeginx, upvalue_512 = l_10_0, l_10_1
    upvalue_1024 = true
    if scroll and not tolua.isnull(scroll) then
      local obj = scroll.content_layer
      local p0 = obj:convertToNodeSpace(ccp(l_10_0, l_10_1))
      for ii = 1,  items do
        if items[ii] and items[ii]:boundingBox():containsPoint(p0) then
          upvalue_2560 = items[ii]
        end
      end
    end
    return true
   end
  local onTouchMoved = function(l_11_0, l_11_1)
    if isclick and (math.abs(touchbeginx - l_11_0) > 10 or math.abs(touchbeginy - l_11_1) > 10) then
      isclick = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_12_0, l_12_1)
    if isclick then
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        upvalue_512 = nil
      end
      if scroll and not tolua.isnull(scroll) then
        local obj = scroll.content_layer
        local p0 = obj:convertToNodeSpace(ccp(l_12_0, l_12_1))
        for ii = 1,  items do
          if items[ii] and items[ii]:boundingBox():containsPoint(p0) and last_selet_item ~= items[ii] then
            audio.play(audio.button)
            local params = {sid = player.sid, grp_id = teams[ii].id}
            tbl2string(params)
            addWaitNet()
            net:gpvp_grp(params, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              if l_1_0.status ~= 0 then
                showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
                return 
              end
              layer:addChild(require("ui.frdarena.teaminfotips").create(l_1_0.grp))
                  end)
            last_selet_item = nil
          end
        end
      end
    end
   end
  local onTouch = function(l_13_0, l_13_1, l_13_2)
    if l_13_0 == "began" then
      return onTouchBegan(l_13_1, l_13_2)
    elseif l_13_0 == "moved" then
      return onTouchMoved(l_13_1, l_13_2)
    else
      return onTouchEnded(l_13_1, l_13_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  layer:setTouchEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  local onEnter = function()
    print("onEnter")
    local params = {sid = player.sid}
    addWaitNet()
    net:gpvp_refresh(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      teams = l_1_0.team
      initData(l_1_0)
      end)
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_17_0)
    if l_17_0 == "enter" then
      onEnter()
    elseif l_17_0 == "exit" then
      onExit()
    end
   end)
  board:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  anim_arr:addObject(CCDelayTime:create(0.15))
  anim_arr:addObject(CCCallFunc:create(function()
    editId:setVisible(true)
   end))
  board:runAction(CCSequence:create(anim_arr))
  return layer
end

return ui

