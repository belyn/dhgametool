-- Command line was: E:\github\dhgametool\scripts\ui\tips\equip.lua 

local tips = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local cfghero = require("config.hero")
local cfgpoker = require("config.poker")
local bagdata = require("data.bag")
local herosdata = require("data.heros")
local i18n = require("res.i18n")
local attrHelper = require("fight.helper.attr")
local TIPS_WIDTH = 360
local TIPS_MARGIN = 20
local SCROLL_HEIGHT = 320
local LABEL_WIDTH = TIPS_WIDTH - 2 * TIPS_MARGIN
local rate_type = nil
local RATE_CASINO = "casino"
local RATE_HCASINO = "hcasino"
tips.createForShow = function(l_1_0)
  return tips.createLayer("show", l_1_0)
end

tips.createForShowCasino = function(l_2_0)
  rate_type = RATE_CASINO
  return tips.createLayer("show", l_2_0)
end

tips.createForShowHCasino = function(l_3_0)
  rate_type = RATE_HCASINO
  return tips.createLayer("show", l_3_0)
end

tips.createById = function(l_4_0)
  return tips.createForShow({id = l_4_0})
end

tips.createForPb = function(l_5_0)
  return tips.createForShow(l_5_0)
end

tips.createForHero = function(l_6_0, l_6_1, l_6_2, l_6_3)
  return tips.createLayer("hero", l_6_0, l_6_1, l_6_2, l_6_3)
end

tips.createForBag = function(l_7_0, l_7_1)
  return tips.createLayer("bag", l_7_0, l_7_1)
end

tips.createForSmith = function(l_8_0)
  return tips.createLayer("smith", l_8_0)
end

tips.createForSkin = function(l_9_0, l_9_1, l_9_2)
  return tips.createLayer("skin", l_9_0, l_9_1, l_9_2)
end

tips.createForTreasureLevelUp = function(l_10_0, l_10_1, l_10_2)
  return tips.createLayer("treasureLevelUp", l_10_0, l_10_1, l_10_2)
end

tips.createHeader = function(l_11_0, l_11_1, l_11_2, l_11_3, l_11_4, l_11_5, l_11_6)
  local container = CCLayer:create()
  local currentY = 0
  local name = lbl.createMix({font = 1, size = 18, text = i18n.equip[l_11_1.id].name, width = LABEL_WIDTH, align = kCCTextAlignmentLeft, color = lbl.qualityColors[cfgequip[l_11_1.id].qlt]})
  name:setAnchorPoint(ccp(0, 1))
  name:setPosition(TIPS_MARGIN, currentY)
  container:addChild(name)
  currentY = name:boundingBox():getMinY()
  local icon = nil
  if cfgequip[l_11_1.id].pos == EQUIP_POS_SKIN then
    icon = img.createSkinEquip(l_11_1.id)
  else
    icon = img.createEquip(l_11_1.id)
  end
  icon:setScale(0.9)
  icon:setAnchorPoint(ccp(0, 0.5))
  icon:setPosition(TIPS_MARGIN, currentY - 49)
  container:addChild(icon)
  currentY = icon:boundingBox():getMinY()
  local pos = lbl.createMixFont1(18, i18n.global.equip_pos_" .. cfgequip[l_11_1.id].po.string, ccc3(251, 251, 251))
  pos:setAnchorPoint(ccp(0, 0))
  pos:setPosition(TIPS_MARGIN + 96, icon:boundingBox():getMidY())
  container:addChild(pos)
  local rate = nil
  if rate_type and rate_type == RATE_CASINO then
    local casinodata = require("data.casino")
    rate = casinodata.getRateById(l_11_1.id, 2)
  elseif rate_type and rate_type == RATE_HCASINO then
    local casinodata = require("data.highcasino")
    rate = casinodata.getRateById(l_11_1.id, 2)
  end
  upvalue_3072 = nil
  if rate and rate > 0 then
    local lbl_rate = lbl.createMix({font = 1, size = 16, text = i18n.global.casino_item_rate.string .. ":" .. rate .. "%", width = LABEL_WIDTH - icon:getContentSize().width, align = kCCTextAlignmentLeft})
    lbl_rate:setAnchorPoint(ccp(0, 0))
    lbl_rate:setPosition(TIPS_MARGIN + 96, icon:boundingBox():getMinY())
    container:addChild(lbl_rate)
  end
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_11_1.owner and cfgequip[l_11_1.id].pos == EQUIP_POS_TREASURE and cfgequip[l_11_1.id].treasureNext and l_11_6 then
    local btn0 = img.createUISprite(img.ui.treasure_up)
    local btn = SpineMenuItem:create(json.ui.button, btn0)
    btn:setPosition(TIPS_WIDTH - TIPS_MARGIN - btn0:getContentSize().width * 0.5, icon:boundingBox():getMidY())
    do
      local btnMenu = CCMenu:createWithItem(btn)
      btnMenu:setPosition(0, 0)
      container:addChild(btnMenu)
      btn:registerScriptTapHandler(function()
      audio.play(audio.button)
      local upgrade = require("ui.treasure.upgrade")
      layer:addChild(upgrade.create(equip, levelUphandler), 1000)
      end)
    end
    do return end
    local param = {id = l_11_1.owner.id, lv = l_11_1.owner.lv, showGroup = true, showStar = true, wake = l_11_1.owner.wake, orangeFx = nil, petID = nil, hid = l_11_1.owner.hid}
    local head = img.createHeroHeadByParam(param)
    head:setScale(0.8)
    head:setAnchorPoint(ccp(1, 0.5))
    head:setPosition(TIPS_WIDTH - TIPS_MARGIN, icon:boundingBox():getMidY())
    container:addChild(head)
  end
  local height = not currentY
  local layer = CCLayer:create()
  layer:ignoreAnchorPointForPosition(false)
  layer:setContentSize(CCSize(TIPS_WIDTH, height))
  container:setPosition(0, height)
  layer:addChild(container)
  return layer
end

tips.createMiddle = function(l_12_0, l_12_1, l_12_2, l_12_3, l_12_4)
  local labels = {}
  local owner = l_12_0.owner
  for i = 1, 3 do
    local attr = cfgequip[l_12_0.id].base" .. 
    if attr then
      local name, value = buffString(attr.type, math.abs(attr.num))
      local attr_str = "+" .. value .. " " .. name
      if attr.num < 0 then
        attr_str = "-" .. value .. " " .. name
      elseif attr.num == 0 then
        attr_str = name
      end
      labels[#labels + 1] = {label = lbl.createMixFont1(18, attr_str, ccc3(251, 251, 251)), x = TIPS_MARGIN, offsetY = op3(i == 1, 0, 2)}
    end
  end
  if cfgequip[l_12_0.id].job or cfgequip[l_12_0.id].group then
    local activated = false
    if owner and (arraycontains(cfgequip[l_12_0.id].job, cfghero[owner.id].job) or cfgequip[l_12_0.id].group == cfghero[owner.id].group) then
      activated = true
    end
    local titleArr = {}
    if cfgequip[l_12_0.id].job then
      for _,id in ipairs(cfgequip[l_12_0.id].job) do
        if cfgequip[l_12_0.id].job then
          titleArr[#titleArr + 1] = i18n.global.job_" .. i.string
        end
      end
    else
      if cfgequip[l_12_0.id].group then
        titleArr[#titleArr + 1] = i18n.global.hero_group_" .. cfgequip[l_12_0.id].grou.string
      end
    end
    labels[#labels + 1] = {label = lbl.createMix({font = 1, size = 18, text = i18n.global.tips_activate.string .. table.concat(titleArr, ","), color = op3(activated, ccc3(237, 203, 31), ccc3(127, 127, 127)), width = LABEL_WIDTH, align = kCCTextAlignmentLeft}), x = TIPS_MARGIN, offsetY = 10}
    local attrColor = op3(activated, ccc3(251, 251, 251), ccc3(127, 127, 127))
    for i = 1, 3 do
      local attr = cfgequip[l_12_0.id].act" .. 
      if attr then
        local name, value = buffString(attr.type, math.abs(attr.num))
        local attr_str = "+" .. value .. " " .. name
        if attr.num < 0 then
          attr_str = "-" .. value .. " " .. name
        elseif attr.num == 0 then
          attr_str = name
        end
        labels[#labels + 1] = {label = lbl.createMixFont1(18, attr_str, attrColor), x = TIPS_MARGIN, offsetY = op3(i == 1, 4, 2)}
      end
    end
  end
  if cfgequip[l_12_0.id].form then
    local sum = #cfgequip[l_12_0.id].form
    local num = 0
    if owner then
      for _,id in ipairs(owner.equips) do
        if arrayequal(cfgequip[id].form, cfgequip[l_12_0.id].form) then
          num = num + 1
        end
      end
    end
    local titleText = nil
    if num > 0 then
      titleText = i18n.equip[l_12_0.id].suitName .. " (" .. num .. "/" .. sum .. ")"
    else
      titleText = i18n.equip[l_12_0.id].suitName .. " (" .. sum .. ")"
    end
    labels[#labels + 1] = {label = lbl.createMix({font = 1, size = 18, text = titleText, color = ccc3(237, 203, 31), width = LABEL_WIDTH, align = kCCTextAlignmentLeft}), x = TIPS_MARGIN, offsetY = 10}
    for i = 1, 3 do
      local attr = cfgequip[l_12_0.id].suit" .. 
      if attr then
        local attr = cfgequip[l_12_0.id].suit" .. 
        local name, value = buffString(attr.type, math.abs(attr.num))
        local attr_str = "+" .. value .. " " .. name
        if attr.num < 0 then
          attr_str = "-" .. value .. " " .. name
        elseif attr.num == 0 then
          attr_str = name
        end
        local attrColor = op3(i + 1 <= num, ccc3(126, 231, 48), ccc3(127, 127, 127))
        labels[#labels + 1] = {label = lbl.createMixFont1(18, attr_str, attrColor), x = TIPS_MARGIN, offsetY = op3(i == 1, 4, 2)}
      end
    end
  end
  if i18n.equip[l_12_0.id].explain then
    labels[#labels + 1] = {label = lbl.createMix({font = 1, size = 18, text = i18n.equip[l_12_0.id].explain, color = ccc3(255, 242, 152), width = LABEL_WIDTH, align = kCCTextAlignmentLeft}), x = TIPS_MARGIN, offsetY = 10}
  end
  local container, currentY = alignLabels(labels)
  local cHeight = not currentY
  local vHeight = op3(cHeight < SCROLL_HEIGHT, cHeight, SCROLL_HEIGHT)
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:ignoreAnchorPointForPosition(false)
  scroll:setContentSize(CCSize(TIPS_WIDTH, cHeight))
  scroll:setViewSize(CCSize(TIPS_WIDTH, vHeight))
  scroll:setTouchEnabled(vHeight < cHeight)
  scroll:setContentOffset(ccp(0, vHeight - cHeight))
  container:setPosition(0, cHeight)
  scroll:getContainer():addChild(container)
  return scroll
end

tips.createFooter = function(l_13_0, l_13_1, l_13_2, l_13_3, l_13_4)
  local container = nil
  local btnW, btnH = 130, 50
  if l_13_1 or l_13_3 then
    container = CCLayer:create()
    container:ignoreAnchorPointForPosition(false)
    container:setContentSize(CCSize(TIPS_WIDTH, btnH))
  end
  if l_13_1 then
    local btn0 = nil
    if cfgequip[l_13_0.id].pos == 7 and cfgequip[l_13_0.id].powerful == nil and l_13_0.flag and l_13_0.flag == true then
      btn0 = img.createLogin9Sprite(img.login.button_9_small_orange)
    else
      btn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
    end
    btn0:setPreferredSize(CCSize(btnW, btnH))
    local btn = SpineMenuItem:create(json.ui.button, btn0)
    btn:setPosition(op3(l_13_3, TIPS_WIDTH / 2 - 75, TIPS_WIDTH / 2), btnH / 2)
    local btnLbl = lbl.createFont1(18, l_13_1, ccc3(115, 59, 5))
    btnLbl:setPosition(btnW / 2, btnH / 2)
    btn0:addChild(btnLbl)
    local btnMenu = CCMenu:createWithItem(btn)
    btnMenu:setPosition(0, 0)
    container:addChild(btnMenu)
    btn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if btn1handler then
        btn1handler(equip)
      end
      end)
  end
  if l_13_3 then
    local btn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
    btn0:setPreferredSize(CCSize(btnW, btnH))
    local btn = SpineMenuItem:create(json.ui.button, btn0)
    btn:setPosition(TIPS_WIDTH / 2 + 75, btnH / 2)
    local btnLbl = lbl.createFont1(18, l_13_3, ccc3(115, 59, 5))
    btnLbl:setPosition(btnW / 2, btnH / 2)
    btn0:addChild(btnLbl)
    local btnMenu = CCMenu:createWithItem(btn)
    btnMenu:setPosition(0, 0)
    container:addChild(btnMenu)
    btn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if btn2handler then
        btn2handler(equip)
      end
      end)
  end
  return container
end

tips.create = function(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4, l_14_5, l_14_6)
  local container = CCLayer:create()
  local header = tips.createHeader(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4, l_14_5, l_14_6)
  local middle = tips.createMiddle(l_14_1, l_14_2, l_14_3, l_14_4, l_14_5)
  local footer = tips.createFooter(l_14_1, l_14_2, l_14_3, l_14_4, l_14_5)
  local currentY = 0
  if header then
    header:setAnchorPoint(ccp(0, 1))
    header:setPosition(0, currentY - 17)
    container:addChild(header)
    currentY = header:boundingBox():getMinY()
  end
  if middle then
    middle:setAnchorPoint(ccp(0, 1))
    middle:setPosition(0, currentY - 13)
    container:addChild(middle)
    currentY = middle:boundingBox():getMinY()
  end
  if footer then
    footer:setAnchorPoint(ccp(0, 1))
    footer:setPosition(0, currentY - 17)
    container:addChild(footer)
    currentY = footer:boundingBox():getMinY()
  end
  local height = 30 - currentY
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setPreferredSize(CCSize(TIPS_WIDTH, height))
  container:setPosition(0, height)
  bg:addChild(container)
  return bg
end

tips.createForDrop = function(l_15_0, l_15_1, l_15_2)
  local h = 330
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setPreferredSize(CCSize(TIPS_WIDTH, h))
  local hint = lbl.createMixFont1(16, i18n.global.tips_drop_hint.string, ccc3(255, 246, 223))
  hint:setAnchorPoint(ccp(0, 1))
  hint:setPosition(25, h - 22)
  bg:addChild(hint)
  local box = img.createUI9Sprite(img.ui.smith_drop_bg)
  box:setAnchorPoint(ccp(0.5, 1))
  box:setPreferredSize(CCSize(TIPS_WIDTH - 50, h - 86))
  box:setPosition(TIPS_WIDTH / 2, h - 60)
  bg:addChild(box)
  for i,stage in ipairs(arraymerge(l_15_1, l_15_2)) do
    do
      local disable = arraycontains(l_15_2, stage)
      local btnW, btnH = TIPS_WIDTH - 66, 72
      local btn0 = nil
      if disable then
        btn0 = img.createLogin9Sprite(img.login.button_9_small_grey)
      else
        btn0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
      end
      btn0:setPreferredSize(CCSize(btnW, btnH))
      local btn = SpineMenuItem:create(json.ui.button, btn0)
      btn:setPosition(TIPS_WIDTH / 2, h - 27 - i * 78)
      btn:setEnabled( disable)
      local fort, num = require("data.hook").getFortStageByStageId(stage)
      local text = string.format(i18n.global.tips_go_hook.string, fort, num)
      local btnLbl = lbl.createFont1(18, text, ccc3(115, 59, 5))
      btnLbl:setPosition(btnW / 2, btnH / 2)
      btn0:addChild(btnLbl)
      if disable then
        setShader(btnLbl, SHADER_GRAY, true)
      end
      local btnMenu = CCMenu:createWithItem(btn)
      btnMenu:setPosition(0, 0)
      bg:addChild(btnMenu)
      btn:registerScriptTapHandler(function()
        audio.play(audio.button)
        if require("data.hook").getHookStage() == stage then
          showToast(i18n.global.hook_already_hooked.string)
          return 
        end
        replaceScene(require("ui.hook.map").create({pop_layer = "stage", stage_id = stage}))
         end)
    end
  end
  return bg
end

tips.createLayer = function(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4)
  local layer = (CCLayer:create())
  local tips1, tips2 = nil, nil
  local createTips = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
    if l_1_0 == "show" then
      tips1 = tips.create(layer, l_1_1)
    elseif l_1_0 == "bag" then
      tips1 = tips.create(layer, l_1_1, i18n.global.tips_sell.string, l_1_2)
      if cfgequip[l_1_1.id].getWays then
        local getwaytips = nil
        do
          local getway0 = img.createUISprite(img.ui.bag_icon_getway)
          local getwayBtn = SpineMenuItem:create(json.ui.button, getway0)
          getwayBtn:setPosition(tips1:getContentSize().width - 38, tips1:getContentSize().height - 35)
          local getwayBtnMenu = CCMenu:createWithItem(getwayBtn)
          getwayBtnMenu:setPosition(0, 0)
          tips1:addChild(getwayBtnMenu)
          getwayBtn:registerScriptTapHandler(function()
            audio.play(audio.button)
            if getwaytips == nil then
              tips1:runAction(CCMoveTo:create(0.1, CCPoint(view.physical.w / 2 - tips1:getContentSize().width / 2 * view.minScale, view.physical.h / 2)))
              schedule(layer, 0.1, function()
                getwaytips = require("ui.tips.getway").createLayer(equip, 2)
                upvalue_1024 = getwaytips.bg
                layer:addChild(getwaytips)
                     end)
            else
              tips1:runAction(CCMoveTo:create(0.1, CCPoint(view.physical.w / 2, view.physical.h / 2)))
              upvalue_3072 = nil
              getwaytips:removeFromParentAndCleanup(true)
              upvalue_512 = nil
            end
               end)
        end
      elseif l_1_0 == "skin" then
        if (cfgequip[l_1_1.id].powerful and cfgequip[l_1_1.id].powerful == 1) or l_1_1.flag == false then
          tips1 = tips.create(layer, l_1_1, i18n.global.ui_decompose_preview.string, l_1_2)
        elseif l_1_3 then
          tips1 = tips.create(layer, l_1_1, i18n.global.devour_btn.string, l_1_3, i18n.global.ui_decompose_preview.string, l_1_2)
        else
          tips1 = tips.create(layer, l_1_1, i18n.global.ui_decompose_preview.string, l_1_2)
        end
      elseif l_1_0 == "smith" then
        local can, cannot = tips.dropStages(l_1_1.id)
        tips1 = tips.createForDrop(l_1_1, can, cannot)
        tips1:setVisible(false)
        upvalue_4608 = tips.create(layer, l_1_1, i18n.global.tips_drop.string, function()
          audio.play(audio.button)
          if #can + #cannot == 0 then
            showToast(i18n.global.tips_no_drop.string)
            return 
          end
          tips1:setVisible(true)
            end)
      elseif l_1_0 == "hero" then
        if cfgequip[l_1_1.id].pos == EQUIP_POS_JADE then
          if isJadeUpgradable(l_1_1.id) then
            tips1 = tips.create(layer, l_1_1, i18n.global.tips_recast.string, l_1_2, i18n.global.tips_upgrade.string, l_1_3)
          else
            tips1 = tips.create(layer, l_1_1, i18n.global.tips_recast.string, l_1_2)
          end
        elseif l_1_1.hero and l_1_1.hero == l_1_1.owner then
          if tips.existsAvailableEquipInBag(l_1_1.hero, cfgequip[l_1_1.id].pos) then
            tips1 = tips.create(layer, l_1_1, i18n.global.tips_take_off.string, l_1_2, i18n.global.tips_replace.string, l_1_3, l_1_4)
          else
            tips1 = tips.create(layer, l_1_1, i18n.global.tips_take_off.string, l_1_2, nil, nil, l_1_4)
          end
        else
          local equip2 = nil
          for _,id in ipairs(l_1_1.hero.equips) do
            if cfgequip[id].pos == cfgequip[l_1_1.id].pos then
              equip2 = {id = id, owner = l_1_1.hero}
          else
            end
          end
          if equip2 then
            tips1 = tips.create(layer, l_1_1, i18n.global.tips_replace.string, l_1_2)
            upvalue_4608 = tips.create(layer, equip2)
          else
            tips1 = tips.create(layer, l_1_1, i18n.global.tips_put_on.string, l_1_2)
          end
        elseif l_1_0 == "treasureLevelUp" then
          tips1 = tips.create(layer, l_1_1, i18n.global.treasure_material_put_one.string, l_1_2, i18n.global.treasure_material_put_ten.string, l_1_3)
        end
      end
    end
    if tips2 then
      tips1:setScale(view.minScale)
      tips1:setAnchorPoint(ccp(0, 1))
      layer:addChild(tips1)
      tips2:setScale(view.minScale)
      tips2:setAnchorPoint(ccp(1, 1))
      layer:addChild(tips2)
      local tips1h = tips1:getPreferredSize().height
      local tips2h = tips2:getPreferredSize().height
      local h = view.physical.h / 2 + math.max(tips1h, tips2h) / 2 * view.minScale
      tips1:setPosition(view.physical.w / 2 + 1, h)
      tips2:setPosition(view.physical.w / 2, h)
    else
      tips1:setScale(view.minScale)
      tips1:setPosition(view.physical.w / 2, view.physical.h / 2)
      layer:addChild(tips1)
    end
   end
  createTips(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4)
  layer.refresh = function(l_2_0)
    if tips1 then
      tips1:removeFromParent()
      tips1 = nil
    end
    if tips2 then
      tips2:removeFromParent()
      upvalue_512 = nil
    end
    createTips(kind, l_2_0, handler1, handler2, handler3)
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
      if not tips1:isVisible() or not tips1:boundingBox():containsPoint(ccp(l_4_1, l_4_2)) then
        if tips2 and not tolua.isnull(tips2) and tips2:boundingBox():containsPoint(ccp(l_4_1, l_4_2)) then
          do return end
        end
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
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

tips.existsAvailableEquipInBag = function(l_17_0, l_17_1)
  for i,eq in ipairs(bagdata.equips) do
    if cfgequip[eq.id].pos == l_17_1 and cfgequip[eq.id].lv <= l_17_0.lv then
      return true
    end
  end
  return false
end

tips.dropStages = function(l_18_0)
  local max = require("data.hook").getMaxHookStage()
  local num = 3
  local can, cannot = {}, {}
  if max > 0 and max <= #cfgpoker then
    for i = max, 1, -1 do
      for _,info in ipairs(cfgpoker[i].yes) do
        if info.id == l_18_0 and info.type == 2 then
          table.insert(can, 1, i)
      else
        end
      end
      if #can == num then
        do return end
      end
    end
  end
  if max + 1 > 0 and max + 1 <= #cfgpoker then
    for i = max + 1, #cfgpoker do
      for _,info in ipairs(cfgpoker[i].yes) do
        if info.id == l_18_0 and info.type == 2 then
          table.insert(cannot, i)
      else
        end
      end
      if #cannot == num then
        do return end
      end
    end
  end
  if #can + #cannot <= 3 then
    return can, cannot
  elseif #can == 1 then
    return can, {cannot[1], cannot[2]}
  elseif #can == 2 then
    return can, {cannot[1]}
   -- DECOMPILER ERROR: Unhandled construct in table

   -- DECOMPILER ERROR: unhandled table 

  elseif #can == 3 then
    return {can[2], can[3]}, can[2]
  end
   -- DECOMPILER ERROR: unhandled table 

  return {can[2], can[3]}, cannot
end

return tips

