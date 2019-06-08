-- Command line was: E:\github\dhgametool\scripts\ui\activity\midautumn.lua 

local ui = {}
local view = require("common.view")
local img = require("res.img")
local i18n = require("res.i18n")
local audio = require("res.audio")
local json = require("res.json")
local lbl = require("res.lbl")
local cfgstore = require("config.store")
local cfgactivity = require("config.activity")
local activityData = require("data.activity")
local shop = require("data.shop")
ui.create = function()
  local layer = CCLayer:create()
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(570, 438))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(352, 57))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_mid_autumn)
  local bg = img.createUISprite(img.ui.activity_mid_autumn_board)
  bg:setPosition(CCPoint(board_w / 2, board_h / 2))
  board:addChild(bg)
  local banner = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    banner = img.createUISprite("activity_mid_autumn_board_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      banner = img.createUISprite("activity_mid_autumn_board_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        banner = img.createUISprite("activity_mid_autumn_board_jp.png")
      else
        if i18n.getCurrentLanguage() == kLanguageRussian then
          banner = img.createUISprite("activity_mid_autumn_board_ru.png")
        else
          if i18n.getCurrentLanguage() == kLanguageChinese then
            banner = img.createUISprite("activity_mid_autumn_board_cn.png")
          else
            if i18n.getCurrentLanguage() == kLanguagePortuguese then
              banner = img.createUISprite("activity_mid_autumn_board_pt.png")
            else
              banner = img.createUISprite("activity_mid_autumn_board_us.png")
            end
          end
        end
      end
    end
  end
  banner:setAnchorPoint(CCPoint(1, 1))
  banner:setPosition(CCPoint(545, 416))
  bg:addChild(banner)
  local lbl_cd_des = lbl.createFont2(14, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(1, 0.5))
  lbl_cd_des:setPosition(CCPoint(429, 182))
  bg:addChild(lbl_cd_des)
  local lbl_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(1, 0.5))
  lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMinX() - 6, 182))
  bg:addChild(lbl_cd)
  local priceBg = img.createUISprite(img.ui.activity_mid_autumn_price_bg)
  priceBg:setPosition(CCPoint(388, 152))
  bg:addChild(priceBg)
  local id = cfgactivity[activityData.IDS.MID_AUTUMN.ID].storeId
  local itemPrice = cfgstore[id].priceStr
  if isAmazon() then
    do return end
  end
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    itemPrice = cfgstore[id].priceCnStr
  else
    if i18n.getCurrentLanguage() == kLanguageChinese then
      itemPrice = cfgstore[id].priceCnStr
    else
      if i18n.getCurrentLanguage() == kLanguageKorean then
        itemPrice = cfgstore[id].priceKrStr
      end
    end
  end
  itemPrice = shop.getPrice(id, itemPrice)
  local costLab = lbl.createFontTTF(18, itemPrice, ccc3(169, 218, 255))
  costLab:setPosition(priceBg:getContentSize().width / 2, priceBg:getContentSize().height / 2)
  priceBg:addChild(costLab)
  local buyImage = img.createLogin9Sprite(img.login.button_9_small_gold)
  buyImage:setPreferredSize(CCSizeMake(158, 50))
  local buyLabel = lbl.createFont1(16, i18n.global.chip_btn_buy.string, ccc3(115, 59, 5))
  buyLabel:setPosition(CCPoint(buyImage:getContentSize().width / 2, buyImage:getContentSize().height / 2))
  buyImage:addChild(buyLabel)
  local buyBtn = SpineMenuItem:create(json.ui.button, buyImage)
  buyBtn:setPosition(CCPoint(388, 103))
  buyBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    addWaitNet().setTimeout(60)
    local storeData = cfgstore[cfgactivity[activityData.IDS.MID_AUTUMN.ID].storeId]
    require("common.iap").pay(storeData.payId, function(l_1_0)
      delWaitNet()
      if l_1_0 then
        require("data.bag").addRewards(l_1_0)
        local data = activityData.getStatusById(activityData.IDS.MID_AUTUMN.ID)
        data.limits = data.limits - 1
        if data.status ~= 0 or data.limits <= 0 then
          setShader(buyBtn, SHADER_GRAY, true)
          buyBtn:setEnabled(false)
        end
        local rw = tablecp(l_1_0)
        arrayfilter(rw.items, function(l_1_0)
          return l_1_0.id ~= ITEM_ID_VIP_EXP
            end)
        layer:addChild(require("ui.reward").createFloating(rw), 1000)
      end
      end)
   end)
  local data = activityData.getStatusById(activityData.IDS.MID_AUTUMN.ID)
  if data.status ~= 0 or data.limits <= 0 then
    setShader(buyBtn, SHADER_GRAY, true)
    buyBtn:setEnabled(false)
  end
  local buyMenu = CCMenu:createWithItem(buyBtn)
  buyMenu:setPosition(CCPoint(0, 0))
  bg:addChild(buyMenu)
  local last_update = os.time() - 1
  local onUpdate = function(l_2_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    local status = activityData.getStatusById(activityData.IDS.MID_AUTUMN.ID)
    local remain_cd = status.cd - (os.time() - activityData.pull_time)
    if remain_cd >= 0 then
      local time_str = time2string(remain_cd)
      lbl_cd:setString(time_str)
    else
       -- Warning: missing end command somewhere! Added here
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui

