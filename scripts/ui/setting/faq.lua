-- Command line was: E:\github\dhgametool\scripts\ui\setting\faq.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local cfghelp = require("config.help")
local player = require("data.player")
local userdata = require("data.userdata")
ui.create = function()
  local boardlayer = require("ui.setting.board")
  local layer = boardlayer.create(boardlayer.TAB.HELP)
  local board = layer.inner_board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  layer.setTitle(i18n.global.setting_title_help.string)
  local btn_help0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
  btn_help0:setPreferredSize(CCSizeMake(210, 42))
  local help_sel = img.createLogin9Sprite(img.login.button_9_small_gold)
  help_sel:setPreferredSize(CCSizeMake(210, 42))
  help_sel:setPosition(CCPoint(btn_help0:getContentSize().width / 2, btn_help0:getContentSize().height / 2))
  btn_help0:addChild(help_sel)
  help_sel:setVisible(false)
  local lbl_help = lbl.createFont1(18, i18n.global.setting_btn_help.string, ccc3(148, 98, 66))
  lbl_help:setPosition(CCPoint(btn_help0:getContentSize().width / 2, btn_help0:getContentSize().height / 2))
  btn_help0:addChild(lbl_help)
  local btn_help = SpineMenuItem:create(json.ui.button, btn_help0)
  btn_help:setPosition(CCPoint(155, 380))
  local btn_help_menu = CCMenu:createWithItem(btn_help)
  btn_help_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_help_menu)
  btn_help:registerScriptTapHandler(function()
    audio.play(audio.button)
    local parentObj = layer:getParent()
    layer:removeFromParentAndCleanup(true)
    parentObj:addChild(require("ui.setting.help").create(), 1000)
   end)
  local btn_faq0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
  btn_faq0:setPreferredSize(CCSizeMake(210, 42))
  local faq_sel = img.createLogin9Sprite(img.login.button_9_small_gold)
  faq_sel:setPreferredSize(CCSizeMake(210, 42))
  faq_sel:setPosition(CCPoint(btn_faq0:getContentSize().width / 2, btn_faq0:getContentSize().height / 2))
  btn_faq0:addChild(faq_sel)
  local faq_str = "FAQ"
  if i18n.getCurrentLanguage() == kLanguageTurkish then
    faq_str = "SSS"
  end
  local lbl_faq = lbl.createFont1(18, faq_str, ccc3(148, 98, 66))
  lbl_faq:setPosition(CCPoint(btn_faq0:getContentSize().width / 2, btn_faq0:getContentSize().height / 2))
  btn_faq0:addChild(lbl_faq)
  local btn_faq = SpineMenuItem:create(json.ui.button, btn_faq0)
  btn_faq:setPosition(CCPoint(370, 380))
  local btn_faq_menu = CCMenu:createWithItem(btn_faq)
  btn_faq_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_faq_menu)
  btn_faq:setEnabled(false)
  local btn_notice0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
  btn_notice0:setPreferredSize(CCSizeMake(210, 42))
  local notice_sel = img.createLogin9Sprite(img.login.button_9_small_gold)
  notice_sel:setPreferredSize(CCSizeMake(210, 42))
  notice_sel:setPosition(CCPoint(btn_notice0:getContentSize().width / 2, btn_notice0:getContentSize().height / 2 + 2))
  btn_notice0:addChild(notice_sel)
  notice_sel:setVisible(false)
  local lbl_notice = lbl.createFont1(18, i18n.global.setting_title_notice.string, ccc3(115, 59, 5))
  lbl_notice:setPosition(CCPoint(btn_notice0:getContentSize().width / 2, btn_notice0:getContentSize().height / 2))
  btn_notice0:addChild(lbl_notice)
  local btn_notice = SpineMenuItem:create(json.ui.button, btn_notice0)
  btn_notice:setPosition(CCPoint(585, 380))
  local btn_notice_menu = CCMenu:createWithItem(btn_notice)
  btn_notice_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_notice_menu)
  btn_notice:registerScriptTapHandler(function()
    audio.play(audio.button)
    local param = {sid = player.sid, language = i18n.getCurrentLanguage(), vsn = 0}
    local net = require("net.netClient")
    local pubs = require("data.pubs")
    addWaitNet()
    net:lpub(param, function(l_1_0)
      delWaitNet()
      if l_1_0.status < 0 then
        return 
      end
      if l_1_0.status ~= 1 then
        pubs.save(l_1_0.language, l_1_0.vsn, l_1_0.pub)
      end
      pubs.print()
      local parentObj = layer:getParent()
      layer:removeFromParentAndCleanup(true)
      parentObj:addChild(require("ui.setting.notice").create(), 1000)
      end)
   end)
  local scroll_bg = img.createUI9Sprite(img.ui.setting_dark_bg)
  scroll_bg:setPreferredSize(CCSizeMake(680, 330))
  scroll_bg:setAnchorPoint(CCPoint(0.5, 0))
  scroll_bg:setPosition(CCPoint(board_w / 2, 23))
  board:addChild(scroll_bg)
  local container = CCSprite:create()
  container:setContentSize(CCSizeMake(680, 330))
  container:setAnchorPoint(CCPoint(0, 0))
  container:setPosition(CCPoint(0, 0))
  scroll_bg:addChild(container)
  local createItem = function(l_3_0)
    local item = img.createUI9Sprite(img.ui.select_tab_btn_unselect)
    item:setPreferredSize(CCSizeMake(664, 50))
    local icon_arr = img.createUISprite(img.ui.setting_icon_arrow)
    icon_arr:setPosition(CCPoint(25, 25))
    item:addChild(icon_arr)
    local item_title = lbl.createMixFont1(18, l_3_0.title, ccc3(148, 98, 66))
    item_title:setPosition(CCPoint(332, 25))
    item:addChild(item_title)
    return item
   end
  local createScroll = function()
    local scroll_params = {width = 680, height = 319}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local list_items = {}
  local showList = function()
    container:removeAllChildrenWithCleanup(true)
    arrayclear(list_items)
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(0, 7))
    container:addChild(scroll)
    container.scroll = scroll
    for ii = 1, #i18n.faq do
      local tmp_item = createItem(i18n.faq[ii])
      tmp_item.ax = 0.5
      tmp_item.px = 340
      tmp_item.idx = ii
      tmp_item.obj = i18n.faq[ii]
      list_items[#list_items + 1] = tmp_item
      scroll.addItem(tmp_item)
      scroll.addSpace(1)
    end
    scroll.setOffsetBegin()
   end
  showList()
  local showContent = function(l_6_0)
    container.scroll = nil
    container:removeAllChildrenWithCleanup(true)
    arrayclear(list_items)
    local content = img.createUI9Sprite(img.ui.setting_help_content_bg)
    content:setPreferredSize(CCSizeMake(664, 319))
    content:setAnchorPoint(CCPoint(0.5, 0))
    content:setPosition(CCPoint(340, 7))
    container:addChild(content)
    local scroll = createScroll()
    scroll:setAnchorPoint(CCPoint(0, 0))
    scroll:setPosition(CCPoint(0, 0))
    content:addChild(scroll, 1)
    local bar0 = img.createUI9Sprite(img.ui.select_tab_btn_unselect)
    bar0:setPreferredSize(CCSizeMake(664, 50))
    local bar = HHMenuItem:createWithScale(bar0, 1)
    bar:setPosition(CCPoint(332, 294))
    local bar_menu = CCMenu:createWithItem(bar)
    bar_menu:setPosition(CCPoint(0, 0))
    content:addChild(bar_menu, 2)
    local icon_arr = img.createUISprite(img.ui.setting_icon_arrow)
    icon_arr:setRotation(90)
    icon_arr:setPosition(CCPoint(25, 25))
    bar:addChild(icon_arr)
    local item_title = lbl.createMixFont1(18, l_6_0.title, ccc3(148, 98, 66))
    item_title:setPosition(CCPoint(332, 25))
    bar:addChild(item_title)
    scroll.addSpace(55)
    if l_6_0.describe then
      local parts = string.split(l_6_0.describe, "|")
      for ii = 1, #parts do
        local item_title = lbl.createMix({font = 1, size = 18, text = string.trim(parts[ii]), color = ccc3(148, 98, 66), width = 644, align = kCCTextAlignmentLeft})
        item_title.height = item_title:getContentSize().height * item_title:getScaleY()
        item_title.ax = 0
        item_title.px = 10
        scroll.addItem(item_title)
        scroll.addSpace(15)
      end
    end
    scroll.setOffsetBegin()
    bar:registerScriptTapHandler(function()
      audio.play(audio.button)
      showList()
      end)
   end
  local onClickItem = function(l_7_0)
    showContent(l_7_0.obj)
   end
  local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
  local onTouchBegan = function(l_8_0, l_8_1)
    touchbeginx, upvalue_512 = l_8_0, l_8_1
    upvalue_1024 = true
    if not container.scroll or tolua.isnull(container.scroll) then
      upvalue_1024 = false
      return false
    end
    local p0 = scroll_bg:convertToNodeSpace(ccp(l_8_0, l_8_1))
    if not container:boundingBox():containsPoint(p0) then
      upvalue_1024 = false
      return false
    end
    local content_layer = container.scroll.content_layer
    local p1 = content_layer:convertToNodeSpace(ccp(l_8_0, l_8_1))
    for ii = 1, #list_items do
      if list_items[ii]:boundingBox():containsPoint(p1) then
        setShader(list_items[ii], SHADER_HIGHLIGHT, true)
        upvalue_3072 = list_items[ii]
    else
      end
    end
    return true
   end
  local onTouchMoved = function(l_9_0, l_9_1)
    if isclick and (math.abs(touchbeginx - l_9_0) > 10 or math.abs(touchbeginy - l_9_1) > 10) then
      isclick = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        clearShader(last_touch_sprite, true)
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_10_0, l_10_1)
    if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
      clearShader(last_touch_sprite, true)
      last_touch_sprite = nil
    end
    if not container.scroll or tolua.isnull(container.scroll) then
      return 
    end
    if isclick then
      local content_layer = container.scroll.content_layer
      local p0 = content_layer:convertToNodeSpace(ccp(l_10_0, l_10_1))
      for ii = 1, #list_items do
        if list_items[ii]:boundingBox():containsPoint(p0) then
          audio.play(audio.button)
          onClickItem(list_items[ii])
      else
        end
      end
    end
   end
  local onTouch = function(l_11_0, l_11_1, l_11_2)
    if l_11_0 == "began" then
      return onTouchBegan(l_11_1, l_11_2)
    elseif l_11_0 == "moved" then
      return onTouchMoved(l_11_1, l_11_2)
    else
      return onTouchEnded(l_11_1, l_11_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui

