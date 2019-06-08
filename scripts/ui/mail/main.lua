-- Command line was: E:\github\dhgametool\scripts\ui\mail\main.lua 

local ui = {}
local cjson = json
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local cfgmail = require("config.mail")
local player = require("data.player")
local bagdata = require("data.bag")
local maildata = require("data.mail")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local dialog = require("ui.dialog")
local rewards = require("ui.reward")
local TAB = {INB = 1, SYS = 2, NEW = 3}
ui.TAB = TAB
local current_tab = TAB.SYS
local btn_size = CCSizeMake(160, 50)
local btn_size2 = CCSizeMake(130, 42)
local m_btn_color = (ccc3(115, 59, 5))
local input_content = nil
local dropConfirm = function(l_1_0, l_1_1)
  if input_content ~= nil and input_content ~= "" then
    local process_dialog = function(l_1_0)
    parentObj:removeChildByTag(dialog.TAG)
    if l_1_0.selected_btn == 2 then
      upvalue_1024 = nil
      if callback then
        callback()
      end
      return 
    elseif l_1_0.selected_btn == 1 then
      return 
    end
   end
    local dialog_params = {title = "", body = i18n.global.mail_leave_send.string, btn_count = 2, btn_text = {1 = i18n.global.dialog_button_cancel.string, 2 = i18n.global.dialog_button_confirm.string}, btn_color = {1 = dialog.COLOR_BLUE, 2 = dialog.COLOR_GOLD}, selected_btn = 0, callback = process_dialog}
    local dialog_ins = dialog.create(dialog_params)
    l_1_0:addChild(dialog_ins, 1000, dialog.TAG)
  elseif l_1_1 then
    l_1_1()
  end
end

local delAllSysRead = function(l_2_0)
  local sys_mails = maildata.getSysMails()
  local d_ids = {}
  local d_mails = {}
  for ii = 1,  sys_mails do
    local mailObj = sys_mails[ii]
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if not mailObj.affix and mailObj.flag == 1 then
      d_ids[ d_ids + 1] = mailObj.mid
      d_mails[ d_mails + 1] = mailObj
      do return end
      if mailObj.flag == 2 then
        d_ids[ d_ids + 1] = mailObj.mid
        d_mails[ d_mails + 1] = mailObj
      end
    end
  end
  if  d_ids <= 0 then
    return 
  end
  local params = {sid = player.sid, deletes = d_ids}
  addWaitNet()
  netClient:op_mail(params, function(l_1_0)
    delWaitNet()
    for ii = 1,  d_mails do
      maildata.delSys(d_mails[ii])
    end
    if callback then
      callback()
    end
   end)
end

local coupleBatchDel = function(l_3_0, l_3_1)
  local process_dialog = function(l_1_0)
    parentObj:removeChildByTag(dialog.TAG)
    if l_1_0.selected_btn == 2 then
      delAllSysRead(callback)
      return 
    elseif l_1_0.selected_btn == 1 then
      return 
    end
   end
  local dialog_params = {title = "", body = i18n.global.mail_batch_del.string, btn_count = 2, btn_text = {1 = i18n.global.dialog_button_cancel.string, 2 = i18n.global.dialog_button_confirm.string}, btn_color = {1 = dialog.COLOR_BLUE, 2 = dialog.COLOR_GOLD}, selected_btn = 0, callback = process_dialog}
  local dialog_ins = dialog.create(dialog_params)
  l_3_0:addChild(dialog_ins, 1000, dialog.TAG)
end

local processMailContent = function(l_4_0)
  l_4_0.type = l_4_0.id
  local body = ""
  if cfgmail[l_4_0.type] then
    local _type = l_4_0.type
    local cfgObj = cfgmail[l_4_0.type]
    local cont_params = cjson.decode(l_4_0.content)
    if type(cont_params) == "table" and cont_params.guildname then
      cont_params.guildname = replaceInvalidChars(cont_params.guildname)
    end
    l_4_0.title = i18n.mail[l_4_0.type].name
    l_4_0.from = i18n.mail[l_4_0.type].from
    body = i18n.mail[l_4_0.type].content
    if _type == 1 then
      local tmp_stamp = checkint(cont_params.time)
      body = string.gsub(body, "#time#", os.date("%Y-%m-%d", tmp_stamp))
      body = string.gsub(body, "#id#", tostring(i18n.arena[cont_params.id].name))
      body = string.gsub(body, "#rank#", tostring(cont_params.rank))
    elseif _type == 2 then
      body = string.gsub(body, "#id#", tostring(i18n.arena[cont_params.id].name))
      body = string.gsub(body, "#rank#", tostring(cont_params.rank))
    elseif _type == 3 then
      body = string.gsub(body, "#member1#", tostring(cont_params.member1))
      body = string.gsub(body, "#member2#", tostring(cont_params.member2))
      body = string.gsub(body, "#guildname#", tostring(cont_params.guildname))
    elseif _type == 4 then
      body = string.gsub(body, "#guildname#", tostring(cont_params.guildname))
    elseif _type == 5 then
      body = string.gsub(body, "#guildname#", tostring(cont_params.guildname))
    elseif _type == 6 then
      body = string.gsub(body, "#guildname#", tostring(cont_params.guildname))
    elseif _type == 7 then
      body = string.gsub(body, "#guildname#", tostring(cont_params.guildname))
    elseif _type == 10 then
      body = tostring(cont_params.content)
    elseif _type == 11 then
      body = string.gsub(body, "#content#", tostring(cont_params.content))
    elseif _type == 12 then
      body = string.gsub(body, "#date#", tostring(cont_params.date))
      body = string.gsub(body, "#gems#", tostring(cont_params.gems))
    elseif _type == 13 then
      body = string.gsub(body, "#number#", tostring(cont_params.number))
      body = string.gsub(body, "#day#", tostring(cont_params.day))
    elseif _type == 15 then
      body = string.gsub(body, "#level#", tostring(cont_params.level))
      body = string.gsub(body, "#gems#", tostring(cont_params.gems))
      body = string.gsub(body, "#gold#", tostring(cont_params.gold))
    elseif _type == 16 then
      local hero_id = checkint(cont_params.ID)
      body = string.gsub(body, "#ID#", i18n.hero[hero_id].heroName)
    elseif _type == 17 then
      body = string.gsub(body, "#gems#", tostring(cont_params.gems))
    elseif _type == 18 then
      body = string.gsub(body, "#date#", tostring(cont_params.date))
    elseif _type == 21 then
      body = string.gsub(body, "#stage#", tostring(i18n.guildwar[cont_params.stage].stageName))
    elseif _type == 22 then
      body = string.gsub(body, "#number#", tostring(cont_params.number))
      body = string.gsub(body, "#stage#", tostring(i18n.guildwar[cont_params.stage].stageName))
    elseif _type == 26 then
      body = string.gsub(body, "#number#", tostring(cont_params.number))
    elseif _type == 27 then
      body = string.gsub(body, "#gems#", tostring(cont_params.gems))
      body = string.gsub(body, "#chip#", tostring(cont_params.chip))
    elseif _type == 29 then
      body = string.gsub(body, "#number#", tostring(cont_params.number))
    elseif _type == 32 then
      body = string.gsub(body, "#rank#", tostring(cont_params.rank))
    elseif _type == 38 then
      body = string.gsub(body, "#number#", tostring(cont_params.number))
    elseif _type == 40 then
      body = string.gsub(body, "#rank#", tostring(cont_params.rank))
    elseif _type == 41 then
      body = string.gsub(body, "#date#", tostring(cont_params.date))
      body = string.gsub(body, "#gems#", tostring(cont_params.gems))
    elseif _type == 42 then
      body = string.gsub(body, "#day#", tostring(cont_params.day))
    elseif _type == 45 then
      local hero_id = checkint(cont_params.ID)
      body = string.gsub(body, "#ID#", i18n.hero[hero_id].heroName)
    elseif _type == 65 then
      local hero_id = checkint(cont_params.ID)
      body = string.gsub(body, "#ID#", i18n.hero[hero_id].heroName)
    elseif _type == 50 then
      body = string.gsub(body, "#rank#", tostring(cont_params.rank))
    elseif _type == 51 then
      body = string.gsub(body, "#rank#", tostring(cont_params.rank))
    elseif _type == 56 then
      body = string.gsub(body, "#guildname#", tostring(cont_params.guildname))
    elseif _type == 69 then
      body = string.gsub(body, "#number#", tostring(cont_params.number))
    elseif _type == 72 then
      body = string.gsub(body, "#platform#", tostring(cont_params.platform))
      body = string.gsub(body, "#price#", tostring(cont_params.price))
      body = string.gsub(body, "#order_id#", tostring(cont_params.order_id))
    elseif _type == 81 then
      body = string.gsub(body, "#rank#", tostring(cont_params.rank))
    elseif _type == 82 then
      body = string.gsub(body, "#rank#", tostring(cont_params.rank))
    elseif _type == 83 then
      body = string.gsub(body, "#rank#", tostring(cont_params.rank))
    elseif _type == 87 then
      body = string.gsub(body, "#chip#", tostring(cont_params.chip))
      body = string.gsub(body, "#gems#", tostring(cont_params.gems))
    elseif _type == 88 then
      body = string.gsub(body, "#key#", tostring(cont_params.key))
    elseif _type == 89 then
      body = string.gsub(body, "#key#", tostring(cont_params.key))
    elseif _type == 108 then
      body = string.gsub(body, "#level#", tostring(cont_params.level))
      body = string.gsub(body, "#number#", tostring(cont_params.number))
      body = string.gsub(body, "#day#", tostring(cont_params.day))
    elseif _type == 120 then
      body = string.gsub(body, "#level#", tostring(cont_params.level))
      body = string.gsub(body, "#number#", tostring(cont_params.number))
      body = string.gsub(body, "#day#", tostring(cont_params.day))
    elseif _type == 130 then
      body = string.gsub(body, "#content#", tostring(cont_params.content))
    elseif _type == 134 then
      body = string.gsub(body, "#level#", tostring(cont_params.level))
      body = string.gsub(body, "#number#", tostring(cont_params.number))
      body = string.gsub(body, "#day#", tostring(cont_params.day))
    elseif _type == 144 then
      local hero_id = checkint(cont_params.ID)
      body = string.gsub(body, "#ID#", i18n.hero[hero_id].heroName)
    elseif _type == 145 then
      local hero_id = checkint(cont_params.ID)
      body = string.gsub(body, "#ID#", i18n.hero[hero_id].heroName)
    elseif _type == 148 then
      body = string.gsub(body, "#day#", tostring(cont_params.day))
    elseif _type == 149 then
      body = string.gsub(body, "#day#", tostring(cont_params.day))
    elseif _type == 153 then
      body = string.gsub(body, "#day#", tostring(cont_params.day))
    elseif _type == 154 then
      body = string.gsub(body, "#day#", tostring(cont_params.day))
    elseif _type == 157 then
      body = string.gsub(body, "#level#", tostring(cont_params.level))
      body = string.gsub(body, "#day#", tostring(cont_params.day))
    elseif _type == 158 then
      body = string.gsub(body, "#number#", tostring(cont_params.number))
    else
      body = l_4_0.content
    end
  end
  l_4_0.body = body
end

local icons = {1 = img.ui.mail_icon_gift, 2 = img.ui.mail_icon_gift_read, 3 = img.ui.mail_icon, 4 = img.ui.mail_icon_read}
local createItem = function(l_5_0)
  local item_bg = img.createUI9Sprite(img.ui.mail_item)
  item_bg:setPreferredSize(CCSizeMake(301, 79))
  local item_bg_w = item_bg:getContentSize().width
  local item_bg_h = item_bg:getContentSize().height
  local item_read = img.createUI9Sprite(img.ui.mail_item_read)
  item_read:setPreferredSize(CCSizeMake(301, 79))
  item_read:setPosition(CCPoint(item_bg_w / 2, item_bg_h / 2))
  item_bg:addChild(item_read, 1)
  local item_focus = img.createUI9Sprite(img.ui.mail_item_hl)
  item_focus:setPreferredSize(CCSizeMake(301, 79))
  item_focus:setAnchorPoint(CCPoint(0, 0.5))
  item_focus:setPosition(CCPoint(0, item_bg_h / 2))
  item_focus:setVisible(false)
  item_bg:addChild(item_focus, 2)
  item_bg.focus = item_focus
  local tmp_icon, tmp_icon_read = nil, nil
  if maildata.getTypeById(l_5_0.id) == 1 then
    tmp_icon = icons[1]
    tmp_icon_read = icons[2]
  else
    tmp_icon = icons[3]
    tmp_icon_read = icons[4]
  end
  local icon = img.createUISprite(tmp_icon)
  icon:setPosition(CCPoint(42, item_bg_h / 2))
  item_bg:addChild(icon, 3)
  local icon_read = img.createUISprite(tmp_icon_read)
  icon_read:setPosition(CCPoint(42, item_bg_h / 2))
  item_bg:addChild(icon_read, 4)
  item_bg.icon_read = icon_read
  if l_5_0.flag == 1 or l_5_0.flag == 2 then
    item_read:setVisible(true)
    icon_read:setVisible(true)
  else
    item_read:setVisible(false)
    icon_read:setVisible(false)
  end
  item_bg.setRead = function()
    item_read:setVisible(true)
    icon_read:setVisible(true)
    print("set read mid:" .. mailObj.mid)
    if mailObj.flag == 0 then
      mailObj.flag = 1
      maildata.read(mailObj.mid)
    end
   end
  local tmp_title = i18n.global.mail_tab_system.string
  if not l_5_0.from then
    tmp_title = string.format("From:%s", current_tab ~= TAB.INB or "")
    do return end
    if current_tab == TAB.SYS then
      tmp_title = i18n.global.mail_tab_system.string
    else
      local lbl_title = lbl.create({kind = "ttf", size = 16, text = tmp_title, color = ccc3(81, 39, 18)})
      lbl_title:setAnchorPoint(CCPoint(0, 0))
      lbl_title:setPosition(CCPoint(80, 41))
      item_bg:addChild(lbl_title, 4)
      do
        local lbl_date = lbl.create({kind = "ttf", size = 16, text = os.date("%Y-%m-%d", l_5_0.send_time), color = ccc3(81, 39, 18)})
        lbl_date:setAnchorPoint(CCPoint(0, 0))
        lbl_date:setPosition(CCPoint(80, 18))
        item_bg:addChild(lbl_date, 4)
        item_bg.height = item_bg_h
        return item_bg
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.create = function(l_6_0)
  local titles = {TAB.INB = i18n.global.mail_tab_player.string, TAB.SYS = i18n.global.mail_tab_system.string, TAB.NEW = i18n.global.mail_tab_new.string}
  local layer = CCLayer:create()
  if current_tab == TAB.NEW then
    upvalue_1024 = TAB.SYS
  end
  upvalue_1024 = l_6_0 and l_6_0.tab or current_tab
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board = img.createUISprite(img.ui.mail_board)
  board:setScale(view.minScale)
  board:setPosition(view.midX - 25 * view.minScale, view.midY)
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  board:setScale(0.5 * view.minScale)
  board:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  local lbl_title = lbl.createFont3(34, "", ccc3(255, 246, 223))
  lbl_title:setAnchorPoint(CCPoint(0, 0.5))
  lbl_title:setPosition(CCPoint(102, 507))
  board:addChild(lbl_title)
  local backEvent = function()
    dropConfirm(layer, function()
      audio.play(audio.button)
      layer:removeFromParentAndCleanup(true)
      end)
   end
  local btn_close0 = img.createUISprite(img.ui.mail_btn_close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(795, 489))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_close_menu, 100)
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local tab_inb0 = img.createUISprite(img.ui.mail_btn_inbox)
  local tab_sys0 = img.createUISprite(img.ui.mail_btn_sys)
  local tab_new0 = img.createUISprite(img.ui.mail_btn_new)
  local tab_inb_hl = img.createUISprite(img.ui.mail_btn_inbox_hl)
  local tab_sys_hl = img.createUISprite(img.ui.mail_btn_sys_hl)
  local tab_new_hl = img.createUISprite(img.ui.mail_btn_new_hl)
  local tab_offset_x = 26
  local tab_offset_y = 408
  local tab_step_y = 75
  local tab_inb = HHMenuItem:create(tab_inb0)
  tab_inb:setPosition(CCPoint(board_w + tab_offset_x, tab_offset_y - tab_step_y * 1))
  local tab_inb_menu = CCMenu:createWithItem(tab_inb)
  tab_inb_menu:setPosition(CCPoint(0, 0))
  board:addChild(tab_inb_menu, -1)
  tab_inb_hl:setPosition(CCPoint(board_w + tab_offset_x, tab_offset_y - tab_step_y * 1))
  board:addChild(tab_inb_hl)
  local tab_sys = HHMenuItem:create(tab_sys0)
  tab_sys:setPosition(CCPoint(board_w + tab_offset_x, tab_offset_y - tab_step_y * 0))
  local tab_sys_menu = CCMenu:createWithItem(tab_sys)
  tab_sys_menu:setPosition(CCPoint(0, 0))
  board:addChild(tab_sys_menu, -1)
  tab_sys_hl:setPosition(CCPoint(board_w + tab_offset_x, tab_offset_y - tab_step_y * 0))
  board:addChild(tab_sys_hl)
  local tab_new = HHMenuItem:create(tab_new0)
  tab_new:setPosition(CCPoint(board_w + tab_offset_x, tab_offset_y - tab_step_y * 2))
  local tab_new_menu = CCMenu:createWithItem(tab_new)
  tab_new_menu:setPosition(CCPoint(0, 0))
  board:addChild(tab_new_menu, -1)
  tab_new_hl:setPosition(CCPoint(board_w + tab_offset_x, tab_offset_y - tab_step_y * 2))
  board:addChild(tab_new_hl)
  local container = CCSprite:create()
  container:setContentSize(CCSizeMake(730, 435))
  container:setPosition(CCPoint(422, 257))
  board:addChild(container, 2)
  local container_w = container:getContentSize().width
  local container_h = container:getContentSize().height
  local content_container = CCSprite:create()
  content_container:setContentSize(CCSizeMake(405, 435))
  content_container:setAnchorPoint(CCPoint(1, 1))
  content_container:setPosition(CCPoint(container:boundingBox():getMaxX(), container:boundingBox():getMaxY()))
  board:addChild(content_container, 1)
  local content_container_w = content_container:getContentSize().width
  local content_container_h = content_container:getContentSize().height
  local onTabSel, last_selet_item = nil, nil
  local items = {}
  local createContentScroll = function()
    local scroll_params = {width = 380, height = 336}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local showTextContent = function(l_4_0, l_4_1)
    processMailContent(l_4_0)
    local txt_bg = img.createUI9Sprite(img.ui.mail_content_bg)
    txt_bg:setPreferredSize(CCSizeMake(406, 356))
    txt_bg:setAnchorPoint(CCPoint(1, 1))
    txt_bg:setPosition(CCPoint(content_container_w, content_container_h))
    content_container:addChild(txt_bg)
    local txt_bg_w = txt_bg:getContentSize().width
    local txt_bg_h = txt_bg:getContentSize().height
    local scroll = createContentScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(17, 10))
    txt_bg:addChild(scroll)
    scroll.addSpace(10)
    local lbl_mail_title = lbl.create({kind = "ttf", size = 18, text = l_4_0.title, color = ccc3(131, 65, 29), width = 358, align = kCCTextAlignmentCenter})
    lbl_mail_title.ax = 0.5
    lbl_mail_title.px = 190
    scroll.addItem(lbl_mail_title)
    scroll.addSpace(16)
    local lbl_body = lbl.create({kind = "ttf", font = 1, size = 17, text = l_4_0.body, color = ccc3(131, 65, 29), width = 358, align = kCCTextAlignmentLeft})
    lbl_body.ax = 0.5
    lbl_body.px = 190
    scroll.addItem(lbl_body)
    scroll.addSpace(16)
    local lbl_from = lbl.create({kind = "ttf", size = 17, text = l_4_0.from, color = ccc3(131, 65, 29)})
    lbl_from.ax = 1
    lbl_from.px = 367
    scroll.addItem(lbl_from)
    scroll.addSpace(30)
    scroll.setOffsetBegin()
    if l_4_1 and l_4_0.affix then
      local split_line = img.createUISprite(img.ui.mail_content_split)
      split_line.ax = 0.5
      split_line.px = 190
      scroll.addItem(split_line)
      scroll.addSpace(10)
      local lbl_rewards = lbl.create({font = 1, size = 20, text = i18n.global.mail_rewards.string, color = ccc3(131, 65, 29)})
      lbl_rewards.ax = 0.5
      lbl_rewards.px = 190
      scroll.addItem(lbl_rewards)
      scroll.addSpace(10)
      if l_4_0.flag == 2 then
        local icon_got = img.createUISprite(img.ui.mail_icon_got)
        icon_got:setPosition(CCPoint(335, split_line:getPositionY()))
        split_line:getParent():addChild(icon_got, 10)
      end
      local item_count = 0
      if l_4_0.affix.items then
        item_count = item_count +  l_4_0.affix.items
      end
      if l_4_0.affix.equips then
        item_count = item_count +  l_4_0.affix.equips
      end
      local affix_container_w = 361
      local affix_container_h = math.floor((item_count + 3) / 4) * 92
      local affix_container = CCSprite:create()
      affix_container:setContentSize(CCSizeMake(affix_container_w, affix_container_h))
      local off_x, off_y = 40, affix_container_h - 43
      local off_step = 91
      local item_idx = 0
      if l_4_0.affix.items then
        do
          for _,_obj in ipairs(l_4_0.affix.items) do
            item_idx = item_idx + 1
            local tmp_item0 = img.createItem(_obj.id, _obj.num)
            local tmp_item = CCMenuItemSprite:create(tmp_item0, nil)
            tmp_item:setPosition(CCPoint(off_x + (item_idx - 1) % 4 * off_step, off_y - math.floor((item_idx + 3) / 4 - 1) * off_step))
            local tmp_item_menu = CCMenu:createWithItem(tmp_item)
            tmp_item_menu:setPosition(CCPoint(0, 0))
            affix_container:addChild(tmp_item_menu)
            tmp_item:registerScriptTapHandler(function()
              audio.play(audio.button)
              layer:addChild(tipsitem.createForShow(_obj), 1000)
                  end)
            if l_4_0.flag == 2 then
              setShader(tmp_item, SHADER_GRAY, true)
            end
          end
        end
      end
      if l_4_0.affix.equips then
        for _,_obj in ipairs(l_4_0.affix.equips) do
          item_idx = item_idx + 1
          local tmp_item0 = img.createEquip(_obj.id, _obj.num)
          local tmp_item = CCMenuItemSprite:create(tmp_item0, nil)
          tmp_item:setPosition(CCPoint(off_x + (item_idx - 1) % 4 * off_step, off_y - math.floor((item_idx + 3) / 4 - 1) * off_step))
          local tmp_item_menu = CCMenu:createWithItem(tmp_item)
          tmp_item_menu:setPosition(CCPoint(0, 0))
          affix_container:addChild(tmp_item_menu)
          tmp_item:registerScriptTapHandler(function()
            audio.play(audio.button)
            layer:addChild(tipsequip.createForShow(_obj), 1000)
               end)
          if l_4_0.flag == 2 then
            setShader(tmp_item, SHADER_GRAY, true)
          end
        end
      end
      affix_container.ax = 0.5
      affix_container.px = 190
      scroll.addItem(affix_container)
      scroll.addSpace(10)
      if l_4_0.flag == 2 then
        local btn_del0 = img.createLogin9Sprite(img.login.button_9_small_gold)
        btn_del0:setPreferredSize(btn_size)
        local lbl_del = lbl.createFont1(18, i18n.global.mail_btn_del.string, m_btn_color)
        lbl_del:setPosition(CCPoint(btn_del0:getContentSize().width / 2, btn_del0:getContentSize().height / 2))
        btn_del0:addChild(lbl_del)
        local btn_del = SpineMenuItem:create(json.ui.button, btn_del0)
        btn_del:setPosition(CCPoint(content_container_w / 2, 34))
        local btn_del_menu = CCMenu:createWithItem(btn_del)
        btn_del_menu:setPosition(CCPoint(0, 0))
        content_container:addChild(btn_del_menu)
        btn_del:registerScriptTapHandler(function()
          audio.play(audio.button)
          addWaitNet()
          maildata.netDel(mailObj, function(l_1_0)
            delWaitNet()
            tbl2string(l_1_0)
            if l_1_0.status ~= 0 then
              showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
              return 
            end
            maildata.del(mailObj)
            onTabSel(current_tab)
               end)
            end)
      else
        local btn_get0 = img.createLogin9Sprite(img.login.button_9_small_gold)
        btn_get0:setPreferredSize(btn_size)
        local lbl_get = lbl.createFont1(18, i18n.global.mail_btn_get.string, m_btn_color)
        lbl_get:setPosition(CCPoint(btn_get0:getContentSize().width / 2, btn_get0:getContentSize().height / 2))
        btn_get0:addChild(lbl_get)
        local btn_get = SpineMenuItem:create(json.ui.button, btn_get0)
        btn_get:setPosition(CCPoint(content_container_w / 2, 34))
        local btn_get_menu = CCMenu:createWithItem(btn_get)
        btn_get_menu:setPosition(CCPoint(0, 0))
        content_container:addChild(btn_get_menu)
        btn_get:registerScriptTapHandler(function()
          audio.play(audio.button)
          addWaitNet()
          maildata.affix({mailObj.mid}, function(l_1_0)
            tbl2string(l_1_0)
            delWaitNet()
            if l_1_0.status ~= 0 then
              showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
              return 
            end
            mailObj.flag = 2
            if l_1_0.affix and l_1_0.affix.items then
              bagdata.items.addAll(l_1_0.affix.items)
              processSpecialHead(l_1_0.affix.items)
            end
            if l_1_0.affix and l_1_0.affix.equips then
              bagdata.equips.addAll(l_1_0.affix.equips)
            end
            if l_1_0.affix then
              CCDirector:sharedDirector():getRunningScene():addChild(rewards.createFloating(l_1_0.affix), 100000)
            end
            onTabSel(TAB.SYS)
               end)
            end)
      end
    else
      local btn_del0 = img.createLogin9Sprite(img.login.button_9_small_gold)
      btn_del0:setPreferredSize(btn_size)
      local lbl_del = lbl.createFont1(18, i18n.global.mail_btn_del.string, m_btn_color)
      lbl_del:setPosition(CCPoint(btn_del0:getContentSize().width / 2, btn_del0:getContentSize().height / 2))
      btn_del0:addChild(lbl_del)
      local btn_del = SpineMenuItem:create(json.ui.button, btn_del0)
      btn_del:setPosition(CCPoint(content_container_w / 2, 34))
      local btn_del_menu = CCMenu:createWithItem(btn_del)
      btn_del_menu:setPosition(CCPoint(0, 0))
      content_container:addChild(btn_del_menu)
      btn_del:registerScriptTapHandler(function()
        audio.play(audio.button)
        addWaitNet()
        maildata.netDel(mailObj, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          if l_1_0.status ~= 0 then
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
            return 
          end
          maildata.del(mailObj)
          onTabSel(current_tab)
            end)
         end)
    end
  end
  scroll.setOffsetBegin()
   end
  local showAffixContent = function(l_5_0)
    showTextContent(l_5_0, true)
   end
  local showPlayerContent = function(l_6_0)
    local txt_bg = img.createUI9Sprite(img.ui.mail_content_bg)
    txt_bg:setPreferredSize(CCSizeMake(406, 356))
    txt_bg:setAnchorPoint(CCPoint(1, 1))
    txt_bg:setPosition(CCPoint(content_container_w, content_container_h))
    content_container:addChild(txt_bg)
    local txt_bg_w = txt_bg:getContentSize().width
    local txt_bg_h = txt_bg:getContentSize().height
    local scroll = createContentScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(17, 10))
    txt_bg:addChild(scroll)
    scroll.addSpace(10)
    local lbl_mail_title = lbl.create({kind = "ttf", size = 20, text = i18n.global.mail_playermail_title.string, color = ccc3(131, 65, 29)})
    lbl_mail_title.ax = 0.5
    lbl_mail_title.px = 190
    scroll.addItem(lbl_mail_title)
    scroll.addSpace(16)
    local lbl_body = lbl.create({kind = "ttf", font = 1, size = 17, text = l_6_0.content, color = ccc3(131, 65, 29), width = 358, align = kCCTextAlignmentLeft})
    lbl_body.ax = 0.5
    lbl_body.px = 190
    scroll.addItem(lbl_body)
    scroll.addSpace(10)
    local lbl_from = lbl.create({kind = "ttf", size = 20, text = l_6_0.from, color = ccc3(131, 65, 29)})
    lbl_from.ax = 1
    lbl_from.px = 367
    scroll.addItem(lbl_from)
    scroll.addSpace(10)
    if l_6_0.content_o then
      local split_dot = "-----------------------------------------------------"
      local split_line_1 = lbl.create({kind = "ttf", size = 17, text = split_dot, color = ccc3(131, 65, 29)})
      split_line_1.ax = 0.5
      split_line_1.px = 190
      scroll.addItem(split_line_1)
      local lbl_o_m = lbl.create({kind = "ttf", size = 17, text = i18n.global.mail_old.string, color = ccc3(131, 65, 29)})
      lbl_o_m:setPosition(CCPoint(split_line_1:getContentSize().width / 2, split_line_1:getContentSize().height / 2))
      split_line_1:addChild(lbl_o_m)
      local mbox = img.createUI9Sprite(img.ui.mail_lbl_bg)
      mbox:setPreferredSize(lbl_o_m:getContentSize())
      mbox:setPosition(CCPoint(lbl_o_m:getContentSize().width / 2, lbl_o_m:getContentSize().height / 2))
      lbl_o_m:addChild(mbox, -1)
      scroll.addSpace(10)
      local lbl_body = lbl.create({kind = "ttf", font = 1, size = 17, text = l_6_0.content_o, color = ccc3(131, 65, 29), width = 358, align = kCCTextAlignmentLeft})
      lbl_body.ax = 0.5
      lbl_body.px = 190
      scroll.addItem(lbl_body)
      scroll.addSpace(10)
    end
    local btn_shield0 = img.createLogin9Sprite(img.login.button_9_small_gold)
    btn_shield0:setPreferredSize(btn_size2)
    local lbl_shield = lbl.createFont1(16, i18n.global.chat_shield.string, m_btn_color)
    lbl_shield:setPosition(CCPoint(btn_shield0:getContentSize().width / 2, btn_shield0:getContentSize().height / 2))
    btn_shield0:addChild(lbl_shield)
    local btn_shield = SpineMenuItem:create(json.ui.button, btn_shield0)
    btn_shield:setPosition(CCPoint(content_container_w / 2 - 135, 34))
    btn_shield:setVisible(false)
    local btn_shield_menu = CCMenu:createWithItem(btn_shield)
    btn_shield_menu:setPosition(CCPoint(0, 0))
    content_container:addChild(btn_shield_menu)
    btn_shield:registerScriptTapHandler(function()
      audio.play(audio.button)
      local dialog = require("ui.dialog")
      local process_dialog = function(l_1_0)
        layer:removeChildByTag(dialog.TAG)
        if l_1_0.selected_btn == 2 then
          addWaitNet()
          maildata.block(mailObj.uid, function(l_1_0)
            delWaitNet()
            tbl2string(l_1_0)
            if l_1_0.status ~= 0 then
              showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
              return 
            end
            maildata.del(mailObj)
            onTabSel(current_tab)
               end)
        elseif l_1_0.selected_btn == 1 then
           -- Warning: missing end command somewhere! Added here
        end
         end
      local params = {title = "", body = i18n.global.chat_sure_shield.string, btn_count = 2, btn_color = {1 = dialog.COLOR_BLUE, 2 = dialog.COLOR_GOLD}, btn_text = {1 = i18n.global.dialog_button_cancel.string, 2 = i18n.global.dialog_button_confirm.string}, callback = process_dialog}
      local dialog_ins = dialog.create(params, true)
      dialog_ins:setAnchorPoint(CCPoint(0, 0))
      dialog_ins:setPosition(CCPoint(0, 0))
      layer:addChild(dialog_ins, 10000, dialog.TAG)
      end)
    local btn_del0 = img.createLogin9Sprite(img.login.button_9_small_gold)
    btn_del0:setPreferredSize(btn_size)
    local lbl_del = lbl.createFont1(18, i18n.global.mail_btn_del.string, m_btn_color)
    lbl_del:setPosition(CCPoint(btn_del0:getContentSize().width / 2, btn_del0:getContentSize().height / 2))
    btn_del0:addChild(lbl_del)
    local btn_del = SpineMenuItem:create(json.ui.button, btn_del0)
    btn_del:setPosition(CCPoint(content_container_w / 2 - 88, 34))
    local btn_del_menu = CCMenu:createWithItem(btn_del)
    btn_del_menu:setPosition(CCPoint(0, 0))
    content_container:addChild(btn_del_menu)
    btn_del:registerScriptTapHandler(function()
      audio.play(audio.button)
      addWaitNet()
      maildata.netDel(mailObj, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        maildata.del(mailObj)
        onTabSel(TAB.INB)
         end)
      end)
    local btn_reply0 = img.createLogin9Sprite(img.login.button_9_small_gold)
    btn_reply0:setPreferredSize(btn_size)
    local lbl_reply = lbl.createFont1(18, i18n.global.mail_btn_reply.string, m_btn_color)
    lbl_reply:setPosition(CCPoint(btn_reply0:getContentSize().width / 2, btn_reply0:getContentSize().height / 2))
    btn_reply0:addChild(lbl_reply)
    local btn_reply = SpineMenuItem:create(json.ui.button, btn_reply0)
    btn_reply:setPosition(CCPoint(content_container_w / 2 + 88, 34))
    local btn_reply_menu = CCMenu:createWithItem(btn_reply)
    btn_reply_menu:setPosition(CCPoint(0, 0))
    content_container:addChild(btn_reply_menu)
    btn_reply:registerScriptTapHandler(function()
      disableObjAWhile(btn_reply, 2)
      audio.play(audio.button)
      if not params then
        upvalue_1024 = {sendto = mailObj.uid, mid = mailObj.mid, tab = TAB.NEW, close = true}
      end
      params.sendto = mailObj.uid or ""
      layer:addChild(require("ui.mail.main").create(params), 1000)
      end)
    local mail_type = maildata.getTypeById(l_6_0.id)
    if mail_type == maildata.TYPE.ALLPLAYER then
      btn_del:setPosition(CCPoint(content_container_w / 2, 34))
      btn_reply:setEnabled(false)
      btn_reply:setVisible(false)
    end
    scroll.setOffsetBegin()
   end
  local showLinkContent = function(l_7_0, l_7_1)
    processMailContent(l_7_0)
    local txt_bg = img.createUI9Sprite(img.ui.mail_content_bg)
    txt_bg:setPreferredSize(CCSizeMake(406, 356))
    txt_bg:setAnchorPoint(CCPoint(1, 1))
    txt_bg:setPosition(CCPoint(content_container_w, content_container_h))
    content_container:addChild(txt_bg)
    local txt_bg_w = txt_bg:getContentSize().width
    local txt_bg_h = txt_bg:getContentSize().height
    local scroll = createContentScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(17, 10))
    txt_bg:addChild(scroll)
    scroll.addSpace(10)
    local lbl_mail_title = lbl.create({kind = "ttf", size = 20, text = l_7_0.title, color = ccc3(131, 65, 29)})
    lbl_mail_title.ax = 0.5
    lbl_mail_title.px = 190
    scroll.addItem(lbl_mail_title)
    scroll.addSpace(16)
    local body1, body2, link_text, link_url = nil, nil, nil, nil
    if l_7_0.content then
      local cont_params = cjson.decode(l_7_0.content)
      if type(cont_params) == "table" and cont_params.content1 then
        body1 = cont_params.content1
      end
      if type(cont_params) == "table" and cont_params.content2 then
        body2 = cont_params.content2
      end
      if type(cont_params) == "table" and cont_params.link_text then
        link_text = cont_params.link_text
      end
      if type(cont_params) == "table" and cont_params.link_url then
        link_url = cont_params.link_url
      end
    end
    if body1 then
      local lbl_body = lbl.create({kind = "ttf", font = 1, size = 17, text = body1, color = ccc3(131, 65, 29), width = 358, align = kCCTextAlignmentLeft})
      lbl_body.ax = 0.5
      lbl_body.px = 190
      scroll.addItem(lbl_body)
      scroll.addSpace(10)
    end
    if link_text and link_url then
      local lbl_body = lbl.create({kind = "ttf", font = 1, size = 17, text = link_text, color = ccc3(0, 0, 240), width = 300, align = kCCTextAlignmentLeft})
      local link_node = CCSprite:create()
      link_node:setContentSize(CCSizeMake(300, lbl_body:getContentSize().height))
      local btn_link0 = CCSprite:create()
      btn_link0:setContentSize(CCSizeMake(300, lbl_body:getContentSize().height))
      local btn_link = CCMenuItemSprite:create(btn_link0, nil)
      btn_link:setPosition(CCPoint(link_node:getContentSize().width / 2, link_node:getContentSize().height / 2))
      local btn_link_menu = CCMenu:createWithItem(btn_link)
      btn_link_menu:setPosition(CCPoint(0, 0))
      link_node:addChild(btn_link_menu)
      lbl_body:setPosition(CCPoint(link_node:getContentSize().width / 2, link_node:getContentSize().height / 2))
      link_node:addChild(lbl_body)
      link_node.ax = 0.5
      link_node.px = 190
      scroll.addItem(link_node)
      scroll.addSpace(10)
      btn_link:registerScriptTapHandler(function()
        audio.play(audio.button)
        device.openURL(link_url)
         end)
    end
    if body2 then
      local lbl_body = lbl.create({kind = "ttf", font = 1, size = 17, text = body2, color = ccc3(131, 65, 29), width = 358, align = kCCTextAlignmentLeft})
      lbl_body.ax = 0.5
      lbl_body.px = 190
      scroll.addItem(lbl_body)
      scroll.addSpace(10)
    end
    local lbl_from = lbl.create({kind = "ttf", size = 20, text = l_7_0.from, color = ccc3(131, 65, 29)})
    lbl_from.ax = 1
    lbl_from.px = 367
    scroll.addItem(lbl_from)
    scroll.addSpace(10)
    if l_7_1 and l_7_0.affix then
      local split_line = img.createUISprite(img.ui.mail_content_split)
      split_line.ax = 0.5
      split_line.px = 190
      scroll.addItem(split_line)
      scroll.addSpace(10)
      local lbl_rewards = lbl.create({font = 1, size = 20, text = i18n.global.mail_rewards.string, color = ccc3(131, 65, 29)})
      lbl_rewards.ax = 0.5
      lbl_rewards.px = 190
      scroll.addItem(lbl_rewards)
      scroll.addSpace(10)
      if l_7_0.flag == 2 then
        local icon_got = img.createUISprite(img.ui.mail_icon_got)
        icon_got:setPosition(CCPoint(335, split_line:getPositionY()))
        split_line:getParent():addChild(icon_got, 10)
      end
      local item_count = 0
      if l_7_0.affix.items then
        item_count = item_count +  l_7_0.affix.items
      end
      if l_7_0.affix.equips then
        item_count = item_count +  l_7_0.affix.equips
      end
      local affix_container_w = 361
      local affix_container_h = math.floor((item_count + 3) / 4) * 92
      do
        local affix_container = CCSprite:create()
        affix_container:setContentSize(CCSizeMake(affix_container_w, affix_container_h))
        local off_x, off_y = 40, affix_container_h - 43
        local off_step = 91
        local item_idx = 0
        if l_7_0.affix.items then
          for _,_obj in ipairs(l_7_0.affix.items) do
            item_idx = item_idx + 1
            local tmp_item0 = img.createItem(_obj.id, _obj.num)
            local tmp_item = CCMenuItemSprite:create(tmp_item0, nil)
            tmp_item:setPosition(CCPoint(off_x + (item_idx - 1) % 4 * off_step, off_y - math.floor((item_idx + 3) / 4 - 1) * off_step))
            local tmp_item_menu = CCMenu:createWithItem(tmp_item)
            tmp_item_menu:setPosition(CCPoint(0, 0))
            affix_container:addChild(tmp_item_menu)
            tmp_item:registerScriptTapHandler(function()
              audio.play(audio.button)
              layer:addChild(tipsitem.createForShow(_obj), 1000)
                  end)
            if l_7_0.flag == 2 then
              setShader(tmp_item, SHADER_GRAY, true)
            end
          end
        end
        if l_7_0.affix.equips then
          for _,_obj in ipairs(l_7_0.affix.equips) do
            item_idx = item_idx + 1
            local tmp_item0 = img.createEquip(_obj.id, _obj.num)
            local tmp_item = CCMenuItemSprite:create(tmp_item0, nil)
            tmp_item:setPosition(CCPoint(off_x + (item_idx - 1) % 4 * off_step, off_y - math.floor((item_idx + 3) / 4 - 1) * off_step))
            local tmp_item_menu = CCMenu:createWithItem(tmp_item)
            tmp_item_menu:setPosition(CCPoint(0, 0))
            affix_container:addChild(tmp_item_menu)
            tmp_item:registerScriptTapHandler(function()
              audio.play(audio.button)
              layer:addChild(tipsequip.createForShow(_obj), 1000)
                  end)
            if l_7_0.flag == 2 then
              setShader(tmp_item, SHADER_GRAY, true)
            end
          end
        end
        affix_container.ax = 0.5
        affix_container.px = 190
        scroll.addItem(affix_container)
        scroll.addSpace(10)
        if l_7_0.flag == 2 then
          local btn_del0 = img.createLogin9Sprite(img.login.button_9_small_gold)
          btn_del0:setPreferredSize(btn_size)
          local lbl_del = lbl.createFont1(18, i18n.global.mail_btn_del.string, m_btn_color)
          lbl_del:setPosition(CCPoint(btn_del0:getContentSize().width / 2, btn_del0:getContentSize().height / 2))
          btn_del0:addChild(lbl_del)
          local btn_del = SpineMenuItem:create(json.ui.button, btn_del0)
          btn_del:setPosition(CCPoint(content_container_w / 2, 34))
          local btn_del_menu = CCMenu:createWithItem(btn_del)
          btn_del_menu:setPosition(CCPoint(0, 0))
          content_container:addChild(btn_del_menu)
          btn_del:registerScriptTapHandler(function()
            audio.play(audio.button)
            addWaitNet()
            maildata.netDel(mailObj, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              if l_1_0.status ~= 0 then
                showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
                return 
              end
              maildata.del(mailObj)
              onTabSel(current_tab)
                  end)
               end)
        else
          local btn_get0 = img.createLogin9Sprite(img.login.button_9_small_gold)
          btn_get0:setPreferredSize(btn_size)
          local lbl_get = lbl.createFont1(18, i18n.global.mail_btn_get.string, m_btn_color)
          lbl_get:setPosition(CCPoint(btn_get0:getContentSize().width / 2, btn_get0:getContentSize().height / 2))
          btn_get0:addChild(lbl_get)
          local btn_get = SpineMenuItem:create(json.ui.button, btn_get0)
          btn_get:setPosition(CCPoint(content_container_w / 2, 34))
          local btn_get_menu = CCMenu:createWithItem(btn_get)
          btn_get_menu:setPosition(CCPoint(0, 0))
          content_container:addChild(btn_get_menu)
          btn_get:registerScriptTapHandler(function()
            audio.play(audio.button)
            addWaitNet()
            maildata.affix({mailObj.mid}, function(l_1_0)
              tbl2string(l_1_0)
              delWaitNet()
              if l_1_0.status ~= 0 then
                showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
                return 
              end
              mailObj.flag = 2
              if l_1_0.affix and l_1_0.affix.items then
                bagdata.items.addAll(l_1_0.affix.items)
                processSpecialHead(l_1_0.affix.items)
              end
              if l_1_0.affix and l_1_0.affix.equips then
                bagdata.equips.addAll(l_1_0.affix.equips)
              end
              if l_1_0.affix then
                CCDirector:sharedDirector():getRunningScene():addChild(rewards.createFloating(l_1_0.affix), 100000)
              end
              onTabSel(TAB.SYS)
                  end)
               end)
        end
      end
    else
      local btn_del0 = img.createLogin9Sprite(img.login.button_9_small_gold)
      btn_del0:setPreferredSize(btn_size)
      local lbl_del = lbl.createFont1(18, i18n.global.mail_btn_del.string, m_btn_color)
      lbl_del:setPosition(CCPoint(btn_del0:getContentSize().width / 2, btn_del0:getContentSize().height / 2))
      btn_del0:addChild(lbl_del)
      local btn_del = SpineMenuItem:create(json.ui.button, btn_del0)
      btn_del:setPosition(CCPoint(content_container_w / 2, 34))
      local btn_del_menu = CCMenu:createWithItem(btn_del)
      btn_del_menu:setPosition(CCPoint(0, 0))
      content_container:addChild(btn_del_menu)
      btn_del:registerScriptTapHandler(function()
        audio.play(audio.button)
        addWaitNet()
        maildata.netDel(mailObj, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          if l_1_0.status ~= 0 then
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
            return 
          end
          maildata.del(mailObj)
          onTabSel(current_tab)
            end)
         end)
    end
  end
  scroll.setOffsetBegin()
   end
  local processMailLink2 = function(l_8_0)
    local mail_body = i18n.mail[l_8_0.id].content
    local cont_arr = string.split(mail_body, "|||")
    local mail_content = {content1 = cont_arr[1], link_text = cont_arr[2], link_url = cont_arr[3], content2 = cont_arr[4]}
    l_8_0.content = cjson.encode(mail_content)
   end
  local showContent = function(l_9_0)
    content_container:removeAllChildrenWithCleanup(true)
    local mail_type = maildata.getTypeById(l_9_0.id)
    if mail_type == maildata.TYPE.AFFIX then
      showAffixContent(l_9_0)
    else
      if mail_type == maildata.TYPE.ACTIVITY then
        showTextContent(l_9_0)
      else
        if mail_type == maildata.TYPE.GUILD then
          showTextContent(l_9_0)
        else
          if mail_type == maildata.TYPE.SYS then
            showTextContent(l_9_0)
          else
            if mail_type == maildata.TYPE.PLAYER then
              showPlayerContent(l_9_0)
            else
              if mail_type == maildata.TYPE.ALLPLAYER then
                showPlayerContent(l_9_0)
              else
                if mail_type == maildata.TYPE.LINK then
                  showLinkContent(l_9_0, true)
                else
                  if mail_type == maildata.TYPE.LINK2 then
                    processMailLink2(l_9_0)
                    showLinkContent(l_9_0, true)
                  end
                end
              end
            end
          end
        end
      end
    end
   end
  local createListScroll = function(l_10_0)
    local scroll_height = 429
    if l_10_0 == TAB.INB then
      scroll_height = 429
    else
      if l_10_0 == TAB.SYS then
        scroll_height = 375
      end
    end
    local scroll_params = {width = 304, height = scroll_height}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local showList = function(l_11_0, l_11_1)
    local list_bg = img.createUI9Sprite(img.ui.mail_list_bg)
    if l_11_1 == TAB.INB then
      list_bg:setPreferredSize(CCSizeMake(314, 435))
    else
      if l_11_1 == TAB.SYS then
        list_bg:setPreferredSize(CCSizeMake(314, 381))
      end
    end
    list_bg:setAnchorPoint(CCPoint(0, 0))
    list_bg:setPosition(CCPoint(0, 0))
    container:addChild(list_bg)
    local scroll = createListScroll(l_11_1)
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(5, 3))
    container:addChild(scroll, 2)
    container.list_scroll = scroll
    arrayclear(items)
    scroll.addSpace(3)
    for ii = 1,  l_11_0 do
      local tmp_item = createItem(l_11_0[ii])
      tmp_item.mailObj = l_11_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = 152
      tmp_item.ay = 0.5
      scroll.addItem(tmp_item)
      items[ items + 1] = tmp_item
      if ii ~=  l_11_0 then
        scroll.addSpace(2)
      end
    end
    scroll.setOffsetBegin()
    if  items > 0 then
      showContent(items[1].mailObj)
      items[1].setRead()
      items[1].focus:setVisible(true)
      upvalue_3584 = items[1]
    end
    if l_11_1 == TAB.SYS then
      local btn_batch_get0 = img.createLogin9Sprite(img.login.button_9_small_gold)
      btn_batch_get0:setPreferredSize(CCSizeMake(258, 47))
      local lbl_batch_get = lbl.createFont1(18, i18n.global.mail_btn_batch.string, ccc3(115, 59, 5))
      lbl_batch_get:setPosition(CCPoint(btn_batch_get0:getContentSize().width / 2, btn_batch_get0:getContentSize().height / 2))
      btn_batch_get0:addChild(lbl_batch_get)
      local btn_batch_get = SpineMenuItem:create(json.ui.button, btn_batch_get0)
      btn_batch_get:setPosition(CCPoint(133, container_h - 23))
      local btn_batch_get_menu = CCMenu:createWithItem(btn_batch_get)
      btn_batch_get_menu:setPosition(CCPoint(0, 0))
      container:addChild(btn_batch_get_menu)
      btn_batch_get:registerScriptTapHandler(function()
        audio.play(audio.button)
        local mids = {}
        for ii = 1,  listObj do
          if listObj[ii].flag ~= 2 and maildata.getTypeById(listObj[ii].id) == 1 then
            mids[ mids + 1] = listObj[ii].mid
          end
        end
        if  mids <= 0 then
          showToast(i18n.global.mail_get_nothing.string)
          return 
        end
        addWaitNet()
        maildata.affix(mids, function(l_1_0)
          tbl2string(l_1_0)
          delWaitNet()
          if l_1_0.status ~= 0 then
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
            return 
          end
          if l_1_0.affix and l_1_0.affix.items then
            bagdata.items.addAll(l_1_0.affix.items)
            processSpecialHead(l_1_0.affix.items)
          end
          if l_1_0.affix and l_1_0.affix.equips then
            bagdata.equips.addAll(l_1_0.affix.equips)
          end
          maildata.flagByMids(mids)
          if l_1_0.affix and layer and not tolua.isnull(layer) then
            layer:addChild(rewards.createFloating(l_1_0.affix))
          end
          onTabSel(TAB.SYS)
            end)
         end)
      local btn_batch_del0 = img.createUISprite(img.ui.mail_icon_del)
      local btn_batch_del = SpineMenuItem:create(json.ui.button, btn_batch_del0)
      btn_batch_del:setPosition(CCPoint(292, container_h - 25))
      local btn_batch_del_menu = CCMenu:createWithItem(btn_batch_del)
      btn_batch_del_menu:setPosition(CCPoint(0, 0))
      container:addChild(btn_batch_del_menu)
      btn_batch_del:registerScriptTapHandler(function()
        audio.play(audio.button)
        coupleBatchDel(layer, function()
          onTabSel(TAB.SYS)
            end)
         end)
    end
   end
  local showNomail = function()
    local icon_nomail = json.create(json.ui.mailbox)
    icon_nomail:playAnimation("animation", -1)
    icon_nomail:setPosition(CCPoint(container_w / 2, container_h / 2))
    container:addChild(icon_nomail)
    local lbl_nomail = lbl.createFont1(18, i18n.global.mail_empty.string, ccc3(147, 108, 84))
    lbl_nomail:setPosition(CCPoint(container_w / 2, container_h / 2 - 28))
    container:addChild(lbl_nomail)
   end
  local createInb = function()
    container:removeAllChildrenWithCleanup(true)
    local maillist = maildata.getPlayerMails()
    if not maillist or  maillist == 0 then
      showNomail()
      return 
    end
    showList(maillist, TAB.INB)
   end
  local createSys = function()
    container:removeAllChildrenWithCleanup(true)
    local maillist = maildata.getSysMails()
    if not maillist or  maillist == 0 then
      showNomail()
      return 
    end
    showList(maillist, TAB.SYS)
   end
  local createNew = function()
    tab_inb:setVisible(false)
    tab_inb_hl:setVisible(false)
    tab_sys:setVisible(false)
    tab_sys_hl:setVisible(false)
    tab_new:setVisible(false)
    tab_new_hl:setVisible(false)
    arrayclear(items)
    container:removeAllChildrenWithCleanup(true)
    local new_bg = img.createUI9Sprite(img.ui.mail_new_bg)
    new_bg:setPreferredSize(CCSizeMake(704, 356))
    new_bg:setPosition(CCPoint(container_w / 2 - 5, 238))
    container:addChild(new_bg)
    local new_bg_w = new_bg:getContentSize().width
    local new_bg_h = new_bg:getContentSize().height
    local lbl_addr = lbl.createFont1(18, i18n.global.mail_address.string, ccc3(100, 48, 22))
    lbl_addr:setAnchorPoint(CCPoint(0, 0))
    lbl_addr:setPosition(CCPoint(36, 322))
    new_bg:addChild(lbl_addr)
    local sprite_addr_input = img.createLogin9Sprite(img.login.input_border)
    sprite_addr_input:setPreferredSize(CCSizeMake(636, 52))
    sprite_addr_input:setPosition(CCPoint(new_bg_w / 2, 291))
    new_bg:addChild(sprite_addr_input)
    local lbl_addr_input = CCLabelTTF:create(params and params.sendto or "", "", 18)
    lbl_addr_input:setColor(ccc3(100, 48, 22))
    lbl_addr_input:setAnchorPoint(CCPoint(0, 0.5))
    lbl_addr_input:setPosition(CCPoint(17, sprite_addr_input:getContentSize().height / 2))
    sprite_addr_input:addChild(lbl_addr_input)
    local lbl_content = lbl.createFont1(18, i18n.global.mail_content.string, ccc3(100, 48, 22))
    lbl_content:setAnchorPoint(CCPoint(0, 0))
    lbl_content:setPosition(CCPoint(36, 235))
    new_bg:addChild(lbl_content)
    local sprite_content_input = img.createLogin9Sprite(img.login.input_border)
    sprite_content_input:setPreferredSize(CCSizeMake(636, 202))
    sprite_content_input:setPosition(CCPoint(new_bg_w / 2, 130))
    new_bg:addChild(sprite_content_input)
    local lbl_content_input = CCLabelTTF:create(params and params.content or "", "", 18)
    lbl_content_input:setColor(ccc3(100, 48, 22))
    lbl_content_input:setHorizontalAlignment(kCCTextAlignmentLeft)
    lbl_content_input:setDimensions(CCSizeMake(602, 168))
    lbl_content_input:setAnchorPoint(CCPoint(0.5, 1))
    lbl_content_input:setPosition(CCPoint(sprite_content_input:getContentSize().width / 2, 185))
    sprite_content_input:addChild(lbl_content_input)
    local onAddrClick = function(l_1_0)
      local addr_str = l_1_0 or ""
      addr_str = string.trim(addr_str)
      if addr_str == "" then
        do return end
      end
      if containsInvalidChar(addr_str) then
        showToast(i18n.global.input_invalid_char.string)
        return 
      end
      lbl_addr_input:setString(addr_str)
      end
    local onContentClick = function(l_2_0)
      local content_str = l_2_0 or ""
      content_str = string.trim(content_str)
      if content_str == "" then
        do return end
      end
      if containsInvalidChar(content_str) then
        showToast(i18n.global.input_invalid_char.string)
        return 
      end
      lbl_content_input:setString(content_str)
      upvalue_1024 = content_str
      end
    local touchInputBeginx, touchInputBeginy, isClickInput = nil, nil, nil
    local onTouchInputBegan = function(l_3_0, l_3_1)
      touchInputBeginx, upvalue_512 = l_3_0, l_3_1
      upvalue_1024 = true
      return true
      end
    local onTouchInputMoved = function(l_4_0, l_4_1)
      if isClickInput and (math.abs(touchInputBeginx - l_4_0) > 10 or math.abs(touchInputBeginy - l_4_1) > 10) then
        isClickInput = false
      end
      end
    local onTouchInputEnded = function(l_5_0, l_5_1)
      if isClickInput then
        local p0 = new_bg:convertToNodeSpace(ccp(l_5_0, l_5_1))
        if sprite_addr_input:boundingBox():containsPoint(p0) then
          return 
          do return end
          if params and params.sendto and params.sendto == "@all" then
            return 
          end
          local inputlayer = require("ui.inputlayer")
          layer:addChild(inputlayer.create(onAddrClick, lbl_addr_input:getString()), 10000)
        else
          if sprite_content_input:boundingBox():containsPoint(p0) then
            local inputlayer = require("ui.inputlayer")
            layer:addChild(inputlayer.create(onContentClick, lbl_content_input:getString(), {maxLen = 300}), 10000)
          end
        end
      end
      end
    local onTouchInput = function(l_6_0, l_6_1, l_6_2)
      if l_6_0 == "began" then
        return onTouchInputBegan(l_6_1, l_6_2)
      elseif l_6_0 == "moved" then
        return onTouchInputMoved(l_6_1, l_6_2)
      else
        return onTouchInputEnded(l_6_1, l_6_2)
      end
      end
    new_bg:registerScriptTouchHandler(onTouchInput, false, -128, false)
    new_bg:setTouchEnabled(true)
    local btn_send0 = img.createLogin9Sprite(img.login.button_9_small_gold)
    btn_send0:setPreferredSize(CCSizeMake(192, 46))
    local lbl_send = lbl.createFont1(20, i18n.global.mail_btn_send.string, ccc3(100, 48, 22))
    lbl_send:setPosition(CCPoint(btn_send0:getContentSize().width / 2, btn_send0:getContentSize().height / 2))
    btn_send0:addChild(lbl_send)
    local btn_send = SpineMenuItem:create(json.ui.button, btn_send0)
    btn_send:setPosition(CCPoint(container_w / 2, 25))
    local btn_send_menu = CCMenu:createWithItem(btn_send)
    btn_send_menu:setPosition(CCPoint(0, 0))
    container:addChild(btn_send_menu)
    btn_send:registerScriptTapHandler(function()
      audio.play(audio.button)
      if maildata.last_sent and os.time() - maildata.last_sent < 30 then
        showToast(string.format(i18n.global.mail_interval.string, 30 - (os.time() - maildata.last_sent)))
        return 
      end
      local mailto = string.trim(lbl_addr_input:getString())
      if not mailto or mailto == "" then
        showToast(i18n.global.mail_address_empty.string)
        return 
      end
      if mailto == "@all" then
        mailto = 0
      else
        if string.len(mailto) ~= 8 then
          showToast(i18n.global.mail_invalid_uid.string)
          return 
        end
      end
      if mailto ~= 0 then
        mailto = checkint(mailto)
        if mailto == 0 then
          showToast(i18n.global.mail_invalid_uid.string)
          return 
        end
      end
      local mailcontent = string.trim(lbl_content_input:getString())
      if not mailcontent or mailcontent == "" then
        showToast(i18n.global.mail_content_empty.string)
        return 
      end
      if isBanWord(mailto) then
        showToast(i18n.global.input_invalid_char.string)
        return 
      end
      if isBanWord(mailcontent) then
        showToast(i18n.global.input_invalid_char.string)
        return 
      end
      addWaitNet()
      local mail_params = {sid = player.sid, uid = mailto, content = mailcontent, mid = params and params.mid or nil}
      maildata.send(mail_params, function(l_1_0)
        tbl2string(l_1_0)
        delWaitNet()
        if l_1_0.status ~= 0 then
          if l_1_0.status == -1 or l_1_0.status == -2 then
            showToast(i18n.global.permission_denied.string)
            return 
          end
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        maildata.last_sent = os.time()
        showToast(i18n.global.mail_send_ok.string)
        upvalue_1024 = nil
        if params and params.close then
          upvalue_2048 = TAB.INB
          layer:removeFromParentAndCleanup(true)
        else
          onTabSel(TAB.INB)
        end
         end)
      end)
   end
  local tabs = {}
  tabs[TAB.INB] = {btn = tab_inb, hl = tab_inb_hl}
  tabs[TAB.SYS] = {btn = tab_sys, hl = tab_sys_hl}
  tabs[TAB.NEW] = {btn = tab_new, hl = tab_new_hl}
  tab_new:setVisible(false)
  tab_new_hl:setVisible(false)
  local doTabSel = function(l_16_0)
    if not container or tolua.isnull(container) then
      return 
    end
    container:removeAllChildrenWithCleanup(true)
    content_container:removeAllChildrenWithCleanup(true)
    container.list_scroll = nil
    for _,_obj in ipairs(tabs) do
      _obj.btn:setEnabled(true)
      _obj.hl:setVisible(false)
    end
    upvalue_1536 = l_16_0
    if l_16_0 == TAB.INB then
      tab_inb:setEnabled(false)
      tab_inb_hl:setVisible(true)
      lbl_title:setString(titles[TAB.INB])
      createInb()
    else
      if l_16_0 == TAB.SYS then
        tab_sys:setEnabled(false)
        tab_sys_hl:setVisible(true)
        lbl_title:setString(titles[TAB.SYS])
        createSys()
      else
        if l_16_0 == TAB.NEW then
          tab_new:setVisible(false)
          tab_new_hl:setVisible(false)
          lbl_title:setString(titles[TAB.NEW])
          createNew()
        end
      end
    end
   end
  onTabSel = function(l_17_0)
    if current_tab == TAB.NEW and l_17_0 ~= TAB.NEW then
      dropConfirm(layer, function()
      doTabSel(which)
      end)
    else
      doTabSel(l_17_0)
    end
   end
  onTabSel(current_tab)
  if l_6_0 and l_6_0.sendto and l_6_0.sendto == "@all" then
    tab_inb:setVisible(false)
    tab_sys:setVisible(false)
    tab_new:setVisible(false)
    tab_inb_hl:setVisible(false)
    tab_sys_hl:setVisible(false)
    tab_new_hl:setVisible(false)
    board:setPosition(view.midX, view.midY)
  elseif l_6_0 and l_6_0.tab and l_6_0.tab == TAB.NEW then
    tab_inb:setVisible(false)
    tab_sys:setVisible(false)
    tab_new:setVisible(false)
    tab_inb_hl:setVisible(false)
    tab_sys_hl:setVisible(false)
    tab_new_hl:setVisible(false)
    board:setPosition(view.midX, view.midY)
  end
  tab_inb:registerScriptTapHandler(function()
    audio.play(audio.button)
    onTabSel(TAB.INB)
   end)
  tab_sys:registerScriptTapHandler(function()
    audio.play(audio.button)
    onTabSel(TAB.SYS)
   end)
  tab_new:registerScriptTapHandler(function()
    audio.play(audio.button)
    onTabSel(TAB.NEW)
   end)
  local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
  local onTouchBegan = function(l_21_0, l_21_1)
    touchbeginx, upvalue_512 = l_21_0, l_21_1
    upvalue_1024 = true
    if current_tab ~= TAB.NEW and container.list_scroll and not tolua.isnull(container.list_scroll) then
      local obj = container.list_scroll.content_layer
      local p0 = obj:convertToNodeSpace(ccp(l_21_0, l_21_1))
      for ii = 1,  items do
        if items[ii]:boundingBox():containsPoint(p0) then
          playAnimTouchBegin(items[ii])
          upvalue_3584 = items[ii]
        end
      end
    end
    return true
   end
  local onTouchMoved = function(l_22_0, l_22_1)
    if isclick and (math.abs(touchbeginx - l_22_0) > 10 or math.abs(touchbeginy - l_22_1) > 10) then
      isclick = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        playAnimTouchEnd(last_touch_sprite)
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_23_0, l_23_1)
    if isclick and current_tab ~= TAB.NEW then
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        playAnimTouchEnd(last_touch_sprite)
        upvalue_1536 = nil
      end
      if container.list_scroll and not tolua.isnull(container.list_scroll) then
        local obj = container.list_scroll.content_layer
        local p0 = obj:convertToNodeSpace(ccp(l_23_0, l_23_1))
        for ii = 1,  items do
          if items[ii]:boundingBox():containsPoint(p0) and last_selet_item ~= items[ii] then
            audio.play(audio.button)
            if last_selet_item then
              last_selet_item.focus:setVisible(false)
            end
            items[ii].focus:setVisible(true)
            upvalue_3072 = items[ii]
            showContent(items[ii].mailObj)
            items[ii].setRead()
          end
        end
      end
    end
   end
  local onTouch = function(l_24_0, l_24_1, l_24_2)
    if l_24_0 == "began" then
      return onTouchBegan(l_24_1, l_24_2)
    elseif l_24_0 == "moved" then
      return onTouchMoved(l_24_1, l_24_2)
    else
      return onTouchEnded(l_24_1, l_24_2)
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
  layer:registerScriptHandler(function(l_28_0)
    if l_28_0 == "enter" then
      onEnter()
    elseif l_28_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

