-- Command line was: E:\github\dhgametool\scripts\ui\town\mainui.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local particle = require("res.particle")
local player = require("data.player")
local bagdata = require("data.bag")
local gdata = require("data.guild")
local onlinedata = require("data.online")
local bag = require("data.bag")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local rewards = require("ui.reward")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local shortcut = require("common.shortcutmgr")
local btn_color = ccc3(255, 246, 223)
local btn_color2 = ccc3(255, 237, 114)
local btn_color3 = ccc3(255, 246, 223)
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local mask_topL = img.createUISprite(img.ui.main_mask_topL)
  mask_topL:setScaleX(view.xScale)
  mask_topL:setScaleY(view.yScale)
  mask_topL:setAnchorPoint(CCPoint(0, 1))
  mask_topL:setPosition(ccp(0, view.physical.h))
  layer:addChild(mask_topL)
  local mask_topR = img.createUISprite(img.ui.main_mask_topL)
  mask_topR:setFlipX(true)
  mask_topR:setScaleX(view.xScale)
  mask_topR:setScaleY(view.yScale)
  mask_topR:setAnchorPoint(CCPoint(1, 1))
  mask_topR:setPosition(ccp(view.physical.w, view.physical.h))
  layer:addChild(mask_topR)
  local mask_bottom = img.createUISprite(img.ui.main_mask_bottom)
  mask_bottom:setScaleX(view.physical.w / 6)
  mask_bottom:setScaleY(view.minScale)
  mask_bottom:setAnchorPoint(CCPoint(0, 0))
  mask_bottom:setPosition(ccp(0, 0))
  layer:addChild(mask_bottom)
  local entry_offset = 120
  local top_container = CCSprite:create()
  top_container:setContentSize(CCSizeMake(960, 576))
  top_container:setScale(view.minScale)
  top_container:setPosition(scalep(480, 288 + entry_offset))
  layer:addChild(top_container)
  local right_container = CCSprite:create()
  right_container:setContentSize(CCSizeMake(960, 576))
  right_container:setScale(view.minScale)
  right_container:setPosition(scalep(480 + entry_offset, 288))
  layer:addChild(right_container)
  local bottom_container = CCSprite:create()
  bottom_container:setContentSize(CCSizeMake(960, 576))
  bottom_container:setScale(view.minScale)
  bottom_container:setPosition(scalep(480, 288 - entry_offset))
  layer:addChild(bottom_container)
  local left_container = CCSprite:create()
  left_container:setContentSize(CCSizeMake(960, 576))
  left_container:setScale(view.minScale)
  left_container:setPosition(scalep(480 - entry_offset, 288))
  layer:addChild(left_container)
  local main_list_bg = img.createUI9Sprite(img.ui.main_list_bg)
  main_list_bg:setPreferredSize(CCSizeMake(80, 388))
  main_list_bg:setAnchorPoint(CCPoint(0.5, 1))
  main_list_bg:setPosition(CCPoint(915, 569))
  right_container:addChild(main_list_bg)
  local btn_list_fold0 = img.createUISprite(img.ui.main_btn_fold)
  local btn_list_unfold0 = img.createUISprite(img.ui.main_btn_unfold)
  local btn_list_fold = SpineMenuItem:create(json.ui.button, btn_list_fold0)
  btn_list_fold:setPosition(CCPoint(915, 546))
  local btn_list_fold_menu = CCMenu:createWithItem(btn_list_fold)
  btn_list_fold_menu:setPosition(CCPoint(0, 0))
  right_container:addChild(btn_list_fold_menu)
  local btn_list_unfold = SpineMenuItem:create(json.ui.button, btn_list_unfold0)
  btn_list_unfold:setPosition(CCPoint(915, 546))
  local btn_list_unfold_menu = CCMenu:createWithItem(btn_list_unfold)
  btn_list_unfold_menu:setPosition(CCPoint(0, 0))
  right_container:addChild(btn_list_unfold_menu)
  btn_list_unfold:setVisible(false)
  autoLayoutShift(main_list_bg)
  autoLayoutShift(btn_list_fold)
  autoLayoutShift(btn_list_unfold)
  local player_bg = CCSprite:create()
  player_bg:setContentSize(CCSizeMake(82, 111))
  player_bg:setAnchorPoint(CCPoint(0, 1))
  player_bg:setPosition(CCPoint(0, 576))
  top_container:addChild(player_bg)
  autoLayoutShift(player_bg)
  local btn_logo0 = CCSprite:create()
  btn_logo0:setContentSize(CCSizeMake(78, 78))
  local head_bg = img.createUISprite(img.ui.head_bg)
  head_bg:setPosition(CCPoint(39, 39))
  btn_logo0:addChild(head_bg)
  local btn_logo = HHMenuItem:createWithScale(btn_logo0, 1)
  btn_logo:setPosition(CCPoint(40, 70))
  local btn_logo_menu = CCMenu:createWithItem(btn_logo)
  btn_logo_menu:setPosition(CCPoint(0, 0))
  player_bg:addChild(btn_logo_menu)
  if player.final_rank then
    addHeadBox(btn_logo, player.final_rank, 122)
  end
  addRedDot(btn_logo, {px = btn_logo:getContentSize().width - 5, py = btn_logo:getContentSize().height - 5})
  delRedDot(btn_logo)
  local updateLogo = function()
    if not btn_logo.logo or player.logo ~= btn_logo.logo then
      if btn_logo:getChildByTag(111) then
        btn_logo:removeChildByTag(111)
      end
      local player_logo = img.createPlayerHeadById(player.logo)
      local cfghead = require("config.head")
      local cfghero = require("config.hero")
      if cfghead[player.logo] and cfghead[player.logo].isShine then
        json.load(json.ui.touxiang)
        aniTouxiang = DHSkeletonAnimation:createWithKey(json.ui.touxiang)
        aniTouxiang:scheduleUpdateLua()
        aniTouxiang:playAnimation("animation", -1)
        aniTouxiang:setAnchorPoint(CCPoint(0.5, 0))
        aniTouxiang:setPosition(player_logo:getContentSize().width / 2, player_logo:getContentSize().height / 2)
        player_logo:addChild(aniTouxiang)
      else
        if not cfghead[player.logo] and cfghero[player.logo] and cfghero[player.logo].maxStar == 10 then
          json.load(json.ui.touxiang)
          aniTouxiang = DHSkeletonAnimation:createWithKey(json.ui.touxiang)
          aniTouxiang:scheduleUpdateLua()
          aniTouxiang:playAnimation("animation", -1)
          aniTouxiang:setAnchorPoint(CCPoint(0.5, 0))
          aniTouxiang:setPosition(player_logo:getContentSize().width / 2, player_logo:getContentSize().height / 2)
          player_logo:addChild(aniTouxiang)
        end
      end
      player_logo:setScale(0.9)
      player_logo:setPosition(CCPoint(btn_logo:getContentSize().width / 2, btn_logo:getContentSize().height / 2))
      btn_logo:addChild(player_logo, 111, 111)
      btn_logo.logo = player.logo
      btn_logo.player_logo = player_logo
    end
   end
  btn_logo:registerScriptTapHandler(function()
    layer:addChild(require("ui.player.main").create(), 1000)
    audio.play(audio.button)
   end)
  updateLogo()
  local main_lt = img.createUISprite(img.ui.main_lt)
  main_lt:setAnchorPoint(CCPoint(0, 1))
  main_lt:setPosition(CCPoint(0, 576))
  top_container:addChild(main_lt, 5)
  autoLayoutShift(main_lt)
  local player_lv_bg = img.createUISprite(img.ui.main_lv_bg)
  player_lv_bg:setAnchorPoint(CCPoint(0.5, 0.5))
  player_lv_bg:setPosition(CCPoint(19, 42))
  player_bg:addChild(player_lv_bg)
  local lbl_player_lv = lbl.createFont2(14, "" .. player.lv())
  lbl_player_lv:setPosition(CCPoint(player_lv_bg:getContentSize().width / 2, player_lv_bg:getContentSize().height / 2))
  player_lv_bg:addChild(lbl_player_lv)
  lbl_player_lv.lv = player.lv()
  local vip_a = {1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4}
  vip_a[0] = 1
  local vip_c1 = ccc3(255, 209, 121)
  local vip_c2 = ccc3(232, 251, 255)
  local vip_c3 = ccc3(255, 244, 120)
  local vip_c4 = ccc3(138, 248, 255)
  local vip_c = {vip_c1, vip_c1, vip_c1, vip_c2, vip_c2, vip_c2, vip_c3, vip_c3, vip_c3, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4, vip_c4}
  vip_c[0] = vip_c1
  json.load(json.ui.ic_vip)
  local vip_bg = CCSprite:create()
  vip_bg:setContentSize(CCSizeMake(58, 58))
  local ic_vip = DHSkeletonAnimation:createWithKey(json.ui.ic_vip)
  ic_vip:scheduleUpdateLua()
  ic_vip:playAnimation("" .. vip_a[player.vipLv()], -1)
  ic_vip:setPosition(CCPoint(29, 29))
  vip_bg:addChild(ic_vip)
  local useless_node = CCNode:create()
  local lbl_player_vip = lbl.createFont2(18, player.vipLv(), ccc3(255, 220, 130))
  lbl_player_vip:setColor(vip_c[player.vipLv()])
  useless_node:addChild(lbl_player_vip)
  ic_vip:addChildFollowSlot("code_num", useless_node)
  lbl_player_vip.vip = player.vipLv()
  local btn_vip = SpineMenuItem:create(json.ui.button, vip_bg)
  btn_vip:setPosition(CCPoint(41, 0))
  local btn_vip_menu = CCMenu:createWithItem(btn_vip)
  btn_vip_menu:setPosition(CCPoint(0, 0))
  player_bg:addChild(btn_vip_menu)
  btn_vip:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.shop.main").create("vip"), 1000)
   end)
  if player.vipLv() < 1 then
    btn_vip:setVisible(false)
  end
  local moneybar = require("ui.moneybar")
  local moneybar_ins = moneybar.create()
  local moneyContainer = CCNode:create()
  moneyContainer:addChild(moneybar_ins)
  moneyContainer:setPosition(0, entry_offset)
  layer:addChild(moneyContainer, 100)
  local shop_bg = CCSprite:create()
  shop_bg:setContentSize(CCSizeMake(99, 110))
  shop_bg:setAnchorPoint(CCPoint(1, 0))
  shop_bg:setPosition(CCPoint(960, 0))
  bottom_container:addChild(shop_bg)
  autoLayoutShift(shop_bg)
  local btn_shop0 = img.createUISprite(img.ui.main_btn_shop)
  local btn_shop = HHMenuItem:createWithScale(btn_shop0, 1)
  btn_shop:setPosition(CCPoint(shop_bg:getContentSize().width - 54, shop_bg:getContentSize().height - 58))
  local btn_shop_menu = CCMenu:createWithItem(btn_shop)
  btn_shop_menu:setPosition(CCPoint(0, 0))
  shop_bg:addChild(btn_shop_menu)
  btn_shop:registerScriptTapHandler(function()
    delayBtnEnable(btn_shop)
    audio.play(audio.button)
    layer:addChild(require("ui.shop.main").create(), 2000)
    require("net.httpClient").userAction("shop01")
   end)
  local main_icon_step_x = -82
  local main_icon_step_y = 77
  local main_icon_pos_x = 916
  local main_icon_pos_y = 44
  local particle_scale = view.minScale
  local particle_shop = particle.create("ui_shop")
  particle_shop:setScale(particle_scale)
  particle_shop:setPosition(scalep(910, 65))
  layer:addChild(particle_shop, 100)
  autoLayoutShift(particle_shop, false, true, false, true)
  local shine_particle = particle.create("loop_shine_1")
  shine_particle:setStartSize(particle_scale * (shine_particle:getStartSize() - 13))
  shine_particle:setStartSizeVar(particle_scale * shine_particle:getStartSizeVar())
  shine_particle:setEndSize(particle_scale * shine_particle:getEndSize())
  shine_particle:setEndSizeVar(particle_scale * shine_particle:getEndSizeVar())
  layer:addChild(shine_particle, 110)
  local shine_particle2 = particle.create("loop_shine_2")
  shine_particle2:setStartSize(particle_scale * (shine_particle2:getStartSize() - 0))
  shine_particle2:setStartSizeVar(particle_scale * shine_particle2:getStartSizeVar())
  shine_particle2:setEndSize(particle_scale * shine_particle2:getEndSize())
  shine_particle2:setEndSizeVar(particle_scale * shine_particle2:getEndSizeVar())
  layer:addChild(shine_particle2, 105)
  shine_particle:setVisible(false)
  shine_particle2:setVisible(false)
  local particle_cx = view.minX + 816 * view.minScale
  local particle_cy = view.minY + 530 * view.minScale
  local particle_speed = 4
  local particle_radius = 36 * view.minScale
  local particle_angle = 0
  local runParticle = function(l_5_0)
    shine_particle:setVisible(true)
    shine_particle2:setVisible(true)
    upvalue_1024 = particle_angle + particle_speed * l_5_0
    if particle_angle > 360 then
      upvalue_1024 = particle_angle - 360
    end
    local particle_pos_x = particle_cx + particle_radius * math.sin(particle_angle)
    local particle_pos_y = particle_cy + particle_radius * math.cos(particle_angle)
    shine_particle:setPosition(CCPoint(particle_pos_x, particle_pos_y))
    shine_particle2:setPosition(CCPoint(particle_pos_x, particle_pos_y))
   end
  local stopParticle = function()
    shine_particle:setVisible(false)
    shine_particle2:setVisible(false)
   end
  local fpay_particle = particle.create("loop_shine_1")
  fpay_particle:setStartSize(particle_scale * (fpay_particle:getStartSize() - 13))
  fpay_particle:setStartSizeVar(particle_scale * fpay_particle:getStartSizeVar())
  fpay_particle:setEndSize(particle_scale * fpay_particle:getEndSize())
  fpay_particle:setEndSizeVar(particle_scale * fpay_particle:getEndSizeVar())
  layer:addChild(fpay_particle, 110)
  local fpay_particle2 = particle.create("loop_shine_2")
  fpay_particle2:setStartSize(particle_scale * (fpay_particle2:getStartSize() - 0))
  fpay_particle2:setStartSizeVar(particle_scale * fpay_particle2:getStartSizeVar())
  fpay_particle2:setEndSize(particle_scale * fpay_particle2:getEndSize())
  fpay_particle2:setEndSizeVar(particle_scale * fpay_particle2:getEndSizeVar())
  layer:addChild(fpay_particle2, 105)
  fpay_particle:setVisible(false)
  fpay_particle2:setVisible(false)
  local fpay_particle_cx = view.minX + 726 * view.minScale
  local fpay_particle_cy = view.minY + 530 * view.minScale
  local fpay_particle_speed = 4
  local fpay_particle_radius = 32 * view.minScale
  local fpay_particle_angle = 0
  local runFpayParticle = function(l_7_0)
    fpay_particle:setVisible(true)
    fpay_particle2:setVisible(true)
    upvalue_1024 = fpay_particle_angle + fpay_particle_speed * l_7_0
    if fpay_particle_angle > 360 then
      upvalue_1024 = fpay_particle_angle - 360
    end
    local fpay_particle_pos_x = fpay_particle_cx + fpay_particle_radius * math.sin(fpay_particle_angle)
    local fpay_particle_pos_y = fpay_particle_cy + fpay_particle_radius * math.cos(fpay_particle_angle)
    fpay_particle:setPosition(CCPoint(fpay_particle_pos_x, fpay_particle_pos_y))
    fpay_particle2:setPosition(CCPoint(fpay_particle_pos_x, fpay_particle_pos_y))
   end
  local stopFpayParticle = function()
    fpay_particle:setVisible(false)
    fpay_particle2:setVisible(false)
   end
  local online_particle = particle.create("loop_shine_1")
  online_particle:setStartSize(particle_scale * (online_particle:getStartSize() - 13))
  online_particle:setStartSizeVar(particle_scale * online_particle:getStartSizeVar())
  online_particle:setEndSize(particle_scale * online_particle:getEndSize())
  online_particle:setEndSizeVar(particle_scale * online_particle:getEndSizeVar())
  layer:addChild(online_particle, 110)
  local online_particle2 = particle.create("loop_shine_2")
  online_particle2:setStartSize(particle_scale * (online_particle2:getStartSize() - 0))
  online_particle2:setStartSizeVar(particle_scale * online_particle2:getStartSizeVar())
  online_particle2:setEndSize(particle_scale * online_particle2:getEndSize())
  online_particle2:setEndSizeVar(particle_scale * online_particle2:getEndSizeVar())
  layer:addChild(online_particle2, 105)
  local online_particle_speed = 4
  local online_particle_radius = 32 * view.minScale
  local online_particle_angle = 0
  local runOnlineParticle = function(l_9_0, l_9_1)
    local pos = l_9_1:convertToWorldSpace(CCPoint(l_9_1:getContentSize().width * 0.5, l_9_1:getContentSize().height * 0.5))
    local online_particle_cx = pos.x
    local online_particle_cy = pos.y
    online_particle:setVisible(true)
    online_particle2:setVisible(true)
    upvalue_1024 = online_particle_angle + online_particle_speed * l_9_0
    if online_particle_angle > 360 then
      upvalue_1024 = online_particle_angle - 360
    end
    local online_particle_pos_x = online_particle_cx + online_particle_radius * math.sin(online_particle_angle)
    local online_particle_pos_y = online_particle_cy + online_particle_radius * math.cos(online_particle_angle)
    online_particle:setPosition(CCPoint(online_particle_pos_x, online_particle_pos_y))
    online_particle2:setPosition(CCPoint(online_particle_pos_x, online_particle_pos_y))
   end
  local stopOnlineParticle = function()
    online_particle:setVisible(false)
    online_particle2:setVisible(false)
   end
  local icon_offset_y = 366
  local icon_step_y = 72
  local btn_bubble0 = img.createUISprite(img.ui.main_icon_bubble)
  addRedDot(btn_bubble0, {px = btn_bubble0:getContentSize().width - 20, py = btn_bubble0:getContentSize().height - 20}, 2)
  delRedDot(btn_bubble0)
  local btn_bubble = SpineMenuItem:create(json.ui.button, btn_bubble0)
  btn_bubble:setScale(0.5)
  btn_bubble:setPosition(CCPoint(35, icon_offset_y))
  local btn_bubble_menu = CCMenu:createWithItem(btn_bubble)
  btn_bubble_menu:setPosition(CCPoint(0, 0))
  left_container:addChild(btn_bubble_menu)
  btn_bubble:registerScriptTapHandler(function()
    delayBtnEnable(btn_bubble)
    audio.play(audio.button)
    local chatdata = require("data.chat")
    if not chatdata.isSynced() then
      addWaitNet()
      chatdata.sync(function(l_1_0)
        delWaitNet()
        chatdata.synced()
        if l_1_0 and l_1_0.msgs then
          chatdata.addMsgs(l_1_0.msgs)
        end
        chatdata.registEvent()
        if layer and not tolua.isnull(layer) then
          layer:addChild(require("ui.chat.main").create(), 1000)
        end
         end)
    else
      layer:addChild(require("ui.chat.main").create(), 1000)
    end
   end)
  autoLayoutShift(btn_bubble, nil, true)
  local mail_btn_0 = img.createUISprite(img.ui.main_icon_mail)
  addRedDot(mail_btn_0, {px = mail_btn_0:getContentSize().width - 20, py = mail_btn_0:getContentSize().height - 20}, 2)
  delRedDot(mail_btn_0)
  local mail_btn = SpineMenuItem:create(json.ui.button, mail_btn_0)
  mail_btn:setScale(0.5)
  mail_btn:setPosition(CCPoint(35, icon_offset_y - icon_step_y * 1))
  mail_btn:registerScriptTapHandler(function()
    delayBtnEnable(mail_btn)
    audio.play(audio.button)
    local maillayer = require("ui.mail.main")
    layer:addChild(maillayer.create(), 1000)
   end)
  local mail_menu = CCMenu:createWithItem(mail_btn)
  mail_menu:setPosition(CCPoint(0, 0))
  left_container:addChild(mail_menu, 101)
  autoLayoutShift(mail_btn, nil, true)
  local friend_btn_0 = img.createUISprite(img.ui.main_icon_friend)
  addRedDot(friend_btn_0, {px = friend_btn_0:getContentSize().width - 20, py = friend_btn_0:getContentSize().height - 20}, 2)
  delRedDot(friend_btn_0)
  local friend_btn = SpineMenuItem:create(json.ui.button, friend_btn_0)
  friend_btn:setScale(0.5)
  friend_btn:setPosition(CCPoint(35, icon_offset_y - icon_step_y * 2))
  friend_btn:registerScriptTapHandler(function()
    delayBtnEnable(friend_btn)
    local friends = require("ui.friends.main")
    layer:addChild(friends.create(), 200)
    audio.play(audio.button)
   end)
  local friend_menu = CCMenu:createWithItem(friend_btn)
  friend_menu:setPosition(CCPoint(0, 0))
  left_container:addChild(friend_menu, 101)
  autoLayoutShift(friend_btn, nil, true)
  local feed_btn_0 = img.createUISprite(img.ui.main_icon_feed)
  addRedDot(feed_btn_0, {px = feed_btn_0:getContentSize().width - 20, py = feed_btn_0:getContentSize().height - 20}, 2)
  delRedDot(feed_btn_0)
  local feed_btn = SpineMenuItem:create(json.ui.button, feed_btn_0)
  feed_btn:setScale(0.5)
  feed_btn:setPosition(CCPoint(35, icon_offset_y - icon_step_y * 3))
  feed_btn:registerScriptTapHandler(function()
    delayBtnEnable(feed_btn)
    audio.play(audio.button)
    local feedui = require("ui.setting.feed")
    layer:addChild(feedui.create(true), 200)
    require("net.httpClient").userAction("mainFeed")
   end)
  local feed_menu = CCMenu:createWithItem(feed_btn)
  feed_menu:setPosition(CCPoint(0, 0))
  left_container:addChild(feed_menu, 101)
  autoLayoutShift(feed_btn, nil, true)
  if APP_CHANNEL and APP_CHANNEL == "MRGAME" then
    feed_btn:setVisible(false)
  end
  local setting_btn_0 = img.createUISprite(img.ui.main_icon_setting)
  local lbl_icon_setting = lbl.create({font = 2, size = 14, text = i18n.global.main_btn_setting.string, color = btn_color3, cn = {size = 16}, pt = {size = 14}})
  lbl_icon_setting:setPosition(CCPoint(setting_btn_0:getContentSize().width / 2 - 0, 9))
  setting_btn_0:addChild(lbl_icon_setting, 1000)
  local setting_btn = SpineMenuItem:create(json.ui.button, setting_btn_0)
  setting_btn:setPosition(CCPoint(40, 60 + 0 * main_icon_step_y))
  setting_btn:registerScriptTapHandler(function()
    delayBtnEnable(setting_btn)
    audio.play(audio.button)
    layer:addChild(require("ui.setting.option").create(true), 1000)
    require("net.httpClient").userAction("mainSetting")
   end)
  local setting_menu = CCMenu:createWithItem(setting_btn)
  setting_menu:setPosition(CCPoint(0, 0))
  main_list_bg:addChild(setting_menu, 101)
  local hero_btn_0 = img.createUISprite(img.ui.main_icon_hero)
  addRedDot(hero_btn_0)
  delRedDot(hero_btn_0)
  local lbl_icon_hero = lbl.create({font = 2, size = 16, text = i18n.global.main_btn_hero.string, color = btn_color3, us = {size = 16}, pt = {size = 14}})
  lbl_icon_hero:setPosition(CCPoint(hero_btn_0:getContentSize().width / 2, 6))
  hero_btn_0:addChild(lbl_icon_hero, 1000)
  local hero_btn = SpineMenuItem:create(json.ui.button, hero_btn_0)
  hero_btn:setPosition(CCPoint(main_icon_pos_x + 1 * main_icon_step_x - 25, main_icon_pos_y + 0 * main_icon_step_y))
  hero_btn:registerScriptTapHandler(function()
    delayBtnEnable(hero_btn)
    audio.play(audio.button)
    replaceScene(require("ui.herolist.main").create())
   end)
  local hero_menu = CCMenu:createWithItem(hero_btn)
  hero_menu:setPosition(CCPoint(0, 0))
  bottom_container:addChild(hero_menu, 101)
  autoLayoutShift(hero_btn, nil, nil, nil, true)
  local bag_btn_0 = img.createUISprite(img.ui.main_icon_bag)
  addRedDot(bag_btn_0, {px = bag_btn_0:getContentSize().width - 5, py = bag_btn_0:getContentSize().height - 15})
  delRedDot(bag_btn_0)
  local lbl_icon_bag = lbl.create({font = 2, size = 16, text = i18n.global.main_btn_bag.string, color = btn_color3, us = {size = 16}, pt = {size = 14}})
  lbl_icon_bag:setPosition(CCPoint(bag_btn_0:getContentSize().width / 2, 6))
  bag_btn_0:addChild(lbl_icon_bag, 1000)
  local bag_btn = SpineMenuItem:create(json.ui.button, bag_btn_0)
  bag_btn:setPosition(CCPoint(main_icon_pos_x + 2 * main_icon_step_x - 25, main_icon_pos_y + 0 * main_icon_step_y))
  bag_btn:registerScriptTapHandler(function()
    delayBtnEnable(bag_btn)
    audio.play(audio.button)
    replaceScene(require("ui.bag.main").create("town"))
   end)
  local bag_menu = CCMenu:createWithItem(bag_btn)
  bag_menu:setPosition(CCPoint(0, 0))
  bottom_container:addChild(bag_menu, 101)
  autoLayoutShift(bag_btn, nil, nil, nil, true)
  local guild_btn_0 = img.createUISprite(img.ui.main_icon_guild)
  addRedDot(guild_btn_0, {px = guild_btn_0:getContentSize().width - 5, py = guild_btn_0:getContentSize().height - 15})
  delRedDot(guild_btn_0)
  local lbl_icon_guild = lbl.create({font = 2, size = 16, text = i18n.global.main_btn_guild.string, color = btn_color3, us = {size = 16}, pt = {size = 14}})
  lbl_icon_guild:setPosition(CCPoint(guild_btn_0:getContentSize().width / 2, 6))
  guild_btn_0:addChild(lbl_icon_guild, 1000)
  local guild_btn = SpineMenuItem:create(json.ui.button, guild_btn_0)
  guild_btn:setPosition(CCPoint(main_icon_pos_x + 3 * main_icon_step_x - 25, main_icon_pos_y + 0 * main_icon_step_y))
  guild_btn:registerScriptTapHandler(function()
    delayBtnEnable(guild_btn)
    audio.play(audio.button)
    if BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_GUILD_LEVEL then
      showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_GUILD_LEVEL))
      return 
    end
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
        replaceScene(require("ui.guild.main").create())
         end)
    else
      if player.gid and player.gid > 0 and gdata.IsInit() then
        replaceScene(require("ui.guild.main").create())
      else
        layer:addChild(require("ui.guild.recommend").create(1, true), 1000)
      end
    end
   end)
  local guild_menu = CCMenu:createWithItem(guild_btn)
  guild_menu:setPosition(CCPoint(0, 0))
  bottom_container:addChild(guild_menu, 101)
  autoLayoutShift(guild_btn, nil, nil, nil, true)
  local pet_img = img.createUISprite(img.ui.main_icon_pet)
  local pet_btn = SpineMenuItem:create(json.ui.button, pet_img)
  local pet_label = lbl.create({font = 2, size = 16, text = i18n.global.main_btn_pet.string, color = btn_color3, us = {size = 16}, pt = {size = 14}})
  pet_label:setPosition(CCPoint(pet_btn:getContentSize().width / 2, 6))
  pet_img:addChild(pet_label, 1000)
  pet_btn:setPosition(CCPoint(main_icon_pos_x + 4 * main_icon_step_x - 25, main_icon_pos_y + 0 * main_icon_step_y))
  pet_btn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_PET then
      showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_PET))
      return 
    end
    addLoading(function()
      replaceScene(require("ui.pet.main").create())
      end, 1)
   end)
  local pet_menu = CCMenu:createWithItem(pet_btn)
  pet_menu:setPosition(CCPoint(0, 0))
  bottom_container:addChild(pet_menu, 101)
  autoLayoutShift(pet_btn, nil, nil, nil, true)
  local skin_img = img.createUISprite(img.ui.main_icon_skin)
  local skin_btn = SpineMenuItem:create(json.ui.button, skin_img)
  local skin_label = lbl.create({font = 2, size = 16, text = i18n.global.main_btn_skin.string, color = btn_color3, us = {size = 16}, pt = {size = 14}})
  skin_label:setPosition(CCPoint(skin_btn:getContentSize().width / 2, 6))
  skin_img:addChild(skin_label, 1000)
  skin_btn:setPosition(CCPoint(main_icon_pos_x + 5 * main_icon_step_x - 25, main_icon_pos_y + 0 * main_icon_step_y))
  skin_btn:registerScriptTapHandler(function()
    audio.play(audio.button)
    replaceScene(require("ui.skin.main").create())
   end)
  local skin_menu = CCMenu:createWithItem(skin_btn)
  skin_menu:setPosition(CCPoint(0, 0))
  bottom_container:addChild(skin_menu, 101)
  autoLayoutShift(skin_btn, nil, nil, nil, true)
  local video_btn_0 = img.createUISprite(img.ui.main_icon_video)
  local video_btn = SpineMenuItem:create(json.ui.button, video_btn_0)
  video_btn:setPosition(CCPoint(165, main_icon_pos_y))
  local video_btn_menu = CCMenu:createWithItem(video_btn)
  video_btn_menu:setPosition(CCPoint(0, 0))
  bottom_container:addChild(video_btn_menu, 101)
  local showVideoBtn = function()
    local videoData = require("data.videoad")
    if videoData.isAvailable() then
      video_btn:setVisible(true)
      video_btn:setEnabled(true)
    else
      video_btn:setEnabled(false)
      video_btn:setVisible(false)
    end
   end
  showVideoBtn()
  video_btn:registerScriptTapHandler(function()
    delayBtnEnable(video_btn)
    audio.play(audio.button)
    video_btn:setVisible(false)
    layer:addChild(require("ui.videoad.main").create(function()
      video_btn:setVisible(false)
      end), 1000)
   end)
  autoLayoutShift(video_btn, nil, nil, true)
  local monthly_btn_0 = img.createUISprite(img.ui.login_month_icon)
  local lbl_icon_monthly = lbl.create({font = 2, size = 10, text = i18n.global.month_login_checkin.string, color = btn_color2, cn = {size = 16}, tw = {size = 16}, us = {size = 14}})
  lbl_icon_monthly:setPosition(CCPoint(monthly_btn_0:getContentSize().width / 2, 16))
  monthly_btn_0:addChild(lbl_icon_monthly, 1000)
  local monthly_btn = SpineMenuItem:create(json.ui.button, monthly_btn_0)
  monthly_btn:setPosition(CCPoint(130, 534))
  monthly_btn:registerScriptTapHandler(function()
    delayBtnEnable(monthly_btn)
    audio.play(audio.button)
    layer:addChild(require("ui.loginreward.main").create(), 1000)
   end)
  local monthly_menu = CCMenu:createWithItem(monthly_btn)
  monthly_menu:setPosition(CCPoint(0, 0))
  top_container:addChild(monthly_menu, 101)
  autoLayoutShift(monthly_btn, true, false, true, false)
  local online_btn_0 = CCSprite:create()
  online_btn_0:setContentSize(CCSizeMake(77, 77))
  local online_bg = img.createUISprite(img.ui.main_icon_online)
  online_bg:setPosition(CCPoint(online_btn_0:getContentSize().width / 2, 42))
  online_btn_0:addChild(online_bg)
  local updateOnlineReward = function()
    if online_bg:getChildByTag(233) then
      online_bg:removeChildByTag(233)
    end
    if onlinedata.id and onlinedata.id > 0 then
      local tmp_reward = onlinedata.getRewardById()[1]
      local tmp_icon = nil
      if tmp_reward.type == 1 then
        tmp_icon = img.createItem(tmp_reward.id, tmp_reward.num)
      elseif tmp_reward.type == 2 then
        tmp_icon = img.createEquip(tmp_reward.id, tmp_reward.num)
      end
      tmp_icon:setScale(0.57)
      tmp_icon:setPosition(CCPoint(39, 29))
      online_bg:addChild(tmp_icon, 1, 233)
    end
   end
  updateOnlineReward()
  local lbl_online_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_online_cd:setScale(lbl_online_cd:getScale() * 0.9)
  lbl_online_cd:setPosition(CCPoint(online_btn_0:getContentSize().width / 2, 6))
  online_btn_0:addChild(lbl_online_cd)
  local online_btn = SpineMenuItem:create(json.ui.button, online_btn_0)
  online_btn:setPosition(CCPoint(215, 534))
  local online_btn_menu = CCMenu:createWithItem(online_btn)
  online_btn_menu:setPosition(CCPoint(0, 0))
  top_container:addChild(online_btn_menu, 101)
  autoLayoutShift(online_btn, true, false, true, false)
  local updateOnlineCD = function(l_25_0)
    if onlinedata.id and onlinedata.id > 0 then
      local remain_cd = onlinedata.cd - (os.time() - onlinedata.pull_time)
      if remain_cd > 0 then
        lbl_online_cd:setVisible(true)
        stopOnlineParticle()
        local time_str = time2string(remain_cd)
        lbl_online_cd:setString(time_str)
      else
        lbl_online_cd:setVisible(false)
        runOnlineParticle(l_25_0, online_btn)
      end
    else
      lbl_online_cd:setVisible(false)
      stopOnlineParticle(l_25_0)
      online_btn:setVisible(false)
    end
  end
   end
  online_btn:registerScriptTapHandler(function()
    delayBtnEnable(online_btn)
    audio.play(audio.button)
    if not onlinedata.id or onlinedata.id <= 0 then
      stopOnlineParticle(dt)
      online_btn:setVisible(false)
      return 
    end
    local remain_cd = onlinedata.cd - (os.time() - onlinedata.pull_time)
    if remain_cd > 0 then
      local tmp_reward = onlinedata.getRewardById()[1]
      if tmp_reward.type == 1 then
        local tmp_tip = tipsitem.createForShow({id = tmp_reward.id})
        layer:addChild(tmp_tip, 1000)
      elseif tmp_reward.type == 2 then
        local tmp_tip = tipsequip.createById(tmp_reward.id)
        layer:addChild(tmp_tip, 1000)
      else
        local nParams = {sid = player.sid, id = onlinedata.id}
        addWaitNet()
        netClient:online_claim(nParams, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          if l_1_0.status < 0 then
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
            onlinedata.sync(l_1_0.online)
            updateOnlineReward()
            return 
          else
            local tmp_pbbag = reward2Pbbag(onlinedata.getRewardById())
            bagdata.addRewards(tmp_pbbag)
            CCDirector:sharedDirector():getRunningScene():addChild(rewards.createFloating(tmp_pbbag), 100000)
            onlinedata.sync(l_1_0.online)
            if onlinedata.id <= 0 then
              online_btn:setVisible(false)
              stopOnlineParticle()
            else
              updateOnlineReward()
            end
          end
            end)
      end
    end
   end)
  local gift_btn_0 = img.createUISprite(img.ui.main_icon_activity)
  addRedDot(gift_btn_0, {px = gift_btn_0:getContentSize().width - 15, py = gift_btn_0:getContentSize().height - 15})
  delRedDot(gift_btn_0)
  local lbl_icon_gift = lbl.create({font = 2, size = 10, text = i18n.global.main_btn_gift.string, color = btn_color2, cn = {size = 16}, tw = {size = 16}, us = {size = 14}})
  lbl_icon_gift:setPosition(CCPoint(gift_btn_0:getContentSize().width / 2, 6))
  gift_btn_0:addChild(lbl_icon_gift, 1000)
  local gift_btn = SpineMenuItem:create(json.ui.button, gift_btn_0)
  gift_btn:setPosition(CCPoint(816, 530))
  gift_btn:registerScriptTapHandler(function()
    delayBtnEnable(gift_btn)
    audio.play(audio.button)
    layer:addChild(require("ui.activityhome.main").create(), 1000)
   end)
  local gift_menu = CCMenu:createWithItem(gift_btn)
  gift_menu:setPosition(CCPoint(0, 0))
  top_container:addChild(gift_menu, 101)
  autoLayoutShift(gift_btn, nil, nil, nil, true)
  local vip_btn_0 = img.createUISprite(img.ui.main_icon_vip)
  local lbl_icon_vip = lbl.create({font = 2, size = 10, text = i18n.global.lbl_icon_vip.string, color = btn_color2, cn = {size = 16}, tw = {size = 16}, us = {size = 14}})
  lbl_icon_vip:setPosition(CCPoint(vip_btn_0:getContentSize().width / 2, 6))
  vip_btn_0:addChild(lbl_icon_vip, 1000)
  local vip_btn = SpineMenuItem:create(json.ui.button, vip_btn_0)
  vip_btn:setPosition(CCPoint(726, 530))
  vip_btn:registerScriptTapHandler(function()
    delayBtnEnable(vip_btn)
    audio.play(audio.button)
    layer:addChild(require("ui.vip.main").create(), 10000)
   end)
  local vip_menu = CCMenu:createWithItem(vip_btn)
  vip_menu:setPosition(CCPoint(0, 0))
  top_container:addChild(vip_menu, 101)
  autoLayoutShift(vip_btn, nil, nil, nil, true)
  local reward_btn_0 = img.createUISprite(img.ui.main_icon_reward)
  addRedDot(reward_btn_0, {px = reward_btn_0:getContentSize().width - 15, py = reward_btn_0:getContentSize().height - 15})
  delRedDot(reward_btn_0)
  local lbl_icon_reward = lbl.create({font = 2, size = 14, text = i18n.global.main_btn_reward.string, color = btn_color3, cn = {size = 16}, tw = {size = 16}})
  lbl_icon_reward:setPosition(CCPoint(reward_btn_0:getContentSize().width / 2, 9))
  reward_btn_0:addChild(lbl_icon_reward, 1000)
  local reward_btn = SpineMenuItem:create(json.ui.button, reward_btn_0)
  reward_btn:setPosition(CCPoint(40, 60 + 2 * main_icon_step_y))
  reward_btn:registerScriptTapHandler(function()
    delayBtnEnable(reward_btn)
    layer:addChild(require("ui.achieve.main").create(), 1000)
    audio.play(audio.button)
   end)
  local reward_menu = CCMenu:createWithItem(reward_btn)
  reward_menu:setPosition(CCPoint(0, 0))
  main_list_bg:addChild(reward_menu, 101)
  local taskRedDot = false
  local task_btn_0 = img.createUISprite(img.ui.main_icon_task)
  addRedDot(task_btn_0, {px = task_btn_0:getContentSize().width - 15, py = task_btn_0:getContentSize().height - 15})
  delRedDot(task_btn_0)
  local lbl_icon_task = lbl.create({font = 2, size = 14, text = i18n.global.main_btn_task.string, color = btn_color3, cn = {size = 16}, pt = {size = 14}})
  lbl_icon_task:setPosition(CCPoint(task_btn_0:getContentSize().width / 2, 9))
  task_btn_0:addChild(lbl_icon_task, 1000)
  local task_btn = SpineMenuItem:create(json.ui.button, task_btn_0)
  task_btn:setPosition(CCPoint(40, 60 + 1 * main_icon_step_y))
  task_btn:registerScriptTapHandler(function()
    delayBtnEnable(task_btn)
    audio.play(audio.button)
    if player.lv() < UNLOCK_TASK_LEVEL then
      showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_TASK_LEVEL))
      return 
    end
    if taskRedDot then
      shortcut.donateShortcut(shortcut.ActionEnum.TASK)
    end
    layer:addChild(require("ui.task.main").create(true), 1000)
   end)
  local task_menu = CCMenu:createWithItem(task_btn)
  task_menu:setPosition(CCPoint(0, 0))
  main_list_bg:addChild(task_menu, 101)
  local challenge_btn_0 = img.createUISprite(img.ui.main_icon_challenge)
  addRedDot(challenge_btn_0, {px = challenge_btn_0:getContentSize().width - 15, py = challenge_btn_0:getContentSize().height - 15})
  delRedDot(challenge_btn_0)
  local lbl_icon_challenge = lbl.create({font = 2, size = 14, text = i18n.global.main_btn_dare.string, color = btn_color3, cn = {size = 16}, pt = {size = 14}})
  lbl_icon_challenge:setPosition(CCPoint(challenge_btn_0:getContentSize().width / 2, 9))
  challenge_btn_0:addChild(lbl_icon_challenge, 1000)
  local challenge_btn = SpineMenuItem:create(json.ui.button, challenge_btn_0)
  challenge_btn:setPosition(CCPoint(40, 60 + 3 * main_icon_step_y))
  local goDare = function(l_31_0)
    local daredata = require("data.dare")
    local nParams = {sid = player.sid}
    addWaitNet()
    netClient:dare_sync(nParams, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      daredata.sync(l_1_0)
      if layer and not tolua.isnull(layer) then
        shortcut.donateShortcut(shortcut.ActionEnum.DARE)
        layer:addChild(require("ui.dare.main").create(_params), 1000)
      end
      end)
   end
  challenge_btn:registerScriptTapHandler(function()
    delayBtnEnable(challenge_btn)
    audio.play(audio.button)
    goDare({_anim = true})
   end)
  local challenge_menu = CCMenu:createWithItem(challenge_btn)
  challenge_menu:setPosition(CCPoint(0, 0))
  main_list_bg:addChild(challenge_menu, 101)
  btn_list_fold:registerScriptTapHandler(function()
    audio.play(audio.button)
    btn_list_fold:setVisible(false)
    btn_list_unfold:setVisible(true)
    main_list_bg:runAction(createSequence({}))
     -- Warning: undefined locals caused missing assignments!
   end)
  btn_list_unfold:registerScriptTapHandler(function()
    audio.play(audio.button)
    btn_list_fold:setVisible(true)
    btn_list_unfold:setVisible(false)
    main_list_bg:runAction(createSequence({}))
     -- Warning: undefined locals caused missing assignments!
   end)
  local entry_ani = CCArray:create()
  entry_ani:addObject(CCCallFunc:create(function()
    local entry_duration = 0.3
    top_container:runAction(CCEaseOut:create(CCMoveTo:create(entry_duration, scalep(480, 288)), 2))
    right_container:runAction(CCEaseOut:create(CCMoveTo:create(entry_duration, scalep(480, 288)), 2))
    bottom_container:runAction(CCEaseOut:create(CCMoveTo:create(entry_duration, scalep(480, 288)), 2))
    left_container:runAction(CCEaseOut:create(CCMoveTo:create(entry_duration, scalep(480, 288)), 2))
    moneyContainer:runAction(CCEaseOut:create(CCMoveTo:create(entry_duration, CCPoint(0, 0)), 2))
   end))
  layer:runAction(CCSequence:create(entry_ani))
  local last_update = os.time() - 4
  local onUpdate = function(l_36_0)
    updateOnlineCD(l_36_0)
    updateLogo()
    if lbl_player_lv.lv ~= player.lv() then
      lbl_player_lv:setString(tostring(player.lv()))
      lbl_player_lv.lv = player.lv()
    end
    if lbl_player_vip.vip ~= player.vipLv() then
      lbl_player_vip:setString(tostring(player.vipLv()))
      lbl_player_vip.vip = player.vipLv()
      ic_vip:playAnimation("" .. vip_a[player.vipLv()], -1)
      lbl_player_vip:setColor(vip_c[player.vipLv()])
    end
    if player.vipLv() < 1 then
      btn_vip:setVisible(false)
    else
      btn_vip:setVisible(true)
    end
    if os.time() - last_update < 3 then
      return 
    end
    upvalue_4608 = os.time()
    local chatdata = require("data.chat")
    if chatdata.showRedDot() then
      addRedDot(btn_bubble0, {px = btn_bubble0:getContentSize().width - 10, py = btn_bubble0:getContentSize().height - 10})
    else
      delRedDot(btn_bubble0)
    end
    local maildata = require("data.mail")
    if maildata.showRedDot() then
      addRedDot(mail_btn_0, {px = mail_btn_0:getContentSize().width - 10, py = mail_btn_0:getContentSize().height - 10})
    else
      delRedDot(mail_btn_0)
    end
    if gdata.showRedDot() then
      addRedDot(guild_btn_0, {px = guild_btn_0:getContentSize().width - 5, py = guild_btn_0:getContentSize().height - 5})
    else
      delRedDot(guild_btn_0)
    end
    local pet = require("data.pet")
    if pet.showRedDot() then
      addRedDot(pet_img, {px = pet_img:getContentSize().width - 5, py = pet_img:getContentSize().height - 5})
    else
      delRedDot(pet_img)
    end
    if bag.showRedDot() then
      addRedDot(bag_btn_0, {px = bag_btn_0:getContentSize().width - 5, py = bag_btn_0:getContentSize().height - 5})
    else
      delRedDot(bag_btn_0)
    end
    local friend = require("data.friend")
    if friend.showRedDot() then
      addRedDot(friend_btn_0, {px = friend_btn_0:getContentSize().width - 10, py = friend_btn_0:getContentSize().height - 10})
    else
      delRedDot(friend_btn_0)
    end
    local achieveData = require("data.achieve")
    if achieveData.showRedDot() then
      addRedDot(reward_btn_0, {px = reward_btn_0:getContentSize().width - 10, py = reward_btn_0:getContentSize().height - 10})
    else
      delRedDot(reward_btn_0)
    end
    showVideoBtn()
    local headData = require("data.head")
    if headData.showRedDot() then
      addRedDot(btn_logo, {px = btn_logo:getContentSize().width - 5, py = btn_logo:getContentSize().height - 5})
    else
      delRedDot(btn_logo)
    end
    local activity_data = require("data.activity")
    local mactData = require("data.monthlyactivity")
    if activity_data.showRedDot() or activity_data.showRedDotLimit() or mactData.showRedDot() then
      addRedDot(gift_btn_0, {px = gift_btn_0:getContentSize().width - 15, py = gift_btn_0:getContentSize().height - 15})
    else
      delRedDot(gift_btn_0)
    end
    local taskdata = require("data.task")
    if taskdata.showRedDot() then
      upvalue_11264 = true
      addRedDot(task_btn_0, {px = task_btn_0:getContentSize().width - 15, py = task_btn_0:getContentSize().height - 15})
    else
      upvalue_11264 = false
      delRedDot(task_btn_0)
    end
   end
  if l_1_0 then
    print("uiparams.from_layer:", l_1_0.from_layer)
  end
  local tutorialData = require("data.tutorial")
  local activity_data = require("data.activity")
  local prevent_addiction = require("data.preventaddiction")
  local christmas_data = require("data.christmas")
  if christmas_data.shouldPop() then
    layer:runAction(CCCallFunc:create(function()
    layer:addChild(require("ui.christmas.socks").createGiftDialog({reward = clone(christmas_data.reward), unlock = true}), 1000)
   end))
  else
    if require("data.tutorial").isComplete() and not activity_data.isVpPopped() then
      layer:runAction(CCCallFunc:create(function()
    layer:addChild(require("ui.pops.vp").create(), 1000)
   end))
    else
      if prevent_addiction.shouldPop() then
        layer:runAction(CCCallFunc:create(function()
      prevent_addiction.popped(true)
      layer:addChild(require("ui.town.PreventAddictionDialog").create(layer), 1000000)
      end))
      else
        if tutorialData.isComplete() and prevent_addiction.shouldShowDialog() and prevent_addiction.needPreventAddiction() then
          layer:runAction(CCCallFunc:create(function()
        layer:addChild(require("ui.town.PreventAddictionDialog").create(layer), 1000)
         end))
        elseif l_1_0 and l_1_0.from_layer == "language" then
          layer:runAction(CCCallFunc:create(function()
          layer:addChild(require("ui.setting.option").create(), 1000)
            end))
        elseif l_1_0 and l_1_0.from_layer == "task" then
          layer:runAction(CCCallFunc:create(function()
          layer:addChild(require("ui.task.main").create(), 1000)
            end))
        elseif l_1_0 and l_1_0.from_layer == "dareStage" then
          layer:runAction(CCCallFunc:create(function()
          goDare({_anim = true, from_layer = "dareStage", type = uiparams.type})
            end))
        elseif l_1_0 and l_1_0.from_layer:beginwith("frdboss_") then
          layer:runAction(CCCallFunc:create(function()
          layer:addChild(require("ui.friends.main").create(uiparams), 1000)
            end))
        elseif l_1_0 and l_1_0.from_layer == "frdpk" then
          layer:runAction(CCCallFunc:create(function()
          layer:addChild(require("ui.friends.main").create(uiparams), 1000)
            end))
        else
          if require("data.rateus").isAvailable() then
            layer:runAction(CCCallFunc:create(function()
          layer:addChild(require("ui.rateus.main").create(), 1000)
            end))
          elseif l_1_0 and l_1_0.from_layer:beginwith("brokenboss") then
            layer:runAction(CCCallFunc:create(function()
            layer:addChild(require("ui.activityhome.main").create(2, "brokenboss"), 1000)
               end))
          elseif l_1_0 and l_1_0.from_layer:beginwith("airisland") then
            layer:runAction(CCCallFunc:create(function()
            local params = {sid = player.sid, pos = 0}
            addWaitNet()
            netClient:island_land(params, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              local airData = require("data.airisland")
              airData.setLandData(l_1_0)
              replaceScene(require("ui.airisland.fightmain").create())
                  end)
               end))
          end
        end
      end
    end
  end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    exitGame(layer)
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_52_0)
    if l_52_0 == "enter" then
      onEnter()
    elseif l_52_0 == "exit" then
      onExit()
    end
   end)
  layer.initHelperUI = function(l_53_0)
    img.load(img.packedOthers.spine_ui_yindao_face)
    local iconFace = json.create(json.ui.yindao_face)
    if l_53_0 then
      local rdNum = math.random(1, 3)
      if rdNum == 1 then
        iconFace:playAnimation("stand02", -1)
      elseif rdNum == 2 then
        iconFace:playAnimation("stand04", -1)
      elseif rdNum == 3 then
        iconFace:playAnimation("stand05", -1)
      elseif rdNum == 4 then
        iconFace:playAnimation("stand03", -1)
      else
        iconFace:playAnimation("enter")
        iconFace:appendNextAnimation("stand02", -1)
      end
    end
    iconFace:setContentSize(CCSize(110, 110))
    local btnHelper = SpineMenuItem:create(json.ui.button, iconFace)
    btnHelper:setPosition(ccp(53, 53))
    local btnMenu = CCMenu:createWithItem(btnHelper)
    btnMenu:setPosition(CCPoint(0, 0))
    left_container:addChild(btnMenu, 10)
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  btnHelper:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer:addChild(require("ui.town.gotoEnter").create(), 1000)
      require("net.httpClient").userAction("mainHelper")
      end)
  autoLayoutShift(btnHelper)
   end
  if tutorialData.isComplete() then
    layer.initHelperUI(true)
  end
  return layer
end

return ui

