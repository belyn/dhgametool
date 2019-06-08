-- Command line was: E:\github\dhgametool\scripts\ui\guildmill\order.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local cfgmill = require("config.mill")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local selecthero = require("ui.selecthero.main")
local cfgmilllv = require("config.milllv")
local net = require("net.netClient")
local guildmill = require("data.guildmill")
local player = require("data.player")
local bag = require("data.bag")
ui.create = function()
  local layer = CCLayer:create()
  local upflag = false
  local isorder, noorder, orderlayer, orderTasklab, recTimeLabel = nil, nil, nil, nil, nil
  local completeTipsLayer = function(l_1_0)
    local comlayer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
    json.load(json.ui.npc_order)
    local aniOrder = DHSkeletonAnimation:createWithKey(json.ui.npc_order)
    aniOrder:setScale(view.minScale)
    aniOrder:scheduleUpdateLua()
    aniOrder:playAnimation("in")
    aniOrder:appendNextAnimation("stand", -1)
    aniOrder:setPosition(scalep(480, 268))
    comlayer:addChild(aniOrder, 1000)
    local tipsLab = lbl.createFont2(24, i18n.global.guild_mill_tip_compele.string, ccc3(253, 225, 105))
    aniOrder:addChildFollowSlot("code_1", tipsLab)
    local ok0 = img.createLogin9Sprite(img.login.button_9_small_gold)
    ok0:setPreferredSize(CCSizeMake(160, 52))
    local okLab = lbl.createFont1(18, i18n.global.summon_comfirm.string, ccc3(115, 59, 5))
    okLab:setPosition(CCPoint(ok0:getContentSize().width / 2, ok0:getContentSize().height / 2))
    ok0:addChild(okLab)
    local okBtn = SpineMenuItem:create(json.ui.button, ok0)
    local okMenu = CCMenu:createWithItem(okBtn)
    okMenu:setPosition(CCPoint(0, 0))
    aniOrder:addChildFollowSlot("code_2", okMenu)
    okBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      comlayer:removeFromParentAndCleanup()
      local rewardsKit = require("ui.reward")
      CCDirector:sharedDirector():getRunningScene():addChild(rewardsKit.showReward(rewads), 100000)
      end)
    comlayer:setTouchEnabled(true)
    return comlayer
   end
  local init = function()
    local param = {}
    param.sid = player.sid
    addWaitNet()
    net:gmill_sync(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      guildmill.initorder(l_1_0)
      if guildmill.order then
        guildmill.sortOrder()
        upvalue_512 = isorder()
        upvalue_1536 = lbl.createMixFont1(16, string.format(i18n.global.gmill_order_tasknum.string,  guildmill.order), ccc3(78, 52, 32))
        orderTasklab:setAnchorPoint(0, 0.5)
        orderTasklab:setPosition(CCPoint(50, 410))
        layer:addChild(orderTasklab)
      else
        upvalue_512 = noorder()
      end
      local recTimeStr = string.format("%02d:%02d:%02d", 0, 0, 0)
      upvalue_4096 = lbl.createFont2(16, recTimeStr, ccc3(195, 255, 66))
      recTimeLabel:setAnchorPoint(1, 0.5)
      recTimeLabel:setPosition(CCPoint(490, 408))
      layer:addChild(recTimeLabel)
      recTimeLabel:setVisible(false)
      layer:addChild(orderlayer)
      if l_1_0.rewards then
        local tmp_bag = {items = {}, equips = {}}
        do
          if l_1_0.rewards[1].items then
            for ii = 1,  l_1_0.rewards[1].items do
              local tbl_p = tmp_bag.items
              tbl_p[ tbl_p + 1] = {id = l_1_0.rewards[1].items[ii].id, num = l_1_0.rewards[1].items[ii].num}
            end
          else
            if l_1_0.rewards[1].equips then
              for ii = 1,  l_1_0.rewards[1].equips do
                local tbl_p = tmp_bag.equips
                tbl_p[ tbl_p + 1] = {id = l_1_0.rewards[1].equips[ii].id, num = l_1_0.rewards[1].equips[ii].num}
              end
            end
          end
          bag.addRewards(l_1_0.rewards[1])
          schedule(layer, 0.2, function()
            local comlayer = completeTipsLayer(tmp_bag)
            CCDirector:sharedDirector():getRunningScene():addChild(comlayer, 1000)
               end)
        end
      end
      end)
   end
  init()
  local title = lbl.createFont1(24, i18n.global.gmill_order_title.string, ccc3(230, 208, 174))
  title:setPosition(CCPoint(360, 492))
  layer:addChild(title, 1)
  local title_shadowD = lbl.createFont1(24, i18n.global.gmill_order_title.string, ccc3(89, 48, 27))
  title_shadowD:setPosition(CCPoint(360, 490))
  layer:addChild(title_shadowD)
  local recvorderSprite = img.createLogin9Sprite(img.login.button_9_small_green)
  recvorderSprite:setPreferredSize(CCSizeMake(160, 40))
  local recvorderlab = lbl.createFont1(16, i18n.global.gmill_receive_order.string, ccc3(29, 103, 0))
  recvorderlab:setPosition(CCPoint(recvorderSprite:getContentSize().width / 2, recvorderSprite:getContentSize().height / 2))
  recvorderSprite:addChild(recvorderlab)
  local recvorderBtn = SpineMenuItem:create(json.ui.button, recvorderSprite)
  recvorderBtn:setAnchorPoint(1, 0)
  recvorderBtn:setPosition(CCPoint(668, 390))
  local recvorderMenu = CCMenu:createWithItem(recvorderBtn)
  recvorderMenu:setPosition(0, 0)
  layer:addChild(recvorderMenu)
  recvorderBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local param = {}
    param.sid = player.sid
    addWaitNet()
    net:gmill_order(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      guildmill.order = {}
      guildmill.order = l_1_0.orders
      guildmill.ecd = 43200
      guildmill.pull_ecd_time = os.time()
      setShader(recvorderBtn, SHADER_GRAY, true)
      recvorderBtn:setEnabled(false)
      if guildmill.pull_ocd_time == nil then
        guildmill.pull_ocd_time = {}
        for i = 1,  guildmill.order do
          guildmill.pull_ocd_time[i] = os.time()
        end
      end
      orderlayer:removeFromParentAndCleanup(true)
      upvalue_1536 = nil
      upvalue_1536 = isorder()
      layer:addChild(orderlayer)
      if orderTasklab == nil then
        upvalue_3072 = lbl.createMixFont1(16, string.format(i18n.global.gmill_order_tasknum.string,  guildmill.order), ccc3(78, 52, 32))
        orderTasklab:setAnchorPoint(0, 0.5)
        orderTasklab:setPosition(CCPoint(50, 410))
        layer:addChild(orderTasklab)
      else
        orderTasklab:setString(string.format(i18n.global.gmill_order_tasknum.string,  guildmill.order))
      end
      end)
   end)
  noorder = function()
    local noorderlayer = CCLayer:create()
    local empty = require("ui.empty")
    local emptyBox = empty.create({text = i18n.global.gmill_noorder.string})
    emptyBox:setPosition(360, 220)
    noorderlayer:addChild(emptyBox)
    return noorderlayer
   end
  isorder = function()
    local isorderlayer = CCLayer:create()
    local itemNum =  guildmill.order
    local SCROLL_CONTAINER_SIZE = itemNum * 250
    local Scroll = CCScrollView:create()
    Scroll:setDirection(kCCScrollViewDirectionHorizontal)
    Scroll:setPosition(51, 52)
    Scroll:setViewSize(CCSize(616, 330))
    Scroll:setContentSize(CCSize(SCROLL_CONTAINER_SIZE + 20, 400))
    isorderlayer:addChild(Scroll)
    local itemBg = {}
    local timebg = {}
    local progressLabel = {}
    local cliamdBtn = {}
    local powerProgress = {}
    local createItem = function(l_1_0)
      print("pos:", l_1_0)
      itemBg[l_1_0] = img.createUI9Sprite(img.ui.botton_fram_2)
      itemBg[l_1_0]:setPreferredSize(CCSizeMake(244, 322))
      itemBg[l_1_0]:setPosition(-248 + 250 * l_1_0 + itemBg[l_1_0]:getContentSize().width / 2, itemBg[l_1_0]:getContentSize().height / 2)
      Scroll:getContainer():addChild(itemBg[l_1_0])
      local orderID = guildmill.order[l_1_0].id
      local ordericon = img.createUISprite(img.ui.guild_mill_order" .. cfgmill[orderID].resI)
      ordericon:setScale(0.8)
      ordericon:setPosition(itemBg[l_1_0]:getContentSize().width / 2, 238)
      itemBg[l_1_0]:addChild(ordericon)
      local line = img.createUI9Sprite(img.ui.gemstore_fgline)
      line:setPreferredSize(CCSize(218, 2))
      line:setPosition(CCPoint(122, 174))
      itemBg[l_1_0]:addChild(line)
      local dx = 14
      local sx = 45 - dx / 2 * (orderID - 1)
      for i = 1, orderID do
        local star = img.createUISprite(img.ui.guild_mill_star_s)
        star:setPosition(sx + dx * (i - 1), 10)
        ordericon:addChild(star, 1)
      end
      json.load(json.ui.clock)
      local clockIcon = DHSkeletonAnimation:createWithKey(json.ui.clock)
      clockIcon:scheduleUpdateLua()
      clockIcon:playAnimation("animation", -1)
      clockIcon:setPosition(28, 292)
      itemBg[l_1_0]:addChild(clockIcon, 100)
      local timelab = lbl.createFont1(16, cfgmill[orderID].time .. i18n.global.herotask_time.string, ccc3(148, 107, 74))
      timelab:setAnchorPoint(0, 0.5)
      timelab:setPosition(clockIcon:boundingBox():getMaxX() + 25, 292)
      itemBg[l_1_0]:addChild(timelab)
      timebg[l_1_0] = img.createUI9Sprite(img.ui.guild_mill_timebg)
      timebg[l_1_0]:setPreferredSize(CCSizeMake(211, 34))
      timebg[l_1_0]:setPosition(122, 54)
      itemBg[l_1_0]:addChild(timebg[l_1_0])
      timebg[l_1_0]:setVisible(false)
      local progress0 = img.createUISprite(img.ui.herotask_time_shortfg)
      powerProgress[l_1_0] = createProgressBar(progress0)
      powerProgress[l_1_0]:setScaleX(208 / powerProgress[l_1_0]:getContentSize().width)
      powerProgress[l_1_0]:setScaleY(30 / powerProgress[l_1_0]:getContentSize().height)
      powerProgress[l_1_0]:setPosition(timebg[l_1_0]:getContentSize().width / 2, timebg[l_1_0]:getContentSize().height / 2)
      powerProgress[l_1_0]:setPercentage(0)
      timebg[l_1_0]:addChild(powerProgress[l_1_0])
      local progressStr = string.format("%02d:%02d:%02d", cfgmill[orderID].time, 0, 0)
      progressLabel[l_1_0] = lbl.createFont2(16, progressStr, ccc3(255, 246, 223))
      progressLabel[l_1_0]:setPosition(CCPoint(timebg[l_1_0]:getContentSize().width / 2, timebg[l_1_0]:getContentSize().height / 2))
      timebg[l_1_0]:addChild(progressLabel[l_1_0])
      local cliamdSprite = img.createLogin9Sprite(img.login.button_9_small_green)
      cliamdSprite:setPreferredSize(CCSizeMake(140, 48))
      cliamdBtn[l_1_0] = SpineMenuItem:create(json.ui.button, cliamdSprite)
      local cliamdlab = lbl.createFont1(20, i18n.global.task_btn_claim.string, ccc3(29, 103, 0))
      cliamdlab:setPosition(CCPoint(cliamdSprite:getContentSize().width / 2, cliamdSprite:getContentSize().height / 2 + 2))
      cliamdSprite:addChild(cliamdlab)
      cliamdBtn[l_1_0]:setPosition(122, 54)
      cliamdBtn[l_1_0]:setVisible(false)
      local cliamdMenu = CCMenu:createWithItem(cliamdBtn[l_1_0])
      cliamdMenu:setPosition(0, 0)
      itemBg[l_1_0]:addChild(cliamdMenu)
      cliamdBtn[l_1_0]:registerScriptTapHandler(function()
        audio.play(audio.button)
        local param = {}
        param.sid = player.sid
        param.mid = guildmill.order[pos].mid
        addWaitNet()
        net:gmill_claim(param, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          if l_1_0.status ~= 0 then
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
            return 
          end
          local tmp_bag = {items = {}, equips = {}}
          if l_1_0.reward.items then
            for ii = 1,  l_1_0.reward.items do
              local tbl_p = tmp_bag.items
              tbl_p[ tbl_p + 1] = {id = l_1_0.reward.items[ii].id, num = l_1_0.reward.items[ii].num}
            end
          else
            if l_1_0.reward.equips then
              for ii = 1,  l_1_0.reward.equips do
                local tbl_p = tmp_bag.equips
                tbl_p[ tbl_p + 1] = {id = l_1_0.reward.equips[ii].id, num = l_1_0.reward.equips[ii].num}
              end
            end
          end
          local rewardsKit = require("ui.reward")
          CCDirector:sharedDirector():getRunningScene():addChild(rewardsKit.showReward(tmp_bag), 100000)
          bag.addRewards(l_1_0.reward)
          table.remove(guildmill.order, pos)
          table.remove(guildmill.pull_ocd_time, pos)
          tbl2string(guildmill.order)
          orderlayer:removeFromParentAndCleanup(true)
          upvalue_2048 = nil
          if guildmill.order and  guildmill.order > 0 then
            upvalue_2048 = isorder()
          else
            upvalue_2048 = noorder()
          end
          orderTasklab:setString(string.format(i18n.global.gmill_order_tasknum.string,  guildmill.order))
          layer:addChild(orderlayer)
            end)
         end)
      local startorder, uporder = nil, nil
      local tmp_item = {}
      local rewardObj = cfgmill[orderID].reward
      local offset_x = 92
      do
        for ii = 1,  rewardObj do
          local itemObj = {}
          itemObj.id = rewardObj[ii].id
          if guildmill.order.rewards and upflag == false then
            for ii = 1,  guildmill.order.rewards.items do
              if guildmill.order.rewards.items[ii].id == itemObj.id then
                itemObj.num = guildmill.order.rewards.items[ii].num
              end
            end
          else
            if guildmill.order[l_1_0].mlv then
              itemObj.num = math.floor(rewardObj[ii].num * cfgmilllv[guildmill.order[l_1_0].mlv].effec + 0.5)
            else
              itemObj.num = math.floor(rewardObj[ii].num * cfgmilllv[guildmill.lv].effec + 0.5)
            end
          end
          local tmp_item0 = img.createItem(itemObj.id, itemObj.num)
          tmp_item[ii] = SpineMenuItem:create(json.ui.button, tmp_item0)
          tmp_item[ii]:setScale(0.65)
          tmp_item[ii]:setPosition(CCPoint(offset_x + (ii - 1) * 64, 125))
          local tmp_item_menu = CCMenu:createWithItem(tmp_item[ii])
          tmp_item_menu:setPosition(CCPoint(0, 0))
          itemBg[l_1_0]:addChild(tmp_item_menu)
          tmp_item[ii]:registerScriptTapHandler(function()
            audio.play(audio.button)
            local tmp_tip = nil
            tmp_tip = tipsitem.createForShow({id = itemObj.id})
            isorderlayer:getParent():getParent():getParent():addChild(tmp_tip, 10000)
            tmp_tip.setClickBlankHandler(function()
              tmp_tip:removeFromParentAndCleanup(true)
                  end)
               end)
        end
        local upgradeSprite = img.createUISprite(img.ui.guild_mill_orderup)
        local upgradeBtn = SpineMenuItem:create(json.ui.button, upgradeSprite)
        upgradeBtn:setPosition(210, 286)
        local upgradeMenu = CCMenu:createWithItem(upgradeBtn)
        upgradeMenu:setPosition(0, 0)
        itemBg[l_1_0]:addChild(upgradeMenu)
        local startSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
        startSprite:setPreferredSize(CCSizeMake(140, 48))
        local startBtn = SpineMenuItem:create(json.ui.button, startSprite)
        local startlab = lbl.createFont1(20, i18n.global.herotask_start_btn.string, ccc3(115, 59, 5))
        startlab:setPosition(CCPoint(startSprite:getContentSize().width / 2, upgradeSprite:getContentSize().height / 2 + 4))
        startSprite:addChild(startlab)
        startBtn:setPosition(122, 54)
        local startMenu = CCMenu:createWithItem(startBtn)
        startMenu:setPosition(0, 0)
        itemBg[l_1_0]:addChild(startMenu)
        local createCostDiamond = function()
          local params = {}
          params.btn_count = 0
          params.body = string.format(i18n.global.gmill_order_sure.string, cfgmill[orderID].upCost)
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
            if bag.gem() < cfgmill[orderID].upCost then
              showToast(i18n.global.summon_gem_lack.string)
              return 
            end
            local param = {}
            param.sid = player.sid
            param.mid = guildmill.order[pos].mid
            addWaitNet()
            net:gmill_uporder(param, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              if l_1_0.status ~= 0 then
                showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
                return 
              end
              upvalue_512 = true
              guildmill.order[pos].id = guildmill.order[pos].id + 1
              bag.subGem(cfgmill[orderID].upCost)
              upvalue_3072 = guildmill.order[pos].id
              uporder()
                  end)
            audio.play(audio.button)
               end)
          btnNo:registerScriptTapHandler(function()
            dialoglayer:removeFromParentAndCleanup(true)
            audio.play(audio.button)
               end)
          local backEvent = function()
            dialoglayer:removeFromParentAndCleanup(true)
               end
          dialoglayer.onAndroidBack = function()
            backEvent()
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
        upgradeBtn:registerScriptTapHandler(function()
          audio.play(audio.button)
          local dialog = createCostDiamond()
          layer:getParent():getParent():addChild(dialog, 1300)
            end)
        startBtn:registerScriptTapHandler(function()
          disableObjAWhile(startBtn)
          audio.play(audio.button)
          local params = {sid = player.sid, mid = guildmill.order[pos].mid}
          addWaitNet()
          net:gmill_start(params, function(l_1_0)
            delWaitNet()
            tbl2string(l_1_0)
            if l_1_0.status ~= 0 then
              showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
              return 
            end
            startorder()
               end)
            end)
        if cfgmill[orderID].upCost == 0 then
          upgradeBtn:setVisible(false)
        end
        startorder = function()
          upgradeBtn:setVisible(false)
          startBtn:setVisible(false)
          if guildmill.order[pos].cd == nil then
            if guildmill.pull_ocd_time == nil then
              guildmill.pull_ocd_time = {}
            end
            guildmill.pull_ocd_time[pos] = os.time()
            guildmill.order[pos].cd = cfgmill[guildmill.order[pos].id].time * 3600
          end
          if guildmill.order[pos].cd == 0 then
            cliamdBtn[pos]:setVisible(true)
            local timeLab = string.format("%02d:%02d:%02d", math.floor(0), math.floor(0), math.floor(0))
            progressLabel[pos]:setString(timeLab)
            powerProgress[pos]:setPercentage((1 - guildmill.order[pos].cd / cfgmill[orderID].time * 3600) * 100)
          else
            cliamdBtn[pos]:setEnabled(false)
          end
            end
        uporder = function()
          ordericon:removeFromParent()
          ordericon = nil
          ordericon = img.createUISprite(img.ui.guild_mill_order" .. cfgmill[orderID].resI)
          ordericon:setScale(0.8)
          ordericon:setPosition(itemBg[pos]:getContentSize().width / 2, 238)
          itemBg[pos]:addChild(ordericon)
          upvalue_3072 = 45 - dx / 2 * (orderID - 1)
          for iii = 1, orderID do
            local star = img.createUISprite(img.ui.guild_mill_star_s)
            star:setPosition(sx + dx * (iii - 1), 10)
            ordericon:addChild(star, 1)
          end
          timelab:setString(cfgmill[orderID].time .. i18n.global.herotask_time.string)
          if cfgmill[orderID].upCost == 0 then
            upgradeBtn:setVisible(false)
          end
          local rewardObj = cfgmill[orderID].reward
          local offset_x = 92
          do
            for ii = 1,  rewardObj do
              if tmp_item[ii] then
                tmp_item[ii]:removeFromParent()
                tmp_item[ii] = nil
              end
              local itemObj = {}
              itemObj.id = rewardObj[ii].id
              if guildmill.order.rewards and upflag == false then
                for ii = 1,  guildmill.order.rewards.items do
                  if guildmill.order.rewards.items[ii].id == itemObj.id then
                    itemObj.num = guildmill.order.rewards.items[ii].num
                  end
                end
              else
                if guildmill.order[pos].mlv then
                  itemObj.num = math.floor(rewardObj[ii].num * cfgmilllv[guildmill.order[pos].mlv].effec + 0.5)
                else
                  itemObj.num = math.floor(rewardObj[ii].num * cfgmilllv[guildmill.lv].effec + 0.5)
                end
              end
              local tmp_item0 = img.createItem(itemObj.id, itemObj.num)
              tmp_item[ii] = SpineMenuItem:create(json.ui.button, tmp_item0)
              tmp_item[ii]:setScale(0.65)
              tmp_item[ii]:setPosition(CCPoint(offset_x + (ii - 1) * 64, 125))
              local tmp_item_menu = CCMenu:createWithItem(tmp_item[ii])
              tmp_item_menu:setPosition(CCPoint(0, 0))
              itemBg[pos]:addChild(tmp_item_menu)
              tmp_item[ii]:registerScriptTapHandler(function()
                audio.play(audio.button)
                local tmp_tip = nil
                tmp_tip = tipsitem.createForShow({id = itemObj.id})
                isorderlayer:getParent():getParent():getParent():addChild(tmp_tip, 10000)
                tmp_tip.setClickBlankHandler(function()
                  tmp_tip:removeFromParentAndCleanup(true)
                        end)
                     end)
            end
          end
            end
        if guildmill.order[l_1_0].cd ~= nil then
          startorder()
        end
      end
      end
    for i = 1, itemNum do
      createItem(i)
    end
    local aniflag = true
    local onUpdate = function(l_2_0)
      if guildmill.order == nil then
        return 
      end
      for ii = 1,  guildmill.order do
        if guildmill.order[ii].cd and guildmill.pull_ocd_time[ii] and progressLabel[ii] and not tolua.isnull(progressLabel[ii]) then
          cd = math.max(0, guildmill.order[ii].cd + guildmill.pull_ocd_time[ii] - os.time())
          if cd > 0 then
            timebg[ii]:setVisible(true)
            local timeLab = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
            progressLabel[ii]:setString(timeLab)
            powerProgress[ii]:setPercentage((1 - cd / (3600 * cfgmill[guildmill.order[ii].id].time)) * 100)
          else
            local timeLab = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
            progressLabel[ii]:setString(timeLab)
            timebg[ii]:setVisible(false)
            cliamdBtn[ii]:setVisible(true)
            cliamdBtn[ii]:setEnabled(true)
            if aniflag then
              upvalue_3072 = false
            end
          end
        end
      end
      end
    isorderlayer:scheduleUpdateWithPriorityLua(onUpdate, 0)
    return isorderlayer
   end
  local onUpdateForecd = function(l_6_0)
    if recTimeLabel and guildmill.ecd and guildmill.pull_ecd_time then
      cd = math.max(0, guildmill.ecd + guildmill.pull_ecd_time - os.time())
      if cd > 0 then
        local timeLab = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
        recTimeLabel:setString(timeLab)
        recTimeLabel:setVisible(true)
        setShader(recvorderBtn, SHADER_GRAY, true)
        recvorderBtn:setEnabled(false)
      else
        recvorderBtn:setEnabled(true)
        clearShader(recvorderBtn, true)
        recTimeLabel:setVisible(false)
      end
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdateForecd, 0)
  return layer
end

return ui

