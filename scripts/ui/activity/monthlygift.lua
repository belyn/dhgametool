-- Command line was: E:\github\dhgametool\scripts\ui\activity\monthlygift.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local cfgactivity = require("config.activity")
local cfgstore = require("config.store")
local activitydata = require("data.activity")
ui.create = function()
  local layer = CCLayer:create()
  local status = ui.getActivityStatus()
  local cfgs, cfgsInStore = ui.getConfigs(status)
  img.load(img.packedOthers.ui_activity_weekly_gift)
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(576, 436))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local bg = img.createUISprite(img.ui.activity_monthly_gift)
  bg:setPosition(board_w / 2, board_h)
  bg:setAnchorPoint(0.5, 1)
  board:addChild(bg)
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
  local title = img.createUISprite(string.format("activity_monthly_gift_%s.png", suffix))
  title:setPosition(148, 12)
  title:setAnchorPoint(0, 0)
  bg:addChild(title)
  local cdClock = lbl.createFont2(16, "000:00:00", ccc3(189, 246, 68))
  cdClock:setAnchorPoint(ccp(1, 0.5))
  cdClock:setPosition(551, 24)
  bg:addChild(cdClock)
  local cdText = lbl.createFont2(16, i18n.global.activity_reset_in.string, lbl.whiteColor)
  cdText:setAnchorPoint(ccp(1, 0.5))
  cdText:setPosition(cdClock:boundingBox():getMinX(), 24)
  bg:addChild(cdText)
  local VIEW_W, VIEW_H = 574, 279
  local scroll = CCScrollView:create()
  scroll:setAnchorPoint(0, 0)
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setViewSize(CCSize(VIEW_W, VIEW_H))
  scroll:setPosition(1, 0)
  board:addChild(scroll)
  local BOX_W, BOX_H = 574, 92
  local container = (CCLayer:create())
  local currentY = nil
  for i,st in ipairs(status) do
    do
      local cfg, cfgInStore = cfgs[i], cfgsInStore[i]
      do
        local x, y = VIEW_W / 2, -3 - (i - 1) * (BOX_H + 1)
        local box = img.createUI9Sprite(img.ui.bottom_border_2)
        box:setPreferredSize(CCSize(BOX_W, BOX_H))
        box:setAnchorPoint(ccp(0.5, 1))
        box:setPosition(x, y)
        container:addChild(box)
        currentY = box:boundingBox():getMinY()
        ui.addRewardIcons(layer, container, cfg.rewards, 45, y - 44, 60)
        local limitLabel = nil
        if st.limits > 0 then
          limitLabel = lbl.createFont1(14, i18n.global.limitact_limit.string .. st.limits, ccc3(115, 59, 5))
          limitLabel:setPosition(494, y - 19)
          container:addChild(limitLabel)
        end
        local expText = lbl.createFont1(14, "VIP EXP", ccc3(115, 59, 5))
        expText:setPosition(337, y - 33)
        container:addChild(expText)
        local expLabel = lbl.createFont1(20, "+" .. cfgInStore.vipExp, ccc3(156, 69, 45))
        expLabel:setPosition(337, y - 55)
        container:addChild(expLabel)
        local buyBtn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
        buyBtn0:setPreferredSize(CCSize(128, 46))
        local buyBtn = SpineMenuItem:create(json.ui.button, buyBtn0)
        buyBtn:setPosition(494, y - 52)
        local buyBtnLbl = lbl.createFontTTF(16, ui.getPrice(cfgInStore, st.id), ccc3(115, 59, 5))
        buyBtnLbl:setPosition(68, 23)
        buyBtn0:addChild(buyBtnLbl)
        local buyMenu = CCMenu:createWithItem(buyBtn)
        buyMenu:setPosition(0, 0)
        container:addChild(buyMenu)
        if st.limits <= 0 then
          setShader(buyBtn, SHADER_GRAY, true)
          buyBtn:setEnabled(false)
        end
        buyBtn:registerScriptTapHandler(function()
          disableSeconds(buyBtn, 8, buyBtnLbl, ui.getPrice(cfgInStore, st.id))
          audio.play(audio.button)
          addWaitNet().setTimeout(60)
          require("common.iap").pay(cfgInStore.payId, function(l_1_0)
            delWaitNet()
            if l_1_0 then
              require("data.bag").addRewards(l_1_0)
              st.limits = st.limits - 1
              if st.limits <= 0 then
                setShader(buyBtn, SHADER_GRAY, true)
                buyBtn:setEnabled(false)
                limitLabel:setVisible(false)
              else
                limitLabel:setString("LIMIT: " .. st.limits)
              end
              local rw = tablecp(l_1_0)
              arrayfilter(rw.items, function(l_1_0)
                return l_1_0.id ~= ITEM_ID_VIP_EXP
                     end)
              layer:getParent():getParent():getParent():addChild(require("ui.reward").createFloating(rw), 1000)
            end
               end)
            end)
      end
    end
  end
  local height = not currentY + 3
  if height < VIEW_H then
    height = VIEW_H
  end
  container:setPosition(0, height)
  scroll:setContentSize(CCSize(VIEW_W, height))
  scroll:addChild(container)
  scroll:setContentOffset(ccp(0, VIEW_H - height))
  local onUpdate = function(l_2_0)
    if status[1] and (cdClock.cd == nil or cdClock.cd > 0) then
      local cd = status[1].cd - (os.time() - activitydata.pull_time)
      if cd < 0 then
        cd = 0
      end
      if cdClock.cd ~= cd then
        cdClock.cd = cd
        cdClock:setString(time2string(cd))
      end
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  layer:registerScriptHandler(function(l_3_0)
    if l_3_0 == "enter" then
      do return end
    end
    if l_3_0 == "exit" then
      do return end
    end
    if l_3_0 == "cleanup" then
      img.unload(img.packedOthers.ui_activity_weekly_gift)
    end
   end)
  require("ui.activity.ban").addBan(layer, scroll)
  layer:setTouchSwallowEnabled(false)
  return layer
end

local ids = {}
ui.getAllIds = function()
  if  ids == 0 then
    for k,v in pairs(activitydata.IDS) do
      if k:beginwith("MONTHLY_GIFT") then
        ids[ ids + 1] = v.ID
      end
    end
  end
  return ids
end

ui.getActivityStatus = function()
  local all = {}
  for _,id in ipairs(ui.getAllIds()) do
    local status = activitydata.getStatusById(id)
    if status then
      status.read = 1
      all[ all + 1] = status
    end
  end
  table.sort(all, function(l_1_0, l_1_1)
    if l_1_0.limits > 0 and l_1_1.limits <= 0 then
      return true
    elseif l_1_0.limits <= 0 and l_1_1.limits > 0 then
      return false
    else
      return l_1_0.id < l_1_1.id
    end
   end)
  return all
end

ui.showRedDot = function()
  for _,id in ipairs(ui.getAllIds()) do
    local status = activitydata.getStatusById(id)
    if status and status.limits > 0 and status.read == 0 then
      return true
    end
  end
  return false
end

ui.getPrice = function(l_5_0)
  local cfgprice = l_5_0.priceStr
  if isAmazon() then
    do return end
  end
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    cfgprice = l_5_0.priceCnStr
  else
    if i18n.getCurrentLanguage() == kLanguageChinese then
      cfgprice = l_5_0.priceCnStr
    end
  end
  local shopData = require("data.shop")
  cfgprice = shopData.getPriceByPayId(l_5_0.payId, cfgprice)
  return cfgprice
end

ui.getConfigs = function(l_6_0)
  do
    local cfgInActivity, cfgInStore = {}, {}
    for _,s in ipairs(l_6_0) do
      cfgInActivity[ cfgInActivity + 1] = cfgactivity[s.id]
      for _,cfg in pairs(cfgstore) do
        if cfg.activity == s.id then
          cfgInStore[ cfgInStore + 1] = cfg
          for _,s in (for generator) do
          end
        end
      end
      return cfgInActivity, cfgInStore
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.addRewardIcons = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4, l_7_5)
  for i,r in ipairs(l_7_2) do
    do
      local t = {id = r.id, num = r.num}
      do
        local icon = nil
        if r.type == 1 then
          icon = img.createItem(t.id, t.num)
        else
          icon = img.createEquip(t.id, t.num)
        end
        icon:setCascadeOpacityEnabled(true)
        local btn = SpineMenuItem:create(json.ui.button, icon)
        btn:setScale(0.65)
        btn:setCascadeOpacityEnabled(true)
        btn:setPosition(l_7_3 + (i - 1) * l_7_5, l_7_4)
        local menu = CCMenu:createWithItem(btn)
        menu:setPosition(0, 0)
        menu:setCascadeOpacityEnabled(true)
        l_7_1:addChild(menu)
        btn:registerScriptTapHandler(function()
          audio.play(audio.button)
          if r.type == 1 then
            layer:getParent():getParent():getParent():addChild(require("ui.tips.item").createForShow(t), 1000)
          else
            layer:getParent():getParent():getParent():addChild(require("ui.tips.equip").createForShow(t), 1000)
          end
            end)
      end
    end
  end
end

return ui

