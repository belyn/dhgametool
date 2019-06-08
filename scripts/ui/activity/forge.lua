-- Command line was: E:\github\dhgametool\scripts\ui\activity\forge.lua 

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
local act_ids = {IDS.FORGE_1.ID, IDS.FORGE_2.ID, IDS.FORGE_3.ID, IDS.FORGE_4.ID}
ui.create = function(l_1_0)
  local layer = CCLayer:create()
  local event_des = {1 = i18n.global.act_forge_task_5.string, 2 = i18n.global.act_forge_task_6.string, 3 = i18n.global.act_forge_task_9.string, 4 = i18n.global.act_forge_task_10.string}
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
  img.load(img.packedOthers.ui_activity_forge)
  local banner = img.createUISprite(img.ui.activity_forge_board)
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2, board_h))
  board:addChild(banner)
  local bannerLabel = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    bannerLabel = img.createUISprite("activity_forge_board_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      bannerLabel = img.createUISprite("activity_forge_board_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        bannerLabel = img.createUISprite("activity_forge_board_jp.png")
      else
        if i18n.getCurrentLanguage() == kLanguagePortuguese then
          bannerLabel = img.createUISprite("activity_forge_board_pt.png")
        else
          if i18n.getCurrentLanguage() == kLanguageChinese then
            bannerLabel = img.createUISprite("activity_forge_board_cn.png")
          else
            bannerLabel = img.createUISprite("activity_forge_board_us.png")
          end
        end
      end
    end
  end
  bannerLabel:setAnchorPoint(CCPoint(0.5, 1))
  bannerLabel:setPosition(CCPoint(board_w / 2 + 50, board_h - 20))
  board:addChild(bannerLabel)
  local lbl_cd_des = lbl.createFont2(14, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd_des:setPosition(CCPoint(340, 24))
  banner:addChild(lbl_cd_des)
  local lbl_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(1, 0.5))
  lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMinX() - 6, 24))
  banner:addChild(lbl_cd)
  if i18n.getCurrentLanguage() == kLanguageRussian then
    lbl_cd_des:setPosition(CCPoint(264, 24))
    lbl_cd:setAnchorPoint(CCPoint(0, 0.5))
    lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMaxX() + 10, 24))
  end
  local createItem = function(l_1_0, l_1_1)
    local temp_item = img.createUI9Sprite(img.ui.bottom_border_2)
    temp_item:setPreferredSize(CCSizeMake(574, 114))
    local item_w = temp_item:getContentSize().width
    local item_h = temp_item:getContentSize().height
    local lbl_des = lbl.create({font = 1, size = 14, text = l_1_0.des, color = ccc3(97, 52, 42), width = 300, align = kCCTextAlignmentLeft})
    lbl_des:setAnchorPoint(CCPoint(0, 0.5))
    lbl_des:setPosition(CCPoint(22, item_h - 22))
    temp_item:addChild(lbl_des)
    local limitLabel = lbl.createFont1(14, i18n.global.activity_limit.string, ccc3(115, 59, 5))
    limitLabel:setPosition(CCPoint(498, item_h - 46))
    temp_item:addChild(limitLabel)
    local limitLabel = lbl.createFont1(18, acts[l_1_1].num .. "/" .. cfgactivity[acts[l_1_1].id].parameter[1].qlt, ccc3(164, 69, 36))
    limitLabel:setPosition(CCPoint(498, 46))
    temp_item:addChild(limitLabel)
    local start_x = 50
    local step_x = 68
    local rewards = cfgactivity[l_1_0.id].rewards
    for ii = 1,  rewards do
      local _obj = rewards[ii]
      do
        if _obj.type == ItemType.Equip then
          local _item0 = img.createEquip(_obj.id, _obj.num)
          local _item = CCMenuItemSprite:create(_item0, nil)
          _item:setAnchorPoint(0.5, 0)
          _item:setScale(0.7)
          _item:setPosition(CCPoint(start_x + (ii - 1) * step_x, 20))
          if acts[l_1_1].num == cfgactivity[l_1_0.id].parameter[1].qlt then
            setShader(_item, SHADER_GRAY, true)
          end
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
            _item:setAnchorPoint(0.5, 0)
            _item:setScale(0.7)
            _item:setPosition(CCPoint(start_x + (ii - 1) * step_x, 20))
            if acts[l_1_1].num == cfgactivity[l_1_0.id].parameter[1].qlt then
              setShader(_item, SHADER_GRAY, true)
            end
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
  local scroll_params = {width = 574, height = 241}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(1, 0))
  board:addChild(scroll)
  layer.scroll = scroll
  local showList = function(l_2_0)
    for ii = 1,  l_2_0 do
      if ii == 1 then
        scroll.addSpace(3)
      end
      local tmp_item = createItem(l_2_0[ii], ii)
      tmp_item.obj = l_2_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = scroll_params.width / 2
      scroll.addItem(tmp_item)
      if ii ~= item_count then
        scroll.addSpace(0)
      end
    end
    scroll.setOffsetBegin()
   end
  local acts = {1 = {id = IDS.FORGE_1.ID, icon = img.ui.activity_forge_head_icon1, des = event_des[1]}, 2 = {id = IDS.FORGE_2.ID, icon = img.ui.activity_forge_head_icon2, des = event_des[2]}, 3 = {id = IDS.FORGE_3.ID, icon = img.ui.activity_forge_head_icon1, des = event_des[3]}, 4 = {id = IDS.FORGE_4.ID, icon = img.ui.activity_forge_head_icon2, des = event_des[4]}}
  showList(acts)
  local act_st = activityData.getStatusById(IDS.FORGE_1.ID)
  local last_update = os.time() - 1
  local onUpdate = function(l_3_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    local remain_cd = act_st.cd - (os.time() - activityData.pull_time)
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
      img.unload(img.packedOthers.ui_activity_forge)
    end
   end)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui

