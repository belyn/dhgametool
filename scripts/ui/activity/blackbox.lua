-- Command line was: E:\github\dhgametool\scripts\ui\activity\blackbox.lua 

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
local bagdata = require("data.bag")
local activityData = require("data.activity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local IDS = activityData.IDS
local ItemType = {Item = 1, Equip = 2}
local vp_ids = {IDS.BLACKBOX_1.ID, IDS.BLACKBOX_2.ID, IDS.BLACKBOX_3.ID, IDS.BLACKBOX_4.ID, IDS.BLACKBOX_5.ID}
ui.create = function()
  local layer = CCLayer:create()
  local vps = {}
  for _,v in ipairs(vp_ids) do
    local tmp_status = activityData.getStatusById(v)
    vps[#vps + 1] = tmp_status
  end
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(576, 436))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_blackbox)
  local banner = (img.createUISprite("activity_chest_board.png"))
  local bannerLabel = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    bannerLabel = img.createUISprite("activity_chest_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChinese then
      bannerLabel = img.createUISprite("activity_chest_cn.png")
    else
      if i18n.getCurrentLanguage() == kLanguageChineseTW then
        bannerLabel = img.createUISprite("activity_chest_tw.png")
      else
        if i18n.getCurrentLanguage() == kLanguageJapanese then
          bannerLabel = img.createUISprite("activity_chest_jp.png")
        else
          if i18n.getCurrentLanguage() == kLanguageRussian then
            bannerLabel = img.createUISprite("activity_chest_ru.png")
          else
            if i18n.getCurrentLanguage() == kLanguagePortuguese then
              bannerLabel = img.createUISprite("activity_chest_pt.png")
            else
              bannerLabel = img.createUISprite("activity_chest.png")
            end
          end
        end
      end
    end
  end
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2, board_h))
  board:addChild(banner)
  bannerLabel:setAnchorPoint(CCPoint(0.5, 1))
  bannerLabel:setPosition(CCPoint(board_w / 2 + 90, board_h - 22))
  board:addChild(bannerLabel)
  local lbl_cd_des = lbl.createFont2(14, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(1, 0.5))
  lbl_cd_des:setPosition(CCPoint(405, 28))
  banner:addChild(lbl_cd_des)
  local lbl_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(1, 0.5))
  lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMinX() - 6, 28))
  banner:addChild(lbl_cd)
  if i18n.getCurrentLanguage() == kLanguageRussian then
    lbl_cd_des:setPosition(CCPoint(345, 28))
    lbl_cd:setAnchorPoint(CCPoint(0, 0.5))
    lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMaxX() + 10, 28))
  end
  local createSurebuy = function(l_1_0)
    local params = {}
    params.btn_count = 0
    params.body = string.format(i18n.global.blackmarket_buy_sure.string, 20)
    local board_w = 474
    local dialoglayer = require("ui.dialog").create(params)
    local btnYesSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnYesSprite:setPreferredSize(CCSize(153, 50))
    local btnYes = SpineMenuItem:create(json.ui.button, btnYesSprite)
    btnYes:setPosition(board_w / 2 + 95, 100)
    local labYes = lbl.createFont1(18, i18n.global.board_confirm_yes.string, ccc3(115, 59, 5))
    labYes:setPosition(btnYes:getContentSize().width / 2, btnYes:getContentSize().height / 2)
    btnYesSprite:addChild(labYes)
    local menuYes = CCMenu:create()
    menuYes:setPosition(0, 0)
    menuYes:addChild(btnYes)
    dialoglayer.board:addChild(menuYes)
    local btnNoSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnNoSprite:setPreferredSize(CCSize(153, 50))
    local btnNo = SpineMenuItem:create(json.ui.button, btnNoSprite)
    btnNo:setPosition(board_w / 2 - 95, 100)
    local labNo = lbl.createFont1(18, i18n.global.board_confirm_no.string, ccc3(115, 59, 5))
    labNo:setPosition(btnNo:getContentSize().width / 2, btnNo:getContentSize().height / 2)
    btnNoSprite:addChild(labNo)
    local menuNo = CCMenu:create()
    menuNo:setPosition(0, 0)
    menuNo:addChild(btnNo)
    dialoglayer.board:addChild(menuNo)
    btnYes:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      audio.play(audio.button)
      callback()
      end)
    btnNo:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      audio.play(audio.button)
      end)
    local diabackEvent = function()
      dialoglayer:removeFromParentAndCleanup(true)
      end
    dialoglayer.onAndroidBack = function()
      diabackEvent()
      end
    addBackEvent(dialoglayer)
    local onEnter = function()
      dialoglayer.notifyParentLock()
      end
    local onExit = function()
      dialoglayer.notifyParentUnlock()
      end
    dialoglayer:registerScriptHandler(function(l_7_0)
      if l_7_0 == "enter" then
        onEnter()
      elseif l_7_0 == "exit" then
        onExit()
      end
      end)
    return dialoglayer
   end
  local createItem = function(l_2_0)
    local temp_item = img.createUI9Sprite(img.ui.bottom_border_2)
    temp_item:setPreferredSize(CCSizeMake(542, 90))
    local item_w = temp_item:getContentSize().width
    local item_h = temp_item:getContentSize().height
    local start_x = 47
    local step_x = 66
    local rewards = cfgactivity[l_2_0.id].rewards
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
            ui.createItemTip(layer, _obj.id)
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
              ui.createItemTip(layer, _obj.id)
                  end)
          end
        end
      end
    end
    local cfgobj = cfgactivity[l_2_0.id]
    local limitLabel = lbl.createFont1(16, i18n.global.limitact_limit.string .. l_2_0.limits, ccc3(115, 59, 5))
    limitLabel:setPosition(CCPoint(466, 68))
    temp_item:addChild(limitLabel)
    local btn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
    btn0:setPreferredSize(CCSizeMake(120, 45))
    local icon = img.createItemIcon2(ITEM_ID_GEM)
    icon:setScale(0.9)
    icon:setPosition(CCPoint(27, btn0:getContentSize().height / 2))
    btn0:addChild(icon)
    local lbl_price = lbl.createFont2(14, cfgobj.extra[1].num)
    lbl_price:setPosition(CCPoint(27, 13))
    btn0:addChild(lbl_price)
    local lbl_btn = lbl.create({font = 1, size = 18, text = i18n.global.tips_buy.string, color = ccc3(115, 59, 5), pt = {size = 14}, es = {size = 14}})
    lbl_btn:setPosition(CCPoint(75, 23))
    btn0:addChild(lbl_btn)
    local btn = SpineMenuItem:create(json.ui.button, btn0)
    btn:setPosition(CCPoint(466, 36))
    local btn_menu = CCMenu:createWithItem(btn)
    btn_menu:setPosition(CCPoint(0, 0))
    temp_item:addChild(btn_menu)
    if l_2_0.status ~= 0 or l_2_0.limits <= 0 then
      setShader(btn, SHADER_GRAY, true)
      btn:setEnabled(false)
      limitLabel:setVisible(false)
    end
    btn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if bagdata.gem() < cfgobj.extra[1].num then
        showToast(i18n.global.gboss_fight_st6.string)
        return 
      end
      local commit = function()
        addWaitNet().setTimeout(60)
        local params = {sid = player.sid, id = vpObj.id, num = 1}
        netClient:exchange_act(params, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          if l_1_0.status ~= 0 then
            showToast(i18n.global.gboss_fight_st6.string)
            return 
          end
          bagdata.subGem(cfgobj.extra[1].num)
          local reward = l_1_0.affix
          if reward then
            bagdata.addRewards(reward)
            vpObj.limits = vpObj.limits - 1
            if vpObj.limits <= 0 then
              setShader(btn, SHADER_GRAY, true)
              btn:setEnabled(false)
              limitLabel:setVisible(false)
            else
              limitLabel:setString(i18n.global.limitact_limit.string .. vpObj.limits)
            end
            local rw = tablecp(reward)
            arrayfilter(rw.items, function(l_1_0)
              return l_1_0.id ~= ITEM_ID_VIP_EXP
                  end)
            layer:getParent():getParent():getParent():addChild(require("ui.reward").createFloating(rw), 1000)
          end
            end)
         end
      layer:getParent():getParent():getParent():addChild(createSurebuy(commit), 1000)
      end)
    return temp_item
   end
  local lineScroll = require("ui.lineScroll")
  local scroll_params = {width = 550, height = 239}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(14, 0))
  board:addChild(scroll)
  layer.scroll = scroll
  local sortValue = function(l_3_0)
    return l_3_0.id
   end
  table.sort(vps, function(l_4_0, l_4_1)
    return sortValue(l_4_0) < sortValue(l_4_1)
   end)
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
  layer:registerScriptHandler(function(l_7_0)
    if l_7_0 == "enter" then
      do return end
    end
    if l_7_0 == "exit" then
      img.unload(img.packedOthers.ui_activity_blackbox)
    end
   end)
  require("ui.activity.ban").addBan(layer, scroll)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

ui.createItemTip = function(l_2_0, l_2_1)
  local layer = CCLayer:create()
  local cfgitem = require("config.item")
  local itemObj = cfgitem[l_2_1]
  local giftId = itemObj.giftId
  local cfggift = require("config.gift")
  local giftObj = cfggift[giftId]
  if not giftObj or not giftObj.giftGoods or #giftObj.giftGoods < 1 then
    return 
  end
  local start_x = 35
  local giftGoods = giftObj.giftGoods
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  local bg_w = start_x + 82 * #giftGoods + 24 * (#giftGoods - 1) + start_x
  local bg_h = 192
  bg:setPreferredSize(CCSizeMake(bg_w, bg_h))
  bg:setScale(view.minScale)
  bg:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(bg)
  local tipstitle = lbl.createFont1(18, i18n.global.brave_baoxiang_tips.string, ccc3(255, 228, 156))
  tipstitle:setPosition(bg_w / 2, 162)
  bg:addChild(tipstitle)
  local line = img.createUISprite(img.ui.help_line)
  line:setScaleX(bg_w * 0.75 / line:getContentSize().width)
  line:setPosition(CCPoint(bg_w / 2, 142))
  bg:addChild(line)
  for ii = 1, #giftGoods do
    local _obj = giftGoods[ii]
    do
      if _obj.type == ItemType.Equip then
        local _item0 = img.createEquip(_obj.id, _obj.num)
        local _item = CCMenuItemSprite:create(_item0, nil)
        _item:setScale(1)
        _item:setPosition(CCPoint(start_x + 41 + (ii - 1) * 106, 77))
        local _item_menu = CCMenu:createWithItem(_item)
        _item_menu:setPosition(CCPoint(0, 0))
        bg:addChild(_item_menu)
        _item:registerScriptTapHandler(function()
          audio.play(audio.button)
          layer:addChild(tipsequip.createById(_obj.id), 1000)
            end)
      else
        if _obj.type == ItemType.Item then
          local _item0 = img.createItem(_obj.id, _obj.num)
          local _item = CCMenuItemSprite:create(_item0, nil)
          _item:setScale(1)
          _item:setPosition(CCPoint(start_x + 41 + (ii - 1) * 106, 77))
          local _item_menu = CCMenu:createWithItem(_item)
          _item_menu:setPosition(CCPoint(0, 0))
          bg:addChild(_item_menu)
          _item:registerScriptTapHandler(function()
            audio.play(audio.button)
            layer:addChild(tipsitem.createForShow({id = _obj.id}), 1000)
               end)
        end
      end
    end
  end
  local clickBlankHandler = nil
  layer.setClickBlankHandler = function(l_3_0)
    clickBlankHandler = l_3_0
   end
  local onTouch = function(l_4_0, l_4_1, l_4_2)
    if l_4_0 == "began" then
      return true
    elseif l_4_0 == "moved" then
      return 
    else
      if not bg:boundingBox():containsPoint(ccp(l_4_1, l_4_2)) then
        layer.onAndroidBack()
      end
    end
   end
  addBackEvent(layer)
  layer.onAndroidBack = function()
    if clickBlankHandler then
      clickBlankHandler()
    else
      layer:removeFromParent()
    end
   end
  layer:registerScriptHandler(function(l_6_0)
    if l_6_0 == "enter" then
      layer.notifyParentLock()
    elseif l_6_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  l_2_0:getParent():getParent():getParent():addChild(layer, 999)
end

return ui

