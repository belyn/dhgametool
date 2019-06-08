-- Command line was: E:\github\dhgametool\scripts\ui\activity\valuePack.lua 

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
  local vps = {}
  for _,v in ipairs(vp_ids) do
    local tmp_status = activityData.getStatusById(v)
    vps[ vps + 1] = tmp_status
  end
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(576, 436))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_vp)
  local banner = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    banner = img.createUISprite("activity_hw_board_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      banner = img.createUISprite("activity_hw_board_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        banner = img.createUISprite("activity_hw_board_jp.png")
      else
        if i18n.getCurrentLanguage() == kLanguageRussian then
          banner = img.createUISprite("activity_hw_board_ru.png")
        else
          if i18n.getCurrentLanguage() == kLanguageChinese then
            banner = img.createUISprite("activity_hw_board_cn.png")
          else
            if i18n.getCurrentLanguage() == kLanguagePortuguese then
              banner = img.createUISprite("activity_hw_board_pt.png")
            else
              if i18n.getCurrentLanguage() == kLanguageSpanish then
                banner = img.createUISprite("activity_hw_board_sp.png")
              else
                if i18n.getCurrentLanguage() == kLanguageTurkish then
                  banner = img.createUISprite("activity_hw_board_tr.png")
                else
                  banner = img.createUISprite(img.ui.activity_hw_board)
                end
              end
            end
          end
        end
      end
    end
  end
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2, board_h))
  board:addChild(banner)
  local lbl_cd_des = lbl.createFont2(14, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(1, 0.5))
  lbl_cd_des:setPosition(CCPoint(527, 28))
  banner:addChild(lbl_cd_des)
  local lbl_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(1, 0.5))
  lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMinX() - 6, 28))
  banner:addChild(lbl_cd)
  if i18n.getCurrentLanguage() == kLanguageRussian then
    lbl_cd_des:setPosition(CCPoint(475, 28))
    lbl_cd:setAnchorPoint(CCPoint(0, 0.5))
    lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMaxX() + 10, 28))
  end
  local createItem = function(l_1_0)
    local temp_item = img.createUI9Sprite(img.ui.bottom_border_2)
    temp_item:setPreferredSize(CCSizeMake(574, 90))
    local item_w = temp_item:getContentSize().width
    local item_h = temp_item:getContentSize().height
    local start_x = 47
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
            layer:getParent():getParent():getParent():addChild(tipsequip.createById(_obj.id), 10000)
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
              layer:getParent():getParent():getParent():addChild(tipsitem.createForShow({id = _obj.id}), 10000)
                  end)
          end
        end
      end
    end
    local storeObj = cfgstore[cfgactivity[l_1_0.id].storeId]
    local lbl_vip_des = lbl.createFont1(16, "VIP EXP", ccc3(115, 59, 5))
    lbl_vip_des:setPosition(CCPoint(373, 60))
    temp_item:addChild(lbl_vip_des)
    local scores = storeObj.vipExp
    local lbl_vip_exp = lbl.createFont1(22, "+" .. scores, ccc3(156, 69, 45))
    lbl_vip_exp:setScaleX(0.7)
    lbl_vip_exp:setPosition(CCPoint(373, 36))
    temp_item:addChild(lbl_vip_exp)
    local limitLabel = lbl.createFont1(16, i18n.global.limitact_limit.string .. l_1_0.limits, ccc3(115, 59, 5))
    limitLabel:setPosition(CCPoint(498, 68))
    temp_item:addChild(limitLabel)
    local btn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
    btn0:setPreferredSize(CCSizeMake(117, 45))
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
    lbl_btn:setPosition(CCPoint(59, 23))
    btn0:addChild(lbl_btn)
    local btn = SpineMenuItem:create(json.ui.button, btn0)
    btn:setPosition(CCPoint(498, 36))
    local btn_menu = CCMenu:createWithItem(btn)
    btn_menu:setPosition(CCPoint(0, 0))
    temp_item:addChild(btn_menu)
    if l_1_0.status ~= 0 or l_1_0.limits <= 0 then
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
          layer:getParent():getParent():getParent():addChild(require("ui.reward").createFloating(rw), 1000)
        end
         end)
      end)
    return temp_item
   end
  local lineScroll = require("ui.lineScroll")
  local scroll_params = {width = 574, height = 279}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(2, 0))
  board:addChild(scroll)
  layer.scroll = scroll
  local sortValue = function(l_2_0)
    if l_2_0.limits <= 0 then
      return 10000 + l_2_0.id
    else
      if l_2_0.id == IDS.VP_1.ID then
        return l_2_0.id - 100
      else
        return l_2_0.id
      end
    end
   end
  table.sort(vps, function(l_3_0, l_3_1)
    return sortValue(l_3_0) < sortValue(l_3_1)
   end)
  local showList = function(l_4_0)
    for ii = 1,  l_4_0 do
      local tmp_item = createItem(l_4_0[ii])
      tmp_item.obj = l_4_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = scroll_params.width / 2
      scroll.addItem(tmp_item)
    end
    scroll.setOffsetBegin()
   end
  showList(vps)
  local last_update = os.time() - 1
  local onUpdate = function(l_5_0)
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
  layer:registerScriptHandler(function(l_6_0)
    if l_6_0 == "enter" then
      do return end
    end
    if l_6_0 == "exit" then
      do return end
    end
    if l_6_0 == "cleanup" then
      img.unload(img.packedOthers.ui_activity_vp)
    end
   end)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui

