-- Command line was: E:\github\dhgametool\scripts\ui\hook\stage.lua 

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
local cfgstage = require("config.stage")
local cfgpoker = require("config.poker")
local player = require("data.player")
local bagdata = require("data.bag")
local hookdata = require("data.hook")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local ItemType = {Item = 1, Equip = 2}
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board_bg = img.createUI9Sprite(img.ui.dialog_1)
  board_bg:setPreferredSize(CCSizeMake(666, 515))
  board_bg:setScale(view.minScale)
  board_bg:setPosition(view.midX - 0 * view.minScale, view.midY)
  layer:addChild(board_bg)
  local board_bg_w = board_bg:getContentSize().width
  local board_bg_h = board_bg:getContentSize().height
  board_bg:setScale(0.5 * view.minScale)
  board_bg:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  local ff, ss = hookdata.getFortStageByStageId(l_1_0)
  local title_str = string.format(i18n.global.hook_stage_board_title.string, ff, ss)
  local lbl_title = lbl.createFont1(24, title_str, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 29))
  board_bg:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, title_str, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_bg_w / 2, board_bg_h - 31))
  board_bg:addChild(lbl_title_shadowD)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
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
  local rate_board = img.createUI9Sprite(img.ui.hero_attribute_lab_frame)
  rate_board:setPreferredSize(CCSizeMake(614, 110))
  rate_board:setPosition(CCPoint(board_bg_w / 2, 390))
  board_bg:addChild(rate_board)
  local rate_board_w = rate_board:getContentSize().width
  local rate_board_h = rate_board:getContentSize().height
  local lbl_rate_title = lbl.createFont1(18, i18n.global.hook_stage_output.string, ccc3(148, 98, 66))
  lbl_rate_title:setPosition(CCPoint(rate_board_w / 2, 88))
  rate_board:addChild(lbl_rate_title)
  local split_l1 = img.createUISprite(img.ui.hook_title_split)
  split_l1:setAnchorPoint(CCPoint(1, 0.5))
  split_l1:setPosition(CCPoint(rate_board_w / 2 - 62, 88))
  rate_board:addChild(split_l1)
  local split_r1 = img.createUISprite(img.ui.hook_title_split)
  split_r1:setFlipX(true)
  split_r1:setAnchorPoint(CCPoint(0, 0.5))
  split_r1:setPosition(CCPoint(rate_board_w / 2 + 62, 88))
  rate_board:addChild(split_r1)
  local coin_box = img.createUI9Sprite(img.ui.hero_icon_bg)
  coin_box:setPreferredSize(CCSizeMake(150, 52))
  coin_box:setPosition(CCPoint(rate_board_w / 2 - 36 - 150, 42))
  rate_board:addChild(coin_box)
  local coin_icon_bg = img.createUISprite(img.ui.hook_rate_bg)
  coin_icon_bg:setPosition(CCPoint(2, coin_box:getContentSize().height / 2))
  coin_box:addChild(coin_icon_bg)
  local coin_icon = img.createItemIcon2(ITEM_ID_COIN)
  coin_icon:setPosition(CCPoint(coin_icon_bg:getContentSize().width / 2, coin_icon_bg:getContentSize().height / 2))
  coin_icon_bg:addChild(coin_icon)
  local pxp_box = img.createUI9Sprite(img.ui.hero_icon_bg)
  pxp_box:setPreferredSize(CCSizeMake(150, 52))
  pxp_box:setPosition(CCPoint(rate_board_w / 2 + 10, 42))
  rate_board:addChild(pxp_box)
  local pxp_icon_bg = img.createUISprite(img.ui.hook_rate_bg)
  pxp_icon_bg:setPosition(CCPoint(2, pxp_box:getContentSize().height / 2))
  pxp_box:addChild(pxp_icon_bg)
  local pxp_icon = img.createItemIcon2(ITEM_ID_PLAYER_EXP)
  pxp_icon:setPosition(CCPoint(pxp_icon_bg:getContentSize().width / 2, pxp_icon_bg:getContentSize().height / 2))
  pxp_icon_bg:addChild(pxp_icon)
  local hxp_box = img.createUI9Sprite(img.ui.hero_icon_bg)
  hxp_box:setPreferredSize(CCSizeMake(150, 52))
  hxp_box:setPosition(CCPoint(rate_board_w / 2 + 56 + 150, 42))
  rate_board:addChild(hxp_box)
  local hxp_icon_bg = img.createUISprite(img.ui.hook_rate_bg)
  hxp_icon_bg:setPosition(CCPoint(2, hxp_box:getContentSize().height / 2))
  hxp_box:addChild(hxp_icon_bg)
  local hxp_icon = img.createItemIcon(ITEM_ID_HERO_EXP)
  hxp_icon:setScale(0.5)
  hxp_icon:setPosition(CCPoint(hxp_icon_bg:getContentSize().width / 2, hxp_icon_bg:getContentSize().height / 2))
  hxp_icon_bg:addChild(hxp_icon)
  local lbl_rate_coin = lbl.createFont1(20, "+" .. cfgstage[l_1_0].gold .. "/5s", ccc3(148, 98, 66))
  lbl_rate_coin:setPosition(CCPoint(82, coin_box:getContentSize().height / 2))
  coin_box:addChild(lbl_rate_coin)
  local lbl_rate_pxp = lbl.createFont1(20, "+" .. cfgstage[l_1_0].expP .. "/5s", ccc3(148, 98, 66))
  lbl_rate_pxp:setPosition(CCPoint(82, pxp_box:getContentSize().height / 2))
  pxp_box:addChild(lbl_rate_pxp)
  local lbl_rate_hxp = lbl.createFont1(20, "+" .. cfgstage[l_1_0].expH .. "/5s", ccc3(148, 98, 66))
  lbl_rate_hxp:setPosition(CCPoint(82, hxp_box:getContentSize().height / 2))
  hxp_box:addChild(lbl_rate_hxp)
  local board = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  board:setPreferredSize(CCSizeMake(614, 202))
  board:setAnchorPoint(CCPoint(0.5, 0))
  board:setPosition(CCPoint(board_bg_w / 2, 85))
  board_bg:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local lbl_board_title = lbl.createFont1(18, i18n.global.hook_stage_drops.string, ccc3(148, 98, 66))
  lbl_board_title:setPosition(CCPoint(board_w / 2, board_h + 23))
  board:addChild(lbl_board_title)
  local split_l2 = img.createUISprite(img.ui.hook_title_split)
  split_l2:setAnchorPoint(CCPoint(1, 0.5))
  split_l2:setPosition(CCPoint(board_w / 2 - 62, board_h + 23))
  board:addChild(split_l2)
  local split_r2 = img.createUISprite(img.ui.hook_title_split)
  split_r2:setFlipX(true)
  split_r2:setAnchorPoint(CCPoint(0, 0.5))
  split_r2:setPosition(CCPoint(board_w / 2 + 62, board_h + 23))
  board:addChild(split_r2)
  local btn_hook0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_hook0:setPreferredSize(CCSizeMake(220, 54))
  local lbl_btn_hook = lbl.createFont1(22, i18n.global.hook_btn_hook.string, ccc3(115, 59, 5))
  lbl_btn_hook:setPosition(CCPoint(btn_hook0:getContentSize().width / 2, btn_hook0:getContentSize().height / 2))
  btn_hook0:addChild(lbl_btn_hook)
  local btn_hook = SpineMenuItem:create(json.ui.button, btn_hook0)
  btn_hook:setPosition(CCPoint(board_bg_w / 2, 51))
  local btn_hook_menu = CCMenu:createWithItem(btn_hook)
  btn_hook_menu:setPosition(CCPoint(0, 0))
  board_bg:addChild(btn_hook_menu)
  if l_1_0 == hookdata.getHookStage() then
    btn_hook:setVisible(false)
  end
  local SCROLL_VIEW_W = 548
  local SCROLL_VIEW_H = 174
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setViewSize(CCSize(SCROLL_VIEW_W, SCROLL_VIEW_H))
  scroll:setContentSize(CCSize(SCROLL_VIEW_W, SCROLL_VIEW_H))
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(33, 12))
  board:addChild(scroll)
  local content_layer = CCLayer:create()
  content_layer:setAnchorPoint(CCPoint(0, 0))
  content_layer:setPosition(CCPoint(0, 0))
  scroll:getContainer():addChild(content_layer)
  scroll.content_layer = content_layer
  local createItem = function(l_3_0)
    if l_3_0.type == ItemType.Equip then
      return img.createEquip(l_3_0.id)
    else
      if l_3_0.type == ItemType.Item then
        return img.createItem(l_3_0.id)
      end
    end
   end
  local items = {}
  local item_offset_x = 41
  local item_offset_y = 53
  local item_step_x = 93
  local item_step_y = 95
  local row_count = 6
  local showList = function()
    arrayclear(items)
    content_layer:removeAllChildrenWithCleanup(true)
    local height = 0
    for ii = 1, #cfgpoker[_stage_id].yes do
      local tmp_objs = cfgpoker[_stage_id].yes
      local tmp_itemObj = {id = tmp_objs[ii].id, type = tmp_objs[ii].type}
      local tmp_item = createItem(tmp_itemObj)
      tmp_item.obj = tmp_itemObj
      local pos_x = item_offset_x + item_step_x * ((ii - 1) % row_count)
      local pos_y = item_offset_y + item_step_y * (math.floor((ii + row_count - 1) / row_count) - 1)
      tmp_item:setPosition(CCPoint(pos_x, 0 - pos_y))
      content_layer:addChild(tmp_item)
      items[#items + 1] = tmp_item
      height = pos_y + 47
    end
    if hookdata.extra then
      local tpos = #cfgpoker[_stage_id].yes
      if hookdata.extra.equips then
        for ii = tpos + 1, tpos + #hookdata.extra.equips do
          local tmp_objs = hookdata.extra.equips
          local tmp_itemObj = {id = tmp_objs[ii - tpos].id, type = 2}
          local tmp_item = createItem(tmp_itemObj)
          tmp_item.obj = tmp_itemObj
          local pos_x = item_offset_x + item_step_x * ((ii - 1) % row_count)
          local pos_y = item_offset_y + item_step_y * (math.floor((ii + row_count - 1) / row_count) - 1)
          tmp_item:setPosition(CCPoint(pos_x, 0 - pos_y))
          content_layer:addChild(tmp_item)
          items[#items + 1] = tmp_item
          height = pos_y + 47
        end
        tpos = tpos + #hookdata.extra.equips
      end
      if hookdata.extra.items then
        for ii = tpos + 1, tpos + #hookdata.extra.items do
          local tmp_objs = hookdata.extra.items
          local tmp_itemObj = {id = tmp_objs[ii - (tpos)].id, type = 1}
          local tmp_item = createItem(tmp_itemObj)
          tmp_item.obj = tmp_itemObj
          local pos_x = item_offset_x + item_step_x * ((ii - 1) % row_count)
          local pos_y = item_offset_y + item_step_y * (math.floor((ii + row_count - 1) / row_count) - 1)
          tmp_item:setPosition(CCPoint(pos_x, 0 - pos_y))
          content_layer:addChild(tmp_item)
          items[#items + 1] = tmp_item
          height = pos_y + 47
        end
      end
    end
    if height < SCROLL_VIEW_H then
      scroll:setContentSize(CCSizeMake(SCROLL_VIEW_W, SCROLL_VIEW_H))
      content_layer:setPosition(CCPoint(0, SCROLL_VIEW_H))
      scroll:setContentOffset(CCPoint(0, 0))
    else
      scroll:setContentSize(CCSizeMake(SCROLL_VIEW_W, height))
      content_layer:setPosition(CCPoint(0, height))
      scroll:setContentOffset(CCPoint(0, SCROLL_VIEW_H - (height)))
    end
   end
  showList()
  local onClickItem = function(l_5_0)
    if l_5_0.obj.type == ItemType.Equip then
      layer:addChild(tipsequip.createById(l_5_0.obj.id), 100)
    else
      if l_5_0.obj.type == ItemType.Item then
        layer:addChild(tipsitem.createForShow({id = l_5_0.obj.id}), 100)
      end
    end
   end
  local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
  local onTouchBegan = function(l_6_0, l_6_1)
    touchbeginx, upvalue_512 = l_6_0, l_6_1
    upvalue_1024 = true
    if scroll and not tolua.isnull(scroll) then
      local p0 = content_layer:convertToNodeSpace(ccp(l_6_0, l_6_1))
      for ii = 1, #items do
        if items[ii]:boundingBox():containsPoint(p0) then
          playAnimTouchBegin(items[ii])
          upvalue_3072 = items[ii]
      else
        end
      end
    end
    return true
   end
  local onTouchMoved = function(l_7_0, l_7_1)
    if isclick and (math.abs(touchbeginx - l_7_0) > 10 or math.abs(touchbeginy - l_7_1) > 10) then
      isclick = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        playAnimTouchEnd(last_touch_sprite)
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_8_0, l_8_1)
    if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
      playAnimTouchEnd(last_touch_sprite)
      last_touch_sprite = nil
    end
    if isclick and scroll and not tolua.isnull(scroll) then
      local p0 = content_layer:convertToNodeSpace(ccp(l_8_0, l_8_1))
      for ii = 1, #items do
        if items[ii]:boundingBox():containsPoint(p0) then
          audio.play(audio.button)
          onClickItem(items[ii])
      else
        end
      end
    end
   end
  local onTouch = function(l_9_0, l_9_1, l_9_2)
    if l_9_0 == "began" then
      return onTouchBegan(l_9_1, l_9_2)
    elseif l_9_0 == "moved" then
      return onTouchMoved(l_9_1, l_9_2)
    else
      return onTouchEnded(l_9_1, l_9_2)
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
  layer:registerScriptHandler(function(l_13_0)
    if l_13_0 == "enter" then
      onEnter()
    elseif l_13_0 == "exit" then
      onExit()
    end
   end)
  btn_hook:registerScriptTapHandler(function()
    audio.play(audio.button)
    btn_hook:setEnabled(false)
    local params = {sid = player.sid, stage = _stage_id}
    addWaitNet()
    hookdata.change(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      require("data.tutorial").goNext("hook2", 2, true)
      hookdata.hook_stage = _stage_id
      if l_1_0.reward then
        hookdata.set_reward(l_1_0.reward)
      end
      if l_1_0.boss_cd then
        hookdata.boss_cd = l_1_0.boss_cd + os.time() - hookdata.init_time
      end
      replaceScene(require("ui.hook.map").create())
      end)
   end)
  return layer
end

return ui

