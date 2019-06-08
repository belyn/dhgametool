-- Command line was: E:\github\dhgametool\scripts\ui\activity\crushboss3.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.activity")
local player = require("data.player")
local activityData = require("data.activity")
local net = require("net.netClient")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local bag = require("data.bag")
local crushbossfight = require("ui.activity.crushbossfight")
local IDS = activityData.IDS
local ItemType = {Item = 1, Equip = 2}
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(570, 438))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(352, 57))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.unload(img.packedOthers.ui_activity_crushing_space3)
  img.unload(img.packedOthers.ui_activity_crushing_space3_cn)
  if i18n.getCurrentLanguage() == kLanguageChinese or i18n.getCurrentLanguage() == kLanguageChineseTW then
    img.load(img.packedOthers.ui_activity_crushing_space3_cn)
  else
    img.load(img.packedOthers.ui_activity_crushing_space3)
  end
  local banner = img.createUISprite(img.ui.activity_crush_board3)
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2, board_h - 10))
  board:addChild(banner)
  local btn_rank0 = img.createUISprite(img.ui.btn_rank)
  local btn_rank = SpineMenuItem:create(json.ui.button, btn_rank0)
  btn_rank:setPosition(CCPoint(100, 40))
  local btn_rank_menu = CCMenu:createWithItem(btn_rank)
  btn_rank_menu:setPosition(CCPoint(0, 0))
  banner:addChild(btn_rank_menu)
  btn_rank:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:getParent():getParent():addChild(require("ui.activity.crushbossrank").create(3), 1000)
   end)
  local btn_reward0 = img.createUISprite(img.ui.reward)
  local btn_reward = SpineMenuItem:create(json.ui.button, btn_reward0)
  btn_reward:setPosition(CCPoint(46, 40))
  local btn_reward_menu = CCMenu:createWithItem(btn_reward)
  btn_reward_menu:setPosition(CCPoint(0, 0))
  banner:addChild(btn_reward_menu)
  btn_reward:registerScriptTapHandler(function()
    audio.play(audio.button)
    local gParams = {sid = player.sid, id = 3}
    addWaitNet()
    net:bboss_syn(gParams, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      layer:getParent():getParent():addChild(require("ui.activity.crushreward").create(3, l_1_0.id), 1000)
      end)
   end)
  local btnInfoSprite = img.createUISprite(img.ui.btn_help)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  btnInfo:setPosition(505, 205)
  local menuInfo = CCMenu:createWithItem(btnInfo)
  menuInfo:setPosition(0, 0)
  banner:addChild(menuInfo, 100)
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:getParent():getParent():addChild(require("ui.help").create(i18n.global.broken_space_help3.string, i18n.global.help_title.string), 1000)
   end)
  local lbl_cd_des = lbl.createFont2(14, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd_des:setPosition(CCPoint(492, 30))
  banner:addChild(lbl_cd_des)
  local lbl_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(1, 0.5))
  lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMinX() - 6, 30))
  banner:addChild(lbl_cd)
  local temp_item = img.createUI9Sprite(img.ui.bottom_border_2)
  temp_item:setPreferredSize(CCSizeMake(542, 170))
  temp_item:setAnchorPoint(CCPoint(0, 0))
  temp_item:setPosition(CCPoint(14, 6))
  local item_w = temp_item:getContentSize().width
  local item_h = temp_item:getContentSize().height
  board:addChild(temp_item)
  local tick_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  tick_bg:setPreferredSize(CCSizeMake(145, 36))
  tick_bg:setPosition(CCPoint(item_w / 2 + 18, 120))
  board:addChild(tick_bg)
  local icon_tick = img.createItemIcon2(ITEM_ID_BROKEN)
  icon_tick:setPosition(CCPoint(5, tick_bg:getContentSize().height / 2 + 2))
  tick_bg:addChild(icon_tick)
  local btn_tick0 = img.createUISprite(img.ui.main_icon_plus)
  local btn_tick = HHMenuItem:create(btn_tick0)
  btn_tick:setPosition(CCPoint(tick_bg:getContentSize().width - 18, tick_bg:getContentSize().height / 2 + 2))
  local btn_tick_menu = CCMenu:createWithItem(btn_tick)
  btn_tick_menu:setPosition(CCPoint(0, 0))
  tick_bg:addChild(btn_tick_menu)
  local tick_num = 0
  if bag.items.find(ITEM_ID_BROKEN) then
    tick_num = bag.items.find(ITEM_ID_BROKEN).num
  end
  local lbl_tick = lbl.createFont2(16, tick_num, ccc3(255, 246, 223))
  lbl_tick:setPosition(CCPoint(tick_bg:getContentSize().width / 2 - 10, tick_bg:getContentSize().height / 2 + 3))
  tick_bg:addChild(lbl_tick)
  lbl_tick.num = tick_num
  local refreshTick = function(l_4_0)
    lbl_tick:setString(tick_num + l_4_0)
   end
  btn_tick:registerScriptTapHandler(function()
    audio.play(audio.button)
    local buybroken = require("ui.activity.buybroken")
    local buybrokendlg = buybroken.create(refreshTick)
    layer:getParent():getParent():addChild(buybrokendlg, 1001)
   end)
  local battleSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
  battleSprite:setPreferredSize(CCSizeMake(216, 54))
  local battlelab = lbl.createFont1(18, i18n.global.trial_stage_btn_battle.string, lbl.buttonColor)
  battlelab:setPosition(CCPoint(battleSprite:getContentSize().width / 2, battleSprite:getContentSize().height / 2))
  battleSprite:addChild(battlelab)
  local battleBtn = SpineMenuItem:create(json.ui.button, battleSprite)
  battleBtn:setAnchorPoint(0.5, 0)
  battleBtn:setPosition(CCPoint(board_w / 2, 36))
  local battleMenu = CCMenu:createWithItem(battleBtn)
  battleMenu:setPosition(0, 0)
  board:addChild(battleMenu)
  battleBtn:registerScriptTapHandler(function()
    disableObjAWhile(battleBtn)
    audio.play(audio.button)
    layer:getParent():getParent():addChild(crushbossfight.create(3), 1001)
   end)
  local act_st = activityData.getStatusById(IDS.CRUSHING_SPACE_3.ID)
  local last_update = os.time() - 1
  local onUpdate = function(l_7_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    local remain_cd = act_st.cd - (os.time() - activityData.pull_time)
    if remain_cd >= 0 then
      local time_str = time2string(remain_cd)
      lbl_cd:setString(time_str)
    else
       -- Warning: missing end command somewhere! Added here
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui

