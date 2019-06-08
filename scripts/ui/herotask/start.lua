-- Command line was: E:\github\dhgametool\scripts\ui\herotask\start.lua 

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
local initHerolistData = function(l_1_0)
  if not l_1_0 then
    local params = {}
  end
  local tmpheros = clone(heros)
  local herolist = {}
  for i,v in ipairs(tmpheros) do
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if params.group and cfghero[v.id].group == params.group then
      herolist[ herolist + 1] = v
      for i,v in (for generator) do
        herolist[ herolist + 1] = v
      end
    end
    for i,v in ipairs(herolist) do
      v.isUsed = false
    end
    table.sort(herolist, compareHero)
    do
      local tlist = herolistless(herolist)
      return tlist
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.create = function(l_2_0)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  darkbg:setScale(2)
  layer:addChild(darkbg)
  local showReward = {}
  local showHero = {}
  local showPowerBg = CCSprite:create()
  showPowerBg:setContentSize(CCSize(960, 576))
  showPowerBg:setPosition(480, 288)
  layer:addChild(showPowerBg)
  showPowerBg:setScale(0.5)
  showPowerBg:runAction(CCScaleTo:create(0.15, 1, 1))
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
  board:setPreferredSize(CCSize(656, 268))
  board:setAnchorPoint(ccp(0, 0))
  board:setPosition(152, 228)
  showPowerBg:addChild(board)
  local powerBg = img.createUI9Sprite(img.ui.select_tab_tab_bg)
  powerBg:setPreferredSize(CCSize(646, 38))
  powerBg:setAnchorPoint(ccp(0, 0))
  powerBg:setPosition(158, 455)
  showPowerBg:addChild(powerBg)
  local showTime = lbl.createFont1(16, cfgtask[l_2_0.id].questTime / 60 .. " " .. i18n.global.herotask_info_hours.string, ccc3(226, 205, 172))
  showTime:setAnchorPoint(ccp(1, 0.5))
  showTime:setPosition(90, 19)
  powerBg:addChild(showTime)
  local timeIcon = img.createUISprite(img.ui.clock)
  timeIcon:setAnchorPoint(ccp(1, 0.5))
  timeIcon:setPosition(showTime:boundingBox():getMinX() - 5, 19)
  powerBg:addChild(timeIcon)
  local reward = conquset2items(l_2_0.reward)
  local offsetX = 480 - 46 *  reward + 9
  for i,v in ipairs(reward) do
    do
      local showRewardSprite = nil
      if v.type == 1 then
        showRewardSprite = img.createItem(v.id, v.num)
      else
        showRewardSprite = img.createEquip(v.id, v.num)
      end
      showReward[i] = CCMenuItemSprite:create(showRewardSprite, nil)
      local menuReward = CCMenu:createWithItem(showReward[i])
      menuReward:setPosition(0, 0)
      showPowerBg:addChild(menuReward)
      showReward[i]:setAnchorPoint(ccp(0, 0))
      showReward[i]:setScale(0.80434782608696)
      showReward[i]:setPosition(offsetX + (i - 1) * 92, 137)
      showReward[i]:registerScriptTapHandler(function()
        local superlayer = layer:getParent():getParent():getParent()
        if v.type == 1 then
          local tips = require("ui.tips.item").createForShow(v)
          superlayer:addChild(tips, 10000)
        else
          local tips = require("ui.tips.equip").createById(v.id)
          superlayer:addChild(tips, 10000)
        end
         end)
    end
  end
  local hids = {}
  local baseHeroBg = {}
  local showHeros = {}
  local heroNum = cfgtask[l_2_0.id].heroNum
  local offsetX = 480 - 26 *  l_2_0.conds + 5
  local condition = {}
  for i,v in ipairs(l_2_0.conds) do
    do
      condition[i] = img.createUISprite(img.ui.hook_rate_bg)
      condition[i]:setScale(0.8)
      condition[i]:setAnchorPoint(ccp(0, 0))
      condition[i]:setPosition(offsetX + 52 * (i - 1), 248)
      showPowerBg:addChild(condition[i])
      local ctip = nil
      if v.type == 1 then
        ctip = string.gsub(i18n.global.toast_herotask_job.string, "##", i18n.global.job_" .. v.factio.string)
      elseif v.type == 2 then
        ctip = string.format(i18n.global.toast_herotask_star.string, v.faction)
      elseif v.type == 3 then
        ctip = string.gsub(i18n.global.toast_herotask_group.string, "##", i18n.global.hero_group_" .. v.factio.string)
      elseif v.type == 4 then
        ctip = string.format(i18n.global.toast_herotask_qualtiy.string, v.faction)
      end
      local showTipBg = img.createUI9Sprite(img.ui.tips_bg)
      showTipBg:setPreferredSize(CCSize(300, 100))
      showTipBg:setAnchorPoint(ccp(1, 0))
      showTipBg:setPosition(condition[i]:boundingBox():getMaxX(), condition[i]:boundingBox():getMaxY())
      showPowerBg:addChild(showTipBg, 10000)
      local showText = lbl.createMixFont1(16, ctip, ccc3(255, 246, 223))
      showTipBg:setPreferredSize(CCSize(showText:boundingBox().size.width + 50, 60))
      showText:setPosition(showTipBg:getContentSize().width / 2, 30)
      showTipBg:addChild(showText)
      condition[i].showTipBg = showTipBg
      showTipBg:setVisible(false)
      do
        if v.type == 1 then
          local showJob = img.createUISprite(img.ui.herotask_job_" .. v.factio)
          showJob:setPosition(condition[i]:getContentSize().width / 2, condition[i]:getContentSize().height / 2)
          condition[i]:addChild(showJob)
        end
        for i,v in (for generator) do
        end
        if v.type == 2 then
          local showStar = img.createUISprite(img.ui.star)
          showStar:setScale(0.95)
          showStar:setPosition(condition[i]:getContentSize().width / 2, condition[i]:getContentSize().height / 2)
          condition[i]:addChild(showStar)
          do
            local showNum = lbl.createFont2(18, v.faction)
            showNum:setPosition(condition[i]:getContentSize().width / 2, condition[i]:getContentSize().height / 2)
            condition[i]:addChild(showNum)
          end
          for i,v in (for generator) do
          end
          do
            if v.type == 3 then
              local showGroup = img.createUISprite(img.ui.herolist_group_" .. v.factio)
              showGroup:setPosition(condition[i]:getContentSize().width / 2, condition[i]:getContentSize().height / 2)
              condition[i]:addChild(showGroup)
            end
            for i,v in (for generator) do
            end
            if v.type == 4 then
              local showQlt = img.createUISprite(img.ui.evolve)
              showQlt:setScale(0.7)
              showQlt:setPosition(condition[i]:getContentSize().width / 2, condition[i]:getContentSize().height / 2)
              condition[i]:addChild(showQlt)
              local showNum = lbl.createFont2(18, v.faction)
              showNum:setPosition(condition[i]:getContentSize().width / 2, condition[i]:getContentSize().height / 2)
              condition[i]:addChild(showNum)
            end
          end
        end
        local titleCondition = lbl.createFont1(18, i18n.global.herotask_title_condition.string, ccc3(91, 39, 6))
        titleCondition:setPosition(480, 308)
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
        local btnStart = nil
        local checkConfirm = false
        local tip = nil
        local checkCondition = function()
          checkConfirm = true
          upvalue_512 = i18n.global.herotask_start_info.string
          local res = {}
          for i,v in ipairs(info.conds) do
            res[i] = false
          end
          for i = 1, cfgtask[info.id].heroNum do
            local v = hids[i] or 0
            if v > 0 then
              local heroInfo = heros.find(v)
              for j,k in ipairs(info.conds) do
                 -- DECOMPILER ERROR: unhandled construct in 'if'

                if k.type == 1 and cfghero[heroInfo.id].job == k.faction then
                  res[j] = true
                  for j,k in (for generator) do
                     -- DECOMPILER ERROR: unhandled construct in 'if'

                    if k.type == 2 and k.faction <= cfghero[heroInfo.id].qlt then
                      res[j] = true
                      for j,k in (for generator) do
                         -- DECOMPILER ERROR: unhandled construct in 'if'

                        if k.type == 3 and cfghero[heroInfo.id].group == k.faction then
                          res[j] = true
                          for j,k in (for generator) do
                            if k.type == 4 and k.faction <= heroInfo.star then
                              res[j] = true
                            end
                          end
                        end
                      end
                    end
                  end
                end
                for i,v in ipairs(info.conds) do
                  if not res[i] then
                    if v.type == 1 then
                      upvalue_512 = string.gsub(i18n.global.toast_herotask_job.string, "##", i18n.global.job_" .. v.factio.string)
                      for i,v in (for generator) do
                      end
                      if v.type == 2 then
                        upvalue_512 = string.format(i18n.global.toast_herotask_star.string, v.faction)
                        for i,v in (for generator) do
                        end
                        if v.type == 3 then
                          upvalue_512 = string.gsub(i18n.global.toast_herotask_group.string, "##", i18n.global.hero_group_" .. v.factio.string)
                          for i,v in (for generator) do
                          end
                          if v.type == 4 and not res[i] then
                            upvalue_512 = string.format(i18n.global.toast_herotask_qualtiy.string, v.faction)
                          end
                        end
                      end
                      for i,v in ipairs(condition) do
                        if v:getChildByTag(1) then
                          v:removeChildByTag(1)
                        end
                        do
                          if res[i] then
                            local dg = img.createUISprite(img.ui.hook_btn_sel)
                            dg:setAnchorPoint(ccp(1, 0))
                            dg:setScale(0.6)
                            dg:setPosition(condition[i]:getContentSize().width + 2, -2)
                            v:addChild(dg, 1, 1)
                          end
                          for i,v in (for generator) do
                          end
                          checkConfirm = false
                        end
                        if not checkConfirm then
                          setShader(btnStart, SHADER_GRAY, true)
                        else
                          clearShader(btnStart, true)
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
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
            end
        local createHeroList = function()
          local showHeroLayer = CCLayer:create()
          layer:addChild(showHeroLayer, 100)
          local herolistBg = img.createUI9Sprite(img.ui.tips_bg)
          herolistBg:setPreferredSize(CCSize(960, 112))
          herolistBg:setPosition(480, -64)
          showHeroLayer:addChild(herolistBg, 100)
          herolistBg:runAction(CCEaseBackOut:create(CCMoveTo:create(0.5, ccp(480, 56))))
          local herolist = clone(heros)
          table.sort(herolist, compareHero)
          herolist = herolistless(herolist)
          local headIcons = {}
          SCROLLVIEW_WIDTH = 793
          SCROLLVIEW_HEIGHT = 112
          SCROLLCONTENT_WIDTH =  herolist * 90 + 8
          kscroll = CCScrollView:create()
          kscroll:setDirection(kCCScrollViewDirectionHorizontal)
          kscroll:setAnchorPoint(ccp(0, 0))
          kscroll:setPosition(7, 0)
          kscroll:setViewSize(CCSize(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT))
          kscroll:setContentSize(CCSizeMake(SCROLLCONTENT_WIDTH, SCROLLVIEW_HEIGHT))
          kscroll:setContentOffset(CCPoint(0, 0))
          herolistBg:addChild(kscroll)
          local btnFilterSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
          btnFilterSprite:setPreferredSize(CCSize(130, 70))
          local btnFilterIcon = lbl.createFont1(20, i18n.global.selecthero_btn_hero.string, ccc3(115, 59, 5))
          btnFilterIcon:setPosition(btnFilterSprite:getContentSize().width / 2, btnFilterSprite:getContentSize().height / 2)
          btnFilterSprite:addChild(btnFilterIcon)
          local btnFilter = SpineMenuItem:create(json.ui.button, btnFilterSprite)
          btnFilter:setPosition(873, 56)
          local menuFilter = CCMenu:createWithItem(btnFilter)
          menuFilter:setPosition(0, 0)
          herolistBg:addChild(menuFilter, 1)
          local filterBg = img.createUI9Sprite(img.ui.tips_bg)
          filterBg:setPreferredSize(CCSize(122, 458))
          filterBg:setAnchorPoint(ccp(1, 0))
          filterBg:setPosition(938, 110)
          showHeroLayer:addChild(filterBg)
          local showHeroLayer2 = CCLayer:create()
          kscroll:getContainer():addChild(showHeroLayer2)
          local selectBatch, blackBatch = nil, nil
          local onMoveUp = function(l_1_0, l_1_1, l_1_2)
            if not l_1_2 then
              local heroInfo = heros.find(hids[l_1_1])
              local param = {id = heroInfo.id, lv = heroInfo.lv, showGroup = true, showStar = 3, wake = heroInfo.wake, orangeFx = nil, petID = nil, hid = heroInfo.hid}
              showHeros[l_1_1] = img.createHeroHeadByParam(param)
              showHeros[l_1_1]:setScale(0.8936170212766)
              showHeros[l_1_1]:setPosition(baseHeroBg[l_1_1]:boundingBox():getMidX(), baseHeroBg[l_1_1]:boundingBox():getMidY())
              layer:addChild(showHeros[l_1_1])
            end
            local blackBoard = img.createUISprite(img.ui.hero_head_shade)
            blackBoard:setScale(0.85106382978723)
            blackBoard:setOpacity(120)
            blackBoard:setPosition(headIcons[l_1_0]:getPositionX(), headIcons[l_1_0]:getPositionY())
            blackBatch:addChild(blackBoard, 0, l_1_0)
            local selectIcon = img.createUISprite(img.ui.hook_btn_sel)
            selectIcon:setPosition(headIcons[l_1_0]:getPositionX(), headIcons[l_1_0]:getPositionY())
            selectBatch:addChild(selectIcon, 0, l_1_0)
               end
          local moveUp = function(l_2_0)
            local tpos = nil
            do
              for i = 1, heroNum do
                if not hids[i] or hids[i] == 0 then
                  tpos = i
              else
                end
              end
            end
            if tpos and not herolist[l_2_0].isUsed then
              herolist[l_2_0].isUsed = true
              hids[tpos] = herolist[l_2_0].hid
              local worldbpos = kscroll:getContainer():convertToWorldSpace(ccp(headIcons[l_2_0]:getPositionX(), headIcons[l_2_0]:getPositionY()))
              local realbpos = showHeroLayer:convertToNodeSpace(worldbpos)
              local worldepos = layer:convertToWorldSpace(ccp(baseHeroBg[tpos]:boundingBox():getMidX(), baseHeroBg[tpos]:boundingBox():getMidY()))
              local realepos = showHeroLayer:convertToNodeSpace(worldepos)
              local param = {id = herolist[l_2_0].id, lv = herolist[l_2_0].lv, showGroup = true, showStar = nil, wake = nil, orangeFx = nil, petID = nil, hid = herolist[l_2_0].hid}
              local tempHero = img.createHeroHeadByParam(param)
              tempHero:setPosition(realbpos)
              showHeroLayer:addChild(tempHero, 100)
              local arr = CCArray:create()
              arr:addObject(CCMoveTo:create(0.2, realepos))
              arr:addObject(CCScaleTo:create(0.2, 0.91304347826087))
              local act1 = CCSpawn:create(arr)
              tempHero:runAction(CCSequence:createWithTwoActions(act1, CCCallFunc:create(function()
                tempHero:removeFromParentAndCleanup(true)
                onMoveUp(pos, tpos)
                     end)))
            elseif tpos then
              showToast(i18n.global.toast_selhero_selected.string)
            else
              showToast(i18n.global.toast_selhero_already.string)
            end
               end
          local onMoveDown = function(l_3_0, l_3_1)
            blackBatch:removeChildByTag(l_3_1)
            selectBatch:removeChildByTag(l_3_1)
               end
          local moveDown = function(l_4_0)
            local tpos = nil
            do
              for i,v in ipairs(herolist) do
                if hids[l_4_0] == v.hid then
                  tpos = i
              else
                end
              end
            end
            if tpos then
              showHeros[l_4_0]:removeFromParentAndCleanup(true)
              showHeros[l_4_0] = nil
              herolist[tpos].isUsed = false
              hids[l_4_0] = nil
              local worldbpos = layer:convertToWorldSpace(ccp(baseHeroBg[l_4_0]:boundingBox():getMidX(), baseHeroBg[l_4_0]:boundingBox():getMidY()))
              local realbpos = showHeroLayer:convertToNodeSpace(worldbpos)
              local worldepos = kscroll:getContainer():convertToWorldSpace(ccp(headIcons[tpos]:getPositionX(), headIcons[tpos]:getPositionY()))
              local realepos = showHeroLayer:convertToNodeSpace(worldepos)
              local tempHero = img.createHeroHead(herolist[tpos].id, herolist[tpos].lv, true)
              tempHero:setPosition(realbpos)
              tempHero:setScale(0.91304347826087)
              showHeroLayer:addChild(tempHero, 100)
              local arr = CCArray:create()
              arr:addObject(CCMoveTo:create(0.2, realepos))
              arr:addObject(CCScaleTo:create(0.2, 1))
              local act1 = CCSpawn:create(arr)
              tempHero:runAction(CCSequence:createWithTwoActions(act1, CCCallFunc:create(function()
                tempHero:removeFromParentAndCleanup(true)
                onMoveDown(pos, tpos)
                     end)))
            end
               end
          local createHerolist = function()
            showHeroLayer2:removeAllChildrenWithCleanup(true)
            arrayclear(headIcons)
            local iconBgBatch = img.createBatchNodeForUI(img.ui.herolist_head_bg)
            showHeroLayer2:addChild(iconBgBatch, 1)
            local iconBgBatch1 = img.createBatchNodeForUI(img.ui.hero_star_ten_bg)
            showHeroLayer2:addChild(iconBgBatch1, 1)
            local groupBgBatch = img.createBatchNodeForUI(img.ui.herolist_group_bg)
            showHeroLayer2:addChild(groupBgBatch, 3)
            local starBatch = img.createBatchNodeForUI(img.ui.star_s)
            showHeroLayer2:addChild(starBatch, 3)
            local star10Batch = img.createBatchNodeForUI(img.ui.hero_star_ten)
            showHeroLayer2:addChild(star10Batch, 3)
            local star1Batch = img.createBatchNodeForUI(img.ui.hero_star_orange)
            showHeroLayer2:addChild(star1Batch, 3)
            upvalue_1536 = img.createBatchNodeForUI(img.ui.hero_head_shade)
            showHeroLayer2:addChild(blackBatch, 4)
            upvalue_2048 = img.createBatchNodeForUI(img.ui.hook_btn_sel)
            showHeroLayer2:addChild(selectBatch, 5)
            for i = 1,  herolist do
              local x, y = 45 + (i - 1) * 90 + 8, 56
              local qlt = cfghero[herolist[i].id].maxStar
              local heroBg = nil
              if qlt == 10 then
                heroBg = img.createUISprite(img.ui.hero_star_ten_bg)
                heroBg:setPosition(x, y)
                heroBg:setScale(0.92)
                iconBgBatch1:addChild(heroBg)
                json.load(json.ui.lv10_framefx)
                local aniten = DHSkeletonAnimation:createWithKey(json.ui.lv10_framefx)
                aniten:playAnimation("animation", -1)
                aniten:scheduleUpdateLua()
                aniten:setScale(0.92)
                aniten:setPosition(x, y)
                showHeroLayer2:addChild(aniten, 4)
              else
                heroBg = img.createUISprite(img.ui.herolist_head_bg)
                heroBg:setScale(0.92)
                heroBg:setPosition(x, y)
                iconBgBatch:addChild(heroBg)
              end
              headIcons[i] = img.createHeroHeadByHid(herolist[i].hid)
              headIcons[i]:setScale(0.92)
              headIcons[i]:setPosition(x, y)
              showHeroLayer2:addChild(headIcons[i], 2)
              local showJob = img.createUISprite(img.ui.job_" .. cfghero[herolist[i].id].jo)
              showJob:setPosition(x - 26, y + 6)
              showHeroLayer2:addChild(showJob, 3)
            end
            for i,v in ipairs(herolist) do
              for j = 1, heroNum do
                if v.hid == hids[j] then
                  onMoveUp(i, j, true)
                  herolist[i].isUsed = true
                end
              end
            end
            for i,v in ipairs(herolist) do
              for _,taskInfo in ipairs(htaskData.tasks) do
                if info.tid ~= taskInfo.tid and taskInfo.heroes then
                  for j,k in ipairs(taskInfo.heroes) do
                    if v.hid == k.hid then
                      onMoveUp(i, 0, true)
                      herolist[i].isUsed = true
                    end
                  end
                end
              end
            end
               end
          createHerolist()
          local lastx = nil
          local onTouchExtraBegin = function(l_6_0, l_6_1)
            lastx = l_6_0
            return true
               end
          local onTouchExtraMoved = function(l_7_0, l_7_1)
            return true
               end
          local onTouchExtraEnd = function(l_8_0, l_8_1)
            local point = (layer:convertToNodeSpace(ccp(l_8_0, l_8_1)))
            local pointOnScroll = nil
            if kscroll and not tolua.isnull(kscroll) and kscroll:getContainer() then
              pointOnScroll = kscroll:getContainer():convertToNodeSpace(ccp(l_8_0, l_8_1))
            else
              return true
            end
            local flag = false
            if math.abs(l_8_0 - lastx) < 10 then
              for i,v in ipairs(headIcons) do
                if v:boundingBox():containsPoint(pointOnScroll) then
                  audio.play(audio.button)
                  local ban = CCLayer:create()
                  do
                    ban:setTouchEnabled(true)
                    ban:setTouchSwallowEnabled(true)
                    layer:addChild(ban, 1000)
                    layer:runAction(createSequence({}))
                    moveUp(i)
                  end
                end
              end
              for i = 1, heroNum do
                if hids[i] and showHeros[i] and showHeros[i]:boundingBox():containsPoint(point) then
                  audio.play(audio.button)
                  moveDown(i)
                   -- DECOMPILER ERROR: Overwrote pending register.

                end
              end
            end
            checkCondition()
            do
              local pointOnLayer = showHeroLayer:convertToNodeSpace(ccp(l_8_0, l_8_1))
              if not kscroll:getContainer():boundingBox():containsPoint(pointOnLayer) and not flag then
                showHeroLayer:removeFromParentAndCleanup(true)
              end
              return true
            end
             -- Warning: undefined locals caused missing assignments!
               end
          local onExtraTouch = function(l_9_0, l_9_1, l_9_2)
            if l_9_0 == "began" then
              return onTouchExtraBegin(l_9_1, l_9_2)
            elseif l_9_0 == "moved" then
              return onTouchExtraMoved(l_9_1, l_9_2)
            else
              return onTouchExtraEnd(l_9_1, l_9_2)
            end
               end
          showHeroLayer:registerScriptTouchHandler(onExtraTouch)
          showHeroLayer:setTouchEnabled(true)
          local group = nil
          local btnGroupList = {}
          for i = 1, 6 do
            do
              local btnGroupSpriteFg = img.createUISprite(img.ui.herolist_group_" .. )
              local btnGroupSpriteBg = img.createUISprite(img.ui.herolist_group_bg)
              btnGroupSpriteFg:setPosition(btnGroupSpriteBg:getContentSize().width / 2, btnGroupSpriteBg:getContentSize().height / 2 + 2)
              btnGroupSpriteBg:addChild(btnGroupSpriteFg)
              btnGroupList[i] = HHMenuItem:createWithScale(btnGroupSpriteBg, 1)
              local btnGroupMenu = CCMenu:createWithItem(btnGroupList[i])
              btnGroupMenu:setPosition(0, 0)
              filterBg:addChild(btnGroupMenu, 10)
              btnGroupList[i]:setPosition(61, 52 + 70 * (i - 1))
              local showSelect = img.createUISprite(img.ui.herolist_select_icon)
              showSelect:setPosition(btnGroupList[i]:getContentSize().width / 2, btnGroupList[i]:getContentSize().height / 2 + 2)
              btnGroupList[i]:addChild(showSelect)
              btnGroupList[i].showSelect = showSelect
              showSelect:setVisible(false)
              btnGroupList[i]:registerScriptTapHandler(function()
                audio.play(audio.button)
                for j = 1, 6 do
                  btnGroupList[j]:unselected()
                  btnGroupList[j].showSelect:setVisible(false)
                end
                if not group or i ~= group then
                  upvalue_1024 = i
                  btnGroupList[i]:selected()
                  btnGroupList[i].showSelect:setVisible(true)
                else
                  upvalue_1024 = nil
                end
                upvalue_2048 = initHerolistData({group = group, hids = hids})
                createHerolist()
                kscroll:setContentOffset(CCPoint(0, 0))
                for i,v in ipairs(herolist) do
                  for j = 1, 6 do
                    if v.hid == hids[j] then
                      onMoveUp(i, j, true)
                      herolist[i].isUsed = true
                    end
                  end
                end
                     end)
            end
          end
          filterBg:setVisible(false)
          btnFilter:registerScriptTapHandler(function()
            if filterBg:isVisible() == true then
              filterBg:setVisible(false)
            else
              filterBg:setVisible(true)
            end
               end)
            end
        offsetX = 480 - 50 * cfgtask[l_2_0.id].heroNum + 9
        for i = 1, cfgtask[l_2_0.id].heroNum do
          local baseHeroBgSp = img.createUISprite(img.ui.herolist_head_bg)
          baseHeroBg[i] = HHMenuItem:createWithScale(baseHeroBgSp, 1)
          local menuHero = CCMenu:createWithItem(baseHeroBg[i])
          menuHero:setPosition(0, 0)
          showPowerBg:addChild(menuHero)
          baseHeroBg[i]:setAnchorPoint(ccp(0, 0))
          baseHeroBg[i]:setScale(0.8936170212766)
          baseHeroBg[i]:setPosition(offsetX + (i - 1) * 100, 333)
          baseHeroBg[i]:registerScriptTapHandler(function()
            delayBtnEnable(baseHeroBg[i])
            audio.play(audio.button)
            createHeroList()
               end)
          local icon = img.createUISprite(img.ui.herotask_add_icon)
          icon:setPosition(baseHeroBg[i]:getContentSize().width / 2, baseHeroBg[i]:getContentSize().height / 2)
          baseHeroBg[i]:addChild(icon)
          icon:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeIn:create(2), CCFadeOut:create(2))))
        end
        local btnBatchSprite = img.createLogin9Sprite(img.login.button_9_small_green)
        btnBatchSprite:setPreferredSize(CCSize(165, 50))
        local labBatch = lbl.createFont1(20, i18n.global.herotask_btn_batch.string, ccc3(30, 99, 5))
        labBatch:setPosition(btnBatchSprite:getContentSize().width / 2, btnBatchSprite:getContentSize().height / 2)
        btnBatchSprite:addChild(labBatch)
        local btnBatch = SpineMenuItem:create(json.ui.button, btnBatchSprite)
        local menuBatch = CCMenu:createWithItem(btnBatch)
        menuBatch:setPosition(0, 0)
        showPowerBg:addChild(menuBatch)
        btnBatch:setPosition(388, 90)
        local btnStartSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
        btnStartSprite:setPreferredSize(CCSize(165, 50))
        local labStart = lbl.createFont1(20, i18n.global.herotask_start_btn.string, ccc3(115, 59, 5))
        labStart:setPosition(btnStartSprite:getContentSize().width / 2, btnStartSprite:getContentSize().height / 2)
        btnStartSprite:addChild(labStart)
        btnStart = SpineMenuItem:create(json.ui.button, btnStartSprite)
        local menuStart = CCMenu:createWithItem(btnStart)
        menuStart:setPosition(0, 0)
        showPowerBg:addChild(menuStart)
        btnStart:setPosition(572, 90)
        setShader(btnStart, SHADER_GRAY, true)
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
        layer:registerScriptHandler(function(l_10_0)
          if l_10_0 == "enter" then
            onEnter()
          elseif l_10_0 == "exit" then
            onExit()
          end
            end)
        local batchSet = function()
          local batchflag = true
          local herolist = clone(heros)
          table.sort(herolist, compareHero)
          for i,v in ipairs(herolist) do
            for _,taskInfo in ipairs(htaskData.tasks) do
              if info.tid ~= taskInfo.tid and taskInfo.heroes then
                for j,k in ipairs(taskInfo.heroes) do
                  if v.hid == k.hid then
                    herolist[i].isUsed = true
                  end
                end
              end
            end
          end
          for i = 1, heroNum do
            if hids[i] and showHeros[i] then
              showHeros[i]:removeFromParentAndCleanup(true)
              showHeros[i] = nil
              local tpos = nil
              for t,v in ipairs(herolist) do
                if hids[i] == v.hid then
                  tpos = t
              else
                end
              end
              herolist[tpos].isUsed = false
              hids[i] = nil
            end
          end
          local res = {}
          for i,k in ipairs(info.conds) do
            res[i] = false
          end
          for i,k in ipairs(info.conds) do
            if not res[i] then
              for j =  herolist, 1, -1 do
                 -- DECOMPILER ERROR: unhandled construct in 'if'

                 -- DECOMPILER ERROR: unhandled construct in 'if'

                if not herolist[j].isUsed and k.type == 1 and cfghero[herolist[j].id].job == k.faction then
                  res[i] = true
                  hids[ hids + 1] = herolist[j].hid
                  herolist[j].isUsed = true
                  for ii = i + 1,  info.conds do
                    if info.conds[ii].type == 2 and info.conds[ii].faction <= cfghero[herolist[j].id].qlt then
                      res[ii] = true
                    end
                    if info.conds[ii].type == 3 and cfghero[herolist[j].id].group == info.conds[ii].faction then
                      res[ii] = true
                    end
                  end
                  for i,k in (for generator) do
                    do return end
                     -- DECOMPILER ERROR: unhandled construct in 'if'

                    if k.type == 2 and k.faction <= cfghero[herolist[j].id].qlt then
                      res[i] = true
                      hids[ hids + 1] = herolist[j].hid
                      herolist[j].isUsed = true
                      for ii = i + 1,  info.conds do
                        if info.conds[ii].type == 1 and cfghero[herolist[j].id].job == info.conds[ii].faction then
                          res[ii] = true
                        end
                        if info.conds[ii].type == 3 and cfghero[herolist[j].id].group == info.conds[ii].faction then
                          res[ii] = true
                        end
                      end
                      for i,k in (for generator) do
                        do return end
                        if k.type == 3 and cfghero[herolist[j].id].group == k.faction then
                          res[i] = true
                          hids[ hids + 1] = herolist[j].hid
                          herolist[j].isUsed = true
                          for ii = i + 1,  info.conds do
                            if info.conds[ii].type == 2 and info.conds[ii].faction <= cfghero[herolist[j].id].qlt then
                              res[ii] = true
                            end
                            if info.conds[ii].type == 1 and cfghero[herolist[j].id].job == info.conds[ii].faction then
                              res[ii] = true
                            end
                          end
                          for i,k in (for generator) do
                          end
                        end
                      end
                    end
                     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

                  end
                end
                for i,k in ipairs(info.conds) do
                   -- DECOMPILER ERROR: Confused at declaration of local variable

                   -- DECOMPILER ERROR: Confused about usage of registers!

                  if res[i] == false then
                    batchflag = false
                   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

                else
                  end
                end
                if batchflag and  hids < heroNum then
                  for i =  hids + 1, heroNum do
                     -- DECOMPILER ERROR: Confused at declaration of local variable

                    for j =  herolist, 1, -1 do
                       -- DECOMPILER ERROR: Confused at declaration of local variable

                       -- DECOMPILER ERROR: Confused about usage of registers!

                       -- DECOMPILER ERROR: Confused about usage of registers!

                      if not herolist[(for step)].isUsed then
                        hids[i] = herolist[(for step)].hid
                         -- DECOMPILER ERROR: Confused about usage of registers!

                        herolist[(for step)].isUsed = true
                       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

                    else
                      end
                       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

                    end
                  end
                  checkCondition()
                  if checkConfirm == false then
                    showToast(i18n.global.herotask_lack_mat.string)
                  end
                  if  hids <= heroNum then
                    for i = 1,  hids do
                       -- DECOMPILER ERROR: Confused at declaration of local variable

                      tpos = i
                       -- DECOMPILER ERROR: Confused at declaration of local variable

                       -- DECOMPILER ERROR: Confused at declaration of local variable

                      showHeros[tpos] = img.createHeroHeadByParam({id = heros.find(hids[tpos]).id, lv = heros.find(hids[tpos]).lv, showGroup = true, showStar = 3, wake = heros.find(hids[tpos]).wake, orangeFx = nil, petID = nil, hid = heros.find(hids[tpos]).hid})
                      showHeros[tpos]:setScale(0.8936170212766)
                      showHeros[tpos]:setPosition(baseHeroBg[tpos]:boundingBox():getMidX(), baseHeroBg[tpos]:boundingBox():getMidY())
                      layer:addChild(showHeros[tpos])
                       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

                    end
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
        btnBatch:registerScriptTapHandler(function()
          delayBtnEnable(btnBatch)
          audio.play(audio.button)
          batchSet()
            end)
        btnStart:registerScriptTapHandler(function()
          delayBtnEnable(btnStart)
          audio.play(audio.button)
          if not checkConfirm then
            print(tip)
            if not tip or tip == "" then
              upvalue_1536 = i18n.global.herotask_start_info.string
            end
            showToast(tip)
            return 
          end
          local heroNum = 0
          for i = 1,  hids do
            if hids[i] then
              heroNum = heroNum + 1
            end
          end
          if not checkConfirm or heroNum < cfgtask[info.id].heroNum then
            showToast(i18n.global.herotask_start_info.string)
            return 
          end
          local params = {sid = player.sid, hids = hids, tid = info.tid}
          tbl2string(params)
          addWaitNet()
          net:htask_start(params, function(l_1_0)
            delWaitNet()
            tbl2string(l_1_0)
            if l_1_0.status ~= 0 then
              showToast("server status:" .. l_1_0.status)
              return 
            end
            info.subrefgem()
            info.cd = os.time() + cfgtask[info.id].questTime * 60
            local heroes = {}
            for i,v in ipairs(params.hids) do
              local hero = heros.find(v)
              local h = {hid = hero.hid, id = hero.id, lv = hero.lv, star = hero.star}
              heroes[ heroes + 1] = h
            end
            info.heroes = heroes
            for i,v in ipairs(htaskData.tasks) do
              if v.tid == info.tid then
                layer:getParent().addAni(i)
                layer:removeFromParentAndCleanup(true)
                return 
              end
            end
               end)
            end)
        local lastx = nil
        local onTouchBegin = function(l_14_0, l_14_1)
          for i,v in ipairs(condition) do
            if v:boundingBox():containsPoint(layer:convertToNodeSpace(ccp(l_14_0, l_14_1))) then
              v.showTipBg:setVisible(true)
              for i,v in (for generator) do
              end
              v.showTipBg:setVisible(false)
            end
            return true
             -- Warning: missing end command somewhere! Added here
          end
            end
        local onTouchMoved = function(l_15_0, l_15_1)
          for i,v in ipairs(condition) do
            if v:boundingBox():containsPoint(layer:convertToNodeSpace(ccp(l_15_0, l_15_1))) then
              v.showTipBg:setVisible(true)
              for i,v in (for generator) do
              end
              v.showTipBg:setVisible(false)
            end
            return true
             -- Warning: missing end command somewhere! Added here
          end
            end
        local onTouchEnd = function(l_16_0, l_16_1)
          for i,v in ipairs(condition) do
            v.showTipBg:setVisible(false)
          end
          return true
            end
        do
          local onTouch = function(l_17_0, l_17_1, l_17_2)
          if l_17_0 == "began" then
            return onTouchBegin(l_17_1, l_17_2)
          elseif l_17_0 == "moved" then
            return onTouchMoved(l_17_1, l_17_2)
          else
            return onTouchEnd(l_17_1, l_17_2)
          end
            end
          layer:registerScriptTouchHandler(onTouch)
          layer:setTouchEnabled(true)
          return layer
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return ui

