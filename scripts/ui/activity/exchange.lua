-- Command line was: E:\github\dhgametool\scripts\ui\activity\exchange.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.activity")
local cfgheromarket = require("config.heromarket")
local player = require("data.player")
local activityData = require("data.activity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local IDS = activityData.IDS
local ItemType = {Item = 1, Equip = 2}
ui.create = function()
  local layer = CCLayer:create()
  local HMIDS = {68, 69}
  local act = activityData.getStatusById(IDS.EXCHANGE.ID)
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(576, 436))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_exchange)
  local banner = (img.createUISprite(img.ui.activity_exchange_board))
  local bannerLabel = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    bannerLabel = img.createUISprite("activity_exchange_board_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      bannerLabel = img.createUISprite("activity_exchange_board_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        bannerLabel = img.createUISprite("activity_exchange_board_jp.png")
      else
        if i18n.getCurrentLanguage() == kLanguageRussian then
          bannerLabel = img.createUISprite("activity_exchange_board_ru.png")
        else
          if i18n.getCurrentLanguage() == kLanguageChinese then
            bannerLabel = img.createUISprite("activity_exchange_board_cn.png")
          else
            if i18n.getCurrentLanguage() == kLanguagePortuguese then
              bannerLabel = img.createUISprite("activity_exchange_board_pt.png")
            else
              bannerLabel = img.createUISprite("activity_exchange_board_us.png")
            end
          end
        end
      end
    end
  end
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2, board_h))
  board:addChild(banner)
  bannerLabel:setAnchorPoint(CCPoint(0.5, 1))
  bannerLabel:setPosition(CCPoint(board_w / 2 - 80, board_h - 12))
  board:addChild(bannerLabel)
  local lbl_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd:setPosition(CCPoint(106, 32))
  banner:addChild(lbl_cd)
  local lbl_cd_des = lbl.createFont2(14, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd_des:setPosition(CCPoint(182, 32))
  banner:addChild(lbl_cd_des)
  if i18n.getCurrentLanguage() == kLanguageRussian then
    lbl_cd_des:setPosition(CCPoint(66, 32))
    lbl_cd:setAnchorPoint(CCPoint(0, 0.5))
    lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMaxX() + 10, 32))
  end
  local cboard = img.createUI9Sprite(img.ui.bottom_border_2)
  cboard:setPreferredSize(CCSizeMake(576, 215))
  cboard:setAnchorPoint(CCPoint(0, 0))
  cboard:setPosition(CCPoint(0, 4))
  board:addChild(cboard)
  local cboard_w = cboard:getContentSize().width
  local cboard_h = cboard:getContentSize().height
  local txt_des = "CURRENT CONVERTIBLE HERO"
  local txt_go = i18n.global.pumpkin_btn_get.string
  if i18n.getCurrentLanguage() == kLanguageChinese or i18n.getCurrentLanguage() == kLanguageChineseTW then
    txt_des = "\233\153\144\230\151\182\229\133\145\230\141\162\232\139\177\233\155\132\230\151\160\230\179\149\229\136\183\230\150\176\233\135\141\231\189\174\232\180\173\228\185\176"
  end
  local lbl_des = lbl.createMixFont1(16, txt_des, ccc3(115, 59, 5))
  lbl_des:setPosition(CCPoint(cboard_w / 2, 182))
  cboard:addChild(lbl_des)
  lbl_des:setVisible(false)
  local count = #HMIDS
  local item_w = 78
  local item_h = 78
  local space_x = 10
  local container_w = (item_w + space_x) * count - space_x
  local start_x = 39
  local container = CCSprite:create()
  container:setContentSize(CCSizeMake(container_w, item_h))
  container:setPosition(CCPoint(cboard_w / 2, 122))
  cboard:addChild(container)
  for ii = 1, count do
    local cfgObj = cfgheromarket[HMIDS[ii]]
    do
      local _obj = {id = cfgObj.excelId, num = cfgObj.count, type = cfgObj.type}
      if _obj.type == ItemType.Equip then
        local _item0 = img.createEquip(_obj.id, _obj.num)
        local _item = CCMenuItemSprite:create(_item0, nil)
        _item:setScale(0.8)
        _item:setPosition(CCPoint(start_x + (ii - 1) * (item_w + space_x), item_h / 2 + 16))
        local _item_menu = CCMenu:createWithItem(_item)
        _item_menu:setPosition(CCPoint(0, 0))
        container:addChild(_item_menu)
        _item:registerScriptTapHandler(function()
          audio.play(audio.button)
          layer:getParent():getParent():getParent():addChild(tipsequip.createById(_obj.id), 1000)
            end)
      else
        if _obj.type == ItemType.Item then
          local _item0 = img.createItem(_obj.id, _obj.num)
          local _item = CCMenuItemSprite:create(_item0, nil)
          _item:setScale(0.8)
          _item:setPosition(CCPoint(start_x + (ii - 1) * (item_w + space_x), item_h / 2 + 16))
          local _item_menu = CCMenu:createWithItem(_item)
          _item_menu:setPosition(CCPoint(0, 0))
          container:addChild(_item_menu)
          _item:registerScriptTapHandler(function()
            audio.play(audio.button)
            layer:getParent():getParent():getParent():addChild(tipsitem.createForShow({id = _obj.id}), 1000)
               end)
        end
      end
    end
  end
  local btn_go0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_go0:setPreferredSize(CCSizeMake(152, 45))
  local lbl_go = lbl.createMixFont1(16, txt_go, ccc3(115, 59, 5))
  lbl_go:setPosition(CCPoint(btn_go0:getContentSize().width / 2, btn_go0:getContentSize().height / 2))
  btn_go0:addChild(lbl_go)
  local btn_go = SpineMenuItem:create(json.ui.button, btn_go0)
  btn_go:setPosition(CCPoint(cboard_w / 2, 60))
  local btn_go_menu = CCMenu:createWithItem(btn_go)
  btn_go_menu:setPosition(CCPoint(0, 0))
  cboard:addChild(btn_go_menu)
  btn_go:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:getParent():getParent():getParent():addChild(require("ui.heromarket.main").create(), 1000)
   end)
  local last_update = os.time() - 1
  local onUpdate = function(l_4_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    local remain_cd = act.cd - (os.time() - activityData.pull_time)
    if remain_cd >= 0 then
      local time_str = time2string(remain_cd)
      lbl_cd:setString(time_str)
    else
       -- Warning: missing end command somewhere! Added here
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  layer:registerScriptHandler(function(l_5_0)
    if l_5_0 == "enter" then
      do return end
    end
    if l_5_0 == "exit" then
      do return end
    end
    if l_5_0 == "cleanup" then
      img.unload(img.packedOthers.ui_activity_exchange)
    end
   end)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui

