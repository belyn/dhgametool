-- Command line was: E:\github\dhgametool\scripts\ui\guildmill\hrecord.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local player = require("data.player")
local net = require("net.netClient")
local space_height = 0
local BG_WIDTH = 620
local BG_HEIGHT = 416
local perall = 0
local icon_rank = {1 = img.ui.arena_rank_1, 2 = img.ui.arena_rank_2, 3 = img.ui.arena_rank_3}
local createItem = function(l_1_0, l_1_1, l_1_2)
  local item1 = CCSprite:create()
  item1:setContentSize(CCSize(288, 32))
  local lbl_name = lbl.createFontTTF(18, l_1_0.name, ccc3(255, 246, 223))
  lbl_name:setPosition(CCPoint(105, 15))
  item1:addChild(lbl_name)
  local lbl_ser = lbl.createFontTTF(18, string.format("%d", l_1_0.sid), ccc3(255, 238, 91))
  lbl_ser:setPosition(CCPoint(295, 15))
  item1:addChild(lbl_ser)
  local flag = nil
  if l_1_0.win == true then
    flag = img.createUISprite(img.ui.guild_mill_win)
  else
    flag = img.createUISprite(img.ui.guild_mill_lose)
  end
  flag:setPosition(CCPoint(475, 15))
  item1:addChild(flag)
  return item1
end

ui.create = function()
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setPreferredSize(CCSize(BG_WIDTH, BG_HEIGHT))
  bg:setScale(view.minScale * 0.1)
  bg:setAnchorPoint(ccp(0.5, 0.5))
  bg:setPosition(view.midX, view.midY)
  bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  layer:addChild(bg)
  local titleLabel = lbl.createFont1(24, i18n.global.gmill_hrecord_title.string, ccc3(255, 227, 134))
  titleLabel:setPosition(BG_WIDTH / 2, BG_HEIGHT - 36)
  bg:addChild(titleLabel)
  local line = img.createUISprite(img.ui.help_line)
  line:setScaleX(590 / line:getContentSize().width)
  line:setPosition(CCPoint(BG_WIDTH / 2, BG_HEIGHT - 62))
  bg:addChild(line)
  local infobg = img.createUISprite(img.ui.guild_vtitle_bg)
  infobg:setPosition(BG_WIDTH / 2, BG_HEIGHT - 82)
  bg:addChild(infobg)
  local namelab = lbl.createFont1(18, i18n.global.guild_create_guild_name.string, ccc3(235, 170, 94))
  namelab:setPosition(CCPoint(108, infobg:getContentSize().height / 2))
  infobg:addChild(namelab)
  local serverlab = lbl.createFont1(18, i18n.global.setting_title_servers.string, ccc3(235, 170, 94))
  serverlab:setPosition(CCPoint(295, infobg:getContentSize().height / 2))
  infobg:addChild(serverlab)
  local timelab = lbl.createFont1(18, i18n.global.gmill_hrecord_result.string, ccc3(235, 170, 94))
  timelab:setPosition(CCPoint(472, infobg:getContentSize().height / 2))
  infobg:addChild(timelab)
  local createScroll = function()
    local scroll_params = {width = 526, height = 306}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local showList = function(l_2_0)
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(1, 15))
    bg:addChild(scroll)
    bg.scroll = scroll
    scroll.addSpace(4)
    for ii = 1, #l_2_0 do
      local tmp_item = createItem(l_2_0[ii], ii, layer)
      tmp_item.guildObj = l_2_0[ii]
      tmp_item.ax = 1
      tmp_item.px = 302
      scroll.addItem(tmp_item)
      if ii ~= #l_2_0 then
        scroll.addSpace(space_height)
      end
    end
    scroll.setOffsetBegin()
   end
  local init = function()
    local gParams = {sid = player.sid}
    addWaitNet()
    net:gmill_olog(gParams, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.users then
        local harrydata = l_1_0.users
        showList(harrydata)
      else
        local empty = require("ui.empty")
        local emptyBox = empty.create({text = i18n.global.gmill_hrecord_empty.string, color = ccc3(255, 246, 223)})
        emptyBox:setPosition(bg:getContentSize().width / 2, bg:getContentSize().height / 2 - 20)
        bg:addChild(emptyBox)
      end
      end)
   end
  init()
  local closeBtn0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(BG_WIDTH - 23, BG_HEIGHT - 26)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  bg:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer.onAndroidBack()
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParent()
   end
  layer:registerScriptHandler(function(l_6_0)
    if l_6_0 == "enter" then
      layer.notifyParentLock()
    elseif l_6_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

