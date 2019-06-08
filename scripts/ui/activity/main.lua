-- Command line was: E:\github\dhgametool\scripts\ui\activity\main.lua 

local listlayer = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local player = require("data.player")
local activityData = require("data.activity")
local monthloginData = require("data.monthlogin")
local shopData = require("data.shop")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local IDS = activityData.IDS
local refreshSelf = function(l_1_0)
  if not l_1_0 or tolua.isnull(l_1_0) then
    return 
  end
  local self_layer = l_1_0:getParent()
  if self_layer and not tolua.isnull(self_layer) then
    local parent_obj = self_layer:getParent()
    self_layer:removeFromParentAndCleanup(true)
    parent_obj:addChild(require("ui.activity.main").create(), 1000)
  end
end

local getItems = function()
  return {IDS.MONTH_LOGIN.ID = {id = IDS.MONTH_LOGIN.ID, group = IDS.MONTH_LOGIN.ID, icon = img.ui.login_month_icon, description = i18n.global.activity_des_login.string, nocd = true, redFunc = monthloginData.showRedDot, tapFunc = function(l_1_0)
    l_1_0:removeAllChildrenWithCleanup(true)
    local monthLoginlayer = require("ui.monthlogin.main")
    local pop = monthLoginlayer.create(function()
      refreshSelf(parent_obj)
      end)
    pop:setTouchEnabled(true)
    pop:setTouchSwallowEnabled(false)
    l_1_0:addChild(pop, 1000)
   end}, IDS.MONTH_CARD.ID = {id = IDS.MONTH_CARD.ID, group = IDS.MONTH_CARD.ID, icon = img.ui.activity_icon_mcard, description = i18n.global.activity_des_mcard_i.string, nocd = true, redFunc = shopData.showRedDot, tapFunc = function(l_2_0)
    l_2_0:removeAllChildrenWithCleanup(true)
    local mcardlayer = require("ui.mcard.main")
    local pop = mcardlayer.create(function()
      refreshSelf(parent_obj)
      end)
    pop:setTouchEnabled(true)
    pop:setTouchSwallowEnabled(false)
    l_2_0:addChild(pop, 1000)
    shopData.read6()
   end}, IDS.MINI_CARD.ID = {id = IDS.MINI_CARD.ID, group = IDS.MINI_CARD.ID, icon = img.ui.activity_icon_mini, description = i18n.global.activity_des_mini_i.string, nocd = true, redFunc = shopData.showRedDot2, tapFunc = function(l_3_0)
    l_3_0:removeAllChildrenWithCleanup(true)
    local mcardlayer = require("ui.minicard.main")
    local pop = mcardlayer.create(function()
      refreshSelf(parent_obj)
      end)
    pop:setTouchEnabled(true)
    pop:setTouchSwallowEnabled(false)
    l_3_0:addChild(pop, 1000)
    shopData.read32()
   end}, IDS.CDKEY.ID = {id = IDS.CDKEY.ID, group = IDS.CDKEY.ID, icon = img.ui.activity_icon_cdkey, description = i18n.global.activity_des_cdkey.string, nocd = true, tapFunc = function(l_4_0)
    l_4_0:removeAllChildrenWithCleanup(true)
    l_4_0:addChild(require("ui.activity.cdkey").create(), 1000)
   end}, IDS.WEEKLY_GIFT.ID = {id = IDS.WEEKLY_GIFT.ID, group = IDS.WEEKLY_GIFT.ID, icon = img.ui.activity_icon_weekly_gift, description = i18n.global.activity_des_weekly_gift.string, redFunc = require("ui.activity.weeklygift").showRedDot, tapFunc = function(l_5_0)
    l_5_0:removeAllChildrenWithCleanup(true)
    l_5_0:addChild(require("ui.activity.weeklygift").create(), 1000)
   end}, IDS.MONTHLY_GIFT.ID = {id = IDS.MONTHLY_GIFT.ID, group = IDS.MONTHLY_GIFT.ID, icon = img.ui.activity_icon_monthly_gift, description = i18n.global.activity_des_monthly_gift.string, redFunc = require("ui.activity.monthlygift").showRedDot, tapFunc = function(l_6_0)
    l_6_0:removeAllChildrenWithCleanup(true)
    l_6_0:addChild(require("ui.activity.monthlygift").create(), 1000)
   end}}
end

listlayer.create = function()
  local all_items = getItems()
  local activity_items = {}
  local touch_items = {}
  local item_count = 0
  local padding = 5
  local item_width = 290
  local item_height = 70
  local init = function()
    local groups = {}
    for _,tmp_item in pairs(all_items) do
      if tmp_item.group then
        if groups[tmp_item.group] then
          for _,tmp_item in (for generator) do
          end
          local item_status = activityData.getStatusById(tmp_item.id)
          if item_status then
            tbl2string(item_status)
          end
          if item_status and item_status.status == 0 and item_status.cd and os.time() - activityData.pull_time < item_status.cd then
            upvalue_1024 = item_count + 1
            activity_items[item_count] = tmp_item
            activity_items[item_count].status = item_status
            groups[tmp_item.group] = tmp_item.group
            for _,tmp_item in (for generator) do
            end
            if item_status and item_status.status == 0 and tmp_item.nocd then
              upvalue_1024 = item_count + 1
              activity_items[item_count] = tmp_item
              activity_items[item_count].status = item_status
              groups[tmp_item.group] = tmp_item.group
              for _,tmp_item in (for generator) do
              end
              print("======================================if 3")
            end
          end
          do
            local sortValue = function(l_1_0)
            if l_1_0.id == IDS.MONTH_LOGIN.ID then
              return 100000
            else
              if l_1_0.id == IDS.MONTH_CARD.ID then
                return 99999
              else
                if l_1_0.id == IDS.MINI_CARD.ID then
                  return 99998
                else
                  return l_1_0.id
                end
              end
            end
               end
            table.sort(activity_items, function(l_2_0, l_2_1)
            return sortValue(l_2_1) < sortValue(l_2_0)
               end)
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
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY * 0.8))
  layer:addChild(darkbg)
  local moneybar = require("ui.moneybar")
  layer:addChild(moneybar.create(), 101)
  local content_layer = CCLayer:create()
  content_layer:setTouchEnabled(true)
  content_layer:setTouchSwallowEnabled(false)
  layer:addChild(content_layer, 100)
  local board = img.createUISprite(img.ui.activity_board)
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0.5, 0))
  board:setPosition(scalep(480, 0))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local backEvent = function()
    layer:removeFromParent()
   end
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setScale(view.minScale)
  btn_close:setPosition(scalep(928, 502))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  layer:addChild(btn_close_menu, 100)
  btn_close:registerScriptTapHandler(function()
    audio.play(audio.button)
    backEvent()
   end)
  local bar_icon = img.createUISprite(img.ui.activity_bar_icon)
  bar_icon:setAnchorPoint(CCPoint(0.5, 0))
  bar_icon:setPosition(CCPoint(200, 484))
  board:addChild(bar_icon)
  local lbl_bar = lbl.createFont2(22, i18n.global.activity_board_title.string, ccc3(250, 216, 105))
  lbl_bar:setPosition(CCPoint(200, 471))
  board:addChild(lbl_bar)
  local createItem = function(l_4_0)
    local tmp_item = img.createUISprite(img.ui.activity_item_bg)
    local tmp_item_w = tmp_item:getContentSize().width
    local tmp_item_h = tmp_item:getContentSize().height
    local tmp_item_sel = img.createUISprite(img.ui.activity_item_bg_sel)
    tmp_item_sel:setPosition(CCPoint(tmp_item_w / 2, tmp_item_h / 2))
    tmp_item:addChild(tmp_item_sel)
    tmp_item.sel = tmp_item_sel
    tmp_item_sel:setVisible(false)
    local item_icon = img.createUISprite(l_4_0.icon)
    item_icon:setPosition(CCPoint(40, tmp_item_h / 2))
    tmp_item:addChild(item_icon, 10)
    local lbl_description = lbl.create({font = 1, size = 12, text = l_4_0.description, color = ccc3(115, 59, 5), cn = {size = 16}, us = {size = 14}, tw = {size = 16}})
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
    tmp_item:addChild(lbl_cd)
    tmp_item.lbl_cd = lbl_cd
    addRedDot(tmp_item, {px = tmp_item:getContentSize().width - 5, py = tmp_item:getContentSize().height - 10})
    delRedDot(tmp_item)
    return tmp_item
   end
  local lineScroll = require("ui.lineScroll")
  local scroll_params = {width = 290, height = 359}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(53, 74))
  board:addChild(scroll)
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
      tmp_item.px = 145
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
  layer:setTouchSwallowEnabled(true)
  addBackEvent(layer)
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
    if item_count == 0 then
       -- Warning: missing end command somewhere! Added here
    end
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_9_0)
    if l_9_0 == "enter" then
      onEnter()
    elseif l_9_0 == "exit" then
      onExit()
    end
   end)
  local last_touch_sprite, last_sel_sprite = nil, nil
  local clearShaderForItem = function(l_10_0)
    if l_10_0 and not tolua.isnull(l_10_0) then
      clearShader(l_10_0, true)
      l_10_0 = nil
    end
   end
  local setShaderForItem = function(l_11_0)
    setShader(l_11_0, SHADER_HIGHLIGHT, true)
    last_touch_sprite = l_11_0
   end
  local touchbeginx, touchbeginy, isclick = nil, nil, nil
  local onTouchBegan = function(l_12_0, l_12_1)
    touchbeginx, upvalue_512 = l_12_0, l_12_1
    upvalue_1024 = true
    if not scroll or tolua.isnull(scroll) then
      return true
    end
    local p1 = scroll.content_layer:convertToNodeSpace(ccp(l_12_0, l_12_1))
    for ii = 1,  touch_items do
      if touch_items[ii]:boundingBox():containsPoint(p1) then
        upvalue_2560 = touch_items[ii]
      end
    end
    return true
   end
  local onTouchMoved = function(l_13_0, l_13_1)
    if isclick and (math.abs(touchbeginx - l_13_0) > 10 or math.abs(touchbeginy - l_13_1) > 10) then
      isclick = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_14_0, l_14_1)
    if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
      last_touch_sprite = nil
    end
    local p0 = layer:convertToNodeSpace(ccp(l_14_0, l_14_1))
    if isclick and not board:boundingBox():containsPoint(p0) then
      backEvent()
    elseif isclick then
      local p1 = scroll.content_layer:convertToNodeSpace(ccp(l_14_0, l_14_1))
      for ii = 1,  touch_items do
        if touch_items[ii]:boundingBox():containsPoint(p1) then
          if last_sel_sprite and last_sel_sprite == touch_items[ii] then
            return 
          elseif last_sel_sprite and not tolua.isnull(last_sel_sprite) and last_sel_sprite.sel and not tolua.isnull(last_sel_sprite.sel) then
            last_sel_sprite.sel:setVisible(false)
          end
          audio.play(audio.button)
          touch_items[ii].sel:setVisible(true)
          touch_items[ii].obj.tapFunc(content_layer)
          upvalue_3584 = touch_items[ii]
          if touch_items[ii].obj.status then
            touch_items[ii].obj.status.read = 1
          end
        end
      end
    end
   end
  local onTouch = function(l_15_0, l_15_1, l_15_2)
    if l_15_0 == "began" then
      return onTouchBegan(l_15_1, l_15_2)
    elseif l_15_0 == "moved" then
      return onTouchMoved(l_15_1, l_15_2)
    else
      return onTouchEnded(l_15_1, l_15_2)
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
      if item_status.status == 0 then
        if item_status.cd and item_status.cd < os.time() - activityData.pull_time then
          item_status.status = 1
          refreshSelf(content_layer)
        elseif item_status.cd then
          local count_down = item_status.cd - (os.time() - activityData.pull_time)
          local time_str = time2string(count_down)
          touch_items[ii].lbl_cd:setString(time_str)
        end
      end
      local tmp_status = item_status
      if touch_items[ii].obj.redFunc then
        if touch_items[ii].obj.redFunc() then
          addRedDot(touch_items[ii], {px = touch_items[ii]:getContentSize().width - 5, py = touch_items[ii]:getContentSize().height - 10})
        else
          delRedDot(touch_items[ii])
        end
      elseif tmp_status and tmp_status.read and tmp_status.read == 0 then
        addRedDot(touch_items[ii], {px = touch_items[ii]:getContentSize().width - 5, py = touch_items[ii]:getContentSize().height - 10})
      else
        delRedDot(touch_items[ii])
      end
    end
   end
  local onUpdate = function(l_17_0)
    updateCountDown()
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  if  touch_items > 0 then
    if touch_items[1].sel and not tolua.isnull(touch_items[1].sel) then
      touch_items[1].sel:setVisible(true)
    end
    touch_items[1].obj.tapFunc(content_layer)
    last_sel_sprite = touch_items[1]
    if touch_items[1].obj.status then
      touch_items[1].obj.status.read = 1
    end
  end
  return layer
end

return listlayer

