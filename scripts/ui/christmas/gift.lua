-- Command line was: E:\github\dhgametool\scripts\ui\christmas\gift.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.activity")
local cfghero = require("config.hero")
local cfgequip = require("config.equip")
local cfgstore = require("config.store")
local player = require("data.player")
local activityData = require("data.activity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local bag = require("data.bag")
local heros = require("data.heros")
local cfgchristmas = require("config.specialactivity")
local IDS = activityData.IDS
ui.create = function()
  local layer = CCLayer:create()
  local vpObj = activityData.getStatusById(IDS.CHRGIFT.ID)
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(576, 436))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_christmas_gift)
  local banner = nil
  if i18n.getCurrentLanguage() == kLanguageJapanese then
    banner = img.createUISprite("activity_libao_board_jp.png")
    banner:setAnchorPoint(CCPoint(0.5, 1))
    banner:setPosition(CCPoint(board_w / 2, board_h))
    board:addChild(banner)
  else
    banner = img.createUISprite("activity_libao_board.png")
    banner:setAnchorPoint(CCPoint(0.5, 1))
    banner:setPosition(CCPoint(board_w / 2, board_h))
    board:addChild(banner)
    local lable = nil
    if i18n.getCurrentLanguage() == kLanguageChinese then
      lable = img.createUISprite("activity_libao_board_cn.png")
    else
      if i18n.getCurrentLanguage() == kLanguageChineseTW then
        lable = img.createUISprite("activity_libao_board_tw.png")
      else
        if i18n.getCurrentLanguage() == kLanguageRussian then
          lable = img.createUISprite("activity_libao_board_ru.png")
        else
          if i18n.getCurrentLanguage() == kLanguageKorean then
            lable = img.createUISprite("activity_libao_board_kr.png")
          else
            if i18n.getCurrentLanguage() == kLanguagePortuguese then
              lable = img.createUISprite("activity_libao_board_pt.png")
            else
              lable = img.createUISprite("activity_libao_board_us.png")
            end
          end
        end
      end
    end
    lable:setAnchorPoint(CCPoint(0.5, 1))
    lable:setPosition(CCPoint(350, 410))
    board:addChild(lable)
  end
  layer.tipsTag = false
  local affixx_btn = 0
  local affixy_btn = 0
  local affixx_limit = 0
  local affixy_limit = 0
  local affixx_cd = 0
  local affixy_cd = -5
  local affixx = 0
  local affixy = 0
  if i18n.getCurrentLanguage() == kLanguageJapanese then
    affixx_btn = -69
    affixy_btn = -20
    affixx_limit = -56
    affixy_limit = -20
    affixx_cd = -74
    affixy_cd = -25
    affixx = -58
    affixy = -22
  else
    if i18n.getCurrentLanguage() == kLanguageRussian then
      affixx_cd = -35
      affixy_cd = -5
    end
  end
  do
    for i = 1,  cfgactivity[vpObj.id].rewards do
      local item = img.createItem(cfgactivity[vpObj.id].rewards[i].id, cfgactivity[vpObj.id].rewards[i].num)
      local itembtn = SpineMenuItem:create(json.ui.button, item)
      itembtn:setAnchorPoint(CCPoint(0.5, 0))
      if i == 1 then
        itembtn:setScale(0.88)
        itembtn:setPosition(238 + affixx, 152 + affixy)
      else
        itembtn:setScale(0.7)
        itembtn:setPosition(307 + (i - 2) * 65 + affixx, 152 + affixy)
      end
      local iconMenu = CCMenu:createWithItem(itembtn)
      iconMenu:setPosition(0, 0)
      board:addChild(iconMenu)
      itembtn:registerScriptTapHandler(function()
        audio.play(audio.button)
        if layer.tipsTag == false then
          layer.tipsTag = true
          local itemnum = cfgactivity[vpObj.id].rewards[i].num
          do
            if unlock then
              itemnum = cfgactivity[vpObj.id].rewards[i].num * 7
            end
            local tips = tipsitem.createForShow({id = cfgactivity[vpObj.id].rewards[i].id, num = itemnum})
            layer:getParent():getParent():getParent():addChild(tips, 1000)
            tips.setClickBlankHandler(function()
              tips:removeFromParent()
              layer.tipsTag = false
                  end)
          end
        end
         end)
    end
  end
  local shade, showLock = nil, nil
  local sock_gift = ui.createItemForSock()
  if activityData.getStatusById(IDS.SOCKS_4.ID) and activityData.getStatusById(IDS.SOCKS_4.ID).limits > 0 then
    shade = img.createUISprite(img.ui.hero_head_shade)
    shade:setPosition(CCPoint(sock_gift:getContentSize().width / 2, sock_gift:getContentSize().height / 2))
    shade:setOpacity(120)
    sock_gift:addChild(shade)
    showLock = img.createUISprite(img.ui.devour_icon_lock)
    showLock:setPosition(CCPoint(sock_gift:getContentSize().width / 2, sock_gift:getContentSize().height / 2))
    sock_gift:addChild(showLock)
  end
  local sock_gift_btn = SpineMenuItem:create(json.ui.button, sock_gift)
  sock_gift_btn:setAnchorPoint(CCPoint(0.5, 0))
  sock_gift_btn:setPosition(502 + affixx, 152 + affixy)
  sock_gift_btn:setScale(0.7)
  local sock_gift_menu = CCMenu:createWithItem(sock_gift_btn)
  sock_gift_menu:setPosition(0, 0)
  board:addChild(sock_gift_menu)
  local createTips = function(l_2_0)
    local layer = CCLayer:create()
    local TIPS_WIDTH = 360
    local TIPS_MARGIN = 20
    local LABEL_WIDTH = TIPS_WIDTH - 2 * TIPS_MARGIN
    local container = CCLayer:create()
    local currentY = -16
    local name = lbl.createMix({font = 1, size = 18, text = i18n.item[l_2_0.id].name, width = LABEL_WIDTH, align = kCCTextAlignmentLeft, color = ccc3(255, 64, 64)})
    name:setAnchorPoint(ccp(0, 1))
    name:setPosition(TIPS_MARGIN, currentY)
    container:addChild(name)
    currentY = name:boundingBox():getMinY()
    local icon = ui.createItemForSock()
    icon:setScale(0.9)
    icon:setAnchorPoint(ccp(0, 0.5))
    icon:setPosition(TIPS_MARGIN, currentY - 49)
    container:addChild(icon)
    currentY = icon:boundingBox():getMinY()
    local brief = lbl.createMix({font = 1, size = 18, text = i18n.item[l_2_0.id].brief, width = LABEL_WIDTH - icon:getContentSize().width, align = kCCTextAlignmentLeft})
    brief:setAnchorPoint(ccp(0, 1))
    brief:setPosition(TIPS_MARGIN + 96, icon:boundingBox():getMaxY())
    container:addChild(brief)
    local explain = i18n.item[l_2_0.id].explain
    if explain and explain ~= "" then
      local label = lbl.createMix({font = 1, size = 18, text = explain, color = ccc3(255, 242, 152), width = LABEL_WIDTH, align = kCCTextAlignmentLeft})
      label:setAnchorPoint(ccp(0, 1))
      label:setPosition(TIPS_MARGIN, currentY - 15)
      container:addChild(label)
      currentY = label:boundingBox():getMinY()
    end
    local height = 30 - currentY
    local bg = img.createUI9Sprite(img.ui.tips_bg)
    bg:setPreferredSize(CCSize(TIPS_WIDTH, height))
    bg:setScale(view.minScale)
    bg:setPosition(view.physical.w / 2, view.physical.h / 2)
    container:setPosition(0, height)
    bg:addChild(container)
    layer:addChild(bg)
    local clickBlankHandler = nil
    layer.setClickBlankHandler = function(l_1_0)
      clickBlankHandler = l_1_0
      end
    local onTouch = function(l_2_0, l_2_1, l_2_2)
      if l_2_0 == "began" then
        return true
      elseif l_2_0 == "moved" then
        return 
      else
        if not bg:boundingBox():containsPoint(ccp(l_2_1, l_2_2)) then
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
    layer:registerScriptHandler(function(l_4_0)
      if l_4_0 == "enter" then
        layer.notifyParentLock()
      elseif l_4_0 == "exit" then
        layer.notifyParentUnlock()
      end
      end)
    layer:registerScriptTouchHandler(onTouch)
    layer:setTouchEnabled(true)
    return layer
   end
  sock_gift_btn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if layer.tipsTag == false then
      layer.tipsTag = true
      local itemnum = 1
      do
        local tips = createTips({id = 88888, num = itemnum})
        layer:getParent():getParent():getParent():addChild(tips, 1000)
        tips.setClickBlankHandler(function()
          tips:removeFromParent()
          layer.tipsTag = false
            end)
      end
    end
   end)
  local lbl_cd_des = lbl.createFont2(14, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd_des:setPosition(CCPoint(385 + affixx_cd, 125 + affixy_cd))
  board:addChild(lbl_cd_des)
  local lbl_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(1, 0.5))
  lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMinX() - 6, 125 + affixy_cd))
  board:addChild(lbl_cd)
  local limitLabel = lbl.createFont2(14, i18n.global.limitact_limit.string .. vpObj.limits)
  limitLabel:setPosition(CCPoint(365 + affixx_limit, 100 + affixy_limit))
  board:addChild(limitLabel)
  local storeObj = cfgstore[cfgactivity[vpObj.id].storeId]
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
  local buy0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  buy0:setPreferredSize(CCSize(160, 50))
  local pricelab = lbl.createFont1(16, item_price, ccc3(115, 59, 5))
  pricelab:setPosition(CCPoint(buy0:getContentSize().width / 2, buy0:getContentSize().height / 2))
  buy0:addChild(pricelab)
  local btn_but = SpineMenuItem:create(json.ui.button, buy0)
  btn_but:setPosition(365 + affixx_btn, 65 + affixy_btn)
  local buyMenu = CCMenu:createWithItem(btn_but)
  buyMenu:setPosition(0, 0)
  board:addChild(buyMenu)
  if vpObj.limits <= 0 then
    setShader(btn_but, SHADER_GRAY, true)
    btn_but:setEnabled(false)
    limitLabel:setVisible(false)
  end
  btn_but:registerScriptTapHandler(function()
    disableSeconds(btn_but, 8, pricelab, item_price)
    audio.play(audio.button)
    addWaitNet().setTimeout(60)
    require("common.iap").pay(storeObj.payId, function(l_1_0)
      delWaitNet()
      if l_1_0 then
        require("data.bag").addRewards(l_1_0)
        vpObj.limits = vpObj.limits - 1
        if vpObj.limits <= 0 then
          setShader(btn_but, SHADER_GRAY, true)
          btn_but:setEnabled(false)
          limitLabel:setVisible(false)
          if shade then
            shade:setVisible(false)
          end
          if showLock then
            showLock:setVisible(false)
          else
            limitLabel:setString(i18n.global.limitact_limit.string .. vpObj.limits)
          end
        end
        local rw = tablecp(l_1_0)
        arrayfilter(rw.items, function(l_1_0)
          return l_1_0.id ~= ITEM_ID_VIP_EXP
            end)
        layer:getParent():getParent():getParent():addChild(require("ui.reward").createFloating(rw), 1002)
        for i = 1,  cfgchristmas[IDS.SOCKS_4.ID].rewards do
          if cfgchristmas[IDS.SOCKS_4.ID].rewards[i].type == 1 then
            bag.items.add({id = cfgchristmas[IDS.SOCKS_4.ID].rewards[i].id, num = cfgchristmas[IDS.SOCKS_4.ID].rewards[i].num * activityData.getStatusById(IDS.SOCKS_4.ID).limits})
          else
            bag.equips.add({id = cfgchristmas[IDS.SOCKS_4.ID].rewards[i].id, num = cfgchristmas[IDS.SOCKS_4.ID].rewards[i].num * activityData.getStatusById(IDS.SOCKS_4.ID).limits})
          end
        end
        local showSocks = require("ui.christmas.socks")
        local day = activityData.getStatusById(IDS.SOCKS_4.ID).limits
        if day > 0 then
          layer:getParent():getParent():getParent():addChild(showSocks.createGiftDialog({sockId = IDS.SOCKS_4.ID, day = day}), 1001)
          activityData.getStatusById(IDS.SOCKS_4.ID).limits = 0
        end
      end
      end)
   end)
  local last_update = os.time() - 1
  local onUpdate = function(l_5_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    local remain_cd = vpObj.cd - (os.time() - activityData.pull_time)
    if remain_cd >= 0 then
      local time_str = time2string(remain_cd)
      lbl_cd:setString(time_str)
    else
       -- Warning: missing end command somewhere! Added here
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  layer:registerScriptHandler(function(l_6_0)
    if l_6_0 == "enter" then
      do return end
    end
    if l_6_0 == "exit" then
      do return end
    end
    if l_6_0 == "cleanup" then
      img.unload(img.packedOthers.ui_activity_christmas_gift)
    end
   end)
  layer:setTouchEnabled(true)
  return layer
end

ui.createItemForSock = function()
  local lbl = require("res.lbl")
  local cfghero = require("config.hero")
  local cfgitem = require("config.item")
  local cfgequip = (require("config.equip"))
  local bg, size = nil, nil
  bg = img.createUISprite(img.ui.grid)
  size = bg:getContentSize()
  local icon = img.createUISprite("activity_icon_christmas_socks.png")
  icon:setPosition(size.width / 2, size.height / 2)
  bg:addChild(icon)
  bg:setCascadeOpacityEnabled(true)
  local l = lbl.createFont2(14, convertItemNum(1))
  l:setAnchorPoint(ccp(1, 0))
  l:setPosition(74, 6)
  bg:addChild(l)
  bg.lblNum = l
  return bg
end

return ui

