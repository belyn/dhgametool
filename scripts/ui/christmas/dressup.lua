-- Command line was: E:\github\dhgametool\scripts\ui\christmas\dressup.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local audio = require("res.audio")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local bagdata = require("data.bag")
local christmas = require("data.christmas")
local cfgwish = require("config.christmaswish")
local cfgspecial = require("config.specialactivity")
local activity = require("data.activity")
local SNOWFLAKE_BG_WIDTH = 174
local SNOWFLAKE_BG_HEIGHT = 40
local GROUP_ID_SNOWMAN = 1
local GROUP_ID_WREATH = 2
local GROUP_ID_TREE = 3
local BOARD_WIDTH = 576
local BOARD_HEIGHT = 436
local TOUCH_CANCEL_OFFSET = 30
local ANIMATION_NAMES = {1 = "xueren_shoutao", 2 = "xueren_maozi", 3 = "xueren_weijin", 4 = "huahuan_hudiejie", 5 = "huahuan_caidan", 6 = "caideng", 7 = "lingdangtangguo", 8 = "liwu", 9 = "xingxing"}
local ANIMATION_INDEX = {BOX = 1, WREATH = 2, SNOWMAN = 3, TREE = 4, RIBBON = 5}
local ANIMATION_IDLE_NAMES = {ANIMATION_INDEX.SNOWMAN = "xueren_huxidonghua", ANIMATION_INDEX.TREE = "shengdanshu_huxi"}
local ANIMATION_GLOW_NAMES = {ANIMATION_INDEX.WREATH = "huahuan_glow", ANIMATION_INDEX.SNOWMAN = "xueren_glow", ANIMATION_INDEX.TREE = "shengdanshu_glow"}
local UNLOCK_STATUS = {LOCKED = 0, JUST_UNLOCK = 1, ALREADY_UNLOCKED = 2}
ui.create = function()
  local layer = CCLayer:create()
  layer:registerScriptHandler(function(l_1_0)
    if l_1_0 == "enter" then
      ui.onEnter()
    elseif l_1_0 == "exit" then
      ui.onExit()
    end
   end)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  ui.layer = layer
  ui.widgets = {}
  ui.loadRes()
  ui.init()
  ui.update()
  return layer
end

ui.init = function()
  local layer = ui.layer
  ui.initData()
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(BOARD_WIDTH, BOARD_HEIGHT))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local bg = img.createUISprite(img.ui.ui_christmas_dressup_bg)
  bg:setAnchorPoint(CCPoint(0.5, 0.5))
  bg:setPosition(CCPoint(BOARD_WIDTH / 2, BOARD_HEIGHT / 2))
  board:addChild(bg)
  local snow_ani = DHSkeletonAnimation:createWithKey(json.ui.winter_main_snow_5)
  snow_ani:scheduleUpdateLua()
  snow_ani:playAnimation("animation", -1)
  snow_ani:setPosition(BOARD_WIDTH / 2 + 100, BOARD_HEIGHT / 2 - 100)
  board:addChild(snow_ani)
  ui.animations = {}
  ui.animations_ghost = {}
  local ribbon_ani = DHSkeletonAnimation:createWithKey(json.ui.christmas_caiqi)
  ribbon_ani:scheduleUpdateLua()
  ribbon_ani:playAnimation("qizi_loop", -1)
  ribbon_ani:setPosition(BOARD_WIDTH / 2 - 173, BOARD_HEIGHT / 2 + 66)
  board:addChild(ribbon_ani)
  ui.animations[ANIMATION_INDEX.RIBBON] = ribbon_ani
  local tree_ani = DHSkeletonAnimation:createWithKey(json.ui.christmas_shengdanshu)
  tree_ani:scheduleUpdateLua()
  tree_ani:setPosition(BOARD_WIDTH / 2 - 174, BOARD_HEIGHT / 2 + 66)
  board:addChild(tree_ani)
  ui.animations[ANIMATION_INDEX.TREE] = tree_ani
  local wreath_ani = DHSkeletonAnimation:createWithKey(json.ui.christmas_huanhuan)
  wreath_ani:scheduleUpdateLua()
  wreath_ani:setPosition(BOARD_WIDTH / 2 - 170, BOARD_HEIGHT / 2 + 58)
  board:addChild(wreath_ani)
  ui.animations[ANIMATION_INDEX.WREATH] = wreath_ani
  local box_ani = DHSkeletonAnimation:createWithKey(json.ui.christmas_baoxiang)
  box_ani:scheduleUpdateLua()
  box_ani:playAnimation("baoxiang_doudong_loop", -1)
  box_ani:setPosition(BOARD_WIDTH / 2 - 174, BOARD_HEIGHT / 2 + 64)
  board:addChild(box_ani)
  ui.animations[ANIMATION_INDEX.BOX] = box_ani
  local snowman_ani = DHSkeletonAnimation:createWithKey(json.ui.christmas_xueren)
  snowman_ani:scheduleUpdateLua()
  snowman_ani:setPosition(BOARD_WIDTH / 2 - 170, BOARD_HEIGHT / 2 + 62)
  board:addChild(snowman_ani)
  ui.animations[ANIMATION_INDEX.SNOWMAN] = snowman_ani
  local snowflake_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  snowflake_bg:setPreferredSize(CCSizeMake(SNOWFLAKE_BG_WIDTH, SNOWFLAKE_BG_HEIGHT))
  snowflake_bg:setPosition(CCPoint(BOARD_WIDTH / 2, BOARD_HEIGHT - 40))
  board:addChild(snowflake_bg)
  local snowflake = img.createItemIcon2(ITEM_ID_SNOWFLAKE)
  snowflake:setPosition(CCPoint(16, SNOWFLAKE_BG_HEIGHT / 2 + 4))
  snowflake_bg:addChild(snowflake)
  local snowflake_btn_img = img.createUISprite(img.ui.main_icon_plus)
  local snowflake_btn = HHMenuItem:create(snowflake_btn_img)
  snowflake_btn:setPosition(CCPoint(SNOWFLAKE_BG_WIDTH - 18, SNOWFLAKE_BG_HEIGHT / 2 + 2))
  local snowflake_btn_menu = CCMenu:createWithItem(snowflake_btn)
  snowflake_btn_menu:setPosition(CCPoint(0, 0))
  snowflake_bg:addChild(snowflake_btn_menu)
  local snowflake_label = lbl.createFont2(16, "", ccc3(255, 246, 223))
  snowflake_label:setPosition(CCPoint(SNOWFLAKE_BG_WIDTH / 2, SNOWFLAKE_BG_HEIGHT / 2 + 3))
  snowflake_bg:addChild(snowflake_label)
  ui.widgets.snowflake_label = snowflake_label
  snowflake_btn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local IDS = activity.IDS
    local snowflake_status = activity.getStatusById(IDS.CHRISTMAS_SNOWFLAKE.ID)
    local limits = 0
    if snowflake_status and snowflake_status.limits then
      limits = snowflake_status.limits
    end
    local snowflake_num = 0
    local max_limit = 0
    if cfgspecial[IDS.CHRISTMAS_SNOWFLAKE.ID] then
      max_limit = cfgspecial[IDS.CHRISTMAS_SNOWFLAKE.ID].instruct
      if max_limit < limits then
        limits = max_limit
      end
      if cfgspecial[IDS.CHRISTMAS_SNOWFLAKE.ID].rewards and cfgspecial[IDS.CHRISTMAS_SNOWFLAKE.ID].rewards[1] then
        snowflake_num = cfgspecial[IDS.CHRISTMAS_SNOWFLAKE.ID].rewards[1].num
      end
    end
    local snowflake_count = limits * snowflake_num
    local snowflake_max_count = max_limit * snowflake_num
    local snowflake_help = string.format(i18n.global.christmas_dressup_snowflake_help.string, snowflake_num, snowflake_max_count, snowflake_count, snowflake_max_count)
    layer:getParent():getParent():getParent():addChild(require("ui.help").create(snowflake_help, i18n.global.help_title.string), 1000)
   end)
  local btnInfoSprite = img.createUISprite(img.ui.btn_help)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  btnInfo:setPosition(BOARD_WIDTH - 40, BOARD_HEIGHT - 40)
  local menuInfo = CCMenu:createWithItem(btnInfo)
  menuInfo:setPosition(0, 0)
  board:addChild(menuInfo)
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    local IDS = activity.IDS
    local snowflake_status = activity.getStatusById(IDS.CHRISTMAS_SNOWFLAKE.ID)
    local limits = 0
    if snowflake_status and snowflake_status.limits then
      limits = snowflake_status.limits
    end
    local snowflake_num = 0
    local max_limit = 0
    if cfgspecial[IDS.CHRISTMAS_SNOWFLAKE.ID] then
      max_limit = cfgspecial[IDS.CHRISTMAS_SNOWFLAKE.ID].instruct
      if max_limit < limits then
        limits = max_limit
      end
      if cfgspecial[IDS.CHRISTMAS_SNOWFLAKE.ID].rewards and cfgspecial[IDS.CHRISTMAS_SNOWFLAKE.ID].rewards[1] then
        snowflake_num = cfgspecial[IDS.CHRISTMAS_SNOWFLAKE.ID].rewards[1].num
      end
    end
    local snowflake_count = limits * snowflake_num
    local snowflake_max_count = max_limit * snowflake_num
    local dressup_help = string.format(i18n.global.christmas_dressup_help.string, snowflake_num, snowflake_max_count)
    layer:getParent():getParent():getParent():addChild(require("ui.help").create(dressup_help, i18n.global.help_title.string), 1000)
   end)
  local selected_animation = nil
  local start_click = false
  local begin_posx = 0
  local begin_posy = 0
  local onTouchBegan = function(l_3_0, l_3_1)
    start_click = true
    if ui.animations then
      for ii = 1, #ui.animations do
        local tObj = ui.animations[ii]
        if tObj:containsPoint(CCPoint(l_3_0, l_3_1)) then
          upvalue_1024 = l_3_0
          upvalue_1536 = l_3_1
          setShader(tObj, SHADER_HIGHLIGHT, true)
          upvalue_2048 = tObj
      else
        end
      end
    end
    return true
   end
  local onTouchMoved = function(l_4_0, l_4_1)
    if start_click and (TOUCH_CANCEL_OFFSET < math.abs(l_4_0 - begin_posx) or TOUCH_CANCEL_OFFSET < math.abs(l_4_1 - begin_posy)) then
      start_click = false
      if selected_animation then
        clearShader(selected_animation, true)
        upvalue_2048 = nil
      end
    end
   end
  local onTouchEnded = function(l_5_0, l_5_1)
    if not start_click then
      return 
    end
    for ii = 1, #ui.animations do
      local tObj = ui.animations[ii]
      if tObj:containsPoint(CCPoint(l_5_0, l_5_1)) then
        audio.play(audio.button)
        ui.onClickAnimation(ii)
    else
      end
    end
    if selected_animation then
      clearShader(selected_animation, true)
      upvalue_1536 = nil
    end
    start_click = false
   end
  local onTouch = function(l_6_0, l_6_1, l_6_2)
    if l_6_0 == "began" then
      return onTouchBegan(l_6_1, l_6_2)
    elseif l_6_0 == "moved" then
      return onTouchMoved(l_6_1, l_6_2)
    else
      return onTouchEnded(l_6_1, l_6_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
end

ui.initData = function()
  local dressup_animations = {GROUP_ID_SNOWMAN = {ids = {}, count = 0}, GROUP_ID_WREATH = {ids = {}, count = 0}, GROUP_ID_TREE = {ids = {}, count = 0}}
  for k,v in ipairs(cfgwish) do
    if dressup_animations[v.group] then
      dressup_animations[v.group].ids[k] = 0
      dressup_animations[v.group].count = dressup_animations[v.group].count + 1
    end
  end
  ui.dressup_animations = dressup_animations
end

ui.clearData = function()
  ui.dressup_animations = nil
  ui.dressup_unlocked_arr = nil
  ui.widgets = nil
  ui.animations = nil
  ui.animations_ghost = nil
end

ui.update = function()
  local snowflake_obj = bagdata.items.find(ITEM_ID_SNOWFLAKE)
  local snowflake_count = snowflake_obj and snowflake_obj.num or 0
  ui.widgets.snowflake_label:setString(num2KM(snowflake_count))
  if not christmas.wishes then
    local dressup_unlocked_arr = {}
  end
  if ui.dressup_unlocked_arr then
    for k,v in ipairs(dressup_unlocked_arr) do
      if cfgwish[v] and ui.dressup_animations[cfgwish[v].group] and ui.dressup_animations[cfgwish[v].group].ids[v] == 0 then
        ui.dressup_animations[cfgwish[v].group].ids[v] = UNLOCK_STATUS.JUST_UNLOCK
      end
    end
  else
    for k,v in ipairs(dressup_unlocked_arr) do
      if cfgwish[v] and ui.dressup_animations[cfgwish[v].group] and ui.dressup_animations[cfgwish[v].group].ids[v] == 0 then
        ui.dressup_animations[cfgwish[v].group].ids[v] = UNLOCK_STATUS.ALREADY_UNLOCKED
      end
    end
  end
  ui.dressup_unlocked_arr = dressup_unlocked_arr
  ui.checkAndPlayAnimation()
end

ui.checkAndPlayAnimation = function()
  if ui.dressup_animations[GROUP_ID_SNOWMAN] then
    ui.playAnimation(ANIMATION_INDEX.SNOWMAN, GROUP_ID_SNOWMAN)
  end
  if ui.dressup_animations[GROUP_ID_WREATH] then
    ui.playAnimation(ANIMATION_INDEX.WREATH, GROUP_ID_WREATH)
  end
  if ui.dressup_animations[GROUP_ID_TREE] then
    ui.playAnimation(ANIMATION_INDEX.TREE, GROUP_ID_TREE)
  end
end

ui.playAnimation = function(l_7_0, l_7_1)
  local ani = ui.animations[l_7_0]
  if ani == nil then
    return 
  end
  ani:stopAnimation()
  ani:unregisterAllAnimation()
  local play_animation_num = 0
  local all_unlocked = true
  for k,v in pairs(ui.dressup_animations[l_7_1].ids) do
    if v == UNLOCK_STATUS.LOCKED then
      all_unlocked = false
      for k,v in (for generator) do
      end
      if v == UNLOCK_STATUS.JUST_UNLOCK then
        ani:clearNextAnimation()
        ani:playAnimation(ANIMATION_NAMES[k] .. "_ruchang", 1)
        ani:appendNextAnimation(ANIMATION_NAMES[k] .. "_loop", -1)
        play_animation_num = play_animation_num + 1
      end
    end
    for k,v in pairs(ui.dressup_animations[l_7_1].ids) do
      if v == UNLOCK_STATUS.JUST_UNLOCK then
        ui.dressup_animations[l_7_1].ids[k] = UNLOCK_STATUS.ALREADY_UNLOCKED
        for k,v in (for generator) do
        end
        if v == UNLOCK_STATUS.ALREADY_UNLOCKED then
          if play_animation_num > 0 then
            ani:registerAnimation(ANIMATION_NAMES[k] .. "_loop", -1)
          else
            ani:playAnimation(ANIMATION_NAMES[k] .. "_loop", -1)
            play_animation_num = play_animation_num + 1
          end
        end
        if ANIMATION_IDLE_NAMES[l_7_0] then
          if play_animation_num > 0 then
            ani:registerAnimation(ANIMATION_IDLE_NAMES[l_7_0], -1)
          else
            ani:playAnimation(ANIMATION_IDLE_NAMES[l_7_0], -1)
            play_animation_num = play_animation_num + 1
          end
          if not all_unlocked and ANIMATION_GLOW_NAMES[l_7_0] then
            if play_animation_num > 0 then
              ani:registerAnimation(ANIMATION_GLOW_NAMES[l_7_0], -1)
            else
              ani:playAnimation(ANIMATION_GLOW_NAMES[l_7_0], -1)
            end
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

ui.onClickAnimation = function(l_8_0)
  if l_8_0 == ANIMATION_INDEX.BOX then
    local dressup_exchange_box = require("ui.christmas.dressupexchangebox").create()
    ui.layer:getParent():getParent():getParent():addChild(dressup_exchange_box, 1000)
  else
    if l_8_0 == ANIMATION_INDEX.SNOWMAN then
      local dressup_exchange = require("ui.christmas.dressupexchange").create(GROUP_ID_SNOWMAN, function()
    ui.update()
   end)
      ui.layer:getParent():getParent():getParent():addChild(dressup_exchange, 1000)
    else
      if l_8_0 == ANIMATION_INDEX.WREATH then
        local dressup_exchange = require("ui.christmas.dressupexchange").create(GROUP_ID_WREATH, function()
      ui.update()
      end)
        ui.layer:getParent():getParent():getParent():addChild(dressup_exchange, 1000)
      else
        if l_8_0 == ANIMATION_INDEX.TREE then
          local dressup_exchange = require("ui.christmas.dressupexchange").create(GROUP_ID_TREE, function()
        ui.update()
         end)
          ui.layer:getParent():getParent():getParent():addChild(dressup_exchange, 1000)
        else
          if l_8_0 == ANIMATION_INDEX.RIBBON then
            local dressup_exchange_ribbon = require("ui.christmas.dressupexchangeribbon").create(function()
          ui.update()
            end)
            ui.layer:getParent():getParent():getParent():addChild(dressup_exchange_ribbon, 1000)
          end
        end
      end
    end
  end
end

ui.onEnter = function()
end

ui.onExit = function()
  ui.unloadRes()
  ui.clearData()
end

ui.loadRes = function()
  img.load(img.packedOthers.ui_christmas_dressup)
  img.load(img.packedOthers.spine_ui_Christmas)
  json.load(json.ui.christmas_baoxiang)
  json.load(json.ui.christmas_caiqi)
  json.load(json.ui.christmas_huanhuan)
  json.load(json.ui.christmas_shengdanshu)
  json.load(json.ui.christmas_xueren)
  json.load(json.ui.winter_main_snow_5)
end

ui.unloadRes = function()
  img.unload(img.packedOthers.ui_christmas_dressup)
  img.unload(img.packedOthers.spine_ui_Christmas)
  json.unload(json.ui.christmas_baoxiang)
  json.unload(json.ui.christmas_caiqi)
  json.unload(json.ui.christmas_huanhuan)
  json.unload(json.ui.christmas_shengdanshu)
  json.unload(json.ui.christmas_xueren)
  json.unload(json.ui.winter_main_snow_5)
end

return ui

