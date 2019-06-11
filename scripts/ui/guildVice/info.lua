-- Command line was: E:\github\dhgametool\scripts\ui\guildVice\info.lua 

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
local cfgguildboss = require("config.guildboss")
local player = require("data.player")
local bagdata = require("data.bag")
local gdata = require("data.guild")
local gbossdata = require("data.gboss")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local dialog = require("ui.dialog")
local rewards = require("ui.reward")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local fight_cost = {0 = 0, 1 = 0, 2 = 40, 3 = 80}
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY * 0.6))
  layer:addChild(darkbg)
  local board = img.createUI9Sprite(img.ui.dialog_1)
  board:setPreferredSize(CCSizeMake(784, 486))
  board:setScale(view.minScale)
  board:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local bossid = gbossdata.id
  local lbl_title = lbl.createFont1(24, i18n.global.guildvice_info_title.string .. bossid, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_w / 2, board_h - 29))
  board:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.guildvice_info_title.string .. bossid, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_w / 2, board_h - 31))
  board:addChild(lbl_title_shadowD)
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
  layer.btn_close = btn_close
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local card = CCSprite:create()
  card:setContentSize(CCSizeMake(218, 256))
  local card_w = card:getContentSize().width
  local card_h = card:getContentSize().height
  local card_box = img.createUI9Sprite(img.ui.guildvice_card_box)
  card_box:setPreferredSize(CCSizeMake(196, 215))
  card_box:setAnchorPoint(CCPoint(0.5, 1))
  card_box:setPosition(CCPoint(card_w / 2, card_h))
  card:addChild(card_box)
  local card_bg = img.createViceMap(cfgguildboss[bossid].show)
  card_bg:setAnchorPoint(CCPoint(0.5, 0.5))
  card_bg:setPosition(CCPoint(card_box:getContentSize().width / 2, card_box:getContentSize().height / 2))
  card_box:addChild(card_bg, -1)
  local card_lbl = img.createUISprite(img.ui.guildvice_card_lbl)
  card_lbl:setAnchorPoint(CCPoint(0.5, 0))
  card_lbl:setPosition(CCPoint(card_w / 2, 0))
  card:addChild(card_lbl)
  local power_icon = img.createUISprite(img.ui.power_icon)
  power_icon:setScale(0.4)
  power_icon:setPosition(CCPoint(68, 23))
  card_lbl:addChild(power_icon)
  local lbl_seq = lbl.createFont2(16, "" .. num2KM(cfgguildboss[bossid].power), ccc3(255, 246, 223))
  lbl_seq:setPosition(CCPoint(card_lbl:getContentSize().width / 2 + 14, 23))
  card_lbl:addChild(lbl_seq)
  card:setPosition(CCPoint(135, 293))
  board:addChild(card)
  local btn_drop0 = img.createUISprite(img.ui.guildvice_icon_drop)
  local btn_drop = SpineMenuItem:create(json.ui.button, btn_drop0)
  btn_drop:setPosition(CCPoint(card_w - 42, card_h - 33))
  local btn_drop_menu = CCMenu:createWithItem(btn_drop)
  btn_drop_menu:setPosition(CCPoint(0, 0))
  card:addChild(btn_drop_menu, 1000)
  btn_drop:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.guildVice.drop").create({bossid = bossid}), 1000)
   end)
  local pgb_bg = img.createUI9Sprite(img.ui.guildvice_hp_bg)
  pgb_bg:setPreferredSize(CCSizeMake(195, 20))
  pgb_bg:setPosition(CCPoint(135, 140))
  board:addChild(pgb_bg)
  local pgb_fg = img.createUISprite(img.ui.guildvice_hp_fg)
  local pgb = createProgressBar(pgb_fg)
  pgb:setPosition(CCPoint(pgb_bg:getContentSize().width / 2, pgb_bg:getContentSize().height / 2))
  pgb_bg:addChild(pgb)
  pgb:setPercentage(gbossdata.hpp)
  local lbl_hpp = lbl.createFont2(14, gbossdata.hpp .. "%")
  lbl_hpp:setPosition(CCPoint(pgb_bg:getContentSize().width / 2, 18))
  pgb_bg:addChild(lbl_hpp, 2)
  local lbl_cd = lbl.createFont2(16, "", ccc3(181, 255, 94))
  lbl_cd:setPosition(CCPoint(135, 112))
  board:addChild(lbl_cd)
  local btn_fight0 = img.createUISprite(img.ui.guildvice_btn_fight)
  local lbl_fight = lbl.createFont1(22, i18n.global.guildvice_info_fight.string, ccc3(97, 52, 42))
  lbl_fight:setPosition(CCPoint(btn_fight0:getContentSize().width / 2, btn_fight0:getContentSize().height / 2))
  btn_fight0:addChild(lbl_fight)
  local btn_fight = SpineMenuItem:create(json.ui.button, btn_fight0)
  btn_fight:setPosition(CCPoint(135, 64))
  local btn_fight_menu = CCMenu:createWithItem(btn_fight)
  btn_fight_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_fight_menu)
  btn_fight:setVisible(false)
  local btn_rise0 = img.createLogin9Sprite(img.login.button_9_small_green)
  btn_rise0:setPreferredSize(CCSizeMake(195, 70))
  local lbl_rise = lbl.createFont1(18, i18n.global.guildvice_info_rise.string, ccc3(29, 103, 0))
  lbl_rise:setPosition(CCPoint(btn_rise0:getContentSize().width / 2, 50))
  btn_rise0:addChild(lbl_rise)
  local icon_gem = img.createItemIcon2(ITEM_ID_GEM)
  icon_gem:setPosition(CCPoint(70, 25))
  btn_rise0:addChild(icon_gem)
  local lbl_cost = lbl.createFont2(22, "")
  lbl_cost:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cost:setPosition(CCPoint(93, 23))
  btn_rise0:addChild(lbl_cost)
  local btn_rise = SpineMenuItem:create(json.ui.button, btn_rise0)
  btn_rise:setPosition(CCPoint(135, 64))
  local btn_rise_menu = CCMenu:createWithItem(btn_rise)
  btn_rise_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_rise_menu)
  btn_rise:setVisible(false)
  local updateBtns = function()
    if gbossdata.fights <= 0 then
      lbl_cd:setVisible(false)
      btn_rise:setVisible(false)
      btn_fight:setVisible(true)
    else
      if gbossdata.fights >= 1 and gbossdata.fights <= 3 then
        lbl_cd:setVisible(true)
        lbl_cost:setString(fight_cost[gbossdata.fights])
        btn_rise:setVisible(true)
        btn_fight:setVisible(false)
      else
        lbl_cd:setVisible(true)
        btn_rise:setVisible(false)
        setShader(btn_fight, SHADER_GRAY, true)
        btn_fight:setEnabled(false)
        btn_fight:setVisible(true)
      end
    end
   end
  updateBtns()
  btn_fight:registerScriptTapHandler(function()
    disableObjAWhile(btn_fight)
    audio.play(audio.button)
    layer:addChild(require("ui.selecthero.main").create({type = "guildVice", id = bossid, gems = 0}))
   end)
  btn_rise:registerScriptTapHandler(function()
    disableObjAWhile(btn_rise)
    audio.play(audio.button)
    local cost_gem = 0
    if gbossdata.fights <= 3 then
      cost_gem = fight_cost[gbossdata.fights]
    else
      return 
    end
    if bagdata.gem() < cost_gem then
      showToast(i18n.global.summon_gem_lack.string)
      return 
    end
    layer:addChild(require("ui.selecthero.main").create({type = "guildVice", id = bossid, gems = cost_gem}))
   end)
  local dmg_board = img.createUI9Sprite(img.ui.inner_bg)
  dmg_board:setPreferredSize(CCSizeMake(500, 365))
  dmg_board:setAnchorPoint(CCPoint(0.5, 0))
  dmg_board:setPosition(CCPoint(504, 30))
  board:addChild(dmg_board)
  local lbl_dmg_title = lbl.createFont1(18, i18n.global.guildvice_info_rank.string, ccc3(97, 52, 42))
  lbl_dmg_title:setPosition(CCPoint(504, 412))
  board:addChild(lbl_dmg_title)
  local lineScroll = require("ui.lineScroll")
  local scroll_params = {width = 500, height = 361}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(0, 2))
  dmg_board:addChild(scroll)
  local createItem = function(l_7_0, l_7_1)
    local item = img.createUI9Sprite(img.ui.botton_fram_2)
    item:setPreferredSize(CCSizeMake(485, 74))
    local item_w = item:getContentSize().width
    local item_h = item:getContentSize().height
    local tmp_rank = nil
    if l_7_1 == 1 then
      tmp_rank = img.createUISprite(img.ui.arena_rank_1)
    elseif l_7_1 == 2 then
      tmp_rank = img.createUISprite(img.ui.arena_rank_2)
    elseif l_7_1 == 3 then
      tmp_rank = img.createUISprite(img.ui.arena_rank_3)
    else
      tmp_rank = lbl.createFont1(14, "" .. l_7_1, ccc3(148, 98, 66))
    end
    tmp_rank:setPosition(CCPoint(42, item_h / 2))
    item:addChild(tmp_rank)
    local head = img.createPlayerHead(l_7_0.logo)
    head:setScale(0.53)
    head:setPosition(CCPoint(109, item_h / 2 + 1))
    item:addChild(head)
    local lv_bg = img.createUISprite(img.ui.main_lv_bg)
    lv_bg:setPosition(CCPoint(161, item_h / 2))
    item:addChild(lv_bg)
    local lbl_mem_lv = lbl.createFont1(14, l_7_0.lv)
    lbl_mem_lv:setPosition(CCPoint(lv_bg:getContentSize().width / 2, lv_bg:getContentSize().height / 2))
    lv_bg:addChild(lbl_mem_lv)
    local lbl_mem_name = lbl.createFontTTF(20, l_7_0.name, ccc3(97, 52, 42))
    lbl_mem_name:setAnchorPoint(CCPoint(0, 0.5))
    lbl_mem_name:setPosition(CCPoint(188, item_h / 2))
    item:addChild(lbl_mem_name)
    local lbl_hurt = lbl.createFont1(16, "" .. num2KM(l_7_0.hurt), ccc3(156, 69, 45))
    lbl_hurt:setAnchorPoint(CCPoint(1, 0.5))
    lbl_hurt:setPosition(CCPoint(437, item_h / 2))
    item:addChild(lbl_hurt)
    return item
   end
  local showList = function(l_8_0)
    if not l_8_0 or #l_8_0 <= 0 then
      local ui_empty = require("ui.empty").create({text = i18n.global.empty_guildvive.string})
      ui_empty:setPosition(CCPoint(250, 183))
      dmg_board:addChild(ui_empty)
      return 
    end
    scroll.addSpace(6)
    for ii = 1, #l_8_0 do
      local tmp_item = createItem(l_8_0[ii], ii)
      tmp_item.ax = 0.5
      tmp_item.px = 250
      scroll.addItem(tmp_item)
      scroll.addSpace(2)
    end
    scroll.setOffsetBegin()
   end
  showList(l_1_0.data)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  local updateCD = function()
    local boss_cd = gbossdata.cd
    local remain_cd = boss_cd - (os.time() - gbossdata.pull_time)
    if remain_cd >= 0 then
      lbl_cd:setVisible(true)
      local time_str = time2string(remain_cd)
      lbl_cd:setString(time_str)
    else
      lbl_cd:setVisible(false)
      gbossdata.fights = 0
      gbossdata.cd = 57600
      gbossdata.pull_time = os.time()
      updateBtns()
    end
   end
  local last_update = os.time()
  local onUpdate = function(l_10_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    updateCD()
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  return layer
end

return ui

