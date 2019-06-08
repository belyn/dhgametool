-- Command line was: E:\github\dhgametool\scripts\ui\brave\levelrewards.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local particle = require("res.particle")
local i18n = require("res.i18n")
local net = require("net.netClient")
local player = require("data.player")
local bag = require("data.bag")
local reward = require("ui.reward")
local databrave = require("data.brave")
local rewardlevel = {3, 6, 9, 12, 15}
ui.create = function(l_1_0)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local board_w = 762
  local board_h = 375
  img.load(img.packedOthers.ui_brave)
  local board = img.createUI9Sprite(img.ui.dialog_1)
  board:setPreferredSize(CCSizeMake(board_w, board_h))
  board:setScale(view.minScale)
  board:setPosition(view.physical.w / 2, view.physical.h / 2)
  layer:addChild(board)
  local title = lbl.createFont1(24, i18n.global.brave_lr_title.string, ccc3(230, 208, 174))
  title:setPosition(CCPoint(board_w / 2, board_h - 32))
  board:addChild(title, 1)
  local title_shadowD = lbl.createFont1(24, i18n.global.brave_lr_title.string, ccc3(89, 48, 27))
  title_shadowD:setPosition(CCPoint(board_w / 2, board_h - 34))
  board:addChild(title_shadowD)
  board:setScale(0.5 * view.minScale)
  board:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  local bottom = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  bottom:setPreferredSize(CCSizeMake(702, 242))
  bottom:setAnchorPoint(0, 0)
  bottom:setPosition(CCPoint(30, 58))
  board:addChild(bottom)
  local judgeboxstatus = function(l_1_0)
    if rewardlevel[l_1_0] < databrave.stage then
      if databrave.nodes then
        for i = 1,  databrave.nodes do
          if databrave.nodes[i] == rewardlevel[l_1_0] then
            return "3"
          end
        end
        return "2"
      else
        return "2"
      end
    else
      return "1"
    end
   end
  local sx = 180
  local dx = 118
  local itemBtn = {}
  local bravebox = {}
  local grid = {}
  local showRewardItems = function(l_2_0)
    l_2_0 = l_2_0 * 3
    local tipslayer = CCLayer:create()
    tipslayer.tipsTag = false
    local tipsbg = img.createUI9Sprite(img.ui.tips_bg)
    tipsbg:setPreferredSize(CCSize(312, 206))
    tipsbg:setScale(view.minScale)
    tipsbg:setPosition(view.physical.w / 2, view.physical.h / 2)
    tipslayer:addChild(tipsbg)
    local tipstitle = lbl.createFont1(18, i18n.global.brave_baoxiang_tips.string, ccc3(255, 228, 156))
    tipstitle:setPosition(156, 174)
    tipsbg:addChild(tipstitle)
    local line = img.createUISprite(img.ui.help_line)
    line:setScaleX(242 / line:getContentSize().width)
    line:setPosition(CCPoint(156, 150))
    tipsbg:addChild(line)
    local cfgnode = require("config.bravenode")
    for i = 1, 2 do
      do
        local item = img.createItem(cfgnode[l_2_0].rewards[i].id, cfgnode[l_2_0].rewards[i].num)
        local itembtn = SpineMenuItem:create(json.ui.button, item)
        itembtn:setPosition(tipsbg:getContentSize().width / 2 - 55 + (i - 1) * 110, 78)
        local iconMenu = CCMenu:createWithItem(itembtn)
        iconMenu:setPosition(0, 0)
        tipsbg:addChild(iconMenu)
        itembtn:registerScriptTapHandler(function()
          audio.play(audio.button)
          if tipslayer.tipsTag == false then
            tipslayer.tipsTag = true
            local tipsitem = require("ui.tips.item")
            tips = tipsitem.createForShow({id = cfgnode[pos].rewards[i].id, num = cfgnode[pos].rewards[i].num})
            tipslayer:addChild(tips, 200)
            tips.setClickBlankHandler(function()
              tips:removeFromParent()
              tipslayer.tipsTag = false
                  end)
          end
            end)
      end
    end
    local clickBlankHandler = nil
    tipslayer.setClickBlankHandler = function(l_2_0)
      clickBlankHandler = l_2_0
      end
    tipslayer.setClickBlankHandler(function()
      itemBtn[pos / 3].gridSelected:setVisible(false)
      tipslayer:removeFromParent()
      end)
    local onTouch = function(l_4_0, l_4_1, l_4_2)
      if l_4_0 == "began" then
        return true
      elseif l_4_0 == "moved" then
        return 
      else
        if not tipsbg:boundingBox():containsPoint(ccp(l_4_1, l_4_2)) then
          tipslayer.onAndroidBack()
        end
      end
      end
    addBackEvent(tipslayer)
    tipslayer.onAndroidBack = function()
      if clickBlankHandler then
        clickBlankHandler()
      else
        tipslayer:removeFromParent()
        itemBtn[i].gridSelected:setVisible(false)
      end
      end
    tipslayer:setTouchEnabled(true)
    tipslayer:setTouchSwallowEnabled(true)
    tipslayer:registerScriptTouchHandler(onTouch)
    return tipslayer
   end
  for i = 1, 5 do
    do
      local raw = img.createUISprite(img.ui.brave_level_raw)
      raw:setAnchorPoint(0.5, 0)
      raw:setPosition(sx + (i - 1) * dx, 142)
      board:addChild(raw, 1)
      local numlab = lbl.createFont1(20, rewardlevel[i], ccc3(115, 59, 5))
      numlab:setPosition(sx + (i - 1) * dx, 100)
      board:addChild(numlab)
      grid[i] = img.createUISprite(img.ui.grid)
      local gridSelected = img.createUISprite(img.ui.bag_grid_selected)
      gridSelected:setAnchorPoint(ccp(0, 0))
      gridSelected:setVisible(false)
      grid[i]:addChild(gridSelected)
      itemBtn[i] = SpineMenuItem:create(json.ui.button, grid[i])
      itemBtn[i]:setPosition(sx + (i - 1) * dx, 220)
      itemBtn[i].gridSelected = gridSelected
      local rewardMenu = CCMenu:createWithItem(itemBtn[i])
      rewardMenu:setPosition(0, 0)
      board:addChild(rewardMenu)
      if i < 4 then
        json.load(json.ui.yuanzheng_baoxiang)
        bravebox[i] = DHSkeletonAnimation:createWithKey(json.ui.yuanzheng_baoxiang)
      else
        json.load(json.ui.yuanzheng_baoxiang_gem)
        bravebox[i] = DHSkeletonAnimation:createWithKey(json.ui.yuanzheng_baoxiang_gem)
      end
      bravebox[i]:scheduleUpdateLua()
      if judgeboxstatus(i) == "2" then
        bravebox[i]:playAnimation("2", -1)
      else
        if judgeboxstatus(i) == "3" then
          itemBtn[i]:setEnabled(false)
          bravebox[i]:playAnimation("1")
          local blackicon = img.createUISprite(img.ui.brave_rl_black)
          blackicon:setPosition(grid[i]:getContentSize().width / 2, grid[i]:getContentSize().height / 2)
          blackicon:setOpacity(85)
          itemBtn[i]:addChild(blackicon, 1001)
          local tickIcon = img.createUISprite(img.ui.hook_btn_sel)
          tickIcon:setPosition(grid[i]:getContentSize().width / 2, grid[i]:getContentSize().height / 2)
          itemBtn[i]:addChild(tickIcon, 1001)
        else
          bravebox[i]:playAnimation(judgeboxstatus(i))
        end
      end
      bravebox[i]:setPosition(grid[i]:getContentSize().width / 2, grid[i]:getContentSize().height / 2)
      grid[i]:addChild(bravebox[i], 1000)
      itemBtn[i]:registerScriptTapHandler(function()
        audio.play(audio.button)
        if judgeboxstatus(i) == "1" then
          itemBtn[i].gridSelected:setVisible(true)
          local tipslayer = showRewardItems(i)
          layer:addChild(tipslayer)
          return 
        end
         end)
    end
  end
  local getRewards = function()
    local stageis = {}
    local stages = {}
    for i = 1, 5 do
      if judgeboxstatus(i) == "2" then
        stageis[ stageis + 1] = i
        stages[ stages + 1] = rewardlevel[i]
      end
    end
    if  stageis < 1 then
      return 
    end
    local param = {}
    param.sid = player.sid
    param.stage = stages
    addWaitNet()
    net:brave_node(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      if databrave.nodes == nil then
        local node = stages
        databrave.nodes = node
      else
        for i = 1,  stages do
          databrave.nodes[ databrave.nodes + 1] = stages[i]
        end
      end
      for i = 1,  stageis do
        bravebox[stageis[i]]:stopAnimation()
        bravebox[stageis[i]]:playAnimation("3")
        itemBtn[stageis[i]]:setEnabled(false)
      end
      local ban = CCLayer:create()
      ban:setTouchEnabled(true)
      ban:setTouchSwallowEnabled(true)
      layer:addChild(ban, 1001)
      bag.addRewards(l_1_0.reward)
      schedule(layer, 1, function()
        callback()
        for i = 1,  stageis do
          bravebox[stageis[i]]:stopAnimation()
          bravebox[stageis[i]]:playAnimation("1")
          local blackicon = img.createUISprite(img.ui.brave_rl_black)
          blackicon:setPosition(grid[stageis[i]]:getContentSize().width / 2, grid[stageis[i]]:getContentSize().height / 2)
          blackicon:setOpacity(85)
          itemBtn[stageis[i]]:addChild(blackicon, 1001)
          local tickIcon = img.createUISprite(img.ui.hook_btn_sel)
          tickIcon:setPosition(grid[stageis[i]]:getContentSize().width / 2, grid[stageis[i]]:getContentSize().height / 2)
          itemBtn[stageis[i]]:addChild(tickIcon, 1001)
        end
        ban:removeFromParent()
        layer:addChild(reward.showRewardForbraveBox(__data.reward), 1002)
         end)
      end)
   end
  getRewards()
  local expreBar = img.createUI9Sprite(img.ui.brave_level_expbg)
  expreBar:setPreferredSize(CCSize(630, 26))
  expreBar:setPosition(board_w / 2, 130)
  board:addChild(expreBar, 1)
  local percel = (databrave.stage - 1) * 0.06
  if databrave.stage == 7 then
    percel = 0.368
  else
    if databrave.stage == 10 then
      percel = 0.555
    else
      if databrave.stage == 13 then
        percel = 0.742
      else
        if databrave.stage == 16 then
          percel = 1
        end
      end
    end
  end
  local progress0 = img.createUISprite(img.ui.brave_level_exppro)
  local powerProgress = createProgressBar(progress0)
  powerProgress:setPosition(expreBar:getContentSize().width / 2, expreBar:getContentSize().height / 2)
  powerProgress:setPercentage(percel * 100)
  expreBar:addChild(powerProgress)
  local slicon = img.createUISprite(img.ui.brave_level_circle)
  slicon:setPosition(percel * 630, 13)
  expreBar:addChild(slicon)
  local sllab = lbl.createFont1(16, databrave.stage - 1, ccc3(29, 103, 0))
  sllab:setPosition(slicon:getContentSize().width / 2, slicon:getContentSize().height / 2)
  slicon:addChild(sllab)
  if databrave.stage == 16 then
    slicon:setVisible(false)
  end
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup()
   end
  local close0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, close0)
  closeBtn:setPosition(CCPoint(board_w - 22, board_h - 26))
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  board:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    backEvent()
   end)
  layer:setTouchEnabled(true)
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
  return layer
end

return ui

