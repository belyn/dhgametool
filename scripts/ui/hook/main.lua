-- Command line was: E:\github\dhgametool\scripts\ui\hook\main.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local particle = require("res.particle")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local cfgstage = require("config.stage")
local player = require("data.player")
local bagdata = require("data.bag")
local hookdata = require("data.hook")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local dialog = require("ui.dialog")
local rewards = require("ui.reward")
local TAG_CONTENT_LAYER = 1117
local last_ask = os.time()
local ASK_INTERVAL = 60
local resources = {imgs = {img.packedOthers.spine_ui_guaji, img.packedOthers.ui_hookmap_bg1}, jsons = {json.ui.hook, json.ui.hook_reward_01, json.ui.hook_reward_02, json.ui.hook_reward_03, json.ui.radar, json.ui.guaji_yellow_btn, json.ui.guaji_green_btn, json.ui.hook_pariticle, json.ui.guaji_red_btn, json.ui.guaji_xuanguan}}
ui.create = function(l_1_0)
  local updateOutput = nil
  local layer = CCLayer:create()
  img.load(img.packedOthers.spine_ui_guaji)
  img.load(img.packedOthers.ui_hookmap_bg1)
  local bgg = img.createUISprite(img.ui.hookmap_bg1)
  bgg:setScale(view.maxScale)
  bgg:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(bgg)
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY * 0.6))
  layer:addChild(darkbg)
  local bg = CCSprite:create()
  bg:setContentSize(CCSizeMake(960, 576))
  bg:setScale(view.minScale)
  bg:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(bg)
  local bg_w = bg:getContentSize().width
  local bg_h = bg:getContentSize().height
  local back0 = img.createUISprite(img.ui.back)
  local backBtn = HHMenuItem:create(back0)
  backBtn:setScale(view.minScale)
  backBtn:setPosition(scalep(35, 546))
  local backMenu = CCMenu:createWithItem(backBtn)
  backMenu:setPosition(0, 0)
  layer:addChild(backMenu)
  backBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer.onAndroidBack()
   end)
  autoLayoutShift(backBtn)
  local icon_layer = CCLayer:create()
  icon_layer:setCascadeOpacityEnabled(true)
  icon_layer:setOpacity(0)
  icon_layer:setVisible(false)
  layer:addChild(icon_layer, 100)
  json.load(json.ui.hook)
  json.load(json.ui.hook_reward_01)
  json.load(json.ui.hook_reward_02)
  json.load(json.ui.hook_reward_03)
  json.load(json.ui.radar)
  local ani_hook = DHSkeletonAnimation:createWithKey(json.ui.hook)
  ani_hook:setScale(view.minScale)
  ani_hook:scheduleUpdateLua()
  ani_hook:setAnchorPoint(CCPoint(0.5, 0.5))
  ani_hook:setPosition(scalep(480, 288))
  layer:addChild(ani_hook)
  local stage_board = img.createUI9Sprite(img.ui.hook_stage_board)
  stage_board:setPreferredSize(CCSizeMake(856, 158))
  stage_board:setCascadeOpacityEnabled(true)
  ani_hook:addChildFollowSlot("code_down_bg", stage_board)
  local stage_board_w = stage_board:getContentSize().width
  local stage_board_h = stage_board:getContentSize().height
  local play_board = img.createUI9Sprite(img.ui.hook_play_board)
  play_board:setPreferredSize(CCSizeMake(925, 329))
  play_board:setCascadeOpacityEnabled(true)
  ani_hook:addChildFollowSlot("code_screen", play_board)
  local play_board_w = play_board:getContentSize().width
  local play_board_h = play_board:getContentSize().height
  local play_bg, thumbnail = nil, nil
  if hookdata.getHookStage() == 0 then
    thumbnail = cfgstage[1].thumbnail
    play_bg = img.createHookMap(cfgstage[1].thumbnail)
  else
    thumbnail = cfgstage[hookdata.getHookStage()].thumbnail
    play_bg = img.createHookMap(cfgstage[hookdata.getHookStage()].thumbnail)
  end
  play_bg:setPosition(CCPoint(play_board_w / 2, play_board_h / 2 + 3))
  play_board:addChild(play_bg)
  local fightAnim = require("ui.hook.fight").create()
  layer:addChild(fightAnim, 10)
  local arr_hook = CCArray:create()
  arr_hook:addObject(CCCallFunc:create(function()
    ani_hook:playAnimation("enter", 1)
   end))
  arr_hook:addObject(CCDelayTime:create(ani_hook:getAnimationTime("enter") - 1.5))
  arr_hook:addObject(CCCallFunc:create(function()
    icon_layer:setVisible(true)
    icon_layer:runAction(CCFadeIn:create(1))
   end))
  layer:runAction(CCSequence:create(arr_hook))
  local container = CCSprite:create()
  container:setContentSize(CCSizeMake(374, 40))
  container:setScale(view.minScale)
  container:setAnchorPoint(CCPoint(0.5, 1))
  container:setPosition(CCPoint(view.midX, view.maxY - 15 * view.minScale))
  icon_layer:addChild(container)
  autoLayoutShift(container)
  local container_w = container:getContentSize().width
  local container_h = container:getContentSize().height
  local coin_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  coin_bg:setPreferredSize(CCSizeMake(174, 40))
  coin_bg:setAnchorPoint(CCPoint(1, 0.5))
  coin_bg:setPosition(CCPoint(container_w / 2 - 13, container_h / 2))
  container:addChild(coin_bg)
  local gem_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  gem_bg:setPreferredSize(CCSizeMake(174, 40))
  gem_bg:setAnchorPoint(CCPoint(0, 0.5))
  gem_bg:setPosition(CCPoint(container_w / 2 + 13, container_h / 2))
  container:addChild(gem_bg)
  local icon_coin = img.createItemIcon2(ITEM_ID_COIN)
  icon_coin:setPosition(CCPoint(5, coin_bg:getContentSize().height / 2 + 2))
  coin_bg:addChild(icon_coin)
  local icon_gem = img.createItemIcon(ITEM_ID_HERO_EXP)
  icon_gem:setScale(0.5)
  icon_gem:setPosition(CCPoint(5, gem_bg:getContentSize().height / 2 + 2))
  gem_bg:addChild(icon_gem)
  local coin_num = bagdata.coin()
  local lbl_coin = lbl.createFont2(16, num2KM(coin_num), ccc3(255, 246, 223))
  lbl_coin:setPosition(CCPoint(coin_bg:getContentSize().width / 2, coin_bg:getContentSize().height / 2 + 3))
  coin_bg:addChild(lbl_coin)
  lbl_coin.num = coin_num
  local gem_num = bagdata.items.find(ITEM_ID_HERO_EXP).num
  local lbl_gem = lbl.createFont2(16, num2KM(gem_num), ccc3(255, 246, 223))
  lbl_gem:setPosition(CCPoint(gem_bg:getContentSize().width / 2, gem_bg:getContentSize().height / 2 + 3))
  gem_bg:addChild(lbl_gem)
  lbl_gem.num = gem_num
  local updateLabels = function()
    local coinnum = bagdata.coin()
    if lbl_coin.num ~= coinnum then
      lbl_coin:setString(num2KM(coinnum))
      lbl_coin.num = coinnum
    end
    local gemnum = bagdata.items.find(ITEM_ID_HERO_EXP).num
    if lbl_gem.num ~= gemnum then
      lbl_gem:setString(num2KM(gemnum))
      lbl_gem.num = gemnum
    end
   end
  local bar_bg = img.createUI9Sprite(img.ui.hook_bar_bg)
  bar_bg:setPreferredSize(CCSizeMake(871, 45))
  bar_bg:setScale(view.minScale)
  bar_bg:setPosition(scalep(480, 465))
  icon_layer:addChild(bar_bg)
  local fortName = hookdata.getFortName()
  local lbl_fort_name = lbl.createFont2(24, fortName, ccc3(255, 246, 216), true)
  lbl_fort_name:setAnchorPoint(CCPoint(0, 0.5))
  lbl_fort_name:setPosition(scalep(100, 465))
  icon_layer:addChild(lbl_fort_name)
  local addStageFocus, addRadar = nil, nil
  local stage_items = {}
  local btn_offset_x = 690
  local btn_offset_y = 540
  local btn_step_x = 78
  local btn_team0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_team0:setPreferredSize(CCSizeMake(148, 42))
  if hookdata.checkTeamChange() then
    addRedDot(btn_team0, {px = btn_team0:getContentSize().width - 3, py = btn_team0:getContentSize().height - 3})
  end
  local icon_team = img.createUISprite(img.ui.hook_icon_team)
  icon_team:setPosition(CCPoint(19, 21))
  btn_team0:addChild(icon_team)
  local lbl_btn_team = lbl.createFont1(16, i18n.global.hook_btn_team.string, ccc3(131, 65, 29))
  lbl_btn_team:setPosition(CCPoint(btn_team0:getContentSize().width / 2 + 10, 21))
  btn_team0:addChild(lbl_btn_team)
  local btn_team = SpineMenuItem:create(json.ui.button, btn_team0)
  btn_team:setScale(view.minScale)
  btn_team:setPosition(scalep(122, 227))
  local btn_team_menu = CCMenu:createWithItem(btn_team)
  btn_team_menu:setPosition(CCPoint(0, 0))
  icon_layer:addChild(btn_team_menu, 10)
  btn_team:registerScriptTapHandler(function()
    btn_team:setEnabled(false)
    audio.play(audio.button)
    delRedDot(btn_team0)
    layer:addChild(require("ui.hook.team").create(function(l_1_0)
      if l_1_0 then
        fightAnim.refresh()
        return 
      end
      if #stage_items > 0 and not tolua.isnull(stage_items[1]) then
        fightAnim.refresh()
        addRadar(stage_items[1])
      end
      require("data.tutorial").goNext("hook", 1, true)
      end), 1000)
    schedule(btn_team, 1.5, function()
      btn_team:setEnabled(true)
      end)
   end)
  local btn_hero0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_hero0:setPreferredSize(CCSizeMake(148, 42))
  local icon_hero = img.createUISprite(img.ui.hook_icon_hero)
  icon_hero:setPosition(CCPoint(19, 21))
  btn_hero0:addChild(icon_hero)
  local lbl_btn_hero = lbl.createFont1(16, i18n.global.hook_btn_hero.string, ccc3(131, 65, 29))
  lbl_btn_hero:setPosition(CCPoint(btn_hero0:getContentSize().width / 2 + 10, 21))
  btn_hero0:addChild(lbl_btn_hero)
  local btn_hero = SpineMenuItem:create(json.ui.button, btn_hero0)
  btn_hero:setScale(view.minScale)
  btn_hero:setPosition(scalep(276, 227))
  local btn_hero_menu = CCMenu:createWithItem(btn_hero)
  btn_hero_menu:setPosition(CCPoint(0, 0))
  icon_layer:addChild(btn_hero_menu)
  btn_hero:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.herolist.main").create({back = "hook"}), 10000)
   end)
  local btn_map0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_map0:setPreferredSize(CCSizeMake(148, 42))
  local icon_map = img.createUISprite(img.ui.hook_icon_map)
  icon_map:setPosition(CCPoint(19, 21))
  btn_map0:addChild(icon_map)
  addRedDot(btn_map0, {px = btn_map0:getContentSize().width - 7, py = btn_map0:getContentSize().height - 4})
  delRedDot(btn_map0)
  local lbl_btn_map = lbl.createFont1(16, i18n.global.hook_btn_map.string, ccc3(131, 65, 29))
  lbl_btn_map:setPosition(CCPoint(btn_map0:getContentSize().width / 2 + 10, 21))
  btn_map0:addChild(lbl_btn_map)
  local btn_map = SpineMenuItem:create(json.ui.button, btn_map0)
  btn_map:setScale(view.minScale)
  btn_map:setPosition(scalep(684, 227))
  local btn_map_menu = CCMenu:createWithItem(btn_map)
  btn_map_menu:setPosition(CCPoint(0, 0))
  icon_layer:addChild(btn_map_menu, 100)
  btn_map:registerScriptTapHandler(function()
    audio.play(audio.button)
    local hint_flag = true
    if hookdata.fort_hint_flag then
      hookdata.fort_hint_flag = nil
      local tmp_pve_stage_id = hookdata.getPveStageId()
      if hookdata.lastStage() < tmp_pve_stage_id then
        hint_flag = nil
      else
        hint_flag = hookdata.getFortIdByStageId(tmp_pve_stage_id)
      end
    end
    replaceScene(require("ui.hook.map").create(nil, hint_flag))
   end)
  local particle_scale = view.minScale
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
  json.load(json.ui.guaji_yellow_btn)
  local map_ani = DHSkeletonAnimation:createWithKey(json.ui.guaji_yellow_btn)
  map_ani:scheduleUpdateLua()
  map_ani:playAnimation("animation", -1)
  map_ani:setAnchorPoint(CCPoint(0.5, 0.5))
  map_ani:setPosition(CCPoint(74, 21))
  btn_map:addChild(map_ani)
  local runParticle = function(l_8_0)
    shine_particle:setVisible(true)
    shine_particle2:setVisible(true)
    shine_particle:setPosition(map_ani:getBonePositionRelativeToLayer("code_fx"))
    shine_particle2:setPosition(map_ani:getBonePositionRelativeToLayer("code_fx"))
   end
  local stopParticle = function()
    shine_particle:setVisible(false)
    shine_particle2:setVisible(false)
   end
  local anyReward = function()
    if hookdata.reward and hookdata.reward.items and #hookdata.reward.items > 0 then
      return true
    end
    if hookdata.reward and hookdata.reward.equips and #hookdata.reward.equips > 0 then
      return true
    end
    return false
   end
  local btn_help0 = img.createUISprite(img.ui.btn_help)
  local btn_help = SpineMenuItem:create(json.ui.button, btn_help0)
  btn_help:setPosition(CCPoint(bg_w - 40, bg_h - 33))
  local btn_help_menu = CCMenu:createWithItem(btn_help)
  btn_help_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_help_menu)
  btn_help:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.help").create(i18n.global.help_hook.string), 1000)
   end)
  autoLayoutShift(btn_help)
  local btn_rank0 = img.createUISprite(img.ui.btn_rank)
  local btn_rank = SpineMenuItem:create(json.ui.button, btn_rank0)
  btn_rank:setPosition(CCPoint(bg_w - 90, bg_h - 33))
  local btn_rank_menu = CCMenu:createWithItem(btn_rank)
  btn_rank_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_rank_menu)
  btn_rank:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.hook.rank").create(), 1000)
   end)
  autoLayoutShift(btn_rank)
  local p_offset_x = 0
  local p_offset_y = -2
  local btn_drops0 = img.createUISprite(img.ui.hook_btn_drops)
  local btn_drops = SpineMenuItem:create(json.ui.button, btn_drops0)
  btn_drops:setScale(view.minScale)
  btn_drops:setPosition(scalep(p_offset_x + 72, p_offset_y + 464))
  local btn_drops_menu = CCMenu:createWithItem(btn_drops)
  btn_drops_menu:setPosition(CCPoint(0, 0))
  icon_layer:addChild(btn_drops_menu, 100)
  local btn_reward0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_reward0:setPreferredSize(CCSizeMake(148, 42))
  addRedDot(btn_reward0, {px = btn_reward0:getContentSize().width - 7, py = btn_reward0:getContentSize().height - 4})
  delRedDot(btn_reward0)
  local icon_reward = img.createUISprite(img.ui.hook_icon_reward)
  icon_reward:setPosition(CCPoint(19, 21))
  btn_reward0:addChild(icon_reward)
  local lbl_btn_reward = lbl.createFont1(16, i18n.global.hook_btn_reward.string, ccc3(131, 65, 29))
  lbl_btn_reward:setPosition(CCPoint(btn_reward0:getContentSize().width / 2 + 10, 21))
  btn_reward0:addChild(lbl_btn_reward)
  local btn_reward = SpineMenuItem:create(json.ui.button, btn_reward0)
  btn_reward:setScale(view.minScale)
  btn_reward:setPosition(scalep(838, 227))
  local btn_reward_menu = CCMenu:createWithItem(btn_reward)
  btn_reward_menu:setPosition(CCPoint(0, 0))
  icon_layer:addChild(btn_reward_menu, 100)
  btn_reward:registerScriptTapHandler(function()
    audio.play(audio.button)
    if not anyReward() then
      showToast(i18n.global.hook_no_reward.string)
      return 
    end
    local params = {sid = player.sid, type = 2}
    addWaitNet()
    hookdata.hook_reward(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      if l_1_0.reward and l_1_0.reward.items then
        bagdata.items.addAll(l_1_0.reward.items)
      end
      if l_1_0.reward and l_1_0.reward.equips then
        bagdata.equips.addAll(l_1_0.reward.equips)
      end
      hookdata.set_reward({})
      if l_1_0.reward then
        layer:addChild(require("ui.hook.drops").create(l_1_0.reward), 1000)
      end
      end)
   end)
  local btn_coin0 = img.createItemIcon2(ITEM_ID_COIN)
  local btn_coin = SpineMenuItem:create(json.ui.button, btn_coin0)
  btn_coin:setScale(view.minScale * 0.76)
  btn_coin:setPosition(scalep(528, p_offset_y + 467))
  local btn_coin_menu = CCMenu:createWithItem(btn_coin)
  btn_coin_menu:setPosition(CCPoint(0, 0))
  icon_layer:addChild(btn_coin_menu, 100)
  local lbl_play_coin = lbl.createFont2(18, "5/s", ccc3(255, 246, 216), true)
  lbl_play_coin:setAnchorPoint(CCPoint(0, 0.5))
  lbl_play_coin:setPosition(CCPoint(btn_coin:boundingBox():getMaxX() + 6 * view.minScale, view.minY + (p_offset_y + 467) * view.minScale))
  icon_layer:addChild(lbl_play_coin, 100)
  local btn_pxp0 = img.createItemIcon2(ITEM_ID_PLAYER_EXP)
  local btn_pxp = SpineMenuItem:create(json.ui.button, btn_pxp0)
  btn_pxp:setScale(view.minScale * 0.72)
  btn_pxp:setPosition(scalep(720, p_offset_y + 467))
  local btn_pxp_menu = CCMenu:createWithItem(btn_pxp)
  btn_pxp_menu:setPosition(CCPoint(0, 0))
  icon_layer:addChild(btn_pxp_menu, 100)
  local lbl_play_pxp = lbl.createFont2(18, "10/s", ccc3(255, 246, 216), true)
  lbl_play_pxp:setAnchorPoint(CCPoint(0, 0.5))
  lbl_play_pxp:setPosition(CCPoint(btn_pxp:boundingBox():getMaxX() + 6 * view.minScale, view.minY + (p_offset_y + 467) * view.minScale))
  icon_layer:addChild(lbl_play_pxp, 100)
  local btn_hxp0 = img.createItemIcon(ITEM_ID_HERO_EXP)
  local btn_hxp = SpineMenuItem:create(json.ui.button, btn_hxp0)
  btn_hxp:setScale(view.minScale * 0.38)
  btn_hxp:setPosition(scalep(624, p_offset_y + 467))
  local btn_hxp_menu = CCMenu:createWithItem(btn_hxp)
  btn_hxp_menu:setPosition(CCPoint(0, 0))
  icon_layer:addChild(btn_hxp_menu, 100)
  local lbl_play_hxp = lbl.createFont2(18, "10/s", ccc3(255, 246, 216), true)
  lbl_play_hxp:setAnchorPoint(CCPoint(0, 0.5))
  lbl_play_hxp:setPosition(CCPoint(btn_hxp:boundingBox():getMaxX() + 6 * view.minScale, view.minY + (p_offset_y + 467) * view.minScale))
  icon_layer:addChild(lbl_play_hxp, 100)
  json.load(json.ui.guaji_green_btn)
  local btn_get0 = DHSkeletonAnimation:createWithKey(json.ui.guaji_green_btn)
  btn_get0:scheduleUpdateLua()
  btn_get0:playAnimation("animation", -1)
  local lbl_btn_get = lbl.createFont1(20, i18n.global.hook_btn_get.string, ccc3(31, 96, 6))
  btn_get0:addChildFollowSlot("code_font", lbl_btn_get)
  local btn_get_box = CCSprite:create()
  btn_get_box:setContentSize(CCSizeMake(88, 40))
  btn_get0:setPosition(CCPoint(44, 20))
  btn_get_box:addChild(btn_get0)
  local btn_get = SpineMenuItem:create(json.ui.button, btn_get_box)
  btn_get:setScale(view.minScale)
  btn_get:setPosition(scalep(871, p_offset_y + 467))
  local btn_get_menu = CCMenu:createWithItem(btn_get)
  btn_get_menu:setPosition(CCPoint(0, 0))
  icon_layer:addChild(btn_get_menu, 100)
  local ani_get_01 = DHSkeletonAnimation:createWithKey(json.ui.hook_reward_01)
  ani_get_01:setScale(view.minScale)
  ani_get_01:scheduleUpdateLua()
  ani_get_01:setPosition(scalep(528, p_offset_y + 451))
  icon_layer:addChild(ani_get_01)
  local ani_get_02 = DHSkeletonAnimation:createWithKey(json.ui.hook_reward_02)
  ani_get_02:setScale(view.minScale)
  ani_get_02:scheduleUpdateLua()
  ani_get_02:setPosition(scalep(624, p_offset_y + 451))
  icon_layer:addChild(ani_get_02)
  local ani_get_03 = DHSkeletonAnimation:createWithKey(json.ui.hook_reward_03)
  ani_get_03:setScale(view.minScale)
  ani_get_03:scheduleUpdateLua()
  ani_get_03:setPosition(scalep(720, p_offset_y + 451))
  icon_layer:addChild(ani_get_03)
  btn_get:registerScriptTapHandler(function()
    disableObjAWhile(btn_get, 2)
    audio.play(audio.get_gold_exp)
    if hookdata.getHookStage() <= 0 then
      showToast(i18n.global.hook_not_hooking.string)
      return 
    end
    local params = {sid = player.sid, type = 1}
    addWaitNet()
    hookdata.hook_reward(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      btn_get:setVisible(false)
      local will_check_lv = false
      if player.maxLv() <= player.lv() then
        will_check_lv = false
      else
        will_check_lv = true
      end
      require("data.tutorial").goNext("hook2", 3, true)
      if l_1_0.reward and l_1_0.reward.items then
        bagdata.items.addAll(l_1_0.reward.items)
      end
      if l_1_0.reward and l_1_0.reward.equips then
        bagdata.equips.addAll(l_1_0.reward.equips)
      end
      local taskdata = require("data.task")
      taskdata.increment(taskdata.TaskType.HOOK_GET)
      local g_coin, g_pxp, g_hxp = coinAndExp(l_1_0.reward)
      if will_check_lv then
        checkLevelUp(g_pxp)
      end
      local arr_get = CCArray:create()
      arr_get:addObject(CCCallFunc:create(function()
        ani_get_01:playAnimation("animation", 1)
        ani_get_02:playAnimation("animation", 1)
        ani_get_03:playAnimation("animation", 1)
        json.load(json.ui.hook_pariticle)
        local ani_particle = DHSkeletonAnimation:createWithKey(json.ui.hook_pariticle)
        ani_particle:setScale(view.minScale)
        ani_particle:scheduleUpdateLua()
        ani_particle:playAnimation("animation")
        ani_particle:setPosition(scalep(480, 288))
        layer:addChild(ani_particle, 10000)
        local particle_coin = particle.create("decompose_particle4")
        layer:addChild(particle_coin, 10000)
        local particle_hxp = particle.create("decompose_particle5")
        layer:addChild(particle_hxp, 10000)
        local partileUpdate = function()
          particle_coin:setPosition(ani_particle:getBonePositionRelativeToLayer("code_particle_01"))
          particle_hxp:setPosition(ani_particle:getBonePositionRelativeToLayer("code_particle_02"))
            end
        icon_layer:scheduleUpdateWithPriorityLua(partileUpdate, 0)
        schedule(icon_layer, 0.8, function()
          icon_layer:unscheduleUpdate()
            end)
         end))
      arr_get:addObject(CCDelayTime:create(0.1))
      arr_get:addObject(CCCallFunc:create(function()
        hookdata.resetOutput()
         end))
      layer:runAction(CCSequence:create(arr_get))
      end)
   end)
  local pgb_bg = img.createUI9Sprite(img.ui.hook_pgb_bg)
  pgb_bg:setPreferredSize(CCSizeMake(657, 32))
  pgb_bg:setScale(view.minScale)
  pgb_bg:setPosition(scalep(480, p_offset_y + 209))
  icon_layer:addChild(pgb_bg, 100)
  local pgb_fg = img.createUISprite(img.ui.hook_pgb_fg)
  local pgb = createProgressBar(pgb_fg)
  pgb:setPosition(CCPoint(pgb_bg:getContentSize().width / 2, pgb_bg:getContentSize().height / 2))
  pgb_bg:addChild(pgb)
  pgb:setPercentage(20)
  local lbl_boss_cd = lbl.createFont2(16, "", ccc3(255, 246, 223))
  lbl_boss_cd:setPosition(CCPoint(pgb_bg:getContentSize().width / 2, pgb_bg:getContentSize().height / 2))
  pgb_bg:addChild(lbl_boss_cd, 2)
  pgb_bg:setVisible(false)
  json.load(json.ui.guaji_red_btn)
  local btn_pve0 = DHSkeletonAnimation:createWithKey(json.ui.guaji_red_btn)
  btn_pve0:scheduleUpdateLua()
  local lbl_btn_pve = lbl.createFont1(22, i18n.global.hook_btn_pve.string, ccc3(126, 39, 0))
  btn_pve0:addChildFollowSlot("code_font", lbl_btn_pve)
  local lbl_btn_pve2 = lbl.createFont1(16, i18n.global.hook_btn_pve.string, ccc3(47, 69, 139))
  btn_pve0:addChildFollowSlot("code_font2", lbl_btn_pve2)
  local lbl_btn_pve3 = lbl.createFont2(22, "00:00:00")
  btn_pve0:addChildFollowSlot("code_font3", lbl_btn_pve3)
  local btn_pve_box = CCSprite:create()
  btn_pve_box:setContentSize(CCSizeMake(252, 57))
  btn_pve0:setPosition(CCPoint(126, 0))
  btn_pve_box:addChild(btn_pve0)
  local btn_pve = HHMenuItem:createWithScale(btn_pve_box, 1)
  btn_pve:setScale(view.minScale)
  btn_pve:setAnchorPoint(CCPoint(0.5, 0))
  btn_pve:setPosition(scalep(480, p_offset_y + 199))
  local btn_pve_menu = CCMenu:createWithItem(btn_pve)
  btn_pve_menu:setPosition(CCPoint(0, 0))
  icon_layer:addChild(btn_pve_menu, 100)
  local btn_pve_cd_bg = img.createUISprite(img.ui.hook_btn_cd_bg)
  btn_pve_cd_bg:setScale(view.minScale)
  btn_pve_cd_bg:setAnchorPoint(CCPoint(0.5, 0))
  btn_pve_cd_bg:setPosition(scalep(480, p_offset_y + 199))
  icon_layer:addChild(btn_pve_cd_bg, 100)
  local btn_pve_cd_fg = img.createUISprite(img.ui.hook_btn_cd_fg)
  local btn_pve_pgb = createProgressBar(btn_pve_cd_fg)
  btn_pve_pgb:setAnchorPoint(CCPoint(0.5, 0))
  btn_pve_pgb:setPosition(CCPoint(btn_pve_cd_bg:getContentSize().width / 2, 0))
  btn_pve_cd_bg:addChild(btn_pve_pgb)
  local lbl_btn_pve4 = lbl.createFont2(22, "00:00:00")
  lbl_btn_pve4:setPosition(CCPoint(btn_pve_cd_bg:getContentSize().width / 2, 26))
  btn_pve_cd_bg:addChild(lbl_btn_pve4, 100)
  local cdPercent = function()
    local boss_time = hookdata.getStageBossCD()
    local time_cd = hookdata.boss_cd - getMilliSecond() / 1000 + hookdata.init_time
    local time_str = time2string(checkint(time_cd))
    lbl_btn_pve4:setString(time_str)
    local percent = (boss_time - time_cd) * 100 / boss_time
    btn_pve_pgb:setPercentage(percent)
   end
  local btn_pve_pass = img.createUISprite(img.ui.hook_btn_battle_pass)
  btn_pve_pass:setScale(view.minScale)
  btn_pve_pass:setAnchorPoint(CCPoint(0.5, 0))
  btn_pve_pass:setPosition(scalep(480, p_offset_y + 199))
  icon_layer:addChild(btn_pve_pass, 90)
  local lbl_pve_pass = lbl.createFont1(24, i18n.global.hook_btn_passed.string, ccc3(255, 215, 107))
  lbl_pve_pass:setPosition(CCPoint(btn_pve_pass:getContentSize().width / 2, 29))
  btn_pve_pass:addChild(lbl_pve_pass)
  local last_battle_st = nil
  local playBattle1 = function()
    btn_pve_pass:setVisible(false)
    btn_pve:setVisible(true)
    if last_battle_st and last_battle_st == "bt1" then
      return 
    end
    upvalue_1024 = "bt1"
    btn_pve0:playAnimation("animation", -1)
   end
  local playBattle2 = function()
    btn_pve_pass:setVisible(false)
    btn_pve:setVisible(true)
    if last_battle_st and last_battle_st == "bt2" then
      return 
    end
    upvalue_1024 = "bt2"
    btn_pve0:playAnimation("animation2", -1)
   end
  local checkBattleSt = function()
    local tmp_stage_id = hookdata.getHookStage()
    if tmp_stage_id <= 0 then
      lbl_pve_pass:setVisible(false)
      btn_pve_pass:setVisible(true)
      btn_pve:setVisible(false)
      btn_pve_cd_bg:setVisible(false)
      return 
    else
      lbl_pve_pass:setVisible(true)
    end
    local tmp_pve_stage_id = hookdata.getPveStageId()
    if tmp_stage_id ~= tmp_pve_stage_id then
      btn_pve_pass:setVisible(true)
      btn_pve:setVisible(false)
      btn_pve_cd_bg:setVisible(false)
      return 
    end
    if hookdata.boss_cd and os.time() - hookdata.init_time < hookdata.boss_cd then
      btn_pve_pass:setVisible(false)
      btn_pve:setVisible(false)
      btn_pve_cd_bg:setVisible(true)
      cdPercent()
    else
      btn_pve_pass:setVisible(false)
      btn_pve:setVisible(true)
      btn_pve_cd_bg:setVisible(false)
      playBattle1()
    end
   end
  checkBattleSt()
  btn_pve:registerScriptTapHandler(function()
    disableObjAWhile(btn_pve)
    if last_battle_st and last_battle_st == "bt1" then
      audio.play(audio.button)
      layer:addChild(require("ui.selecthero.main").create({type = "pve"}), 10000)
    end
   end)
  local SCROLL_VIEW_W = 768
  local SCROLL_VIEW_H = 135
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionHorizontal)
  scroll:setViewSize(CCSize(SCROLL_VIEW_W, SCROLL_VIEW_H))
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(43, 13))
  stage_board:addChild(scroll)
  local content_layer = CCLayer:create()
  content_layer:setAnchorPoint(CCPoint(0, 0))
  content_layer:setPosition(CCPoint(0, 0))
  scroll:getContainer():addChild(content_layer, 1, TAG_CONTENT_LAYER)
  scroll.content_layer = content_layer
  addStageFocus = function(l_20_0)
    json.load(json.ui.guaji_xuanguan)
    local next_ani = DHSkeletonAnimation:createWithKey(json.ui.guaji_xuanguan)
    next_ani:scheduleUpdateLua()
    next_ani:setPosition(CCPoint(l_20_0:getContentSize().width / 2, l_20_0:getContentSize().height / 2))
    l_20_0:addChild(next_ani)
    next_ani:playAnimation("animation", -1)
    l_20_0.ani = next_ani
   end
  addRadar = function(l_21_0)
    local stage_anim = DHSkeletonAnimation:createWithKey(json.ui.radar)
    stage_anim:scheduleUpdateLua()
    stage_anim:playAnimation("radar", -1)
    stage_anim:setAnchorPoint(CCPoint(0.5, 0.5))
    stage_anim:setPosition(CCPoint(50, 50))
    l_21_0:addChild(stage_anim)
   end
  local stage_id = hookdata.getHookStage()
  local fort_id = hookdata.getFortIdByStageId(stage_id)
  local pve_stage_id = hookdata.getPveStageId()
  local createStageItem = function(l_22_0)
    local btn_stage0 = img.createUISprite(img.ui.hook_btn_stage_bg)
    local fortInfo = hookdata.getFortByStageId(l_22_0)
    local stage_name = fort_id .. "-" .. l_22_0 - fortInfo.stageId[1] + 1
    local lbl_stage_name = lbl.createFont1(22, stage_name, ccc3(131, 65, 29))
    lbl_stage_name:setPosition(CCPoint(btn_stage0:getContentSize().width / 2, 50))
    btn_stage0:addChild(lbl_stage_name)
    if l_22_0 < pve_stage_id then
      do return end
    end
    if l_22_0 == pve_stage_id and hookdata.getStageLv(l_22_0) <= player.lv() then
      do return end
    end
    do
      local icon_lock = img.createUISprite(img.ui.hook_btn_lock)
      icon_lock:setPosition(CCPoint(btn_stage0:getContentSize().width / 2, btn_stage0:getContentSize().height / 2))
      btn_stage0:addChild(icon_lock)
      lbl_stage_name:setVisible(false)
    end
    if l_22_0 == stage_id then
      addRadar(btn_stage0)
    elseif uiParams and uiParams.win and l_22_0 == stage_id + 1 then
      addStageFocus(btn_stage0)
    end
    return btn_stage0
   end
  local stage_offset_x = 91
  local stage_step_x = 150
  local createStageList = function(l_23_0)
    content_layer:removeAllChildrenWithCleanup(true)
    arrayclear(stage_items)
    local fortInfo = hookdata.getFortByStageId(l_23_0)
    local list_width = 0
    for ii = 1, #fortInfo.stageId do
      local tmp_stage_item = createStageItem(fortInfo.stageId[ii])
      tmp_stage_item.stage_id = fortInfo.stageId[ii]
      tmp_stage_item:setPosition(CCPoint(stage_offset_x + (ii - 1) * stage_step_x, SCROLL_VIEW_H / 2))
      content_layer:addChild(tmp_stage_item)
      stage_items[#stage_items + 1] = tmp_stage_item
      list_width = stage_offset_x + (ii - 1) * stage_step_x + 100
    end
    if SCROLL_VIEW_W < list_width then
      scroll:setContentSize(CCSizeMake(list_width, SCROLL_VIEW_H))
    else
      scroll:setContentSize(CCSizeMake(SCROLL_VIEW_W, SCROLL_VIEW_H))
    end
    local stage_count = #fortInfo.stageId
    local cur_idx = l_23_0 - fortInfo.stageId[1] + 1
    if cur_idx <= 0 then
      cur_idx = 1
    end
    if stage_count - cur_idx <= 3 then
      cur_idx = stage_count - 3
    end
    if cur_idx <= 2 then
      cur_idx = 2
    end
    scroll:setContentOffset(CCPoint(0 - (cur_idx - 2) * stage_step_x, 0))
   end
  createStageList(stage_id)
  local onClickItem = function(l_24_0)
    if l_24_0.focus then
      l_24_0:stopAllActions()
      l_24_0.focus = nil
    end
    if l_24_0.ani and not tolua.isnull(l_24_0.ani) then
      l_24_0.ani:removeFromParentAndCleanup(true)
    end
    local tmp_stage_id = l_24_0.stage_id
    if tmp_stage_id == pve_stage_id then
      if player.lv() < hookdata.getStageLv(tmp_stage_id) then
        local tmp_tip = require("ui.hook.powerTip").create(1, tmp_stage_id)
        local pp1 = CCPoint(l_24_0:getPosition())
        local pp2 = scroll:getContentOffset()
        local p0 = layer:convertToNodeSpace(ccpAdd(pp1, pp2))
        tmp_tip.adaptPos(p0)
        layer:addChild(tmp_tip, 1000)
        return 
      end
      if hookdata.getAllPower() < hookdata.stage_power(tmp_stage_id) then
        local tmp_tip = require("ui.hook.powerTip").create(1, tmp_stage_id)
        local pp1 = CCPoint(l_24_0:getPosition())
        local pp2 = scroll:getContentOffset()
        local p0 = layer:convertToNodeSpace(ccpAdd(pp1, pp2))
        tmp_tip.adaptPos(p0)
        layer:addChild(tmp_tip, 1000)
        return 
      elseif pve_stage_id < tmp_stage_id then
        local tmp_tip = require("ui.hook.powerTip").create(2, tmp_stage_id)
        local pp1 = CCPoint(l_24_0:getPosition())
        local pp2 = scroll:getContentOffset()
        local p0 = layer:convertToNodeSpace(ccpAdd(pp1, pp2))
        tmp_tip.adaptPos(p0)
        layer:addChild(tmp_tip, 1000)
        return 
      end
    end
    layer:addChild(require("ui.hook.stage").create(tmp_stage_id), 1000)
   end
  btn_drops:registerScriptTapHandler(function()
    audio.play(audio.button)
    upvalue_512 = hookdata.getHookStage()
    if stage_id <= 0 then
      return 
    end
    layer:addChild(require("ui.hook.stage").create(stage_id), 1000)
   end)
  local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
  local onTouchBegan = function(l_26_0, l_26_1)
    touchbeginx, upvalue_512 = l_26_0, l_26_1
    upvalue_1024 = true
    if scroll and not tolua.isnull(scroll) then
      local p0 = content_layer:convertToNodeSpace(ccp(l_26_0, l_26_1))
      for ii = 1, #stage_items do
        if stage_items[ii]:boundingBox():containsPoint(p0) then
          if stage_items[ii].stage_id ~= stage_id then
            playAnimTouchBegin(stage_items[ii])
            upvalue_3584 = stage_items[ii]
          else
            upvalue_1024 = false
            return false
          end
      else
        end
      end
    end
  end
  return true
   end
  local onTouchMoved = function(l_27_0, l_27_1)
    if isclick and (math.abs(touchbeginx - l_27_0) > 10 or math.abs(touchbeginy - l_27_1) > 10) then
      isclick = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        playAnimTouchEnd(last_touch_sprite)
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_28_0, l_28_1)
    if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
      playAnimTouchEnd(last_touch_sprite)
      last_touch_sprite = nil
    end
    if isclick and scroll and not tolua.isnull(scroll) then
      local p0 = content_layer:convertToNodeSpace(ccp(l_28_0, l_28_1))
      for ii = 1, #stage_items do
        if stage_items[ii]:boundingBox():containsPoint(p0) then
          audio.play(audio.button)
          onClickItem(stage_items[ii])
      else
        end
      end
    end
   end
  local onTouch = function(l_29_0, l_29_1, l_29_2)
    if l_29_0 == "began" then
      return onTouchBegan(l_29_1, l_29_2)
    elseif l_29_0 == "moved" then
      return onTouchMoved(l_29_1, l_29_2)
    else
      return onTouchEnded(l_29_1, l_29_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    fightAnim:unloadAllResources()
    if uiParams and uiParams.from_layer == "task" then
      replaceScene(require("ui.town.main").create({from_layer = "task"}))
    else
      replaceScene(require("ui.town.main").create())
    end
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
    if isIOSLowerModel() then
      json.unloadAll(resources.jsons)
      img.unloadAll(resources.imgs)
      img.unloadHookMap(thumbnail)
    end
   end
  layer:registerScriptHandler(function(l_33_0)
    if l_33_0 == "enter" then
      onEnter()
    elseif l_33_0 == "exit" then
      onExit()
    end
   end)
  local askReward = function()
    if os.time() - last_ask < ASK_INTERVAL then
      return 
    end
    last_ask = os.time()
    local params = {sid = player.sid}
    hookdata.hook_ask(params, function(l_1_0)
      tbl2string(l_1_0)
      if l_1_0.status == 0 then
        if not l_1_0.reward then
          hookdata.set_reward({})
        end
      end
      end)
   end
  local last_output_update = os.time() - hookdata.OUTPUT_INTERVAL
  updateOutput = function()
    if not hookdata.status or hookdata.status ~= 0 then
      return 
    end
    upvalue_512 = os.time()
    local tmp_coins = hookdata.coins or 0
    if tmp_coins > 10000000 then
      tmp_coins = math.floor(tmp_coins / 1000000) .. "M"
    elseif tmp_coins > 10000 then
      tmp_coins = math.floor(tmp_coins / 1000) .. "K"
    end
    local tmp_pxps = hookdata.pxps or 0
    if tmp_pxps > 10000000 then
      tmp_pxps = math.floor(tmp_pxps / 1000000) .. "M"
    elseif tmp_pxps > 10000 then
      tmp_pxps = math.floor(tmp_pxps / 1000) .. "K"
    end
    local tmp_hxps = hookdata.hxps or 0
    if tmp_hxps > 10000000 then
      tmp_hxps = math.floor(tmp_hxps / 1000000) .. "M"
    elseif tmp_hxps > 10000 then
      tmp_hxps = math.floor(tmp_hxps / 1000) .. "K"
    end
    if player.maxLv() <= player.lv() then
      tmp_pxps = 0
      btn_pxp:setVisible(false)
      lbl_play_pxp:setVisible(false)
    else
      btn_pxp:setVisible(true)
      lbl_play_pxp:setVisible(true)
    end
    lbl_play_coin:setString(tmp_coins or 0)
    lbl_play_pxp:setString(tmp_pxps or 0)
    lbl_play_hxp:setString(tmp_hxps or 0)
    if hookdata.coins and hookdata.coins > 0 then
      btn_get:setVisible(true)
    else
      btn_get:setVisible(false)
    end
   end
  local checkLastPVE = function()
    if hookdata.fort_hint_flag then
      local tmp_stage_id = hookdata.getHookStage()
      local tmp_pve_stage_id = hookdata.getPveStageId()
      if hookdata.lastStage() < tmp_pve_stage_id then
        return false
      end
      local fortInfo = hookdata.getFortByStageId(hookdata.getHookStage())
      if fortInfo.stageId[#fortInfo.stageId] == tmp_stage_id and tmp_pve_stage_id and tmp_stage_id < tmp_pve_stage_id then
        return true
      end
    end
    return false
   end
  local last_update = os.time()
  local onUpdate = function(l_37_0)
    updateOutput()
    askReward()
    if checkLastPVE() then
      addRedDot(btn_map0, {px = btn_map0:getContentSize().width - 7, py = btn_map0:getContentSize().height - 4})
      runParticle(l_37_0)
    else
      delRedDot(btn_map0)
      stopParticle()
    end
    checkBattleSt()
    if os.time() - last_update < 1 then
      return 
    end
    upvalue_3584 = os.time()
    updateLabels()
    if anyReward() then
      addRedDot(btn_reward0, {px = btn_reward0:getContentSize().width - 7, py = btn_reward0:getContentSize().height - 4})
    else
      delRedDot(btn_reward0)
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  if l_1_0 and l_1_0.pop_layer == "stage" then
    schedule(layer, function()
    layer:addChild(require("ui.hook.stage").create(uiParams.stage_id), 1000)
   end)
  end
  require("ui.tutorial").show("ui.hook.main", layer)
  return layer
end

return ui

