-- Command line was: E:\github\dhgametool\scripts\ui\herotask\main.lua 

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
local cfgtask = require("config.herotask")
local cfgequip = require("config.equip")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local htaskData = require("data.herotask")
local cfgvip = require("config.vip")
local achieveData = require("data.achieve")
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  img.load(img.packedOthers.ui_herotask_bg)
  img.load(img.packedOthers.spine_ui_jiuguan_refresh)
  local bg = CCSprite:create()
  bg:setScale(view.minScale)
  bg:setPosition(scalep(0, 0))
  layer:addChild(bg)
  local ssco_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  ssco_bg:setPreferredSize(CCSizeMake(155, 40))
  ssco_bg:setPosition(297, 552)
  bg:addChild(ssco_bg, 1000)
  local gem_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  gem_bg:setPreferredSize(CCSizeMake(155, 40))
  gem_bg:setPosition(663, 552)
  bg:addChild(gem_bg, 1000)
  local bsco_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  bsco_bg:setPreferredSize(CCSizeMake(155, 40))
  bsco_bg:setPosition(480, 552)
  bg:addChild(bsco_bg, 1000)
  autoLayoutShift(ssco_bg)
  autoLayoutShift(gem_bg)
  autoLayoutShift(bsco_bg)
  local icon_ssco = img.createItemIcon2(ITEM_ID_HTASK_LOW)
  icon_ssco:setPosition(CCPoint(5, ssco_bg:getContentSize().height / 2 + 2))
  ssco_bg:addChild(icon_ssco)
  local icon_gem = img.createItemIcon2(ITEM_ID_GEM)
  icon_gem:setPosition(CCPoint(5, gem_bg:getContentSize().height / 2 + 2))
  gem_bg:addChild(icon_gem)
  local icon_bsco = img.createItemIcon2(ITEM_ID_HTASK_HIGH)
  icon_bsco:setPosition(CCPoint(5, bsco_bg:getContentSize().height / 2 + 2))
  bsco_bg:addChild(icon_bsco)
  local btn_gem0 = img.createUISprite(img.ui.main_icon_plus)
  local btn_gem = HHMenuItem:create(btn_gem0)
  btn_gem:setPosition(CCPoint(gem_bg:getContentSize().width - 18, gem_bg:getContentSize().height / 2 + 2))
  local btn_gem_menu = CCMenu:createWithItem(btn_gem)
  btn_gem_menu:setPosition(CCPoint(0, 0))
  gem_bg:addChild(btn_gem_menu)
  btn_gem:registerScriptTapHandler(function()
    audio.play(audio.button)
    local gemshop = require("ui.shop.main")
    local gemShop = gemshop.create()
    layer:addChild(gemShop, 1001)
   end)
  local ssco_num = bag.coin()
  local lbl_ssco = lbl.createFont2(16, num2KM(ssco_num), ccc3(255, 246, 223))
  lbl_ssco:setPosition(CCPoint(ssco_bg:getContentSize().width / 2 - 10, ssco_bg:getContentSize().height / 2 + 3))
  ssco_bg:addChild(lbl_ssco)
  lbl_ssco.num = ssco_num
  local gem_num = bag.gem()
  local lbl_gem = lbl.createFont2(16, gem_num, ccc3(255, 246, 223))
  lbl_gem:setPosition(CCPoint(gem_bg:getContentSize().width / 2 - 10, gem_bg:getContentSize().height / 2 + 3))
  gem_bg:addChild(lbl_gem)
  lbl_gem.num = gem_num
  local bsco_num = 0
  if bag.items.find(ITEM_ID_HTASK_HIGH) then
    bsco_num = bag.items.find(ITEM_ID_HTASK_HIGH).num
  end
  local lbl_bsco = lbl.createFont2(16, num2KM(bsco_num), ccc3(255, 246, 223))
  lbl_bsco:setPosition(CCPoint(bsco_bg:getContentSize().width / 2 - 10, bsco_bg:getContentSize().height / 2 + 3))
  bsco_bg:addChild(lbl_bsco)
  lbl_bsco.num = bsco_num
  local updateLabels = function()
    local ssconum = 0
    if bag.items.find(ITEM_ID_HTASK_LOW) then
      ssconum = bag.items.find(ITEM_ID_HTASK_LOW).num
    end
    if lbl_ssco.num ~= ssconum then
      lbl_ssco:setString(num2KM(ssconum))
      lbl_ssco.num = ssconum
    end
    local gemnum = bag.gem()
    if lbl_gem.num ~= gemnum then
      lbl_gem:setString(gemnum)
      lbl_gem.num = gemnum
    end
    local bsconum = 0
    if bag.items.find(ITEM_ID_HTASK_HIGH) then
      bsconum = bag.items.find(ITEM_ID_HTASK_HIGH).num
    end
    if lbl_bsco.num ~= bsconum then
      lbl_bsco:setString(num2KM(bsconum))
      lbl_bsco.num = bsconum
    end
   end
  local openUpdate = false
  local lbg = img.createUISprite(img.ui.herotask_bg)
  lbg:setPosition(480, 288)
  bg:addChild(lbg)
  local fontg = img.createUISprite(img.ui.herotask_font)
  fontg:setAnchorPoint(0.5, 0)
  fontg:setPosition(479, -35)
  bg:addChild(fontg, 5)
  local infoSprite = img.createUISprite(img.ui.btn_detail)
  local infoBtn = SpineMenuItem:create(json.ui.button, infoSprite)
  infoBtn:setPosition(880, 550)
  local infoMenu = CCMenu:createWithItem(infoBtn)
  infoMenu:setPosition(0, 0)
  bg:addChild(infoMenu)
  infoBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.help").create(i18n.global.tavern_rate_des.string, i18n.global.casino_item_rate.string), 1000)
   end)
  local btnInfoSprite = img.createUISprite(img.ui.btn_help)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  btnInfo:setPosition(932, 550)
  local menuInfo = CCMenu:createWithItem(btnInfo)
  menuInfo:setPosition(0, 0)
  bg:addChild(menuInfo)
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.help").create(i18n.global.help_tavern.string, i18n.global.help_title.string), 1000)
   end)
  autoLayoutShift(btnInfo)
  autoLayoutShift(infoBtn)
  local vipLv = player.vipLv() or 0
  local showTitle = lbl.createMixFont2(15, string.format(i18n.global.herotask_info.string, 0, cfgvip[vipLv].heroTask), ccc3(255, 251, 220))
  showTitle:setPosition(438, 512)
  bg:addChild(showTitle)
  local refreshTime = lbl.createFont2(15, "00:00:00", ccc3(165, 253, 71))
  refreshTime:setAnchorPoint(ccp(0, 0.5))
  refreshTime:setPosition(showTitle:boundingBox():getMaxX() + 5, showTitle:getPositionY())
  bg:addChild(refreshTime)
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(54, 69)
  scroll:setViewSize(CCSize(850, 419))
  scroll:setContentSize(CCSize(850, 0))
  bg:addChild(scroll)
  local btnRecHighSprite = img.createUI9Sprite(img.ui.btn_2)
  btnRecHighSprite:setPreferredSize(CCSize(162, 50))
  local labRecHigh = lbl.createFont1(16, i18n.global.herotast_use_sco.string, ccc3(115, 59, 5))
  labRecHigh:setAnchorPoint(ccp(0, 0.5))
  labRecHigh:setPosition(72, 25)
  btnRecHighSprite:addChild(labRecHigh)
  local showRecHigh = img.createItemIcon2(ITEM_ID_HTASK_HIGH)
  showRecHigh:setScale(0.8)
  showRecHigh:setPosition(41, 29)
  btnRecHighSprite:addChild(showRecHigh)
  local labRecHigh = lbl.createFont2(14, "1")
  labRecHigh:setPosition(41, 17)
  btnRecHighSprite:addChild(labRecHigh)
  local btnRecHigh = SpineMenuItem:create(json.ui.button, btnRecHighSprite)
  local menuRecHigh = CCMenu:createWithItem(btnRecHigh)
  menuRecHigh:setPosition(0, 0)
  bg:addChild(menuRecHigh, 10)
  btnRecHigh:setAnchorPoint(ccp(0.5, 0))
  btnRecHigh:setPosition(480, 4)
  local btnRecLowSprite = img.createUI9Sprite(img.ui.btn_2)
  btnRecLowSprite:setPreferredSize(CCSize(162, 50))
  local labRecLow = lbl.createFont1(16, i18n.global.herotast_use_sco.string, ccc3(115, 59, 5))
  labRecLow:setAnchorPoint(ccp(0, 0.5))
  labRecLow:setPosition(72, 25)
  btnRecLowSprite:addChild(labRecLow)
  local showRecLow = img.createItemIcon2(ITEM_ID_HTASK_LOW)
  showRecLow:setScale(0.8)
  showRecLow:setPosition(41, 29)
  btnRecLowSprite:addChild(showRecLow)
  local labRecLow = lbl.createFont2(14, "1")
  labRecLow:setPosition(41, 17)
  btnRecLowSprite:addChild(labRecLow)
  local btnRecLow = SpineMenuItem:create(json.ui.button, btnRecLowSprite)
  local menuRecLow = CCMenu:createWithItem(btnRecLow)
  menuRecLow:setPosition(0, 0)
  bg:addChild(menuRecLow, 10)
  btnRecLow:setAnchorPoint(ccp(0.5, 0))
  btnRecLow:setPosition(310, 4)
  local btnRefreshSprite = img.createLogin9Sprite(img.login.button_9_small_green)
  btnRefreshSprite:setPreferredSize(CCSize(162, 50))
  local labRefresh = lbl.createFont1(16, i18n.global.herotask_btn_refresh.string, ccc3(30, 99, 5))
  labRefresh:setAnchorPoint(ccp(0, 0.5))
  labRefresh:setPosition(72, 25)
  btnRefreshSprite:addChild(labRefresh)
  local showDiamond = img.createItemIcon2(ITEM_ID_GEM)
  showDiamond:setScale(0.8)
  showDiamond:setPosition(41, 29)
  btnRefreshSprite:addChild(showDiamond)
  local labDiamond = lbl.createFont2(14, "")
  labDiamond:setPosition(41, 17)
  btnRefreshSprite:addChild(labDiamond)
  local btnRefresh = SpineMenuItem:create(json.ui.button, btnRefreshSprite)
  local menuRefresh = CCMenu:createWithItem(btnRefresh)
  menuRefresh:setPosition(0, 0)
  bg:addChild(menuRefresh, 10)
  btnRefresh:setAnchorPoint(ccp(0.5, 0))
  btnRefresh:setPosition(650, 4)
  local contentLayer = CCLayer:create()
  bg:addChild(contentLayer, 1002)
  local refreshGem = 0
  local taskBg = {}
  contentLayer.addAni = function(l_5_0)
    taskBg[l_5_0].anim:playAnimation("refresh3")
   end
  contentLayer.loadContent = function(l_6_0)
    contentLayer:removeAllChildrenWithCleanup(true)
    if #htaskData.tasks < 1 then
      return 
    end
    local info = htaskData.tasks[l_6_0]
    for i,v in ipairs(taskBg) do
      if i == l_6_0 then
        for i,v in (for generator) do
        end
      end
      if info then
        if not info.heroes then
          info.subrefgem = function()
        if info.lock == 0 then
          upvalue_512 = refreshGem - 10
          labDiamond:setString(refreshGem)
          htaskData.changeLock(info.tid)
        end
         end
          contentLayer:addChild(require("ui.herotask.start").create(info), 10000)
        else
          if os.time() < info.cd then
            tbl2string(info)
            contentLayer:addChild(require("ui.herotask.speed").create(info), 10000)
          else
            contentLayer:addChild(require("ui.herotask.finish").create(info), 10000)
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local createTasks = function(l_7_0, l_7_1)
    refreshGem = 0
    upvalue_512 = {}
    scroll:getContainer():removeAllChildrenWithCleanup(true)
    local height = 109 * #htaskData.tasks + 20
    scroll:setContentSize(CCSize(260, height))
    if l_7_1 and #htaskData.tasks > 3 then
      scroll:setContentOffset(ccp(0, l_7_1 + 109))
    else
      scroll:setContentOffset(ccp(0, 428 - height))
    end
    for i,v in ipairs(htaskData.tasks) do
      do
        local cfg = cfgtask[v.id]
        do
          taskBg[i] = CCSprite:create()
          taskBg[i]:setContentSize(CCSize(840, 88))
          taskBg[i]:setPosition(426, 44 + height - 109 * i)
          scroll:getContainer():addChild(taskBg[i])
          if l_7_0 == 2 and i == 1 then
            taskBg[i]:setVisible(false)
            schedule(scroll:getContainer(), 0.5, function()
              taskBg[i]:setVisible(true)
              taskBg[i]:setScale(0.5)
              taskBg[i]:runAction(CCEaseBackOut:create(CCScaleTo:create(0.15, 1, 1)))
                  end)
          end
          json.load(json.ui.jiuguan_refresh)
          local anim = DHSkeletonAnimation:createWithKey(json.ui.jiuguan_refresh)
          anim:scheduleUpdateLua()
          anim:setPosition(420, 44)
          taskBg[i]:addChild(anim, 10000)
          taskBg[i].anim = anim
          if l_7_0 == 1 and (v.lock == nil or v.lock == 0) and not v.heroes then
            if cfg.star < 4 then
              anim:playAnimation("refresh1")
            else
              anim:playAnimation("refresh2")
            end
          end
          if l_7_0 == 2 then
            if i == 1 then
              schedule(taskBg[i], 0.7, function()
            if cfg.star < 4 then
              anim:playAnimation("refresh1")
            else
              anim:playAnimation("refresh2")
            end
               end)
            else
              taskBg[i]:setPosition(426, 44 + height - 109 * (i - 1))
              taskBg[i]:runAction(CCMoveBy:create(0.5, ccp(0, -109)))
            end
          end
          if (v.lock == nil or v.lock == 0) and not v.heroes then
            refreshGem = refreshGem + 10
          end
           -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

        end
        local normalBg = img.createUI9Sprite(img.ui.herotask_task_bg)
        normalBg:setPreferredSize(CCSize(840, 102))
        normalBg:setPosition(taskBg[i]:getContentSize().width / 2, taskBg[i]:getContentSize().height / 2)
        taskBg[i]:addChild(normalBg)
        taskBg[i].normal = normalBg
        local reward = conquset2items(v.reward)
        local ox = 540
        local showReward = {}
        for ii,r in pairs(reward) do
          do
            local showRewardSprite = nil
            if r.type == 1 then
              showRewardSprite = img.createItem(r.id, r.num)
            else
              showRewardSprite = img.createEquip(r.id, r.num)
            end
            showReward[ii] = CCMenuItemSprite:create(showRewardSprite, nil)
            local menuReward = CCMenu:createWithItem(showReward[ii])
            menuReward:setPosition(0, 0)
            taskBg[i]:addChild(menuReward)
            showReward[ii]:setScale(0.80434782608696)
            showReward[ii]:setPosition(ox, 45)
            showReward[ii]:registerScriptTapHandler(function()
              if r.type == 1 then
                local tips = require("ui.tips.item").createForShow(r)
                layer:addChild(tips, 10000)
              else
                local tips = require("ui.tips.equip").createById(r.id)
                layer:addChild(tips, 10000)
              end
                  end)
          end
        end
        local showName = nil
        if v.nameid then
          showName = lbl.createMixFont1(16, i18n.herotaskname[v.nameid].taskName, ccc3(115, 63, 32))
        else
          showName = lbl.createMixFont1(16, i18n.herotaskname[1].taskName, ccc3(115, 63, 32))
        end
        showName:setAnchorPoint(0, 0.5)
        showName:setPosition(98, 64)
        taskBg[i]:addChild(showName)
        local normalStat = CCLayer:create()
        taskBg[i]:addChild(normalStat)
        taskBg[i].normalStat = normalStat
        local star = cfg.star
        local starbg = img.createUISprite(img.ui.hero_task_" .. sta)
        starbg:setAnchorPoint(0, 0.5)
        starbg:setPosition(96, 32)
        taskBg[i]:addChild(starbg)
        local offsetX = starbg:getContentSize().width - 22 * star / 2 + 1
        for j = 1, star do
          local showStar = img.createUISprite(img.ui.star)
          showStar:setAnchorPoint(ccp(0, 0.5))
          showStar:setScale(0.5)
          showStar:setPosition(offsetX + 22 * (j - 1), 32)
          taskBg[i]:addChild(showStar)
        end
        local showTime = lbl.createFont1(13, cfg.questTime / 60 .. " " .. i18n.global.herotask_info_hours.string, ccc3(150, 94, 61))
        showTime:setAnchorPoint(ccp(1, 0.5))
        showTime:setPosition(375, 32)
        normalStat:addChild(showTime)
        local timeIcon = img.createUISprite(img.ui.clock)
        timeIcon:setAnchorPoint(ccp(1, 0.5))
        timeIcon:setPosition(showTime:boundingBox():getMinX() - 5, 32)
        normalStat:addChild(timeIcon)
        local compStat = CCLayer:create()
        taskBg[i]:addChild(compStat)
        taskBg[i].compStat = compStat
        local showCompBg = img.createUISprite(img.ui.herotask_time_bar)
        showCompBg:setAnchorPoint(ccp(0, 0.5))
        showCompBg:setPosition(292, 31)
        compStat:addChild(showCompBg)
        local showComp = img.createUISprite(img.ui.herotask_time_finish)
        showComp:setAnchorPoint(ccp(0, 0.5))
        showComp:setPosition(295, 31)
        compStat:addChild(showComp)
        local lblComp = lbl.createFont2(16, i18n.global.herotask_finish.string)
        lblComp:setPosition(showComp:getContentSize().width / 2, showComp:getContentSize().height / 2)
        showComp:addChild(lblComp)
        local companim = DHSkeletonAnimation:createWithKey(json.ui.jiuguan_refresh)
        companim:scheduleUpdateLua()
        companim:setPosition(420, 42)
        companim:playAnimation("refresh4", -1)
        compStat:addChild(companim, 10000)
        local btnFinishSprite = img.createUI9Sprite(img.ui.btn_2)
        btnFinishSprite:setPreferredSize(CCSize(165, 50))
        local btnFinish = HHMenuItem:create(btnFinishSprite)
        local menuFinish = CCMenu:createWithItem(btnFinish)
        menuFinish:setPosition(0, 0)
        compStat:addChild(menuFinish)
        btnFinish:setPosition(738, 45)
        local labFinish = lbl.createFont1(16, i18n.global.herotask_finish.string, ccc3(115, 59, 5))
        labFinish:setPosition(btnFinish:getContentSize().width / 2, btnFinish:getContentSize().height / 2)
        btnFinish:addChild(labFinish)
        local createSureFinish = function()
          local params = {}
          params.btn_count = 0
          params.body = string.format(i18n.global.herotask_surefinish.string, 20)
          local board_w = 474
          local dialoglayer = require("ui.dialog").create(params)
          local btnYesSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
          btnYesSprite:setPreferredSize(CCSize(153, 50))
          local btnYes = SpineMenuItem:create(json.ui.button, btnYesSprite)
          btnYes:setPosition(board_w / 2 + 95, 100)
          local labYes = lbl.createFont1(18, i18n.global.board_confirm_yes.string, ccc3(115, 59, 5))
          labYes:setPosition(btnYes:getContentSize().width / 2, btnYes:getContentSize().height / 2)
          btnYesSprite:addChild(labYes)
          local menuYes = CCMenu:create()
          menuYes:setPosition(0, 0)
          menuYes:addChild(btnYes)
          dialoglayer.board:addChild(menuYes)
          local btnNoSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
          btnNoSprite:setPreferredSize(CCSize(153, 50))
          local btnNo = SpineMenuItem:create(json.ui.button, btnNoSprite)
          btnNo:setPosition(board_w / 2 - 95, 100)
          local labNo = lbl.createFont1(18, i18n.global.board_confirm_no.string, ccc3(115, 59, 5))
          labNo:setPosition(btnNo:getContentSize().width / 2, btnNo:getContentSize().height / 2)
          btnNoSprite:addChild(labNo)
          local menuNo = CCMenu:create()
          menuNo:setPosition(0, 0)
          menuNo:addChild(btnNo)
          dialoglayer.board:addChild(menuNo)
          btnYes:registerScriptTapHandler(function()
            dialoglayer:removeFromParentAndCleanup(true)
            local param = {}
            param.sid = player.sid
            addWaitNet()
            param.tid = v.tid
            net:htask_rec(param, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              if l_1_0.status == -1 then
                showToast(i18n.global.herotask_get_toast.string)
                return 
              end
              if l_1_0.status ~= 0 then
                showToast("server status:" .. l_1_0.status)
                return 
              end
              if cfgtask[v.id].star == QUALITY_4 then
                achieveData.add(ACHIEVE_TYPE_COMPLETE_HEROTASK4, 1)
                local mactivity_data = require("data.monthlyactivity")
                mactivity_data.addScore(mactivity_data.IDS.SCORE_TARVEN_4.ID, 1)
              end
              if cfgtask[v.id].star == QUALITY_5 then
                achieveData.add(ACHIEVE_TYPE_COMPLETE_HEROTASK5, 1)
                local mactivity_data = require("data.monthlyactivity")
                mactivity_data.addScore(mactivity_data.IDS.SCORE_TARVEN_5.ID, 1)
              end
              if cfgtask[v.id].star == QUALITY_6 then
                achieveData.add(ACHIEVE_TYPE_COMPLETE_HEROTASK6, 1)
                local mactivity_data = require("data.monthlyactivity")
                mactivity_data.addScore(mactivity_data.IDS.SCORE_TARVEN_6.ID, 1)
              end
              if cfgtask[v.id].star == QUALITY_7 then
                local mactivity_data = require("data.monthlyactivity")
                mactivity_data.addScore(mactivity_data.IDS.SCORE_TARVEN_7.ID, 1)
              end
              local dailytask = require("data.task")
              dailytask.increment(dailytask.TaskType.HERO_TASK, 1)
              databag = require("data.bag")
              databag.addRewards(l_1_0.reward)
              htaskData.del(v.tid)
              layer:addChild(require("ui.tips.reward").create(l_1_0.reward), 1000)
                  end)
               end)
          btnNo:registerScriptTapHandler(function()
            dialoglayer:removeFromParentAndCleanup(true)
            audio.play(audio.button)
               end)
          local diabackEvent = function()
            dialoglayer:removeFromParentAndCleanup(true)
               end
          dialoglayer.onAndroidBack = function()
            diabackEvent()
               end
          addBackEvent(dialoglayer)
          local onEnter = function()
            dialoglayer.notifyParentLock()
               end
          local onExit = function()
            dialoglayer.notifyParentUnlock()
               end
          dialoglayer:registerScriptHandler(function(l_7_0)
            if l_7_0 == "enter" then
              onEnter()
            elseif l_7_0 == "exit" then
              onExit()
            end
               end)
          return dialoglayer
            end
        btnFinish:registerScriptTapHandler(function()
          audio.play(audio.button)
          local params = {sid = player.sid, tid = v.tid}
          if cfgtask[v.id].star == QUALITY_6 or cfgtask[v.id].star == QUALITY_7 then
            local sureFinish = createSureFinish()
            layer:addChild(sureFinish, 300)
            return 
          end
          addWaitNet()
          net:htask_rec(params, function(l_1_0)
            delWaitNet()
            tbl2string(l_1_0)
            if l_1_0.status == -1 then
              showToast(i18n.global.herotask_get_toast.string)
              return 
            end
            if l_1_0.status ~= 0 then
              showToast("server status:" .. l_1_0.status)
              return 
            end
            if cfgtask[v.id].star == QUALITY_4 then
              achieveData.add(ACHIEVE_TYPE_COMPLETE_HEROTASK4, 1)
              local mactivity_data = require("data.monthlyactivity")
              mactivity_data.addScore(mactivity_data.IDS.SCORE_TARVEN_4.ID, 1)
            end
            if cfgtask[v.id].star == QUALITY_5 then
              achieveData.add(ACHIEVE_TYPE_COMPLETE_HEROTASK5, 1)
              local mactivity_data = require("data.monthlyactivity")
              mactivity_data.addScore(mactivity_data.IDS.SCORE_TARVEN_5.ID, 1)
            end
            if cfgtask[v.id].star == QUALITY_6 then
              achieveData.add(ACHIEVE_TYPE_COMPLETE_HEROTASK6, 1)
              local mactivity_data = require("data.monthlyactivity")
              mactivity_data.addScore(mactivity_data.IDS.SCORE_TARVEN_6.ID, 1)
            end
            if cfgtask[v.id].star == QUALITY_7 then
              local mactivity_data = require("data.monthlyactivity")
              mactivity_data.addScore(mactivity_data.IDS.SCORE_TARVEN_7.ID, 1)
            end
            local dailytask = require("data.task")
            dailytask.increment(dailytask.TaskType.HERO_TASK, 1)
            databag = require("data.bag")
            databag.addRewards(l_1_0.reward)
            htaskData.del(v.tid)
            layer:addChild(require("ui.tips.reward").create(l_1_0.reward), 1000)
               end)
            end)
        if not v.heroes then
          local btnLockSp = img.createUISprite(img.ui.hero_unlock)
          local btnLock = SpineMenuItem:create(json.ui.button, btnLockSp)
          btnLock:setScale(0.9)
          taskBg[i].btnLock = btnLock
          if v.lock and v.lock == 1 then
            taskBg[i].btnLock:setVisible(false)
          end
          local menuLock = CCMenu:createWithItem(btnLock)
          menuLock:setPosition(0, 0)
          btnLock:setPosition(52, 44)
          taskBg[i]:addChild(menuLock)
          local btnUnLockSp = img.createUISprite(img.ui.hero_lock)
          local btnUnLock = SpineMenuItem:create(json.ui.button, btnUnLockSp)
          btnUnLock:setScale(0.9)
          taskBg[i].btnUnLock = btnUnLock
          if v.lock == nil or v.lock == 0 then
            taskBg[i].btnUnLock:setVisible(false)
          end
          local menuUnLock = CCMenu:createWithItem(btnUnLock)
          menuUnLock:setPosition(0, 0)
          btnUnLock:setPosition(52, 44)
          taskBg[i]:addChild(menuUnLock)
          btnLock:registerScriptTapHandler(function()
            taskBg[i].btnLock:setVisible(false)
            taskBg[i].btnUnLock:setVisible(true)
            local params = {sid = player.sid, tid = v.tid}
            addWaitNet()
            net:htask_lock(params, function(l_1_0)
              delWaitNet()
              if l_1_0.status < 0 then
                showToast("server status:" .. l_1_0.status)
                return 
              end
              htaskData.changeLock(v.tid)
              upvalue_1024 = refreshGem - 10
              htaskData.tasks[i].lock = 1
              labDiamond:setString(refreshGem)
                  end)
               end)
          btnUnLock:registerScriptTapHandler(function()
            if v.heroes then
              showToast(i18n.global.herotast_start_notlock.string)
              return 
            end
            taskBg[i].btnLock:setVisible(true)
            taskBg[i].btnUnLock:setVisible(false)
            local params = {sid = player.sid, tid = v.tid}
            addWaitNet()
            net:htask_lock(params, function(l_1_0)
              delWaitNet()
              if l_1_0.status < 0 then
                showToast("server status:" .. l_1_0.status)
                return 
              end
              htaskData.changeLock(v.tid)
              upvalue_1024 = refreshGem + 10
              htaskData.tasks[i].lock = 0
              labDiamond:setString(refreshGem)
                  end)
               end)
        else
          local btnUnLockSp = img.createUISprite(img.ui.hero_lock)
          local btnUnLock = SpineMenuItem:create(json.ui.button, btnUnLockSp)
          btnUnLock:setScale(0.9)
          taskBg[i].btnUnLock = btnUnLock
          local menuUnLock = CCMenu:createWithItem(btnUnLock)
          menuUnLock:setPosition(0, 0)
          btnUnLock:setPosition(52, 44)
          taskBg[i]:addChild(menuUnLock)
          btnUnLock:registerScriptTapHandler(function()
            showToast(i18n.global.herotast_start_notlock.string)
               end)
        end
        local showFinish = img.createUISprite(img.ui.herotask_complete_dg)
        showFinish:setPosition(233, 73)
        taskBg[i]:addChild(showFinish)
        taskBg[i].finish = showFinish
        showFinish:setVisible(false)
        local ingStat = CCLayer:create()
        taskBg[i]:addChild(ingStat)
        taskBg[i].ingStat = ingStat
        local showTimeBg = img.createUISprite(img.ui.herotask_time_bar)
        showTimeBg:setAnchorPoint(ccp(0, 0.5))
        showTimeBg:setPosition(292, 31)
        ingStat:addChild(showTimeBg)
        local showTimeBarSp = img.createUISprite(img.ui.herotask_time_shortfg)
        local showTimeBar = createProgressBar(showTimeBarSp)
        showTimeBar:setAnchorPoint(ccp(0, 0.5))
        showTimeBar:setPosition(295, 31)
        showTimeBar:setPercentage(100)
        ingStat:addChild(showTimeBar)
        ingStat.showTimeBar = showTimeBar
        local showLastTime = lbl.createFont2(14, "00:12:84")
        showLastTime:setPosition(390, 31)
        ingStat:addChild(showLastTime, 1)
        ingStat.showLastTime = showLastTime
        local xbtn = img.createLogin9Sprite(img.login.button_9_small_orange)
        xbtn:setPreferredSize(CCSizeMake(50, 50))
        local btnCancel1 = img.createUISprite(img.ui.friends_x)
        btnCancel1:setPosition(CCPoint(xbtn:getContentSize().width / 2, xbtn:getContentSize().height / 2 + 1))
        xbtn:addChild(btnCancel1)
        local btnCancel = SpineMenuItem:create(json.ui.button, xbtn)
        local menuCancel = CCMenu:createWithItem(btnCancel)
        btnCancel:setPosition(794, 43)
        menuCancel:setPosition(0, 0)
        ingStat:addChild(menuCancel)
        btnCancel:registerScriptTapHandler(function()
          audio.play(audio.button)
          local onCancel = function()
            local params = {sid = player.sid, tid = v.tid, type = 2}
            tbl2string(params)
            addWaitNet()
            net:htask_speedup(params, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              if l_1_0.status < 0 then
                showToast("status:" .. l_1_0.status)
                return 
              end
              if l_1_0.status >= 0 then
                htaskData.del(v.tid)
                return 
              end
                  end)
               end
          local pr = {title = "", text = i18n.global.herotask_cancel_if.string, handle = onCancel, scale = false}
          bg:addChild(require("ui.tips.confirm").create(pr), 100)
            end)
        local btnSpeedSprite = img.createLogin9Sprite(img.login.button_9_small_green)
        btnSpeedSprite:setPreferredSize(CCSize(150, 50))
        local btnSpeed = SpineMenuItem:create(json.ui.button, btnSpeedSprite)
        local menuSpeed = CCMenu:createWithItem(btnSpeed)
        btnSpeed:setPosition(681, 43)
        menuSpeed:setPosition(0, 0)
        ingStat:addChild(menuSpeed)
        local showSpeedIcon = img.createItemIcon2(ITEM_ID_GEM)
        showSpeedIcon:setScale(0.8)
        showSpeedIcon:setPosition(31, 27)
        btnSpeedSprite:addChild(showSpeedIcon)
        local showSpeedCost = lbl.createFont2(13, cfgtask[v.id].speedup)
        showSpeedCost:setPosition(31, 17)
        btnSpeedSprite:addChild(showSpeedCost, 1)
        local showSpeedLab = lbl.createFont1(16, i18n.global.herotask_btn_carryout.string, ccc3(30, 99, 5))
        showSpeedLab:setPosition(95, 26)
        btnSpeedSprite:addChild(showSpeedLab)
        if cfgtask[v.id].speedup == 0 then
          showSpeedIcon:setVisible(false)
          showSpeedCost:setVisible(false)
          showSpeedLab:setString(i18n.global.casino_btn_free.string)
          showSpeedLab:setPosition(btnSpeedSprite:getContentSize().width / 2, btnSpeedSprite:getContentSize().height / 2 + 1)
        end
        btnSpeed:registerScriptTapHandler(function()
          audio.play(audio.button)
          local onSpeedUp = function()
            local params = {sid = player.sid, tid = v.tid, type = 1}
            addWaitNet()
            net:htask_speedup(params, function(l_1_0)
              delWaitNet()
              if l_1_0.status < 0 then
                showToast("status:" .. l_1_0.status)
                return 
              end
              tbl2string(l_1_0)
              if l_1_0.status >= 0 then
                local databag = require("data.bag")
                databag.subGem(cfgtask[v.id].speedup)
                if cfgtask[v.id].star == QUALITY_4 then
                  achieveData.add(ACHIEVE_TYPE_COMPLETE_HEROTASK4, 1)
                  local mactivity_data = require("data.monthlyactivity")
                  mactivity_data.addScore(mactivity_data.IDS.SCORE_TARVEN_4.ID, 1)
                end
                if cfgtask[v.id].star == QUALITY_5 then
                  achieveData.add(ACHIEVE_TYPE_COMPLETE_HEROTASK5, 1)
                  local mactivity_data = require("data.monthlyactivity")
                  mactivity_data.addScore(mactivity_data.IDS.SCORE_TARVEN_5.ID, 1)
                end
                if cfgtask[v.id].star == QUALITY_6 then
                  achieveData.add(ACHIEVE_TYPE_COMPLETE_HEROTASK6, 1)
                  local mactivity_data = require("data.monthlyactivity")
                  mactivity_data.addScore(mactivity_data.IDS.SCORE_TARVEN_6.ID, 1)
                end
                if cfgtask[v.id].star == QUALITY_7 then
                  local mactivity_data = require("data.monthlyactivity")
                  mactivity_data.addScore(mactivity_data.IDS.SCORE_TARVEN_7.ID, 1)
                end
                local dailytask = require("data.task")
                dailytask.increment(dailytask.TaskType.HERO_TASK, 1)
                databag = require("data.bag")
                databag.addRewards(l_1_0.reward)
                htaskData.del(v.tid)
                layer:addChild(require("ui.tips.reward").create(l_1_0.reward), 1000)
              end
                  end)
               end
          local pr = {title = i18n.global.herotask_skip_title.string, text = string.format(i18n.global.herotask_skip_info.string, cfgtask[v.id].speedup), handle = onSpeedUp, scale = false}
          if cfgtask[v.id].speedup <= bag.gem() then
            bg:addChild(require("ui.tips.confirm").create(pr), 100)
          else
            local gotoStoreDialog = require("ui.gotoShopDlg")
            gotoStoreDialog.show(layer, "herotask")
          end
            end)
      end
    end
  end
  showTitle:setString(string.format(i18n.global.herotask_info.string, #taskBg, cfgvip[vipLv].heroTask))
  upvalue_10240 = true
   end
  local lasty = nil
  local onTouchBegin = function(l_8_0, l_8_1)
    lasty = l_8_1
    return true
   end
  local onTouchMoved = function(l_9_0, l_9_1)
    return true
   end
  local onTouchEnd = function(l_10_0, l_10_1)
    if math.abs(l_10_1 - lasty) > 10 then
      return 
    end
    local pointOnScroll = scroll:getContainer():convertToNodeSpace(ccp(l_10_0, l_10_1))
    for i,v in ipairs(taskBg) do
      if v:boundingBox():containsPoint(pointOnScroll) then
        audio.play(audio.button)
        contentLayer.loadContent(i)
        print(i)
    else
      end
    end
    return true
   end
  local onTouch = function(l_11_0, l_11_1, l_11_2)
    if l_11_0 == "began" then
      return onTouchBegin(l_11_1, l_11_2)
    elseif l_11_0 == "moved" then
      return onTouchMoved(l_11_1, l_11_2)
    else
      return onTouchEnd(l_11_1, l_11_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    if uiParams and uiParams.from_layer == "task" then
      replaceScene(require("ui.town.main").create({from_layer = "task"}))
    else
      replaceScene(require("ui.town.main").create())
    end
   end
  local onEnter = function()
    local params = {}
    params.sid = player.sid
    addWaitNet()
    net:htask(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      htaskData.init(l_1_0)
      createTasks(0)
      labDiamond:setString(refreshGem)
      end)
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_15_0)
    if l_15_0 == "enter" then
      onEnter()
    elseif l_15_0 == "exit" then
      onExit()
    elseif l_15_0 == "cleanup" then
      img.unload(img.packedOthers.ui_herotask_bg)
      img.unload(img.packedOthers.spine_ui_jiuguan_refresh)
      json.unload(json.ui.jiuguan_refresh)
    end
   end)
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = SpineMenuItem:create(json.ui.button, btnBackSprite)
  btnBack:setPosition(35, 546)
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  bg:addChild(menuBack)
  layer.back = btnBack
  btnBack:registerScriptTapHandler(function()
    audio.play(audio.button)
    if uiParams and uiParams.from_layer == "task" then
      replaceScene(require("ui.town.main").create({from_layer = "task"}))
    else
      replaceScene(require("ui.town.main").create())
    end
   end)
  autoLayoutShift(btnBack)
  layer:scheduleUpdateWithPriorityLua(function()
    updateLabels()
    if openUpdate then
      if #htaskData.tasks < #taskBg then
        createTasks(0, scroll:getContentOffset().y)
        labDiamond:setString(refreshGem)
      end
      if #taskBg < #htaskData.tasks then
        createTasks(0)
        labDiamond:setString(refreshGem)
      end
      refreshTime:setString(time2string(math.max(0, htaskData.cd - os.time())))
      for i,v in ipairs(htaskData.tasks) do
        if not v.heroes then
          taskBg[i].normalStat:setVisible(true)
          taskBg[i].finish:setVisible(false)
          taskBg[i].ingStat:setVisible(false)
          taskBg[i].compStat:setVisible(false)
          for i,v in (for generator) do
          end
          if os.time() < v.cd then
            taskBg[i].normalStat:setVisible(false)
            taskBg[i].finish:setVisible(false)
            taskBg[i].compStat:setVisible(false)
            taskBg[i].ingStat:setVisible(true)
            if taskBg[i].btnLock and taskBg[i].btnUnLock then
              taskBg[i].btnLock:setVisible(false)
              taskBg[i].btnUnLock:setVisible(true)
            end
            taskBg[i].ingStat.showLastTime:setString(time2string(math.max(0, v.cd - os.time())))
            taskBg[i].ingStat.showTimeBar:setPercentage(100 - (v.cd - os.time()) / cfgtask[v.id].questTime / 60 * 100)
            for i,v in (for generator) do
            end
            taskBg[i].normalStat:setVisible(false)
            taskBg[i].finish:setVisible(false)
            taskBg[i].ingStat:setVisible(false)
            taskBg[i].compStat:setVisible(true)
          end
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end)
  btnRecHigh:registerScriptTapHandler(function()
    audio.play(audio.button)
    local itemCount = 0
    if bag.items.find(ITEM_ID_HTASK_HIGH) then
      itemCount = bag.items.find(ITEM_ID_HTASK_HIGH).num
    end
    if itemCount < 1 then
      showToast(i18n.global.herotast_no_scohigh.string)
      return 
    end
    local params = {sid = player.sid, type = 2}
    addWaitNet()
    net:htask_add(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast("server status:" .. l_1_0.status)
        return 
      end
      bag.items.sub({id = ITEM_ID_HTASK_HIGH, num = 1})
      htaskData.add(l_1_0.task)
      createTasks(2)
      labDiamond:setString(refreshGem)
      end)
   end)
  btnRecLow:registerScriptTapHandler(function()
    audio.play(audio.button)
    local itemCount = 0
    if bag.items.find(ITEM_ID_HTASK_LOW) then
      itemCount = bag.items.find(ITEM_ID_HTASK_LOW).num
    end
    if itemCount < 1 then
      showToast(i18n.global.herotast_no_scolow.string)
      return 
    end
    local params = {sid = player.sid, type = 1}
    addWaitNet()
    net:htask_add(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast("server status:" .. l_1_0.status)
        return 
      end
      bag.items.sub({id = ITEM_ID_HTASK_LOW, num = 1})
      htaskData.add(l_1_0.task)
      createTasks(2)
      labDiamond:setString(refreshGem)
      end)
   end)
  btnRefresh:registerScriptTapHandler(function()
    audio.play(audio.button)
    local onrefresh = function()
      local params = {sid = player.sid}
      addWaitNet()
      net:htask_gem(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast("server status:" .. l_1_0.status)
          return 
        end
        local databag = require("data.bag")
        databag.subGem(refreshGem)
        htaskData.init(l_1_0)
        createTasks(1)
        labDiamond:setString(refreshGem)
         end)
      end
    local pr = {title = i18n.global.herotask_btn_refresh.string, text = string.format(i18n.global.herotask_refresh_info.string, refreshGem), handle = onrefresh}
    local isNeedRe = false
    for i,v in ipairs(htaskData.tasks) do
      if not v.heroes then
        isNeedRe = true
      end
    end
    if not isNeedRe then
      showToast(i18n.global.toast_herotask_nrefresh.string)
    else
      if bag.gem() < refreshGem then
        local gotoStoreDialog = require("ui.gotoShopDlg")
        gotoStoreDialog.show(layer, "herotask")
      else
        layer:addChild(require("ui.tips.confirm").create(pr), 100)
      end
    end
   end)
  return layer
end

return ui

