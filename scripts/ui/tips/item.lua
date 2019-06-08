-- Command line was: E:\github\dhgametool\scripts\ui\tips\item.lua 

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
local bagdata = require("data.bag")
local herosdata = require("data.heros")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local TIPS_WIDTH = 360
local TIPS_MARGIN = 20
local SCROLL_HEIGHT = 320
local LABEL_WIDTH = TIPS_WIDTH - 2 * TIPS_MARGIN
local rate_type = nil
local RATE_CASINO = "casino"
local RATE_HCASINO = "hcasino"
local getEXQHeroList = function(l_1_0)
  local items = {}
  local herolist = cfgitem[l_1_0].heroList
  if not herolist then
    return items
  end
  for ii = 1,  herolist do
    local tlist = require("config.herolist")[herolist[ii]].heroList
    for jj = 1,  tlist do
      items[ items + 1] = tlist[jj]
    end
  end
  return items
end

tips.createForShow = function(l_2_0)
  return tips.createLayer("show", l_2_0)
end

tips.createForShowCasino = function(l_3_0)
  rate_type = RATE_CASINO
  return tips.createLayer("show", l_3_0)
end

tips.createForShowHCasino = function(l_4_0)
  rate_type = RATE_HCASINO
  return tips.createLayer("show", l_4_0)
end

tips.createForPb = function(l_5_0)
  return tips.createForShow(tablecp(l_5_0))
end

tips.createForBag = function(l_6_0, l_6_1, l_6_2)
  return tips.createLayer("bag", l_6_0, nil, l_6_1, l_6_2)
end

tips.createForMarket = function(l_7_0, l_7_1, l_7_2)
  return tips.createLayer("market", l_7_0, nil, l_7_1, l_7_2)
end

tips.createForForge = function(l_8_0, l_8_1)
  return tips.createLayer("forge", l_8_0, nil, l_8_1)
end

tips.createForJadeOn = function(l_9_0, l_9_1)
  return tips.createLayer("jadeOn", l_9_0, nil, l_9_1)
end

tips.createForJadeOff = function(l_10_0, l_10_1)
  return tips.createLayer("jadeOff", l_10_0, nil, l_10_1)
end

tips.createForJadeReplace = function(l_11_0, l_11_1, l_11_2)
  return tips.createLayer("jadeReplace", l_11_0, nil, l_11_1, l_11_2)
end

tips.createForJadeCompare = function(l_12_0, l_12_1, l_12_2)
  return tips.createLayer("jadeCompare", l_12_0, l_12_1, l_12_2)
end

tips.createHeader = function(l_13_0, l_13_1, l_13_2, l_13_3, l_13_4, l_13_5)
  local container = CCLayer:create()
  local currentY = 0
  local name = lbl.createMix({font = 1, size = 18, text = i18n.item[l_13_0.id].name, width = LABEL_WIDTH, align = kCCTextAlignmentLeft, color = lbl.qualityColors[cfgitem[l_13_0.id].qlt]})
  name:setAnchorPoint(ccp(0, 1))
  name:setPosition(TIPS_MARGIN, currentY)
  container:addChild(name)
  currentY = name:boundingBox():getMinY()
  local icon = img.createItem(l_13_0.id)
  icon:setScale(0.9)
  icon:setAnchorPoint(ccp(0, 0.5))
  icon:setPosition(TIPS_MARGIN, currentY - 49)
  container:addChild(icon)
  currentY = icon:boundingBox():getMinY()
  local brief = lbl.createMix({font = 1, size = 18, text = i18n.item[l_13_0.id].brief, width = LABEL_WIDTH - icon:getContentSize().width, align = kCCTextAlignmentLeft})
  brief:setAnchorPoint(ccp(0, 1))
  brief:setPosition(TIPS_MARGIN + 96, icon:boundingBox():getMaxY())
  container:addChild(brief)
  local rate = nil
  if rate_type and rate_type == RATE_CASINO then
    local casinodata = require("data.casino")
    rate = casinodata.getRateById(l_13_0.id, 1)
  elseif rate_type and rate_type == RATE_HCASINO then
    local casinodata = require("data.highcasino")
    rate = casinodata.getRateById(l_13_0.id, 1)
  end
  upvalue_3072 = nil
  if rate and rate > 0 then
    local lbl_rate = lbl.createMix({font = 1, size = 16, text = i18n.global.casino_item_rate.string .. ":" .. rate .. "%", width = LABEL_WIDTH - icon:getContentSize().width, align = kCCTextAlignmentLeft})
    lbl_rate:setAnchorPoint(ccp(0, 0))
    lbl_rate:setPosition(TIPS_MARGIN + 96, icon:boundingBox():getMinY())
    container:addChild(lbl_rate)
  end
  if l_13_0.owner then
    local head = img.createHeroHead(l_13_0.owner.id, l_13_0.owner.lv, true, true)
    head:setScale(0.8)
    head:setAnchorPoint(ccp(1, 0.5))
    head:setPosition(TIPS_WIDTH - TIPS_MARGIN, icon:boundingBox():getMidY())
    container:addChild(head)
  end
  local explain = i18n.item[l_13_0.id].explain
  if explain and explain ~= "" then
    local label = lbl.createMix({font = 1, size = 18, text = explain, color = ccc3(255, 242, 152), width = LABEL_WIDTH, align = kCCTextAlignmentLeft})
    label:setAnchorPoint(ccp(0, 1))
    label:setPosition(TIPS_MARGIN, currentY - 15)
    container:addChild(label)
    currentY = label:boundingBox():getMinY()
  end
  local height = not currentY
  local layer = CCLayer:create()
  layer:ignoreAnchorPointForPosition(false)
  layer:setContentSize(CCSize(TIPS_WIDTH, height))
  container:setPosition(0, height)
  layer:addChild(container)
  return layer
end

tips.createMiddle = function(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4, l_14_5)
  local labels = {}
  if cfgitem[l_14_0.id].type == ITEM_KIND_JADE then
    for i,bonus in ipairs(cfgitem[l_14_0.id].JadeBonus) do
      local name, value = buffString(bonus.type, bonus.num)
      labels[ labels + 1] = {label = lbl.createMixFont1(18, "+" .. value .. " " .. name, ccc3(126, 231, 48)), x = TIPS_MARGIN, offsetY = op3(attrNum == 1, 0, 2)}
    end
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
labels[ labels + 1] = {label = lbl.createMixFont1(18, i18n.global.tips_unsellable.string, ccc3(250, 53, 53)), x = TIPS_MARGIN, offsetY = op3(not l_14_1 or cfgitem[l_14_0.id].recovery == 1, 10, 0)}
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

tips.createFooter = function(l_15_0, l_15_1, l_15_2, l_15_3, l_15_4, l_15_5)
  local container = nil
  local btnW, btnH = 130, 50
  if l_15_2 or l_15_4 then
    container = CCLayer:create()
    container:ignoreAnchorPointForPosition(false)
    container:setContentSize(CCSize(TIPS_WIDTH, btnH))
  end
  if l_15_2 then
    local btn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
    btn0:setPreferredSize(CCSize(btnW, btnH))
    local btn = SpineMenuItem:create(json.ui.button, btn0)
    btn:setPosition(op3(l_15_4, TIPS_WIDTH / 2 - 75, TIPS_WIDTH / 2), btnH / 2)
    local btnLbl = lbl.createFont1(18, l_15_2, ccc3(115, 59, 5))
    btnLbl:setPosition(btnW / 2, btnH / 2)
    btn0:addChild(btnLbl)
    local btnMenu = CCMenu:createWithItem(btn)
    btnMenu:setPosition(0, 0)
    container:addChild(btnMenu)
    btn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if btn1handler then
        btn1handler(item)
      end
      end)
  end
  if l_15_4 then
    local btn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
    btn0:setPreferredSize(CCSize(btnW, btnH))
    local btn = SpineMenuItem:create(json.ui.button, btn0)
    btn:setPosition(TIPS_WIDTH / 2 + 75, btnH / 2)
    local btnLbl = lbl.createFont1(18, l_15_4, ccc3(115, 59, 5))
    btnLbl:setPosition(btnW / 2, btnH / 2)
    btn0:addChild(btnLbl)
    local btnMenu = CCMenu:createWithItem(btn)
    btnMenu:setPosition(0, 0)
    container:addChild(btnMenu)
    btn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if btn2handler then
        btn2handler(item)
      end
      end)
  end
  return container
end

tips.create = function(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4, l_16_5)
  local header = tips.createHeader(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4, l_16_5)
  local middle = tips.createMiddle(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4, l_16_5)
  local footer = tips.createFooter(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4, l_16_5)
  local container = CCLayer:create()
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

tips.createLayer = function(l_17_0, l_17_1, l_17_2, l_17_3, l_17_4)
  local layer = CCLayer:create()
  layer.onSkinPieceInfo = function()
    local id = cfgitem[item.id].equip.id
    local parent = layer:getParent()
    parent:addChild(require("ui.skin.preview").create(id, i18n.equip[id].name), 10000)
    layer.onAndroidBack()
   end
  layer.onPieceInfo = function()
    local id = cfgitem[item.id].heroCost.id
    local zOrder = layer:getZOrder()
    local parent = layer:getParent()
    parent:addChild(require("ui.herolist.herobook").create(id), zOrder)
    layer.onAndroidBack()
   end
  local tips1, tips2 = nil, nil
  if l_17_0 == "show" then
    if cfgitem[l_17_1.id].type == ITEM_KIND_HERO_PIECE and not isUniversalPiece(l_17_1.id) then
      tips1 = tips.create(l_17_1, false, i18n.global.tips_info.string, layer.onPieceInfo)
    else
      if cfgitem[l_17_1.id].type == ITEM_KIND_SKIN_PIECE and l_17_1.id ~= ITEM_ID_PIECE_SKIN then
        tips1 = tips.create(l_17_1, false, i18n.global.ui_decompose_preview.string, layer.onSkinPieceInfo)
      else
        tips1 = tips.create(l_17_1, false)
      end
    elseif l_17_0 == "bag" then
      if cfgitem[l_17_1.id].giftId and cfgitem[l_17_1.id].isAutoOpen == 2 then
        tips1 = tips.create(l_17_1, true, i18n.global.tips_gift.string, l_17_3)
      else
        if cfgitem[l_17_1.id].type == ITEM_KIND_HERO_PIECE then
          if isUniversalPiece(l_17_1.id) or l_17_1.id == ITEM_ID_PIECE_SKIN then
            if cfgitem[l_17_1.id].heroCost.count <= l_17_1.num then
              tips1 = tips.create(l_17_1, true, i18n.global.tips_summon.string, l_17_3)
            else
              tips1 = tips.create(l_17_1, true)
            end
          else
            if cfgitem[l_17_1.id].heroCost.count <= l_17_1.num then
              tips1 = tips.create(l_17_1, false, i18n.global.tips_info.string, layer.onPieceInfo, i18n.global.tips_summon.string, l_17_3)
            else
              tips1 = tips.create(l_17_1, false, i18n.global.tips_info.string, layer.onPieceInfo, i18n.global.tips_sell.string, l_17_3)
            end
          else
            if cfgitem[l_17_1.id].type == ITEM_KIND_SKIN_PIECE then
              if l_17_1.id == ITEM_ID_PIECE_SKIN then
                tips1 = tips.create(l_17_1, true, i18n.global.tips_forge.string, l_17_3)
              else
                if cfgitem[l_17_1.id].equip.count <= l_17_1.num then
                  tips1 = tips.create(l_17_1, false, i18n.global.ui_decompose_preview.string, layer.onSkinPieceInfo, i18n.global.tips_forge.string, l_17_3)
                else
                  tips1 = tips.create(l_17_1, true, i18n.global.ui_decompose_preview.string, layer.onSkinPieceInfo)
                end
              else
                if cfgitem[l_17_1.id].type == ITEM_KIND_TREASURE_PIECE then
                  if cfgitem[l_17_1.id].treasureCost.count <= l_17_1.num then
                    tips1 = tips.create(l_17_1, true, i18n.global.tips_summon.string, l_17_3)
                  else
                    tips1 = tips.create(l_17_1, true)
                  end
                else
                  if cfgitem[l_17_1.id].recovery ~= 1 then
                    tips1 = tips.create(l_17_1, true)
                  else
                    tips1 = tips.create(l_17_1, false, i18n.global.tips_sell.string, l_17_3)
                  end
                end
              end
            end
          end
        end
      end
      if cfgitem[l_17_1.id].getWays then
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
                getwaytips = require("ui.tips.getway").createLayer(item, 1)
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
      end
      if l_17_1.id == ITEM_ID_EXQ_Q5 or l_17_1.id == ITEM_ID_EXQ_LIGHT_Q5 or l_17_1.id == ITEM_ID_EXQ_DARK_Q5 then
        local dropstips = nil
        local drops0 = img.createUISprite(img.ui.btn_preview)
        local dropsBtn = SpineMenuItem:create(json.ui.button, drops0)
        dropsBtn:setPosition(tips1:getContentSize().width - 38, tips1:getContentSize().height - 85)
        local dropsBtnMenu = CCMenu:createWithItem(dropsBtn)
        dropsBtnMenu:setPosition(0, 0)
        tips1:addChild(dropsBtnMenu)
        dropsBtn:registerScriptTapHandler(function()
          audio.play(audio.button)
          local hlist = getEXQHeroList(item.id)
          local itemlist = require("ui.tips.itemlist")
          local rewardslayer = itemlist.create(hlist, i18n.global.ui_decompose_preview.string, itemlist.heroFunc)
          layer:addChild(rewardslayer)
            end)
      elseif l_17_0 == "market" then
        if cfgitem[l_17_1.id].type == ITEM_KIND_HERO_PIECE and not isUniversalPiece(l_17_1.id) then
          tips1 = tips.create(l_17_1, false, i18n.global.tips_info.string, layer.onPieceInfo, i18n.global.tips_buy.string, l_17_3)
        else
          tips1 = tips.create(l_17_1, false, i18n.global.tips_buy.string, l_17_3)
        end
      elseif l_17_0 == "forge" then
        tips1 = tips.create(l_17_1, false, i18n.global.tips_put_in.string, l_17_3)
      elseif l_17_0 == "jadeOn" then
        tips1 = tips.create(l_17_1, false, i18n.global.tips_put_on.string, l_17_3)
      elseif l_17_0 == "jadeOff" then
        tips1 = tips.create(l_17_1, false, i18n.global.tips_put_off.string, l_17_3)
      elseif l_17_0 == "jadeReplace" then
        tips1 = tips.create(l_17_1, false, i18n.global.tips_put_off.string, l_17_3, i18n.global.tips_replace.string, l_17_4)
      elseif l_17_0 == "jadeCompare" then
        tips1 = tips.create(l_17_1, false, i18n.global.tips_replace.string, l_17_3)
        tips2 = tips.create(l_17_2, false)
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
  local clickBlankHandler = nil
  layer.setClickBlankHandler = function(l_5_0)
    clickBlankHandler = l_5_0
   end
  local onTouch = function(l_6_0, l_6_1, l_6_2)
    if l_6_0 == "began" then
      return true
    elseif l_6_0 == "moved" then
      return 
    else
      if not tips1:boundingBox():containsPoint(ccp(l_6_1, l_6_2)) and (tips2 == nil or not tips2 or tolua.isnull(tips2) or not tips2:boundingBox():containsPoint(ccp(l_6_1, l_6_2))) then
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
  layer:registerScriptHandler(function(l_8_0)
    if l_8_0 == "enter" then
      layer.notifyParentLock()
    elseif l_8_0 == "exit" then
      layer.notifyParentUnlock()
    end
   end)
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return tips

