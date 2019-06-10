-- Command line was: E:\github\dhgametool\scripts\ui\hook\team.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local cfghooklock = require("config.hooklock")
local player = require("data.player")
local bagdata = require("data.bag")
local herodata = require("data.heros")
local hookdata = require("data.hook")
local i18n = require("res.i18n")
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, 0))
  layer:addChild(darkbg)
  local board_bg = img.createUI9Sprite(img.ui.dialog_1)
  board_bg:setPreferredSize(CCSizeMake(827, 410))
  board_bg:setScale(view.minScale)
  board_bg:setAnchorPoint(CCPoint(0.5, 0))
  board_bg:setPosition(view.midX, view.minY + 127 * view.minScale)
  layer:addChild(board_bg)
  local board_bg_w = board_bg:getContentSize().width
  local board_bg_h = board_bg:getContentSize().height
  local list_board = img.createUI9Sprite(img.ui.tips_bg)
  list_board:setPreferredSize(CCSizeMake(954, 125))
  list_board:setScale(view.minScale)
  list_board:setAnchorPoint(CCPoint(0.5, 1))
  list_board:setPosition(CCPoint(view.midX, view.minY + 0 * view.minScale))
  layer:addChild(list_board)
  local anim_duration = 0.2
  board_bg:setPosition(CCPoint(view.midX, view.minY + 576 * view.minScale))
  board_bg:runAction(CCMoveTo:create(anim_duration, CCPoint(view.midX, view.minY + 130 * view.minScale)))
  list_board:runAction(CCMoveTo:create(anim_duration, CCPoint(view.midX, view.minY + 123 * view.minScale)))
  darkbg:runAction(CCFadeTo:create(anim_duration, POPUP_DARK_OPACITY))
  local backEvent = function()
    audio.play(audio.button)
    local act_array = CCArray:create()
    act_array:addObject(CCCallFunc:create(function()
      board_bg:runAction(CCMoveTo:create(anim_duration, CCPoint(view.midX, view.minY + 576 * view.minScale)))
      end))
    act_array:addObject(CCCallFunc:create(function()
      list_board:runAction(CCMoveTo:create(anim_duration, CCPoint(view.midX, view.minY + 0 * view.minScale)))
      end))
    act_array:addObject(CCCallFunc:create(function()
      darkbg:runAction(CCFadeTo:create(anim_duration, 0))
      end))
    act_array:addObject(CCDelayTime:create(anim_duration))
    act_array:addObject(CCCallFunc:create(function()
      layer:removeFromParentAndCleanup(true)
      end))
    layer:runAction(CCSequence:create(act_array))
   end
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(board_bg_w - 25, board_bg_h - 28))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  board_bg:addChild(btn_close_menu, 100)
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local lbl_title = lbl.createFont1(24, i18n.global.hook_team_board_title.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 29))
  board_bg:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.hook_team_board_title.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 31))
  board_bg:addChild(lbl_title_shadowD)
  local board = img.createUI9Sprite(img.ui.select_hero_camp_bg)
  board:setPreferredSize(CCSizeMake(770, 248))
  board:setAnchorPoint(CCPoint(0.5, 0))
  board:setPosition(CCPoint(board_bg_w / 2, 94))
  board_bg:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local board_tab = img.createUI9Sprite(img.ui.select_tab_tab_bg)
  board_tab:setPreferredSize(CCSizeMake(760, 38))
  board_tab:setAnchorPoint(CCPoint(0.5, 1))
  board_tab:setPosition(CCPoint(board_w / 2, board_h - 4))
  board:addChild(board_tab)
  local power_bg = img.createUISprite(img.ui.select_hero_power_bg)
  power_bg:setAnchorPoint(CCPoint(0, 0.5))
  power_bg:setPosition(CCPoint(0, board_tab:getContentSize().height / 2))
  board_tab:addChild(power_bg)
  local power_icon = img.createUISprite(img.ui.power_icon)
  power_icon:setScale(0.5)
  power_icon:setPosition(CCPoint(30, power_bg:getContentSize().height / 2))
  power_bg:addChild(power_icon)
  local lbl_power = lbl.createFont2(20, "0")
  lbl_power:setAnchorPoint(CCPoint(0, 0.5))
  lbl_power:setPosition(CCPoint(55, power_bg:getContentSize().height / 2))
  power_bg:addChild(lbl_power)
  local btn_confirm0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_confirm0:setPreferredSize(CCSizeMake(216, 52))
  local lbl_confirm = lbl.createFont1(22, i18n.global.hook_team_save.string, ccc3(115, 59, 5))
  lbl_confirm:setPosition(CCPoint(btn_confirm0:getContentSize().width / 2, btn_confirm0:getContentSize().height / 2))
  btn_confirm0:addChild(lbl_confirm)
  local btn_confirm = SpineMenuItem:create(json.ui.button, btn_confirm0)
  btn_confirm:setPosition(CCPoint(board_bg_w / 2, 53))
  local btn_confirm_menu = CCMenu:createWithItem(btn_confirm)
  btn_confirm_menu:setPosition(CCPoint(0, 0))
  board_bg:addChild(btn_confirm_menu)
  local createHeroHead = function(l_3_0)
    local headBg = img.createUISprite(img.ui.select_hero_hero_bg)
    local headBg_w = headBg:getContentSize().width
    local headBg_h = headBg:getContentSize().height
    if l_3_0 then
      local headIcon = img.createHeroHeadByHid(l_3_0)
      headIcon:setScale(0.9)
      headIcon:setPosition(CCPoint(headBg_w / 2, headBg_h / 2))
      headBg:addChild(headIcon)
      headBg.headIcon = headIcon
    end
    return headBg
   end
  local createLock = function()
    local headBg = img.createUISprite(img.ui.select_hero_hero_bg)
    local headBg_w = headBg:getContentSize().width
    local headBg_h = headBg:getContentSize().height
    local btn_lock = img.createUISprite(img.ui.hook_icon_lock)
    btn_lock:setPosition(CCPoint(headBg_w / 2, headBg_h / 2))
    headBg:addChild(btn_lock)
    return headBg
   end
  local dealSelHids = function(l_5_0)
    arrayfilter(l_5_0, herodata.find)
   end
  local sel_items = {}
  local unlock_items = {}
  local max_heroes = hookdata.getMaxHeroes()
  dealSelHids(hookdata.hids)
  if not hookdata.hids then
    local sel_hids = clone({})
  end
  local offset_x = 62
  local offset_y = 150
  local step_x = 92
  local step_y = 92
  for ii = 1, 16 do
    local tmp_item = nil
    if ii <= max_heroes then
      if sel_hids[ii] then
        tmp_item = createHeroHead(sel_hids[ii])
        tmp_item.hid = sel_hids[ii]
        sel_items[#sel_items + 1] = tmp_item
      else
        tmp_item = createHeroHead()
        sel_items[#sel_items + 1] = tmp_item
      end
    else
      tmp_item = createLock()
      tmp_item.idx = ii
      unlock_items[#unlock_items + 1] = tmp_item
    end
  end
  local pos_x = offset_x + (ii - 1) % 8 * step_x
  local pos_y = offset_y - step_y * (math.floor((ii + 8 - 1) / 8) - 1)
  tmp_item:setPosition(CCPoint(pos_x, pos_y))
  board:addChild(tmp_item)
end
local findUnlockLv = function(l_6_0)
  for ii = 1, #cfghooklock do
    if l_6_0 <= cfghooklock[ii].unlock then
      return ii
    end
  end
end

local showUnlock = function(l_7_0)
  if not l_7_0 then
    return 
  end
  audio.play(audio.button)
  showToast(string.format(i18n.global.func_need_lv.string, l_7_0))
end

local updatePower = function()
  lbl_power:setString(hookdata.getAllPower(sel_hids))
end

updatePower()
local SCROLL_VIEW_W = 937
local SCROLL_VIEW_H = 130
local scroll = CCScrollView:create()
scroll:setDirection(kCCScrollViewDirectionHorizontal)
scroll:setViewSize(CCSize(SCROLL_VIEW_W, SCROLL_VIEW_H))
scroll:setContentSize(CCSize(SCROLL_VIEW_W, SCROLL_VIEW_H))
scroll:setAnchorPoint(CCPoint(0, 0))
scroll:setPosition(CCPoint(9, -7))
list_board:addChild(scroll)
local content_layer = CCLayer:create()
content_layer:setAnchorPoint(CCPoint(0, 0))
content_layer:setPosition(CCPoint(0, 0))
scroll:getContainer():addChild(content_layer)
scroll.content_layer = content_layer
local createListHeroHead = function(l_9_0)
  local headBg = img.createUISprite(img.ui.herolist_head_bg)
  local headBg_w = headBg:getContentSize().width
  local headBg_h = headBg:getContentSize().height
  local headIcon = img.createHeroHeadByHid(l_9_0.hid)
  headIcon:setPosition(CCPoint(headBg_w / 2, headBg_h / 2))
  headBg:addChild(headIcon)
  local head_mask = img.createUISprite(img.ui.hook_btn_mask)
  head_mask:setPosition(CCPoint(headBg_w / 2, headBg_h / 2))
  headBg:addChild(head_mask)
  local icon_sel = img.createUISprite(img.ui.hook_btn_sel)
  icon_sel:setPosition(CCPoint(head_mask:getContentSize().width / 2, head_mask:getContentSize().height / 2))
  head_mask:addChild(icon_sel)
  headBg.head_mask = head_mask
  if l_9_0.isSelected then
    head_mask:setVisible(true)
  else
    head_mask:setVisible(false)
  end
  return headBg
end

local findHeroFromList = function(l_10_0, l_10_1)
  if not l_10_0 then
    return 
  end
  for ii = 1, #l_10_0 do
    if l_10_0[ii].hid == l_10_1 then
      return l_10_0[ii]
    end
  end
end

local initHeroList = function(l_11_0)
  if not sel_hids or #sel_hids <= 0 then
    return 
  end
  for ii = 1, #sel_hids do
    local _h = findHeroFromList(l_11_0, sel_hids[ii])
    if _h then
      _h.isSelected = true
  else
    end
  end
end

local hero_items = {}
local item_offset_x = 54
local item_offset_y = list_board:getContentSize().height / 2 + 7
local item_step_x = 100
local item_step_y = 0
local showHeroList = function()
  arrayclear(hero_items)
  content_layer:removeAllChildrenWithCleanup(true)
  local hero_list = clone(herodata)
  table.sort(hero_list, compareHero)
  hero_list = herolistless(hero_list, sel_hids)
  initHeroList(hero_list)
  local list_width = 0
  for ii = 1, #hero_list do
    local tmp_item = createListHeroHead(hero_list[ii])
    tmp_item.heroObj = hero_list[ii]
    local pos_x = item_offset_x + item_step_x * (ii - 1)
    local pos_y = item_offset_y
    tmp_item:setPosition(CCPoint(pos_x, pos_y))
    content_layer:addChild(tmp_item)
    hero_items[#hero_items + 1] = tmp_item
    list_width = pos_x + 67
  end
  if list_width < SCROLL_VIEW_W then
    scroll:setContentSize(CCSizeMake(SCROLL_VIEW_W, SCROLL_VIEW_H))
    content_layer:setPosition(CCPoint(0, 0))
    scroll:setContentOffset(CCPoint(0, 0))
  else
    scroll:setContentSize(CCSizeMake(list_width, SCROLL_VIEW_H))
    content_layer:setPosition(CCPoint(0, 0))
    scroll:setContentOffset(CCPoint(0, 0))
  end
end

showHeroList()
local findFirstBlank = function()
  for ii = 1, #sel_items do
    if not sel_items[ii].hid then
      return sel_items[ii]
    end
  end
end

local touchHead = function(l_14_0, l_14_1)
  local headIcon = img.createHeroHeadByHid(l_14_1)
  headIcon:setScale(0.9)
  headIcon:setPosition(CCPoint(l_14_0:getContentSize().width / 2, l_14_0:getContentSize().height / 2))
  l_14_0:addChild(headIcon)
  l_14_0.hid = l_14_1
  l_14_0.headIcon = headIcon
end

local detouchHead = function(l_15_0)
  for ii = 1, #sel_hids do
    if sel_hids[ii] == l_15_0.hid then
      table.remove(sel_hids, ii)
  else
    end
  end
  if l_15_0.headIcon and not tolua.isnull(l_15_0.headIcon) then
    l_15_0.headIcon:removeFromParentAndCleanup(true)
    l_15_0.headIcon = nil
    l_15_0.hid = nil
  end
end

local below2above = function(l_16_0)
  if l_16_0.heroObj.isSelected then
    return 
  end
  local blank_item = findFirstBlank()
  if not blank_item then
    return 
  end
  l_16_0.head_mask:setVisible(true)
  l_16_0.heroObj.isSelected = true
  sel_hids[#sel_hids + 1] = l_16_0.heroObj.hid
  sel_items[#sel_items + 1] = blank_item
  touchHead(blank_item, l_16_0.heroObj.hid)
end

local findFromBelowList = function(l_17_0)
  for ii = 1, #hero_items do
    if hero_items[ii].heroObj.hid == l_17_0 then
      return hero_items[ii]
    end
  end
end

local findFromAboveList = function(l_18_0)
  for ii = 1, #sel_items do
    if sel_items[ii].hid and sel_items[ii].hid == l_18_0 then
      return sel_items[ii]
    end
  end
end

local above2below = function(l_19_0)
  if l_19_0.hid then
    local tmp_hid = l_19_0.hid
    detouchHead(l_19_0)
    local listObj = findFromBelowList(tmp_hid)
    if listObj then
      listObj.head_mask:setVisible(false)
      listObj.heroObj.isSelected = false
    end
  end
end

local teamChange = function(l_20_0)
  if not hookdata.status or hookdata.status ~= 0 then
    local params = {sid = player.sid, hids = l_20_0}
    addWaitNet()
    hookdata.hook_init(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      hookdata.init(l_1_0.hook)
      if callback then
        callback()
      end
      backEvent()
      end)
  else
    local params = {sid = player.sid, hids = l_20_0}
    addWaitNet()
    hookdata.hook_heroes(params, function(l_2_0)
      delWaitNet()
      tbl2string(l_2_0)
      if l_2_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_2_0.status))
        btn_confirm:setEnabled(true)
        return 
      end
      require("data.tutorial").goNext("hook2", 1, true)
      arrayclear(hookdata.hids)
      hookdata.hids = clone(_hids)
      hookdata.ids = {}
      for ii = 1, #hookdata.hids do
        hookdata.ids[ii] = hid2id(hookdata.hids[ii])
      end
      if callback then
        callback(true)
      end
      backEvent()
      end)
  end
end

btn_confirm:registerScriptTapHandler(function()
  btn_confirm:setEnabled(false)
  if not sel_hids or #sel_hids <= 0 then
    showToast(i18n.global.hook_team_empty.string)
    btn_confirm:setEnabled(true)
    return 
  end
  teamChange(sel_hids)
end
)
local onClickBelowItem = function(l_22_0)
  if l_22_0.heroObj.isSelected then
    local _above_obj = findFromAboveList(l_22_0.heroObj.hid)
    if _above_obj then
      above2below(_above_obj)
      updatePower()
    else
      below2above(l_22_0)
      updatePower()
    end
  end
end

local onClickAboveItem = function(l_23_0)
  above2below(l_23_0)
  updatePower()
end

local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
local onTouchBegan = function(l_24_0, l_24_1)
  touchbeginx, upvalue_512 = l_24_0, l_24_1
  upvalue_1024 = true
  if scroll and not tolua.isnull(scroll) then
    local pp0 = list_board:convertToNodeSpace(ccp(l_24_0, l_24_1))
    local p0 = content_layer:convertToNodeSpace(ccp(l_24_0, l_24_1))
    for ii = 1, #hero_items do
      if hero_items[ii]:boundingBox():containsPoint(p0) then
        playAnimTouchBegin(hero_items[ii])
        upvalue_3584 = hero_items[ii]
    else
      end
    end
    local p1 = board:convertToNodeSpace(ccp(l_24_0, l_24_1))
    for ii = 1, #sel_items do
      if sel_items[ii]:boundingBox():containsPoint(p1) then
        playAnimTouchBegin(sel_items[ii])
        upvalue_3584 = sel_items[ii]
    else
      end
    end
  end
  return true
end

local onTouchMoved = function(l_25_0, l_25_1)
  if isclick and (math.abs(touchbeginx - l_25_0) > 10 or math.abs(touchbeginy - l_25_1) > 10) then
    isclick = false
    if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
      playAnimTouchEnd(last_touch_sprite)
      upvalue_1536 = nil
    end
  end
end

local onTouchEnded = function(l_26_0, l_26_1)
  if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
    playAnimTouchEnd(last_touch_sprite)
    last_touch_sprite = nil
  end
  if isclick and scroll and not tolua.isnull(scroll) then
    local p0 = content_layer:convertToNodeSpace(ccp(l_26_0, l_26_1))
    for ii = 1, #hero_items do
      if hero_items[ii]:boundingBox():containsPoint(p0) then
        audio.play(audio.button)
        onClickBelowItem(hero_items[ii])
    else
      end
    end
    local p1 = board:convertToNodeSpace(ccp(l_26_0, l_26_1))
    for ii = 1, #sel_items do
      if sel_items[ii]:boundingBox():containsPoint(p1) then
        audio.play(audio.button)
        onClickAboveItem(sel_items[ii])
    else
      end
    end
    for ii = 1, #unlock_items do
      if unlock_items[ii]:boundingBox():containsPoint(p1) and unlock_items[ii].idx then
        showUnlock(findUnlockLv(unlock_items[ii].idx))
      end
    end
  end
end

local onTouch = function(l_27_0, l_27_1, l_27_2)
  if l_27_0 == "began" then
    return onTouchBegan(l_27_1, l_27_2)
  elseif l_27_0 == "moved" then
    return onTouchMoved(l_27_1, l_27_2)
  else
    return onTouchEnded(l_27_1, l_27_2)
  end
end

layer:registerScriptTouchHandler(onTouch, false, -128, false)
layer:setTouchEnabled(true)
layer:setTouchSwallowEnabled(true)
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

layer:registerScriptHandler(function(l_31_0)
  if l_31_0 == "enter" then
    onEnter()
  elseif l_31_0 == "exit" then
    onExit()
  end
end
)
return layer
end

return ui

