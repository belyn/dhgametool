-- Command line was: E:\github\dhgametool\scripts\ui\highcasino\main.lua 

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
local player = require("data.player")
local bagdata = require("data.bag")
local casinodata = require("data.highcasino")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local dialog = require("ui.dialog")
local rewards = require("ui.reward")
local COST_PER_CHIP = casinodata.COST_PER_CHIP
local REFRESH_COST = 100
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local ban = CCLayer:create()
  ban:setTouchEnabled(true)
  ban:setTouchSwallowEnabled(true)
  layer:addChild(ban, 1000)
  layer:runAction(createSequence({}))
  img.load(img.packedOthers.spine_ui_duchang_1)
  img.load(img.packedOthers.spine_ui_chongwu)
  img.load(img.packedOthers.spine_ui_tunvlang)
  local bg = CCSprite:create()
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  bg:setContentSize(CCSizeMake(CCDelayTime:create(1.5), CCCallFunc:create(function()
    ban:removeFromParent()
   end)))
  bg:setScale(view.minScale)
  bg:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(bg, 10)
  local bg_w = bg:getContentSize().width
  local bg_h = bg:getContentSize().height
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
  layer:addChild(backMenu, 10)
  backBtn:registerScriptTapHandler(function()
    backEvent()
   end)
  autoLayoutShift(backBtn)
  json.load(json.ui.duchang_new)
  json.load(json.ui.chongwu_new)
  json.load(json.ui.tunvlang_new)
  local ani_duchang = DHSkeletonAnimation:createWithKey(json.ui.duchang_new)
  ani_duchang:setScale(view.minScale)
  ani_duchang:scheduleUpdateLua()
  ani_duchang:setAnchorPoint(CCPoint(0.5, 0.5))
  ani_duchang:setPosition(scalep(480, 288))
  layer:addChild(ani_duchang)
  local ani_chongwu = DHSkeletonAnimation:createWithKey(json.ui.chongwu_new)
  ani_chongwu:setVisible(false)
  ani_chongwu:scheduleUpdateLua()
  ani_duchang:addChildFollowSlot("code_chongwu", ani_chongwu)
  local ani_tunvlang = DHSkeletonAnimation:createWithKey(json.ui.tunvlang_new)
  ani_tunvlang:scheduleUpdateLua()
  ani_duchang:addChildFollowSlot("code_tunvlang", ani_tunvlang)
  local arrow0 = img.createUISprite(img.ui.casino_pointer)
  local arrow = CCSprite:create()
  arrow:setContentSize(CCSizeMake(arrow0:getContentSize().width, 160))
  arrow0:setAnchorPoint(CCPoint(0.5, 1))
  arrow0:setPosition(CCPoint(arrow:getContentSize().width / 2, 160))
  arrow:addChild(arrow0)
  arrow:setAnchorPoint(CCPoint(0.5, 0))
  ani_duchang:addChildFollowSlot("code_arrow", arrow)
  local btn_1draw0 = img.createUISprite(img.ui.casino_1draw)
  local btn_1draw = HHMenuItem:createWithScale(btn_1draw0, 1)
  local btn_1draw_menu = CCMenu:createWithItem(btn_1draw)
  btn_1draw_menu:ignoreAnchorPointForPosition(false)
  ani_duchang:addChildFollowSlot("duchang/button_up", btn_1draw_menu)
  local btn_10draw0 = img.createUISprite(img.ui.casino_10draw)
  local btn_10draw = HHMenuItem:createWithScale(btn_10draw0, 1)
  local btn_10draw_menu = CCMenu:createWithItem(btn_10draw)
  btn_10draw_menu:ignoreAnchorPointForPosition(false)
  ani_duchang:addChildFollowSlot("duchang/button_up2", btn_10draw_menu)
  local itemObjs = {}
  local showItems = function()
    arrayclear(itemObjs)
    for ii = 1, 8 do
      ani_duchang:removeChildFollowSlot("code_equip_" .. ii)
    end
    local items = casinodata.items
    do
      for ii = 1, #items do
        local tmp_item = nil
        if items[ii].type == 1 then
          local tmp_item0 = img.createItem(items[ii].id, items[ii].count)
          tmp_item = CCMenuItemSprite:create(tmp_item0, nil)
        else
          if items[ii].type == 2 then
            local tmp_item0 = img.createEquip(items[ii].id, items[ii].count)
            tmp_item = CCMenuItemSprite:create(tmp_item0, nil)
          end
        end
        if items[ii].limitBuy and items[ii].limitBuy == 0 then
          setShader(tmp_item, SHADER_GRAY, true)
          local icon_limit = img.createUISprite(img.ui.blackmarket_soldout)
          icon_limit:setScale(0.9)
          icon_limit:setPosition(CCPoint(tmp_item:getContentSize().width / 2, tmp_item:getContentSize().height / 2))
          tmp_item:addChild(icon_limit)
        end
        itemObjs[ii] = tmp_item
        tmp_item:registerScriptTapHandler(function()
          audio.play(audio.button)
          ani_duchang:setPause(true)
          local tmp_tip = nil
          if items[ii].type == 1 then
            tmp_tip = tipsitem.createForShowHCasino({id = items[ii].id})
            layer:addChild(tmp_tip, 100)
          else
            if items[ii].type == 2 then
              tmp_tip = tipsequip.createForShowHCasino({id = items[ii].id})
              layer:addChild(tmp_tip, 100)
            end
          end
          tmp_tip.setClickBlankHandler(function()
            tmp_tip:removeFromParentAndCleanup(true)
            ani_duchang:setPause(false)
               end)
            end)
        local tmp_item_menu = CCMenu:createWithItem(tmp_item)
        tmp_item_menu:ignoreAnchorPointForPosition(false)
        ani_duchang:addChildFollowSlot("code_equip_" .. ii, tmp_item_menu)
      end
    end
   end
  showItems()
  local ani_start = function()
    local arr_start = CCArray:create()
    arr_start:addObject(CCCallFunc:create(function()
      ani_duchang:playAnimation("start", 1)
      ani_duchang:appendNextAnimation("idle", -1)
      ani_chongwu:setVisible(true)
      ani_chongwu:playAnimation("start", 1)
      ani_chongwu:appendNextAnimation("idle", -1)
      ani_tunvlang:playAnimation("start", 1)
      ani_tunvlang:appendNextAnimation("idle", -1)
      end))
    layer:runAction(CCSequence:create(arr_start))
   end
  ani_start()
  local lbl_des1 = lbl.createFont1(16, i18n.global.casino_btn_1time.string, ccc3(130, 71, 35))
  lbl_des1:setAnchorPoint(CCPoint(0, 0.5))
  lbl_des1:setPosition(CCPoint(69, 36))
  btn_1draw:addChild(lbl_des1)
  local lbl_cost1 = lbl.createFont2(16, "1")
  lbl_cost1:setPosition(CCPoint(41, 28))
  btn_1draw:addChild(lbl_cost1, 2)
  local icon1 = img.createItemIcon(ITEM_ID_ADVANCED_CHIP)
  icon1:setScale(0.5)
  icon1:setPosition(CCPoint(41, 36))
  btn_1draw:addChild(icon1)
  local lbl_des2 = lbl.createFont1(16, i18n.global.casino_btn_10time.string, ccc3(130, 71, 35))
  lbl_des2:setAnchorPoint(CCPoint(0, 0.5))
  lbl_des2:setPosition(CCPoint(69, 60))
  btn_10draw:addChild(lbl_des2)
  local lbl_cost2 = lbl.createFont2(16, "10")
  lbl_cost2:setPosition(CCPoint(43, 52))
  btn_10draw:addChild(lbl_cost2, 2)
  local icon2 = img.createItemIcon(ITEM_ID_ADVANCED_CHIP)
  icon2:setScale(0.5)
  icon2:setPosition(CCPoint(43, 60))
  btn_10draw:addChild(icon2)
  local bar = img.createUI9Sprite(img.ui.main_coin_bg)
  bar:setPreferredSize(CCSizeMake(164, 38))
  bar:setPosition(CCPoint(480, 549))
  bg:addChild(bar, 10)
  autoLayoutShift(bar)
  local icon_chip = img.createItemIcon(ITEM_ID_ADVANCED_CHIP)
  icon_chip:setScale(0.5)
  icon_chip:setPosition(CCPoint(4, bar:getContentSize().height / 2 + 2))
  bar:addChild(icon_chip)
  local lbl_chips = lbl.createFont2(16, casinodata.getChips() or "0", ccc3(255, 246, 223))
  lbl_chips:setPosition(CCPoint(bar:getContentSize().width / 2 - 5, bar:getContentSize().height / 2 + 2))
  bar:addChild(lbl_chips)
  local btn_refresh0 = img.createUI9Sprite(img.ui.btn_7)
  btn_refresh0:setPreferredSize(CCSizeMake(190, 70))
  local lbl_refresh = lbl.createFont1(18, i18n.global.casino_btn_refresh.string, ccc3(29, 103, 0))
  lbl_refresh:setAnchorPoint(CCPoint(0.5, 0.5))
  lbl_refresh:setPosition(CCPoint(110, btn_refresh0:getContentSize().height / 2))
  btn_refresh0:addChild(lbl_refresh)
  local lbl_free = lbl.createFont1(18, i18n.global.casino_btn_refresh.string, ccc3(29, 103, 0))
  lbl_free:setPosition(CCPoint(btn_refresh0:getContentSize().width / 2, btn_refresh0:getContentSize().height / 2))
  btn_refresh0:addChild(lbl_free)
  lbl_free:setVisible(false)
  local icon_gem = img.createItemIcon2(ITEM_ID_GEM)
  icon_gem:setScale(0.9)
  icon_gem:setPosition(CCPoint(35, 38))
  btn_refresh0:addChild(icon_gem)
  local lbl_refresh_cost = lbl.createFont2(16, "" .. REFRESH_COST)
  lbl_refresh_cost:setPosition(CCPoint(35, 24))
  btn_refresh0:addChild(lbl_refresh_cost)
  local btn_refresh = SpineMenuItem:create(json.ui.button, btn_refresh0)
  btn_refresh:setPosition(CCPoint(480, 38))
  local btn_refresh_menu = CCMenu:createWithItem(btn_refresh)
  btn_refresh_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_refresh_menu, 10)
  btn_refresh:setVisible(false)
  local lbl_cd_des = lbl.createFont2(16, i18n.global.casino_high_next_refresh.string)
  local lbl_cd = lbl.createFont2(16, "00:00:00", ccc3(213, 255, 44))
  local cd_container = CCSprite:create()
  cd_container:setContentSize(CCSizeMake(lbl_cd_des:boundingBox().size.width + lbl_cd:boundingBox().size.width + 5, lbl_cd_des:getContentSize().height + 3))
  lbl_cd_des:setAnchorPoint(CCPoint(0, 0))
  lbl_cd_des:setPosition(CCPoint(0, 0))
  lbl_cd:setAnchorPoint(CCPoint(1, 0))
  lbl_cd:setPosition(CCPoint(cd_container:getContentSize().width, 0))
  cd_container:addChild(lbl_cd_des)
  cd_container:addChild(lbl_cd)
  cd_container:setPosition(CCPoint(475, 531))
  bg:addChild(cd_container)
  cd_container:setVisible(false)
  autoLayoutShift(cd_container)
  local btn_log0 = img.createUISprite(img.ui.casino_btn_log)
  local lbl_log = lbl.createFont2(16, i18n.global.casino_records.string)
  lbl_log:setPosition(CCPoint(btn_log0:getContentSize().width / 2, 2))
  btn_log0:addChild(lbl_log)
  local btn_log = SpineMenuItem:create(json.ui.button, btn_log0)
  btn_log:setPosition(CCPoint(913, 540))
  local btn_log_menu = CCMenu:createWithItem(btn_log)
  btn_log_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_log_menu)
  btn_log:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.casino.log").create(casinodata.msgs), 1000)
   end)
  autoLayoutShift(btn_log)
  local checkChips = function(l_7_0)
    if casinodata.getChips() < l_7_0 then
      return false
    end
    return true
   end
  local banlayer = CCLayer:create()
  layer:addChild(banlayer, 1000)
  local disableBtns = function()
    banlayer:setTouchEnabled(true)
    banlayer:setTouchSwallowEnabled(true)
    layer:setKeypadEnabled(false)
   end
  local enableBtns = function()
    banlayer:setTouchEnabled(false)
    banlayer:setTouchSwallowEnabled(false)
    layer:setKeypadEnabled(true)
   end
  local onemore_1draw = function()
    if not checkChips(1) then
      showToast(i18n.global.casino_high_no_chip.string)
      return 
    end
    disableBtns()
    local params = {sid = player.sid, type = 1, up = true}
    addWaitNet()
    casinodata.draw(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        enableBtns()
        return 
      end
      audio.play(audio.casino_1)
      casinodata.subChips(1)
      local cfgactivity = require("config.activity")
      local activity = require("data.activity")
      local activityData = cfgactivity[activity.IDS.FRIDAY_HAPPY_1.ID]
      if activityData and activityData.extra and activityData.extra[2] then
        local limits = activityData.extra[2].num
        activity.addScore(activity.IDS.FRIDAY_HAPPY_1.ID, 1, 2, limits)
      end
      local ani_1draw = CCArray:create()
      ani_1draw:addObject(CCCallFunc:create(function()
        arrow:runAction(CCEaseIn:create(CCRotateTo:create(2.4, 2880), 2))
        ani_duchang:playAnimation("spin_start", 1)
        ani_duchang:appendNextAnimation("spin_end", 1, 0)
         end))
      ani_1draw:addObject(CCDelayTime:create(2.4))
      ani_1draw:addObject(CCCallFunc:create(function()
        local toAngle = 22.5 + (__data.ids[1] - 1) * 45
        arrow:runAction(CCEaseOut:create(CCRotateTo:create(2, 1080 + toAngle), 2))
         end))
      ani_1draw:addObject(CCDelayTime:create(2))
      ani_1draw:addObject(CCCallFunc:create(function()
        if __data.bag then
          bagdata.addRewards(__data.bag)
          layer:addChild(rewards.showReward(casinodata.ids2Pbbag(__data.ids), {count = 1, callback = onemore_1draw}, true), 1000)
        end
        if __data.lucky_coin then
          bagdata.items.add({id = ITEM_ID_LUCKY_COIN, num = __data.lucky_coin})
        end
        ani_duchang:playAnimation("idle", -1)
        local itemObj = casinodata.items[__data.ids[1]]
        if itemObj.limitBuy and itemObj.limitBuy > 1 then
          itemObj.limitBuy = itemObj.limitBuy - 1
        elseif itemObj.limitBuy and itemObj.limitBuy == 1 then
          itemObj.limitBuy = 0
          setShader(itemObjs[__data.ids[1]], SHADER_GRAY, true)
          local icon_limit = img.createUISprite(img.ui.blackmarket_soldout)
          icon_limit:setScale(0.9)
          icon_limit:setPosition(CCPoint(itemObjs[__data.ids[1]]:getContentSize().width / 2, itemObjs[__data.ids[1]]:getContentSize().height / 2))
          itemObjs[__data.ids[1]]:addChild(icon_limit)
        end
        enableBtns()
         end))
      layer:runAction(CCSequence:create(ani_1draw))
      end)
   end
  btn_1draw:registerScriptTapHandler(function()
    onemore_1draw()
   end)
  local onemore_10draw = function()
    if not checkChips(10) then
      showToast(i18n.global.casino_high_no_chip.string)
      return 
    end
    disableBtns()
    local params = {sid = player.sid, type = 2, up = true}
    addWaitNet()
    casinodata.draw(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        enableBtns()
        return 
      end
      audio.play(audio.casino_10)
      casinodata.subChips(10)
      local cfgactivity = require("config.activity")
      local activity = require("data.activity")
      local activityData = cfgactivity[activity.IDS.FRIDAY_HAPPY_1.ID]
      if activityData and activityData.extra and activityData.extra[2] then
        local limits = activityData.extra[2].num
        activity.addScore(activity.IDS.FRIDAY_HAPPY_1.ID, 10, 2, limits)
      end
      local ani_10draw = CCArray:create()
      ani_10draw:addObject(CCCallFunc:create(function()
        arrow:runAction(CCEaseIn:create(CCRotateTo:create(4, 4320), 2))
        ani_duchang:playAnimation("spin_start2", -1)
         end))
      ani_10draw:addObject(CCDelayTime:create(3))
      ani_10draw:addObject(CCCallFunc:create(function()
        if __data.bag then
          bagdata.addRewards(__data.bag)
          layer:addChild(rewards.showReward(casinodata.ids2Pbbag(__data.ids), {count = 10, callback = onemore_10draw}, true), 1000)
        end
        if __data.lucky_coin then
          bagdata.items.add({id = ITEM_ID_LUCKY_COIN, num = __data.lucky_coin})
        end
        arrow:setRotation(0)
        ani_duchang:playAnimation("idle", -1)
        for ii = 1, #__data.ids do
          local itemObj = casinodata.items[__data.ids[ii]]
          if itemObj.limitBuy and itemObj.limitBuy > 1 then
            itemObj.limitBuy = itemObj.limitBuy - 1
          elseif itemObj.limitBuy and itemObj.limitBuy == 1 then
            itemObj.limitBuy = 0
            setShader(itemObjs[__data.ids[ii]], SHADER_GRAY, true)
            local icon_limit = img.createUISprite(img.ui.blackmarket_soldout)
            icon_limit:setScale(0.9)
            icon_limit:setPosition(CCPoint(itemObjs[__data.ids[ii]]:getContentSize().width / 2, itemObjs[__data.ids[ii]]:getContentSize().height / 2))
            itemObjs[__data.ids[ii]]:addChild(icon_limit)
          end
        end
        enableBtns()
         end))
      layer:runAction(CCSequence:create(ani_10draw))
      end)
   end
  btn_10draw:registerScriptTapHandler(function()
    onemore_10draw()
   end)
  btn_refresh:registerScriptTapHandler(function()
    audio.play(audio.button)
    disableBtns()
    local refresh_type = nil
    if os.time() - casinodata.last_pull < casinodata.cd then
      refresh_type = 3
      if bagdata.gem() < REFRESH_COST then
        enableBtns()
        local gotoShopDlg = require("ui.gotoShopDlg")
        gotoShopDlg.show(layer, "casino", i18n.global.ele_hint_no_gem.string)
        return 
      else
        refresh_type = 2
      end
    end
    local params = {sid = player.sid, type = refresh_type, up = true}
    addWaitNet()
    casinodata.pull(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        enableBtns()
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      casinodata.init(l_1_0)
      if refresh_type == 3 then
        bagdata.subGem(REFRESH_COST)
      end
      local ani_refresh = CCArray:create()
      ani_refresh:addObject(CCCallFunc:create(function()
        showItems()
         end))
      ani_refresh:addObject(CCCallFunc:create(function()
        ani_duchang:playAnimation("refresh", 1)
         end))
      ani_refresh:addObject(CCDelayTime:create(ani_duchang:getAnimationTime("refresh")))
      ani_refresh:addObject(CCCallFunc:create(function()
        enableBtns()
        ani_duchang:playAnimation("idle", -1)
         end))
      layer:runAction(CCSequence:create(ani_refresh))
      end)
   end)
  local updateChips = function()
    lbl_chips:setString(casinodata.getChips())
   end
  local updateCD = function()
    local remain_cd = casinodata.cd - (os.time() - casinodata.last_pull)
    local remain_force_cd = casinodata.force_cd - (os.time() - casinodata.last_force_pull)
    if remain_cd > 0 then
      lbl_free:setVisible(false)
      lbl_refresh:setVisible(true)
      lbl_refresh_cost:setVisible(true)
      icon_gem:setVisible(true)
    else
      lbl_free:setVisible(true)
      lbl_refresh:setVisible(false)
      lbl_refresh_cost:setVisible(false)
      icon_gem:setVisible(false)
    end
    btn_refresh:setVisible(true)
    if remain_force_cd > 0 then
      local time_str = time2string(remain_force_cd)
      lbl_cd:setString(time_str)
    else
      local params = {sid = player.sid, type = 1, up = true}
      addWaitNet()
      casinodata.pull(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          enableBtns()
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        casinodata.init(l_1_0)
        local ani_refresh = CCArray:create()
        ani_refresh:addObject(CCCallFunc:create(function()
          showItems()
            end))
        ani_refresh:addObject(CCCallFunc:create(function()
          ani_duchang:playAnimation("refresh", 1)
            end))
        ani_refresh:addObject(CCDelayTime:create(ani_duchang:getAnimationTime("refresh")))
        ani_refresh:addObject(CCCallFunc:create(function()
          enableBtns()
          ani_duchang:playAnimation("idle", -1)
            end))
        layer:runAction(CCSequence:create(ani_refresh))
         end)
    end
    cd_container:setVisible(true)
   end
  local last_update = os.time()
  local onUpdate = function(l_17_0)
    if os.time() - last_update < 0.5 then
      return 
    end
    last_update = os.time()
    updateChips()
    updateCD()
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
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
  layer:registerScriptHandler(function(l_21_0)
    if l_21_0 == "enter" then
      onEnter()
    elseif l_21_0 == "exit" then
      onExit()
    elseif l_21_0 == "cleanup" then
      img.unload(img.packedOthers.spine_ui_duchang_1)
      img.unload(img.packedOthers.spine_ui_chongwu)
      img.unload(img.packedOthers.spine_ui_tunvlang)
    end
   end)
  require("ui.tutorial").show("ui.casino.main", layer)
  return layer
end

return ui

