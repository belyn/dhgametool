-- Command line was: E:\github\dhgametool\scripts\ui\achieve\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local heros = require("data.heros")
local cfghero = require("config.hero")
local bag = require("data.bag")
local player = require("data.player")
local cfgachieve = require("config.achievement")
local achieveData = require("data.achieve")
ui.create = function()
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(732, 489))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local btnCloseSp = img.createLoginSprite(img.login.button_close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSp)
  btnClose:setPosition(708, 461)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose, 1000)
  btnClose:registerScriptTapHandler(function()
    layer:removeFromParentAndCleanup(true)
    audio.play(audio.button)
   end)
  local titleBgLef = img.createUISprite(img.ui.achieve_decoration)
  titleBgLef:setAnchorPoint(ccp(1, 0))
  titleBgLef:setPosition(board:getContentSize().width / 2, 417)
  board:addChild(titleBgLef, 1)
  local titleBgRig = img.createUISprite(img.ui.achieve_decoration)
  titleBgRig:setFlipX(true)
  titleBgRig:setAnchorPoint(ccp(0, 0))
  titleBgRig:setPosition(board:getContentSize().width / 2, 417)
  board:addChild(titleBgRig, 1)
  local title = lbl.createFont1(24, i18n.global.achieve_title.string, ccc3(250, 216, 105))
  title:setPosition(board:getContentSize().width / 2, 460)
  board:addChild(title, 100)
  local showAchieveBg = img.createUI9Sprite(img.ui.inner_bg)
  showAchieveBg:setPreferredSize(CCSize(685, 393))
  showAchieveBg:setAnchorPoint(ccp(0.5, 0))
  showAchieveBg:setPosition(board:getContentSize().width / 2, 28)
  board:addChild(showAchieveBg)
  scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(11, 1)
  scroll:setViewSize(CCSize(666, 390))
  scroll:setContentSize(CCSizeMake(0, 0))
  showAchieveBg:addChild(scroll)
  local showItems = {}
  local loadAchieve = function()
    local tasks = {}
    for i,v in ipairs(achieveData.achieveInfos) do
      do
        if cfgachieve[v.id].status and cfgachieve[v.id].status > 0 then
          for i,v in (for generator) do
          end
          tasks[#tasks + 1] = v
        end
      end
      for i = 1, #tasks do
        for j = i + 1, #tasks do
           -- DECOMPILER ERROR: unhandled construct in 'if'

          if tasks[i].isComplete ~= tasks[j].isComplete and tasks[i].isComplete == true then
            tasks[i], tasks[j] = tasks[j], tasks[i]
            do return end
            if cfgachieve[tasks[j].id].completeValue <= tasks[j].num then
              tasks[i], tasks[j] = tasks[j], tasks[i]
            else
              if tasks[j].num > 0 and tasks[i].num == 0 then
                tasks[i], tasks[j] = tasks[j], tasks[i]
              end
            end
          end
        end
      end
      scroll:getContainer():removeAllChildrenWithCleanup(true)
      do
        local height = 6 + 100 * #tasks
        scroll:setContentSize(CCSize(666, height))
        scroll:setContentOffset(ccp(0, 390 - height))
        upvalue_1024 = {}
        for i,v in ipairs(tasks) do
          local taskBg = img.createUI9Sprite(img.ui.bottom_border_2)
          taskBg:setPreferredSize(CCSize(660, 98))
          taskBg:setAnchorPoint(ccp(0, 0))
          taskBg:setPosition(2, height - 8 - 100 * i)
          scroll:getContainer():addChild(taskBg)
          local showText = lbl.createMix({font = 1, size = 12, text = i18n.achievement[v.id].achieveDesc, color = ccc3(93, 45, 18), width = 276, align = kCCTextAlignmentLeft})
          showText:setAnchorPoint(ccp(0, 1))
          showText:setPosition(23, 77)
          taskBg:addChild(showText)
          local progressBg = img.createUI9Sprite(img.ui.playerInfo_process_bar_bg)
          progressBg:setPreferredSize(CCSize(248, 20))
          progressBg:setAnchorPoint(ccp(0, 0))
          progressBg:setPosition(23, 20)
          taskBg:addChild(progressBg)
          local progressFgSp = img.createUISprite(img.ui.achieve_progress_fg)
          local progressFg = createProgressBar(progressFgSp)
          progressFg:setAnchorPoint(ccp(0, 0.5))
          progressFg:setPosition(1, progressBg:getContentSize().height / 2)
          progressFg:setPercentage(v.num / cfgachieve[v.id].completeValue * 100)
          progressBg:addChild(progressFg)
          local showPercent = lbl.createFont2(16, v.num .. "/" .. cfgachieve[v.id].completeValue)
          showPercent:setPosition(progressBg:getContentSize().width / 2, progressBg:getContentSize().height / 2)
          progressBg:addChild(showPercent)
          for k,item in ipairs(cfgachieve[v.id].rewards) do
            local idx = #showItems + 1
            if item.type == 1 then
              showItems[idx] = img.createItem(item.id, item.num)
            else
              showItems[idx] = img.createEquip(item.id)
            end
            showItems[idx]:setAnchorPoint(ccp(0, 0.5))
            showItems[idx]:setScale(0.7)
            showItems[idx]:setPosition(taskBg:boundingBox():getMinX() + 272 + k * 67, taskBg:boundingBox():getMidY() + 1)
            scroll:getContainer():addChild(showItems[idx])
            showItems[idx].info = clone(item)
          end
          if v.isComplete == true then
            local showCalimed = img.createUISprite(img.ui.achieve_calim)
            showCalimed:setPosition(581, taskBg:getContentSize().height / 2)
            taskBg:addChild(showCalimed)
          else
            local btnCalimSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
            btnCalimSprite:setPreferredSize(CCSize(120, 50))
            local showLab = lbl.createFont1(16, i18n.global.achieve_btn_calim.string, ccc3(115, 59, 5))
            showLab:setPosition(btnCalimSprite:getContentSize().width / 2, btnCalimSprite:getContentSize().height / 2 + 1)
            btnCalimSprite:addChild(showLab)
            local btnCalim = SpineMenuItem:create(json.ui.button, btnCalimSprite)
            local menuCalim = CCMenu:createWithItem(btnCalim)
            menuCalim:setPosition(0, 0)
            taskBg:addChild(menuCalim)
            btnCalim:setPosition(581, taskBg:getContentSize().height / 2)
            btnCalim:registerScriptTapHandler(function()
            audio.play(audio.button)
            local params = {sid = player.sid, id = v.id}
            addWaitNet()
            net:achieve_claim(params, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              if l_1_0.status < 0 then
                showToast("status:" .. l_1_0.status)
                return 
              end
              achieveData.claim(v.id)
              bag.addRewards(l_1_0.reward)
              layer:addChild(require("ui.tips.reward").create(l_1_0.reward), 1000)
              loadAchieve()
                  end)
               end)
            if v.num < cfgachieve[v.id].completeValue then
              btnCalim:setEnabled(false)
              setShader(btnCalim, SHADER_GRAY, true)
            end
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local lasty = nil
  local onTouchBegin = function(l_3_0, l_3_1)
    lasty = l_3_1
    return true
   end
  local onTouchMoved = function(l_4_0, l_4_1)
    return true
   end
  local onTouchEnd = function(l_5_0, l_5_1)
    local point = layer:convertToNodeSpace(ccp(l_5_0, l_5_1))
    if math.abs(l_5_1 - lasty) > 10 or not board:boundingBox():containsPoint(point) then
      return true
    end
    do
      local pointOnScroll = scroll:getContainer():convertToNodeSpace(ccp(l_5_0, l_5_1))
      for i,v in ipairs(showItems) do
        if v:boundingBox():containsPoint(pointOnScroll) then
          audio.play(audio.button)
          do
            if v.info.type == 1 then
              local tips = require("ui.tips.item").createForShow(v.info)
              layer:addChild(tips, 10000)
            end
            for i,v in (for generator) do
            end
            local tips = require("ui.tips.equip").createById(v.info.id)
            layer:addChild(tips, 10000)
          end
        end
        return true
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local onTouch = function(l_6_0, l_6_1, l_6_2)
    if l_6_0 == "began" then
      return onTouchBegin(l_6_1, l_6_2)
    elseif l_6_0 == "moved" then
      return onTouchMoved(l_6_1, l_6_2)
    else
      return onTouchEnd(l_6_1, l_6_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
    loadAchieve()
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
  board:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  anim_arr:addObject(CCDelayTime:create(0.15))
  anim_arr:addObject(CCCallFunc:create(function()
   end))
  board:runAction(CCSequence:create(anim_arr))
  return layer
end

return ui

