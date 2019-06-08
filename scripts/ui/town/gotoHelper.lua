-- Command line was: E:\github\dhgametool\scripts\ui\town\gotoHelper.lua 

local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local i18n = require("res.i18n")
local json = require("res.json")
local audio = require("res.audio")
local dataGuild = require("data.guild")
local dataPlayer = require("data.player")
local dataHeros = require("data.heros")
local net = require("net.netClient")
local player = require("data.player")
local gdata = require("data.guild")
local droidhangComponents = require("dhcomponents.DroidhangComponents")
local GoTypeEnum = {none = 0, hook = 1, arena = 2, guild = 3, friend = 4, achieve = 5, herotask = 6, task = 7, midas = 8, trial = 9, dare = 10, casino = 11, summon = 12, brave = 13, blackmarket = 14, summonspe = 15, herolist = 16, heromarket = 17, smith = 18, devour = 19, heroforge = 20, brave_shop = 21, dare_2 = 22, dare_3 = 23, pvp3_shop = 24}
local gotoList = {{title = "1", items = {{name = "1", goType = GoTypeEnum.arena}, {name = "2", goType = GoTypeEnum.herotask}, {name = "3", goType = GoTypeEnum.task}, {name = "4", goType = GoTypeEnum.hook}, {name = "5", goType = GoTypeEnum.friend}, {name = "6", goType = GoTypeEnum.achieve}}}, {title = "2", items = {{name = "1", goType = GoTypeEnum.hook}, {name = "2", goType = GoTypeEnum.dare}, {name = "3", goType = GoTypeEnum.midas}, {name = "4", goType = GoTypeEnum.trial}, {name = "5", goType = GoTypeEnum.guild}, {name = "6", goType = GoTypeEnum.task}, {name = "7", goType = GoTypeEnum.casino}}}, {title = "3", items = {{name = "1", goType = GoTypeEnum.hook}, {name = "2", goType = GoTypeEnum.dare_3}, {name = "3", goType = GoTypeEnum.herotask}, {name = "4", goType = GoTypeEnum.trial}, {name = "5", goType = GoTypeEnum.guild}, {name = "6", goType = GoTypeEnum.heromarket}, {name = "7", goType = GoTypeEnum.brave_shop}, {name = "8", goType = GoTypeEnum.friend}, {name = "9", goType = GoTypeEnum.casino}, {name = "10", goType = GoTypeEnum.blackmarket}, {name = "11", goType = GoTypeEnum.summonspe}}}, {title = "4", items = {{name = "1", goType = GoTypeEnum.hook}, {name = "2", goType = GoTypeEnum.dare_2}, {name = "3", goType = GoTypeEnum.task}, {name = "4", goType = GoTypeEnum.casino}, {name = "5", goType = GoTypeEnum.blackmarket}}}, {title = "5", items = {{name = "1", goType = GoTypeEnum.trial}, {name = "3", goType = GoTypeEnum.dare_3}, {name = "5", goType = GoTypeEnum.blackmarket}, {name = "6", goType = GoTypeEnum.hook}}}, {title = "6", items = {{name = "1", goType = GoTypeEnum.hook}, {name = "2", goType = GoTypeEnum.trial}, {name = "3", goType = GoTypeEnum.casino}, {name = "4", goType = GoTypeEnum.blackmarket}, {name = "5", goType = GoTypeEnum.brave_shop}, {name = "6", goType = GoTypeEnum.guild}}}, {title = "7", items = {{name = "1", goType = GoTypeEnum.hook}, {name = "2", goType = GoTypeEnum.brave_shop}, {name = "3", goType = GoTypeEnum.casino}}}, {title = "8", items = {{name = "1", goType = GoTypeEnum.hook}, {name = "2", goType = GoTypeEnum.guild}, {name = "3", goType = GoTypeEnum.casino}}}, {title = "11", items = {{name = "1", goType = GoTypeEnum.none}, {name = "2", goType = GoTypeEnum.herotask}, {name = "3", goType = GoTypeEnum.none}, {name = "4", goType = GoTypeEnum.blackmarket}, {name = "5", goType = GoTypeEnum.pvp3_shop}}}, {title = "9", items = {{name = "1", goType = GoTypeEnum.herolist}, {name = "2", goType = GoTypeEnum.heroforge}, {name = "3", goType = GoTypeEnum.summon}}}, {title = "10", items = {{name = "1", goType = GoTypeEnum.smith}, {name = "2", goType = GoTypeEnum.none}}}}
local gotoHelper = class("gotoHelper", function()
  return cc.LayerColor:create(cc.c4b(0, 0, 0, POPUP_DARK_OPACITY))
end
)
gotoHelper.create = function(l_2_0)
  return gotoHelper.new(l_2_0)
end

gotoHelper.ctor = function(l_3_0, l_3_1)
  local BG_WIDTH = 760
  local BG_HEIGHT = 470
  local bg = img.createLogin9Sprite(img.login.dialog)
  bg:setPreferredSize(CCSize(BG_WIDTH, BG_HEIGHT))
  bg:setScale(view.minScale * 0.1)
  bg:setAnchorPoint(ccp(0.5, 0.5))
  bg:setPosition(scalep(480, 288))
  bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  l_3_0:addChild(bg)
  l_3_0.bg = bg
  local showTitle = lbl.createFont1(26, i18n.global.gotoHelper_enter_title_2.string, ccc3(230, 208, 174))
  showTitle:setPosition(bg:getContentSize().width / 2, BG_HEIGHT - 30)
  bg:addChild(showTitle, 1)
  local showTitleShade = lbl.createFont1(26, i18n.global.gotoHelper_enter_title_2.string, ccc3(89, 48, 27))
  showTitleShade:setPosition(bg:getContentSize().width / 2, BG_HEIGHT - 32)
  bg:addChild(showTitleShade)
  l_3_0:initLeft()
  local onTouch = function(l_1_0, l_1_1, l_1_2)
    if l_1_0 == "began" then
      return true
    end
   end
  l_3_0:registerScriptTouchHandler(onTouch, false, -128, false)
  l_3_0:setTouchEnabled(true)
  local backEvent = function()
    self:removeFromParentAndCleanup(true)
   end
  local close0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, close0)
  droidhangComponents:mandateNode(closeBtn, "r1TO_IJ8gKV")
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  bg:addChild(closeMenu, 1)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    backEvent()
   end)
  addBackEvent(l_3_0)
  l_3_0.onAndroidBack = function()
    backEvent()
   end
  l_3_0:registerScriptHandler(function(l_5_0)
    if l_5_0 == "cleanup" then
      do return end
    end
    if l_5_0 == "enter" then
      self.notifyParentLock()
    elseif l_5_0 == "exit" then
      self.notifyParentUnlock()
    end
   end)
end

gotoHelper.initLeft = function(l_4_0)
  local bg = l_4_0.bg
  local SCROLL_MARGIN_TOP = 14
  local SCROLL_MARGIN_BOTTOM = 34
  local SCROLL_VIEW_WIDTH = 235
  local SCROLL_VIEW_HEIGHT = 410 - SCROLL_MARGIN_TOP - SCROLL_MARGIN_BOTTOM + 6
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setViewSize(CCSize(SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT))
  scroll:setPosition(20, SCROLL_MARGIN_BOTTOM)
  bg:addChild(scroll, 2)
  local createItem = function(l_1_0)
    local bg = img.createLogin9Sprite(img.login.button_9_small_mwhite)
    bg:setPreferredSize(CCSizeMake(206, 72))
    local bg2 = img.createLogin9Sprite(img.login.button_9_small_gold)
    bg2:setAnchorPoint(0, 0)
    bg2:setPreferredSize(CCSizeMake(206, 72))
    bg2:setOpacity(0)
    bg:addChild(bg2)
    local title = lbl.createMix({font = 1, size = 16, text = i18n.global.gotoHelper_title_" .. l_1_.string, color = ccc3(115, 59, 5), width = 180})
    title:setPosition(CCPoint(bg:getContentSize().width / 2, bg:getContentSize().height / 2))
    bg:addChild(title)
    bg.setSelected = function(l_1_0)
      if l_1_0 then
        bg2:setOpacity(255)
      else
        bg2:setOpacity(0)
      end
      end
    return bg
   end
  local height = 0
  local itemAry = {}
  for i,v in ipairs(gotoList) do
    local item = createItem(v.title)
    height = height + item:getContentSize().height + 6
    table.insert(itemAry, item)
    scroll:addChild(item)
  end
  local sy = height - 4
  for _,item in ipairs(itemAry) do
    item:setAnchorPoint(0.5, 0.5)
    item:setPosition(SCROLL_VIEW_WIDTH * 0.5, sy - item:getContentSize().height * 0.5)
    sy = sy - item:getContentSize().height - 6
  end
  l_4_0.itemAry = itemAry
  scroll:setContentSize(CCSize(SCROLL_VIEW_WIDTH, height))
  scroll:setContentOffset(ccp(0, SCROLL_VIEW_HEIGHT - (height)))
  local touchNode = cc.Layer:create()
  bg:addChild(touchNode, 1)
  local lasty = nil
  local onTouchBegan = function(l_2_0, l_2_1)
    lasty = l_2_1
    return true
   end
  local onTouchMoved = function(l_3_0, l_3_1)
    return true
   end
  local onTouchEnded = function(l_4_0, l_4_1)
    if math.abs(l_4_1 - lasty) > 10 then
      return 
    end
    local pointOnScroll = scroll:getContainer():convertToNodeSpace(ccp(l_4_0, l_4_1))
    for i,v in ipairs(itemAry) do
      if v:boundingBox():containsPoint(pointOnScroll) then
        audio.play(audio.button)
        self:onPage(i)
    else
      end
    end
    return true
   end
  local onTouch = function(l_5_0, l_5_1, l_5_2)
    if l_5_0 == "began" then
      return onTouchBegan(l_5_1, l_5_2)
    elseif l_5_0 == "moved" then
      return onTouchMoved(l_5_1, l_5_2)
    else
      return onTouchEnded(l_5_1, l_5_2)
    end
   end
  touchNode:registerScriptTouchHandler(onTouch)
  touchNode:setTouchEnabled(true)
  l_4_0:onPage(1)
end

gotoHelper.checkUnlock = function(l_5_0, l_5_1)
  if l_5_1 == GoTypeEnum.hook then
    return 0
  else
    if l_5_1 == GoTypeEnum.arena and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_ARENA_LEVEL then
      return UNLOCK_ARENA_LEVEL
      do return end
      if l_5_1 == GoTypeEnum.guild and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_GUILD_LEVEL then
        return UNLOCK_GUILD_LEVEL
        do return end
        if l_5_1 == GoTypeEnum.friend then
          return 0
        else
          if l_5_1 == GoTypeEnum.achieve then
            return 0
          else
            if l_5_1 == GoTypeEnum.herotask and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_TAVERN_LEVEL then
              return UNLOCK_TAVERN_LEVEL
              do return end
              if l_5_1 == GoTypeEnum.task and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_TASK_LEVEL then
                return 0
                do return end
                if l_5_1 == GoTypeEnum.midas then
                  return 0
                else
                  if l_5_1 == GoTypeEnum.trial and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_TRIAL_LEVEL then
                    return UNLOCK_TRIAL_LEVEL
                    do return end
                    if l_5_1 == GoTypeEnum.dare and BUILD_ENTRIES_ENABLE and player.lv() < 20 then
                      return 20
                      do return end
                      if l_5_1 == GoTypeEnum.casino and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_CASINO_LEVEL then
                        return UNLOCK_CASINO_LEVEL
                        do return end
                        if l_5_1 == GoTypeEnum.summon then
                          return 0
                        else
                          if l_5_1 == GoTypeEnum.brave and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_HERO_BRAVE then
                            return UNLOCK_HERO_BRAVE
                            do return end
                            if l_5_1 == GoTypeEnum.blackmarket and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_BLACKMARKET_LEVEL then
                              return UNLOCK_BLACKMARKET_LEVEL
                              do return end
                              if l_5_1 == GoTypeEnum.summonspe and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_GTREE_LEVEL then
                                return UNLOCK_GTREE_LEVEL
                                do return end
                                if l_5_1 == GoTypeEnum.herolist then
                                  return 0
                                else
                                  if l_5_1 == GoTypeEnum.heromarket then
                                    return 0
                                  else
                                    if l_5_1 == GoTypeEnum.smith then
                                      return 0
                                    else
                                      if l_5_1 == GoTypeEnum.devour then
                                        return 0
                                      else
                                        if l_5_1 == GoTypeEnum.heroforge then
                                          return 0
                                        else
                                          if l_5_1 == GoTypeEnum.pvp3_shop then
                                            return 0
                                          else
                                            if l_5_1 == GoTypeEnum.brave_shop and BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_HERO_BRAVE then
                                              return UNLOCK_HERO_BRAVE
                                              do return end
                                              if l_5_1 == GoTypeEnum.dare_2 and BUILD_ENTRIES_ENABLE and player.lv() < 25 then
                                                return 25
                                                do return end
                                                if l_5_1 == GoTypeEnum.dare_3 and BUILD_ENTRIES_ENABLE and player.lv() < 30 then
                                                  return 30
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
  return 0
end

gotoHelper.playGoTo = function(l_6_0, l_6_1)
  local unlockLv = l_6_0:checkUnlock(l_6_1)
  if unlockLv > 0 then
    showToast(string.format(i18n.global.func_need_lv.string, unlockLv))
    return 
  end
  local hold = nil
  local layer = l_6_0:getParent()
  local removeSelf = function()
    if tolua.isnull(self) then
      return 
    end
    self:runAction(cc.RemoveSelf:create(true))
   end
  if l_6_1 == GoTypeEnum.hook then
    replaceScene(require("ui.hook.main").create())
  else
    if l_6_1 == GoTypeEnum.arena then
      layer:addChild(require("ui.arena.entrance").create(), 1000)
    else
      if l_6_1 == GoTypeEnum.guild then
        if player.gid and player.gid > 0 and not gdata.IsInit() then
          hold = true
          local gparams = {sid = player.sid}
          do
            addWaitNet()
            netClient:guild_sync(gparams, function(l_2_0)
              delWaitNet()
              tbl2string(l_2_0)
              if l_2_0.status ~= 0 then
                showToast(i18n.global.error_server_status_wrong.string .. tostring(l_2_0.status))
                return 
              end
              gdata.init(l_2_0)
              replaceScene(require("ui.guild.main").create())
              removeSelf()
                  end)
          end
        else
          if player.gid and player.gid > 0 and gdata.IsInit() then
            replaceScene(require("ui.guild.main").create())
          else
            layer:addChild(require("ui.guild.recommend").create(1, true), 1000)
          end
        else
          if l_6_1 == GoTypeEnum.friend then
            local friends = require("ui.friends.main")
            layer:addChild(friends.create(), 200)
          else
            if l_6_1 == GoTypeEnum.achieve then
              layer:addChild(require("ui.achieve.main").create(), 1000)
            else
              if l_6_1 == GoTypeEnum.herotask then
                replaceScene(require("ui.herotask.main").create())
              else
                if l_6_1 == GoTypeEnum.task then
                  layer:addChild(require("ui.task.main").create(true), 1000)
                else
                  if l_6_1 == GoTypeEnum.midas then
                    layer:addChild(require("ui.midas.main").create(), 1000)
                  else
                    if l_6_1 == GoTypeEnum.trial then
                      replaceScene(require("ui.trial.main").create())
                    else
                      if l_6_1 == GoTypeEnum.dare or l_6_1 == GoTypeEnum.dare_2 or l_6_1 == GoTypeEnum.dare_3 then
                        hold = true
                        local daredata = require("data.dare")
                        local nParams = {sid = player.sid}
                        addWaitNet()
                        netClient:dare_sync(nParams, function(l_3_0)
                          delWaitNet()
                          tbl2string(l_3_0)
                          daredata.sync(l_3_0)
                          layer:addChild(require("ui.dare.main").create(_params), 1000)
                          removeSelf()
                                    end)
                      else
                        if l_6_1 == GoTypeEnum.casino then
                          hold = true
                          local params = {sid = player.sid, type = 1}
                          addWaitNet()
                          local casinodata = require("data.casino")
                          casinodata.pull(params, function(l_4_0)
                            delWaitNet()
                            tbl2string(l_4_0)
                            if l_4_0.status ~= 0 then
                              showToast(i18n.global.error_server_status_wrong.string .. tostring(l_4_0.status))
                              return 
                            end
                            casinodata.init(l_4_0)
                            replaceScene(require("ui.casino.main").create())
                            removeSelf()
                                       end)
                        else
                          if l_6_1 == GoTypeEnum.summon then
                            replaceScene(require("ui.summon.main").create())
                          else
                            if l_6_1 == GoTypeEnum.brave then
                              local databrave = require("data.brave")
                              if not databrave.isPull or databrave.cd < os.time() then
                                hold = true
                                local params = {sid = player.sid}
                                addWaitNet()
                                netClient:sync_brave(params, function(l_5_0)
                                  delWaitNet()
                                  tbl2string(l_5_0)
                                  databrave.init(l_5_0)
                                  if layer and not tolua.isnull(layer) then
                                    layer:addChild(require("ui.brave.main").create(), 1000)
                                    removeSelf()
                                  end
                                                end)
                              else
                                layer:addChild(require("ui.brave.main").create(), 1000)
                              end
                            else
                              if l_6_1 == GoTypeEnum.blackmarket then
                                replaceScene(require("ui.blackmarket.main").create())
                              else
                                if l_6_1 == GoTypeEnum.summonspe then
                                  layer:addChild(require("ui.summonspe.main").create(), 1000)
                                else
                                  if l_6_1 == GoTypeEnum.herolist then
                                    replaceScene(require("ui.herolist.main").create())
                                  else
                                    if l_6_1 == GoTypeEnum.heromarket then
                                      layer:addChild(require("ui.heromarket.main").create(), 1000)
                                    else
                                      if l_6_1 == GoTypeEnum.smith then
                                        replaceScene(require("ui.smith.main").create())
                                      else
                                        if l_6_1 == GoTypeEnum.devour then
                                          replaceScene(require("ui.devour.main").create())
                                        else
                                          if l_6_1 == GoTypeEnum.heroforge then
                                            replaceScene(require("ui.heroforge.main").create())
                                          else
                                            if l_6_1 == GoTypeEnum.brave_shop then
                                              local shop = require("ui.braveshop.main")
                                              layer:addChild(shop.create(), 1000)
                                            else
                                              if l_6_1 == GoTypeEnum.pvp3_shop then
                                                local shop = require("ui.arena.shop")
                                                layer:addChild(shop.create(), 1000)
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
  if not hold then
    removeSelf()
  end
end

gotoHelper.onPage = function(l_7_0, l_7_1)
  if l_7_1 == l_7_0.pageIndex then
    return 
  end
  if l_7_0.pageIndex then
    l_7_0.itemAry[l_7_0.pageIndex].setSelected(false)
  end
  l_7_0.itemAry[l_7_1].setSelected(true)
  l_7_0.pageIndex = l_7_1
  if l_7_0.rightNode then
    l_7_0.rightNode:removeFromParent()
    l_7_0.rightNode = nil
  end
  local rightNode = cc.Node:create()
  l_7_0.bg:addChild(rightNode, 2)
  l_7_0.rightNode = rightNode
  local SCROLL_MARGIN_TOP = 14
  local SCROLL_MARGIN_BOTTOM = 34
  local SCROLL_VIEW_WIDTH = 484
  local SCROLL_VIEW_HEIGHT = 410 - SCROLL_MARGIN_TOP - SCROLL_MARGIN_BOTTOM
  local innerBg = img.createUI9Sprite(img.ui.inner_bg)
  innerBg:setPreferredSize(CCSize(SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT + 4))
  innerBg:setAnchorPoint(ccp(0, 0))
  innerBg:setPosition(250, SCROLL_MARGIN_BOTTOM - 2)
  rightNode:addChild(innerBg)
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setViewSize(CCSize(SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT))
  scroll:setPosition(250, SCROLL_MARGIN_BOTTOM)
  rightNode:addChild(scroll)
  local createItem = function(l_1_0, l_1_1)
    local bg = img.createUI9Sprite(img.ui.botton_fram_2)
    bg:setPreferredSize(CCSize(454, 82))
    local desc = lbl.createMix({font = 1, size = 16, text = i18n.global.gotoHelper_iteam_" .. l_1_0 .. "_" .. l_1_1.nam.string, color = ccc3(115, 59, 5), width = 290, align = kCCTextAlignmentLeft})
    desc:setAnchorPoint(0, 0.5)
    desc:setPosition(26, bg:getContentSize().height * 0.5)
    bg:addChild(desc)
    if l_1_1.goType ~= GoTypeEnum.none then
      local goto0 = img.createLogin9Sprite(img.login.button_9_small_green)
      goto0:setPreferredSize(CCSize(116, 42))
      local gotoLab = lbl.createFont1(16, i18n.global.task_btn_goto.string, ccc3(27, 89, 2))
      gotoLab:setPosition(goto0:getContentSize().width / 2, goto0:getContentSize().height / 2)
      goto0:addChild(gotoLab)
      local gotoBtn = SpineMenuItem:create(json.ui.button, goto0)
      droidhangComponents:mandateNode(gotoBtn, "FJra_DcpJx6")
      gotoBtn:setPositionY(bg:getContentSize().height * 0.5)
      local gotoMenu = CCMenu:createWithItem(gotoBtn)
      gotoMenu:setPosition(CCPoint(0, 0))
      bg:addChild(gotoMenu, 1)
      gotoBtn:registerScriptTapHandler(function()
        self:playGoTo(data.goType)
         end)
      if self:checkUnlock(l_1_1.goType) > 0 then
        setShader(gotoBtn, SHADER_GRAY, true)
      end
    end
    return bg
   end
  local height = 0
  local itemAry = {}
  local info = gotoList[l_7_1]
  for i,data in ipairs(info.items) do
    local item = createItem(info.title, data)
    height = height + item:getContentSize().height + 2
    table.insert(itemAry, item)
    scroll:addChild(item)
  end
  local sy = height - 4
  for _,item in ipairs(itemAry) do
    item:setAnchorPoint(0.5, 0.5)
    item:setPosition(SCROLL_VIEW_WIDTH * 0.5, sy - item:getContentSize().height * 0.5)
    sy = sy - item:getContentSize().height - 2
  end
  scroll:setContentSize(CCSize(SCROLL_VIEW_WIDTH, height + 10))
  scroll:setContentOffset(ccp(0, SCROLL_VIEW_HEIGHT - (height) - 10))
end

return gotoHelper

