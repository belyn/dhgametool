-- Command line was: E:\github\dhgametool\scripts\ui\activity\scoreCasino.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.activity")
local player = require("data.player")
local activityData = require("data.activity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local IDS = activityData.IDS
local ItemType = {Item = 1, Equip = 2}
local MaxPoints = cfgactivity[IDS.SCORE_CASINO.ID].instruct
ui.create = function()
  local layer = CCLayer:create()
  local st1 = activityData.getStatusById(IDS.SCORE_CASINO.ID)
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(576, 436))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_casino)
  local banner = img.createUISprite(img.ui.activity_wishing_board)
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2, board_h))
  board:addChild(banner)
  local bannerLabel = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    bannerLabel = img.createUISprite("activity_wishing_board_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageJapanese then
      bannerLabel = img.createUISprite("activity_wishing_board_jp.png")
    else
      if i18n.getCurrentLanguage() == kLanguageChinese then
        bannerLabel = img.createUISprite("activity_wishing_board_cn.png")
      else
        if i18n.getCurrentLanguage() == kLanguageChineseTW then
          bannerLabel = img.createUISprite("activity_wishing_board_tw.png")
        else
          if i18n.getCurrentLanguage() == kLanguagePortuguese then
            bannerLabel = img.createUISprite("activity_wishing_board_pt.png")
          else
            bannerLabel = img.createUISprite("activity_wishing_board_us.png")
          end
        end
      end
    end
  end
  bannerLabel:setAnchorPoint(CCPoint(0.5, 1))
  bannerLabel:setPosition(CCPoint(board_w / 2 - 90, board_h - 18))
  board:addChild(bannerLabel)
  local finish_node = CCSprite:create()
  finish_node:setPosition(210, 20)
  banner:addChild(finish_node)
  local finish_str = "(" .. st1.loop .. "/" .. cfgactivity[st1.id].limitNum .. ")"
  local lbl_finish = lbl.createFont2(14, finish_str)
  lbl_finish:setAnchorPoint(CCPoint(0, 0.5))
  lbl_finish:setPosition(CCPoint(3, 0))
  finish_node:addChild(lbl_finish)
  local finish_des = lbl.createFont2(14, i18n.global.herotask_finish.string)
  finish_des:setAnchorPoint(CCPoint(1, 0.5))
  finish_des:setPosition(CCPoint(-3, 0))
  finish_node:addChild(finish_des)
  local item_des = "GET %s POINTS"
  if i18n.getCurrentLanguage() == kLanguageChinese or i18n.getCurrentLanguage() == kLanguageChineseTW then
    item_des = "\232\142\183\229\190\151 %s \231\167\175\229\136\134"
  end
  item_des = i18n.global.spesummon_gain.string .. " %s " .. i18n.global.arena_main_score.string
  local createItem = function(l_1_0)
    local temp_item = img.createUI9Sprite(img.ui.bottom_border_2)
    temp_item:setPreferredSize(CCSizeMake(542, 84))
    local item_w = temp_item:getContentSize().width
    local item_h = temp_item:getContentSize().height
    local lbl_des = lbl.createFont1(16, string.format(item_des, l_1_0.instruct), ccc3(93, 45, 18))
    lbl_des:setAnchorPoint(CCPoint(0, 0.5))
    lbl_des:setPosition(CCPoint(18, 55))
    temp_item:addChild(lbl_des)
    local pgb_bg = img.createUI9Sprite(img.ui.playerInfo_process_bar_bg)
    pgb_bg:setPreferredSize(CCSizeMake(203, 20))
    pgb_bg:setPosition(CCPoint(120, 26))
    temp_item:addChild(pgb_bg)
    local pgb_fg = img.createUISprite(img.ui.activity_pgb_casino)
    local pgb = createProgressBar(pgb_fg)
    pgb:setPosition(CCPoint(pgb_bg:getContentSize().width / 2, pgb_bg:getContentSize().height / 2))
    pgb_bg:addChild(pgb)
    local numerator = 0
    if l_1_0.instruct <= st1.limits then
      numerator = l_1_0.instruct
    else
      numerator = st1.limits
    end
    pgb:setPercentage(numerator * 100 / l_1_0.instruct)
    local lbl_pgb = lbl.createFont2(14, numerator .. "/" .. l_1_0.instruct)
    lbl_pgb:setAnchorPoint(CCPoint(0.5, 0))
    lbl_pgb:setPosition(CCPoint(pgb_bg:getContentSize().width / 2, pgb_bg:getContentSize().height / 2))
    pgb_bg:addChild(lbl_pgb)
    local r_pos = {1 = 490, 2 = 420, 3 = 350, 4 = 280}
    for ii = 1,  l_1_0.rewards do
      local _obj = l_1_0.rewards[ii]
      do
        if _obj.type == ItemType.Equip then
          local _item0 = img.createEquip(_obj.id, _obj.num)
          local _item = CCMenuItemSprite:create(_item0, nil)
          _item:setPosition(CCPoint(r_pos[ii], item_h / 2 + 1))
          if l_1_0.instruct <= st1.limits then
            local _mask = img.createUISprite(img.ui.hook_btn_mask)
            _mask:setScale(0.9)
            _mask:setPosition(CCPoint(_item0:getContentSize().width / 2, _item0:getContentSize().height / 2))
            _item0:addChild(_mask, 100)
            local _sel = img.createUISprite(img.ui.hook_btn_sel)
            _sel:setPosition(CCPoint(_item0:getContentSize().width / 2, _item0:getContentSize().height / 2))
            _item0:addChild(_sel, 100)
          end
          _item:setScale(0.7)
          local _item_menu = CCMenu:createWithItem(_item)
          _item_menu:setPosition(CCPoint(0, 0))
          temp_item:addChild(_item_menu)
          _item:registerScriptTapHandler(function()
            audio.play(audio.button)
            layer:addChild(tipsequip.createById(_obj.id), 100)
               end)
        else
          if _obj.type == ItemType.Item then
            local _item0 = img.createItem(_obj.id, _obj.num)
            local _item = CCMenuItemSprite:create(_item0, nil)
            _item:setPosition(CCPoint(r_pos[ii], item_h / 2 + 1))
            if l_1_0.instruct <= st1.limits then
              local _mask = img.createUISprite(img.ui.hook_btn_mask)
              _mask:setPosition(CCPoint(_item0:getContentSize().width / 2, _item0:getContentSize().height / 2))
              _mask:setScale(0.95)
              _item0:addChild(_mask, 100)
              local _sel = img.createUISprite(img.ui.hook_btn_sel)
              _sel:setPosition(CCPoint(_item0:getContentSize().width / 2, _item0:getContentSize().height / 2))
              _item0:addChild(_sel, 100)
            end
            _item:setScale(0.7)
            local _item_menu = CCMenu:createWithItem(_item)
            _item_menu:setPosition(CCPoint(0, 0))
            temp_item:addChild(_item_menu)
            _item:registerScriptTapHandler(function()
              audio.play(audio.button)
              layer:getParent():getParent():getParent():addChild(tipsitem.createForShow({id = _obj.id}), 1000)
                  end)
          end
        end
      end
    end
    temp_item.height = item_h
    return temp_item
   end
  local lineScroll = require("ui.lineScroll")
  local scroll_params = {width = 550, height = 241}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(14, 3))
  board:addChild(scroll)
  layer.scroll = scroll
  local items = {}
  for ii = 3, 0, -1 do
    items[ items + 1] = clone(cfgactivity[st1.id - ii])
  end
  local sortValue = function(l_2_0)
    if l_2_0.instruct <= st1.limits then
      return 10000 + l_2_0.instruct
    else
      return l_2_0.instruct
    end
   end
  table.sort(items, function(l_3_0, l_3_1)
    return sortValue(l_3_0) < sortValue(l_3_1)
   end)
  local showList = function(l_4_0)
    for ii = 1,  l_4_0 do
      local tmp_item = createItem(l_4_0[ii])
      tmp_item.obj = l_4_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = scroll_params.width / 2
      scroll.addItem(tmp_item)
      if ii ~= item_count then
        scroll.addSpace(3)
      end
    end
    scroll.setOffsetBegin()
   end
  showList(items)
  img.unload(img.packedOthers.ui_activity_casino)
  require("ui.activity.ban").addBan(layer, scroll)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui

