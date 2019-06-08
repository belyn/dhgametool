-- Command line was: E:\github\dhgametool\scripts\ui\activity\asylum.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.activity")
local cfghero = require("config.hero")
local cfgequip = require("config.equip")
local player = require("data.player")
local activityData = require("data.activity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local bag = require("data.bag")
local heros = require("data.heros")
local IDS = activityData.IDS
local ItemType = {Item = 1, Equip = 2}
local vp_ids = {IDS.ASYLUM_1.ID, IDS.ASYLUM_2.ID, IDS.ASYLUM_3.ID, IDS.ASYLUM_4.ID, IDS.ASYLUM_5.ID, IDS.ASYLUM_6.ID}
local operData = {}
local initHeros = function()
  local tmpheros = {}
  for i,v in ipairs(heros) do
    tmpheros[ tmpheros + 1] = {hid = v.hid, id = v.id, lv = v.lv, isUsed = false, flag = v.flag or 0}
  end
  operData.heros = tmpheros
end

local createSelectBoard = function(l_2_0, l_2_1)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 210))
  local headData = {}
  for i,v in ipairs(operData.heros) do
    if v.isUsed == false then
      if cfghero[v.id].job == l_2_0.job and cfghero[v.id].maxStar == l_2_0.qlt and cfghero[v.id].group == l_2_0.group then
        headData[ headData + 1] = v
        for i,v in (for generator) do
        end
        if cfghero[v.id].group == l_2_0.group and cfghero[v.id].maxStar == l_2_0.qlt and l_2_0.job == 0 then
          headData[ headData + 1] = v
          for i,v in (for generator) do
          end
          if cfghero[v.id].job == l_2_0.job and cfghero[v.id].maxStar == l_2_0.qlt and l_2_0.group == 0 then
            headData[ headData + 1] = v
            for i,v in (for generator) do
            end
            if cfghero[v.id].job == l_2_0.job and cfghero[v.id].group == l_2_0.group and l_2_0.qlt == 0 then
              headData[ headData + 1] = v
              for i,v in (for generator) do
              end
              for j,k in ipairs(l_2_0.select) do
                if k == v.hid then
                  headData[ headData + 1] = v
                  for i,v in (for generator) do
                  end
                end
              end
            end
            local board = img.createUI9Sprite(img.ui.tips_bg)
            board:setPreferredSize(CCSize(520, 420))
            board:setScale(view.minScale)
            board:setPosition(scalep(480, 288))
            layer:addChild(board)
            local showTitle = lbl.createFont1(20, i18n.global.heroforge_board_title.string, ccc3(255, 227, 134))
            showTitle:setPosition(260, 386)
            board:addChild(showTitle)
            local showFgline = img.createUI9Sprite(img.ui.hero_enchant_info_fgline)
            showFgline:setPreferredSize(CCSize(453, 1))
            showFgline:setPosition(260, 354)
            board:addChild(showFgline)
            local tmpSelect = {}
            local showHeads = {}
            local curSelect = {}
            local backEvent = function()
              for i,v in ipairs(headData) do
                if  tmpSelect == 0 and  curSelect ~= 0 then
                  for z = i,  curSelect do
                    if v.hid == curSelect[z] then
                      v.isUsed = true
                  else
                    end
                  end
                end
                for j = 1,  tmpSelect do
                  if v.hid == tmpSelect[j] then
                    local curflag = false
                    for z = i,  curSelect do
                      if v.hid == curSelect[z] then
                        curflag = true
                    else
                      end
                    end
                    if curflag == false then
                      v.isUsed = false
                      for i,v in (for generator) do
                      end
                    end
                  end
                   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

                end
                layer:removeFromParentAndCleanup(true)
                 -- Warning: missing end command somewhere! Added here
              end
                  end
            local btnCloseSp = img.createLoginSprite(img.login.button_close)
            local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSp)
            btnClose:setPosition(495, 397)
            local menuClose = CCMenu:createWithItem(btnClose)
            menuClose:setPosition(0, 0)
            board:addChild(menuClose, 1000)
            btnClose:registerScriptTapHandler(function()
              backEvent()
              audio.play(audio.button)
                  end)
            local height = 84 * math.ceil( headData / 5)
            local scroll = CCScrollView:create()
            scroll:setDirection(kCCScrollViewDirectionVertical)
            scroll:setAnchorPoint(ccp(0, 0))
            scroll:setPosition(53, 113)
            scroll:setViewSize(CCSize(420, 225))
            scroll:setContentSize(CCSize(420, height))
            board:addChild(scroll)
            if  headData == 0 then
              local empty = require("ui.empty").create({size = 16, text = i18n.global.empty_heromar.string, color = ccc3(255, 246, 223)})
              empty:setPosition(board:getContentSize().width / 2, board:getContentSize().height / 2)
              board:addChild(empty)
            end
            for i,v in ipairs(headData) do
              local x = math.ceil(i / 5)
              local y = i - (x - 1) * 5
              showHeads[i] = img.createHeroHead(v.id, v.lv, true, true)
              showHeads[i]:setScale(0.8)
              showHeads[i]:setAnchorPoint(ccp(0, 0))
              showHeads[i]:setPosition(2 + 84 * (y - 1), height - 84 * x - 5)
              scroll:getContainer():addChild(showHeads[i])
              local showJob = img.createUISprite(img.ui.job_" .. cfghero[v.id].jo)
              showJob:setPosition(17, 52)
              showHeads[i]:addChild(showJob, 3)
              if v.flag > 0 then
                local blackBoard = img.createUISprite(img.ui.hero_head_shade)
                blackBoard:setScale(0.93617021276596)
                blackBoard:setOpacity(120)
                blackBoard:setPosition(showHeads[i]:getContentSize().width / 2, showHeads[i]:getContentSize().height / 2)
                showHeads[i]:addChild(blackBoard)
                local showLock = img.createUISprite(img.ui.devour_icon_lock)
                showLock:setPosition(showHeads[i]:getContentSize().width / 2, showHeads[i]:getContentSize().height / 2)
                showHeads[i]:addChild(showLock)
              end
            end
            scroll:setContentOffset(ccp(0, 225 - height))
            local onSelect = function(l_3_0)
              if headData[l_3_0].flag > 0 then
                local count = 0
                local text = ""
                if headData[l_3_0].flag % 2 == 1 then
                  text = text .. i18n.global.toast_devour_arena.string
                  count = count + 1
                end
                if math.floor(headData[l_3_0].flag / 2) % 2 == 1 then
                  if count >= 1 then
                    text = text .. "\n"
                  end
                  text = text .. i18n.global.toast_devour_lock.string
                  count = count + 1
                end
                if math.floor(headData[l_3_0].flag / 4) % 2 % 2 == 1 then
                  if count >= 1 then
                    text = text .. "\n"
                  end
                  text = text .. i18n.global.toast_devour_3v3arena.string
                  count = count + 1
                end
                if math.floor(headData[l_3_0].flag / 8) % 2 % 2 % 2 == 1 then
                  if count >= 1 then
                    text = text .. "\n"
                  end
                  text = text .. i18n.global.toast_devour_frdarena.string
                  count = count + 1
                end
                showToast(text)
                return 
              end
              headData[l_3_0].isUsed = true
              tmpSelect[ tmpSelect + 1] = headData[l_3_0].hid
              local blackBoard = img.createUISprite(img.ui.hero_head_shade)
              blackBoard:setScale(0.93617021276596)
              blackBoard:setOpacity(120)
              blackBoard:setPosition(showHeads[l_3_0]:getContentSize().width / 2, showHeads[l_3_0]:getContentSize().height / 2)
              showHeads[l_3_0]:addChild(blackBoard, 0, 1)
              local selectIcon = img.createUISprite(img.ui.hook_btn_sel)
              selectIcon:setPosition(blackBoard:getContentSize().width / 2, blackBoard:getContentSize().height / 2)
              blackBoard:addChild(selectIcon)
                  end
            local onUnselect = function(l_4_0)
              for i,v in ipairs(tmpSelect) do
                if v == headData[l_4_0].hid then
                  tmpSelect[i], tmpSelect[ tmpSelect] = tmpSelect[ tmpSelect], tmpSelect[i]
                  tmpSelect[ tmpSelect] = nil
              else
                end
              end
              headData[l_4_0].isUsed = false
              if showHeads[l_4_0]:getChildByTag(1) then
                showHeads[l_4_0]:removeChildByTag(1)
              end
                  end
            for i,v in ipairs(headData) do
              for j,k in ipairs(l_2_0.select) do
                if k == v.hid then
                  onSelect(i)
                  curSelect[ curSelect + 1] = v.hid
                end
              end
            end
            local lasty = nil
            local onTouchBegin = function(l_5_0, l_5_1)
              lasty = l_5_1
              return true
                  end
            local onTouchMoved = function(l_6_0, l_6_1)
              return true
                  end
            local onTouchEnd = function(l_7_0, l_7_1)
              local point = layer:convertToNodeSpace(ccp(l_7_0, l_7_1))
              do
                local pointOnScroll = scroll:getContainer():convertToNodeSpace(ccp(l_7_0, l_7_1))
                if math.abs(l_7_1 - lasty) > 10 then
                  return 
                end
                for i,v in ipairs(showHeads) do
                  if v:boundingBox():containsPoint(pointOnScroll) then
                    if not headData[i].isUsed and  tmpSelect < condition.num then
                      onSelect(i)
                      for i,v in (for generator) do
                      end
                      if headData[i].isUsed == true then
                        onUnselect(i)
                      end
                    end
                  end
                  return true
                end
                 -- Warning: missing end command somewhere! Added here
              end
                  end
            local onTouch = function(l_8_0, l_8_1, l_8_2)
              if l_8_0 == "began" then
                return onTouchBegin(l_8_1, l_8_2)
              elseif l_8_0 == "moved" then
                return onTouchMoved(l_8_1, l_8_2)
              else
                return onTouchEnd(l_8_1, l_8_2)
              end
                  end
            layer:registerScriptTouchHandler(onTouch)
            layer:setTouchEnabled(true)
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
            layer:registerScriptHandler(function(l_12_0)
              if l_12_0 == "enter" then
                onEnter()
              elseif l_12_0 == "exit" then
                onExit()
              end
                  end)
            local btnSelectSp = img.createLogin9Sprite(img.login.button_9_small_gold)
            btnSelectSp:setPreferredSize(CCSize(150, 50))
            local labSelect = lbl.createFont1(16, i18n.global.heroforge_board_btn.string, ccc3(106, 61, 37))
            labSelect:setPosition(btnSelectSp:getContentSize().width / 2, btnSelectSp:getContentSize().height / 2)
            btnSelectSp:addChild(labSelect)
            local btnSelect = SpineMenuItem:create(json.ui.button, btnSelectSp)
            btnSelect:setPosition(260, 55)
            local menuSelect = CCMenu:createWithItem(btnSelect)
            menuSelect:setPosition(0, 0)
            board:addChild(menuSelect)
            btnSelect:registerScriptTapHandler(function()
              condition.select = tmpSelect
              layer:removeFromParentAndCleanup(true)
              callfunc()
                  end)
            board:setScale(0.5)
            do
              local anim_arr = CCArray:create()
              anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
              anim_arr:addObject(CCDelayTime:create(0.15))
              anim_arr:addObject(CCCallFunc:create(function()
                  end))
              board:runAction(CCSequence:create(anim_arr))
              return layer
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.createOplayer = function(l_3_0, l_3_1, l_3_2)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  darkbg:setScale(2)
  layer:addChild(darkbg)
  local showReward = {}
  local showHero = {}
  local showPowerBg = CCSprite:create()
  showPowerBg:setContentSize(CCSize(960, 576))
  showPowerBg:setScale(view.minScale)
  showPowerBg:setPosition(scalep(480, 288))
  layer:addChild(showPowerBg)
  showPowerBg:setScale(0.5 * view.minScale)
  showPowerBg:runAction(CCScaleTo:create(0.15, view.minScale, view.minScale))
  local lbg = img.createUISprite(img.ui.herotask_dialog)
  lbg:setAnchorPoint(1, 0.5)
  lbg:setPosition(480, 288)
  showPowerBg:addChild(lbg)
  local rbg = img.createUISprite(img.ui.herotask_dialog)
  rbg:setFlipX(true)
  rbg:setAnchorPoint(0, 0.5)
  rbg:setPosition(lbg:boundingBox():getMaxX() - 1, 288)
  showPowerBg:addChild(rbg)
  local board = img.createUI9Sprite(img.ui.select_hero_camp_bg)
  board:setPreferredSize(CCSize(622, 182))
  board:setAnchorPoint(ccp(0.5, 0))
  board:setPosition(480, 315)
  showPowerBg:addChild(board)
  local titleCondition = lbl.createFont1(18, i18n.global.mail_rewards.string, ccc3(91, 39, 6))
  titleCondition:setPosition(480, 465)
  showPowerBg:addChild(titleCondition)
  local showLfgline = img.createUISprite(img.ui.herotask_fgline)
  showLfgline:setAnchorPoint(ccp(1, 0.5))
  showLfgline:setPosition(titleCondition:boundingBox():getMinX() - 30, titleCondition:boundingBox():getMidY())
  showPowerBg:addChild(showLfgline)
  local showRfgline = img.createUISprite(img.ui.herotask_fgline)
  showRfgline:setAnchorPoint(ccp(0, 0.5))
  showRfgline:setFlipX(true)
  showRfgline:setPosition(titleCondition:boundingBox():getMaxX() + 30, titleCondition:boundingBox():getMidY())
  showPowerBg:addChild(showRfgline)
  local labTip = lbl.createMixFont1(16, i18n.global.asylum_put_tip.string, ccc3(115, 59, 5))
  labTip:setPosition(480, 285)
  showPowerBg:addChild(labTip)
  local cfgact = cfgactivity[IDS.ASYLUM_1.ID + l_3_0 - 1]
  local ox = 532 - 52 *  cfgact.rewards
  local showReward = {}
  for i,v in ipairs(cfgact.rewards) do
    do
      local showRewardSprite = nil
      do
        if v.type == 1 then
          showRewardSprite = img.createItem(v.id, v.num)
        else
          showRewardSprite = img.createEquip(v.id, v.num)
        end
        showReward[i] = CCMenuItemSprite:create(showRewardSprite, nil)
        showReward[i]:setPosition(ox + (i - 1) * 105, 387)
        local menuReward = CCMenu:createWithItem(showReward[i])
        do
          menuReward:setPosition(0, 0)
          showPowerBg:addChild(menuReward)
          showReward[i]:registerScriptTapHandler(function()
            audio.play(audio.button)
            if v.type == 1 then
              local tips = require("ui.tips.item").createForShow(v)
              layer:addChild(tips, 10000)
            else
              local tips = require("ui.tips.equip").createById(v.id)
              layer:addChild(tips, 10000)
            end
               end)
        end
      end
      local condition = cfgact.parameter
      local sx = 518 - ( condition - 1) * 48
      do
        if cfgact.extra then
          sx = 518 - ( condition +  cfgact.extra - 1) * 48
          for i = 1,  cfgact.extra do
            local icon1 = img.createItem(cfgact.extra[i].id, cfgact.extra[i].num)
            local btnIcon1 = CCMenuItemSprite:create(icon1, nil)
            btnIcon1:setAnchorPoint(1, 0)
            btnIcon1:setScale(0.9)
            btnIcon1:setPosition(sx + ( condition + i - 1) * 96, 174)
            local menuIcon1 = CCMenu:createWithItem(btnIcon1)
            menuIcon1:setPosition(0, 0)
            showPowerBg:addChild(menuIcon1)
            btnIcon1:registerScriptTapHandler(function()
              audio.play(audio.button)
              local tips = require("ui.tips.item").createForShow({id = cfgact.extra[i].id, num = cfgact.extra[i].num})
              layer:addChild(tips, 10000)
                  end)
             -- DECOMPILER ERROR: unhandled construct in 'if'

            if cfgact.extra[i].id == ITEM_ID_COIN and bag.coin() < cfgact.extra[i].num then
              icon1.lblNum:setColor(ccc3(255, 44, 44))
              do return end
              if bag.gem() < cfgact.extra[i].num then
                icon1.lblNum:setColor(ccc3(255, 44, 44))
              end
            end
          end
        end
        local btnHero = {}
        initHeros()
        for i,v in ipairs(condition) do
          v.select = {}
          local id = 1000 * v.qlt + 100 * v.group + 99
          if v.group == 0 then
            id = 1000 * v.qlt + 900 + 99
          end
          local btnSp = nil
          btnSp = img.createHeroHead(id, nil, true, true)
          if v.job ~= 0 then
            local showJob = img.createUISprite(img.ui.job_" .. v.jo)
            showJob:setPosition(15, 52)
            btnSp:addChild(showJob, 3)
          end
          btnHero[i] = CCMenuItemSprite:create(btnSp, nil)
          btnHero[i]:setAnchorPoint(ccp(1, 0))
          btnHero[i]:setScale(0.8)
          btnHero[i]:setPosition(sx + (i - 1) * 95, 174)
          local menuHero = CCMenu:createWithItem(btnHero[i])
          menuHero:setPosition(0, 0)
          showPowerBg:addChild(menuHero)
          local showNum = lbl.createFont2(16, "0/" .. v.num)
          showNum:setPosition(btnHero[i]:boundingBox():getMidX(), 162)
          showPowerBg:addChild(showNum)
          setShader(btnHero[i], SHADER_GRAY, true)
          local icon = img.createUISprite(img.ui.hero_equip_add)
          icon:setPosition(btnHero[i]:boundingBox():getMaxX() - 23, btnHero[i]:boundingBox():getMaxY() - 23)
          showPowerBg:addChild(icon)
          icon:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(0.5, 76.5), CCFadeTo:create(0.5, 255))))
          btnHero[i]:registerScriptTapHandler(function()
            audio.play(audio.button)
            local func = function()
              showNum:setString( v.select .. "/" .. v.num)
              if  v.select < v.num then
                setShader(btnHero[i], SHADER_GRAY, true)
                showNum:setColor(ccc3(255, 255, 255))
              else
                clearShader(btnHero[i], true)
                showNum:setColor(ccc3(195, 255, 66))
              end
                  end
            layer:addChild(createSelectBoard(v, func), 1000)
               end)
        end
        local createSurebuy = function(l_4_0, l_4_1, l_4_2)
          local params = {}
          params.btn_count = 0
          params.body = string.format(i18n.global.asylum_submit_sure.string, 20)
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
            if cfgact.extra then
              for i = 1,  cfgact.extra do
                if cfgact.extra[i].id == ITEM_ID_COIN and bag.coin() < cfgact.extra[i].num then
                  showToast(i18n.global.toast_hero_need_coin.string)
                  return 
                end
                if cfgact.extra[i].id == ITEM_ID_GEM and bag.gem() < cfgact.extra[i].num then
                  showToast(i18n.global.gboss_fight_st6.string)
                  return 
                end
              end
            end
            local hids = {}
            if not condition then
              return 
            end
            for i,v in ipairs(condition) do
              if v.num <=  v.select then
                for j,k in ipairs(v.select) do
                  hids[ hids + 1] = k
                end
                for i,v in (for generator) do
                end
                showToast(i18n.global.hero_wake_no_hero.string)
                return 
              end
              do
                local param = {sid = player.sid, id = IDS.ASYLUM_1.ID + pos - 1, hids = hids}
                tbl2string(param)
                addWaitNet()
                netClient:shield_change(param, function(l_1_0)
                delWaitNet()
                tbl2string(l_1_0)
                if l_1_0.status < 0 then
                  showToast("status:" .. l_1_0.status)
                  return 
                end
                if l_1_0.status == -1 then
                  showToast(i18n.global.actitem_onlyone.string)
                  return 
                end
                if l_1_0.status == -2 then
                  showToast(i18n.global.hero_wake_no_hero.string)
                  return 
                end
                vps[pos].limits = vps[pos].limits - 1
                if cfgact.extra then
                  for ii = 1,  cfgact.extra do
                    if cfgact.extra[ii].id == ITEM_ID_COIN then
                      bag.subCoin(cfgact.extra[ii].num)
                    end
                    if cfgact.extra[ii].id == ITEM_ID_GEM then
                      bag.subGem(cfgact.extra[ii].num)
                    end
                  end
                end
                local reward = {items = {}, equips = {}}
                local returnflag = false
                for i,v in ipairs(hids) do
                  local heroData = heros.find(v)
                  if heroData then
                    for j,k in ipairs(heroData.equips) do
                      if cfgequip[k].pos == EQUIP_POS_JADE then
                        bag.items.addAll(cfgequip[k].jadeUpgAll)
                        if cfgequip[k].jadeUpgAll[1].num > 0 then
                          table.insert(reward.items, {id = cfgequip[k].jadeUpgAll[1].id, num = cfgequip[k].jadeUpgAll[1].num})
                        end
                        if cfgequip[k].jadeUpgAll[2].num > 0 then
                          table.insert(reward.items, {id = cfgequip[k].jadeUpgAll[2].id, num = cfgequip[k].jadeUpgAll[2].num})
                        else
                          table.insert(reward.equips, {id = k, num = 1})
                        end
                      end
                      returnflag = true
                    end
                  end
                  heros.del(v)
                end
                if returnflag then
                  layer:getParent():getParent():getParent():addChild(require("ui.hook.drops").create(reward, i18n.global.material_return.string), 1000)
                end
                if l_1_0.reward then
                  bag.addRewards(l_1_0.reward)
                  local rewardsKit = require("ui.reward")
                  CCDirector:sharedDirector():getRunningScene():addChild(rewardsKit.showReward(l_1_0.reward), 100000)
                end
                layer:removeFromParentAndCleanup()
                getgrayfunc(pos)
                     end)
                audio.play(audio.button)
              end
               -- Warning: missing end command somewhere! Added here
            end
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
        local submit = img.createLogin9Sprite(img.login.button_9_small_gold)
        submit:setPreferredSize(CCSize(148, 54))
        local submitlab = lbl.createFont1(16, i18n.global.frdpvp_team_submit.string, ccc3(115, 59, 5))
        submitlab:setPosition(CCPoint(submit:getContentSize().width / 2, submit:getContentSize().height / 2))
        submit:addChild(submitlab)
        local submitBtn = SpineMenuItem:create(json.ui.button, submit)
        submitBtn:setPosition(480, 90)
        local submitMenu = CCMenu:createWithItem(submitBtn)
        submitMenu:setPosition(0, 0)
        showPowerBg:addChild(submitMenu)
        submitBtn:registerScriptTapHandler(function()
          audio.play(audio.button)
          local surelayer = createSurebuy()
          layer:addChild(surelayer, 1000)
            end)
        local backEvent = function()
          layer:removeFromParentAndCleanup()
            end
        local close0 = img.createUISprite(img.ui.close)
        local closeBtn = SpineMenuItem:create(json.ui.button, close0)
        closeBtn:setPosition(CCPoint(814, 525))
        local closeMenu = CCMenu:createWithItem(closeBtn)
        closeMenu:setPosition(CCPoint(0, 0))
        showPowerBg:addChild(closeMenu)
        closeBtn:registerScriptTapHandler(function()
          backEvent()
            end)
        layer.onAndroidBack = function()
          backEvent()
            end
        addBackEvent(layer)
        local onEnter = function()
          layer.notifyParentLock()
            end
        local onExit = function()
          layer.notifyParentUnlock()
            end
        layer:registerScriptHandler(function(l_11_0)
          if l_11_0 == "enter" then
            onEnter()
          elseif l_11_0 == "exit" then
            onExit()
          end
            end)
        layer:setTouchEnabled(true)
        return layer
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.create = function()
  local layer = CCLayer:create()
  local vps = {}
  for _,v in ipairs(vp_ids) do
    local tmp_status = activityData.getStatusById(v)
    vps[ vps + 1] = tmp_status
  end
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(576, 436))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_asylum)
  local banner = img.createUISprite("activity_asylum.png")
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2, board_h))
  board:addChild(banner)
  local titlebg = img.createUISprite(img.ui.activity_asylum_title)
  titlebg:setAnchorPoint(0.5, 1)
  titlebg:setPosition(board_w / 2, board_h - 5)
  board:addChild(titlebg, 1)
  local titleLab = lbl.createFont2(18, i18n.global.activity_asylum_title.string, ccc3(246, 214, 108))
  titleLab:setPosition(CCPoint(board_w / 2, board_h - 20 - 5))
  board:addChild(titleLab, 1)
  local lbl_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd:setPosition(CCPoint(250, 376))
  banner:addChild(lbl_cd)
  local lbl_cd_des = lbl.createFont2(14, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd_des:setPosition(CCPoint(321, 376))
  banner:addChild(lbl_cd_des)
  if i18n.getCurrentLanguage() == kLanguageRussian then
    lbl_cd_des:setPosition(CCPoint(210, 380))
    lbl_cd:setAnchorPoint(CCPoint(0, 0.5))
    lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMaxX() + 10, 380))
  end
  local SCROLL_CONTAINER_SIZE =  vp_ids * 180 + 30
  local scrollUI = require("ui.pet.scrollUI")
  local Scroll = scrollUI.create()
  Scroll:setDirection(kCCScrollViewDirectionHorizontal)
  Scroll:setPosition(6, 75)
  Scroll:setTouchEnabled(false)
  Scroll:setViewSize(CCSize(564, 290))
  Scroll:setContentSize(CCSize(SCROLL_CONTAINER_SIZE + 20, 290))
  board:addChild(Scroll)
  local sign = {}
  local sell = {}
  local heroBody = {}
  local bottom = {}
  local btn = {}
  local acceMenu = {}
  local selectPos = 1
  local setBtnStatus = function()
    for i = selectPos, selectPos + 2 do
      if vps[i].limits == 0 then
        btn[i - selectPos + 1]:setVisible(false)
      else
        btn[i - selectPos + 1]:setVisible(true)
      end
    end
   end
  local getgrayfunc = function(l_2_0)
    print("debug:pos=", l_2_0, selectPos)
    sign[l_2_0]:setVisible(false)
    sell[l_2_0]:setVisible(true)
    if btn[l_2_0 - selectPos + 1] then
      btn[l_2_0 - selectPos + 1]:setVisible(false)
    end
   end
  local dx = 154
  local posx = {board_w / 2 - 154 - 8, board_w / 2 - 8, board_w / 2 + 154 - 8, board_w / 2 + 300, board_w / 2 + 454, board_w / 2 + 608}
  local createItem = function(l_3_0)
    sign[l_3_0] = img.createUISprite(img.ui.activity_asylum_a)
    sign[l_3_0]:setPosition(posx[l_3_0] - 6, 240)
    Scroll:getContainer():addChild(sign[l_3_0])
    sell[l_3_0] = img.createUISprite(img.ui.activity_asylum_tick)
    sell[l_3_0]:setPosition(posx[l_3_0] - 6, 240)
    Scroll:getContainer():addChild(sell[l_3_0])
    sell[l_3_0]:setVisible(false)
    bottom[l_3_0] = img.createUISprite(img.ui.activity_asylum_bottom)
    bottom[l_3_0]:setPosition(posx[l_3_0] - 6, 47)
    Scroll:getContainer():addChild(bottom[l_3_0])
    local cfgact = cfgactivity[IDS.ASYLUM_1.ID + l_3_0 - 1]
    local cfgitem = require("config.item")
    heroBody[l_3_0] = json.createSpineHero(cfgact.instruct)
    heroBody[l_3_0]:setScale(0.38)
    heroBody[l_3_0]:setPosition(posx[l_3_0] - 6, 41)
    Scroll:getContainer():addChild(heroBody[l_3_0])
    if vps[l_3_0].limits == 0 then
      getgrayfunc(l_3_0)
    end
   end
  for i = 1,  vp_ids do
    createItem(i)
  end
  local createBtn = function(l_4_0)
    local spritebtn = img.createLogin9Sprite(img.login.button_9_small_gold)
    spritebtn:setPreferredSize(CCSize(125, 42))
    local accelab = lbl.createFont1(16, i18n.global.asylum_btn_acce.string, ccc3(115, 59, 5))
    accelab:setPosition(CCPoint(spritebtn:getContentSize().width / 2, spritebtn:getContentSize().height / 2))
    spritebtn:addChild(accelab)
    btn[l_4_0] = SpineMenuItem:create(json.ui.button, spritebtn)
    btn[l_4_0]:setPosition(posx[l_4_0], 50)
    acceMenu[l_4_0] = CCMenu:createWithItem(btn[l_4_0])
    acceMenu[l_4_0]:setPosition(0, 0)
    board:addChild(acceMenu[l_4_0])
    btn[l_4_0]:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer:getParent():getParent():getParent():addChild(ui.createOplayer(pos + selectPos - 1, vps, getgrayfunc), 1000)
      end)
   end
  for i = 1, 3 do
    createBtn(i)
  end
  setBtnStatus()
  local last_update = os.time() - 1
  local onUpdate = function(l_5_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    local remain_cd = vps[1].cd - (os.time() - activityData.pull_time)
    if remain_cd >= 0 then
      local time_str = time2string(remain_cd)
      lbl_cd:setString(time_str)
    else
       -- Warning: missing end command somewhere! Added here
    end
   end
  local btnInfoSprite = img.createUISprite(img.ui.btn_help)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  btnInfo:setPosition(525, board_h - 38)
  local menuInfo = CCMenu:createWithItem(btnInfo)
  menuInfo:setPosition(0, 0)
  board:addChild(menuInfo, 100)
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:getParent():getParent():getParent():addChild(require("ui.help").create(i18n.global.help_asylum.string, i18n.global.help_title.string), 1000)
   end)
  local leftraw = img.createUISprite(img.ui.hero_raw)
  local btnLeftraw = SpineMenuItem:create(json.ui.button, leftraw)
  btnLeftraw:setScale(0.85)
  btnLeftraw:setPosition(32, 198)
  local menuLeftraw = CCMenu:createWithItem(btnLeftraw)
  menuLeftraw:setPosition(0, 0)
  board:addChild(menuLeftraw, 1)
  if selectPos <= 1 then
    setShader(btnLeftraw, SHADER_GRAY, true)
    btnLeftraw:setEnabled(false)
  end
  local rightraw = img.createUISprite(img.ui.hero_raw)
  rightraw:setFlipX(true)
  local btnRightraw = SpineMenuItem:create(json.ui.button, rightraw)
  btnRightraw:setScale(0.85)
  btnRightraw:setPosition(544, 198)
  local menuRightraw = CCMenu:createWithItem(btnRightraw)
  menuRightraw:setPosition(0, 0)
  board:addChild(menuRightraw, 1)
  if  vp_ids - 2 <= selectPos then
    setShader(btnRightraw, SHADER_GRAY, true)
    btnRightraw:setEnabled(false)
  end
  local moveLeft = function()
    if selectPos <  vp_ids - 2 then
      selectPos = selectPos + 1
    else
      return 
    end
    setBtnStatus()
    if selectPos == 2 then
      clearShader(btnLeftraw, true)
      btnLeftraw:setEnabled(true)
    end
    if  vp_ids - 2 <= selectPos then
      setShader(btnRightraw, SHADER_GRAY, true)
      btnRightraw:setEnabled(false)
    end
    for i = 1,  vp_ids do
      sign[i]:runAction(CCMoveBy:create(0.1, CCPoint(-154, 0)))
      sell[i]:runAction(CCMoveBy:create(0.1, CCPoint(-154, 0)))
      bottom[i]:runAction(CCMoveBy:create(0.1, CCPoint(-154, 0)))
      heroBody[i]:runAction(CCMoveBy:create(0.1, CCPoint(-154, 0)))
    end
   end
  local moveRight = function()
    if selectPos > 1 then
      selectPos = selectPos - 1
    else
      return 
    end
    setBtnStatus()
    if selectPos ==  vp_ids - 3 then
      clearShader(btnRightraw, true)
      btnRightraw:setEnabled(true)
    end
    if selectPos <= 1 then
      setShader(btnLeftraw, SHADER_GRAY, true)
      btnLeftraw:setEnabled(false)
    end
    for i = 1,  vp_ids do
      sign[i]:runAction(CCMoveBy:create(0.1, CCPoint(154, 0)))
      sell[i]:runAction(CCMoveBy:create(0.1, CCPoint(154, 0)))
      bottom[i]:runAction(CCMoveBy:create(0.1, CCPoint(154, 0)))
      heroBody[i]:runAction(CCMoveBy:create(0.1, CCPoint(154, 0)))
    end
   end
  btnLeftraw:registerScriptTapHandler(function()
    audio.play(audio.button)
    moveRight()
   end)
  btnRightraw:registerScriptTapHandler(function()
    audio.play(audio.button)
    moveLeft()
   end)
  local touchbeginx, touchbeginy, isclick = nil, nil, nil
  local onTouchBegin = function(l_11_0, l_11_1)
    touchbeginx = l_11_0
    upvalue_512 = true
    return true
   end
  local onTouchMoved = function(l_12_0, l_12_1)
    local p0 = board:convertToNodeSpace(ccp(touchbeginx, l_12_1))
    local p1 = board:convertToNodeSpace(ccp(l_12_0, l_12_1))
    if isclick and math.abs(p1.x - p0.x) > 10 then
      upvalue_1024 = false
      if Scroll:boundingBox():containsPoint(p1) then
        if p1.x - p0.x >= 10 then
          moveRight()
        end
        if p0.x - p1.x >= 10 then
          moveLeft()
        end
      end
    end
   end
  local onTouchEnd = function(l_13_0, l_13_1)
   end
  local onTouch = function(l_14_0, l_14_1, l_14_2)
    if l_14_0 == "began" then
      return onTouchBegin(l_14_1, l_14_2)
    elseif l_14_0 == "moved" then
      return onTouchMoved(l_14_1, l_14_2)
    else
      return onTouchEnd(l_14_1, l_14_2)
    end
   end
  board:registerScriptTouchHandler(onTouch)
  board:setTouchSwallowEnabled(false)
  board:setTouchEnabled(true)
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  return layer
end

return ui

