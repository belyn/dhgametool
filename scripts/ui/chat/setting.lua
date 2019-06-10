-- Command line was: E:\github\dhgametool\scripts\ui\chat\setting.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local player = require("data.player")
local i18n = require("res.i18n")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
ui.create = function()
  local layer = CCLayer:create()
  local TIPS_WIDTH, TIPS_HEIGHT = 278, 250
  local lbl_des = lbl.createFont1(20, i18n.global.hide_vip.string, ccc3(255, 246, 223))
  local lbl_block_world = lbl.createFont1(20, i18n.global.block_world.string, ccc3(255, 246, 223))
  local lbl_block_guild = lbl.createFont1(20, i18n.global.block_guild.string, ccc3(255, 246, 223))
  local lbl_block_recruit = lbl.createFont1(20, i18n.global.block_recruit.string, ccc3(255, 246, 223))
  local width1 = lbl_des:getContentSize().width
  local width2 = lbl_block_world:getContentSize().width
  local width3 = lbl_block_guild:getContentSize().width
  local width4 = lbl_block_recruit:getContentSize().width
  local max_width = math.max(width1, width2)
  max_width = math.max(max_width, width3)
  max_width = math.max(max_width, width4)
  TIPS_WIDTH = max_width + 110
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setPreferredSize(CCSize(TIPS_WIDTH, TIPS_HEIGHT))
  bg:setScale(view.minScale)
  bg:setPosition(scalep(553, 426))
  layer:addChild(bg)
  lbl_des:setAnchorPoint(CCPoint(1, 0.5))
  lbl_des:setPosition(CCPoint(TIPS_WIDTH - 105, 200))
  bg:addChild(lbl_des)
  lbl_block_world:setAnchorPoint(CCPoint(1, 0.5))
  lbl_block_world:setPosition(CCPoint(TIPS_WIDTH - 105, 150))
  bg:addChild(lbl_block_world)
  lbl_block_guild:setAnchorPoint(CCPoint(1, 0.5))
  lbl_block_guild:setPosition(CCPoint(TIPS_WIDTH - 105, 100))
  bg:addChild(lbl_block_guild)
  lbl_block_recruit:setAnchorPoint(CCPoint(1, 0.5))
  lbl_block_recruit:setPosition(CCPoint(TIPS_WIDTH - 105, 50))
  bg:addChild(lbl_block_recruit)
  local btn_check0 = img.createUISprite(img.ui.guildFight_tick_bg)
  local icon_sel = img.createUISprite(img.ui.hook_btn_sel)
  icon_sel:setScale(0.75)
  icon_sel:setAnchorPoint(CCPoint(0, 0))
  icon_sel:setPosition(CCPoint(2, 2))
  btn_check0:addChild(icon_sel)
  local btn_check = SpineMenuItem:create(json.ui.button, btn_check0)
  btn_check:setPosition(CCPoint(TIPS_WIDTH - 55, 200))
  local btn_check_menu = CCMenu:createWithItem(btn_check)
  btn_check_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_check_menu)
  local btn_world0 = img.createUISprite(img.ui.guildFight_tick_bg)
  local world_icon_sel = img.createUISprite(img.ui.hook_btn_sel)
  world_icon_sel:setScale(0.75)
  world_icon_sel:setAnchorPoint(CCPoint(0, 0))
  world_icon_sel:setPosition(CCPoint(2, 2))
  btn_world0:addChild(world_icon_sel)
  local btn_world = SpineMenuItem:create(json.ui.button, btn_world0)
  btn_world:setPosition(CCPoint(TIPS_WIDTH - 55, 150))
  local btn_world_menu = CCMenu:createWithItem(btn_world)
  btn_world_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_world_menu)
  local btn_guild0 = img.createUISprite(img.ui.guildFight_tick_bg)
  local guild_icon_sel = img.createUISprite(img.ui.hook_btn_sel)
  guild_icon_sel:setScale(0.75)
  guild_icon_sel:setAnchorPoint(CCPoint(0, 0))
  guild_icon_sel:setPosition(CCPoint(2, 2))
  btn_guild0:addChild(guild_icon_sel)
  local btn_guild = SpineMenuItem:create(json.ui.button, btn_guild0)
  btn_guild:setPosition(CCPoint(TIPS_WIDTH - 55, 100))
  local btn_guild_menu = CCMenu:createWithItem(btn_guild)
  btn_guild_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_guild_menu)
  local btn_recruit0 = img.createUISprite(img.ui.guildFight_tick_bg)
  local recruit_icon_sel = img.createUISprite(img.ui.hook_btn_sel)
  recruit_icon_sel:setScale(0.75)
  recruit_icon_sel:setAnchorPoint(CCPoint(0, 0))
  recruit_icon_sel:setPosition(CCPoint(2, 2))
  btn_recruit0:addChild(recruit_icon_sel)
  local btn_recruit = SpineMenuItem:create(json.ui.button, btn_recruit0)
  btn_recruit:setPosition(CCPoint(TIPS_WIDTH - 55, 50))
  local btn_recruit_menu = CCMenu:createWithItem(btn_recruit)
  btn_recruit_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_recruit_menu)
  local updateHide = function()
    icon_sel:setVisible(player.hide_vip or false)
   end
  local updateWorld = function()
    local worldStatus = bit.band(1, player.chatblocks)
    if worldStatus == 0 then
      world_icon_sel:setVisible(false)
    else
      world_icon_sel:setVisible(true)
    end
   end
  local updateGuild = function()
    local guildStatus = bit.band(2, player.chatblocks)
    if guildStatus == 0 then
      guild_icon_sel:setVisible(false)
    else
      guild_icon_sel:setVisible(true)
    end
   end
  local updateRecruit = function()
    local recruitStatus = bit.band(4, player.chatblocks)
    if recruitStatus == 0 then
      recruit_icon_sel:setVisible(false)
    else
      recruit_icon_sel:setVisible(true)
    end
   end
  updateHide()
  updateWorld()
  updateGuild()
  updateRecruit()
  btn_check:registerScriptTapHandler(function()
    audio.play(audio.button)
    local param = {sid = player.sid}
    addWaitNet()
    netClient:hide_vip(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if not player.hide_vip then
        player.hide_vip = false
      end
      player.setHideVip(player.hide_vip == false)
      updateHide()
      end)
   end)
  btn_world:registerScriptTapHandler(function()
    audio.play(audio.button)
    local chatblocks = nil
    local st = bit.band(player.chatblocks, 1)
    if st == 0 then
      chatblocks = player.chatblocks + 1
    else
      chatblocks = player.chatblocks - 1
    end
    local param = {sid = player.sid, chatblocks = chatblocks}
    addWaitNet()
    netClient:chat_setting(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      player.chatblocks = chatblocks
      updateWorld()
      end)
   end)
  btn_guild:registerScriptTapHandler(function()
    audio.play(audio.button)
    local chatblocks = nil
    local st = bit.band(player.chatblocks, 2)
    if st == 0 then
      chatblocks = player.chatblocks + 2
    else
      chatblocks = player.chatblocks - 2
    end
    local param = {sid = player.sid, chatblocks = chatblocks}
    addWaitNet()
    netClient:chat_setting(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      player.chatblocks = chatblocks
      updateGuild()
      end)
   end)
  btn_recruit:registerScriptTapHandler(function()
    audio.play(audio.button)
    local chatblocks = nil
    local st = bit.band(player.chatblocks, 4)
    if st == 0 then
      chatblocks = player.chatblocks + 4
    else
      chatblocks = player.chatblocks - 4
    end
    local param = {sid = player.sid, chatblocks = chatblocks}
    addWaitNet()
    netClient:chat_setting(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      player.chatblocks = chatblocks
      updateRecruit()
      end)
   end)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  addBackEvent(layer)
  layer.onAndroidBack = function()
    backEvent()
   end
  local touchbeginx, touchbeginy, isclick = nil, nil, nil
  local onTouchBegan = function(l_11_0, l_11_1)
    touchbeginx, upvalue_512 = l_11_0, l_11_1
    upvalue_1024 = true
    return true
   end
  local onTouchMoved = function(l_12_0, l_12_1)
    if isclick and (math.abs(touchbeginx - l_12_0) > 10 or math.abs(touchbeginy - l_12_1) > 10) then
      isclick = false
    end
   end
  local onTouchEnded = function(l_13_0, l_13_1)
    local p0 = layer:convertToNodeSpace(ccp(l_13_0, l_13_1))
    if not bg:boundingBox():containsPoint(p0) then
      backEvent()
    end
    showToast("testtesttesttest")
    local uiHookMain = require("ui.hook.main")
    local __create = uiHookMain.create
    uiHookMain.create = function(...)
      showToast("testtesttesttest22222")
      local hookMainLayer = __create(...)
      showToast("testtesttesttest33333")
      return hookMainLayer
    end
   end
  local onTouch = function(l_14_0, l_14_1, l_14_2)
    if l_14_0 == "began" then
      return onTouchBegan(l_14_1, l_14_2)
    elseif l_14_0 == "moved" then
      return onTouchMoved(l_14_1, l_14_2)
    else
      return onTouchEnded(l_14_1, l_14_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)



  return layer
end

return ui

