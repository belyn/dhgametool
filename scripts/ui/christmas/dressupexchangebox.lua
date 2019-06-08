-- Command line was: E:\github\dhgametool\scripts\ui\christmas\dressupexchangebox.lua 

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
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local rewards = require("ui.reward")
local cfgwish = require("config.christmaswish")
local christmas = require("data.christmas")
local BOARD_WIDTH = 664
local BOARD_HEIGHT = 505
local CELL_WIDTH = 590
local CELL_HEIGHT = 91
local CELL_SPACE = 4
local INNER_BOARD_WIDTH = 613
local INNER_BOARD_HEIGHT = 296
local PROGRESS_BAR_WIDTH = 203
local PROGRESS_BAR_HEIGHT = 20
local DRESSUP_ALL_GROUP_ID = 4
local DRESSUP_NAME_GROUP_ID_KEYS = {"christmas_dressup_snowman", "christmas_dressup_wreath", "christmas_dressup_tree", "christmas_dressup_all"}
ui.create = function()
  if not christmas.wishes then
    local dressup_unlocked_arr = {}
  end
  local dressup_unlocked_map = {}
  for k,v in ipairs(dressup_unlocked_arr) do
    dressup_unlocked_map[v] = 1
  end
  local one_dress_unlocked = false
  local dressup_arr = {}
  for i = 1, 3 do
    dressup_arr[i] = {curr_count = 0, max_count = 0, unlocked = false}
  end
  for k,v in ipairs(cfgwish) do
    if dressup_arr[v.group] then
      dressup_arr[v.group].max_count = dressup_arr[v.group].max_count + 1
      if dressup_unlocked_map[k] then
        dressup_arr[v.group].curr_count = dressup_arr[v.group].curr_count + 1
      end
    end
  end
  local all_unlocked = true
  for k,v in ipairs(dressup_arr) do
    if v.max_count <= v.curr_count then
      v.unlocked = true
      for k,v in (for generator) do
      end
      all_unlocked = false
    end
    local layer = CCLayer:create()
    local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
    layer:addChild(darkbg)
    local board = img.createUI9Sprite(img.ui.dialog_1)
    board:setPreferredSize(CCSizeMake(BOARD_WIDTH, BOARD_HEIGHT))
    board:setScale(view.minScale)
    board:setPosition(view.midX - 5 * view.minScale, view.midY)
    layer:addChild(board)
    layer.board = board
    local inner_board = img.createUI9Sprite(img.ui.inner_bg)
    inner_board:setPreferredSize(CCSizeMake(INNER_BOARD_WIDTH, INNER_BOARD_HEIGHT))
    local inner_board_posy = BOARD_HEIGHT / 2 - 70
    inner_board:setPosition(CCPoint(BOARD_WIDTH / 2, inner_board_posy))
    board:addChild(inner_board)
    local lbl_title = lbl.createFont1(24, i18n.global.christmas_dressup_reward.string, ccc3(230, 208, 174))
    lbl_title:setPosition(CCPoint(BOARD_WIDTH / 2, BOARD_HEIGHT - 29))
    board:addChild(lbl_title, 2)
    local lbl_title_shadowD = lbl.createFont1(24, i18n.global.christmas_dressup_reward.string, ccc3(89, 48, 27))
    lbl_title_shadowD:setPosition(CCPoint(BOARD_WIDTH / 2, BOARD_HEIGHT - 31))
    board:addChild(lbl_title_shadowD)
    local backEvent = function()
      audio.play(audio.button)
      layer:removeFromParentAndCleanup(true)
      end
    local btn_close0 = img.createUISprite(img.ui.close)
    local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
    btn_close:setPosition(CCPoint(BOARD_WIDTH - 25, BOARD_HEIGHT - 28))
    local btn_close_menu = CCMenu:createWithItem(btn_close)
    btn_close_menu:setPosition(CCPoint(0, 0))
    board:addChild(btn_close_menu, 100)
    layer.btn_close = btn_close
    btn_close:registerScriptTapHandler(function()
      backEvent()
      end)
    local createGroupCell = function(l_3_0, l_3_1)
      local cell = img.createUI9Sprite(img.ui.botton_fram_2)
      cell:setPreferredSize(CCSizeMake(CELL_WIDTH, CELL_HEIGHT))
      local all_bg = img.createUI9Sprite(img.ui.task_all_bg)
      all_bg:setPreferredSize(CCSizeMake(CELL_WIDTH, CELL_HEIGHT))
      all_bg:setPosition(CCPoint(CELL_WIDTH / 2, CELL_HEIGHT / 2))
      cell:addChild(all_bg)
      local dressup_name_key = DRESSUP_NAME_GROUP_ID_KEYS[l_3_1]
      local dressup_name = i18n.global[dressup_name_key] and i18n.global[dressup_name_key].string or ""
      local lbl_name = lbl.createMix({font = 1, size = 14, text = dressup_name, color = ccc3(125, 88, 70), minScale = false, width = 140, cn = {size = 16}, tw = {size = 16}})
      lbl_name:setPosition(CCPoint(80, CELL_HEIGHT / 2))
      cell:addChild(lbl_name)
      for i,v in ipairs(l_3_0) do
        do
          local reward0 = nil
          if v.type == 1 then
            reward0 = img.createItem(v.id, v.num)
          elseif v.type == 2 then
            reward0 = img.createEquip(v.id, v.num)
          end
          if reward0 then
            if all_unlocked then
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
            reward:setPosition(CCPoint(206 + 64.4 * (i - 1), CELL_HEIGHT / 2))
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
      local lbl_desc = lbl.createMix({font = 1, size = 14, text = i18n.global.christmas_dressup_complete_all.string, color = ccc3(125, 88, 70), minScale = false, width = 190, cn = {size = 16}, tw = {size = 16}})
      if i18n.getCurrentLanguage() == kLanguageChinese or i18n.getCurrentLanguage() == kLanguageChineseTW then
        lbl_desc:setPosition(CCPoint(CELL_WIDTH - 96, CELL_HEIGHT / 2))
      else
        lbl_desc:setPosition(CCPoint(CELL_WIDTH - 116, CELL_HEIGHT / 2))
      end
      cell:addChild(lbl_desc)
      return cell
      end
    local createCell = function(l_4_0)
      local cell = img.createUI9Sprite(img.ui.botton_fram_2)
      cell:setPreferredSize(CCSizeMake(CELL_WIDTH, CELL_HEIGHT))
      local pgb_bg = img.createUI9Sprite(img.ui.playerInfo_process_bar_bg)
      pgb_bg:setPreferredSize(CCSizeMake(PROGRESS_BAR_WIDTH, PROGRESS_BAR_HEIGHT))
      pgb_bg:setPosition(CCPoint(280, CELL_HEIGHT / 2))
      cell:addChild(pgb_bg)
      local pgb_fg = img.createUISprite(img.ui.activity_pgb_casino)
      local pgb = createProgressBar(pgb_fg)
      pgb:setPosition(CCPoint(PROGRESS_BAR_WIDTH / 2, PROGRESS_BAR_HEIGHT / 2))
      pgb_bg:addChild(pgb)
      pgb:setPercentage(100 * dressup_arr[l_4_0].curr_count / dressup_arr[l_4_0].max_count)
      local lbl_percent = lbl.createFont2(18, dressup_arr[l_4_0].curr_count .. "/" .. dressup_arr[l_4_0].max_count, ccc3(248, 242, 226))
      lbl_percent:setPosition(CCPoint(PROGRESS_BAR_WIDTH / 2, PROGRESS_BAR_HEIGHT - 2))
      pgb_bg:addChild(lbl_percent)
      local dressup_name_key = DRESSUP_NAME_GROUP_ID_KEYS[l_4_0]
      local dressup_name = i18n.global[dressup_name_key] and i18n.global[dressup_name_key].string or ""
      local lbl_name = lbl.createMix({font = 1, size = 14, text = dressup_name, color = ccc3(125, 88, 70), minScale = false, width = 140, cn = {size = 16}, tw = {size = 16}})
      lbl_name:setPosition(CCPoint(80, CELL_HEIGHT / 2))
      cell:addChild(lbl_name)
      if dressup_arr[l_4_0].unlocked then
        local soldout = img.createUISprite(img.ui.blackmarket_soldout)
        soldout:setPosition(CELL_WIDTH - 56, CELL_HEIGHT / 2)
        cell:addChild(soldout)
      end
      return cell
      end
    local all_cell = createGroupCell(cfgwish[1].allRewards, DRESSUP_ALL_GROUP_ID)
    all_cell:setPosition(CCPoint(BOARD_WIDTH / 2, BOARD_HEIGHT - 120))
    board:addChild(all_cell)
    for i = 1, 3 do
      local cell = createCell(i)
      cell:setPosition(CCPoint(BOARD_WIDTH / 2, inner_board_posy + (2 - i) * (CELL_HEIGHT + CELL_SPACE) - 1))
      board:addChild(cell)
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
    do
      local onExit = function()
      layer.notifyParentUnlock()
      end
      layer:registerScriptHandler(function(l_8_0)
      if l_8_0 == "enter" then
        onEnter()
      elseif l_8_0 == "exit" then
        onExit()
      end
      end)
      board:setScale(0.5 * view.minScale)
      board:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
      return layer
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return ui

