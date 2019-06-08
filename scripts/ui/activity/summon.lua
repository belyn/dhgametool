-- Command line was: E:\github\dhgametool\scripts\ui\activity\summon.lua 

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
local act_ids = {IDS.SUMMON_HERO_1.ID, IDS.SUMMON_HERO_2.ID}
ui.create = function()
  local layer = CCLayer:create()
  local acts = {}
  for _,v in ipairs(act_ids) do
    local tmp_status = activityData.getStatusById(v)
    acts[ acts + 1] = tmp_status
  end
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(576, 436))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_summon)
  local bannerLabel = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    bannerLabel = img.createUISprite("activity_summon_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChinese then
      bannerLabel = img.createUISprite("activity_summon_cn.png")
    else
      if i18n.getCurrentLanguage() == kLanguageChineseTW then
        bannerLabel = img.createUISprite("activity_summon_tw.png")
      else
        if i18n.getCurrentLanguage() == kLanguageJapanese then
          bannerLabel = img.createUISprite("activity_summon_jp.png")
        else
          if i18n.getCurrentLanguage() == kLanguageRussian then
            bannerLabel = img.createUISprite("activity_summon_ru.png")
          else
            if i18n.getCurrentLanguage() == kLanguagePortuguese then
              bannerLabel = img.createUISprite("activity_summon_pt.png")
            else
              bannerLabel = img.createUISprite("activity_summon_us.png")
            end
          end
        end
      end
    end
  end
  local banner = img.createUISprite(img.ui.activity_summon_board)
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2, board_h))
  board:addChild(banner)
  bannerLabel:setAnchorPoint(CCPoint(0.5, 1))
  bannerLabel:setPosition(CCPoint(board_w / 2 + 88 + 10, board_h - 10))
  board:addChild(bannerLabel)
  local lbl_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd:setPosition(CCPoint(343, 17))
  banner:addChild(lbl_cd)
  local lbl_cd_des = lbl.createFont2(14, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd_des:setPosition(CCPoint(418, 17))
  banner:addChild(lbl_cd_des)
  if i18n.getCurrentLanguage() == kLanguageRussian then
    lbl_cd_des:setPosition(CCPoint(253, 17))
    lbl_cd:setAnchorPoint(CCPoint(0, 0.5))
    lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMaxX() + 10, 17))
  end
  local createItem = function(l_1_0)
    local temp_item = img.createUI9Sprite(img.ui.bottom_border_2)
    temp_item:setPreferredSize(CCSizeMake(574, 95))
    local item_w = temp_item:getContentSize().width
    local item_h = temp_item:getContentSize().height
    local hero_id = cfgactivity[l_1_0.id].instruct
    print("================actid, hero_id:", l_1_0.id, hero_id)
    local head0 = img.createHeroHead(hero_id, nil, true, true, nil, true)
    local head = CCMenuItemSprite:create(head0, nil)
    head:setScale(0.75)
    head:setPosition(CCPoint(65, item_h / 2))
    local head_menu = CCMenu:createWithItem(head)
    head_menu:setPosition(CCPoint(0, 0))
    temp_item:addChild(head_menu)
    head:registerScriptTapHandler(function()
      audio.play(audio.button)
      local herotips = require("ui.tips.hero")
      local tips = herotips.create(hero_id)
      layer:getParent():getParent():getParent():addChild(tips, 1001)
      end)
    local icon_arrow = img.createUISprite(img.ui.arrow)
    icon_arrow:setPosition(CCPoint(164, item_h / 2))
    temp_item:addChild(icon_arrow)
    local start_x = 254
    local step_x = 66
    local rewards = cfgactivity[l_1_0.id].rewards
    for ii = 1,  rewards do
      local _obj = rewards[ii]
      do
        if _obj.type == ItemType.Equip then
          local _item0 = img.createEquip(_obj.id, _obj.num)
          local _item = CCMenuItemSprite:create(_item0, nil)
          _item:setScale(0.7)
          _item:setPosition(CCPoint(start_x + (ii - 1) * step_x, item_h / 2))
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
            local _item = CCMenuItemSprite:create(_item0, nil)
            _item:setScale(0.7)
            _item:setPosition(CCPoint(start_x + (ii - 1) * step_x, item_h / 2))
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
    return temp_item
   end
  local lineScroll = require("ui.lineScroll")
  local scroll_params = {width = 574, height = 216}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(0, 3))
  board:addChild(scroll)
  layer.scroll = scroll
  local sortValue = function(l_2_0)
    return l_2_0.id
   end
  table.sort(acts, function(l_3_0, l_3_1)
    return sortValue(l_3_0) < sortValue(l_3_1)
   end)
  local showList = function(l_4_0)
    for ii = 1,  l_4_0 do
      if ii == 1 then
        scroll.addSpace(3)
      end
      local tmp_item = createItem(l_4_0[ii])
      tmp_item.obj = l_4_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = scroll_params.width / 2
      scroll.addItem(tmp_item)
      if ii ~= item_count then
        scroll.addSpace(1)
      end
    end
    scroll.setOffsetBegin()
   end
  showList(acts)
  local last_update = os.time() - 1
  local onUpdate = function(l_5_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    local remain_cd = acts[1].cd - (os.time() - activityData.pull_time)
    if remain_cd >= 0 then
      local time_str = time2string(remain_cd)
      lbl_cd:setString(time_str)
    else
       -- Warning: missing end command somewhere! Added here
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  img.unload(img.packedOthers.ui_activity_summon)
  require("ui.activity.ban").addBan(layer, scroll)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui

