-- Command line was: E:\github\dhgametool\scripts\ui\activity\follow.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.activity")
local player = require("data.player")
local activityData = require("data.activity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local IDS = activityData.IDS
local act_ids = {IDS.FOLLOW.ID}
ui.create = function()
  local layer = CCLayer:create()
  local acts = {}
  for _,v in ipairs(act_ids) do
    local tmp_status = activityData.getStatusById(v)
    acts[ acts + 1] = tmp_status
  end
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(570, 438))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(352, 57))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local link_url = nil
  local btnFlag = false
  local bannerLabel = nil
  img.load(img.packedOthers.ui_activity_follow)
  if i18n.getCurrentLanguage() == kLanguageChinese then
    link_url = "http://weibo.com/idleheroes"
    bannerLabel = img.createUISprite("activity_follow_des_cn.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      link_url = "https://www.facebook.com/Idleheroes"
      bannerLabel = img.createUISprite("activity_follow_des_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        link_url = "https://www.facebook.com/Idleheroes"
        bannerLabel = img.createUISprite("activity_follow_des_jp.png")
      else
        if i18n.getCurrentLanguage() == kLanguageKorean then
          link_url = "https://www.facebook.com/Idleheroes"
          bannerLabel = img.createUISprite("activity_follow_des_kr.png")
        else
          if i18n.getCurrentLanguage() == kLanguagePortuguese then
            link_url = "https://www.facebook.com/Idleheroes"
            bannerLabel = img.createUISprite("activity_follow_des_pt.png")
          else
            if i18n.getCurrentLanguage() == kLanguageRussian then
              link_url = "https://www.facebook.com/Idleheroes"
              bannerLabel = img.createUISprite("activity_follow_des_ru.png")
            else
              link_url = "https://www.facebook.com/Idleheroes"
              bannerLabel = img.createUISprite("activity_follow_des.png")
            end
          end
        end
      end
    end
  end
  local banner = img.createUISprite(img.ui.activity_follow)
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2, board_h - 8))
  board:addChild(banner)
  bannerLabel:setAnchorPoint(CCPoint(0.5, 1))
  bannerLabel:setPosition(CCPoint(board_w / 2 + 96, board_h - 30))
  board:addChild(bannerLabel)
  if APP_CHANNEL == "IAS" or isChannel() or i18n.getCurrentLanguage() == kLanguageChinese then
    local wb_link = img.createUISprite(img.ui.setting_btn_weibo)
    local btn_wb_link = SpineMenuItem:create(json.ui.button, wb_link)
    btn_wb_link:setPosition(CCPoint(324, 60))
    local btn_wb_link_menu = CCMenu:createWithItem(btn_wb_link)
    btn_wb_link_menu:setPosition(CCPoint(0, 0))
    board:addChild(btn_wb_link_menu)
    btn_wb_link:registerScriptTapHandler(function()
      audio.play(audio.button)
      device.openURL(link_url)
      end)
    bannerLabel:setPosition(CCPoint(board_w / 2 + 96, board_h - 55))
  else
    local spriteFollow = img.createUISprite(img.ui.setting_btn_fb)
    local btnFollow = SpineMenuItem:create(json.ui.button, spriteFollow)
    btnFollow:setPosition(CCPoint(430, 105))
    local menu = CCMenu:createWithItem(btnFollow)
    menu:setPosition(0, 0)
    banner:addChild(menu)
    btnFollow:registerScriptTapHandler(function()
      audio.play(audio.button)
      device.openURL(link_url)
      end)
    local tt_link = img.createUISprite(img.ui.setting_btn_tt)
    local btn_tt_link = SpineMenuItem:create(json.ui.button, tt_link)
    btn_tt_link:setPosition(CCPoint(430, 45))
    local btn_tt_link_menu = CCMenu:createWithItem(btn_tt_link)
    btn_tt_link_menu:setPosition(CCPoint(0, 0))
    banner:addChild(btn_tt_link_menu)
    btn_tt_link:registerScriptTapHandler(function()
      audio.play(audio.button)
      device.openURL(URL_TWITTER_WEB)
      end)
    local fbNum = img.createUISprite("activity_follow_fbnum.png")
    fbNum:setPosition(CCPoint(430, 162))
    banner:addChild(fbNum)
  end
  return layer
end

return ui

