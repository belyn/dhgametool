-- Command line was: E:\github\dhgametool\scripts\ui\tips\sell.lua 

local tips = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local cfgequip = require("config.equip")
local cfgitem = require("config.item")
local i18n = require("res.i18n")
local TIPS_WIDTH = 360
local TIPS_HEIGHT = 345
tips.create = function(l_1_0, l_1_1, l_1_2)
  local layer = (CCLayer:create())
  local price = nil
  if l_1_0 == "equip" then
    price = cfgequip[l_1_1.id].price
  else
    price = cfgitem[l_1_1.id].recoveryPrice
  end
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setPreferredSize(CCSize(TIPS_WIDTH, TIPS_HEIGHT))
  bg:setScale(view.minScale)
  bg:setPosition(view.physical.w / 2, view.physical.h / 2)
  layer:addChild(bg)
  local nameText, nameColor = nil, nil
  if l_1_0 == "equip" then
    nameText = i18n.equip[l_1_1.id].name
    nameColor = lbl.qualityColors[cfgequip[l_1_1.id].qlt]
  else
    nameText = i18n.item[l_1_1.id].name
    nameColor = lbl.qualityColors[cfgitem[l_1_1.id].qlt]
  end
  local name = lbl.createMix({font = 1, size = 18, text = nameText, color = nameColor, width = LABEL_WIDTH, align = kCCTextAlignmentLeft})
  name:setPosition(TIPS_WIDTH / 2, TIPS_HEIGHT - 30)
  bg:addChild(name)
  local icon = nil
  if l_1_0 == "equip" then
    icon = img.createEquip(l_1_1.id)
  else
    icon = img.createItem(l_1_1.id)
  end
  icon:setPosition(TIPS_WIDTH / 2, TIPS_HEIGHT - 97)
  bg:addChild(icon)
  local subBtn0 = img.createUISprite(img.ui.tips_sell_sub)
  local subBtn = SpineMenuItem:create(json.ui.button, subBtn0)
  subBtn:setPosition(TIPS_WIDTH / 2 - 82, TIPS_HEIGHT - 177)
  local subMenu = CCMenu:createWithItem(subBtn)
  subMenu:setPosition(0, 0)
  bg:addChild(subMenu)
  local addBtn0 = img.createUISprite(img.ui.tips_sell_add)
  local addBtn = SpineMenuItem:create(json.ui.button, addBtn0)
  addBtn:setPosition(TIPS_WIDTH / 2 + 82, TIPS_HEIGHT - 177)
  local addMenu = CCMenu:createWithItem(addBtn)
  addMenu:setPosition(0, 0)
  bg:addChild(addMenu)
  local inputBoxBg = img.createLogin9Sprite(img.login.input_border)
  local inputBox = CCEditBox:create(CCSize(90 * view.minScale, 35 * view.minScale), inputBoxBg)
  inputBox:setInputMode(kEditBoxInputModeNumeric)
  inputBox:setReturnType(kKeyboardReturnTypeDone)
  inputBox:setFont("", 14 * view.minScale)
  inputBox:setFontColor(ccc3(66, 36, 6))
  inputBox:setText(tostring(l_1_1.num))
  inputBox:setPosition(scalep(480, 285))
  inputBox.num = l_1_1.num
  layer:addChild(inputBox, 1)
  local coinBg = img.createUI9Sprite(img.ui.tips_sell_coin_bg)
  coinBg:setPreferredSize(CCSize(202, 33))
  coinBg:setPosition(TIPS_WIDTH / 2, TIPS_HEIGHT - 226)
  bg:addChild(coinBg)
  local coinIcon = img.createItemIcon2(ITEM_ID_COIN)
  coinIcon:setPosition(110, TIPS_HEIGHT - 226)
  bg:addChild(coinIcon)
  local coinLabel = lbl.createFont2(18, tostring(price * inputBox.num))
  coinLabel:setPosition(TIPS_WIDTH / 2, TIPS_HEIGHT - 226)
  bg:addChild(coinLabel)
  local sellBtn0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  sellBtn0:setPreferredSize(CCSize(138, 47))
  local sellBtn = SpineMenuItem:create(json.ui.button, sellBtn0)
  local sellBtnSize = sellBtn:getContentSize()
  sellBtn:setPosition(TIPS_WIDTH / 2, TIPS_HEIGHT - 289)
  local sellLabel = lbl.createFont1(22, i18n.global.tips_sell.string, ccc3(115, 59, 5))
  sellLabel:setPosition(sellBtnSize.width / 2, sellBtnSize.height / 2)
  sellBtn0:addChild(sellLabel)
  local sellMenu = CCMenu:createWithItem(sellBtn)
  sellMenu:setPosition(0, 0)
  bg:addChild(sellMenu)
  sellBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if handler then
      handler({id = thing.id, num = inputBox.num})
    end
   end)
  subBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if inputBox.num > 1 then
      inputBox.num = inputBox.num - 1
      inputBox:setText(tostring(inputBox.num))
      coinLabel:setString(tostring(price * inputBox.num))
    end
   end)
  addBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if inputBox.num < thing.num then
      inputBox.num = inputBox.num + 1
      inputBox:setText(tostring(inputBox.num))
      coinLabel:setString(tostring(price * inputBox.num))
    end
   end)
  inputBox:registerScriptEditBoxHandler(function(l_4_0)
    if l_4_0 == "ended" then
      local num = checkint(string.trim(inputBox:getText()))
      if num < 1 then
        num = 1
      else
        if thing.num < num then
          num = thing.num
        end
      end
      inputBox.num = num
      inputBox:setText(tostring(inputBox.num))
      coinLabel:setString(tostring(price * inputBox.num))
    elseif l_4_0 == "changed" then
       -- Warning: missing end command somewhere! Added here
    end
   end)
  local clickBlankHandler = nil
  layer.setClickBlankHandler = function(l_5_0)
    clickBlankHandler = l_5_0
   end
  local beginx, beginy = nil, nil
  local onTouch = function(l_6_0, l_6_1, l_6_2)
    if l_6_0 == "began" then
      beginx, upvalue_512 = l_6_1, l_6_2
      return true
    elseif l_6_0 == "moved" then
      return 
    else
      if not bg:boundingBox():containsPoint(ccp(l_6_1, l_6_2)) and not bg:boundingBox():containsPoint(ccp(beginx, beginy)) then
        layer.onAndroidBack()
      end
      return 
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

