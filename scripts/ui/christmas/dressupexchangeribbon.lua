-- Command line was: E:\github\dhgametool\scripts\ui\christmas\dressupexchangeribbon.lua 

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
local christmas = require("data.christmas")
local suredialog = require("ui.suredialog")
local net = require("net.netClient")
local BOARD_WIDTH = 664
local BOARD_HEIGHT = 226
local CELL_WIDTH = 590
local CELL_HEIGHT = 91
local RIBBON_INDEX = 10
ui.create = function(l_1_0)
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
    dressup_arr[i] = true
  end
  for k,v in ipairs(cfgwish) do
    if dressup_arr[v.group] and dressup_unlocked_map[k] == nil then
      dressup_arr[v.group] = false
    end
  end
  for k,v in ipairs(dressup_arr) do
    if v then
      one_dress_unlocked = true
  else
    end
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
  local lbl_title = lbl.createFont1(24, i18n.global.christmas_dressup_reward.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(BOARD_WIDTH / 2, BOARD_HEIGHT - 29))
  board:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.christmas_dressup_reward.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(BOARD_WIDTH / 2, BOARD_HEIGHT - 31))
  board:addChild(lbl_title_shadowD)
  local dirty = false
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
    if dirty and callback then
      callback()
    end
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
  local createCell = function(l_3_0)
    local cell = img.createUI9Sprite(img.ui.botton_fram_2)
    cell:setPreferredSize(CCSizeMake(CELL_WIDTH, CELL_HEIGHT))
    local lbl_name = lbl.createMix({font = 1, size = 14, text = i18n.global.christmas_dressup_ribbon.string, color = ccc3(125, 88, 70), minScale = false, width = 140, cn = {size = 16}, tw = {size = 16}})
    lbl_name:setPosition(CCPoint(80, CELL_HEIGHT / 2))
    cell:addChild(lbl_name)
    for i,v in ipairs(l_3_0.rewards) do
      do
        local reward0 = nil
        if v.type == 1 then
          reward0 = img.createItem(v.id, v.num)
        elseif v.type == 2 then
          reward0 = img.createEquip(v.id, v.num)
        end
        if reward0 then
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
    if l_3_0.extra[1] then
      local snowflake = img.createItemIcon2(l_3_0.extra[1].id)
      snowflake:setPosition(CCPoint(24, button0:getContentSize().height / 2))
      button0:addChild(snowflake)
      local snowflake_label = lbl.createFont2(14, convertItemNum(l_3_0.extra[1].num))
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
    if not one_dress_unlocked then
      setShader(button0, SHADER_GRAY, true)
      button_menu:setTouchEnabled(false)
    else
      button:registerScriptTapHandler(function()
      audio.play(audio.button)
      if itemObj.extra[1] then
        local snowflake_obj = bagdata.items.find(ITEM_ID_SNOWFLAKE)
        do
          local snowflake_count = snowflake_obj and snowflake_obj.num or 0
          local need_snowflake_count = itemObj.extra[1].num
          if snowflake_count < need_snowflake_count then
            showToast(i18n.global.snowflake_not_enough.string)
            return 
          end
          layer:addChild(suredialog.create(i18n.global.blackmarket_buy_sure.string, function()
            local nParams = {sid = player.sid, id = RIBBON_INDEX}
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
              upvalue_2048 = true
              if not christmas.wishes then
                local dressup_unlocked_arr = {}
              end
              local find = false
              for k,v in ipairs(dressup_unlocked_arr) do
                if v == RIBBON_INDEX then
                  find = true
                end
              end
              if not find then
                table.insert(dressup_unlocked_arr, RIBBON_INDEX)
                christmas.setValue("wishes", dressup_unlocked_arr)
              end
                  end)
               end), 1000)
        end
      end
      end)
    end
    return cell
   end
  local item_cell = createCell(cfgwish[RIBBON_INDEX])
  item_cell:setPosition(CCPoint(BOARD_WIDTH / 2, BOARD_HEIGHT / 2))
  board:addChild(item_cell)
  local dressup_ribbon_desc = nil
  if one_dress_unlocked then
    dressup_ribbon_desc = i18n.global.christmas_dressup_ribbon_unlocked.string
  else
    dressup_ribbon_desc = i18n.global.christmas_dressup_unlock_one.string
  end
  local lbl_desc = lbl.createMix({font = 1, size = 14, text = dressup_ribbon_desc, color = ccc3(125, 88, 70), minScale = false, width = CELL_WIDTH, cn = {size = 16}, tw = {size = 16}})
  lbl_desc:setPosition(CCPoint(BOARD_WIDTH / 2, 46))
  board:addChild(lbl_desc)
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
  layer:registerScriptHandler(function(l_7_0)
    if l_7_0 == "enter" then
      onEnter()
    elseif l_7_0 == "exit" then
      onExit()
    end
   end)
  board:setScale(0.5 * view.minScale)
  board:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  return layer
end

return ui

