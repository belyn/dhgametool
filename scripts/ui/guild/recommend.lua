-- Command line was: E:\github\dhgametool\scripts\ui\guild\recommend.lua 

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
local player = require("data.player")
local gdata = require("data.guild")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local dialog = require("ui.dialog")
local board1 = require("ui.guild.board1")
local gitem = require("ui.guild.gitem")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local space_height = 6
local pullRecommend = function(l_1_0)
  local params = {sid = player.sid}
  addWaitNet()
  netClient:guild_recommend(params, function(l_1_0)
    delWaitNet()
    tbl2string(l_1_0)
    if callback and not l_1_0.guilds then
      callback({})
    end
   end)
end

ui.create = function(l_2_0, l_2_1)
  local layer = board1.create(board1.TAB.GUILD, l_2_1)
  local board = layer.board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local lbl_des = lbl.createFont1(18, i18n.global.guild_recommend_des.string, ccc3(73, 38, 4))
  lbl_des:setAnchorPoint(CCPoint(0, 0))
  lbl_des:setPosition(CCPoint(36, 322))
  board:addChild(lbl_des)
  local btn_refresh0 = img.createUISprite(img.ui.friends_refresh)
  local btn_refresh = SpineMenuItem:create(json.ui.button, btn_refresh0)
  btn_refresh:setPosition(CCPoint(551, 332))
  local btn_refresh_menu = CCMenu:createWithItem(btn_refresh)
  btn_refresh_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_refresh_menu)
  local container = CCSprite:create()
  container:setContentSize(CCSizeMake(640, 277))
  container:setAnchorPoint(CCPoint(0.5, 0))
  container:setPosition(CCPoint(board_w / 2, 27))
  board:addChild(container)
  local createScroll = function()
    local scroll_params = {width = 640, height = 277}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local showList = function(l_2_0)
    container:removeAllChildrenWithCleanup(true)
    container.scroll = nil
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(0, 0))
    container:addChild(scroll)
    container.scroll = scroll
    for ii = 1, #l_2_0 do
      local tmp_item = gitem.createItem(l_2_0[ii])
      tmp_item.guildObj = l_2_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = 320
      scroll.addItem(tmp_item)
      if ii ~= #l_2_0 then
        scroll.addSpace(space_height)
      end
    end
    scroll.setOffsetBegin()
   end
  layer:runAction(CCCallFunc:create(function()
    pullRecommend(showList)
   end))
  btn_refresh:registerScriptTapHandler(function()
    audio.play(audio.button)
    btn_refresh:setEnabled(false)
    local ani_arr = CCArray:create()
    ani_arr:addObject(CCCallFunc:create(function()
      container:removeAllChildrenWithCleanup(true)
      end))
    ani_arr:addObject(CCDelayTime:create(0.2))
    ani_arr:addObject(CCCallFunc:create(function()
      pullRecommend(showList)
      btn_refresh:setEnabled(true)
      end))
    layer:runAction(CCSequence:create(ani_arr))
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

