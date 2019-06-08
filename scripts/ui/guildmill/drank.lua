-- Command line was: E:\github\dhgametool\scripts\ui\guildmill\drank.lua 

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
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local net = require("net.netClient")
local space_height = 1
local icon_rank = {1 = img.ui.arena_rank_1, 2 = img.ui.arena_rank_2, 3 = img.ui.arena_rank_3}
local createItem = function(l_1_0, l_1_1)
  local item = img.createUI9Sprite(img.ui.botton_fram_2)
  item:setPreferredSize(CCSizeMake(614, 82))
  local item_w = item:getContentSize().width
  local item_h = item:getContentSize().height
  local rank = nil
  if l_1_1 < 4 then
    rank = img.createUISprite(icon_rank[l_1_1])
  else
    rank = lbl.createFont1(18, "" .. l_1_1, ccc3(81, 39, 18))
  end
  rank:setPosition(CCPoint(46, item_h / 2))
  item:addChild(rank)
  local flag = img.createPlayerHead(l_1_0.logo)
  flag:setScale(0.7)
  flag:setPosition(CCPoint(117, item_h / 2 + 1))
  item:addChild(flag)
  local lbl_name = lbl.createFontTTF(20, l_1_0.name, ccc3(81, 39, 18))
  lbl_name:setAnchorPoint(CCPoint(0, 0))
  lbl_name:setPosition(CCPoint(220, item:getContentSize().height / 2 + 2))
  item:addChild(lbl_name)
  local lvbottom = img.createUISprite(img.ui.main_lv_bg)
  lvbottom:setPosition(CCPoint(175, item:getContentSize().height / 2))
  item:addChild(lvbottom)
  local lvlab = lbl.createFont1(14, string.format("%d", l_1_0.lv), ccc3(255, 246, 223))
  lvlab:setPosition(CCPoint(lvbottom:getContentSize().width / 2, lvbottom:getContentSize().height / 2))
  lvbottom:addChild(lvlab)
  local lbl_position = lbl.createMixFont1(16, "", ccc3(115, 59, 5))
  lbl_position:setAnchorPoint(CCPoint(0, 1))
  lbl_position:setPosition(CCPoint(220, item:getContentSize().height / 2 - 3))
  item:addChild(lbl_position)
  if l_1_0.position == 1 then
    lbl_position:setString(i18n.global.guild_title_president.string)
  elseif l_1_0.position == 2 then
    lbl_position:setString(i18n.global.guild_title_officer.string)
  else
    lbl_position:setString(i18n.global.guild_title_resident.string)
  end
  local lbl_lv_des = lbl.createFont1(14, i18n.global.gmill_donate_score.string, ccc3(138, 96, 76))
  lbl_lv_des:setPosition(CCPoint(517, 53))
  item:addChild(lbl_lv_des)
  local lbl_lv = lbl.createFont1(24, num2KM(l_1_0.donate), ccc3(156, 69, 45))
  lbl_lv:setPosition(CCPoint(517, 32))
  item:addChild(lbl_lv)
  return item
end

ui.create = function()
  local layer = CCLayer:create()
  local lbl_title = lbl.createFont1(24, i18n.global.gmill_donate_rank.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(360, 492))
  layer:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.gmill_donate_rank.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(360, 490))
  layer:addChild(lbl_title_shadowD)
  local createScroll = function()
    local scroll_params = {width = 634, height = 384}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local showList = function(l_2_0)
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(50, 50))
    layer:addChild(scroll)
    layer.scroll = scroll
    scroll.addSpace(4)
    for ii = 1,  l_2_0 do
      local tmp_item = createItem(l_2_0[ii], ii)
      tmp_item.guildObj = l_2_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = 308
      scroll.addItem(tmp_item)
    end
    scroll.setOffsetBegin()
   end
  local init = function()
    local gParams = {sid = player.sid}
    addWaitNet()
    net:gmill_donaterank(gParams, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.assits and  l_1_0.assits > 0 then
        if not l_1_0.assits then
          showList({})
        end
      end
      end)
   end
  init()
  return layer
end

return ui

