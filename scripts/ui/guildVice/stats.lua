-- Command line was: E:\github\dhgametool\scripts\ui\guildVice\stats.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local BG_WIDTH = 710
local BG_HEIGHT = 512
local calPercent = function(l_1_0)
  if not l_1_0 or  l_1_0 <= 0 then
    return 
  end
  local base = l_1_0[1].hurt
  for ii = 1,  l_1_0 do
    l_1_0[ii].percent = l_1_0[ii].hurt * 100 / base
  end
end

ui.create = function(l_2_0)
  local layer = CCLayer:create()
  calPercent(l_2_0.data)
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board = img.createUI9Sprite(img.ui.tips_bg)
  board:setPreferredSize(CCSize(BG_WIDTH, BG_HEIGHT))
  board:setScale(view.minScale * 0.1)
  board:setAnchorPoint(ccp(0.5, 0.5))
  board:setPosition(view.midX, view.midY)
  board:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  layer:addChild(board)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local closeBtn0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(BG_WIDTH - 23, BG_HEIGHT - 26)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  board:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    backEvent()
   end)
  local lbl_title_rank = lbl.createFont1(20, i18n.global.guildvice_dps_rank.string, ccc3(249, 227, 154))
  lbl_title_rank:setPosition(CCPoint(99, 479))
  board:addChild(lbl_title_rank)
  local lbl_title_dps = lbl.createFont1(20, i18n.global.guildvice_dps_hurt.string, ccc3(249, 227, 154))
  lbl_title_dps:setPosition(CCPoint(320, 479))
  board:addChild(lbl_title_dps)
  local lbl_title_reward = lbl.createFont1(20, i18n.global.guildvice_dps_reward.string, ccc3(249, 227, 154))
  lbl_title_reward:setPosition(CCPoint(578, 479))
  board:addChild(lbl_title_reward)
  local lineScroll = require("ui.lineScroll")
  local scroll_params = {width = BG_WIDTH, height = 445}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(0, 9))
  board:addChild(scroll)
  local createItem = function(l_3_0, l_3_1)
    local item = CCSprite:create()
    item:setContentSize(CCSizeMake(704, 74))
    local item_l = img.createUISprite(img.ui.fight_hurts_bg_2)
    item_l:setAnchorPoint(CCPoint(1, 0))
    item_l:setPosition(CCPoint(352, 0))
    item:addChild(item_l)
    local item_r = img.createUISprite(img.ui.fight_hurts_bg_2)
    item_r:setFlipX(true)
    item_r:setAnchorPoint(CCPoint(0, 0))
    item_r:setPosition(CCPoint(352, 0))
    item:addChild(item_r)
    if l_3_1 % 2 == 1 then
      item_l:setOpacity(178.5)
      item_r:setOpacity(178.5)
    end
    local item_w = item:getContentSize().width
    local item_h = item:getContentSize().height
    local tmp_rank = nil
    if l_3_1 == 1 then
      tmp_rank = img.createUISprite(img.ui.arena_rank_1)
    elseif l_3_1 == 2 then
      tmp_rank = img.createUISprite(img.ui.arena_rank_2)
    elseif l_3_1 == 3 then
      tmp_rank = img.createUISprite(img.ui.arena_rank_3)
    else
      tmp_rank = lbl.createFont1(16, "" .. l_3_1, ccc3(255, 255, 255))
    end
    tmp_rank:setPosition(CCPoint(55, item_h / 2))
    item:addChild(tmp_rank)
    local head = img.createPlayerHead(l_3_0.logo)
    head:setScale(0.65)
    head:setPosition(CCPoint(125, item_h / 2 + 1))
    item:addChild(head)
    local pgb_bg = img.createUI9Sprite(img.ui.fight_hurts_bar_bg)
    pgb_bg:setPreferredSize(CCSize(276, 19))
    pgb_bg:setPosition(CCPoint(320, 21))
    item:addChild(pgb_bg)
    local pgb_fg = img.createUISprite(img.ui.guildvice_dps_fg)
    local pgb = createProgressBar(pgb_fg)
    pgb:setPosition(CCPoint(pgb_bg:getContentSize().width / 2, pgb_bg:getContentSize().height / 2))
    pgb_bg:addChild(pgb)
    pgb:setPercentage(l_3_0.percent)
    local lbl_mem_name = lbl.createFontTTF(20, l_3_0.name)
    lbl_mem_name:setAnchorPoint(CCPoint(0, 0.5))
    lbl_mem_name:setPosition(CCPoint(183, 55))
    item:addChild(lbl_mem_name)
    local lbl_hurt = lbl.createFont2(16, "" .. l_3_0.hurt, ccc3(248, 242, 226))
    lbl_hurt:setAnchorPoint(CCPoint(1, 0.5))
    lbl_hurt:setPosition(CCPoint(352, item_h / 2 - 9))
    item:addChild(lbl_hurt)
    local r_container = CCSprite:create()
    r_container:setContentSize(CCSizeMake(189, 62))
    r_container:setPosition(CCPoint(578, item_h / 2))
    item:addChild(r_container)
    local rewards = pbbag2reward(l_3_0.reward)
    for ii = 1,  rewards do
      do
        if rewards[ii].type == 1 then
          local tmp_item0 = img.createItem(rewards[ii].id, rewards[ii].num)
          local tmp_item = CCMenuItemSprite:create(tmp_item0, nil)
          tmp_item:setScale(0.7)
          tmp_item:setPosition(CCPoint((ii - 1) * 65 + 31, 31))
          local tmp_item_menu = CCMenu:createWithItem(tmp_item)
          tmp_item_menu:setPosition(CCPoint(0, 0))
          r_container:addChild(tmp_item_menu)
          tmp_item:registerScriptTapHandler(function()
            audio.play(audio.button)
            local tmp_tip = tipsitem.createForShow({id = rewards[ii].id})
            layer:addChild(tmp_tip, 100)
               end)
        else
          if rewards[ii].type == 2 then
            local tmp_item0 = img.createEquip(rewards[ii].id, rewards[ii].num)
            local tmp_item = CCMenuItemSprite:create(tmp_item0, nil)
            tmp_item:setScale(0.7)
            tmp_item:setPosition(CCPoint((ii - 1) * 65 + 31, 31))
            local tmp_item_menu = CCMenu:createWithItem(tmp_item)
            tmp_item_menu:setPosition(CCPoint(0, 0))
            r_container:addChild(tmp_item_menu)
            tmp_item:registerScriptTapHandler(function()
              audio.play(audio.button)
              local tmp_tip = tipsequip.createById(rewards[ii].id)
              layer:addChild(tmp_tip, 100)
                  end)
          end
        end
      end
    end
    return item
   end
  local showList = function(l_4_0)
    if not l_4_0 or  l_4_0 <= 0 then
      return 
    end
    for ii = 1,  l_4_0 do
      local tmp_item = createItem(l_4_0[ii], ii)
      scroll.addItem(tmp_item)
    end
    scroll.setOffsetBegin()
   end
  showList(l_2_0.data)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

