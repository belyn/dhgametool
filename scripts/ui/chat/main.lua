-- Command line was: E:\github\dhgametool\scripts\ui\chat\main.lua 

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
local cfghero = require("config.hero")
local chatdata = require("data.chat")
local player = require("data.player")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local dialog = require("ui.dialog")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local TAG_EDIT = 3111
local TAB = {WORLD = 1, GUILD = 2, RECRUIT = 3}
local current_tab = TAB.WORLD
local anim_duration = 0.2
local space_height = 3
local qltColor = {1 = ccc3(0, 110, 213), 2 = ccc3(170, 148, 0), 3 = ccc3(158, 63, 225), 4 = ccc3(0, 148, 7), 5 = ccc3(231, 37, 37), 6 = ccc3(254, 120, 0)}
local stamp2str = function(l_1_0)
  return os.date("[%H:%M %m-%d]", l_1_0)
end

local createEdit = function(l_2_0)
  local edit_bg = img.createLogin9Sprite(img.login.input_border)
  local edit_msg = CCEditBox:create(CCSizeMake(508 * view.minScale, 44 * view.minScale), edit_bg)
  edit_msg:setInputFlag(kEditBoxInputFlagInitialCapsSentence)
  edit_msg:setReturnType(kKeyboardReturnTypeDone)
  edit_msg:setMaxLength(140)
  edit_msg:setFont("", 18 * view.minScale)
  edit_msg:setFontColor(ccc3(0, 0, 0))
  edit_msg:setPlaceHolder("")
  edit_msg:setAnchorPoint(CCPoint(0, 0))
  edit_msg:setPosition(scalep(13, 17))
  l_2_0:addChild(edit_msg, 100, TAG_EDIT)
  l_2_0.edit_msg = edit_msg
  autoLayoutShift(edit_msg)
end

local removeEdit = function(l_3_0)
  local obj = l_3_0:getChildByTag(TAG_EDIT)
  if obj then
    l_3_0:removeChildByTag(TAG_EDIT)
    l_3_0.edit_msg = nil
  end
end

local msg_pos = {head = {l = 42, r = 508}, name = {l = 89, r = 461}}
local share_items = {}
local getShareInfo = function(l_4_0, l_4_1)
  local nParams = {sid = player.sid, share_id = l_4_0}
  addWaitNet()
  netClient:cunit(nParams, function(l_1_0)
    delWaitNet()
    tbl2string(l_1_0)
    if l_1_0.status ~= 0 then
      if l_1_0.status == -1 then
        showToast("have been deleted")
      end
      return 
    end
    if callback then
      callback(l_1_0.unit)
    end
   end)
end

local vip_a = {1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4}
vip_a[0] = 1
local vip_c1 = ccc3(255, 209, 121)
local vip_c2 = ccc3(232, 251, 255)
local vip_c3 = ccc3(255, 244, 120)
local vip_c4 = ccc3(138, 248, 255)
local vip_c = {vip_c1, vip_c1, vip_c1, vip_c2, vip_c2, vip_c2, vip_c3, vip_c3, vip_c3, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4}
vip_c[0] = vip_c1
json.load(json.ui.ic_vip)
local createItem = function(l_5_0, l_5_1)
  local item_bg = CCSprite:create()
  local item = CCSprite:create()
  item:setContentSize(CCSizeMake(550, 1))
  local isMe = false
  local anchorX = 0
  if l_5_0.uid == player.uid then
    isMe = true
    anchorX = 1
  end
  local head0 = nil
  if isMe then
    head0 = img.createPlayerHead(l_5_0.logo, l_5_0.lv, true)
  else
    head0 = img.createPlayerHead(l_5_0.logo, l_5_0.lv)
  end
  if l_5_0.final_rank then
    addHeadBox(head0, l_5_0.final_rank, 122)
  end
  local head = SpineMenuItem:create(json.ui.button, head0)
  head:registerScriptTapHandler(function()
    audio.play(audio.button)
    if isMe then
      return 
    end
    msgObj.report = true
    parentObj:addChild(require("ui.tips.player1").create(clone(msgObj)), 100)
   end)
  local name = lbl.create({kind = "ttf", size = 18, text = l_5_0.name, color = ccc3(81, 39, 18)})
  local msg_bg = (img.createUI9Sprite(img.ui.chat_bubble))
  local msg = nil
  if l_5_0.share_id then
    local msg_str = "[ " .. i18n.hero[l_5_0.hero_id].heroName .. " ]"
    msg = lbl.create({kind = "ttf", size = 18, text = msg_str, color = qltColor[cfghero[l_5_0.hero_id].qlt]})
  elseif l_5_0.gid then
    local msg_str = "[ LV." .. l_5_0.glv .. " " .. l_5_0.gname .. " ]" .. l_5_0.gmsg
    msg = lbl.create({kind = "ttf", size = 18, text = msg_str, color = ccc3(112, 74, 43)})
  elseif l_5_0.gFight then
    local msg_str = i18n.global.chat_gFight_desc.string
    msg = lbl.create({kind = "ttf", size = 18, text = msg_str, color = ccc3(112, 74, 43)})
  else
    msg = lbl.create({kind = "ttf", size = 18, text = l_5_0.text or "", color = ccc3(112, 74, 43)})
  end
  local extra_h = 0
  if l_5_0.gid or l_5_0.gFight then
    extra_h = 40
  elseif not l_5_0.share_id then
    extra_h = 0
  end
  msg_bg:addChild(msg)
  local updateMsgSize = function()
    msg:setDimensions(CCSizeMake(0, 0))
    if msg:getContentSize().width > 417 then
      msg:setHorizontalAlignment(kCCTextAlignmentLeft)
      msg:setDimensions(CCSizeMake(417, 0))
      msg_bg:setPreferredSize(CCSizeMake(447, msg:getContentSize().height + 30 + extra_h))
    else
      local width = msg:getContentSize().width + 30
       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    width = op3(extra_h <= 0, width, 200)
    msg_bg:setPreferredSize(CCSizeMake(width, msg:getContentSize().height + 30 + extra_h))
  end
  msg:setAnchorPoint(CCPoint(0.5, 1))
  msg:setPosition(CCPoint(msg_bg:getContentSize().width / 2, msg_bg:getContentSize().height - 15))
   end
  do
    updateMsgSize()
    local time_str = ""
    if l_5_0.time then
      time_str = stamp2str(l_5_0.time)
    end
    local lbl_time = lbl.createFont1(14, time_str, ccc3(130, 79, 39))
    if l_5_0.share_id then
      msg_bg.share_id = l_5_0.share_id
      share_items[#share_items + 1] = msg_bg
      local share_btn0 = CCSprite:create()
      share_btn0:setContentSize(CCSizeMake(msg:getContentSize().width + 30, msg:getContentSize().height + 30))
      local share_btn = CCMenuItemSprite:create(share_btn0, nil)
      share_btn:setPosition(CCPoint(msg_bg:getContentSize().width / 2, msg_bg:getContentSize().height / 2))
      local share_btn_menu = CCMenu:createWithItem(share_btn)
      share_btn_menu:setPosition(CCPoint(0, 0))
      msg_bg:addChild(share_btn_menu)
      share_btn:registerScriptTapHandler(function()
        audio.play(audio.button)
        getShareInfo(msgObj.share_id, function(l_1_0)
          parentObj:addChild(require("ui.tips.hero").create(l_1_0), 1000)
            end)
         end)
    elseif l_5_0.gid then
      local lbl_invite = lbl.createMixFont1(10, i18n.global.chat_btn_join.string, ccc3(27, 89, 2))
      local btn_invite0 = img.createLogin9Sprite(img.login.button_9_small_green)
      btn_invite0:setContentSize(CCSizeMake(150, 40))
      lbl_invite:setPosition(CCPoint(btn_invite0:getContentSize().width / 2, btn_invite0:getContentSize().height / 2 + 1))
      btn_invite0:addChild(lbl_invite)
      local btn_invite = SpineMenuItem:create(json.ui.button, btn_invite0)
      btn_invite:setPosition(CCPoint(msg_bg:getContentSize().width / 2, 30))
      local btn_invite_menu = CCMenu:createWithItem(btn_invite)
      btn_invite_menu:setPosition(CCPoint(0, 0))
      msg_bg:addChild(btn_invite_menu)
      btn_invite:registerScriptTapHandler(function()
        disableObjAWhile(btn_invite)
        audio.play(audio.button)
        if player.gid and player.gid > 0 then
          showToast(i18n.global.guild_accepted_u.string)
          return 
        end
        if player.lv() < UNLOCK_GUILD_LEVEL then
          showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_GUILD_LEVEL))
          return 
        end
        parentObj:addChild(require("ui.guild.search").create({word = msgObj.gid}), 1000)
         end)
    elseif l_5_0.gFight then
      local lbl_invite = lbl.createMixFont1(10, i18n.global.chat_btn_gFight.string, ccc3(27, 89, 2))
      local btn_invite0 = img.createLogin9Sprite(img.login.button_9_small_green)
      btn_invite0:setContentSize(CCSizeMake(150, 40))
      lbl_invite:setPosition(CCPoint(btn_invite0:getContentSize().width / 2, btn_invite0:getContentSize().height / 2 + 1))
      btn_invite0:addChild(lbl_invite)
      local btn_invite = SpineMenuItem:create(json.ui.button, btn_invite0)
      btn_invite:setPosition(CCPoint(msg_bg:getContentSize().width / 2, 30))
      local btn_invite_menu = CCMenu:createWithItem(btn_invite)
      btn_invite_menu:setPosition(CCPoint(0, 0))
      msg_bg:addChild(btn_invite_menu)
      btn_invite:registerScriptTapHandler(function()
        disableObjAWhile(btn_invite)
        audio.play(audio.button)
        local gdata = require("data.guild")
        if player.gid and player.gid > 0 and not gdata.IsInit() then
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
            replaceScene(require("ui.guildVice.main").create({from_layer = "gwar"}))
               end)
        else
          if player.gid and player.gid > 0 and gdata.IsInit() then
            replaceScene(require("ui.guildVice.main").create({from_layer = "gwar"}))
        end
         end)
    else
      local btn_trans0 = img.createUISprite(img.ui.chat_btn_trans)
      local btn_trans = SpineMenuItem:create(json.ui.button, btn_trans0)
      btn_trans:registerScriptTapHandler(function()
        audio.play(audio.button)
        if msg.state == "transing" then
          showToast(i18n.global.chat_translating.string)
          return 
        else
          if msg.state == "transed" then
            local oH = msg:getContentSize().height
            msg:setString(msgObj.text)
            updateMsgSize()
            local nH = msg:getContentSize().height
            msg.state = nil
            local pscroll = parentObj.msg_container.scroll
            pscroll.validUI(item_bg, nH - oH)
          else
            msg.state = "transing"
            local tparams = {sid = player.sid, sentence = string.urlencode(msg:getString()), target = getTargetLgg()}
            netClient:translate(tparams, function(l_1_0)
              tbl2string(l_1_0)
              if l_1_0.status == 0 and btn_trans and not tolua.isnull(btn_trans) then
                local oH = msg:getContentSize().height
                msg:setString(l_1_0.sentence or "")
                updateMsgSize()
                local nH = msg:getContentSize().height
                msg.state = "transed"
                do
                  local pscroll = parentObj.msg_container.scroll
                  pscroll.validUI(item_bg, nH - oH)
                end
                do return end
                msg.state = nil
              end
                  end)
          end
        end
         end)
      local arrow = img.createUISprite(img.ui.chat_bubble_arrow)
      local icon_vip = DHSkeletonAnimation:createWithKey(json.ui.ic_vip)
      icon_vip:setScale(0.7)
      icon_vip:scheduleUpdateLua()
      if l_5_0.vip then
        icon_vip:playAnimation("" .. vip_a[l_5_0.vip], -1)
        local lbl_player_vip = lbl.createFont2(18, l_5_0.vip, ccc3(255, 220, 130))
        lbl_player_vip:setColor(vip_c[l_5_0.vip])
        icon_vip:addChildFollowSlot("code_num", lbl_player_vip)
      end
      if isMe then
        name:setAnchorPoint(CCPoint(1, 1))
        msg_bg:setAnchorPoint(CCPoint(1, 1))
        lbl_time:setAnchorPoint(CCPoint(0, 1))
        head:setPosition(CCPoint(508, -47))
        name:setPosition(CCPoint(455, -8))
        msg_bg:setPosition(CCPoint(455, -37))
        lbl_time:setPosition(CCPoint(8, -8))
        icon_vip:setPosition(CCPoint(name:boundingBox():getMinX() - 30, -20))
        arrow:setFlipX(true)
        arrow:setAnchorPoint(CCPoint(0, 1))
        arrow:setPosition(CCPoint(msg_bg:getContentSize().width - 2, msg_bg:getContentSize().height - 14))
        msg_bg:addChild(arrow)
      else
        name:setAnchorPoint(CCPoint(0, 1))
        msg_bg:setAnchorPoint(CCPoint(0, 1))
        lbl_time:setAnchorPoint(CCPoint(1, 1))
        head:setPosition(CCPoint(42, -47))
        name:setPosition(CCPoint(95, -8))
        msg_bg:setPosition(CCPoint(95, -37))
        lbl_time:setPosition(CCPoint(542, -8))
        icon_vip:setPosition(CCPoint(name:boundingBox():getMaxX() + 30, -20))
        arrow:setAnchorPoint(CCPoint(1, 1))
        arrow:setPosition(CCPoint(2, msg_bg:getContentSize().height - 14))
        msg_bg:addChild(arrow)
      end
      local head_menu = CCMenu:createWithItem(head)
      head_menu:setPosition(CCPoint(0, 0))
      item:addChild(head_menu)
      item:addChild(name)
      item:addChild(icon_vip)
      item:addChild(msg_bg)
      item:addChild(lbl_time)
      item.height = 37 + msg_bg:getContentSize().height + 10
      if l_5_0.vip and l_5_0.vip > 0 then
        icon_vip:setVisible(true)
        btn_trans:setPosition(CCPoint(icon_vip:boundingBox():getMaxX() + 42, icon_vip:boundingBox():getMidY()))
      else
        icon_vip:setVisible(false)
        btn_trans:setPosition(CCPoint(name:boundingBox():getMaxX() + 22, name:boundingBox():getMidY()))
      end
      if l_5_0.share_id or l_5_0.gFight or l_5_0.gid or isMe then
        btn_trans:setVisible(false)
      elseif APP_CHANNEL and APP_CHANNEL ~= "" then
        btn_trans:setVisible(false)
      else
        btn_trans:setVisible(true)
      end
      local btn_trans_menu = CCMenu:createWithItem(btn_trans)
      btn_trans_menu:setPosition(CCPoint(0, 0))
      item:addChild(btn_trans_menu)
      item_bg:setContentSize(CCSizeMake(550, item.height))
      item:setAnchorPoint(CCPoint(0, 1))
      item:setPosition(CCPoint(0, item.height))
      item_bg:addChild(item)
      item_bg.height = item.height
      return item_bg
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.create = function(l_6_0)
  local layer = CCLayer:create()
  local board = img.createUI9Sprite(img.ui.chat_board)
  board:setPreferredSize(CCSizeMake(602, 576))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(-630, 0))
  layer:addChild(board)
  autoLayoutShift(board)
  local fix_bg = img.createUI9Sprite(img.ui.chat_board)
  fix_bg:setPreferredSize(CCSizeMake(200, 576))
  fix_bg:setAnchorPoint(CCPoint(1, 0))
  fix_bg:setPosition(CCPoint(0, 0))
  board:addChild(fix_bg)
  local arr_anim = CCArray:create()
  arr_anim:addObject(CCCallFunc:create(function()
    board:runAction(CCMoveTo:create(anim_duration, getAutoLayoutShiftPos(board, scalep(0, 0))))
   end))
  arr_anim:addObject(CCDelayTime:create(anim_duration))
  arr_anim:addObject(CCCallFunc:create(function()
    createEdit(layer)
   end))
  layer:runAction(CCSequence:create(arr_anim))
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local btn_close0 = img.createUISprite(img.ui.chat_btn_close)
  local btn_close = HHMenuItem:createWithScale(btn_close0, 1)
  btn_close:setAnchorPoint(CCPoint(0, 0.5))
  btn_close:setPosition(CCPoint(board_w - 4, board_h / 2))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_close_menu)
  local backEvent = function()
    audio.play(audio.button)
    local arr = CCArray:create()
    arr:addObject(CCCallFunc:create(function()
      removeEdit(layer)
      end))
    arr:addObject(CCMoveTo:create(anim_duration, getAutoLayoutShiftPos(board, scalep(-630, 0))))
    arr:addObject(CCDelayTime:create(anim_duration))
    arr:addObject(CCCallFunc:create(function()
      layer:removeFromParentAndCleanup(true)
      end))
    board:runAction(CCSequence:create(arr))
   end
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local btn_send0 = img.createUISprite(img.ui.chat_btn_send)
  local btn_send = SpineMenuItem:create(json.ui.button, btn_send0)
  btn_send:setPosition(CCPoint(board_w - 44, 37))
  local btn_send_menu = CCMenu:createWithItem(btn_send)
  btn_send_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_send_menu)
  local tab_world0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
  local tab_guild0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
  local tab_recruit0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
  local tab_world_hl = img.createLogin9Sprite(img.login.button_9_small_gold)
  local tab_guild_hl = img.createLogin9Sprite(img.login.button_9_small_gold)
  local tab_recruit_hl = img.createLogin9Sprite(img.login.button_9_small_gold)
  tab_world0:setPreferredSize(CCSizeMake(164, 47))
  tab_guild0:setPreferredSize(CCSizeMake(164, 47))
  tab_recruit0:setPreferredSize(CCSizeMake(164, 47))
  tab_world_hl:setPreferredSize(CCSizeMake(164, 47))
  tab_guild_hl:setPreferredSize(CCSizeMake(164, 47))
  tab_recruit_hl:setPreferredSize(CCSizeMake(164, 47))
  addRedDot(tab_world0, {px = tab_world0:getContentSize().width - 5, py = tab_world0:getContentSize().height - 5})
  delRedDot(tab_world0)
  addRedDot(tab_guild0, {px = tab_guild0:getContentSize().width - 5, py = tab_guild0:getContentSize().height - 5})
  delRedDot(tab_guild0)
  addRedDot(tab_recruit0, {px = tab_recruit0:getContentSize().width - 5, py = tab_recruit0:getContentSize().height - 5})
  delRedDot(tab_recruit0)
  tab_world_hl:setPosition(CCPoint(tab_world0:getContentSize().width / 2, tab_world0:getContentSize().height / 2))
  tab_world0:addChild(tab_world_hl)
  local lbl_tab_world = lbl.createFont1(20, i18n.global.chat_tab_world.string, ccc3(115, 59, 5))
  lbl_tab_world:setPosition(CCPoint(tab_world0:getContentSize().width / 2, tab_world0:getContentSize().height / 2))
  tab_world0:addChild(lbl_tab_world)
  tab_guild_hl:setPosition(CCPoint(tab_guild0:getContentSize().width / 2, tab_guild0:getContentSize().height / 2))
  tab_guild0:addChild(tab_guild_hl)
  local lbl_tab_guild = lbl.createFont1(20, i18n.global.chat_tab_guild.string, ccc3(115, 59, 5))
  lbl_tab_guild:setPosition(CCPoint(tab_guild0:getContentSize().width / 2, tab_guild0:getContentSize().height / 2))
  tab_guild0:addChild(lbl_tab_guild)
  tab_recruit_hl:setPosition(CCPoint(tab_recruit0:getContentSize().width / 2, tab_recruit0:getContentSize().height / 2))
  tab_recruit0:addChild(tab_recruit_hl)
  local lbl_tab_recruit = lbl.createFont1(20, i18n.global.chat_tab_recruit.string, ccc3(115, 59, 5))
  lbl_tab_recruit:setPosition(CCPoint(tab_recruit0:getContentSize().width / 2, tab_recruit0:getContentSize().height / 2))
  tab_recruit0:addChild(lbl_tab_recruit)
  local tab_world = SpineMenuItem:create(json.ui.button, tab_world0)
  tab_world:setPosition(CCPoint(93, 543))
  local tab_world_menu = CCMenu:createWithItem(tab_world)
  tab_world_menu:setPosition(CCPoint(0, 0))
  board:addChild(tab_world_menu, 1)
  local tab_guild = SpineMenuItem:create(json.ui.button, tab_guild0)
  tab_guild:setPosition(CCPoint(265, 543))
  local tab_guild_menu = CCMenu:createWithItem(tab_guild)
  tab_guild_menu:setPosition(CCPoint(0, 0))
  board:addChild(tab_guild_menu, 1)
  local tab_recruit = SpineMenuItem:create(json.ui.button, tab_recruit0)
  tab_recruit:setPosition(CCPoint(437, 543))
  local tab_recruit_menu = CCMenu:createWithItem(tab_recruit)
  tab_recruit_menu:setPosition(CCPoint(0, 0))
  board:addChild(tab_recruit_menu, 1)
  local btn_setting0 = img.createUISprite(img.ui.guild_icon_admin)
  local btn_setting = SpineMenuItem:create(json.ui.button, btn_setting0)
  btn_setting:setPosition(CCPoint(board_w - 33, 543))
  local btn_setting_menu = CCMenu:createWithItem(btn_setting)
  btn_setting_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_setting_menu)
  btn_setting:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.chat.setting").create(), 1000)
   end)
  local content_bg = img.createUI9Sprite(img.ui.chat_bg)
  content_bg:setPreferredSize(CCSizeMake(576, 439))
  content_bg:setAnchorPoint(CCPoint(0, 0))
  content_bg:setPosition(CCPoint(12, 74))
  board:addChild(content_bg)
  local content_bg_w = content_bg:getContentSize().width
  local content_bg_h = content_bg:getContentSize().height
  local msg_container = CCSprite:create()
  msg_container:setContentSize(CCSizeMake(576, 439))
  msg_container:setAnchorPoint(CCPoint(0, 0))
  msg_container:setPosition(CCPoint(0, 0))
  content_bg:addChild(msg_container)
  layer.msg_container = msg_container
  local msg_container_w = msg_container:getContentSize().width
  local msg_container_h = msg_container:getContentSize().height
  local createScroll = function()
    local scroll_params = {width = 550, height = 428}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local showList = function(l_7_0)
    arrayclear(share_items)
    share_items = {}
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(13, 6))
    msg_container:addChild(scroll)
    msg_container.scroll = scroll
    for ii = 1, #l_7_0 do
      local tmp_item = createItem(l_7_0[ii], layer)
      tmp_item.msgObj = l_7_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = 275
      scroll.addItem(tmp_item)
      if ii ~= #l_7_0 then
        scroll.addSpace(space_height)
      end
    end
    scroll.setOffsetEnd()
   end
  local showWorldChat = function()
    local msg_list = chatdata.getWorldMsg()
    showList(msg_list)
   end
  local showGuildChat = function()
    local msg_list = chatdata.getGuildMsg()
    showList(msg_list)
   end
  local showRecruitChat = function()
    local msg_list = chatdata.getRecruitMsg()
    showList(msg_list)
   end
  local tabs = {}
  tabs[TAB.WORLD] = {btn = tab_world, hl = tab_world_hl}
  tabs[TAB.GUILD] = {btn = tab_guild, hl = tab_guild_hl}
  tabs[TAB.RECRUIT] = {btn = tab_recruit, hl = tab_recruit_hl}
  local onTabSel = function(l_11_0)
    msg_container:removeAllChildrenWithCleanup(true)
    msg_container.scroll = nil
    for _,_obj in ipairs(tabs) do
      _obj.btn:setEnabled(true)
      _obj.hl:setVisible(false)
    end
    upvalue_1024 = l_11_0
    if l_11_0 == TAB.WORLD then
      tabs[TAB.WORLD].btn:setEnabled(false)
      tabs[TAB.WORLD].hl:setVisible(true)
      showWorldChat()
      if layer.edit_msg then
        layer.edit_msg:setVisible(true)
        btn_send:setVisible(true)
        content_bg:setPreferredSize(CCSizeMake(576, 439))
        content_bg:setPosition(CCPoint(12, 74))
        msg_container.scroll:setViewSize(CCSize(550, 428))
      else
        if l_11_0 == TAB.GUILD then
          tabs[TAB.GUILD].btn:setEnabled(false)
          tabs[TAB.GUILD].hl:setVisible(true)
          showGuildChat()
          if layer.edit_msg then
            layer.edit_msg:setVisible(true)
            btn_send:setVisible(true)
            content_bg:setPreferredSize(CCSizeMake(576, 439))
            content_bg:setPosition(CCPoint(12, 74))
            msg_container.scroll:setViewSize(CCSize(550, 428))
          else
            if l_11_0 == TAB.RECRUIT then
              tabs[TAB.RECRUIT].btn:setEnabled(false)
              tabs[TAB.RECRUIT].hl:setVisible(true)
              showRecruitChat()
            end
          end
        end
      end
    end
   end
  onTabSel(current_tab)
  tab_world:registerScriptTapHandler(function()
    audio.play(audio.button)
    onTabSel(TAB.WORLD)
   end)
  local gotoGuild = function()
    local process_dialog = function(l_1_0)
      layer:removeChildByTag(dialog.TAG)
      if l_1_0.selected_btn == 2 then
        layer:addChild(require("ui.guild.recommend").create(true), 10000)
      elseif l_1_0.selected_btn == 1 then
        layer:addChild(require("ui.guild.create").create(true), 10000)
      end
      end
    local dParams = {title = "", body = i18n.global.goto_guild_body.string, btn_count = 2, btn_color = {1 = dialog.COLOR_GOLD, 2 = dialog.COLOR_GOLD}, btn_text = {1 = i18n.global.goto_guild_create.string, 2 = i18n.global.goto_guild_join.string}, callback = process_dialog}
    local dialog_ins = dialog.create(dParams, true)
    dialog_ins:setAnchorPoint(CCPoint(0, 0))
    dialog_ins:setPosition(CCPoint(0, 0))
    layer:addChild(dialog_ins, 10000, dialog.TAG)
   end
  tab_guild:registerScriptTapHandler(function()
    audio.play(audio.button)
    if player.lv() < UNLOCK_GUILD_LEVEL then
      showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_GUILD_LEVEL))
      return 
    end
    if player.gid <= 0 then
      gotoGuild()
      return 
    end
    onTabSel(TAB.GUILD)
   end)
  tab_recruit:registerScriptTapHandler(function()
    audio.play(audio.button)
    onTabSel(TAB.RECRUIT)
   end)
  btn_send:registerScriptTapHandler(function()
    audio.play(audio.button)
    if not layer.edit_msg or tolua.isnull(layer.edit_msg) then
      return 
    end
    local msg_type = nil
    if current_tab == TAB.WORLD then
      if player.lv() < 15 then
        showToast(string.format(i18n.global.func_need_lv.string, 15))
        return 
      end
      if chatdata.last_world_sent and os.time() - chatdata.last_world_sent < 30 then
        showToast(string.format(i18n.global.chat_interval.string, 30 - (os.time() - chatdata.last_world_sent)))
        return 
      end
      msg_type = 1
    else
      if current_tab == TAB.GUILD then
        msg_type = 2
        if not player.gid or player.gid <= 0 then
          showToast(i18n.global.chat_toast_need_guild.string)
          return 
        else
          if current_tab == TAB.RECRUIT then
            msg_type = 3
          end
        end
      end
    end
    local sendStr = layer.edit_msg:getText()
    sendStr = string.trim(sendStr)
    if isBanWord(sendStr) then
      showToast(i18n.global.chat_send_failed1.string)
      return 
    end
    if sendStr == "" then
      showToast(i18n.global.chat_toast_empty_msg.string)
      return 
    end
    if containsInvalidChar(sendStr) then
      showToast(i18n.global.input_invalid_char.string)
      return 
    end
    local send_params = {sid = player.sid, type = msg_type, text = sendStr}
    chatdata.send(send_params, function(l_1_0)
      if l_1_0 and l_1_0.status and l_1_0.status ~= 0 then
        if l_1_0.status == -10 then
          showToast(i18n.global.chat_send_failed1.string)
          return 
        end
        if l_1_0.status == -11 then
          showToast(i18n.global.chat_send_failed3.string)
          return 
        end
        if l_1_0.status == -12 then
          showToast(i18n.global.chat_send_failed2.string)
          return 
        end
      end
      end)
    layer.edit_msg:setText("")
    if current_tab == TAB.WORLD then
      chatdata.last_world_sent = os.time()
    end
   end)
  local onUpdate = function(l_17_0)
    if current_tab == TAB.WORLD then
      local tmp_world_msg = chatdata.fetchWorldMsg()
      local scrollObj = msg_container.scroll
      if not scrollObj or tolua.isnull(scrollObj) then
        return 
      end
      if tmp_world_msg then
        scrollObj.addSpace(space_height)
        local tmp_item = createItem(tmp_world_msg, layer)
        scrollObj.addItem(tmp_item)
        scrollObj.updateOffsetEnd()
      else
        if current_tab == TAB.GUILD then
          local tmp_guild_msg = chatdata.fetchGuildMsg()
          local scrollObj = msg_container.scroll
          if not scrollObj or tolua.isnull(scrollObj) then
            return 
          end
          if tmp_guild_msg then
            scrollObj.addSpace(space_height)
            local tmp_item = createItem(tmp_guild_msg, layer)
            scrollObj.addItem(tmp_item)
            scrollObj.updateOffsetEnd()
          else
            if current_tab == TAB.RECRUIT then
              local tmp_recruit_msg = chatdata.fetchRecruitMsg()
              local scrollObj = msg_container.scroll
              if not scrollObj or tolua.isnull(scrollObj) then
                return 
              end
              if layer.edit_msg then
                layer.edit_msg:setVisible(false)
                btn_send:setVisible(false)
                content_bg:setPreferredSize(CCSizeMake(576, 499))
                content_bg:setPosition(CCPoint(12, 14))
                scrollObj:setViewSize(CCSize(550, 488))
              end
              if tmp_recruit_msg then
                scrollObj.addSpace(space_height)
                local tmp_item = createItem(tmp_recruit_msg, layer)
                scrollObj.addItem(tmp_item)
                scrollObj.updateOffsetEnd()
              end
            end
          end
        end
      end
    end
    local chatdata = require("data.chat")
    if chatdata.showRedDotForWorld() then
      addRedDot(tab_world0, {px = tab_world0:getContentSize().width - 5, py = tab_world0:getContentSize().height - 5})
    else
      delRedDot(tab_world0)
    end
    local chatdata = require("data.chat")
    if chatdata.showRedDotForGuild() then
      addRedDot(tab_guild0, {px = tab_guild0:getContentSize().width - 5, py = tab_guild0:getContentSize().height - 5})
    else
      delRedDot(tab_guild0)
    end
    local chatdata = require("data.chat")
    if chatdata.showRedDotForRecruit() then
      addRedDot(tab_recruit0, {px = tab_recruit0:getContentSize().width - 5, py = tab_recruit0:getContentSize().height - 5})
    else
      delRedDot(tab_recruit0)
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  local touchbeginx, touchbeginy, isclick = nil, nil, nil
  local onTouchBegan = function(l_18_0, l_18_1)
    touchbeginx, upvalue_512 = l_18_0, l_18_1
    upvalue_1024 = true
    return true
   end
  local onTouchMoved = function(l_19_0, l_19_1)
    if isclick and (math.abs(touchbeginx - l_19_0) > 10 or math.abs(touchbeginy - l_19_1) > 10) then
      isclick = false
    end
   end
  local onTouchEnded = function(l_20_0, l_20_1)
    local p0 = layer:convertToNodeSpace(ccp(l_20_0, l_20_1))
    if isclick and not board:boundingBox():containsPoint(p0) then
      backEvent()
    end
   end
  local onTouch = function(l_21_0, l_21_1, l_21_2)
    if l_21_0 == "began" then
      return onTouchBegan(l_21_1, l_21_2)
    elseif l_21_0 == "moved" then
      return onTouchMoved(l_21_1, l_21_2)
    else
      return onTouchEnded(l_21_1, l_21_2)
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
  layer:registerScriptHandler(function(l_25_0)
    if l_25_0 == "enter" then
      onEnter()
    elseif l_25_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

