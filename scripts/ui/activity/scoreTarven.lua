-- Command line was: E:\github\dhgametool\scripts\ui\activity\scoreTarven.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.monthlyactivity")
local player = require("data.player")
local activityData = require("data.monthlyactivity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local IDS = activityData.IDS
local ItemType = {Item = 1, Equip = 2}
local MaxPoints = {IDS.SCORE_TARVEN_4.ID = cfgactivity[IDS.SCORE_TARVEN_4.ID].parameter[1].qlt, IDS.SCORE_TARVEN_5.ID = cfgactivity[IDS.SCORE_TARVEN_5.ID].parameter[1].qlt, IDS.SCORE_TARVEN_6.ID = cfgactivity[IDS.SCORE_TARVEN_6.ID].parameter[1].qlt, IDS.SCORE_TARVEN_7.ID = cfgactivity[IDS.SCORE_TARVEN_7.ID].parameter[1].qlt, IDS.SCORE_TARVEN_ALL.ID = 1}
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local st1 = activityData.getStatusById(IDS.SCORE_TARVEN_4.ID)
  local st2 = activityData.getStatusById(IDS.SCORE_TARVEN_5.ID)
  local st3 = activityData.getStatusById(IDS.SCORE_TARVEN_6.ID)
  local st4 = activityData.getStatusById(IDS.SCORE_TARVEN_7.ID)
  local st5 = activityData.getStatusById(IDS.SCORE_TARVEN_ALL.ID)
  st1.instruct = MaxPoints[IDS.SCORE_TARVEN_4.ID]
  st1.des = string.format(i18n.global.scoretarven_item_des.string, 4)
  st2.instruct = MaxPoints[IDS.SCORE_TARVEN_5.ID]
  st2.des = string.format(i18n.global.scoretarven_item_des.string, 5)
  st3.instruct = MaxPoints[IDS.SCORE_TARVEN_6.ID]
  st3.des = string.format(i18n.global.scoretarven_item_des.string, 6)
  st4.instruct = MaxPoints[IDS.SCORE_TARVEN_7.ID]
  st4.des = string.format(i18n.global.scoretarven_item_des.string, 7)
  st5.instruct = MaxPoints[IDS.SCORE_TARVEN_ALL.ID]
  st5.des = string.format(i18n.global.scoretarven_allitem_des.string)
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(576, 436))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_tarven)
  local banner = img.createUISprite("activity_tarven_board.png")
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2, board_h))
  board:addChild(banner)
  local suffix = "us"
  if i18n.getCurrentLanguage() == kLanguageKorean then
    suffix = "kr"
  else
    if i18n.getCurrentLanguage() == kLanguageChinese then
      suffix = "cn"
    else
      if i18n.getCurrentLanguage() == kLanguageChineseTW then
        suffix = "tw"
      else
        if i18n.getCurrentLanguage() == kLanguageJapanese then
          suffix = "jp"
        else
          if i18n.getCurrentLanguage() == kLanguageRussian then
            suffix = "ru"
          else
            if i18n.getCurrentLanguage() == kLanguagePortuguese then
              suffix = "pt"
            else
              suffix = "us"
            end
          end
        end
      end
    end
  end
  local title = img.createUISprite(string.format("activity_tarven_board_%s.png", suffix))
  title:setPosition(384, 105)
  banner:addChild(title)
  local lbl_cd = lbl.createFont2(16, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(1, 0.5))
  lbl_cd:setPosition(CCPoint(383, 40))
  banner:addChild(lbl_cd)
  local lbl_cd_des = lbl.createFont2(16, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd_des:setPosition(CCPoint(388, 40))
  banner:addChild(lbl_cd_des)
  local createItem = function(l_1_0)
    local temp_item = img.createUI9Sprite(img.ui.bottom_border_2)
    temp_item:setPreferredSize(CCSizeMake(574, 102))
    local item_w = temp_item:getContentSize().width
    local item_h = temp_item:getContentSize().height
    local lbl_des = lbl.createMixFont1(14, l_1_0.des, ccc3(93, 45, 18))
    lbl_des:setAnchorPoint(CCPoint(0, 0.5))
    lbl_des:setPosition(CCPoint(23, 67))
    temp_item:addChild(lbl_des)
    local pgb_bg = img.createUI9Sprite(img.ui.playerInfo_process_bar_bg)
    pgb_bg:setPreferredSize(CCSizeMake(203, 20))
    pgb_bg:setPosition(CCPoint(125, 36))
    temp_item:addChild(pgb_bg)
    local pgb_fg = img.createUISprite(img.ui.activity_pgb_casino)
    local pgb = createProgressBar(pgb_fg)
    pgb:setPosition(CCPoint(pgb_bg:getContentSize().width / 2, pgb_bg:getContentSize().height / 2))
    pgb_bg:addChild(pgb)
    local numerator = 0
    if l_1_0.instruct <= l_1_0.num then
      numerator = l_1_0.instruct
    else
      numerator = l_1_0.num
    end
    pgb:setPercentage(numerator * 100 / l_1_0.instruct)
    local lbl_pgb = lbl.createFont2(14, numerator .. "/" .. l_1_0.instruct)
    lbl_pgb:setAnchorPoint(CCPoint(0.5, 0))
    lbl_pgb:setPosition(CCPoint(pgb_bg:getContentSize().width / 2, pgb_bg:getContentSize().height / 2))
    pgb_bg:addChild(lbl_pgb)
    local max_x = 520
    local step_x = 73
    l_1_0.rewards = cfgactivity[l_1_0.id].rewards
    local rewards_count =  l_1_0.rewards
    for ii = rewards_count, 1, -1 do
      local _obj = l_1_0.rewards[ii]
      do
        if _obj.type == ItemType.Equip then
          local _item0 = img.createEquip(_obj.id, _obj.num)
          if l_1_0.instruct <= l_1_0.num then
            local _mask = img.createUISprite(img.ui.hook_btn_mask)
            _mask:setPosition(CCPoint(_item0:getContentSize().width / 2, _item0:getContentSize().height / 2))
            _item0:addChild(_mask, 100)
            local _sel = img.createUISprite(img.ui.hook_btn_sel)
            _sel:setPosition(CCPoint(_item0:getContentSize().width / 2, _item0:getContentSize().height / 2))
            _item0:addChild(_sel, 100)
          end
          local _item = CCMenuItemSprite:create(_item0, nil)
          _item:setScale(0.8)
          _item:setPosition(CCPoint(max_x - (rewards_count - ii) * step_x, item_h / 2))
          local _item_menu = CCMenu:createWithItem(_item)
          _item_menu:setPosition(CCPoint(0, 0))
          temp_item:addChild(_item_menu)
          _item:registerScriptTapHandler(function()
            audio.play(audio.button)
            layer:getParent():getParent():getParent():addChild(tipsequip.createById(_obj.id), 1000)
               end)
        else
          if _obj.type == ItemType.Item then
            local _item0 = img.createItem(_obj.id, _obj.num)
            if l_1_0.instruct <= l_1_0.num then
              local _mask = img.createUISprite(img.ui.hook_btn_mask)
              _mask:setPosition(CCPoint(_item0:getContentSize().width / 2, _item0:getContentSize().height / 2))
              _item0:addChild(_mask, 100)
              local _sel = img.createUISprite(img.ui.hook_btn_sel)
              _sel:setPosition(CCPoint(_item0:getContentSize().width / 2, _item0:getContentSize().height / 2))
              _item0:addChild(_sel, 100)
            end
            local _item = CCMenuItemSprite:create(_item0, nil)
            _item:setScale(0.8)
            _item:setPosition(CCPoint(max_x - (rewards_count - ii) * step_x, item_h / 2 + 2))
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
  local scroll_params = {width = 574, height = 218}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(1, 3))
  board:addChild(scroll)
  layer.scroll = scroll
  local items = {1 = st1, 2 = st2, 3 = st3, 4 = st4, 5 = st5}
  local showList = function(l_2_0)
    for ii = 1,  l_2_0 do
      local tmp_item = createItem(l_2_0[ii])
      tmp_item.obj = l_2_0[ii]
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
  local last_update = os.time() - 1
  local onUpdate = function(l_3_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    local remain_cd = st1.cd - (os.time() - activityData.pull_time)
    if remain_cd >= 0 then
      local time_str = time2string(remain_cd)
      lbl_cd:setString(time_str)
    else
       -- Warning: missing end command somewhere! Added here
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  layer:registerScriptHandler(function(l_4_0)
    if l_4_0 == "enter" then
      do return end
    end
    if l_4_0 == "exit" then
      do return end
    end
    if l_4_0 == "cleanup" then
      img.unload(img.packedOthers.ui_activity_tarven)
    end
   end)
  l_1_0(layer, scroll)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui

