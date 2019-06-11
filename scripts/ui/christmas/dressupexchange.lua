-- Command line was: E:\github\dhgametool\scripts\ui\christmas\dressupexchange.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local player = require("data.player")
local bagdata = require("data.bag")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local rewards = require("ui.reward")
local cfgwish = require("config.christmaswish")
local suredialog = require("ui.suredialog")
local net = require("net.netClient")
local christmas = require("data.christmas")
local BOARD_WIDTH = 664
local BOARD_HEIGHT = 535
local INNER_BOARD_WIDTH = 613
local INNER_BOARD_HEIGHT = 334
local CELL_WIDTH = 590
local CELL_HEIGHT = 91
local CELL_SPACE = 4
local DRESSUP_NAME_GROUP_ID_KEYS = {"christmas_dressup_snowman", "christmas_dressup_wreath", "christmas_dressup_tree", "christmas_dressup_all"}
ui.create = function(l_1_0, l_1_1)
  if not christmas.wishes then
    local dressup_unlocked_arr = {}
  end
  local dressup_unlocked_map = {}
  for k,v in ipairs(dressup_unlocked_arr) do
    dressup_unlocked_map[v] = 1
  end
  local wish_arr = {}
  local unlocked_count = 0
  if l_1_0 and l_1_0 > 0 then
    for i,v in ipairs(cfgwish) do
      if v.group == l_1_0 then
        local item = {id = i, config = v}
        if dressup_unlocked_map[i] then
          item.unlocked = true
          unlocked_count = unlocked_count + 1
        else
          item.unlocked = false
        end
        table.insert(wish_arr, item)
      end
    end
  end
  local board_height = BOARD_HEIGHT
  local inner_board_height = INNER_BOARD_HEIGHT
  if #wish_arr > 0 and #wish_arr < 4 then
    board_height = BOARD_HEIGHT - (CELL_HEIGHT + CELL_SPACE) * (3 - #wish_arr) - 38
    inner_board_height = INNER_BOARD_HEIGHT - (CELL_HEIGHT + CELL_SPACE) * (3 - #wish_arr) - 38
  end
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board = img.createUI9Sprite(img.ui.dialog_1)
  do
    board:setPreferredSize(CCSizeMake(BOARD_WIDTH, board_height))
    board:setScale(view.minScale)
    board:setPosition(view.midX - 5 * view.minScale, view.midY)
    layer:addChild(board)
    layer.board = board
    local lbl_title = lbl.createFont1(24, i18n.global.christmas_dressup_reward.string, ccc3(230, 208, 174))
    lbl_title:setPosition(CCPoint(BOARD_WIDTH / 2, board_height - 29))
    board:addChild(lbl_title, 2)
    local lbl_title_shadowD = lbl.createFont1(24, i18n.global.christmas_dressup_reward.string, ccc3(89, 48, 27))
    lbl_title_shadowD:setPosition(CCPoint(BOARD_WIDTH / 2, board_height - 31))
    board:addChild(lbl_title_shadowD)
    local backEvent = function()
      audio.play(audio.button)
      layer:removeFromParentAndCleanup(true)
      end
    local btn_close0 = img.createUISprite(img.ui.close)
    local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
    btn_close:setPosition(CCPoint(BOARD_WIDTH - 25, board_height - 28))
    local btn_close_menu = CCMenu:createWithItem(btn_close)
    btn_close_menu:setPosition(CCPoint(0, 0))
    board:addChild(btn_close_menu, 100)
    layer.btn_close = btn_close
    btn_close:registerScriptTapHandler(function()
      backEvent()
      end)
    local createCell = function(l_3_0)
      local cell = img.createUI9Sprite(img.ui.botton_fram_2)
      cell:setPreferredSize(CCSizeMake(CELL_WIDTH, CELL_HEIGHT))
      local name_key = "christmas_dressup_name_" .. l_3_0.id
      local lbl_name = lbl.createMix({font = 1, size = 14, text = i18n.global[name_key].string, color = ccc3(125, 88, 70), minScale = false, width = 140, cn = {size = 16}, tw = {size = 16}})
      lbl_name:setPosition(CCPoint(80, CELL_HEIGHT / 2))
      cell:addChild(lbl_name)
      for i,v in ipairs(l_3_0.config.rewards) do
        do
          local reward0 = nil
          if v.type == 1 then
            reward0 = img.createItem(v.id, v.num)
          elseif v.type == 2 then
            reward0 = img.createEquip(v.id, v.num)
          end
          if reward0 then
            if l_3_0.unlocked then
              local img_size = reward0:getContentSize()
              local mask_img = img.createUISprite(img.ui.hero_head_shade)
              mask_img:setOpacity(120)
              mask_img:setPosition(img_size.width / 2, img_size.height / 2)
              reward0:addChild(mask_img, 100)
              local tick_icon = img.createUISprite(img.ui.hook_btn_sel)
              tick_icon:setPosition(img_size.width / 2, img_size.height / 2)
              reward0:addChild(tick_icon, 101)
            end
            local reward = CCMenuItemSprite:create(reward0, nil)
            reward:setScale(0.7)
            reward:setPosition(CCPoint(200 + 64.4 * (i - 1), CELL_HEIGHT / 2))
            local reward_menu = CCMenu:createWithItem(reward)
            reward_menu:setPosition(CCPoint(0, 0))
            cell:addChild(reward_menu)
            reward:registerScriptTapHandler(function()
              audio.play(audio.button)
              if v.type == 1 then
                local tmp_tip = tipsitem.createForShow({id = v.id})
                layer:addChild(tmp_tip, 100)
              else
                if v.type == 2 then
                  local tmp_tip = tipsequip.createById(v.id)
                  layer:addChild(tmp_tip, 100)
                end
              end
                  end)
          end
        end
      end
      local button0 = img.createLogin9Sprite(img.login.button_9_small_gold)
      button0:setPreferredSize(CCSizeMake(120, 45))
      if l_3_0.config.extra[1] then
        local snowflake = img.createItemIcon2(l_3_0.config.extra[1].id)
        snowflake:setPosition(CCPoint(24, button0:getContentSize().height / 2))
        button0:addChild(snowflake)
        local snowflake_label = lbl.createFont2(14, convertItemNum(l_3_0.config.extra[1].num))
        snowflake_label:setAnchorPoint(ccp(1, 0))
        snowflake_label:setPosition(28, 0)
        snowflake:addChild(snowflake_label)
      end
      local lbl_btn = lbl.create({font = 1, size = 14, text = i18n.global.dress_up.string, color = ccc3(130, 71, 35), minScale = false, cn = {size = 16}, tw = {size = 16}})
      lbl_btn:setPosition(CCPoint(button0:getContentSize().width / 2 + 20, button0:getContentSize().height / 2))
      button0:addChild(lbl_btn)
      button = SpineMenuItem:create(json.ui.button, button0)
      button:setPosition(CCPoint(CELL_WIDTH - 80, CELL_HEIGHT / 2))
      local button_menu = CCMenu:createWithItem(button)
      button_menu:setPosition(CCPoint(0, 0))
      cell:addChild(button_menu)
      if l_3_0.unlocked then
        button_menu:setTouchEnabled(false)
        setShader(button, SHADER_GRAY, true)
      else
        button:registerScriptTapHandler(function()
        audio.play(audio.button)
        if itemObj.config.extra[1] then
          local snowflake_obj = bagdata.items.find(ITEM_ID_SNOWFLAKE)
          do
            local snowflake_count = snowflake_obj and snowflake_obj.num or 0
            local need_snowflake_count = itemObj.config.extra[1].num
            if snowflake_count < need_snowflake_count then
              showToast(i18n.global.snowflake_not_enough.string)
              return 
            end
            layer:addChild(suredialog.create(i18n.global.blackmarket_buy_sure.string, function()
              local nParams = {sid = player.sid, id = itemObj.id}
              addWaitNet()
              net:sact_chriswish(nParams, function(l_1_0)
                delWaitNet()
                if l_1_0 and l_1_0.status and l_1_0.status ~= 0 then
                  showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
                  return 
                end
                if l_1_0.reward then
                  bagdata.addRewards(l_1_0.reward)
                  CCDirector:sharedDirector():getRunningScene():addChild(rewards.createFloating(l_1_0.reward), 100000)
                end
                bagdata.items.sub({id = ITEM_ID_SNOWFLAKE, num = need_snowflake_count})
                if not christmas.wishes then
                  local dressup_unlocked_arr = {}
                end
                local find = false
                for k,v in ipairs(dressup_unlocked_arr) do
                  if v == itemObj.id then
                    find = true
                  end
                end
                if not find then
                  table.insert(dressup_unlocked_arr, itemObj.id)
                  christmas.setValue("wishes", dressup_unlocked_arr)
                end
                backEvent()
                if callback then
                  callback()
                end
                     end)
                  end), 1000)
          end
        end
         end)
      end
      return cell
      end
    local createGroupCell = function(l_4_0)
      local cell = img.createUI9Sprite(img.ui.botton_fram_2)
      cell:setPreferredSize(CCSizeMake(CELL_WIDTH, CELL_HEIGHT))
      local all_bg = img.createUI9Sprite(img.ui.task_all_bg)
      all_bg:setPreferredSize(CCSizeMake(CELL_WIDTH, CELL_HEIGHT))
      all_bg:setPosition(CCPoint(CELL_WIDTH / 2, CELL_HEIGHT / 2))
      cell:addChild(all_bg)
      local lbl_desc = lbl.createMix({font = 1, size = 14, text = i18n.global.christmas_dressup_complete_all.string, color = ccc3(125, 88, 70), minScale = false, width = 190, cn = {size = 16}, tw = {size = 16}})
      if i18n.getCurrentLanguage() == kLanguageChinese or i18n.getCurrentLanguage() == kLanguageChineseTW then
        lbl_desc:setPosition(CCPoint(CELL_WIDTH - 96, CELL_HEIGHT / 2))
      else
        lbl_desc:setPosition(CCPoint(CELL_WIDTH - 116, CELL_HEIGHT / 2))
      end
      cell:addChild(lbl_desc)
      local whole_name = ""
      if DRESSUP_NAME_GROUP_ID_KEYS[group_id] and i18n.global[DRESSUP_NAME_GROUP_ID_KEYS[group_id]] then
        whole_name = i18n.global[DRESSUP_NAME_GROUP_ID_KEYS[group_id]].string
      end
      local lbl_name = lbl.createMix({font = 1, size = 14, text = whole_name, color = ccc3(125, 88, 70), minScale = false, width = 140, cn = {size = 16}, tw = {size = 16}})
      lbl_name:setPosition(CCPoint(80, CELL_HEIGHT / 2))
      cell:addChild(lbl_name)
      for i,v in ipairs(l_4_0) do
        do
          local reward0 = nil
          if v.type == 1 then
            reward0 = img.createItem(v.id, v.num)
          elseif v.type == 2 then
            reward0 = img.createEquip(v.id, v.num)
          end
          if reward0 then
            if #wish_arr <= unlocked_count then
              local img_size = reward0:getContentSize()
              local mask_img = img.createUISprite(img.ui.hero_head_shade)
              mask_img:setOpacity(120)
              mask_img:setPosition(img_size.width / 2, img_size.height / 2)
              reward0:addChild(mask_img, 100)
              local tick_icon = img.createUISprite(img.ui.hook_btn_sel)
              tick_icon:setPosition(img_size.width / 2, img_size.height / 2)
              reward0:addChild(tick_icon, 101)
            end
            local reward = CCMenuItemSprite:create(reward0, nil)
            reward:setScale(0.7)
            reward:setPosition(CCPoint(200 + 64.4 * (i - 1), CELL_HEIGHT / 2))
            local reward_menu = CCMenu:createWithItem(reward)
            reward_menu:setPosition(CCPoint(0, 0))
            cell:addChild(reward_menu)
            reward:registerScriptTapHandler(function()
              audio.play(audio.button)
              if v.type == 1 then
                local tmp_tip = tipsitem.createForShow({id = v.id})
                layer:addChild(tmp_tip, 100)
              else
                if v.type == 2 then
                  local tmp_tip = tipsequip.createById(v.id)
                  layer:addChild(tmp_tip, 100)
                end
              end
                  end)
          end
        end
      end
      return cell
      end
    local inner_board = img.createUI9Sprite(img.ui.inner_bg)
    inner_board:setPreferredSize(CCSizeMake(INNER_BOARD_WIDTH, inner_board_height))
    local inner_board_posy = (board_height) / 2 - 70
    inner_board:setPosition(CCPoint(BOARD_WIDTH / 2, inner_board_posy))
    board:addChild(inner_board)
    if #wish_arr > 3 then
      local scroll_params = {width = INNER_BOARD_WIDTH, height = inner_board_height - 6}
      local lineScroll = require("ui.lineScroll")
      local scroll = lineScroll.create(scroll_params)
      scroll:setAnchorPoint(CCPoint(0, 0))
      scroll:setPosition(CCPoint((BOARD_WIDTH - CELL_WIDTH) / 2, 34))
      board:addChild(scroll)
      scroll.addSpace(6)
      for i,v in ipairs(wish_arr) do
        local item_cell = createCell(v)
        item_cell.ax = 0.5
        item_cell.px = CELL_WIDTH / 2
        scroll.addItem(item_cell)
        scroll.addSpace(CELL_SPACE / 2)
      end
      scroll.setOffsetBegin()
      local swallow_layer = CCLayer:create()
      swallow_layer:setTouchEnabled(true)
      swallow_layer:setTouchSwallowEnabled(false)
      swallow_layer:registerScriptTouchHandler(function(l_5_0, l_5_1, l_5_2)
        if l_5_0 == "began" then
          local scroll_parent = scroll:getParent()
          if scroll_parent then
            local scroll_parent_pos = scroll_parent:convertToNodeSpace(CCPoint(l_5_1, l_5_2))
            if scroll:getBoundingBox():containsPoint(scroll_parent_pos) then
              swallow_layer:setTouchSwallowEnabled(false)
            else
              swallow_layer:setTouchSwallowEnabled(true)
            end
          end
          return true
        end
         end)
      scroll:getContainer():addChild(swallow_layer, 1000)
    else
      for i,v in ipairs(wish_arr) do
        local item_cell = createCell(v)
        item_cell:setPosition(CCPoint(BOARD_WIDTH / 2, inner_board_posy + (#wish_arr / 2 + 0.5 - i) * (CELL_HEIGHT + CELL_SPACE) - 1))
        board:addChild(item_cell)
      end
    end
    if wish_arr[1] then
      local group_cell = createGroupCell(wish_arr[1].config.groupRewards)
      group_cell:setPosition(CCPoint(BOARD_WIDTH / 2, board_height - 116))
      board:addChild(group_cell)
    end
    layer:setTouchEnabled(true)
    layer:setTouchSwallowEnabled(true)
    addBackEvent(layer)
    layer.onAndroidBack = function()
      backEvent()
      end
    local onEnter = function()
      layer.notifyParentLock()
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
    board:setScale(0.5 * view.minScale)
    board:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
    return layer
  end
end

return ui

