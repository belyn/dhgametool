-- Command line was: E:\github\dhgametool\scripts\ui\pops\vp.lua 

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
local activityData = require("data.activity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local IDS = activityData.IDS
local ItemType = {Item = 1, Equip = 2}
local vp_ids = {IDS.VP_1.ID, IDS.VP_2.ID, IDS.VP_3.ID, IDS.VP_4.ID}
ui.create = function()
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local vps = {}
  for _,v in ipairs(vp_ids) do
    local tmp_status = activityData.getStatusById(v)
    vps[ vps + 1] = tmp_status
  end
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(766, 511))
  board:setScale(view.minScale)
  board:setPosition(scalep(480, 288))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.unload(img.packedOthers.ui_vp_pop)
  img.load(img.packedOthers.ui_vp_pop)
  local bg = img.createUISprite("activity_chaozhi_board.png")
  bg:setPosition(CCPoint(board_w / 2, board_h / 2))
  board:addChild(bg)
  board:setScale(view.minScale * 0.1)
  board:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  local btn_close0 = img.createUISprite("activity_chaozhi_close.png")
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(board_w - 65, board_h - 78))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_close_menu)
  btn_close:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local title = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    title = img.createUISprite("activity_chaozhi_board_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      title = img.createUISprite("activity_chaozhi_board_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        title = img.createUISprite("activity_chaozhi_board_jp.png")
      else
        if i18n.getCurrentLanguage() == kLanguageRussian then
          title = img.createUISprite("activity_chaozhi_board_ru.png")
        else
          if i18n.getCurrentLanguage() == kLanguageChinese then
            title = img.createUISprite("activity_chaozhi_board_cn.png")
          else
            if i18n.getCurrentLanguage() == kLanguagePortuguese then
              title = img.createUISprite("activity_chaozhi_board_pt.png")
            else
              title = img.createUISprite("activity_chaozhi_board_us.png")
            end
          end
        end
      end
    end
  end
  title:setPosition(CCPoint(446, 408))
  board:addChild(title)
  local createItem = function(l_2_0)
    local temp_item = img.createUI9Sprite(img.ui.bottom_border_2)
    temp_item:setPreferredSize(CCSizeMake(436, 85))
    local item_w = temp_item:getContentSize().width
    local item_h = temp_item:getContentSize().height
    local start_x = 42
    local step_x = 56
    local rewards = cfgactivity[l_2_0.id].rewards
    for ii = 1,  rewards do
      local _obj = rewards[ii]
      do
        if _obj.type == ItemType.Equip then
          local _item0 = img.createEquip(_obj.id, _obj.num)
          local _item = CCMenuItemSprite:create(_item0, nil)
          _item:setScale(0.63)
          _item:setPosition(CCPoint(start_x + (ii - 1) * step_x, item_h / 2))
          local _item_menu = CCMenu:createWithItem(_item)
          _item_menu:setPosition(CCPoint(0, 0))
          temp_item:addChild(_item_menu)
          _item:registerScriptTapHandler(function()
            audio.play(audio.button)
            layer:addChild(tipsequip.createById(_obj.id), 10000)
               end)
        else
          if _obj.type == ItemType.Item then
            local _item0 = img.createItem(_obj.id, _obj.num)
            local _item = CCMenuItemSprite:create(_item0, nil)
            _item:setScale(0.63)
            _item:setPosition(CCPoint(start_x + (ii - 1) * step_x, item_h / 2))
            local _item_menu = CCMenu:createWithItem(_item)
            _item_menu:setPosition(CCPoint(0, 0))
            temp_item:addChild(_item_menu)
            _item:registerScriptTapHandler(function()
              audio.play(audio.button)
              layer:addChild(tipsitem.createForShow({id = _obj.id}), 10000)
                  end)
          end
        end
      end
    end
    local storeObj = cfgstore[cfgactivity[l_2_0.id].storeId]
    local lbl_vip_des = lbl.createFont1(14, "VIP EXP", ccc3(115, 59, 5))
    lbl_vip_des:setPosition(CCPoint(275, 55))
    temp_item:addChild(lbl_vip_des)
    local scores = storeObj.vipExp
    local lbl_vip_exp = lbl.createFont1(18, "+" .. scores, ccc3(156, 69, 45))
    lbl_vip_exp:setScaleX(0.7)
    lbl_vip_exp:setPosition(CCPoint(275, 31))
    temp_item:addChild(lbl_vip_exp)
    local limitLabel = lbl.createFont1(12, i18n.global.limitact_limit.string .. l_2_0.limits, ccc3(115, 59, 5))
    limitLabel:setPosition(CCPoint(370, 65))
    temp_item:addChild(limitLabel)
    local btn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
    btn0:setPreferredSize(CCSizeMake(100, 40))
    local item_price = storeObj.priceStr
    if isAmazon() then
      do return end
    end
    if APP_CHANNEL and APP_CHANNEL ~= "" then
      item_price = storeObj.priceCnStr
    else
      if i18n.getCurrentLanguage() == kLanguageChinese then
        item_price = storeObj.priceCnStr
      end
    end
    local shopData = require("data.shop")
    item_price = shopData.getPriceByPayId(storeObj.payId, item_price)
    local lbl_btn = lbl.createFontTTF(18, item_price, ccc3(115, 59, 5))
    lbl_btn:setPosition(CCPoint(50, 21))
    btn0:addChild(lbl_btn)
    local btn = SpineMenuItem:create(json.ui.button, btn0)
    btn:setPosition(CCPoint(370, 33))
    local btn_menu = CCMenu:createWithItem(btn)
    btn_menu:setPosition(CCPoint(0, 0))
    temp_item:addChild(btn_menu)
    if l_2_0.status ~= 0 or l_2_0.limits <= 0 then
      setShader(btn, SHADER_GRAY, true)
      btn:setEnabled(false)
      limitLabel:setVisible(false)
    end
    btn:registerScriptTapHandler(function()
      disableSeconds(btn, 8, lbl_btn, item_price)
      audio.play(audio.button)
      addWaitNet().setTimeout(60)
      require("common.iap").pay(storeObj.payId, function(l_1_0)
        delWaitNet()
        if l_1_0 then
          require("data.bag").addRewards(l_1_0)
          vpObj.limits = vpObj.limits - 1
          if vpObj.limits <= 0 then
            setShader(btn, SHADER_GRAY, true)
            btn:setEnabled(false)
            limitLabel:setVisible(false)
          else
            limitLabel:setString(i18n.global.limitact_limit.string .. vpObj.limits)
          end
          local rw = tablecp(l_1_0)
          arrayfilter(rw.items, function(l_1_0)
            return l_1_0.id ~= ITEM_ID_VIP_EXP
               end)
          layer:addChild(require("ui.reward").createFloating(rw), 1000)
        end
         end)
      end)
    return temp_item
   end
  local lineScroll = require("ui.lineScroll")
  local scroll_params = {width = 450, height = 238}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(222, 100))
  board:addChild(scroll)
  layer.scroll = scroll
  local sortValue = function(l_3_0)
    if l_3_0.limits <= 0 then
      return 10000 + l_3_0.id
    else
      if l_3_0.id == IDS.VP_1.ID then
        return l_3_0.id - 100
      else
        return l_3_0.id
      end
    end
   end
  table.sort(vps, function(l_4_0, l_4_1)
    return sortValue(l_4_0) < sortValue(l_4_1)
   end)
  local showList = function(l_5_0)
    for ii = 1,  l_5_0 do
      local tmp_item = createItem(l_5_0[ii])
      tmp_item.obj = l_5_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = scroll_params.width / 2
      scroll.addItem(tmp_item)
    end
    scroll.setOffsetBegin()
   end
  showList(vps)
  local setVpPopped = function()
    activityData.setVpPopped()
    local params = {sid = player.sid, ids = vp_ids}
    netClient:activity(params, function(l_1_0)
      end)
   end
  layer:setTouchSwallowEnabled(true)
  layer:setTouchEnabled(true)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  addBackEvent(layer)
  local onEnter = function()
    layer.notifyParentLock()
    setVpPopped()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_10_0)
    if l_10_0 == "enter" then
      onEnter()
    elseif l_10_0 == "exit" then
      onExit()
    elseif l_10_0 == "cleanup" then
      img.unload(img.packedOthers.ui_vp_pop)
    end
   end)
  return layer
end

return ui

