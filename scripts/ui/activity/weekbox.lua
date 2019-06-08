-- Command line was: E:\github\dhgametool\scripts\ui\activity\weekbox.lua 

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
local vp_ids = {IDS.WEEKYEARBOX_1.ID, IDS.WEEKYEARBOX_2.ID, IDS.WEEKYEARBOX_3.ID}
ui.createItemTip = function(l_1_0, l_1_1)
  local layer = CCLayer:create()
  local cfgitem = require("config.item")
  local itemObj = cfgitem[l_1_1]
  local giftId = itemObj.giftId
  local cfggift = require("config.gift")
  local giftObj = cfggift[giftId]
  if not giftObj or not giftObj.giftGoods or  giftObj.giftGoods < 1 then
    return 
  end
  local start_x = 61
  local giftGoods = giftObj.giftGoods
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  local bg_w = start_x + 82 *  giftGoods + 24 * ( giftGoods - 1) + start_x
  local bg_h = 192
  bg_w = 310
  bg_h = 205
  if  giftGoods == 1 then
    start_x = bg_w / 2 - 41
  end
  bg:setPreferredSize(CCSizeMake(bg_w, bg_h))
  bg:setScale(view.minScale)
  bg:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(bg)
  local tipstitle = lbl.createFont1(18, i18n.global.brave_baoxiang_tips.string, ccc3(255, 228, 156))
  tipstitle:setPosition(bg_w / 2, 175)
  bg:addChild(tipstitle)
  local line = img.createUISprite(img.ui.help_line)
  line:setScaleX(240 / line:getContentSize().width)
  line:setPosition(CCPoint(bg_w / 2, 149))
  bg:addChild(line)
  for ii = 1,  giftGoods do
    local _obj = giftGoods[ii]
    do
      if _obj.type == ItemType.Equip then
        local _item0 = img.createEquip(_obj.id, _obj.num)
        local _item = CCMenuItemSprite:create(_item0, nil)
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
  l_1_0:getParent():getParent():addChild(layer, 999)
end

ui.create = function()
  local layer = CCLayer:create()
  local vps = {}
  for _,v in ipairs(vp_ids) do
    local tmp_status = activityData.getStatusById(v)
    vps[ vps + 1] = tmp_status
  end
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(570, 438))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(352, 57))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_weekbox)
  local banner = img.createUISprite("activity_anniversary_board.png")
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2, board_h - 10))
  board:addChild(banner)
  local bannerLabel = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    bannerLabel = img.createUISprite("activity_anniversary_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      bannerLabel = img.createUISprite("activity_anniversary_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        bannerLabel = img.createUISprite("activity_anniversary_jp.png")
      else
        if i18n.getCurrentLanguage() == kLanguageRussian then
          bannerLabel = img.createUISprite("activity_anniversary_ru.png")
        else
          if i18n.getCurrentLanguage() == kLanguagePortuguese then
            bannerLabel = img.createUISprite("activity_anniversary_pt.png")
          else
            if i18n.getCurrentLanguage() == kLanguageChinese then
              bannerLabel = img.createUISprite("activity_anniversary_cn.png")
            else
              bannerLabel = img.createUISprite("activity_anniversary_en.png")
            end
          end
        end
      end
    end
  end
  bannerLabel:setAnchorPoint(CCPoint(0.5, 1))
  bannerLabel:setPosition(CCPoint(375, 407))
  board:addChild(bannerLabel)
  local lbl_cd_des = lbl.createFont2(14, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd_des:setPosition(CCPoint(380, 20))
  banner:addChild(lbl_cd_des)
  local lbl_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd:setPosition(CCPoint(305, 20))
  banner:addChild(lbl_cd)
  if i18n.getCurrentLanguage() == kLanguageRussian then
    lbl_cd_des:setPosition(CCPoint(265, 20))
    lbl_cd:setAnchorPoint(CCPoint(0, 0.5))
    lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMaxX() + 10, 20))
  end
  local createSurebuy = function(l_1_0, l_1_1, l_1_2)
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
      local itemObj = bagData.items.find(ITEM_ID_GEM)
      if not itemObj then
        itemObj = {id = ITEM_ID_GEM, num = 0}
      end
      if itemObj.num < cfgObj.extra[1].num then
        showToast(i18n.global.gboss_fight_st6.string)
        return 
      end
      local param = {sid = player.sid, id = vpObj.id, num = 1}
      addWaitNet()
      netClient:exchange_act(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status == -2 then
          showToast(string.format(i18n.global.shop_onlytime.string, cfgObj.limitNum))
          return 
        end
        if l_1_0.status ~= 0 then
          showToast(i18n.global.luckcoin_notenough.string)
          return 
        end
        vpObj.limits = vpObj.limits - 1
        if vpObj.limits == 0 then
          callback()
        end
        itemObj.num = itemObj.num - cfgObj.extra[1].num
        if l_1_0.affix then
          bagData.addRewards(l_1_0.affix)
          CCDirector:sharedDirector():getRunningScene():addChild(uirewards.createFloating(l_1_0.affix), 100000)
        end
         end)
      audio.play(audio.button)
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
  local buyCount = 1
  local selectSweepnumLayer = function(l_2_0, l_2_1, l_2_2)
    local sweepLayer = CCLayer:create()
    buyCount = 1
    local sweepdarkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
    sweepLayer:addChild(sweepdarkbg)
    local sweepboard_bg = img.createUI9Sprite(img.ui.dialog_1)
    sweepboard_bg:setPreferredSize(CCSizeMake(370, 448))
    sweepboard_bg:setScale(view.minScale)
    sweepboard_bg:setPosition(scalep(480, 288))
    sweepLayer:addChild(sweepboard_bg)
    local sweepboard_bg_w = sweepboard_bg:getContentSize().width
    local sweepboard_bg_h = sweepboard_bg:getContentSize().height
    local edit0 = img.createLogin9Sprite(img.login.input_border)
    local edit = CCEditBox:create(CCSizeMake(160 * view.minScale, 40 * view.minScale), edit0)
    edit:setInputMode(kEditBoxInputModeNumeric)
    edit:setReturnType(kKeyboardReturnTypeDone)
    edit:setMaxLength(5)
    edit:setFont("", 16 * view.minScale)
    edit:setText("1")
    edit:setFontColor(ccc3(148, 98, 66))
    edit:setPosition(scalep(480, 272))
    sweepLayer:addChild(edit, 1000)
    sweepLayer.edit = edit
    local sweeplbl_title = lbl.createFont1(24, i18n.global.pumpkin_btn_get.string, ccc3(230, 208, 174))
    sweeplbl_title:setPosition(CCPoint(sweepboard_bg_w / 2, sweepboard_bg_h - 29))
    sweepboard_bg:addChild(sweeplbl_title, 2)
    local sweeplbl_title_shadowD = lbl.createFont1(24, i18n.global.pumpkin_btn_get.string, ccc3(89, 48, 27))
    sweeplbl_title_shadowD:setPosition(CCPoint(sweepboard_bg_w / 2, sweepboard_bg_h - 31))
    sweepboard_bg:addChild(sweeplbl_title_shadowD)
    local icon_thing = nil
    if l_2_1.rewards[1].type == ItemType.Equip then
      icon_thing = img.createEquip(l_2_1.rewards[1].id, l_2_1.rewards[1].num)
    else
      if l_2_1.rewards[1].type == ItemType.Item then
        icon_thing = img.createItem(l_2_1.rewards[1].id, l_2_1.rewards[1].num)
      end
    end
    icon_thing:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2, 309))
    sweepboard_bg:addChild(icon_thing)
    local btn_sub0 = img.createUISprite(img.ui.btn_sub)
    local btn_sub = SpineMenuItem:create(json.ui.button, btn_sub0)
    btn_sub:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 - 111, 210))
    local btn_sub_menu = CCMenu:createWithItem(btn_sub)
    btn_sub_menu:setPosition(CCPoint(0, 0))
    sweepboard_bg:addChild(btn_sub_menu)
    local btn_add0 = img.createUISprite(img.ui.btn_add)
    local btn_add = SpineMenuItem:create(json.ui.button, btn_add0)
    btn_add:setPosition(CCPoint(sweepboard_bg:getContentSize().width / 2 + 111, 210))
    local btn_add_menu = CCMenu:createWithItem(btn_add)
    btn_add_menu:setPosition(CCPoint(0, 0))
    sweepboard_bg:addChild(btn_add_menu)
    local broken_bg = img.createUI9Sprite(img.ui.casino_gem_bg)
    broken_bg:setPreferredSize(CCSizeMake(165, 34))
    broken_bg:setPosition(CCPoint(sweepboard_bg_w / 2, 144))
    sweepboard_bg:addChild(broken_bg)
    local icon_broken = img.createItemIcon2(ITEM_ID_GEM)
    icon_broken:setScale(0.8)
    icon_broken:setPosition(CCPoint(30, broken_bg:getContentSize().height / 2))
    broken_bg:addChild(icon_broken)
    local brokennum = 0
    if bagData.items.find(ITEM_ID_GEM) then
      brokennum = bagData.items.find(ITEM_ID_GEM).num
    end
    local lbl_pay = lbl.createFont2(16, l_2_1.extra[1].num)
    lbl_pay:setPosition(CCPoint(100, broken_bg:getContentSize().height / 2))
    broken_bg:addChild(lbl_pay)
    local updatePay = function(l_1_0)
      local tmp_str = l_1_0 * cfgObj.extra[1].num
      lbl_pay:setString(tmp_str)
      end
    local edit_tickets = sweepLayer.edit
    edit_tickets:registerScriptEditBoxHandler(function(l_2_0)
      if l_2_0 == "returnSend" then
        do return end
      end
      if l_2_0 == "return" then
        do return end
      end
      if l_2_0 == "ended" then
        local tmp_ticket_count = edit_tickets:getText()
        tmp_ticket_count = string.trim(tmp_ticket_count)
        tmp_ticket_count = checkint(tmp_ticket_count)
        if tmp_ticket_count <= 1 then
          tmp_ticket_count = 1
        end
        edit_tickets:setText(tmp_ticket_count)
        updatePay(tmp_ticket_count)
        upvalue_1024 = tmp_ticket_count
      elseif l_2_0 == "began" then
        do return end
      end
      if l_2_0 == "changed" then
         -- Warning: missing end command somewhere! Added here
      end
      end)
    btn_sub:registerScriptTapHandler(function()
      audio.play(audio.button)
      local edt_txt = edit_tickets:getText()
      edt_txt = string.trim(edt_txt)
      if edt_txt == "" then
        edt_txt = 1
        edit_tickets:setText(1)
        updatePay(0)
        upvalue_1536 = 1
        return 
      end
      local ticket_count = checkint(edt_txt)
      if ticket_count <= 1 then
        edit_tickets:setText(1)
        updatePay(1)
        upvalue_1536 = 1
        return 
      else
        ticket_count = ticket_count - 1
        edit_tickets:setText(ticket_count)
        updatePay(ticket_count)
        upvalue_1536 = ticket_count
      end
      end)
    btn_add:registerScriptTapHandler(function()
      audio.play(audio.button)
      local edt_txt = edit_tickets:getText()
      edt_txt = string.trim(edt_txt)
      if edt_txt == "" then
        edt_txt = 0
        edit_tickets:setText(0)
        updatePay(0)
        upvalue_1536 = 0
        return 
      end
      local ticket_count = checkint(edt_txt)
      if ticket_count < 0 then
        edit_tickets:setText(0)
        updatePay(0)
        upvalue_1536 = 0
        return 
      else
        local tmp_gem_cost = ticket_count + 1
        if brokennum / cfgObj.extra[1].num < tmp_gem_cost then
          return 
        end
        ticket_count = ticket_count + 1
        edit_tickets:setText(ticket_count)
        updatePay(ticket_count)
        upvalue_1536 = ticket_count
      end
      end)
    local okSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    okSprite:setPreferredSize(CCSize(155, 45))
    local oklab = lbl.createFont1(18, i18n.global.dialog_button_confirm.string, ccc3(126, 39, 0))
    oklab:setPosition(CCPoint(okSprite:getContentSize().width / 2, okSprite:getContentSize().height / 2))
    okSprite:addChild(oklab)
    local okBtn = SpineMenuItem:create(json.ui.button, okSprite)
    okBtn:setPosition(CCPoint(sweepboard_bg_w / 2, 80))
    local okMenu = CCMenu:createWithItem(okBtn)
    okMenu:setPosition(0, 0)
    sweepboard_bg:addChild(okMenu)
    okBtn:registerScriptTapHandler(function()
      disableObjAWhile(okBtn)
      audio.play(audio.button)
      local itemObj = bagData.items.find(ITEM_ID_GEM)
      if not itemObj then
        itemObj = {id = ITEM_ID_GEM, num = 0}
      end
      if itemObj.num < cfgObj.extra[1].num then
        showToast(i18n.global.luckcoin_notenough.string)
        return 
      end
      if brokennum / cfgObj.extra[1].num < buyCount then
        showToast(i18n.global.luckcoin_notenough.string)
        return 
      end
      local param = {sid = player.sid, id = vpObj.id, num = buyCount}
      addWaitNet()
      netClient:exchange_act(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status == -2 then
          showToast(string.format(i18n.global.shop_onlytime.string, cfgObj.limitNum))
          return 
        end
        if l_1_0.status ~= 0 then
          showToast(i18n.global.luckcoin_notenough.string)
          return 
        end
        upvalue_1024 = brokennum - cfgObj.extra[1].num * buyCount
        itemObj.num = itemObj.num - cfgObj.extra[1].num * buyCount
        updateCoin()
        vpObj.limits = vpObj.limits - buyCount
        if vpObj.limits == 0 then
          callback()
        end
        if l_1_0.affix then
          bagData.addRewards(l_1_0.affix)
          CCDirector:sharedDirector():getRunningScene():addChild(uirewards.createFloating(l_1_0.affix), 100000)
        end
        sweepLayer:removeFromParentAndCleanup(true)
         end)
      end)
    local sweepbackEvent = function()
      audio.play(audio.button)
      sweepLayer:removeFromParentAndCleanup(true)
      end
    local sweepbtn_close0 = img.createUISprite(img.ui.close)
    local sweepbtn_close = SpineMenuItem:create(json.ui.button, sweepbtn_close0)
    sweepbtn_close:setPosition(CCPoint(sweepboard_bg_w - 25, sweepboard_bg_h - 28))
    local sweepbtn_close_menu = CCMenu:createWithItem(sweepbtn_close)
    sweepbtn_close_menu:setPosition(CCPoint(0, 0))
    sweepboard_bg:addChild(sweepbtn_close_menu, 100)
    sweepbtn_close:registerScriptTapHandler(function()
      sweepbackEvent()
      end)
    sweepLayer:setTouchEnabled(true)
    sweepLayer:setTouchSwallowEnabled(true)
    addBackEvent(sweepLayer)
    sweepLayer.onAndroidBack = function()
      sweepbackEvent()
      end
    local onEnter = function()
      print("onEnter")
      sweepLayer.notifyParentLock()
      end
    local onExit = function()
      sweepLayer.notifyParentUnlock()
      end
    sweepLayer:registerScriptHandler(function(l_11_0)
      if l_11_0 == "enter" then
        onEnter()
      elseif l_11_0 == "exit" then
        onExit()
      end
      end)
    return sweepLayer
   end
  local createItem = function(l_3_0)
    local cfgObj = cfgactivity[l_3_0.id]
    local temp_item = img.createUISprite(img.ui.casino_shop_frame)
    local item_w = temp_item:getContentSize().width
    local item_h = temp_item:getContentSize().height
    local rewards = cfgObj.rewards
    local _obj = rewards[1]
    local _item = nil
    if _obj.type == ItemType.Equip then
      local _item0 = img.createEquip(_obj.id, _obj.num)
      _item = CCMenuItemSprite:create(_item0, nil)
      _item:setScale(0.9)
      _item:setPosition(CCPoint(item_w / 2, item_h / 2 + 9))
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
        _item = CCMenuItemSprite:create(_item0, nil)
        _item:setScale(0.9)
        _item:setPosition(CCPoint(item_w / 2, item_h / 2 + 9))
        local _item_menu = CCMenu:createWithItem(_item)
        _item_menu:setPosition(CCPoint(0, 0))
        temp_item:addChild(_item_menu)
        _item:registerScriptTapHandler(function()
          audio.play(audio.button)
          ui.createItemTip(layer, _obj.id)
            end)
      end
    end
    local btn0 = img.createUISprite(img.ui.casino_shop_btn)
    local icon = img.createItemIcon2(ITEM_ID_GEM)
    icon:setScale(0.8)
    icon:setPosition(CCPoint(27, btn0:getContentSize().height / 2))
    btn0:addChild(icon)
    local lbl_price = lbl.createFont2(16, cfgObj.extra[1].num)
    lbl_price:setPosition(CCPoint(74, btn0:getContentSize().height / 2))
    btn0:addChild(lbl_price)
    local btn = SpineMenuItem:create(json.ui.button, btn0)
    btn:setPosition(CCPoint(item_w / 2, 4))
    local btn_menu = CCMenu:createWithItem(btn)
    btn_menu:setPosition(CCPoint(0, 0))
    temp_item:addChild(btn_menu, 1)
    if l_3_0.limits <= 1000 then
      local limittag = img.createUISprite(img.ui.blackmarket_limittag)
      limittag:setAnchorPoint(0, 0.5)
      limittag:setPosition(CCPoint(0, 107))
      temp_item:addChild(limittag)
    end
    local setAlreadyBuy = function()
      setShader(_item, SHADER_GRAY, true)
      _item:setEnabled(false)
      local soldout = img.createUISprite(img.ui.blackmarket_soldout)
      soldout:setPosition(CCPoint(_item:getContentSize().width / 2, _item:getContentSize().height / 2))
      _item:addChild(soldout)
      setShader(btn, SHADER_GRAY, true)
      btn:setEnabled(false)
      end
    if l_3_0.limits == 0 then
      setAlreadyBuy()
    end
    btn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if vpObj.limits == 1 then
        local surelayer = createSurebuy(vpObj, cfgObj, setAlreadyBuy)
        layer:getParent():getParent():addChild(surelayer, 1000)
      else
        local selectsweepnumlayer = selectSweepnumLayer(vpObj, cfgObj, setAlreadyBuy)
        layer:getParent():getParent():addChild(selectsweepnumlayer, 1000)
      end
      end)
    return temp_item
   end
  local lineScroll = require("ui.lineScroll")
  local scroll_params = {width = 550, height = 216}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(5, 6))
  board:addChild(scroll)
  layer.scroll = scroll
  local sortValue = function(l_4_0)
    if l_4_0.limits <= 0 then
      return 10000 + l_4_0.id
    else
      return l_4_0.id
    end
   end
  local ITEM_PER_ROW = 3
  local start_x = 101
  local step_x = 170
  local start_y = -46
  local step_y = -161
  local showList = function(l_5_0)
    for ii = 1,  l_5_0 do
      local _x = start_x + (ii - 1) % ITEM_PER_ROW * step_x
      local _y = start_y + math.floor((ii + ITEM_PER_ROW - 1) / ITEM_PER_ROW - 1) * step_y
      local tmp_item = createItem(l_5_0[ii])
      tmp_item.obj = l_5_0[ii]
      tmp_item:setPosition(CCPoint(_x + 8, _y - 55))
      scroll.content_layer:addChild(tmp_item)
    end
    local content_h = 60 - start_y - math.floor(( l_5_0 + ITEM_PER_ROW - 1) / ITEM_PER_ROW - 1) * step_y - step_y / 2
    scroll:setContentSize(CCSizeMake(scroll.width, content_h))
    scroll.content_layer:setPosition(CCPoint(0, content_h))
    scroll:setContentOffset(CCPoint(0, scroll.height - content_h))
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

