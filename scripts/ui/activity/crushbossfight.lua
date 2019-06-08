-- Command line was: E:\github\dhgametool\scripts\ui\activity\crushbossfight.lua 

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
local cfgfriendstage = require("config.brokenboss")
local cfgmonster = require("config.monster")
local player = require("data.player")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local selecthero = require("ui.selecthero.main")
local net = require("net.netClient")
local friendboss = require("data.friendboss")
local bag = require("data.bag")
ui.create = function(l_1_0, l_1_1)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board_bg = img.createUI9Sprite(img.ui.dialog_1)
  board_bg:setPreferredSize(CCSizeMake(735, 488))
  board_bg:setScale(view.minScale)
  board_bg:setPosition(view.midX, view.midY)
  layer:addChild(board_bg)
  local board_bg_w = board_bg:getContentSize().width
  local board_bg_h = board_bg:getContentSize().height
  board_bg:setScale(0.5 * view.minScale)
  board_bg:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  local lbl_title = lbl.createFont1(24, i18n.global.friendboss_enemy_line.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 29))
  board_bg:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.friendboss_enemy_line.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 31))
  board_bg:addChild(lbl_title_shadowD)
  local heroCampBg = img.createUI9Sprite(img.ui.select_hero_camp_bg)
  heroCampBg:setPreferredSize(CCSize(678, 205))
  heroCampBg:setPosition(367, 315)
  board_bg:addChild(heroCampBg, 1)
  local selectTeamBg = img.createUI9Sprite(img.ui.select_tab_tab_bg)
  selectTeamBg:setPreferredSize(CCSize(665, 37))
  selectTeamBg:setPosition(340, 180)
  heroCampBg:addChild(selectTeamBg)
  local enegyBottom = img.createUI9Sprite(img.ui.main_coin_bg)
  enegyBottom:setPreferredSize(CCSizeMake(138, 40))
  enegyBottom:setPosition(CCPoint(80, selectTeamBg:getContentSize().height / 2 - 2))
  selectTeamBg:addChild(enegyBottom)
  local tick_num = 0
  if bag.items.find(ITEM_ID_BROKEN) then
    tick_num = bag.items.find(ITEM_ID_BROKEN).num
  end
  local enegy = string.format("%d", tick_num)
  local showEnegy = lbl.createFont2(18, enegy, ccc3(255, 246, 223))
  showEnegy:setPosition(CCPoint(enegyBottom:getContentSize().width / 2 + 5, enegyBottom:getContentSize().height / 2 + 2))
  enegyBottom:addChild(showEnegy)
  local enegyIcon = img.createUISprite(img.ui.friends_enegy)
  local enegyIcon = img.createItemIcon2(ITEM_ID_BROKEN)
  enegyIcon:setPosition(8, enegyBottom:getContentSize().height / 2 + 4)
  enegyBottom:addChild(enegyIcon)
  local showRewardlayer = function(l_1_0, l_1_1)
    handler(not l_1_1)
    layer:getParent():addChild(require("ui.hook.drops").create(l_1_0, i18n.global.mail_rewards.string), 1000)
    layer:removeFromParent()
   end
  local buyCount = 1
  local selectSweepnumLayer = function(l_2_0)
    local sweepLayer = CCLayer:create()
    buyCount = 1
    local sweepdarkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
    sweepLayer:addChild(sweepdarkbg)
    local sweepboard_bg = img.createUI9Sprite(img.ui.dialog_1)
    sweepboard_bg:setPreferredSize(CCSizeMake(470, 380))
    sweepboard_bg:setScale(view.minScale)
    sweepboard_bg:setPosition(scalep(480, 288))
    sweepLayer:addChild(sweepboard_bg)
    local sweepboard_bg_w = sweepboard_bg:getContentSize().width
    local sweepboard_bg_h = sweepboard_bg:getContentSize().height
    local edit0 = img.createLogin9Sprite(img.login.input_border)
    local edit = CCEditBox:create(CCSizeMake(136 * view.minScale, 40 * view.minScale), edit0)
    edit:setInputMode(kEditBoxInputModeNumeric)
    edit:setReturnType(kKeyboardReturnTypeDone)
    edit:setMaxLength(5)
    edit:setFont("", 16 * view.minScale)
    edit:setText("1")
    edit:setFontColor(ccc3(148, 98, 66))
    edit:setPosition(scalep(480, 308))
    sweepLayer:addChild(edit, 1000)
    sweepLayer.edit = edit
    local sweeplbl_title = lbl.createFont1(24, i18n.global.act_bboss_sweep.string, ccc3(230, 208, 174))
    sweeplbl_title:setPosition(CCPoint(sweepboard_bg_w / 2, sweepboard_bg_h - 29))
    sweepboard_bg:addChild(sweeplbl_title, 2)
    local sweeplbl_title_shadowD = lbl.createFont1(24, i18n.global.act_bboss_sweep.string, ccc3(89, 48, 27))
    sweeplbl_title_shadowD:setPosition(CCPoint(sweepboard_bg_w / 2, sweepboard_bg_h - 31))
    sweepboard_bg:addChild(sweeplbl_title_shadowD)
    local sweeplbl = lbl.createMixFont1(18, i18n.global.act_bboss_sweep_lable.string, ccc3(115, 59, 5))
    sweeplbl:setPosition(CCPoint(sweepboard_bg_w / 2, 275))
    sweepboard_bg:addChild(sweeplbl)
    local icon_ticket = img.createItem(ITEM_ID_TRIAL_TL)
    icon_ticket:setPosition(CCPoint(board_bg_w / 2, 309))
    board_bg:addChild(icon_ticket)
    local btn_sub0 = img.createUISprite(img.ui.btn_sub)
    local btn_sub = SpineMenuItem:create(json.ui.button, btn_sub0)
    btn_sub:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 - 100, 210))
    local btn_sub_menu = CCMenu:createWithItem(btn_sub)
    btn_sub_menu:setPosition(CCPoint(0, 0))
    sweepboard_bg:addChild(btn_sub_menu)
    local btn_add0 = img.createUISprite(img.ui.btn_add)
    local btn_add = SpineMenuItem:create(json.ui.button, btn_add0)
    btn_add:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 + 100, 210))
    local btn_add_menu = CCMenu:createWithItem(btn_add)
    btn_add_menu:setPosition(CCPoint(0, 0))
    sweepboard_bg:addChild(btn_add_menu)
    local btn_min0 = img.createUISprite(img.ui.btn_max)
    btn_min0:setFlipX(true)
    local btn_min = SpineMenuItem:create(json.ui.button, btn_min0)
    btn_min:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 - 150, 210))
    local btn_min_menu = CCMenu:createWithItem(btn_min)
    btn_min_menu:setPosition(CCPoint(0, 0))
    sweepboard_bg:addChild(btn_min_menu)
    local btn_max0 = img.createUISprite(img.ui.btn_max)
    local btn_max = SpineMenuItem:create(json.ui.button, btn_max0)
    btn_max:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 + 150, 210))
    local btn_max_menu = CCMenu:createWithItem(btn_max)
    btn_max_menu:setPosition(CCPoint(0, 0))
    sweepboard_bg:addChild(btn_max_menu)
    local broken_bg = img.createUI9Sprite(img.ui.casino_gem_bg)
    broken_bg:setPreferredSize(CCSizeMake(165, 34))
    broken_bg:setPosition(CCPoint(sweepboard_bg_w / 2, 144))
    sweepboard_bg:addChild(broken_bg)
    local icon_broken = img.createItemIcon2(ITEM_ID_BROKEN)
    icon_broken:setScale(0.8)
    icon_broken:setPosition(CCPoint(30, broken_bg:getContentSize().height / 2))
    broken_bg:addChild(icon_broken)
    local brokennum = 0
    if bag.items.find(ITEM_ID_BROKEN) then
      brokennum = bag.items.find(ITEM_ID_BROKEN).num
    end
    local lbl_pay = lbl.createFont2(16, brokennum)
    lbl_pay:setPosition(CCPoint(100, broken_bg:getContentSize().height / 2))
    broken_bg:addChild(lbl_pay)
    local edit_tickets = sweepLayer.edit
    edit_tickets:registerScriptEditBoxHandler(function(l_1_0)
      if l_1_0 == "returnSend" then
        do return end
      end
      if l_1_0 == "return" then
        do return end
      end
      if l_1_0 == "ended" then
        local tmp_ticket_count = edit_tickets:getText()
        tmp_ticket_count = string.trim(tmp_ticket_count)
        tmp_ticket_count = checkint(tmp_ticket_count)
        if tmp_ticket_count <= 1 then
          tmp_ticket_count = 1
        end
        edit_tickets:setText(tmp_ticket_count)
        upvalue_512 = tmp_ticket_count
      elseif l_1_0 == "began" then
        do return end
      end
      if l_1_0 == "changed" then
         -- Warning: missing end command somewhere! Added here
      end
      end)
    btn_sub:registerScriptTapHandler(function()
      audio.play(audio.button)
      local edt_txt = edit_tickets:getText()
      edt_txt = string.trim(edt_txt)
      if edt_txt == "" then
        edt_txt = 1
        edit_tickets:setText(1)
        upvalue_1024 = 1
        return 
      end
      local ticket_count = checkint(edt_txt)
      if ticket_count <= 1 then
        edit_tickets:setText(1)
        upvalue_1024 = 1
        return 
      else
        ticket_count = ticket_count - 1
        edit_tickets:setText(ticket_count)
        upvalue_1024 = ticket_count
      end
      end)
    btn_add:registerScriptTapHandler(function()
      audio.play(audio.button)
      local edt_txt = edit_tickets:getText()
      edt_txt = string.trim(edt_txt)
      if edt_txt == "" then
        edt_txt = 0
        edit_tickets:setText(0)
        upvalue_1024 = 0
        return 
      end
      local ticket_count = checkint(edt_txt)
      if ticket_count < 0 then
        edit_tickets:setText(0)
        upvalue_1024 = 0
        return 
      else
        local tmp_gem_cost = ticket_count + 1
        if brokennum < tmp_gem_cost then
          return 
        end
        ticket_count = ticket_count + 1
        edit_tickets:setText(ticket_count)
        upvalue_1024 = ticket_count
      end
      end)
    btn_min:registerScriptTapHandler(function()
      audio.play(audio.button)
      edit_tickets:setText(1)
      upvalue_1024 = 1
      end)
    btn_max:registerScriptTapHandler(function()
      audio.play(audio.button)
      if brokennum ~= 0 then
        edit_tickets:setText(brokennum)
        upvalue_1536 = brokennum
      end
      end)
    local okSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    okSprite:setPreferredSize(CCSize(155, 45))
    local oklab = lbl.createFont1(18, i18n.global.dialog_button_confirm.string, ccc3(126, 39, 0))
    oklab:setPosition(CCPoint(okSprite:getContentSize().width / 2, okSprite:getContentSize().height / 2))
    okSprite:addChild(oklab)
    local okBtn = SpineMenuItem:create(json.ui.button, okSprite)
    okBtn:setPosition(CCPoint(sweepboard_bg_w / 2, 80))
    local okMenu = CCMenu:createWithItem(okBtn)
    okMenu:setPosition(0, 0)
    sweepboard_bg:addChild(okMenu)
    okBtn:registerScriptTapHandler(function()
      disableObjAWhile(okBtn)
      audio.play(audio.button)
      if brokennum < buyCount then
        showToast(i18n.global.tips_act_ticket_lack.string)
        return 
      end
      layer:addChild(selecthero.create({type = "sweepforbrokenboss", stage = __data.id, num = buyCount, callback = showRewardlayer}))
      end)
    local sweepbackEvent = function()
      audio.play(audio.button)
      sweepLayer:removeFromParentAndCleanup(true)
      end
    local sweepbtn_close0 = img.createUISprite(img.ui.close)
    local sweepbtn_close = SpineMenuItem:create(json.ui.button, sweepbtn_close0)
    sweepbtn_close:setPosition(CCPoint(sweepboard_bg_w - 25, sweepboard_bg_h - 28))
    local sweepbtn_close_menu = CCMenu:createWithItem(sweepbtn_close)
    sweepbtn_close_menu:setPosition(CCPoint(0, 0))
    sweepboard_bg:addChild(sweepbtn_close_menu, 100)
    sweepbtn_close:registerScriptTapHandler(function()
      sweepbackEvent()
      end)
    sweepLayer:setTouchEnabled(true)
    sweepLayer:setTouchSwallowEnabled(true)
    addBackEvent(sweepLayer)
    sweepLayer.onAndroidBack = function()
      sweepbackEvent()
      end
    local onEnter = function()
      print("onEnter")
      sweepLayer.notifyParentLock()
      end
    local onExit = function()
      sweepLayer.notifyParentUnlock()
      end
    sweepLayer:registerScriptHandler(function(l_12_0)
      if l_12_0 == "enter" then
        onEnter()
      elseif l_12_0 == "exit" then
        onExit()
      end
      end)
    return sweepLayer
   end
  local battleBtn = nil
  local initenemy = function()
    local gParams = {sid = player.sid, id = doorId}
    addWaitNet()
    net:bboss_syn(gParams, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status == -2 then
        showToast(i18n.global.friendboss_boss_die.string)
        layer:removeFromParentAndCleanup(true)
        return 
      end
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      bossId = l_1_0.id
      local cfgbrokenboss = require("config.brokenboss")
      local sx = 25
      local px = 90
      if  cfgfriendstage[l_1_0.id].monster == 5 then
        sx = 70
      end
      if  cfgfriendstage[l_1_0.id].monster == 4 then
        sx = 115
      end
      if  cfgfriendstage[l_1_0.id].monster == 3 then
        sx = 160
      end
      if  cfgfriendstage[l_1_0.id].monster == 2 then
        sx = 205
      end
      if  cfgfriendstage[l_1_0.id].monster == 1 then
        sx = 250
      end
      for ii = 1,  cfgfriendstage[l_1_0.id].monster do
        local info = cfgmonster[cfgfriendstage[l_1_0.id].monster[ii]]
        local bossIcon = img.createHeroHead(info.heroLink, info.lvShow, true, info.star)
        bossIcon:setScale(0.85)
        bossIcon:setPosition(sx + px * ii, 100)
        heroCampBg:addChild(bossIcon)
      end
      local bloodBar = img.createUI9Sprite(img.ui.fight_hurts_bar_bg)
      bloodBar:setPreferredSize(CCSize(290, 22))
      bloodBar:setPosition(340, 35)
      heroCampBg:addChild(bloodBar)
      local progress0 = img.createUISprite(img.ui.friends_boss_blood)
      local bloodProgress = createProgressBar(progress0)
      bloodProgress:setPosition(bloodBar:getContentSize().width / 2, bloodBar:getContentSize().height / 2)
      bloodProgress:setPercentage(l_1_0.hp)
      bloodBar:addChild(bloodProgress)
      local progressStr = string.format("%d%%", l_1_0.hp)
      local progressLabel = lbl.createFont2(16, progressStr, ccc3(255, 246, 223))
      progressLabel:setPosition(CCPoint(145, bloodBar:getContentSize().height / 2 + 5))
      bloodBar:addChild(progressLabel)
      local titleRewards = lbl.createFont1(18, i18n.global.brave_title_reward.string, ccc3(99, 48, 16))
      titleRewards:setPosition(board_bg:getContentSize().width / 2, 190)
      board_bg:addChild(titleRewards)
      local cfgbrokenboss = require("config.brokenboss")
      local rewards = {}
      do
        for i,v in ipairs(cfgbrokenboss[l_1_0.id].final) do
          rewards[ rewards + 1] = v
        end
        local showRewards = {}
        local offset = 400 -  rewards * 35
        for i = 1,  rewards do
          local showRewardsSp = nil
          if rewards[i].type == 1 then
            showRewardsSp = img.createItem(rewards[i].id, rewards[i].num)
          else
            showRewardsSp = img.createEquip(rewards[i].id)
          end
          showRewards[i] = CCMenuItemSprite:create(showRewardsSp, nil)
          local menuReward = CCMenu:createWithItem(showRewards[i])
          menuReward:setPosition(0, 0)
          board_bg:addChild(menuReward)
          showRewards[i]:setScale(0.74)
          showRewards[i]:setPosition(offset + (i - 1) * 70, 144)
          showRewards[i]:registerScriptTapHandler(function()
            audio.play(audio.button)
            if rewards[i].type == 1 then
              local tips = require("ui.tips.item").createForShow(rewards[i])
              layer:addChild(tips, 100)
            else
              local tips = require("ui.tips.equip").createById(rewards[i].id)
              layer:addChild(tips, 100)
            end
               end)
        end
        local sweepSprite = img.createLogin9Sprite(img.login.button_9_small_green)
        sweepSprite:setPreferredSize(CCSize(170, 56))
        local sweeplab = lbl.createFont1(22, i18n.global.act_bboss_sweep.string, ccc3(29, 103, 0))
        sweeplab:setPosition(CCPoint(sweepSprite:getContentSize().width / 2, sweepSprite:getContentSize().height / 2))
        sweepSprite:addChild(sweeplab)
        sweepBtn = SpineMenuItem:create(json.ui.button, sweepSprite)
        sweepBtn:setPosition(CCPoint(272, 65))
        local sweepMenu = CCMenu:createWithItem(sweepBtn)
        sweepMenu:setPosition(0, 0)
        board_bg:addChild(sweepMenu)
        sweepBtn:registerScriptTapHandler(function()
          disableObjAWhile(sweepBtn)
          audio.play(audio.button)
          if player.lv() < UNLOCK_ACT_BROKEN then
            showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_ACT_BROKEN))
            return 
          end
          layer:addChild(selectSweepnumLayer(__data))
            end)
        local battleSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
        battleSprite:setPreferredSize(CCSize(170, 56))
        local battlelab = lbl.createFont1(22, i18n.global.trial_stage_btn_battle.string, ccc3(126, 39, 0))
        battlelab:setPosition(CCPoint(battleSprite:getContentSize().width / 2, battleSprite:getContentSize().height / 2))
        battleSprite:addChild(battlelab)
        upvalue_6144 = SpineMenuItem:create(json.ui.button, battleSprite)
        battleBtn:setPosition(CCPoint(462, 65))
        local battleMenu = CCMenu:createWithItem(battleBtn)
        battleMenu:setPosition(0, 0)
        board_bg:addChild(battleMenu)
        battleBtn:registerScriptTapHandler(function()
          disableObjAWhile(battleBtn)
          audio.play(audio.button)
          if player.lv() < UNLOCK_ACT_BROKEN then
            showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_ACT_BROKEN))
            return 
          end
          layer:addChild(selecthero.create({type = "brokenboss", stage = __data.id}))
            end)
        if l_1_0.cd then
          refcd = l_1_0.cd
          pull_ref_time = os.time()
          layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
        end
        if l_1_0.hp == 0 and bossId and cfgbrokenboss[bossId].next == nil then
          setShader(battleBtn, SHADER_GRAY, true)
          battleBtn:setEnabled(false)
          setShader(sweepBtn, SHADER_GRAY, true)
          sweepBtn:setEnabled(false)
        end
      end
      end)
   end
  initenemy()
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(board_bg_w - 25, board_bg_h - 28))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  board_bg:addChild(btn_close_menu, 100)
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
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
  layer:registerScriptHandler(function(l_9_0)
    if l_9_0 == "enter" then
      onEnter()
    elseif l_9_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

