-- Command line was: E:\github\dhgametool\scripts\ui\setting\language.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local player = require("data.player")
local userdata = require("data.userdata")
local lggs = {1 = {name = "English", icon = img.ui.setting_lgg_en, lbl_method = lbl.createOptionEnglish, language = kLanguageEnglish}, 2 = {name = "\208\160\209\131\209\129\209\129\208\186\208\184\208\185", icon = img.ui.setting_lgg_ru, lbl_method = lbl.createOptionRussian, language = kLanguageRussian}, 3 = {name = "\231\174\128\228\189\147\228\184\173\230\150\135", icon = img.ui.setting_lgg_cn, lbl_method = lbl.createOptionChineseSimplified, language = kLanguageChinese}, 4 = {name = "\231\185\129\233\171\148\228\184\173\230\150\135", icon = img.ui.setting_lgg_hk, lbl_method = lbl.createOptionChineseTraditional, language = kLanguageChineseTW}, 5 = {name = "Fran\195\167ais", icon = img.ui.setting_lgg_fr, lbl_method = lbl.createOptionFrench, language = kLanguageFrench}, 6 = {name = "Portugu\195\170s(BR)", icon = img.ui.setting_lgg_pt, lbl_method = lbl.createOptionPortuguese, language = kLanguagePortuguese}, 7 = {name = "Espa\195\177ol", icon = img.ui.setting_lgg_es, lbl_method = lbl.createOptionSpanish, language = kLanguageSpanish}, 8 = {name = "T\195\188rk\195\167e", icon = img.ui.setting_lgg_tr, lbl_method = lbl.createOptionTur, language = kLanguageTurkish}, 9 = {name = "\230\151\165\230\156\172\232\170\158", icon = img.ui.setting_lgg_jp, lbl_method = lbl.createOptionJapanese, language = kLanguageJapanese}, 10 = {name = "\237\149\156\234\181\173\236\150\180", icon = img.ui.setting_lgg_kr, lbl_method = lbl.createOptionKorean, language = kLanguageKorean}, 11 = {name = "Deutsch", icon = img.ui.setting_lgg_de, lbl_method = lbl.createOptionGerman, language = kLanguageGerman}, 12 = {name = "Italiano", icon = img.ui.setting_lgg_it, lbl_method = lbl.createOptionItalian, language = kLanguageItalian}, 13 = {name = "\224\184\160\224\184\178\224\184\169\224\184\178\224\185\132\224\184\151\224\184\162", icon = img.ui.setting_lgg_th, lbl_method = lbl.createOptionThai, language = kLanguageThai}, 14 = {name = "Ti\225\186\191ng Vi\225\187\135t", icon = img.ui.setting_lgg_vi, lbl_method = lbl.createOptionVi, language = kLanguageVietnamese}, 15 = {name = "Melayu", icon = img.ui.setting_lgg_ms, lbl_method = lbl.createOptionMs, language = kLanguageMalay}}
local createItem2 = function(l_1_0)
  local item = img.createUISprite(l_1_0.icon)
  local lbl_lgg = lbl.createFontTTF(16, l_1_0.name, ccc3(255, 255, 255))
  lbl_lgg:setPosition(CCPoint(item:getContentSize().width / 2, -20))
  item:addChild(lbl_lgg)
  item.lbl_lgg = lbl_lgg
  local item_mask = img.createUISprite(img.ui.setting_lgg_mask)
  item_mask:setPosition(CCPoint(item:getContentSize().width / 2, item:getContentSize().height / 2))
  item_mask:setVisible(false)
  item:addChild(item_mask)
  item.item_mask = item_mask
  local item_sel = img.createUISprite(img.ui.hook_btn_sel)
  item_sel:setScale(0.6)
  item_sel:setPosition(CCPoint(item_mask:getContentSize().width / 2, item_mask:getContentSize().height / 2))
  item_mask:addChild(item_sel)
  return item
end

local createItem = function(l_2_0)
  local item = img.createUI9Sprite(img.ui.botton_fram_2)
  item:setPreferredSize(CCSizeMake(246, 70))
  local item_w = item:getContentSize().width
  local item_h = item:getContentSize().height
  local item_sel = img.createUI9Sprite(img.ui.setting_server_sel)
  item_sel:setPreferredSize(CCSizeMake(246, 70))
  item_sel:setPosition(CCPoint(item_w / 2, item_h / 2))
  item_sel:setVisible(false)
  item:addChild(item_sel)
  item.item_sel = item_sel
  local lbl_lgg = lbl.createFontTTF(16, l_2_0.name, ccc3(81, 39, 18))
  lbl_lgg:setPosition(CCPoint(item_w / 2, item_h / 2))
  item:addChild(lbl_lgg)
  item.lbl_lgg = lbl_lgg
  return item
end

ui.create = function()
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board = img.createUI9Sprite(img.ui.tips_bg)
  board:setPreferredSize(CCSizeMake(618, 450))
  board:setScale(view.minScale)
  board:setPosition(view.midX - 5 * view.minScale, view.midY)
  layer:addChild(board)
  layer.board = board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  board:setScale(0.5 * view.minScale)
  board:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  local lbl_title = lbl.createFont1(24, i18n.global.setting_chose_lgg.string, ccc3(255, 234, 136))
  lbl_title:setPosition(CCPoint(board_w / 2, board_h - 36))
  board:addChild(lbl_title)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(board_w - 28, board_h - 28))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_close_menu, 100)
  layer.btn_close = btn_close
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local line = img.createUISprite(img.ui.help_line)
  line:setScaleX(520 / line:getContentSize().width)
  line:setPosition(board_w / 2, board_h - 64)
  board:addChild(line)
  local current_language = (i18n.getCurrentLanguage())
  local last_sel_item = nil
  local lineScroll = require("ui.lineScroll")
  local params = {width = 524, height = 364}
  local scroll = lineScroll.create(params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(47, 12))
  board:addChild(scroll)
  local lgg_items = {}
  local obj_count = #lggs
  local offset_x = 5
  local offset_y = 15
  local item_width = 270
  local item_height = 80
  local ITEM_PER_ROW = 2
  local rows = math.floor((obj_count + ITEM_PER_ROW - 1) / ITEM_PER_ROW)
  if scroll.height < offset_y + item_height * rows then
    scroll:setContentSize(CCSizeMake(scroll.width, offset_y + item_height * rows))
    scroll:setContentOffset(CCPoint(0, scroll.height - (offset_y + item_height * rows)))
  end
  scroll.content_layer:setPosition(CCPoint(0, scroll:getContentSize().height))
  for ii = 1, #lggs do
    local item = createItem(lggs[ii])
    if current_language == lggs[ii].language then
      item.item_sel:setVisible(true)
      last_sel_item = item
    end
    item.obj = lggs[ii]
    lgg_items[#lgg_items + 1] = item
    item:setAnchorPoint(CCPoint(0, 1))
    local cur_column = (ii - 1) % ITEM_PER_ROW
    local cur_row = math.floor((ii + ITEM_PER_ROW - 1) / ITEM_PER_ROW) - 1
    item:setPosition(CCPoint(offset_x + cur_column * item_width, 0 - offset_y - cur_row * item_height))
    scroll.content_layer:addChild(item)
  end
  local switchLanguage = function(l_3_0)
    local sel_language = l_3_0
    local old_language = i18n.getCurrentLanguage()
    if sel_language == old_language then
      return 
    end
    i18n.switchLanguage(sel_language)
    local townlayer = require("ui.town.main")
    replaceScene(townlayer.create({from_layer = "language"}))
   end
  local onOptionSel = function(l_4_0)
    for ii = 1, #lgg_items do
      if ii == l_4_0 then
        lgg_items[ii].item_sel:setVisible(true)
        upvalue_512 = lgg_items[ii]
      else
        lgg_items[ii].item_sel:setVisible(false)
      end
    end
    upvalue_1024 = lgg_items[l_4_0].obj.language
   end
  local touchbeginx, touchbeginy, isclick = nil, nil, nil
  local onTouchBegan = function(l_5_0, l_5_1)
    touchbeginx, upvalue_512 = l_5_0, l_5_1
    upvalue_1024 = true
    return true
   end
  local onTouchMoved = function(l_6_0, l_6_1)
    if isclick and (math.abs(touchbeginx - l_6_0) > 10 or math.abs(touchbeginy - l_6_1) > 10) then
      isclick = false
    end
   end
  local onTouchEnded = function(l_7_0, l_7_1)
    local p0 = board:convertToNodeSpace(ccp(l_7_0, l_7_1))
    if isclick and scroll:boundingBox():containsPoint(p0) then
      local p1 = scroll.content_layer:convertToNodeSpace(ccp(l_7_0, l_7_1))
      for ii = 1, #lgg_items do
        if lgg_items[ii]:boundingBox():containsPoint(p1) then
          if last_sel_item and last_sel_item == lgg_items[ii] then
            return 
          end
          audio.play(audio.button)
          onOptionSel(ii)
          switchLanguage(current_language)
        end
      end
    end
   end
  local onTouch = function(l_8_0, l_8_1, l_8_2)
    if l_8_0 == "began" then
      return onTouchBegan(l_8_1, l_8_2)
    elseif l_8_0 == "moved" then
      return onTouchMoved(l_8_1, l_8_2)
    else
      return onTouchEnded(l_8_1, l_8_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    backEvent()
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_12_0)
    if l_12_0 == "enter" then
      onEnter()
    elseif l_12_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui

