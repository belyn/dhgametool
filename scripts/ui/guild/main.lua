-- Command line was: E:\github\dhgametool\scripts\ui\guild\main.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local i18n = require("res.i18n")
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
local rewards = require("ui.reward")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local enter_duration = 0.2
local opacity_start = 76.5
local space_height = 1
local alreadyJoinedFight = function()
  audio.play(audio.button)
  showToast(i18n.global.guild_mem_joined_fight.string)
end

ui.create = function(l_2_0)
  local layer = CCLayer:create()
  local bg = img.createUISprite(img.ui.bag_bg)
  bg:setScale(view.minScale)
  bg:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(bg)
  local board = CCNode:create()
  board:setAnchorPoint(ccp(0.5, 0.5))
  board:setContentSize(CCSize(960, 576))
  board:setScale(view.minScale)
  board:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local bg = img.createUI9Sprite(img.ui.dialog_2)
  bg:setPreferredSize(CCSizeMake(574, 553))
  bg:setAnchorPoint(CCPoint(0, 0.5))
  bg:setPosition(CCPoint(672, 285))
  board:addChild(bg)
  local bg_w = bg:getContentSize().width
  local bg_h = bg:getContentSize().height
  local info_bg = img.createUISprite(img.ui.guild_info_bg)
  info_bg:setAnchorPoint(CCPoint(0, 1))
  info_bg:setPosition(CCPoint(-270.9, 560))
  board:addChild(info_bg)
  local info_bg_w = info_bg:getContentSize().width
  local info_bg_h = info_bg:getContentSize().height
  local area_bg = img.createUI9Sprite(img.ui.guild_token_bg)
  area_bg:setPreferredSize(CCSizeMake(312, 125))
  addRedDot(area_bg, {px = area_bg:getContentSize().width - 13, py = area_bg:getContentSize().height - 13})
  delRedDot(area_bg)
  local btn_building0 = img.createUISprite(img.ui.guild_token_area)
  btn_building0:setPosition(CCPoint(70, 63))
  area_bg:addChild(btn_building0)
  local lbl_building_name = lbl.createFont2(20, i18n.global.guild_area.string, ccc3(255, 246, 223))
  lbl_building_name:setPosition(CCPoint(203, 63))
  area_bg:addChild(lbl_building_name)
  json.load(json.ui.gh_chengbao_fx)
  local cb_ani = DHSkeletonAnimation:createWithKey(json.ui.gh_chengbao_fx)
  cb_ani:scheduleUpdateLua()
  cb_ani:playAnimation("animation", -1)
  cb_ani:setPosition(CCPoint(54, 30))
  btn_building0:addChild(cb_ani)
  local btn_area = SpineMenuItem:create(json.ui.button, area_bg)
  btn_area:setPosition(CCPoint(-147, 77))
  local btn_area_menu = CCMenu:createWithItem(btn_area)
  btn_area_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_area_menu)
  btn_area:registerScriptTapHandler(function()
    audio.play(audio.button)
    replaceScene(require("ui.guildVice.main").create())
   end)
  local btn_help0 = img.createUISprite(img.ui.btn_help)
  local btn_help = SpineMenuItem:create(json.ui.button, btn_help0)
  btn_help:setPosition(CCPoint(board_w - 25, board_h - 26))
  local btn_help_menu = CCMenu:createWithItem(btn_help)
  btn_help_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_help_menu, 100)
  btn_help:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.help").create(i18n.global.help_guild.string), 1000)
   end)
  autoLayoutShift(btn_help)
  local enter_ani = CCArray:create()
  enter_ani:addObject(CCCallFunc:create(function()
    bg:setCascadeOpacityEnabled(true)
    info_bg:setCascadeOpacityEnabled(true)
    btn_area:setCascadeOpacityEnabled(true)
    bg:setOpacity(opacity_start)
    info_bg:setOpacity(opacity_start)
    btn_area:setOpacity(opacity_start)
    bg:runAction(CCMoveTo:create(enter_duration, CCPoint(366, 285)))
    info_bg:runAction(CCMoveTo:create(enter_duration, CCPoint(14, 560)))
    btn_area:runAction(CCMoveTo:create(enter_duration, CCPoint(210, 77)))
    bg:runAction(CCFadeTo:create(enter_duration, 255))
    info_bg:runAction(CCFadeTo:create(enter_duration, 255))
    btn_area:runAction(CCFadeTo:create(enter_duration, 255))
   end))
  layer:runAction(CCSequence:create(enter_ani))
  local backEvent = function()
    audio.play(audio.button)
    if uiParams and uiParams.from_layer == "task" then
      replaceScene(require("ui.town.main").create({from_layer = "task"}))
    else
      replaceScene(require("ui.town.main").create())
    end
   end
  local back0 = img.createUISprite(img.ui.back)
  local backBtn = HHMenuItem:create(back0)
  backBtn:setScale(view.minScale)
  backBtn:setPosition(scalep(35, 546))
  local backMenu = CCMenu:createWithItem(backBtn)
  backMenu:setPosition(0, 0)
  layer:addChild(backMenu, 100)
  backBtn:registerScriptTapHandler(function()
    backEvent()
   end)
  autoLayoutShift(backBtn)
  local lbl_guild = lbl.createFont1(22, i18n.global.guild_main_title.string, ccc3(250, 216, 104))
  lbl_guild:setPosition(CCPoint(info_bg:getContentSize().width / 2, info_bg_h - 28))
  info_bg:addChild(lbl_guild)
  local offset_x = 2
  local offset_y = 10
  local mem_board = img.createUI9Sprite(img.ui.guild_mem_bg)
  mem_board:setPreferredSize(CCSizeMake(542, 438))
  mem_board:setAnchorPoint(CCPoint(0.5, 0))
  mem_board:setPosition(CCPoint(bg_w / 2, 97))
  bg:addChild(mem_board)
  local mem_board_w = mem_board:getContentSize().width
  local mem_board_h = mem_board:getContentSize().height
  local btn_flag0 = CCSprite:create()
  btn_flag0:setContentSize(CCSizeMake(70, offset_y + 73))
  local btn_flag = HHMenuItem:create(btn_flag0)
  btn_flag:setPosition(CCPoint(offset_x + 83, 311))
  btn_flag:setEnabled(false)
  local btn_flag_menu = CCMenu:createWithItem(btn_flag)
  btn_flag_menu:setPosition(CCPoint(0, 0))
  info_bg:addChild(btn_flag_menu)
  local updateFlag = function()
    if btn_flag.flag_id == gdata.guildObj.logo then
      return 
    end
    if btn_flag.flag and not tolua.isnull(btn_flag.flag) then
      btn_flag.flag:removeFromParentAndCleanup(true)
    end
    local guild_flag = img.createGFlag(gdata.guildObj.logo)
    guild_flag:setAnchorPoint(CCPoint(0, 0))
    guild_flag:setPosition(CCPoint(0, 0))
    btn_flag:addChild(guild_flag)
    btn_flag.flag = guild_flag
    btn_flag.flag_id = gdata.guildObj.logo
   end
  updateFlag()
  local lbl_name = lbl.createFontTTF(18, gdata.guildObj.name, ccc3(255, 239, 215))
  lbl_name:setAnchorPoint(CCPoint(0, 0.5))
  lbl_name:setPosition(CCPoint(offset_x + 132, offset_y + 323))
  info_bg:addChild(lbl_name)
  lbl_name.name = gdata.guildObj.name
  local lbl_ID = lbl.createFont1(16, "ID   " .. gdata.guildObj.id, ccc3(255, 239, 215))
  lbl_ID:setAnchorPoint(CCPoint(0, 0.5))
  lbl_ID:setPosition(CCPoint(offset_x + 132, offset_y + 297))
  info_bg:addChild(lbl_ID)
  local icon_mem = img.createUISprite(img.ui.guild_icon_mem2)
  icon_mem:setPosition(CCPoint(offset_x + 140, offset_y + 271))
  info_bg:addChild(icon_mem)
  local lbl_mem = lbl.createFont1(16, gdata.guildObj.members .. "/" .. gdata.maxMember(gdata.guildObj.exp), ccc3(255, 239, 215))
  lbl_mem:setAnchorPoint(CCPoint(0, 0.5))
  lbl_mem:setPosition(CCPoint(offset_x + 157, offset_y + 270))
  info_bg:addChild(lbl_mem)
  local btn_mem0 = img.createUISprite(img.ui.guild_icon_admin)
  local btn_mem = SpineMenuItem:create(json.ui.button, btn_mem0)
  btn_mem:setPosition(CCPoint(offset_x + 310, 330))
  local btn_mem_menu = CCMenu:createWithItem(btn_mem)
  btn_mem_menu:setPosition(CCPoint(0, 0))
  info_bg:addChild(btn_mem_menu)
  btn_mem:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.guild.modify").create(), 100)
   end)
  btn_mem:setVisible(gdata.TITLE.RESIDENT < gdata.selfTitle())
  local btn_mail0 = img.createUISprite(img.ui.guild_icon_mail)
  local btn_mail = SpineMenuItem:create(json.ui.button, btn_mail0)
  btn_mail:setPosition(CCPoint(offset_x + 310, 283))
  local btn_mail_menu = CCMenu:createWithItem(btn_mail)
  btn_mail_menu:setPosition(CCPoint(0, 0))
  info_bg:addChild(btn_mail_menu)
  btn_mail:registerScriptTapHandler(function()
    audio.play(audio.button)
    local maillayer = require("ui.mail.main")
    local mParams = {tab = maillayer.TAB.NEW, sendto = "@all", close = true}
    layer:addChild(maillayer.create(mParams), 100)
   end)
  btn_mail:setVisible(false)
  local lbl_lv = lbl.createFont1(16, "Lv." .. gdata.Lv(), ccc3(255, 239, 215))
  lbl_lv:setAnchorPoint(CCPoint(0, 0.5))
  lbl_lv:setPosition(CCPoint(offset_x + 62, offset_y + 234))
  info_bg:addChild(lbl_lv)
  local pgb_bg = img.createUI9Sprite(img.ui.hero_progress_bg)
  pgb_bg:setPreferredSize(CCSizeMake(205, 20))
  pgb_bg:setAnchorPoint(CCPoint(0, 0.5))
  pgb_bg:setPosition(CCPoint(offset_x + 125, offset_y + 234))
  info_bg:addChild(pgb_bg)
  local pgb_fg = img.createUISprite(img.ui.guild_exp_pgb_fg)
  local pgb = createProgressBar(pgb_fg)
  pgb:setPosition(CCPoint(pgb_bg:getContentSize().width / 2, pgb_bg:getContentSize().height / 2))
  pgb_bg:addChild(pgb)
  local expPercent = function()
    pgb:setPercentage(gdata.curLvExp() * 100 / gdata.upLvExp())
   end
  expPercent()
  local btn_rank0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_rank0:setPreferredSize(CCSizeMake(88, 56))
  local icon_rank = img.createUISprite(img.ui.guild_icon_mail2)
  icon_rank:setPosition(CCPoint(44, 28))
  btn_rank0:addChild(icon_rank)
  local btn_rank = SpineMenuItem:create(json.ui.button, btn_rank0)
  btn_rank:setPosition(CCPoint(offset_x + 93, offset_y + 178))
  local btn_rank_menu = CCMenu:createWithItem(btn_rank)
  btn_rank_menu:setPosition(CCPoint(0, 0))
  info_bg:addChild(btn_rank_menu)
  btn_rank:registerScriptTapHandler(function()
    audio.play(audio.button)
    if gdata.selfTitle() <= gdata.TITLE.RESIDENT then
      showToast(i18n.global.permission_denied.string)
      return 
    end
    local maillayer = require("ui.mail.main")
    local mParams = {tab = maillayer.TAB.NEW, sendto = "@all", close = true}
    layer:addChild(maillayer.create(mParams), 100)
   end)
  local btn_log0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_log0:setPreferredSize(CCSizeMake(88, 56))
  local icon_log = img.createUISprite(img.ui.guild_icon_log)
  icon_log:setPosition(CCPoint(44, 28))
  btn_log0:addChild(icon_log)
  local btn_log = SpineMenuItem:create(json.ui.button, btn_log0)
  btn_log:setPosition(CCPoint(offset_x + 193, offset_y + 178))
  local btn_log_menu = CCMenu:createWithItem(btn_log)
  btn_log_menu:setPosition(CCPoint(0, 0))
  info_bg:addChild(btn_log_menu)
  btn_log:registerScriptTapHandler(function()
    audio.play(audio.button)
    local gParams = {sid = player.sid}
    addWaitNet()
    netClient:glog(gParams, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      layer:addChild(require("ui.guild.log").create(l_1_0.logs), 100)
      end)
   end)
  local btn_sign0 = img.createLogin9Sprite(img.login.button_9_small_green)
  btn_sign0:setPreferredSize(CCSizeMake(88, 56))
  addRedDot(btn_sign0, {px = btn_sign0:getContentSize().width - 2, py = btn_sign0:getContentSize().height - 2})
  local icon_sign = img.createUISprite(img.ui.guild_icon_sign)
  icon_sign:setPosition(CCPoint(44, 28))
  btn_sign0:addChild(icon_sign)
  local lbl_sign_cd = lbl.createFont2(16, "", ccc3(255, 246, 233))
  lbl_sign_cd:setPosition(CCPoint(offset_x + 288, offset_y + 165))
  info_bg:addChild(lbl_sign_cd, 100)
  local btn_sign = SpineMenuItem:create(json.ui.button, btn_sign0)
  btn_sign:setPosition(CCPoint(offset_x + 288, offset_y + 178))
  local btn_sign_menu = CCMenu:createWithItem(btn_sign)
  btn_sign_menu:setPosition(CCPoint(0, 0))
  info_bg:addChild(btn_sign_menu)
  local checkSign = function()
    if gdata.sign_cd <= os.time() - gdata.last_pull then
      lbl_sign_cd:setVisible(false)
      btn_sign:setEnabled(true)
      clearShader(btn_sign, true)
      addRedDot(btn_sign0, {px = btn_sign0:getContentSize().width - 2, py = btn_sign0:getContentSize().height - 2})
    else
      lbl_sign_cd:setVisible(true)
      btn_sign:setEnabled(false)
      delRedDot(btn_sign0)
      setShader(btn_sign, SHADER_GRAY, true)
      local remain_cd = gdata.sign_cd - (os.time() - gdata.last_pull)
      local time_str = time2string(checkint(remain_cd))
      lbl_sign_cd:setString(time_str)
    end
   end
  checkSign()
  btn_sign:registerScriptTapHandler(function()
    audio.play(audio.button)
    local gParams = {sid = player.sid}
    addWaitNet()
    netClient:guild_sign(gParams, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 and l_1_0.status ~= 1 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      btn_sign:setEnabled(false)
      setShader(btn_sign, SHADER_GRAY, true)
      gdata.last_pull = os.time()
      gdata.sign_cd = l_1_0.cd or 86400
      if l_1_0.status == 0 then
        gdata.addExp(gdata.SIGN_EXP)
      end
      bagdata.items.add({id = ITEM_ID_GUILD_COIN, num = gdata.SIGN_COIN})
      local taskdata = require("data.task")
      taskdata.increment(taskdata.TaskType.GUILD_SIGN)
      local tmp_pb_bag = {items = {1 = {id = ITEM_ID_GUILD_COIN, num = gdata.SIGN_COIN}}, equips = {}}
      if l_1_0.status == 0 then
        tmp_pb_bag.items[#tmp_pb_bag.items + 1] = {id = ITEM_ID_GUILD_EXP, num = gdata.SIGN_EXP}
      end
      CCDirector:sharedDirector():getRunningScene():addChild(rewards.createFloating(tmp_pb_bag), 100000)
      end)
   end)
  local notice_bg = img.createLogin9Sprite(img.login.input_border)
  notice_bg:setPreferredSize(CCSizeMake(286, 107))
  notice_bg:setAnchorPoint(CCPoint(0, 0))
  notice_bg:setPosition(CCPoint(offset_x + 49, offset_y + 32))
  info_bg:addChild(notice_bg)
  local nScroll = require("ui.lineScroll").create({width = 262, height = 83})
  nScroll:setAnchorPoint(CCPoint(0, 0))
  nScroll:setPosition(CCPoint(12, 12))
  notice_bg:addChild(nScroll)
  local lbl_notice = lbl.create({kind = "ttf", size = 18, text = gdata.guildObj.notice or "", color = ccc3(112, 74, 43)})
  lbl_notice:setHorizontalAlignment(kCCTextAlignmentLeft)
  lbl_notice:setDimensions(CCSizeMake(262, 0))
  lbl_notice:setAnchorPoint(CCPoint(0, 0))
  lbl_notice:setPosition(CCPoint(0, 0))
  nScroll.addItem(lbl_notice)
  nScroll.setOffsetBegin()
  local mem_container = CCSprite:create()
  mem_container:setContentSize(CCSizeMake(550, 437))
  mem_container:setAnchorPoint(CCPoint(0, 0))
  mem_container:setPosition(CCPoint(0, 0))
  mem_board:addChild(mem_container)
  local container_w = mem_container:getContentSize().width
  local container_h = mem_container:getContentSize().height
  local createScroll = function()
    local scroll_params = {width = 550, height = 400}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local createItem = function(l_15_0)
    local item = img.createUI9Sprite(img.ui.botton_fram_2)
    item:setPreferredSize(CCSizeMake(492, 77))
    local item_w = item:getContentSize().width
    local item_h = item:getContentSize().height
    local head = img.createPlayerHead(l_15_0.logo)
    head:setScale(0.65)
    head:setPosition(CCPoint(41, item_h / 2 + 1))
    item:addChild(head)
    local lv_bg = img.createUISprite(img.ui.main_lv_bg)
    lv_bg:setPosition(CCPoint(92, item_h / 2))
    item:addChild(lv_bg)
    local lbl_mem_lv = lbl.createFont1(14, l_15_0.lv)
    lbl_mem_lv:setPosition(CCPoint(lv_bg:getContentSize().width / 2, lv_bg:getContentSize().height / 2))
    lv_bg:addChild(lbl_mem_lv)
    local lbl_mem_name = lbl.createFontTTF(20, l_15_0.name, ccc3(81, 39, 18))
    lbl_mem_name:setAnchorPoint(CCPoint(0, 0))
    lbl_mem_name:setPosition(CCPoint(122, item_h / 2))
    item:addChild(lbl_mem_name)
    local lbl_mem_title = lbl.createFont1(14, gdata.getTitleStr(l_15_0.title), ccc3(138, 96, 76))
    lbl_mem_title:setAnchorPoint(CCPoint(0, 1))
    lbl_mem_title:setPosition(CCPoint(122, item_h / 2))
    item:addChild(lbl_mem_title)
    if l_15_0.gfight and l_15_0.gfight == 1 then
      local icon_fight0 = img.createUISprite(img.ui.guild_icon_gfight)
      local icon_fight = SpineMenuItem:create(json.ui.button, icon_fight0)
      icon_fight:setPosition(CCPoint(324, item_h / 2))
      local icon_fight_menu = CCMenu:createWithItem(icon_fight)
      icon_fight_menu:setPosition(CCPoint(0, 0))
      item:addChild(icon_fight_menu)
      icon_fight:registerScriptTapHandler(alreadyJoinedFight)
    end
    local lbl_mem_status = lbl.createFont1(16, gdata.onlineStatus(l_15_0.last), ccc3(138, 96, 76))
    lbl_mem_status:setAnchorPoint(CCPoint(1, 0.5))
    lbl_mem_status:setPosition(CCPoint(item_w - 25, item_h / 2))
    item:addChild(lbl_mem_status)
    return item
   end
  local items = {}
  local showList = function(l_16_0)
    table.sort(l_16_0, gdata.mem_sort)
    mem_container:removeAllChildrenWithCleanup(true)
    arrayclear(items)
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(0, 19))
    mem_container:addChild(scroll)
    mem_container.scroll = scroll
    scroll.addSpace(3)
    for ii = 1, #l_16_0 do
      local tmp_item = createItem(l_16_0[ii])
      tmp_item.memObj = l_16_0[ii]
      tmp_item.ax = 0.5
      tmp_item.ay = 0.5
      tmp_item.px = 271
      scroll.addItem(tmp_item)
      items[#items + 1] = tmp_item
      if ii ~= #l_16_0 then
        scroll.addSpace(space_height)
      end
    end
    scroll.setOffsetBegin()
   end
  if not gdata.members then
    showList({})
  end
  local onClickItem = function(l_17_0)
      audio.play(audio.button)
      if not l_17_0 or tolua.isnull(l_17_0) then
        return 
      end
      local memObj = l_17_0.memObj
      if memObj.uid == player.uid then
        return 
      end
      local mParams = {name = memObj.name, logo = memObj.logo, lv = memObj.lv, uid = memObj.uid, guild = gdata.guildObj.name, power = 1000, defens = {}, buttons = {}}
      layer:addChild(require("ui.tips.player1").create(mParams), 1000)
      end
  local btn_quit0 = img.createLogin9Sprite(img.login.button_9_small_orange)
  btn_quit0:setPreferredSize(CCSizeMake(66, 52))
  local icon_quit = img.createUISprite(img.ui.guild_icon_quit)
  icon_quit:setPosition(CCPoint(39, 26))
  btn_quit0:addChild(icon_quit)
  local btn_quit = SpineMenuItem:create(json.ui.button, btn_quit0)
  btn_quit:setPosition(CCPoint(bg_w - 60, 65))
  local btn_quit_menu = CCMenu:createWithItem(btn_quit)
  btn_quit_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_quit_menu)
  btn_quit:registerScriptTapHandler(function()
    audio.play(audio.button)
    if gdata.selfTitle() == gdata.TITLE.PRESIDENT then
      showToast(i18n.global.guild_president_quit.string)
      return 
    end
    local dialog = require("ui.dialog")
    local process_dialog = function(l_1_0)
      layer:removeChildByTag(dialog.TAG)
      if l_1_0.selected_btn == 2 then
        local gParams = {sid = player.sid}
        addWaitNet()
        netClient:guild_leave(gParams, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          if l_1_0.status ~= 0 then
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
            return 
          end
          gdata.deInit()
          player.gid = 0
          player.gname = ""
          replaceScene(require("ui.town.main").create())
            end)
      elseif l_1_0.selected_btn == 1 then
         -- Warning: missing end command somewhere! Added here
      end
      end
    local params = {title = "", body = i18n.global.guild_dlg_quit_body.string, btn_count = 2, btn_color = {1 = dialog.COLOR_BLUE, 2 = dialog.COLOR_GOLD}, btn_text = {1 = i18n.global.dialog_button_cancel.string, 2 = i18n.global.dialog_button_confirm.string}, callback = process_dialog}
    local dialog_ins = dialog.create(params, true)
    dialog_ins:setAnchorPoint(CCPoint(0, 0))
    dialog_ins:setPosition(CCPoint(0, 0))
    layer:addChild(dialog_ins, 10000, dialog.TAG)
   end)
  local btn_manage0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_manage0:setPreferredSize(CCSizeMake(145, 52))
  local lbl_manage = lbl.createFont1(16, i18n.global.guild_memopt_dlg_title.string, ccc3(115, 59, 5))
  lbl_manage:setPosition(CCPoint(btn_manage0:getContentSize().width / 2, btn_manage0:getContentSize().height / 2))
  btn_manage0:addChild(lbl_manage)
  local btn_manage = SpineMenuItem:create(json.ui.button, btn_manage0)
  btn_manage:setPosition(CCPoint(251, 65))
  local btn_manage_menu = CCMenu:createWithItem(btn_manage)
  btn_manage_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_manage_menu)
  btn_manage:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.guild.members").create(1), 100)
   end)
  btn_manage:setVisible(gdata.TITLE.RESIDENT < gdata.selfTitle())
  local btn_invite0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_invite0:setPreferredSize(CCSizeMake(145, 52))
  local lbl_invite = lbl.createFont1(16, i18n.global.guild_btn_recruit.string, ccc3(115, 59, 5))
  lbl_invite:setPosition(CCPoint(btn_invite0:getContentSize().width / 2, btn_invite0:getContentSize().height / 2))
  btn_invite0:addChild(lbl_invite)
  local btn_invite = SpineMenuItem:create(json.ui.button, btn_invite0)
  btn_invite:setPosition(CCPoint(400, 65))
  local btn_invite_menu = CCMenu:createWithItem(btn_invite)
  btn_invite_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_invite_menu)
  btn_invite:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.guild.recruit").create(), 100)
   end)
  btn_invite:setVisible(gdata.TITLE.RESIDENT < gdata.selfTitle())
  local btn_apply0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_apply0:setPreferredSize(CCSizeMake(145, 52))
  addRedDot(btn_apply0, {px = btn_apply0:getContentSize().width - 3, py = btn_apply0:getContentSize().height - 3})
  delRedDot(btn_apply0)
  local lbl_apply = lbl.createFont1(16, i18n.global.guild_applylist_board_title.string, ccc3(115, 59, 5))
  lbl_apply:setPosition(CCPoint(btn_apply0:getContentSize().width / 2, btn_apply0:getContentSize().height / 2))
  btn_apply0:addChild(lbl_apply)
  local btn_apply = SpineMenuItem:create(json.ui.button, btn_apply0)
  btn_apply:setPosition(CCPoint(102, 65))
  local btn_apply_menu = CCMenu:createWithItem(btn_apply)
  btn_apply_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_apply_menu)
  btn_apply:registerScriptTapHandler(function()
    audio.play(audio.button)
    local params = {sid = player.sid}
    addWaitNet()
    netClient:guild_appliers(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      layer:addChild(require("ui.guild.appliers").create(l_1_0.mems), 100)
      end)
   end)
  local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
  local onTouchBegan = function(l_22_0, l_22_1)
    touchbeginx, upvalue_512 = l_22_0, l_22_1
    upvalue_1024 = true
    local pp0 = mem_container:convertToNodeSpace(ccp(l_22_0, l_22_1))
    if not mem_container:boundingBox():containsPoint(pp0) then
      upvalue_1024 = false
      return false
    end
    if mem_container.scroll and not tolua.isnull(mem_container.scroll) then
      local p0 = mem_container.scroll.content_layer:convertToNodeSpace(ccp(l_22_0, l_22_1))
      for ii = 1, #items do
        if items[ii]:boundingBox():containsPoint(p0) then
          playAnimTouchBegin(items[ii])
          upvalue_2560 = items[ii]
      else
        end
      end
    end
    return true
   end
  local onTouchMoved = function(l_23_0, l_23_1)
    if isclick and (math.abs(touchbeginx - l_23_0) > 10 or math.abs(touchbeginy - l_23_1) > 10) then
      isclick = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        playAnimTouchEnd(last_touch_sprite)
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_24_0, l_24_1)
    if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
      playAnimTouchEnd(last_touch_sprite)
      last_touch_sprite = nil
    end
    if isclick and mem_container.scroll and not tolua.isnull(mem_container.scroll) then
      local p0 = mem_container.scroll.content_layer:convertToNodeSpace(ccp(l_24_0, l_24_1))
      for ii = 1, #items do
        if items[ii]:boundingBox():containsPoint(p0) then
          audio.play(audio.button)
          onClickItem(items[ii])
      else
        end
      end
    end
   end
  local onTouch = function(l_25_0, l_25_1, l_25_2)
    if l_25_0 == "began" then
      return onTouchBegan(l_25_1, l_25_2)
    elseif l_25_0 == "moved" then
      return onTouchMoved(l_25_1, l_25_2)
    else
      return onTouchEnded(l_25_1, l_25_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  local last_update = os.time()
  local onUpdate = function(l_26_0)
    if os.time() - last_update < 0.5 then
      return 
    end
    last_update = os.time()
    expPercent()
    lbl_lv:setString("Lv." .. gdata.Lv())
    updateFlag()
    if gdata.guildObj.name ~= lbl_name.name then
      lbl_name.name = gdata.guildObj.name
      lbl_name:setString(gdata.guildObj.name)
    end
    checkSign()
    if gdata.showRedDotApply() then
      addRedDot(btn_apply0, {px = btn_apply0:getContentSize().width - 3, py = btn_apply0:getContentSize().height - 3})
    else
      delRedDot(btn_apply0)
    end
    local gmill = require("data.guildmill")
    if gmill.showRedDot() then
      addRedDot(area_bg, {px = area_bg:getContentSize().width - 13, py = area_bg:getContentSize().height - 13})
    else
      delRedDot(area_bg)
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    backEvent()
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    json.unload(json.ui.gh_chengbao_fx)
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_30_0)
    if l_30_0 == "enter" then
      onEnter()
    elseif l_30_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

