-- Command line was: E:\github\dhgametool\scripts\ui\activity\weeklygift_ba.lua 

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
  img.unload(img.packedOthers.ui_activity_weekly_gift)
  img.unload(img.packedOthers.ui_activity_weekly_gift_cn)
  if i18n.getCurrentLanguage() == kLanguageChinese or i18n.getCurrentLanguage() == kLanguageChineseTW then
    img.load(img.packedOthers.ui_activity_weekly_gift_cn)
  else
    img.load(img.packedOthers.ui_activity_weekly_gift)
  end
  local bg = img.createUISprite(img.ui.activity_weekly_gift)
  bg:setScale(view.minScale)
  bg:setPosition(scalep(638, 359))
  layer:addChild(bg)
  local cdContainer = CCSprite:create()
  cdContainer:setScale(view.minScale)
  cdContainer:setPosition(scalep(533, 290))
  layer:addChild(cdContainer)
  local cdText = lbl.createFont2(18, i18n.global.activity_reset_in.string, lbl.whiteColor)
  cdText:setAnchorPoint(ccp(0, 0.5))
  cdText:setPosition(0, 5)
  cdContainer:addChild(cdText)
  local cdClock = lbl.createFont2(18, "00:00:00", ccc3(189, 246, 68))
  cdClock:setAnchorPoint(ccp(0, 0.5))
  cdClock:setPosition(cdText:boundingBox():getMaxX() + 10, 5)
  cdContainer:addChild(cdClock)
  cdContainer:setContentSize(CCSize(cdClock:boundingBox():getMaxX(), 10))
  local VIEW_W, VIEW_H = 564, 172
  local scroll = CCScrollView:create()
  scroll:ignoreAnchorPointForPosition(false)
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setViewSize(CCSize(VIEW_W, VIEW_H))
  scroll:setScale(view.minScale)
  scroll:setPosition(scalep(638, 148))
  layer:addChild(scroll)
  local BOX_W, BOX_H = 548, 165
  local container = (CCLayer:create())
  local currentY = nil
  for i,st in ipairs(status) do
    do
      local cfg, cfgInStore = cfgs[i], cfgsInStore[i]
      do
        local x, y = VIEW_W / 2, -3 - (i - 1) * (BOX_H + 1)
        local box = img.createUI9Sprite(img.ui.arena_frame5)
        box:setPreferredSize(CCSize(BOX_W, BOX_H))
        box:setAnchorPoint(ccp(0.5, 1))
        box:setPosition(x, y)
        container:addChild(box)
        currentY = box:boundingBox():getMinY()
        ui.addRewardIcons(layer, box, cfg.rewards, 80, BOX_H / 2, 95)
        local limitLabel = nil
        if st.limits > 0 then
          limitLabel = lbl.createFont1(16, "LIMIT: " .. st.limits, ccc3(115, 59, 5))
          limitLabel:setPosition(ccp(442, 106))
          box:addChild(limitLabel)
        end
        local expText = lbl.createFont1(16, "VIP EXP", ccc3(122, 83, 52))
        expText:setPosition(ccp(289, 90))
        box:addChild(expText)
        local expLabel = lbl.createFont1(22, "+" .. cfgInStore.vipExp, ccc3(156, 69, 45))
        expLabel:setPosition(ccp(289, 67))
        box:addChild(expLabel)
        local buyBtn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
        buyBtn0:setPreferredSize(CCSize(146, 54))
        local buyBtn = SpineMenuItem:create(json.ui.button, buyBtn0)
        buyBtn:setPosition(ccp(442, 64))
        local buyBtnLbl = lbl.createFontTTF(18, ui.getPrice(cfgInStore, id), ccc3(115, 59, 5))
        buyBtnLbl:setPosition(73, 27)
        buyBtn0:addChild(buyBtnLbl)
        local buyMenu = CCMenu:createWithItem(buyBtn)
        buyMenu:setPosition(0, 0)
        box:addChild(buyMenu)
        if st.limits == 0 then
          setShader(buyBtn, SHADER_GRAY, true)
          buyBtn:setEnabled(false)
        end
        buyBtn:registerScriptTapHandler(function()
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
              layer:addChild(require("ui.reward").createFloating(rw), 1000)
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
    if status and status[1] and (cdClock.cd == nil or cdClock.cd > 0) then
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
  layer:setTouchSwallowEnabled(false)
  require("ui.activity.ban").addBan(layer, scroll)
  layer:setTouchSwallowEnabled(false)
  return layer
end

local ids = {}
ui.getAllIds = function()
  if  ids == 0 then
    for k,v in pairs(activitydata.IDS) do
      if k:beginwith("WEEKLY_GIFT") then
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
  if APP_CHANNEL and (APP_CHANNEL == "LT" or APP_CHANNEL == "IAS") then
    cfgprice = l_5_0.priceCnStr
  end
  return cfgprice
end

ui.getConfigInStore = function(l_6_0)
  for _,cfg in pairs(cfgstore) do
    if cfg.activity == l_6_0 then
      return cfg
    end
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
        btn:setCascadeOpacityEnabled(true)
        btn:setPosition(l_7_3 + (i - 1) * l_7_5, l_7_4)
        local menu = CCMenu:createWithItem(btn)
        menu:setPosition(0, 0)
        menu:setCascadeOpacityEnabled(true)
        l_7_1:addChild(menu)
        btn:registerScriptTapHandler(function()
          audio.play(audio.button)
          if r.type == 1 then
            layer:addChild(require("ui.tips.item").createForShow(t), 1000)
          else
            layer:addChild(require("ui.tips.equip").createForShow(t), 1000)
          end
            end)
      end
    end
  end
end

ui.getConfigs = function(l_8_0)
  do
    local cfgInActivity, cfgInStore = {}, {}
    for _,s in ipairs(l_8_0) do
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

return ui

