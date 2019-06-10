-- Command line was: E:\github\dhgametool\scripts\ui\activity\pumpkin.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.activity")
local cfgstore = require("config.store")
local player = require("data.player")
local bagData = require("data.bag")
local activityData = require("data.activity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local uirewards = require("ui.reward")
local IDS = activityData.IDS
local ItemType = {Item = 1, Equip = 2}
local vp_ids = {IDS.ICEBABY_1.ID, IDS.ICEBABY_2.ID, IDS.ICEBABY_3.ID, IDS.ICEBABY_4.ID, IDS.ICEBABY_5.ID, IDS.ICEBABY_6.ID, IDS.ICEBABY_7.ID}
local STATE = {LOCK = 1, GET = 2, FINISH = 3}
local getVpState = function(l_1_0)
  if l_1_0.limits < 1 then
    return STATE.FINISH
  end
  if l_1_0.id == IDS.ICEBABY_1.ID then
    return STATE.GET
  else
    local tmp_status = activityData.getStatusById(l_1_0.id - 1)
    if tmp_status.limits < 1 then
      return STATE.GET
    else
      return STATE.LOCK
    end
  end
  return STATE.LOCK
end

ui.create = function()
  local layer = CCLayer:create()
  local vps = {}
  for _,v in ipairs(vp_ids) do
    local tmp_status = activityData.getStatusById(v)
    vps[#vps + 1] = tmp_status
  end
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(570, 438))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(362, 60))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.unload(img.packedOthers.ui_activity_fish)
  img.unload(img.packedOthers.ui_activity_fish_cn)
  if i18n.getCurrentLanguage() == kLanguageChinese or i18n.getCurrentLanguage() == kLanguageChineseTW then
    img.load(img.packedOthers.ui_activity_fish_cn)
  else
    img.load(img.packedOthers.ui_activity_fish)
  end
  local banner = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    banner = img.createUISprite("activity_home_board_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageRussian then
      banner = img.createUISprite("activity_home_board_ru.png")
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        banner = img.createUISprite("activity_home_board_jp.png")
      else
        banner = img.createUISprite(img.ui.activity_home_board)
      end
    end
  end
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2 - 10, board_h - 8))
  board:addChild(banner)
  local lbl_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd:setPosition(CCPoint(281, 28))
  banner:addChild(lbl_cd)
  local lbl_cd_des = lbl.createFont2(14, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd_des:setPosition(CCPoint(363, 28))
  banner:addChild(lbl_cd_des)
  local coin_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  coin_bg:setPreferredSize(CCSizeMake(174, 40))
  coin_bg:setPosition(CCPoint(banner:getContentSize().width / 2 + 68, 58))
  banner:addChild(coin_bg)
  local coin_icon = img.createItemIcon2(ITEM_ID_CHOCO)
  coin_icon:setPosition(CCPoint(8, coin_bg:getContentSize().height / 2 + 3))
  coin_bg:addChild(coin_icon)
  local lbl_coin = lbl.createFont2(16, "12345")
  lbl_coin:setPosition(CCPoint(92, coin_bg:getContentSize().height / 2 + 3))
  coin_bg:addChild(lbl_coin)
  local updateCoin = function()
    local itemObj = bagData.items.find(ITEM_ID_CHOCO)
    if not itemObj then
      itemObj = {id = ITEM_ID_CHOCO, num = 0}
    end
    lbl_coin:setString(itemObj.num)
   end
  updateCoin()
  local btns = {}
  local btns_lock = {}
  local createItem = function(l_2_0)
    local cfgObj = cfgactivity[l_2_0.id]
    local temp_item = img.createUI9Sprite(img.ui.bottom_border_2)
    temp_item:setPreferredSize(CCSizeMake(542, 86))
    local item_w = temp_item:getContentSize().width
    local item_h = temp_item:getContentSize().height
    local start_x = 47
    local step_x = 66
    local rewards = cfgObj.rewards
    for ii = 1, #rewards do
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
            layer:getParent():getParent():addChild(tipsequip.createById(_obj.id), 1000)
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
              layer:getParent():getParent():addChild(tipsitem.createForShow({id = _obj.id}), 1000)
                  end)
          end
        end
      end
    end
    local btn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
    btn0:setPreferredSize(CCSizeMake(120, 45))
    local icon = img.createItemIcon2(ITEM_ID_CHOCO)
    icon:setScale(0.9)
    icon:setPosition(CCPoint(27, btn0:getContentSize().height / 2))
    btn0:addChild(icon)
    local lbl_price = lbl.createFont2(14, cfgObj.extra[1].num)
    lbl_price:setPosition(CCPoint(27, 13))
    btn0:addChild(lbl_price)
    local lbl_btn = lbl.createMixFont1(14, i18n.global.task_btn_claim.string, ccc3(115, 59, 5))
    lbl_btn:setPosition(CCPoint(75, btn0:getContentSize().height / 2))
    btn0:addChild(lbl_btn)
    local btn = SpineMenuItem:create(json.ui.button, btn0)
    btn:setPosition(CCPoint(458, 43))
    local btn_menu = CCMenu:createWithItem(btn)
    btn_menu:setPosition(CCPoint(0, 0))
    temp_item:addChild(btn_menu)
    btns[l_2_0.id] = btn
    local icon_recv = img.createUISprite(img.ui.achieve_calim)
    icon_recv:setPosition(CCPoint(458, item_h / 2))
    temp_item:addChild(icon_recv)
    local btn_lock0 = img.createLogin9Sprite(img.login.button_9_small_gold)
    btn_lock0:setPreferredSize(CCSizeMake(120, 45))
    local icon2 = img.createItemIcon2(ITEM_ID_CHOCO)
    icon2:setScale(0.9)
    icon2:setPosition(CCPoint(27, btn_lock0:getContentSize().height / 2))
    btn_lock0:addChild(icon2)
    local lbl_price2 = lbl.createFont2(14, cfgObj.extra[1].num)
    lbl_price2:setPosition(CCPoint(27, 13))
    btn_lock0:addChild(lbl_price2)
    local iconx = img.createUISprite(img.ui.devour_icon_lock)
    iconx:setPosition(CCPoint(75, btn_lock0:getContentSize().height / 2))
    btn_lock0:addChild(iconx)
    local btn_lock = SpineMenuItem:create(json.ui.button, btn_lock0)
    btn_lock:setPosition(CCPoint(458, 43))
    local btn_lock_menu = CCMenu:createWithItem(btn_lock)
    btn_lock_menu:setPosition(CCPoint(0, 0))
    temp_item:addChild(btn_lock_menu)
    btns_lock[l_2_0.id] = btn_lock
    btn_lock:registerScriptTapHandler(function()
      audio.play(audio.button)
      showToast(i18n.global.unlock_last.string)
      end)
    local vstate = getVpState(l_2_0)
    if vstate == STATE.LOCK then
      btn_lock:setVisible(true)
      icon_recv:setVisible(false)
      btn:setVisible(false)
    else
      if vstate == STATE.GET then
        btn_lock:setVisible(false)
        icon_recv:setVisible(false)
        btn:setVisible(true)
      else
        if vstate == STATE.FINISH then
          icon_recv:setVisible(true)
          btn:setVisible(false)
          btn_lock:setVisible(false)
        end
      end
    end
    btn:registerScriptTapHandler(function()
      audio.play(audio.button)
      local itemObj = bagData.items.find(ITEM_ID_CHOCO)
      if not itemObj then
        itemObj = {id = ITEM_ID_CHOCO, num = 0}
      end
      local vpstate = getVpState(vpObj)
      if vpstate == STATE.LOCK then
        showToast(i18n.global.unlock_last.string)
        return 
      else
        if itemObj.num < cfgObj.extra[1].num then
          showToast(i18n.global.pet_smaterial_not_enough.string)
          return 
        end
      end
      local param = {sid = player.sid, id = vpObj.id, num = 1}
      addWaitNet()
      netClient:exchange_act(param, function(l_1_0)
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          delWaitNet()
          showToast(i18n.global.pet_smaterial_not_enough.string)
          return 
        end
        itemObj.num = itemObj.num - cfgObj.extra[1].num
        vpObj.limits = vpObj.limits - 1
        delWaitNet()
        updateCoin()
        btn:setEnabled(false)
        btn:setVisible(false)
        btn_lock:setVisible(false)
        icon_recv:setVisible(true)
        if btns[vpObj.id + 1] then
          btns[vpObj.id + 1]:setVisible(true)
          btns[vpObj.id + 1]:setEnabled(true)
        end
        if btns_lock[vpObj.id + 1] then
          btns_lock[vpObj.id + 1]:setVisible(false)
          btns_lock[vpObj.id + 1]:setEnabled(false)
        end
        if l_1_0.affix then
          bagData.addRewards(l_1_0.affix)
          CCDirector:sharedDirector():getRunningScene():addChild(uirewards.createFloating(l_1_0.affix), 100000)
        end
         end)
      end)
    return temp_item
   end
  local lineScroll = require("ui.lineScroll")
  local scroll_params = {width = 550, height = 215}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(0, 3))
  board:addChild(scroll)
  layer.scroll = scroll
  local sortValue = function(l_3_0)
    if l_3_0.limits <= 0 then
      return 10000 + l_3_0.id
    else
      return l_3_0.id
    end
   end
  table.sort(vps, function(l_4_0, l_4_1)
    return sortValue(l_4_0) < sortValue(l_4_1)
   end)
  local ITEM_PER_ROW = 1
  local start_x = 101
  local step_x = 170
  local start_y = -73
  local step_y = -161
  local showList = function(l_5_0)
    for ii = 1, #l_5_0 do
      local tmp_item = createItem(l_5_0[ii])
      tmp_item.obj = l_5_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = scroll_params.width / 2
      scroll.addItem(tmp_item)
    end
    scroll.setOffsetBegin()
   end
  showList(vps)
  local last_update = os.time() - 1
  local onUpdate = function(l_6_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    local remain_cd = vps[1].cd - (os.time() - activityData.pull_time)
    if remain_cd >= 0 then
      local time_str = time2string(remain_cd)
      lbl_cd:setString(time_str)
    else
       -- Warning: missing end command somewhere! Added here
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  require("ui.activity.ban").addBan(layer, scroll)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui

