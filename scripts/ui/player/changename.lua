-- Command line was: E:\github\dhgametool\scripts\ui\player\changename.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local net = require("net.netClient")
local player = require("data.player")
local databag = require("data.bag")
local audio = require("res.audio")
ui.create = function(l_1_0, l_1_1)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 210))
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(515, 343))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local btnCloseSp = img.createLoginSprite(img.login.button_close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSp)
  btnClose:setPosition(489, 317)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  if l_1_0 or tostring(player.uid) == tostring(player.name) then
    btnClose:setVisible(false)
  end
  local showTitle = lbl.createFont1(26, i18n.global.player_change_name_title.string, ccc3(230, 208, 174))
  showTitle:setPosition(board:getContentSize().width / 2, 314)
  board:addChild(showTitle, 1)
  local showTitleShade = lbl.createFont1(26, i18n.global.player_change_name_title.string, ccc3(89, 48, 27))
  showTitleShade:setPosition(board:getContentSize().width / 2, 312)
  board:addChild(showTitleShade)
  local showText = lbl.createMixFont1(18, i18n.global.player_change_name_info.string, ccc3(113, 63, 22))
  showText:setPosition(board:getContentSize().width / 2, 244)
  board:addChild(showText)
  local edit_normal = img.createLogin9Sprite(img.login.input_border)
  local edit_click = img.createLogin9Sprite(img.login.input_border)
  local edit = CCEditBox:create(CCSizeMake(390 * view.minScale, 40 * view.minScale), edit_normal, edit_click)
  edit:setInputFlag(kEditBoxInputFlagInitialCapsSentence)
  edit:setFontColor(ccc3(115, 59, 5))
  edit:setReturnType(kKeyboardReturnTypeDone)
  edit:setMaxLength(240)
  edit:setFont("", 16 * view.minScale)
  edit:setPlaceHolder(i18n.global.player_change_name_limit.string)
  edit:setPosition(view.midX, view.midY + 15)
  layer:addChild(edit, 10000)
  if l_1_0 or tostring(player.uid) == tostring(player.name) then
    btnClose:setVisible(false)
  end
  local btnConfirm = nil
  if not l_1_0 and tostring(player.uid) ~= tostring(player.name) then
    local btnConfirmSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    local labConfirm = lbl.createFont1(16, i18n.global.player_change_name_confirm.string, ccc3(113, 63, 22))
    labConfirm:setPosition(97, 59)
    btnConfirmSprite:addChild(labConfirm)
    local showDiamond = img.createItemIcon2(ITEM_ID_GEM)
    showDiamond:setScale(0.8)
    showDiamond:setPosition(64, 30)
    btnConfirmSprite:addChild(showDiamond)
    local showCost = lbl.createFont2(20, "200", ccc3(255, 246, 223))
    showCost:setAnchorPoint(ccp(0, 0.5))
    showCost:setPosition(showDiamond:boundingBox():getMaxX() + 5, showDiamond:getPositionY())
    btnConfirmSprite:addChild(showCost)
    if databag.gem() < 200 then
      showCost:setColor(ccc3(255, 44, 44))
    end
    btnConfirmSprite:setPreferredSize(CCSize(194, 80))
    btnConfirm = SpineMenuItem:create(json.ui.button, btnConfirmSprite)
    btnConfirm:setPosition(250, 86)
    local menuConfirm = CCMenu:create()
    menuConfirm:setPosition(0, 0)
    menuConfirm:addChild(btnConfirm)
    board:addChild(menuConfirm)
  else
    local btnConfirmSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnConfirmSprite:setPreferredSize(CCSize(194, 80))
    local labConfirm = lbl.createFont1(20, i18n.global.player_change_name_confirm.string, ccc3(113, 63, 22))
    labConfirm:setPosition(btnConfirmSprite:getContentSize().width / 2, btnConfirmSprite:getContentSize().height / 2)
    btnConfirmSprite:addChild(labConfirm)
    btnConfirm = SpineMenuItem:create(json.ui.button, btnConfirmSprite)
    btnConfirm:setPosition(250, 86)
    local menuConfirm = CCMenu:create()
    menuConfirm:setPosition(0, 0)
    menuConfirm:addChild(btnConfirm)
    board:addChild(menuConfirm)
  end
  btnConfirm:registerScriptTapHandler(function()
    audio.play(audio.button)
    local newName = edit:getText()
    newName = string.trim(newName)
    if isBanWord(newName) then
      showToast(i18n.global.input_invalid_char.string)
      return 
    end
    if string.len(newName) > 16 then
      showToast(i18n.global.player_change_name_long.string)
      return 
    else
      if string.len(newName) < 4 then
        showToast(i18n.global.player_change_name_short.string)
        return 
      else
        if newName == player.name then
          showToast(i18n.global.player_change_name_equal.string)
          return 
        else
          if containsInvalidChar(newName) then
            showToast(i18n.global.player_change_name_invalid.string)
            return 
          end
        end
      end
      if newName ~= "" and newName ~= "input:" then
        if databag.gem() < 200 and string.trim(player.name) ~= string.trim(player.uid) then
          showToast(i18n.global.player_change_name_gem.string)
          return 
        end
        local params = {sid = player.sid, name = newName}
        addWaitNet()
        net:change_name(params, function(l_1_0)
          delWaitNet()
          if l_1_0.status < 0 then
            if l_1_0.status == -1 then
              showToast(i18n.global.toast_name_used.string)
            elseif l_1_0.status <= -10 then
              showToast("\228\184\141\230\148\175\230\140\129\229\173\151\230\175\141\229\146\140\230\149\176\229\173\151")
            else
              showToast("status:" .. l_1_0.status)
              return 
            end
            if string.trim(player.name) ~= string.trim(player.uid) then
              databag.subGem(200)
            end
            player.name = newName
            if handle then
              handle()
            end
            if layer and not tolua.isnull(layer) then
              layer:removeFromParentAndCleanup(true)
            end
            require("data.tutorial").goNext("rename", 1, true)
             -- Warning: missing end command somewhere! Added here
          end
            end)
      end
       -- Warning: missing end command somewhere! Added here
    end
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_6_0)
    if l_6_0 == "enter" then
      onEnter()
    elseif l_6_0 == "exit" then
      onExit()
    end
   end)
  layer:registerScriptTouchHandler(function()
    return true
   end)
  layer:setTouchEnabled(true)
  return layer
end

return ui

