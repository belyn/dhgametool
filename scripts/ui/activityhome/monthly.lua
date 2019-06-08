-- Command line was: E:\github\dhgametool\scripts\ui\activityhome\monthly.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local json = require("res.json")
local audio = require("res.audio")
local player = require("data.player")
local mactivityData = require("data.monthlyactivity")
local cfglimitgift = require("config.limitgift")
local shopData = require("data.shop")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local IDS = mactivityData.IDS
local refreshSelf = function(l_1_0)
  local parent_obj = l_1_0:getParent()
  l_1_0:removeFromParentAndCleanup(true)
end

local getItems = function()
  return {IDS.SCORE_FIGHT.ID = {id = IDS.SCORE_FIGHT.ID, group = IDS.SCORE_FIGHT.ID, icon = img.ui.activity_icon_fight, description = i18n.global.activity_des_fight.string, tapFunc = function(l_1_0, l_1_1)
    l_1_0:removeAllChildrenWithCleanup(true)
    l_1_0:runAction(CCCallFunc:create(function()
      local scorefightlayer = require("ui.activity.scoreFight")
      local pop = scorefightlayer.create(addBan)
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.SCORE_TARVEN_4.ID = {id = IDS.SCORE_TARVEN_4.ID, group = IDS.SCORE_TARVEN_4.ID, icon = img.ui.activity_icon_tarven, description = i18n.global.activity_des_tarven.string, tapFunc = function(l_2_0, l_2_1)
    l_2_0:removeAllChildrenWithCleanup(true)
    l_2_0:runAction(CCCallFunc:create(function()
      local scoretarvenlayer = require("ui.activity.scoreTarven")
      local pop = scoretarvenlayer.create(addBan)
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.FORGE_1.ID = {id = IDS.FORGE_1.ID, group = IDS.FORGE_1.ID, icon = img.ui.activity_icon_forge, description = i18n.global.activity_des_forge.string, tapFunc = function(l_3_0, l_3_1)
    l_3_0:removeAllChildrenWithCleanup(true)
    l_3_0:runAction(CCCallFunc:create(function()
      local forgelayer = require("ui.activity.forge")
      local pop = forgelayer.create(addBan)
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}, IDS.CRUSHING_SPACE_1.ID = {id = IDS.CRUSHING_SPACE_1.ID, group = IDS.CRUSHING_SPACE_1.ID, icon = img.ui.activity_icon_crush1, description = i18n.global.broken_space_name1.string, tapFunc = function(l_4_0)
    l_4_0:removeAllChildrenWithCleanup(true)
    l_4_0:runAction(CCCallFunc:create(function()
      local crushboss1 = require("ui.activity.crushboss1")
      local pop = crushboss1.create()
      pop:setTouchEnabled(true)
      pop:setTouchSwallowEnabled(false)
      parent_obj:addChild(pop, 1000)
      end))
   end}}
end

ui.create = function(l_3_0)
  local all_items = getItems()
  local activity_items = {}
  local touch_items = {}
  local item_count = 0
  local padding = 5
  local item_width = 100
  local item_height = 120
  local init = function()
    do
      local groups = {}
      for _,tmp_item in pairs(all_items) do
        if tmp_item.group == IDS.SCORE_FIGHT.ID or tmp_item.group == IDS.SCORE_TARVEN_4.ID or tmp_item.group == IDS.FORGE_1.ID or tmp_item.group == IDS.CRUSHING_SPACE_1.ID or tmp_item.group == IDS.CRUSHING_SPACE_2.ID or tmp_item.group == IDS.CRUSHING_SPACE_3.ID then
          if groups[tmp_item.group] then
            for _,tmp_item in (for generator) do
            end
            groups[tmp_item.group] = tmp_item.group
            do
              local item_status = mactivityData.getStatusById(tmp_item.id)
              if item_status and item_status.status ~= 2 and item_status.cd and os.time() - mactivityData.pull_time < item_status.cd then
                upvalue_1536 = item_count + 1
                activity_items[item_count] = tmp_item
                activity_items[item_count].status = item_status
                for _,tmp_item in (for generator) do
                end
                if item_status and item_status.status ~= 2 and tmp_item.nocd then
                  upvalue_1536 = item_count + 1
                  activity_items[item_count] = tmp_item
                  activity_items[item_count].status = item_status
                  for _,tmp_item in (for generator) do
                  end
                  print("======================================if 3")
                end
                for _,tmp_item in (for generator) do
                end
                if groups[tmp_item.group] then
                  for _,tmp_item in (for generator) do
                  end
                  groups[tmp_item.group] = tmp_item.group
                  local item_status = mactivityData.getStatusById(tmp_item.id)
                  if item_status and item_status.status == 0 and item_status.cd and os.time() - mactivityData.pull_time < item_status.cd then
                    upvalue_1536 = item_count + 1
                    activity_items[item_count] = tmp_item
                    activity_items[item_count].status = item_status
                    for _,tmp_item in (for generator) do
                    end
                    if item_status and item_status.status == 0 and tmp_item.nocd then
                      upvalue_1536 = item_count + 1
                      activity_items[item_count] = tmp_item
                      activity_items[item_count].status = item_status
                      for _,tmp_item in (for generator) do
                      end
                      print("======================================if 3")
                    end
                    table.sort(activity_items, function(l_1_0, l_1_1)
                    return l_1_0.id < l_1_1.id
                           end)
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
  init()
  local layer = CCLayer:create()
  local content_layer = CCLayer:create()
  content_layer:setTouchEnabled(true)
  content_layer:setTouchSwallowEnabled(false)
  layer:addChild(content_layer, 100)
  local addBan = function(l_2_0, l_2_1)
    local ban = CCLayer:create()
    l_2_0:addChild(ban, 1000)
    ban:setTouchEnabled(true)
    ban:registerScriptTouchHandler(function(l_1_0, l_1_1, l_1_2)
      if l_1_0 == "began" then
        local pscroll = banlayer:getParent():getParent().scroll
        local p0 = pscroll:getParent():convertToNodeSpace(ccp(l_1_1, l_1_2))
        local p1 = (banscroll:getParent():convertToNodeSpace(ccp(l_1_1, l_1_2)))
        local p2 = nil
        if mact_btn then
          p2 = mact_btn:getParent():convertToNodeSpace(ccp(l_1_1, l_1_2))
        end
        if pscroll:boundingBox():containsPoint(p0) or banscroll:boundingBox():containsPoint(p1) or mact_btn and mact_btn:boundingBox():containsPoint(p2) then
          ban:setTouchSwallowEnabled(false)
        else
          ban:setTouchSwallowEnabled(true)
        end
        return true
      end
      end)
   end
  local backEvent = function()
   end
  local createItem = function(l_4_0)
    local tmp_item = img.createUISprite(img.ui.activity_home_item_bg2)
    local tmp_item_w = tmp_item:getContentSize().width
    local tmp_item_h = tmp_item:getContentSize().height
    local tmp_item_sel = img.createUISprite(img.ui.activity_home_item_bg1)
    tmp_item_sel:setPosition(CCPoint(tmp_item_w / 2, tmp_item_h / 2))
    tmp_item:addChild(tmp_item_sel)
    tmp_item.sel = tmp_item_sel
    tmp_item_sel:setVisible(false)
    local tmp_item_bg = img.createUISprite(img.ui.activity_home_item_bg3)
    tmp_item_bg:setPosition(tmp_item_w, tmp_item_h / 2)
    tmp_item_bg:setAnchorPoint(1, 0.5)
    tmp_item:addChild(tmp_item_bg)
    local item_icon = img.createUISprite(l_4_0.icon)
    item_icon:setPosition(CCPoint(43, tmp_item_h / 2 + 3))
    tmp_item:addChild(item_icon, 1)
    local lbl_description = lbl.create({font = 1, size = 14, text = l_4_0.description, color = ccc3(115, 59, 5), cn = {size = 16}, us = {size = 14}, tw = {size = 16}, fr = {size = 12}})
    local flag = img.createUISprite(img.ui.activity_home_icon_bg)
    flag:setAnchorPoint(0, 1)
    flag:setPosition(0, tmp_item_h)
    flag:setVisible(false)
    tmp_item:addChild(flag, 2)
    tmp_item.flag = flag
    if l_4_0.nocd then
      lbl_description:setAnchorPoint(CCPoint(0, 0.5))
      lbl_description:setPosition(CCPoint(94, tmp_item_h / 2))
    else
      lbl_description:setAnchorPoint(CCPoint(0, 0))
      lbl_description:setPosition(CCPoint(94, tmp_item_h / 2))
    end
    tmp_item:addChild(lbl_description, 2)
    local lbl_cd = lbl.create({font = 2, size = 10, text = "", color = ccc3(181, 244, 59), cn = {size = 14}, us = {size = 12}, tw = {size = 14}})
    lbl_cd:setAnchorPoint(CCPoint(0, 1))
    lbl_cd:setPosition(CCPoint(94, tmp_item_h / 2 - 2))
    tmp_item:addChild(lbl_cd, 1)
    tmp_item.lbl_cd = lbl_cd
    addRedDot(tmp_item, {px = tmp_item:getContentSize().width - 5, py = tmp_item:getContentSize().height - 10})
    delRedDot(tmp_item)
    return tmp_item
   end
  local lineScroll = require("ui.lineScroll")
  local scroll_params = {width = 334, height = 441}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(scalep(1, 9))
  scroll:setScale(view.minScale)
  layer:addChild(scroll)
  layer.scroll = scroll
  local showList = function(l_5_0)
    for ii = 1,  l_5_0 do
      if ii == 1 then
        scroll.addSpace(4)
      end
      local tmp_item = createItem(l_5_0[ii])
      touch_items[ touch_items + 1] = tmp_item
      tmp_item.obj = l_5_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = 167
      scroll.addItem(tmp_item)
      if ii ~= item_count then
        scroll.addSpace(padding - 3)
      end
    end
   end
  showList(activity_items)
  scroll.setOffsetBegin()
  layer.onAndroidBack = function()
    backEvent()
   end
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(false)
  layer:registerScriptHandler(function(l_7_0)
    if l_7_0 == "enter" then
      do return end
    end
    if l_7_0 == "exit" then
       -- Warning: missing end command somewhere! Added here
    end
   end)
  local last_touch_sprite, last_sel_sprite = nil, nil
  local clearShaderForItem = function(l_8_0)
    if l_8_0 and not tolua.isnull(l_8_0) then
      clearShader(l_8_0, true)
      l_8_0 = nil
    end
   end
  local setShaderForItem = function(l_9_0)
    setShader(l_9_0, SHADER_HIGHLIGHT, true)
    last_touch_sprite = l_9_0
   end
  local touchbeginx, touchbeginy, isclick = nil, nil, nil
  local onTouchBegan = function(l_10_0, l_10_1)
    touchbeginx, upvalue_512 = l_10_0, l_10_1
    upvalue_1024 = true
    if not scroll or tolua.isnull(scroll) then
      return true
    end
    local p1 = scroll.content_layer:convertToNodeSpace(ccp(l_10_0, l_10_1))
    for ii = 1,  touch_items do
      if touch_items[ii]:boundingBox():containsPoint(p1) then
        upvalue_2560 = touch_items[ii]
      end
    end
    return true
   end
  local onTouchMoved = function(l_11_0, l_11_1)
    if isclick and (math.abs(touchbeginx - l_11_0) > 10 or math.abs(touchbeginy - l_11_1) > 10) then
      isclick = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_12_0, l_12_1)
    if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
      last_touch_sprite = nil
    end
    local p0 = layer:convertToNodeSpace(ccp(l_12_0, l_12_1))
    if isclick and false then
      backEvent()
    elseif isclick then
      local p1 = scroll.content_layer:convertToNodeSpace(ccp(l_12_0, l_12_1))
      for ii = 1,  touch_items do
        if touch_items[ii]:boundingBox():containsPoint(p1) then
          if last_sel_sprite and last_sel_sprite == touch_items[ii] then
            return 
          elseif last_sel_sprite and not tolua.isnull(last_sel_sprite) then
            if last_sel_sprite.sel and not tolua.isnull(last_sel_sprite.sel) then
              last_sel_sprite.sel:setVisible(false)
            end
            if last_sel_sprite.flag and not tolua.isnull(last_sel_sprite.flag) then
              last_sel_sprite.flag:setVisible(false)
            end
          end
          audio.play(audio.button)
          touch_items[ii].sel:setVisible(true)
          touch_items[ii].flag:setVisible(true)
          touch_items[ii].obj.tapFunc(content_layer, addBan)
          upvalue_3072 = touch_items[ii]
          if touch_items[ii].obj.status then
            touch_items[ii].obj.status.read = 1
          end
        end
      end
    end
   end
  local onTouch = function(l_13_0, l_13_1, l_13_2)
    if l_13_0 == "began" then
      return onTouchBegan(l_13_1, l_13_2)
    elseif l_13_0 == "moved" then
      return onTouchMoved(l_13_1, l_13_2)
    else
      return onTouchEnded(l_13_1, l_13_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  local last_check_time = 0
  local updateCountDown = function()
    if os.time() - last_check_time < 1 then
      return 
    end
    last_check_time = os.time()
    for ii = 1,  touch_items do
      local item_status = touch_items[ii].obj.status
      if item_status.cd and item_status.cd < os.time() - mactivityData.pull_time then
        item_status.status = 1
        refreshSelf(layer)
      elseif item_status.cd then
        local count_down = item_status.cd - (os.time() - mactivityData.pull_time)
        local time_str = time2string(count_down)
        if count_down <= 2592000 then
          touch_items[ii].lbl_cd:setString(time_str)
        end
      end
      local tmp_status = item_status
      if tmp_status and tmp_status.read and tmp_status.read == 0 then
        addRedDot(touch_items[ii], {px = touch_items[ii]:getContentSize().width - 5, py = touch_items[ii]:getContentSize().height - 10})
      else
        delRedDot(touch_items[ii])
      end
    end
   end
  local onUpdate = function(l_15_0)
    updateCountDown()
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  local showActivity = function(l_16_0)
    if touch_items[l_16_0].sel and not tolua.isnull(touch_items[l_16_0].sel) then
      touch_items[l_16_0].sel:setVisible(true)
    end
    if touch_items[l_16_0].flag and not tolua.isnull(touch_items[l_16_0].flag) then
      touch_items[l_16_0].flag:setVisible(true)
    end
    touch_items[l_16_0].obj.tapFunc(content_layer, addBan)
    upvalue_1536 = touch_items[l_16_0]
    if touch_items[l_16_0].obj.status then
      touch_items[l_16_0].obj.status.read = 1
    end
   end
  if  touch_items > 0 then
    if l_3_0 then
      for i = 1,  touch_items do
        if l_3_0 == "brokenboss" and touch_items[i].obj.id == IDS.CRUSHING_SPACE_1.ID then
          showActivity(i)
        end
      end
    else
      showActivity(1)
    end
  end
  return layer
end

return ui

