-- Command line was: E:\github\dhgametool\scripts\ui\activity\scoreFight.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgmactivity = require("config.monthlyactivity")
local player = require("data.player")
local mactivityData = require("data.monthlyactivity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local IDS = mactivityData.IDS
local ItemType = {Item = 1, Equip = 2}
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local st1 = mactivityData.getStatusById(IDS.SCORE_FIGHT.ID)
  local st2 = mactivityData.getStatusById(IDS.SCORE_FIGHT2.ID)
  local st3 = mactivityData.getStatusById(IDS.SCORE_FIGHT3.ID)
  local dot1 = 4
  local dot2 = 8
  local dot1Limit = cfgmactivity[IDS.SCORE_FIGHT.ID].parameter[1].qlt
  local dot2Limit = cfgmactivity[IDS.SCORE_FIGHT2.ID].parameter[1].qlt
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(576, 436))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_fight)
  local banner = img.createUISprite(img.ui.activity_fight_board)
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
  local title = img.createUISprite(string.format("activity_fight_board_%s.png", suffix))
  title:setPosition(19, 22)
  title:setAnchorPoint(0, 0)
  banner:addChild(title)
  local lbl_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd:setPosition(CCPoint(409, 27))
  banner:addChild(lbl_cd)
  local lbl_cd_des = lbl.createFont2(14, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd_des:setPosition(CCPoint(491, 27))
  banner:addChild(lbl_cd_des)
  if i18n.getCurrentLanguage() == kLanguageRussian then
    lbl_cd_des:setPosition(CCPoint(369, 27))
    lbl_cd:setAnchorPoint(CCPoint(0, 0.5))
    lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMaxX() + 10, 27))
  end
  local createItem = function(l_1_0, l_1_1)
    local temp_item = img.createUI9Sprite(img.ui.bottom_border_2)
    temp_item:setPreferredSize(CCSizeMake(574, 84))
    local item_w = temp_item:getContentSize().width
    local item_h = temp_item:getContentSize().height
    local des_str = i18n.arena[1].name .. i18n.global.casino_log_gain.string .. " " .. l_1_0.parameter[1].qlt .. " " .. i18n.global.arena_main_score.string
    if dot1 < l_1_1 and l_1_1 <= dot2 then
      des_str = i18n.arena[2].name .. i18n.global.casino_log_gain.string .. " " .. l_1_0.parameter[1].qlt .. " " .. i18n.global.arena_main_score.string
    end
    if dot2 < l_1_1 then
      des_str = i18n.global.act_hero_summon_7.string
    end
    local lbl_des = lbl.createMixFont1(16, des_str, ccc3(93, 45, 18))
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
    if l_1_1 <= dot1 then
      if l_1_0.parameter[1].qlt <= st1.num then
        numerator = l_1_0.parameter[1].qlt
      else
        numerator = st1.num
      end
    elseif l_1_1 <= dot2 then
      if l_1_0.parameter[1].qlt <= st2.num then
        numerator = l_1_0.parameter[1].qlt
      else
        numerator = st2.num
      end
    else
      if dot1Limit <= st1.num and dot2Limit <= st2.num then
        st3.num = 1
        numerator = 1
      else
        numerator = st3.num
      end
    end
    local lbl_pgb = lbl.createFont2(14, numerator .. "/" .. l_1_0.parameter[1].qlt)
    lbl_pgb:setAnchorPoint(CCPoint(0.5, 0))
    lbl_pgb:setPosition(CCPoint(pgb_bg:getContentSize().width / 2, pgb_bg:getContentSize().height / 2))
    pgb_bg:addChild(lbl_pgb)
    if l_1_1 <= dot2 then
      pgb:setPercentage(numerator * 100 / l_1_0.parameter[1].qlt)
    else
      pgb:setPercentage(numerator * 100 / 1)
      lbl_pgb:setString(numerator .. "/" .. 1)
    end
    local max_x = 518
    local step_x = 68
    local rewards_count = #l_1_0.rewards
    for ii = rewards_count, 1, -1 do
      local _obj = l_1_0.rewards[ii]
      do
        local stlimits = 0
        local finishnum = 0
        if l_1_1 <= dot1 then
          stlimits = st1.num
          finishnum = l_1_0.parameter[1].qlt
        elseif l_1_1 <= dot2 then
          stlimits = st2.num
          finishnum = l_1_0.parameter[1].qlt
        else
          stlimits = st3.num
          finishnum = 1
        end
        if _obj.type == ItemType.Equip then
          local _item0 = img.createEquip(_obj.id, _obj.num)
          if finishnum <= stlimits then
            local _mask = img.createUISprite(img.ui.hook_btn_mask)
            _mask:setPosition(CCPoint(_item0:getContentSize().width / 2, _item0:getContentSize().height / 2))
            _item0:addChild(_mask, 100)
            local _sel = img.createUISprite(img.ui.hook_btn_sel)
            _sel:setPosition(CCPoint(_item0:getContentSize().width / 2, _item0:getContentSize().height / 2))
            _item0:addChild(_sel, 100)
          end
          local _item = CCMenuItemSprite:create(_item0, nil)
          _item:setScale(0.7)
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
            if finishnum <= stlimits then
              local _mask = img.createUISprite(img.ui.hook_btn_mask)
              _mask:setPosition(CCPoint(_item0:getContentSize().width / 2, _item0:getContentSize().height / 2))
              _item0:addChild(_mask, 100)
              local _sel = img.createUISprite(img.ui.hook_btn_sel)
              _sel:setPosition(CCPoint(_item0:getContentSize().width / 2, _item0:getContentSize().height / 2))
              _item0:addChild(_sel, 100)
            end
            local _item = CCMenuItemSprite:create(_item0, nil)
            _item:setScale(0.7)
            _item:setPosition(CCPoint(max_x - (rewards_count - ii) * step_x, item_h / 2))
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
  local scroll_params = {width = 574, height = 221}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(1, 0))
  board:addChild(scroll)
  layer.scroll = scroll
  local items = {}
  for ii = 3, 0, -1 do
    items[#items + 1] = clone(cfgmactivity[st1.id - ii])
  end
  for ii = 3, 0, -1 do
    items[#items + 1] = clone(cfgmactivity[st2.id - ii])
  end
  items[#items + 1] = clone(cfgmactivity[st3.id])
  local showList = function(l_2_0)
    for ii = 1, #l_2_0 do
      local tmp_item = createItem(l_2_0[ii], ii)
      tmp_item.obj = l_2_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = scroll_params.width / 2
      scroll.addItem(tmp_item)
    end
    scroll.setOffsetBegin()
   end
  tbl2string(items)
  showList(items)
  local last_update = os.time() - 1
  local onUpdate = function(l_3_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    local remain_cd = st1.cd - (os.time() - mactivityData.pull_time)
    if remain_cd >= 0 then
      local time_str = time2string(remain_cd)
      lbl_cd:setString(time_str)
    else
       -- Warning: missing end command somewhere! Added here
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  l_1_0(layer, scroll)
  layer:registerScriptHandler(function(l_4_0)
    if l_4_0 == "enter" then
      do return end
    end
    if l_4_0 == "exit" then
      do return end
    end
    if l_4_0 == "cleanup" then
      img.unload(img.packedOthers.ui_activity_fight)
    end
   end)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui

