-- Command line was: E:\github\dhgametool\scripts\ui\tips\getway.lua 

local tips = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local cfghero = require("config.hero")
local bagdata = require("data.bag")
local herosdata = require("data.heros")
local i18n = require("res.i18n")
local player = require("data.player")
local gdata = require("data.guild")
local TIPS_WIDTH = 360
local TIPS_MARGIN = 23
local MAX_WAY = 6
local SCROLL_HEIGHT = 420
local LABEL_WIDTH = TIPS_WIDTH - 2 * TIPS_MARGIN
local GoTypeEnum = {none = 0, arenaTickte = 1, blackmarket = 2, herotask = 3, casino = 4, arena = 5, hook = 6, summon = 7, summonspe = 8, heromarket = 9, trial = 10, casinoshop = 11, brave = 12, achieve = 13, task = 14, guild = 15, midas = 16, solo = 17, shopbuy = 18, airland = 19, smith = 20, devour = 21, guildshop = 22, commoncasino = 23, highcasino = 24, dare = 25, brave_shop = 27, pvp3 = 28, pvp3_shop = 29, casinoTickte = 30, hookmain = 31, seal_land = 32}
tips.checkUnlock = function(l_1_0)
  if l_1_0 == GoTypeEnum.hook then
    return 0
  else
    if l_1_0 == GoTypeEnum.hookmain then
      return 0
    else
      if l_1_0 == GoTypeEnum.arena and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_ARENA_LEVEL then
        return UNLOCK_ARENA_LEVEL
        do return end
        if l_1_0 == GoTypeEnum.guild and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_GUILD_LEVEL then
          return UNLOCK_GUILD_LEVEL
          do return end
          if l_1_0 == GoTypeEnum.friend then
            return 0
          else
            if l_1_0 == GoTypeEnum.achieve then
              return 0
            else
              if l_1_0 == GoTypeEnum.herotask and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_TAVERN_LEVEL then
                return UNLOCK_TAVERN_LEVEL
                do return end
                if l_1_0 == GoTypeEnum.task and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_TASK_LEVEL then
                  return 0
                  do return end
                  if l_1_0 == GoTypeEnum.midas then
                    return 0
                  else
                    if l_1_0 == GoTypeEnum.casino then
                      return 0
                    else
                      if l_1_0 == GoTypeEnum.arenaTickte then
                        return 0
                      else
                        if l_1_0 == GoTypeEnum.casinoTickte then
                          return 0
                        else
                          if l_1_0 == GoTypeEnum.trial and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_TRIAL_LEVEL then
                            return UNLOCK_TRIAL_LEVEL
                            do return end
                            if l_1_0 == GoTypeEnum.dare and BUILD_ENTRIES_ENABLE and player.lv() < 20 then
                              return 20
                              do return end
                              if l_1_0 == GoTypeEnum.commoncasino and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_CASINO_LEVEL then
                                return UNLOCK_CASINO_LEVEL
                                do return end
                                if l_1_0 == GoTypeEnum.highcasino and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_ADVANCED_CASINO_LEVEL and player.vipLv() < 3 then
                                  return UNLOCK_ADVANCED_CASINO_LEVEL
                                  do return end
                                  if l_1_0 == GoTypeEnum.airland and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_AIRISLAND_LEVEL then
                                    return UNLOCK_AIRISLAND_LEVEL
                                    do return end
                                    if l_1_0 == GoTypeEnum.solo and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_SOLO_LEVEL then
                                      return UNLOCK_SOLO_LEVEL
                                      do return end
                                      if l_1_0 == GoTypeEnum.summon then
                                        return 0
                                      else
                                        if l_1_0 == GoTypeEnum.brave and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_HERO_BRAVE then
                                          return UNLOCK_HERO_BRAVE
                                          do return end
                                          if l_1_0 == GoTypeEnum.blackmarket and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_BLACKMARKET_LEVEL then
                                            return UNLOCK_BLACKMARKET_LEVEL
                                            do return end
                                            if l_1_0 == GoTypeEnum.summonspe and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_GTREE_LEVEL then
                                              return UNLOCK_GTREE_LEVEL
                                              do return end
                                              if l_1_0 == GoTypeEnum.herolist then
                                                return 0
                                              else
                                                if l_1_0 == GoTypeEnum.heromarket then
                                                  return 0
                                                else
                                                  if l_1_0 == GoTypeEnum.smith then
                                                    return 0
                                                  else
                                                    if l_1_0 == GoTypeEnum.devour then
                                                      return 0
                                                    else
                                                      if l_1_0 == GoTypeEnum.heroforge then
                                                        return 0
                                                      else
                                                        if l_1_0 == GoTypeEnum.pvp3_shop then
                                                          return 0
                                                        else
                                                          if l_1_0 == GoTypeEnum.pvp3 and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_ARENA_LEVEL then
                                                            return UNLOCK_ARENA_LEVEL
                                                            do return end
                                                            if l_1_0 == GoTypeEnum.brave_shop and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_HERO_BRAVE then
                                                              return UNLOCK_HERO_BRAVE
                                                              do return end
                                                              if l_1_0 == GoTypeEnum.dare_2 and BUILD_ENTRIES_ENABLE and player.lv() < 25 then
                                                                return 25
                                                                do return end
                                                                if l_1_0 == GoTypeEnum.dare_3 and BUILD_ENTRIES_ENABLE and player.lv() < 30 then
                                                                  return 30
                                                                  do return end
                                                                  if l_1_0 == GoTypeEnum.seal_land and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_SEAL_LAND_LEVEL then
                                                                    return UNLOCK_SEAL_LAND_LEVEL
                                                                    do return end
                                                                    return 100
                                                                  end
                                                                end
                                                              end
                                                            end
                                                          end
                                                        end
                                                      end
                                                    end
                                                  end
                                                end
                                              end
                                            end
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  return 0
end

local searchHookDrop = function(l_2_0, l_2_1)
  local cfgpoker = require("config.poker")
  local hookdata = require("data.hook")
  local stage_id = hookdata.getPveStageId()
  if not stage_id then
    return 
  end
  for ii = stage_id, 1, -1 do
    local cfg = cfgpoker[ii]
    if not cfg then
      return 
    end
    for jj = 1,  cfg.yes do
      if l_2_0.id == cfg.yes[jj].id and l_2_1 == cfg.yes[jj].type then
        return ii
      end
    end
  end
  for ii = stage_id,  cfgpoker do
    local cfg = cfgpoker[ii]
    if not cfg then
      return 
    end
    for jj = 1,  cfg.yes do
      if l_2_0.id == cfg.yes[jj].id and l_2_1 == cfg.yes[jj].type then
        return ii
      end
    end
  end
  return 
end

tips.createLayer = function(l_3_0, l_3_1)
  local layer = (CCLayer:create())
  local cfg = nil
  if l_3_1 == 1 then
    cfg = cfgitem[l_3_0.id].getWays
  else
    cfg = cfgequip[l_3_0.id].getWays
  end
  local container = CCLayer:create()
  local currentY = 0
  local name = lbl.createMix({font = 1, size = 18, text = i18n.global.item_getway_tips.string, width = LABEL_WIDTH, align = kCCTextAlignmentLeft, color = ccc3(255, 246, 223)})
  name:setAnchorPoint(ccp(0, 1))
  name:setPosition(TIPS_MARGIN + 12, currentY - 18)
  container:addChild(name)
  currentY = name:boundingBox():getMinY()
  local btnBg = img.createUI9Sprite(img.ui.smith_drop_bg)
  btnBg:setPreferredSize(CCSize(314, op3( cfg <= MAX_WAY, 70 *  cfg + 25, SCROLL_HEIGHT)))
  btnBg:setAnchorPoint(ccp(0, 1))
  btnBg:setPosition(TIPS_MARGIN, currentY - 15)
  container:addChild(btnBg)
  local gotoLayer = function(l_1_0)
    local unlockLv = tips.checkUnlock(l_1_0)
    if unlockLv > 0 then
      if l_1_0 == GoTypeEnum.highcasino then
        showToast(string.format(i18n.global.func_need_lv.string, unlockLv) .. "\n" .. string.format(i18n.global.func_need_lv_vip.string, 3))
      else
        showToast(string.format(i18n.global.func_need_lv.string, unlockLv))
        return 
      end
      local hold = nil
      if l_1_0 == GoTypeEnum.hook then
        local t_stage = searchHookDrop(thing, ctype)
        do
          if not t_stage then
            showToast(string.format(i18n.global.hook_stage_unlock.string, ""))
            return 
          end
          local hookdata = require("data.hook")
          local stage_id = hookdata.getPveStageId()
          if stage_id < t_stage then
            local ff, ss = hookdata.getFortStageByStageId(t_stage)
            showToast(string.format(i18n.global.hook_stage_unlock.string, ff .. "-" .. ss))
            return 
          end
          replaceScene(require("ui.hook.main").create({pop_layer = "stage", stage_id = t_stage}))
        end
      else
        if l_1_0 == GoTypeEnum.arena then
          layer:addChild(require("ui.arena.entrance").create(), 1000)
        else
          if l_1_0 == GoTypeEnum.hookmain then
            replaceScene(require("ui.hook.main").create())
          else
            if l_1_0 == GoTypeEnum.guild then
              if player.gid and player.gid > 0 and not gdata.IsInit() then
                hold = true
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
              else
                if l_1_0 == GoTypeEnum.friend then
                  local friends = require("ui.friends.main")
                  layer:addChild(friends.create(), 200)
                else
                  if l_1_0 == GoTypeEnum.achieve then
                    layer:addChild(require("ui.achieve.main").create(), 1000)
                  else
                    if l_1_0 == GoTypeEnum.herotask then
                      replaceScene(require("ui.herotask.main").create())
                    else
                      if l_1_0 == GoTypeEnum.task then
                        layer:addChild(require("ui.task.main").create(true), 1000)
                      else
                        if l_1_0 == GoTypeEnum.midas then
                          layer:addChild(require("ui.midas.main").create(), 1000)
                        else
                          if l_1_0 == GoTypeEnum.casino then
                            layer:addChild(require("ui.casino.selectcasino").create(), 1000)
                          else
                            if l_1_0 == GoTypeEnum.arenaTickte then
                              layer:addChild(require("ui.arena.buy").create(), 1000)
                            else
                              if l_1_0 == GoTypeEnum.casinoTickte then
                                layer:addChild(require("ui.casino.chip").create(), 1000)
                              else
                                if l_1_0 == GoTypeEnum.trial then
                                  replaceScene(require("ui.trial.main").create())
                                else
                                  if l_1_0 == GoTypeEnum.dare or l_1_0 == GoTypeEnum.dare_2 or l_1_0 == GoTypeEnum.dare_3 then
                                    hold = true
                                    local daredata = require("data.dare")
                                    local nParams = {sid = player.sid}
                                    addWaitNet()
                                    netClient:dare_sync(nParams, function(l_2_0)
                                      delWaitNet()
                                      tbl2string(l_2_0)
                                      daredata.sync(l_2_0)
                                      layer:addChild(require("ui.dare.main").create(_params), 1000)
                                                      end)
                                  else
                                    if l_1_0 == GoTypeEnum.commoncasino then
                                      hold = true
                                      local params = {sid = player.sid, type = 1}
                                      addWaitNet()
                                      local casinodata = require("data.casino")
                                      casinodata.pull(params, function(l_3_0)
                                        delWaitNet()
                                        tbl2string(l_3_0)
                                        if l_3_0.status ~= 0 then
                                          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_3_0.status))
                                          return 
                                        end
                                        casinodata.init(l_3_0)
                                        replaceScene(require("ui.casino.main").create())
                                                         end)
                                    else
                                      if l_1_0 == GoTypeEnum.highcasino then
                                        hold = true
                                        local params = {sid = player.sid, type = 1, up = true}
                                        addWaitNet()
                                        local highcasinodata = require("data.highcasino")
                                        highcasinodata.pull(params, function(l_4_0)
                                          delWaitNet()
                                          tbl2string(l_4_0)
                                          if l_4_0.status ~= 0 then
                                            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_4_0.status))
                                            return 
                                          end
                                          highcasinodata.init(l_4_0)
                                          replaceScene(require("ui.highcasino.main").create())
                                                            end)
                                      else
                                        if l_1_0 == GoTypeEnum.airland then
                                          local params = {sid = player.sid}
                                          addWaitNet()
                                          netClient:island_sync(params, function(l_5_0)
                                            delWaitNet()
                                            tbl2string(l_5_0)
                                            local airData = require("data.airisland")
                                            airData.setData(l_5_0)
                                            replaceScene(require("ui.airisland.main1").create(l_5_0))
                                                               end)
                                        else
                                          if l_1_0 == GoTypeEnum.solo then
                                            addWaitNet()
                                            local params = {sid = player.sid}
                                            net:spk_sync(params, function(l_6_0)
                                              delWaitNet()
                                              print("\230\151\182\233\151\180\228\184\186" .. l_6_0.cd)
                                              print("\232\191\148\229\155\158\230\149\176\230\141\174")
                                              tablePrint(l_6_0)
                                              tbl2string(l_6_0)
                                              local soloData = require("data.solo")
                                              soloData.init()
                                              if l_6_0.status == 1 or l_6_0.status == 2 then
                                                if soloData.getStatus() == 0 then
                                                  soloData.setSelectOrder(nil)
                                                end
                                                soloData.setMainData(l_6_0)
                                                replaceScene(require("ui.solo.main").create())
                                              elseif l_6_0.status == 0 then
                                                soloData.setSelectOrder(nil)
                                                soloData.setMainData(l_6_0)
                                                replaceScene(require("ui.solo.noStartUI").create())
                                              end
                                                                  end)
                                          else
                                            if l_1_0 == GoTypeEnum.summon then
                                              replaceScene(require("ui.summon.main").create())
                                            else
                                              if l_1_0 == GoTypeEnum.brave then
                                                local databrave = require("data.brave")
                                                if not databrave.isPull or databrave.cd < os.time() then
                                                  hold = true
                                                  local params = {sid = player.sid}
                                                  addWaitNet()
                                                  netClient:sync_brave(params, function(l_7_0)
                                                    delWaitNet()
                                                    tbl2string(l_7_0)
                                                    databrave.init(l_7_0)
                                                    if layer and not tolua.isnull(layer) then
                                                      layer:addChild(require("ui.brave.main").create(), 1000)
                                                    end
                                                                           end)
                                                else
                                                  layer:addChild(require("ui.brave.main").create(), 1000)
                                                end
                                              else
                                                if l_1_0 == GoTypeEnum.blackmarket then
                                                  replaceScene(require("ui.blackmarket.main").create())
                                                else
                                                  if l_1_0 == GoTypeEnum.summonspe then
                                                    layer:addChild(require("ui.summonspe.main").create(), 1000)
                                                  else
                                                    if l_1_0 == GoTypeEnum.herolist then
                                                      replaceScene(require("ui.herolist.main").create())
                                                    else
                                                      if l_1_0 == GoTypeEnum.heromarket then
                                                        layer:addChild(require("ui.heromarket.main").create(), 1000)
                                                      else
                                                        if l_1_0 == GoTypeEnum.smith then
                                                          replaceScene(require("ui.smith.main").create())
                                                        else
                                                          if l_1_0 == GoTypeEnum.devour then
                                                            replaceScene(require("ui.devour.main").create())
                                                          else
                                                            if l_1_0 == GoTypeEnum.heroforge then
                                                              replaceScene(require("ui.heroforge.main").create())
                                                            else
                                                              if l_1_0 == GoTypeEnum.brave_shop then
                                                                local shop = require("ui.braveshop.main")
                                                                layer:addChild(shop.create(), 1000)
                                                              else
                                                                if l_1_0 == GoTypeEnum.pvp3_shop then
                                                                  local shop = require("ui.arena.shop")
                                                                  layer:addChild(shop.create(), 1000)
                                                                else
                                                                  if l_1_0 == GoTypeEnum.pvp3 then
                                                                    local pvp3layer = require("ui.arena.entrance").create(2)
                                                                    layer:addChild(pvp3layer, 1000)
                                                                  else
                                                                    if l_1_0 == GoTypeEnum.seal_land then
                                                                      local params = {sid = player.sid}
                                                                      addWaitNet()
                                                                      netClient:sealland_sync(params, function(l_8_0)
                                                                        delWaitNet()
                                                                        tbl2string(l_8_0)
                                                                        local sealLandData = require("data.sealland")
                                                                        sealLandData:init(l_8_0)
                                                                        replaceScene(require("ui.sealland.main").create())
                                                                                                         end)
                                                                    end
                                                                  end
                                                                end
                                                              end
                                                            end
                                                          end
                                                        end
                                                      end
                                                    end
                                                  end
                                                end
                                              end
                                            end
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local btnGetway = {}
  local createScrollLayer = function()
    local sccontainer = CCLayer:create()
    for i = 1,  cfg do
      do
        local btnGetwaysp = img.createLogin9Sprite(img.login.button_9_small_mwhite)
        btnGetwaysp:setPreferredSize(CCSize(290, 68))
        local labGetway = lbl.createFont1(20, i18n.itemgetways[cfg[i]].name, ccc3(118, 37, 5))
        labGetway:setPosition(btnGetwaysp:getContentSize().width / 2, btnGetwaysp:getContentSize().height / 2)
        btnGetwaysp:addChild(labGetway)
        btnGetway[i] = SpineMenuItem:create(json.ui.button, btnGetwaysp)
        btnGetway[i]:setPosition(TIPS_MARGIN + 157, not (i - 1) * 70 - 52)
        local menuGetway = CCMenu:createWithItem(btnGetway[i])
        menuGetway:setPosition(0, 0)
        sccontainer:addChild(menuGetway)
        btnGetway[i]:registerScriptTapHandler(function()
          audio.play(audio.button)
          gotoLayer(cfg[i])
            end)
      end
    end
    local ccurrentY =  cfg * 70 + 22
    local cHeight = ccurrentY
    local vHeight = op3( cfg <= MAX_WAY, cHeight, SCROLL_HEIGHT)
    local scroll = CCScrollView:create()
    scroll:setDirection(kCCScrollViewDirectionVertical)
    scroll:ignoreAnchorPointForPosition(false)
    scroll:setContentSize(CCSize(TIPS_WIDTH, cHeight))
    scroll:setViewSize(CCSize(TIPS_WIDTH, vHeight))
    scroll:setTouchEnabled(vHeight < cHeight)
    scroll:setContentOffset(ccp(0, vHeight - cHeight))
    sccontainer:setPosition(0, cHeight)
    scroll:getContainer():addChild(sccontainer)
    return scroll
   end
  local scrollLayer = createScrollLayer()
  scrollLayer:setAnchorPoint(ccp(0, 1))
  scrollLayer:setPosition(0, currentY - 13)
  container:addChild(scrollLayer)
  currentY = btnBg:boundingBox():getMinY()
  local height = 27 - currentY
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setPreferredSize(CCSize(TIPS_WIDTH, height))
  container:setPosition(0, height)
  bg:addChild(container)
  bg:setScale(view.minScale)
  bg:setPosition(view.physical.w / 2 + bg:getPreferredSize().width / 2 * view.minScale, view.physical.h / 2)
  layer:addChild(bg)
  bg:setScale(0.5 * view.minScale)
  bg:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  layer.bg = bg
  local clickBlankHandler = nil
  layer.setClickBlankHandler = function(l_3_0)
    clickBlankHandler = l_3_0
   end
  local onTouch = function(l_4_0, l_4_1, l_4_2)
    if l_4_0 == "began" then
      return true
    elseif l_4_0 == "moved" then
      return 
    else
       -- Warning: missing end command somewhere! Added here
    end
   end
  addBackEvent(layer)
  layer.onAndroidBack = function()
    if clickBlankHandler then
      clickBlankHandler()
    else
      layer:removeFromParent()
    end
   end
  layer:registerScriptHandler(function(l_6_0)
    if l_6_0 == "enter" then
      layer.notifyParentLock()
    elseif l_6_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return tips

