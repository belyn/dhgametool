-- Command line was: E:\github\dhgametool\scripts\ui\activity\treasures.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local particle = require("res.particle")
local cfgactivity = require("config.activity")
local cfgtreasuremap = require("config.treasuremap")
local cfggift = require("config.gift")
local player = require("data.player")
local activityData = require("data.activity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local bag = require("data.bag")
local rewards = require("ui.reward")
local IDS = activityData.IDS
local ItemType = {Item = 1, Equip = 2}
local MaxPoints = cfgactivity[IDS.TREASURES.ID].instruct
ui.createItem1 = function(l_1_0)
  local item = (img.createUISprite(img.ui.treasure_board1))
  local icon = nil
  if l_1_0.type == 1 then
    icon = img.createItem(l_1_0.id, l_1_0.num)
  else
    icon = img.createEquip(l_1_0.id, l_1_0.num)
  end
  icon:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
  icon:setScale(0.8)
  item:addChild(icon)
  return item
end

ui.createItem2 = function(l_2_0)
  json.load(json.ui.fengshoubaozhang)
  local bannerboss = DHSkeletonAnimation:createWithKey(json.ui.fengshoubaozhang)
  bannerboss:scheduleUpdateLua()
  if l_2_0 then
    bannerboss:playAnimation("start")
    bannerboss:appendNextAnimation("loop", -1)
  else
    bannerboss:playAnimation("start2")
    bannerboss:appendNextAnimation("loop2", -1)
  end
  return bannerboss
end

ui.createFail = function()
  local params = {}
  params.btn_count = 0
  params.body = i18n.global.activity_treasure_toast_trap.string
  local board_w = 474
  local dialoglayer = require("ui.dialog").create(params)
  local btnYesSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnYesSprite:setPreferredSize(CCSize(153, 50))
  local btnYes = SpineMenuItem:create(json.ui.button, btnYesSprite)
  btnYes:setPosition(board_w / 2, 100)
  local labYes = lbl.createFont1(18, i18n.global.dialog_button_confirm.string, ccc3(115, 59, 5))
  labYes:setPosition(btnYes:getContentSize().width / 2, btnYes:getContentSize().height / 2)
  btnYesSprite:addChild(labYes)
  local menuYes = CCMenu:create()
  menuYes:setPosition(0, 0)
  menuYes:addChild(btnYes)
  dialoglayer.board:addChild(menuYes)
  btnYes:registerScriptTapHandler(function()
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
  dialoglayer:registerScriptHandler(function(l_6_0)
    if l_6_0 == "enter" then
      onEnter()
    elseif l_6_0 == "exit" then
      onExit()
    end
   end)
  return dialoglayer
end

ui.create = function()
  local layer = CCLayer:create()
  local st1 = activityData.getStatusById(IDS.TREASURES.ID)
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(570, 438))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(362, 60))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.spine_ui_fengshoubaozhang)
  img.load(img.packedOthers.ui_activity_treasures)
  local banner = img.createUISprite(img.ui.treasure_bg)
  banner:setPosition(CCPoint(board_w / 2 - 10, 192))
  board:addChild(banner)
  local costId = cfgtreasuremap[1].cost[1].id
  local tick_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  tick_bg:setPreferredSize(CCSizeMake(138, 36))
  tick_bg:setPosition(CCPoint(90, board_h - 35))
  board:addChild(tick_bg)
  local icon_tick = img.createItemIcon2(costId)
  icon_tick:setPosition(CCPoint(5, tick_bg:getContentSize().height / 2 + 2))
  tick_bg:addChild(icon_tick)
  local tick_num = 0
  if bag.items.find(costId) then
    tick_num = bag.items.find(costId).num
  end
  local lbl_tick = lbl.createFont2(16, tick_num, ccc3(255, 246, 223))
  lbl_tick:setPosition(CCPoint(tick_bg:getContentSize().width / 2 - 10, tick_bg:getContentSize().height / 2 + 3))
  tick_bg:addChild(lbl_tick)
  lbl_tick.num = tick_num
  local need_num = lbl.createFont2(16, cfgtreasuremap[st1.limits + 1].cost[1].num, ccc3(165, 253, 71))
  need_num:setPosition(412, board_h - 34)
  board:addChild(need_num)
  local need_des = lbl.createMixFont2(16, i18n.global.activity_treasure_need.string, ccc3(255, 246, 223))
  need_des:setAnchorPoint(CCPoint(1, 0.5))
  need_des:setPosition(CCPoint(need_num:getPositionX() - 9, board_h - 34))
  board:addChild(need_des)
  json.load(json.ui.fengshoubaozhang_click)
  local changeLayer = nil
  local sx = 4
  local sy = 4
  local itemNode = {}
  local iconAnimal = {}
  local baseCount = 0
  createChangeLayer = function()
    local clayer = CCLayer:create()
    for i = 1, 16 do
      do
        local item0 = CCSprite:create()
        do
          item0:setContentSize(CCSizeMake(131, 86))
          itemNode[i] = CCMenuItemSprite:create(item0, nil)
          itemNode[i]:setPosition(sx + (i - 1) % 4 * 135, 364 - sy - math.floor((i - 1) / 4) * 90)
          itemNode[i]:setAnchorPoint(0, 1)
          local itemMenu = CCMenu:createWithItem(itemNode[i])
          itemMenu:setPosition(CCPoint(0, 0))
          clayer:addChild(itemMenu)
          if bit.band(bit.brshift(st1.loop, i - 1), 1) == 1 then
            upvalue_2048 = baseCount + 1
            local itemPos = bit.band(bit.brshift(st1.next, (i - 1) * 2), 3)
            local reward = cfggift[cfgtreasuremap[i].rewards2].randomGoods[itemPos + 1]
            iconAnimal[i] = ui.createItem1(reward)
            iconAnimal[i]:setPosition(item0:getContentSize().width / 2, item0:getContentSize().height / 2)
            item0:addChild(iconAnimal[i])
          end
          itemNode[i]:registerScriptTapHandler(function()
            audio.play(audio.button)
            if bit.band(bit.brshift(st1.loop, i - 1), 1) == 1 then
              return 
            end
            local tickNum = 0
            if bag.items.find(costId) then
              tickNum = bag.items.find(costId).num
            end
            if tickNum < cfgtreasuremap[st1.limits + 1].cost[1].num then
              showToast(i18n.global.activity_treasure_notenough.string)
              return 
            end
            local clickAni = DHSkeletonAnimation:createWithKey(json.ui.fengshoubaozhang_click)
            clickAni:scheduleUpdateLua()
            clickAni:playAnimation("animation")
            clickAni:setPosition(item0:getContentSize().width / 2, item0:getContentSize().height / 2)
            item0:addChild(clickAni, 1001)
            local loopparcl = particle.create("fengshoubaozhang")
            loopparcl:setPosition(item0:getContentSize().width / 2, item0:getContentSize().height / 2)
            item0:addChild(loopparcl, 1001)
            local params = {sid = player.sid, id = st1.id, grid = i}
            tbl2string(params)
            addWaitNet()
            netClient:activity_grid(params, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              if l_1_0.status == -2 then
                showToast(i18n.global.activity_treasure_notenough.string)
                return 
              end
              if l_1_0.status ~= 0 then
                showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
                return 
              end
              if l_1_0.reward and l_1_0.reward.items then
                bag.items.addAll(l_1_0.reward.items)
              end
              if l_1_0.reward and l_1_0.reward.equips then
                bag.equips.addAll(l_1_0.reward.equips)
              end
              bag.items.sub({id = costId, num = cfgtreasuremap[st1.limits + 1].cost[1].num})
              upvalue_2560 = tick_num - cfgtreasuremap[st1.limits + 1].cost[1].num
              lbl_tick:setString(tick_num)
              if l_1_0.type == 0 then
                if l_1_0.reward then
                  CCDirector:sharedDirector():getRunningScene():addChild(rewards.createFloating(l_1_0.reward), 100000)
                  if l_1_0.reward.items then
                    iconAnimal[i] = ui.createItem1({type = 1, id = l_1_0.reward.items[1].id, num = l_1_0.reward.items[1].num})
                    iconAnimal[i]:setPosition(item0:getContentSize().width / 2, item0:getContentSize().height / 2)
                    item0:addChild(iconAnimal[i])
                  end
                  if l_1_0.reward.equips then
                    iconAnimal[i] = ui.createItem1({type = 2, id = l_1_0.reward.equips[1].id, num = l_1_0.reward.equips[1].num})
                    iconAnimal[i]:setPosition(item0:getContentSize().width / 2, item0:getContentSize().height / 2)
                    item0:addChild(iconAnimal[i])
                  end
                end
                st1.loop = bit.bor(st1.loop, bit.blshift(1, i - 1))
                st1.limits = st1.limits + 1
                st1.next = l_1_0.grid
                need_num:setString(cfgtreasuremap[st1.limits + 1].cost[1].num)
              elseif l_1_0.type == 1 then
                st1.loop = 0
                st1.limits = 0
                need_num:setString(cfgtreasuremap[st1.limits + 1].cost[1].num)
                iconAnimal[i] = ui.createItem2(true)
                iconAnimal[i]:setPosition(item0:getContentSize().width / 2, item0:getContentSize().height / 2)
                item0:addChild(iconAnimal[i])
                local ban = CCLayer:create()
                do
                  ban:setTouchEnabled(true)
                  ban:setTouchSwallowEnabled(true)
                  layer:addChild(ban, 1000)
                  layer:runAction(createSequence({}))
                  schedule(layer, 1, function()
                    if __data.reward then
                      local rewardsKit = require("ui.reward")
                      CCDirector:sharedDirector():getRunningScene():addChild(rewardsKit.showReward(__data.reward), 100000)
                    end
                    changeLayer:removeFromParentAndCleanup(true)
                    upvalue_512 = nil
                    upvalue_512 = createChangeLayer()
                    banner:addChild(changeLayer)
                           end)
                end
              else
                need_num:setString(cfgtreasuremap[st1.limits + 1].cost[1].num)
                iconAnimal[i]:setPosition(item0:getContentSize().width / 2, item0:getContentSize().height / 2)
                item0:addChild(iconAnimal[i])
                local ban = CCLayer:create()
                ban:setTouchEnabled(true)
                ban:setTouchSwallowEnabled(true)
                layer:addChild(ban, 1000)
                 -- DECOMPILER ERROR: Overwrote pending register.

                 -- DECOMPILER ERROR: Overwrote pending register.

                layer:runAction(createSequence({}))
                schedule(layer, 1, function()
                  local failLayer = ui.createFail()
                  layer:getParent():getParent():addChild(failLayer, 300)
                  changeLayer:removeFromParentAndCleanup(true)
                  upvalue_1024 = nil
                  upvalue_1024 = createChangeLayer()
                  banner:addChild(changeLayer)
                        end)
              end
               -- Warning: undefined locals caused missing assignments!
                  end)
               end)
        end
      end
    end
    return clayer
   end
  changeLayer = createChangeLayer()
  banner:addChild(changeLayer)
  local btnInfoSprite = img.createUISprite(img.ui.btn_help)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  btnInfo:setPosition(525, board_h - 38)
  local menuInfo = CCMenu:createWithItem(btnInfo)
  menuInfo:setPosition(0, 0)
  board:addChild(menuInfo, 100)
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:getParent():getParent():addChild(require("ui.help").create(i18n.global.help_acttreasure.string, i18n.global.help_title.string), 1000)
   end)
  return layer
end

return ui

