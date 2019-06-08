-- Command line was: E:\github\dhgametool\scripts\ui\setting\option.lua 

local ui = {}
local cjson = json
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local player = require("data.player")
local userdata = require("data.userdata")
ui.create = function(l_1_0)
  local boardlayer = require("ui.setting.board")
  local layer = boardlayer.create(boardlayer.TAB.OPTION, l_1_0)
  local board = layer.inner_board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  layer.setTitle(i18n.global.setting_title_option.string)
  local lbl_email = nil
  if isOnestore() then
    lbl_email = lbl.createFont1(16, "Email: idle@withusgame.com", ccc3(86, 44, 25))
  else
    lbl_email = img.createUISprite(img.ui.setting_email_link)
  end
  lbl_email:setPosition(CCPoint(192, 37))
  board:addChild(lbl_email)
  local is6kw = not APP_CHANNEL or APP_CHANNEL == "6KW"
  local is6kwyyb = not APP_CHANNEL or APP_CHANNEL == "6KWYYB"
  if is6kw or is6kwyyb then
    lbl_email:setVisible(false)
  else
    lbl_email:setVisible(true)
  end
  local fb_link = img.createUISprite(img.ui.setting_btn_fb)
  local btn_fb_link = CCMenuItemSprite:create(fb_link, nil)
  btn_fb_link:setScale(0.8)
  btn_fb_link:setPosition(CCPoint(442, 39))
  local btn_fb_link_menu = CCMenu:createWithItem(btn_fb_link)
  btn_fb_link_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_fb_link_menu)
  btn_fb_link:registerScriptTapHandler(function()
    audio.play(audio.button)
    if i18n.getCurrentLanguage() == kLanguageJapanese then
      device.openURL("https://www.facebook.com/IdleHeroesJP")
    else
      if not HHUtils:isFacebookInstalled() then
        device.openURL(URL_FACEBOOK_WEB)
      else
        if CCApplication:sharedApplication():getTargetPlatform() == kTargetAndroid then
          device.openURL(URL_FACEBOOK_ANDROID)
        else
          device.openURL(URL_FACEBOOK_IOS)
        end
      end
    end
   end)
  local tt_link = img.createUISprite(img.ui.setting_btn_tt)
  local btn_tt_link = CCMenuItemSprite:create(tt_link, nil)
  btn_tt_link:setScale(0.8)
  btn_tt_link:setPosition(CCPoint(608, 39))
  local btn_tt_link_menu = CCMenu:createWithItem(btn_tt_link)
  btn_tt_link_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_tt_link_menu)
  btn_tt_link:registerScriptTapHandler(function()
    audio.play(audio.button)
    if isOnestore() then
      device.openURL("https://twitter.com/IdleheroesKr")
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        device.openURL(URL_TWITTER_WEB_JP)
      else
        if i18n.getCurrentLanguage() == kLanguageKorean then
          device.openURL("https://twitter.com/IdleheroesKr")
        else
          device.openURL(URL_TWITTER_WEB)
        end
      end
    end
   end)
  local wx_link = img.createUISprite(img.ui.setting_btn_wx)
  local btn_wx_link = CCMenuItemSprite:create(wx_link, nil)
  btn_wx_link:setPosition(CCPoint(429, 38))
  local btn_wx_link_menu = CCMenu:createWithItem(btn_wx_link)
  btn_wx_link_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_wx_link_menu)
  btn_wx_link:registerScriptTapHandler(function()
   end)
  local wb_link = img.createUISprite(img.ui.setting_btn_weibo)
  local btn_wb_link = CCMenuItemSprite:create(wb_link, nil)
  btn_wb_link:setScale(0.8)
  btn_wb_link:setPosition(CCPoint(608, 39))
  local btn_wb_link_menu = CCMenu:createWithItem(btn_wb_link)
  btn_wb_link_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_wb_link_menu)
  btn_wb_link:registerScriptTapHandler(function()
    audio.play(audio.button)
    device.openURL(URL_WEIBO_WEB)
   end)
  local sys_board = img.createUI9Sprite(img.ui.botton_fram_2)
  sys_board:setPreferredSize(CCSizeMake(680, 176))
  sys_board:setAnchorPoint(CCPoint(0.5, 0))
  sys_board:setPosition(CCPoint(board_w / 2, 222))
  board:addChild(sys_board)
  local sys_board_w = sys_board:getContentSize().width
  local sys_board_h = sys_board:getContentSize().height
  local lbl_sys_title = lbl.createFont1(18, i18n.global.setting_lbl_sys.string, ccc3(148, 98, 66))
  lbl_sys_title:setPosition(CCPoint(sys_board_w / 2, 152))
  sys_board:addChild(lbl_sys_title)
  local split_l1 = img.createUISprite(img.ui.hook_title_split)
  split_l1:setAnchorPoint(CCPoint(1, 0.5))
  split_l1:setPosition(CCPoint(sys_board_w / 2 - 62, 152))
  sys_board:addChild(split_l1)
  local split_r1 = img.createUISprite(img.ui.hook_title_split)
  split_r1:setFlipX(true)
  split_r1:setAnchorPoint(CCPoint(0, 0.5))
  split_r1:setPosition(CCPoint(sys_board_w / 2 + 62, 152))
  sys_board:addChild(split_r1)
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionHorizontal)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(17, 16)
  scroll:setViewSize(CCSize(645, 122))
  scroll:setContentSize(CCSize(662, 122))
  sys_board:addChild(scroll)
  local acc_board = img.createUI9Sprite(img.ui.botton_fram_2)
  acc_board:setPreferredSize(CCSizeMake(680, 150))
  acc_board:setAnchorPoint(CCPoint(0.5, 0))
  acc_board:setPosition(CCPoint(board_w / 2, 66))
  board:addChild(acc_board)
  local acc_board_w = acc_board:getContentSize().width
  local acc_board_h = acc_board:getContentSize().height
  local lbl_acc_title = lbl.createFont1(18, i18n.global.setting_lbl_account.string, ccc3(148, 98, 66))
  lbl_acc_title:setPosition(CCPoint(acc_board_w / 2, 128))
  acc_board:addChild(lbl_acc_title)
  local split_l1 = img.createUISprite(img.ui.hook_title_split)
  split_l1:setAnchorPoint(CCPoint(1, 0.5))
  split_l1:setPosition(CCPoint(acc_board_w / 2 - 62, 128))
  acc_board:addChild(split_l1)
  local split_r1 = img.createUISprite(img.ui.hook_title_split)
  split_r1:setFlipX(true)
  split_r1:setAnchorPoint(CCPoint(0, 0.5))
  split_r1:setPosition(CCPoint(acc_board_w / 2 + 62, 128))
  acc_board:addChild(split_r1)
  local mtx_msc_bg = img.createUI9Sprite(img.ui.select_hero_buff_bg)
  mtx_msc_bg:setPreferredSize(CCSizeMake(130, 114))
  local lbl_msc = lbl.createFont1(16, i18n.global.setting_lbl_music.string, ccc3(97, 52, 42))
  lbl_msc:setPosition(CCPoint(65, 94))
  mtx_msc_bg:addChild(lbl_msc)
  local btn_msc0 = img.createUISprite(img.ui.setting_msc_on)
  local btn_msc_off = img.createUISprite(img.ui.setting_msc_off)
  btn_msc_off:setPosition(CCPoint(btn_msc0:getContentSize().width / 2, btn_msc0:getContentSize().height / 2))
  btn_msc0:addChild(btn_msc_off)
  local btn_msc = SpineMenuItem:create(json.ui.button, btn_msc0)
  btn_msc:setPosition(CCPoint(65, 47))
  local btn_msc_menu = CCMenu:createWithItem(btn_msc)
  btn_msc_menu:setPosition(CCPoint(0, 0))
  mtx_msc_bg:addChild(btn_msc_menu)
  if audio.isBackgroundMusicEnabled() then
    btn_msc_off:setVisible(false)
  else
    btn_msc_off:setVisible(true)
  end
  btn_msc:registerScriptTapHandler(function()
    audio.play(audio.button)
    if audio.isBackgroundMusicEnabled() then
      audio.setBackgroundMusicEnabled(false)
      btn_msc_off:setVisible(true)
    else
      audio.setBackgroundMusicEnabled(true)
      btn_msc_off:setVisible(false)
    end
   end)
  local mtx_snd_bg = img.createUI9Sprite(img.ui.select_hero_buff_bg)
  mtx_snd_bg:setPreferredSize(CCSizeMake(130, 114))
  local lbl_snd = lbl.createFont1(16, i18n.global.setting_lbl_snd.string, ccc3(97, 52, 42))
  lbl_snd:setPosition(CCPoint(65, 94))
  mtx_snd_bg:addChild(lbl_snd)
  local btn_snd0 = img.createUISprite(img.ui.setting_aud_on)
  local btn_snd_off = img.createUISprite(img.ui.setting_aud_off)
  btn_snd_off:setPosition(CCPoint(btn_snd0:getContentSize().width / 2, btn_snd0:getContentSize().height / 2))
  btn_snd0:addChild(btn_snd_off)
  local btn_snd = SpineMenuItem:create(json.ui.button, btn_snd0)
  btn_snd:setPosition(CCPoint(65, 47))
  local btn_snd_menu = CCMenu:createWithItem(btn_snd)
  btn_snd_menu:setPosition(CCPoint(0, 0))
  mtx_snd_bg:addChild(btn_snd_menu)
  if audio.isEffectEnabled() then
    btn_snd_off:setVisible(false)
  else
    btn_snd_off:setVisible(true)
  end
  btn_snd:registerScriptTapHandler(function()
    audio.play(audio.button)
    if audio.isEffectEnabled() then
      audio.setEffectEnabled(false)
      btn_snd_off:setVisible(true)
    else
      audio.setEffectEnabled(true)
      btn_snd_off:setVisible(false)
    end
   end)
  local mtx_lgg_bg = img.createUI9Sprite(img.ui.select_hero_buff_bg)
  mtx_lgg_bg:setPreferredSize(CCSizeMake(130, 114))
  local lbl_lgg = lbl.createFont1(16, i18n.global.setting_lbl_lgg.string, ccc3(97, 52, 42))
  lbl_lgg:setPosition(CCPoint(65, 94))
  mtx_lgg_bg:addChild(lbl_lgg)
  local short_name = i18n.getLanguageShortName()
  if short_name == "us" then
    short_name = "en"
  elseif short_name == "tw" then
    short_name = "hk"
  end
  local btn_lgg0 = img.createUISprite(img.ui.setting_lgg_world)
  local btn_lgg = SpineMenuItem:create(json.ui.button, btn_lgg0)
  btn_lgg:setPosition(CCPoint(65, 47))
  local btn_lgg_menu = CCMenu:createWithItem(btn_lgg)
  btn_lgg_menu:setPosition(CCPoint(0, 0))
  mtx_lgg_bg:addChild(btn_lgg_menu)
  btn_lgg:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.setting.language").create(), 100)
   end)
  local mtx_fb_bg = img.createUI9Sprite(img.ui.select_hero_buff_bg)
  mtx_fb_bg:setPreferredSize(CCSizeMake(130, 114))
  local lbl_fb = lbl.createFont1(16, "Facebook", ccc3(97, 52, 42))
  lbl_fb:setPosition(CCPoint(65, 94))
  mtx_fb_bg:addChild(lbl_fb)
  local btn_fb0 = img.createUISprite(img.ui.setting_icon_fb)
  local btn_fb = SpineMenuItem:create(json.ui.button, btn_fb0)
  btn_fb:setPosition(CCPoint(65, 47))
  local btn_fb_menu = CCMenu:createWithItem(btn_fb)
  btn_fb_menu:setPosition(CCPoint(0, 0))
  mtx_fb_bg:addChild(btn_fb_menu)
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    mtx_fb_bg:setVisible(false)
  end
  btn_fb:registerScriptTapHandler(function()
    audio.play(audio.button)
    HHUtils:shareFacebook(i18n.global.facebook_share_name.string, i18n.global.facebook_share_caption.string, i18n.global.facebook_share_description.string, "http://linkfiles.droidhang.com/prompt/hh/ad_facebook.png", URL_GOOGLE_PLAY_WEB)
   end)
  local mtx_fix_bar_bg = img.createUI9Sprite(img.ui.select_hero_buff_bg)
  mtx_fix_bar_bg:setPreferredSize(CCSizeMake(130, 114))
  local lbl_fb = lbl.createFont1(16, i18n.global.setting_lbl_fix_bar.string, ccc3(97, 52, 42))
  lbl_fb:setPosition(CCPoint(65, 94))
  mtx_fix_bar_bg:addChild(lbl_fb)
  local btn_fix_bar0 = img.createUISprite(img.ui.setting_icon_fix_bar)
  local btn_fix_bar = SpineMenuItem:create(json.ui.button, btn_fix_bar0)
  btn_fix_bar:setPosition(CCPoint(65, 47))
  local btn_fix_bar_menu = CCMenu:createWithItem(btn_fix_bar)
  btn_fix_bar_menu:setPosition(CCPoint(0, 0))
  mtx_fix_bar_bg:addChild(btn_fix_bar_menu)
  btn_fix_bar:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:getParent():addChild(require("ui.setting.fix").create(), 1000)
    layer:removeFromParentAndCleanup(true)
   end)
  local head = img.createPlayerHead(player.logo, player.lv())
  head:setScale(0.8)
  head:setPosition(CCPoint(67, 65))
  acc_board:addChild(head)
  local acct = userdata.getString(userdata.keys.account)
  local nick = player.name
  local isFormal = userdata.getBool(userdata.keys.accountFormal)
  if not isFormal and not isChannel() then
    acct = ""
    nick = i18n.global.visitor_account_name.string
  end
  local lbl_nick = lbl.createFontTTF(18, nick, ccc3(148, 98, 66))
  lbl_nick:setAnchorPoint(CCPoint(0, 0))
  lbl_nick:setPosition(CCPoint(115, 68))
  acc_board:addChild(lbl_nick)
  local lbl_mail = lbl.createFontTTF(18, acct or "", ccc3(148, 98, 66))
  lbl_mail:setAnchorPoint(CCPoint(0, 0))
  lbl_mail:setPosition(CCPoint(115, 35))
  acc_board:addChild(lbl_mail)
  local btn_reg0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_reg0:setPreferredSize(CCSizeMake(160, 52))
  local lbl_reg = lbl.createFont1(16, i18n.global.setting_btn_reg.string, ccc3(115, 59, 5))
  lbl_reg:setPosition(CCPoint(btn_reg0:getContentSize().width / 2, btn_reg0:getContentSize().height / 2))
  btn_reg0:addChild(lbl_reg)
  local btn_reg = SpineMenuItem:create(json.ui.button, btn_reg0)
  btn_reg:setPosition(CCPoint(404, 64))
  local btn_reg_menu = CCMenu:createWithItem(btn_reg)
  btn_reg_menu:setPosition(CCPoint(0, 0))
  acc_board:addChild(btn_reg_menu)
  local btn_change0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_change0:setPreferredSize(CCSizeMake(160, 52))
  local lbl_change = lbl.createFont1(16, i18n.global.setting_btn_change.string, ccc3(115, 59, 5))
  lbl_change:setPosition(CCPoint(btn_change0:getContentSize().width / 2, btn_change0:getContentSize().height / 2))
  btn_change0:addChild(lbl_change)
  local btn_change = SpineMenuItem:create(json.ui.button, btn_change0)
  btn_change:setPosition(CCPoint(404, 64))
  local btn_change_menu = CCMenu:createWithItem(btn_change)
  btn_change_menu:setPosition(CCPoint(0, 0))
  acc_board:addChild(btn_change_menu)
  if isFormal then
    btn_change:setVisible(true)
    btn_reg:setVisible(false)
  else
    btn_change:setVisible(false)
    btn_reg:setVisible(true)
  end
  local btn_switch0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_switch0:setPreferredSize(CCSizeMake(160, 52))
  local lbl_switch = lbl.createFont1(16, i18n.global.setting_btn_switch.string, ccc3(115, 59, 5))
  lbl_switch:setPosition(CCPoint(btn_switch0:getContentSize().width / 2, btn_switch0:getContentSize().height / 2))
  btn_switch0:addChild(lbl_switch)
  local btn_switch = SpineMenuItem:create(json.ui.button, btn_switch0)
  btn_switch:setPosition(CCPoint(580, 64))
  local btn_switch_menu = CCMenu:createWithItem(btn_switch)
  btn_switch_menu:setPosition(CCPoint(0, 0))
  acc_board:addChild(btn_switch_menu)
  btn_reg:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.setting.register").create(), 1000)
   end)
  btn_change:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.setting.change").create(), 1000)
   end)
  btn_switch:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.setting.switch").create(), 1000)
   end)
  local btn_logout0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_logout0:setPreferredSize(CCSizeMake(80, 48))
  local lbl_logout = lbl.createMixFont1(18, "\230\179\168\233\148\128", ccc3(131, 65, 29))
  lbl_logout:setPosition(CCPoint(40, 24))
  btn_logout0:addChild(lbl_logout)
  local btn_logout = SpineMenuItem:create(json.ui.button, btn_logout0)
  btn_logout:setPosition(CCPoint(580, 64))
  local btn_logout_menu = CCMenu:createWithItem(btn_logout)
  btn_logout_menu:setPosition(CCPoint(0, 0))
  acc_board:addChild(btn_logout_menu)
  btn_logout:setVisible(false)
  btn_logout:registerScriptTapHandler(function()
    audio.play(audio.button)
    player.uid = nil
    player.sid = nil
    local lparams = {which = "logout"}
    local lparamStr = cjson.encode(lparams)
    SDKHelper:getInstance():login(lparamStr, function(l_1_0)
      print("msdk option logout data:", l_1_0)
      local director = CCDirector:sharedDirector()
      schedule(director:getRunningScene(), function()
        replaceScene(require("ui.login.home").create())
         end)
      end)
   end)
  local btn_6kw_logout0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_6kw_logout0:setPreferredSize(CCSizeMake(80, 48))
  local lbl_logout = lbl.createMixFont1(18, "\230\179\168\233\148\128", ccc3(131, 65, 29))
  lbl_logout:setPosition(CCPoint(40, 24))
  btn_6kw_logout0:addChild(lbl_logout)
  local btn_6kw_logout = SpineMenuItem:create(json.ui.button, btn_6kw_logout0)
  btn_6kw_logout:setPosition(CCPoint(580, 64))
  local btn_6kw_logout_menu = CCMenu:createWithItem(btn_6kw_logout)
  btn_6kw_logout_menu:setPosition(CCPoint(0, 0))
  acc_board:addChild(btn_6kw_logout_menu)
  btn_6kw_logout:setVisible(false)
  btn_6kw_logout:registerScriptTapHandler(function()
    audio.play(audio.button)
    player.uid = nil
    player.sid = nil
    SDKHelper:getInstance():logout("1", function(l_1_0)
      print("6kwsdk option logout data:", l_1_0)
      local director = CCDirector:sharedDirector()
      schedule(director:getRunningScene(), function()
        replaceScene(require("ui.login.home").create())
         end)
      end)
   end)
  local btn_realname0 = img.createUISprite(img.ui.icon_realname)
  local btn_realname = SpineMenuItem:create(json.ui.button, btn_realname0)
  btn_realname:setPosition(CCPoint(640, 114))
  local btn_realname_menu = CCMenu:createWithItem(btn_realname)
  btn_realname_menu:setPosition(CCPoint(0, 0))
  acc_board:addChild(btn_realname_menu)
  btn_realname:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.town.PreventAddictionDialog").create(layer), 1000)
   end)
  local prevent_addiction = require("data.preventaddiction")
  if isChannel() then
    btn_realname:setVisible(false)
  else
    if not prevent_addiction.isChinese() and i18n.getLanguageShortName() ~= "cn" then
      btn_realname:setVisible(false)
    else
      btn_realname:setVisible(true)
    end
  end
  if APP_CHANNEL and APP_CHANNEL == "MSDK" then
    btn_logout:setVisible(true)
  elseif APP_CHANNEL and APP_CHANNEL == "6KW" then
    btn_6kw_logout:setVisible(true)
  elseif APP_CHANNEL and APP_CHANNEL == "6KWYYB" then
    btn_6kw_logout:setVisible(true)
  else
    btn_logout:setVisible(false)
  end
  if isAmazon() then
    btn_fb_link:setVisible(true)
    btn_tt_link:setVisible(true)
    btn_wx_link:setVisible(false)
    btn_wb_link:setVisible(false)
    btn_reg:setVisible(false)
    btn_change:setVisible(false)
    btn_switch:setVisible(false)
  else
    if isOnestore() then
      btn_fb_link:setVisible(true)
      btn_tt_link:setVisible(true)
      btn_wx_link:setVisible(false)
      btn_wb_link:setVisible(false)
      btn_switch:setVisible(true)
    else
      if isChannel() then
        btn_reg:setVisible(false)
        btn_change:setVisible(false)
        btn_switch:setVisible(false)
        btn_fb_link:setVisible(false)
        btn_tt_link:setVisible(false)
        btn_wx_link:setVisible(false)
        btn_wb_link:setVisible(false)
        mtx_lgg_bg:setVisible(false)
        mtx_fb_bg:setVisible(false)
      elseif APP_CHANNEL and APP_CHANNEL ~= "" then
        btn_fb_link:setVisible(false)
        btn_tt_link:setVisible(false)
        btn_wx_link:setVisible(true)
        btn_wb_link:setVisible(true)
      else
        btn_fb_link:setVisible(true)
        btn_tt_link:setVisible(true)
        btn_wx_link:setVisible(false)
        btn_wb_link:setVisible(false)
      end
    end
  end
  local scrollCount = 0
  local addToScrollView = function(l_16_0)
    if not l_16_0 or not l_16_0:isVisible() then
      return 
    end
    scrollCount = scrollCount + 1
    l_16_0:setPosition(CCPoint(73 + (scrollCount - 1) * 142, 60))
    scroll:getContainer():addChild(l_16_0)
   end
  addToScrollView(mtx_msc_bg)
  addToScrollView(mtx_snd_bg)
  addToScrollView(mtx_lgg_bg)
  addToScrollView(mtx_fb_bg)
  addToScrollView(mtx_fix_bar_bg)
  scroll:setContentSize(CCSize(73 + (scrollCount - 1) * 142 + 73, 122))
  return layer
end

return ui

